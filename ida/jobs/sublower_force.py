r"""SUB-LOWER job 2c: controlled force-code pass and peripheral scan.

Reopen SUB_LOWER. Five things:

1. POSITIVE CONTROL. Run the identical prologue-pattern + linear-sweep filter
   over the UPPER code region and measure recall against the 478 known function
   starts. Without this the zero result in LOWER means nothing.
2. TIERED CANDIDATES in LOWER: raw pattern hits -> no decode failures ->
   reaches a return -> branch targets land on boundaries. Honest precision.
3. POINTER TARGETS. Every distinct LOWER address named by an aligned dword in
   the image: code or data, and which kind of data.
4. FORCE. Actually try ida_funcs.add_func at the surviving candidates and count
   what IDA accepts and what it rejects.
5. PERIPHERAL REFERENCES. Register-tracked scan for the RX64M peripheral window
   0x00080000-0x000FFFFF across all recovered code, plus a raw scan of LOWER.
   Covers #imm, register-indirect and dsp:8/dsp:16 displacement forms.

Plus a correct disassembly of the two jump-table sites (the earlier dump used
the stored item size on unexplored bytes and printed garbage).
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
import ida_idp
import ida_ua
import idautils
import idc

OUT = str(_REPO / "ida/out/sub-lower")
ERR = os.path.join(OUT, "force_error.txt")
LO = 0xFFC00000
HI = 0xFFE80000
TOP = 0x100000000
PLO = 0x00080000
PHI = 0x00100000
USB0_LO = 0x000A0000
USB0_HI = 0x000A0400
NOTE = []

O_NEAR = ida_ua.o_near
O_MEM = ida_ua.o_mem
O_IMM = ida_ua.o_imm
O_DISPL = ida_ua.o_displ
O_PHRASE = ida_ua.o_phrase
O_REG = ida_ua.o_reg


def esc(t: str) -> str:
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def dis(ea: int) -> str:
    return esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE))


def sweep(a: int, end: int):
    """Linear decode. (n_insn, fail_bytes, boundaries, n_branch, n_on_boundary,
    saw_return, bytes_covered)."""
    bounds = set()
    branches = []
    n = fail = cov = 0
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
        cov += ln
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
    return n, fail, bounds, len(branches), hits, saw_ret, cov


PROLOGUES = (
    ("add_imm8_r0", bytes.fromhex("7100"), 3, lambda b: b[2] >= 0x80),
    ("sub_imm4_r0", bytes.fromhex("60"), 2,
     lambda b: (b[1] & 0x0F) == 0 and (b[1] >> 4) != 0),
    ("push_l_r6", bytes.fromhex("7ea6"), 2, lambda b: True),
    ("pushm", bytes.fromhex("6e"), 2,
     lambda b: 1 <= (b[1] >> 4) < (b[1] & 0x0F) <= 15),
    ("movl_imm32_r14", bytes.fromhex("fbe2"), 6, lambda b: True),
    ("add_imm16_r0", bytes.fromhex("7200"), 4, lambda b: True),
)

WIN = 0x400  # sweep window for the filter


def tiered_scan(lo: int, hi: int, tag: str):
    """Return (rows, tally) where rows = (ea, pattern, tier)."""
    data = ida_bytes.get_bytes(lo, hi - lo)
    if not data or len(data) != hi - lo:
        NOTE.append("%s: could not read %08X-%08X" % (tag, lo, hi))
        return [], collections.Counter()
    rows = []
    tally = collections.Counter()
    for name, pat, need, test in PROLOGUES:
        pos = data.find(pat)
        while pos >= 0:
            if pos + need <= len(data) and test(data[pos:pos + need]):
                ea = lo + pos
                tally["t0_raw"] += 1
                tally["t0_raw_" + name] += 1
                n, fail, bounds, nbr, hop, ret, _c = sweep(ea, min(ea + WIN, hi))
                tier = 0
                if fail == 0:
                    tier = 1
                    tally["t1_nofail"] += 1
                    if ret:
                        tier = 2
                        tally["t2_return"] += 1
                        if nbr == 0 or hop / nbr >= 0.75:
                            tier = 3
                            tally["t3_align"] += 1
                            if n > 0 and _c / max(1, n) >= 2.0:
                                tier = 4
                                tally["t4_meanlen"] += 1
                if tier >= 1:
                    rows.append((ea, name, tier, n, fail, nbr, hop,
                                 _c / max(1, n)))
            pos = data.find(pat, pos + 1)
    return rows, tally


def control() -> None:
    """Positive control over the UPPER region where the 478 functions live."""
    known = set()
    for s in idautils.Functions():
        if s >= HI:
            known.add(s)
    rows, tally = tiered_scan(0xFFEDA000, 0xFFF50000, "CTRL")
    found = {r[0] for r in rows if r[2] >= 3}
    found4 = {r[0] for r in rows if r[2] >= 4}
    NOTE.append("CONTROL: known function starts in FFEDA000-FFF50000: %d"
                % len(known & set(range(0xFFEDA000, 0xFFF50000))))
    kn = {k for k in known if 0xFFEDA000 <= k < 0xFFF50000}
    NOTE.append("CONTROL: tier counts %s" % dict(
        (k, v) for k, v in sorted(tally.items()) if not k.startswith("t0_raw_")))
    NOTE.append("CONTROL: tier>=3 candidates %d, of which real function starts %d "
                "(recall %.1f%% of %d known)"
                % (len(found), len(found & kn),
                   100.0 * len(found & kn) / max(1, len(kn)), len(kn)))
    NOTE.append("CONTROL: tier>=4 candidates %d, of which real function starts %d "
                "(recall %.1f%%)"
                % (len(found4), len(found4 & kn),
                   100.0 * len(found4 & kn) / max(1, len(kn))))
    with open(os.path.join(OUT, "control_candidates.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tpattern\ttier\tinsns\tfail\tbranches\ton_boundary\t"
                 "mean_len\tis_known_func\n")
        for r in sorted(rows):
            fh.write("%08X\t%s\t%d\t%d\t%d\t%d\t%d\t%.2f\t%s\n"
                     % (r + (("yes" if r[0] in kn else "no"),)))


def lower_scan() -> list:
    rows, tally = tiered_scan(LO, HI, "LOWER")
    NOTE.append("LOWER: tier counts %s" % dict(
        (k, v) for k, v in sorted(tally.items()) if not k.startswith("t0_raw_")))
    NOTE.append("LOWER: raw pattern hits by pattern: %s" % dict(
        (k[7:], v) for k, v in sorted(tally.items()) if k.startswith("t0_raw_")))
    with open(os.path.join(OUT, "lower_candidates.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tpattern\ttier\tinsns\tfail\tbranches\ton_boundary\tmean_len\n")
        for r in sorted(rows):
            fh.write("%08X\t%s\t%d\t%d\t%d\t%d\t%d\t%.2f\n" % r)
    return rows


def classify_targets() -> None:
    """Every distinct LOWER address named by an aligned dword anywhere."""
    src = os.path.join(OUT, "ptr_into_lower.tsv")
    tgts = set()
    if os.path.isfile(src):
        with open(src, encoding="utf-8") as fh:
            next(fh)
            for line in fh:
                p = line.rstrip("\n").split("\t")
                tgts.add(int(p[3], 16))
    kinds = collections.Counter()
    rows = []
    for t in sorted(tgts):
        b = ida_bytes.get_bytes(t, 48) or b""
        n, fail, _bd, nbr, hop, ret, cov = sweep(t, min(t + 0x200, HI))
        printable = sum(1 for c in b[:16] if 0x20 <= c < 0x7F)
        nul = b.find(b"\x00")
        if printable >= 5 and 4 <= nul <= 24:
            k = "string"
        elif fail == 0 and ret and (nbr == 0 or hop / nbr >= 0.75) \
                and cov / max(1, n) >= 2.0:
            k = "code_like"
        elif b[:8] == b"\x00" * 8:
            k = "zero_head"
        else:
            k = "data"
        kinds[k] += 1
        rows.append((t, k, n, fail, nbr, hop, b[:16].hex(),
                     "".join(chr(c) if 32 <= c < 127 else "." for c in b[:16])))
    with open(os.path.join(OUT, "ptr_target_class.tsv"), "w",
              encoding="utf-8", newline="\n") as fh:
        fh.write("target\tclass\tinsns\tfail\tbranches\ton_boundary\t"
                 "head16_hex\thead16_ascii\n")
        for r in rows:
            fh.write("%08X\t%s\t%d\t%d\t%d\t%d\t%s\t%s\n" % r)
    NOTE.append("PTR: %d distinct LOWER targets classified: %s"
                % (len(tgts), dict(kinds)))
    for r in rows:
        if r[1] == "code_like":
            NOTE.append("PTR: code_like %08X insns %d branches %d %s"
                        % (r[0], r[2], r[4], r[7]))


def force(rows: list) -> None:
    """Try to make real functions at the surviving candidates."""
    before = len(list(idautils.Functions()))
    attempted = accepted = 0
    detail = []
    for ea, name, tier, n, fail, nbr, hop, mlen in sorted(rows):
        if tier < 2:
            continue
        attempted += 1
        ida_bytes.del_items(ea, 0, 4)
        if ida_ua.create_insn(ea) <= 0:
            detail.append((ea, name, tier, "create_insn_failed"))
            continue
        ok = ida_funcs.add_func(ea)
        if ok:
            accepted += 1
            f = ida_funcs.get_func(ea)
            detail.append((ea, name, tier, "accepted size %d"
                           % (f.end_ea - f.start_ea if f else 0)))
        else:
            detail.append((ea, name, tier, "add_func_rejected"))
    ida_auto.auto_wait()
    after = len(list(idautils.Functions()))
    NOTE.append("FORCE: attempted %d (tier>=2), IDA accepted %d, functions %d -> %d"
                % (attempted, accepted, before, after))
    with open(os.path.join(OUT, "force_result.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("ea\tpattern\ttier\tresult\n")
        for r in detail:
            fh.write("%08X\t%s\t%d\t%s\n" % r)


def periph() -> None:
    """Register-tracked peripheral-window scan over all recovered code, plus a
    raw scan of the LOWER region bytes."""
    rows = []
    usb = []
    CHG = (ida_idp.CF_CHG1, ida_idp.CF_CHG2, ida_idp.CF_CHG3,
           ida_idp.CF_CHG4, ida_idp.CF_CHG5, ida_idp.CF_CHG6)
    for start in idautils.Functions():
        const = {}
        insn = ida_ua.insn_t()
        for ea in idautils.FuncItems(start):
            if ida_ua.decode_insn(insn, ea) <= 0:
                const.clear()
                continue
            mnem = insn.get_canon_mnem()
            feat = insn.get_canon_feature()
            # record effective addresses first, using the register state
            for i in range(4):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                ea_eff = None
                form = ""
                if op.type == O_IMM and PLO <= op.value < PHI:
                    ea_eff, form = op.value, "imm"
                elif op.type == O_MEM and PLO <= op.addr < PHI:
                    ea_eff, form = op.addr, "abs"
                elif op.type == O_DISPL:
                    base = const.get(op.reg)
                    if base is not None and PLO <= base + op.addr < PHI:
                        ea_eff, form = base + op.addr, "base+dsp"
                elif op.type == O_PHRASE:
                    base = const.get(op.reg)
                    if base is not None and PLO <= base < PHI:
                        ea_eff, form = base, "reg_indirect"
                if ea_eff is not None:
                    row = (ea, start, mnem, form, ea_eff, dis(ea))
                    rows.append(row)
                    if USB0_LO <= ea_eff < USB0_HI:
                        usb.append(row)
            # then update the constant map
            if mnem == "mov" and insn.ops[0].type == O_IMM \
                    and insn.ops[1].type == O_REG:
                const[insn.ops[1].reg] = insn.ops[0].value
            else:
                for i in range(6):
                    if feat & CHG[i]:
                        op = insn.ops[i]
                        if op.type == O_REG:
                            const.pop(op.reg, None)
    with open(os.path.join(OUT, "periph_refs.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("insn_ea\tfunc_ea\tmnem\tform\teff_addr\tinsn\n")
        for r in sorted(rows):
            fh.write("%08X\t%08X\t%s\t%s\t%08X\t%s\n" % r)
    by_form = collections.Counter(r[3] for r in rows)
    by_blk = collections.Counter(r[4] & 0xFFFFF000 for r in rows)
    NOTE.append("PERIPH: hits in recovered code %d, by form %s"
                % (len(rows), dict(by_form)))
    for blk, c in sorted(by_blk.items()):
        NOTE.append("PERIPH:   %08X-%08X  %d" % (blk, blk + 0xFFF, c))
    NOTE.append("PERIPH: USB0 %08X-%08X hits: %d" % (USB0_LO, USB0_HI, len(usb)))
    for r in usb[:40]:
        NOTE.append("PERIPH: USB0 %08X %s -> %08X  %s" % (r[0], r[3], r[4], r[5]))

    # raw scan of the LOWER region for peripheral-range dwords and mov.l forms
    data = ida_bytes.get_bytes(LO, HI - LO) or b""
    raw = []
    for off in range(0, len(data) - 5):
        if data[off] != 0xFB or (data[off + 1] & 0x0F) != 0x02:
            continue
        v = struct.unpack_from("<I", data, off + 2)[0]
        if PLO <= v < PHI:
            raw.append((LO + off, v))
    dw = collections.Counter()
    for off in range(0, len(data) - 3, 4):
        v = struct.unpack_from("<I", data, off)[0]
        if PLO <= v < PHI:
            dw[v] += 1
    NOTE.append("PERIPH: LOWER raw 'FB x2 imm32' byte patterns with a "
                "peripheral immediate: %d" % len(raw))
    for ea, v in raw[:40]:
        NOTE.append("PERIPH:   %08X -> %08X" % (ea, v))
    NOTE.append("PERIPH: LOWER aligned dwords in the peripheral window: %d "
                "(distinct %d)" % (sum(dw.values()), len(dw)))
    usbdw = {k: v for k, v in dw.items() if USB0_LO <= k < USB0_HI}
    NOTE.append("PERIPH: LOWER aligned dwords inside USB0: %s" % (usbdw or "none"))
    with open(os.path.join(OUT, "periph_lower_raw.tsv"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("kind\tea_or_value\tvalue_or_count\n")
        for ea, v in raw:
            fh.write("movl_imm32\t%08X\t%08X\n" % (ea, v))
        for v, c in sorted(dw.items()):
            fh.write("aligned_dword\t%08X\t%d\n" % (v, c))


def jump_tables() -> None:
    with open(os.path.join(OUT, "jump_tables.txt"), "w", encoding="utf-8",
              newline="\n") as fh:
        fh.write("Decoded with ida_ua.decode_insn lengths, not stored item size.\n")
        for site in (0xFFF0896A, 0xFFF0897E, 0xFFF08B1F):
            fh.write("\n=== %08X ===\n" % site)
            ea = site - 0x30
            insn = ida_ua.insn_t()
            while ea < site + 0x60:
                ln = ida_ua.decode_insn(insn, ea)
                if ln <= 0:
                    fh.write("%08X  %-20s (no decode)\n"
                             % (ea, (ida_bytes.get_bytes(ea, 1) or b"").hex()))
                    ea += 1
                    continue
                bs = ida_bytes.get_bytes(ea, ln) or b""
                fh.write("%08X  %-20s %-40s%s\n"
                         % (ea, bs.hex(), dis(ea), "   <<<" if ea == site else ""))
                ea += ln
        for tbl, n in ((0xFFED74F0, 48), (0xFFED75A8, 16), (0xFFED75B8, 16)):
            fh.write("\n=== dwords at %08X ===\n" % tbl)
            for i in range(n):
                ea = tbl + i * 4
                v = ida_bytes.get_dword(ea)
                where = ("LOWER" if LO <= v < HI
                         else "UPPER" if HI <= v < TOP else "small/out")
                f = ida_funcs.get_func(v)
                s = ""
                if LO <= v < HI:
                    b = ida_bytes.get_bytes(v, 20) or b""
                    s = "".join(chr(c) if 32 <= c < 127 else "." for c in b)
                fh.write("  [%2d] %08X = %08X  %-9s %-22s %s\n"
                         % (i, ea, v, where,
                            idc.get_func_name(f.start_ea) if f else "", s))


def coverage(tag: str) -> tuple:
    code = data = unk = 0
    ea = LO
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            code += 1
        elif ida_bytes.is_data(fl):
            data += 1
        else:
            unk += 1
        ea += 1
    nf = sum(1 for s in idautils.Functions() if LO <= s < HI)
    bf = sum((ida_funcs.get_func(s).end_ea - s)
             for s in idautils.Functions() if LO <= s < HI)
    NOTE.append("COVERAGE %s: LOWER code %d data %d unknown %d | functions %d "
                "bytes_in_functions %d" % (tag, code, data, unk, nf, bf))
    return code, data, unk, nf, bf


def main() -> None:
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    coverage("before")
    control()
    rows = lower_scan()
    classify_targets()
    periph()
    jump_tables()
    force(rows)
    coverage("after")
    with open(os.path.join(OUT, "force_notes.txt"), "w", encoding="utf-8",
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
