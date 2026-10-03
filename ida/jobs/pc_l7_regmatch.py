"""Lane 7 (pc-07): match MAIN's on-chip register accesses against public Renesas
register tables and write ida/out/pc/L7-register-match.tsv.

Inputs (read-only):
  ida/out/main-full/absrefs.tsv, ida/out/main-full/ioregs.tsv  (MAIN-FULL IDA pass)
  decrypted/FT3D_MAIN_ver102_EXP.bin                           (byte context filter)
  <mandir>/h8sx1668r.txt  pdftotext -layout of REJ09B0412-0200 (H8SX/1668R, 1668M)
  <mandir>/h8sx1658r.txt  pdftotext -layout of REJ09B0413-0200 (H8SX/1658R, 1658M)
  <mandir>/h8s2456.txt    pdftotext -layout of R01UH0309EJ0500 (H8S/2456, 2456R, 2454)
The manual text files are public Renesas hardware manuals converted locally; they
are not stored in the workspace.

usage: python ida/jobs/pc_l7_regmatch.py <mandir>
"""
import collections, csv, os, re, sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
MAN = sys.argv[1]


def lines(name):
    return open(os.path.join(MAN, name), encoding="utf-8", errors="replace").read().split("\n")


def section(L, start_pat, end_pat):
    # skip the table-of-contents entries (they end in dot leaders and a page number)
    s = next(i for i, l in enumerate(L) if re.match(start_pat + r"\s*$", l))
    e = next(i for i in range(s + 1, len(L)) if re.match(end_pat + r"\s*$", L[i]))
    return L[s:e]


def addr_set(sec, width):
    """Every register address printed in an address-order register list."""
    out = set()
    for l in sec:
        for h in re.findall(r"H'([0-9A-F]{%d})\b" % width, l):
            out.add(("F" * (6 - width)) + h)
    return out


def seq_names(sec):
    """Pair abbreviations and addresses page by page, in order (manual layout)."""
    pages, cur = [], []
    for l in sec:
        if re.search(r"Page \d+ of \d+", l):
            pages.append(cur); cur = []
        else:
            cur.append(l)
    pages.append(cur)
    names = {}
    for p in pages:
        ab, ad = [], []
        for l in p:
            for m in re.finditer(r"(?<=\s)([A-Z][A-Za-z0-9_]{1,14})(?=\s|$)", " " + l):
                c = m.start() - 1
                pre = (" " + l)[:m.start()]
                if 26 <= c <= 52 and m.group(1) not in ("Abbreviation", "Number") and (
                        pre.endswith("  ") or pre.strip() in ("", "Register Name", "Section 29 List of Registers")):
                    ab.append(m.group(1)); break
            ad += re.findall(r"\d+\s+H'([0-9A-F]{5})\s", l)
        for n, a in zip(ab, ad):
            names["F" + a] = n
    return names


L68 = lines("h8sx1668r.txt")
sec68 = section(L68, r"^29\.1 Register Addresses \(Address Order\)", r"^29\.2 Register Bits")
A_set = addr_set(sec68, 5)
names = seq_names(sec68)
# pages whose layout broke the ordered pairing; values checked by hand in the manual
names.update({"FFFDC0": "MDCR", "FFFDC2": "SYSCR", "FFFDC4": "SCKCR", "FFFDC6": "SBYCR",
              "FFFDC8": "MSTPCRA", "FFFDCA": "MSTPCRB", "FFFDCC": "MSTPCRC", "FFFDCF": "SUBCKCR",
              "FFFBCE": "SSIER", "FFEE2F": "CTLR", "FFEE32": "EPIR", "FFEE44": "TRNTREG0",
              "FFEE45": "TRNTREG1"})
L58 = lines("h8sx1658r.txt")
B_set = addr_set(section(L58, r"^28\.1 Register Addresses \(Address Order\)", r"^28\.2 Register Bits"), 5)
L56 = lines("h8s2456.txt")
sec56 = section(L56, r"^25\.1 Register Addresses \(Address Order\)", r"^25\.2 Register Bits")
C_set = addr_set(sec56, 4)
C_names = {}
for l in sec56:
    for m in re.finditer(r"\b([A-Z][A-Za-z0-9_]{1,12})\s+(?:8|16|24|32)\s+H'([0-9A-F]{4})\b", l):
        C_names["FF" + m.group(2)] = m.group(1)

img = sys.exit("The firmware image is not in this repository.")


def is_code(r):
    """@aa:8 hits inside ASCII text are mis-decoded strings ('20 20' = mov.b @FF20,r0h)."""
    if ":8" not in r["line"]:
        return True
    s = int(r["site"], 16)
    if img[s] in (0x7E, 0x7F) and img[s + 2] in range(0x60, 0x80):
        return True                      # bset/bclr/btst/bst @aa:8 (7E/7F aa 6x/7x b0)
    if (img[s] >> 4) == 0x3 and (0xF8 <= img[s - 2] or 0xF8 <= img[s - 4] or img[s - 4] in (0x7E, 0x7F)
                                 or img[s - 6] == 0x6A):
        return True                      # mov.b rXl,@aa:8 right after an immediate load / bit op
    w = img[s - 8:s + 8]
    return sum(0x20 <= b < 0x7F for b in w) / len(w) <= 0.5


tot, clean = collections.Counter(), collections.Counter()
for r in csv.DictReader(open(os.path.join(ROOT, "ida/out/main-full/ioregs.tsv")), delimiter="\t"):
    if int(r["ea24"], 16) >= 0xFFBD00:
        tot[r["ea24"]] += 1
        clean[r["ea24"]] += is_code(r)
absr = {r["ea24"]: r for r in csv.DictReader(open(os.path.join(ROOT, "ida/out/main-full/absrefs.tsv")), delimiter="\t")}

NOTE = {
    "FFEE00": "USB IFR0; read by vector 234 (USBINTN2) sub_54D50",
    "FFEE01": "USB IFR1; vector 235 (USBINTN3) sub_54EC2",
    "FFEE02": "USB IFR2; vectors 235/238",
    "FFEE04": "USB IER0=0x8D then 0x8F (sub_54C44, sub_55620)",
    "FFEE08": "USB ISR0=0x00 -> all IFR0 sources on USBINTN2 = vector 234",
    "FFEE09": "USB ISR1=0x07 -> IFR1 b0-2 on USBINTN3 = vector 235",
    "FFEE0A": "USB ISR2=0x1F -> IFR2 b0-4 on USBINTN3 = vector 235",
    "FFEE0E": "EPDR0s SETUP FIFO, 8-byte read",
    "FFEE28": "FCLR=0x73 (FIFO clear)",
    "FFEE2C": "TRG packet trigger",
    "FFEE2D": "USB 'DMA' register; bset #2 = PULLUP_E (D+ pull-up via PM4) at 0x54CA6/0x78154/0x78216 = USB attach",
    "FFEE2F": "CTLR 0x08 = RSME (remote-wakeup resume) then 0x00; vector 238 = USB resume",
    "FFEE32": "EPIR endpoint-information FIFO, 50 bytes from 0x54C12",
    "FFEE50": "PMDDR (port M) = 0 at 0x22C0",
    "FFEE51": "PMDR = 0 at 0x22BA",
    "FFEE53": "PMICR bit1 = PM1/RxD6 input buffer, set just before SCI_6 init (0x446C4)",
    "FFF610": "SCI_6 SMR=0 (SUB IPC link, 'SCI-D')",
    "FFF611": "SCI_6 BRR=0 -> 16MHz/32 = 500000 bit/s",
    "FFF613": "SCI_6 TDR = DMAC ch0 destination; DMRSR_0=0xE1=225=TXI6",
    "FFFB82": "P3DDR - port 3 absent on 120-pin H8SX/1658R",
    "FFFB8B": "PCDDR - port C absent on 120-pin H8SX/1658R",
    "FFFB90": "P1ICR; bset #1 (P11/RxD2) at 0x45572 before SCI_2 init",
    "FFFB91": "P2ICR; bset #5 (P25/RxD1) at 0x5DD98",
    "FFFB95": "P6ICR; bset #1 (P61/RxD4) at 0x4518C before SCI_4 (DATA jack) init",
    "FFFBA4": "PHDR port H data, 336 bit ops (21 funcs)",
    "FFFBCD": "PFCRD=0 (PCJKE=0: ports D/E, not J/K)",
    "FFFBCE": "SSIER (software-standby release IRQ enable), word writes",
    "FFFC14": "DMDR_0 = 0x800001A0 (bit31 DTE) - H8SX DMAC geometry",
    "FFFD20": "DMRSR_0 = 0xE1 (vector 225 TXI6) at 0x4830E",
    "FFFD21": "DMRSR_1 = 0x96 (vector 150 TXI1) at 0x483B6",
    "FFFD22": "DMRSR_2 = 0xA2 (vector 162 TXI4) at 0x6B96E",
    "FFFD68": "ISCRH (IRQ15-8 sense); vectors 74/75 = IRQ10/IRQ11",
    "FFFD6A": "ISCRL (IRQ7-0 sense)",
    "FFFDC2": "SYSCR=0xD103 at 0x212A",
    "FFFDC4": "SCKCR=0x0111 at 0x2100: ICK=PCK=BCK=001 -> x1 with MD_CLK=1, EXTAL 16MHz -> I=P=B=16MHz, USB=EXTALx3=48MHz",
    "FFFDC6": "SBYCR=0x8E00 in NMI power-down path 0x281E",
    "FFFDC8": "MSTPCRA=0x5CD4: DMAC,TMR0-3,D/A,A/D0,TPU0-11 on; EXDMAC,DTC off",
    "FFFDCA": "MSTPCRB=0xE8FF: SCI_0,1,2,4 on; PPG0,IIC off",
    "FFFDCC": "MSTPCRC=0xB700: SCI_6,USB,RAM0-7 (incl. RAM6/5 = FEE000-FF1FFF, 56KB parts only) on; SCI_5,TMR4-7,CRC,A/D1,PPG1 off",
    "FFFE70": "DPSBYCR=0x31 in NMI path",
    "FFFE90": "SCI_4 SMR=0 (DATA jack, 'SCI-A')",
    "FFFE91": "SCI_4 BRR = table 0x452C2 {0x67,0x33,0x19,0x0C}[FF8C27] -> 4800/9600/19200/38400; fixed 0x0C (38400) alt mode",
    "FFFE93": "SCI_4 TDR = DMAC ch2 destination; DMRSR_2=0xA2=TXI4",
    "FFFEC4": "TCORA_2/3 word access (TMR_2/3 cascaded)",
    "FFFEE5": "TSR_4; cleared by IRQ2 handler 0x561C2 (vector 66)",
    "FFFEF5": "TSR_5; vector 110 = TGI5A",
    "FFFF20": "mostly mis-decoded ASCII spaces; DTC is module-stopped",
    "FFFF32": "INTCR=0 at 0x2130",
    "FFFF34": "IER=0x0480 (IRQ10,IRQ7) at 0x23DE; 0x0808/0x0008 (IRQ11,IRQ3) in sub_284E",
    "FFFF36": "ISR (IRQ status) read-modify-write",
    "FFFF52": "P3DR (DSP reset/boot line per doc-09) - port 3 absent on 1658R",
    "FFFF5B": "PCDR - port C absent on 1658R",
    "FFFF60": "SCI_2 SMR ('SCI-B')",
    "FFFF61": "SCI_2 BRR=0x0C -> 38400",
    "FFFF68": "DADR0=0x7F at 0x235A",
    "FFFF69": "DADR1=0x7F at 0x2356",
    "FFFF6B": "write 0x03 at 0x2352 (sub_20FA) to an address not listed in the H8SX/1668R table - unexplained, single site",
    "FFFF88": "SCI_1 SMR ('SCI-C', DSP)",
    "FFFF8B": "SCI_1 TDR = DMAC ch1 destination; DMRSR_1=0x96=TXI1",
    "FFFFA0": "ADCSR_0 (polled A/D)",
    "FFFFBC": "TSTR (TPU start) - H8S/2456 has TSTR at FFFFC0",
    "FFFFC5": "TSR_0; vector 88 = TGI0A",
    "FFFFD5": "TSR_1; vector 93 = TGI1A",
    "FFFFE5": "TSR_2; vector 97 = TGI2A",
}

out = os.path.join(ROOT, "ida", "out", "pc")
os.makedirs(out, exist_ok=True)
with open(os.path.join(out, "L7-register-match.tsv"), "w", encoding="utf-8", newline="") as f:
    w = csv.writer(f, delimiter="\t", lineterminator="\n")
    w.writerow(["ea24", "image_hits", "code_hits", "n_functions", "mnemonics",
                "H8SX1668R_name", "A_H8SX1668R_1668M", "B_H8SX1658R_1658M", "C_H8S2456_2456R_2454",
                "C_name", "notes"])
    for a in sorted(tot):
        n = names.get(a, "") if a in A_set else ""
        note = NOTE.get(a, "")
        if clean[a] == 0 and not note:
            note = "all hits are mis-decoded data/ASCII"
        w.writerow([a, tot[a], clean[a], absr[a]["n_functions"] if a in absr else "",
                    absr[a]["mnemonics"] if a in absr else "", n,
                    "Y" if a in A_set else "N", "Y" if a in B_set else "N", "Y" if a in C_set else "N",
                    C_names.get(a, ""), note])
    # memory rows (not registers): the discriminating RAM / ROM facts
    w.writerow(["RAM FEE000-FF1FFF", "BSS clear from 0xFEE000 (0x2138); 103 refs", "", "", "",
                "on-chip RAM 6/5", "Y (56KB)", "Y (56KB)", "N (H8S/2456 RAM FF0000- ,<=64KB, different map)", "", "only 56KB parts map RAM here"])
    w.writerow(["ROM 000000-07B753", "content 505,172 B; image 1,048,576 B", "", "", "",
                "user MAT", "Y (1MB)", "Y (1MB)", "N (256KB max)", "", "exceeds every 512KB-or-smaller part"])
print("rows", len(tot), "A", sum(a in A_set for a in tot), "B", sum(a in B_set for a in tot),
      "C", sum(a in C_set for a in tot))
for a in sorted(tot):
    if clean[a] and a not in A_set:
        print("code hit not in A:", a, clean[a])
for a in sorted(tot):
    if clean[a] and a in A_set and a not in B_set:
        print("A-only (not 1658R):", a, clean[a], names.get(a))
