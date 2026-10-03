# 58 — The 32 orphaned setup screens and their settings bytes (lane I6)

Owner-side, static, read-only analysis of the owner's FT3DR/FT3DE ver 1.02 MAIN image
`decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, big-endian, base 0, so file offset = address). No image was
modified, nothing was connected to or written to any device, and the closed window `0x078106`–`0x07B753` was not
analysed (it was excluded from every scan below). Model: **Opus 5.5 (`claude-opus-5-5`)**.

Machine tables are in `ida\out\orphan-screens\`:

| File | Content |
| --- | --- |
| `orphans.tsv` | the 32 screens: the four table slots, the parsed exit saves, the RAM/EEPROM/BACKUP.dat target, the bits or range, the editor, live/dead, why unopened, and the evidence |
| `other-unopened.tsv` | the other 39 unopened ids: handlers, parsed exit saves, and what the code shows |
| `settings-bytes-ext.tsv` | extends F5's `settings-bytes.tsv` by key `(region, n)`: ram, eeprom, backup offset, screen id(s), handler, label, live/dead, evidence, source, F5 class. 644 rows |
| `bitfield-map.tsv` | per-bit owners of the R1 flag bytes `n=0x9E`–`0xA5` (`FF89BE`–`FF89C5`), live and orphan |
| `exit-table-runs.tsv`, `exit-table-new-insns.tsv`, `exit-table-lencheck.txt` | the ledger term in Findings §7 |
| `ledger-delta.tsv` | the coverage delta |
| `readers_raw.tsv` | every MAIN code head that addresses `0xFF8920`–`0xFF8EAF` (2,800 rows) |
| `d1.txt`–`d5.txt` | raw IDA dumps; `req*.txt` are the requests |
| `gen_log.txt` | the generator's counts |

The generator is `ida\jobs\i6_gen_tables.py`. It writes every table above except `readers_raw.tsv` and the IDA
dumps, including `exit-table-new-insns.tsv`, which it recomputes and does not read from scratch. It is plain
read-only Python. Before writing anything it re-reads
**106 cited byte runs** from the `.bin` file and aborts on any mismatch. Last run: `checks ok: 106`.

## Verdict

**Twenty of the 32 screens are dead in ver 1.02.** Each has a working editor and an EEPROM save, but nothing
outside the screen reads the value. The breakdown:

- 17 are leftovers with a working editor.
- `0x80` (F395) is a complete two-field screen whose SUB value page still exists.
- `0x22` and `0xB9` have no editor at all.

**Two screens are hidden but active. They edit live values that no menu row exposes:**

- **`0x3E` → `FF89A7`** (R1 `n=0x87`, EEPROM `0x607`, BACKUP.dat `0x4C7`). It selects a hold time of
  30/50/70/100/150 ticks from table `0x16642`. That time is the long-press threshold for one key code, `0x0B`;
  every other key uses a fixed 100 ticks.
- **`0x49` → `FF89AC`** (R1 `n=0x8C`, EEPROM `0x60C`, BACKUP.dat `0x4CC`). It selects how far a channel-number
  jump moves: 10, 20, 50 or 100, from the step pairs at `0x1EDEE`.

**Two screens are superseded layouts for live bits:**

- `0x17` saves BELL's ringer byte `FF8995`, which the live BELL screen `0x16` edits.
- `0x4C` toggles `FF89BF` bit 7, which screen `0x09` toggles through its key table (`sub_28F46`).

**The other eight have no editor and are inert:**

- seven are save-only stubs: `0x2A`, `0x2D`, `0x2E`, `0x30`, `0x77`, `0x81` and `0x97`;
- one is a service-type screen, `0x32`, whose bit `FF89C3` b1 has no tester.

**What the code shows (Confirmed):**
- 29 of the 32 have an `rts` entry notifier, so the SUB is never told to draw them.
- No handler tests the market byte `FF800F`.

**Why they were left behind (Inferred).** The pattern fits items left over from a shared code base, not
market-gated items.

**Attribution.** These screens attribute **16 of F5's 663** unattributed persisted bytes. Reading every live
screen's exit handler the same way attributes **598 more**. That gives **614 of 663** tied to a screen, 282 of
them to a SUB label; **49 remain unattributed**.

**Two corrections to H13:**
- Screens `0xED` and `0xEE` are opened. They are pushed at `0x103DE` by power-on handlers.
- Eleven of the "no save" ids do write EEPROM, through block saves.

**Coverage.** H9's strict descent never followed the BE16 exit table `0x19A9E`. Following it proves **+1,544 B** of
MAIN code: proven goes from 365,570 to **367,114**. Named code rises by **+10 B**, to **497,149**.

## Method

- **Database.** `I6_MAIN`, created with `run_job.py --copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`. It was then
  reopened 6 times with `--reopen`. Every run exited with `idat_exit 0` and wrote no error file. No other database was
  opened, `run_ida.py` was not run, and no SUB database was needed.
- **Job scripts.** All are in `ida\jobs\`:
  - `i6_dump.py` is a copy of `h13_dump.py` with new paths, and produced `d1`–`d5`.
  - `i6_readers.py` lists every code head in `0..0x078105` and `0x07B754..0x7FFFF` that has an `o_mem`, `o_imm` or
    `o_displ` operand in `0xFF8920`–`0xFF8EAF`. It scanned 124,021 heads.
  - `i6_lencheck.py` is an IDA length cross-check.
  - `i6_gen_tables.py` is the offline generator.
- **Slot sources.** Screen slots were read from the image through H13's four tables:
  - notifier = BE32 `0x782C+4·id`;
  - dial = BE32 `0x12268+4·(id−0x0E)`;
  - exit = `0x148A0` + BE16 `0x19A9E+2·(id−0x0E)`;
  - key table = `0x125D4` + BE16 `0x1208C+2·(id−1)`, 17 BE32 slots.
- **Exit handlers.** These were parsed with H9's binutils oracle (`main-descent\offline\common.py`, imported
  read-only with `dont_write_bytecode`). The parser follows conditional branches but not calls, and records each
  `sub_3CCBC`/`3CCD0`/`3CCEC`/`3CD00`/`3CD1C`/`3CD30` call with its `r1`, or with its `er1` and `r6`.
- **Reader scope.** Readers of each target byte were taken from three sources:
  - `readers_raw.tsv` (IDA code heads);
  - a raw-byte scan of `0..0x80000` for the abs16 forms `6a xx` and `6b xx` followed by `89 yy` / `8a ab` / `8d 8e`,
    and for the abs32 address;
  - BE32 and `jsr`/`jmp` abs24 scans for the address of every reader fragment.

  Reachability of a reader is H9's `work\reached_insns.tsv` plus this lane's §7 descent.
- **Not covered.** Readers that reach a byte through a base register plus displacement were not covered. H13
  showed that the only `FF8920`-based loads are the bulk and EEPROM writers. That result is reused here and was not
  re-derived. Each "dead" verdict below therefore means **Not found** within this scope.
- **Not decoded.** The code-entry constants in the routine at `0x163CC`–`0x16556` are not reproduced; they are
  redacted in `d3.txt`. Key identities are not decoded, and `49-key-sequence-hidden.md` was not redone.
- **Byte checks.** All key cites below were byte-checked in Python against the `.bin` by the generator.

## Findings

### 1. How an item screen edits and saves (Confirmed)

- **Generic key table.** The generic item key table `0x12948` sends the dial slot (slot 13) to `0x15E1E`, which
  calls the screen's `0x12268` entry.
- **Bit items.** Bit items call a helper at `0x17760 + 8·k` with `r4l` = bit. The helper does
  `bnot r4l,@FF89BE+k` (`6a 18 89 be 61 c0` …), then `bset #6,@FFAA30` at `0x1779E`.
  - k = 0..7 covers `FF89BE`–`FF89C5` (R1 `n=0x9E`–`0xA5`).
  - The `FF89C4` helper at `0x17790` is data in the MAIN_H8SX seed. Its only caller is orphan `0x67`.
- **Value items.** Value items pass a `{u8 lo, u8 hi, u32 ptr}` record to one of two routines:
  - `loc_3F628` wraps;
  - `sub_3F600` saturates.
- **Exit handler.** The exit handler runs from `sub_19158` only when the dirty flag `FFAA30` b6 is set
  (`0x19158` `6a 10 aa 30 73 60`, then `beq`). The dispatch is at `0x1919A`:
  `78 60 6b 26 00 01 9a 9e` · `7a 16 00 01 48 a0` · `5d 60`.

### 2. The 32 screens

Region R1 is `RAM 0xFF8920+n` → `EEPROM 0x580+n` → `BACKUP.dat 0x440+n`. R2 adds `0xC000` and R3 adds `0xD000`, with
BACKUP.dat = EEPROM − 0x140. Full columns are in `orphans.tsv`.

Defaults come from `sub_DEFA` stores. For example, `fc a8 6a 8c 89 c3` at `0x0E670` sets the default of
`FF89C3` to `0xA8`.

**Dead leftovers with a working editor (17).** No reader of the bit or byte was found outside the screen's own
handlers.

| id | Byte (R1 n) | Field | Editor | Evidence |
| --- | --- | --- | --- | --- |
| `0x0E` | `FF89C3` (`0xA3`) | b5 | `15ED0` `fc 05 5e 01 77 88` | testers of `FF89C3` use b0/b2/b3; b1 is only cleared. Default `0xA8` sets b5 = 1 |
| `0x10` | `FF8994` (`0x74`) | 0..2 | rec `15F10` = `00 02 00 ff 89 94` | only other reference is default 1 at `0x0E5D8` |
| `0x11` | `FF89C1` (`0xA1`) | b4 | `15F16` `fc 04 5e 01 77 78` | testers use b0/b2/b3/b6/b7. Default `0x11` sets b4 = 1 |
| `0x29` | `FF89BF` (`0x9F`) | b1 | `16208` | testers use b3/b4/b6/b7. Default `0x42` sets b1 = 1 |
| `0x33` | `FF89C3` | b6 | `165DA` | no tester |
| `0x34` | `FF89C3` | b4 | `165F0` (then `jsr 0x1E79C`) | no tester |
| `0x36` | `FF89C0` (`0xA0`) | b1 | `16608` | see below |
| `0x41` | `FF89A9` (`0x89`) | `0x13..0x21` | rec `166BA` | H13: dead (F316 "LEVEL") |
| `0x5C` | `FF89B6` (`0x96`) | 0..3 | rec `16B5A` | H13: dead (F31A) |
| `0x61` | `FF89C0` | b5 | `16C46` | no tester |
| `0x65` | `FF89B7` (`0x97`) | 0..2 | rec `16E5A` = `00 02 00 ff 89 b7` | no reader and no default. The only reference is the record itself |
| `0x67` | `FF89C4` (`0xA4`) | b0 | `16E7E` → `0x17790` | the flags byte's b0 has no tester, which settles doc 32 Open 4 for bit 0. Default 5 sets b0 = 1 |
| `0x6E` | `FF89C3` | b7 | `17104` | apply hook `nullsub_63` (`0x446BC` = `54 70`). Default sets b7 = 1 |
| `0x78` | `FF89BF` | b0 | `173D4` | no tester |
| `0x7B` | `FF89C2` (`0xA2`) | b7 | `173E4` | testers use b0/b1/b4/b6 |
| `0xD4` | `FF89B4` (`0x94`) | b4–6 (0..7) | `1762E`: rec `1766A`, then `(FF89B4&7)|(v<<4)` | the only readers are `0x17652`–`0x176A6`, inside the two dials. The apply hook is `nullsub_63` |
| `0xD5` | `FF89B4` | b0–2 (0..7) | `1767E`: rec `176A0`, then `(FF89B4&0x70)|v` | as `0xD4` |

**Screen `0x36`.** The bit `FF89C0` b1 has two testers, `0x1F4E2` and `0x1F510`. Both sit in fragments
`0x1F4DA`/`0x1F508`, each preceded by `rts` (`0x1F4D8` = `54 70 6a 10 a9 ee 73 70`). No IDA xref, BE32 pointer or
abs24 `jsr`/`jmp` reaches either fragment, and H9 does not reach them. **Dead** (Not found within scope), even though
`sub_DEFA` sets the bit at `0x0E82C` (`6a 18 89 c0 70 10`).

**Screen `0x80` (F395): a complete screen with no consumer (Confirmed path; meaning Inferred).**
- **Key table.** Its own key table `0x133E8` sends slot 13 to `0x16582`. That calls `sub_15260` with table
  `0x1658C` = `0001a0ac 00016598 000165c0`.
- **Field 1.** `0x16598` edits band record `+0x36` b0–1 through `AA56`, with rec `{0,2,AA56}`.
- **Field 2.** `0x165C0` edits `FF89C7` (R1 `n=0xA7`, EEPROM `0x627`, BACKUP.dat `0x4E7`) with rec `0x165D4` =
  `00 02 00 ff 89 c7`.
- **Readers.** The only reader of `FF89C7` is the F395 notifier `0x52CC` (`6a 0b 89 c7`). Doc 35 found no other
  reader of `+0x36` b0–1.
- **SUB side.** The SUB latches F395 into the shared item buffer `0x8C4D` (`FFEFF956`) and draws "MODE
  OFF/BUSY/SIGNALING · SELECT PATTERN1..3" (doc 38). It has no label row for F395 and falls back to "APO".
- **Twin.** `0x81` is a save-only twin of it: dial `0x165D2` = `54 70`, and it saves the same `n=0xA7`.

**Hidden but active (2).**

- **`0x3E` → `FF89A7`, wrap step 0..4** (`16618` `7a 06 00 01 66 24`, rec `00 04 00 ff 89 a7`). Default 1,
  `fc 01 6a 8c 89 a7` at `0x0E5EE`.
  - **Use 1.** `0x1662A` `6a 0c 89 a7` indexes the table `0x16642` = `1e 32 46 64 96` and stores the result to
    `FF953F`. That is a key-hold countdown, decremented by the tick loop `sub_3576` (block `FF9536`, 0x58 bytes).
  - **Who uses it.** The key handler `sub_FE88` sends only key code `0x0B` there (`0x0FEE4` `a9 0b 47 46`, then
    `0x0FF2E` `5e 01 66 2a`). Other keys load a fixed `0x64` (`0x0FF04` `fc 64 6a 8c 95 3f`). When the countdown
    ends, `0x0FF74` sets the long-press flag `A9EE` b7.
  - **Use 2.** The same index is looked up in the second table `0x16660` (identical values) and stored to
    `FF958E`, the tenth-rate countdown block at `0x35DA`. That path is `0x16648`, called from `0x1099E`,
    `0x1FAAE` and `0x200C2`.
  - **Result.** The value is live, and the setting can only be changed by restoring a BACKUP.dat image. If the
    tick is 10 ms (Inferred; H15 left the tick rate open), the choices are 0.3, 0.5, 0.7, 1.0 and 1.5 s.
- **`0x49` → `FF89AC`, wrap step 0..3** (rec `16722` = `00 03 00 ff 89 ac`).
  - **The lookup.** `sub_1EDFE` (`6a 09 89 ac 10 49 …`) multiplies the value by 4 and indexes `0x1EDEE` =
    `{9,0x442} {0x13,0x438} {0x31,0x41A} {0x63,0x3E8}`.
  - **The jump.** It moves the channel number in `AA56` by `e2+1` = 10/20/50/100, taken from the band record word
    `+8`.
  - **Reachability.** `sub_1ED5E` is reached through H3's tier-A array `0x1F8E2`
    (`0001ed5e 0001db54 0001ed5e …`), and H9 reaches it.
  - **Default.** No `sub_DEFA` default store was found. The reset path `0x103F2` zero-fills `FF8970`–`FF8A1B`,
    which gives step 10.
  - **Meaning.** Live; a memory-channel jump size (Inferred).

**Superseded layouts (2).**

- **`0x17` → `FF8995`** (R1 `n=0x75`, BELL ringer).
  - Its dial `0x16032` is `54 70`. The next six bytes are BELL's record `01 15 00 ff 89 95`, which the live BELL
    field-2 editor `0x16020` uses (`7a 06 00 01 60 34 5e 03 f6 28`).
  - The live BELL screen `0x16` saves the same `n=0x75`. Its notifier `0x4EB4` sends the byte as F340 `+0x23`,
    with `0x15` meaning CONTI.
- **`0x4C` → `FF89BF` b7.**
  - Its dial `0x16738` does `bnot #7,@FF89BF` when band mode `+5` is 5, or is 2 and passes a check.
  - The same bit is toggled and saved by `sub_28F46` (`6a 18 89 bf 71 70 5e 01 93 a2`). That routine is reached
    from slot 5 of screen `0x09`'s key table (`0x12808` = `00028f46`), and screen `0x09` is opened at `0x21A1A`.
  - The readers are `0x07300` (`sub_72D0`), `0x0D786` and `0x0DACC`. With the bit set, they skip the 8-word name
    at record `+0x24` / `FFAC7C` and format the frequency instead.
  - Meaning: a name/frequency display toggle (Inferred). The bit is live.

**Save-only stubs (7).** These ids have no editor. Their dial is `rts` or `0x3FFA0`, or none for `0x97`, so the
dirty flag is never set and the exit save cannot fire:

| id | Saves | Note |
| --- | --- | --- |
| `0x2A`, `0x2D`, `0x77` | `n=0x9E` | its live bits b1/b3/b5/b7 belong to SQL EXPANSION, RPT ARS, SCAN LAMP and VFO MODE |
| `0x30` | `n=0x9F` | |
| `0x2E` | `n=0xA0` | |
| `0x81` | `n=0xA7` | twin of `0x80` |
| `0x97` | R2 `n=0x0B` (`FF8AAB`) | live APRS bits; screens `0x90`/`0x95`/`0x9C`/`0xA0` save the same byte |

**No editor and a dead byte (2).**
- **`0x22`** saves `FF89A0` (`n=0x80`). Its only other reference is the default 6 at `0x0E5AE`.
- **`0xB9`** saves R3 `n=0x6E` (`FF8D8E`, EEPROM `0xD06E`, BACKUP.dat `0xCF2E`). Its only tester is `0x1B99C`,
  inside fragment `0x1B99A`, which follows `rts` at `0x1B998` (`54 70 68 1b 6a 0c 8d 8e`) and has no reference.
  That fragment filters text-entry characters (Inferred).

**Service-type (1).** `0x32` has its own key table `0x12E10`:
- slot 0 enters the shared code-entry routine at `0x163EA`, the routine that screen `0x0C`'s key table also uses
  (doc 32/H11; not re-decoded);
- slot 13 `0x16574` toggles `FF89C3` b1 through `fc 01 5e 01 77 88`.

That bit is only ever cleared (`0x02DDA` `bclr #1`, in `sub_2DCE`). Dead.

### 3. Why they are unopened (Confirmed facts; Inferred reading)

- **No path in.** No screen-byte writer produces any of the 32. This is H13's scope, re-checked here: an
  immediate scan of every H9-reached `mov.b #id,rN` near a push found only `0xED` and `0xEE` (§6) and ASCII bytes.
- **No draw path.** 29 have an `rts` notifier, so MAIN sends no F3xx frame and the SUB never draws them. Only
  `0x41`, `0x5C` and `0x80` would draw.
- **Not market-gated.** No dumped handler reads `FF800F` (Not found in `d1`–`d5`).
- **Reading (Inferred).** Leftover items from a shared code base. The values persist and keep their defaults, and
  several dead bits default to 1 (`0x0E`, `0x11`, `0x29`, `0x67`, `0x6E`). Two are live parameters frozen at their
  default. Two were replaced by other UI paths. None is a market variant within this firmware.
- **Labels.** The labels the code would have shown are Unknown for 29 of the 32. The SUB setup-label table has no
  unclaimed label that fits them (`menu_slots.tsv`).

### 4. Attribution count (`settings-bytes-ext.tsv`, `gen_log.txt`)

| Source | Bytes linked to a screen | Of F5's 663 |
| --- | --- | --- |
| the 32 orphan screens | 19 (incl. `0x89`, `0x96`, `0xA4` already attributed) | **16**: R1 `0x74 0x75 0x80 0x87 0x8C 0x94 0x97 0x9E 0x9F 0xA0 0xA1 0xA2 0xA3 0xA7`, R2 `0x0B`, R3 `0x6E` |
| block saves in 11 other unopened screens | 61 | 60 |
| exit handlers of opened screens (by-product) | 587 | 560 (282 with a G3 SUB label) |
| union | — | **614**; **49 still unattributed** |

- **Labels.** A label means "saved by the exit of the screen with that label" (Confirmed path). For block saves,
  such as `0x9D` DIGI PATH (115 B) or `0x94` (130 B), what each byte inside the block means is Unknown.
- **Bit owners.** `bitfield-map.tsv` names the live owners of the flag bytes, from the dial helpers:
  - `FF89BE`: b1 SQL EXPANSION, b3 RPT ARS, b5 SCAN LAMP, b7 VFO MODE;
  - `FF89BF`: b4 BCLO;
  - `FF89C1`: b0 MEMORY WRITE, b2 MEMORY PROTECT;
  - `FF89C2`: b1 LANGUAGE, b4 WX ALERT;
  - `FF89C3`: b0 PRIORITY REVERT, b3 HOME VFO;
  - `FF89C5`: b0 TARGET LOCATION.

### 5. The other 39 unopened ids (`other-unopened.tsv`)

| Class | ids | What the code shows |
| --- | --- | --- |
| empty slot | `0x08 0x2F 0x31 0x3A–0x3D 0x46–0x48 0x74 0x75 0x7E 0x8A 0xB6 0xBA 0xD8–0xDA` (19) | `rts` notifier, a consume-only dial, `rts` exit; the key table only navigates or pops |
| no save, flag only | `0x19` | exit `0x19444` only clears `FFAA30` b6 |
| **EEPROM-writing exits** (H13 counted them as "no save") | `0x21 0x23 0x24 0x38 0x50 0x53 0x54 0x79 0xAA 0xAF 0xB0` (11) | see below |
| partial | `0x25 0x42 0x69 0x83 0x86 0xAD` | details below |
| **opened (correction)** | `0xED`, `0xEE` | power-on handler screens, §6 |

**The 11 EEPROM-writing exits:**
- `0x21`: a 16-character text editor on `FF8926`;
- `0x38`: the edit variant of DP-ID LIST (F364, R3 `FF8DD7`×5);
- `0x53`/`0x54`: PAGER clones (key table `0x13074` and exit `0x19584`, both shared with PAGER `0x52`);
- `0x50`: shares `FF898A` with TIMER;
- `0x79`: a memory editor that writes word `FF898C`;
- `0xAA`/`0xAF`/`0xB0`: R2/R3 block editors.

**The 6 partial ids:**
- `0x42` sends F387 but has no editor;
- `0x69` edits the live band byte `FF8EAD` but has no save;
- `0x83` toggles `FF8ABE` b7;
- `0x86` is the BACKUP sub-screen dispatcher on `FFADA1`;
- `0x25` and `0xAD` have no notifier or save.

### 6. Corrections to earlier docs

- **H13 (doc 49) §3.4/§3.5.** `0xED` and `0xEE` are opened, not unopened. Power-on handler `0x103E6` does
  `mov.b #0xED,r3l; bra 0x103DE` (`0x103EE` `fb ed 40 ec`), and `0x103C0` does `mov.b #0xEE,r3l; bra 0x103DE`
  (`0x103D4` `fb ee 40 06`). `0x103DE` is `jsr 0x3FF10` (push); H13 credited it only to `0xEC`. All three sites are
  H9-reached. So the unopened set is **69**, not 71.
  - `0xED`'s keys: 16 slots go to `0x0DC40` (`mov.l #0xFF7F00,sp`, then 0x20 to `FF8000`; Inferred restart), and
    slot 7 goes to `0x103F2`, a settings reset.
  - `0xEE`'s notifier `0x5E9E2` sends F008.
- **H13 §3.5, "32 with a save handler".** That counts only the `mov.w #n,r1; jmp writer` form. Eleven more
  unopened ids write EEPROM through block saves (§5). So **43** unopened ids have EEPROM-writing exits.
- **H13/doc 32, `FF89A7` and `FF89AC`.** These had no known meaning. They are live parameters (§2).
- **Doc 32 Open 4, `FF89C4` b0.** Its only writer is orphan `0x67`, and it has no tester. Dead.

### 7. Coverage: the exit/save table was never descended (ledger term)

H9's strict descent treats tables as roots but did not model the BE16-relative exit table: 108 of its 127
distinct entries were unreached.

**Method.** Gated on the H9-reached dispatch `0x1919A`–`0x191A8`, the generator descends from all 127 entries
with H9's oracle and flow rules. It follows conditional branches and calls to a fixed point.

**Result:**
- 383 new instructions, **1,544 new bytes**, in 20 runs (`exit-table-runs.tsv`);
- 0 bytes overlap H9's reach mask (asserted);
- 0 bytes fall in the closed window (asserted);
- IDA `h8sxa` decodes all 383 instructions at the same length (`exit-table-lencheck.txt`: 383/383).

**Byte-mask argument against `main-descent\ledger-delta.tsv`.** H9's proven figure (365,570) is asserted to equal
the byte union of its reach. This term is the byte set `NEWM` with `NEWM ∩ H9reach = ∅`, so it cannot double-count
H9's +8,057 "new-proven" or any other H9 addend. How the 1,544 bytes split:

| Bytes | H9 status | Note |
| --- | --- | --- |
| 1,472 | H9's demoted RC rows (re-proven) | 1,423 code-structural, 35 "text", 6 "fill", 8 "junk"; the text and fill bytes are really code, e.g. `0x19447` `30 73 60 47` is inside `btst #6,@FFAA30` |
| 40 | W2-8 "parameter table" | not in any H9 proven addend |
| 30 | W2-8 "code" | not in any H9 proven addend |
| 2 | W2-8 "other" | `0x19762` `54 70` |

**Named mask.** H9's own masks put 1,542 of the bytes in H1's named union. The bytes outside H9's named set are the
8 "junk → leaves" bytes plus the 2 "other" bytes, so named rises by **+10**.

| Term | Delta | Value |
| --- | --- | --- |
| MAIN proven code | **+1,544** | 365,570 → **367,114** (72.60 % of 505,684; 94.50 % of 388,490) |
| MAIN named/typed | **+10** | 497,139 → **497,149** |
| Headline numerator (MAIN named + SUB 464,166) | +10 | 961,305 → **961,315** / 1,029,972 = 93.33 % |

Another I-wave lane could also have descended `0x19A9E`. If so, the orchestrator should union the byte sets in
`exit-table-new-insns.tsv`, not add the two counts.

## USB relevance

None of the three mission answers changes.
- **The settings themselves.** No orphan screen, settings byte or bit touches the USB module (`0xFFEE00`), SCI-C,
  the DSP driver or the closed window. The two live hidden values set a key-hold time and a channel-jump size.
- **The new code.** The 1,544 B of newly proven code are EEPROM save stubs plus `sub_16A44`. None of it addresses
  the USB, the DSP or the closed window. The descent never entered the window, which is asserted in the generator.
- **The resets.** The settings-reset path `0x103F2` (screen `0xED`) writes only RAM regions R1/R2/R3 and EEPROM. It
  does not reach flash.

## Open

1. **Name the two live hidden parameters on the radio side.** Decide whether key code `0x0B` is a physical key, a
   long-press class, or something else. This needs the key-identity work that other lanes deliberately left out of
   scope. Also confirm the tick (H15 Open 3) to turn 30–150 ticks into seconds.
2. **Exit-table descent.** Fold this lane's +1,544 B into the next MAIN seed: create the 53 heads that are not
   IDA code in MAIN_H8SX. Then re-run H9's descent with `0x19A9E` as a root, so the term becomes part of the
   reproducible baseline.
3. **Base-plus-displacement readers of R2/R3 block bytes.** These are the bytes of `0x21`, `0x23`, `0x24`, `0x50`,
   `0x79`, `0xAA`, `0xAF` and `0xB0` (§5). They are needed to call those 60 bytes live or dead. This lane
   classified only the 32.
4. **The 49 still-unattributed dedicated bytes.** Find their writers' callers, which are not exit handlers.
5. **The labels of the 29 `rts`-notifier orphans.** These are Unknown from this package. A sibling-model firmware
   with the same table layout would settle them, if one is ever in scope.
