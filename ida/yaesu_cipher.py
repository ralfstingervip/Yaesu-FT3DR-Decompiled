"""Yaesu firmware-updater cipher.

The updater expands a Unix timestamp from the front of the RES_UPDATE_INFO
resource into a 56-byte session key, using four static 56-byte tables, then
runs a 16-round bit permutation. The static tables are not embedded here.
find_key.py reads them out of the updater with IDA and passes them in.

The round structure matches the FT3D MAIN updater (image base 0x400000):

  derive session key   0x4082c0
  set_key              0x407850
  decrypt block        0x407980
  decrypt image        0x408350
  timestamp format     "%Y%m%d%H%M%S" via a 64-bit UTC time

Payload length is the little-endian dword that follows the ciphertext.
MAIN ver 1.02 is 0x100000 bytes. SUB ver 1.02 is 0x400000 bytes.
Both lengths are multiples of the 8-byte block.
"""

from __future__ import annotations

import struct
from datetime import datetime, timezone


class CipherError(Exception):
    pass


def _u32(buf: bytes, off: int) -> int:
    return struct.unpack_from("<I", buf, off)[0]


def extract_named_resource(pe: bytes, type_id: int, name: str) -> bytes:
    """Return one resource from a PE32 image. Offsets are section-relative."""
    if pe[:2] != b"MZ":
        raise CipherError("not a PE file")
    e_lfanew = _u32(pe, 0x3C)
    if pe[e_lfanew:e_lfanew + 4] != b"PE\x00\x00":
        raise CipherError("not a PE file")
    coff = e_lfanew + 4
    _machine, nsec, _td, _sp, _ns, optsz, _chars = struct.unpack_from(
        "<HHIIIHH", pe, coff
    )
    opt = coff + 20
    magic = struct.unpack_from("<H", pe, opt)[0]
    if magic != 0x10B:
        raise CipherError("expected a PE32 updater")
    dd = opt + 96
    rsrc_rva, _rsrc_sz = struct.unpack_from("<II", pe, dd + 16)
    sec_off = opt + optsz
    sections = []
    for i in range(nsec):
        off = sec_off + i * 40
        vsz, va, rsz, raw = struct.unpack_from("<IIII", pe, off + 8)
        sections.append((va, raw, max(vsz, rsz)))

    def rva_to_off(rva: int) -> int:
        for va, raw, span in sections:
            if va <= rva < va + span:
                return raw + (rva - va)
        raise CipherError("resource RVA %#x is not in a section" % rva)

    base = rva_to_off(rsrc_rva)

    def read_res_name(rel: int) -> str:
        off = base + rel
        n = struct.unpack_from("<H", pe, off)[0]
        return pe[off + 2 : off + 2 + n * 2].decode("utf-16le", "replace")

    # Directory levels: type, name, language.
    matches = []
    off = base
    _c, _ts, _maj, _minr, nn, ni = struct.unpack_from("<IIHHHH", pe, off)
    ent = off + 16
    for i in range(nn + ni):
        name_or_id, offset = struct.unpack_from("<II", pe, ent + i * 8)
        type_label = name_or_id & 0xFFFF if i >= nn else read_res_name(name_or_id & 0x7FFFFFFF)
        if type_label != type_id or not (offset & 0x80000000):
            continue
        type_rel = offset & 0x7FFFFFFF
        toff = base + type_rel
        _c2, _ts2, _maj2, _minr2, nn2, ni2 = struct.unpack_from("<IIHHHH", pe, toff)
        tent = toff + 16
        for j in range(nn2 + ni2):
            n2, o2 = struct.unpack_from("<II", pe, tent + j * 8)
            res_name = read_res_name(n2 & 0x7FFFFFFF) if j < nn2 else str(n2 & 0xFFFF)
            if res_name != name or not (o2 & 0x80000000):
                continue
            lang_off = base + (o2 & 0x7FFFFFFF)
            _c3, _ts3, _maj3, _minr3, nn3, ni3 = struct.unpack_from("<IIHHHH", pe, lang_off)
            nent = nn3 + ni3
            if nent < 1:
                continue
            _lang, data_dir = struct.unpack_from("<II", pe, lang_off + 16)
            if data_dir & 0x80000000:
                continue
            doff = base + data_dir
            data_rva, size, _cp, _res = struct.unpack_from("<IIII", pe, doff)
            fileoff = rva_to_off(data_rva)
            matches.append(pe[fileoff : fileoff + size])
    if len(matches) != 1:
        raise CipherError("resource %s under type %s not found once" % (name, type_id))
    return matches[0]


def read_update_info(path: str) -> bytes:
    with open(path, "rb") as f:
        pe = f.read()
    return extract_named_resource(pe, 23, "RES_UPDATE_INFO")


def split_update(blob: bytes) -> tuple[int, bytes, bytes]:
    """Return (unix_timestamp, ciphertext, trailer).

    The trailer starts with the ciphertext length, repeated as a dword.
    """
    if len(blob) < 8:
        raise CipherError("update resource is too small")
    timestamp = _u32(blob, 0)
    for size in (0x100000, 0x400000, 0x80000, 0x200000, 0x800000):
        off = 4 + size
        if off + 4 <= len(blob) and _u32(blob, off) == size:
            return timestamp, blob[4:off], blob[off:]
    raise CipherError("ciphertext length dword was not found in the trailer")


def trailer_strings(trailer: bytes) -> list[str]:
    out: list[str] = []
    cur: list[str] = []
    for b in trailer:
        if 32 <= b < 127:
            cur.append(chr(b))
        else:
            if len(cur) >= 3:
                out.append("".join(cur))
            cur = []
    if len(cur) >= 3:
        out.append("".join(cur))
    return out


def timestamp_text(timestamp: int) -> str:
    """UTC, matching the updater's 64-bit time format string %Y%m%d%H%M%S."""
    return datetime.fromtimestamp(timestamp, timezone.utc).strftime("%Y%m%d%H%M%S")


class Decryptor:
    def __init__(self, tables: dict):
        self.key_config = tables["key_config"]
        self.key_config2 = tables["key_config2"]
        self.enc_config = tables["encryption_config"]
        self.enc_config2 = tables["encryption_config2"]
        self.enc_config3 = tables["encryption_config3"]
        self.timestamp_tables = tables["timestamp_tables"]
        self._check_tables()
        self.key = bytearray(0x300)

    def _check_tables(self) -> None:
        if len(self.key_config) != 0x40:
            raise CipherError("key_config must be 64 bytes")
        if len(self.key_config2) != 0x30:
            raise CipherError("key_config2 must be 48 bytes")
        if len(self.enc_config) != 0x30:
            raise CipherError("encryption_config must be 48 bytes")
        if len(self.enc_config2) != 0x800:
            raise CipherError("encryption_config2 must be 2048 bytes")
        if len(self.enc_config3) != 0x20:
            raise CipherError("encryption_config3 must be 32 bytes")
        if len(self.timestamp_tables) != 4 or any(len(t) != 56 for t in self.timestamp_tables):
            raise CipherError("expected four 56-byte timestamp tables")

    def set_key(self, key56: bytes) -> None:
        if len(key56) != 56:
            raise CipherError("session key must be 56 bytes")
        scrambled = bytearray(key56)
        kc = self.key_config
        kc2 = self.key_config2
        schedule = self.key
        for i in range(16):
            rounds = 2 if kc[i * 4] == 2 else 1
            for _ in range(rounds):
                temp = scrambled[0]
                scrambled[0:27] = scrambled[1:28]
                scrambled[27] = temp
                temp = scrambled[28]
                scrambled[28:55] = scrambled[29:56]
                scrambled[55] = temp
            base = i * 48
            for k in range(48):
                schedule[base + k] = scrambled[kc2[k] - 1]

    def decrypt_block(self, outbuf: bytearray, is_encrypt: bool) -> None:
        key = self.key
        enc = self.enc_config
        enc2 = self.enc_config2
        enc3 = self.enc_config3
        scratch = bytearray(48)
        multiplier = 0 if is_encrypt else 0xF
        remaining = 15
        while True:
            for i in range(8):
                iidx = i * 6
                lhs_base = 48 * multiplier + iidx
                for j in range(6):
                    rhs = outbuf[enc[iidx + j] + 31]
                    scratch[iidx + j] = key[lhs_base + j] ^ rhs

            temps = bytearray(32)
            groups = (
                (0, 5, 1, 2, 3, 4, 0x000),
                (6, 11, 7, 8, 9, 10, 0x100),
                (12, 17, 13, 14, 15, 16, 0x200),
                (18, 23, 19, 20, 21, 22, 0x300),
                (24, 29, 25, 26, 27, 28, 0x400),
                (30, 35, 31, 32, 33, 34, 0x500),
                (36, 41, 37, 38, 39, 40, 0x600),
                (42, 47, 43, 44, 45, 46, 0x700),
            )
            for n, (a, b, c, d, e, f, off) in enumerate(groups):
                idx = (
                    ((scratch[a] << 5) + 2)
                    | ((scratch[b] << 4) + 2)
                    | ((scratch[c] << 3) + 2)
                    | ((scratch[d] << 2) + 2)
                    | ((scratch[e] << 1) + 2)
                    | (scratch[f] + 2)
                )
                temps[n * 4 : n * 4 + 4] = enc2[off + idx : off + idx + 4]
            material = temps + scratch

            pos = 0
            if remaining == 0:
                for _ in range(8):
                    for j in range(4):
                        outbuf[pos + j] ^= material[enc3[pos + j] - 1]
                    pos += 4
            else:
                for _ in range(8):
                    for second, first in enumerate(range(0x1C, 0x20)):
                        src = first + pos + 4
                        original = outbuf[src]
                        constant = enc3[pos + second]
                        outbuf[src] = outbuf[pos + second] ^ material[constant - 1]
                        outbuf[pos + second] = original
                    pos += 4

            if remaining == 0:
                return
            remaining -= 1
            if is_encrypt:
                multiplier += 1
            else:
                multiplier -= 1

    def derive(self, timestamp: int) -> bytes:
        text = timestamp_text(timestamp).encode("ascii")
        outbuf = bytearray(64)
        pos = 0

        def next_byte() -> int:
            nonlocal pos
            if pos < len(text):
                b = text[pos]
                pos += 1
                return b
            return 0

        curr = next_byte()
        for table in self.timestamp_tables:
            self.set_key(table)
            for byte_idx in range(8):
                base = byte_idx * 8
                for bit_idx in range(8):
                    bit = (curr >> (7 - bit_idx)) & 1
                    outbuf[base + bit_idx] ^= bit
                curr = next_byte()
            self.decrypt_block(outbuf, True)
        session = bytes(outbuf[:56])
        self.set_key(session)
        return session

    def decrypt_payload(self, encrypted: bytes, progress=None) -> bytes:
        if len(encrypted) % 8 != 0:
            raise CipherError("ciphertext length is not a multiple of 8")
        decrypted = bytearray(len(encrypted))
        inflated = bytearray(64)
        out_i = 0
        total = len(encrypted)
        while out_i < total:
            for i in range(8):
                b = encrypted[out_i + i]
                bit = i * 8
                inflated[bit] = b >> 7
                inflated[bit + 1] = (b >> 6) & 1
                inflated[bit + 2] = (b >> 5) & 1
                inflated[bit + 3] = (b >> 4) & 1
                inflated[bit + 4] = (b >> 3) & 1
                inflated[bit + 5] = (b >> 2) & 1
                inflated[bit + 6] = (b >> 1) & 1
                inflated[bit + 7] = b & 1
            self.decrypt_block(inflated, False)
            for i in range(8):
                acc = 0
                base = i * 8
                for shift in range(8):
                    acc |= inflated[7 - shift + base] << shift
                decrypted[out_i + i] = acc
            out_i += 8
            if progress is not None and (out_i & 0xFFFF) == 0:
                progress(out_i, total)
        if progress is not None:
            progress(total, total)
        return bytes(decrypted)


def derive_session_key(timestamp: int, tables: dict) -> tuple[bytes, bytes]:
    dec = Decryptor(tables)
    session = dec.derive(timestamp)
    return session, bytes(dec.key)
