r"""Lane I2 -- build the frozen repair plan for SUB_FINAL (read-only on the DB).

Run once, on an UNREPAIRED copy of the H10_SUB / H8_SUBGAP lineage, after i2_h10fix.py:

    python ida/run_job.py --script ida\jobs\i2_plan.py --db SUB_FINAL --reopen

Inputs
  ida\out\sub-final\raw\h10fix\fix_heads.tsv   H10 FIX head set (verbatim port of h10_phase.py)
  ida\out\sub-final\raw\h10fix\rej_heads.tsv   heads of the 68 wave-2 rejects
  ida\out\sub-gap\gap-runs.tsv                 H8 residue runs (code-unref-fn / -frag / -conflict)
  ida\out\sub-phase\orphans.tsv                H10 orphan verdicts
  ida\out\sub-gap\new-functions.tsv, raw\units.tsv   H8 entries and owner hints
Outputs (ida\out\sub-final\)
  target-heads.tsv   every instruction head the final DB must carry in FFED0000..FFF50A00
  func-plan.tsv      function deletions / creations / merges
  retype.tsv         published-data bytes IDA had decoded as code, with the data type to give them
  raw\plan_status.txt
"""
from __future__ import annotations
import sys
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

ROOT = str(_REPO)
OUT = os.path.join(ROOT, r"ida\out\sub-final")
RAW = os.path.join(OUT, "raw")
H10F = os.path.join(RAW, "h10fix")
GAP = os.path.join(ROOT, r"ida\out\sub-gap")
PHASE = os.path.join(ROOT, r"ida\out\sub-phase")
STATUS = os.path.join(RAW, "plan_status.txt")
BIN = os.path.join(ROOT, r"decrypted\FT3D_SUB_ver102_ALL.bin")
BASE = 0xFFC00000
LO, HI = 0xFFED0000, 0xFFF50A00          # window + past-window block
WIN_HI = 0xFFF50000
PUB = [(0xFFED0000, 0xFFED8E70), (0xFFF48000, 0xFFF4B059)]   # published data, pool bound corrected
CF_STOP = 0x1


def log(t):
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(t + "\n")


def rd(path):
    with open(path, encoding="utf-8") as h:
        lines = h.read().splitlines()
    hd = lines[0].split("\t")
    return [dict(zip(hd, l.split("\t"))) for l in lines[1:]]


def main():
    import ida_auto, ida_bytes, ida_ua, ida_funcs, idautils, idc
    ida_auto.auto_wait()
    img = sys.exit("The firmware image is not in this repository.")

    def b(ea, n):
        return img[ea - BASE:ea - BASE + n]

    def dec(ea):
        insn = ida_ua.insn_t(); ln = ida_ua.decode_insn(insn, ea)
        return (insn, ln) if ln > 0 else (None, 0)

    # ---- 1. credited heads (H10 FIX) + H8's hand-decoded pair
    tgt = {}
    for r in rd(os.path.join(H10F, "fix_heads.tsv")):
        tgt[int(r["ea"], 16)] = [int(r["size"]), "cred-" + r["class"]]
    # H8 finding 5: FFEDFFFD fb e2 d4 cd 01 00 / FFEE0003 f8 e6 01, decodable once the
    # RES/DENSE segment boundary no longer cuts the first instruction.
    assert b(0xFFEDFFFD, 9).hex() == "fbe2d4cd0100f8e601"
    tgt[0xFFEDFFFD] = [6, "cred-H"]
    tgt[0xFFEE0003] = [3, "cred-H"]

    # ---- 2. extent overlaps H10's push() test did not see (it tests only the target start)
    over = []
    while True:
        s = sorted(tgt); bad = []
        for i in range(len(s) - 1):
            a = s[i]; j = i + 1
            while j < len(s) and s[j] < a + tgt[a][0]:
                bad.append((a, s[j])); j += 1
        if not bad:
            break
        for a, c in bad:
            ka, kc = tgt[a][1], tgt.get(c, [0, ""])[1]
            if c not in tgt:
                continue
            if kc == "cred-V" and ka in ("cred-C", "cred-R", "cred-H"):
                over.append((c, tgt[c][0], a, tgt[a][0], ka)); del tgt[c]
            elif ka == "cred-V" and kc in ("cred-C", "cred-R", "cred-H"):
                over.append((a, tgt[a][0], c, tgt[c][0], kc)); del tgt[a]
            else:
                raise RuntimeError("unresolvable overlap %08X %s / %08X %s" % (a, ka, c, kc))
    log("credited heads %d ; V heads dropped as out of phase (extent overlap) %d" % (len(tgt), len(over)))
    with open(os.path.join(OUT, "overlap-fakes.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("fake_head\tfake_size\tfake_bytes\ttrue_head\ttrue_size\ttrue_bytes\ttrue_class\n")
        for c, cs, a, as_, k in sorted(over):
            h.write("%08X\t%d\t%s\t%08X\t%d\t%s\t%s\n" % (c, cs, b(c, cs).hex(), a, as_, b(a, as_).hex(), k))

    covered = set()
    for ea, (sz, k) in tgt.items():
        covered.update(range(ea, ea + sz))

    # ---- 3. residue: well-formed but unreferenced code (kept as code, never credited)
    res_runs = []
    for r in rd(os.path.join(GAP, "gap-runs.tsv")):
        if r["region"] == "window" and r["class"] in ("code-unref-fn", "code-unref-frag", "code-conflict"):
            res_runs.append((int(r["start"], 16), int(r["end"], 16), r["class"]))
    rejh = [(int(r["ea"], 16), int(r["size"])) for r in rd(os.path.join(H10F, "rej_heads.tsv"))]
    # H10 left 49 wave-2-reject `60 40` slivers unreached (-98 B).  They are pointer-table
    # entries: each start occurs as an aligned LE32 value in the layout tables (I2 correction).
    import struct
    w2ptr = {}
    for ea, sz in rejh:
        pat = struct.pack("<I", ea); i = img.find(pat); sites = []
        while i >= 0:
            if i % 4 == 0:
                sites.append(BASE + i)
            i = img.find(pat, i + 1)
        if sites and ea not in tgt:
            w2ptr[ea] = sites
            tgt[ea] = [sz, "cred-T2w"]; covered.update(range(ea, ea + sz))
        elif ea not in tgt:
            res_runs.append((ea, ea + sz, "w2-sliver"))
    with open(os.path.join(OUT, "w2-pointer-entries.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("entry\tbytes\tpointer_sites\n")
        for ea in sorted(w2ptr):
            h.write("%08X\t%s\t%s\n" % (ea, b(ea, 8).hex(), ",".join("%08X" % x for x in w2ptr[ea])))
    log("wave-2 reject heads pointer-referenced (aligned LE32) and not otherwise credited: %d" % len(w2ptr))
    res_runs.append((0xFFF4B077, 0xFFF4B084, "twin-FFF4B06C"))
    resb = {}
    for s, e, k in res_runs:
        for x in range(s, e):
            if x not in covered:
                resb[x] = k
    # maximal runs of residue bytes
    xs = sorted(resb); runs = []
    for x in xs:
        if runs and runs[-1][1] == x and runs[-1][2] == resb[x]:
            runs[-1][1] = x + 1
        else:
            runs.append([x, x + 1, resb[x]])
    nres = 0; issues = []
    res_heads = {}
    run_info = []
    phase_rep = []
    for s, e, k in runs:
        cur = s; last = None
        while cur < e:
            insn, ln = dec(cur)
            if not insn:
                issues.append("residue %08X-%08X invalid at %08X" % (s, e, cur)); break
            if cur + ln > e:
                # The residue instruction runs on into credited lane-4 heads: those heads are out
                # of phase.  Decode on from here until we land on an existing credited head start.
                issues.append("residue %08X-%08X overrun at %08X len %d -> phase repair" % (s, e, cur, ln))
                res_heads[cur] = [ln, "res-phase"]; last = (cur, insn)
                p = cur + ln; disp = set(x for x in range(cur + 1, p) if x in tgt)
                for _ in range(40):
                    if p in tgt and p not in disp:
                        break
                    i2, l2 = dec(p)
                    if not i2:
                        raise RuntimeError("phase repair decode failed at %08X" % p)
                    disp.update(x for x in range(p, p + l2) if x in tgt)
                    res_heads[p] = [l2, "cred-P"]
                    p += l2
                for x in sorted(disp):
                    phase_rep.append((x, tgt[x][0], cur, p))
                    del tgt[x]
                break
            res_heads[cur] = [ln, "res-" + k]; last = (cur, insn)
            cur += ln
        stop = bool(last and (last[1].get_canon_feature() & CF_STOP))
        run_info.append((s, e, k, stop, last[1].get_canon_mnem() if last else ""))
        nres += e - s
    log("residue runs %d bytes %d heads %d issues %d" % (len(runs), nres, len(res_heads), len(issues)))
    for t in issues:
        log("  ISSUE " + t)
    for x, sz, a, z in phase_rep:
        log("  phase repair: credited head %08X (%s, %d B) displaced by residue-led decode %08X..%08X" % (x, b(x, sz).hex(), sz, a, z))
        over.append((x, sz, a, 0, "residue-overrun"))
    with open(os.path.join(OUT, "overlap-fakes.tsv"), "a", encoding="utf-8", newline="\n") as h:
        for x, sz, a, z in phase_rep:
            h.write("%08X\t%d\t%s\t%08X\t%d\t%s\t%s\n" % (x, sz, b(x, sz).hex(), a, z - a, b(a, z - a).hex(), "residue-overrun"))
    allt = dict(tgt); allt.update(res_heads)

    with open(os.path.join(OUT, "target-heads.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("ea\tsize\tclass\tbytes\n")
        for ea in sorted(allt):
            sz, k = allt[ea]
            h.write("%08X\t%d\t%s\t%s\n" % (ea, sz, k, b(ea, sz).hex()))

    # ---- 4. seed code heads that are not targets
    funcs = {}
    for s in idautils.Functions(LO, HI):
        funcs[s] = ida_funcs.get_func(s)
    extra = []
    ea = LO
    while ea < HI:
        fl = ida_bytes.get_flags(ea)
        if ida_bytes.is_code(fl):
            sz = max(ida_bytes.get_item_size(ea), 1)
            if ea not in allt or allt[ea][0] != sz:
                extra.append((ea, sz))
            ea += sz
        elif ida_bytes.is_data(fl):
            ea += max(ida_bytes.get_item_size(ea), 1)
        else:
            ea += 1
    def where(ea):
        for lo, hi in PUB:
            if lo <= ea < hi:
                return "pubdata"
        return "code"
    from collections import Counter
    log("seed code heads not in target %d (%s)" % (len(extra), dict(Counter(where(e) for e, _ in extra))))
    # published-data bytes that were code -> retype
    rbytes = sorted(set(x for e, sz in extra if where(e) == "pubdata" for x in range(e, e + sz)))
    rruns = []
    for x in rbytes:
        if rruns and rruns[-1][1] == x:
            rruns[-1][1] = x + 1
        else:
            rruns.append([x, x + 1])
    retype = []
    for s, e in rruns:
        if s < 0xFFED8E70:
            a = s & ~3; z = (e + 3) & ~3
            retype.append((a, z, "dword"))
        else:
            # string pool: extend to the enclosing NUL-terminated strings
            a = s
            while a > 0xFFF48000 and img[a - 1 - BASE] != 0:
                a -= 1
            cur = a
            while cur < e:
                z = cur
                while img[z - BASE] != 0:
                    z += 1
                z += 1
                txt = b(cur, z - cur - 1)
                if txt and all(0x20 <= c < 0x7F for c in txt):
                    retype.append((cur, z, "strlit"))
                else:
                    for q in range(cur, z):
                        retype.append((q, q + 1, "byte"))
                cur = z
    dd = {}
    for a, z, t in retype:
        dd[(a, z)] = t
    with open(os.path.join(OUT, "retype.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("start\tend\ttype\tbytes\n")
        for (a, z), t in sorted(dd.items()):
            h.write("%08X\t%08X\t%s\t%s\n" % (a, z, t, b(a, z - a).hex()))
    log("retype runs %d (from %d code bytes in published data)" % (len(dd), len(rbytes)))

    # ---- 5. function plan
    plan = []
    rej_starts = set(ea for ea, sz in rejh)
    w2 = set()
    for i in range(1, 6):
        for r in rd(os.path.join(ROOT, r"ida\out\wave2\sub-purpose-%d.tsv" % i)):
            if r.get("validated") == "rejected":
                w2.add(int(r["ea"], 16))
    for s, f in sorted(funcs.items()):
        if s not in allt:
            plan.append(("delete", s, f.end_ea, "start is not a true instruction head (%s)" % where(s)))
        elif s in w2:
            calls = [x for x in idautils.XrefsTo(s, 0) if x.iscode and x.type in (16, 17)]
            if s in w2ptr or calls:
                continue
            plan.append(("delete", s, f.end_ea, "wave-2 reject, no call or pointer (%s)" % allt[s][1]))
    # H8 NEW entries
    units = {}
    with open(os.path.join(GAP, r"raw\units.tsv"), encoding="utf-8") as h:
        for ln in h:
            k, own, how, heads = ln.rstrip("\n").split("\t")
            units.setdefault(int(own, 16), []).append((k, how, [int(x, 16) for x in heads.split(",") if x]))
    entries = {}
    for r in rd(os.path.join(GAP, "new-functions.tsv")):
        if r["kind"] == "NEW":
            entries[int(r["owner_or_entry"], 16)] = r["reached_by"]
    for r in rd(os.path.join(PHASE, "orphans.tsv")):
        entries[int(r["start"], 16)] = "orphan-" + r["class"]
    for ea in w2ptr:
        entries[ea] = "w2-pointer"
    for ea in w2:
        if ea in allt and ea not in w2ptr and [x for x in idautils.XrefsTo(ea, 0) if x.iscode and x.type in (16, 17)]:
            entries[ea] = "w2-called"
    for s, e, k, stop, mn in run_info:
        if k in ("code-unref-frag", "twin-FFF4B06C") and stop and s not in entries:
            entries[s] = "residue-" + k
    dels = set(p[1] for p in plan)
    vecs = set(struct.unpack_from("<I", img, 0xFFED8A70 - BASE + 4 * i)[0] for i in range(256)) | \
        set(struct.unpack_from("<I", img, 0xFFFFFF80 - BASE + 4 * i)[0] for i in range(32))
    tk = sorted(allt)
    import bisect
    for ent, how in sorted(entries.items()):
        if ent not in allt:
            log("  ISSUE entry %08X (%s) is not a target head" % (ent, how)); continue
        # an entry entered only by fall-through from the head before it is not a function entry
        i = bisect.bisect_left(tk, ent) - 1
        if i >= 0 and tk[i] + allt[tk[i]][0] == ent and ent not in vecs and how in ("vector",):
            pi, pl = dec(tk[i])
            if pi is not None and not (pi.get_canon_feature() & CF_STOP):
                plan.append(("skip", ent, ent, "%s entry is fall-through from %08X (%s), not a vector target" % (how, tk[i], b(tk[i], pl).hex())))
                continue
        # walk the contiguous run of target heads from the entry
        cur = ent; stop = False
        while cur in allt:
            insn, ln = dec(cur)
            if insn is None:
                break
            nxt = cur + allt[cur][0]
            if insn.get_canon_feature() & CF_STOP:
                stop = True; cur = nxt; break
            cur = nxt
            if cur in funcs and cur not in dels:
                break
        end = cur
        merge = None
        if not stop and end in funcs and end not in dels:
            refs = [x for x in idautils.XrefsTo(end, 0) if x.type != 21 and not (ent <= x.frm < end)]
            if not refs:
                merge = end
        if ent in funcs and ent not in dels:
            if merge:
                plan.append(("merge", ent, end, "entry %s falls into %08X (no other reference): delete it and regrow from the entry" % (how, merge)))
            continue
        plan.append(("create", ent, end, how + ("; falls into %08X%s" % (end, " (merge)" if merge else " (has refs, kept)") if not stop else "")))
        if merge:
            plan.append(("merge", ent, merge, "delete %08X and regrow %08X across it" % (merge, ent)))
    with open(os.path.join(OUT, "func-plan.tsv"), "w", encoding="utf-8", newline="\n") as h:
        h.write("action\tea\tend\treason\n")
        for a, s, e, why in plan:
            h.write("%s\t%08X\t%08X\t%s\n" % (a, s, e, why))
    log("func plan: %s" % dict(Counter(p[0] for p in plan)))
    log("done")


try:
    os.makedirs(RAW, exist_ok=True)
    main()
except Exception:
    with open(STATUS, "a", encoding="utf-8", newline="\n") as h:
        h.write(traceback.format_exc())
finally:
    import idc
    idc.qexit(0)
