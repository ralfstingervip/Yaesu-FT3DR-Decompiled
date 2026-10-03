r"""Lane 8 - SUB (RX64M / CC-RX) calling-convention census + IPC receive path.

Runs on ABI_IPC_SUB (copy of SUB_VEC, RX little-endian, base 0xFFC00000).

Output: ida\out\abi-ipc\SUB_abi.txt
  (1) prologue pushm / epilogue popm+rts / rtsd census => callee-saved set
  (2) function terminators (rts / rtsd / rte)
  (3) call addressing modes (bsr / jsr rel / jsr @rn) + most-called helpers
  (4) full disasm of the IPC receive chain + settings apply + SCI0 callbacks
  (5) handler pointer table dump at 0xFFED4050 (entry count, dummy slots)
"""
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, re, traceback, collections
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_idaapi, idautils, idc

OUT = str(_REPO / "ida/out/abi-ipc")
JOB = os.environ.get("YAESU_JOB", "ABI_IPC_SUB")

FOCUS = [
    0xFFEDC1F6,   # dequeue 300-byte slot; mirror slot[0..1] -> 0x84C8/9
    0xFFEDF1D8,   # dispatch switch on 0x8E46 (opcode high byte)
    0xFFEDF269,   # F0-family sub-dispatch on 0x8E47
    0xFFEF0385,   # memcpy slot -> 0x8E46
    0xFFEF4142,   # settings apply (shadow 0x8C4D <- 0x8E46)
    0xFFEDB131,   # SCI0 rx callback
    0xFFEDB081,   # SCI0 tx callback
    0xFFEDAB4C,   # serial init
]

def dis(ea): return idc.generate_disasm_line(ea, 0) or ""

def full(f, cap=400):
    out = []
    cur = f.start_ea
    n = 0
    while cur < f.end_ea and cur != ida_idaapi.BADADDR and n < cap:
        out.append("  %08X  %s" % (cur, dis(cur)))
        cur = ida_bytes.next_head(cur, f.end_ea); n += 1
    return out

def main():
    ida_auto.auto_wait()
    lines = ["job %s  SUB RX64M CC-RX ABI + IPC receive" % JOB]
    funcs = [ida_funcs.get_func(f) for f in idautils.Functions()]
    funcs = [f for f in funcs if f]
    lines.append("total functions: %d" % len(funcs))

    pushm = collections.Counter()   # exact pushm range string in prologue
    popm  = collections.Counter()
    term  = collections.Counter()
    rtsd  = collections.Counter()   # rtsd stack-release sizes / with regs
    n_pushm = 0
    livein = collections.Counter()  # r1..r4 read-before-write in entry block
    n_livein = 0

    TOK = re.compile(r'\br(\d{1,2})\b', re.I)
    def regidx(t):
        m = re.match(r'r(\d{1,2})$', t.lower())
        return int(m.group(1)) if m else None

    for f in funcs:
        # prologue: leading pushm
        cur = f.start_ea; head = []
        for _ in range(6):
            if cur >= f.end_ea or cur == ida_idaapi.BADADDR: break
            head.append((cur, dis(cur), idc.print_insn_mnem(cur)))
            cur = ida_bytes.next_head(cur, f.end_ea)
        got = False
        for ea,t,m in head:
            tl = t.lower()
            if m == "pushm" or tl.startswith("pushm"):
                key = tl.split(None,1)[1].strip() if " " in tl else tl
                pushm[key] += 1; got = True; break
            if m in ("bsr","jsr","rts","rtsd"):
                break
        if got: n_pushm += 1
        # epilogue: last few
        cur = f.start_ea; eas=[]
        while cur < f.end_ea and cur != ida_idaapi.BADADDR:
            eas.append(cur); cur = ida_bytes.next_head(cur, f.end_ea)
        for ea in eas[-4:]:
            m = idc.print_insn_mnem(ea); tl = dis(ea).lower()
            if m == "popm" or tl.startswith("popm"):
                key = tl.split(None,1)[1].strip() if " " in tl else tl
                popm[key] += 1
        # terminator
        if eas:
            lm = idc.print_insn_mnem(eas[-1])
            term[lm] += 1
            if lm == "rtsd":
                rtsd[dis(eas[-1]).lower()] += 1
        # live-in r1..r4 in entry block (until first branch/call)
        written=set(); seen=set(); cur=f.start_ea; n=0
        while cur < f.end_ea and cur != ida_idaapi.BADADDR and n < 30:
            t = dis(cur); m = idc.print_insn_mnem(cur)
            parts = t.split(None,1); ops = parts[1].split(";")[0] if len(parts)>1 else ""
            fields = [x.strip() for x in ops.split(",")]
            # RX: destination is usually the LAST operand
            for i,fld in enumerate(fields):
                regs = set()
                for mm in TOK.finditer(fld):
                    ri = regidx(mm.group(0))
                    if ri is not None: regs.add(ri)
                is_mem = "[" in fld or "]" in fld
                if i==len(fields)-1 and not is_mem:
                    written |= regs
                else:
                    for r in regs:
                        if r not in written and 1<=r<=4: seen.add(r)
                    if is_mem:
                        for r in regs:
                            if r not in written and 1<=r<=4: seen.add(r)
            if m.startswith(("b","j")) and m not in ("bset","bclr","bnot","btst","bmset","bmclr"):
                break
            if m in ("rts","rtsd","rte"): break
            cur = ida_bytes.next_head(cur, f.end_ea); n+=1
        for r in seen: livein[r]+=1
        if seen: n_livein+=1

    lines.append("")
    lines.append("=== (1) prologue pushm register ranges ===")
    for k,v in pushm.most_common():
        lines.append("  pushm %-14s  %5d funcs" % (k, v))
    lines.append("functions with pushm prologue: %d / %d" % (n_pushm, len(funcs)))
    lines.append("--- epilogue popm ranges ---")
    for k,v in popm.most_common():
        lines.append("  popm  %-14s  %5d funcs" % (k, v))
    lines.append("")
    lines.append("=== (2) terminators ===")
    for k,v in term.most_common(20):
        lines.append("  %-8s %5d" % (k, v))
    lines.append("--- rtsd variants (stack release + optional reg restore) ---")
    for k,v in rtsd.most_common(20):
        lines.append("  %-28s %5d" % (k, v))
    lines.append("")
    lines.append("=== live-in r1..r4 (candidate ARGUMENTS, CC-RX passes args r1-r4) ===")
    for r in (1,2,3,4):
        lines.append("  r%d : %5d funcs" % (r, livein.get(r,0)))
    lines.append("functions with >=1 live-in r1-r4: %d" % n_livein)

    # ---- (3) call modes + helper frequency ----
    mode = collections.Counter(); tgt = collections.Counter()
    for f in funcs:
        cur=f.start_ea
        while cur < f.end_ea and cur != ida_idaapi.BADADDR:
            m = idc.print_insn_mnem(cur)
            if m in ("bsr","jsr"):
                t = dis(cur).lower()
                if "[" in t or re.search(r'\br\d', t):
                    mode["%s rN (reg-indirect)" % m] += 1
                else:
                    mode["%s label (pc-rel/abs)" % m] += 1
                    v = idc.get_operand_value(cur,0)
                    if v and v != ida_idaapi.BADADDR: tgt[v]+=1
            cur = ida_bytes.next_head(cur, f.end_ea)
    lines.append("")
    lines.append("=== (3) call addressing modes ===")
    for k,v in mode.most_common():
        lines.append("  %-30s %6d" % (k,v))
    lines.append("--- most-called targets (candidate CC-RX runtime helpers) ---")
    for ea,cnt in tgt.most_common(30):
        lines.append("  %08X  %5d  %s" % (ea, cnt, idc.get_name(ea) or ""))
    lines.append("--- disasm of top 8 helpers ---")
    for ea,cnt in tgt.most_common(8):
        f = ida_funcs.get_func(ea)
        lines.append("; ---- %08X (%d callers) %s ----" % (ea, cnt, idc.get_name(ea) or ""))
        if f:
            lines += full(f, cap=40)
        lines.append("")

    # ---- (4) IPC receive chain ----
    lines.append("=== (4) IPC receive chain ===")
    for ea in FOCUS:
        f = ida_funcs.get_func(ea)
        if not f:
            ida_ua.create_insn(ea); ida_auto.auto_wait(); f = ida_funcs.get_func(ea)
        lines.append("; ==== %08X  %s ====" % (ea, idc.get_name(ea) or ""))
        if f:
            lines += full(f, cap=500)
        else:
            lines.append("  (no function; linear 80)")
            c=ea
            for _ in range(80):
                lines.append("  %08X  %s" % (c, dis(c)))
                c = ida_bytes.next_head(c, ea+0x1000)
        lines.append("")

    # ---- (5) handler pointer table 0xFFED4050 ----
    lines.append("=== (5) handler pointer table at 0xFFED4050 (little-endian dwords) ===")
    base = 0xFFED4050
    vals = []
    for i in range(64):
        v = ida_bytes.get_dword(base + i*4)
        vals.append(v)
    # detect the dominant (dummy) value
    freq = collections.Counter(vals)
    dummy = freq.most_common(1)[0][0]
    lines.append("  most-common (dummy/default?) target: %08X x%d" % (dummy, freq[dummy]))
    for i,v in enumerate(vals):
        nm = idc.get_name(v) or ""
        flag = "  <== dummy" if v == dummy else ""
        lines.append("  [%2d] %08X -> %08X  %s%s" % (i, base+i*4, v, nm, flag))

    with open(os.path.join(OUT, "SUB_abi.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(lines) + "\n")

try:
    main(); idc.qexit(0)
except Exception:
    with open(os.path.join(OUT, "SUB_abi_TRACEBACK.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    idc.qexit(1)
