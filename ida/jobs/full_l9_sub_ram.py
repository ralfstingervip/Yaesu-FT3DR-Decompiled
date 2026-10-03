import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import idaapi, idautils, idc, ida_auto, ida_bytes, ida_ua, ida_funcs, ida_segment
import traceback

OUT = str(_REPO / "ida/out/extension")
LOG = str(_REPO / "ida/log/jobs/FREESPACE_SUB")
import os
for d in (OUT, LOG):
    try: os.makedirs(d)
    except: pass

def log(fn, s):
    with open(os.path.join(LOG, fn), "w", encoding="utf-8") as f:
        f.write(s)

try:
    ida_auto.auto_wait()
    lines = []
    RAM_LO, RAM_HI = 0x00000000, 0x0007FFFF

    # 1) reset entry: follow reset vector at 0xFFFFFFFC (LE dword)
    rv = ida_bytes.get_dword(0xFFFFFFFC)
    lines.append("reset vector @0xFFFFFFFC = 0x%08X" % rv)
    ea = rv
    dis = []
    for _ in range(120):
        d = idc.generate_disasm_line(ea, 0)
        dis.append("0x%08X  %s" % (ea, d))
        nxt = idc.next_head(ea)
        if nxt <= ea or nxt == idc.BADADDR: break
        ea = nxt
        if ea - rv > 0x400: break
    log("reset_disasm.txt", "\n".join(dis))

    # 2) scan all instructions for RAM store targets, with simple const-prop
    max_abs = 0; max_abs_site = 0; max_abs_line = ""
    max_cp = 0;  max_cp_site = 0;  max_cp_line = ""
    abs_targets = {}
    cp_targets = {}

    def is_store_mnem(m):
        return m.startswith("mov")

    for f in idautils.Functions():
        regs = {}  # reg index -> imm value (RAM candidate)
        for ea in idautils.FuncItems(f):
            insn = ida_ua.insn_t()
            if ida_ua.decode_insn(insn, ea) == 0:
                regs = {}; continue
            mn = insn.get_canon_mnem()
            line = idc.generate_disasm_line(ea, 0)
            ops = insn.ops
            # track MOV.L #imm, Rn
            if mn.lower().startswith("mov") and ops[0].type == idaapi.o_imm and ops[1].type == idaapi.o_reg:
                v = ops[0].value & 0xFFFFFFFF
                regs[ops[1].reg] = v
                continue
            # absolute store: dst operand is o_mem
            # RX: store when a memory operand is operand 1 (dst) for mov
            for i in range(2):
                op = ops[i]
                if op.type == idaapi.o_mem:
                    addr = op.addr & 0xFFFFFFFF
                    # only count as store if it's the destination (op index 1 typical for mov src,dst? RX uses dst-last)
                    # record either way but only RAM range
                    if RAM_LO <= addr <= RAM_HI:
                        abs_targets[addr] = abs_targets.get(addr,0)+1
                        if addr > max_abs:
                            max_abs = addr; max_abs_site = ea; max_abs_line = line
                # displacement store [Rn] or disp[Rn]
                if op.type == idaapi.o_phrase or op.type == idaapi.o_displ:
                    rn = op.reg
                    if rn in regs:
                        base = regs[rn]
                        disp = op.value if op.type == idaapi.o_displ else 0
                        addr = (base + disp) & 0xFFFFFFFF
                        if RAM_LO <= addr <= RAM_HI:
                            # only treat as store when memory op is dst (op index 1 for 2-op)
                            if i == 1 or (insn.ops[1].type in (idaapi.o_void,)):
                                cp_targets[addr] = cp_targets.get(addr,0)+1
                                if addr > max_cp:
                                    max_cp = addr; max_cp_site = ea; max_cp_line = line
            # invalidate reg if it's written by a non-imm mov / arith (best effort)
            if ops[1].type == idaapi.o_reg and not (mn.lower().startswith("mov") and ops[0].type==idaapi.o_imm):
                regs.pop(ops[1].reg, None)

    lines.append("highest ABS store/access RAM target: 0x%08X at 0x%08X  %s" % (max_abs, max_abs_site, max_abs_line))
    lines.append("highest CONST-PROP RAM target:       0x%08X at 0x%08X  %s" % (max_cp, max_cp_site, max_cp_line))
    lines.append("distinct abs RAM targets: %d ; distinct cp RAM targets: %d" % (len(abs_targets), len(cp_targets)))

    allt = sorted(set(list(abs_targets.keys())+list(cp_targets.keys())))
    with open(os.path.join(OUT,"space-sub-ram.tsv"),"w",encoding="utf-8") as f:
        f.write("addr\tabs_hits\tcp_hits\n")
        for a in allt:
            f.write("0x%08X\t%d\t%d\n"%(a, abs_targets.get(a,0), cp_targets.get(a,0)))
    lines.append("top 15 RAM targets:")
    for a in allt[-15:]:
        lines.append("  0x%08X abs=%d cp=%d"%(a,abs_targets.get(a,0),cp_targets.get(a,0)))

    log("ram_summary.txt", "\n".join(lines))
except Exception:
    log("traceback.txt", traceback.format_exc())
idc.qexit(0)
