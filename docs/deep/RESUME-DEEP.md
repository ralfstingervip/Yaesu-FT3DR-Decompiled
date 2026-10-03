# Deep pass — resume point

**Second deep pass complete, 2026-09-27.** Ten agents ran in parallel; all ten
delivered. This supersedes the 2026-09-26 pause (that pass launched 14 agents, 6
finished, 8 paused with interim deliverables — every paused thread has now been
resumed and finished). Shared context remains `docs\deep\BRIEF.md`.

## Status — all deliverables on disk

`docs\deep\01`–`16` are final (no interim banners left). Newly finished this pass:
`02, 04, 07, 09, 11, 12, 13`; new: `15` (CDC-ACM adjudication), `16` (SUB upper
region + bitmaps).

| Doc | Subject | One-line verdict |
| --- | --- | --- |
| 02 | SUB vectors/ISR | All 256 INTB + 32 EXTB decoded; 17 live vectors → 13 peripherals; **no USB vector live** |
| 04 | MAIN recovery | DATA-jack CAT API mapped; **no arbitrary R/W, no flash write**; part = **H8S/2456 group** |
| 07 | RF / IQ path | **USB SDR not feasible** — no IQ sample source in hardware (audio-rate 12-bit SAR only) |
| 09 | Boot & inter-proc | DSP loader FSM decoded; strap = keypad key `0x11` on `0xFFFF4C`; IPC link = SCI-D `0xFFF610` ↔ SUB SCI0 |
| 11 | Protocols | C4FM/DV framing lives in the external DSP, not the images; boot-ROM read only on host-DLL debugger path |
| 12 | Hidden features | Boot-hold USB-personality gate; DEFAULT RESET; **no soft expanded-RX/MARS/CAP unlock** |
| 13 | Storage / SD | microSD is **data storage only — not a firmware-load path** |
| 15 | CDC-ACM live/dead | **LIVE, but gated** behind a held-key service mode; not present in normal operation |
| 16 | SUB upper + bitmaps | Bitmap atlas = static flash descriptor table `0xFFECE55C`; CS1 `0x06000000` = LCD; USB0-dark & no-self-write hold at 3806 funcs |

(01, 03, 05, 06, 08, 10 unchanged from the first pass; see corrections below.)

## Infrastructure fixed this pass

- `ida\run_job.py` `ROOT` now derives from `__file__` (was hardcoded `r"."`;
  the tree had been relocated into the repository root). Verified: `--reopen`
  resolves the job DBs under `ida\db\jobs\`. Every agent had worked around the stale
  ROOT with a private scratchpad copy of the launcher — no longer necessary.
- The stray `ida/` skeleton the old launcher created was removed;
  `USB_ADJ`'s database and logs were preserved into `ida\db\jobs\USB_ADJ\` and
  `ida\log\jobs\USB_ADJ\`.

## The three mission questions — answered

1. **Everything USB.** SUB (RX64M) USB0 is **dark** — clock-gated off, no live
   vector, never addressed (closed at 3806-function coverage + whole-image scans).
   The radio's USB lives on **MAIN**, an **H8S/2456-group** part with an on-chip USB
   Function Module at `0xFFEE00`. It has two device personalities selected by
   `0xFF813A`: default = vendor-specific bulk (`0x26AA:0x0001`); alternate = a
   **CDC-ACM virtual COM port** (`0x26AA:0x0020`).
2. **Is USB SDR possible? No.** The only ISR-driven sample stream is a mono,
   audio-band, 12-bit S12AD0 capture (not IF/IQ); the front end is a conventional
   dual-conversion superhet. Missing link = **no IQ sample source in hardware**.
   Even the CDC bulk-IN endpoint (~1 MB/s) has no IQ source behind it.
3. **Is the DSP reachable? It is MAIN's**, on clocked-sync SCI-C `0xFFFF88`, with a
   proprietary 1-byte-opcode 32/96-byte frame (not AMBE-3000R). It is field-writable
   only through the service-mode USB↔DSP loader relay (below), holding the DSP in
   reset/boot on `0xFFFF52` — a byte relay into the DSP's own loader, not an exposure
   of the voice frame protocol.

## The #1 open conflict — RESOLVED (MAIN-IO was right)

The MAIN **CDC-ACM stack at `0x07B680` is LIVE code, not dead vendor data** —
confirmed three independent ways (docs 15, 09, 12). The `.data` copy at `0x002152`
EEPMOVs the descriptor block to RAM (`0x07B2A6`→`0xFF6034`) unconditionally at boot;
boot hands off via `JSR @0x078106` which enables the USB module; the USB IRQ
(`sub_54D50`) dispatches to the stack-2 ISR when the selector is set. DSP-AMBE's
"dead" was a zero-xref scanning artifact (stack-1's descriptor, indisputably served,
also has zero xrefs — descriptors are reached by immediate loads on this core).

**But it is gated:** the selector flips to CDC-ACM only when the radio is powered on
with keypad key code `0x11` held (bit 1 of the keypad-matrix return column
`0xFFFF4C`, decoded by `sub_100E4`). That same flag starts the USB↔DSP queue engine
— i.e. the CDC-ACM personality *is* the DSP-firmware-download transport, a
deliberate service/factory mode. **In normal (centre-switch) operation the radio is
a vendor bulk device, not a serial port.**

## Corrections to earlier deep docs

- **doc-06 (DSP):** the MAIN↔SUB inter-processor link is **SCI-D `0xFFF610` ↔ SUB
  SCI0 `0x0008A000`** (~500 kbaud), NOT SCI-A `0xFFFE90`. SCI-A is the external
  DATA-jack CAT/clone/debug port; doc-06 mistook CAT/clone PC responses for the SUB
  path. (Source: doc-09 BOOT-IPC; cross-confirmed by doc-02 SUB SCI0 live vectors
  58/59 and doc-14 SCI2=GPS/SCI3=BT.)
- **doc-06:** `FIRM ERROR` string is at `0xFFF4AB3F` (doc-06 had `0xFFF4AB44`); does
  not change its conclusions. (Source: doc-13 STORAGE.)

## Settled negatives — high coverage, do not redo

- Neither MAIN nor SUB writes its own code flash (re-confirmed at high coverage both
  sides). Update is boot-ROM-only, program-switch selected in silicon; the
  application never reads the program switch.
- SUB USB0 dark (vector table + constant-prop over 3806 funcs + immediate scans).
- No SDR IQ source in hardware; SD card is data storage, not a firmware/code path.
- No soft expanded-RX/MARS/CAP unlock in either image; band coverage is a stored
  destination index (`0xFF9E1F`), changeable only by a clone/service tool.
- Boot-ROM read command exists only on the host DLL's on-chip-debugger path
  (emulator PIDs `0x8233/0x8236`), never the radio's `045B:0025` serial boot loader.

## Remaining residuals — most valuable first

1. **Which physical button is key code `0x11`** (bit 1 of the `0xFFFF4C` keypad
   matrix). Electrically pinned; the physical legend is not in the package — needs
   the radio's keypad schematic (hardware, not files).
2. **What makes MAIN send the SUB DSP-WRITE-MODE byte (`0x8C4E`==8)** — an SD-present
   DSP image, or a MAIN boot condition. (DSP-AMBE / BOOT-IPC / STORAGE.)
3. **MAIN `.dat` container-reader validation** (`BACKUP.dat`/`MEMORY.dat`/`QSO*.dat`)
   — the one real card→radio data-input surface. Whether readers check header
   magic/length/checksum or trust the file; a malformed card file can't run code but
   could corrupt settings or overflow a buffer.
4. **Exact H8S/2456-group die/flash variant** (datasheet register-table cross-check).
5. **Camera image transport** — inferred MAIN SCI-B `0xFFFF60` → IPC → microSD; not
   yet byte-confirmed (parser `sub_48C44`).

## Rules that still apply

Nothing has been written to a radio and nothing should be. `Firmware\`,
`decrypted\`, `ida\db\radio\` and `ida\db\FT3D_*.i64` are unchanged. Owner-side
static analysis of files on disk only.
