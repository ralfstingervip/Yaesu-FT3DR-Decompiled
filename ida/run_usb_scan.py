"""Open an existing survey database and write usb_operands.tsv.

    python ida/run_usb_scan.py MAIN
    python ida/run_usb_scan.py SUB

Does not create or delete a database. Run one image at a time.
"""

from __future__ import annotations
import pathlib as _pathlib
_REPO = _pathlib.Path(__file__).resolve().parents[1]  # repository root

import os
import subprocess
import sys

# Path to idat.exe (IDA text mode). Set the IDAT environment variable.
IDAT = os.environ.get("IDAT")
SCRIPT = str(_REPO / "ida/usb_operand_scan.py")
DB_DIR = str(_REPO / "ida/db/radio")
LOG_DIR = str(_REPO / "ida/log/survey")

STEMS = {"MAIN": "MAIN", "SUB": "SUB"}


def _decode(blob: bytes) -> str:
    return blob.decode("utf-8", errors="replace")


def run_job(label: str) -> int:
    os.makedirs(LOG_DIR, exist_ok=True)
    stem = STEMS[label]
    db_path = os.path.join(DB_DIR, stem + ".i64")
    log_path = os.path.join(LOG_DIR, stem + "_usb.log")
    if not os.path.isfile(db_path):
        sys.exit("IDA databases are not in this repository.")
    argv = [IDAT, "-A", "-L" + log_path, "-S" + SCRIPT, db_path]
    env = os.environ.copy()
    env["YAESU_JOB"] = label
    proc = subprocess.run(
        argv,
        cwd=os.path.dirname(IDAT),
        stdin=subprocess.DEVNULL,
        capture_output=True,
        env=env,
    )
    with open(os.path.join(LOG_DIR, stem + "_usb.stdout.txt"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(_decode(proc.stdout))
    with open(os.path.join(LOG_DIR, stem + "_usb.stderr.txt"), "w", encoding="utf-8", newline="\n") as handle:
        handle.write(_decode(proc.stderr))
    sys.stdout.write("%s idat_exit %d\n" % (label, proc.returncode))
    return proc.returncode


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if not IDAT:
        sys.exit("Set the IDAT environment variable to the full path of idat.exe.")
    rc = 0
    for label in sys.argv[1:]:
        if label not in STEMS:
            sys.stdout.write("usage: run_usb_scan.py MAIN SUB\n")
            return 2
        code = run_job(label)
        if code != 0 and rc == 0:
            rc = code
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
