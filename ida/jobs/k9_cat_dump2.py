import ida_auto, ida_bytes, ida_ua, idc, idautils
import traceback
OUT = "local-temp"

def log(f,s): f.write(s+"\n")
def fc(ea,end):
    a=ea
    while a<end:
        if not ida_bytes.is_code(ida_bytes.get_flags(a)): ida_ua.create_insn(a)
        n=idc.next_head(a,end); a=n if n>a else a+1
def dr(f,s,e,l):
    log(f,"\n==== %s %06X..%06X ===="%(l,s,e)); ea=s
    while ea<e and ea!=idc.BADADDR:
        sz=idc.get_item_size(ea); sz=1 if sz<1 else sz
        raw=" ".join("%02x"%ida_bytes.get_byte(ea+i) for i in range(min(sz,10)))
        log(f,"%06X  %-28s  %s"%(ea,raw,idc.generate_disasm_line(ea,0) or ""))
        n=idc.next_head(ea,e); ea=n if n>ea else ea+1
def xr(f,ea,l):
    log(f,"\n-- xrefs to %s %06X --"%(l,ea))
    for x in idautils.XrefsTo(ea,0):
        log(f,"  from %06X  %s"%(x.frm,idc.generate_disasm_line(x.frm,0) or ""))
try:
    for (s,e) in [(0x6BE00,0x6C05C),(0x6C7D8,0x6C8E8),(0x6C8E8,0x6CB40),
                  (0x2AC00,0x2AE00),(0x737C8,0x737FC)]:
        fc(s,e)
    ida_auto.auto_wait()
    with open(OUT+r"\handlers2.lst","w",encoding="utf-8",newline="\n") as f:
        dr(f,0x6BE34,0x6BE9C,"sub_6BE34 M echo builder")
        dr(f,0x6BE9C,0x6BEF6,"B handler loc_6BE9C")
        dr(f,0x6BEF6,0x6BF44,"C handler loc_6BEF6")
        dr(f,0x6BF44,0x6BF6C,"F reply sub_6BF44")
        dr(f,0x6BF6C,0x6BF8C,"E reply sub_6BF6C")
        dr(f,0x6BF8C,0x6BFB4,"S reply sub_6BF8C")
        dr(f,0x6BFB4,0x6C05C,"N handler loc_6BFB4")
        dr(f,0x6C7D8,0x6C850,"sub_6C7D8 (F helper)")
        dr(f,0x6C850,0x6C8E8,"E handler sub_6C850")
        dr(f,0x6C8E8,0x6CA6E,"S handler sub_6C8E8 + sub_6C9xx")
    with open(OUT+r"\clone_menu.lst","w",encoding="utf-8",newline="\n") as f:
        dr(f,0x2AC00,0x2AE00,"clone menu region (caller of sub_7358E/737FC)")
        dr(f,0x737C8,0x737FC,"sub_737C8 ID/region check")
        xr(f,0x2AD12,"clone recv call site")
        xr(f,0x2AD18,"clone send call site")
        # find the function start containing 0x2AD12 and its xrefs
        fn=idc.get_func_attr(0x2AD12, idc.FUNCATTR_START)
        log(f,"\nfunc containing 0x2AD12 starts at %06X"%fn)
        xr(f,fn,"clone-menu function start")
    with open(OUT+r"\done2.txt","w",encoding="utf-8") as f: f.write("ok\n")
except Exception:
    with open(OUT+r"\traceback2.txt","w",encoding="utf-8") as f: f.write(traceback.format_exc())
idc.qexit(0)
