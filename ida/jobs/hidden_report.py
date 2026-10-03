r"""HIDDEN job 3: string xrefs, reachability / orphans, and targeted listings.

Runs against HID_MAIN or HID_SUB after hidden_cover.py raised coverage.

Inputs (regenerated between --reopen runs so iteration is cheap):
  ida\out\hidden\_raw_strings_<img>.tsv   candidate strings from the byte scan
  ida\out\hidden\_targets_<img>.txt       "0xADDR<TAB>label" listing requests
  ida\out\hidden\_refsites_<img>.txt      "0xADDR" force a function here first

Outputs:
  strxref_<img>.tsv     per candidate string: IDA xrefs + containing functions
  reach_<img>.tsv       per function: indegree detail + reachability class
  listing_<img>.txt     disassembly windows for every requested target
  ptrfuncs_<img>.tsv    every function whose address appears as a data pointer
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import sys
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_segment
import ida_ua
import ida_xref
import idautils
import idc

OUT = str(_REPO / "ida/out/hidden")
os.makedirs(OUT, exist_ok=True)
JOB = os.environ.get("YAESU_JOB", "HID")
IMG = os.environ.get("YAESU_IMG", "MAIN" if "MAIN" in JOB.upper() else "SUB")
TAG = IMG.lower()
BASE = 0x00000000 if IMG == "MAIN" else 0xFFC00000

LOG = []


def log(msg):
    LOG.append(str(msg))
    sys.stdout.write(str(msg) + "\n")


def w(path, text):
    with open(os.path.join(OUT, path), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def rd(path):
    p = os.path.join(OUT, path)
    if not os.path.isfile(p):
        return []
    with open(p, "r", encoding="utf-8") as f:
        return [ln.rstrip("\n") for ln in f]


# ------------------------------------------------------------------ listings

def dis_window(ea, back, fwd):
    """Text listing. Aligns backwards by finding an offset that lands on ea."""
    lines = []
    start = ea
    for k in range(back, -1, -1):
        p = ea - k
        q = p
        ok = True
        guard = 0
        while q < ea and guard < 400:
            fl = ida_bytes.get_flags(q)
            n = ida_bytes.get_item_size(q) if (ida_bytes.is_code(fl) or ida_bytes.is_data(fl)) else 0
            if n <= 0:
                ok = False
                break
            q += n
            guard += 1
        if ok and q == ea:
            start = p
            break
    cur = start
    end = ea + fwd
    guard = 0
    while cur < end and guard < 1200:
        fl = ida_bytes.get_flags(cur)
        n = ida_bytes.get_item_size(cur)
        if n <= 0:
            n = 1
        raw = " ".join("%02X" % b for b in ida_bytes.get_bytes(cur, min(n, 8)) or b"")
        txt = idc.generate_disasm_line(cur, 0) or ""
        fn = ida_funcs.get_func(cur)
        mark = "*" if cur == ea else " "
        lines.append("%s %08X  %-24s %-12s %s" % (
            mark, cur, raw, ("[%s]" % ida_funcs.get_func_name(fn.start_ea)) if fn else "", txt))
        cur += n
        guard += 1
    return lines


def do_listings():
    reqs = []
    for ln in rd("_targets_%s.txt" % TAG):
        ln = ln.strip()
        if not ln or ln.startswith("#"):
            continue
        parts = ln.split("\t")
        try:
            addr = int(parts[0], 16)
        except ValueError:
            continue
        label = parts[1] if len(parts) > 1 else ""
        back = int(parts[2], 0) if len(parts) > 2 else 0x40
        fwd = int(parts[3], 0) if len(parts) > 3 else 0xC0
        reqs.append((addr, label, back, fwd))
    out = []
    for addr, label, back, fwd in reqs:
        out.append("=" * 78)
        out.append("TARGET 0x%08X  %s" % (addr, label))
        fn = ida_funcs.get_func(addr)
        if fn:
            out.append("  inside %s  0x%08X-0x%08X" % (
                ida_funcs.get_func_name(fn.start_ea), fn.start_ea, fn.end_ea))
        xr = []
        for x in idautils.XrefsTo(addr, 0):
            if x.type == ida_xref.fl_F:
                continue
            f2 = ida_funcs.get_func(x.frm)
            xr.append("0x%08X%s" % (x.frm, ("(%s)" % ida_funcs.get_func_name(f2.start_ea)) if f2 else ""))
        out.append("  xrefs_to: %s" % (", ".join(xr) if xr else "NONE"))
        out.append("=" * 78)
        out.extend(dis_window(addr, back, fwd))
        out.append("")
    w("listing_%s.txt" % TAG, "\n".join(out) + "\n")
    return len(reqs)


# ------------------------------------------------------------- string xrefs

def do_strxrefs():
    rows = ["offset\taddr\tlen\tenc\tterm\tclass\tn_ida_xref\tida_xref_from\tref_funcs\ttext"]
    n = 0
    lines = rd("_raw_strings_%s.tsv" % TAG)
    for ln in lines[1:]:
        parts = ln.split("\t")
        if len(parts) < 7:
            continue
        off_s, addr_s, len_s, enc, term, cls = parts[:6]
        text = parts[6]
        try:
            addr = int(addr_s, 16)
            slen = int(len_s)
        except ValueError:
            continue
        nbytes = slen * (1 if enc == "ascii" else 2)
        frms = []
        funcs = set()
        # a pointer may land on the head or anywhere inside the string
        for probe in range(addr, addr + max(1, nbytes)):
            for x in idautils.XrefsTo(probe, 0):
                if x.type == ida_xref.fl_F:
                    continue
                frms.append("0x%08X%s" % (x.frm, "" if probe == addr else "+%d" % (probe - addr)))
                f2 = ida_funcs.get_func(x.frm)
                if f2:
                    funcs.add("0x%08X" % f2.start_ea)
        n += 1
        rows.append("%s\t%s\t%s\t%s\t%s\t%s\t%d\t%s\t%s\t%s" % (
            off_s, addr_s, len_s, enc, term, cls, len(frms),
            ",".join(frms[:10]), ",".join(sorted(funcs)[:10]), text))
    w("strxref_%s.tsv" % TAG, "\n".join(rows) + "\n")
    return n


# ---------------------------------------------------------------- reachability

def do_reach():
    """Indegree detail plus a transitive-reachability class from real roots.

    Roots: the reset entry, every vector-table target, and every function whose
    address appears as a data pointer anywhere (which covers pointer tables,
    vector slots and computed jumps -- the false-positive sources the brief
    warns about).
    """
    funcs = {}
    for ea in idautils.Functions():
        f = ida_funcs.get_func(ea)
        if f:
            funcs[f.start_ea] = f

    callers = {ea: set() for ea in funcs}
    callees = {ea: set() for ea in funcs}
    dataref = {ea: set() for ea in funcs}
    for ea in funcs:
        for x in idautils.XrefsTo(ea, 0):
            if x.type == ida_xref.fl_F:
                continue
            src = ida_funcs.get_func(x.frm)
            if x.iscode:
                if src and src.start_ea != ea:
                    callers[ea].add(src.start_ea)
                    callees[src.start_ea].add(ea)
                elif src is None:
                    callers[ea].add(-1)          # code outside any function
            else:
                dataref[ea].add(x.frm)

    # --- data-pointer roots: scan every segment for aligned words equal to a
    # function start. Coverage-independent; catches pointer tables IDA did not
    # turn into offsets.
    ptr_roots = set()
    ptr_sites = {}
    step = 4
    for seg_ea in idautils.Segments():
        s = ida_segment.getseg(seg_ea)
        ea = s.start_ea
        end = s.end_ea
        # unaligned too: RX/H8S immediates are not word aligned
        while ea < end - 3:
            v = ida_bytes.get_dword(ea)
            if IMG == "MAIN":
                v &= 0x00FFFFFF
            if v in funcs:
                ptr_roots.add(v)
                ptr_sites.setdefault(v, []).append(ea)
            ea += 1
    log("data-pointer roots %d" % len(ptr_roots))

    roots = set()
    entry = idc.get_inf_attr(idc.INF_START_IP)
    if entry in funcs:
        roots.add(entry)
    # vector tables
    if IMG == "MAIN":
        for i in range(256):
            v = ida_bytes.get_dword(i * 4) & 0x00FFFFFF
            if v in funcs:
                roots.add(v)
    else:
        for tbl, cnt in ((0xFFFFFF80, 32), (0xFFED8A70, 256)):
            for i in range(cnt):
                v = ida_bytes.get_dword(tbl + i * 4)
                if v in funcs:
                    roots.add(v)
    log("vector/entry roots %d" % len(roots))
    reach_roots = set(roots) | ptr_roots

    # transitive closure over call edges
    seen = set()
    stack = list(reach_roots)
    while stack:
        cur = stack.pop()
        if cur in seen:
            continue
        seen.add(cur)
        for nxt in callees.get(cur, ()):
            if nxt not in seen:
                stack.append(nxt)
    log("reachable from roots %d of %d" % (len(seen), len(funcs)))

    rows = ["ea\tsize\tname\tn_callers\tn_callees\tn_dataref\tis_ptr_target\t"
            "ptr_sites\tclass\tcallers"]
    orphans = []
    for ea in sorted(funcs):
        f = funcs[ea]
        size = f.end_ea - f.start_ea
        nc = len(callers[ea] - {-1})
        loose = -1 in callers[ea]
        nd = len(dataref[ea])
        isptr = ea in ptr_roots
        if nc == 0 and not isptr and nd == 0 and not loose and ea not in roots:
            cls = "orphan"
            orphans.append((size, ea))
        elif nc == 0 and (isptr or nd or loose):
            cls = "indirect_only"
        elif ea in seen:
            cls = "reachable"
        else:
            cls = "island"          # has callers, but none reachable from a root
        rows.append("0x%08X\t%d\t%s\t%d\t%d\t%d\t%d\t%s\t%s\t%s" % (
            ea, size, ida_funcs.get_func_name(ea), nc, len(callees[ea]), nd,
            1 if isptr else 0,
            ",".join("0x%08X" % p for p in ptr_sites.get(ea, [])[:6]),
            cls, ",".join("0x%08X" % c for c in sorted(callers[ea] - {-1})[:10])))
    w("reach_%s.tsv" % TAG, "\n".join(rows) + "\n")

    orphans.sort(reverse=True)
    orows = ["rank\tea\tsize\tname\tn_insn\tn_callees\tfirst_bytes"]
    for i, (size, ea) in enumerate(orphans[:400], 1):
        ni = sum(1 for _ in idautils.FuncItems(ea))
        b = ida_bytes.get_bytes(ea, 16) or b""
        orows.append("%d\t0x%08X\t%d\t%s\t%d\t%d\t%s" % (
            i, ea, size, ida_funcs.get_func_name(ea), ni, len(callees[ea]),
            " ".join("%02X" % x for x in b)))
    w("orphans_%s.tsv" % TAG, "\n".join(orows) + "\n")
    log("orphans %d (largest %d bytes)" % (len(orphans), orphans[0][0] if orphans else 0))
    return len(funcs), len(orphans)


def main():
    ida_auto.auto_wait()
    log("job3 img=%s" % IMG)
    log("strings annotated %d" % do_strxrefs())
    log("listings %d" % do_listings())
    log("reach funcs=%d orphans=%d" % do_reach())


try:
    main()
except Exception:
    LOG.append(traceback.format_exc())
finally:
    w("job3_log_%s.txt" % TAG, "\n".join(LOG) + "\n")
    idc.qexit(0)
