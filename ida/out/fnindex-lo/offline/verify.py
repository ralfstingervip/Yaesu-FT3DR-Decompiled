import sys, pickle
sys.dont_write_bytecode = True
exec(open("l2_reach.py", encoding="utf-8").read().split("FNSAVE = dict(D9.FNSEED)")[0])
P = pickle.load(open(SCR + "reach.pkl", "rb")); runs = P["runs"]
FO = bytearray(HI)
for s, e in runs:
    for x in range(s, e): FO[x] = 1
D9.FNSEED.clear()
CB = [(0x018250, "L2 er1 cb 018276->jsr 15206->jsr @er1 015224"), (0x018ABE, "L2 er1 cb 018AD2"), (0x01A094, "L2 er1 cb 018BE8")]
r = run_folded(COMBINED + CB); M = bm(r["reached"])
got = [x for x in range(HI) if FO[x] and M[x]]
lo = [x for x in got if x < 0x30000]; hi = [x for x in got if x >= 0x30000]
print("fnonly bytes reached with RN+3 callbacks: lo", len(lo), "hi", len(hi))
sp = []
for x in lo:
    if sp and sp[-1][1] == x: sp[-1][1] = x + 1
    else: sp.append([x, x + 1])
print(["%06X-%06X" % tuple(s) for s in sp])
# also: is anything outside the fnonly set newly reached (beyond RN)?
P4 = open(ROOT + "ida/out/main-final4/final4_proven_mask.bin", "rb").read()
MN = P["MN"]
extra = [x for x in range(HI) if M[x] and not MN[x] and not FO[x]]
print("newly reached bytes outside fnonly set:", len(extra), "of which unproven:", sum(1 for x in extra if not P4[x]))
