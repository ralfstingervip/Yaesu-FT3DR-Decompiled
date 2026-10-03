r"""USB-ADJUDICATE probe: is MAIN's stack-2 CDC-ACM personality live or dead?

Seeded --copy-from ida\db\radio\MAIN.i64 (base 0, h8s300a, big-endian).
Force-decodes the boot/stack-2/USB-ISR regions, dumps annotated disasm, and
takes an xref census on the selector, the USB registers, and the descriptors.

Rules honoured: auto_wait() after analysis; qexit(0) at the end; body wrapped in
try/except with the traceback written to ida\log ; writes UTF-8 explicitly.
"""
from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[2]  # repository root
import os, traceback

OUT = str(_REPO / "ida/out/usb-adj")
LOG = str(_REPO / "ida/log/jobs/USB_ADJ")

def _run():
    import idc, idaapi, idautils, ida_bytes, ida_ua, ida_auto, ida_funcs, ida_segment, ida_xref
    os.makedirs(OUT, exist_ok=True)
    lines = []
    def P(s=""):
        lines.append(str(s))

    # ---- segments / base ----
    P("== segments ==")
    for s in idautils.Segments():
        P("  %-10s %06X..%06X" % (idc.get_segm_name(s), idc.get_segm_start(s),
                                  idc.get_segm_end(s)))
    P("min_ea=%06X max_ea=%06X  funcs=%d" % (idc.get_inf_attr(idc.INF_MIN_EA),
                                             idc.get_inf_attr(idc.INF_MAX_EA),
                                             ida_funcs.get_func_qty()))

    def force_code(start, end):
        ea = start
        made = 0
        while ea < end:
            f = ida_bytes.get_flags(ea)
            if ida_bytes.is_code(f):
                ea = idc.next_head(ea, end)
                if ea == idc.BADADDR:
                    break
                continue
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 1)
            ln = ida_ua.create_insn(ea)
            if ln <= 0:
                ea += 1
            else:
                made += 1
                ea += ln
        return made

    def dump(start, end, title):
        P("")
        P("======== %s  (%06X..%06X) ========" % (title, start, end))
        force_code(start, end)
        ida_auto.auto_wait()
        ea = start
        # align to a head at/just below start
        h = idc.prev_head(start + 1, max(0, start - 8))
        if h != idc.BADADDR and h <= start:
            ea = h
        while ea < end and ea != idc.BADADDR:
            f = ida_bytes.get_flags(ea)
            raw = " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(min(idc.get_item_size(ea), 8)))
            dl = idc.generate_disasm_line(ea, 0) or ""
            import ida_lines
            dl = ida_lines.tag_remove(dl)
            mark = "C" if ida_bytes.is_code(f) else "."
            P("%06X %s %-23s %s" % (ea, mark, raw, dl))
            nxt = idc.next_head(ea, end)
            if nxt == idc.BADADDR or nxt <= ea:
                break
            ea = nxt

    RANGES = [
        (0x002130, 0x002240, "BOOT: bss clear + .data EEPMOV copy + strap + stack selection"),
        (0x055FFE, 0x056060, "strap-path pre-init sub_55FFE"),
        (0x078106, 0x0782B0, "STACK-2 CDC init 0x078106 / service 0x07815C / ISR tramp 0x07827C"),
        (0x0782B0, 0x078560, "STACK-2 tail (SCI helpers + refs 0x784F0/0x7853A)"),
        (0x0761E0, 0x076360, "STACK-2 code loading 0xFF6034 (0x0761FE..0x0762BA)"),
        (0x076700, 0x0769B0, "STACK-2 endpoint helper (refs 0xFF6240 @0x76832/0x76890)"),
        (0x077010, 0x0770F0, "STACK-2 polled TDR 0x07701E / 0x0770DE"),
        (0x077110, 0x077170, "0x07711E byte-in handler (from SCI ISR bridge)"),
        (0x054BF8, 0x054D50, "STACK-1 init sub_54BF8 + sub_54C44 (writes IER0/1/2)"),
        (0x054D50, 0x054FA0, "USB ISR sub_54D50 incl dispatch @0x054EB0 on 0xFF813A"),
        (0x054CFA, 0x054D30, "USB ISR sub_54CFA (IFR2/VBUS)"),
        (0x054EC2, 0x054F00, "USB ISR sub_54EC2 (IFR1)"),
        (0x00EE70, 0x00EEA0, "reader of 0xFF813A @0x00EE82"),
        (0x0101A0, 0x0101D0, "reader of 0xFF813A @0x0101B2"),
        (0x056150, 0x0561C6, "SCI-C ISR sub_5615C reader of 0xFF813A @0x056160 (bridge split)"),
    ]
    for a, b, t in RANGES:
        try:
            dump(a, b, t)
        except Exception as e:
            P("  [dump failed %06X..%06X: %r]" % (a, b, e))

    # ---- linear forced decode of tight init bodies ----
    def lindump(start, end, title):
        import ida_lines
        P("")
        P("-------- LINEAR %s (%06X..%06X) --------" % (title, start, end))
        ea = start
        while ea < end:
            ida_bytes.del_items(ea, ida_bytes.DELIT_SIMPLE, 6)
            ln = ida_ua.create_insn(ea)
            if ln <= 0:
                P("%06X  (undecodable %02X)" % (ea, ida_bytes.get_byte(ea)))
                ea += 1
                continue
            raw = " ".join("%02X" % ida_bytes.get_byte(ea + i) for i in range(min(ln, 8)))
            dl = ida_lines.tag_remove(idc.generate_disasm_line(ea, 0) or "")
            P("%06X  %-23s %s" % (ea, raw, dl))
            ea += ln
    ida_auto.auto_wait()
    for a, b, t in [(0x078106, 0x078162, "STACK-2 CDC init body 0x078106"),
                    (0x07827C, 0x078320, "STACK-2 USB ISR trampoline 0x07827C")]:
        try:
            lindump(a, b, t)
        except Exception as e:
            P("  [lindump failed %06X: %r]" % (a, e))

    # ---- xref census ----
    P("")
    P("################ XREF CENSUS ################")
    # IDA's h8s module maps register-page @aa:16/@aa:8 to 32-bit sign-extended
    # 0xFFFFxxxx addresses, so query both the 0xFFFF and 0xFF forms.
    targets = [
        ("selector 0xFF813A", 0xFFFF813A),
        ("0xFF813B", 0xFFFF813B),
        ("USB module-enable 0xFFEE2D", 0xFFFFEE2D),
        ("USB pullup/reset 0xFFEE2F", 0xFFFFEE2F),
        ("USB IFR0 0xFFEE00", 0xFFFFEE00),
        ("USB IER0 0xFFEE04", 0xFFFFEE04),
        ("USB EPDR0I 0xFFEE0C", 0xFFFFEE0C),
        ("USB EPDR0S 0xFFEE0E", 0xFFFFEE0E),
        ("USB EPDR1 0xFFEE10", 0xFFFFEE10),
        ("USB EPDR2/bulkIN 0xFFEE14", 0xFFFFEE14),
        ("USB EPDR3 0xFFEE18", 0xFFFFEE18),
        ("USB TRG 0xFFEE2C", 0xFFFFEE2C),
        ("copied .data base 0xFF6034", 0xFF6034),
        ("EP/tbl RAM base 0xFF6240", 0xFF6240),
        ("stack1 devdesc flash 0x055818", 0x055818),
        ("stack2 devdesc flash 0x07B680", 0x07B680),
        ("stack2 cfgdesc flash 0x07B711", 0x07B711),
        ("stack2 ACME str flash 0x07B69C", 0x07B69C),
    ]
    XT = {0: "U", 1: "Off", 2: "Wr", 3: "Rd", 4: "Txt", 5: "Inf",
          16: "cCF", 17: "cCN", 18: "cJF", 19: "cJN", 20: "cU", 21: "cF"}
    import ida_lines
    for name, ea in targets:
        refs = list(idautils.XrefsTo(ea, 0))
        P("")
        P("%-32s %08X : %d xref(s)" % (name, ea, len(refs)))
        for x in refs:
            dl = ida_lines.tag_remove(idc.generate_disasm_line(x.frm, 0) or "")
            kind = XT.get(x.type, str(x.type)) + ("/code" if x.iscode else "/data")
            P("    from %06X  %-9s  %s" % (x.frm, kind, dl))

    txt = "\n".join(lines)
    with open(os.path.join(OUT, "usbadj_disasm.txt"), "w", encoding="utf-8", newline="\n") as fh:
        fh.write(txt)
    # also echo to stdout for the launcher log
    print(txt)

try:
    _run()
except Exception:
    os.makedirs(LOG, exist_ok=True)
    with open(os.path.join(LOG, "usbadj_probe.trace.txt"), "w", encoding="utf-8") as fh:
        fh.write(traceback.format_exc())
    try:
        os.makedirs(OUT, exist_ok=True)
        with open(os.path.join(OUT, "usbadj_probe.trace.txt"), "w", encoding="utf-8") as fh:
            fh.write(traceback.format_exc())
    except Exception:
        pass
finally:
    import idc
    idc.qexit(0)
