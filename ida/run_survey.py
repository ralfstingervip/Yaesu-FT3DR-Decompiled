"""Launch IDA survey jobs without a shell.

PowerShell mangles idat.exe -S paths. This file uses subprocess with an
argument list. The job name is an environment variable, YAESU_JOB.
IDA's log goes to ida\\log\\survey. The script writes ida\\out\\survey.

    python ida/run_survey.py RCOMMS
    python ida/run_survey.py RFP MAIN SUB

A listed job replaces only its own database under ida\\db\\radio.
The updater databases ida\\db\\FT3D_MAIN.i64 and FT3D_SUB.i64 stay in place.
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
SCRIPT = os.path.join(ROOT, "ida", "survey.py")
DB_DIR = os.path.join(ROOT, "ida", "db", "radio")
LOG_DIR = os.path.join(ROOT, "ida", "log", "survey")
FW = str(_REPO / "Firmware/FT3D_MAIN_ver102(EXP)")

JOBS = {
    "RCOMMS": (os.path.join(FW, "RComms.dll"), "RComms", None),
    "RFP": (os.path.join(FW, "RFP_USB_VB.dll"), "RFP_USB_VB", None),
    "MAIN": (
        str(_REPO / "decrypted/FT3D_MAIN_ver102_EXP.bin"),
        "MAIN",
        "h8s300a",
    ),
    "SUB": (
        str(_REPO / "decrypted/FT3D_SUB_ver102_ALL.bin"),
        "SUB",
        "rx",
    ),
}


def _decode(blob: bytes) -> str:
    return blob.decode("utf-8", errors="replace")


def _drop_db(stem: str) -> None:
    for suffix in (".idb", ".i64", ".id0", ".id1", ".id2", ".nam", ".til"):
        old = os.path.join(DB_DIR, stem + suffix)
        if os.path.isfile(old):
            os.remove(old)


def run_job(label: str, exe: str, stem: str, proc: str | None) -> int:
    os.makedirs(DB_DIR, exist_ok=True)
    os.makedirs(LOG_DIR, exist_ok=True)
    log_path = os.path.join(LOG_DIR, stem + ".log")
    db_path = os.path.join(DB_DIR, stem + ".i64")
    _drop_db(stem)
    if os.path.isfile(log_path):
        os.remove(log_path)
    argv = [
        IDAT,
        "-A",
        "-c",
        "-L" + log_path,
        "-o" + db_path,
        "-S" + SCRIPT,
    ]
    if proc:
        argv.append("-p" + proc)
    argv.append(exe)
    env = os.environ.copy()
    env["YAESU_JOB"] = label
    proc_run = subprocess.run(
        argv,
        cwd=os.path.dirname(IDAT),
        stdin=subprocess.DEVNULL,
        capture_output=True,
        env=env,
    )
    stdout_path = os.path.join(LOG_DIR, stem + ".stdout.txt")
    stderr_path = os.path.join(LOG_DIR, stem + ".stderr.txt")
    with open(stdout_path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write(_decode(proc_run.stdout))
    with open(stderr_path, "w", encoding="utf-8", newline="\n") as handle:
        handle.write(_decode(proc_run.stderr))
    sys.stdout.write("%s idat_exit %d\n" % (label, proc_run.returncode))
    return proc_run.returncode


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if not IDAT:
        sys.exit("Set the IDAT environment variable to the full path of idat.exe.")
    want = sys.argv[1:]
    if not want:
        sys.stdout.write("usage: run_survey.py RCOMMS|RFP|MAIN|SUB ...\n")
        return 2
    rc = 0
    for label in want:
        job = JOBS.get(label)
        if job is None:
            sys.stdout.write("unknown %s\n" % label)
            return 2
        exe, stem, proc = job
        if not os.path.isfile(exe):
            if label in ("MAIN", "SUB"):
                sys.exit("The firmware image is not in this repository.")
            sys.exit("The Yaesu updater files (Firmware/) are not in this repository.")
        if not os.path.isfile(SCRIPT):
            sys.stdout.write("missing %s\n" % SCRIPT)
            return 1
        code = run_job(label, exe, stem, proc)
        if code != 0 and rc == 0:
            rc = code
    return rc


if __name__ == "__main__":
    raise SystemExit(main())
