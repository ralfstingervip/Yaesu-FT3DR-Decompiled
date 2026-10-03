r"""PROTOCOLS job 1: seed inventory of a radio image.

Run with --copy-from ida\db\radio\MAIN.i64 (db PROTO_MAIN) or
--copy-from ida\db\radio\SUB.i64 (db PROTO_SUB).

Writes, per image, into ida\out\protocols\:
  <job>_segments.tsv   segment map
  <job>_funcs.tsv      every function: ea, end, name, size
  <job>_strings.tsv    every IDA string with address
  <job>_kwhits.tsv     byte-scan for protocol keywords over the whole image
  <job>_seed.txt       counters

No writes outside ida\out\protocols. Never opens a shared database.
"""

from __future__ import annotations

import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import ida_auto
import ida_bytes
import ida_funcs
import ida_ida
import ida_nalt
import ida_segment
import ida_strlist
import idautils
import idc

import proto_lib as L

JOB = os.environ.get("YAESU_JOB", "PROTO")

# Keywords worth a byte-level hunt across the image.  ASCII, case sensitive
# unless the regex says otherwise.
KEYWORDS = [
    # digital voice protocol families
    "DMR", "D-STAR", "DSTAR", "DPRS", "P25", "APCO", "NXDN", "dPMR", "DPMR",
    "TETRA", "IDAS", "MOTOTRBO", "C4FM", "4FSK", "FSK", "GMSK", "AFSK",
    # Fusion / Yaesu digital
    "FUSION", "Fusion", "YSF", "AMS", "DN", "VW", "WIRES", "FICH", "DSQ",
    "CSQ", "DIGITAL", "Digital", "ANALOG", "Analog", "FM", "AM", "NFM",
    # vocoder
    "AMBE", "DVSI", "IMBE", "VOCODER", "PRODID", "VERSTRING", "RATEP", "RATET",
    # fec / modem
    "GOLAY", "Golay", "VITERBI", "Viterbi", "TRELLIS", "Trellis", "BPTC",
    "HAMMING", "Hamming", "REED", "SOLOMON", "CRC", "INTERLEAV", "SCRAMBL",
    "DEINTERL", "PN9", "LFSR", "NYQUIST", "RRC", "RAISED",
    # analogue signalling
    "CTCSS", "DCS", "DTMF", "TONE", "PAGER", "EPCS", "SQL", "SQUELCH",
    "BELL", "AX25", "AX.25", "APRS", "KISS", "TNC", "SSID", "MIC-E", "MICE",
    "BEACON", "SmartBeacon",
]

KW_RE = re.compile(b"|".join(re.escape(k.encode("ascii")) for k in sorted(set(KEYWORDS), key=len, reverse=True)))
PRINTABLE = re.compile(rb"[\x20-\x7e]")


def ctx(blob: bytes, i: int, n: int = 40) -> str:
    lo = max(0, i - n)
    hi = min(len(blob), i + n)
    win = blob[lo:hi]
    return "".join(chr(c) if 0x20 <= c < 0x7F else "." for c in win)


@L.guard
def main() -> None:
    ida_auto.auto_wait()

    with L.open_out("%s_segments.tsv" % JOB) as h:
        h.write("start\tend\tname\tclass\tperm\n")
        seg = ida_segment.get_first_seg()
        nseg = 0
        while seg is not None:
            h.write("%08X\t%08X\t%s\t%s\t%d\n" % (
                seg.start_ea, seg.end_ea,
                ida_segment.get_segm_name(seg) or "",
                ida_segment.get_segm_class(seg) or "",
                seg.perm))
            nseg += 1
            seg = ida_segment.get_next_seg(seg.start_ea)

    nfunc = 0
    with L.open_out("%s_funcs.tsv" % JOB) as h:
        h.write("start\tend\tsize\tname\n")
        for ea in idautils.Functions():
            fn = ida_funcs.get_func(ea)
            if fn is None:
                continue
            h.write("%08X\t%08X\t%d\t%s\n" % (
                fn.start_ea, fn.end_ea, fn.end_ea - fn.start_ea,
                idc.get_func_name(ea) or ""))
            nfunc += 1

    # IDA string list
    nstr = 0
    try:
        ida_strlist.build_strlist()
        with L.open_out("%s_strings.tsv" % JOB) as h:
            h.write("ea\tlen\ttext\n")
            for i in range(ida_strlist.get_strlist_qty()):
                si = ida_strlist.string_info_t()
                if not ida_strlist.get_strlist_item(si, i):
                    continue
                txt = ida_bytes.get_strlit_contents(si.ea, si.length, si.type)
                if txt is None:
                    continue
                s = txt.decode("latin-1").replace("\t", " ").replace("\n", " ")
                h.write("%08X\t%d\t%s\n" % (si.ea, si.length, s))
                nstr += 1
    except Exception as exc:
        with L.open_out("%s_strings_error.txt" % JOB) as h:
            h.write(str(exc))

    # raw keyword scan across every segment, independent of IDA's string list
    nkw = 0
    with L.open_out("%s_kwhits.tsv" % JOB) as h:
        h.write("ea\tkeyword\tcontext\n")
        for base, blob in L.seg_bytes():
            for m in KW_RE.finditer(blob):
                # require a plausible text neighbourhood: at least 3 printable
                # bytes on one side, or a NUL terminator right after
                h.write("%08X\t%s\t%s\n" % (
                    base + m.start(), m.group(0).decode("ascii"),
                    ctx(blob, m.start())))
                nkw += 1

    with L.open_out("%s_seed.txt" % JOB) as h:
        h.write("job %s\n" % JOB)
        h.write("procname %s\n" % ida_ida.inf_get_procname())
        h.write("min %#x max %#x\n" % (ida_ida.inf_get_min_ea(), ida_ida.inf_get_max_ea()))
        h.write("segments %d\nfunctions %d\nstrings %d\nkeyword_hits %d\n"
                % (nseg, nfunc, nstr, nkw))


main()
