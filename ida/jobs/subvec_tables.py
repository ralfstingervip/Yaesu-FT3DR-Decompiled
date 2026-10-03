r"""SUB-VEC pass A: decode the RX64M relocatable (INTB) and fixed (EXTB) vector
tables of the FT3DR SUB image, create a function at every distinct handler
target, walk the call graph out of the handlers, and dump raw disassembly.

Launch only through run_job.py.  Seed with:
    python ida/run_job.py --script ida\jobs\subvec_tables.py \
        --db SUB_VEC --copy-from ida\db\radio\SUB.i64
Iterate with --reopen.

Output: ida/out/sub-vec/
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root

import os
import traceback

OUT = str(_REPO / "ida/out/sub-vec")
BASE = 0xFFC00000
SIZE = 0x400000
TOP = BASE + SIZE
INTB = 0xFFED8A70
EXTB = 0xFFFFFF80
STATUS = os.path.join(OUT, "passA_status.txt")


def log(text):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as handle:
        handle.write(text + "\n")


def esc(text):
    return (text or "").replace("\t", " ").replace("\r", " ").replace("\n", " ")


def main():
    import ida_auto
    import ida_bytes
    import ida_funcs
    import ida_ida
    import ida_idp
    import ida_name
    import ida_segment
    import ida_ua
    import idautils
    import idc

    log("procname %s" % (ida_ida.inf_get_procname() or "?"))
    log("min %#x max %#x" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))

    # ---- segments -------------------------------------------------------
    seg_rows = []
    seg = ida_segment.get_first_seg()
    while seg is not None:
        seg_rows.append((idc.get_segm_name(seg.start_ea), seg.start_ea, seg.end_ea))
        seg = ida_segment.get_next_seg(seg.start_ea)
    for name, start, end in seg_rows:
        log("seg_in %s %08X-%08X class %s" % (name, start, end, idc.get_segm_attr(start, idc.SEGATTR_TYPE)))

    # Handlers live in the RES (0xFFC40000-0xFFEE0000) and DENSE
    # (0xFFEE0000-0xFFF50000) segments, both loaded as DATA by the earlier
    # survey.  Re-class them CODE so add_func / flow tracing behaves.  This
    # does not queue a sweep, it only changes the class.
    for name, start, end in seg_rows:
        if name in ("RES", "DENSE", "PAD", "ROM"):
            s = ida_segment.getseg(start)
            try:
                ida_segment.set_segm_class(s, "CODE", 0)
                log("reclass %s CODE ok" % name)
            except Exception as exc:
                log("reclass %s failed %s" % (name, exc))

    funcs_before = sum(1 for _ in idautils.Functions())
    bytes_before = 0
    for start in idautils.Functions():
        f = ida_funcs.get_func(start)
        if f:
            bytes_before += f.end_ea - f.start_ea
    log("funcs_before %d bytes_before %d" % (funcs_before, bytes_before))

    # ---- read the two tables -------------------------------------------
    def read_table(table_ea, count):
        rows = []
        for i in range(count):
            ea = table_ea + i * 4
            raw = ida_bytes.get_bytes(ea, 4)
            if raw is None or len(raw) != 4:
                rows.append((i, ea, None, None))
                continue
            value = int.from_bytes(raw, "little")
            rows.append((i, ea, value, raw))
        return rows

    intb_rows = read_table(INTB, 256)
    extb_rows = read_table(EXTB, 32)
    log("intb rows %d extb rows %d" % (len(intb_rows), len(extb_rows)))

    # ---- classify targets ----------------------------------------------
    targets = {}
    for tag, rows in (("intb", intb_rows), ("extb", extb_rows)):
        for i, ea, value, raw in rows:
            if value is None or value == 0:
                continue
            if not (BASE <= value < TOP):
                continue
            targets.setdefault(value, []).append((tag, i))
    log("distinct in-image targets %d" % len(targets))

    # ---- make code / functions at each target --------------------------
    made = []
    for value in sorted(targets):
        flags = ida_bytes.get_flags(value)
        was_code = ida_bytes.is_code(flags)
        if not was_code:
            ida_bytes.del_items(value, ida_bytes.DELIT_SIMPLE, 4)
            ida_ua.create_insn(value)
        ida_auto.auto_make_proc(value)
        made.append((value, was_code))
    log("auto_make_proc issued %d" % len(made))
    ida_auto.auto_wait()
    log("auto_wait_1_done")

    # a second explicit add_func for anything still not a function
    forced = 0
    for value, _ in made:
        if ida_funcs.get_func(value) is None:
            if ida_funcs.add_func(value):
                forced += 1
    ida_auto.auto_wait()
    log("forced add_func %d" % forced)

    # name them
    for value in sorted(targets):
        slots = targets[value]
        if len(slots) == 1:
            tag, i = slots[0]
            nm = "vec_%s_%03d" % (tag, i)
        else:
            nm = "vec_shared_%08X" % value
        cur = ida_name.get_name(value) or ""
        if not cur or cur.startswith(("sub_", "loc_", "unk_", "byte_", "word_", "dword_")):
            ida_name.set_name(value, nm, ida_name.SN_FORCE)

    # ---- BFS the call graph out of every handler -----------------------
    def code_refs(ea):
        out = []
        for ref in idautils.CodeRefsFrom(ea, 0):   # 0 = do not follow normal flow
            out.append(ref)
        return out

    seen = set()
    queue = [v for v in sorted(targets)]
    closure = []
    rounds = 0
    while queue and rounds < 400:
        rounds += 1
        nxt = []
        for start in queue:
            if start in seen:
                continue
            seen.add(start)
            f = ida_funcs.get_func(start)
            if f is None:
                closure.append((start, start, start, "nofunc"))
                continue
            closure.append((f.start_ea, f.end_ea, start, "func"))
            ea = f.start_ea
            while ea < f.end_ea and ea != idc.BADADDR:
                for ref in code_refs(ea):
                    if not (BASE <= ref < TOP):
                        continue
                    if ref in seen:
                        continue
                    if ida_funcs.get_func(ref) is None:
                        ida_bytes.del_items(ref, ida_bytes.DELIT_SIMPLE, 2)
                        ida_ua.create_insn(ref)
                        ida_auto.auto_make_proc(ref)
                    nxt.append(ref)
                ea = idc.next_head(ea, f.end_ea)
        if nxt:
            ida_auto.auto_wait()
        # keep only true function starts for the next round
        queue = []
        for ref in nxt:
            fr = ida_funcs.get_func(ref)
            if fr is not None and fr.start_ea not in seen:
                queue.append(fr.start_ea)
            elif fr is None and ref not in seen:
                queue.append(ref)
    ida_auto.auto_wait()
    log("bfs rounds %d closure %d" % (rounds, len(closure)))

    funcs_after = sum(1 for _ in idautils.Functions())
    bytes_after = 0
    for start in idautils.Functions():
        f = ida_funcs.get_func(start)
        if f:
            bytes_after += f.end_ea - f.start_ea
    log("funcs_after %d bytes_after %d" % (funcs_after, bytes_after))

    # ---- write the vector tables ---------------------------------------
    def kind_of(value):
        if value is None:
            return "unreadable"
        if value == 0:
            return "null"
        if not (BASE <= value < TOP):
            return "out_of_image"
        f = ida_funcs.get_func(value)
        size = (f.end_ea - f.start_ea) if f else 0
        line = (idc.generate_disasm_line(value, idc.GENDSM_FORCE_CODE) or "").strip()
        if size <= 2 and line.lower().startswith("rte"):
            return "rte_stub"
        return "handler"

    def write_table(path, rows, tag):
        with open(path, "w", encoding="utf-8", newline="\n") as h:
            h.write("slot\tslot_ea\tslot_file_off\traw_le\ttarget\ttarget_file_off\tkind\tfunc_start\tfunc_size\tname\tfirst_insn\n")
            for i, ea, value, raw in rows:
                k = kind_of(value)
                fs = ""
                fsz = ""
                nm = ""
                line = ""
                if value and BASE <= value < TOP:
                    f = ida_funcs.get_func(value)
                    if f:
                        fs = "%08X" % f.start_ea
                        fsz = "%d" % (f.end_ea - f.start_ea)
                    nm = idc.get_name(value) or ""
                    line = (idc.generate_disasm_line(value, idc.GENDSM_FORCE_CODE) or "").strip()
                h.write("%d\t%08X\t%06X\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" % (
                    i, ea, ea - BASE,
                    raw.hex() if raw else "",
                    ("%08X" % value) if value is not None else "",
                    ("%06X" % (value - BASE)) if (value and BASE <= value < TOP) else "",
                    k, fs, fsz, esc(nm), esc(line)))
        log("wrote %s" % path)

    write_table(os.path.join(OUT, "intb.tsv"), intb_rows, "intb")
    write_table(os.path.join(OUT, "extb.tsv"), extb_rows, "extb")

    # ---- occupancy summary ---------------------------------------------
    counts = {}
    for i, ea, value, raw in intb_rows:
        counts[value] = counts.get(value, 0) + 1
    with open(os.path.join(OUT, "intb_targets.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("target\tslots\tkind\tslot_list\n")
        for value in sorted(counts, key=lambda v: (-counts[v], v if v is not None else 0)):
            slots = [str(i) for i, _e, v, _r in intb_rows if v == value]
            h.write("%s\t%d\t%s\t%s\n" % (
                ("%08X" % value) if value is not None else "?",
                counts[value], kind_of(value), ",".join(slots)))
    log("wrote intb_targets.tsv")

    # ---- full disassembly of the handler closure -----------------------
    closure_starts = sorted({c[0] for c in closure})
    with open(os.path.join(OUT, "isr_disasm.txt"), "w", encoding="utf-8", newline="\n") as h:
        for start in closure_starts:
            f = ida_funcs.get_func(start)
            nm = idc.get_func_name(start) or idc.get_name(start) or ""
            if f is None:
                h.write("\n;=== %08X (no function) %s\n" % (start, nm))
                ea = start
                for _ in range(40):
                    h.write("%08X  %-24s %s\n" % (
                        ea, (ida_bytes.get_bytes(ea, max(1, idc.get_item_size(ea))) or b"").hex(),
                        esc(idc.generate_disasm_line(ea, idc.GENDSM_FORCE_CODE) or "")))
                    nx = idc.next_head(ea, start + 200)
                    if nx == idc.BADADDR:
                        break
                    ea = nx
                continue
            h.write("\n;=== %08X-%08X  file %06X  size %d  %s\n" % (
                f.start_ea, f.end_ea, f.start_ea - BASE, f.end_ea - f.start_ea, nm))
            ea = f.start_ea
            while ea < f.end_ea and ea != idc.BADADDR:
                sz = max(1, idc.get_item_size(ea))
                raw = ida_bytes.get_bytes(ea, min(sz, 12)) or b""
                h.write("%08X  %-26s %s\n" % (ea, raw.hex(), esc(idc.generate_disasm_line(ea, 0) or "")))
                ea = idc.next_head(ea, f.end_ea)
    log("wrote isr_disasm.txt")

    # ---- operand-type debug on the handler closure ---------------------
    # Needed to tune the peripheral scan in pass B: learn how the RX module
    # encodes [rN] and disp[rN].
    with open(os.path.join(OUT, "operand_debug.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tmnem\tn\ttype\tvalue\taddr\treg\tphrase\tdtype\tspecflag1\tspecflag2\ttext\n")
        shown = 0
        for start in closure_starts[:60]:
            f = ida_funcs.get_func(start)
            if f is None:
                continue
            ea = f.start_ea
            while ea < f.end_ea and ea != idc.BADADDR and shown < 4000:
                insn = ida_ua.insn_t()
                if ida_ua.decode_insn(insn, ea):
                    for n in range(6):
                        op = insn.ops[n]
                        if op.type == 0:
                            break
                        h.write("%08X\t%s\t%d\t%d\t%X\t%X\t%d\t%d\t%d\t%d\t%d\t%s\n" % (
                            ea, idc.print_insn_mnem(ea), n, op.type, op.value & 0xFFFFFFFF,
                            op.addr & 0xFFFFFFFF, op.reg, op.phrase, op.dtype,
                            getattr(op, "specflag1", 0), getattr(op, "specflag2", 0),
                            esc(idc.print_operand(ea, n) or "")))
                        shown += 1
                ea = idc.next_head(ea, f.end_ea)
    log("wrote operand_debug.txt")

    with open(os.path.join(OUT, "passA_summary.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("funcs_before %d\nbytes_before %d\nfuncs_after %d\nbytes_after %d\n" % (
            funcs_before, bytes_before, funcs_after, bytes_after))
        h.write("distinct_targets %d\nclosure_funcs %d\n" % (len(targets), len(closure_starts)))
    log("passA done")


if __name__ == "__main__" or True:
    os.makedirs(OUT, exist_ok=True)
    with open(STATUS, "w", encoding="utf-8", newline="\n") as _h:
        _h.write("start\n")
    try:
        main()
    except Exception:
        with open(os.path.join(OUT, "passA_traceback.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
        log("EXCEPTION written")
    import idc as _idc
    _idc.qexit(0)
