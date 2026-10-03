#  K9 lane: DATA-jack CAT/clone opcode dump on MAIN (H8SX).
#  Owner-side static analysis only. Dumps disassembly + raw bytes for the
#  frame engine, dispatcher, per-opcode handlers, the 0x6B91A DMA path, the
#  0x6B7DC reset path, and the clone/BACKUP EEPROM streamers.
import ida_auto, ida_bytes, ida_funcs, ida_ua, ida_name, ida_xref, idc, idautils
import traceback

OUT = "local-temp"

def log(f, s):
    f.write(s + "\n")

def force_code(ea, end):
    a = ea
    while a < end:
        fl = ida_bytes.get_flags(a)
        if not ida_bytes.is_code(fl):
            ida_ua.create_insn(a)
        nxt = idc.next_head(a, end)
        if nxt <= a:
            a += 1
        else:
            a = nxt

def disasm_range(f, start, end, label):
    log(f, "\n==== %s  %06X..%06X ====" % (label, start, end))
    ea = start
    while ea < end and ea != idc.BADADDR:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            dis = idc.generate_disasm_line(ea, 0) or ""
            sz = idc.get_item_size(ea)
            raw = " ".join("%02x" % ida_bytes.get_byte(ea+i) for i in range(min(sz,10)))
            log(f, "%06X  %-28s  %s" % (ea, raw, dis))
        else:
            sz = idc.get_item_size(ea)
            if sz < 1: sz = 1
            raw = " ".join("%02x" % ida_bytes.get_byte(ea+i) for i in range(min(sz,16)))
            dis = idc.generate_disasm_line(ea, 0) or ""
            log(f, "%06X  %-28s  %s" % (ea, raw, dis))
        nxt = idc.next_head(ea, end)
        if nxt <= ea:
            ea += 1
        else:
            ea = nxt

def dump_bytes(f, start, n, label):
    log(f, "\n---- bytes %s %06X (%d) ----" % (label, start, n))
    row = []
    for i in range(n):
        if i % 16 == 0 and row:
            log(f, "%06X  %s" % (start+i-16, " ".join(row)))
            row = []
        row.append("%02x" % ida_bytes.get_byte(start+i))
    if row:
        log(f, "%06X  %s" % (start+ (n//16)*16, " ".join(row)))

def xrefs_to(f, ea, label):
    log(f, "\n---- xrefs to %s %06X ----" % (label, ea))
    for x in idautils.XrefsTo(ea, 0):
        log(f, "  from %06X  %s" % (x.frm, idc.generate_disasm_line(x.frm,0) or ""))

try:
    # Force-code the whole command region so nothing is left as data gaps.
    for (s,e) in [(0x6B700,0x6C800),(0x737FC,0x74000),(0x73500,0x737FC),
                  (0x737C8,0x73820),(0x25D72,0x26200),(0x2611A,0x26300),
                  (0x25EAE,0x25D72+2)]:
        force_code(s,e)
    ida_auto.auto_wait()

    with open(OUT + r"\frame_engine.lst","w",encoding="utf-8",newline="\n") as f:
        disasm_range(f, 0x6B700, 0x6B9AC, "frame RX state machine sub_6B700..")
        disasm_range(f, 0x6B9AC, 0x6BA46, "gate handler sub_6B9AC")
        disasm_range(f, 0x6BA46, 0x6BAC8, "data-phase handler sub_6BA46")
        disasm_range(f, 0x6BAC8, 0x6BB4C, "dispatcher sub_6BAC8 / sub_6BAD6")
        disasm_range(f, 0x6BB4C, 0x6BD3E, "auto senders P/status + jump table 0x6BD26")
        xrefs_to(f, 0x6B91A, "loc_6B91A DMA path")
        xrefs_to(f, 0x6B7DC, "loc_6B7DC reset")
        xrefs_to(f, 0x6B700, "sub_6B700 install")
        xrefs_to(f, 0x6B73A, "sub_6B73A install2")

    with open(OUT + r"\dma_reset.lst","w",encoding="utf-8",newline="\n") as f:
        disasm_range(f, 0x6B7A0, 0x6B834, "timeout + reset region (0x6B7B8..0x6B7EE)")
        disasm_range(f, 0x6B8D0, 0x6B9AC, "finalizer + DMA push 0x6B91A..")
        disasm_range(f, 0x6B986, 0x6B9AC, "DMA completion ISR sub_6B986")

    with open(OUT + r"\handlers.lst","w",encoding="utf-8",newline="\n") as f:
        # builders / handlers named in prior docs
        for (s,e,l) in [(0x6B77E,0x6B7A0,"sub_6B77E frame builder"),
                        (0x6BB6E,0x6BD26,"sub_6BB6E C/P status builder"),
                        (0x6C05C,0x6C19A,"sub_6C05C G builder"),
                        (0x6C19A,0x6C344,"sub_6C19A H builder"),
                        (0x6C344,0x6C539,"sub_6C344 R read handler"),
                        (0x6C539,0x6C700,"template block 0x6C539 (DATA)"),
                        (0x6C686,0x6C7A0,"sub_6C686 F handler"),
                        (0x6CB40,0x6CD00,"hex decode/encode + finalizer 0x6CC76"),
                        (0x6BD3E,0x6BE00,"V ident builder sub_6BD3E"),
                        (0x6B9FE,0x6BA46,"M handler entry 0x6B9FE")]:
            disasm_range(f, s, e, l)
        dump_bytes(f, 0x6C539, 0x200, "template block raw 0x6C539")

    with open(OUT + r"\clone.lst","w",encoding="utf-8",newline="\n") as f:
        disasm_range(f, 0x737FC, 0x73900, "sub_737FC clone/backup send walker")
        disasm_range(f, 0x7358E, 0x73700, "sub_7358E clone receive")
        disasm_range(f, 0x737C8, 0x7360E, "sub_737C8 ID/region check")
        disasm_range(f, 0x734BE, 0x73500, "sub_734BE const 2 / sub_7357A")
        xrefs_to(f, 0x737FC, "sub_737FC")
        xrefs_to(f, 0x7358E, "sub_7358E")
        xrefs_to(f, 0x737C8, "sub_737C8")

    with open(OUT + r"\m_handler.lst","w",encoding="utf-8",newline="\n") as f:
        disasm_range(f, 0x25EAE, 0x26120, "sub_25EAE M mode-A parser")
        disasm_range(f, 0x2611A, 0x26220, "sub_2611A M mode-B parser")
        disasm_range(f, 0x25D72, 0x25EAE, "sub_25D72 apply VFO")

    # also dump sub_6B77E build / checksum accumulator context and the
    # length-store site 0x6B844 to confirm bounds (overrun question)
    with open(OUT + r"\assembler.lst","w",encoding="utf-8",newline="\n") as f:
        disasm_range(f, 0x6B800, 0x6B8D0, "assembler drain / store loop (len bound @0x6B844)")

    with open(OUT + r"\done.txt","w",encoding="utf-8") as f:
        f.write("ok\n")
except Exception:
    with open(OUT + r"\traceback.txt","w",encoding="utf-8") as f:
        f.write(traceback.format_exc())
idc.qexit(0)
