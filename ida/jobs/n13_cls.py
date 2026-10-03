# -*- coding: utf-8 -*-
"""Lane N13: classify raw byte candidates for 0xFFFF4E against IDA heads (read-only, no edits).
Env N13_REQ = tsv (hexaddr<TAB>kind), N13_OUT = output tsv."""
import os, traceback
import ida_auto, idc, ida_bytes, ida_funcs
REQ = os.environ.get("N13_REQ", ""); OUT = os.environ.get("N13_OUT", "")
def main():
    ida_auto.auto_wait()
    out = ["addr\tkind\tclass\thead\tsize\tfunc\tdisasm"]
    for raw in open(REQ, encoding="utf-8"):
        p = raw.strip().split("\t")
        if len(p) < 2:
            continue
        ea = int(p[0], 16)
        fl = ida_bytes.get_flags(ea)
        head = idc.get_item_head(ea)
        hfl = ida_bytes.get_flags(head)
        if ida_bytes.is_code(hfl):
            cls = "code_head" if head == ea else "inside_insn"
        elif ida_bytes.is_unknown(hfl):
            cls = "unknown"
        else:
            cls = "data"
        f = ida_funcs.get_func(head)
        fn = ida_funcs.get_func_name(f.start_ea) if f else "-"
        out.append("%06X\t%s\t%s\t%06X\t%d\t%s\t%s" % (ea, p[1], cls, head, idc.get_item_size(head), fn,
                   (idc.generate_disasm_line(head, 0) or "").replace("\t", " ")))
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(out) + "\n")
try:
    main()
except Exception:
    with open(OUT + ".tb.txt", "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    idc.qexit(0)
