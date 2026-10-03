# PC_L5: for every write of key-event byte, dump preceding instructions
import os, idautils, idc, ida_bytes, ida_auto
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "ida", "out", "pc")
ida_auto.auto_wait()
res=[]
for a in [0xFFFFA9ED, 0xFFFFA9F1]:
    for x in idautils.XrefsTo(a,0):
        if x.type != 2: continue
        prev=[]; cur=x.frm
        for _ in range(4):
            cur=idc.prev_head(cur); prev.append("    %06X %s" % (cur, idc.generate_disasm_line(cur,0)))
        res.append("---- %06X write %06X in %s: %s" % (x.frm, a, idc.get_func_name(x.frm), idc.generate_disasm_line(x.frm,0)))
        res += prev[::-1]
open(os.path.join(OUT,"_l5_writes.txt"),"w",encoding="utf-8").write("\n".join(res)+"\n")
idc.qexit(0)
