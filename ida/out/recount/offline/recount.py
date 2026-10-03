# H1 recount: applies G1's F1 corrections + H1 junk-function corrections + odd-head audit, recomputes the
# headline and the MAIN companions at byte level from on-disk tables. Read-only on every input.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys, os, json, collections, pickle
sys.path.insert(0, (REPO + "/ida/out/h8s-decode/offline"))
from ctx import runs, runtype
from rd import load, IMG, HI, flow

R = (REPO + "/ida/out/")
OUT = R + "recount/"
SCR = "local-temp"
_, ib, fb = load("before")
_, ia, fa = load("after")


def codemask(items, cond=lambda ea: True):
    m = bytearray(HI)
    for ea, (sz, k, st, fn, mn) in items.items():
        if k == "code" and cond(ea):
            for x in range(ea, min(HI, ea + sz)):
                m[x] = 1
    return m


mb = codemask(ib)
ma = codemask(ia)
_, _, reach, _ = pickle.load(open(SCR, "rb"))
PR = bytearray(HI)
for a, (n, t, k) in reach.items():
    for x in range(a, min(HI, a + n)):
        PR[x] = 1

# ---------------------------------------------------------------- corrections
# F1 rows (proved.tsv). reattr = bytes stay proven code, the row's entry was bogus (+2 into an H8SX MOV.L);
# text = the row opens with ASCII; the true entry is later.
F1C = [  # start, end, true insn / entry, text bytes, kind, found_by, evidence
    (0x034644, 0x034674, 0x034642, 0, "reattr", "G1",
     "tail of the routine entered at 0x034538 (jsr @0x34538:24 at 0x002CA8 = 5e 03 45 38); 0x034642 = 78 b0 6b 26 00 03 46 74 mov.l @(0x34674:32,er3),er6; the BE32 00034644 at 0x004AA6 sits in the code table 'FC',0,2,'FT',0,3,'FDG' (coincidence)"),
    (0x038104, 0x038160, 0x038102, 0, "reattr", "G1",
     "body of sub_0380EA (jsr @0x380ea:24 at 0x030D90 = 5e 03 80 ea; 0x030D68 is an entry of table 0x030DA8); 0x038102 = 78 b0 6b 26 00 03 81 8e"),
    (0x04F3A4, 0x04F3DE, 0x04F3A2, 0, "reattr", "G1",
     "body of sub_04F390 (jsr @0x4f390:24 at 0x04F340 = 5e 04 f3 90, inside validated sub_4F30A); 0x04F3A2 = 78 b0 6b 26 00 04 f3 e4"),
    (0x06AC14, 0x06AC3A, 0x06AC12, 0, "reattr", "G1",
     "case code of jump table 0x06AC3A (entry 0x06ABF2 -> 0x06AC0C -> 0x06AC12; also bra .+118 at 0x06AB94); 0x06AC12 = 78 c0 6b 24 00 04 36 a6"),
    (0x04DE6E, 0x04DEE2, 0x04DE94, 38, "text", "G1",
     "0x04DE6E-0x04DE93 = ASCII tail of the 80 B string at 0x04DE44; true entry 0x04DE94 = BE32 at 0x04AD6C in table 0x04AB70"),
    (0x04DF72, 0x04E010, 0x04DF98, 38, "text", "G1",
     "0x04DF72-0x04DF97 = ASCII 'ni  45  90 ... 360   -'; true entry 0x04DF98 = BE32 at 0x04AD74 in table 0x04AB70"),
    (0x04E320, 0x04E392, 0x04E32E, 14, "text", "H1",
     "'Baro     -hPa' + FF; true entry 0x04E32E is an entry of tables 0x04AB70/0x04ABE4"),
    (0x04E538, 0x04E584, 0x04E546, 14, "text", "H1",
     "'Gust     -mph' + FF; true entry 0x04E546 is an entry of tables 0x04AB70/0x04ABE4"),
    (0x051694, 0x0516C6, 0x05169E, 10, "text", "H1",
     "'---------' + FF; true entry 0x05169E is an entry of table 0x051548"),
]
# fnindex-validated functions: span [s,e) is not code. new_type None = data whose type is not established -> not credited.
FNC = [
    (0x00C448, 0x00C456, "parameter table", "task",
     "junk sub_C448: 02 02 02 02 02 22 74 00 6c 69 5a 49 5c 62 fills the hole between lane5 byte-table runs 0x00C06A-0x00C448 and 0x00C456-0x00C636 (same alphabet); its 'jmp @0x495C62' leaves the 16 MB space; only xref from 0x00C3F8 inside that table"),
    (0x00C636, 0x00C63A, "parameter table", "H1", "5a de 01 01 between lane5 byte-table runs ending 0x00C636 and starting 0x00C63A"),
    (0x004C14, 0x004C2A, "string", "H1", "20 spaces + FF 00 after rts at 0x004C12"),
    (0x011038, 0x011050, None, "H1", "24 B of byte pairs 72 06 26 07 25 07 42 07 ... e7 08 after rts at 0x011036"),
    (0x0232C6, 0x0232EA, None, "H1", "nine 4-byte records 44 00 00 00 / 05 21 00 00 / 14 51 00 00 ... after rts at 0x0232C4"),
    (0x0261F0, 0x0261FA, "string", "H1", "'0000.00000' after rts at 0x0261EE; code resumes at 0x0261FA"),
    (0x037A00, 0x037A02, None, "H1", "44 71 inside a big-endian float32 table (43 89 00 00, 43 95 00 00, 44 58 00 00, 44 71 00 00, 45 34 00 00 ...)"),
    (0x048B80, 0x048B84, "string", "H1", "'LON ' continues w2-8 string 0x048B7B '.LAT '; 54 70 (rts) at 0x048B84 left as is"),
    (0x04CAB6, 0x04CAB8, "string", "H1", "'[ ' opening '[ STATUS TEXT ]'"),
    (0x04D9D4, 0x04D9D6, "string", "H1", "'[ ' opening '[ COMMENT TEXT ]'"),
    (0x04F054, 0x04F056, "string", "H1", "'[ ' opening '[ DATA TEXT ]'"),
    (0x04F96A, 0x04F9A4, "string", "H1", "dot/space display masks with FF 00 terminators"),
    (0x04FDEE, 0x04FDF2, "string", "H1", "': [3' inside '[1: [2: [3: ... [8: '"),
    (0x04FDF4, 0x04FDF6, "string", "H1", "'[4' same string"),
    (0x04FDF8, 0x04FDFA, "string", "H1", "'[5' same string"),
    (0x04FE00, 0x04FE02, "string", "H1", "'[7' same string"),
    (0x051054, 0x051094, "string", "H1", "'    -1  -2 ... -15 ' 4-char field table"),
    (0x0510DA, 0x0510E2, "string", "H1", "':ack:rej'"),
    (0x0511D2, 0x05120E, "string", "H1", "NUL-terminated 3-char strings 'PPP','PP0',...,'AAA',...,'000'"),
    (0x0516C6, 0x0516C8, "string", "H1", "'[ ' opening '[   RAW DATA  ]'"),
    (0x0526FC, 0x052704, "string", "H1", "'....    '"),
    (0x052704, 0x05270A, "string", "H1", "'    ' + FF 00 (same string)"),
    (0x059C14, 0x059C28, "string", "H1", "20 spaces"),
    (0x05E08A, 0x05E0C0, "string", "H1", "'000102...26' two-digit table"),
    (0x066AF6, 0x066B06, "string", "H1", "16 x '-'; code resumes at 0x066B06 (entry of table 0x0669E0)"),
    (0x06A976, 0x06A97A, "string", "H1", "'.jpg'; code resumes at 0x06A97A"),
    (0x06AB5C, 0x06AB68, "string", "H1", "'NEW       ' + FF 00"),
    (0x06BE28, 0x06BE34, "string", "H1", "'USA JPN EXP ' (its 'bsr .+83' at 0x06BE28 targets odd 0x06BE7D)"),
    (0x06E05E, 0x06E062, "string", "H1", "'****'; code resumes at 0x06E062"),
    (0x073B62, 0x073B6C, "string", "H1", "10 spaces; code resumes at 0x073B6C"),
]
NOT_APPLIED = [
    (0x022E3A, 0x022E62, "fnindex", "decodes as code (bsr/bne/mov.b/jsr @0x3FFA0/rts); no proven flow reaches it; ASCII-looking start is coincidence"),
    (0x02D704, 0x02D708, "fnindex", "27 29 2a 29 = mov.b @0x29:8,r7h / mov.b @0x29:8,r2l before table entry 0x02D708; may be fall-through"),
    (0x02D7FE, 0x02D802, "fnindex", "20 22 23 22, same shape"),
    (0x02E2D8, 0x02E2DC, "fnindex", "27 29 2a 29, same shape"),
    (0x02E3D2, 0x02E3D6, "fnindex", "20 22 23 22, same shape"),
    (0x03400E, 0x034012, "fnindex", "27 29 2a 29, same shape"),
    (0x034F22, 0x034F24, "F1", "4f 6e (ble) 2 B before table entry 0x034F24"),
]

# ---------------------------------------------------------------- base sets
FN = {}
for f in ["main-low", "main-high-a", "main-high-b"]:
    L = open(R + "fnindex/%s.tsv" % f, encoding="utf-8").read().splitlines()
    h = L[0].split("\t")
    for ln in L[1:]:
        c = dict(zip(h, ln.split("\t")))
        if c["validated"] == "yes":
            FN[int(c["start"], 16)] = int(c["end"], 16)
A_mask = bytearray(HI)
for s, e in FN.items():
    for x in range(s, min(e, HI)):
        if mb[x]:
            A_mask[x] = 1
B_mask = bytearray(HI)
for s, e, t in runs:
    if t != "other":
        for x in range(s, e):
            B_mask[x] = 1
PROV = [ln.split("\t") for ln in open(R + "main-indirect/proved.tsv", encoding="utf-8").read().splitlines()]
PHDR, PROV = PROV[0], PROV[1:]
D_mask = bytearray(HI)
for c in PROV:
    for x in range(int(c[0], 16), int(c[1], 16)):
        D_mask[x] = 1
E_mask = bytearray(HI)
for ln in open(R + "main-raw-other/split.tsv", encoding="utf-8").read().splitlines():
    if ln.startswith("#") or ln.startswith("run_start"):
        continue
    c = ln.split("\t")
    if c[3] == "other" and c[4] in ("code",) or c[4].startswith("parameter table") and c[3] == "other":
        for x in range(int(c[0], 16), int(c[1], 16)):
            E_mask[x] = 1
# G1 new-and-uncredited bytes, replicated from h8s-decode/offline/cov.py (same inputs, same rules)
plan = json.load(open(R + "h8s-decode/work/absorb_plan.json", encoding="utf-8"))
tier = bytearray(HI)
for a, n, t, o in plan["insns"]:
    for x in range(a, a + n):
        tier[x] = 1 if t == "A" else 2
ATTR_A = [(0x07630A, 0x0767B6), (0x02F2E0, 0x02F35E), (0x02F36C, 0x02F386), (0x030E00, 0x030E62), (0x030E6A, 0x030E96),
          (0x038074, 0x03808C), (0x0380A2, 0x0380E8), (0x0380EA, 0x038102), (0x05AF70, 0x05AF7C), (0x077A1C, 0x077A2C)]
for s, e in ATTR_A:
    for x in range(s, e):
        if ma[x] and not mb[x]:
            tier[x] = 1
new = [x for x in range(HI) if ma[x] and not mb[x] and tier[x]]
lost = [x for x in range(HI) if mb[x] and not ma[x]]
cred = bytearray(HI)
for x in range(HI):
    if A_mask[x] or D_mask[x] or B_mask[x] or E_mask[x]:
        cred[x] = 1
F_mask = bytearray(HI)
for x in new:
    if not cred[x]:
        F_mask[x] = 1
G1A_mask = bytearray(HI)
for x in new:
    if tier[x] == 1 and not D_mask[x]:
        G1A_mask[x] = 1
RC_mask = bytearray(HI)
for s, e, t in runs:
    if t == "recovered code":
        for x in range(s, e):
            RC_mask[x] = 1

T = []


def row(k, v, src, note=""):
    T.append((k, str(v), src, note))


# ---------------------------------------------------------------- published reproduction
pub = dict(A=249098, B=222192, C=-28, D=19848, E=983, F=794, G=438300)
P = sum(pub.values())
row("A_fnindex_validated_iscode", 249098, "ida/out/fnindex/l1_counts.txt + w2_1_counts.txt + w2_2_counts.txt", "100,766 + 80,850 + 67,482 (published)")
row("A_check_items_before_mask", sum(A_mask), "fnindex/*.tsv validated=yes x h8s-decode/work/items_before.tsv is_code", "re-sum %+d vs published (MAIN_FULL dump differs from the fnindex DB by 44 B is_code)" % (sum(A_mask) - 249098))
row("B_typed_runs", sum(B_mask), "ida/out/wave2/main-raw-types.tsv type!=other", "")
row("C_doublecount_published", -28, "doc 33 (sub_1A25A 6, sub_1A432 4, sub_63C04 18)", "mask check A_mask & B_mask = %d: those 28 B are not is_code in MAIN_FULL, so A_mask = published A - 28" % sum(1 for x in range(HI) if A_mask[x] and B_mask[x]))
row("D_F1_proved_extents", sum(D_mask), "ida/out/main-indirect/proved.tsv sum(end-start)", "")
row("E_F2_newly_typed", sum(E_mask), "ida/out/main-raw-other/split.tsv old=other -> code / parameter table*", "")
row("F_G1_new_uncredited", sum(F_mask), "h8s-decode/work/items_{before,after}.tsv + absorb_plan.json (cov.py rules)", "doc 36: 794")
row("G_SUB_window_validated_iscode", 438300, "ida/out/sub-window/coverage.txt (297,232 + 141,068)", "unchanged by G/H")
row("headline_numerator_published", P, "A+B+C+D+E+F+G", "931,187 = 90.41%")
U = bytearray(HI)
for x in range(HI):
    if A_mask[x] or B_mask[x] or D_mask[x] or E_mask[x] or F_mask[x]:
        U[x] = 1
row("MAIN_union_bytes_precorrection", sum(U), "union A|B|D|E|F masks", "additive MAIN (A..F) = %d; difference = overlaps + A re-sum delta" % (P - 438300))
masks = dict(A=A_mask, B=B_mask, D=D_mask, E=E_mask, F=F_mask)
keys = list(masks)
for i, k1 in enumerate(keys):
    for k2 in keys[i + 1:]:
        ov = sum(1 for x in range(HI) if masks[k1][x] and masks[k2][x])
        row("overlap_%s_x_%s" % (k1, k2), ov, "byte intersection", "")

# ---------------------------------------------------------------- apply corrections
cA = 0; cH = 0; cHnot = 0; rows_fn = []
for s, e, typ, who, note in FNC:
    owner = [a for a, b in FN.items() if a <= s < b]
    assert owner, hex(s)
    inA = sum(A_mask[s:e])
    cA += inA
    cr = 0
    if typ:
        cr = sum(1 for x in range(s, e) if not (B_mask[x] or F_mask[x] or D_mask[x] or E_mask[x]))
        cH += cr
    else:
        cHnot += e - s
    rows_fn.append((s, e, owner[0], FN[owner[0]], e - s, inA, typ or "data, type not established (not credited)", cr, who, note, IMG[s:min(e, s + 16)].hex()))
cD = 0
for s, e, te, tb, kind, who, note in F1C:
    if kind == "text":
        assert all(32 <= c < 127 or c in (0, 0xFF) for c in IMG[s:s + tb]), hex(s)
        cD += tb
cH_f1 = cD  # F1 text retyped as string, credited
# odd heads inside recovered-code runs
oddrows = [l.rstrip("\n").split("\t") for l in open(OUT + "odd-heads.tsv", encoding="utf-8")
           if not l.startswith("#") and not l.startswith("ea\t")]
odd_rc_ascii = 0; odd_rc_bin = 0
for r_ in oddrows:
    a = int(r_[0], 16); n = int(r_[1]); reg = r_[4]; cl = r_[8]
    if reg != "run:recovered code":
        continue
    if cl.startswith("data: ASCII"):
        odd_rc_ascii += n
    elif cl.startswith("data"):
        odd_rc_bin += n
    elif cl.startswith("bogus: partly"):
        odd_rc_bin += sum(1 for x in range(a, a + n) if not PR[x])
# ---------------------------------------------------------------- headline
NEWP = P - cA + cH - cD + cH_f1 - odd_rc_bin
row("H1_A_removed_fnindex_spans", -cA, "recount/fnindex-corrections.tsv is_code_in_A", "%d spans" % len(FNC))
row("H1_retyped_credited_fnindex_spans", cH, "recount/fnindex-corrections.tsv credited_bytes", "string / parameter table, bytes not already credited")
row("H1_removed_not_credited", cHnot, "recount/fnindex-corrections.tsv new_type=data", "type not established")
row("H1_D_removed_F1_text", -cD, "recount/proved-corrected.tsv text_bytes", "G1 76 + H1 %d" % (cD - 76))
row("H1_retyped_F1_text_as_string", cH_f1, "recount/proved-corrected.tsv text_bytes", "credited as typed string")
row("H1_odd_heads_in_recovered_code_ascii", odd_rc_ascii, "recount/odd-heads.tsv", "retyped string; stays in numerator")
row("H1_odd_heads_in_recovered_code_untyped", -odd_rc_bin, "recount/odd-heads.tsv", "data, type not established; leaves numerator")
row("headline_numerator_H1", NEWP, "published + H1 rows", "")
row("headline_denominator", 1029972, "505,684 MAIN content + 524,288 SUB window", "unchanged")
row("headline_pct_H1", "%.4f" % (100 * NEWP / 1029972), "", "published %.4f" % (100 * P / 1029972))
# MAIN named/typed
MAINP = P - 438300; MAINN = NEWP - 438300
row("MAIN_named_or_typed_published", MAINP, "A+B+C+D+E+F", "%.2f%% of 505,684" % (100 * MAINP / 505684))
row("MAIN_named_or_typed_H1", MAINN, "", "%.2f%% of 505,684" % (100 * MAINN / 505684))
# MAIN proven code
PROVEN_P = 376290
proven_cut = cA + cD + odd_rc_ascii + odd_rc_bin
PROVEN_N = PROVEN_P - proven_cut
row("MAIN_proven_published", PROVEN_P, "249,098 A + 100,125 recovered-code runs + 19,848 D + 7,219 G1 tier A", "doc 36")
row("MAIN_proven_check_RC_bytes", sum(RC_mask), "main-raw-types.tsv type=recovered code", "")
row("MAIN_proven_check_G1_tierA", sum(G1A_mask), "replicated tier-A new bytes outside D", "doc 36: 7,219")
row("MAIN_proven_H1", PROVEN_N, "minus fnindex spans, F1 text, odd-head data in recovered-code runs", "-%d" % proven_cut)

# ---------------------------------------------------------------- decodable-instruction denominator
def odd_split(still_only):
    tot=0; code=0; n_=0
    for r_ in oddrows:
        if still_only and r_[9]!="yes": continue
        a=int(r_[0],16); n=int(r_[1]); cl=r_[8]; n_+=1
        tot+=n
        if cl.startswith("bogus: partly"): code+=sum(1 for x in range(a,a+n) if PR[x])
        elif cl.startswith("bogus"): code+=n
    return n_,tot,code
nb,tb_,cb_=odd_split(False); na_,ta_,ca_=odd_split(True)
fnc_b=sum(sum(mb[s:e]) for s,e,*_ in FNC); fnc_a=sum(sum(ma[s:e]) for s,e,*_ in FNC)
txt=[(s,s+tb) for s,e,te,tb,kind,who,note in F1C if kind=="text"]
txt_b=sum(sum(mb[s:e]) for s,e in txt); txt_a=sum(sum(ma[s:e]) for s,e in txt)
row("DEC_MAIN_FULL_published",380782,"ida/out/main-raw/l5_counts.txt instruction_bytes_content","items_before dump = %d"%sum(mb))
row("DEC_odd_heads_MAIN_FULL","%d heads / %d B"%(nb,tb_),"recount/odd-heads.tsv","%d B sit on real even code, %d B are data"%(cb_,tb_-cb_))
row("DEC_fnindex_spans_iscode_MAIN_FULL",fnc_b,"recount/fnindex-corrections.tsv x items_before","")
row("DEC_F1_text_iscode_MAIN_FULL",txt_b,"proved-delta.tsv text x items_before","")
decb=380782-(tb_-cb_)-fnc_b-txt_b
row("DEC_MAIN_FULL_corrected",decb,"380,782 - odd data - fnindex spans - F1 text","pre-G1 basis")
row("DEC_G1_published",391458,"ida/out/h8s-decode/coverage.txt (380,782 + 10,701 - 25)","items_after dump = %d"%sum(ma))
row("DEC_odd_heads_G1_H8S","%d heads / %d B"%(na_,ta_),"recount/odd-heads.tsv still_in_G1_H8S=yes","%d B on real even code, %d B data"%(ca_,ta_-ca_))
row("DEC_fnindex_spans_iscode_G1_H8S",fnc_a,"fnindex-corrections.tsv x items_after","")
row("DEC_F1_text_iscode_G1_H8S",txt_a,"proved-delta.tsv text x items_after","G1 left all but 6 B of this text as IDA code (items_after: data only at 0x04DE6C, 0x04DF70)")
deca=391458-(ta_-ca_)-fnc_a-txt_a
row("DEC_G1_corrected",deca,"391,458 - odd data - fnindex spans - F1 text","current basis")
# IDA-measured (H1_RECOUNT, ida/jobs/h1_recount.py): edits applied in the private DB, then is_code recounted
mh = bytearray(HI)
for ln in open(OUT + "work/items_h1.tsv", encoding="utf-8").read().splitlines()[1:]:
    ea, sz, k = ln.split("	")
    if k == "code":
        for x in range(int(ea, 16), int(ea, 16) + int(sz)): mh[x] = 1
oddA = bytearray(HI)
for ea, v in ia.items():
    if v[1] == "code" and ea % 2:
        for x in range(ea, ea + v[0]): oddA[x] = 1
on_odd = sum(1 for x in range(HI) if mh[x] and oddA[x])
gained = sum(1 for x in range(HI) if mh[x] and not ma[x])
row("DEC_IDA_H1_RECOUNT_is_code", sum(mh), "recount/work/items_h1.tsv (H1_RECOUNT after edits; h1_ida.txt)", "G1_H8S dump 391,452")
row("DEC_IDA_true_even_insn_bytes_on_old_odd_heads", on_odd, "items_h1 code x items_after odd heads", "arithmetic estimate %d" % ca_)
row("DEC_IDA_true_even_insn_bytes_not_code_before", gained, "items_h1 code minus items_after code", "real instruction bytes IDA had left undecoded between odd heads")
decI = 391458 - ta_ + on_odd + gained - (fnc_a + txt_a)
row("DEC_corrected_final", decI, "391,458 - %d odd-head B + %d + %d - %d H1 data spans" % (ta_, on_odd, gained, fnc_a + txt_a), "= IDA %d + 6 (published 391,458 vs dump 391,452)" % sum(mh))
deca = decI
row("MAIN_proven_pct_of_decodable_published","%.2f"%(100*PROVEN_P/391458),"376,290 / 391,458","")
row("MAIN_proven_pct_of_decodable_H1","%.2f"%(100*PROVEN_N/deca),"%d / %d"%(PROVEN_N,deca),"")
row("MAIN_proven_pct_of_content_H1","%.2f"%(100*PROVEN_N/505684),"%d / 505,684"%PROVEN_N,"published 74.41")

json.dump(dict(P=P, NEWP=NEWP, cA=cA, cH=cH, cHnot=cHnot, cD=cD, odd_rc_ascii=odd_rc_ascii, odd_rc_bin=odd_rc_bin,
               PROVEN_N=PROVEN_N, lost=len(lost)), open(OUT + "work_recount.json", "w", encoding="utf-8"), indent=1)

with open(OUT + "fnindex-corrections.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# H1: fnindex-validated MAIN functions whose span [span_start,span_end) is not code. Applied to the recount (A addend).\n")
    f.write("# Bytes read from decrypted/FT3D_MAIN_ver102_EXP.bin (base 0, file offset = address). credited_bytes = bytes re-credited under new_type (0 when the type is not established).\n")
    f.write("span_start\tspan_end\tfn_start\tfn_end\tbytes\tis_code_in_A\tnew_type\tcredited_bytes\tfound_by\tevidence\tfirst_bytes\n")
    for r_ in rows_fn:
        f.write("%06X\t%06X\t%06X\t%06X\t%d\t%d\t%s\t%d\t%s\t%s\t%s\n" % r_)
    f.write("# NOT applied (Unknown), listed for a later pass:\n")
    for s, e, src, note in NOT_APPLIED:
        f.write("# %06X\t%06X\t%s\t%d B\t%s\t%s\n" % (s, e, src, e - s, note, IMG[s:e][:16].hex()))

# proved-corrected.tsv: F1's 444 rows, corrected copy
F1D = {s: (e, te, tb, kind, who, note) for s, e, te, tb, kind, who, note in F1C}
with open(OUT + "proved-corrected.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("# H1 corrected copy of ida/out/main-indirect/proved.tsv (F1's file is unchanged). 'bytes' = credited code bytes after correction.\n")
    f.write("# h1_action: keep | reattributed (row start was +2 into an H8SX MOV.L; bytes are still proven code via the parent named in h1_evidence)\n")
    f.write("#            | text-trimmed (row opened with ASCII; start moved to the true entry; text_bytes retyped as string).\n")
    f.write("\t".join(PHDR + ["orig_start", "orig_bytes", "text_bytes", "true_insn_or_entry", "h1_action", "found_by", "h1_evidence"]) + "\n")
    tot = 0
    for c in PROV:
        s = int(c[0], 16); e = int(c[1], 16)
        cc = list(c)
        if s in F1D:
            e2, te, tb, kind, who, note = F1D[s]
            if kind == "text":
                cc[0] = "%06X" % te; cc[2] = str(e - te)
                act = "text-trimmed"
            else:
                act = "reattributed"
            extra = [c[0], c[2], str(tb), "%06X" % te, act, who, note]
        else:
            extra = [c[0], c[2], "0", "-", "keep", "-", "-"]
        tot += int(cc[2])
        f.write("\t".join(cc + extra) + "\n")
row("D_H1_proved_corrected_sum", tot, "recount/proved-corrected.tsv sum(bytes)", "")
with open(OUT + "proved-delta.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("orig_start\torig_end\torig_bytes\tcorrected_start\tcorrected_bytes\tdelta_code_bytes\ttext_bytes\taction\tfound_by\tbytes_at_orig_start\tbytes_at_corrected\tevidence\n")
    for s, e, te, tb, kind, who, note in F1C:
        cs = te if kind == "text" else s
        f.write("%06X\t%06X\t%d\t%06X\t%d\t%d\t%d\t%s\t%s\t%s\t%s\t%s\n" % (
            s, e, e - s, cs, e - cs, -(cs - s), tb, "text-trimmed" if kind == "text" else "reattributed", who,
            IMG[s:s + 8].hex(" "), IMG[te:te + 8].hex(" "), note))
with open(OUT + "recount.tsv", "w", encoding="utf-8", newline="\n") as f:
    f.write("metric\tvalue\tsource\tnote\n")
    for t in T:
        f.write("\t".join(t) + "\n")
print("\n".join("\t".join(t) for t in T))
