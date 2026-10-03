"""IDA 9.1 batch script. Find the FT3D updater key and decrypt RES_UPDATE_INFO.

Launch only through run_ida.py. That launcher passes one argument vector to
idat.exe, so PowerShell never tokenizes the script path or the key bytes.

Everything important is written as UTF-8 or raw binary under the repository root.
This script does not print key material. IDA's own log is a side channel;
keep it, but read the JSON and the decrypted image.

Exit code is idc.qexit. 0 means the plaintext file was written.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[1]  # repository root

import json
import os
import struct
import sys
import traceback

import ida_auto
import ida_bytes
import ida_funcs
import ida_idaapi
import ida_name
import ida_nalt
import ida_segment
import idc

SCRIPT_DIR = str(_REPO / "ida")
OUT_DIR = str(_REPO / "ida/out")
PLAIN_DIR = str(_REPO / "decrypted")
sys.path.insert(0, SCRIPT_DIR)

import yaesu_cipher  # noqa: E402


def _status(name: str, text: str) -> None:
    path = os.path.join(OUT_DIR, name + ".status.txt")
    with open(path, "a", encoding="utf-8", newline="\n") as f:
        f.write(text + "\n")


def _seg_bytes(name: str) -> tuple[int, bytes]:
    seg = ida_segment.get_segm_by_name(name)
    if seg is None:
        raise RuntimeError("segment %s is missing" % name)
    blob = ida_bytes.get_bytes(seg.start_ea, seg.end_ea - seg.start_ea)
    if not blob:
        raise RuntimeError("could not read segment %s" % name)
    return seg.start_ea, bytes(blob)


def _find_key_config(rdata_ea: int, rdata: bytes) -> int:
    hits = []
    limit = len(rdata) - 0x40
    for off in range(0, limit, 4):
        vals = struct.unpack_from("<16I", rdata, off)
        if all(v in (1, 2) for v in vals) and vals.count(2) >= 8:
            hits.append(rdata_ea + off)
    if len(hits) != 1:
        raise RuntimeError("expected one key-config dword run, found %d" % len(hits))
    return hits[0]


def _tables_from(key_ea: int) -> dict:
    def grab(ea: int, size: int) -> bytes:
        blob = ida_bytes.get_bytes(ea, size)
        if not blob or len(blob) != size:
            raise RuntimeError("short read at %#x size %#x" % (ea, size))
        return bytes(blob)

    key_config = grab(key_ea, 0x40)
    key_config2 = grab(key_ea + 0x40, 0x30)
    enc = grab(key_ea + 0x70, 0x30)
    enc2 = grab(key_ea + 0xA0, 0x800)
    enc3 = grab(key_ea + 0x8A0, 0x20)
    if any(b < 1 or b > 56 for b in key_config2):
        raise RuntimeError("key_config2 at %#x is not a 1..56 index table" % (key_ea + 0x40))
    if any(b < 1 or b > 32 for b in enc):
        raise RuntimeError("encryption_config at %#x is not a 1..32 index table" % (key_ea + 0x70))
    if sum(b in (0, 1) for b in enc2) != len(enc2):
        raise RuntimeError("encryption_config2 at %#x is not a 0/1 table" % (key_ea + 0xA0))
    if sorted(enc3) != list(range(1, 33)):
        raise RuntimeError("encryption_config3 at %#x is not a permutation of 1..32" % (key_ea + 0x8A0))
    return {
        "key_config_ea": key_ea,
        "key_config2_ea": key_ea + 0x40,
        "encryption_config_ea": key_ea + 0x70,
        "encryption_config2_ea": key_ea + 0xA0,
        "encryption_config3_ea": key_ea + 0x8A0,
        "key_config": key_config,
        "key_config2": key_config2,
        "encryption_config": enc,
        "encryption_config2": enc2,
        "encryption_config3": enc3,
    }


def _find_timestamp_tables(text_ea: int, text: bytes, lo: int, hi: int) -> tuple[int, list[int]]:
    """The derive function pushes four 56-byte tables, 0x38 apart."""
    found = []
    limit = len(text) - 0x60
    for i in range(limit):
        if text[i] != 0x68:
            continue
        ea = struct.unpack_from("<I", text, i + 1)[0]
        # Immediates are not all addresses. Reject anything that cannot be
        # four in-image tables without wrapping a 32-bit add.
        if ea < lo or ea + 168 >= hi:
            continue
        window = text[i : i + 0x60]
        pushes = [b"\x68" + struct.pack("<I", ea + 56 * k) for k in range(4)]
        if not all(p in window for p in pushes):
            continue
        ok = True
        for k in range(4):
            block = ida_bytes.get_bytes(ea + 56 * k, 56)
            if not block or len(block) != 56:
                ok = False
                break
            vals = set(block)
            if vals - {0, 1} or len(vals) != 2:
                ok = False
                break
        if ok:
            found.append((text_ea + i, ea))
    if len(found) != 1:
        raise RuntimeError("expected one four-table push site, found %d" % len(found))
    site, first = found[0]
    return site, [first + 56 * k for k in range(4)]


def _code_ea_for_imm(text_ea: int, text: bytes, imm: int) -> int | None:
    needle = struct.pack("<I", imm)
    at = text.find(needle)
    if at < 0:
        return None
    return text_ea + at


def _func_start(ea: int | None) -> int | None:
    if ea is None or ea == ida_idaapi.BADADDR:
        return None
    fn = ida_funcs.get_func(ea)
    if fn is None:
        return None
    return fn.start_ea


def _name(ea: int | None, name: str) -> None:
    if ea is None:
        return
    ida_name.set_name(ea, name, ida_name.SN_FORCE | ida_name.SN_NOWARN)


def _hx(blob: bytes) -> str:
    return blob.hex()


def main() -> None:
    os.makedirs(OUT_DIR, exist_ok=True)
    os.makedirs(PLAIN_DIR, exist_ok=True)
    ida_auto.auto_wait()

    infile = ida_nalt.get_input_file_path()
    imagebase = ida_nalt.get_imagebase()
    stem = os.path.splitext(os.path.basename(infile))[0]
    stem = stem.replace("(", "_").replace(")", "")
    status_path = os.path.join(OUT_DIR, stem + ".status.txt")
    if os.path.isfile(status_path):
        os.remove(status_path)
    err_path = os.path.join(OUT_DIR, "find_key_error.txt")
    if os.path.isfile(err_path):
        os.remove(err_path)
    _status(stem, "analysis finished for " + infile)

    rdata_ea, rdata = _seg_bytes(".rdata")
    text_ea, text = _seg_bytes(".text")
    key_ea = _find_key_config(rdata_ea, rdata)
    tables = _tables_from(key_ea)
    push_site, ts_eas = _find_timestamp_tables(text_ea, text, imagebase, imagebase + 0x200000)
    ts_blobs = []
    for ea in ts_eas:
        blob = ida_bytes.get_bytes(ea, 56)
        if not blob or len(blob) != 56:
            raise RuntimeError("timestamp table short read at %#x" % ea)
        ts_blobs.append(bytes(blob))
    tables["timestamp_tables"] = ts_blobs

    fmt = ida_bytes.find_bytes(b"%Y%m%d%H%M%S", text_ea)
    # The format string lives in .rdata, not .text. Search from image base.
    if fmt == ida_idaapi.BADADDR:
        fmt = ida_bytes.find_bytes(b"%Y%m%d%H%M%S", imagebase)

    set_key_site = _code_ea_for_imm(text_ea, text, key_ea)
    block_site = _code_ea_for_imm(text_ea, text, tables["encryption_config_ea"])
    derive_ea = _func_start(push_site)
    set_key_ea = _func_start(set_key_site)
    block_ea = _func_start(block_site)
    _name(derive_ea, "yaesu_derive_session_key")
    _name(set_key_ea, "yaesu_set_key")
    _name(block_ea, "yaesu_decrypt_block")
    _name(key_ea, "yaesu_key_config")
    _name(ts_eas[0], "yaesu_timestamp_table_0")

    # The updater payload is the firmware image; it is not shipped, and the key
    # JSON and decrypted image this script used to write are not shipped either.
    sys.exit("The firmware image is not in this repository.")
    update = yaesu_cipher.read_update_info(infile)
    timestamp, payload, trailer = yaesu_cipher.split_update(update)
    strings = yaesu_cipher.trailer_strings(trailer)
    session, schedule = yaesu_cipher.derive_session_key(timestamp, tables)

    def progress(done: int, total: int) -> None:
        _status(stem, "decrypt %d/%d" % (done, total))

    plain = yaesu_cipher.Decryptor(tables)
    # derive_session_key already set a different object's schedule.
    # Rebuild on this object so the image key matches the JSON session key.
    got = plain.derive(timestamp)
    if got != session:
        raise RuntimeError("session key did not reproduce")
    decrypted = plain.decrypt_payload(payload, progress)

    key_path = os.path.join(OUT_DIR, stem + ".key.json")
    bin_path = os.path.join(PLAIN_DIR, stem + ".bin")
    meta_path = os.path.join(PLAIN_DIR, stem + ".meta.txt")

    doc = {
        "input": infile,
        "imagebase": "0x%X" % imagebase,
        "timestamp_unix": timestamp,
        "timestamp_utc_text": yaesu_cipher.timestamp_text(timestamp),
        "trailer_strings": strings,
        "ciphertext_len": len(payload),
        "plaintext_len": len(decrypted),
        "addresses": {
            "format_string": None if fmt == ida_idaapi.BADADDR else "0x%X" % fmt,
            "key_config": "0x%X" % key_ea,
            "key_config2": "0x%X" % tables["key_config2_ea"],
            "encryption_config": "0x%X" % tables["encryption_config_ea"],
            "encryption_config2": "0x%X" % tables["encryption_config2_ea"],
            "encryption_config3": "0x%X" % tables["encryption_config3_ea"],
            "timestamp_tables": ["0x%X" % ea for ea in ts_eas],
            "derive_push_site": "0x%X" % push_site,
            "derive_session_key": None if derive_ea is None else "0x%X" % derive_ea,
            "set_key": None if set_key_ea is None else "0x%X" % set_key_ea,
            "decrypt_block": None if block_ea is None else "0x%X" % block_ea,
        },
        "session_key_56": _hx(session),
        "key_schedule_0x300": _hx(schedule),
        "tables": {
            "key_config": _hx(tables["key_config"]),
            "key_config2": _hx(tables["key_config2"]),
            "encryption_config": _hx(tables["encryption_config"]),
            "encryption_config2": _hx(tables["encryption_config2"]),
            "encryption_config3": _hx(tables["encryption_config3"]),
            "timestamp_tables": [_hx(t) for t in ts_blobs],
        },
        "plaintext": bin_path,
    }
    with open(key_path, "w", encoding="utf-8", newline="\n") as f:
        json.dump(doc, f, indent=2)
        f.write("\n")
    with open(bin_path, "wb") as f:
        f.write(decrypted)
    with open(meta_path, "w", encoding="utf-8", newline="\n") as f:
        f.write("input: %s\n" % infile)
        f.write("timestamp: %d %s\n" % (timestamp, doc["timestamp_utc_text"]))
        f.write("trailer: %s\n" % ", ".join(strings))
        f.write("ciphertext_len: %d\n" % len(payload))
        f.write("plaintext_len: %d\n" % len(decrypted))
        f.write("plaintext: %s\n" % bin_path)
        f.write("key_json: %s\n" % key_path)
        f.write("session_key_56: %s\n" % doc["session_key_56"])
    _status(stem, "wrote " + bin_path)


_status_name = "find_key"
try:
    os.makedirs(OUT_DIR, exist_ok=True)
    main()
    idc.qexit(0)
except Exception:
    os.makedirs(OUT_DIR, exist_ok=True)
    err = os.path.join(OUT_DIR, "find_key_error.txt")
    with open(err, "w", encoding="utf-8", newline="\n") as f:
        f.write(traceback.format_exc())
    idc.qexit(1)
