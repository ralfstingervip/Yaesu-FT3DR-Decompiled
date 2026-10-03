r"""BOOT-IPC job: boot path, vectors, flash-control refs, and IPC serial refs.

Dispatches on processor. Works on a --copy-from seeded DB (MAIN.i64 or SUB.i64).
Writes tables under ida/out/boot-ipc/ , prefixed by YAESU_JOB.

Idempotent: safe to --reopen.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_ida, ida_bytes, ida_segment, ida_funcs, ida_name, ida_ua, ida_xref
import idautils, idc, ida_idaapi
BADADDR = ida_idaapi.BADADDR

OUT = str(_REPO / "ida/out/boot-ipc")
os.makedirs(OUT, exist_ok=True)
JOB = os.environ.get("YAESU_JOB", "job")

def w(fn, text):
    with open(os.path.join(OUT, fn), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)

def dis(ea):
    return idc.generate_disasm_line(ea, 0) or ""

def follow(ea, n):
    """Linear disassemble n instructions from ea (creating code as needed)."""
    lines = []
    cur = ea
    for _ in range(n):
        if not ida_bytes.is_code(ida_bytes.get_flags(cur)):
            ida_ua.create_insn(cur)
        insn = ida_ua.insn_t()
        ln = ida_ua.decode_insn(insn, cur)
        if ln <= 0:
            lines.append("%08X  (undecodable %02X)" % (cur, ida_bytes.get_byte(cur)))
            cur += 1
            continue
        lines.append("%08X  %s" % (cur, dis(cur)))
        cur += insn.size
    return "\n".join(lines)

def op_addrs(insn):
    """Yield resolved addresses/immediates for each operand."""
    for op in insn.ops:
        if op.type == 0:  # o_void
            break
        # o_imm=5, o_mem=2, o_displ=4, o_far=6, o_near=7
        if op.type == ida_ua.o_imm:
            yield ("imm", op.value)
        elif op.type in (ida_ua.o_mem, ida_ua.o_far, ida_ua.o_near):
            yield ("mem", op.addr)
        elif op.type == ida_ua.o_displ:
            yield ("displ", op.addr)

# ranges of interest per proc, filled below
def classify(v, ranges):
    v24 = v & 0xFFFFFF  # H8S @aa:8/@aa:16 sign-extend to 0xFFFFFFxx; normalise
    for name, lo, hi in ranges:
        if lo <= v <= hi or lo <= v24 <= hi:
            return name
    return None

def scan_ops(ranges):
    """Walk every code head in every segment, classify operand addresses."""
    rows = []
    for seg_ea in idautils.Segments():
        s = ida_segment.getseg(seg_ea)
        if s is None:
            continue
        ea = s.start_ea
        end = s.end_ea
        while ea < end:
            fl = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl):
                insn = ida_ua.insn_t()
                ln = ida_ua.decode_insn(insn, ea)
                if ln > 0:
                    for kind, v in op_addrs(insn):
                        cat = classify(v, ranges)
                        if cat:
                            fn = ida_funcs.get_func(ea)
                            fname = ida_funcs.get_func_name(fn.start_ea) if fn else ""
                            rows.append((ea, cat, kind, v, fname, dis(ea)))
                    ea += insn.size if ln > 0 else 1
                    continue
            ea = ida_bytes.next_head(ea, end)
            if ea == BADADDR:
                break
    return rows

def dump_vectors_targets(rows_ea, count, is_le):
    """rows_ea: table start; returns list of (idx, slot_ea, target, first_disasm)."""
    out = []
    for i in range(count):
        slot = rows_ea + i * 4
        val = ida_bytes.get_dword(slot)
        out.append((i, slot, val))
    return out

try:
    ida_auto.auto_wait()
    proc = ida_ida.inf_get_procname()
    minea = ida_ida.inf_get_min_ea()
    maxea = ida_ida.inf_get_max_ea()
    hdr = "job %s proc %s min %08X max %08X funcs %d\n" % (
        JOB, proc, minea, maxea, sum(1 for _ in idautils.Functions()))

    if proc.startswith("h8") or JOB.endswith("MAIN") or "MAIN" in JOB:
        # H8S MAIN
        ranges = [
            ("REG_PAGE", 0xFFFE00, 0xFFFFFF),   # on-chip register page
            ("RAM", 0xFF6000, 0xFFFBFF),        # candidate on-chip RAM
        ]
        reset = 0x2092
        report = [hdr, "== MAIN reset path (0x2092, 160 insns) ==", follow(reset, 160)]
        report.append("\n== MAIN nmi (0x267C, 40 insns) ==")
        report.append(follow(0x267C, 40))
        w(JOB + "_boot.txt", "\n".join(report))
        # operand scan for register-page accesses
        rows = scan_ops(ranges)
        lines = ["ea\tcat\tkind\ttarget\tfunc\tdisasm"]
        for ea, cat, kind, v, fn, d in rows:
            lines.append("%08X\t%s\t%s\t%06X\t%s\t%s" % (ea, cat, kind, v, fn, d))
        w(JOB + "_regops.tsv", "\n".join(lines) + "\n")
        w(JOB + "_regops_summary.txt",
          "rows %d\n" % len(rows) +
          "distinct targets:\n" +
          "\n".join("  %06X x%d" % (t, sum(1 for r in rows if r[3] == t))
                    for t in sorted({r[3] for r in rows})))

    else:
        # RX SUB
        SB = 0xFFC00000
        ranges = [
            ("SYSTEM", 0x00080000, 0x000800FF),
            ("DMAC", 0x00082000, 0x000827FF),
            ("ICU", 0x00087000, 0x000877FF),
            ("CMT", 0x00088000, 0x000880FF),
            ("CRC", 0x00088280, 0x0008829F),
            ("S12AD", 0x00089000, 0x000897FF),
            ("SCI", 0x0008A000, 0x0008B4FF),
            ("PORT", 0x0008C000, 0x0008C1FF),
            ("FLASH_SYS", 0x0008C280, 0x0008C2FF),   # FWEPROR
            ("USB0", 0x000A0000, 0x000A03FF),
            ("RSPI", 0x000D0100, 0x000D02FF),
            ("DATAFLASH", 0x00100000, 0x00107FFF),
            ("FCU_RAM", 0x007F8000, 0x007FBFFF),
            ("FLASH_FCU", 0x007FE000, 0x007FE0FF),
        ]
        report = [hdr]
        report.append("== SUB reset path (0xFFC00000, 40 insns) ==")
        report.append(follow(SB, 40))
        report.append("\n== sub_FFF45DBC (first call from reset, 80 insns) ==")
        report.append(follow(0xFFF45DBC, 80))
        # the 17 real ISRs
        isrs = [44,58,59,62,63,80,81,110,111,123,126,128,129,134,135,136,210]
        INTB = 0xFFED8A70
        report.append("\n== SUB real ISR handlers ==")
        for v in isrs:
            tgt = ida_bytes.get_dword(INTB + v * 4)
            report.append("\n-- vec %d -> %08X --" % (v, tgt))
            report.append(follow(tgt, 40))
        w(JOB + "_boot.txt", "\n".join(report))
        rows = scan_ops(ranges)
        lines = ["ea\tcat\tkind\ttarget\tfunc\tdisasm"]
        for ea, cat, kind, v, fn, d in rows:
            lines.append("%08X\t%s\t%s\t%08X\t%s\t%s" % (ea, cat, kind, v, fn, d))
        w(JOB + "_regops.tsv", "\n".join(lines) + "\n")
        # summary by category
        from collections import Counter
        catc = Counter(r[1] for r in rows)
        w(JOB + "_regops_summary.txt",
          "rows %d\n" % len(rows) +
          "by category:\n" + "\n".join("  %-12s %d" % (k, v) for k, v in catc.most_common()) +
          "\n\nflash/usb detail:\n" +
          "\n".join("%08X %-10s %s %08X  %s" % (ea, cat, kind, v, d)
                    for ea, cat, kind, v, fn, d in rows
                    if cat in ("FLASH_FCU", "FLASH_SYS", "FCU_RAM", "USB0", "DATAFLASH")))
    idc.qexit(0)
except Exception:
    w(JOB + "_TRACEBACK.txt", traceback.format_exc())
    idc.qexit(1)
