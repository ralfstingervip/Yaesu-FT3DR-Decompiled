r"""Lane 8 - MAIN: representative compiler-generated functions + precise
return-value consumption histogram (next instruction only).

Output: ida\out\abi-ipc\MAIN_abi3.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback, collections
import ida_auto, ida_bytes, ida_funcs, ida_idaapi, idautils, idc

OUT = str(_REPO / "ida/out/abi-ipc")
JOB = os.environ.get("YAESU_JOB", "ABI_IPC_MAIN")

def dis(ea): return idc.generate_disasm_line(ea, 0) or ""

def full(f):
    out = []
    cur = f.start_ea
    while cur < f.end_ea and cur != ida_idaapi.BADADDR:
        out.append("  %08X  %s" % (cur, dis(cur)))
        cur = ida_bytes.next_head(cur, f.end_ea)
    return out

def first_head_mnem_ops(f):
    return dis(f.start_ea).lower()

def main():
    ida_auto.auto_wait()
    lines = ["job %s  MAIN representative funcs + return consumption" % JOB]
    funcs = [ida_funcs.get_func(f) for f in idautils.Functions()]
    funcs = [f for f in funcs if f]

    # collect examples by prologue type
    ex_er45 = []; ex_er46 = []; ex_er03 = []
    for f in funcs:
        h = first_head_mnem_ops(f)
        if "stm.l" in h and "er4-er5" in h and len(ex_er45) < 3:
            ex_er45.append(f)
        elif "stm.l" in h and "er4-er6" in h and len(ex_er46) < 3:
            ex_er46.append(f)
        elif "stm.l" in h and "er0-er3" in h and len(ex_er03) < 4:
            # prefer small ones
            if f.end_ea - f.start_ea < 0x120:
                ex_er03.append(f)

    lines.append("")
    lines.append("=== examples: prologue stm.l er4-er5 (callee-saved save) ===")
    for f in ex_er45:
        lines.append("; ---- %s %08X-%08X ----" % (idc.get_func_name(f.start_ea), f.start_ea, f.end_ea))
        lines += full(f)
        lines.append("")
    lines.append("=== examples: prologue stm.l er4-er6 (callee-saved save) ===")
    for f in ex_er46:
        lines.append("; ---- %s %08X-%08X ----" % (idc.get_func_name(f.start_ea), f.start_ea, f.end_ea))
        lines += full(f)
        lines.append("")
    lines.append("=== examples: prologue stm.l er0-er3 (arg preservation) ===")
    for f in ex_er03:
        lines.append("; ---- %s %08X-%08X ----" % (idc.get_func_name(f.start_ea), f.start_ea, f.end_ea))
        lines += full(f)
        lines.append("")

    # precise: for every jsr/bsr site, classify the SINGLE next instruction
    RREAD = re.compile(r'\br0[lh]?\b|\ber0\b|\be0\b', re.I)
    R4READ = re.compile(r'\br4[lh]?\b|\ber4\b|\be4\b', re.I)
    cat = collections.Counter()
    er0_read = 0; er0_written = 0
    for f in funcs:
        cur = f.start_ea
        while cur < f.end_ea and cur != ida_idaapi.BADADDR:
            if idc.print_insn_mnem(cur) in ("jsr","bsr"):
                nxt = ida_bytes.next_head(cur, f.end_ea)
                if nxt != ida_idaapi.BADADDR and nxt < f.end_ea:
                    t = dis(nxt)
                    m = idc.print_insn_mnem(nxt)
                    tl = t.lower()
                    parts = tl.split(None,1)
                    ops = parts[1] if len(parts)>1 else ""
                    fields = [x.strip() for x in ops.split(";")[0].split(",")]
                    # is er0/r0 a source (read) in next insn?
                    src_fields = fields[:-1] if len(fields)>1 else []
                    dst_field = fields[-1] if fields else ""
                    r0_src = any(RREAD.search(x) for x in src_fields) or ("@" in (fields[-1] if fields else "") and RREAD.search(fields[-1]))
                    r0_dst = (not "@" in dst_field) and bool(RREAD.search(dst_field))
                    if m.startswith(("b","j")) and m not in ("bset","bclr","btst","bld","bst","bist","bnot"):
                        cat["branch-on-flags (CCR return or none)"] += 1
                    elif r0_src:
                        cat["reads R0/ER0 (return in ER0)"] += 1
                    elif r0_dst:
                        cat["overwrites R0/ER0 (return discarded/void)"] += 1
                    elif R4READ.search(ops):
                        cat["touches R4 next"] += 1
                    else:
                        cat["other"] += 1
            cur = ida_bytes.next_head(cur, f.end_ea)

    lines.append("=== return consumption: single next-instruction class over ALL call sites ===")
    tot = sum(cat.values())
    for k, v in cat.most_common():
        lines.append("  %-45s %6d  (%.1f%%)" % (k, v, 100.0*v/max(tot,1)))
    lines.append("  total call sites: %d" % tot)

    with open(os.path.join(OUT, "MAIN_abi3.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines) + "\n")

try:
    main(); idc.qexit(0)
except Exception:
    with open(os.path.join(OUT, "MAIN_abi3_TRACEBACK.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)
