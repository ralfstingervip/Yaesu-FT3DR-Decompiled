# 124 — Bluetooth module protocol on SUB, and every path from the module into MAIN (lane M12)

> Lane M12, model `claude-opus-5-5`. Owner-side static analysis only: read-only work on the two
> plaintext images. Nothing was connected to, enumerated on or written to any radio or device.
> Private databases `M12_BT_SUB` (`--copy-from ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`) and
> `M12_BT_MAIN` (`--copy-from ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64`), iterated with
> `--reopen`. No other database was opened. `decrypted\*.bin` unchanged (sha256 `b93570b3c2f69ccb…` /
> `8e3ecd05409b2c31…`, printed by `verify.py`). SUB is RX little-endian at `0xFFC00000`; IDA prints
> unsigned `75 5x` immediates as signed (`cmp #-2Eh` = `0xD2`, `cmp #-1` = `0xFF`). MAIN is H8SX
> big-endian at base 0. Tables: `ida\out\bluetooth\`.

## Verdict

The Bluetooth unit is a self-contained module on SUB SCI3 (channel 2) that speaks a line protocol
of 12 four-letter tokens. The radio is the host. It sends 5 command families (`SCAN`, `LINK`, `SCOL`,
`TXAT`, `PINF`) and the module answers each with the same token. The module also sends 7 unsolicited
indications (`HELL`, `PAIR`, `FIND`, `ERAT`, `RXAT`, `SCOI`, `ERRO`), and the radio acknowledges
each one by echoing it or by returning a 4-hex-digit byte sum. A 50 ms ack timer re-sends an
unanswered command once, then sends `ACK ERROR`.

**Not found (scope: both images):** no vendor, chip or model string. The module family is Unknown.
`AT+CKPD=200` is the Headset Profile button command, so the far end is a headset (Inferred).

Four MAIN→SUB opcodes drive the protocol, plus header bits carried in every frame:

| Opcode | What it does |
| --- | --- |
| `F3D2` | Bluetooth on/connect item, four sub-ops |
| `F3D3` | Search on/off, and the device-list names |
| `F3D5` | Remove a pairing (`PINF=0,<addr>`) |
| `F3D6` | Immediate (re)connect, used for auto-connect at power-up |

The header bits ride in byte `+0x18` (`FF3D8C`) and byte `+9` (`FF3D7D`) of **every** MAIN frame:
- BT on;
- "Bluetooth Save";
- SCO wanted;
- VOX mode, hang and threshold.

Status returns to MAIN only as E4, E5 and E6 frames:
- **E4:** link and scan status, with codes 0–3, 5, 9 and `0x10`–`0x13`.
- **E5:** the radio's own audio-level ("BT VOX") detector. MAIN never reads it.
- **E6:** headset PTT.

**Owner question: is `CKPD=200` the only TX-keying input from the module?** Yes, as a protocol
input (Confirmed). Every `E6 01` the SUB can send traces to an `RXAT=CKPD=200` line, and that line
is parsed only after the module has acknowledged `TXAT=1`.

The module can still change MAIN state in other ways (all gated, list below):
- found-device names and addresses go into MAIN's 5-entry device list and its EEPROM;
- link status drives the speaker-path port bit `0xFFFF59.b2`, an alert tone and a popup.

Separately, headset audio can key TX through MAIN's VOX when VOX is on. That path is analog and
electrical, not protocol, and its wiring is Inferred.

**USB:** none. 0 USB0 operands in SUB, and 0 USB-module operands in any MAIN routine on these paths.

## Method

- **SUB jobs.** `ida\jobs\m12_dump.py` is a copy of `l10_dump.py` plus a `funcs` lister. Its
  commands are `dis`, `func`, `xref`, `callers`, `refrange` and `imm`. Requests and outputs are in
  `ida\out\bluetooth\work\` (`reqs*.txt`/`outs*.txt` for SUB, `req*.txt`/`out*.txt` for MAIN).
- **SUB scope.**
  - Full disassembly of the Bluetooth cluster `FFF37CB9`–`FFF3B8DE` (82 functions, including
    `vsnprintf` `sub_FFF3B1F7`, which was skimmed only).
  - The link-layer dispatcher tail `FFEDCDC0`–`FFEDD0D0`.
  - The ADC helpers `FFF15811`–`FFF15A18`.
  - Callers of every Bluetooth function.
  - Operand scans of every code head over the whole image for the state cells `10540`–`1076F`,
    `1229C`–`122B0`, `1251E`–`12535`, `12CB8`–`12CC6`, `6836C`–`683E0`, `69540`–`69590`,
    `8C020`–`8C02F` and USB0 `A0000`–`A0FFF`.
- **MAIN scope.**
  - `sub_7C20` (common header) `0x7C20`–`0x7E58`.
  - The F3D2/F3D3/F3D5/F3D6/F3D4 builders `0xD2A0`–`0xD560`.
  - The sender table `0x7860`–`0x78C0`.
  - The E4/E5 handlers and the Bluetooth state machine `0x72FF0`–`0x734BE`.
  - The DEVICE LIST actions `0x2C0A0`–`0x2C1AA`.
  - The VOX keyer `0x105BE`–`0x106B0`.
  - The speaker-path routine `0x39130`–`0x391C0`.
  - Operand scans for `FFBB71`–`FFBB92`, `FF3D8C`/`8D`, `FF8EAF`/`B0`, `FFBB8E`–`90`, `FFAAEA`/`EB`
    and USB `FFEE00`–`FFEE53`.
  - Raw byte searches of `0`–`0x80000` for `bb 92`, `ba 92`, `bb 70`, `89 20` and the `F3Dx` opcodes.
- **Verification.** `ida\out\bluetooth\verify.py` re-reads every byte run in `cites.tsv` from the
  images. Result: **342/342 PASS**. The output is `verify.tsv`.
- **Not done.**
  - The module's own firmware is not in the package.
  - `sub_FFF3B1F7` (formatter) was not decoded beyond its role.
  - Which ADC channel the BT-VOX detector samples (`sub_FFF15967`) is not traced.
  - The electrical net of SUB P24 and MAIN `0xFFFF4E.b0` is Unknown.
  - The MAIN screens that show E4 names were not traced past the state cells.

## Findings

### 1. Transport, pump and timing (Confirmed)

- **Transmit.** `sub_FFF3B630` formats into `1075F` and writes channel 2
  (`FFF3B652 66 21`, `FFF3B654 05 d9 f8 f9`).
- **Receive.** `sub_FFF3A11F` reads one byte at a time from channel 2 (`FFF3A1D4 05 7c 10 fa`) into
  the line buffer `1065B`. A line ends at LF (`FFF3A1AE 61 a1`). The index is capped at 255
  (`FFF3A189 75 5e ff`), so the buffer ends at `1075A`.
- **Pump.** `sub_FFF3B69B` is called from the tick fan-out `sub_FFF36CAB` (`FFF36CB7 05 e4 49 00`).
  That fan-out is called from the TPU0 vector-135 ISR (`FFEE11D9 05 d2 5a 05`; 200 Hz per doc 02),
  so all Bluetooth parsing and all E4/E5/E6 sends run in tick-interrupt context. Each pass does
  the following, in order:
  1. the power-up countdown, then sets **P87** (`FFF3B6D4 f0 e7` on `8C028`);
  2. the deferred-LINK countdown (`FFF3B71C`);
  3. the level detector, every 2nd pass (`FFF3B74C`);
  4. reads one line (`FFF3B74F`) and runs classifier B (`FFF3B760`), then classifier A
     (`FFF3B770`);
  5. checks the ack timer 3 (`FFF3B784`), HELL timer 1 (`FFF3B798`) and operation timer 2
     (`FFF3B7AC`);
  6. runs the SCO idle manager (`FFF3B7AF`).
- **Timers.** There are 7 software timers at `6836C`, counted by the CMT3 ISR. CMT3 is set to
  CMCR `0xFFC0` and CMCOR `0xEA5F` (`FFF39E43 3d 10 c0`, `FFF39E4B f9 e9 02 5f ea`), which is
  100 Hz (doc 02).

  | Timer | Ticks | Time |
  | --- | --- | --- |
  | Ack (timer 3) | 5 (`FFF397E5 66 52`) | 50 ms |
  | HELL wait (timer 1) | 500 (`FFF396D2`) | 5 s |
  | Scan window (timer 2) | 3000 (`FFF397EC fb 2a b8 0b`) | 30 s |
  | Link (timer 2) | 2000 | 20 s |
  | SCO open (timer 2) | 1000 | 10 s |

- **Module power.**
  - Bluetooth ON sets **P22** (`FFF396BE f0 e2` on `8C022`), waits 2 pump passes, then sets P87.
  - Bluetooth OFF clears both (`sub_FFF396E5`).
  - The labels "power" and "reset" are Inferred.

### 2. Line classification (Confirmed)

The ROM table `0xFFEDA7A0` holds 14 pointers and a zero terminator (verified, 60 B). It is copied
to RAM as two arrays:

| Array | RAM base | Index 0 | Real tokens | Compare limit |
| --- | --- | --- | --- | --- |
| A | `69550` | blank `"    "` | 1 `SCAN`, 2 `LINK`, 3 `SCOL`, 4 `TXAT`, 5 `PINF` | `FFF3A3F6 61 61` (index < 6) |
| B | `69568` | blank `"   "` | 1 `HELL`, 2 `PAIR`, 3 `FIND`, 4 `ERAT`, 5 `RXAT`, 6 `SCOI`, 7 `ERRO` | `FFF3A398 61 81` (index < 8) |

The pump tries **B first**. If B returns non-zero (no match, or a handler refused the line), it
tries A. If A also fails, the radio answers `ERROR\r\n` (`FFF3A404`). `RXAT` and `ERAT` are
dispatched only while `[10578] == 1` (`FFF3A2FF`, `FFF3A31D`).

**Group A lines are acknowledgements of the radio's own commands.** Each handler clears the pending
code `1054A` and timer 3.

| Line | Handler action |
| --- | --- |
| `SCAN=0` | scan callback 3 |
| `SCAN=1` | scan callback 5 |
| `LINK=<sum4>` | compares with `1075B`, the byte sum of the 12 address characters the radio sent, as 4 hex digits; callback 5 if it matches, 6 if not |
| `SCOL=` | content ignored |
| `TXAT=1` | `[10578] = 1` |
| `TXAT=0` | `[10578] = 0` |
| `PINF=<sum4>` | PINF callback 1 if it matches, 2 if not |

**Group B lines are indications from the module.** The radio echoes each one, or returns its sum.
The full table is `indications.tsv`; the headline effects:

- **`HELL<c>`** (`c` = `'O'` or a digit): module present. Sets `122AD = 2` (`FFF3A473 f8 e4 02`).
  Its callback sends **E4 code 1**.
- **`PAIR=<addr12>`:** the link is up. Sets `122AE = 5` (`FFF3A77B f8 e4 05`) and calls link
  callback 1 (`FFF3A786 66 11`), which sends **E4 code 0**. The address the module reports is
  only summed, never stored. MAIN gets back the name and address MAIN itself supplied.
- **`PAIR=0`:** the link is down. Calls callback 3 if the radio asked for it (`12528 == 1`),
  otherwise 9 (remote drop) or 2 (link attempt failed).
- **`FIND=<addr12>,<name≤16>,<4 chars>`:** a discovery result.
  - It is stored in an 8 × `0x1C` list at `10579`.
  - Duplicates are dropped by `sub_FFF3AC93`.
  - The list is copied to `[683B0] = 10469` (`smovf`, `FFF3A2DF`).
  - Scan callback 1 then sends **E4 `0x12`** with the newest entry's name and address.
  - When the list is full, the radio answers `FIND=OVER`.
- **`SCOI=1` / `SCOI=0` / `ERROR+SCOI`:** SCO opened, closed or failed. They drive the SCO callback
  `sub_FFF38EFB` (codes 1, 3 or 5, and 2).
- **`RXAT=<≤12>` / `ERAT=<≤6>`:** AT pass-through. Only `RXAT=CKPD=200` has an effect: it calls
  `sub_FFF39216(6)` (`FFF3AA79 66 61`), the doc-107 PTT toggle.

**Robustness note (Confirmed code, effect Inferred).** The FIND name loop runs `j` from 0 to 15
(`FFF3A57F 61 f1`) and then stores the terminator at `entry + 0x0C + j` (`FFF3A599 3c 1c 00`). A
16-character name with no comma therefore writes one `0x00` at `entry + 0x1C`:
- for entries 0–6, that byte is the first address character of the next entry;
- for entry 7, it is the count byte `10659` itself, which the following `count++` turns into 1.

This is a one-byte zero write inside SUB RAM. The value written cannot be chosen and the target
cannot be redirected.

### 3. Commands the radio sends, and what triggers them (Confirmed; `commands.tsv`)

Each command sets the pending code `1054A` and timer 3. The first expiry re-sends the command. The
second expiry sends `ACK ERROR\r\n` (`FFF3AC7B`) and drops the command, calling the callback with
code 4 or 2 where one exists.

- **`SCAN=1`** (`FFF397C5`) and **`SCAN=0`** (`FFF39825`). Sent on `F3D3` with frame `+0x21`
  bit 7 set or clear (`FFF382B2 51 1e 21`). They are also sent by `LINK` while a scan is running
  and on scan-window expiry with no device found.
- **`LINK=<12 hex>`** (`FFF3AFD4`). Sent on:
  - `F3D2` sub-op 3 (`FFF380E1`);
  - `F3D6` when `122A7 == 1` (`FFF381A8`);
  - the deferred re-link, 1000 pump passes after `F3D2` sub-op 2 or `F3D6` (`FFF38007`, `FFF3826C`,
    pump `FFF3B71C`);
  - link-failure retries.

  Retries are counted in `12CC0`: at most 3 attempts for a connect (`FFF38DAF 61 2e`) and 35 for a
  reconnect (`FFF38D10 75 5e 22`). After that the radio sends **E4 code 5**.
- **`LINK=0`** (`FFF39A23`/`FFF39A5D`). Sent on `F3D2` sub-op 1. When SCO is open, it is deferred
  through `122A2` until SCO has closed (`FFF37ECB`, then `FFF38FF2`).
- **`SCOL=1`** (`FFF39ADB`). Only sent when linked (`122AE == 5`). Senders:
  - `F3D2` sub-op 0;
  - every MAIN frame while linked with `FF3D7D.b5` set;
  - header bit changes;
  - the `CKPD=200` press;
  - SCO-drop re-opens.
- **`SCOL=0`** (`FFF39B5D`/`FFF39B90`). Sent on:
  - `F3D2` sub-op 1;
  - save mode with bit 6 clear;
  - the SCO idle manager: close request `1229C`, or 1000 idle passes (`FFF3959C 76 0e e8 03`);
  - SCO-open timeout.
- **`TXAT=1`** (`FFF39BE8`). Sent once per link (latch `122A5`, cleared on connect at `FFF38CB1`):
  - by `F3D2` sub-op 0;
  - by **any** MAIN frame other than `F3D2` while linked and `FF3D7D.b5` is set (`FFF38467`).

  This enables `RXAT` parsing.
- **`PINF=0,<12 hex>`** (`FFF3B0DB`). Sent on `F3D5` with frame `+8 == 9` (`FFF38359 61 91`). The
  address is frame `+0x19` and the name is frame `+9`.
- **Dead commands (Not found: no reachable caller):**
  - `LINK=1` (`FFF3B01A`): `sub_FFF39845` mode 0 is never requested, because `12526` and `1252A`
    only ever hold 1 or 2→1.
  - `TXAT=0` (`FFF39C48`): only its own retry case calls it.
  - `PINF=0` (`FFF3B05B`): `sub_FFF39C68` is called only with mode 1.
- **Replies the radio sends to indications** (§2): `HELL%c`, `FIND=OVER`, `FIND=%c%c%c%c`,
  `PAIR=0`, `PAIR=%c%c%c%c`, `SCOI=%c`, `ERAT=…`, `RXAT=…`, `ERROR+SCOI`, `ERROR`.

### 4. MAIN→SUB operations (Confirmed bytes; menu labels Inferred)

Frame offset `k` on SUB equals MAIN address `FF3D74 + k`.

| Op | MAIN builder | Trigger on MAIN | Payload | SUB handler and effect |
| --- | --- | --- | --- | --- |
| `F3D2` | `sub_D2DE` (`0x00D2E8 79 04 f3 d2`) | setup-item sender table slot `0x0078A4` | `+0x20` = `FF8920.b0`; **`+0x21` = `FF8EAF`** (`0x00D32E`); `+0x22` 16-char name, `+0x32` 12-char address of record `FFAAEC + 0x1C·FF8EB0` | `sub_FFF37D88`, by sub-op: **0** connected → `TXAT=1`, `SCOL=1` if SCO closed; **1** disconnect → `SCOL=0` and/or `LINK=0`, `122A7 = 1`, `12CBC = 3` with no E6; **2** reconnect → `E6 00` if keyed, `E5 00` if `12CBA == 1`, deferred `LINK`; **3** connect → `LINK=<addr>`, `122A7 = 3` |
| `F3D3` | `sub_D38C` (`0x00D3C0`) | slot `0x0078A0` | `+0x21` bit 7 = search (`BB8E == 1`, `0x00D3FA 70 7b`), low bits = `AAEB`; names of the stored devices from `+0x22` | `sub_FFF38292`: `SCAN=1` / `SCAN=0` |
| `F3D5` | `0x00D4C0` (`0x00D4CA 79 04 f3 d5`) | the same slot when `BB8F.b0` is set (`0x00D38C`/`0x00D392`); `BB8F.b0` is set by the DEVICE LIST action `0x02C0FA` | `+8 = 9` (`0x00D4FA fc 09`), `+9` name, `+0x19` address of the selected record | `sub_FFF38338`: `PINF=0,<addr>` → E4 code 9 → MAIN deletes the record (`0x07336C`) and rewrites the EEPROM list |
| `F3D6` | `sub_D2B2` (`0x00D2C2 79 04 f3 d6`), sent at once via `sub_B6B6` | `BB90` state 2 after E4 code 1 (`0x073118`), so auto-connect at power-up; E4 code 3 off screen `0x1E` (`0x0732C2`) | same as `F3D2` | `sub_FFF38107`: `LINK` now if `122A7 == 1`, else close E6/E5 and run the deferred re-link |
| `F3D4` | `sub_D526` (`0x00D52C 79 0b f3 d4`) | slot `0x0078A8` | `FF8920.b7` only (`0x00D526`) | no Bluetooth handler; SUB reads the same bit from the header (Inferred to be the "Bluetooth Save" item) |

**Header byte `+0x18` = `FF3D8C`, built in `sub_7C20` and carried by every frame.** Read on SUB by
`sub_FFF3850B` and the dispatcher at `FFEDCFB6 f5 e7 1d`.

| Bit(s) | Meaning | Source |
| --- | --- | --- |
| b7 | BT on | `0x007DC8` |
| b5 | save mode: BT on, VOX off, `FF8920.b7` | `0x007E4C` |
| b6 | SCO wanted | in save mode `!BB8F.b7` (`0x007E54 67 eb`); otherwise `BB70 == 0`, i.e. linked (`0x007E48`) |
| b1–0 | VOX mode: 0 off, 1 on, 2 on with BT | `0x007DE0`/`0x007DEE` |
| b4–2 | VOX hang (`FF89BC & 7`) | — |

Byte `+0x19` = `FF3D8D` is the threshold from table `0x007E2C` = `00 28 14 2d 18 00`, indexed by
`FF89BB`, plus 2 when BT is on.

**MAIN side of `BB8F.b7`.** `sub_73412` clears `BB8F.b7` (meaning "SCO needed") while TX is active
(`0x07342C`) or while RX is busy, then holds it for 100 ticks (`0x07348C fc 64`). In save mode,
SCO therefore opens for TX and for receive audio (Inferred).

**Header byte `+9` = `FF3D7D`.**
- b5 = BT on and linked (`0x007C9A`);
- b6 = BT on and not linked.

### 5. State machines (Confirmed values; meanings Inferred; `states.tsv`)

| Cell | Values | Writers / notes |
| --- | --- | --- |
| `122AD` (module) | 0 → 1 → 2 | 0 = driver down; 1 = driver up; 2 = HELL received |
| `10549` (radio activity) | 0 idle; 1 HELL wait; 2 scanning; 3 linking; 4 SCO opening; 5 deferred link | — |
| `122AE` (link layer) | 2 idle; 3 scanning; 4 linking; 5 linked | — |
| `122AF` (SCO) | 5 closed; 6 `SCOL=1` sent; 7 open | — |
| `122A7` (last E4 link code) | 0 connected; 1 disconnected or ready; 2 lost; 3 connecting; 5 failed | — |
| `12CBC` (headset PTT toggle) | 2 keyed; 3 released | 2 is written only on `CKPD` paths (doc 107) |
| `12CB8` | 1 running; 2 stopped; 0 never started | **The BT-VOX level detector state** |
| `12CC2` | 1 = the radio sent `SCOL=0` | lets `SCOI=0` tell a radio close (callback 3) from a headset close (callback 5) |
| `122A0` | 2 generic; 3 `CKPD`; 4 VOX-level; 1 dead | reason SCO was opened |

**`12CB8` in detail.**
- It is set to 1 when `sub_FFF38705` starts the detector (`FFF38759`).
- It is set to 2 on BT on/off edges while VOX mode is 6 (`FFF38627`, `FFF3865A`), and when VOX goes
  off (`FFF387B6`).
- **This answers doc 107's open item on `12CB8`.**
- The `CKPD` toggle sends E6 only if `1229D == 0x20` (save mode) or `12CB8 == 2` (`FFF392DF 61 2e`).
  So with Bluetooth Save **off**, the headset button keys only after VOX has been switched on and
  off, or BT toggled with VOX on, since boot. No initialiser of `12CB8` was found (operand scan),
  so its boot value is the RAM default (Inferred 0). This is a firmware quirk.

**`122A0` = 4** is written only at `FFF39486`. That site needs `1251E == 2`, which is written only
in `dead_FFF3887C`. So the "level → open SCO" branch is dead too.

**MAIN.**
- **`BB90`** (bring-up): 0 → 1 → 2 → 3.
- **`BB8E`** (user operation): 1 search; 2 connect; 3 awaiting connected.
- **`BB70`** (status): a copy of the E4 code.
- **`8EAF`:** the `F3D2` sub-op.
- The 5-slot device list lives at `FFAAEA`–`FFAB77`.

### 6. Every path from the module into MAIN state, with gates

| # | Module input | SUB → MAIN | MAIN effect | Gates (all Confirmed as code) |
| --- | --- | --- | --- | --- |
| 1 | `RXAT=CKPD=200` | `E6 01` / `E6 00` (sites `FFF39284`, `FFF39312`, `FFF393B6`, `FFF393F4`; plus `FFF38FD2` on SCO-up after a press) | **PTT key / unkey** via `FFBB91` → `sub_FD22` → event 14/15 (doc 107) | `FF8920.b0` on; module acked `TXAT=1` (`10578`); save mode or `12CB8 == 2`; `FF8004 < 2`; hardware PTT idle; then PTT LOCK, TX range, TOT |
| 2 | `SCOI=0` (radio-closed) after a `CKPD` key | `E6 00` (`FFF3906F`) | unkey | `122A0 == 3` |
| 3 | `FIND=<addr>,<name>,…` | E4 `0x12` (name ≤16, address 12) | added to `FFAAEC` if new and the list has fewer than 5 entries (`0x073202 ac 05`); **EEPROM write** of `0x8E` B at `0x1EA00` through `sub_3BF4C` (`0x03CDA4`–`0x03CDB4`) | only in MAIN search state `BB8E == 1`, i.e. the user started a search |
| 4 | timer-2 expiry, no device | E4 `0x11` | `BB70 = 0x11`; alert tone `AAE0 = 0x1D` (`0x0731AA`) | search state |
| 5 | `LINK=<sum>` | E4 3 | `BB70 = 3`; `F3D6` re-sent unless on screen `0x1E` (`0x0732C2`) | `BB8E == 2` |
| 6 | `PAIR=<addr>` | E4 0 | `BB70 = 0` (linked) → speaker-path routine forces **`0xFFFF59.b2` low** (`0x039162`/`0x0391AC 7f 59 72 20`); frame bits b5/b6 change | `BB8E == 3`; otherwise ignored |
| 7 | link failure | E4 5 | `sub_730D0`; popup `BBE1 = 6` (`0x0732FC`) | `BB8E == 3` |
| 8 | `PAIR=0` (remote) | E4 2 | `BB70 = 2`; reconnect via `F3D6` | `BB70 == 0` |
| 9 | `PINF=<sum>` | E4 9 | deletes the record, rewrites EEPROM | `BB8F.b1` (the user asked to delete) |
| 10 | `HELL` | E4 1 | `BB90` 1→2 → `F3D6` auto-connect | power-up after BT on |
| 11 | none (radio ADC) | E5 0/1 | **nothing**: `FFBB92` is written at `0x0482C8` and never read; `bb 92` occurs once in `0`–`0x80000`; `BA92.b4` is only set (`0x0482BE`) | — |
| 12 | headset audio (analog, Inferred) | SUB level detector drives **P24** (`FFF3B133 f0 e4` / clear at `FFF3B136`) | MAIN VOX keyer on `0xFFFF4E.b0` (doc 93), which keys TX; with BT on it clears instead of sets `0xFFFF50.b6` (`0x01069E` vs `0x0106AA`) | VOX on (`FF89BB ≠ 0`); P24→`4E.b0` wiring Unknown |

- **No path from the module writes settings other than the device list.** Other indication content
  is never stored:
  - `ERAT` text;
  - `RXAT` text other than `CKPD=200`;
  - the `HELL` character;
  - the `PAIR` address.
- **No path reaches the DSP or the TX frequency.**
- **Doc 107's open interaction is answered:** audio routing changes on MAIN only through `BB70`
  (path 6) and the VOX keyer (path 12).

## USB relevance

- **Q1.** Neither side touches USB.
  - **SUB:** 0 operands in `A0000`–`A0FFF` over every code head.
  - **MAIN:** all 170 operands in `FFEE00`–`FFEE53` lie in `0x0022BA`–`0x0770FE`, and none falls in
    the Bluetooth, header, E4/E5/E6, VOX or speaker-path ranges listed in Method.
  - The Bluetooth wire is SCI3 ASCII lines.
- **Q2.** No sample path. The largest field is a 28-byte E4 record; SCO audio stays inside the
  module and the analog path.
- **Q3.** No DSP frame is built on any path.

## Corrections to earlier docs (owning docs not edited)

- **Doc 14 / `bt_commands.tsv`.**
  - `FIND=%c%c%c%c`, `FIND=OVER`, `PAIR=0`, `PAIR=%c%c%c%c`, `SCOI=%c`, `HELL%c`, `ERAT=` and
    `RXAT=` are the radio's acknowledgements or echoes, not module data or "4-character PIN".
  - The module's `FIND` line carries `<addr12>,<name>,<4 chars>` (`FFF3A50B 61 c1`,
    `FFF3A57F 61 f1`).
  - `PAIR=<addr>` means "linked" (`FFF3A77B f8 e4 05`).
  - `LINK=1` is dead.
  - `PINF=0,<addr>` is sent only by `F3D5` (the delete flow, `0x07336C ac 09`), not as a DEVICE LIST
    feed.
  - A module line `ERROR` alone is answered with `ERROR`; only `ERROR+SCOI` is handled
    (`FFF3A8CF 75 51 2b`).
- **Doc 51.** `F3D5`/`F3D6` are Bluetooth pairing-delete and (re)connect frames (`FFF383DE`,
  `FFF381A8`), not a clone or identity handshake.
- **Doc 108.**
  - E4 is the Bluetooth link/scan status record (codes 0–3, 5, 9, `0x10`–`0x13`, name, address;
    `FFF38AEA`, `0x073292 ac 03`), not WIRES-X/GM status.
  - E5 is dead on MAIN, now Confirmed at byte level (scope `0`–`0x80000`).
- **Doc 109.**
  - E5 is the SUB BT-VOX level result (`FFF394CF`, `FFF39516`), not "Unknown".
  - `PAIR=`/`FIND=` in its channel-2 list are replies, not commands.
- **Doc 107.**
  - `TXAT=1` is also sent on every non-`F3D2` MAIN frame while linked (`FFF38467 39 7b 00`).
  - `1229D` comes from the common header of every frame (`FFEDD019`), not only `F3D2`.
  - Bit 6 of `FF3D8C` is `!BB8F.b7` only in save mode; otherwise it is "linked" (`0x007E48 70 6b`).

## Ledger

**MAIN proven +0, named +0.** Every MAIN routine used here is already set in `final6_*_mask`. The
unset bytes in these ranges are:
- data tables: `0x7308C` 16 B, `0x73162` 16 B, `0x733E0` 50 B, `0x2C110` 80 B, `0x7860` 96 B,
  `0x7E2C` 6 B (all named);
- L5's Inferred dead code `0x7319E` (8 B), which is unreachable behind `bra` at `0x07319C`.

**SUB window code +0.** The Bluetooth code `FFF37CB9`–`FFF3B8DE` is fully set, except the two
existing `dead_` functions.

**Proposals only (typed data; no headline effect):**

| Range | Size | What | Notes |
| --- | --- | --- | --- |
| `0xFFF4AE70`–`0xFFF4AFB0` | 321 B | 14 tokens + all Bluetooth format strings | overlaps L12's 260 B proposal by 252 B, adds the 69-B token block, and leaves out L12's non-Bluetooth `%d`/`FT3D` |
| `0xFFEDA7A0`–`0xFFEDA7DB` | 60 B | token pointer table + terminator | — |
| `0xFFECE2CC`–`0xFFECE2E3` | 24 B | VOX hang table `{u16, u16}` × 6, 500–3000 | below the window |

All three are 0 in every `mask_final3_after_*` file.

## Open

1. **The P24 → MAIN `0xFFFF4E.b0` net.** It decides whether headset audio can key VOX (path 12). It
   needs a board trace or the owner's radio, not the images.
2. **The ADC channel `sub_FFF15967` samples** for VOX mode 1 versus 2 (`1250A[2]` / `[4]`), and the
   peripheral bit `0xC1A80.6` that `sub_FFF1521C` sets.
3. **The `12CB8 == 0` quirk.** Confirm on hardware: with Bluetooth Save off and no VOX toggle since
   power-up, the headset button should not key.
4. **The `FF89BB` range.** It bounds the index of table `0x7E2C`; that is the M-wave prompt 4 item.
5. **MAIN screen `0x1E` and popup `BBE1 = 6`.** Find the label text via the SUB label lookup.

Files: `commands.tsv`, `indications.tsv`, `states.tsv`, `cites.tsv`, `verify.py`, `verify.tsv`, and
`work\` (requests and outputs). Job: `ida\jobs\m12_dump.py`.
