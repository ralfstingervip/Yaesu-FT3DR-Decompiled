r"""HIDDEN resume job: key-combination / boot-hold gates, service/factory modes,
region / expanded-RX gating, and the DATA-jack control API.

Self-contained: does NOT depend on the stale the repository root paths. Writes under the
real (relocated) tree. Reads a target list from _keys_targets_<tag>.txt so it can
be iterated cheaply with --reopen. For each target:
  - if a function starts there: full listing + callers + coherence
  - else: a byte+disasm window
Also lists every XrefsTo for a set of gate DATA addresses.

Targets file line formats (TAB separated):
  0xADDR   label                    -> function listing (or 80-insn window if none)
  0xADDR   label   W=<n_insns>       -> force a window of n instructions
  0xADDR   label   D                 -> data address: list all XrefsTo

Env:
  YAESU_IMG = MAIN | SUB
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, sys, traceback
import ida_auto, ida_bytes, ida_funcs, ida_xref, ida_segment
import idautils, idc

OUT = str(_REPO / "ida/out/hidden")
os.makedirs(OUT, exist_ok=True)
JOB = os.environ.get("YAESU_JOB", "HID")
IMG = os.environ.get("YAESU_IMG", "MAIN" if "MAIN" in JOB.upper() else "SUB")
TAG = IMG.lower()
RET = {"MAIN": ("rts", "rte", "rtsd"), "SUB": ("rts", "rtsd", "rte", "rtfi")}[IMG]
MASK = 0x00FFFFFF if IMG == "MAIN" else 0xFFFFFFFF
LOG = []

def log(m):
    LOG.append(str(m)); sys.stdout.write(str(m) + "\n")

def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)

def rd(path):
    p = os.path.join(OUT, path)
    if not os.path.isfile(p):
        return []
    with open(p, "r", encoding="utf-8") as f:
        return [ln.rstrip("\n") for ln in f]

def bytes_at(ea, n):
    return " ".join("%02X" % b for b in (ida_bytes.get_bytes(ea, n) or b""))

def disasm_window(ea, n_insns):
    out = []
    cur = ea
    for _ in range(n_insns):
        sz = ida_bytes.get_item_size(cur) or 1
        raw = bytes_at(cur, min(sz, 10))
        cmt = idc.get_cmt(cur, 0) or idc.get_cmt(cur, 1) or ""
        out.append("  %08X  %-30s %-46s %s" % (cur, raw, idc.generate_disasm_line(cur, 0) or "", cmt))
        cur += sz
    return out

def coherence(ea, end):
    n = end - ea
    if n <= 0:
        return "n=0"
    blob = ida_bytes.get_bytes(ea, n) or b""
    insn = 0; mnems = set(); last = None; cur = ea; g = 0
    while cur < end and g < 20000:
        fl = ida_bytes.get_flags(cur); sz = ida_bytes.get_item_size(cur) or 1
        if ida_bytes.is_code(fl):
            insn += sz; m = idc.print_insn_mnem(cur)
            if m:
                mnems.add(m); last = m
        cur += sz; g += 1
    return "frac_insn=%.2f n_mnem=%d ends_ret=%d last=%s" % (
        insn / float(n), len(mnems), 1 if last in RET else 0, last or "")

def callers_of(ea):
    cs = []
    for x in idautils.XrefsTo(ea, 0):
        if x.type == ida_xref.fl_F:
            continue
        cf = ida_funcs.get_func(x.frm)
        cs.append("0x%08X%s%s" % (x.frm, "(%s)" % ida_funcs.get_func_name(cf.start_ea) if cf else "",
                                  "" if x.iscode else "[data]"))
    return cs

def full_func(ea, label):
    out = ["=" * 90]
    f = ida_funcs.get_func(ea)
    if f is None or f.start_ea != ea:
        out.append("ADDR 0x%08X  %s   (no function head here; 80-insn window)" % (ea, label))
        out.append("=" * 90)
        out += disasm_window(ea, 80)
        out.append("")
        return out
    out.append("FUNC %s  0x%08X-0x%08X  %d bytes  %s" % (
        ida_funcs.get_func_name(f.start_ea), f.start_ea, f.end_ea, f.end_ea - f.start_ea, label))
    cs = callers_of(f.start_ea)
    out.append("  callers/refs: %s" % (", ".join(cs) if cs else "NONE"))
    out.append("  coherence: %s" % coherence(f.start_ea, f.end_ea))
    out.append("=" * 90)
    cur = f.start_ea; g = 0
    while cur < f.end_ea and g < 6000:
        sz = ida_bytes.get_item_size(cur) or 1
        cmt = idc.get_cmt(cur, 0) or idc.get_cmt(cur, 1) or ""
        out.append("  %08X  %-30s %-46s %s" % (cur, bytes_at(cur, min(sz, 10)),
                                               idc.generate_disasm_line(cur, 0) or "", cmt))
        cur += sz; g += 1
    out.append("")
    return out

def data_xrefs(ea, label):
    out = ["#" * 90, "DATA XREFS to 0x%08X  %s" % (ea, label)]
    hits = list(idautils.XrefsTo(ea, 0))
    if not hits:
        out.append("  (IDA sees no xref; access likely via immediate/absolute the sweep did not mark)")
    for x in hits:
        cf = ida_funcs.get_func(x.frm)
        out.append("  0x%08X  %s  %s  %s" % (
            x.frm, "code" if x.iscode else "DATA",
            ida_funcs.get_func_name(cf.start_ea) if cf else "(loose)",
            idc.generate_disasm_line(x.frm, 0) or ""))
    out.append("")
    return out

def main():
    ida_auto.auto_wait()
    log("hidden_keys img=%s" % IMG)
    reqs = rd("_keys_targets_%s.txt" % TAG)
    func_out = []; data_out = []
    nf = nd = 0
    for ln in reqs:
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        p = ln.split("\t")
        try:
            ea = int(p[0], 16)
        except ValueError:
            continue
        label = p[1] if len(p) > 1 else ""
        opt = p[2].strip() if len(p) > 2 else ""
        if opt == "D":
            data_out += data_xrefs(ea, label); nd += 1
        elif opt.startswith("W="):
            func_out += ["=" * 90, "WINDOW 0x%08X  %s" % (ea, label), "=" * 90]
            func_out += disasm_window(ea, int(opt[2:])); func_out.append(""); nf += 1
        else:
            func_out += full_func(ea, label); nf += 1
    w("keys_funcdump_%s.txt" % TAG, "\n".join(func_out) + "\n")
    w("keys_dataxref_%s.txt" % TAG, "\n".join(data_out) + "\n")
    log("funcs/windows=%d dataxrefs=%d" % (nf, nd))

try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    w("keys_log_%s.txt" % TAG, "\n".join(LOG) + "\n")
    idc.qexit(0)
