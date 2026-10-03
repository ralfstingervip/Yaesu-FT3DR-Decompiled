# i13_verify.py - lane I13. Re-reads every cited byte run from the MAIN image
# (cites.tsv and the evid columns of tx-opcodes.tsv) and runs the whole-image
# writer scans the doc relies on. Writes verify.tsv. Read-only on the image.
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import csv, hashlib, os, re

HERE = os.path.dirname(os.path.abspath(__file__))
IMG = (_REPO_S + "/decrypted/FT3D_MAIN_ver102_EXP.bin")
sys.exit("The firmware image is not in this repository.")

def rd(name):
    with open(os.path.join(HERE, name), encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f, delimiter="\t"))

rows = []
def check(cid, addr, hx, claim):
    if hx in ("", "-"):
        return
    a, want = int(addr, 16), bytes.fromhex(hx)
    got = B[a:a + len(want)]
    rows.append([cid, "%06X" % a, hx, got.hex(" "), "ok" if got == want else "FAIL", claim])

for r in rd("cites.tsv"):
    check(r["id"], r["addr"], r["expect_hex"], r["claim"])
for i, r in enumerate(rd("tx-opcodes.tsv")):
    check("OP%02d" % i, r["evid_addr"], r["evid_hex"], "opcode %s %s" % (r["opcode"], r["builder"]))

def scan(cid, rx, expect, claim, lo=0, hi=0x80000):
    hits = ["%06X" % (lo + m.start()) for m in re.finditer(rx, B[lo:hi], re.S)]
    rows.append([cid, "%06X-%06X" % (lo, hi), rx.hex(" ") if isinstance(rx, bytes) else "",
                 " ".join(hits), "ok" if (expect is None or hits == expect) else "FAIL", claim])

# whole-image scans (0x000000-0x080000 is the MAIN content)
scan("W1", rb"\x6a[\x80-\x8f]\x8d\xde", ["00E516", "010580", "0105B6"], "abs16 byte stores to FF8DDE")
scan("W2", rb"\x6a[\xa0-\xaf]\x00\xff\x8d\xde", [], "abs32 byte stores to FF8DDE")
scan("W3", rb"\x7a[\x00-\x07]\x00\xff\x8d\xde", [], "pointer loads of FF8DDE")
scan("W4", rb"\x6a[\x80-\x8f]\xb0\xbe",
     ["0349F8", "0560FE", "05A3A4", "05B426", "05B43C", "05B778", "05B836", "06CF54", "06D090"],
     "abs16 byte stores to FFB0BE (script code)")
scan("W5", rb"\x6a[\xa0-\xaf]\x00\xff\xb0\xbe|\x7a[\x00-\x07]\x00\xff\xb0\xbe", [], "abs32 stores / pointer loads of FFB0BE")
scan("W6", re.escape(bytes.fromhex("0005c1a4")), [], "32-bit references to table 0x05C1A4")
scan("W7", rb"\x7f\x52\x70\x20", ["05650A", "05BC7C", "05BF30"], "bset #2,@FFFF52 (P3DR.b2 set)")
scan("W8", rb"\x7f\x52\x72\x20", ["056068", "05B810"], "bclr #2,@FFFF52 (P3DR.b2 clear)")
scan("W9", re.escape(bytes.fromhex("0001054a")) + b"|" + re.escape(bytes.fromhex("00010556")),
     ["010266", "01026A"], "references to the FF8DDE setters 0x01054A/0x010556")
scan("W10", re.escape(b"\x5e\x01\x05\x4a") + b"|" + re.escape(b"\x5e\x01\x05\x56"), [], "jsr to the setters")
scan("W11", rb"HRI", [], "string HRI in MAIN")
scan("W16", re.escape(bytes.fromhex("6a0c8dde4a0cfc006a10b3d9770067fc0ccc")), None, "sign-test idiom on FF8DDE (count only)")
scan("W12", rb"\xfc[\x06-\x09]\x6a[\x80-\x8f]\xb0\xbf", [], "immediate stores of 6..9 to the step byte FFB0BF")
scan("W13", rb"\x5e\x05\x9b\xba|\x5e\x05\x9b\xde", ["05B6AA", "05B6E6"], "jsr to the 07/08 builders")
scan("W14", rb"\x5e\x05\xb6\xa0|\x5e\x05\xb6\xdc", ["05B062", "05B072", "05B092", "05B0A2"],
     "jsr to the 07/08 step bodies (all inside unreferenced chunks 05B058/05B068/05B088/05B098)")
scan("W15", re.escape(bytes.fromhex("0005b058")) + b"|" + re.escape(bytes.fromhex("0005b068")) + b"|" +
     re.escape(bytes.fromhex("0005b088")) + b"|" + re.escape(bytes.fromhex("0005b098")), [],
     "32-bit references to those chunks")

with open(os.path.join(HERE, "verify.tsv"), "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f, delimiter="\t", lineterminator="\n")
    w.writerow(["id", "addr", "expect", "got", "result", "claim"])
    w.writerows(rows)
fails = [r for r in rows if r[4] != "ok"]
print("image sha256", hashlib.sha256(B).hexdigest()[:16], "checks", len(rows), "fail", len(fails))
for r in fails:
    print("FAIL", r)
