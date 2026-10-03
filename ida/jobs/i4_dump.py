r"""Lane I4 (copied from h15_dump) range dumper (MAIN, H8SX).  Reopen-only.

  --env I4_RANGES=name:lo-hi,...   hex
  --env I4_FORCE=1                 force-decode those ranges first (never inside 0x78106-0x7B753)
  --env I4_XREF=ea,ea,...          xrefs to these
  --env I4_FUNCS=lo-hi             list function bounds in a range
Writes ida\out\dsp-runtime\work\<name>.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_name, idautils, idc

ROOT = str(_REPO)
OUT = os.path.join(ROOT, "ida", "out", "dsp-rx", "work")
WLO, WHI = 0x078106, 0x07B754

def esc(t): return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")

def force_code(lo, hi):
    ea, made = lo, 0
    while ea < hi:
        if WLO <= ea < WHI:
            ea = WHI; continue
        if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            if idc.create_insn(ea) > 0:
                made += 1; ea += max(1, idc.get_item_size(ea)); continue
            ea += 1; continue
        ea += max(1, idc.get_item_size(ea))
    ida_auto.auto_wait()
    return made

def dump(name, lo, hi):
    rows = []
    ea = lo
    while ea < hi:
        if WLO <= ea < WHI:
            rows.append("-- closed window %#x..%#x skipped --" % (WLO, WHI)); ea = WHI; continue
        fl = ida_bytes.get_flags(ea)
        sz = max(1, idc.get_item_size(ea))
        if not ida_bytes.is_code(fl): sz = min(sz, 16)
        raw = ida_bytes.get_bytes(ea, min(sz, 16)) or b""
        txt = ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "?")
        fn = ida_funcs.get_func(ea)
        head = ""
        if fn and fn.start_ea == ea:
            head = "\n;---- func %#x..%#x\n" % (fn.start_ea, fn.end_ea)
        xr = ["%x" % x.frm for x in idautils.XrefsTo(ea, 0) if x.type != 21]
        rows.append("%s%06x  %-24s %-44s %s" % (head, ea, raw.hex(" "), esc(txt), ("<- " + ",".join(xr[:8])) if xr else ""))
        ea += sz
    with open(os.path.join(OUT, name + ".txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")

def main():
    os.makedirs(OUT, exist_ok=True)
    ida_auto.auto_wait()
    log = []
    force = os.environ.get("I4_FORCE", "") == "1"
    for part in [p for p in os.environ.get("I4_RANGES", "").split(",") if p.strip()]:
        name, _, rng = part.partition(":")
        a, _, b = rng.partition("-")
        lo, hi = int(a, 16), int(b, 16)
        if force: log.append("force %s made=%d" % (name, force_code(lo, hi)))
        dump(name, lo, hi); log.append("dump %s %x-%x" % (name, lo, hi))
    xs = [t for t in os.environ.get("I4_XREF", "").split(",") if t.strip()]
    if xs:
        rows = []
        for t in xs:
            ea = int(t, 16)
            for x in idautils.XrefsTo(ea, 0):
                fn = ida_funcs.get_func(x.frm)
                txt = ida_lines.tag_remove(ida_lines.generate_disasm_line(x.frm, ida_lines.GENDSM_REMOVE_TAGS) or "")
                rows.append("%06x\t%06x\t%s\t%d\t%s" % (ea, x.frm, ("%x" % fn.start_ea) if fn else "-", x.type, esc(txt)))
        with open(os.path.join(OUT, "xrefs.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
    fr = os.environ.get("I4_FUNCS", "")
    if fr:
        a, _, b = fr.partition("-"); lo, hi = int(a, 16), int(b, 16)
        rows = []
        for f in idautils.Functions(lo, hi):
            fn = ida_funcs.get_func(f)
            callers = sorted(set(idautils.CodeRefsTo(f, 0)))
            rows.append("%06x\t%06x\t%d\t%s" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea, ",".join("%x" % c for c in callers[:12])))
        with open(os.path.join(OUT, "funcs.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
    with open(os.path.join(OUT, "log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")

try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
