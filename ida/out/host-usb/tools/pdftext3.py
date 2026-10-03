r"""PDF text extractor for an AESV2-encrypted (empty user password) PDF."""
import hashlib, re, struct, sys, zlib
from Crypto.Cipher import AES

PAD = bytes([0x28, 0xBF, 0x4E, 0x5E, 0x4E, 0x75, 0x8A, 0x41, 0x64, 0x00, 0x4E, 0x56,
             0xFF, 0xFA, 0x01, 0x08, 0x2E, 0x2E, 0x00, 0xB6, 0xD0, 0x68, 0x3E, 0x80,
             0x2F, 0x0C, 0xA9, 0xFE, 0x64, 0x53, 0x69, 0x7A])

data = open(sys.argv[1], "rb").read()

def _pdfstr(tag):
    i = data.find(tag)
    j = i + len(tag)
    out = bytearray()
    while j < len(data):
        c = data[j]
        if c == 0x5C:
            nx = data[j + 1]
            mp = {0x6E: 10, 0x72: 13, 0x74: 9, 0x62: 8, 0x66: 12}
            if nx in mp:
                out.append(mp[nx]); j += 2; continue
            if 0x30 <= nx <= 0x37:
                k = j + 1; o = ""
                while k < len(data) and len(o) < 3 and 0x30 <= data[k] <= 0x37:
                    o += chr(data[k]); k += 1
                out.append(int(o, 8) & 0xFF); j = k; continue
            out.append(nx); j += 2; continue
        if c == 0x29:
            break
        out.append(c); j += 1
    return bytes(out)


O = _pdfstr(b"/O(")
P = int(re.search(rb"/P\s+(-?\d+)", data).group(1))
idm = re.search(rb"/ID\s*\[\s*<([0-9A-Fa-f]+)>", data)
fid = bytes.fromhex(idm.group(1).decode())
n = int(re.search(rb"/Length\s+(\d+)\s*/O\(", data).group(1)) // 8 if re.search(
    rb"/Length\s+(\d+)\s*/O\(", data) else 16
h = hashlib.md5(PAD + O + struct.pack("<i", P) + fid).digest()
for _ in range(50):
    h = hashlib.md5(h[:n]).digest()
KEY = h[:n]


def objkey(num, gen):
    k = hashlib.md5(KEY + struct.pack("<I", num)[:3] + struct.pack("<I", gen)[:2]
                    + b"sAlT").digest()
    return k[:min(n + 5, 16)]


def dec_aes(blob, num, gen):
    if len(blob) < 32:
        return b""
    k = objkey(num, gen)
    body = blob[:len(blob) // 16 * 16]
    out = AES.new(k, AES.MODE_CBC, body[:16]).decrypt(body[16:])
    if out and 1 <= out[-1] <= 16:
        out = out[:-out[-1]]
    return out


# ---- collect raw objects -------------------------------------------------
raw_objs = {}
for m in re.finditer(rb"(?<![0-9])(\d+)\s+(\d+)\s+obj", data):
    num, gen = int(m.group(1)), int(m.group(2))
    e = data.find(b"endobj", m.end())
    raw_objs[num] = (gen, data[m.end():e if e > 0 else len(data)])


def split(body):
    i = body.find(b"<<")
    if i < 0:
        return b"", None
    depth, j = 0, i
    while j < len(body):
        if body[j:j + 2] == b"<<":
            depth += 1; j += 2; continue
        if body[j:j + 2] == b">>":
            depth -= 1; j += 2
            if depth == 0:
                break
            continue
        j += 1
    dd = body[i:j]
    s = body.find(b"stream", j)
    st = None
    if s >= 0:
        k = s + 6
        while k < len(body) and body[k] in (13, 10):
            k += 1
        e = body.rfind(b"endstream")
        st = body[k:e]
        while st and st[-1] in (13, 10):
            st = st[:-1]
    return dd, st


def unpredict(dd, buf):
    pm = re.search(rb"/Predictor\s+(\d+)", dd)
    if not pm or int(pm.group(1)) < 10:
        return buf
    g = lambda k, dv: int(m.group(1)) if (m := re.search(rb"/" + k + rb"\s+(\d+)", dd)) else dv
    cols = g(b"Columns", 1); colors = g(b"Colors", 1); bpc = g(b"BitsPerComponent", 8)
    bpp = max(1, colors * bpc // 8); rowlen = cols * colors * bpc // 8
    out, prev, p = bytearray(), bytearray(rowlen), 0
    while p + 1 + rowlen <= len(buf):
        ft = buf[p]; row = bytearray(buf[p + 1:p + 1 + rowlen]); p += 1 + rowlen
        if ft == 1:
            for i in range(bpp, rowlen): row[i] = (row[i] + row[i - bpp]) & 0xFF
        elif ft == 2:
            for i in range(rowlen): row[i] = (row[i] + prev[i]) & 0xFF
        elif ft == 3:
            for i in range(rowlen):
                left = row[i - bpp] if i >= bpp else 0
                row[i] = (row[i] + ((left + prev[i]) >> 1)) & 0xFF
        elif ft == 4:
            for i in range(rowlen):
                a = row[i - bpp] if i >= bpp else 0
                b = prev[i]; c = prev[i - bpp] if i >= bpp else 0
                pp = a + b - c
                pa, pb, pc = abs(pp - a), abs(pp - b), abs(pp - c)
                pr = a if (pa <= pb and pa <= pc) else (b if pb <= pc else c)
                row[i] = (row[i] + pr) & 0xFF
        out += row; prev = row
    return bytes(out)


def stream_of(num):
    """decrypted + decompressed stream of object num, or None"""
    if num not in raw_objs:
        return None, b""
    gen, body = raw_objs[num]
    dd, st = split(body)
    if st is None:
        return dd, b""
    blob = dec_aes(st, num, gen)
    if b"/FlateDecode" in dd:
        try:
            blob = zlib.decompressobj().decompress(blob)
        except Exception:
            return dd, b""
        blob = unpredict(dd, blob)
    return dd, blob


# ---- expand object streams ---------------------------------------------
objs = {}
for num in raw_objs:
    dd, _ = split(raw_objs[num][1])
    objs[num] = raw_objs[num][1]
for num in list(raw_objs):
    dd, blob = stream_of(num)
    if not dd or b"/ObjStm" not in dd or not blob:
        continue
    N = int(re.search(rb"/N\s+(\d+)", dd).group(1))
    first = int(re.search(rb"/First\s+(\d+)", dd).group(1))
    hdr = blob[:first].split()
    for i in range(0, min(len(hdr) - 1, 2 * N), 2):
        onum, off = int(hdr[i]), int(hdr[i + 1])
        end = first + int(hdr[i + 3]) if i + 3 < len(hdr) else len(blob)
        if onum not in raw_objs:
            objs[onum] = blob[first + off:end]        # already decrypted


def body_of(num):
    return objs.get(num, b"")


# ---- ToUnicode maps ----------------------------------------------------
def parse_cmap(txt):
    mp = {}
    for blk in re.findall(rb"beginbfchar(.*?)endbfchar", txt, re.S):
        for a, b in re.findall(rb"<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>", blk):
            mp[int(a, 16)] = "".join(chr(int(b[i:i + 4], 16)) for i in range(0, len(b), 4))
    for blk in re.findall(rb"beginbfrange(.*?)endbfrange", txt, re.S):
        for lo, hi, dst in re.findall(rb"<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>\s*<([0-9A-Fa-f]+)>", blk):
            lo, hi, d0 = int(lo, 16), int(hi, 16), int(dst, 16)
            for k in range(lo, min(hi, lo + 0x4000) + 1):
                mp[k] = chr(d0 + k - lo)
    return mp


fonts = {}
for num in list(raw_objs) + list(objs):
    b = body_of(num)
    if b"/Font" not in b[:600]:
        continue
    tu = re.search(rb"/ToUnicode\s+(\d+)\s+\d+\s+R", b)
    mp = None
    if tu:
        _, cm = stream_of(int(tu.group(1)))
        if cm:
            mp = parse_cmap(cm)
    fonts[num] = (mp, b"/Type0" in b)

STR = re.compile(rb"\((?:\\.|[^\\()])*\)|<[0-9A-Fa-f\s]*>", re.S)


def unescape(s):
    s = s[1:-1]; out = bytearray(); i = 0
    while i < len(s):
        c = s[i]
        if c == 0x5C and i + 1 < len(s):
            nx = s[i + 1]
            mp = {0x6E: 10, 0x72: 13, 0x74: 9, 0x62: 8, 0x66: 12}
            if nx in mp:
                out.append(mp[nx]); i += 2; continue
            if 0x30 <= nx <= 0x37:
                j = i + 1; o = ""
                while j < len(s) and len(o) < 3 and 0x30 <= s[j] <= 0x37:
                    o += chr(s[j]); j += 1
                out.append(int(o, 8) & 0xFF); i = j; continue
            out.append(nx); i += 2; continue
        out.append(c); i += 1
    return bytes(out)


def render(content, fmap):
    txt = []; cur = (None, False)
    pat = re.compile(rb"/([A-Za-z0-9_.+-]+)\s+[-\d.]+\s+Tf|"
                     rb"(\[(?:[^\[\]\\]|\\.|\((?:\\.|[^\\()])*\))*\])\s*TJ|"
                     rb"((?:\((?:\\.|[^\\()])*\)|<[0-9A-Fa-f\s]*>))\s*(?:Tj|'|\")|"
                     rb"(T\*|TD|Td)|(ET)", re.S)
    for m in pat.finditer(content):
        if m.group(1):
            cur = fonts.get(fmap.get(m.group(1), -1), (None, False)); continue
        if m.group(4):
            txt.append("\x00"); continue
        if m.group(5):
            txt.append("\n"); continue
        cmap, two = cur
        pieces = [sm.group(0) for sm in STR.finditer(m.group(2))] if m.group(2) else [m.group(3)]
        for p in pieces:
            if p.startswith(b"<"):
                hx = re.sub(rb"\s", b"", p[1:-1]).decode()
                if len(hx) % 2:
                    hx += "0"
                rb_ = bytes.fromhex(hx)
            else:
                rb_ = unescape(p)
            codes = ([(rb_[i] << 8) | (rb_[i + 1] if i + 1 < len(rb_) else 0)
                      for i in range(0, len(rb_), 2)] if two else list(rb_))
            for c in codes:
                if cmap and c in cmap:
                    txt.append(cmap[c])
                elif two:
                    txt.append("?")
                else:
                    txt.append(chr(c))
    s = "".join(txt)
    s = re.sub(r"\x00+", " ", s)
    s = re.sub(r"[ \t]+", " ", s)
    s = re.sub(r"\n{3,}", "\n\n", s)
    return s.strip()


def fontmap(pd):
    out = {}
    res = pd
    rm = re.search(rb"/Resources\s+(\d+)\s+\d+\s+R", pd)
    if rm:
        res = body_of(int(rm.group(1)))
    i = res.find(b"/Font")
    if i < 0:
        return out
    j = res.find(b"<<", i)
    if j < 0 or j > i + 8:
        fr = re.search(rb"/Font\s+(\d+)\s+\d+\s+R", res)
        if not fr:
            return out
        res = body_of(int(fr.group(1))); j = res.find(b"<<")
        if j < 0:
            return out
    depth, k = 0, j
    while k < len(res):
        if res[k:k + 2] == b"<<":
            depth += 1; k += 2; continue
        if res[k:k + 2] == b">>":
            depth -= 1; k += 2
            if depth == 0:
                break
            continue
        k += 1
    for nm, on in re.findall(rb"/([A-Za-z0-9_.+-]+)\s+(\d+)\s+\d+\s+R", res[j:k]):
        out[nm] = int(on)
    return out


# ---- page order from the page tree -------------------------------------
def kids(num, seen):
    b = body_of(num)
    if num in seen:
        return []
    seen.add(num)
    if b"/Kids" in b:
        km = re.search(rb"/Kids\s*\[(.*?)\]", b, re.S)
        out = []
        if km:
            for on in re.findall(rb"(\d+)\s+\d+\s+R", km.group(1)):
                out += kids(int(on), seen)
        return out
    if b"/MediaBox" in b and b"/Contents" in b:
        return [num]
    return []


root = re.search(rb"/Pages\s+(\d+)\s+\d+\s+R", data)
order = kids(int(root.group(1)), set()) if root else []
if not order:
    order = sorted(k for k in objs if b"/MediaBox" in body_of(k) and b"/Contents" in body_of(k))

for i, num in enumerate(order, 1):
    pd = body_of(num)
    refs = []
    cm = re.search(rb"/Contents\s*\[([^\]]*)\]", pd, re.S)
    if cm:
        refs = [int(x) for x in re.findall(rb"(\d+)\s+\d+\s+R", cm.group(1))]
    else:
        cm = re.search(rb"/Contents\s+(\d+)\s+\d+\s+R", pd)
        if cm:
            refs = [int(cm.group(1))]
    content = b"".join((stream_of(r)[1] or b"") + b"\n" for r in refs)
    print("\n" + "#" * 72)
    print("### MANUAL PAGE %d of %d   (pdf object %d)" % (i, len(order), num))
    print("#" * 72)
    print(render(content, fontmap(pd)))
