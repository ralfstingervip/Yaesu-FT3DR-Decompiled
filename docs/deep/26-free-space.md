# Free space map — MAIN (H8S) and SUB (RX64M) ver 1.02

Lane 9. Databases: `FREESPACE_SUB` (`ida\db\jobs\FREESPACE_SUB\`, copied from
`SUB_VEC`). Tables: `ida\out\extension\space.tsv` (453 flash free runs),
`space-vectors.tsv` (3 vector tables), `space-sub-ram.tsv` (566 resolved SUB RAM
targets). All byte scans are plain Python against the read-only `.bin` files.

## Verdict

Both images are mostly empty at the top. **MAIN** carries content in
`0x000000`–`0x07B753`; everything above is a single `0xFF` erase region of
**542,892 bytes** (`0x07B754`–`0x0FFFFF`) — the obvious attach point for added
MAIN code. **SUB** content runs to `0xFFF509DD` — **~2.5 KB higher than the
`0xFFF50000` code-window top the earlier passes used** (there is live RX code at
`0xFFF50000`–`0xFFF509DD`, not fill) — above which is a single `0xFF` erase
region of **718,242 bytes** (`0xFFF509DE`–`0xFFFFFF7F`, ending just below EXTB).
The code windows themselves are nearly solid: the largest fill run of any kind
inside `0xFFED0000`–`0xFFF50000` is a **283-byte** zero run. RAM high-water is
`0xFFBCB5` on MAIN and the stack top `0x0006B8FC` on SUB. Free interrupt capacity
is large: **226/256** MAIN vector slots and **198/256** SUB INTB slots still point
at a do-nothing handler. **No firmware-resident integrity check covers flash** —
the only flash checksums are the Renesas boot-ROM verify commands the PC updater
issues (`0x4B` MAIN, `0x4D` SUB), which recompute over whatever is programmed, so
they constrain the *update tool*, not the placement of a later addition.

## Method

- **Flash fill (Confirmed).** Byte scan of both images: first/last non-`0xFF`,
  and every `0xFF` and `0x00` run ≥ 64 B (MAIN) / ≥ 256 B (SUB). Runs are emitted
  to `space.tsv` with core, address, length, kind, and code-window flag.
- **Vector tables (Confirmed).** MAIN 256 big-endian dwords at file `0`; SUB INTB
  256 little-endian dwords at `0xFFED8A70` (file `0x2D8A70`); SUB EXTB 32 at
  `0xFFFFFF80` (file `0x3FFF80`). Each slot's target's first two bytes read to
  classify dummy vs live. Matches doc-02's independent re-decode exactly.
- **MAIN RAM high-water (Confirmed).** Parsed `ida\out\main-full\ioregs.tsv`
  (16,893 absolute-operand sites) for store forms `mov.X reg, @addr`; took the
  highest target in RAM (`≤ 0xFFDFFF`). Cross-read the reset section-init from
  doc-04 §2.
- **SUB RAM high-water (Confirmed).** IDA job `full_l9_sub_ram.py` on
  `FREESPACE_SUB`: dumped the reset routine (stack/INTB/EXTB init) and ran an
  intra-function const-prop store scan over all 3806 functions for RAM targets
  (`0x00000000`–`0x0007FFFF`). Output `space-sub-ram.tsv`,
  `ida\log\jobs\FREESPACE_SUB\`.
- **Integrity checks.** Read the reset self-test `sub_20D8` (18 bytes — a delay
  loop, not a CRC); relied on the settled negative "neither core writes/self-checks
  its own flash" (RESUME-DEEP, docs 04/16, MAIN 3899 funcs + SUB 3806 funcs) and
  doc-10 for the boot-ROM/host-side checksum commands.
- **Did not run.** No new full MAIN re-analysis (reused `main-full` tables). Did
  not follow the DSP boot personality. SUB const-prop does not resolve bases held
  in RAM/tables (doc-02 caveat), so the SUB RAM figure rests on the reset stack
  init, which is definitive for the ceiling.

## Findings

### MAIN flash (base 0, file offset = address)

- **Confirmed.** First non-`0xFF` at `0x000000` (`0x00`, start of vector table);
  last non-`0xFF` at **`0x07B753`** (`0x00`); `0x07B754` = `0xFF`. Reconfirms
  doc-04 exactly.
- **Largest free run: `0x07B754`–`0x0FFFFF` = 542,892 B of `0xFF`** (erase fill).
- `0xFF` runs ≥ 64 B: **17 runs, 544,147 B**. `0x00` runs ≥ 64 B: **54 runs,
  3,776 B**. Combined free ≥ 64 B: **547,923 B**.
- The `0x00` runs and the small (<256 B) `0xFF` runs below `0x07B754` are
  inter-table/struct padding inside content, not appendable space. The only
  large usable block is the top erase region. Largest sub-content runs:
  `0x0365FC`–`0x036691` (150 B, `0x00`), `0x07132A`–`0x0713BB` (146 B, `0x00`),
  `0x00F6D6`–`0x00F755` (128 B, `0xFF`). Full list in `space.tsv`.

### SUB flash (base `0xFFC00000`)

- **Confirmed and a correction.** The nominal fill region `0xFFF50000`–
  `0xFFFFFF80` is **not** all fill: `0xFFF50000`–`0xFFF509DD` (file `0x350000`–
  `0x3509DD`, ~2,526 B) is **live RX code** (e.g. `0xFFF50000: ed 0f 20 af …`,
  valid RX). SUB content therefore ends at **`0xFFF509DD`**, above the
  `0xFFF50000` code-window top used by doc-02 (its "96–100 % 0xFF per 64 KB block"
  correctly flagged the first block as <100 %).
- **Largest free run: `0xFFF509DE`–`0xFFFFFF7F` = 718,242 B of `0xFF`** (erase
  fill, ends exactly one byte below EXTB at `0xFFFFFF80`).
- Whole-image runs ≥ 256 B: `0xFF` **96 runs / 763,214 B**; `0x00` **286 runs /
  214,256 B**. Combined ≥ 256 B: **977,470 B**. Most `0x00` runs sit in the
  data region below `0xFFED0000` (table/struct padding — not guaranteed free).
- **Inside the code window `0xFFED0000`–`0xFFF50000`:** exactly **one** run
  ≥ 256 B — a `0x00` run `0xFFEDA609`–`0xFFEDA723` (283 B). Clipped free bytes in
  the window = **283 B**. The code window is otherwise solid; a later addition
  cannot expand inside it and must use the top erase region.

### RAM high-water

- **MAIN — Confirmed `0xFFBCB5`.** Highest RAM store `mov.b r4l, @0xFFBCB5:16`.
  Data RAM occupied `0xFEE000`–`0xFFBCB5`; nothing addressed `0xFFBD00`–`0xFFEDFF`
  (doc-04 §2). Reset init: BSS clear `0xFEE000`–`0xFF72FF` (37,632 B), `.data`
  copy → `0xFF6034` (1,198 B), SP init `0xFF7F00`. Headroom to the top of the
  second data region (`0xFFBFFF`) ≈ 1.3 KB. Part = H8S/2456 group; exact on-chip
  RAM size **Unknown** (two addressed windows: `0xFEE000`–`0xFF7FFF`,
  `0xFF8000`–`0xFFBFFF`).
- **SUB — Confirmed stack top `0x0006B8FC`.** Reset routine (`0xFFC00000`):
  `mvtc #6A8FCh, usp` / `mvtc #6B8FCh, isp`. Highest resolved data store
  `0x00069794`; the 16 kHz audio ping-pong buffer B ends at `0x000503A6`
  (doc-02). RAM used `0x00000000`–`0x0006B8FC`. Part = RX64M; on-chip SRAM up to
  512 KB (`0x00000000`–`0x0007FFFF`, Inferred), so ~82 KB of SRAM sits unused
  above the stack.

### Vector slots still pointing at a do-nothing handler

| Table | Slots | Dummy | Breakdown |
| --- | --- | --- | --- |
| MAIN @ `0x000000` | 256 | **226** | all hold reset entry `0x00002092`; 30 real handlers |
| SUB INTB @ `0xFFED8A70` | 256 | **198** | 198 RTE-stub (`7F 95`) + 40 null (zero) + 1 WAIT-trap (`7F 96`, slot 0) + 17 live |
| SUB EXTB @ `0xFFFFFF80` | 32 | **31** | 31 point at empty stubs (26 share `0xFFF47E3E`); slot 31 = reset `0xFFC00000` |

Matches doc-02's re-decode (0 mismatches). `space-vectors.tsv`.

### Integrity / length / header coverage

- **Firmware-resident self-check over flash — Not found.** Scope: MAIN reset path
  (`sub_20D8` is a 5× delay loop calling `sub_246C`, then `sub_20EA` — no wide
  flash read/accumulate), and the settled negative that neither core writes or
  self-verifies its own flash (RESUME-DEEP; MAIN_FULL 3899 funcs, SUB 3806 funcs).
  A later addition in the erase region triggers no on-radio integrity failure.
- **Boot-ROM / update-tool checksums — Found (2), external to the images.** The PC
  updater drives the Renesas boot ROM: MAIN H8S **checksum request `0x4B`** (host
  builder `0x404060`), SUB RX64M **finalise/checksum `0x4D`** (doc-10 §4–5). These
  are boot-mode verify commands computed over the user-MAT flash actually
  programmed; they recompute over whatever bytes are written, so they bind the
  update tool, not the placement of an addition. The `RES_UPDATE_INFO` resource in
  the updater EXE declares image size MAIN `0x00100000` / SUB `0x00400000` (full
  images, incl. erase fill), SUB span `0xFFC00000`–`0xFFFFFFFF`, and a 16-byte ID
  code that is **all zero** (no boot-mode protection on either part) — these live
  in the EXE resource, not in the on-disk `.bin`, and are cited as context only.
- **ID-code / option-setting block inside the image — Not found** (scope: both
  full images). H8S/RX ID-code protection lives in boot-ROM-managed config, all
  zero per doc-10, not in the application flash.

## Extension — what a later owner feature would attach to

- **MAIN code/data:** the 542,892 B erase region `0x07B754`–`0x0FFFFF`.
- **SUB code/data:** the 718,242 B erase region `0xFFF509DE`–`0xFFFFFF7F` (attach
  above `0xFFF509DD`, the true content top — **not** at `0xFFF50000`). Leave the
  last 128 B (`0xFFFFFF80`–`0xFFFFFFFF`) for EXTB.
- **Interrupt capacity:** 226 free MAIN vector slots, 198 free SUB INTB RTE stubs
  to repoint (plus 40 null INTB slots).
- **RAM headroom:** SUB ~82 KB above the stack (`0x0006B8FC`–`0x0007FFFF`,
  Inferred from 512 KB SRAM); MAIN ~1.3 KB below `0xFFBFFF`.
- **No blocker:** no firmware self-checksum sits over any of the above; only the
  update tool's own verify pass must include the new bytes.

## Counts

- MAIN free: **largest run 542,892 B** (`0x07B754`–`0x0FFFFF`); total ≥64 B
  **547,923 B** (FF 544,147 / 00 3,776).
- SUB free: **largest run 718,242 B** (`0xFFF509DE`–`0xFFFFFF7F`); total ≥256 B
  **977,470 B** (FF 763,214 / 00 214,256); **inside code window 283 B** (1 run).
- RAM high-water: **MAIN `0xFFBCB5`**, **SUB `0x0006B8FC`** (stack top; data store
  ceiling `0x00069794`).
- Dummy-handler vector slots: **MAIN 226/256**, **SUB INTB 198/256**, **SUB EXTB
  31/32**.
- Integrity checks covering flash: firmware-resident **0** (Not found); boot-ROM /
  update-tool verify **2** — MAIN `0x4B` (host `0x404060`), SUB `0x4D`.

## Open

1. Byte-map the `0xFFF50000`–`0xFFF509DD` SUB code block into functions (it is
   above the window every prior lane analysed, so it may be uncovered).
2. Confirm the exact on-chip RAM size of both parts (bounds true RAM headroom);
   currently Inferred from addressed extent + part family.
3. The 286 SUB `0x00` runs below `0xFFED0000` are counted as fill but most are
   data-table padding; a content/entropy pass would separate truly-free zero
   regions from structural padding if that space were ever wanted.
