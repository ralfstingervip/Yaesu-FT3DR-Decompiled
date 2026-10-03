r"""Lane H12 - generic dumper (copy of g3_dump.py) (read-only analysis of a private DB copy).

Reads a request file named by env G3_REQ (default ida\out\value-tables\req.txt).
Each non-comment line:
    func  <ea>              dump whole function containing ea (create if missing)
    lin   <ea> <count>      linear decode <count> instructions from ea (make code)
    imm   <hexval>[,<hexval>...]   list every code head with an o_imm/o_mem/o_displ
                            value equal to one of the values (+ function name)
    xref  <ea>              list code/data xrefs to ea
Output: G3_OUT (default ida\out\value-tables\dump.txt), UTF-8.

    python "ida/run_job.py" --script ida\jobs\g3_dump.py --db G3_SUB --reopen
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os
import traceback

BASE = str(_REPO / "ida/out/frame-pack")
REQ = os.environ.get("H12_REQ", os.path.join(BASE, "req.txt"))
OUT = os.environ.get("H12_OUT", os.path.join(BASE, "dump.txt"))
ERR = os.path.join(BASE, "h12_dump_error.txt")


def main():
    import ida_auto, ida_ua, ida_funcs, ida_bytes, ida_xref, idc, idautils
    ida_auto.auto_wait()
    out = []
    w = out.append

    def ops(insn):
        r = []
        for i in range(8):
            op = insn.ops[i]
            if op.type == ida_ua.o_void:
                break
            if op.type == ida_ua.o_imm:
                r.append("#0x%X" % (op.value & 0xFFFFFFFF))
            elif op.type == ida_ua.o_displ:
                r.append("d(R%d,+0x%X)" % (op.reg, op.value & 0xFFFFFFFF))
            elif op.type in (ida_ua.o_mem, ida_ua.o_near, ida_ua.o_far):
                r.append("a=0x%X" % (op.addr & 0xFFFFFFFF))
            elif op.type == ida_ua.o_reg:
                r.append("R%d" % op.reg)
            else:
                r.append("t%d" % op.type)
        return " ".join(r)

    def line(ea):
        insn = ida_ua.insn_t()
        n = ida_ua.decode_insn(insn, ea)
        if n <= 0:
            return None, 1
        raw = ida_bytes.get_bytes(ea, n).hex(" ")
        dis = idc.generate_disasm_line(ea, 0) or ""
        return "%08X  %-22s %-44s ; %s" % (ea, raw, dis.split(";")[0].strip(), ops(insn)), n

    lines = open(REQ, encoding="utf-8").read().splitlines()
    for ln in lines:
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        p = ln.split()
        cmd = p[0]
        try:
            if cmd == "func":
                ea = int(p[1], 16)
                f = ida_funcs.get_func(ea)
                if f is None:
                    ida_ua.create_insn(ea)
                    ida_funcs.add_func(ea)
                    ida_auto.auto_wait()
                    f = ida_funcs.get_func(ea)
                if f is None:
                    w("###### func %08X : no function" % ea)
                    continue
                w("###### func %08X-%08X (req %08X)" % (f.start_ea, f.end_ea, ea))
                callers = sorted(set(x.frm for x in idautils.XrefsTo(f.start_ea) if True))
                w("; xrefs-to: " + " ".join("%08X" % c for c in callers[:40]))
                for ch in idautils.Chunks(f.start_ea):
                    ea2 = ch[0]
                    while ea2 < ch[1]:
                        if ida_bytes.is_code(ida_bytes.get_flags(ea2)):
                            s, n = line(ea2)
                            if s:
                                w(s)
                            ea2 += n
                        else:
                            sz = ida_bytes.get_item_size(ea2) or 1
                            w("%08X  data %s" % (ea2, ida_bytes.get_bytes(ea2, min(sz, 16)).hex(" ")))
                            ea2 += sz
            elif cmd == "lin":
                ea = int(p[1], 16)
                cnt = int(p[2])
                w("###### lin %08X x%d" % (ea, cnt))
                for _ in range(cnt):
                    if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                        ida_bytes.del_items(ea, 0, 2)
                        ida_ua.create_insn(ea)
                    s, n = line(ea)
                    if s is None:
                        w("%08X  ?? %02X" % (ea, ida_bytes.get_byte(ea)))
                        ea += 1
                        continue
                    w(s)
                    ea += n
            elif cmd == "range":
                ea = int(p[1], 16)
                end = int(p[2], 16)
                w("###### range %08X-%08X" % (ea, end))
                while ea < end:
                    if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
                        ida_bytes.del_items(ea, 0, 2)
                        ida_ua.create_insn(ea)
                    s, n = line(ea)
                    if s is None:
                        w("%08X  ?? %02X" % (ea, ida_bytes.get_byte(ea)))
                        ea += 1
                        continue
                    w(s)
                    ea += n
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
                        hit = False
                        for i in range(8):
                            op = insn.ops[i]
                            if op.type == ida_ua.o_void:
                                break
                            v = (op.value if op.type in (ida_ua.o_imm, ida_ua.o_displ) else op.addr) & 0xFFFFFFFF
                            if v in vals:
                                hit = True
                        if hit:
                            f = ida_funcs.get_func(h)
                            s, _n = line(h)
                            w("%s   [fn %s]" % (s, ("%08X" % f.start_ea) if f else "-"))
            elif cmd == "based":
                # every o_displ/o_phrase access whose base reg was loaded with
                # mov.l #<base>,Rn within the previous 4 heads (same function)
                base = int(p[1], 16) & 0xFFFFFFFF
                w("###### based %08X" % base)
                for seg in idautils.Segments():
                    for h in idautils.Heads(seg, idc.get_segm_end(seg)):
                        if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                            continue
                        insn = ida_ua.insn_t()
                        if ida_ua.decode_insn(insn, h) <= 0:
                            continue
                        for i in range(4):
                            op = insn.ops[i]
                            if op.type not in (ida_ua.o_displ, ida_ua.o_phrase):
                                continue
                            reg = op.reg
                            disp = (op.value & 0xFFFFFFFF) if op.type == ida_ua.o_displ else 0
                            q = h
                            found = False
                            for _k in range(4):
                                q = idc.prev_head(q)
                                if q == idc.BADADDR:
                                    break
                                pi = ida_ua.insn_t()
                                if ida_ua.decode_insn(pi, q) <= 0:
                                    break
                                o0, o1 = pi.ops[0], pi.ops[1]
                                if o1.type == ida_ua.o_reg and o1.reg == reg:
                                    if o0.type == ida_ua.o_imm and (o0.value & 0xFFFFFFFF) == base and pi.get_canon_mnem().startswith("mov"):
                                        found = True
                                    break
                            if found:
                                f = ida_funcs.get_func(h)
                                s, _n = line(h)
                                w("disp=0x%X  %s   [fn %s]" % (disp, s, ("%08X" % f.start_ea) if f else "-"))
            elif cmd == "displ":
                # displ <hexvals> <lo> <hi> : every code head with an o_displ whose
                # displacement (op.addr or op.value) is in the set, within [lo,hi)
                vals = set(int(x, 16) for x in p[1].split(","))
                lo, hi = int(p[2], 16), int(p[3], 16)
                w("###### displ %s %X-%X" % (p[1], lo, hi))
                for seg in idautils.Segments():
                    for h in idautils.Heads(max(seg, lo), min(idc.get_segm_end(seg), hi)):
                        if not ida_bytes.is_code(ida_bytes.get_flags(h)):
                            continue
                        insn = ida_ua.insn_t()
                        if ida_ua.decode_insn(insn, h) <= 0:
                            continue
                        for i in range(8):
                            op = insn.ops[i]
                            if op.type == ida_ua.o_void:
                                break
                            if op.type == ida_ua.o_displ and ((op.addr & 0xFFFFFFFF) in vals or (op.value & 0xFFFFFFFF) in vals):
                                f = ida_funcs.get_func(h)
                                s, _n = line(h)
                                w("%s   [fn %s]" % (s, ("%08X" % f.start_ea) if f else "-"))
                                break
            elif cmd == "ctx":
                # ctx <ea> <before> <after> : read-only context window (no item changes)
                ea = int(p[1], 16)
                nb, na = int(p[2]), int(p[3])
                st = ea
                for _k in range(nb):
                    q = idc.prev_head(st)
                    if q == idc.BADADDR or st - q > 10:
                        break
                    st = q
                f = ida_funcs.get_func(ea)
                w("###### ctx %08X [fn %s]" % (ea, ("%08X" % f.start_ea) if f else "-"))
                cur = st
                for _k in range(nb + na + 1):
                    s, n = line(cur)
                    if s is None:
                        w("%08X  ?? %02X" % (cur, ida_bytes.get_byte(cur)))
                        cur += 1
                        continue
                    w(("=> " if cur == ea else "   ") + s)
                    cur += n
            elif cmd == "xref":
                ea = int(p[1], 16)
                w("###### xref %08X" % ea)
                for x in idautils.XrefsTo(ea):
                    f = ida_funcs.get_func(x.frm)
                    w("  from %08X type %d fn %s" % (x.frm, x.type, ("%08X" % f.start_ea) if f else "-"))
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
