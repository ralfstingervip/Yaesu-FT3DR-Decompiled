r"""General IDA 9.1 job launcher for parallel analysis jobs.

Same rules as run_survey.py: subprocess with an argument list, no shell, no
firmware bytes through PowerShell, IDA's own log under ida\log\. Each job gets
a private database so several jobs can run at once without fighting over the
IDA lock.

    python ida/run_job.py --script ida\jobs\sub_recover.py \
        --input decrypted\FT3D_SUB_ver102_ALL.bin --db SUB_full --proc rx

    python ida/run_job.py --script ida\jobs\probe.py --reopen --db SUB_full

Databases live under ida\db\jobs\<db>\<db>.i64 so the shared databases in
ida\db and ida\db\radio are never touched. Relative paths resolve against
the repository root. Extra environment for the script: --env NAME=VALUE (repeatable).
YAESU_JOB is always set to the --db name unless --env overrides it.
Set the IDAT environment variable to the full path of idat.exe before running.
"""

from __future__ import annotations

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

# Path to idat.exe (IDA text mode). Set the IDAT environment variable; nothing
# about the local IDA install is stored in this repository.
IDAT = os.environ.get("IDAT")
# ROOT is the repository root, i.e. the parent of this ida\ directory. Derived
# from __file__ so the launcher keeps working wherever the tree is checked out.
ROOT = str(Path(__file__).resolve().parents[1])
JOB_DB_ROOT = os.path.join(ROOT, "ida", "db", "jobs")
LOG_ROOT = os.path.join(ROOT, "ida", "log", "jobs")
DB_SUFFIXES = (".idb", ".i64", ".id0", ".id1", ".id2", ".nam", ".til")


def _abs(path: str) -> str:
    return path if os.path.isabs(path) else os.path.join(ROOT, path)


def _decode(blob: bytes) -> str:
    return blob.decode("utf-8", errors="replace")


def _drop_db(db_dir: str, stem: str) -> None:
    for suffix in DB_SUFFIXES:
        old = os.path.join(db_dir, stem + suffix)
        if os.path.isfile(old):
            os.remove(old)


def main() -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    if not IDAT:
        sys.exit("Set the IDAT environment variable to the full path of idat.exe.")
    ap = argparse.ArgumentParser(add_help=True)
    ap.add_argument("--script", required=True, help="IDAPython script to run")
    ap.add_argument("--db", required=True, help=r"private database name under ida\db\jobs")
    ap.add_argument("--input", help="binary to load; omit with --reopen")
    ap.add_argument("--proc", help="processor module, e.g. rx or h8s300a")
    ap.add_argument("--loader", help="loader name passed as -T")
    ap.add_argument("--reopen", action="store_true", help="open the existing database")
    ap.add_argument("--keep", action="store_true", help="do not delete an existing database")
    ap.add_argument("--copy-from", help="seed the database by copying this .i64 first")
    ap.add_argument("--env", action="append", default=[], metavar="NAME=VALUE")
    ap.add_argument("--timeout", type=int, default=7200, help="seconds, default 7200")
    args = ap.parse_args()

    stem = args.db
    if not stem.replace("_", "").replace("-", "").isalnum():
        sys.stdout.write("bad --db name %s\n" % stem)
        return 2
    script = _abs(args.script)
    if not os.path.isfile(script):
        sys.stdout.write("missing script %s\n" % script)
        return 1

    db_dir = os.path.join(JOB_DB_ROOT, stem)
    log_dir = os.path.join(LOG_ROOT, stem)
    os.makedirs(db_dir, exist_ok=True)
    os.makedirs(log_dir, exist_ok=True)
    db_path = os.path.join(db_dir, stem + ".i64")
    log_path = os.path.join(log_dir, os.path.basename(script) + ".log")

    if args.copy_from and not args.reopen:
        src = _abs(args.copy_from)
        if not os.path.isfile(src):
            sys.exit("IDA databases are not in this repository.")
        _drop_db(db_dir, stem)
        shutil.copyfile(src, db_path)
        args.reopen = True

    if args.reopen:
        if not os.path.isfile(db_path):
            sys.exit("IDA databases are not in this repository.")
        argv = [IDAT, "-A", "-L" + log_path, "-S" + script, db_path]
    else:
        if not args.input:
            sys.stdout.write("--input is required without --reopen\n")
            return 2
        target = _abs(args.input)
        if not os.path.isfile(target):
            sys.exit("The firmware image is not in this repository.")
        if not args.keep:
            _drop_db(db_dir, stem)
        argv = [IDAT, "-A", "-c", "-L" + log_path, "-o" + db_path, "-S" + script]
        if args.proc:
            argv.append("-p" + args.proc)
        if args.loader:
            argv.append("-T" + args.loader)
        argv.append(target)

    env = os.environ.copy()
    env["YAESU_JOB"] = stem
    env["YAESU_DB_DIR"] = db_dir
    for pair in args.env:
        name, _, value = pair.partition("=")
        if not name:
            sys.stdout.write("bad --env %s\n" % pair)
            return 2
        env[name] = value

    try:
        proc = subprocess.run(
            argv,
            cwd=os.path.dirname(IDAT),
            stdin=subprocess.DEVNULL,
            capture_output=True,
            env=env,
            timeout=args.timeout,
        )
    except subprocess.TimeoutExpired:
        sys.stdout.write("%s idat_timeout after %ds\n" % (stem, args.timeout))
        return 124

    base = os.path.join(log_dir, os.path.basename(script))
    with open(base + ".stdout.txt", "w", encoding="utf-8", newline="\n") as handle:
        handle.write(_decode(proc.stdout))
    with open(base + ".stderr.txt", "w", encoding="utf-8", newline="\n") as handle:
        handle.write(_decode(proc.stderr))
    sys.stdout.write("%s idat_exit %d\n" % (stem, proc.returncode))
    sys.stdout.write("db %s\n" % db_path)
    sys.stdout.write("log %s\n" % log_path)
    return proc.returncode


if __name__ == "__main__":
    raise SystemExit(main())
