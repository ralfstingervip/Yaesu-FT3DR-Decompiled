"""Hand decoders for the main H8SX families, written from the H8SX instruction
encodings (field layout per Renesas H8SX software manual; same layout as the
binutils opcode table). Returns (len, text) or None."""
def r16(n): return ("e%d"%(n&7)) if n&8 else ("r%d"%n)
def hand(b):
    b0,b1=b[0],b[1]
    # MOV.L @(d:32,ERs),ERd  : 78 [1sss]0 6B 2[0ddd] d32
    if b0==0x78 and b1&0x8f==0x80 and b[2]==0x6b and b[3]>>4==2 and not b[3]&8:
        return 8,"mov.l @(0x%x:32,er%d),er%d"%(int.from_bytes(b[4:8],"big"),(b1>>4)&7,b[3]&7)
    # RTS/L : 54 [nnnn][0rrr]  n = count-1, rrr = last register
    if b0==0x54 and b1!=0x70 and not b1&8 and (b1>>4)<=3:
        n=b1>>4; last=b1&7
        return 2,("rts/l er%d-er%d"%(last-n,last)) if n else "rts/l er%d"%last
    # EXTU.L #2,ERd : 17 6[0ddd]
    if b0==0x17 and b1>>4==6 and not b1&8: return 2,"extu.l #2,er%d"%(b1&7)
    # MOV.L #imm3,ERd : 0F [1iii][1ddd] (iii != 0)
    if b0==0x0f and b1&0x88==0x88 and (b1>>4)&7: return 2,"mov.l #0x%x,er%d"%((b1>>4)&7,b1&7)
    # MOV.W #imm3,Rd : 0F [0iii][dddd] (iii != 0)
    if b0==0x0f and not b1&0x80 and (b1>>4)&7: return 2,"mov.w #0x%x,%s"%((b1>>4)&7,r16(b1&15))
    # CMP.W #imm3,Rd : 1F [0iii][dddd]
    if b0==0x1f and not b1&0x80 and (b1>>4)&7: return 2,"cmp.w #0x%x,%s"%((b1>>4)&7,r16(b1&15))
    # MOV.B #imm8,@aa:16 : 01 7D 40 ii aaaa
    if b0==0x01 and b1==0x7d and b[2]==0x40: return 6,"mov.b #0x%x,@0x%x:16"%(b[3],int.from_bytes(b[4:6],"big"))
    # MOV.B #imm4,@aa:32 : 6A F[iiii] aaaaaaaa ; MOV.B #imm4,@aa:16 : 6A D[iiii] aaaa
    if b0==0x6a and b1>>4==0xf: return 6,"mov.b #0x%x,@0x%x:32"%(b1&15,int.from_bytes(b[2:6],"big"))
    if b0==0x6a and b1>>4==0xd: return 4,"mov.b #0x%x,@0x%x:16"%(b1&15,int.from_bytes(b[2:4],"big"))
    # SHLL.L #8 / #16 : 10 7[1ddd] / 10 F[1ddd]  (10 7[0ddd] is the H8S shll.l #2)
    if b0==0x10 and b1>>4 in (7,0xf) and b1&8: return 2,"shll.l #%d,er%d"%(8 if b1>>4==7 else 16,b1&7)
    # BRA Rn.W : 59 [0nnn]6
    if b0==0x59 and b1&0x0f==6: return 2,"bra r%d.w"%(b1>>4)
    return None
