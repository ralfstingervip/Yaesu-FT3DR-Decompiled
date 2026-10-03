# Lane H2 -- build table-xrefs-h8sx.tsv / table-xrefs-excluded.tsv from G2's table-xrefs.tsv and
# work\seed_tclass.tsv (written by ida\jobs\h2_tclass.py on MAIN_H8SX after h2_fix.py).
import os
H = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(H, "..", "main-banks", "table-xrefs.tsv")
cls = {}
for l in open(os.path.join(H, "work", "seed_tclass.tsv"), encoding="utf-8").read().splitlines()[1:]:
    r = l.split("\t"); cls[r[0]] = r
F0 = ("0x00F020-0x00F68F is a block of 32-bit configuration records (e.g. 0000 0957 5000, 0002 1440, 0000 4300 0000 4400); "
      "targets include ASCII-space bytes 0x4400/0x4200 and mid-instruction 0x2220/0x1080 (Inferred data, not code pointers)")
DATA_TABLES = {t: F0 for t in ("00F020 00F068 00F0A4 00F0C8 00F0EC 00F110 00F134 00F158 00F17C 00F1A0 00F1C4 "
                               "00F23C 00F284 00F36C 00F3CC 00F42C 00F47C 00F54C 00F674").split()}
DATA_TABLES.update({
    "01DE24": "numeric step table 0x500,0x625,0x800,0x1000,0x1250,0x1500,0x2000,0x2500,0x5000,0x10000,0x900,0x20000 = 5/6.25/8.33/10/12.5/15/20/25/50/100/9/200 kHz steps (Confirmed bytes 0x01DE1C-0x01DE4B); not code pointers",
    "035320": "constants 00001370 00002220 00004200; 0x4200 is ASCII spaces, 0x2220 mid-instruction (Confirmed bytes 0x035320)",
    "037D8C": "constants 0001010A 00012B4A 00072000 followed by 210c 2211 234b (Confirmed bytes 0x037D8C); 0x12B4A undecodable",
    "04B470": "slots are code: 6e e4 00 01 / 6e e4 00 02 ... = mov.b r4h,@(n:16,er6) inside sub_4B378 (Confirmed bytes 0x04B46C-0x04B47F)",
    "04B6B8": "slots are code: 6e e4 00 01 ... inside sub_4B5B6 (Confirmed bytes 0x04B6B4-0x04B6C7)",
})
keep, excl = [], []
lines = open(SRC).read().splitlines()
for l in lines[1:]:
    p = l.split("\t"); r = cls[p[0]]; t = int(p[1], 16)
    if p[2] in DATA_TABLES:
        excl.append((p, "table", DATA_TABLES[p[2]])); continue
    why = None
    if t & 1: why = "odd target"
    elif r[5] in ("mid_code", "mid_data", "data", "strlit"): why = "target is %s in seed (inside an existing item)" % r[5]
    elif r[7] == "0": why = "target does not decode (bytes %s)" % r[8]
    elif r[8].startswith("2020"): why = "target bytes are ASCII spaces"
    if why: excl.append((p, "row", why)); continue
    keep.append(l)
open(os.path.join(H, "table-xrefs-h8sx.tsv"), "w", encoding="utf-8", newline="\n").write(lines[0] + "\n" + "\n".join(keep) + "\n")
with open(os.path.join(H, "table-xrefs-excluded.tsv"), "w", encoding="utf-8", newline="\n") as o:
    o.write("from_table_entry\ttarget\ttable\tindex\tscope\treason\n")
    for p, s, w in excl:
        o.write("\t".join(p[:4] + [s, w]) + "\n")
print(len(keep), len(excl))
