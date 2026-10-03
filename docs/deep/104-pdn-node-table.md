# 104 — WIRES-X / PDN node-command table off_74472 (MAIN, SCI-A) — lane L7

Owner-side static analysis of `decrypted\FT3D_MAIN_ver102_EXP.bin` (MAIN, H8SX,
big-endian, base 0, file offset = mapped address). Private DB `L7_PDN_TABLE`,
`--copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`. No shared DB opened,
no image modified, nothing written to or connected with a radio. `decrypted\*.bin`
unchanged (MAIN sha256 `8e3ecd05…`, SUB `b93570b3…`). The closed window
`0x078106`–`0x07B753` was not entered (the whole node engine lives in `0x073900`–
`0x074532`, well outside it). Model running as: **`claude-opus-5-5`**.

Job `ida\jobs\l7_nodetable.py`; dump `ida\out\pdn-node-table\l7_dump.txt`; tables
`table.tsv`, `writers.tsv` (plus auto-generated `table_auto.tsv`, `writers_auto.tsv`).

## Verdict

`off_74472` is a **48-entry (0x30) jump table of 4-byte big-endian handler
pointers** at `0x074472`–`0x074532`, indexed by RAM byte `0xFF97FC`. The index is
**`FF97FC = command_byte − 0x30` (ASCII '0'), 0-based, no other offset** — so the
table covers the single-character node commands **'0' (0x30) … '_' (0x5F)**. A
parallel 48-byte table at `0x074532` is the **expected argument-byte count** per
command (`0xFF` = variable length). There is **exactly one writer of `FF97FC`**
(`0x073A70` in `sub_73A54`), gated so a host can only reach a command while in
remote mode (`FF8004 ≥ 2`, except command '0' which enters it).

**The slot 0x10 vs 0x11 question is settled: `sub_73E58` is table slot 0x10
(command byte '@', 0x40 − 0x30 = 0x10).** Doc 77/J9's "host command 0x11" was
conflating the slot with the **argument byte** `r1h = 0x11` that, *inside* command
'@', selects the TX-start sub-branch (`0x073E88 jsr sub_34A52 → sub_35872`). Both
numbers are real: 0x10 is the command/table index (K11 correct); 0x11 is the first
data byte of that command. No index arithmetic subtracts anything beyond the '0'
bias.

**No node command exposes host-chosen memory access.** All 48 handlers read and
write only fixed compile-time addresses or bounded indices into fixed arrays; no
handler takes a host-supplied address operand (Confirmed over all 48 + the
dispatcher). The read-block commands do leak *fixed* internal regions to the host
(radio-ID `FF8060`, 128-byte blocks at `FF8016`/`FF8096`, `FF813F`, `FFA98C`),
but only those compile-time regions, never an arbitrary address.

**Four commands can cause/enable transmission**, all behind remote mode and the
normal TX gates: **'3'** injects a PTT press/release (keys TX), **'@'** drives the
DSP TX session once keyed (`FF94C0 == 1`), **'G'** is a TX-aux toggle while keyed,
**']'** arms DSP session 0x15 on the next TX. None streams samples; none reaches
the DSP with a host-chosen opcode.

## Method

- Decoded the pointer table and byte table directly from the image (48 × BE32 +
  48 × u8), and disassembled every one of the 48 handlers to a terminator
  (`l7_dump.txt` §handlers).
- Resolved the dispatch chain by IDA xref on `0x74472`, `0x74532`, `0xFF97FC`, and
  by a raw-byte scan for every encoding of an `FF97FC` reference over `0..0x80000`.
- Disassembled the three functions that touch `FF97FC` in full, plus the parent
  phase table `off_73974`.
- Cross-read docs 77 (J9), 86 (K4), 91 (K9), 92 (K10), 93 (K11) and reconciled the
  numbering, the TX keyers, and the "no host-chosen address" finding.
- Not covered: the SCI-A byte-feed / ring that drives the parser phase machine
  (K11's `FF95F8` ring; traced to the phase table but not byte-by-byte); the DSP's
  interpretation of any TX session (no DSP firmware in package); the framed-CAT
  letter layer (that is K9/K10's `sub_6BAD6`, a *different* dispatcher).

## Findings

### 1. The table and its index (Confirmed)

`off_74472` at `0x074472`: 48 big-endian 32-bit pointers (`0x074472`–`0x074531`).
Immediately after, `byte_74532` at `0x074532`: 48 bytes, the per-command expected
argument length. Full decode in `table.tsv`. Spot bytes (Confirmed from image):

```
0x074472  00 07 3a fe | 00 00 20 70 | 00 07 3b 6c | 00 07 3b b4   slots 0..3
0x0744B2  00 07 3e 58                                              slot 0x10 -> sub_73E58
0x074526  00 07 43 96 | 00 07 43 e0                               slots 0x2D,0x2E
0x074532  02 02 01 02 04 ff 04 ff 01 01 01 01 02 05 09 03 ...      arg-length table
```

**Index arithmetic (Confirmed, `sub_73A54` at `0x073A54`):**

```
073A58  cmp.b #0x30, r2l        ; byte < '0'  -> reject
073A5A  bcs  ret
073A5C  beq  accept             ; byte == '0' -> accept unconditionally
073A5E  cmp.b #0x60, r2l        ; byte >= '`' -> reject
073A60  bcc  ret
073A62  mov.b @FF8004, r4l
073A66  cmp.b #2, r4l
073A68  bcs  ret                ; FF8004 < 2 (not remote mode) -> reject
073A6A  accept: mov.b r2l, r4l
073A6C  mov.b #0x30, r5l
073A6E  sub.b r5l, r4l          ; INDEX = byte - 0x30
073A70  mov.b r4l, @FF97FC      ; the only writer of FF97FC
073A74  mov.b #0,  @FF97FB      ; reset arg counter
073A80  mov.b #1,  @FF97FE      ; advance parser phase
```

The dispatcher `sub_739FA` (`0x0739FA`) then: checks `FF9547 == 0`, computes an
additive checksum over the `FF96F9`-count argument bytes at `FF96F8` and compares
the trailing byte, and on match does `mov.b @FF97FC, r3l ; shll.l #2 ; mov.l
@(off_74472, er3), er6 ; jsr @er6` (`0x073A28`–`0x073A3C`). The index is already
bounded to 0..0x2F by the acceptor, so no bounds check is needed at dispatch.

`sub_73992` (`0x073992`) reads `byte_74532[FF97FC]`; if negative (`0xFF`) it skips
the length check (variable-length command), otherwise it requires the received
count to equal the table value before accepting the command.

### 2. The parser is a 5-phase state machine on FF97FE (Confirmed)

A second jump table `off_73974` (7 × BE32 at `0x073974`) is indexed by phase byte
`FF97FE` (read at `0x07395E`, `shll.l #2`, `jsr @er6`):

| FF97FE | handler | role |
| --- | --- | --- |
| 0 | `0x073990` (`rts`) | idle |
| 1 | `sub_73992` | validate arg length vs `byte_74532`, set `FF97FD`=len, →phase 2 (or 5 err) |
| 2 | `0x0739DA` | collect data bytes |
| 3 | `sub_739FA` | checksum check, **dispatch `off_74472[FF97FC]`**, →phase 4 |
| 4 | `sub_73A54` | accept command byte, **write `FF97FC`=byte−0x30**, →phase 1 |
| 5/6 | `0x073A86`/`0x073A98` | error / housekeeping |

So the ready-state is phase 4; a command byte advances 4→1→2→3→(dispatch)→4.
`FF97FB` = arg counter, `FF97FD` = arg length, `FF97FE` = phase. These are the
link-layer parser state; the SCI-A byte feed (K11's `FF95F8` ring) is upstream.

### 3. Writers of FF97FC — exactly one (Confirmed, whole-image)

Raw scan of `0..0x80000` for every `FF97FC` encoding found **3 references, all in
`0x0739xx`**: read `0x073996` (length table), read `0x073A28` (dispatch), **write
`0x073A70`** (`sub_73A54`). No abs32 form, no untyped hit elsewhere. Details and
conditions in `writers.tsv`. The write value is always `command_byte − 0x30`;
the gate is remote mode (`FF8004 ≥ 2`) for every command except '0'.

### 4. The 48 handlers (Confirmed bytes; semantic labels Inferred where noted)

Full one-line roles in `table.tsv`. Grouped:

- **Reset/control:** '0' enter remote mode (also `FF89BA`=0 TOT-off, `B0CC`=0),
  '1' software reset (`jmp loc_DC5A`), 'C' restart (`jmp sub_DBD8`), 'I' mask
  interrupts + `jmp loc_25AC`, '_' set parser state `FF94FE`.
- **Read-back (reply to host):** '2' identity/config (`FF800E`), '8' 128 B @`FF8016`,
  ':' 12 B @`FFA98C`, ';' 1 status byte, '=' 4 B @`FFAE8C`, 'B' 128 B @`FF8096`,
  'S'/'Z' comm-mode, 'W'/'X' 5-byte radio-ID @`FF8060`, '[' 3 B @`FF813F`,
  '^' RF-status line (`0xFFFF4D` b3/b2). **All sources are fixed addresses.**
- **Parameter writes (fixed sinks, bounded values):** '4' 16-bit param, '5'/'7'
  variable-length into `FF96FD`, '6' block op, '<','>','?' bounded field sets,
  'A' channel index `A9F0`, 'D' flag array `FFA9A8[r1h<0x10]`, 'E' `FF8971`,
  'F' `FF89B1`, 'J' `AA35`.b2 + port `0xFFFF52`, 'L' `FF80A4`, 'M' `FF8975`,
  'O'/'P' band toggles, 'R' comm mode, 'T' `FF89C9`, 'Y' 18 B → `FF8956`.
- **NAK (unsupported):** 'K', 'Q', '\\' (all `jsr loc_73AC2`).
- **TX-capable (see §5).**

`er0` throughout is a pointer to a fixed per-session context struct (accesses at
`@(5,er0)`, `@(8,er0)`, `@(0x17,er0)`, `@(0x84,er0)` — fixed offsets, not
host-chosen). Reply staging uses fixed `FF96F8` (tag), `FF96FA`/`FF96FD` (data).

### 5. Which commands transmit, and under what conditions (Confirmed path, Inferred RF)

| Cmd | Slot | What keys/arms | Gate |
| --- | --- | --- | --- |
| '3' | 0x03 | injects PTT press (r1h=0) / release (r1h=1) → key handler → `sub_2244C` → keys TX | remote mode; then PTT LOCK, DSP-ready, TX-freq-range, TOT (doc 93) |
| '@' | 0x10 | **only while `FF94C0 == 1`**: arg r1h=0x11 → `jsr sub_34A52 → sub_35872` (DSP TX-start dispatcher); 0x12 → `sub_350E4` (stop); r1h<0x10 → set TX subtype (`AC09.b7`, `AC06`=r1h+0x50, `AAE1.b0`) | radio must already be keyed (`FF94C0`) by '3' or the framed `S` frame |
| 'G' | 0x17 | TX-aux toggle while keyed (`FF94C0==1`, r1h=0 → `sub_356C8`) | keyed |
| ']' | 0x2D | sets/clears `B0CC` → arms DSP session 0x15 (`1C 03`) on next TX (K11) | remote mode + digital + DSP init |

`0x073E88 5e 03 4a 52` (`jsr sub_34A52`) and `0x073E90 5e 03 50 e4` (`jsr
sub_350E4`) were re-read from the image — these are the TX-start/stop calls inside
command '@', confirming the "0x11 = TX" of J9 is the **argument**, not the slot.

### 6. Relation to the SCI-A frame letters and DSP sessions

This `0x30`-based node-command protocol (dispatcher `sub_739FA`, table
`off_74472`, index `FF97FC`) is a **distinct layer** from the framed-CAT letter
protocol (K9/K10: SOH|letter|4-hex-len|…|EOT|sum, dispatcher `sub_6BAD6`, letters
V/M/B/C/E/F/S/N/W). Both ride SCI-A (the DATA jack), but the node commands are
single ASCII characters '0'–'_' with a fixed per-command arg length and an
additive checksum — the WIRES-X node **link-layer control**, where the framed
letters are the payload/CAT layer. DSP reach from here is only via the TX commands
in §5 (sessions 0x02/0x0A/0x10/0x15 through `sub_35872`); there is no
host-selectable DSP opcode.

## USB relevance

- **Q1 (USB): none.** The entire engine is `0x073900`–`0x074532` on SCI-A; no
  `0xFFEE00`–`0xFFEE53` USB register is touched by any of the 48 handlers or the
  dispatcher. Adds no USB surface.
- **Q2 (USB SDR): unchanged no.** No command reads a sample stream or raw memory;
  the densest read is a fixed 128-byte EEPROM-shadow block ('8'/'B'), and TX
  commands drive the fixed DSP voice/data sessions, not samples.
- **Q3 (DSP): bounded, consistent with K10/K11.** The node commands can key the
  radio ('3'), drive the DSP TX session once keyed ('@' arg 0x11), and arm session
  0x15 (']'), but the opcode is always firmware-chosen; there is no
  arbitrary-opcode or arbitrary-address path to the DSP.

## Open

Most valuable first.
1. Trace the SCI-A byte feed into the phase machine (K11's `FF95F8` ring, and what
   sets `FF97FE` initially at `0x002BD8`/`0x073560`) to state the full on-wire
   framing of a node command (SOH? length? the checksum byte position vs
   `FF96F8`/`FF96F9`).
2. Decode command '@' sub-branches `loc_73E86`/`loc_73E8E`/`loc_73EA8` and the
   r1h<0x10 subtype path fully (what `AC06`/`AAE1.b0` select in the DSP TX engine).
3. Name the fixed read regions '8' (`FF8016`), 'B' (`FF8096`), ':' (`FFA98C`),
   '[' (`FF813F`) — '[' sits next to the USB personality selector `FF813A`
   (BRIEF), worth confirming what 3 bytes it exposes.
4. Confirm the '3' → `sub_2244C` key edge (the PTT-inject link is Inferred from
   K11/J9's key path, not re-walked here).

Machine tables: `ida\out\pdn-node-table\table.tsv` (48 slots: index, byte, ptr
bytes, target, arg length, role, TX class, host-address), `writers.tsv` (the one
`FF97FC` writer with conditions, plus readers and the parser state bytes),
`l7_dump.txt` (full disassembly of all handlers and the dispatch chain).
