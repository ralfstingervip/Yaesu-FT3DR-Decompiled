r"""Lane W2-8 Task-1 helper (corrected): decode-probe residual 'other' runs.
Undefined bytes: rely on decode_insn sz>0 & itype!=0 (print_insn_mnem returns
"" on undefined items). Mnemonic via insn.get_canon_mnem for ret/branch/call.
Closed window 0x078106-0x07B753 is never probed (byte-class only).
Reopen DB W2_MAIN_RAW2.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import csv, os, traceback
import ida_auto, ida_ua, ida_idp, idc

ROOT = str(_REPO)
MR = os.path.join(ROOT, "ida", "out", "main-raw")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", "W2_MAIN_RAW2")
OUT = os.path.join(LOGDIR, "w2_8_probe2.tsv")
LOG = os.path.join(LOGDIR, "w2_8_probe2.run.txt")
CONTENT_END = 0x07B754
CODE_LO = 0x400
CLOSED_LO = 0x078106
CLOSED_HI = 0x07B753
RET = ("rts", "rte", "rtsl", "rtel", "rtd")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf", "jmp")


def load_tsv(path):
    rows = []
    with open(path, encoding="utf-8") as h:
        r = csv.reader(h, delimiter="\t"); next(r)
        for x in r:
            if x and not x[0].startswith("#"):
                rows.append(x)
    return rows


def main():
    ida_auto.auto_wait()
    ph = ida_idp.get_ph() if hasattr(ida_idp, "get_ph") else ida_idp.ph
    insn = ida_ua.insn_t()

    def mnem_of():
        try:
            m = insn.get_canon_mnem(ph)
        except TypeError:
            m = insn.get_canon_mnem()
        return (m or "").lower().split(".")[0]

    runs = load_tsv(os.path.join(MR, "runs.tsv"))
    out = []
    for x in runs:
        if x[3] != "other":
            continue
        s = int(x[0], 16); e = int(x[1], 16); L = e - s
        if CLOSED_LO <= s <= CLOSED_HI:
            out.append((s, e, L, "CLOSED", 0, 0.0, "", "", 0))
            continue
        ea = s; n = 0; covered = 0; first = None; last = None
        seen_ret = seen_br = seen_call = False; refs = 0
        while ea < e and n < 300:
            sz = ida_ua.decode_insn(insn, ea)
            if sz <= 0 or insn.itype == 0:
                break
            m = mnem_of()
            if first is None:
                first = m or "?"
            last = m
            n += 1; covered += sz
            if m in RET: seen_ret = True
            if m in BRANCH: seen_br = True
            if m in CALL: seen_call = True
            for k in range(min(2, len(insn.ops))):
                op = insn.ops[k]
                if op.type in (ida_ua.o_near, ida_ua.o_far):
                    if CODE_LO <= op.addr < CONTENT_END:
                        refs += 1
            ea += sz
        cov = covered / max(1, L)
        ends = "ret" if seen_ret else ("call" if seen_call else ("br" if seen_br else ""))
        clean = "clean" if covered == L else ""
        out.append((s, e, L, first or "-", n, round(cov, 3), ends, clean, refs))

    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlen\tfirst\tn_insn\tcoverage\tends\tclean\trefs_inrange\n")
        for r in out:
            h.write("%06X\t%06X\t%d\t%s\t%d\t%s\t%s\t%s\t%d\n" % r)

    # quick stats
    fullcode = sum(1 for r in out if r[3] not in ("CLOSED", "-") and r[7] == "clean" and r[4] >= 2)
    anycode = sum(1 for r in out if r[3] not in ("CLOSED", "-") and r[4] >= 1)
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("probes=%d cleanfull(>=2 insn,cov==L)=%d any(n>=1)=%d\n"
                % (len(out), fullcode, anycode))


try:
    main()
except Exception:
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("TRACE\n" + traceback.format_exc())
idc.qexit(0)
