r"""BOOT-IPC reusable probe. Env-driven so it can be re-run with --reopen.

  BOOT_FUNCS=ea1,ea2   full disassembly of the function containing each ea
  BOOT_XREFS=ea1,ea2   all xrefs TO each ea (with referrer func + disasm)
  BOOT_RANGE=lo-hi     linear disassembly of [lo,hi)
  BOOT_SWITCH=1        enumerate switch/jump tables in all functions
  BOOT_OUT=name        output file suffix (default 'probe')

Writes ida/out/boot-ipc/<JOB>_<BOOT_OUT>.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_xref, idautils, idc
import ida_nalt, ida_idaapi
try:
    import ida_switch
except Exception:
    ida_switch = None

OUT = str(_REPO / "ida/out/boot-ipc")
JOB = os.environ.get("YAESU_JOB", "job")
SUF = os.environ.get("BOOT_OUT", "probe")

def dis(ea):
    return idc.generate_disasm_line(ea, 0) or ""

def env_eas(name):
    v = os.environ.get(name, "").strip()
    if not v:
        return []
    out = []
    for tok in v.replace(" ", "").split(","):
        if tok:
            out.append(int(tok, 16))
    return out

def dump_func(ea, lines):
    f = ida_funcs.get_func(ea)
    if f is None:
        ida_ua.create_insn(ea)
        ida_auto.auto_wait()
        f = ida_funcs.get_func(ea)
    if f is None:
        lines.append("; no function at %08X; linear 60" % ea)
        cur = ea
        for _ in range(60):
            lines.append("%08X  %s" % (cur, dis(cur)))
            cur = ida_bytes.next_head(cur, cur + 0x1000)
        return
    name = ida_funcs.get_func_name(f.start_ea)
    lines.append("; ==== %s  %08X-%08X ====" % (name, f.start_ea, f.end_ea))
    ea = f.start_ea
    while ea < f.end_ea and ea != ida_idaapi.BADADDR:
        lines.append("%08X  %s" % (ea, dis(ea)))
        ea = ida_bytes.next_head(ea, f.end_ea)

def dump_xrefs(ea, lines):
    lines.append("; ==== xrefs TO %08X ====" % ea)
    n = 0
    for xr in idautils.XrefsTo(ea, 0):
        frm = xr.frm
        f = ida_funcs.get_func(frm)
        fn = ida_funcs.get_func_name(f.start_ea) if f else "?"
        lines.append("  %08X  %-28s  %s" % (frm, fn, dis(frm)))
        n += 1
    lines.append("; (%d xrefs)" % n)

def enum_switches(lines):
    lines.append("; ==== switch / jump tables ====")
    for fea in idautils.Functions():
        f = ida_funcs.get_func(fea)
        ea = fea
        while ea < f.end_ea:
            si = None
            try:
                si = idc.get_switch_info(ea) if hasattr(idc, "get_switch_info") else None
            except Exception:
                si = None
            if si is None and ida_switch is not None:
                try:
                    tmp = ida_switch.switch_info_t()
                    if ida_switch.get_switch_info(tmp, ea):
                        si = tmp
                except Exception:
                    si = None
            if si is not None:
                try:
                    ncases = si.get_jtable_size()
                    lines.append("  switch @%08X in %s  cases=%d jump=%08X" % (
                        ea, ida_funcs.get_func_name(fea), ncases, si.jumps))
                except Exception:
                    lines.append("  switch @%08X in %s" % (ea, ida_funcs.get_func_name(fea)))
            ea = ida_bytes.next_head(ea, f.end_ea)
            if ea == ida_idaapi.BADADDR:
                break

def main():
    ida_auto.auto_wait()
    lines = ["job %s suffix %s" % (JOB, SUF)]
    for ea in env_eas("BOOT_FUNCS"):
        dump_func(ea, lines)
        lines.append("")
    for ea in env_eas("BOOT_XREFS"):
        dump_xrefs(ea, lines)
        lines.append("")
    rng = os.environ.get("BOOT_RANGE", "").strip()
    if rng and "-" in rng:
        lo, hi = rng.split("-", 1)
        lo = int(lo, 16); hi = int(hi, 16)
        lines.append("; ==== linear %08X-%08X ====" % (lo, hi))
        cur = lo
        while cur < hi:
            if not ida_bytes.is_code(ida_bytes.get_flags(cur)):
                ida_ua.create_insn(cur)
            lines.append("%08X  %s" % (cur, dis(cur)))
            nh = ida_bytes.next_head(cur, hi)
            cur = nh if nh != ida_idaapi.BADADDR and nh > cur else cur + 1
    if os.environ.get("BOOT_SWITCH", "").strip() == "1":
        enum_switches(lines)
    with open(os.path.join(OUT, "%s_%s.txt" % (JOB, SUF)), "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines) + "\n")

try:
    main()
    idc.qexit(0)
except Exception:
    with open(os.path.join(OUT, "%s_%s_TRACEBACK.txt" % (JOB, SUF)), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
    idc.qexit(1)
