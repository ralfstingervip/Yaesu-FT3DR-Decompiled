r"""Lane M15 -- SUB window residue re-proof and ledger, on a private copy of K7_SUB_FINAL3.  Read-only on the DB.

    python ida/run_job.py --script ida\jobs\m15_residue.py --db M15_SUB_RESIDUE --copy-from ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64

Exports (ida\out\sub-residue-final\raw\):
  codeheads.tsv   every code head in every segment: ea, size, canon feature flags, mnemonic, disasm
  dataitems.tsv   every data item head in the window FFED0000-FFF50000: ea, size, kind
  runs-heads.tsv  every DB head inside each residue run plus the head before and the head at the run end
  xrefs.tsv       every IDA xref (code or data) into any residue byte, with source
  operands.tsv    every o_imm / o_displ(op.value) / o_mem / o_near / o_far operand of every code head whose value
                  falls inside a residue byte (whole DB)
  switches.tsv    every code head carrying IDA switch info, with every case target
  indirect.tsv    every jsr/jmp/bsr.l/bra.l Rn head with the 8 preceding heads
  ctrl.tsv        every mvtc/mvfc head (INTB/EXTB/PC)
  funcs.tsv       function owning each residue run start
  status.txt      log / traceback
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-residue-final\raw")
STATUS = os.path.join(OUT, "status.txt")
MASKS = os.path.join(ROOT, r"ida\out\sub-final3\raw")
WLO, WHI = 0xFFED0000, 0xFFF50000
CF_STOP, CF_CALL, CF_JUMP = 0x1, 0x2, 0x8000


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def mask(n):
    return open(os.path.join(MASKS, "mask_final3_after_%s.bin" % n), "rb").read()


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_nalt, ida_xref, idautils, idc, ida_segment, ida_lines
    ida_auto.auto_wait()
    HW, A = mask("headline_w2"), mask("allwf")
    res = set(WLO + i for i in range(len(A)) if A[i] and not HW[i])
    runs = []
    for x in sorted(res):
        if runs and runs[-1][1] == x:
            runs[-1][1] = x + 1
        else:
            runs.append([x, x + 1])
    log("residue bytes %d runs %d" % (len(res), len(runs)))

    def dis(ea):
        t = idc.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or ""
        return t.replace("\t", " ")

    def hexb(ea, n):
        return (ida_bytes.get_bytes(ea, n) or b"").hex()

    # ---- whole-DB code heads, plus window data items
    ch = open(os.path.join(OUT, "codeheads.tsv"), "w", encoding="utf-8", newline="\n")
    ch.write("ea\tsize\tfeature\tmnem\tbytes\tdisasm\n")
    di = open(os.path.join(OUT, "dataitems.tsv"), "w", encoding="utf-8", newline="\n")
    di.write("ea\tsize\tkind\tname\n")
    opf = open(os.path.join(OUT, "operands.tsv"), "w", encoding="utf-8", newline="\n")
    opf.write("site\topn\toptype\tvalue\trun_start\tdisasm\n")
    ind = open(os.path.join(OUT, "indirect.tsv"), "w", encoding="utf-8", newline="\n")
    ind.write("site\tbytes\tdisasm\tprev8\n")
    ctl = open(os.path.join(OUT, "ctrl.tsv"), "w", encoding="utf-8", newline="\n")
    ctl.write("site\tbytes\tdisasm\n")
    sw = open(os.path.join(OUT, "switches.tsv"), "w", encoding="utf-8", newline="\n")
    sw.write("site\tncases\ttargets_in_residue\tall_targets\n")
    runstart = {}
    for s, e in runs:
        for x in range(s, e):
            runstart[x] = s
    nch = 0; nsw = 0
    for si in range(ida_segment.get_segm_qty()):
        seg = ida_segment.getnseg(si)
        ea = seg.start_ea
        while ea < seg.end_ea:
            fl = ida_bytes.get_flags(ea)
            sz = max(ida_bytes.get_item_size(ea), 1)
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
                feat = insn.get_canon_feature() if ln > 0 else 0
                mn = insn.get_canon_mnem() if ln > 0 else "?"
                d = dis(ea)
                ch.write("%08X\t%d\t%X\t%s\t%s\t%s\n" % (ea, sz, feat, mn, hexb(ea, sz), d))
                nch += 1
                if ln > 0:
                    for k, op in enumerate(insn.ops):
                        if op.type == 0:
                            break
                        vals = []
                        if op.type == ida_ua.o_imm:
                            vals.append(op.value & 0xFFFFFFFF)
                        elif op.type == ida_ua.o_displ:
                            vals.append(op.value & 0xFFFFFFFF); vals.append(op.addr & 0xFFFFFFFF)
                        elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                            vals.append(op.addr & 0xFFFFFFFF)
                        for v in vals:
                            if v in runstart:
                                opf.write("%08X\t%d\t%d\t%08X\t%08X\t%s\n" % (ea, k, op.type, v, runstart[v], d))
                    low = d.lower()
                    if mn in ("jsr", "jmp") or low.startswith(("bsr.l", "bra.l")):
                        prev = []; p = ea
                        for _ in range(8):
                            p = idc.prev_head(p, seg.start_ea)
                            if p == idc.BADADDR or not ida_bytes.is_code(ida_bytes.get_flags(p)):
                                break
                            prev.append("%08X %s" % (p, dis(p)))
                        ind.write("%08X\t%s\t%s\t%s\n" % (ea, hexb(ea, sz), d, " <- ".join(prev)))
                    if mn in ("mvtc", "mvfc") or low.startswith(("mvtc", "mvfc")):
                        ctl.write("%08X\t%s\t%s\n" % (ea, hexb(ea, sz), d))
                    si_ = ida_nalt.get_switch_info(ea)
                    if si_ is not None:
                        nsw += 1
                        res_ = ida_xref.calc_switch_cases(ea, si_)
                        tg = []
                        if res_ is not None:
                            tg = [t for t in res_.targets]
                        hit = [t for t in tg if t in runstart]
                        sw.write("%08X\t%d\t%s\t%s\n" % (ea, len(tg), ",".join("%08X" % t for t in hit),
                                                         ",".join("%08X" % t for t in sorted(set(tg)))))
            elif ida_bytes.is_data(fl) and ea + sz > WLO and ea < WHI:
                if ida_bytes.is_strlit(fl): k = "strlit"
                elif ida_bytes.is_struct(fl): k = "struct"
                elif ida_bytes.is_align(fl): k = "align"
                elif ida_bytes.is_off0(fl): k = "offset"
                elif ida_bytes.is_dword(fl): k = "dword"
                elif ida_bytes.is_word(fl): k = "word"
                elif ida_bytes.is_byte(fl): k = "byte"
                elif ida_bytes.is_double(fl): k = "double"
                elif ida_bytes.is_float(fl): k = "float"
                elif ida_bytes.is_qword(fl): k = "qword"
                else: k = "other"
                di.write("%08X\t%d\t%s\t%s\n" % (ea, sz, k, idc.get_name(ea) or ""))
            elif WLO <= ea < WHI and not ida_bytes.is_code(fl):
                di.write("%08X\t%d\t%s\t\n" % (ea, 1, "unexplored"))
            ea += sz
    for f in (ch, di, opf, ind, ctl, sw):
        f.close()
    log("code heads %d ; switch heads %d" % (nch, nsw))

    # ---- per-run heads, xrefs, owning function
    rh = open(os.path.join(OUT, "runs-heads.tsv"), "w", encoding="utf-8", newline="\n")
    rh.write("run_start\trun_end\tpos\tea\tsize\tis_code\tfeature\tbytes\tdisasm\n")
    xr = open(os.path.join(OUT, "xrefs.tsv"), "w", encoding="utf-8", newline="\n")
    xr.write("run_start\tto\tfrom\ttype\tiscode\tfrom_disasm\n")
    fu = open(os.path.join(OUT, "funcs.tsv"), "w", encoding="utf-8", newline="\n")
    fu.write("run_start\tfunc_start\tfunc_end\tname\tchunk_start\tchunk_end\n")
    for s, e in runs:
        p = ida_bytes.get_item_head(s - 1)
        for pos, ea in [("prev", p)]:
            fl = ida_bytes.get_flags(ea); sz = ida_bytes.get_item_size(ea)
            feat = 0
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t(); ida_ua.decode_insn(insn, ea); feat = insn.get_canon_feature()
            rh.write("%08X\t%08X\t%s\t%08X\t%d\t%d\t%X\t%s\t%s\n" % (s, e, pos, ea, sz, int(ida_bytes.is_code(fl)), feat, hexb(ea, sz), dis(ea)))
        ea = ida_bytes.get_item_head(s)
        while ea < e:
            fl = ida_bytes.get_flags(ea); sz = max(ida_bytes.get_item_size(ea), 1)
            feat = 0
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t(); ida_ua.decode_insn(insn, ea); feat = insn.get_canon_feature()
            rh.write("%08X\t%08X\t%s\t%08X\t%d\t%d\t%X\t%s\t%s\n" % (s, e, "in", ea, sz, int(ida_bytes.is_code(fl)), feat, hexb(ea, sz), dis(ea)))
            ea += sz
        fl = ida_bytes.get_flags(ea); sz = ida_bytes.get_item_size(ea)
        rh.write("%08X\t%08X\t%s\t%08X\t%d\t%d\t%X\t%s\t%s\n" % (s, e, "next", ea, sz, int(ida_bytes.is_code(fl)), 0, hexb(ea, sz), dis(ea)))
        for t in range(s, e):
            for x in idautils.XrefsTo(t, 0):
                if s <= x.frm < e:
                    continue
                xr.write("%08X\t%08X\t%08X\t%d\t%d\t%s\n" % (s, t, x.frm, x.type, int(x.iscode), dis(x.frm)))
        f = ida_funcs.get_func(s)
        if f:
            c = ida_funcs.get_fchunk(s)
            fu.write("%08X\t%08X\t%08X\t%s\t%08X\t%08X\n" % (s, f.start_ea, f.end_ea, idc.get_func_name(s), c.start_ea, c.end_ea))
        else:
            fu.write("%08X\t\t\t(no function)\t\t\n" % s)
    for f in (rh, xr, fu):
        f.close()
    log("done")


try:
    os.makedirs(OUT, exist_ok=True)
    open(STATUS, "w").close()
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
