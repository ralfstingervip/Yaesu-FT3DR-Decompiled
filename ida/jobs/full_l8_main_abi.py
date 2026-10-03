r"""Lane 8 (ABI + IPC) - MAIN / H8S calling-convention census + IPC send path.

Runs on ABI_IPC_MAIN (copy of MAIN_FULL, H8S big-endian, base 0).

Produces ida\out\abi-ipc\MAIN_abi.txt with:
  (1) prologue/epilogue register census across all functions
      (stm.l / ldm.l / push / pop / mov.l @-sp patterns) => caller vs callee saved
  (2) terminator census (rts / rte / trapa) and stack-frame setup (sub.w #imm,sp / add #imm,sp)
  (3) call-site addressing-mode census (jsr @aa:24 / jsr @ern / jsr @@aa:8 / bsr)
  (4) most-frequently-called targets (candidate runtime helpers) with disasm
  (5) full disasm of the IPC send builder sub_B6B6 and requested routines
  (6) xrefs to sub_B6B6 with a short caller context window (arg-register setup)
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback, collections
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_idaapi, idautils, idc

OUT = str(_REPO / "ida/out/abi-ipc")
JOB = os.environ.get("YAESU_JOB", "ABI_IPC_MAIN")

FOCUS = [
    0xB6B6,   # IPC frame builder (send one frame to SUB)
    0x8532,   # status-frame writer (opcode/len into 0xFF3D7x)
    0x5E9E2,  # progress builder that calls sub_8532
    0x482D4,  # DMAC ch0 tx of the frame to SCI-D
    0x446BE,  # SCI-D init
    0x20FA,   # hardware init
    0x2092,   # reset
]

def dis(ea):
    return idc.generate_disasm_line(ea, 0) or ""

def func_insns(f, limit=None):
    out = []
    cur = f.start_ea
    while cur < f.end_ea and cur != ida_idaapi.BADADDR:
        out.append((cur, dis(cur), idc.print_insn_mnem(cur)))
        if limit and len(out) >= limit:
            break
        cur = ida_bytes.next_head(cur, f.end_ea)
    return out

def last_insns(f, n):
    eas = []
    cur = f.start_ea
    while cur < f.end_ea and cur != ida_idaapi.BADADDR:
        eas.append(cur)
        cur = ida_bytes.next_head(cur, f.end_ea)
    return [(e, dis(e), idc.print_insn_mnem(e)) for e in eas[-n:]]

REG_RE = re.compile(r'\b(er[0-7]|r[0-7][lh]?)\b', re.I)

def regs_in(text):
    return set(m.group(1).lower() for m in REG_RE.finditer(text))

def main():
    ida_auto.auto_wait()
    lines = ["job %s  MAIN H8S ABI+IPC census" % JOB]

    funcs = list(idautils.Functions())
    lines.append("total functions: %d" % len(funcs))

    # ---- (1)/(2) prologue / epilogue / terminator census -------------------
    prologue_stm = collections.Counter()   # exact stm register-range string
    prologue_push = collections.Counter()  # single-reg push targets
    epilogue_ldm = collections.Counter()
    terminator = collections.Counter()
    frame_setup = collections.Counter()     # sub.w/#imm,sp or add #-imm,sp count
    saved_reg = collections.Counter()       # any reg saved in prologue (stm+push)
    n_with_prologue = 0
    n_leaf = 0   # no jsr/bsr in body

    for fea in funcs:
        f = ida_funcs.get_func(fea)
        if not f:
            continue
        head = func_insns(f, limit=6)
        tail = last_insns(f, 6)
        # prologue: leading stm.l / push / mov.l Rn,@-sp / sub.*,sp
        got_pro = False
        for ea, t, m in head:
            tl = t.lower()
            if m == "stm" or "stm.l" in tl or tl.startswith("stm"):
                key = tl.split(None, 1)[1].split(",")[0].strip() if " " in tl else tl
                prologue_stm[key] += 1
                for r in regs_in(key):
                    saved_reg[r] += 1
                got_pro = True
            elif m == "push" or (m == "mov" and "@-sp" in tl):
                # capture reg being pushed
                rs = regs_in(tl.split("@-sp")[0]) if "@-sp" in tl else regs_in(tl)
                for r in rs:
                    prologue_push[r] += 1
                    saved_reg[r] += 1
                got_pro = True
            elif m in ("sub", "add") and tl.endswith(",sp"):
                frame_setup[m] += 1
            elif m in ("jsr", "bsr", "rts", "rte"):
                break
        if got_pro:
            n_with_prologue += 1
        # epilogue ldm
        for ea, t, m in tail:
            tl = t.lower()
            if m == "ldm" or tl.startswith("ldm"):
                key = tl.split(None, 1)[1].split("@sp+,")[-1].strip() if "@sp+," in tl else tl
                epilogue_ldm[key] += 1
        # terminator
        last_m = tail[-1][2] if tail else "?"
        terminator[last_m] += 1
        # leaf?
        is_leaf = True
        for ea, t, m in func_insns(f):
            if m in ("jsr", "bsr"):
                is_leaf = False
                break
        if is_leaf:
            n_leaf += 1

    lines.append("")
    lines.append("=== (1) PROLOGUE register-save patterns (leading stm.l) ===")
    for k, v in prologue_stm.most_common():
        lines.append("  stm  %-24s  %5d funcs" % (k, v))
    lines.append("--- single-register push in prologue ---")
    for k, v in prologue_push.most_common():
        lines.append("  push %-6s  %5d funcs" % (k, v))
    lines.append("--- per-register save frequency (stm+push, prologue) ---")
    for r in ("er0","er1","er2","er3","er4","er5","er6","er7"):
        lines.append("  %-4s saved-in-prologue: %5d" % (r, saved_reg.get(r,0)))
    lines.append("functions with a detected register-save prologue: %d / %d" % (n_with_prologue, len(funcs)))
    lines.append("leaf functions (no jsr/bsr): %d" % n_leaf)

    lines.append("")
    lines.append("=== (2) EPILOGUE ldm.l patterns ===")
    for k, v in epilogue_ldm.most_common():
        lines.append("  ldm  %-24s  %5d funcs" % (k, v))
    lines.append("--- function terminators ---")
    for k, v in terminator.most_common():
        lines.append("  %-6s  %5d" % (k, v))
    lines.append("--- explicit sp frame adjust in prologue ---")
    for k, v in frame_setup.most_common():
        lines.append("  %-6s ...,sp  %5d" % (k, v))

    # ---- (3) call addressing-mode census + (4) call frequency --------------
    mode = collections.Counter()
    tgt = collections.Counter()
    for fea in funcs:
        f = ida_funcs.get_func(fea)
        if not f:
            continue
        cur = f.start_ea
        while cur < f.end_ea and cur != ida_idaapi.BADADDR:
            m = idc.print_insn_mnem(cur)
            if m in ("jsr", "bsr"):
                t = dis(cur).lower()
                if "@@" in t:
                    mode["jsr @@aa:8 (mem-indirect vector)"] += 1
                elif "@er" in t or re.search(r'@r[0-7]', t):
                    mode["jsr @ern (reg-indirect)"] += 1
                elif m == "bsr":
                    mode["bsr (pc-relative)"] += 1
                else:
                    mode["jsr @aa (absolute)"] += 1
                    v = idc.get_operand_value(cur, 0)
                    if v and v != ida_idaapi.BADADDR:
                        tgt[v] += 1
                if m == "bsr":
                    v = idc.get_operand_value(cur, 0)
                    if v and v != ida_idaapi.BADADDR:
                        tgt[v] += 1
            cur = ida_bytes.next_head(cur, f.end_ea)

    lines.append("")
    lines.append("=== (3) call-site addressing modes (over all functions) ===")
    for k, v in mode.most_common():
        lines.append("  %-34s %6d" % (k, v))

    lines.append("")
    lines.append("=== (4) most-called targets (candidate runtime helpers) ===")
    for ea, cnt in tgt.most_common(40):
        nm = idc.get_name(ea) or ""
        lines.append("  %08X  %5d calls   %s" % (ea, cnt, nm))
    lines.append("--- disasm of top 12 call targets ---")
    for ea, cnt in tgt.most_common(12):
        f = ida_funcs.get_func(ea)
        lines.append("; ---- %08X (%d callers) %s ----" % (ea, cnt, idc.get_name(ea) or ""))
        if f:
            for e, t, m in func_insns(f):
                lines.append("  %08X  %s" % (e, t))
        else:
            c = ea
            for _ in range(24):
                lines.append("  %08X  %s" % (c, dis(c)))
                c = ida_bytes.next_head(c, ea + 0x400)
        lines.append("")

    # ---- (5) focus routines full disasm ------------------------------------
    lines.append("=== (5) focus routines ===")
    for ea in FOCUS:
        f = ida_funcs.get_func(ea)
        if not f:
            ida_ua.create_insn(ea); ida_auto.auto_wait()
            f = ida_funcs.get_func(ea)
        lines.append("; ==== %08X  %s ====" % (ea, idc.get_name(ea) or ""))
        if f:
            for e, t, m in func_insns(f):
                lines.append("  %08X  %s" % (e, t))
        else:
            lines.append("  (no function; linear 60)")
            c = ea
            for _ in range(60):
                lines.append("  %08X  %s" % (c, dis(c)))
                c = ida_bytes.next_head(c, ea + 0x800)
        lines.append("")

    # ---- (6) callers of sub_B6B6 with arg-setup context --------------------
    lines.append("=== (6) callers of IPC builder 0x0000B6B6 (arg registers) ===")
    n = 0
    for xr in idautils.XrefsTo(0xB6B6, 0):
        frm = xr.frm
        m = idc.print_insn_mnem(frm)
        if m not in ("jsr", "bsr"):
            continue
        n += 1
        ff = ida_funcs.get_func(frm)
        fn = idc.get_func_name(frm) or "?"
        lines.append("; caller #%d %08X in %s" % (n, frm, fn))
        # 12 insns before the call
        eas = []
        cur = ff.start_ea if ff else frm - 0x40
        while cur <= frm and cur != ida_idaapi.BADADDR:
            eas.append(cur)
            cur = ida_bytes.next_head(cur, frm + 2)
        for e in eas[-14:]:
            lines.append("    %08X  %s" % (e, dis(e)))
        lines.append("")
    lines.append("; (%d call sites)" % n)

    with open(os.path.join(OUT, "MAIN_abi.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines) + "\n")

try:
    main()
    idc.qexit(0)
except Exception:
    with open(os.path.join(OUT, "MAIN_abi_TRACEBACK.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)
