r"""Lane H8 -- per-unit facts for newly reached SUB gap code (read-only on the DB).

Input  ida\out\sub-gap\raw\units.tsv  (kind, owner/entry, how, comma list of heads)
Output ida\out\sub-gap\raw\unit_info.tsv : entry, n_insn, bytes, last mnem, callees, window imms, periph imms, ram imms

    python ida/run_job.py --script ida\jobs\h8_units.py --db H8_SUBGAP --reopen
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

RAW = str(_REPO / "ida/out/sub-gap/raw")


def main():
    import ida_auto, ida_ua
    ida_auto.auto_wait()
    out = open(os.path.join(RAW, "unit_info.tsv"), "w", encoding="utf-8", newline="\n")
    out.write("kind\towner\thow\tn_insn\tbytes\tlast\tcallees\twin_imm\tperiph_imm\tram_imm\tmnems\n")
    for ln in open(os.path.join(RAW, "units.tsv"), encoding="utf-8"):
        kind, owner, how, heads = ln.rstrip("\n").split("\t")
        hs = [int(x, 16) for x in heads.split(",") if x]
        n = 0; nb = 0; last = ""; cal = []; wi = []; pi = []; ri = []; mn = {}
        for ea in hs:
            insn = ida_ua.insn_t(); l = ida_ua.decode_insn(insn, ea)
            if l <= 0:
                continue
            n += 1; nb += l
            m = insn.get_canon_mnem(); last = m; mn[m] = mn.get(m, 0) + 1
            for op in insn.ops:
                if op.type == 0:
                    break
                if op.type == ida_ua.o_near and m in ("bsr", "jsr"):
                    cal.append(op.addr)
                if op.type == ida_ua.o_imm:
                    v = op.value & 0xFFFFFFFF
                    if 0xFFC00000 <= v:
                        wi.append(v)
                    elif 0x00080000 <= v < 0x00100000:
                        pi.append(v)
                    elif 0x00000400 <= v < 0x00080000:
                        ri.append(v)
        top = ",".join("%s:%d" % kv for kv in sorted(mn.items(), key=lambda kv: -kv[1])[:6])
        out.write("%s\t%s\t%s\t%d\t%d\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
            kind, owner, how, n, nb, last,
            ",".join("%08X" % x for x in sorted(set(cal))), ",".join("%08X" % x for x in sorted(set(wi))),
            ",".join("%08X" % x for x in sorted(set(pi))), ",".join("%05X" % x for x in sorted(set(ri))), top))
    out.close()


try:
    main()
except Exception:
    with open(os.path.join(RAW, "h8_units_err.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
