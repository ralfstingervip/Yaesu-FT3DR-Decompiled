r"""Lane L6 -- home key-table resolver cross-check (MAIN, read-only).
DB L6_HOME_KEYS (copy of K1_MAIN_FINAL4). No byte is patched and nothing is created or renamed.
Inputs : ida\out\home-keytable\work\ida_req.tsv (oracle addr, size, text, bytes)
Outputs: ida\out\home-keytable\work\ida_check.tsv  (per instruction: IDA kind/size/text vs oracle)
         ida\out\home-keytable\work\ida_xrefs.tsv  (xrefs to the 60 home tables + 7 extra tables, the jump
                                                    tables 0x02ADD0/0x02BA86/0x061C5A/0x0669E0 and key handlers)
         ida\out\home-keytable\work\ida_items.tsv  (item kind/type over each table range)
         traceback -> ida_main_check.err
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
import ida_auto, ida_bytes, ida_funcs, idc, idautils, ida_lines, ida_name

W = str(_REPO / "ida/out/home-keytable/work")
XT = {0: "Data_Unknown", 1: "dr_O", 2: "dr_W", 3: "dr_R", 4: "dr_T", 5: "dr_I",
      16: "fl_CF", 17: "fl_CN", 18: "fl_JF", 19: "fl_JN", 21: "fl_F"}


def kind(ea):
    fl = ida_bytes.get_flags(ea)
    return "code" if ida_bytes.is_code(fl) else ("data" if ida_bytes.is_data(fl) else ("tail" if ida_bytes.is_tail(fl) else "unk"))


def fname(ea):
    f = ida_funcs.get_func(ea)
    return ("%06X" % f.start_ea) if f else "-"


def main():
    ida_auto.auto_wait()
    chk = ["addr\toracle_size\tida_kind\tida_size\tsize_match\tida_func\tida_text\toracle_text\tbytes"]
    n = ok = 0
    with open(os.path.join(W, "ida_req.tsv"), encoding="utf-8") as f:
        for ln in f:
            p = ln.rstrip("\n").split("\t")
            if len(p) < 4:
                continue
            ea = int(p[0], 16); osz = int(p[1])
            k = kind(ea); sz = ida_bytes.get_item_size(ea) if k == "code" else 0
            txt = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
            m = (k == "code" and sz == osz) or (p[2].startswith(".word") and k != "code")
            n += 1; ok += 1 if m else 0
            chk.append("%06X\t%d\t%s\t%d\t%s\t%s\t%s\t%s\t%s" % (ea, osz, k, sz, "yes" if m else "NO", fname(ea), txt, p[2], p[3]))
    chk.insert(0, "# instructions compared: %d ; size/kind match: %d" % (n, ok))
    targets = [0x1109C + 0x44 * i for i in range(60)] + [0x12590, 0x1276C, 0x12948, 0x12CBC, 0x147D4, 0x14818, 0x1485C,
               0x02ADD0, 0x02BA86, 0x061C5A, 0x0669E0, 0x011038, 0x01079E, 0x010CC4, 0x010EB8, 0x010EF0, 0x010FA8,
               0x02AD6A, 0x02BA60, 0x0286CA, 0x029406, 0x0291D4, 0x021A22, 0x061BE2, 0x066966]
    xr = ["target\tida_name\tfrom\ttype\tfrom_func"]
    for t in targets:
        refs = list(idautils.XrefsTo(t, 0))
        if not refs:
            xr.append("%06X\t%s\t-\t-\t-" % (t, ida_name.get_name(t)))
        for r in refs:
            xr.append("%06X\t%s\t%06X\t%s\t%s" % (t, ida_name.get_name(t), r.frm, XT.get(r.type, str(r.type)), fname(r.frm)))
    it = ["range_start\trange_end\tkinds(first 8 items: addr kind size type)"]
    for s, e in [(0x01109C, 0x01208C), (0x02ADD0, 0x02AEE4), (0x02BA86, 0x02BB9A), (0x061C5A, 0x061D6E), (0x0669E0, 0x066AF4), (0x011038, 0x011050)]:
        ea = s; items = []; kinds = {}
        while ea < e:
            sz = max(1, ida_bytes.get_item_size(ea)); k = kind(ea)
            kinds[k] = kinds.get(k, 0) + sz
            if len(items) < 8:
                items.append("%06X %s %d %s" % (ea, k, sz, idc.get_type(ea) or "-"))
            ea += sz
        it.append("%06X\t%06X\t%s | %s" % (s, e, " ".join("%s=%d" % kv for kv in sorted(kinds.items())), " ; ".join(items)))
    for fn, rows in (("ida_check.tsv", chk), ("ida_xrefs.tsv", xr), ("ida_items.tsv", it)):
        with open(os.path.join(W, fn), "w", encoding="utf-8", newline="\n") as f:
            f.write("\n".join(rows) + "\n")


try:
    main()
except Exception:
    with open(os.path.join(W, "ida_main_check.err"), "w", encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)
