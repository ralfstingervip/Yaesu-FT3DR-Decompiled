import sys
# M9 byte-check: every cited run re-read straight from the images. Read-only.
import hashlib,sys
sys.exit('The firmware image is not in this repository.')
assert hashlib.sha256(MAIN).hexdigest().startswith("8e3ecd05")
assert hashlib.sha256(SUB ).hexdigest().startswith("b93570b3")
def M(a): return a              # MAIN base 0
def S(a): return a-0xFFC00000   # SUB mapped base
rows=[]
def chk(img,off,hexs,note):
    want=bytes(int(x,16) for x in hexs.split())
    got=img[off:off+len(want)]
    ok = got==want
    rows.append((ok,note,"%06X"%off if img is MAIN else "%08X"%(off+0xFFC00000),hexs,got.hex(" ")))
    return ok
# ---- MAIN: start-byte switch fixed per-type remaining counts (FF9D2C) + state (FF9D2D) ----
chk(MAIN,0x04761E,"0c ac","start-byte: mov r2l,r4l (zero test)")
chk(MAIN,0x047620,"47 d8","start-byte: beq loc_475FA (skip zero byte)")
chk(MAIN,0x04766A,"fc 0f","E3 count=0x0F (15)")
chk(MAIN,0x047670,"fc 04","E3 state=4")
chk(MAIN,0x047688,"fc 10","E2 count=0x10 (16)")
chk(MAIN,0x04768E,"fc 06","E2 state=6")
chk(MAIN,0x0476A6,"79 04 01 10","FF FFBC4C=0x110")
chk(MAIN,0x0476AE,"fc 05","FF state=5")
chk(MAIN,0x0476C6,"fc 7f","E1 count init 0x7F (127)")
chk(MAIN,0x0476CC,"fc 03","E1 state=3")
chk(MAIN,0x0476E4,"fc 11","E0 count=0x11 (17)")
chk(MAIN,0x0476EA,"fc 02","E0 state=2")
chk(MAIN,0x047702,"fc 0d","E5 count=0x0D (13)")
chk(MAIN,0x047708,"fc 0b","E5 state=0xB")
chk(MAIN,0x047720,"fc c7","FE count init 0xC7 (199)")
chk(MAIN,0x047726,"fc 07","FE state=7")
chk(MAIN,0x04773E,"fc 0d","EA count=0x0D (13)")
chk(MAIN,0x047744,"fc 08","EA state=8")
chk(MAIN,0x04775C,"fc 0d","E6 count=0x0D (13)")
chk(MAIN,0x047762,"fc 0a","E6 state=0xA")
chk(MAIN,0x04777A,"fc 29","E4 count=0x29 (41)")
chk(MAIN,0x047780,"fc 09","E4 state=9")
# E1 variable recompute from byte3
chk(MAIN,0x047BC4,"aa 85","E1: cmp.b #0x85,r2l (len bound)")
chk(MAIN,0x047BCC,"6a 8c 9d 2c","E1: FF9D2C = byte3-1")
chk(MAIN,0x047BD6,"6a 8c bb e6","E1: FFBBE6 = byte3-9")
# FE variable recompute
chk(MAIN,0x047E80,"79 24 04 01","FE: cmp.w #0x401 (<=0x400)")
chk(MAIN,0x047E7C,"6b 84 ba 94","FE: FFBA94 = len-1")
# FF variable recompute
chk(MAIN,0x047AD2,"79 24 01 12","FF: cmp.w #0x112")
chk(MAIN,0x047AD8,"79 34 00 02","FF: sub.w #2")
chk(MAIN,0x047ADC,"6b 84 bc 4c","FF: FFBC4C = len-2")
# E2 checksum span derived from byte3 (len lo), payload word -> FFBC60
chk(MAIN,0x047A42,"6e 5a 00 03","E2: r2l = byte3 (len lo)")
chk(MAIN,0x047A48,"8e 02","E2: add #2 -> checksum span")
chk(MAIN,0x047A5A,"6a 24 00 ff 98 0b","E2: r4h = FF980B (payload hi)")
chk(MAIN,0x047A66,"6b 84 bc 60","E2: FFBC60 = payload word")
# error/resync path
chk(MAIN,0x0475A8,"6b 84 ba a8","err: FFBAA8 = index")
chk(MAIN,0x0475AE,"6a 8c 9d 2d","err: FF9D2D = 1 (resync)")
chk(MAIN,0x0475C0,"fc 1b","err: FFAAE0 = 0x1B (tone)")
# E6 -> PTT
chk(MAIN,0x0481DE,"6a 18 ba 92 70 30","E6: bset #3 FFBA92")
chk(MAIN,0x0481E8,"6a 8c bb 91","E6: FFBB91 = FF980B (PTT byte)")
# ---- SUB ----
chk(SUB,S(0xFFEDD34F),"05 de db ff","builder182: bsr sub_FFEDAF2D (tx)")
chk(SUB,S(0xFFEDD239),"3d 03 0b","builder182: var_6 = 0x0B (header len, payload start idx)")
chk(SUB,S(0xFFEDD6F5),"05 38 d8 ff","builder528: bsr sub_FFEDAF2D (tx)")
# 0x8A86 GPS-mode flag + 12180 mirror
chk(SUB,S(0xFFEDCE5E),"75 51 f3","disp: frame[5]==0xF3 (opcode hi)")
chk(SUB,S(0xFFEDCE7E),"61 31","disp: frame[0x18]==3")
chk(SUB,S(0xFFEDCE82),"05 1b 9d 05","disp: bsr sub_FFF36B9D (TPU3 slow)")
chk(SUB,S(0xFFEDCE8F),"fb e2 86 8a 00 00","disp: r14 = 0x8A86")
chk(SUB,S(0xFFEDCE95),"f8 e4 01","disp: [0x8A86] = 1")
chk(SUB,S(0xFFEDCEA6),"05 78 9c 05","disp: bsr sub_FFF36B1E (TPU3 restore)")
chk(SUB,S(0xFFEDCEB3),"fb e2 86 8a 00 00","disp: r14 = 0x8A86 (clear)")
chk(SUB,S(0xFFEDCEB9),"f8 e4 00","disp: [0x8A86] = 0")
chk(SUB,S(0xFFF36BE2),"f9 e9 04 1a b7","TPU3 slow: TGRA = 0xB71A")
# 12CB8 states
chk(SUB,S(0xFFF3862D),"f8 e5 02","12CB8 = 2 (BT on)")
chk(SUB,S(0xFFF38660),"f8 e5 02","12CB8 = 2 (BT off path)")
chk(SUB,S(0xFFF38F7B),"f8 e5 01","12CB8 = 1 (SCO up)")
# E5 / 12CBA
chk(SUB,S(0xFFF394A9),"f8 e5 01","12CBA = 1")
chk(SUB,S(0xFFF394CC),"75 41 e5","E5 type byte (-> sub_FFEDD528)")
chk(SUB,S(0xFFF394F0),"f8 e5 02","12CBA = 2")
chk(SUB,S(0xFFF39513),"75 41 e5","E5 type byte (send 0)")
npass=sum(1 for r in rows if r[0])
for ok,note,addr,want,got in rows:
    if not ok: print("FAIL %-40s %s want[%s] got[%s]"%(note,addr,want,got))
print("VERIFY %d/%d PASS"%(npass,len(rows)))
