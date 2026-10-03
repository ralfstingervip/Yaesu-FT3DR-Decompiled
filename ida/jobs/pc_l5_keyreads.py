# PC_L5: for every read of the key-event byte(s), dump following instructions
import os, idautils, idc, ida_bytes, ida_auto, ida_funcs
OUT = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "ida", "out", "pc")
ida_auto.auto_wait()
addrs = [int(x,16) for x in os.environ.get("L5_ADDRS","FFFFA9ED").split(",")]
N = int(os.environ.get("L5_N","14"))
res=[]
for a in addrs:
    for x in idautils.XrefsTo(a,0):
        if x.type != 3: continue
        res.append("---- %06X read of %06X in %s" % (x.frm, a, idc.get_func_name(x.frm)))
        cur=x.frm
        for _ in range(N):
            sz=ida_bytes.get_item_size(cur) or 1
            res.append("  %06X  %s" % (cur, idc.generate_disasm_line(cur,0)))
            cur+=sz
open(os.path.join(OUT, os.environ.get("L5_OUTF","_l5_keyreads.txt")),"w",encoding="utf-8").write("\n".join(res)+"\n")
idc.qexit(0)
