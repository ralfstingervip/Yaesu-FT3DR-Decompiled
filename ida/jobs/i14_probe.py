# -*- coding: utf-8 -*-
r"""Lane I14 probe (read-only on the DB): report the seed state for the merged I-wave instructions,
the 16 lead-in sites, the I9 repair points and the exit table. Makes no DB edit.
Writes <scratchpad>\i14\i14_probe_*.tsv. Ends with qexit(0)."""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
SCR = "local-temp"
ROOT = str(_REPO)
OUT2 = os.path.join(ROOT, "ida", "out", "main-final2")


def main():
    import ida_auto, ida_bytes, ida_funcs, ida_ua, idautils, idc, ida_xref
    pass  # no auto_wait: probe makes no edit

    def item(ea):
        fl = ida_bytes.get_flags(ea)
        h = ida_bytes.get_item_head(ea)
        hf = ida_bytes.get_flags(h)
        kind = "code" if ida_bytes.is_code(hf) else ("data" if ida_bytes.is_data(hf) else ("tail" if ida_bytes.is_tail(fl) else "unk"))
        f = ida_funcs.get_func(ea)
        return h, kind, ida_bytes.get_item_size(h), ("%06X" % f.start_ea) if f else "-"

    def xr(ea):
        c = ["%06X:%d" % (x.frm, x.type) for x in idautils.XrefsTo(ea, 0)]
        return ",".join(c) if c else "-"

    # merged instructions
    rows = []
    with open(os.path.join(OUT2, "merged-insns.tsv"), encoding="utf-8") as h:
        h.readline()
        for ln in h:
            c = ln.rstrip("\n").split("\t")
            a = int(c[0], 16); n = int(c[1])
            insn = ida_ua.insn_t(); L = ida_ua.decode_insn(insn, a)
            hd, kind, sz, fn = item(a)
            rows.append("%06X\t%d\t%d\t%s\t%06X\t%d\t%s\t%s\t%s" % (a, n, L, kind, hd, sz, fn, c[3], xr(a)))
    with open(os.path.join(SCR, "i14_probe_insns.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("addr\toracle_len\tida_decode_len\titem_kind\thead\thead_size\tfunc\tlanes\txrefs_to\n" + "\n".join(rows) + "\n")

    # lead-in sites and repair points: dump items over a small window
    pts = []
    with open(os.path.join(ROOT, "ida", "out", "main-final", "proven-not-dbcode.tsv"), encoding="utf-8") as h:
        h.readline()
        for ln in h:
            pts.append(int(ln.split("\t")[0], 16))
    pts += [0x000700, 0x000760, 0x000A80, 0x0296E8, 0x029712, 0x029730, 0x029760, 0x05E33C, 0x05E37A, 0x07327C,
            0x019A9E, 0x0191A0, 0x003270, 0x034CCC, 0x01A084, 0x015224]
    out = []
    for p in pts:
        out.append("== %06X" % p)
        for ea in range(p - 6, p + 10, 2):
            hd, kind, sz, fn = item(ea)
            insn = ida_ua.insn_t(); L = ida_ua.decode_insn(insn, ea)
            out.append("%06X head=%06X %s sz=%d func=%s declen=%d dis=%s xrefs=%s" % (
                ea, hd, kind, sz, fn, L, idc.generate_disasm_line(ea, 0) if hd == ea else "", xr(ea)))
    with open(os.path.join(SCR, "i14_probe_sites.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(out) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(SCR, "i14_probe_tb.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
