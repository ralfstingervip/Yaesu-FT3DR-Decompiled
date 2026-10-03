r"""Lane I7 - read-only dumper for the FF800F market-gate pass (private DB I7_MAIN).

Request file: env I7_REQ (default ida\out\market-gates\req.txt). Commands:
    fn    <ea>[,<ea>...]     containing function bounds for each ea
    func  <ea>               dump the whole containing function (no item changes)
    xref  <ea>               code/data xrefs to ea
    ctx   <ea> <before> <after>   read-only context window
    imm   <hex>[,<hex>...]   every code head with an imm/mem/displ operand equal to a value
Output: env I7_OUT (default ida\out\market-gates\dump.txt), UTF-8.
Nothing here creates or deletes items.

    python "ida/run_job.py" --script ida\jobs\i7_dump.py --db I7_MAIN --reopen
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

BASE = str(_REPO / "ida/out/market-gates")
REQ = os.environ.get("I7_REQ", os.path.join(BASE, "req.txt"))
OUT = os.environ.get("I7_OUT", os.path.join(BASE, "dump.txt"))
ERR = os.path.join(BASE, "i7_dump_error.txt")


def main():
    import ida_auto, ida_ua, ida_funcs, ida_bytes, idc, idautils
    ida_auto.auto_wait()
    out = []
    w = out.append

    def line(ea):
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, ea)
        if n <= 0:
            return None, 1
        raw = ida_bytes.get_bytes(ea, n).hex(" ")
        dis = idc.generate_disasm_line(ea, 0) or ""
        return "%08X  %-22s %s" % (ea, raw, dis.split(";")[0].strip()), n

    def fname(ea):
        f = ida_funcs.get_func(ea)
        return ("%06X-%06X" % (f.start_ea, f.end_ea)) if f else "-"

    w("# funcs %d" % ida_funcs.get_func_qty())
    for ln in open(REQ, encoding="utf-8").read().splitlines():
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        p = ln.split()
        cmd = p[0]
        try:
            if cmd == "fn":
                for x in p[1].split(","):
                    ea = int(x, 16)
                    w("fn %06X %s code=%d" % (ea, fname(ea), int(ida_bytes.is_code(ida_bytes.get_flags(ea)))))
            elif cmd == "func":
                ea = int(p[1], 16)
                f = ida_funcs.get_func(ea)
                if f is None:
                    w("###### func %06X : no function" % ea)
                    continue
                w("###### func %06X-%06X (req %06X)" % (f.start_ea, f.end_ea, ea))
                w("; xrefs-to: " + " ".join("%06X" % x.frm for x in idautils.XrefsTo(f.start_ea)))
                for ch in idautils.Chunks(f.start_ea):
                    e2 = ch[0]
                    while e2 < ch[1]:
                        if ida_bytes.is_code(ida_bytes.get_flags(e2)):
                            s, n = line(e2)
                            if s:
                                w(s)
                            e2 += n
                        else:
                            sz = ida_bytes.get_item_size(e2) or 1
                            w("%08X  data %s" % (e2, ida_bytes.get_bytes(e2, min(sz, 16)).hex(" ")))
                            e2 += sz
            elif cmd == "xref":
                ea = int(p[1], 16)
                w("###### xref %06X" % ea)
                for x in idautils.XrefsTo(ea):
                    w("  from %06X type %d fn %s" % (x.frm, x.type, fname(x.frm)))
            elif cmd == "ctx":
                ea = int(p[1], 16)
                nb, na = int(p[2]), int(p[3])
                st = ea
                for _k in range(nb):
                    q = idc.prev_head(st)
                    if q == idc.BADADDR or st - q > 10:
                        break
                    st = q
                w("###### ctx %06X [fn %s]" % (ea, fname(ea)))
                cur = st
                for _k in range(nb + na + 1):
                    s, n = line(cur)
                    if s is None:
                        w("%08X  ?? %02X" % (cur, ida_bytes.get_byte(cur)))
                        cur += 1
                        continue
                    w(("=> " if cur == ea else "   ") + s)
                    cur += n
            elif cmd == "imm":
                vals = set(int(x, 16) & 0xFFFFFFFF for x in p[1].split(","))
                w("###### imm %s" % p[1])
                for seg in idautils.Segments():
                    for h in idautils.Heads(seg, idc.get_segm_end(seg)):
                        if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                            continue
                        insn = ida_ua.insn_t()
                        if ida_ua.decode_insn(insn, h) <= 0:
                            continue
                        for i in range(8):
                            op = insn.ops[i]
                            if op.type == ida_ua.o_void:
                                break
                            v = (op.value if op.type in (ida_ua.o_imm, ida_ua.o_displ) else op.addr) & 0xFFFFFFFF
                            if v in vals:
                                s, _n = line(h)
                                w("%s   [fn %s]" % (s, fname(h)))
                                break
        except Exception:
            w("!! error on %s\n%s" % (ln, traceback.format_exc()))
    with open(OUT, "w", encoding="utf-8") as fh:
        fh.write("\n".join(out) + "\n")


try:
    main()
except Exception:
    with open(ERR, "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
import idc
idc.qexit(0)
