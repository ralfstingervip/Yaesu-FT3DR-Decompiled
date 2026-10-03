# 72 — MAIN typed-but-unreached functions and the 22,360 B of unproven DB code (Lane J4)

> Lane J4, model `claude-opus-4-8` (Claude Opus 4.8). Owner-side, strictly read-only static analysis of
> `decrypted\FT3D_MAIN_ver102_EXP.bin` (H8SX, base 0, big-endian, so file offset = address). No image byte was modified
> and nothing was connected to or written to any radio. Inputs read: `ida\out\main-final2\final2_proven_mask.bin`,
> `MAIN_FINAL2_codemask.bin`, `functions.tsv`, and the H9 descent offline library (`ida\out\main-descent\offline\common.py`,
> whose binutils H8SX oracle H9 already cross-checked against IDA `h8sxa` with 0 length mismatches). The closed window
> `0x078106`–`0x07B753` was not analysed; items there are reported as "closed-window, out of scope". The reference scans
> are pure byte scans of the image (offset = address), so no IDA pass was needed to run them; the proven/code masks that
> gate them are the IDA MAIN_FINAL2 dumps. Tables: `ida\out\main-unreached\`.

## Verdict

**Of MAIN's 83 typed-but-unreached functions, 5 are genuinely reached by roots the descent missed, 3 are reached only
from inside the closed window, 15 are mis-typed data, and 60 are genuinely dead well-formed code.** Only **36 B move from
typed-unreached to proven** — two record-field callbacks (`0x02A924`, `0x02A9F4`, 20 B, Confirmed root) and three
switch-case handlers (`0x065EFA`/`0x065F00`/`0x065F06`, 16 B, Inferred root). A whole-image BE32 + `jsr/jmp` abs24 scan of
the entire **22,360 B** of unproven DB code finds **no other code root**: there are **0** proven calls into the interior of
any unproven run, and every run-start that carries a proven reference is a data pointer (string, parameter table, constant)
or a coincidental mid-instruction byte match. The remaining 22,324 B splits roughly in half: **~11,996 B is mis-typed data**
(strings, byte-ramp/parameter/pointer tables, zero-fill, constants) and **~10,230 B is well-formed but unreferenced code**,
of which **958 B is the H8SX USB module** (`0x076C0A`–`0x076FC7`) that is reachable only through a pointer table inside the
closed window, and ~9,272 B is dead in scope. So the proven-code figure rises by at most 36 B
(368,432 → **368,468**); the named/typed figure does not change, because all of these bytes are already credited as
named/typed under their current type.

## Method

All scans are offline Python over the image, gated by the MAIN_FINAL2 masks. Scripts live in the session scratchpad;
the two result tables are in `ida\out\main-unreached\`.

1. **Input.** The 83 functions are the `reach_class == typed-unreached` rows of `main-final2\functions.tsv`. All 83 lie
   below `0x078106`, so none is itself inside the closed window.
2. **Per-function reference scan** (`scan.py`, `refs.py`). For each function start I searched the whole image
   (`0..0x7B754`) for: (a) a BE32 word equal to the start (pointer / `mov.l #imm` immediate — flagged when the four bytes
   are preceded by `7A 0x`); (b) a `jsr @aa:24` (`0x5E`) or `jmp @aa:24` (`0x5A`) whose 24-bit operand equals the start;
   (c) the oracle instruction that ends exactly at the start, to test flow fall-through. Each hit is tagged with whether
   its site is **proven**, **unproven DB code**, **data**, or **in the window**.
3. **Adjudication.** A reference promotes a function to *reached* only when the referencing site is itself reached
   (proven) **and** the target is entered as code (a call/flow/switch target), not merely loaded as a data address. A
   `mov.l #imm` that loads the address of a string or table is a *data* reference, not a code entry.
4. **Byte-level run scan of all unproven DB code** (`dbcode.py`). I cut the code mask minus the proven mask into 598
   maximal runs (22,262 B outside the window; +98 B inside = 22,360 B), then tested every run-start for a proven abs24 or
   proven BE32 reference, and separately tested for any proven abs24 landing in a run's *interior* (a missed interior
   entry point). I classified each run as data or code with the same printable-fraction / byte-diversity / monotonic /
   zero-fill / linear-decode test H9 used.
5. **Oracle decode** for the individual sites quoted below (`probe.py`), using the binutils H8SX oracle.

**Not done / scope.** I did not open an IDA database; the question is a reference-and-reachability question that the image
bytes plus the existing IDA-derived masks answer directly, and the oracle decode is already IDA-cross-checked. I did not
enter the closed window, so the entry point that reaches the USB module (and the 98 B of in-window unproven code) is
reported but not traced. I did not re-run H9's descent; I measured against its fixed-point masks.

## Findings

### 1. The 5 functions that move to proven

| Func | B | Root (missed by the descent) | Evidence | Grade |
| --- | ---: | --- | --- | --- |
| `0x02A924` | 10 | record-field callback | PROVEN `0x028C20: 7A 01 00 02 8C 2A` (`mov.l #0x28C2A,er1`) then `bra 0x28CBC` (the common record dispatch). Record at `0x028C2A` holds a BE32 code pointer at **+0x14** = `0x028C3E` = `00 02 A9 24`. Body `55 08 47 04 5E 02 9C 56` (`bsr; …; jsr @0x29C56`). | Confirmed field + proven base-load; call-through Inferred |
| `0x02A9F4` | 10 | record-field callback | PROVEN `0x028C82: 7A 01 00 02 8C 8A` (`mov.l #0x28C8A,er1`) then `bra 0x28CBC`. Record at `0x028C8A` field **+0x14** = `0x028C9E` = `00 02 A9 F4`. Same stub body. | Confirmed field + proven base-load; call-through Inferred |
| `0x065EFA` | 6 | switch-case handler | Embedded between proven `0x065EF8 bra→0x65F30` and proven `0x065F0A`. Body `5E 06 5B 66` (`jsr @0x65B66`, proven) `; bra 0x65F30` (proven). Its address is listed in the dispatch table at `~0x02B3C0` (`… 00 06 5E FA …`). | Table entry Confirmed; reader Inferred |
| `0x065F00` | 6 | switch-case handler | `jsr @0x65B86` (proven) `; bra 0x65F30`. Table entry `00 06 5F 00` at `0x02B3DC`. | as above |
| `0x065F06` | 4 | switch-case handler | `jsr @0x65BA6` (proven) `; bra 0x65F30`. Table entry `00 06 5F 06` at `0x02B3E0`. | as above |

These are the two root types H9 explicitly left unresolved (Open 1: struct-member callbacks; switch index tables not
followed) and that I14 flagged as uncredited (Open 4 named `0x028C2A+0x14 → 0x02A924` and `0x028C8A+0x14 → 0x02A9F4` as
"Confirmed fields that nothing credits yet"). This lane confirms the record bases are loaded by proven code, so the two
callbacks are genuinely reachable: **+20 B Confirmed**. The three switch stubs are bracketed by proven code, call proven
subroutines, and are listed verbatim in a pointer table; the one gap is that the instruction that indexes the
`~0x02B3C0` table was not pinned (no proven BE32/abs24 names the base; it is reached through a computed register base), so
they are **+16 B Inferred**.

### 2. The 3 functions reached only from the closed window — the H8SX USB module

`0x076C0A` (750 B), `0x076EF8` (204 B) and `0x076FC4` (4 B) are the H8SX USB-module routines H9 found unreached. They call
each other by abs24 `jsr` (`0x07691A → 0x076C0A`, `0x076C34 → 0x076EF8`, `0x076C56 → 0x076FC4`), all sites inside the same
unproven `0x0768xx`–`0x077xxx` cluster. **No in-scope pointer reaches that cluster.** The only inbound pointers come from
**inside the closed window**: BE32 pointers at `0x07B4C4 → 0x0769AA`, `0x07B4CE → 0x0768C8`, `0x07B4D8 → 0x0769AA`,
`0x07B4EC → 0x0768A8` (all addresses in `0x078106`–`0x07B753`). This is direct confirmation of H9's and G1's claim that
the USB module's callers live in the closed window. Disposition: **real USB code, reachable only from the closed window →
out of scope**; not credited to in-scope proven, not dead, not data. (USB relevance below.)

### 3. The 15 mis-typed data functions (604 B)

IDA created function heads over data. Representative items (first bytes Confirmed):
- Strings: `0x0044DA` `"373839404142…"` (164 B, decimal-digit table), `0x008352` `" : TX   …"` (186 B),
  `0x045308` `"ESU FT1D\r\n"`, `0x0458D8` `"$GPWPL,0000."` (28 B NMEA GPS sentence — loaded as a data pointer by PROVEN
  `0x0455B8: 7A 05 00 04 58 D8`, which is a *data* load, not a call), `0x04E012` `"P-Rate"`, `0x06796A` `"M01\xffM02\xff…"`,
  `0x067446` `":\xffSENT:\xffD/L "`, `0x06B69C` `"SEND   \xffFORW"`, `0x00D22C` `"   . Hz"`, `0x03619E` `"iiiihhhhgggg"`.
- Byte-ramp / parameter tables: `0x0376C8` (`11 11 … 12 12`, 152 B monotonic), `0x009B34` (`1C 1D 1E 1F 20`),
  `0x00244C`, `0x006646`, `0x00A54C`, `0x066DC8`, `0x0379EA` (zero-sparse record), `0x03798C`, `0x0780BE` is borderline
  (kept as code; see §4).

All 15 have **zero** inbound code reference (BE32/abs24) anywhere; where a proven instruction touches one (e.g. `0x0458D8`)
it is a data-pointer load. These are already credited as named/typed under string/table types, so the named figure is
unaffected.

### 4. The 60 genuinely dead functions (2,286 B)

Well-formed H8SX code that decodes cleanly (most to an `rts`/`bra` stop) but has **0 inbound references** of any kind in
`0..0x7B754`. The large majority sit immediately after a proven function's `rts` (e.g. `0x00A73A`, `0x024CCA`,
`0x04FE8E`, `0x0529AC`) — adjacent to live code but never called and not fallen into (the preceding `rts`/`bra` stops
flow). A few notable confirmations:
- `0x010B44` (10 B) is **not** reached by flow: the authoritative oracle decode shows `0x010B40` is a 4-byte `bra .-140`
  (a stop), so it does not fall through to `0x010B44`. (A naive "previous 2-byte instruction" heuristic falsely paired it
  with `0x010B42`; the real boundary is `0x010B40`.) Dead.
- `0x023602` (28 B) — H9's demoted F1 row; its only hit is a BE24 value at `0x078570`, inside the closed window. Dead in
  scope.
- `0x06DBE0` (2 B, a lone `rts`) — two abs24 `jsr` matches (`0x061C54`, `0x0669DA`) both fall in data, not real code. Junk.

### 5. The full 22,360 B of unproven DB code (`dbcode-runs.tsv`)

598 runs outside the window (22,262 B) + 98 B inside. Byte-level disposition:

| Disposition | B | Note |
| --- | ---: | --- |
| reached → proven | 36 | the 5 functions of §1 |
| mis-typed data | ~11,996 | strings, byte-ramp/parameter/pointer tables, zero-fill, numeric constants |
| dead code (in scope) | ~9,272 | well-formed, unreferenced; incl. H9's unreached code-structural runs |
| USB module, window-sourced | 958 | `0x076C0A`/`0x076EF8`/`0x076FC4` (§2) |
| closed-window interior | 98 | out of scope |

W2-8 runtype of the 22,262 B outside the window: recovered code 13,283, untyped 3,680, parameter table 3,326, string
1,532, other 266, fill 149, pointer table 26 — matching I14 §5.

**The decisive negative result:** across all 22,360 B, there are **0** proven abs24 calls into the interior of any
unproven run, and the 25 run-starts that carry a proven BE32/abs24 reference are every one a data pointer or a false
positive. Two checked explicitly: `0x036B84` (`jsr` operand `5A` at `0x074342` is actually the immediate of
`mov.w #0x5A03`; target `1D 1D … 1E 1E` is a byte ramp, not code), and `0x014C6A` (its BE32 match at `0x01CFD3` is
odd-offset and crosses the `bra` at `0x01CFD2`). So beyond the 5 functions, nothing in the 22,360 B is reachable code that
the descent missed.

## USB relevance

- **The USB module is real, complete, and reachable only from the closed window.** `0x076C0A` (750 B) + `0x076EF8` (204 B)
  + `0x076FC4` (4 B) form the H8SX on-chip USB-function-module driver, entered through the BE32 pointer table at
  `0x07B4C4`–`0x07B4EC` (inside `0x078106`–`0x07B753`) that targets `0x0768A8`/`0x0768C8`/`0x0769AA`. This is the strongest
  in-scope evidence yet that the USB engine's entry/dispatch lives in the closed window: the window holds a pointer table
  into the module, not just code. A lane that is allowed into the window should decode `0x07B4C0`+ as a USB handler
  pointer array and follow it into `0x0768xx`.
- Nothing in the 36 B that moves to proven touches USB: the record callbacks `0x02A924`/`0x02A9F4` and the switch stubs
  `0x065EFA`/`F00`/`F06` are application-logic handlers (the switch function at `0x065Exx` reads port bits `0xB26B`/`0xB26C`
  and `0xA9EE`, not the USB module at `0xFFEE00`).
- No new descriptor, endpoint, SCI-C/DSP path or SDR data path is reached. The SDR and DSP answers are unchanged.

## Open

1. **Enter the closed window for the USB entry.** Decode the pointer table at `0x07B4C4`–`0x07B4EC` and the code at
   `0x0768A8`/`0x0768C8`/`0x0769AA`; that is the live caller of the 958 B USB module and the natural continuation of the
   USB survey. Highest value.
2. **Pin the `~0x02B3C0` switch reader** to upgrade the three stubs (`0x065EFA`/`F00`/`F06`, 16 B) from Inferred to
   Confirmed. The dispatcher is the proven function containing `0x065EC2`–`0x065F3A`; find the indexed `jmp` that uses the
   `0x02B3C0` base held in a register.
3. **Retype the 15 data functions and the ~11,996 B of mis-typed data** (strings, byte/parameter/pointer tables) from
   "function"/"recovered code" to data. It tidies the DB and would make the named figure rest on correct types, but moves
   no headline byte.
4. **The 20 B record callbacks are ready to credit now.** Union `0x02A924` and `0x02A9F4` (and, once the reader is pinned,
   the 16 B of switch stubs) into `final2_proven_mask.bin`: 368,432 → 368,452 (Confirmed) or 368,468 (incl. Inferred).
   They are disjoint from the merged proven mask, so the merge's no-overlap asserts hold.

### Files (`ida\out\main-unreached\`)

| File | Content |
| --- | --- |
| `functions-disposition.tsv` | all 83 typed-unreached functions: start, end, size, disposition (REACHED/WINDOW/DATA/DEAD), evidence |
| `dbcode-runs.tsv` | all 598 unproven-DB-code runs (excl. window): start, end, size, W2-8 runtype, any proven reference, first bytes |
