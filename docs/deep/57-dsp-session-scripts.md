# DSP init and session scripts, the driver tick, and `0xFF8DDE` (MAIN)

> Lane I13 (narrowed re-run of lane I5). Model: claude-opus-5-5. Static analysis only. No
> database was opened, no IDA job was run, no image was modified, and nothing was written to or
> connected with any device. Image `decrypted\FT3D_MAIN_ver102_EXP.bin` (sha256 prefix
> `8e3ecd05…`, unchanged), base 0, so file offset = address, big-endian.
>
> Sources: lane I5's read-only dumps in `ida\out\dsp-session\work\` (produced by `i5_dump.py` from
> the `MAIN_H8SX` seed; code addresses are the same in `MAIN_FINAL`), I4's dumps in
> `ida\out\dsp-rx\work\`, and Python reads of the image. Every cited byte run is re-read from the
> image by `ida\out\dsp-session\i13_verify.py` (115 checks, 0 failures, `verify.tsv`), and every
> step-handler classification is checked by `i13_steps.py` (78 handlers, 0 failures).
>
> Scope narrowing. Three areas are out of scope and are not decoded here:
> - the boot-time held-key dispatch `0x10100`–`0x102C0`;
> - the destination/market byte `FF800F`;
> - the service window `0x078106`–`0x07B753`.
> Where a chain leads into one of them, the address is recorded with "out of scope".
>
> Tables, all in `ida\out\dsp-session\`:
> - `tables.tsv`: the 14 step tables;
> - `handlers.tsv`: the 78 step handlers, with evidence bytes;
> - `scripts.tsv`: 295 rows, one per table slot;
> - `tx-opcodes.tsv`: the MAIN→DSP opcode catalogue;
> - `cites.tsv` and `verify.tsv`: the cite list and the byte check.

## Verdict

**The scripts are code, not data.** Each one is a table of big-endian code pointers, indexed by a
one-byte step counter. The driver tick calls it once per main-loop pass. Each step handler does one
of these things, then advances the counter by writing it:

- sends one frame;
- waits for the ACK/NAK of the last frame;
- waits for a DSP event bit;
- runs a loop over a data block;
- toggles the TX line.

No record carries a length, opcode or delay. Lengths come from the opcode: 96 bytes for
`0x15`/`0x16`/`0x19`, and for `0x0C`–`0x0E` in host-link mode; 32 bytes otherwise. Pacing is the
link's one-frame-per-turn handshake, plus three timer bytes.

**Fourteen tables exist:**

- **Ten are live.** These are the 14-step init script (`0x05AF92`), two small request scripts, and
  seven session scripts.
- **Four are dead.** `0x05C1A4` (one of the two addresses this lane was given) has no reference
  anywhere in the image. The live table for that script code is `0x05C200`. Three more tables can
  be reached only through script codes that nothing ever stores.

**Opcodes.** The constant `0x31` frame is built from immediates in `sub_05EAEE`. The builders for
opcodes `0x07` and `0x08` are present but are never reached in ver 1.02.

**The driver tick.** The DSP tick runs once per main-loop pass. Its timers run on a TPU-style
channel at `0xFFFEF0`. The register writes were read: TCR `0x21`, TGRA `0x4E20`, TIER `0x41`,
vector 110 → `0x002A30`.

- With the standard H8S/H8SX TPSC encoding (`001` = Pφ/4) and Pφ = 16 MHz, the interrupt period
  is **5 ms** (**Inferred**: the register reads are Confirmed, the bit decode is not).
- On that reading, the scheduler tiers are 10 ms, 100 ms and 1 s.
- This halves every DSP timing in doc 52.

**`0xFF8DDE`** is the WIRES-X node-mode byte.

- The image shows two values:
  - `0xFF` is labelled `WIRES-X PDN` (`0x008A70`);
  - `1` is labelled `WIRES-X NODE` (`0x008A82`).
- Both values turn on the SCI-A host link and the DSP codec relay.
- The only code that stores a nonzero value is reached only through two pointer slots inside the
  out-of-scope boot-time dispatch (`0x010266`/`0x01026A`). How it is selected is therefore **out
  of scope**.
- "WIRES-X PDN" is **Confirmed for `0xFF` only**. "HRI-200" appears in neither image (Not found,
  whole-image string scan). Doc 14's reading of the positive value as a "clone personality" is
  not supported (§6).

**I4's claims.** (a), (b) and (c) hold, with refinements and one address correction (§7).

## Method

What was run:

1. **I5's dumps were read, not regenerated.** The files were:
   - `scripts.txt` (`0x05AF70`–`0x05C900`) and `bld.txt` (`0x058EA0`–`0x05A1BE`);
   - `req.txt`, `tickdrv.txt` and `ecfg.txt` (`0x05E9E0`–`0x05ED00`);
   - `sched.txt`, `dskip.txt`, `mloop2.txt`, `tinit.txt`, `tisr.txt`, `tpuinit.txt` and
     `ckinit.txt`;
   - `mode.txt` (`0x0103C0`–`0x010620`; nothing below `0x0102C0` was used), `e5.txt`,
     `hostlink.txt`, `wxui2.txt`–`wxui4.txt` and `nloop.txt`;
   - the trigger windows `r3596.txt`, `r34966.txt`, `r6cf30.txt`, `r6d052.txt` and `t*.txt`;
   - `acc_a1.tsv` (accesses to 50 variables) and `txt_tpu.tsv`.

   `bootkey.txt` was not opened.
2. **I4's dumps were read**: `rx.txt` (the RX assembler and the RX handlers), `post.txt` (the
   message relay gate) and `tr.txt` (the vendor trace formatter).
3. **Python reads of the image** (scratch scripts in the session scratchpad, `i13\i13_*.py`):
   - every step table was read as BE32 until the first non-code value;
   - every table base, the dead chunks and the two `FF8DDE` setters were searched as BE32,
     `jsr`/`jmp @aa:24`;
   - a writer census was taken of `FFB0BF` (91 stores), `FFB0BE`, `FF8DDE`, `FFBB94` and the
     `P3DR.b2` bit operations;
   - a string scan was run for `HRI`, `PDN`, `NODE` and `WIRES` in both images.
4. **The deliverable scripts:**
   - `i13_steps.py` joins the step tables with `handlers.tsv` and checks each handler's evidence
     bytes;
   - `i13_verify.py` re-reads `cites.tsv`, the `tx-opcodes.tsv` evidence columns and 16
     whole-image scans.

   Results: 78/78 and 115/115.

Not covered:

- IDA was not run. All instruction text comes from the I5/I4 listings (h8sxa); the bytes were
  re-checked here.
- The upstream UI meaning of several request flags is not decoded: `B0AA.b7` (about 20 setters),
  `B0CC.b0`, `FF89BB`, and the `B0BE=0x16`/`0x17` callers.
- The vendor manual for this H8SX part is not in the package, so the TPU bit decode is general
  part knowledge (labelled Inferred).
- No coverage delta is claimed.

## Findings

### 1. Script format (Confirmed)

A script is a jump table of BE32 code pointers. Its dispatcher is five instructions, the same in
every case, for example the B0BE=2 session at `0x05B442`:

```
05B442  6a 0b b0 bf              mov.b  @0xFFB0BF:16, r3l      ; step counter
05B446  7a 63 00 00 00 ff        and.l  #0xFF, er3             ; no bound check
05B44C  10 73                    shll.l #2, er3
05B44E  78 b0 6b 26 00 05 b4 58  mov.l  @(0x05B458:32,er3), er6
05B456  59 60                    jmp    @er6
```

There is no bound check. As with I4's RX table, safety rests on the writers: 57 of the 91 stores
to `FFB0BF` are `inc.b`, and the rest are `add.b #3/#5/#6` or immediate stores of 0, 4, `0x0A`,
`0x0E`, `0x0F`, `0x10`, `0x11`, `0x14`, `0x16`, `0x18`, `0x1A`, `0x1C`, `0x1D` and `0x21`.

**Selection (Confirmed, `tickdrv.txt`, `S1`–`S4` in `verify.tsv`).** The tick `0x056272` picks a
script as follows:

- if `B0A4.b2` (init done) is clear: the init script `0x05AF70`, on `B0A9` (`0x056304`);
- else, if `B0C9.b6`: table `0x05B19A` on `B0CA` (`0x05632E`);
- else, the request flags `B0AB`/`B0AA.b7`/`BBF9.b7`, `B0AC.b7`, `B0AE`, `B0CE.b7` and
  `B0CE.b3`, each a single-frame sender (`0x05B210`, `0x05B254`, `0x05B1A2`, `0x05B28C`,
  `0x05B2D8`);
- then, if `BB94 ≠ 0`: table `0x05EBD2` on `B0BF` (`0x0563A8`);
- otherwise:
  - if `B0BD` is set: `B0BF = 0`, `B0BD = 0`, and `sub_05C50C` prepares the data block;
  - then, if `B0BE ≠ 0`: `0x05B310[B0BE]` (`0x0563DA`).

**The script code `B0BE`** is set by the request entries only (`S5`–`S12`). Each entry first
checks that the link is ready (`B0A4.b7` set, `b3` clear) and that no script is running:

| Writer | B0BE | Header DT `B11E` | Table | Called from |
| --- | --- | --- | --- | --- |
| `0x05A1BE`, `B0C7` not 2 or 3 | `0x02` | 0 | `0x05B458` | TX start `0x03596A`, `0x035EEE` |
| `0x05A1BE`, `B0C7 == 2` | `0x0B` | 2 | `0x05BFBC` | same |
| `0x05A1BE`, `B0C7 == 3` | `0x10` | 3 | `0x05BFBC` | same |
| `0x05A28A` | `0x0A` | 1 | `0x05BDA8` | `0x0359A8` (`AAD4.b0`), `0x035F28`, `0x05F73A`, … |
| `0x05A2F8` | `0x15` | – | `0x05C40A` | `0x0359C8` (`B0CC.b0`), `0x035F48` |
| `0x06CF30` (after `0x05A1BE`) | `0x16` | 2 | `0x05C06A`, entered at step 4 | `0x01115C`, `0x01159C` |
| `0x06D052` (after `0x05A28A`) | `0x17` | 1 | `0x05C200` | `0x062DB2`, … (message engine) |

In the TX-start routine `0x035872`, `B0C7` is the band's digital mode (`[FF8EB6]`/`[FF8EC5]`;
0 is forced to 2). In host-link mode it is `[FFB3DB]`, which the host `F` packet fills
(`0x06C826`).

Every other `B0BE` write stores 0 (`W4`: 9 writers, all abs16). Power-off at `0x0560EE` stores
`B0B7 = 1`, but `B0BE = 0`. So these codes have no writer, and their tables are dead:

- `1` → `0x05B388`;
- `6` → `0x05BCCE`;
- `0x0F` and `0x14` → `0x05C352`.

**Handler kinds** (`handlers.tsv`; 78 handlers, each with evidence bytes):

| Kind | Body | Example |
| --- | --- | --- |
| SEND | `if (B0A4 & 0x80) && !(B0A4 & 0x08) { builder(); step++; }`, i.e. link ready and no ACK/NAK owed | `0x05B6A0`: `6a 0c b0 a4 4a 12 73 3c 46 0e 5e 05 9b ba` |
| WAIT | `if (B0A4 & 0x30) step++;`, i.e. ACK or NAK received; a NAK is not retried | `0x05B3E2`: `6a 0c b0 a4 ec 30 47 0a` |
| END | WAIT, then `B0BE = 0` (or `B0A9 = 0` / `B0C9 = 0` / `B0AE = B0AF = 0`) | `0x05B41C` |
| EVENT | wait for a DSP event bit in `B12D` (`b0` = `9C`, `b7` = `9E`), then clear it | `0x05BC34` |
| LOOP | `if (B126 && B122 < B123) { step = k; send next block } else step = j` | `0x05B7C0` |
| TXON / TXOFF | `P3DR(0xFFFF52).b2 = 0` / `= 1`, plus `B0BB` flags | `0x05B810` / `0x05BC7C` |
| TIMER | TPU guard on TSTR `0xFFFFBC` b3 / TCNT `0xFFFFF6 ≥ 0x8980` / TSR `0xFFFFF5` b4 | `0x05B8A0` |
| GATE | jump on a flag (`B3D8.b7`, `B0BB.b0`, `B0BA`) | `0x05B724` |

A NAK advances the step exactly like an ACK. Every WAIT tests `B0A4 & 0x30`, which is `b5` ACK or
`b4` NAK, and none of them re-sends. So a NAKed frame is dropped and the script carries on
(Confirmed for all 16 handlers that begin with the test `6a 0c b0 a4 ec 30`).

### 2. The 14-step init script, table `0x05AF92` on `B0A9` (Confirmed)

The script runs while `B0A4.b2` is clear. Its counter is `B0A9`, and the shared increment is
`0x05B012`.

| Step | Handler | Action | Frame |
| --- | --- | --- | --- |
| 0 | `0x05AFCA` | wait until `B0A8 ≠ 0` (set only by the DSP's unsolicited `9F`) and `B0A4.b1`; SEND `sub_05905E`; `B0A8 = 0` | `11`, 32 B |
| 1 | `0x05AFEE` | WAIT | – |
| 2 | `0x05AFF8` | SEND `sub_059240` (`r2l = 0`); clear `B0AA.b7`, `BBF9.b7` | `12`, 32 B |
| 3 | `0x05AFEE` | WAIT | – |
| 4 | `0x05B158` | SEND `sub_05EAEE` | `31 00 30 44 40 A0 A0`, 32 B |
| 5 | `0x05AFEE` | WAIT | – |
| 6 | `0x05B16E` | SEND `sub_05EB4E` | `32`, 32 B |
| 7 | `0x05AFEE` | WAIT | – |
| 8 | `0x05B0CC` | if `B0DC < 0x041E` then `B0A9 += 4` (go to 12); else SEND `sub_05A0B4` | `15 01`, 96 B |
| 9 | `0x05AFEE` | WAIT | – |
| 10 | `0x05B0F8` | SEND `sub_05A0C0` | `15 11`, 96 B |
| 11 | `0x05AFEE` | WAIT | – |
| 12 | `0x05B03A` | if `FF8DDE ≠ 0`, `[FF0BF6] = 0x24`; then `0x05B680`: `B134 = 0`, SEND `sub_059A1E`, `B0BF++` | `16`, 96 B |
| 13 | `0x05B01E` | on ACK/NAK: `B0AC.b7 = 0`, `B0A4.b2 = 1` (init done), `B0A9 = 0` | – |

This matches H15's table, with three refinements:

- step 0 also needs `B0A4.b1`, the version-known bit;
- step 12's side effect is `B0BF++`;
- the `0x31` frame is built at `0x05EB2A` from immediates: `f3 31 fb 00 6b 83 b1 3e`
  (`31 00`), `f3 30 fb 44 … b1 40` (`30 44`), `f3 40 fb a0 … b1 42` (`40 A0`), and `fc a0 6a 8c
  b1 44` (`A0`). Then `jsr 0x058FA2` appends the checksum. This answers H15's open "where is the
  `0x31` frame built". It is not a ROM literal, which is why H15's literal search missed it.

More init-region chunks are dead. `0x05B058` (SEND `07`) and `0x05B068` (SEND `08`) are
unreferenced. Each is preceded by an unconditional `bra` (`0x05B056 40 ba`, `0x05B066 40 aa`), and
no 32-bit reference to either exists (`W15`). The same is true of `0x05B088`/`0x05B098`/`0x05B0A8`
behind `0x05B078`.

### 3. Session scripts (Confirmed per slot; `scripts.tsv`)

**TX session, B0BE = `0x02`, table `0x05B458` (35 steps).** This is the reference layout. The
`0x0B`/`0x10` table (`0x05BFBC`) and the dead `0x05BCE4`/`0x05C368` tables differ only in steps
10–19.

| Step | Handler | What happens |
| --- | --- | --- |
| 0 | `0x05B4E4` | SEND `12`: `sub_059240` (`r2l = 0`) if `B0DC < 0x0106`, else `sub_05923C` (`r2l = 2`) |
| 1 | `0x05B522` | WAIT; then +1 if `B0DC < 0x0106`, else +3 (to 4) |
| 2 | `0x05B54C` | SEND `sub_059E10`: `1A 01` RX DISABLE, or `12` (`r2l = 2`) when `[FF8DD5] ≠ 0` |
| 3 | `0x05B3E2` | WAIT |
| 4 | `0x05B566` | header: if the block changed, SEND `16` (96 B; host link: the 60-byte block `FF0BFC` via `sub_0599BE`); otherwise +6 (to 10) |
| 5 | `0x05B3F6` | WAIT, then **+5 on both arms** (to 10) |
| 6–9 | `0x05B6A0`, `0x05B6BA`, `0x05B6DC`, `0x05B3E2` | SEND `07`, WAIT, SEND `08`, WAIT. **Unreachable** (below) |
| 10–12 | `0x05B7A6`, `0x05B3E2`, `0x05B7C0` | SEND `09` (next 20 B of `*B128`), WAIT, loop while `B122 < B123` |
| 13 | `0x05B7E6` | TXON: wait for `B0BB.b1` or `b0` (immediate in host link); clear `B0BB.b1`, **`P3DR.b2 = 0`**, clear a stale `B12D.b7`, clear `B0BB.b7` |
| 14 | `0x05B856` | wait for `B12D.b0` (DSP `9C` DATA TEXT SET). In host link it also pumps codec frames (`0x05BA22`) |
| 15 | `0x05B8A0` | TPU guard (TSTR `0xFFFFBC` b3) |
| 16 | `0x05B90C` | TX hold loop. `B0BC` → 17. `B0C0` → DTMF start 22, MUTE ON 20, MUTE OFF 26 or DTMF stop 24. `!B0BB.b0 && [FFAC0A] == 0` → 28 |
| 17–19 | `0x05BBE0`, `0x05B3E2`, `0x05BBFA` | SEND `09`, WAIT, loop to 17 or back to 14 |
| 20/21, 22/23, 24/25, 26/27 | `0x05B9D2`/`0x05BA12`, … | SEND `1D 01` / `0B 00 d` / `0B 01 d` / `1D 00`, then WAIT and return to 16 |
| 28 | `0x05BC1A` | SEND canned `0x05903E` = `18 00…00 18`, vendor trace "CPU>DSP: STOP ENCODE" (`N1`/`N2`) |
| 29 | `0x05B3E2` | WAIT |
| 30 | `0x05BC34` | wait for `B12D.b7` (DSP `9E` TERM TX), then clear it |
| 31 | `0x05B8A0` | TPU guard |
| 32 | `0x05BC7C` | TXOFF: **`P3DR.b2 = 1`**, `B0BB.b7 = 1`. Host link: reset the codec ring (`B3E2 = B3E3 = 0`, `B3DD = 0xFF`, …) |
| 33 | `0x05B83C` | SEND `sub_059D8E`: `1A 00` RX ENABLE (or `12` with `r2l = 3` when `[FF8DD5] ≠ 0`; nothing at all when the mode sum `sub_059DE8` is 0) |
| 34 | `0x05B41C` | END: WAIT, then `B0BE = 0` |

**Opcodes `07`/`08` are dead in ver 1.02** (Confirmed bytes, Inferred unreachability):

- Step 5 (`0x05B3F6`) ends with `8c 05` (`add.b #5`) on both arms of its `B134` test (bytes
  `47 0c 6a 0c b0 bf 8c 05 … 6a 0c b0 bf 8c 05`).
- No code stores 6–9 to `B0BF` (`W12`, whole image).
- Step 7's `B0BF = 0x0A` arm is dead too (`0x05B6C2 fc 02 ac 02 47 08` compares a constant with
  itself).
- The only other callers of the `07`/`08` step bodies are the unreferenced chunks in §2 (`W13`,
  `W14`).

So the 96-byte `16` frame carries the whole CSD1–CSD3 set, and the per-block `07`/`08` path is
left over. Doc 52 §6 lists `07`/`08` as live MAIN→DSP traffic; that is a correction.

**`P3DR.b2` is the TX-session line, not a power-only bit.** Doc 52 §1 says b2 is "set at
power-up, cleared only at shutdown". The bit-operation census (`W7`, `W8`) finds five writers:

- set at `0x05650A` (power-up), `0x05BC7C` and `0x05BF30` (session end);
- cleared at `0x056068` (shutdown) and `0x05B810` (session TX start).

So b2 is low for the duration of each transmission, from TXON to TXOFF (Confirmed). That it is the
DSP's encode/transmit enable is Inferred from its position: cleared before the DSP's `9C`, set
after the DSP's `9E` TERM TX.

**The other live sessions** (step rows in `scripts.tsv`):

- **`0x0A`, data FR message (`0x05BDA8`, 25 steps).**
  1. Same steps 0–5.
  2. Step 10 (`0x05BE84`) sends `19` (up to 80 B of `*B128`) or `09` (20 B, for the short message
     types `Ne`, `Gc`, `]q`, `]#`, `]*`, `]c`; `0x059C56`–`0x059C7A`). Step 12 loops.
  3. Step 13 (`0x05B7E4`) is an unconditional TXON.
  4. Step 14 (`0x05B890`) waits for `9C` before each further block, and steps 16–19 send it.
  5. Step 20 waits for `9E`; step 22 is TXOFF (`0x05BF30`).
  6. Step 23 (`0x05B82C`) ends without RX ENABLE when `B0BA > 0`.
- **`0x0B`/`0x10`, header DT 2/3 (`0x05BFBC`, 35 steps).** Like `0x02`, but steps 10–12 and
  17–19 send `19` (`sub_059D2E`) instead of `09`.
- **`0x16`, host-link data session (`0x05C06A`, 37 steps, entered at step 4 by `0x05C048`).**
  - Step 4 sends `16` (`0x05B6F6`), and steps 10–18 send `19` blocks.
  - Step 15 (`0x05B724`) waits on `B3D8.b7`/`B0BC`.
  - Step 30 arms `FF9565 = 0x1E`, and step 31 waits for `9E` or that timer.
  - Step 33 (`0x05B772`) ends.
  - There is no TXON/TXOFF and no `18`.
- **`0x17`, automatic data reply (`0x05C200`, 21 steps).**
  - It starts with the unconditional `12` (`0x05B4EE`).
  - Its header step is `0x05B5D0`, which compares the own callsign `FFA8DA` with `FFB3B4`.
  - Its data steps use `sub_059C28`; it waits for `9C`/`9E`.
  - It ends at `0x05B42C`, which also clears `B3D9.b7`.

  The unreferenced `0x05C1A4` (23 slots, `W6`) is the same script with a version-gated first step
  and two extra steps.
- **`0x15`, `1C 03` session (`0x05C40A`, 11 steps).** The steps are: `12`, WAIT, `1A 01`/`12`,
  WAIT, then SEND `1C 03` (`0x05C436`: `B0B8 = 3`, `jsr 0x05A040`), WAIT, TXON (`0x05B7E6`),
  wait until `B0BB.b0` is clear (`0x05C44C`), TXOFF, RX ENABLE, END.
- **`BB94`, short TX (`0x05EBD2`, 14 steps).** This is started at `0x0349E8` when `[FF89BB] ≠ 0`.
  The steps are: `12`, WAIT, `1A 01`/`12`, WAIT, TXON, hold (`0x05EC0A`, which arms
  `FF95A2 = 0x14`), `18` STOP ENCODE, WAIT, then `9E` or timeout (`0x05EC8C`), TPU guard, TXOFF,
  `12`, WAIT, END (`BB94 = 0`, `jsr 0x022772`).
- **Small request scripts.**
  - `0x05B19A` on `B0CA`: SEND `16`, then END (`B0C9 = 0`). It is started when `0x019954` sets
    `B0C9.b7`.
  - `0x05B1F8` on `B0AF`: `15 01`, WAIT, `15 11`, END. It is started by `0x05B208` after the ID
    list `FF4576` is edited (`0x056D44`, `0x06973A`). It runs only when `B0DC ≥ 0x041E`
    (`0x05B1A6`).

### 4. MAIN→DSP opcode catalogue (`tx-opcodes.tsv`)

Every builder clears the frame at `0xFFB13E`, writes its fields, and calls `0x058FA2`
(frame_finish). Frame_finish computes the length (96 for `15`/`16`/`19`, and for `0C`–`0E` when
`FF8DDE ≠ 0`; else 32), stores the checksum, and queues the frame. The vendor trace formatter
`0x05A506` names six of the opcodes. Its string pointers are in `cites.tsv` `N1`–`N5`.

| Op | Len | Builder | Payload | Vendor name | Trigger |
| --- | --- | --- | --- | --- | --- |
| `11` | 32 | `0x05905E` | `[1] = [FF8E2A] \| 0x80 (\| 0x02 if FF8DDE)`, settings `FF8E20`–`FF8E36`, 12 ROM bytes `0x00F9A8` | – | power-on (init 0) |
| `12` | 32 | `0x059240`/`0x05923C`/`0x059238`/`0x059234` (`r2l` 0/2/2/3) | `[FF8D85]`, DT `B11E`, `[FF8D86]`, request bits `B0AA`/`B0AC`, host-link bits `B3D6` | – | power-on; settings/mode change (`B0AA.b7`, `B0AC.b7`); every TX start; TX end when `[FF8DD5] ≠ 0` |
| `31` | 32 | `0x05EAEE` | constant `31 00 30 44 40 A0 A0` | – | power-on (init 4) |
| `32` | 32 | `0x05EB4E` | `[FF8AA0]`, `[FF8ABD]`, `FFAA35.b7` | – | power-on (init 6); `B0CE.b3` (set at `0x01782E` only when `FF8DDE == 0`, `0x017990`, `0x049376`) |
| `15 01` / `15 11` | 96 | `0x05A0B4` / `0x05A0C0` | 18 / 6 five-byte records from `FF4576` / `FF4696` | – | power-on if DSP ≥ `0x041E`; ID-list edit |
| `16` | 96 | `0x059A1E`, `0x0599BE`, `0x0599FA` | callsign/ID header (or the 60-B host block `FF0BFC`) | – | power-on; TX start when changed; `B0C9.b7` |
| `09` | 32 | `0x059CD6` (`0x059C28` for short types) | next 20 B of `*B128` | – | TX with text/data |
| `19` | 96 | `0x059C28`, `0x059D2E` | next ≤ 80 B of `*B128` | – | data FR, DT2/DT3 sessions |
| `1A 00` / `1A 01` | 32 | `0x059D94` / `0x059E16` | – | RX ENABLE / RX DISABLE | TX end / TX start; `B0CE.b7` |
| `1D 01` / `1D 00` | 32 | `0x059E66` / `0x059EB6` | – | MUTE ON / MUTE OFF | `B0C0` = `0xFD` / `0xFF` during TX |
| `0B 00 d` / `0B 01 d` | 32 | `0x059F40` / `0x059FE0` | digit `0x80 \| (B0C0−1)` | DTMF … O / … S | DTMF key press/release during TX |
| `18` | 32 | canned `0x05903E` | `18 00×30 18` | STOP ENCODE | PTT release |
| `1C 03` | 32 | `0x05A040` (`B0B8 = 3`) | `[2]` from `FF8E2B`–`FF8E2D` only for `B0B8` 9/`0x0D` | – | `B0BE = 0x15` session |
| `0C`/`0D`/`0E` | 96 | `0x05BA22` | 45/65/90 B codec bits from the host `E` ring | – | host link, DSP `9A` request |
| `20` / `10` | 32 | `0x058F2A` / `0x058EE6` | ACK / NAK of `rx[0]` | ACK / NAK | every non-streamed DSP frame |
| `07`, `08` | 32 | `0x059BBA`, `0x059BDE` | 20-B CSD sub-block | – | **unreachable** (§3) |
| `06`, `1F 02`, `1F 01` | 32 | `0x059A6E`, ROM `0x05901E`, ROM `0x058FFE` | – | VER? | **dead** (doc 52) |

Mode changes reach the DSP only through `12`. Every TX session starts with `12`, built with the
current `B11E` DT and the `FF8D85`/`FF8D86` settings. `B0AA.b7`, set by about 20 UI routines
(`0x019C5A`–`0x06CE60`; `acc_a1.tsv`), re-sends `12` between sessions.

No catalogue entry carries volume or squelch as a field that this lane could name: the `11`/`12`/
`32` setting bytes are copied without interpretation (Unknown). DG-ID reaches the DSP inside the
`16` header (`[4]`, `0x0598FE`–`0x05990E`, from `FF8ED6`–`FF8ED9` or the host `FF0BF9`).

**`0C`–`0E` frame layout, corrected.** H15 wrote `op, FEEAB0[s], FEEAB4[s]`. The code is:

```
05BB2A  78 20 6a 2d 00 fe ea b4   mov.b @(0xFEEAB4,er2), r5l
05BB32  0d 5d                     mov.w r5, e5          ; e5 = op : FEEAB4[s]
05BB34  78 20 6a 25 00 fe ea b0   mov.b @(0xFEEAB0,er2), r5h
05BB3C  fd 00                     mov.b #0, r5l
05BB3E  01 00 6b 85 b1 3e         mov.l er5, @0xFFB13E  ; [0]=op [1]=FEEAB4[s] [2]=FEEAB0[s] [3]=0
```

Then the payload is copied from `0xFFB141`, so `[3]` is overwritten. When the ring is empty
(`B3E2 == B3E3`), `0x05BB8C` sends a filler frame `op, 01, 1F, 00` followed by zeros, with `op`
taken from `0x05BBD2[B0C7]` (`0x05BBA0 fd 01 0d 5d f5 1f fd 00`). Both kinds then clear
`B0A4.b6`, so no ACK is awaited (Confirmed).

### 5. The driver tick (register writes Confirmed; period Inferred)

**There are two levels.** The DSP tick `0x056272` is called once per main-loop pass
(`0x0030B8 5e 05 62 72`; its sibling entry `0x056236` is called from other loop sites, eight by H15's count). It is not tied to a timer. All
DSP delays are counted in scheduler timer bytes, and those bytes run off one interrupt.

**The timer channel** is initialised at `0x002482`, which is called at `0x002320` (boot) and
`0x002594`:

```
002482  fc 21 6a 8c fe f0   TCR  (FFFEF0) = 0x21
002488  fc c0 6a 8c fe f1   TMDR (FFFEF1) = 0xC0
00248E  fc 00 6a 8c fe f2   TIOR (FFFEF2) = 0x00
002494  fc 41 6a 8c fe f4   TIER (FFFEF4) = 0x41
00249A  79 04 00 00 6b 84 fe f6   TCNT (FFFEF6) = 0
0024A2  79 04 4e 20 6b 84 fe f8   TGRA (FFFEF8) = 0x4E20 = 20000
0024AA  fc 20 3c bc         TSTR (FFFFBC) = 0x20
0024AE  fc 00 3c bd         TSYR (FFFFBD) = 0
```

The same `TCR`/`TMDR`/`TIOR`/`TIER` layout is written to `0xFFFFC0`, `0xFFFFD0`, `0xFFFFE0`,
`0xFFFFF0` and `0xFFFEE0` at `0x0022C4`–`0x00231C`. That is six channels, with the start register
`0xFFFFBC` and sync register `0xFFFFBD` below them. This matches the H8SX TPU layout (Inferred), with bit 5 of `TSTR`
starting the sixth channel, `0xFFFEF0`. Elsewhere bit 3 starts and stops the `0xFFFFF0` channel
(`0x05B8C2 7f bc 72 30`).

**The ISR** is vector 110 (`0x0001B8` = `00 00 2a 30`) → `0x002A30`:

```
002A32  6a 18 fe f5 72 00   bclr #0, @FFFEF5     ; TSR.TGFA acknowledge
002A38  6a 0c 94 b8 ...     if (FF94B8) FF94B8--  ; also FF94B9, FF94BA
```

**The scheduler** `0x003576` is called from the main loops (`0x002AB0`, `0x002AFE`, `0x002BCC`,
`0x003114`):

1. It returns while `FF94B8 ≠ 0`.
2. Otherwise it reloads `FF94B8 = 2` and decrements the 88 byte timers `FF9536`–`FF958D` and 14
   word timers `FF95B2`–`FF95CD`.
3. Every 10th call (`FF9534`, `0x0035C4`) it does the same for 36 byte timers `FF958E`–`FF95B1`
   and 14 words `FF95CE`–.
4. Every 10th of those (`FF9535`, `0x003618`) it does the same for 7 words `FF95EA`–.

**Period.** In `TCR = 0x21`, `CCLR` (bits 7:5) = `001` (clear on TGRA match) and `TPSC` (bits 2:0)
= `001`. The standard H8S/H8SX TPU encoding gives `TPSC 001` = Pφ/4. Pφ = 16 MHz comes from the
SCI BRR ladder (doc 05, doc 14 §4). So the count rate is 4 MHz and the interrupt period is
20,001 / 4 MHz = **5.000 ms**. On that basis:

| Tier | Period | DSP timers in it |
| --- | --- | --- |
| ISR | 5 ms | – |
| fast (`FF94B8` = 2) | 10 ms | `FF9552` (power sequence), `FF9558` (header repeat, 100 = 1 s), `FF9565` (`0x1E` = 300 ms, TERM TX wait), `FF957B`/`FF957C`/`FF958C`/`FF958D` |
| slow (×10) | 100 ms | `FF9596` (version watchdog `0x78` = 12 s), `FF95A2` (`0x14` = 2 s, short-TX TERM TX wait), `FF9597` (`0x23` = 3.5 s, set at TX start `0x0359A2`) |
| ×100 | 1 s | words `FF95EA`– |

The tiers are minimum periods: they advance only when a main loop polls `0x003576`, and
`FF94B8` saturates at 0.

**This corrects doc 52 §2.2.** H15 assumed φ/8 and a 10 ms interrupt. Its derived times halve:

| Timing | Doc 52 | Corrected |
| --- | --- | --- |
| enable → reset assert (`T9552 = 10`) | ≈ 200 ms | 100 ms |
| reset pulse (`3`) | ≈ 60 ms | 30 ms |
| version watchdog (`0x78`) | ≈ 24 s | 12 s |

The register values are Confirmed (`T2`–`T7`). The TPSC decode is **Inferred**: the vendor manual
for this part is not in the package. The `SCKCR` write `0xFFFDC4 = 0x0111` (`0x0020FC`, `T9`) was
not decoded. Pφ rests on the SCI ladder, not on `SCKCR`.

One loose end belongs to the TPU guard used by the scripts (`0x05B8A0`):

- the `0xFFFFF0` channel is initialised with `TCR = 0x00` (`0x0022F6 fc 00 3c f0`, `T10`), which
  is Pφ/1;
- the guard compares its counter with `0x8980` (35,200 counts, 2.2 ms at Pφ/1);
- H15 called this a "3 s" timeout.

No other `TCR` write to that channel was found in `txt_tpu.tsv`, so the "3 s" label is not
confirmed (Open).

### 6. `0xFF8DDE`: writers, readers, and what it is

**Writers (Confirmed).** All 215 accesses are `mov.b` (`acc_a1.tsv`). The whole-image scans find
exactly three stores, all abs16 (`W1`), and no abs32 store, pointer load or bit operation (`W2`,
`W3`):

1. **`0x010580` `6a 84 8d de`, in the setter pair.**
   - Entries `0x01054A` (`f4 ff`, value `0xFF`) and `0x010556` (`f4 01`, value 1) both call
     `0x010310` and `0x0452C6` first.
   - The pair is a toggle. If `FF8DDE` is already nonzero, `r4h` is forced to 0 before the store
     (`0x010578 6a 0c 8d de 47 02 f4 00 6a 84 8d de`).
   - Next, `0x01058A` re-initialises SCI-A (`jsr 0x045186`). When the byte is nonzero it first
     copies `[er0+0x6C]` to `FF8DE1`; when it is zero it first calls `0x0452AC`.
   - **The only references to the two entries are the BE32 slots `0x010266` and `0x01026A`**
     (`D7`, `W9`). There is no `jsr`/`jmp` (`W10`). Both slots lie inside the boot-time held-key
     dispatch `0x10100`–`0x102C0`. **Which key or condition selects them is out of scope**, and
     this lane did not read that region.
2. **`0x0105B6` in `0x0105AE`.** This clears the byte if it is set, then runs the same SCI-A
   re-init. It is called by the five other mode entries: `0x0103C0`, `0x0103E6`, `0x010444`,
   `0x01050E` and `0x010528`. So entering any of those modes leaves node mode.
3. **`0x00E516` in the defaults routine `0x00DEFA`** (called from `0x00DCDA`). This sets
   `FF8DDE = FF8DDF = FF8DE0 = 0` and `FF8DE1 = FF8DE2 = 0x0A`.

**Persistence (Inferred).** `FF8DDE` is offset `0xBE` of the R3 settings block
`0xFF8D20`–`0xFF8E9F`, which doc 32 maps to EEPROM `0xD000+n`. The mode would therefore survive a
power cycle. The save path was not re-traced.

**Two values, two labels (Confirmed).** The display routine `0x008A94` makes the choice (`D8`–`D11`):

- `bpl` falls through for a negative value and loads `0x008A70` = `00 00 "WIRES-X PDN"`;
- a positive value takes `0x008AE8` → `0x008A82` = `00 00 "WIRES-X NODE"`, or one of the status
  lines at `0x008274 + 18·n`.

`0x0081B6` (`D12`) puts the `WIRES-X` line on screen for any nonzero value. The shared test idiom
(`D13`, 14 occurrences in the image) makes `0xFF` active only while `B3D9.b0 == 0`, and `1` active
always:

```
6a 0c 8d de   mov.b @FF8DDE, r4l
4a 0c         bpl   +12          ; 1: r4l stays 1 -> active
fc 00         mov.b #0, r4l      ; 0xFF:
6a 10 b3 d9 77 00  bld #0, @FFB3D9
67 fc         bist  #7, r4l      ; r4l = 0x80 iff B3D9.b0 == 0
0c cc         mov.b r4l, r4l     ; Z flag = inactive
```

**What a nonzero value changes** (readers, Confirmed at the cited sites):

- **SCI-A.** `0x045186` sets 38,400 bit/s and installs the framed host handler (doc 14 §4).
  `0x06B73A` sets `FFB3E0 = 1` when the second handler (`0x06BA46`) is installed, which means
  the link is up.
- **DSP link.** `0C`–`0E` become 96-byte frames (frame_finish and the DMA, doc 52). The `11`
  frame gets bit 1 in `[1]` (`0x0590A2`). Init step 12 stores `0x24` to `FF0BF6`.
- **The `16` header comes from the PC.** The builder's host arm (`0x0597FC` → `0x05993A`) takes
  `[1]`, `[3]` and `[4]` from `FF0BF6`/`FF0BF8`/`FF0BF9`. The host `F` packet fills those at
  `0x06C7D8`–`0x06C848` from the ASCII fields `FF1ACE`–`FF1AD5`. The same handler sets the TX DT
  source `FFB3DB` (`0x06C826`), which the TX start routine copies into `B0C7` (`0x0358BE`).
- **Codec relay.** In sessions, steps 14/16 run `0x05BA22`, and TXOFF resets the ring. On the RX
  side, `9A` and `AC`–`AE` divert to the host path (doc 52).
- **Header and message relay** (§7 c).
- **UI and settings.** There are the labels above. `0x017822` refuses the `32` re-send request in
  node mode (`6a 0c 8d de 47 06 5e 03 ff a0`).
- **Main loop.** There is a separate node-mode main loop at `0x0037C8` (`nloop.txt`).

**Is it WIRES-X PDN on the DATA jack?**

- **Confirmed for `0xFF` only.** The label `WIRES-X PDN` is selected by the sign bit.
- **The value `1` is `WIRES-X NODE`.** Its hardware partner is not named in the image. "HRI-200"
  does not appear in MAIN or SUB (Not found, whole-image string scan, `W11` plus the SUB scan in
  §Method). So the HRI-200 link is **Unknown** from this package.
- **"DATA jack" is Inferred.** It rests on doc 14's identification of SCI-A `0xFFFE90` through the
  `COM PORT SETTING` speed list.

**Correction to doc 14 (Inferred).** Doc 14 calls the positive value the "clone/programming
personality", citing the reset at `0x06B7DC`. That code runs only when `FFB3E0 ≠ 0` (link up)
and the link timer `FF959E` has expired (`0x06B7A4`–`0x06B7BE`), or when `B3D5.b1` is set with
`FF94C0 == 0`:

- for a positive value it then resets the radio (`jsr 0x002648; orc #0x80,ccr; jmp 0x002050`);
- for `0xFF`, while `FF959E < 0x32`, it reinstalls the handler instead.

That is a link-loss action, not a clone protocol. The positive value also shows `WIRES-X NODE`
and runs the full codec relay. So it is the second node mode, not a clone mode.

### 7. Lane I4's hand-off claims

**(a) `B12D` bits 0 and 7. Confirmed, with a wider consumer set.**

- **Set:** `0x0569B6 ac 9c 47 22 ac 9e 47 16` branches to `0x0569DC 6a 18 b1 2d 70 00`
  (`9C` → b0) and `0x0569D4 6a 18 b1 2d 70 70` (`9E` → b7) (`A1`, `A2`).
- **Consumers of b0:**
  - the session EVENT steps `0x05B856`/`0x05B890` (clear at `0x05B898`);
  - the data builders, which clear b0 each time they build a `09`/`19` frame (`0x059CCE`,
    `0x059D26`, `0x059D86`).
- **Consumers of b7:**
  - `0x05BC34` (clear at `0x05BC3C`);
  - `0x05BC4E` (`0x05BC56`, `0x05BC6E`);
  - `0x05EC8C` (`0x05EC94`);
  - stale b7 is cleared at TX start (`0x05B814`, `0x05C454`).

The consumers therefore span `0x059CCE`–`0x05EC94`, not just `0x059C28`–`0x05C44C`.

**(b) `0x0594FA` reads `0xFF0BF6`. Confirmed, host-link arm only.**

- The read is `0x05993C 6a 2c 00 ff 0b f6` (`B1`). It sits behind the `FF8DDE` gate at
  `0x0597FC` (`B2`), and the value is ORed into header byte `[1]`.
- **Writers:**
  - `0x05B04C` (init step 12, `0x24`, `B3`);
  - `0x06C7F4` (host `F` packet, `B4`).
- **Also:** the `]` receive store copies into the `0xFF0BF4` record through pointer loads
  (`0x0581BC`, `0x058404` `7a 06 00 ff 0b f6`).
- In normal mode `[1]` comes from `B120`/`B12E` instead (`0x059812`–`0x059836`).

**(c) Host-link relays. Confirmed, with one destination corrected.**

`sub_06C200` takes its tag in `r3l`:

- `'1'` from the CSD1 (`A6`) states, e.g. `0x05714A fb 31 5e 06 c2 00`;
- `'2'` from CSD2 (`A7`), e.g. `0x05732C`;
- `'3'` from CSD3 (`A8`), e.g. `0x0577DA`.

There are 20 call sites in `0x05714C`–`0x057F84` (`C1`–`C3`).

It passes only if all of these hold:

- `FF8DDE` is positive, or negative with `B2A5 == 2`;
- `FFB3E0 ≠ 0` (`C4`);
- `DT ≠ 1`;
- `B111 ≠ 0`;
- `rx[6]` b7:6 == 0;
- the DG-ID matches when `FF8ED7` is set.

It then does the following:

- stores the tag at `FEEB28`;
- copies `rx[1..6]` (6 B from `FFB0E1`) to `FFB3BE` (`C5`);
- copies **`rx[7..26]` (20 B from `FFB0E7`) to `0xFEEB14`** (`C6`), where I4's table gave
  `0xFEEB2A…`;
- writes a voice-mode character `'0'`–`'3'` to `FEEB29` (`C7`);
- sets `B3D7.b7`.

**Message relay.** `sub_05EA3A` copies `length + 0x42` bytes from `FEF920` to `FEFD72` (`C10`)
and sets `B3D7.b2`. It requires `FFB3E0 ≠ 0` (`C11`). At its first caller, the gate is
`0x058794 6a 0c 8d de 47 2e 4a 26` (`C9`):

- `0` → local dispatch only;
- positive → relay **instead of** the local dispatch (`0x0587C2 jsr`, then `bra 0x058816`);
- `0xFF` → relay only when `B2A5 == 2` and the `B3D9` bits allow it (plus `sub_05EACA` for `]`
  messages).

### 8. Hand-reconstructed C for the script interpreter

```c
/* RAM cells (all in FFB0xx unless noted); names are descriptive, not vendor names */
extern uint8_t B0A4;   /* link flags: b7 ready, b5 ACK, b4 NAK, b3 ACK/NAK owed, b2 init done, b1 ver known */
extern uint8_t B0A9, B0BF, B0CA, B0AF;   /* step counters: init, session, header refresh, ID push */
extern uint8_t B0BD, B0BE, B0B7, B0B5;   /* new-session flag, script code, requested code, mode */
extern uint8_t B12D;   /* DSP events: b0 9C DATA TEXT SET, b1 9F, b7 9E TERM TX */
extern uint8_t BB94;   /* short-TX session active */
extern uint16_t B0DC;  /* DSP version word from 9F */
typedef void (*step_fn)(void);

#define LINK_READY()  ((B0A4 & 0x80) && !(B0A4 & 0x08))
#define ACKED()       (B0A4 & 0x30)              /* ACK or NAK: both advance */

/* 0x05B442 and every other session dispatcher: one shape, no bound check */
static void run(const step_fn *tbl, uint8_t *step) { tbl[*step](); }

/* typical handlers */
static void send_07(void)  { if (LINK_READY()) { build_07_59BBA(); B0BF++; } }  /* 0x05B6A0 */
static void wait_ack(void) { if (ACKED()) B0BF++; }                             /* 0x05B3E2 */
static void end_ack(void)  { if (ACKED()) B0BE = 0; }                            /* 0x05B41C */
static void wait_9c(void)  { if (B12D & 0x01) { B12D &= ~0x01; B0BF++; } }       /* 0x05B890 */
static void wait_9e(void)  { if (B12D & 0x80) { B12D &= ~0x80; B0BF++; } }       /* 0x05BC34 */
static void tx_on(void) {                                                        /* 0x05B7E6 */
    if (!host_link_active() && !(B0BB & 0x02) && !(B0BB & 0x01)) return;
    B0BB &= ~0x02; P3DR &= ~0x04; B12D &= ~0x80; B0BB &= ~0x80; B0BF++;
}
static void tx_off(void) {                                                       /* 0x05BC7C */
    P3DR |= 0x04; B0BB |= 0x80;
    if (host_link_active()) { B3E2 = B3E3 = 0; B3DD = 0xFF; B3D6 &= ~0x0B; B3D7 &= ~0x08; }
    B0BF++;
}
static void send_more_09(void) {                                                 /* 0x05B7C0 */
    if (B126 && B122 < B123) { B0BF = 0x0A; send_09_step(); return; }            /* 0x05B7A0 */
    if (B126 && B122 > B123) B126 = 0;
    B0BF++;
}
static int host_link_active(void) {          /* the 14-site idiom, D13 */
    int8_t m = (int8_t)FF8DDE;
    if (m == 0) return 0;
    if (m > 0)  return 1;                    /* value 1: WIRES-X NODE */
    return !(B3D9 & 0x01);                   /* value 0xFF: WIRES-X PDN, gated by B3D9.b0 */
}

/* 0x05AF70: init script, table 0x05AF92, counter B0A9 */
static const step_fn init_tbl[14];           /* 05AFCA 05AFEE 05AFF8 05AFEE 05B158 05AFEE 05B16E
                                                05AFEE 05B0CC 05AFEE 05B0F8 05AFEE 05B03A 05B01E */

/* 0x05A1BE / 0x05A28A / 0x05A2F8 -> 0x05A376: request a session */
int dsp_request(uint8_t code /* 2,0x0A,0x0B,0x10,0x15 */, uint8_t dt) {
    if (!LINK_READY()) { ui_beep_3FFA0(); return 1; }  /* also aborts on the TPU guard */
    B0B5 = 1; B0B7 = code; B11E = dt;
    B0AC = 0; B0BB = 0;
    if (B0B5 >= 2) { build_1C_5A040(); return 0; }      /* dead: B0B5 is only ever 1 */
    if (B0BE) { ui_beep_3FFA0(); return 1; }            /* a script is already running */
    B0BD = 1; B0BE = B0B7; return 0;
}

/* tail of the tick 0x056272, from 0x0562FC */
void dsp_scripts(void) {
    if (!(B0A4 & 0x04)) { run(init_tbl, &B0A9); return; }          /* 0x056304 */
    if (B0C9 & 0x80) { B0C9 = (B0C9 & ~0x80) | 0x40; B0CA = 0; }   /* header refresh */
    if (B0C9 & 0x40) { run(hdr_tbl_5B19A, &B0CA); goto tail; }
    if ((B0AB || (B0AA & 0x80) || (BBF9 & 0x80)) && !B0BE) { send_12_req_5B210(); goto tail; }
    if ((B0AC & 0x80) && !B0BE) send_12_req_5B254();
    if (idpush_5B1A2()) goto tail;                                  /* 15 01 / 15 11, B0AF */
    if ((B0CE & 0x80) && !B0BE) { rx_enable_req_5B28C(); goto tail; }
    if ((B0CE & 0x08) && !B0BE) send_32_req_5B2D8();
tail:
    if (BB94) { run(short_tx_5EBD2, &B0BF); return; }
    if (B0BD) { B0BF = 0; B0BD = 0; prepare_block_5C50C(); }
    if (B0BE) session_5B310[B0BE]();       /* each entry runs its own table on B0BF */
}
```

Three small behaviours in the C are worth stating:

- The tick runs the init script **instead of** everything else until `B0A4.b2` is set.
- `dsp_request` returns 1 and calls `0x03FFA0` when the link is busy. The UI callers turn that
  into `AAD5 = 0x14` (`0x0359E2`), so a press while busy is refused, not queued.
- `B0BE = 0x16`/`0x17` overwrite the code after a successful `0x05A1BE`/`0x05A28A` call
  (`0x06CF4A`, `0x06D08A`).

### 9. Corrections to earlier documents (evidence above)

| Doc | Claim | Correction | Evidence |
| --- | --- | --- | --- |
| 52 §2.2 | ISR 10 ms (φ/8), tiers 20/200 ms; times ≈ 200 ms / 60 ms / 24 s | ISR 5 ms (`TPSC 001` = Pφ/4, Inferred), tiers 10/100/1000 ms; 100 ms / 30 ms / 12 s | `T2`–`T7` |
| 52 §1 | `P3DR.b2` "set at power-up, cleared only at shutdown" | also cleared at TX start `0x05B810`, set at TX end `0x05BC7C`/`0x05BF30` | `W7`, `W8` |
| 52 §5/§6 | `0C`–`0E` frame `op, FEEAB0[s], FEEAB4[s]` | `op, FEEAB4[s], FEEAB0[s]`; filler `op 01 1F 00` when empty | `OP22`, `OP25` |
| 52 §6 | `07`/`08` are live MAIN→DSP traffic | unreachable in ver 1.02 | §3, `W12`–`W15` |
| 52 §3.6 | session tables include `0x05C1A4` | `0x05C1A4` is unreferenced; B0BE `0x17` uses `0x05C200`; tables for codes 1, 6, `0x0F`, `0x14` are dead | `S4`, `W4`, `W6` |
| 52 §3.6 | `0x31` frame not found | built from immediates at `0x05EB2A` | `OP02` |
| 56 §4 | host header copy `rx+7` → `0xFEEB2A…` | → `0xFEEB14` (20 B); tag at `FEEB28`, mode at `FEEB29` | `C5`–`C7` |
| 56 §5 | `sub_05EA3A` copies in host-link mode | it replaces the local dispatch (gate `0x058794`) and needs `FFB3E0 ≠ 0` | `C9`–`C12` |
| 14 §4 | positive `FF8DDE` = clone personality | positive = `WIRES-X NODE` mode; `0x06B7DC` is a link-loss reset (Inferred) | `D8`–`D13` |

## USB relevance

**Q1 (USB): no USB here.** None of these code areas touches the USB module (`0xFFEE00`–`0xFFEE53`):
the scripts, the builders, the tick, the timer setup, the `FF8DDE` setter tail or the host link.
None of them jumps into the closed window either.

- Not found, by a Python operand scan of `0x055FF0`–`0x05A480`, `0x05AF70`–`0x05C900`,
  `0x05E9E0`–`0x05ED00`, `0x06B700`–`0x06CD40`, `0x002400`–`0x0025B0`, `0x002A00`–`0x002A80`,
  `0x003500`–`0x003660` and `0x010540`–`0x010600`. The scan covered abs16/abs32 `0xFFEExx`
  operands and `jsr 0x0781xx`–`0x07B7xx`.
- The only external path into the DSP sessions is **SCI-A**, through the `FF8DDE` node modes.

**Q2 (SDR): no, unchanged.**

- Every script frame is a control, header, text or data-block frame. The largest is 96 B per
  link turn.
- The only bulk payloads are data-channel text (`09`/`19`) and, in node mode, compressed codec
  bits (`0C`–`0E`).
- No script requests or receives samples.

**Q3 (DSP reachability): sharpened.** The DSP is driven only by:

- the fixed init script;
- seven fixed session scripts, selected by UI/PTT/message code through `B0BE`;
- six single-frame requests.

There is no generic "send this opcode" entry: the only table that maps an index to builders
(`0x05A3CE`) is dead. In node mode, the PC controls more than H15 stated:

- the codec bits (`0C`–`0E`);
- the `16` header bytes `[1]`, `[3]` and `[4]` (frame-kind, DT and DG-ID fields, from the host
  `F` packet via `FF0BF6`–`FF0BF9`);
- the 60-byte header block (`FF0BFC`, compared and sent at step 4);
- the TX DT (`FFB3DB` → `B0C7`).

All of these are field values inside fixed frames. The opcode is always chosen by the firmware.
Node mode itself is entered only through the out-of-scope boot-time dispatch slots
`0x010266`/`0x01026A`, or restored from EEPROM (Inferred).

## Open

1. **Pin the TPU decode.** Confirm `TCR` `TPSC 001` = Pφ/4 and the channel numbering
   (`0xFFFEF0` as channel 5, `0xFFFFBC` as `TSTR`) against the exact part's manual. That would
   make the 5 ms tick Confirmed. In the same pass, resolve the `0xFFFFF0` guard: its
   `TCR = 0x00` and its `0x8980` compare do not give "3 s".
2. **Name the request sources.** `B0AA.b7` has about 20 setters (`0x019C5A`–`0x06CE60`). Also
   trace `B0CC.b0` (the `1C 03` session), `FF89BB` (the `BB94` short TX), `0x01115C`/`0x01159C`
   (`B0BE = 0x16`) and the message-engine callers of `0x06D052` (`B0BE = 0x17`). These give the
   UI meaning of each session.
3. **Decode the `11`/`12`/`32` setting bytes.** These are `FF8E20`–`FF8E36`, `FF8D85`/`FF8D86`,
   `FF8AA0`/`FF8ABD` and ROM `0x00F9A8`. Use doc 32's settings map to find which ones are
   volume, squelch, AMS or digital mode. This lane found no named volume/squelch opcode.
4. **Doc 14 / doc 24 owners:**
   - re-label the positive `FF8DDE` value as `WIRES-X NODE`;
   - decide whether `0x06B7DC` is only a link-loss reset;
   - trace the EEPROM save of `FF8DDE` (R3 offset `0xBE`).
5. **Seed hygiene.**
   - Mark the dead step bodies as unreferenced code: `0x05B058`, `0x05B068`, `0x05B088`,
     `0x05B098`, `0x05B0A8`, `0x05BE2C`/`0x05BE4C`, `0x05BED0`/`0x05BF02`, `0x05C0FE` and
     `0x05C144`.
   - Mark the table `0x05C1A4` as data.

   None of these has a 32-bit, `jsr` or `jmp` reference anywhere in the image (scratch scan), or a
   branch xref in the I5 listing.

**Ledger: no change claimed.** This lane added no reached bytes and retyped none.
