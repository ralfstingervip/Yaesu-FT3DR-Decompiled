from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, struct, traceback
OUT = str(_REPO / "ida/out/sub-layout")
def esc(t): return (t or "").replace("\t"," ").replace("\r"," ").replace("\n"," ")
def main():
    import ida_bytes, ida_funcs, idc, ida_auto
    ida_auto.auto_wait()
    with open(os.path.join(OUT, "font_blocks.txt"), "w", encoding="utf-8", newline="\n") as h:
        h.write("=== font-block table at 0xFFED4644 (8 x 12 bytes) ===\n")
        for i in range(10):
            a = 0xFFED4644 + i*12
            raw = ida_bytes.get_bytes(a, 12)
            if not raw or len(raw)!=12: h.write("  rec %d @%08X unreadable\n"%(i,a)); continue
            f0,f2,p4,p8 = struct.unpack_from("<HHII", raw, 0)
            b1 = raw[1]
            h.write("  rec %d @%08X  raw=%s  u16[0]=%04X u16[2]=%04X ptr+4=%08X ptr+8=%08X  (byte+1=%02X)\n"
                    % (i,a,raw.hex(),f0,f2,p4,p8,b1))
        # disassemble sub_FFEE5269
        for ea in (0xFFEE5269,):
            fn = ida_funcs.get_func(ea)
            h.write("\n=== %08X %s ===\n"%(ea, idc.get_func_name(ea) or ""))
            if fn:
                a=fn.start_ea
                while a<fn.end_ea and a!=idc.BADADDR:
                    r=(ida_bytes.get_bytes(a,min(idc.get_item_size(a),8)) or b"").hex()
                    h.write("  %08X  %-16s %s\n"%(a,r,esc(idc.generate_disasm_line(a,0))))
                    a=idc.next_head(a,fn.end_ea)
        # readers of the block table 0xFFED4644 (immediate loads)
        import idautils, ida_ua
        h.write("\n=== immediate loaders of 0xFFED4644 (font-block table) ===\n")
        for start in idautils.Functions():
            for iea in idautils.FuncItems(start):
                insn=ida_ua.insn_t()
                if ida_ua.decode_insn(insn,iea)<=0: continue
                for i in range(6):
                    op=insn.ops[i]
                    if op.type==0: break
                    if op.type==ida_ua.o_imm and (op.value&0xFFFFFFFF)==0xFFED4644:
                        h.write("  %08X (func %08X)  %s\n"%(iea,start,esc(idc.generate_disasm_line(iea,0))))
if True:
    os.makedirs(OUT, exist_ok=True)
    try: main()
    except Exception:
        with open(os.path.join(OUT, "blocks_tb.txt"), "w", encoding="utf-8", newline="\n") as _h:
            _h.write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
