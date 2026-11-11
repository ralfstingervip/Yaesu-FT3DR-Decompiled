"""Rebuild per-function disassembly listings from the IDA outputs in ida/out.

No firmware image is needed: the instruction text is taken from the TSV dumps
the earlier waves already published. Output goes to the directory given as the
first argument (default decomp/listing), one file per 64 KiB region:

  main/<start>.lst   MAIN H8SX, functions from main-final7
  sub/<start>.lst    SUB RX64M, functions from sub-final3

Each function block starts with ';=== <start>-<end> <name> size N'. Lines are
'<ea>  <text>'. Instructions with no text in any dump are printed as
'<ea>  ?? (len N, no text in dumps)'.
"""
import csv, os, sys, re
from collections import defaultdict

OUT = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else "decomp/listing")
os.chdir(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "ida", "out"))
csv.field_size_limit(10**9)

def rows(path):
    with open(path, newline="", encoding="utf-8", errors="replace") as f:
        yield from csv.DictReader(f, delimiter="\t")

def hx(s):
    s = s.strip()
    return int(s, 16) if s else None

# ---------------- MAIN ----------------
main_text = {}
def add_main(path, ea_col, txt_col):
    if not os.path.exists(path): return
    for r in rows(path):
        try: ea = hx(r[ea_col])
        except Exception: continue
        t = (r.get(txt_col) or "").strip()
        if ea is not None and t and ea not in main_text:
            main_text[ea] = t
# IDA-style text first (has names), oracle text as fallback
for p, e, t in [
    ("protocols/main_operands.tsv", "ea", "disasm"),
    ("main-final-unnamed/work/n2_heads.tsv", "ea", "disasm"),
    ("unread-tables/work/n3_heads.tsv", "ea", "disasm"),
    ("inferred-tables/work/m6_heads.tsv", "ea", "disasm"),
    ("main-unnamed/work/ida_items.tsv", "ea", "disasm"),
    ("fnindex-lo/ida-items.tsv", "ea", "disasm"),
    ("fnindex-mid/work/l3_ida_heads.tsv", "ea", "disasm"),
    ("punr-mid/work/m3_ida_heads.tsv", "ea", "disasm"),
    ("main-descent/work/reached_insns.tsv", "addr", "text"),
    ("h8s-decode/work/text_out.tsv", "ea", "text"),
    ("h8s-decode/work/sx_text.tsv", "ea", "text"),
    ("main-final2/merged-insns.tsv", "addr", "text"),
    ("main-final4/new-heads.tsv", "ea", "text"),
    ("service-window/insns.tsv", "addr", "text"),
    ("dead-code-tier/work/m5_idadec.tsv", "ea", "disasm"),
]:
    add_main(p, e, t)

heads = []
for r in rows("main-final7/MAIN_FINAL7_heads.tsv"):
    heads.append((int(r["ea"], 16), int(r["size"]), r["kind"]))
funcs = [(int(r["start"], 16), int(r["end"], 16)) for r in rows("main-final7/MAIN_FINAL7_functions_raw.tsv")]
names = {}
for p in ("main-full/functions.tsv",):
    for r in rows(p):
        names[int(r["ea"], 16)] = r["name"]
for r in rows("hidden/names_main.tsv"):
    names[int(r["ea"], 16)] = r["name"]

def emit(core, funcs, heads, text, names, fmt):
    d = os.path.join(OUT, core); os.makedirs(d, exist_ok=True)
    funcs.sort()
    hi = 0; heads.sort()
    files = defaultdict(list); missing = total = 0
    for s, e in funcs:
        while hi < len(heads) and heads[hi][0] < s: hi += 1
        j = hi
        lines = [f";=== {fmt(s)}-{fmt(e)} {names.get(s, 'sub_%X' % s)} size {e-s}"]
        while j < len(heads) and heads[j][0] < e:
            ea, sz, kind = heads[j]
            t = text.get(ea)
            if kind == "code":
                total += 1
                if not t: missing += 1; t = f"?? (len {sz}, no text in dumps)"
            else:
                t = f".data {sz}" + (f"  {t}" if t else "")
            lines.append(f"{fmt(ea)}  {t}")
            j += 1
        files[s >> 16].append("\n".join(lines))
    for k, blocks in files.items():
        with open(os.path.join(d, fmt(k << 16) + ".lst"), "w") as f:
            f.write("\n\n".join(blocks) + "\n")
    return total, missing

t, m = emit("main", funcs, heads, main_text, names, lambda x: "%06X" % x)
print("MAIN funcs", len(funcs), "code heads in funcs", t, "no text", m)

# ---------------- SUB ----------------
sub_text = {}; sheads = []
for r in rows("sub-residue-final/raw/codeheads.tsv"):
    ea = int(r["ea"], 16); sub_text[ea] = r["disasm"].strip()
    sheads.append((ea, int(r["size"]), "code"))
sfuncs = []; snames = {}
for r in rows("sub-final3/functions.tsv"):
    s, e = int(r["start"], 16), int(r["end"], 16)
    sfuncs.append((s, e)); snames[s] = r["name"]
t, m = emit("sub", sfuncs, sheads, sub_text, snames, lambda x: "%08X" % x)
print("SUB funcs", len(sfuncs), "code heads in funcs", t, "no text", m)
