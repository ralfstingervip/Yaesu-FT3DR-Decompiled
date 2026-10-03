r"""Wave-2 slice-1 SUB-window function characterization (owner static analysis).

Reads a slice list (start/end/validated) and the lane-3 purpose map from the
scratchpad, then for every function decodes its body from start..end and emits a
facts TSV to ida\out\wave2\sub-facts-1.tsv. No DB mutation; read-only.

    Set-Location "."
    python ida\run_job.py --script ida\jobs\w2_sub_purpose_k1.py --db W2_SUBP_1 \
        --copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

SP = "local-temp"
OUT = str(_REPO / "ida/out/wave2")
SLICE = os.path.join(SP, "slice1.tsv")
LANE3 = os.path.join(SP, "lane3.tsv")
FACTS = os.path.join(OUT, "sub-facts-1.tsv")
STATUS = os.path.join(OUT, "w2_k1_status.txt")

PERI_LO, PERI_HI = 0x00080000, 0x00100000
RAM_LO, RAM_HI = 0x00000000, 0x00080000
CODE_LO = 0xFFC00000


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def main():
    import ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_nalt, ida_xref

    lane3 = {}
    with open(LANE3, encoding="utf-8") as f:
        for ln in f:
            p = ln.rstrip("\n").split("\t")
            if len(p) >= 2:
                lane3[p[0].upper()] = p[1]

    def peri_name(v):
        return lane3.get(("%08X" % v).upper())

    def get_str(ea):
        for st in (ida_nalt.STRTYPE_C, ida_nalt.STRTYPE_C_16):
            s = idc.get_strlit_contents(ea, -1, st)
            if s:
                try:
                    return s.decode("latin-1", "replace")
                except Exception:
                    return None
        return None

    rows = []
    with open(SLICE, encoding="utf-8") as f:
        for ln in f:
            p = ln.rstrip("\n").split("\t")
            if len(p) >= 2:
                rows.append((int(p[0], 16), int(p[1], 16), p[2] if len(p) > 2 else ""))

    out = []
    for start, end, validated in rows:
        size = end - start
        # Use IDA's real function boundary when start is a defined function
        # entry; lane-4 rows' `end` is only the next label, so it truncates
        # over-split bodies. func_here=1 means IDA has a func starting here.
        f = ida_funcs.get_func(start)
        func_here = 1 if (f and f.start_ea == start) else 0
        interior = 1 if (f and f.start_ea != start) else 0  # start is mid-func
        if func_here:
            body_end = f.end_ea
        else:
            body_end = end
        insn_cnt = 0
        code_bytes = 0
        bad = 0
        calls = []          # (target, kind)
        rts = 0
        rtsd = 0
        loops = 0           # backward branches within body
        periph = set()
        ramrefs = set()
        immconsts = []
        strings = []
        first_mnems = []
        has_push = False
        prologue = 0
        tail = None
        indjsr = 0
        dtab = set()
        last_mnem = ""
        ea = start
        # xrefs (callers) to start
        callers = 0
        arefs = 0
        call_from = set()
        for xr in idautils.XrefsTo(start, 0):
            if xr.iscode:
                callers += 1
                call_from.add(xr.frm)
            else:
                arefs += 1
        while ea < body_end:
            insn = ida_ua.insn_t()
            ln = ida_ua.decode_insn(insn, ea)
            if ln <= 0:
                bad += 1
                ea += 1
                continue
            mnem = idc.print_insn_mnem(ea).lower()
            insn_cnt += 1
            code_bytes += ln
            last_mnem = mnem
            if len(first_mnems) < 6:
                first_mnems.append(mnem)
            if mnem in ("push", "pushm"):
                has_push = True
            # prologue detection on the very first instruction of the row
            if ea == start:
                if mnem in ("push", "pushm", "mvfc"):
                    prologue = 1
                elif mnem in ("sub", "add", "mov"):
                    # SP is R0 in RX; a first-insn write to R0 is stack setup
                    dst = insn.ops[1] if insn.ops[1].type != ida_ua.o_void else insn.ops[0]
                    if dst.type == ida_ua.o_reg and dst.reg == 0:
                        prologue = 1
            if mnem == "rts":
                rts += 1
            elif mnem == "rtsd":
                rtsd += 1
            elif mnem in ("bsr", "jsr"):
                if insn.ops[0].type == ida_ua.o_near:
                    tv = idc.get_operand_value(ea, 0)
                    calls.append((tv & 0xFFFFFFFF, mnem))
                else:
                    indjsr += 1
            elif mnem in ("bra", "jmp") and ea + ln >= body_end:
                # tail branch at end of body
                tv = idc.get_operand_value(ea, 0)
                tail = tv & 0xFFFFFFFF
            elif mnem in ("beq", "bne", "bgeu", "bltu", "bgtu", "bleu", "bge",
                          "blt", "bgt", "ble", "bo", "bno", "bpz", "bn", "bc",
                          "bnc", "bra", "bt", "bf"):
                tv = idc.get_operand_value(ea, 0)
                if start <= tv < ea:
                    loops += 1
            # operand scan for memory/imm addresses
            for opn in range(4):
                op = insn.ops[opn]
                if op.type == ida_ua.o_void:
                    break
                if op.type in (ida_ua.o_mem, ida_ua.o_displ, ida_ua.o_far):
                    v = op.addr & 0xFFFFFFFF
                    if PERI_LO <= v < PERI_HI:
                        periph.add(v)
                    elif RAM_LO < v < RAM_HI and op.type == ida_ua.o_mem:
                        ramrefs.add(v)
                elif op.type == ida_ua.o_imm:
                    iv = op.value & 0xFFFFFFFF
                    if PERI_LO <= iv < PERI_HI:
                        periph.add(iv)
                    elif 0xFFED0000 <= iv < 0xFFEDA000:
                        # immediate into the SUB rodata/pointer-table region:
                        # dispatch/jump/vtable pointer table
                        dtab.add(iv)
                    elif iv >= CODE_LO:
                        # pointer-ish immediate into flash; check for string
                        s = get_str(iv)
                        if s and 2 <= len(s) <= 40 and s.isprintable():
                            strings.append(s)
                    elif RAM_LO < iv < RAM_HI:
                        ramrefs.add(iv)
                    else:
                        immconsts.append(iv)
            ea += ln
        # fall-through: last instruction is not a flow-terminator
        falls_through = 0 if last_mnem in ("rts", "rtsd", "rte", "rtfi", "bra", "jmp") else 1
        # forward scan past body_end to find where control really returns, to
        # tie over-split fall-through fragments to their terminating routine.
        reach_dist = 0
        reach_term = ""
        if falls_through:
            fea = body_end
            steps = 0
            while steps < 400:
                fi = ida_ua.insn_t()
                fl2 = ida_ua.decode_insn(fi, fea)
                if fl2 <= 0:
                    reach_term = "bad"
                    break
                fm = idc.print_insn_mnem(fea).lower()
                if fm in ("rts", "rtsd", "rte", "rtfi"):
                    reach_term = fm
                    reach_dist = fea + fl2 - body_end
                    break
                if fm in ("bra", "jmp"):
                    reach_term = fm
                    reach_dist = fea + fl2 - body_end
                    break
                fea += fl2
                steps += 1
            if not reach_term:
                reach_term = "far"
                reach_dist = fea - body_end
        # For an over-split fall-through prologue, the routine's real behavior
        # lives past body_end. Extend the scan through to the return so this
        # row's calls/periph/strings describe the whole routine it heads.
        ext = 0
        if falls_through and reach_term in ("rts", "rtsd") and reach_dist <= 512:
            xea = body_end
            xend = body_end + reach_dist
            while xea < xend:
                xi = ida_ua.insn_t()
                xl = ida_ua.decode_insn(xi, xea)
                if xl <= 0:
                    break
                xm = idc.print_insn_mnem(xea).lower()
                ext += 1
                if xm in ("bsr", "jsr"):
                    if xi.ops[0].type == ida_ua.o_near:
                        calls.append((idc.get_operand_value(xea, 0) & 0xFFFFFFFF, xm))
                    else:
                        indjsr += 1
                for opn in range(4):
                    op = xi.ops[opn]
                    if op.type == ida_ua.o_void:
                        break
                    if op.type in (ida_ua.o_mem, ida_ua.o_displ, ida_ua.o_far):
                        v = op.addr & 0xFFFFFFFF
                        if PERI_LO <= v < PERI_HI:
                            periph.add(v)
                    elif op.type == ida_ua.o_imm:
                        iv = op.value & 0xFFFFFFFF
                        if PERI_LO <= iv < PERI_HI:
                            periph.add(iv)
                        elif 0xFFED0000 <= iv < 0xFFEDA000:
                            dtab.add(iv)
                        elif iv >= CODE_LO:
                            s = get_str(iv)
                            if s and 2 <= len(s) <= 40 and s.isprintable():
                                strings.append(s)
                xea += xl
        # also collect string xrefs via data refs from body
        # resolve call purposes
        callp = []
        for tv, kind in calls[:8]:
            key = ("%08X" % tv).upper()
            p = lane3.get(key)
            callp.append((key, p))
        periph_named = []
        for v in sorted(periph):
            nm = peri_name(v)
            periph_named.append("%08X%s" % (v, ("=" + nm) if nm else ""))

        rec = {
            "ea": "%08X" % start,
            "end": "%08X" % end,
            "size": size,
            "validated": validated,
            "func_here": func_here,
            "interior": interior,
            "bodyend": "%08X" % body_end,
            "insn": insn_cnt,
            "cbytes": code_bytes,
            "bad": bad,
            "haspush": int(has_push),
            "prologue": prologue,
            "rts": rts,
            "rtsd": rtsd,
            "loops": loops,
            "callers": callers,
            "arefs": arefs,
            "ncalls": len(calls),
            "indjsr": indjsr,
            "dtab": ";".join("%08X" % v for v in sorted(dtab)[:4]),
            "tail": ("%08X" % tail) if tail else "",
            "last": last_mnem,
            "fallthru": falls_through,
            "reachterm": reach_term,
            "reachdist": reach_dist,
            "ext": ext,
            "first": ",".join(first_mnems),
            "calls": ";".join("%s%s" % (k, ("[" + p + "]") if p else "") for k, p in callp),
            "periph": ";".join(periph_named[:12]),
            "ram": ";".join("%08X" % v for v in sorted(ramrefs)[:8]),
            "imm": ";".join("%X" % v for v in immconsts[:8]),
            "str": " | ".join(strings[:5]),
        }
        out.append(rec)

    cols = ["ea", "end", "size", "validated", "func_here", "interior", "bodyend",
            "insn", "cbytes", "bad", "haspush",
            "prologue", "rts", "rtsd", "loops", "callers", "arefs", "ncalls", "indjsr", "dtab", "tail", "last",
            "fallthru", "reachterm", "reachdist", "ext", "first",
            "calls", "periph", "ram", "imm", "str"]
    with open(FACTS, "w", encoding="utf-8", newline="\n") as h:
        h.write("\t".join(cols) + "\n")
        for r in out:
            h.write("\t".join(str(r[c]) for c in cols) + "\n")
    log("wrote %d rows to %s" % (len(out), FACTS))


if True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "w2_k1_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION")
    import idc as _idc
    _idc.qexit(0)
