# i13_steps.py - lane I13. Joins the step jump tables read from the MAIN image
# with the hand-written handler classes in handlers.tsv, checks every handler's
# evidence bytes against the image, and writes scripts.tsv. Read-only on the image.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import csv, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
IMG = (_REPO_S + "/decrypted/FT3D_MAIN_ver102_EXP.bin")
sys.exit("The firmware image is not in this repository.")

def rd(name):
    with open(os.path.join(HERE, name), encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f, delimiter="\t"))

H = {r["handler"]: r for r in rd("handlers.tsv")}
bad = []
for h, r in H.items():
    a = int(r["evid_addr"], 16)
    want = bytes.fromhex(r["evid_hex"])
    if B[a:a + len(want)] != want:
        bad.append((h, r["evid_addr"], r["evid_hex"], B[a:a + len(want)].hex(" ")))

out = []
for t in rd("tables.tsv"):
    base, n = int(t["table"], 16), int(t["entries"])
    for i in range(n):
        p = struct.unpack(">I", B[base + 4 * i: base + 4 * i + 4])[0]
        k = "%06X" % p
        r = H.get(k)
        if r is None:
            bad.append(("missing", t["table"], i, k))
            r = {"kind": "?", "action": "?", "frame": "?", "next": "?"}
        out.append([t["table"], t["status"], t["index_var"], "%d" % i, "0x%02X" % i,
                    "%06X" % (base + 4 * i), k, r["kind"], r["frame"], r["next"], r["action"]])

with open(os.path.join(HERE, "scripts.tsv"), "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f, delimiter="\t", lineterminator="\n")
    w.writerow(["table", "status", "index_var", "step", "step_hex", "slot_addr", "handler",
                "kind", "frame", "next", "action"])
    w.writerows(out)

print("rows", len(out), "handlers", len(H), "problems", len(bad))
for b in bad:
    print("PROBLEM", b)
sys.exit(1 if bad else 0)
