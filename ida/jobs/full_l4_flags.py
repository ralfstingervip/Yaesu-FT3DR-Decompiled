from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback
OUT = str(_REPO / "ida/out/sub-window")
def main():
    import ida_bytes, ida_funcs, idc, idautils
    lines=[]
    def ch(ea):
        fl=ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl): return 'C'
        if ida_bytes.is_data(fl): return 'd'
        return '.'
    for base in (0xFFEE4000,0xFFEEE000,0xFFF08000):
        lines.append("== %08X =="%base)
        for r in range(8):
            a=base+r*32
            s=''.join(ch(a+i) for i in range(32))
            lines.append("%08X %s"%(a,s))
    # run-length histogram of undefined in band
    from collections import Counter
    hist=Counter()
    for blo,bhi in ((0xFFEDB000,0xFFF48000),(0xFFF4C000,0xFFF50000)):
        ea=blo
        while ea<bhi:
            fl=ida_bytes.get_flags(ea)
            if ida_bytes.is_code(fl) or ida_bytes.is_data(fl):
                ea+=1; continue
            rs=ea
            while ea<bhi and not ida_bytes.is_code(ida_bytes.get_flags(ea)) and not ida_bytes.is_data(ida_bytes.get_flags(ea)):
                ea+=1
            rl=ea-rs
            b= rl if rl<=8 else (16 if rl<=16 else (32 if rl<=32 else (64 if rl<=64 else (256 if rl<=256 else 999))))
            hist[b]+=1
    lines.append("== undefined run-length histogram (bucket: count, bytes) ==")
    ea=0
    # recompute bytes per bucket
    bytes_bucket=Counter()
    for blo,bhi in ((0xFFEDB000,0xFFF48000),(0xFFF4C000,0xFFF50000)):
        ea=blo
        while ea<bhi:
            if ida_bytes.is_code(ida_bytes.get_flags(ea)) or ida_bytes.is_data(ida_bytes.get_flags(ea)):
                ea+=1; continue
            rs=ea
            while ea<bhi and not ida_bytes.is_code(ida_bytes.get_flags(ea)) and not ida_bytes.is_data(ida_bytes.get_flags(ea)):
                ea+=1
            rl=ea-rs
            b= rl if rl<=8 else (16 if rl<=16 else (32 if rl<=32 else (64 if rl<=64 else (256 if rl<=256 else 999))))
            bytes_bucket[b]+=rl
    for k in sorted(hist):
        lines.append("  <=%4d : %6d runs  %8d bytes"%(k,hist[k],bytes_bucket[k]))
    with open(os.path.join(OUT,"flags_dump.txt"),"w",encoding="utf-8",newline="\n") as h:
        h.write("\n".join(lines)+"\n")
if True:
    os.makedirs(OUT,exist_ok=True)
    try: main()
    except Exception:
        open(os.path.join(OUT,"flags_tb.txt"),"w").write(traceback.format_exc())
    import idc as _idc; _idc.qexit(0)
