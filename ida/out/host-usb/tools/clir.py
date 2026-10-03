r"""Minimal CLI metadata reader: TypeDef/MethodDef/MemberRef/ImplMap/ModuleRef
plus #US user strings and raw IL for named methods.  Enough to recover the
managed surface of a mixed-mode C++/CLI assembly without a .NET decompiler."""
import struct, sys

f = sys.argv[1]
d = open(f, "rb").read()
pe = struct.unpack_from("<I", d, 0x3C)[0]
nsec = struct.unpack_from("<H", d, pe + 6)[0]
ohsz = struct.unpack_from("<H", d, pe + 20)[0]
magic = struct.unpack_from("<H", d, pe + 24)[0]
oh = pe + 24
base = struct.unpack_from("<Q" if magic == 0x20B else "<I", d, oh + (24 if magic == 0x20B else 28))[0]
ddir = oh + (112 if magic == 0x20B else 96)
secs = []
t = pe + 24 + ohsz
for i in range(nsec):
    o = t + 40 * i
    nm = d[o:o + 8].rstrip(b"\0").decode("latin1")
    vs, va, rs, ra = struct.unpack_from("<IIII", d, o + 8)
    secs.append((nm, va, vs, ra, rs))


def r2o(rva):
    for nm, va, vs, ra, rs in secs:
        if va <= rva < va + max(vs, rs):
            return ra + rva - va
    return None


clr_rva, clr_sz = struct.unpack_from("<II", d, ddir + 14 * 8)
co = r2o(clr_rva)
md_rva, md_sz = struct.unpack_from("<II", d, co + 8)
flags, entry = struct.unpack_from("<II", d, co + 16)
vt_rva, vt_sz = struct.unpack_from("<II", d, co + 40)
print("# COR20 flags %#x entrypoint_token %#x vtablefixups rva %#x size %d"
      % (flags, entry, vt_rva, vt_sz))
mo = r2o(md_rva)
assert d[mo:mo + 4] == b"BSJB"
vlen = struct.unpack_from("<I", d, mo + 12)[0]
p = mo + 16 + vlen
nstreams = struct.unpack_from("<H", d, p + 2)[0]
p += 4
streams = {}
for _ in range(nstreams):
    off, size = struct.unpack_from("<II", d, p)
    p += 8
    e = d.index(b"\0", p)
    nm = d[p:e].decode("latin1")
    p = (e + 1 + 3) & ~3
    streams[nm] = (mo + off, size)
print("# streams", {k: (hex(v[0]), v[1]) for k, v in streams.items()})

so, ssz = streams["#Strings"]
STR = d[so:so + ssz]


def s(idx):
    e = STR.index(b"\0", idx)
    return STR[idx:e].decode("utf-8", "replace")


us = streams.get("#US")
blob = streams.get("#Blob")

to, tsz = streams["#~"]
heapsz = d[to + 6]
valid, sorted_ = struct.unpack_from("<QQ", d, to + 8)
p = to + 24
rows = {}
for i in range(64):
    if valid >> i & 1:
        rows[i] = struct.unpack_from("<I", d, p)[0]
        p += 4
SIDX = 4 if heapsz & 1 else 2
GIDX = 4 if heapsz & 2 else 2
BIDX = 4 if heapsz & 4 else 2

TN = {0: "Module", 1: "TypeRef", 2: "TypeDef", 4: "Field", 6: "MethodDef", 8: "Param",
      9: "InterfaceImpl", 10: "MemberRef", 11: "Constant", 12: "CustomAttribute",
      14: "DeclSecurity", 15: "ClassLayout", 16: "FieldLayout", 17: "StandAloneSig",
      18: "EventMap", 20: "Event", 21: "PropertyMap", 23: "Property",
      24: "MethodSemantics", 25: "MethodImpl", 26: "ModuleRef", 27: "TypeSpec",
      28: "ImplMap", 29: "FieldRVA", 32: "Assembly", 35: "AssemblyRef",
      38: "File", 39: "ExportedType", 40: "ManifestResource", 41: "NestedClass",
      42: "GenericParam", 44: "GenericParamConstraint"}
print("# tables", {TN.get(k, k): v for k, v in sorted(rows.items())})


def ridx(tables):
    """coded/simple index width for a set of table ids"""
    if isinstance(tables, int):
        return 4 if rows.get(tables, 0) >= 0x10000 else 2
    bits = (len(tables) - 1).bit_length()
    mx = max(rows.get(t, 0) for t in tables)
    return 4 if mx >= (1 << (16 - bits)) else 2


TYPEDEFORREF = [2, 1, 27]
MEMBERFORWARDED = [4, 6]
MEMBERREFPARENT = [2, 1, 26, 6, 27]
HASCUSTOMATTR = [6, 4, 1, 2, 8, 9, 10, 11, 12, 14, 17, 20, 23, 26, 27, 32, 35, 38, 39, 40, 44]

SCHEMA = {
    0:  [("Generation", 2), ("Name", "S"), ("Mvid", "G"), ("EncId", "G"), ("EncBaseId", "G")],
    1:  [("ResolutionScope", ("c", [26, 35, 38, 1])), ("Name", "S"), ("Namespace", "S")],
    2:  [("Flags", 4), ("Name", "S"), ("Namespace", "S"),
         ("Extends", ("c", TYPEDEFORREF)), ("FieldList", ("t", 4)), ("MethodList", ("t", 6))],
    4:  [("Flags", 2), ("Name", "S"), ("Signature", "B")],
    6:  [("RVA", 4), ("ImplFlags", 2), ("Flags", 2), ("Name", "S"),
         ("Signature", "B"), ("ParamList", ("t", 8))],
    8:  [("Flags", 2), ("Sequence", 2), ("Name", "S")],
    9:  [("Class", ("t", 2)), ("Interface", ("c", TYPEDEFORREF))],
    10: [("Class", ("c", MEMBERREFPARENT)), ("Name", "S"), ("Signature", "B")],
    11: [("Type", 1), ("Pad", 1), ("Parent", ("c", [4, 8, 23])), ("Value", "B")],
    13: [("Parent", ("c", [4, 8])), ("NativeType", "B")],
    12: [("Parent", ("c", HASCUSTOMATTR)), ("Type", ("c", [6, 10])), ("Value", "B")],
    14: [("Action", 2), ("Parent", ("c", [2, 6, 32])), ("PermissionSet", "B")],
    15: [("PackingSize", 2), ("ClassSize", 4), ("Parent", ("t", 2))],
    16: [("Offset", 4), ("Field", ("t", 4))],
    17: [("Signature", "B")],
    18: [("Parent", ("t", 2)), ("EventList", ("t", 20))],
    20: [("EventFlags", 2), ("Name", "S"), ("EventType", ("c", TYPEDEFORREF))],
    21: [("Parent", ("t", 2)), ("PropertyList", ("t", 23))],
    23: [("Flags", 2), ("Name", "S"), ("Type", "B")],
    24: [("Semantics", 2), ("Method", ("t", 6)), ("Association", ("c", [20, 23]))],
    25: [("Class", ("t", 2)), ("MethodBody", ("c", [6, 10])), ("MethodDeclaration", ("c", [6, 10]))],
    26: [("Name", "S")],
    27: [("Signature", "B")],
    28: [("MappingFlags", 2), ("MemberForwarded", ("c", MEMBERFORWARDED)),
         ("ImportName", "S"), ("ImportScope", ("t", 26))],
    29: [("RVA", 4), ("Field", ("t", 4))],
    32: [("HashAlgId", 4), ("Major", 2), ("Minor", 2), ("Build", 2), ("Rev", 2),
         ("Flags", 4), ("PublicKey", "B"), ("Name", "S"), ("Culture", "S")],
    35: [("Major", 2), ("Minor", 2), ("Build", 2), ("Rev", 2), ("Flags", 4),
         ("PublicKeyOrToken", "B"), ("Name", "S"), ("Culture", "S"), ("HashValue", "B")],
    38: [("Flags", 4), ("Name", "S"), ("HashValue", "B")],
    39: [("Flags", 4), ("TypeDefId", 4), ("Name", "S"), ("Namespace", "S"),
         ("Implementation", ("c", [38, 35, 39]))],
    40: [("Offset", 4), ("Flags", 4), ("Name", "S"), ("Implementation", ("c", [38, 35, 39]))],
    41: [("NestedClass", ("t", 2)), ("EnclosingClass", ("t", 2))],
    42: [("Number", 2), ("Flags", 2), ("Owner", ("c", [2, 6])), ("Name", "S")],
    44: [("Owner", ("t", 42)), ("Constraint", ("c", TYPEDEFORREF))],
}

tables = {}
for tid in sorted(rows):
    cols = SCHEMA.get(tid)
    if cols is None:
        print("# unknown table", tid, "- stopping")
        break
    out = []
    for _ in range(rows[tid]):
        rec = {}
        for name, kind in cols:
            if kind == "S":
                w = SIDX
            elif kind == "G":
                w = GIDX
            elif kind == "B":
                w = BIDX
            elif isinstance(kind, int):
                w = kind
            elif kind[0] == "t":
                w = ridx(kind[1])
            else:
                w = ridx(kind[1])
            v = int.from_bytes(d[p:p + w], "little")
            p += w
            rec[name] = v
            if isinstance(kind, tuple) and kind[0] == "c":
                bits = (len(kind[1]) - 1).bit_length()
                rec[name + "_tbl"] = kind[1][v & ((1 << bits) - 1)] if (v & ((1 << bits) - 1)) < len(kind[1]) else -1
                rec[name + "_row"] = v >> bits
        out.append(rec)
    tables[tid] = out

TD = tables.get(2, [])
MD = tables.get(6, [])
MR = tables.get(10, [])
TR = tables.get(1, [])
IM = tables.get(28, [])
MODR = tables.get(26, [])

# ---- type of each method ------------------------------------------------
owner = {}
for i, td in enumerate(TD):
    start = td["MethodList"] - 1
    end = TD[i + 1]["MethodList"] - 1 if i + 1 < len(TD) else len(MD)
    for m in range(start, end):
        owner[m] = i

print("\n===== TypeDefs =====")
for i, td in enumerate(TD):
    print("%3d  %s%s" % (i, (s(td["Namespace"]) + ".") if td["Namespace"] else "", s(td["Name"])))

print("\n===== MethodDefs (rva, flags, owner.name) =====")
for i, m in enumerate(MD):
    o = owner.get(i)
    tn = (s(TD[o]["Name"]) if o is not None else "?")
    print("%4d  rva=%08X impl=%04X flags=%04X  %s::%s" %
          (i + 1, m["RVA"], m["ImplFlags"], m["Flags"], tn, s(m["Name"])))

print("\n===== ModuleRef (P/Invoke target modules) =====")
for i, r in enumerate(MODR):
    print("%3d  %s" % (i + 1, s(r["Name"])))

print("\n===== ImplMap (P/Invoke) =====")
for r in IM:
    mrow = r["MemberForwarded_row"] - 1
    nm = s(MD[mrow]["Name"]) if r["MemberForwarded_tbl"] == 6 and 0 <= mrow < len(MD) else "?"
    scope = s(MODR[r["ImportScope"] - 1]["Name"]) if 0 < r["ImportScope"] <= len(MODR) else "?"
    print("  flags=%04X  %s -> %s!%s" % (r["MappingFlags"], nm, scope, s(r["ImportName"])))

print("\n===== MemberRef (external calls) =====")
seen = set()
for r in MR:
    pt, pr = r["Class_tbl"], r["Class_row"]
    if pt == 1 and 0 < pr <= len(TR):
        tr = TR[pr - 1]
        par = ((s(tr["Namespace"]) + ".") if tr["Namespace"] else "") + s(tr["Name"])
    elif pt == 26 and 0 < pr <= len(MODR):
        par = "[module]" + s(MODR[pr - 1]["Name"])
    elif pt == 2 and 0 < pr <= len(TD):
        par = s(TD[pr - 1]["Name"])
    else:
        par = "tbl%d#%d" % (pt, pr)
    k = par + "::" + s(r["Name"])
    if k not in seen:
        seen.add(k)
        print("  " + k)

if us:
    uo, usz = us
    print("\n===== #US user strings =====")
    q = uo + 1
    while q < uo + usz:
        b0 = d[q]
        if b0 < 0x80:
            ln = b0; q += 1
        elif b0 & 0xC0 == 0x80:
            ln = ((b0 & 0x3F) << 8) | d[q + 1]; q += 2
        else:
            ln = ((b0 & 0x1F) << 24) | (d[q + 1] << 16) | (d[q + 2] << 8) | d[q + 3]; q += 4
        if ln == 0:
            continue
        raw = d[q:q + ln]
        q += ln
        try:
            txt = raw[:-1 if ln % 2 else None].decode("utf-16-le", "replace")
        except Exception:
            txt = repr(raw)
        if txt.strip():
            print("  " + txt.replace("\n", "\\n").replace("\r", "\\r"))

# ---- crude IL dumper for named methods ---------------------------------
WANT = [w for w in sys.argv[2:]]
if WANT:
    def mname(i):
        o = owner.get(i - 1)
        return (s(TD[o]["Name"]) + "::" if o is not None else "") + s(MD[i - 1]["Name"])

    def tokname(tok):
        tbl, row = tok >> 24, tok & 0xFFFFFF
        if tbl == 0x06 and 0 < row <= len(MD):
            return mname(row)
        if tbl == 0x0A and 0 < row <= len(MR):
            r = MR[row - 1]
            pt, pr = r["Class_tbl"], r["Class_row"]
            if pt == 1 and 0 < pr <= len(TR):
                tr = TR[pr - 1]
                par = ((s(tr["Namespace"]) + ".") if tr["Namespace"] else "") + s(tr["Name"])
            elif pt == 26:
                par = "[thismodule]"
            elif pt == 2 and 0 < pr <= len(TD):
                par = s(TD[pr - 1]["Name"])
            else:
                par = "tbl%d#%d" % (pt, pr)
            return par + "::" + s(r["Name"])
        if tbl == 0x70:
            return "<string#%x>" % row
        if tbl == 0x01 and 0 < row <= len(TR):
            tr = TR[row - 1]
            return ((s(tr["Namespace"]) + ".") if tr["Namespace"] else "") + s(tr["Name"])
        return "tok%08X" % tok

    OPS = {0x00: "nop", 0x01: "break", 0x02: "ldarg.0", 0x03: "ldarg.1", 0x04: "ldarg.2",
           0x05: "ldarg.3", 0x06: "ldloc.0", 0x07: "ldloc.1", 0x08: "ldloc.2",
           0x09: "ldloc.3", 0x0A: "stloc.0", 0x0B: "stloc.1", 0x0C: "stloc.2",
           0x0D: "stloc.3", 0x14: "ldnull", 0x15: "ldc.i4.m1", 0x16: "ldc.i4.0",
           0x17: "ldc.i4.1", 0x18: "ldc.i4.2", 0x19: "ldc.i4.3", 0x1A: "ldc.i4.4",
           0x1B: "ldc.i4.5", 0x1C: "ldc.i4.6", 0x1D: "ldc.i4.7", 0x1E: "ldc.i4.8",
           0x25: "dup", 0x26: "pop", 0x2A: "ret", 0x58: "add", 0x59: "sub", 0x5A: "mul",
           0x65: "neg", 0x69: "conv.i4", 0x6A: "conv.i8", 0x4A: "ldind.i4",
           0x52: "stind.i4", 0x46: "ldind.i1", 0x47: "ldind.u1", 0x4E: "ldind.i",
           0xD3: "conv.i", 0xD1: "conv.u2", 0xD2: "conv.u1"}
    ONE = {0x0E: "ldarga.s", 0x0F: "ldarga.s", 0x10: "starg.s", 0x11: "ldloc.s",
           0x12: "ldloca.s", 0x13: "stloc.s", 0x1F: "ldc.i4.s", 0x2B: "br.s",
           0x2C: "brfalse.s", 0x2D: "brtrue.s", 0x2E: "beq.s", 0x2F: "bge.s",
           0x30: "bgt.s", 0x31: "ble.s", 0x32: "blt.s"}
    TOK = {0x28: "call", 0x6F: "callvirt", 0x73: "newobj", 0x72: "ldstr",
           0x7B: "ldfld", 0x7C: "ldflda", 0x7D: "stfld", 0x7E: "ldsfld",
           0x7F: "ldsflda", 0x80: "stsfld", 0x8D: "newarr", 0xFE06: "ldftn",
           0x71: "ldobj", 0x81: "stobj", 0x74: "castclass", 0x75: "isinst"}
    for i, m in enumerate(MD, 1):
        nm = mname(i)
        if not any(w.lower() in nm.lower() for w in WANT):
            continue
        rva = m["RVA"]
        if not rva:
            print("\n---- %s : no body" % nm); continue
        o = r2o(rva)
        b0 = d[o]
        if b0 & 3 == 2:
            size = b0 >> 2; code = o + 1
        else:
            size = struct.unpack_from("<I", d, o + 4)[0]
            code = o + 12
        print("\n---- %s  (rva %#x, %d bytes IL)" % (nm, rva, size))
        q = code; end = code + size
        while q < end:
            off = q - code
            op = d[q]; q += 1
            if op == 0xFE:
                op = 0xFE00 | d[q]; q += 1
            if op in TOK:
                tok = struct.unpack_from("<I", d, q)[0]; q += 4
                print("  IL_%04X: %-10s %s" % (off, TOK[op], tokname(tok)))
            elif op in ONE:
                v = d[q]; q += 1
                print("  IL_%04X: %-10s %d" % (off, ONE[op], v))
            elif op == 0x20:
                v = struct.unpack_from("<i", d, q)[0]; q += 4
                print("  IL_%04X: ldc.i4     %d (%#x)" % (off, v, v & 0xFFFFFFFF))
            elif op == 0x21:
                v = struct.unpack_from("<q", d, q)[0]; q += 8
                print("  IL_%04X: ldc.i8     %d" % (off, v))
            elif op in (0x38, 0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40):
                v = struct.unpack_from("<i", d, q)[0]; q += 4
                print("  IL_%04X: br(%02X)     %+d" % (off, op, v))
            elif op in OPS:
                print("  IL_%04X: %s" % (off, OPS[op]))
            else:
                print("  IL_%04X: op_%02X" % (off, op))
