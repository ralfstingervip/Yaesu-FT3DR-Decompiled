import pickle,collections
from bu import BU,IMG
visited,tabs=pickle.load(open("rd.pkl","rb"))
st=pickle.load(open("stores2.pkl","rb"))
e3=pickle.load(open("e3.pkl","rb"))
S=collections.defaultdict(list)  # opcode -> [(mech, site, live)]
for a,reg,v,live in st:
    if reg in (4,12) and v is not None: S["%04X"%v].append(("imm",a,live))
for s,k,a,v,p,live in e3:
    S["%04X"%v].append(("e3:%06X"%s,a,live))
S["F102"].append(("rewrite F101->F102 sub_8B7C",0x8B98,0x8B9C in visited))
for i in range(0,0x2C): S["F2%02X"%i].append(("F200 builder lo=idx(0x1BD80) via 0xFF3D75",0x945C,0x945C in visited))
pickle.dump(dict(S),open("mainset.pkl","wb"))
live=[k for k,v in S.items() if any(x[2] for x in v)]
dead=[k for k,v in S.items() if not any(x[2] for x in v)]
print("distinct",len(S),"live",len(live),"deadonly",sorted(dead))
for k in ["F003","F00A","F109","F10A","F10D","F10F","F113","F115","F400","F401","F402","F404","F501","F503","F703","F801","FF01","FFFE","F102","F3D2","F3D6","FE00","FC00"]:
    print(k, [(m,"%06X"%a,l) for m,a,l in S.get(k,[])])
