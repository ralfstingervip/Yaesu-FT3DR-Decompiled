# 59 — Behaviour behind the FF800F market (destination) gates (lane I7)

Owner-side static analysis of the owner's FT3DR/FT3DE ver 1.02 **MAIN** image
(`decrypted\FT3D_MAIN_ver102_EXP.bin`, H8SX, big-endian, base 0, file offset =
mapped address; this is the **EXP** build). Nothing was written to any device and
no image was modified. The closed CDC-ACM / DSP-download window `0x078106`–`0x07B753`
was not analysed. Model: **Opus 5.5 (`claude-opus-5-5`)**.

Image sha256 begins `8e3ecd05…` (unchanged). Every cite below was byte-verified in
Python directly from `decrypted\FT3D_MAIN_ver102_EXP.bin`, cross-checked against the
G1 binutils H8SX decode (`ida\out\h8s-decode\work\bu_all.tsv`), H9's reached set
(`ida\out\main-descent\work\reached_insns.tsv`), and a fresh IDA listing from my own
DB `I7_MAIN`.

Machine tables (`ida\out\market-gates\`):
- `readers.tsv` — every read/write of `FF800F`/`FF8010`/`FF8011`, the 10 predicate
  wrappers, and every static caller (123 rows marked `h9_reached=Y`).
- `gates.tsv` — 69 gate sites: predicate, behaviour on each side, feature area.
- `market-tables.tsv` — every 8-entry per-destination table, byte-verified.
- `segment-ranges.tsv` — the 19 band/coverage segment range tables the gates index.
- `bandplan-records.tsv` — the 0xF23A band-plan records and the F1FA/F21A selectors.
- `ledger-delta.tsv` — zero delta (see §6).

This document records **what** each gate does. Following the lane boundary (and
doc 50 §2's convention), it does **not** decode or describe how a destination is set
or changed: writers of `FF800F` are listed by address and labelled "boundary — not
traced", and no gate constant, held-key mapping, EEPROM/BACKUP offset or clone edit
that would select a market is given.

## Verdict

**Confirmed.** The destination byte `FF800F` (0..7, with companions `FF8010`
sub-variant and `FF8011` board strap) is read at **26 direct sites** plus through
**five predicate wrappers** (`sub_3ECB8` ==0, `sub_3ECD4` ==1, `sub_3ECDE` 2..4,
`sub_3ECC4` {0,6} — dead, and `sub_3F386`/`loc_3F554`/`loc_3F47E` which index
per-market tables), giving **69 gate sites** in total. The gates set, in order of
weight: **RX/TX band coverage** (6 m and band-8 edges, per-band BCD edge tables
F022/F042/F062/F082, the F0A2 ham windows and the F672/F92CE-F92D6 coverage
windows, US-cellular lockout 824–849/869–894 MHz, PLL band maps); **power-on
defaults** (TIME ZONE, LANGUAGE, SAVE RX, RPT ARS, TOT, the WIRES-X preset
frequencies); **fixed RX-mode and fixed-step segment tables** (F400/F391);
**menu/band-cycle exceptions**; **the WIRES-X "news-station" region feature**; and
**the cable-clone / BACKUP.dat conversion** (`sub_7516A`/`sub_75554`, ID check
`sub_7357A`). `sub_3ECB8` returns Z iff `FF800F==0`, and the factory-default
routine `sub_DEFA` branches on it to set English + UTC for every non-zero
destination, so **destination 0 is the Japanese-default market**. Four gates are
no-ops (conditional branch to the next instruction), and one reader (`0x035776`)
sits in code with no static reference. The destination-code table at `0x68A8`
(` F1 `/` A1 `/` B1 `/` C1 `/` D1 `/` H1 `/`*** `/`HAM `, three variant rows) is a
display/identification string copied into the clone/`V`-record header by `sub_6864`;
it is indexed by `FF800F` (+8/+16 by `FF8010`/`FF8011`) and is not itself a gate.
This confirms and extends H12's doc 50 §2 — I add the full per-table decode, the
clone-conversion switch behaviour, and raise the gate count from ~55 to 69.

## Method

- **Private DB only.** `I7_MAIN`, seeded `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`
  (`h8sxa`, 5,022 functions) via `run_job.py`, then iterated with `--reopen`. Script
  `ida\jobs\i7_dump.py` (read-only: `imm`/`xref`/`func`/`fn`/`ctx`, `auto_wait`,
  try/except traceback, UTF-8, `qexit(0)`; it creates and deletes no items). Both runs
  exited `idat_exit 0`; no `i7_dump_error.txt`. `run_ida.py` was not run; no shared or
  other-lane DB was opened. IDA listings: `ida\out\market-gates\dump.txt`,
  `gate-ida.txt`.
- **Offline cross-check.** `i7_tables.py` / `i7_gates.py` (scratch, lane-private
  `i7_` names) read the image and `bu_all.tsv`/`reached_insns.tsv` to emit the TSVs
  and byte-verify every cite. A reader is credited only if it is in H9's reached set
  **and** not shadowed by a covering reached instruction (this drops the per-address
  decoder's mid-instruction false hits).
- **Scope covered.** All 505,684 decode heads of `bu_all.tsv` in `0..0x7B754` minus
  the closed window, for the abs16 `@FF800F/10/11:16` form, the long `mov.l @FF800E`
  form, and the `#0xFF800E` block-pointer form; caller forms `jsr`/`jmp` abs24, `bsr`
  disp8/16, and BE32 pointer. Every per-destination table and every segment range
  table the gates index was decoded from file bytes.
- **Not done / out of scope.** The closed window (none of the 69 sites lies inside
  it). How a destination is chosen or changed (boundary). The SUB-side rendering of
  screen 0xE8. The 11 `sub_3ECDE` callers' downstream UI past the table select.

## Findings

### 1. The destination source and the three bytes (Confirmed)

`FF800F` (destination 0..7), `FF8010` (sub-variant 0/1) and `FF8011` (board strap,
port `0xFFFF4E` bit 2, re-sampled every boot) are the market key, exactly as doc 50
reported. The predicate helpers (`readers.tsv`, byte-verified at `0x3ECB8`):

```
03ECB8  6a 0c 80 0f  mov.b @FF800F,r4l   ; sub_3ECB8: Z iff FF800F==0
03ECBC  f4 01        mov.b #1,r4h
03ECBE  47 02        beq .+2
03ECC0  ac 00        cmp.b #0,r4l
03ECC2  54 70        rts
03ECD4  … cmp.b #1   ; sub_3ECD4: Z iff FF800F==1
03ECDE  … cmp 2 / cmp 5 ; sub_3ECDE: r4l=0 iff 2<=FF800F<=4
03ECC4  … {0,6}      ; sub_3ECC4: no caller (dead)
03F386  6a 0c 80 0f f4 01 10 4c 6a 04 80 10 47 08 08 4c 6a 04 80 11 08 4c
        ; sub_3F386: er4 = 4*FF800F + (FF8010 ? FF8010+FF8011 : 0)  (variant index 0..31)
```

`sub_3ECB8` has **22** static callers, `sub_3ECD4` **6**, `sub_3ECDE` **11**,
`sub_3F386` **9**; `sub_3ECC4` has none. All callers are in H9's reached set.

**Writers of `FF800F` (boundary — not traced):** `0x00DE0A`, `0x0236E2`, `0x0740F6`,
plus the `FF800E` block-load helper armed by `sub_39554`/`sub_39534` and the
clone-header builder at `0x073B82`. Listed by address only; this lane does not
describe them.

### 2. Gate inventory and feature areas (Confirmed — `gates.tsv`, 69 rows)

By feature area (see the TSV for per-site predicate and both-side behaviour):

| Feature area | sites | representative behaviour |
| --- | --- | --- |
| RX/TX band coverage | ~22 | 6 m edge 51.0↔50.0 MHz (`0x0E9E0`), band-8 start 380.0↔222.0 MHz (`0x0EA14`), per-band BCD edges F022/F042/F062/F082 (`sub_EA92`), ham windows F0A2 and coverage windows F672/F0AE→FF92CE/FF92D6 (`sub_3F4A2`), US-cellular lockout 824–849/869–894 MHz (`0x22172`/`0x221C0`, `0x20C48`) |
| PLL band maps / offset tables | 8 | region-dependent PLL maps 0x30B00/0x30BA4, 0x32442/0x324E6; PLL constants FF811A/FF811E (`0x2FB00`/`0x315A8`) |
| Power-on defaults | 5 | LANGUAGE=English + TIME ZONE UTC + SAVE RX + RPT ARS + TOT for dest≠0 (`sub_DEFA` `0x0E80E`..`0x0E844`); RPT-ARS mask F6C2 (`0x0E7F8`); band-record +0x11/+0x1B |
| Fixed RX-mode / fixed-step segments | 5 | F400 segment tables 20BB4/20BE0/20BFC (`sub_1E646`); F391 step tables 40D2C/40F92/4116C/41346/41480 (`sub_1E6E2`) |
| WIRES-X / RPT defaults | 3 | preset freqs F958/F980 (`0x0E440`); RPT offsets F682/F6A2; news-station region flag FFB963.0/FFB421 (`0x63C7A`) |
| Menu / band-cycle exceptions | 8 | value-skip in cycle tables (`0x16FAC`, `0x1D24C`, `0x14F96`); band availability via F1FA (`sub_3F386`) |
| Clone / BACKUP conversion | 5 | per-dest record conversion `sub_7516A`/`sub_75554`; band-availability on restore (`0x74ABE`/`0x75096`); ID check `sub_7357A` |
| Display / identification | 1 | `0x68A8` code via `sub_6864` into V-record FEE019 |
| No-op (branch to next insn) | 4 | `0x0EAA8`, `0x1E524`, `0x2CE8A`, `0x3F56E` |
| Unreached | 1 | `0x035776` (byte table 0x357C4) — containing code has no static reference |
| Feature paths (dest 6 / FF8010) | 3 | `0x1D40E`, `0x1D618`, `0x2136A`: `FF800F==6 OR FF8010!=0` enables a feature branch |

### 3. Per-market tables (Confirmed — `market-tables.tsv`, `segment-ranges.tsv`)

All frequencies are 4-byte packed BCD in 10 Hz units. Key tables, per destination
0..7 (byte-verified):

- **F022 (FM-bcast top edge):** `76 76 88 88 88 76 76 76` MHz. **F062/F082** (band
  upper edges): `175.75/174…175.75` and `481.75/470…481.75`.
- **F958 (WIRES-X VHF preset):** `145.78 146.55 145.375×4 145.78 145.375`;
  **F980 (UHF):** `438.98 446.5 433.45×4 438.98 433.45`.
- **F682/F6A2 (band-6/9 RPT offset):** `0 .6 .6 .6 .6 .6 0 0` MHz / `5 5 7.6 1.6 1.6 5 0 0` MHz.
- **F6C2 = 0x3F** (RPT-ARS default bit mask: dest 0..5 get ARS on).
- **F0A2 (ham windows, 0x24 per dest, four lo/hi pairs):** e.g. dest 1 =
  144–148/430–450, dest 4 = 144–146/432–438, dest 6 (wideband) =
  137–174/120–221.995/420–470/300–579.995.
- **Band-plan records 0xF23A** (0x60 each, 12 UI-band segments): record 0 =
  144–148 / 6 m 50–54 / 222–224.995 / 430–450; record 3 = the wideband RX plan
  0.522–999.995. Selected by the current band via `F21A[col]` with per-column merge
  flag `F1FA[col]` — i.e. the destination enters the band plan through `sub_E9CC`'s
  segment starts and the F022/F062/F082 edges, not by indexing 0xF23A directly.
- **US-cellular lockout** `0x20C48` = 824–848.995 / 869–893.995 / 940.1–965.095 MHz
  (the US scanner-receiver block); the wider variant `0x20C6A` adds 253–276, 380–383,
  412–416, 810–846, 860–901, 915–961 MHz. Both reached via `sub_32650`/`sub_1E110`.
- **Coverage lists F5E2/F5F6/F622** (via pointer array F5D2) give the three overall
  RX-coverage variants (generic / US-cellular-blocked / wide-blocked).

### 4. The clone / BACKUP conversion cross-check (Confirmed)

`sub_7357A` returns all three bytes; the cable-clone receive path (`sub_737C8`,
doc 24's 0x73540–0x74600 engine) compares them against the 10-byte header's
region dword and `sub_734BE`'s build constant 2 (`0x737E2`/`0x737F4`), and the
`BACKUP.dat` ID check uses the same. On a card/clone **load**, `sub_7516A` and
`sub_75554` each `switch` on `FF800F` (1/2/3/4/5/7) and convert the restored
operating records to the loaded market's band availability — `0x74ABE`/`0x75096`
re-test each record against `F1FA[sub_3F386 idx]`, dropping bands the new market
does not have (matching doc 24's one-shot streamed EEPROM image and doc 32's
`BACKUP.dat` layout; behaviour only). `sub_6864` then writes the `0x68A8` 3-char
code into the clone/`V`-record identity at `FEE019` for display.

### 5. Relationship of the `0x68A8` table to `FF800F` (Confirmed, display only)

`sub_6864` (`0x6864`): `r5l = 0x10` if `FF8010==0` and dest not 6/7; `+= 0x08` if
`FF8011==0`; `index = (dest + r5l) << 2`; `&0xFF`; `+ 0x68A8`. So the three variant
rows (` F1 … HAM `, ` F2 … HAM `, ` F3 … HAM `) are chosen by the companion bytes,
and the per-dest letter (`F/A/B/C/D/H`, `***`, `HAM`) by `FF800F`. The result is a
3-character identity copied into `FEE019` for the clone header and version/ID
display — it is a *name for* the market, not a selector *of* it.

## USB relevance

None of the 69 gate sites touches a USB endpoint, the on-chip USB module
(`0xFFEE00`), a sample path, or the DSP link; none lies inside the closed CDC-ACM /
DSP-download window. This is EEPROM-resident market data driving band-plan, default,
menu and clone-conversion logic on MAIN. It does not change the three mission
answers. The one point of USB/host relevance is indirect: the cable-clone and
`BACKUP.dat` paths (doc 24, host-reachable over the DATA jack / SD) carry and
re-validate these three bytes, so a host-side clone tool that moves band coverage
must satisfy `sub_7357A`'s ID check — documented here as behaviour only, with the
market-selection mechanism left to the boundary.

## Open

1. SUB-side screen 0xE8 rendering of the `0x68A8` names (the editor's display half);
   this lane stayed MAIN-side.
2. The feature-path triplet `0x1D40E`/`0x1D618`/`0x2136A` (`FF800F==6 OR FF8010!=0`)
   — name the enabled feature (looks like a wideband/dual-receive capability).
3. `0x035776` → byte table `0x357C4`: confirm whether its containing block
   (`0x035754`–`0x0357E8`) is truly dead or reached only through an indirect table
   not in H9's root set.
4. The downstream UI of the 11 `sub_3ECDE` (dest 2..4) callers past the table
   selection — the region-specific PLL/offset consequences were traced to the table,
   not to the final displayed behaviour.
