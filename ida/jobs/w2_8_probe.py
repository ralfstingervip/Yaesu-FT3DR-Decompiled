r"""Lane W2-8: re-validate lane 5 recovered functions (Task 2) and decode-probe
the residual 'other' runs (Task 1 helper), on a private copy of MAIN_RAW.

Seeded --copy-from ida\db\jobs\MAIN_RAW\MAIN_RAW.i64 into DB W2_MAIN_RAW2.
Read-only w.r.t. lane-5 outputs; writes helper TSVs to ida\log\jobs\W2_MAIN_RAW2\.

Closed boundary honoured: the CDC-ACM / USB<->DSP loader window
0x078106-0x07B753 is never probe-decoded (byte-class only elsewhere).
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import csv
import os
import traceback

import ida_auto
import ida_bytes
import ida_ua
import idautils
import idc

ROOT = str(_REPO)
MF = os.path.join(ROOT, "ida", "out", "main-full")
MR = os.path.join(ROOT, "ida", "out", "main-raw")
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", "W2_MAIN_RAW2")
os.makedirs(LOGDIR, exist_ok=True)
LOG = os.path.join(LOGDIR, "w2_8_probe.run.txt")
_L = []

CONTENT_END = 0x07B754
CODE_LO = 0x400
RAM_LO = 0xFE0000
RAM_HI = 0x1000000
# closed service window (per lane W2-8 scope): no probe-decode inside
CLOSED_LO = 0x078106
CLOSED_HI = 0x07B753

RET = ("rts", "rte", "rtsl", "rtel")
CALL = ("jsr", "bsr")
BRANCH = ("bra", "beq", "bne", "bcs", "bcc", "bhi", "bls", "bmi", "bpl", "bvs",
          "bvc", "bge", "blt", "bgt", "ble", "bt", "bf", "jmp")
PROLOGUE = ("push", "stm", "mov", "sub")   # same set lane 5 used


def log(t):
    _L.append(str(t))
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_L) + "\n")


def esc(t):
    return (t or "").replace("\t", " ").replace("\n", " ").replace("\r", " ")


def load_tsv(path):
    rows = []
    with open(path, encoding="utf-8") as h:
        r = csv.reader(h, delimiter="\t")
        hdr = next(r)
        for x in r:
            if x and not x[0].startswith("#"):
                rows.append(x)
    return rows


def main():
    ida_auto.auto_wait()

    # ---- build independent reachability target set (vector/call/jump) ----
    code_xref_to = set()     # targets of code control-flow xrefs (call/jump)
    data_xref_to = set()     # targets of data refs (offset/read/write)
    for x in load_tsv(os.path.join(MF, "xrefs.tsv")):
        to = int(x[0], 16)
        try:
            typ = int(x[4])
        except Exception:
            typ = 0
        if typ in (16, 17, 18, 19, 21):     # call/jump (near/far), user
            code_xref_to.add(to)
        else:
            data_xref_to.add(to)
    tbl_targets = set()
    for x in load_tsv(os.path.join(MF, "jumptables.tsv")):
        if len(x) >= 4 and x[3]:
            for t in x[3].split(","):
                t = t.strip()
                if t:
                    tbl_targets.add(int(t, 16))
    for x in load_tsv(os.path.join(MF, "switch_tables.tsv")):
        if len(x) >= 4 and x[3]:
            for t in x[3].split(","):
                t = t.strip()
                if t:
                    tbl_targets.add(int(t, 16))
    vec_targets = set()
    for x in load_tsv(os.path.join(MF, "vectors.tsv")):
        if len(x) >= 4 and x[3] != "filler":
            vec_targets.add(int(x[2], 16))
    log("xref_code_to=%d xref_data_to=%d tbl_targets=%d vec_targets=%d"
        % (len(code_xref_to), len(data_xref_to), len(tbl_targets), len(vec_targets)))

    insn = ida_ua.insn_t()

    def decode_body(s, e):
        """re-decode [s,e); return dict of independent stats."""
        st = collections.Counter()
        ea = s
        first = None
        last_mnem = None
        bad = 0
        while ea < e:
            sz = ida_ua.decode_insn(insn, ea)
            m = (ida_ua.print_insn_mnem(ea) or "").lower().split(".")[0]
            if sz <= 0 or insn.itype == 0 or not m:
                bad += 1
                ea += 1
                continue
            if first is None:
                first = m
            last_mnem = m
            st["insn"] += 1
            if m in RET:
                st["ret"] += 1
            elif m in CALL:
                st["call"] += 1
            elif m in BRANCH:
                st["branch"] += 1
            ea += sz
        return st, first, last_mnem, bad

    # ---- Task 2: re-validate every recovered function ----
    recfns = load_tsv(os.path.join(MR, "recovered-functions.tsv"))
    t2 = []
    for x in recfns:
        s = int(x[0], 16); e = int(x[1], 16)
        l5v = x[2]; l5xref = int(x[3])
        # independent reachability via idautils.XrefsTo (.iscode flag)
        n_all = 0; n_cf = 0
        for xr in idautils.XrefsTo(s, 0):
            n_all += 1
            if xr.iscode:
                n_cf += 1
        reach_tbl = s in tbl_targets
        reach_vec = s in vec_targets
        reach_xref_code = (s in code_xref_to) or (n_cf > 0)
        reachable = reach_xref_code or reach_tbl or reach_vec
        st, first, last_mnem, bad = decode_body(s, e)
        structural = st["ret"] + st["call"] + st["branch"]
        prologue = (first in PROLOGUE) if first else False
        byte_ok = (st["ret"] >= 1 and st["insn"] >= 3 and bad == 0
                   and structural > 0 and prologue)
        # Task-2 literal definition: reachable OR (prologue+return byte-decode)
        v_new = reachable or byte_ok
        why = []
        if reach_xref_code: why.append("code-xref")
        if reach_tbl: why.append("jump/switch-table")
        if reach_vec: why.append("vector")
        if byte_ok: why.append("prologue+ret")
        t2.append((s, e, l5v, l5xref, "yes" if v_new else "no",
                   n_all, n_cf, int(reach_tbl), int(reach_vec),
                   first or "?", st["insn"], st["ret"], st["call"], st["branch"],
                   bad, "|".join(why) or "none"))
    log("task2 functions=%d" % len(t2))

    # ---- Task 1 helper: decode-probe residual 'other' runs (non-closed) ----
    runs = load_tsv(os.path.join(MR, "runs.tsv"))
    probe = []
    for x in runs:
        if x[3] != "other":
            continue
        s = int(x[0], 16); e = int(x[1], 16); L = e - s
        if CLOSED_LO <= s <= CLOSED_HI:
            probe.append((s, e, L, "CLOSED", 0, 0, "", "", 0))
            continue
        # linear decode probe
        ea = s; n = 0; covered = 0; first = None; last = None
        seen_ret = False; seen_br = False; refs_inrange = 0
        while ea < e and n < 200:
            sz = ida_ua.decode_insn(insn, ea)
            m = (ida_ua.print_insn_mnem(ea) or "").lower().split(".")[0]
            if sz <= 0 or insn.itype == 0 or not m:
                break
            if first is None:
                first = m
            last = m
            n += 1; covered += sz
            if m in RET:
                seen_ret = True
            if m in BRANCH:
                seen_br = True
            # count in-range control targets (call/jump immediates)
            for k in range(2):
                op = insn.ops[k]
                if op.type in (ida_ua.o_near, ida_ua.o_far):
                    tv = op.addr
                    if CODE_LO <= tv < CONTENT_END:
                        refs_inrange += 1
            ea += sz
        cov = covered / max(1, L)
        clean = (covered == L)
        probe.append((s, e, L, first or "-", n, round(cov, 3),
                      "ret" if seen_ret else ("br" if seen_br else ""),
                      "clean" if clean else "", refs_inrange))
    log("task1 probes=%d" % len(probe))

    # ---- write helper outputs ----
    with open(os.path.join(LOGDIR, "w2_8_task2.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tl5_validated\tl5_xref\tw2_validated\tn_all\tn_codexref"
                "\treach_tbl\treach_vec\tfirst\tinsn\tret\tcall\tbranch\tbad\twhy\n")
        for r in t2:
            h.write("%06X\t%06X\t%s\t%d\t%s\t%d\t%d\t%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\t%s\n" % r)

    with open(os.path.join(LOGDIR, "w2_8_probe.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\tlen\tfirst\tn_insn\tcoverage\tends\tclean\trefs_inrange\n")
        for r in probe:
            h.write("%06X\t%06X\t%d\t%s\t%s\t%s\t%s\t%s\t%s\n" % r)

    # ---- summary counts for task 2 ----
    l5_yes = sum(1 for r in t2 if r[2] == "yes")
    w2_yes = sum(1 for r in t2 if r[4] == "yes")
    confirm = sum(1 for r in t2 if r[2] == "yes" and r[4] == "yes")
    newrej = sum(1 for r in t2 if r[2] == "yes" and r[4] == "no")
    newval = sum(1 for r in t2 if r[2] == "no" and r[4] == "yes")
    both_no = sum(1 for r in t2 if r[2] == "no" and r[4] == "no")
    log("TASK2: total=%d l5_yes=%d w2_yes=%d confirm=%d newreject=%d newvalidate=%d both_no=%d"
        % (len(t2), l5_yes, w2_yes, confirm, newrej, newval, both_no))
    # how the newly-validated got in
    nv_tbl = sum(1 for r in t2 if r[2] == "no" and r[4] == "yes" and r[7] == 1)
    nv_vec = sum(1 for r in t2 if r[2] == "no" and r[4] == "yes" and r[8] == 1)
    nv_byte = sum(1 for r in t2 if r[2] == "no" and r[4] == "yes" and "prologue+ret" in r[15])
    nv_cx = sum(1 for r in t2 if r[2] == "no" and r[4] == "yes" and "code-xref" in r[15])
    log("newvalidate-by: code-xref=%d jump/switch-tbl=%d vector=%d prologue+ret=%d"
        % (nv_cx, nv_tbl, nv_vec, nv_byte))


try:
    main()
except Exception:
    _L.append("TRACEBACK\n" + traceback.format_exc())
    with open(LOG, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(_L) + "\n")
idc.qexit(0)
