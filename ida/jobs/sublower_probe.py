r"""SUB-LOWER job 2b: read-only measurement of the lower region.

Reopen SUB_LOWER (already loaded, segmented, 478 functions from the fixed
vectors). Nothing here creates functions; that is job 2c.

A. Real branch/call/operand scan over every recovered function: does actual
   decoded code anywhere reference 0xFFC00000-0xFFE80000, and how.
B. Linear-sweep coherence metric per 1 KB of LOWER, calibrated against known
   code blocks in UPPER and against the confirmed bitmap font at 0xFFC3A000.
C. Cross-references to the setup-label table and its named labels.
D. Proper decode of the two jump tables at 0xFFF0897E and 0xFFF08B1F.
E. Prologue-pattern candidate list for job 2c (written, not applied).

Outputs under ida/out/sub-lower.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import collections
import os
import struct
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "probe_error.txt")
LO = 0xFFC00000
HI = 0xFFE80000
TOP = 0x100000000
BLK = 1024

O_NEAR = ida_ua.o_near
O_MEM = ida_ua.o_mem
O_IMM = ida_ua.o_imm
O_DISPL = ida_ua.o_displ
O_PHRASE = ida_ua.o_phrase

NOTE = []


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


# ---------------------------------------------------------------- A
def scan_real_refs() -> None:
    """Every operand of every instruction inside a recovered function."""
    rows = []
    kinds = collections.Counter()
    n_insn = 0
    for start in idautils.Functions():
        f = ida_funcs.get_func(start)
        if f is None:
            continue
        for ea in idautils.FuncItems(start):
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) <= 0:
                continue
            n_insn += 1
            mnem = insn.get_canon_mnem()
            for i in range(8):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                val = None
                if op.type in (O_NEAR, O_MEM):
                    val = op.addr
                elif op.type == O_IMM:
                    val = op.value
                elif op.type == O_DISPL:
                    val = op.addr
                if val is None:
                    continue
                if LO <= val < HI:
                    tk = ("branch" if op.type == O_NEAR
                          else "mem" if op.type == O_MEM
                          else "imm" if op.type == O_IMM else "displ")
                    kinds[(tk, mnem)] += 1
                    rows.append((ea, mnem, tk, val, dis(ea)))
    with open(os.path.join(OUT, "real_refs_into_lower.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("from_ea\tmnem\top_kind\ttarget\tinsn\n")
        for r in sorted(rows):
            fh.write("%08X\t%s\t%s\t%08X\t%s\n" % r)
    NOTE.append("A: decoded %d instructions in %d functions"
                % (n_insn, len(list(idautils.Functions()))))
    NOTE.append("A: operands resolving into LOWER: %d" % len(rows))
    br = sum(c for (k, _m), c in kinds.items() if k == "branch")
    NOTE.append("A: of those, o_near (control transfer): %d" % br)
    for (k, m), c in kinds.most_common(30):
        NOTE.append("A:   %-7s %-8s %5d" % (k, m, c))
    tgts = sorted({r[3] for r in rows})
    NOTE.append("A: distinct LOWER targets referenced by real code: %d" % len(tgts))
    if tgts:
        NOTE.append("A: lowest %08X  highest %08X" % (tgts[0], tgts[-1]))


# ---------------------------------------------------------------- B
def sweep(a: int, end: int):
    """Linear decode from a. Returns (n_insn, fail_bytes, boundaries, branches,
    branch_hits_boundary, saw_return)."""
    bounds = set()
    branches = []
    n = 0
    fail = 0
    saw_ret = False
    ea = a
    insn = ida_ua.insn_t()
    while ea < end:
        bounds.add(ea)
        ln = ida_ua.decode_insn(insn, ea)
        if ln <= 0:
            fail += 1
            ea += 1
            continue
        n += 1
        m = insn.get_canon_mnem()
        if m in ("rts", "rtsd", "rte", "rtfi"):
            saw_ret = True
        for i in range(4):
            op = insn.ops[i]
            if op.type == ida_ua.o_void:
                break
            if op.type == O_NEAR:
                branches.append(op.addr)
        ea += ln
    hits = sum(1 for t in branches if t in bounds)
    return n, fail, bounds, len(branches), hits, saw_ret


def coherence() -> None:
    rows = []
    for a in range(LO, HI, BLK):
        end = a + BLK
        n, fail, bounds, nbr, hits, ret = sweep(a, end)
        # a second sweep, offset by 1, to test self-synchronisation
        n2, fail2, b2, _nb2, _h2, _r2 = sweep(a + 1, end)
        conv = len(bounds & b2) / max(1, min(len(bounds), len(b2)))
        rows.append((a, n, fail, nbr, hits,
                     (hits / nbr) if nbr else -1.0, conv, 1 if ret else 0))
    with open(os.path.join(OUT, "coherence.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("ea\tinsns\tfail_bytes\tbranches\tbranch_on_boundary\t"
                 "branch_align_frac\tsync_frac\tsaw_return\n")
        for r in rows:
            fh.write("%08X\t%d\t%d\t%d\t%d\t%.4f\t%.4f\t%d\n" % r)

    # calibration: known-code blocks in UPPER (aligned to the start of large funcs)
    cal = []
    for start in idautils.Functions():
        f = ida_funcs.get_func(start)
        if f and f.end_ea - f.start_ea > 700 and start >= HI:
            cal.append(start & ~0x3FF)
        if len(cal) >= 24:
            break
    cal_rows = []
    for a in sorted(set(cal)):
        n, fail, bounds, nbr, hits, ret = sweep(a, a + BLK)
        n2, _f2, b2, _n, _h, _r = sweep(a + 1, a + BLK)
        conv = len(bounds & b2) / max(1, min(len(bounds), len(b2)))
        cal_rows.append((a, n, fail, nbr, hits,
                         (hits / nbr) if nbr else -1.0, conv, 1 if ret else 0))
    with open(os.path.join(OUT, "coherence_calibration.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tinsns\tfail_bytes\tbranches\tbranch_on_boundary\t"
                 "branch_align_frac\tsync_frac\tsaw_return\tnote\n")
        for r in cal_rows:
            fh.write("%08X\t%d\t%d\t%d\t%d\t%.4f\t%.4f\t%d\tUPPER known code\n" % r)
        for a in (0xFFC3A000, 0xFFC3A400, 0xFFC50000, 0xFFC60000, 0xFFD00000):
            n, fail, bounds, nbr, hits, ret = sweep(a, a + BLK)
            n2, _f2, b2, _n, _h, _r = sweep(a + 1, a + BLK)
            conv = len(bounds & b2) / max(1, len(b2))
            fh.write("%08X\t%d\t%d\t%d\t%d\t%.4f\t%.4f\t%d\tLOWER control\n"
                     % (a, n, fail, nbr, hits, (hits / nbr) if nbr else -1.0,
                        conv, 1 if ret else 0))

    def stats(rs):
        if not rs:
            return "none"
        al = [r[5] for r in rs if r[5] >= 0]
        fl = [r[2] for r in rs]
        al.sort()
        fl.sort()
        return ("n=%d  branch_align median %.3f  fail_bytes median %d"
                % (len(rs), al[len(al) // 2] if al else -1, fl[len(fl) // 2]))

    NOTE.append("B: LOWER blocks       %s" % stats(rows))
    NOTE.append("B: UPPER calibration  %s" % stats(cal_rows))
    good = [r for r in rows if r[5] >= 0.90 and r[2] == 0 and r[3] >= 4]
    NOTE.append("B: LOWER blocks meeting code-like test "
                "(branch_align>=0.90, 0 fail bytes, >=4 branches): %d" % len(good))
    for r in good[:60]:
        NOTE.append("B:   %08X insns %d branches %d align %.3f"
                    % (r[0], r[1], r[3], r[5]))


# ---------------------------------------------------------------- C
LABELS = {
    0xFFC3DF4D: "setup-label table base",
    0xFFC3DF75: "BAND SCOPE",
    0xFFC3E5C9: "COM PORT SETTING",
    0xFFC3E709: "USB CAMERA",
    0xFFC3E759: "RAM DISPLAY",
    0xFFED74F0: "record table base",
    0xFFED7540: "USB CAMERA record",
}


def label_xrefs() -> None:
    with open(os.path.join(OUT, "label_xrefs.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("addr\tnote\tkind\tfrom\tdetail\n")
        for addr, note in sorted(LABELS.items()):
            n = 0
            for xr in idautils.XrefsTo(addr, 0):
                fh.write("%08X\t%s\txref\t%08X\t%s\n"
                         % (addr, note, xr.frm, dis(xr.frm)))
                n += 1
            # also: any decoded instruction whose operand equals this address
            NOTE.append("C: %08X %-24s ida xrefs %d" % (addr, note, n))
    # brute force: scan every recovered instruction for these constants
    want = set(LABELS)
    # plus the whole 20-byte-stride table range
    tbl_lo, tbl_hi = 0xFFC3DF4D, 0xFFC3E8D4
    hits = []
    for start in idautils.Functions():
        for ea in idautils.FuncItems(start):
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) <= 0:
                continue
            for i in range(8):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                v = (op.value if op.type == O_IMM
                     else op.addr if op.type in (O_MEM, O_NEAR, O_DISPL) else None)
                if v is None:
                    continue
                if v in want or tbl_lo <= v < tbl_hi:
                    hits.append((ea, v, dis(ea)))
    with open(os.path.join(OUT, "label_operand_hits.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("from_ea\tvalue\tinsn\n")
        for r in hits:
            fh.write("%08X\t%08X\t%s\n" % r)
    NOTE.append("C: operands inside the setup-label table range "
                "%08X-%08X across all recovered code: %d" % (tbl_lo, tbl_hi, len(hits)))
    for r in hits[:40]:
        NOTE.append("C:   %08X -> %08X  %s" % r)


# ---------------------------------------------------------------- D
def jump_tables() -> None:
    with open(os.path.join(OUT, "jump_tables.txt"), "w", encoding="utf-8",
              newline="\n") as fh:
        for site in (0xFFF0897E, 0xFFF08B1F, 0xFFF0896A):
            fh.write("\n=== context around %08X ===\n" % site)
            ea = site - 0x40
            while ea < site + 0x40:
                sz = max(1, ida_bytes.get_item_size(ea))
                bs = ida_bytes.get_bytes(ea, sz) or b""
                mark = " <<<" if ea == site else ""
                fh.write("%08X  %-20s %s%s\n" % (ea, bs.hex(), dis(ea), mark))
                ea += sz
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, site) > 0:
                fh.write("decoded: %s  len %d\n" % (dis(site), insn.size))
                for i in range(4):
                    op = insn.ops[i]
                    if op.type == ida_ua.o_void:
                        break
                    fh.write("  op%d type %d addr %08X value %08X reg %d phrase %d\n"
                             % (i, op.type, op.addr, op.value, op.reg, op.phrase))
        # dump the two tables the previous pass reported
        for tbl in (0xFFED75A8, 0xFFED75B8, 0xFFED74F0):
            fh.write("\n=== table at %08X, 32 dwords ===\n" % tbl)
            for i in range(32):
                ea = tbl + i * 4
                v = ida_bytes.get_dword(ea)
                where = ("LOWER" if LO <= v < HI
                         else "UPPER" if HI <= v < TOP else "out")
                fn = ida_funcs.get_func(v)
                fh.write("  [%2d] %08X = %08X  %-5s %s\n"
                         % (i, ea, v, where,
                            (idc.get_func_name(fn.start_ea) if fn else "")))


# ---------------------------------------------------------------- E
PROLOGUES = (
    ("add_imm8_r0", bytes.fromhex("7100"), 3, lambda b: b[2] >= 0x80),
    ("sub_imm4_r0", bytes.fromhex("60"), 2,
     lambda b: (b[1] & 0x0F) == 0 and (b[1] >> 4) != 0),
    ("push_l", bytes.fromhex("7ea6"), 2, lambda b: True),
    ("pushm", bytes.fromhex("6e"), 2,
     lambda b: (b[1] >> 4) <= (b[1] & 0x0F) and (b[1] & 0x0F) >= 1),
    ("movl_imm_r14", bytes.fromhex("fbe2"), 6, lambda b: True),
    ("add_imm16_r0", bytes.fromhex("7200"), 4, lambda b: True),
)


def prologue_candidates() -> None:
    data = ida_bytes.get_bytes(LO, HI - LO)
    if not data or len(data) != HI - LO:
        NOTE.append("E: could not read LOWER bytes")
        return
    cands = []
    tally = collections.Counter()
    for name, pat, need, test in PROLOGUES:
        pos = data.find(pat)
        while pos >= 0:
            if pos + need <= len(data):
                b = data[pos:pos + need]
                if test(b):
                    ea = LO + pos
                    # candidate must sweep to a return inside 4 KB with no
                    # decode failure -- the cheap structural filter
                    n, fail, bounds, nbr, hits, ret = sweep(ea, min(ea + 0x400, HI))
                    ok = (fail == 0 and ret and (nbr == 0 or hits / nbr >= 0.75))
                    if ok:
                        cands.append((ea, name, n, nbr, hits, 1))
                        tally[name] += 1
            pos = data.find(pat, pos + 1)
    cands.sort()
    with open(os.path.join(OUT, "prologue_candidates.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("ea\tpattern\tinsns_to_return\tbranches\tbranch_on_boundary\tpass\n")
        for r in cands:
            fh.write("%08X\t%s\t%d\t%d\t%d\t%d\n" % r)
    NOTE.append("E: prologue candidates surviving the sweep filter: %d" % len(cands))
    for k, c in tally.most_common():
        NOTE.append("E:   %-16s %d" % (k, c))


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    scan_real_refs()
    coherence()
    label_xrefs()
    jump_tables()
    prologue_candidates()
    with open(os.path.join(OUT, "probe_notes.txt"), "w", encoding="utf-8",
              newline="\n") as fh:
        for line in NOTE:
            fh.write(line + "\n")
    idc.qexit(0)


try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(ERR, "w", encoding="utf-8", newline="\n") as fh:
        fh.write(traceback.format_exc())
        fh.write("\n\n" + "\n".join(NOTE))
    idc.qexit(1)
