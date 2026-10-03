# Lane M5 - final per-piece verdicts for L5's 135 dead-code pieces, plus Task 2 table.
# Reads work\scan.json (m5_scan.py) and work\readers.json (m5_readers.py). Writes:
#   pieces.tsv, proposed-typing.tsv, proposed-demotions.tsv, summary.txt   (all under ida\out\dead-code-tier\)
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[4].as_posix()
import json, sys, collections
sys.path.insert(0, (_REPO_S + "/ida/out/dead-code-tier/offline"))
from m5_lib import *

S = json.load(open(O + r"\work\scan.json", encoding="utf-8"))
CH = {ea: v[0] for ea, v in heads.items() if v[1] == "code"}
PH = set()
i = 0
while i < HI:
    if PM[i]:
        j = i
        while j < HI and PM[j]: j += 1
        k = i
        while k < j: PH.add(k); k += bu[k][0]
        i = j
    else: i += 1

# Manual adjudications (each re-read from bytes in this session; see doc 117 Findings)
DEAD_SRC = {   # pieces whose only code-shaped inbound comes from code that itself has no inbound edge whole-image
    "0169E8": "beq at 0x0169DA (47 0c) sits in the unreferenced 10-B prefix 0x0169D2-0x0169DB (5e 01 51 ec 47 14 aa 01 47 0c); 0 BE32/abs24/rel refs to 0x0169D2-0x0169DB; 0x0169CC is a 6-B record loaded by P 0x0169B2",
    "05DCF8": "bne at 0x05DCDE (46 18) sits in 0x05DCDA-0x05DCDF, after P bra 0x05DCD8 (40 06); 0 refs to 0x05DCDA-0x05DCDF",
    "01758E": "only ref is mov.l #0x1758e,er1 at 0x017570 (7a 01 00 01 75 8e) in N routine 0x017570-0x017587 (after rts 0x01756E); 0 BE32/abs24/rel refs to 0x017538-0x017587",
    "053496": "only refs are jsr @0x534a8 at 0x053532/0x05353E (5e 05 34 a8) in N routine 0x05351A-0x053543 (after rts 0x053518); 0 refs to 0x05351A-0x053543 or 0x0534C0-0x053519",
    "06259A": "only code ref is jsr @0x625d0 at 0x062624 (5e 06 25 d0) in N routine 0x0625F6-0x062629 (after rts 0x0625F4); 0 refs to 0x0625F6-0x062629; the 4 rel 'sources' 0x06257A..0x06258E are ASCII labels 'DIRECT ENTRY'/'SEARCH'",
    "076C06": "entered only by fall-through from mov.w at 0x076C00 (6b f0 00 ff 63 14) and beq at 0x076BE8 (47 1c), both inside N routine 0x076B20-0x076C09 (after rts/l 0x076B1E 54 02); 0 BE32/abs24/rel refs to 0x076B20-0x076C09 (11 BE32 hits are 00 07 6b 8x straddles of mov.w #7 insns)",
    "018766": "only refs are beq at 0x01872A/0x01872E inside dead piece 0x018728 (after P bra 0x018726 40 6e)",
    "06DBE0": "only refs are jsr @0x6dbe0 at 0x061C54 / 0x0669DA, themselves dead pieces (each after P bra .+4)",
}
OVR = {
    "018FAA": ("NOT DEAD", "Inferred", "code", "Confirmed",
               "6 x jsr @0x18faa (5e 01 8f aa) at 0x017950/58/6C/74/7C/84 in handlers 0x01794E-0x017989; handlers are fields 1-7 of "
               "record 0x01792E (00 01 a0 d4 00 01 79 4e ... 00 01 79 82) passed by P 0x017924 (7a 05 00 01 79 2e 5a 01 52 60) to "
               "helper 0x015260, which calls field[@0xAD68] (0x015288 10 72 0a a5 01 00 69 56 ... 5d 60) - reached under the 0x015260 rule (Inferred)"),
}
SPLIT = {   # 0x01E1C6: first 2 B are the operand tail of the 8-B named insn 0x01E1C0 78 b0 6b 26 00 01 e1 de
    "01E1C6": [(0x01E1C6, 0x01E1C8, "operand tail", "Confirmed", "code (extend insn)", "Confirmed",
                "bytes e1 de are the last 2 B of named 0x01E1C0 78 b0 6b 26 00 01 e1 de mov.l @(0x1e1de:32,er3),er6 (IDA item size 8); L5 split at 0x01E1C6 was mid-instruction"),
               (0x01E1C8, 0x01E1DE, "dead code", "Confirmed", "code (unreferenced)", "Confirmed",
                "0x01E1C8 ldm.l .. 0x01E1DC rts; whole routine 0x01E1A4-0x01E1DD has no inbound: refs into 0x01E1A0-0x01E1C5 are only rel to rts 0x01E1A2 (P); internal beq 0x01E1A8 / bne 0x01E1AE")],
}

def decode_checks(a, b, r):
    """(a) criterion; returns (ok, notes)"""
    notes = []
    ok = True
    if r["bad"]: ok = False; notes.append("undecodable %s" % r["bad"])
    if not r["end_exact"]: ok = False; notes.append("decode overruns piece end")
    if not r["ida_agree"]: ok = False; notes.append("IDA forced decode disagrees")
    if r["bad_targets"]: ok = False; notes.append("branch target off-boundary %s" % r["bad_targets"])
    # a real instruction (IDA code head or proven head) straddling into the piece start
    for h in range(max(0, a - 10), a):
        if (h in CH or h in PH) and h + bu[h][0] > a:
            ok = False; notes.append("real insn %06X (%d B) straddles piece start" % (h, bu[h][0]))
    # existing IDA heads inside the piece must sit on oracle boundaries
    bounds = set(x[0] for x in lin(a, b))
    off = [h for h in range(a, b) if h in heads and h not in bounds]
    if off: ok = False; notes.append("IDA heads off-boundary %s" % ["%06X" % x for x in off])
    if r["last_term"]: notes.append("ends %s" % r["last"].split(" ", 1)[1].strip())
    elif r["next_head"]: notes.append("flows into real head %s (%s)" % (r["next_insn"].split(" ")[0], r["next_cls"]))
    else: ok = False; notes.append("ends without terminator and not at a real head")
    return ok, notes

def inbound_summary(r):
    real, coinc = [], collections.Counter()
    for x in r["inbound"]:
        kind, s, k, t, src, live = x[0], x[1], x[2], x[3], x[4], x[5]
        if kind in ("cf", "abs24", "imm") and src.startswith(("P-head", "piece", "code-head")):
            real.append("%s %s->%s %s%s" % (kind, s, t, src, " LIVE" if live else ""))
        elif kind == "be32" and src.startswith(("REAL", "data cell")):
            real.append("be32 %s=%s %s" % (s, t, src[:40]))
        else:
            coinc["%s:%s" % (kind, src.split("(")[0].split(" ")[0])] += 1
    for f in r["fallthrough_cands"]:
        if f[3].startswith(("P-head", "piece", "code-head")) and not f[5]:
            real.append("fall %s %s %s%s" % (f[0], f[1], f[3], " LIVE" if f[4] else ""))
        if f[6]: real.append("delay-slot after bra/s %s" % f[0])
    return real, coinc

rows, typ = [], []
tot = collections.Counter()
for k, r in S.items():
    a, b = r["start"], r["end"]
    assert sum(NM[a:b]) == 0 and sum(PM[a:b]) == 0, k
    if k in SPLIT:
        for (x, y, cl, cc, ty, tc, ev) in SPLIT[k]:
            rows.append(("%06X" % x, "%06X" % y, y - x, k, cl, cc, ty, tc, img[x:y].hex(" ")[:47], ev))
            typ.append(("%06X" % x, "%06X" % y, y - x, ty, tc, "create_insn (code)" if x != 0x01E1C6 else "extend item 0x01E1C0 (already 8 B in DB)"))
            tot[(cl, cc)] += y - x
        continue
    ok, dn = decode_checks(a, b, r)
    real, coinc = inbound_summary(r)
    live = r["live_bytes"] > 0
    ev = "; ".join(dn)
    if k in OVR:
        cl, cc, ty, tc, note = OVR[k]
        ev += "; " + note
    else:
        dead_src_ok = all(" LIVE" not in x for x in real)
        if ok and not live and dead_src_ok:
            cl, cc, ty, tc = "dead code", "Confirmed", "code (unreferenced)", "Confirmed"
        else:
            cl, cc, ty, tc = "dead code", "Inferred", "code (unreferenced)", "Inferred"
        if real:
            ev += "; code-shaped inbound only from dead code: " + " | ".join(real)
        if k in DEAD_SRC: ev += "; " + DEAD_SRC[k]
        if not real: ev += "; 0 inbound from any real code head, data cell, abs24 or fall-through"
    if coinc: ev += "; coincidental (not executable / never entered): " + ", ".join("%s x%d" % (x, n) for x, n in sorted(coinc.items()))
    ev += "; not in forward closure of proven code" if not live else "; IN forward closure"
    rows.append(("%06X" % a, "%06X" % b, b - a, k, cl, cc, ty, tc, img[a:min(b, a + 16)].hex(" "), ev))
    typ.append(("%06X" % a, "%06X" % b, b - a, ty, tc, "create_insn (code)"))
    tot[(cl, cc)] += b - a

with open(O + r"\pieces.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tlen\tl5_piece\tclass\tclass_conf\ttyping\ttyping_conf\tbytes(first16)\tevidence\n")
    for x in rows: f.write("\t".join(str(c) for c in x) + "\n")
with open(O + r"\proposed-typing.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("start\tend_excl\tlen\ttyping\ttyping_conf\tdb_action\n")
    for x in typ: f.write("\t".join(str(c) for c in x) + "\n")

# ---------- Task 2 ----------
RD = json.load(open(O + r"\work\readers.json", encoding="utf-8"))
L2L4 = {}
for lane, fn in (("L2", "fnindex-lo"), ("L3", "fnindex-mid"), ("L4", "fnindex-hi")):
    for l in open(R + r"\ida\out\%s\proposed-demotions.tsv" % fn, encoding="utf-8"):
        p = l.rstrip("\n").split("\t")
        try: x, y = int(p[0], 16), int(p[1], 16)
        except ValueError: continue
        L2L4[(x, y)] = (lane, p[3])
drops = [tuple(int(v, 16) for v in l.split()[:2]) for l in open(R + r"\ida\out\l-wave-recon\drop_runs.tsv")]
USE = {  # how the pointer is consumed (read from the image this session)
    "03799E": "er6 -> jsr 0x3F5B2: mov.w @er6+,r2 / mov.l @er6,er4 (6d 62, 01 00 69 64)",
    "037A02": "interior of the same table 0x037988 (u16 stride 8, u16 count 0x11, 17 x 8 B -> ends 0x037A13)",
    "01E22C": "er5 indexed: and.l #0xff,er3; shll.l er3; add.l er3,er5 (0x01E17A..)",
    "074310": "er5 -> eepmov.w block copy to 0xFF8956 (0x0742FE 7b 5c 59 8f)",
    "065A88": "direct byte read mov.b @(0x65a88:32,er4),r3l",
    "04C3C8": "no direct reader; bytes follow the 17 x 9-B APRS device-name table 0x04C32C (u16 stride 9, read at P 0x04C2A8..0x04C2D4); as code they would be stc/orc #0xff,ccr/xorc/ldc #8,ccr",
    "00245C": "er5 -> eepmov.w block copy to 0xFFA998/0xFFA9A8 (6 sites)",
    "024000": "direct byte read mov.b @(0x24000:32,er4),r3l",
    "02D704": "er5 -> bsr 0x02D71A: add.l er3,er5; mov.b @er5,r3l (0a b5 68 5b)",
    "02D7FE": "er5 -> bsr 0x02D814: add.l er3,er5; mov.b @er5,r3l",
    "02E2D8": "er5 -> bsr 0x02E2EE: add.l er3,er5; mov.b @er5,r3l",
    "02E3D2": "er5 -> bsr 0x02E3E8: add.l er3,er5; mov.b @er5,r3l",
    "03400E": "er5 -> bsr 0x034022: add.l er3,er5; mov.b @er5,r3l",
    "02E640": "er5 -> jsr 0x3F768: mov.b @er5+,r4l; cmp.b #0xff (FF-terminated list)",
    "033B70": "er5 -> jsr 0x3F768: mov.b @er5+,r4l; cmp.b #0xff",
    "03531E": "er6 -> jsr 0x3F94C: mov.w @(2,er6),r4 / mov.w @er6,r4 (BCD subtract)",
    "035422": "direct byte reads mov.b @(0x35422/26/2A/2E:32,er2),r5h",
    "05C600": "er5 -> jsr 0x5C9D6 / 0x5C780: mov.b @er5+,r4l; cmp.b #0xff",
    "073908": "mov.l #0x73908,er1 and odd sibling mov.l #0x73909,er1; direct read mov.b @0x73909:32,r3l at 0x074444 (6a 2b 00 07 39 09)",
    "01E5EE": "er6 -> jsr 0x3F5EE: mov.l @er6,er4 / mov.l @(4,er6),er4 (BCD range compare)",
    "016642": "direct byte read mov.b @(0x16642:32,er4),r4l",
    "0151E6": "direct byte read mov.b @(0x151e6:32,er3),r3l at 0x01509A",
}
with open(O + r"\proposed-demotions.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# M5 Task 2 - L5 proven-data candidates. All 22 ranges are already OUT of final6_proven_mask.bin (drop_runs.tsv), so the\n"
            "# proven delta against the L-wave ledger is 0 B. data_conf = Confirmed where a proven/IDA code head reads the address as data.\n")
    f.write("start\tend_excl\tlen\tl5_conf\tin_final6_proven\tin_drop_runs\tearlier_lane\tverdict\tdata_conf\treader\tuse\tbytes\n")
    t2 = collections.Counter()
    for o in RD:
        a, b = int(o["start"], 16), int(o["end"], 16)
        dr = any(x < b and a < y for x, y in drops)
        lane = [v for (x, y), v in L2L4.items() if x < b and a < y]
        rds = [h for h in o["readers"] if cls(int(h[0], 16)) == "P" and (a <= int(h[2], 16) < b)
               and (h[3].startswith("mov.l #") or "@" in h[3])]
        if o["start"] in ("03799E", "037A02"):   # interior of table 0x037988 (base 22 B / 122 B before the range)
            rds = [h for h in RD[0]["readers"]]
        # readers that hit the range itself, or the table base that covers it
        conf = "Confirmed" if (rds and o["start"] != "04C3C8") else "Inferred"
        rd = "; ".join("%s %s (%s)" % (h[0], h[3], h[4]) for h in rds if h[3].find("0x34001") < 0)[:300]
        f.write("\t".join([o["start"], o["end"], str(o["len"]), o["l5conf"], str(sum(PM[a:b])), "yes" if dr else "no",
                           ",".join("%s %s" % v for v in lane), "DATA (already demoted in final6)", conf, rd or "-", USE[o["start"]], o["bytes"]]) + "\n")
        t2[(o["l5conf"], conf)] += o["len"]

summ = []
summ.append("pieces in: %d, %d B" % (len(S), sum(r["len"] for r in S.values())))
for (cl, cc), n in sorted(tot.items()): summ.append("%-14s %-9s %5d B  rows %d" % (cl, cc, n, sum(1 for x in rows if x[4] == cl and x[5] == cc)))
named_conf = sum(x[2] for x in rows if x[7] == "Confirmed")
summ.append("typing Confirmed bytes (named delta proposal): %d" % named_conf)
summ.append("  of which dead-code Confirmed: %d ; operand tail: %d ; reached-not-dead (018FAA): %d" % (
    sum(x[2] for x in rows if x[4] == "dead code" and x[5] == "Confirmed"),
    sum(x[2] for x in rows if x[4] == "operand tail"), sum(x[2] for x in rows if x[4] == "NOT DEAD")))
summ.append("typing Inferred bytes: %d" % sum(x[2] for x in rows if x[7] != "Confirmed"))
summ.append("named: 501,656 + %d = %d ; headline %d / 1,029,972" % (named_conf, 501656 + named_conf, 501656 + named_conf + 464263))
summ.append("Task 2 (l5_conf, data_conf) -> bytes: %s" % dict(t2))
open(O + r"\summary.txt", "w", encoding="utf-8", newline="\n").write("\n".join(summ) + "\n")
print("\n".join(summ))
