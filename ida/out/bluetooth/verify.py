# -*- coding: utf-8 -*-
r"""Lane M12 byte checker (read-only).

Reads cites.tsv (image, addr, expected bytes, insn, note) and re-reads each byte run
straight from the plaintext images. SUB file offset = addr - 0xFFC00000, MAIN offset = addr.
Writes verify.tsv next to this file and prints the PASS count and image hashes.
"""
import sys
import hashlib
import os

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(HERE)))
IMAGES = {
    "SUB": os.path.join(ROOT, "decrypted", "FT3D_SUB_ver102_ALL.bin"),
    "MAIN": os.path.join(ROOT, "decrypted", "FT3D_MAIN_ver102_EXP.bin"),
}


def main():
    sys.exit("The firmware image is not in this repository.")
    sha = {k: hashlib.sha256(v).hexdigest() for k, v in img.items()}
    rows = []
    with open(os.path.join(HERE, "cites.tsv"), encoding="utf-8") as fh:
        next(fh)
        for line in fh:
            line = line.rstrip("\n")
            if line:
                rows.append(line.split("\t"))
    out = ["image\taddr\tfile_off\texpected\tactual\tresult\tinsn\tnote"]
    ok = 0
    for im, addr, hexs, insn, note in rows:
        a = int(addr, 16)
        off = a - 0xFFC00000 if im == "SUB" else a
        exp = bytes.fromhex(hexs)
        act = img[im][off:off + len(exp)]
        res = "PASS" if act == exp else "FAIL"
        ok += res == "PASS"
        out.append("\t".join([im, addr, "0x%06X" % off, exp.hex(" "), act.hex(" "), res, insn, note]))
    out.append("# %d/%d PASS; sha256 SUB %s MAIN %s" % (ok, len(rows), sha["SUB"], sha["MAIN"]))
    with open(os.path.join(HERE, "verify.tsv"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write("\n".join(out) + "\n")
    print("%d/%d PASS  SUB %s  MAIN %s" % (ok, len(rows), sha["SUB"][:16], sha["MAIN"][:16]))


if __name__ == "__main__":
    main()
