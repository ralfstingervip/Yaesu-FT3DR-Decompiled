r"""Lane H1 -- recount checks on the private DB H1_RECOUNT (seeded from G1_H8S, processor h8sxa).

Phase 1 (read-only): processor name, is_code byte total and odd-head census over MAIN content
  0x000000-0x07B753, and the h8sxa disassembly at the F1 rows / true entries / sub_C448.
Phase 2 (edits, this private DB only): apply ida\out\recount\work\apply.json --
  undefine every odd-aligned code head, create the true even instruction where H1 found one,
  turn the junk / text spans of the H1 correction tables into data, delete the junk functions.
  Auto-analysis is disabled during the edits so IDA does not flow into new bytes.
Phase 3 (read-only): recount is_code and odd heads, dump items to ida\out\recount\work\items_h1.tsv.
Outputs: ida\out\recount\work\h1_ida.txt, items_h1.tsv; traceback to h1_ida.err.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, json, traceback
import ida_auto, ida_bytes, ida_ua, ida_funcs, ida_ida, ida_idp, idc, idautils, ida_lines

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "recount", "work")
os.makedirs(OUT, exist_ok=True)
LO, HI = 0x000000, 0x07B754
L = []


def log(s):
    L.append(s)


def census(tag):
    tot = 0; odd = 0; oddb = 0; heads = 0
    ea = LO
    if not ida_bytes.is_head(ida_bytes.get_flags(ea)):
        ea = ida_bytes.next_head(ea, HI)
    while ea != idc.BADADDR and ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz = ida_bytes.get_item_size(ea)
            tot += sz; heads += 1
            if ea & 1:
                odd += 1; oddb += sz
        ea = ida_bytes.next_head(ea, HI)
    nf = sum(1 for _ in idautils.Functions(LO, HI))
    log("%s: is_code %d B in %d heads; odd heads %d (%d B); functions %d" % (tag, tot, heads, odd, oddb, nf))
    return tot


def dis(ea, n=4):
    out = []
    insn = ida_ua.insn_t()
    for _ in range(n):
        sz = ida_ua.decode_insn(insn, ea)
        if sz <= 0:
            out.append("%06X: <undecodable> %s" % (ea, ida_bytes.get_bytes(ea, 2).hex()))
            break
        out.append("%06X: %-18s %s" % (ea, ida_bytes.get_bytes(ea, sz).hex(" "), idc.generate_disasm_line(ea, ida_lines.GENDSM_FORCE_CODE) if ida_bytes.is_code(ida_bytes.get_flags(ea)) else ida_lines.tag_remove(ida_ua.print_insn_mnem(ea) or "")))
        ea += sz
    return out


def main():
    ida_auto.auto_wait()
    log("processor: %s" % ida_idp.get_idp_name())
    log("procname (inf): %s" % ida_ida.inf_get_procname())
    census("phase1 (G1_H8S state)")
    plan = json.load(open(os.path.join(OUT, "apply.json"), encoding="utf-8"))
    insn = ida_ua.insn_t()
    log("-- h8sxa decode at check addresses (decode_insn on raw bytes, independent of item state)")
    for ea in plan["check"]:
        for x in range(ea, ea + 16):
            pass
        cur = ea
        for _ in range(3):
            sz = ida_ua.decode_insn(insn, cur)
            if sz <= 0:
                log("  %06X: <size 0> %s" % (cur, ida_bytes.get_bytes(cur, 4).hex(" ")))
                break
            ops = ida_ua.print_insn_mnem(cur)
            log("  %06X: %-24s %s" % (cur, ida_bytes.get_bytes(cur, sz).hex(" "), ops))
            cur += sz
        f = ida_funcs.get_func(ea)
        log("     func at %06X: %s" % (ea, ("%06X-%06X" % (f.start_ea, f.end_ea)) if f else "-"))

    # ---- phase 2: edits (private DB only)
    ida_auto.enable_auto(False)
    nf = 0
    for s in plan["del_funcs"]:
        if ida_funcs.get_func(s) and ida_funcs.get_func(s).start_ea == s:
            nf += 1 if ida_funcs.del_func(s) else 0
    log("deleted functions: %d of %d" % (nf, len(plan["del_funcs"])))
    nu = 0
    for a, n in plan["undef_odd"]:
        if ida_bytes.is_code(ida_bytes.get_flags(a)) and ida_bytes.is_head(ida_bytes.get_flags(a)):
            nu += 1 if ida_bytes.del_items(a, ida_bytes.DELIT_SIMPLE, n) else 0
    log("odd heads undefined: %d of %d" % (nu, len(plan["undef_odd"])))
    nm = 0; skip = 0
    for ea in plan["make_insn"]:
        sz = ida_ua.decode_insn(insn, ea)
        if sz <= 0:
            skip += 1; continue
        ok = True
        for x in range(ea, ea + sz):
            h = ida_bytes.get_item_head(x)
            fl = ida_bytes.get_flags(h)
            if ida_bytes.is_code(fl) and not (h & 1):
                ok = False
        if not ok:
            skip += 1; continue
        ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, sz)
        nm += 1 if ida_ua.create_insn(ea) == sz else 0
    log("true even instructions created: %d of %d (skipped %d: overlap an existing even head or undecodable)" % (nm, len(plan["make_insn"]), skip))
    nd = 0
    for s, e in plan["data_spans"]:
        ida_bytes.del_items(s, ida_bytes.DELIT_SIMPLE, e - s)
        for x in range(s, e):
            ida_bytes.create_byte(x, 1)
        nd += e - s
    log("data spans made data: %d B in %d spans" % (nd, len(plan["data_spans"])))
    census("phase3 (after H1 edits)")
    with open(os.path.join(OUT, "items_h1.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("ea\tsize\tkind\n")
        ea = LO
        if not ida_bytes.is_head(ida_bytes.get_flags(ea)):
            ea = ida_bytes.next_head(ea, HI)
        while ea != idc.BADADDR and ea < HI:
            fl = ida_bytes.get_flags(ea)
            k = "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else "unk")
            fh.write("%06X\t%d\t%s\n" % (ea, ida_bytes.get_item_size(ea), k))
            ea = ida_bytes.next_head(ea, HI)


try:
    main()
except Exception:
    with open(os.path.join(OUT, "h1_ida.err"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
with open(os.path.join(OUT, "h1_ida.txt"), "w", encoding="utf-8", newline="\n") as fh:
    fh.write("\n".join(L) + "\n")
idc.qexit(0)
