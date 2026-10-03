r"""Lane K2 read-only operand scanner. Env K2_REQ = JSON {"out": path, "addrs": [ea24,...],
"lo": ea, "hi": ea}. Walks every code head in [lo,hi) and reports each instruction having an
operand whose addr or value (masked to 24 bits) is in addrs, or within addrs+0..3 when the
operand is a long access. Output TSV: target, insn_ea, func, rw-guess, disasm.
"""
from __future__ import annotations
import json, os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, idautils, ida_lines


def main():
    req = json.load(open(os.environ["K2_REQ"], encoding="utf-8"))
    ida_auto.auto_wait()
    targets = set(a & 0xFFFFFF for a in req["addrs"])
    span = req.get("span", 1)
    lo, hi = req.get("lo", 0), req.get("hi", 0x80000)
    rows = ["target\tea\tfunc\tslot\tdisasm"]
    ea = lo
    insn = ida_ua.insn_t()
    while ea < hi and ea != idc.BADADDR:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl) and ida_ua.decode_insn(insn, ea) > 0:
            for i in range(6):
                op = insn.ops[i]
                if op.type == 0:
                    break
                for v in (op.addr, op.value):
                    v &= 0xFFFFFF
                    for d in range(span):
                        if (v + d) in targets:
                            fn = ida_funcs.get_func(ea)
                            rows.append("%06X\t%06X\t%s\t%d\t%s" % (v + d, ea,
                                        ida_funcs.get_func_name(fn.start_ea) if fn else "-", i,
                                        ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")))
            ea = ida_bytes.next_head(ea, hi)
        else:
            ea = ida_bytes.next_head(ea, hi)
    with open(req["out"], "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    with open(os.environ.get("K2_REQ", "k2") + ".err.txt", "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)
