# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
_HERE = _Path(__file__).resolve().parent
_REPO = _Path(__file__).resolve().parents[4]
# I9: write the IDA probe inputs (work\probe_addrs.tsv, work\check_insns.tsv). Read-only on inputs.
import sys, pickle
sys.dont_write_bytecode = True
sys.path.insert(0, str(_REPO / "ida/out/main-descent/offline"))
import descent as D9
from common import be32
SCR = (str(_HERE / "local-temp") + "/")
W = (str(_REPO / "ida/out/suspect-tables/work") + "/")
P = pickle.load(open(SCR + "i9_descent.pkl", "rb"))
r2 = D9.run("full", extra_seeds=P["extra"])["reached"]
probe = []
for T, n in ((0x02941C, 8), (0x0357CC, 7), (0x07308C, 4)):
    for i in range(n):
        probe.append((T + 4 * i, "table %06X slot %d" % (T, i)))
        probe.append((be32(T + 4 * i), "table %06X target %d" % (T, i)))
for rec in (0x0296E8, 0x029712):
    for off in range(0, 0x20, 4):
        probe.append((rec + off, "record %06X +%02X" % (rec, off)))
        v = be32(rec + off)
        if v: probe.append((v, "record %06X +%02X target" % (rec, off)))
for a, l in [(0x029406, "dispatch 02941C"), (0x035704, "dispatch 0357CC"), (0x073072, "dispatch 07308C"), (0x028CBC, "key-record dispatcher"),
             (0x028D0C, "record +00 load"), (0x028682, "descriptor dispatcher n<0x13"), (0x028562, "descriptor dispatcher n<4"),
             (0x03DE20, "EEPROM->RAM load 1A000/1A080"), (0x03DE52, "RAM->EEPROM save"), (0x03DE96, "slot u16 write-through"),
             (0x03DF1C, "slot u16 read"), (0x03BDAC, "I2C read dev A2/A3"), (0x03BF4C, "I2C write dev A2/A3"), (0x00ED16, "boot settings load"),
             (0x00DEFA, "reset-to-defaults"), (0x00E546, "zero FF4726/FF476E"), (0x01BEF2, "new"), (0x01BF28, "H9-demoted F1 row"),
             (0x05E33E, "new"), (0x05E37C, "new"), (0x029732, "new"), (0x029764, "new"), (0x000706, "vector-88 hook body (FF811A)"), (0x000760, "H9-demoted F1 row"), (0x000800, "H9-demoted F1 row"), (0x00042C, "hook installer helper"), (0x000454, "installs 0x706"), (0x0028D0, "vector 88 stub"), (0x000A8C, "popcount table")] + [(a, "ROM 1A07C pad") for a in range(0x01A07C, 0x01A0EC, 8)]:
    probe.append((a, l))
with open(W + "probe_addrs.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("addr\tlabel\n")
    for a, l in probe: f.write("%06X\t%s\n" % (a, l))
SP = [(0x028682, 0x0286A6), (0x02943C, 0x029800), (0x03571A, 0x035754), (0x07309C, 0x0733E0), (0x01BEF2, 0x01BF38), (0x05E33E, 0x05E3B4),
      (0x028CBC, 0x028DA0), (0x03DE20, 0x03DF86), (0x01A07C, 0x01A0EE), (0x000706, 0x000A8C), (0x0028D0, 0x0028F4), (0x000400, 0x000480)]
with open(W + "check_insns.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("addr\toracle_len\toracle_text\n")
    for a in sorted(r2):
        if any(s <= a < e for s, e in SP): f.write("%06X\t%d\t%s\n" % (a, r2[a][0], r2[a][1]))
print(len(probe), "probe addrs")
