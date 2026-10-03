# MAIN functions 0x05A000–0x07B753 — validation, purpose (Lane W2-2)

Machine-readable table: `ida\out\fnindex\main-high-b.tsv` (818 rows, columns
`start end validated xref purpose evidence`, same layout as `main-low.tsv`).
Detail table: `ida\out\fnindex\main-high-b-extra.tsv`
(`start end regs callees callers strings`). New/recovered:
`ida\out\fnindex\main-high-b-new.tsv`.

## Verdict

Every one of the 942 `functions.tsv` rows with `0x05A000 <= ea <= 0x07B753` was
covered. **818 functions are validated** (816 reached by a call/jump/vector, 1
recovered call-target new to the 3,899 list, and 1 accepted on the byte-level +
deep-doc citation `sub_5E9E2`), each with an evidence-based purpose line citing
its start address, so `T == D == 818`. **125 candidates were rejected** — all 125
are marked `swept` in `functions.tsv` (the earlier forced-linear-sweep residue,
no xref and no clean prologue/return); **none of the rejected rows was
`reachable`**, so no genuine function was dropped. This region is not a driver
region: the SCI/USB drivers and both USB descriptors live *below* the cut
(`0x44xxx`–`0x55xxx`). Above `0x05A000` the byte budget is dominated by the
**settings/config state model** — 410 validated functions write config RAM
(`0xFF8000`–`0xFFBFFF` / `0xFEE000`–`0xFF72FF`) and 187 carry an `eepmov`
block copy — plus three concrete host surfaces: the **DATA-jack CAT/clone DMAC
path** (`0x6B77E`), the **node-link command dispatcher** (`0x6BAC8`), the
**cable-clone engine** (`0x73540`–`0x74600`), and one **MAIN→SUB IPC status-frame
builder** (`0x5E9E2`). The top of the range (`0x078106`–`0x07B753`) is the
service-mode DSP-loader / CDC-ACM window and is left closed by rule.

## Method

Private DB `W2_MAIN_HI_B`, seeded `--copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64`
(the 3,899-function state) and reopened. One IDA job through `ida\run_job.py`:
`ida\jobs\w2_2_classify.py`.

- **Stage A (conservative recovery in `[LO,HI]`):** A1 — call/jump/vector
  code-xref targets inside the range not yet functions; A2 — undefined runs that
  decode cleanly from an H8S prologue to a return (≥4 insn, no bad decode). A1
  recovered exactly one real function, `sub_63C04` (a 6-insn leaf called from
  `sub_1CE80`, `nrefs=2`); A2 recovered none. Low yield confirms MAIN_FULL had
  near-complete coverage of this range.
- **Stage B (classify every function `LO<=start<=HI`):** validated test
  (`nrefs>0` and not a data signature, OR a byte-level prologue+return decode, OR
  a start byte-confirmed by deep docs 24/25), per-function decode stats,
  absolute-operand peripheral map, settings/RAM writers, callees, callers, string
  refs, indirect-dispatch idiom, purpose synthesis. Purposes for `sub_6BAC8`,
  `sub_5E9E2`, and the cable-clone routines are **reused from docs 24 and 25**
  (each cites the start address); the remaining purposes are synthesized from the
  function's own peripherals / RAM writes / callees / callers / strings.
- **Closed window:** functions with `0x078106 <= start <= 0x07B753` get only the
  one-line purpose `service-mode DSP loader / CDC-ACM stack (closed)`; no protocol
  detail, no decode of the loader body. `sub_78222` and `sub_7827A` are the two
  discrete validated functions inside it.
- **Stage C:** byte accounting over the range and the counts below.

Did **not** run: no device I/O; nothing written to `decrypted\`, `ida\db\radio\`,
the shared `.i64`s, or any other lane's files; the DSP `26AA:0020` loader and its
CDC-ACM stack left closed; band/MARS/CAP not touched; settled RESUME-DEEP answers
not re-proved. Addresses are true 24-bit effective addresses (IDA's `h8s300a`
prints the 16-bit-absolute register page as `@0xFFFFxxxx:16` = real `0xFFxxxx`).

**Validated test:** `nrefs>0` and not a data signature (a large, zero-xref,
structure-less/odd-heavy run), OR a byte-level decode with a plausible H8S
prologue, ≥1 return, ≥3 insn, no bad decode and a structural instruction, OR a
start byte-confirmed in a deep doc (`sub_5E9E2`, doc 25). Rejected candidates are
counted, not listed.

## Findings — notable subsystems (with addresses)

### Settings / config state model (the bulk of the range)
410 validated functions write config RAM in `0xFF8000`–`0xFFBFFF` /
`0xFEE000`–`0xFF72FF`; 187 contain an `eepmov` structured block copy. This is the
UI/menu settings model and its serializers — e.g. `sub_5A040`
(`FF8E2B..FF8E2D/FFB0B8`), `sub_5A1BE` (timer `FFFFF5/F6` + `FFB0A4/FFB0C7`),
`sub_5A0B4` (266-byte `eepmov` copier). Peripheral touches are otherwise sparse
in this range: port-io 8, timer 4, port-dir 3, DMAC 2, SCI-A 2, USB 1 — the raw
drivers are below `0x05A000`.

### DATA-jack CAT / clone DMAC path — `sub_6B77E` @ `0x6B77E`
Drives **DMAC** (`FFFC40/44/4C/54/58`, trigger `FFFD22`) into **SCI-A / SCI_4**
(`FFFE92`, the DATA-jack port) and writes settings `FF8DDE/FF94C0/FF959E/FFB036/
FFB03C/FFB2A5`. `sub_6B986` (`0x6B986`) is the small DMAC+SCI-A companion. This is
the DATA-jack transfer engine underneath the CAT/clone command layer.

### Node-link inbound command dispatcher — `sub_6BAC8` @ `0x6BAC8`
(doc 24) A `cmp.b` chain on the command letter at `0xFF1AC9`, 8 explicit letters
(`B C E F N S V W`) with the default at `0x6BB04` (unknown letters ignored). Not a
jump table — a new inbound letter is a new compare pair. No spare table slot.

### MAIN→SUB IPC status-frame builder — `sub_5E9E2` @ `0x5E9E2`
(doc 25) Fills the fixed `0xFF3D72` IPC staging mailbox (total/opcode/len/payload)
and calls the sender `sub_B6B6`; keyed off the USB selector byte `0xFF813A` and
`0xFFB0C4`. Present in the seed DB as code but zero-xref (reached indirectly);
validated on the doc-25 byte-level disassembly (`how = doc-cited(24/25)`).

### Cable-clone engine — `0x73540`–`0x74600`
(doc 24) `sub_73540` sets SCI_4 to 19200 8N1 polled (`BRR 0xFFFE91=0x19`);
`sub_7358E` receives the `AH72M` header + streamed EEPROM blocks and verifies a
single 8-bit mod-256 checksum (`0xFF812E`); `sub_737FC` is the send side;
`sub_73908` builds the header; `sub_7374A` is the timed (1200-count) byte receive;
`sub_73AB4` is the `0x06`/`0x15` ACK/NAK transmit helper. An **extended
clone-variant family** occupies `0x73B00`–`0x74600` (8 functions). Two of these,
`sub_7481A` and `sub_74DCA`, reference the data string **`"MARUCHAN0000z"`** at
`0x00DD16` (a fixed clone/backup identifier constant).

### On-chip USB Function Module toucher — `sub_768A8` @ `0x768A8`
The only function in this range that touches the USB module base `0xFFEE00`; the
full USB device stacks (`sub_54Dxx`) and both descriptors (`0x055818`,
`0x07B680`) are below the range.

### Closed service window — `0x078106`–`0x07B753`
Service-mode DSP-loader / CDC-ACM stack (closed by rule). `0x078106` is the boot
USB-enable loader entry (`JSR @0x078106` from `0x002234`, per RESUME-DEEP); in
MAIN_FULL its follow-on bytes are unanalyzed loader data, so it is not a discrete
function boundary and was not force-decoded (the window stays closed). The two
discrete validated functions inside the window, `sub_78222` and `sub_7827A`, carry
only the one-line closed purpose. The CDC-ACM descriptor block itself
(`0x07B680`, `0x07B2A6` `.data` source) is data, not a function.

## Counts

- **T (validated, `0x05A000 <= start <= 0x07B753`):** **818**
  (816 reachable by xref, 1 new call-target `sub_63C04`, 1 doc-cited `sub_5E9E2`)
- **D (validated with a purpose citing the start address):** **818** (`T == D`)
- **Rejected (sweep-only, all `swept` in functions.tsv, none reachable):** **125**
- **New (validated, missing from `functions.tsv`):** **1** — `sub_63C04`
  (`0x63C04`–`0x63C16`, reachable, called by `sub_1CE80`)
- **Closed-window functions (one-line closed purpose):** **2** (`0x78222`,
  `0x7827A`); plus reachable non-function loader entry `0x078106` noted above
- **Instruction bytes inside validated functions in the range:** **67,482**
- **Content bytes in range (`0x05A000`–`0x07B754`):** **137,044**
  (non-`0xFF`: 132,135; fill begins at `0x07B754`)
- **Derived instruction share of range content:** 67,482 / 137,044 = **49.24%**
- **Weak (structural-only) purposes:** 319 of 818 (39%), each marked `[weak]` with
  caller context where available — not invented.

Reconciliation: 942 in-range `functions.tsv` rows = 817 validated-from-tsv + 125
rejected; + 1 new (`sub_63C04`) = 818 validated total.

## Open

1. The 319 `[weak]` helpers carry a structural purpose plus caller names; a
   caller-argument pass would upgrade many to concrete purposes.
2. The 8-function extended clone-variant family (`0x73B00`–`0x74600`) and the
   `"MARUCHAN0000z"` identifier were not walked entry-by-entry — the base clone
   path (doc 24) is decoded, the variants are not.
3. `sub_5E9E2`'s indirect caller (the table/dispatch that reaches this zero-xref
   IPC status builder) was not traced.
