r"""Lane H14: classify every 'mov.l #8E46h,rN' site. Read-only on a private DB copy.
Reads site list from H14_SITES, writes a TSV to H14_ROUT.
For each site: in-function? is-code? first use of rN within 8 insns (offset + kind).
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
BASE = str(_REPO / "ida/out/sub-link")
SITES = os.environ.get("H14_SITES", os.path.join(BASE, "readers_sites.txt"))
OUT = os.environ.get("H14_ROUT", os.path.join(BASE, "readers_class.tsv"))
ERR = os.path.join(BASE, "h14_readers_error.txt")


def main():
    import ida_auto, ida_ua, ida_funcs, ida_bytes, idc
    ida_auto.auto_wait()
    rows = ["addr\trd\tis_code\tin_func\tfunc\tfirst_use_off\tuse_kind\tuse_disasm"]
    undec = 0
    decoded = 0
    reader = 0
    for ln in open(SITES, encoding="utf-8"):
        ln = ln.strip()
        if not ln:
            continue
        a_s, rd_s = ln.split()
        ea = int(a_s, 16)
        rd = int(rd_s)
        is_code = 1 if ida_bytes.is_code(ida_bytes.get_flags(ea)) else 0
        f = ida_funcs.get_func(ea)
        in_func = 1 if f else 0
        fn = ("%08X" % f.start_ea) if f else "-"
        use_off = ""
        use_kind = ""
        use_dis = ""
        # try to find first use of rd within 8 insns from ea+6 (walk by decoding fresh, no DB change)
        cur = ea + 6
        for _k in range(8):
            insn = ida_ua.insn_t()
            nlen = ida_ua.decode_insn(insn, cur)
            if nlen <= 0:
                break
            # does any operand reference register rd (as base of displ/phrase, or reg)?
            found = None
            for i in range(6):
                op = insn.ops[i]
                if op.type == ida_ua.o_void:
                    break
                if op.type in (ida_ua.o_displ, ida_ua.o_phrase) and op.reg == rd:
                    found = ("displ+0x%X" % (op.value & 0xFFFFFFFF))
                    break
                if op.type == ida_ua.o_reg and op.reg == rd:
                    found = "reg"
                    break
            if found:
                use_off = "%d" % (cur - ea)
                use_kind = found
                use_dis = (idc.generate_disasm_line(cur, 0) or "").split(";")[0].strip()
                break
            cur += nlen
        rows.append("%08X\t%d\t%d\t%d\t%s\t%s\t%s\t%s" % (ea, rd, is_code, in_func, fn, use_off, use_kind, use_dis))
        if not is_code:
            undec += 1
        else:
            decoded += 1
        if use_kind.startswith("displ"):
            reader += 1
    rows.insert(0, "# total=%d decoded(is_code)=%d undecoded=%d displ_readers=%d" % (len(rows) - 1, decoded, undec, reader))
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)
