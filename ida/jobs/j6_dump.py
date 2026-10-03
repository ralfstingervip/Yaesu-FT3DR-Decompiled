r"""Lane J6: key-0x14 path + tone event 0x4F / FFAAE8 survey. Read-only.

MAIN, H8SX, base 0, big-endian. Never decodes inside the closed window 0x078106-0x07B753.
  --env J6_TAG=name                   output subfolder under ida\out\usb-key14\work\
  --env J6_RANGES=name:lo-hi,...      dump disasm + xrefs (hex)
  --env J6_XREF=ea,ea,...             xref census
  --env J6_GREP=s1|s2|...             every code head (outside window) whose text contains any
  --env J6_FUNCS=lo-hi                function bounds + callers
No edits, no auto analysis.
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, ida_lines, ida_name, idautils, idc, ida_segment

ROOT = str(_REPO)
TAG = os.environ.get("J6_TAG", "w")
OUT = os.path.join(ROOT, "ida", "out", "usb-key14", "work", TAG)
WLO, WHI = 0x078106, 0x07B754

def esc(t): return t.replace("\t", " ").replace("\r", " ").replace("\n", " ")

def line(ea):
    return esc(ida_lines.tag_remove(ida_lines.generate_disasm_line(ea, ida_lines.GENDSM_REMOVE_TAGS) or "?"))

def dump(name, lo, hi):
    rows = []
    ea = lo
    while ea < hi:
        if WLO <= ea < WHI:
            rows.append("-- closed window skipped --"); ea = WHI; continue
        fl = ida_bytes.get_flags(ea)
        sz = max(1, idc.get_item_size(ea))
        if not ida_bytes.is_code(fl): sz = min(sz, 16)
        raw = ida_bytes.get_bytes(ea, min(sz, 16)) or b""
        fn = ida_funcs.get_func(ea)
        head = ""
        if fn and fn.start_ea == ea:
            head = "\n;---- func %#x..%#x  %s\n" % (fn.start_ea, fn.end_ea, ida_name.get_name(fn.start_ea) or "")
        xr = ["%x" % x.frm for x in idautils.XrefsTo(ea, 0) if x.type != 21]
        c = "C" if ida_bytes.is_code(fl) else "d"
        rows.append("%s%06x %s %-30s %-50s %s" % (head, ea, c, raw.hex(" "), line(ea), ("<- " + ",".join(xr[:12])) if xr else ""))
        ea += sz
    with open(os.path.join(OUT, name + ".txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")

def main():
    os.makedirs(OUT, exist_ok=True)
    log = []
    for part in [p for p in os.environ.get("J6_RANGES", "").split(",") if p.strip()]:
        name, _, rng = part.partition(":")
        a, _, b = rng.partition("-")
        dump(name, int(a, 16), int(b, 16)); log.append("dump %s" % name)
    fr = os.environ.get("J6_FUNCS", "")
    if fr:
        a, _, b = fr.partition("-"); lo, hi = int(a, 16), int(b, 16)
        rows = []
        for f in idautils.Functions(lo, hi):
            fn = ida_funcs.get_func(f)
            callers = sorted(set(idautils.CodeRefsTo(f, 0)))
            rows.append("%06x\t%06x\t%d\t%s\t%s" % (fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea,
                        ida_name.get_name(fn.start_ea) or "", ",".join("%x" % c for c in callers[:24])))
        with open(os.path.join(OUT, "funcs.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
        log.append("funcs %x-%x" % (lo, hi))
    xs = [t for t in os.environ.get("J6_XREF", "").split(",") if t.strip()]
    if xs:
        rows = []
        for t in xs:
            ea = int(t, 16); n = 0
            for x in idautils.XrefsTo(ea, 0):
                fn = ida_funcs.get_func(x.frm)
                rows.append("%06x\t%06x\t%s\t%d\t%s" % (ea, x.frm, ("%x" % fn.start_ea) if fn else "-", x.type, line(x.frm)))
                n += 1
            if n == 0: rows.append("%06x\t-\t-\t-\t(no xref)" % ea)
        with open(os.path.join(OUT, "xrefs.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
        log.append("xref %d" % len(xs))
    gs = [g for g in os.environ.get("J6_GREP", "").split("|") if g.strip()]
    if gs:
        gl = [g.lower() for g in gs]
        rows = []
        seg = ida_segment.get_first_seg()
        while seg:
            for h in idautils.Heads(seg.start_ea, seg.end_ea):
                if WLO <= h < WHI: continue
                if not ida_bytes.is_code(ida_bytes.get_flags(h)): continue
                t = line(h); tl = t.lower()
                for g in gl:
                    if g in tl:
                        fn = ida_funcs.get_func(h)
                        rows.append("%s\t%06x\t%s\t%s" % (g, h, ("%x" % fn.start_ea) if fn else "-", t)); break
            seg = ida_segment.get_next_seg(seg.start_ea)
        with open(os.path.join(OUT, "grep.txt"), "w", encoding="utf-8", newline="\n") as h:
            h.write("\n".join(rows) + "\n")
        log.append("grep %d hits" % len(rows))
    with open(os.path.join(OUT, "log.txt"), "a", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(log) + "\n")

try:
    main()
except Exception:
    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "traceback.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
idc.qexit(0)
