# 37 — MAIN fixed-stride dispatch banks and the full MAIN→SUB IPC opcode set (Lane G2)

Owner-side static analysis of firmware already on disk. No device, USB, serial or
flash access; nothing was written to a radio and no image byte was modified. MAIN
is Hitachi/Renesas H8S advanced (`h8s300a`), big-endian, image base 0 so file
offset == mapped address; content region `0x000400`–`0x07B753`. SUB is Renesas RX64M,
little-endian, base `0xFFC00000`. Model running: **claude-opus-5-5**.

Machine tables under `ida\out\main-banks\`: `banks.tsv`, `bank-entries.tsv`,
`ipc-opcodes.tsv`, `table-xrefs.tsv` (4,194 rows), `survival.txt`,
`newly-proven.tsv`, plus evidence dumps `bank_decode.txt`, `ipc_raw.tsv`,
`b6b6_callers.txt`, `sub_dispatch.txt`, `sub_handlers.tsv`, `sub_probe.txt`.
Reusable job: `ida\jobs\g2_apply_table_xrefs.py`.

## Verdict

**There is no computed fixed-stride dispatch bank in MAIN.** F1's "0xA7xx IPC
command-sender bank (stride 0x3C, base+index*stride)" does not exist as a computed
dispatch structure. What sits at `0x00A6FE`–`0x00A87A` is five *independent,
compiler-emitted frame-builder functions* (opcodes `0xF500`,`0xF501`,`0xF502`,
`0xF503`,`0xF510`) that happen to be the same 60-byte size for the first four — the
0x3C "stride" is coincidental uniform function size, not an index multiplier. Each
is reached (if at all) by a plain `jsr @aa:24`, never by `base+index*0x3C`: no 32-bit
immediate `0x0000A6FE` is loaded anywhere in the image (BE32 scan = 0 hits), so no
base is ever indexed. `0x00A6FE`/`F500` (caller `0x052F82`), `0x00A776`/`F502`
(`0x052C6C`) and `0x00A7EE`/`F510` (`0x04F6CA`,`0x04FAAA`) are directly called;
`0x00A73A`/`F501` and `0x00A7B2`/`F503` have **zero** code or data xrefs and are
confirmed dead (unused protocol opcodes). The real structure this "bank" belongs to
is a flat array of **106 per-opcode IPC frame-builder functions** spanning
`0x007FAA`–`0x00D928`, each staging one opcode into the mailbox; they are the MAIN→SUB
command set. I enumerated all of them, byte-verified the opcodes, and cross-checked
every one against the SUB receive dispatcher. Numerator (reached-code) byte delta from
this lane: **0 B** — every residual function examined is unreferenced (dead), so none
moves into proven-reached; what changes is their *classification quality*, from
"dead-or-computed (unknown)" to "confirmed dead, typed".

## Method

Private databases via `run_job.py` only; no shared DB opened. `G2_BANKS` seeded from
`ida\db\jobs\FIN_MAIN_IND\FIN_MAIN_IND.i64`; `G2_SUB` seeded from
`ida\db\radio\SUB.i64` (455-function state). Scripts `ida\jobs\g2_banks.py`,
`g2_survival.py`, `g2_apply_table_xrefs.py`, `g2_sub.py`, `g2_sub_probe.py`; each calls
`ida_auto.auto_wait()`, wraps the body in try/except to a traceback file, writes UTF-8,
and ends `idc.qexit(0)`.

1. **Bank decode + caller census (`g2_banks.py`).** Decoded the A6FE family and all 42
   F1 residual "standalone" functions via IDA, dumping per-instruction disassembly,
   immediates, mailbox stores, call targets and IDA's incoming cref/dref lists.
2. **Direct-caller map (Python, raw image).** Built a full `jsr @aa:24`/`bsr d:8`/
   `bsr d:16` target map over `0x400`–`0x80000`, and a BE32/BE24 pointer scan, to
   decide reachability of each builder independently of IDA.
3. **IPC opcode census (`g2_banks.py`).** Forward-scanned every one of the 3,899 MAIN
   functions tracking register immediates; on any store to the mailbox fields
   `0xFF3D72`/`0xFF3D74`/`0xFF3D76` it resolved the written value, and recorded whether
   the function calls the fill helper `sub_7C20` and/or the send API `sub_B6B6`.
4. **SUB cross-check (`g2_sub.py`,`g2_sub_probe.py`).** Promoted and decoded the receive
   dispatcher chain `sub_FFEDF1D8` → family handlers → `sub_FFEDF269`, read IDA's native
   switch tables (`jpt_FFEDF1F6`, `jpt_FFEDF290`, `jpt_FFEDF308`) and hand-decoded the
   cmp-chain classifiers, giving the exact set of low opcodes each family recognises.
5. **Table→target xrefs + survival (`g2_survival.py`).** Read all 149 resolved tables
   from the image as BE32, emitted every live code target to `table-xrefs.tsv`, applied
   them with `g2_apply_table_xrefs.apply_from_tsv`, re-analysed `0x400`–`0x7B754`, and
   counted how many of the 444 F1-proved functions survive as a function with an
   incoming xref.

Scope not crossed: the closed service window `0x078106`–`0x07B753` (no builder lives
there). I did not re-reverse the SUB-side *payload apply* routines (e.g.
`sub_FFEF4142` for `0xFC00`); the cross-check is at opcode-recognition granularity.

## Findings

### 1. The A6FE "bank" is five independent frame-builders (byte-verified)

`bank-entries.tsv` carries the per-entry proof. Each of `0x00A6FE`,`0x00A73A`,
`0x00A776`,`0x00A7B2` is 60 bytes with an identical skeleton — opcode immediate at
`+0xC`, opcode store `6B A4 00 FF 3D 74` at `+0xE` (byte-verified OK on all four):

| addr | opcode | total `@+2` | paylen `@+0x16` | callers | status |
| --- | --- | --- | --- | --- | --- |
| `0x00A6FE` | `F500` | 0x9D | 0x93 | `0x052F82` | live (direct `jsr`) |
| `0x00A73A` | `F501` | 0x63 | 0x59 | **NONE** | **dead** (0 xref) |
| `0x00A776` | `F502` | 0xA2 | 0x98 | `0x052C6C` | live |
| `0x00A7B2` | `F503` | 0x65 | 0x5B | **NONE** | **dead** |
| `0x00A7EE` | `F510` | — | — | `0x04F6CA`,`0x04FAAA` | live (140 B fn) |

Each: `mov.w #total,r4; mov.w r4,@0xFF3D72` → `mov.w #opcode,r4; mov.w r4,@0xFF3D74`
→ `mov.w #paylen,r4; mov.w r4,@0xFF3D76` → `jsr sub_7C20` (payload fill) → `eepmov.w`
of an 18-byte ROM template (`er5=0xC444`/`0xC456`, `er6=@0xFFBC2C`) → `rts`. They do
**not** call `sub_B6B6` — the actual transmit is done by the dispatcher that called the
builder. `0x00A82A` is a second entry point inside the `F510` function (`0x00A7EE`), not
a separate bank slot, and is itself unreferenced.

### 2. The full MAIN→SUB IPC opcode set — 106 builder sites, 99 distinct opcodes

`ipc-opcodes.tsv` lists every site. The builders form a flat array `0x007FAA`–`0x00D928`
(not a jump table — none of them appears in any of the 149 resolved tables), one per
opcode, reached by direct `jsr`/`bsr` from UI/control code or (for `F401`) a BE32 function
pointer. Per-family site counts:

| Family | sites | SUB top-level slot (doc 25) |
| --- | --- | --- |
| F0 | 12 (`F000`–`F00B`) | `sub_FFEDF269`, 12-case switch — implemented |
| F1 | 14 | `sub_FFEDF2E0`, 22-case switch (4 default) |
| F2 | 3 (`F200`,`F280`) | `sub_FFEDF36A` |
| F3 | 32 | `sub_FFEDF3A7` (shared F3/F4) |
| F4 | 2 (`F401`,`F403`) | `sub_FFEDF3A7` |
| F5 | 14 (`F500`–`F518`) | `sub_FFEDF447` |
| F6 | 11 | `sub_FFEDF4B8` |
| F7 | 1 (`F701`) | `sub_FFEDF53E` |
| F8 | 13 (`F800`–`F824`) | `sub_FFEDF56F` |
| FC | 1 (`FC00`) | **FC family unused in dispatcher** |
| FD | 1 (`FD00`) | `sub_FFEDF61B` |
| FE | 1 (`FE00`) | `sub_FFEDF645` (shared FE/FF) |
| FF | 1 (`FFFF`) | `sub_FFEDF645` |

Two additional generic send-wrappers (`0x005634`, `0x00698C`) call `sub_B6B6` on an
already-staged frame. Only **14** sites call `sub_B6B6` directly (`b6b6_callers.txt`);
of the opcode builders, four send inline (`F000`@`0x007FCE`, `F007`@`0x0084C4`,
`F3D6`@`0x00D2B2`, `FC00`@`0x00D53A`) and the rest are staged-then-sent by their caller.
Payload is filled by `sub_7C20` for the large majority.

### 3. SUB dispatcher is an opcode→screen-id classifier; cross-check result

The chain `sub_FFEDF1D8` (`0xFFEDF1D8`) reads opcode hi at `0x8E46`, `add #-0xF0`,
bounds `≤0x0F`, and switches through `jpt_FFEDF1F6` to a family handler; each handler
re-verifies its hi byte, reads lo at `0x8E47`, and maps recognised low bytes to a small
UI screen id (`0x08`..`0x48`), defaulting to `0xFF`. **Top-level: 12 families
implemented, 4 unused (`0xF9`,`0xFA`,`0xFB`,`0xFC`)** — confirms doc 25 byte-for-byte
(`sub_handlers.tsv`). I extracted each family's recognised low-opcode set from the
switch tables / cmp-chains (`sub_dispatch.txt`).

**Mismatches flagged (from `ipc-opcodes.tsv`):**

- **MAIN opcode with no SUB handler:** `F102` (sender `0x008B7C`, live). The SUB F1
  handler `sub_FFEDF2E0` routes low byte `0x02` to its default (IDA: "default case,
  cases 2,12,14,16"), so `F102` reaches no screen handler — either a vestigial sender
  or handled via an alternate apply path not in this classifier.
- **MAIN opcodes handled off the classifier (alt apply path, not a mismatch):** `F3D6`
  (`0x00D2B2`) — the F3 handler explicitly excludes `0xD5`/`0xD6` (`add #-0xD5; cmp #2;
  bltu →skip`); `FC00` (`0x00D53A`) — FC family is unused in the dispatcher and is
  applied via the pending buffer / `sub_FFEF4142`; `FE00` (`0x00B5CE`) — the shared
  FE/FF handler `sub_FFEDF645` only matches `0xFF`, so `FE00` falls to default.
- **SUB handlers with no live MAIN sender** (SUB recognises, MAIN never sends, or only a
  dead builder sends): `F003`, `F00A`, `F109`, `F10A`, `F10D`, `F10F`, `F113`, `F115`,
  `F400`, `F401`(dead builder), `F402`, `F404`, `F501`(dead), `F503`(dead), `F703`,
  `F801`, `FF01`, `FFFE`. Several are the dead-builder opcodes below.

### 4. Confirmed-dead IPC builders and the residual

Six opcode builders have no direct `jsr`/`bsr` caller. Correcting a naive direct-call
test: `F401` (`0x00D910`) is in fact **reached** via a BE32 function pointer at
`0x009196` (F1 `proved.tsv`); `F392` (`0x00A160`) and `F3D1` (`0x00A684`) are in the
base-validated set with no direct call or static pointer found (indirect/unknown — not
counted dead). The **three confirmed dead** builders — exhaustively checked by F1
(absent from all 149 tables, full BE32 scan, validated BE24 scan, and IDA's xref db)
and by my direct-call scan — are:

| addr | opcode | bytes | note |
| --- | --- | --- | --- |
| `0x0085D6` | `F00A` | 76 | SUB *does* recognise `F00A`; builder never called |
| `0x00A73A` | `F501` | 60 | SUB recognises `F501` (→id `0x22`); builder dead |
| `0x00A7B2` | `F503` | 60 | SUB recognises `F503` (→id `0x22`); builder dead |

= 196 B of the F1 residual, now typed as dead IPC builders (`newly-proven.tsv`). The
remaining **39** of the 42 F1 "standalone" residual functions (1,646 B) are **not IPC
builders** and have no static caller, BE32/BE24 pointer, or table entry — confirmed
dead/unreferenced standalone routines (`bank-entries.tsv`). No computed dispatch reaches
any of them. **Reached-code numerator delta from this lane = 0 B** (reasoning: every
examined residual function is unreferenced; none becomes reachable, so none enters the
proven-reached count — the 90.3% headline is unchanged).

### 5. Table→target xref emission and survival (`survival.txt`)

Emitted all **4,194** live code targets from the 149 resolved tables (6,406 entries,
2,212 sentinel `0x0003FFA0` dropped, 0 out-of-range) to `table-xrefs.tsv`, applied them
(4,194 drefs, 943 functions promoted), and re-analysed.

| | before | after apply + reanalyse |
| --- | --- | --- |
| 444 proved still a function at start | 444 | 416 |
| …with an incoming xref | **0** | 261 |
| …function **and** incoming xref | 0 | **261 / 444 (58.8%)** |

The "before = 0 incoming xrefs" reproduces F1's root cause exactly. The ceiling under
the 149-table scope is **257** — that is how many of the 444 proved *starts* are an exact
live table target; the realised 261 slightly exceeds it because re-analysis created a few
code refs onto promoted targets. The 183 that do not survive are reached by
function-pointer arrays found by F1's image-wide pointer scan (**outside** the 149-table
scope, so no xref was emitted for them) or by a table pointer that lands *inside* a
function's extent rather than at its start. 28 of the 444 lose function status when
re-analysis merges an over-split fragment. This is the honest result for the stated
scope; widening to the pointer-array targets would raise it but is a separate emission.

`g2_apply_table_xrefs.py` is standalone and reusable: `apply_from_tsv(path)` reads any
`from_table_entry <TAB> target` TSV, makes each slot a 32-bit offset, adds a user dref,
and promotes the target to a function — idempotent, runnable against any MAIN DB copy via
`--env G2_XREF_TSV=…`.

## USB relevance

Negative, and now more completely. The entire MAIN→SUB IPC surface is **99 opcodes of
UI / menu / settings / status plumbing** (screen ids `0x08`–`0x48`); there is no bulk,
isochronous, or sample-streaming opcode, and the one bulk opcode (`FC00`) carries
settings/memory blocks, not samples. The dispatch backbone that F1 flagged as a possible
hidden "command-sender bank" resolves to ordinary per-opcode frame builders, with two of
them dead. Nothing here is a path to IQ/SDR streaming or to the DSP: the DSP opcode
`F008` is a single UI-status frame (`sub_8532`, doc 25), not a bulk pipe, and no opcode
reaches a USB endpoint. The four unused SUB families (`F9`–`FC`) and the dead MAIN
builders (`F00A`,`F501`,`F503`) are spare protocol space, consistent with the "free IPC
opcodes" extension point in `RESUME-FULL.md`, not evidence of a latent capability.

## Open

Most valuable first:

1. **Resolve `F102`'s fate** — decode `0x008B7C` and its caller to confirm whether it is
   a vestigial sender or applied via an off-classifier path like `F3D6`/`FC00`. One
   function; closes the only live MAIN-no-SUB-handler flag.
2. **Emit xrefs for the function-pointer arrays too** (F1's image-wide pointer-scan
   targets, the 86+ functions reached as `data@…`), so the proved-function survival rises
   past the 149-table ceiling of 257 and future auto-analysis stops re-rejecting them.
3. **Confirm `F392`/`F3D1` reachability** — both are base-validated but carry no direct
   call or static pointer; they may be reached by a tracked indirect `jsr @ERn`, or be a
   small base-pass over-count (~190 B). Resolving this tightens the MAIN numerator.
4. **Decode the SUB payload-apply routines** (`sub_FFEF4142` for `FC00`, and the `F3D6`
   field apply) to raise the cross-check from opcode-recognition to field-layout
   granularity — the natural continuation for doc 25.

### Proposed additions to doc 25 (not edited here, per rules)

- The MAIN send surface is **106 per-opcode frame-builder functions** (`0x007FAA`–
  `0x00D928`), one opcode each, staging the `0xFF3D72` mailbox and `jsr sub_7C20`; the
  transmit (`jsr sub_B6B6`) is done by the dispatcher/wrapper that calls the builder —
  only 14 direct `sub_B6B6` call sites exist. Full set in `ida\out\main-banks\ipc-opcodes.tsv`.
- The SUB top-level dispatcher + family handlers are an **opcode→screen-id classifier**
  (ids `0x08`–`0x48`, default `0xFF`); recognised low-opcode sets per family are in
  `sub_handlers.tsv`/`sub_dispatch.txt`. `F102` has no screen handler; `F3D6`,`FC00`,
  `FE00` are handled off this classifier.
