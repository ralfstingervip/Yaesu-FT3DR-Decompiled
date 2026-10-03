# FT3DR deep-analysis brief

Shared context for the parallel analysis agents. Read this first, then your own
assignment. Everything here is owner-side static analysis of firmware the owner
already has. Nothing in this effort writes to a radio.

## Mission

Recover the FT3DR/FT3DE ver 1.02 **radio firmware** as completely as static
analysis allows, and answer three owner questions with evidence:

1. **Everything USB.** Every USB-touching byte, with the radio firmware as the
   primary subject: hardware blocks, register writes, interrupt handlers,
   descriptors, protocol bytes, the boot path, the connector. The Windows-side
   DLLs matter only as a cross-check on the wire protocol, and only one agent
   works on them. If you find yourself analysing a PE file and you are not that
   agent, you are off-assignment.
2. **Is USB SDR possible?** Could this radio be made to stream IQ or raw
   receiver samples over its USB port? Answer at the level of the data path:
   sample source, transport, USB engine, firmware. A "no" must say which link
   in the chain is missing and what evidence shows it.
3. **Can the DSP / vocoder chip be reached directly?** The radio's version
   screen shows a DSP version that is not in this update package. Find the chip,
   the bus, the framing, and whether any firmware path exposes it.

The deliverable the owner asked for is a full decompilation of the firmware. For
the two radio images that means exhaustive disassembly plus hand-reconstructed C
for the routines that matter, because no decompiler exists for these two cores.
Depth on the radio images is the goal; breadth over host tooling is not.

## Ground truth already established

Confirmed by earlier sessions; do not re-derive, but do challenge it if your
evidence disagrees.

- Two processors. **MAIN** is Hitachi/Renesas H8S advanced (`h8s300a`), image
  `decrypted\FT3D_MAIN_ver102_EXP.bin`, 1,048,576 bytes, base `0`, reset
  `0x2092`, content ends near `0x80000`, big-endian.
- **SUB** is Renesas RX64M (`rx`), image `decrypted\FT3D_SUB_ver102_ALL.bin`,
  4,194,304 bytes, mapped at `0xFFC00000` so it ends at `0xFFFFFFFF`, reset
  vector at `0xFFFFFFFC` = `0xFFC00000`, little-endian. `EXTB` = `0xFFFFFF80`,
  `INTB` = `0xFFED8A70` (file `0x2D8A70`).
- Both images were decrypted from resource type 23 `RES_UPDATE_INFO` in the
  updater EXEs. Cipher record: `docs\firmware-decryption.md`.
- Updater USB path per the official manual: Renesas boot mode, the device shows
  as `Generic Boot USB Direct`, `VID_045B&PID_0025`. The program switch behind
  the DATA jack has three positions: up = Main write, down = Sub write,
  centre = normal operation.
- SUB setup-label table: 20-byte stride, file `0x3DF4D`..`0x3E8D4`, 120 labels,
  including `COM PORT SETTING` (`0xFFC3E5C9`), `USB CAMERA` (`0xFFC3E709`),
  `RAM DISPLAY` (`0xFFC3E759`), `BAND SCOPE` (`0xFFC3DF75`). Table:
  `ida\out\survey\SUB\menu_slots.tsv`.
- MAIN was built with the Renesas H8S/H8 C/C++ compiler, SUB with Renesas CC-RX.
  Record: `docs\compiler.md`.

### Prior negative results that are probably premature — treat as open

Earlier passes concluded "no USB anywhere in the SUB image". That conclusion
rests on only **455 recovered functions out of a 4 MB image**, which is very thin
coverage: about 421 of those sit in `0xFFEE0000`–`0xFFF50000`, so roughly
`0xFFC00000`–`0xFFEE0000` (~2.8 MB) was effectively never disassembled. MAIN had
1298 functions for ~512 KB of content, also incomplete. The prior scan also only
tested a single 1 KB window (`0x000A0000`–`0x000A03FF`) for literal immediates,
and only inside recovered functions.

So: **a negative result from that coverage is not evidence of absence.** Re-test
every earlier "not found" against real coverage before repeating it. Equally, do
not flip to the opposite error: if full coverage still shows nothing, that is a
real and useful answer, and you should say it plainly.

## CORRECTIONS — confirmed in flight, supersede anything above

Added after agents began reporting. These are verified, and two of them reverse
a seed this brief originally gave you.

1. **MAIN has an on-chip USB device controller, and the ver 1.02 application
   firmware contains two complete, working USB device stacks.** The seed above
   ("H8S/237x has no USB module") is **wrong for this part**. A Renesas USB
   Function Module sits at `0xFFEE00`–`0xFFEE53` (IFR0/1/2, IER0/1/2, EPDR0i/0o/0s,
   EPDR1/2/3, EPSZ, FCLR, TRG), with three dedicated interrupt vectors — 234 →
   `0x054D50`, 235 → `0x054EC2`, 238 → `0x054CFA` — and an 8-byte SETUP packet read
   at `0x054DB4`. Two device descriptors exist and **both were byte-verified by the
   orchestrator**: VID `0x26AA` PID `0x0001` at `0x055818` (vendor class), and VID
   `0x26AA` PID `0x0020` at `0x07B680` with `bDeviceClass = 0x02`, a **CDC-ACM
   virtual COM port**. An exhaustive sweep of the image finds exactly these two and
   no others. Selector at `0xFF813A`, chosen in boot by a held-key check on port
   `0xFFFF4C`.
2. **The register map of the MAIN part is not H8S/2370.** RAM from `0xFEE000`,
   a second data region `0xFF8000`–`0xFFBFFF`, USB at `0xFFEE00`, an SCI at
   `0xFFF610`, port DDRs `0xFFFB80`–`0xFFFB95`, port inputs `0xFFFF40`–`0xFFFF4F`,
   outputs `0xFFFF50`–`0xFFFF5F`, SCIs at `0xFFFF60` and `0xFFFF88`, three DMAC
   channels at `0xFFFC00`/`20`/`40`, TPU `0xFFFFC0`–`0xFFFFFF`, φ = 16 MHz. Pinning
   the exact part is open.
3. **USB0 on the SUB RX64M is confirmed dark** — in module stop, never addressed
   by any instruction, no descriptors, no endpoints. Two independent whole-image
   scans agree. But note this now means the radio's USB surface lives on **MAIN**,
   not SUB, and is not limited to the boot ROM as earlier notes implied.
4. **RX immediate encoding, a trap worth knowing.** `MOV.L #imm, Rd` is `FB`, then
   `(rd<<4) | (li<<2) | 0b10`, where `li` `00` = 32-bit, `01` = 8-bit, `10` =
   16-bit, `11` = **24-bit**. Every peripheral address in the SUB firmware uses the
   24-bit form, so a 32-bit-only scan finds nothing. Also: in IDA's RX module an
   `o_displ` operand keeps its byte-scaled displacement in **`op.value`, not
   `op.addr`**.
5. **Menu labels are reached only as `menu_table[cat].labels[item]`**, a computed
   index — so every one of the 117 labels looks unreferenced. Table base is
   `0xFFED74E8`, **1-based**, not `0xFFED74F0`. Walker is `sub_FFF0964A`. Do not
   conclude "dead string" from a null xref where access is table-driven; this
   already produced one wrong conclusion about `USB CAMERA`, which is in fact
   reachable and unconditional with a working settings screen at `sub_FFF08201`.
6. **The DSP is MAIN's, on SCI-C `0xFFFF88`** (clocked synchronous, MAIN as clock
   slave), with a proprietary 1-byte-opcode, fixed-length 32/96-byte frame. It is
   **not** AMBE-3000R: no `0x61` start byte, no 16-bit BE length, and no `AMBE`,
   `DVSI`, `PRODID` or `VERSTRING` string anywhere in MAIN.
7. **Neither application can write its own flash**, verified at good coverage on
   both sides, and **the application never reads the program switch** — it is
   wired to the reset-time mode pins. Entering update mode is a hardware decision.

## Hardware seeds — verify, do not assume

These are starting points from general part knowledge, not from this image. Cite
image evidence for anything you state as fact.

**RX64M (SUB).** Peripheral I/O region `0x00080000`–`0x000FFFFF`.

- `SYSTEM` block at `0x00080000`. Module-stop registers `MSTPCRA` `0x00080010`,
  `MSTPCRB` `0x00080014`, `MSTPCRC` `0x00080018`, `MSTPCRD` `0x0008001C`.
  Register-protect `PRCR` at `0x000803FE` (write key `0xA50x`).
  USB0 is a bit in `MSTPCRB`; a peripheral never released from module stop is
  definitively unused. **This is the cheapest decisive USB test.**
- `USB0` full-speed host/function controller at `0x000A0000`. `SYSCFG` `+0x00`,
  `SYSSTS0` `+0x04`, `DVSTCTR0` `+0x08`, `CFIFO` `+0x14`, `D0FIFO` `+0x18`,
  `D1FIFO` `+0x1C`, `CFIFOSEL` `+0x20`, `CFIFOCTR` `+0x22`, `INTENB0` `+0x30`,
  `INTSTS0` `+0x40`, pipe configuration around `+0x64`..`+0x7F`.
- `ICU` interrupt controller at `0x00087000` (`IR` `+0x000`, `IER` `+0x200`,
  `IPR` `+0x300`, group registers above). An `IER` bit set for a USB source is
  strong positive evidence; never set is strong negative evidence.
- Relocatable vector table: 256 entries x 4 bytes at `INTB` = `0xFFED8A70`.
  **Decode all 256.** Slots pointing at the shared dummy handler are unused
  sources; slots with unique handlers name the peripherals this firmware
  actually uses. This was never done and is the single biggest unlock.
- Fixed vector table at `EXTB` `0xFFFFFF80`, 32 entries.
- `SCI` async/sync serial channels in the `0x0008A000` area on a `0x20` stride;
  `RSPI` around `0x000D0100`; 12-bit ADC `S12AD` around `0x00089000`; `DMAC`
  `0x00082000`; `DTC` `0x00082400`; `CMT` `0x00088000`; I/O ports `0x0008C000`.
- Relevant to SDR: the RX64M on-chip ADC is a roughly 12-bit, roughly 1 Msps SAR
  converter. It is not an IF-sampling converter.
- RX code reaches peripherals in several ways, so an immediate scan alone is not
  sufficient: `mov.l #imm, rN` then `mov.b [rN]`, base register plus `dsp:8/16`
  displacement, a base held in a static variable, or a pointer from a table. Cover
  the displacement forms, not just bare immediates.

**H8S/2370 family (MAIN).** Big-endian, advanced mode, 16 MB space, on-chip
register page at the top of the address space, reached by 16-bit absolute
addressing (`@0xFFFFxx:16`) and 8-bit absolute. Vector table is 256 big-endian
dwords at `0`. This family has SCI channels, timers, A/D and PPG, and to the best
of general knowledge **no USB module** — confirm from the image rather than
assuming. USB exists on H8S/221x parts, not H8S/237x.

**Vocoder / DSP.** C4FM System Fusion voice uses AMBE+2. Yaesu handhelds of this
generation are generally understood to carry a DVSI AMBE+2 vocoder (AMBE-3000R
class) or a DSP running a licensed equivalent, with its own firmware version
shown on the radio's version screen. The AMBE-3000R host interface is a UART or
SPI with a distinctive packet frame: start byte `0x61`, then a 16-bit big-endian
length, then a packet type (`0x00` control, `0x01` channel data, `0x02` speech),
then type-length-value fields. Search for that framing, for `0x61` constants next
to serial code, and for strings such as `AMBE`, `DVSI`, `PRODID`, `VERSTRING`,
`RATEP`, `RATET`. Also consider that the DSP may be reached from MAIN rather than
SUB. Confirm which side owns it. Treat the framing above as a hypothesis to test,
not a fact: an equally good answer is "a proprietary frame, and here it is".

**What a USB SDR would require**, for question 2. Judge each link separately:

1. a sample source — direct-sampling ADC, or a quadrature mixer plus a stereo
   ADC, exposing IQ at a useful rate;
2. a path from that converter into a processor that can move it (DMA/DTC, or a
   dedicated serial link);
3. a USB device controller in device mode with a bulk or isochronous IN endpoint
   and the throughput to sustain the stream — USB0 full speed is 12 Mbit/s raw,
   so roughly 16-bit IQ at 48 kHz (1.5 Mbit/s) fits easily and 192 kHz
   (6.1 Mbit/s) is marginal;
4. firmware that implements all of it, or a route to install firmware that does.

Say which links exist, which do not, and what would have to be true. "The part
can do it but this firmware does not" is a different answer from "the hardware
cannot", and the owner needs to know which one applies.

## Paths

| What | Path |
| --- | --- |
| Workspace root | the repository root |
| Plaintext MAIN | `decrypted/FT3D_MAIN_ver102_EXP.bin` |
| Plaintext SUB | `decrypted/FT3D_SUB_ver102_ALL.bin` |
| Vendor packages, read-only | `Firmware/` |
| Existing survey tables | `ida/out/survey/<JOB>/` |
| Existing docs | `docs/` |
| Deep-pass output | `docs/deep/` |
| New IDA job scripts | `ida/jobs/` |
| Private job databases | `ida/db/jobs/<name>/` |
| Job logs | `ida/log/jobs/<name>/` |

## Tooling

**IDA 9.1 Professional**, `idat.exe`. Never invoke `idat.exe` yourself and never
pipe firmware bytes through PowerShell. Use the launcher:

```text
python "ida/run_job.py" --script ida\jobs\<yours>.py --db <YOURDB> --input decrypted\FT3D_SUB_ver102_ALL.bin --proc rx

python "ida/run_job.py" --script ida\jobs\<yours>.py --db <YOURDB> --reopen

python "ida/run_job.py" --script ida\jobs\<yours>.py --db <YOURDB> --copy-from ida\db\radio\SUB.i64
```

- `--db` is yours alone. Concurrent IDA instances are confirmed working, so you
  never wait on another agent, but you must not open a database you do not own.
- `--reopen` re-runs a script against your existing database. Iterate that way; a
  full re-analysis of the 4 MB RX image is expensive, so do it once and then
  reopen.
- `--copy-from` seeds your database from an existing one, then reopens it. Use
  this to inherit the earlier 455-function SUB or 1298-function MAIN state
  instead of starting cold.
- Default timeout is 7200 s; raise it with `--timeout` for a heavy pass.
- For a raw binary, rebasing and segment creation are your script's job. See
  `ida\survey.py` `_rebase` and `_split_sub` for the working pattern: SUB rebases
  to `0xFFC00000`, MAIN to `0`.
- Your IDAPython script must call `ida_auto.auto_wait()` after anything that
  triggers analysis, and must end with `idc.qexit(0)`. Write output files with an
  explicit encoding. Wrap the body in try/except and write the traceback to a
  file — a silent IDA crash is the usual failure, and the log is in
  `ida\log\jobs\<db>\`.
- `-A` autonomous mode is already set; no dialog can be answered.

**Decompilers.** `hexx64.dll` is installed and `init_hexrays_plugin()` returns
True for `metapc`, so x86/x64 PE files decompile fully. There is **no Hex-Rays
decompiler for RX or H8S**, and none exists. For the two radio images
"decompile" means: exhaustive disassembly, function boundaries, cross-references,
switch and jump tables resolved, calling convention and stack frames understood,
then hand-written C for the routines that carry the answer. Prefer depth on the
routines that matter over a shallow pass over everything.

**Python 3.14** is on PATH as `python`. Shell is Windows PowerShell; chain with
`;`, never `&&`. A Bash tool is also available and is usually easier for
`grep`/`sed`/`xxd` work. `objdump`, `gcc` and `rustc` exist. No 7-Zip, no Ghidra,
and do not assume `dotnet` — check before relying on one.

**Scratch.** Use your session scratchpad for throwaway files. Anything another
agent or the owner should see goes in `docs/deep/` or `ida/out/`.

## Rules

1. **Never modify `Firmware/`.** Read it; copy out of it if needed.
2. **Never open, delete or write `ida\db\FT3D_MAIN.i64`, `ida\db\FT3D_SUB.i64`,
   or anything in `ida\db\radio\`.** Those are shared. Copy them instead.
3. **Do not run `run_ida.py`.** It deletes the updater databases.
4. **Nothing is written to a radio, ever.** No serial, no USB, no device access,
   no device enumeration. This is static analysis of files on disk only.
5. Do not edit another agent's output file, and do not edit anything under
   `docs/` other than your own assigned deliverable.
6. Keep `decrypted\*.bin` unchanged.

## Evidence standard

Every factual claim carries a location: file offset, mapped address, and the
bytes or the disassembly line. Use this vocabulary and mean it:

- **Confirmed** — you read the bytes or the instruction.
- **Inferred** — follows from confirmed evidence plus a stated assumption.
- **Not found** — you searched a stated scope and it was absent. Always state the
  scope, because the earlier pass's mistake was a "not found" over 11% of an image.
- **Unknown** — not determinable from this package.

Do not pad, and do not restate this brief back. If your assignment turns out to
be a dead end, say so early and spend the remaining effort on the adjacent
question that is alive. Report what you actually ran: if a pass failed or you
skipped a scope, say that rather than implying coverage you do not have.

## Deliverable

Write one Markdown file, `docs/deep/<your assigned filename>`:

```text
# <title>
## Verdict            one paragraph, the answer, no hedging beyond the evidence
## Method             what you ran, what scope you covered, what you could not
## Findings           the substance, with addresses and bytes
## USB relevance      what this means for the three mission questions
## Open               what a next pass should do, most valuable first
```

Leave machine-readable tables under `ida/out/<yourname>/` and name them
in the document. Then return a compact summary as your final message: the
verdict, your highest-value findings with addresses, and anything another agent
needs. Your final message is the only thing the orchestrator sees, so put the
real content in it — but keep the long tables in files.
