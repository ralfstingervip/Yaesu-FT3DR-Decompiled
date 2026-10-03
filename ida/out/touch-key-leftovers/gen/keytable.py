# Lane L6. keytable.tsv: the 60 home/main key tables 0x01109C-0x01208B (17 BE32 slots, stride 0x44) plus the
# other tables the resolver sub_1079E can return, with the selecting condition, the `mov.l #tbl,er5` site
# (bytes 7a 05 00 01 xx xx) and all 17 slot handlers. Read-only.
import sys
sys.path.insert(0, '.')
from l6lib import *

N = "[94C0]==0 & [94C1]==0"
import collections
COND = collections.defaultdict(str)
COND.update({
    0x1109C: "home selector sub_10CC4: [8DDE]==0, [A9F9]==1, [BBE0].b2==0 & [89C5].b0==1 (0x010D7C-0x010DA6); keys 4/5/8/D/E fall through to rec+1 (0x010DB4-0x010DCA)",
    0x110E0: "sub_10CC4: [8DDE]==0, [A9F9]==1, otherwise (0x010D8C); key E falls through (0x010D9E)",
    0x11124: "sub_10CC4: [8DDE]>0, [B3E0]!=0, [8DE0].b7==1, [A9F9]==1 (0x010CFC)",
    0x11168: "sub_10CC4: [8DDE]<0, [A9F9]==1, [B2A5]==0 (0x010D16)",
    0x111AC: "sub_10CC4: [8DDE]<0, [A9F9]==1, [B2A5]!=0 (0x010D22)",
    0x111F0: "sub_10CC4: [8DDE]==0, [A9F9]==4 (0x010DE4); [A506]!=0 & key not in {A,D} -> 0x01485C",
    0x11234: "sub_10CC4: [8DDE]==0, [A9F9]==5, [A9FA].b1==0 (0x010DF2)",
    0x11278: "sub_10CC4: [8DDE]==0, [A9F9]==5, [A9FA].b1==1 (0x010E00)",
    0x112BC: "sub_1079E prefix: ([A9FC]|[A9FE])!=0 and key!=0x0E (0x0108B2-0x0108C6)",
    0x11300: "no reference (Not found: BE32, mov.l #imm, base+index arithmetic over all selectors); all 17 slots = 0x3FFA0",
    0x11344: "sub_10CC4: [8DDE]==0, [A9F9]==8 (0x010E30)",
    0x11388: "sub_10CC4: [A9F9]==9 with [8DDE]==0 (0x010E3A) or [8DDE]<0 (0x010D06)",
    0x113CC: "sub_10CC4: [8DDE]==0, [A9F9]==10 (0x010E44)",
    0x11410: "sub_1079E prefix: [BC4E]==2 (0x010852)",
    0x11454: "sub_1079E prefix: [BC4E] not in {0,1,2} (0x010848)",
    0x11498: "sub_1079E prefix: [BC4E]==1 (0x01085C)",
    0x114DC: "sub_10CC4: [8DDE]>0, [B3E0]==0 (0x010CCE)",
    0x11520: "sub_10CC4: [8DDE]>0, [B3E0]!=0, [8DE0].b7==0 (0x010CDC)",
    0x11564: "sub_10CC4: [8DDE]>0, [B3E0]!=0, [8DE0].b7==1, [A9F9]!=1 (0x010CEC)",
    0x115A8: "sub_10CC4: [8DDE]<0, [A9F9] not in {1,9}, rec+0x46.b0==0 (0x010D42)",
    0x115EC: "sub_10CC4 0x010E4E: [8DDE]==0, [A9F9] not in {1,4,5,8,9,10}: 0x0115EC + 0x44*rec+5 (rec+5=0); also loaded by 0x01D5B8 0x01F6CE 0x01F6FE 0x024FC2 0x06D14A 0x06D196",
    0x11630: "0x0115EC + 0x44*rec+5, rec+5==1 (0x010E92 mulxu)",
    0x11674: "0x0115EC + 0x44*rec+5, rec+5==2 and (sub_3F1F2<0, or ==0 with sub_4906!=0)",
    0x116B8: "0x0115EC + 0x44*rec+5, rec+5==3",
    0x116FC: "0x0115EC + 0x44*rec+5, rec+5==4",
    0x11740: "0x0115EC + 0x44*rec+5, rec+5==5",
    0x11784: "rec+5==2, sub_3F1F2>0, sub_10EA0==0 (0x010E64)",
    0x117C8: "rec+5==2, sub_3F1F2>0, sub_10EA0!=0 (rec+0x5A.b1 & rec+0x54==0) (0x010E6E)",
    0x1180C: "sub_10CC4: [8DDE]==0, rec+0x46.b0==1 (0x010D56)",
    0x11850: "sub_10CC4: [8DDE]<0, [A9F9]!=1, rec+0x46.b0==1 (0x010D32)",
    0x11894: "TX selector sub_10FA8: [94C0]!=0, [8DDE]>0, [8DE0].b7==0 (0x010FB0)",
    0x118D8: "sub_10FA8: [8DDE]>0, [8DE0].b7==1, rec+1 not in {0x28,0x40} (0x010FBE)",
    0x1191C: "sub_10FA8: [8DDE]<0, [94C0]!=2 (0x010FE4)",
    0x11960: "sub_10FA8 0x011024: 0x011960 + 0x44*(r-1); r=[94C0] (==2 -> #34); [94C0]==1: r from screen table 0x011038 {72:6, 26/25/42/45/70:7, DD/E1-E4/E7:8}, else 4 if [AAD1]&0x0C, 9 if [AAD3]&0x0F or [AAD4].b0, else 1 (this table, r=1)",
})
for i, r in ((34, 2), (35, 3), (36, 4), (37, 5), (38, 6), (39, 7), (40, 8), (41, 9)):
    COND[0x1109C + 0x44 * i] = "sub_10FA8: 0x011960 + 0x44*(r-1), r=%d%s" % (r, {2: " ([94C0]==2)", 4: " ([AAD1]&0x0C)", 6: " (rec+1==0x72)", 7: " (rec+1 in 26/25/42/45/70)", 8: " (rec+1 in DD/E1/E2/E3/E4/E7)", 9: " ([AAD3]&0x0F or [AAD4].b0)"}.get(r, " (no selector produces r=%d: Not found)" % r))
for i, r in ((42, 1), (43, 2), (44, 3), (45, 4), (46, 5)):
    COND[0x1109C + 0x44 * i] = "layer selector sub_10EF0 ([94C1]=%d): 0x011BC4 + 0x44*([94C1]-1) at 0x010F94, reached after jsr 0x021A22 at 0x010F82, rec+5!=0" % r
COND[0x11D18] = "sub_10EF0: rec+5==0 after jsr 0x021A22 (0x010F86; no [94C1] index)"
for i, r in ((48, 1), (49, 2), (50, 3), (51, 4), (52, 5)):
    COND[0x1109C + 0x44 * i] += ("; " if COND[0x1109C + 0x44 * i] else "") + "sub_10EF0: rec+1 in {3,4} (sub_2EAEE==0 at 0x010F3A): 0x011D5C + 0x44*([94C1]-1), [94C1]=%d" % r
for i, r in ((50, 1), (51, 2), (52, 3), (53, 4), (54, 5)):
    COND[0x1109C + 0x44 * i] += "; sub_10EF0: [94C1] not in {2,4,5}, rec+0 in {0x0A,0x0B} (0x010F50-0x010F5E): 0x011DE4 + 0x44*([94C1]-1), [94C1]=%d" % r
COND[0x11F38] = "sub_10EF0: [94C1] not in {2,4,5}, [AD6A]!=0 (0x010F60; no index)"
for i, r in ((53, 1), (54, 2), (55, 3), (56, 4), (57, 5)):
    COND[0x1109C + 0x44 * i] = (COND[0x1109C + 0x44 * i] + "; sub_10EF0: rec+5==2 & sub_3F1F2>0: 0x011EB0 + 0x44*([94C1]-1), [94C1]=%d" % r).lstrip("; ")
for i, r in ((56, 1), (57, 2), (58, 3)):
    COND[0x1109C + 0x44 * i] += "; sub_10EF0: [A9F9] in {4,5,6}: 0x011F7C + 0x44*([94C1]-1), [94C1]=%d (0x010F08)" % r
for i, r in ((57, 1), (58, 2), (59, 3)):
    COND[0x1109C + 0x44 * i] += "; sub_10EF0: [A9F9]==10: 0x011FC0 + 0x44*([94C1]-1), [94C1]=%d (0x010F2A)" % r
for i, r in ((58, 1), (59, 2)):
    COND[0x1109C + 0x44 * i] += "; sub_10EF0: [A9F9]==9: 0x012004 + 0x44*([94C1]-1), [94C1]=%d (0x010F20)" % r
COND[0x12048] += "; sub_10EF0: [8DDE]<0 & [94C1]==1 & [A9F9]==0 (0x010EFA)"
EXTRA = {
    0x12590: "sub_1079E prefix: [BBDE]!=0, rec+1==0, key not in {0,0x0A} (0x010890)",
    0x147D4: "sub_1079E prefix: [BBF4].b1==1 (0x0108A8)",
    0x1485C: "sub_10CC4: [A9F9] in {4,5}, [A506]!=0, key not in {0x0A,0x0D} (0x010E26, after jsr 0x2888C)",
    0x14818: "sub_10EB8: [BBF1].b5==1 and key==0x0A (0x010EC8) - menu item list",
    0x1276C: "sub_10CC4: rec+5==2, sub_3F1F2==0, sub_4906==0 (0x010E7C) - inside the screen-table area",
    0x12948: "sub_10FA8: [8DDE]>0, [8DE0].b7==1, rec+1==0x28 (0x010FD0)",
    0x12CBC: "sub_10FA8: [8DDE]>0, [8DE0].b7==1, rec+1==0x40 (0x010FD8)",
}
out = ["# Lane L6. Key tables returned by the resolver sub_1079E (0x01079E-0x0109B7) and its selectors sub_10CC4/sub_10EB8/sub_10EF0/sub_10FA8 (0x010900-0x011036).",
       "# 17 BE32 slots per table (slot = key code in [FFA9ED]; slot 10 = touch button event). sel_sites = every 'mov.l #tbl,er5' (7a 05 00 01 xx xx) in the image.",
       "# Default user state ([8DDE]==0, [94C0]==[94C1]==0, no prefix flags) uses #20-#25 by rec+5, or #0/#1 ([A9F9]=1), #5-#7 (4/5), #10 (8), #11 (9), #12 (10).",
       "n\ttable\tend\tsel_sites\tcondition\tslot10\t" + "\t".join("s%02d" % k for k in range(17))]


def sites(b):
    pat = bytes([0x7a, 0x05]) + b.to_bytes(4, 'big'); r = []; i = IMG.find(pat)
    while i >= 0: r.append("%06X" % i); i = IMG.find(pat, i + 1)
    return ",".join(r) or "-"


for i in range(60):
    b = 0x1109C + 0x44 * i
    sl = [be32(b + 4 * k) for k in range(17)]
    out.append("\t".join(["%d" % i, "%06X" % b, "%06X" % (b + 0x43), sites(b), (COND[b].lstrip("; ") or "reached only by an index from a lower base (see condition of that base)"), "%06X" % sl[10]] + ["%06X" % x for x in sl]))
for b, c in sorted(EXTRA.items()):
    sl = [be32(b + 4 * k) for k in range(17)]
    out.append("\t".join(["x", "%06X" % b, "%06X" % (b + 0x43), sites(b), c, "%06X" % sl[10]] + ["%06X" % x for x in sl]))
open(R + "home-keytable/keytable.tsv", "w", encoding="utf-8", newline="\n").write("\n".join(out) + "\n")
print(len(out))
