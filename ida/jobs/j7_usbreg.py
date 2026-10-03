r"""Lane J7: enumerate accesses to 8 unnamed MAIN USB registers and owner of RAM 0xFF5C06-0xFF5C44.

MAIN, H8SX, base 0 (file offset = mapped addr), big-endian. Reopen/copy-from seed.
READ-ONLY: no edits, no auto-analysis beyond the inherited db. Never decodes inside
the closed window 0x078106-0x07B753.

Outputs under ida\out\usb-registers\work\ and ida\out\usb-registers\ .
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_name, ida_ua, idautils, idc
import ida_ida

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "usb-registers")
WORK = os.path.join(OUT, "work")
WLO, WHI = 0x078106, 0x07B754

REG_TARGETS = [0xFFEE08, 0xFFEE09, 0xFFEE0A, 0xFFEE2E, 0xFFEE44, 0xFFEE50, 0xFFEE51, 0xFFEE53]
# neighbors for context in the full map
REG_ALL_LO, REG_ALL_HI = 0xFFEE00, 0xFFEE54
RAM_LO, RAM_HI = 0xFF5C06, 0xFF5C44          # inclusive-ish owner question
RAM_CTX_LO, RAM_CTX_HI = 0xFF5000, 0xFF6100  # neighborhood

o_void, o_mem, o_imm, o_displ, o_near, o_far = 0, 2, 5, 4, 7, 6

def esc(t):
    return (t or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")

def dline(ea):
    return esc(ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "?"))

def funcname(ea):
    fn = ida_funcs.get_func(ea)
    if fn:
        return "%06x %s" % (fn.start_ea, ida_name.get_name(fn.start_ea) or "")
    return "-"

def context(ea, before=3, after=3):
    rows = []
    # walk backwards
    pre = []
    cur = ea
    for _ in range(before):
        p = idc.prev_head(cur)
        if p == idc.BADADDR or p < 0:
            break
        pre.append(p); cur = p
    for p in reversed(pre):
        rows.append("    %06x  %s" % (p, dline(p)))
    rows.append("  > %06x  %s" % (ea, dline(ea)))
    cur = ea
    for _ in range(after):
        n = idc.next_head(cur, idc.BADADDR)
        if n == idc.BADADDR:
            break
        rows.append("    %06x  %s" % (n, dline(n)))
        cur = n
    return rows

def iter_code_heads():
    """Yield every code head in the image, skipping the closed window."""
    lo = ida_ida.inf_get_min_ea()
    hi = ida_ida.inf_get_max_ea()
    ea = lo
    while ea < hi and ea != idc.BADADDR:
        if WLO <= ea < WHI:
            ea = WHI
            continue
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) and ida_bytes.is_head(fl):
            yield ea
        ea = idc.next_head(ea, hi)

def operand_scan():
    """Decode every code head, record operands whose value is a target reg or RAM-neighborhood addr."""
    reg_hits = []   # (reg, ea, opn, optype, disasm, func)
    ram_hits = []   # same for 0xFF5C06-0xFF5C44 (any op value in range)
    ramnbr = {}     # value -> list of (ea, optype) for the whole neighborhood (for owner map)
    insn = ida_ua.insn_t()
    for ea in iter_code_heads():
        if ida_ua.decode_insn(insn, ea) <= 0:
            continue
        for n in range(6):
            op = insn.ops[n]
            if op.type == o_void:
                break
            vals = []
            if op.type == o_mem:
                vals.append(("mem", op.addr & 0xFFFFFF))   # @aa:16 sign-extends to 0xFFFFEExx; mask to 24-bit
            elif op.type == o_imm:
                vals.append(("imm", op.value & 0xFFFFFF))
            elif op.type == o_displ:
                # H8: op.addr holds displacement; base is a register. Record disp for reach analysis.
                vals.append(("displ", op.addr))
            for kind, v in vals:
                if kind in ("mem", "imm"):
                    if v in REG_TARGETS:
                        reg_hits.append((v, ea, n, kind, dline(ea), funcname(ea)))
                    if RAM_LO <= v <= RAM_HI:
                        ram_hits.append((v, ea, n, kind, dline(ea), funcname(ea)))
                    if RAM_CTX_LO <= v <= RAM_CTX_HI:
                        ramnbr.setdefault(v, []).append((ea, kind))
    return reg_hits, ram_hits, ramnbr

def full_reg_map():
    """Every access to 0xFFEE00-0xFFEE53 via mem/imm operands, grouped by reg."""
    acc = {}
    insn = ida_ua.insn_t()
    for ea in iter_code_heads():
        if ida_ua.decode_insn(insn, ea) <= 0:
            continue
        for n in range(6):
            op = insn.ops[n]
            if op.type == o_void:
                break
            v = None
            if op.type == o_mem:
                v = op.addr & 0xFFFFFF
            elif op.type == o_imm:
                v = op.value & 0xFFFFFF
            if v is not None and REG_ALL_LO <= v < REG_ALL_HI:
                acc.setdefault(v, []).append((ea, n, dline(ea), funcname(ea)))
    return acc

def io_addr(reg):
    # register page is sign-extended to 0xFFFFEExx in this db
    return 0xFFFF0000 | (reg & 0xFFFF)

def xrefs_to(ea):
    out = []
    for x in idautils.XrefsTo(ea, 0):
        if x.type == 21:
            continue
        out.append((x.frm, x.type, dline(x.frm), funcname(x.frm)))
    return out

def main():
    os.makedirs(WORK, exist_ok=True)
    ida_auto.auto_wait()
    log = []

    reg_hits, ram_hits, ramnbr = operand_scan()
    regmap = full_reg_map()

    # ---- per-target register access table + context dumps ----
    with open(os.path.join(OUT, "reg-access.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("reg\tea\topn\tkind\tfunc\tdisasm\n")
        for reg in REG_TARGETS:
            rows = [r for r in reg_hits if r[0] == reg]
            # also merge xrefs (catch bit-manip that decode_insn op scan may label differently)
            xr = xrefs_to(io_addr(reg))
            seen = set(r[1] for r in rows)
            for frm, typ, dis, fn in xr:
                if frm not in seen and not (WLO <= frm < WHI):
                    rows.append((reg, frm, -1, "xref", dis, fn))
                    seen.add(frm)
            if not rows:
                h.write("%06X\t-\t-\tNONE\t-\t(no access outside window)\n" % reg)
            for reg_, ea, opn, kind, dis, fn in sorted(rows, key=lambda r: r[1]):
                h.write("%06X\t%06x\t%s\t%s\t%s\t%s\n" % (reg_, ea, opn, kind, fn, dis))

    with open(os.path.join(WORK, "reg-context.txt"), "w", encoding="utf-8", newline="\n") as h:
        for reg in REG_TARGETS:
            h.write("\n========== %06X ==========\n" % reg)
            rows = sorted(set((r[1]) for r in reg_hits if r[0] == reg))
            xr = [frm for frm, t, d, f in xrefs_to(io_addr(reg)) if not (WLO <= frm < WHI)]
            for frm in xr:
                if frm not in rows:
                    rows.append(frm)
            for ea in sorted(set(rows)):
                h.write("-- access at %06x  (func %s)\n" % (ea, funcname(ea)))
                for line in context(ea):
                    h.write(line + "\n")
                h.write("\n")
    log.append("reg_hits=%d" % len(reg_hits))

    # ---- full FFEE00-FFEE53 map ----
    with open(os.path.join(WORK, "reg-fullmap.txt"), "w", encoding="utf-8", newline="\n") as h:
        for v in sorted(regmap):
            sites = regmap[v]
            h.write("%06X  count=%d\n" % (v, len(sites)))
            for ea, n, dis, fn in sites:
                h.write("    %06x op%d  %-44s  %s\n" % (ea, n, dis, fn))

    # ---- RAM 0xFF5C06-0xFF5C44 owner ----
    with open(os.path.join(OUT, "ram-ff5c06.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("# direct absolute (mem/imm) operand references into 0xFF5C06-0xFF5C44 (outside window)\n")
        h.write("addr\tea\topn\tkind\tfunc\tdisasm\n")
        if not ram_hits:
            h.write("-\t-\t-\tNONE\t-\t(no direct absolute reference in 0xFF5C06-0xFF5C44 anywhere outside window)\n")
        for v, ea, opn, kind, dis, fn in sorted(ram_hits, key=lambda r: r[1]):
            h.write("%06X\t%06x\t%s\t%s\t%s\t%s\n" % (v, ea, opn, kind, fn, dis))

    # neighborhood owner map: every imm/mem value in 0xFF5000-0xFF6100 with its sites
    with open(os.path.join(WORK, "ram-neighborhood.txt"), "w", encoding="utf-8", newline="\n") as h:
        for v in sorted(ramnbr):
            sites = ramnbr[v]
            h.write("%06X  count=%d  %s\n" % (v, len(sites), ",".join("%06x"%s[0] for s in sites[:16])))

    # named objects IDA knows in the neighborhood
    with open(os.path.join(WORK, "ram-names.txt"), "w", encoding="utf-8", newline="\n") as h:
        ea = RAM_CTX_LO
        while ea <= RAM_CTX_HI:
            nm = ida_name.get_name(ea)
            if nm:
                xr = xrefs_to(ea)
                h.write("%06X  %-24s  xrefs=%d  %s\n" % (ea, nm, len(xr),
                        ",".join("%06x"%x[0] for x in xr[:8])))
            ea += 1

    # EP1 copy-loop bound: dump the loop + the index arithmetic precisely
    with open(os.path.join(WORK, "ep1-loop.txt"), "w", encoding="utf-8", newline="\n") as h:
        for a in range(0x055650, 0x0556D0, 1):
            fl = ida_bytes.get_flags(a)
            if ida_bytes.is_code(fl) and ida_bytes.is_head(fl):
                raw = ida_bytes.get_bytes(a, max(1, idc.get_item_size(a))) or b""
                h.write("%06x  %-20s  %s\n" % (a, raw.hex(" "), dline(a)))

    # context around key neighborhood refs to pin buffer layout
    probe_eas = [0x029b9a, 0x0356fe, 0x03aaba, 0x073c32,  # 0xFF5E01/0xFF5E03 refs
                 0x05fa30, 0x06ef34, 0x0745b0,            # 0xFF5406 uses
                 0x047f22, 0x055cb6,                       # 0xFF5006 uses
                 0x0048f0 if False else 0x004867]          # 0xFF5A5E ref
    with open(os.path.join(WORK, "buffer-probe.txt"), "w", encoding="utf-8", newline="\n") as h:
        for ea in probe_eas:
            if WLO <= ea < WHI:
                continue
            h.write("-- probe %06x  (func %s)\n" % (ea, funcname(ea)))
            for line in context(ea, 2, 4):
                h.write(line + "\n")
            h.write("\n")

    # targeted range disassembly for init/ISR/boot/SCI context
    ranges = [
        ("sub_54C44_init", 0x054C44, 0x054CAE),
        ("sub_54CAE_reset", 0x054CAE, 0x054CFA),
        ("sub_54CFA_v238", 0x054CFA, 0x054D50),
        ("nmi_ee50_a", 0x002730, 0x002760),
        ("nmi_ee50_b", 0x0027E8, 0x002810),
        ("sub_20FA_boot", 0x0022A0, 0x0022D0),
        ("sub_446BE_sci", 0x0446B0, 0x0446E0),
    ]
    with open(os.path.join(WORK, "ranges.txt"), "w", encoding="utf-8", newline="\n") as h:
        for name, lo, hi in ranges:
            h.write("\n==== %s %06x-%06x ====\n" % (name, lo, hi))
            ea = lo
            while ea < hi:
                if WLO <= ea < WHI:
                    ea = WHI; continue
                raw = ida_bytes.get_bytes(ea, max(1, idc.get_item_size(ea))) or b""
                h.write("%06x  %-22s %s\n" % (ea, raw.hex(" "), dline(ea)))
                ea = idc.next_head(ea, hi)

    log.append("ram_hits=%d" % len(ram_hits))
    with open(os.path.join(WORK, "log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("; ".join(log) + "\n")

try:
    main()
except Exception:
    os.makedirs(WORK, exist_ok=True)
    with open(os.path.join(WORK, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
