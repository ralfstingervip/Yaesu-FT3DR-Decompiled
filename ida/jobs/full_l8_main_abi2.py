r"""Lane 8 - MAIN H8S argument/return register census (empirical).

Determines, across the whole function set, which of er0..er6 are used to
PASS arguments (read before written in the entry block => live-in) and which
carry the RETURN value (register written last before rts, and register read
by callers immediately after the call).

Output: ida\out\abi-ipc\MAIN_abi2.txt
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback, collections
import ida_auto, ida_bytes, ida_funcs, ida_idaapi, idautils, idc

OUT = str(_REPO / "ida/out/abi-ipc")
JOB = os.environ.get("YAESU_JOB", "ABI_IPC_MAIN")

# map any sub-register token to its ER index
def norm_reg(tok):
    tok = tok.lower()
    m = re.match(r'^er([0-7])$', tok)
    if m: return int(m.group(1))
    m = re.match(r'^e([0-7])$', tok)       # upper word of ERn
    if m: return int(m.group(1))
    m = re.match(r'^r([0-7])[lh]?$', tok)  # r0/r0l/r0h
    if m: return int(m.group(1))
    return None

TOK = re.compile(r'\b(er[0-7]|e[0-7]|r[0-7][lh]?|r[0-7])\b', re.I)

def dis(ea):
    return idc.generate_disasm_line(ea, 0) or ""

def operands(ea):
    """return (dest_regs set, src_regs set) approx from disasm text.
    H8S dest is the LAST operand; source operands are earlier."""
    t = dis(ea)
    # strip mnemonic
    parts = t.split(None, 1)
    if len(parts) < 2:
        return set(), set(), parts[0] if parts else ""
    mnem = parts[0]
    ops = parts[1]
    # comment strip
    ops = ops.split(";")[0]
    fields = [f.strip() for f in ops.split(",")]
    dst = set(); src = set()
    if not fields:
        return dst, src, mnem
    # last field = destination (for most H8S ops); others = source
    for i, f in enumerate(fields):
        regs = set()
        for m in TOK.finditer(f):
            idx = norm_reg(m.group(1))
            if idx is not None and idx != 7:
                regs.add(idx)
        # a memory operand like @er5+ reads er5 (address) - treat as src use of pointer
        is_mem = "@" in f
        if i == len(fields) - 1 and not is_mem:
            dst |= regs
        else:
            src |= regs
        # pointer registers in memory operands are always reads (uses)
        if is_mem:
            src |= regs
    return dst, src, mnem

def entry_block_insns(f, maxn=40):
    """linear walk until first control-flow change (branch/jsr/rts)."""
    out = []
    cur = f.start_ea
    while cur < f.end_ea and cur != ida_idaapi.BADADDR and len(out) < maxn:
        mnem = idc.print_insn_mnem(cur)
        out.append(cur)
        if mnem.startswith(("b", "j", "rt")) and mnem not in ("bset","bclr","bst","bld","bist","btst","bnot"):
            break
        cur = ida_bytes.next_head(cur, f.end_ea)
    return out

def main():
    ida_auto.auto_wait()
    lines = ["job %s  MAIN H8S arg/return register census" % JOB]
    funcs = [f for f in idautils.Functions()]

    livein = collections.Counter()   # regs read-before-write in entry block
    n_livein_any = 0
    ret_reg = collections.Counter()  # last written reg before rts (whole func)
    n_funcs = 0

    for fea in funcs:
        f = ida_funcs.get_func(fea)
        if not f:
            continue
        n_funcs += 1
        written = set()
        seen_livein = set()
        for ea in entry_block_insns(f):
            dst, src, mnem = operands(ea)
            for r in src:
                if r not in written:
                    seen_livein.add(r)
            written |= dst
        for r in seen_livein:
            livein[r] += 1
        if seen_livein:
            n_livein_any += 1
        # return register: scan whole function, remember last dst reg before each rts
        last_dst = None
        cur = f.start_ea
        while cur < f.end_ea and cur != ida_idaapi.BADADDR:
            mnem = idc.print_insn_mnem(cur)
            if mnem == "rts":
                if last_dst is not None:
                    ret_reg[last_dst] += 1
            else:
                dst, src, m2 = operands(cur)
                if dst:
                    # prefer the lowest-index? keep the set's min for determinism
                    last_dst = min(dst)
            cur = ida_bytes.next_head(cur, f.end_ea)

    lines.append("functions analysed: %d" % n_funcs)
    lines.append("")
    lines.append("=== live-in registers in entry block (candidate ARGUMENTS) ===")
    lines.append("(count = # functions where ERn is read before being written)")
    for r in range(7):
        lines.append("  er%d : %5d funcs" % (r, livein.get(r,0)))
    lines.append("functions with >=1 live-in reg: %d / %d" % (n_livein_any, n_funcs))
    lines.append("")
    lines.append("=== last-written register before rts (candidate RETURN) ===")
    for r in range(7):
        lines.append("  er%d : %5d funcs" % (r, ret_reg.get(r,0)))

    # ---- how callers consume the return of a few frequently-called helpers ----
    lines.append("")
    lines.append("=== caller consumption of helper returns (first reg-read after call) ===")
    helpers = [0x1C82E, 0x3F5EE, 0x3F5B2, 0x976A, 0x3FFA0]
    for h in helpers:
        lines.append("; --- callers of %08X ---" % h)
        cons = collections.Counter()
        shown = 0
        for xr in idautils.XrefsTo(h, 0):
            frm = xr.frm
            if idc.print_insn_mnem(frm) not in ("jsr","bsr"):
                continue
            # look at up to 4 insns after the call for first reg read
            cur = ida_bytes.next_head(frm, frm + 0x40)
            found = None
            for _ in range(4):
                if cur == ida_idaapi.BADADDR: break
                dst, src, m2 = operands(cur)
                if src:
                    found = min(src); break
                if dst:
                    found = ("wrote", min(dst)); break
                cur = ida_bytes.next_head(cur, cur + 0x40)
            if isinstance(found, int):
                cons["er%d read" % found] += 1
            elif found:
                cons["er%d written-first" % found[1]] += 1
            else:
                cons["none"] += 1
            if shown < 3:
                lines.append("    %08X  next: %s" % (frm, dis(ida_bytes.next_head(frm, frm+0x40))))
                shown += 1
        for k, v in cons.most_common():
            lines.append("    consume %-22s %d" % (k, v))

    with open(os.path.join(OUT, "MAIN_abi2.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines) + "\n")

try:
    main()
    idc.qexit(0)
except Exception:
    with open(os.path.join(OUT, "MAIN_abi2_TRACEBACK.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)
