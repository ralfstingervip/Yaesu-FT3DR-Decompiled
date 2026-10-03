# FT3DR workspace

This tree is the Yaesu FT3DR/DE firmware workspace. The goal is to understand the radio firmware and what the USB update path can reach. These were the working instructions for the analysis sessions. `Firmware/`, `decrypted/`, `ida/db/` and `ida/log/` are named below for reference; they are not in this repository.

## Layout

| Path | Role |
| --- | --- |
| `Firmware/` | Vendor ver 1.02 updater packages. Leave the files unchanged. |
| `decrypted/` | Plaintext MAIN and SUB images, plus a short `.meta.txt` for each. |
| `ida/find_key.py` | IDA 9.1 script. Locates the cipher tables, derives the session key, writes the plaintext. |
| `ida/yaesu_cipher.py` | Cipher used by that script. Tables come from the IDA dump, not from constants in this file. |
| `ida/run_ida.py` | Launches `idat.exe` for the cipher pass. |
| `ida/run_survey.py` | Launches the function, xref, and USB survey. |
| `ida/run_open.py` | Reopens a radio database and rewrites `insn_scan.txt`. |
| `ida/survey.py` | Survey script. Job name is the environment variable `YAESU_JOB`. |
| `ida/insn_scan.py` | Lists USB-window immediates inside recovered functions. |
| `ida/out/*.key.json` | Addresses, static tables, timestamp, and session key from the cipher run. |
| `ida/db/FT3D_MAIN.i64`, `FT3D_SUB.i64` | Updater databases from the cipher pass. |
| `ida/db/radio/` | H8S image, RX64M image, `RComms.dll`, and `RFP_USB_VB.dll`. |
| `ida/out/survey/` | Function lists, xrefs, the setup-label table, and the USB check. |
| `docs/firmware-decryption.md` | Cipher notes and the verification record. |
| `docs/usb-survey.md` | USB, setup labels, and the two processors. |
| `docs/compiler.md` | Renesas compiler for each radio image. |
| `docs/resume.md` | Where the last session stopped. |

## Re-run

```text
python "ida/run_ida.py"
python "ida/run_ida.py" MAIN
python "ida/run_ida.py" SUB
```

`idat.exe` is a local IDA Professional 9.1 install (local tree, not in this repo). Call it only through `run_ida.py`, `run_survey.py`, or `run_open.py`. Those launchers use `subprocess` with an argument list, send IDA's stdout and stderr to `ida/log/`, and let the script write UTF-8 or raw bytes. Do not pipe firmware bytes or key material through PowerShell.

A rerun deletes the previous `ida/db/FT3D_MAIN.*` and `FT3D_SUB.*` database files before IDA starts.

## Cipher facts already checked

- Both images are resource type 23, name `RES_UPDATE_INFO`, inside the updater EXE.
- The first four bytes are a Unix timestamp, formatted in UTC as `%Y%m%d%H%M%S`.
- The static tables in the MAIN ver 1.02 updater and the SUB ver 1.02 updater are the same bytes. The session keys differ because the timestamps differ.
- MAIN EXP 1.02 plaintext is `decrypted/FT3D_MAIN_ver102_EXP.bin` (1,048,576 bytes).
- SUB ALL 1.02 plaintext is `decrypted/FT3D_SUB_ver102_ALL.bin` (4,194,304 bytes).
- `RComms.dll`, `RFP_USB_VB.dll`, and `HMSEUSBDRIVER.exe` are byte-identical across the two packages.

## Shell

Windows PowerShell. Chain commands with `;`. Do not use `&&`. Write binary and non-ASCII output from Python with an explicit encoding.

## Survey

`run_survey.py` deletes and recreates only the database it was asked to build, under `ida/db/radio/`. It does not touch the updater databases. `run_ida.py` still deletes `ida/db/FT3D_MAIN.*` and `FT3D_SUB.*` before the cipher pass.

```text
python "ida/run_survey.py" RCOMMS
python "ida/run_survey.py" RFP MAIN SUB
python "ida/run_open.py" MAIN SUB
```

MAIN is Hitachi H8S advanced (`h8s300a`), image base 0, reset `0x2092`. SUB is Renesas RX (`rx`), image base `0xFFC00000`, reset at that base. The USB libraries are the PE files in either updater package. They match byte for byte.

## Stop line

The ver 1.02 USB survey is written up in `docs/usb-survey.md`. Read `docs/resume.md` before continuing. The DSP version shown on the radio is not in this package. No session has written firmware to the radio.
