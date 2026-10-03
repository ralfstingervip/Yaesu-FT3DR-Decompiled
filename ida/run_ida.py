"""Launch IDA text mode without a shell.

PowerShell mangles idat.exe -S paths and any binary that leaks to stdout.
This file uses subprocess with an argument list. IDA writes its log to a
file. The script writes the key JSON and the decrypted image itself.
The only console text is a few ASCII status lines.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[1]  # repository root

import os
import subprocess
import sys

# Path to idat.exe (IDA text mode). Set the IDAT environment variable.
IDAT = os.environ.get("IDAT")
ROOT = str(_REPO)
SCRIPT = os.path.join(ROOT, "ida", "find_key.py")
DB_DIR = os.path.join(ROOT, "ida", "db")
LOG_DIR = os.path.join(ROOT, "ida", "log")
OUT_DIR = os.path.join(ROOT, "ida", "out")

JOBS = (
    (
        "MAIN",
        str(_REPO / "Firmware/FT3D_MAIN_ver102(EXP)/FT3D_MAIN_ver102(EXP).exe"),
        "FT3D_MAIN",
    ),
    (
        "SUB",
        str(_REPO / "Firmware/FT3D_SUB_ver102(ALL)/FT3D_SUB_ver102(ALL).exe"),
        "FT3D_SUB",
    ),
)


def _decode(blob: bytes) -> str:
    return blob.decode("utf-8", errors="replace")


def run_job(label: str, exe: str, db_stem: str) -> int:
    os.makedirs(DB_DIR, exist_ok=True)
    os.makedirs(LOG_DIR, exist_ok=True)
    os.makedirs(OUT_DIR, exist_ok=True)
    log_path = os.path.join(LOG_DIR, db_stem + ".log")
    db_path = os.path.join(DB_DIR, db_stem + ".idb")
    # Drop a previous database so -c cannot stop on a prompt.
    # IDA 9 packs a 32-bit database as .i64 even when -o names an .idb.
    for suffix in (".idb", ".i64", ".id0", ".id1", ".id2", ".nam", ".til"):
        old = os.path.join(DB_DIR, db_stem + suffix)
        if os.path.isfile(old):
            os.remove(old)
    if os.path.isfile(log_path):
        os.remove(log_path)
    argv = [
        IDAT,
        "-A",
        "-c",
        "-L" + log_path,
        "-o" + db_path,
        "-S" + SCRIPT,
        exe,
    ]
    # cwd is the IDA directory so idat finds its DLLs even if PATH is odd.
    proc = subprocess.run(
        argv,
        cwd=os.path.dirname(IDAT),
        stdin=subprocess.DEVNULL,
        capture_output=True,
    )
    stdout_path = os.path.join(LOG_DIR, db_stem + ".stdout.txt")
    stderr_path = os.path.join(LOG_DIR, db_stem + ".stderr.txt")
    with open(stdout_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(_decode(proc.stdout))
    with open(stderr_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(_decode(proc.stderr))
    sys.stdout.write("%s idat_exit %d\n" % (label, proc.returncode))
    return proc.returncode


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if not IDAT:
        sys.exit("Set the IDAT environment variable to the full path of idat.exe.")
    want = sys.argv[1:]
    jobs = JOBS
    if want:
        jobs = tuple(job for job in JOBS if job[0] in want)
        if not jobs:
            sys.stdout.write("usage: run_ida.py [MAIN] [SUB]\n")
            return 2
    rc = 0
    for label, exe, stem in jobs:
        if not os.path.isfile(exe):
            sys.exit("The firmware image is not in this repository.")
        code = run_job(label, exe, stem)
        if code != 0:
            rc = code
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
