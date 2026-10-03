r"""Lane L11 operand scanner. Finds every instruction in 0..0x80000 whose any
operand references one of a target set of RAM cells (H8S abs16 sign-extends to
0xFFFFxxxx; we match on the low 24 bits == target low 24 bits, and also raw
op.value / op.addr). Driven by env L11_TARGETS = comma-separated hex addresses
(either 0xFFxxxx or 0xFFFFxxxx form) and L11_OUT = output path. Read-only.
"""
from __future__ import annotations
import os, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, idc, ida_lines, ida_name, idautils


def norm(a):
    # normalize to 24-bit MAIN space
    return a & 0xFFFFFF


def fname(ea):
    fn = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(fn.start_ea) if fn else "-"


def line(ea):
    return ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")


def main():
    ida_auto.auto_wait()
    targets = set()
    for tok in os.environ["L11_TARGETS"].split(","):
        tok = tok.strip()
        if not tok:
            continue
        v = int(tok, 16)
        targets.add(norm(v))
    out = os.environ["L11_OUT"]
    hits = []
    for ea in idautils.Heads(0, 0x80000):
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            continue
        insn = ida_ua.insn_t()
        if ida_ua.decode_insn(insn, ea) == 0:
            continue
        matched = None
        for op in insn.ops:
            if op.type == ida_ua.o_void:
                break
            cand = set()
            cand.add(norm(op.addr))
            cand.add(norm(op.value))
            # displacement form keeps scaled displ in op.value sometimes; also raw addr
            for c in cand:
                if c in targets:
                    matched = norm(op.addr) if norm(op.addr) in targets else c
                    break
            if matched is not None:
                break
        if matched is not None:
            raw = " ".join("%02x" % b for b in (ida_bytes.get_bytes(ea, max(1, insn.size)) or b""))
            hits.append("%06X  tgt=%06X  %-30s | %-44s {%s}" % (ea, matched, raw, line(ea), fname(ea)))
    with open(out, "w", encoding="utf-8", newline="\n") as f:
        f.write("targets: %s\n" % ",".join("%06X" % t for t in sorted(targets)))
        f.write("\n".join(hits) + "\n")
        f.write("\n# %d hits\n" % len(hits))


try:
    main()
except Exception:
    with open(os.environ.get("L11_OUT", "l11scan") + ".err.txt", "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)
