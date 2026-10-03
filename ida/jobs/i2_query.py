r"""Lane I2 -- spot dump (read-only): for each address in env I2_ADDRS (comma list, hex),
the DB items in [a-0x14, a+0x18) with disasm and code/data xrefs-to, plus a linear decode
from a.  Output ida\out\sub-final\raw\query_<I2_TAG>.txt

    python ida/run_job.py --script ida\jobs\i2_query.py --db SUB_FINAL --reopen --env I2_TAG=x --env I2_ADDRS=FFEDEC76
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
TAG = os.environ.get("I2_TAG", "q")
OUT = os.path.join(ROOT, r"ida\out\sub-final\raw", "query_%s.txt" % TAG)


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, idautils, idc
    ida_auto.auto_wait()
    addrs = [int(x, 16) for x in os.environ.get("I2_ADDRS", "").split(",") if x.strip()]
    with open(OUT, "w", encoding="utf-8", newline="\n") as h:
        for a in addrs:
            h.write("==== %08X\n" % a)
            ea = a - 0x14
            hd = ida_bytes.get_item_head(ea)
            if hd != idc.BADADDR and hd < ea:
                ea = hd
            while ea < a + 0x18:
                fl = ida_bytes.get_flags(ea)
                if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
                    sz = max(ida_bytes.get_item_size(ea), 1)
                    f = ida_funcs.get_func(ea)
                    xr = ",".join("%08X:%d" % (x.frm, x.type) for x in idautils.XrefsTo(ea, 0) if x.type != 21)
                    h.write("  %08X %-14s %s%s  {%s} xr[%s]\n" % (ea, ida_bytes.get_bytes(ea, sz).hex(),
                            "C " if ida_bytes.is_code(fl) else "D ", idc.generate_disasm_line(ea, 0),
                            ("%08X" % f.start_ea) if f else "", xr))
                    ea += sz
                else:
                    h.write("  %08X %02x             unk\n" % (ea, ida_bytes.get_byte(ea)))
                    ea += 1
            h.write("  -- linear from %08X\n" % a)
            cur = a
            for _ in range(10):
                insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, cur)
                if ln <= 0:
                    h.write("    %08X invalid\n" % cur); break
                h.write("    %08X %-14s %s\n" % (cur, ida_bytes.get_bytes(cur, ln).hex(), idc.GetDisasm(cur) if ida_bytes.is_head(ida_bytes.get_flags(cur)) and ida_bytes.get_item_size(cur) == ln else insn.get_canon_mnem()))
                cur += ln


try:
    main()
except Exception:
    with open(OUT, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
