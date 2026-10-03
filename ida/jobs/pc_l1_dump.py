r"""Lane 1 (PC software, DATA-jack CAT) generic dumper.

Private DB PC_L1 only. Reads a spec file (env PC_L1_SPEC):
  c <start> <end> <title>     forced-code disassembly
  d <start> <end> <title>     hex dump
  x <addr> <title>            xrefs to addr (also 0xFF.. -> 0xFFFF.. alias)
  f <addr>                    function bounds + callers
Writes env PC_L1_OUT (UTF-8).
"""
from __future__ import annotations
import os, traceback

SPEC = os.environ.get("PC_L1_SPEC", "")
OUT = os.environ.get("PC_L1_OUT", "")


def _run():
    import idc, idautils, ida_bytes, ida_ua, ida_auto, ida_funcs, ida_lines
    lines = []
    P = lines.append

    def force_code(start, end):
        ea = start
        while ea < end:
            f = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(f):
                n = idc.next_head(ea, end)
                if n == idc.BADADDR or n <= ea:
                    break
                ea = n
                continue
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            ln = ida_ua.create_insn(ea)
            ea += ln if ln > 0 else 1

    def dis(start, end, title):
        P("")
        P("======== %s (%06X..%06X) ========" % (title, start, end))
        force_code(start, end)
        ida_auto.auto_wait()
        ea = start
        while ea < end and ea != idc.BADADDR:
            f = ida_bytes.get_flags(ea)
            sz = max(1, idc.get_item_size(ea))
            raw = " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(min(sz, 10)))
            dl = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
            fn = ida_funcs.get_func(ea)
            if fn and fn.start_ea == ea:
                P("---- sub_%X ----" % ea)
            P("%06X %s %-29s %s" % (ea, "C" if ida_bytes.is_code(f) else ".", raw, dl))
            n = idc.next_head(ea, end)
            if n == idc.BADADDR or n <= ea:
                break
            ea = n

    def hexd(start, end, title):
        P("")
        P("======== HEX %s (%06X..%06X) ========" % (title, start, end))
        ea = start
        while ea < end:
            bs = [ida_bytes.get_byte(ea + i) for i in range(min(16, end - ea))]
            P("%06X  %s  %s" % (ea, " ".join("%02X" % b for b in bs),
                               "".join(chr(b) if 32 <= b < 127 else "." for b in bs)))
            ea += 16

    def xr(addr, title):
        cands = [addr]
        if 0xFF0000 <= addr <= 0xFFFFFF:
            cands.append(addr | 0xFF000000)
        P("")
        for a in cands:
            refs = list(idautils.XrefsTo(a, 0))
            P("XREFS %s %08X : %d" % (title, a, len(refs)))
            for x in refs:
                dl = ida_lines.tag_remove(idc.generate_disasm_line(x.frm, 0) or "")
                fn = ida_funcs.get_func(x.frm)
                P("    from %06X (in %s) t%d  %s" % (x.frm, ("sub_%X" % fn.start_ea) if fn else "-", x.type, dl))

    def fin(addr):
        fn = ida_funcs.get_func(addr)
        P("")
        if fn:
            P("FUNC %06X: sub_%X .. %06X" % (addr, fn.start_ea, fn.end_ea))
            for x in idautils.XrefsTo(fn.start_ea, 0):
                P("    caller %06X t%d" % (x.frm, x.type))
        else:
            P("FUNC %06X: none" % addr)

    ida_auto.auto_wait()
    with open(SPEC, "r", encoding="utf-8") as fh:
        for raw in fh:
            raw = raw.strip()
            if not raw or raw.startswith("#"):
                continue
            parts = raw.split(None, 3)
            k = parts[0]
            try:
                if k == "c":
                    dis(int(parts[1], 16), int(parts[2], 16), parts[3] if len(parts) > 3 else "")
                elif k == "d":
                    hexd(int(parts[1], 16), int(parts[2], 16), parts[3] if len(parts) > 3 else "")
                elif k == "x":
                    xr(int(parts[1], 16), " ".join(parts[2:]))
                elif k == "f":
                    fin(int(parts[1], 16))
            except Exception as e:
                P("  [failed %s: %r]" % (raw, e))
    with open(OUT, "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines))


try:
    _run()
except Exception:
    with open((OUT or "pc_l1") + ".trace.txt", "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
