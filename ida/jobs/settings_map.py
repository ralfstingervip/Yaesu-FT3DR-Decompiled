r"""Lane F5 - MAIN settings-byte map.

Read-only. Seeded from EXT_MENU_MAIN. Dumps, with real disassembly:
  - the EEPROM writer family sub_3CCBC..sub_3CD4B (3 regions, 6 entries)
  - every caller of each writer entry, with ~14 preceding instructions so n /
    er1-base / r6-count can be recovered
  - every caller of the F3xx item senders sub_976A and sub_9D82, with context
    (to map a RAM settings byte -> F3xx menu code)
  - the default-init routine(s) that seed the RAM regions (around 0xE600)
  - the row-code dispatch (0x14EBE..0x150B4), its 13-entry jump table 0x150B6,
    the 15 param records 0x15102, and every row-code sub-table from 0x1515C
  - byte-scan for every access to 0xFF89C4 (the flag byte)

Outputs under ida\out\settings\. No DB write of consequence; ends qexit(0).
"""

import os
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_ua
import idautils
import idc

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "ida", "out", "settings")
os.makedirs(OUT, exist_ok=True)
LOGDIR = os.path.join(ROOT, "ida", "log", "jobs", os.environ.get("YAESU_JOB", "FIN_SETTINGS"))
os.makedirs(LOGDIR, exist_ok=True)
LOG = []


def log(m):
    LOG.append(str(m))


def w(name, text):
    with open(os.path.join(OUT, name), "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def ensure_code(ea):
    if not ida_bytes.is_code(ida_bytes.get_flags(ea)):
        ida_ua.create_insn(ea)


def fname(ea):
    f = ida_funcs.get_func(ea)
    return ida_funcs.get_func_name(f.start_ea) if f else "-"


def dl(ea):
    return (idc.generate_disasm_line(ea, 1) or "?").split(";")[0].rstrip()


def raw(ea, n):
    return " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(n))


def slab(start, end):
    lines = []
    q = start
    while q < end:
        ensure_code(q)
        sz = ida_bytes.get_item_size(q) or 1
        lines.append("%06X  %-23s %s" % (q, raw(q, min(8, sz)), dl(q)))
        q += sz
    return "\n".join(lines)


def ctx(site, n=14):
    """site plus n preceding heads, in address order."""
    heads = []
    q = site
    for _ in range(n):
        q = idc.prev_head(q, max(0, site - 0x80))
        if q == idc.BADADDR or q >= site:
            break
        heads.append(q)
    heads.reverse()
    out = []
    for a in heads + [site]:
        out.append("    %06X  %-20s %s" % (a, raw(a, min(6, ida_bytes.get_item_size(a) or 1)), dl(a)))
    return "\n".join(out)


def callers_block(title, ea, nctx=14):
    out = ["", "########## %s %06X  (%s)" % (title, ea, fname(ea))]
    seen = set()
    refs = []
    for xr in idautils.XrefsTo(ea, 0):
        refs.append(xr.frm)
    for frm in sorted(set(refs)):
        seen.add(frm)
        out.append("  ---- call site %06X  in %s" % (frm, fname(frm)))
        out.append(ctx(frm, nctx))
    out.append("  (xref count: %d)" % len(seen))
    return "\n".join(out), seen


def scan_calls(targets):
    """Raw byte scan for jsr(5E)/jmp(5A) 24-bit to any target; cross-check xrefs."""
    data = ida_bytes.get_bytes(0, 0x80000)
    hits = {t: [] for t in targets}
    for t in targets:
        for op in (0x5E, 0x5A):
            pat = bytes([op, (t >> 16) & 0xFF, (t >> 8) & 0xFF, t & 0xFF])
            i = data.find(pat)
            while i != -1:
                hits[t].append((i, "jsr" if op == 0x5E else "jmp"))
                i = data.find(pat, i + 1)
    return hits


def main():
    ida_auto.auto_wait()

    # 1. writer family full disasm
    w("writers-family.txt",
      "; EEPROM writer family (region map)\n" + slab(0x3CCBC, 0x3CD4C) + "\n")

    # 2. writer call sites with context
    writer_entries = {
        0x3CCBC: "R1 single-byte  (r1=n -> 0xFF8920+n -> EEPROM 0x580+n)",
        0x3CCD0: "R1 multi-byte   (er1=0xFF8920+n, r6=count)",
        0x3CCEC: "R2 single-byte  (r1=n -> 0xFF8AA0+n -> EEPROM 0xC000+n)",
        0x3CD00: "R2 multi-byte   (er1=0xFF8AA0+n, r6=count)",
        0x3CD1C: "R3 single-byte  (r1=n -> 0xFF8D20+n -> EEPROM 0xD000+n)",
        0x3CD30: "R3 multi-byte   (er1=0xFF8D20+n, r6=count)",
    }
    out = ["; writer call sites with preceding context"]
    allsites = {}
    for ea, desc in writer_entries.items():
        blk, seen = callers_block(desc, ea)
        out.append(blk)
        allsites[ea] = seen
    # raw scan cross-check
    out.append("\n; ---- raw jsr/jmp byte-scan cross-check ----")
    hits = scan_calls(list(writer_entries.keys()))
    for ea in writer_entries:
        xr = allsites[ea]
        raws = hits[ea]
        extra = [h for h in raws if h[0] not in xr]
        out.append("  %06X  xref=%d  raw=%d  raw-not-in-xref=%s"
                   % (ea, len(xr), len(raws), [("%06X/%s" % (a, k)) for a, k in extra]))
    w("writers-callsites.txt", "\n".join(out) + "\n")

    # 3. F3xx senders and their callers
    out = ["; F3xx item senders sub_976A / sub_9D82 and their callers"]
    out.append(slab(0x976A, 0x9792))
    out.append(slab(0x9D82, 0x9DBC))
    b1, s1 = callers_block("sub_976A sender", 0x976A, 10)
    b2, s2 = callers_block("sub_9D82 sender", 0x9D82, 10)
    out.append(b1)
    out.append(b2)
    w("senders-callsites.txt", "\n".join(out) + "\n")

    # 4. default-init routine(s)
    out = ["; default-init routines (seed RAM settings regions)"]
    for seed in (0xE600,):
        f = ida_funcs.get_func(seed)
        if f:
            out.append("#### func %06X-%06X (%s)" % (f.start_ea, f.end_ea, fname(seed)))
            out.append(slab(f.start_ea, f.end_ea))
        else:
            out.append("#### no func at %06X; raw slab" % seed)
            out.append(slab(0xE580, 0xE820))
    # Also dump the broad init window so sibling default-writers are visible
    out.append("\n#### broad init window 0xE400-0xEA00")
    out.append(slab(0xE400, 0xEA00))
    w("default-init.txt", "\n".join(out) + "\n")

    # 5. row-code dispatch + tables
    out = ["; row-code dispatch and tables"]
    out.append("#### sub containing 0x14EBE")
    f = ida_funcs.get_func(0x14EBE)
    if f:
        out.append(slab(f.start_ea, min(f.end_ea, 0x150B6)))
    else:
        out.append(slab(0x14E80, 0x150B6))
    out.append("\n#### dispatch jump table 0x150B6 (13 x u32 BE) + trailing")
    for i in range(19):
        ea = 0x150B6 + 4 * i
        v = int.from_bytes(ida_bytes.get_bytes(ea, 4), "big")
        tag = fname(v) if ida_funcs.get_func(v) else ("CODE?" if 0x2000 <= v < 0x80000 else "(not-code / past-end)")
        out.append("  grp%2d  %06X  -> %08X  %s" % (i, ea, v, tag))
    out.append("\n#### param records 0x15102 (15 x {u16 cnt, u32 ram})")
    for i in range(15):
        ea = 0x15102 + 6 * i
        cnt = int.from_bytes(ida_bytes.get_bytes(ea, 2), "big")
        ram = int.from_bytes(ida_bytes.get_bytes(ea + 2, 4), "big")
        out.append("  p%2d  %06X  cnt=0x%X ram=%06X" % (i, ea, cnt, ram & 0xFFFFFF))
    out.append("\n#### row-code tables 0x1515C..0x151EC (raw)")
    out.append("  " + ida_bytes.get_bytes(0x1515C, 0x151EC - 0x1515C).hex())
    out.append("\n#### 0x69 scan in 0x1515C..0x151EC")
    found = [0x1515C + i for i in range(0x151EC - 0x1515C)
             if ida_bytes.get_byte(0x1515C + i) == 0x69]
    out.append("  0x69 at: %s" % ([("%06X" % a) for a in found] or "NONE"))
    out.append("\n#### OPTION gate case 0x1504A..0x1506E (RAM DISPLAY, real gate)")
    out.append(slab(0x1504A, 0x15070))
    out.append("\n#### group-1 case 0x14ED4..0x14EFE (the cmp #0x69 site)")
    out.append(slab(0x14ED4, 0x14EFE))
    w("rowcodes.txt", "\n".join(out) + "\n")

    # 6. 0xFF89C4 accesses (flag byte) - byte scan for abs16 forms
    data = ida_bytes.get_bytes(0, 0x80000)
    out = ["; accesses to 0xFF89C4 (abs16 operand 0x89C4)"]
    # 6A 0x 89 C4 (byte mov abs16), 6A 1x 89 C4 (bit ops abs16)
    i = 0
    while True:
        i = data.find(b"\x89\xc4", i)
        if i == -1:
            break
        op = data[i - 2] if i >= 2 else 0
        # only report when preceded by 6A xx (abs16 addressing prefix)
        if i >= 2 and data[i - 2] == 0x6A:
            site = i - 2
            ensure_code(site)
            out.append("  %06X  %-20s %s   [in %s]" % (site, raw(site, min(6, ida_bytes.get_item_size(site) or 1)), dl(site), fname(site)))
        i += 1
    w("flag-89C4-sites.txt", "\n".join(out) + "\n")

    log("done")


try:
    main()
except Exception:
    log(traceback.format_exc())
finally:
    with open(os.path.join(LOGDIR, "settings_map.log"), "w", encoding="utf-8") as f:
        f.write("\n".join(LOG) + "\n")
    idc.qexit(0)
