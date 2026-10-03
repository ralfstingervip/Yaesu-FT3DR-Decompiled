# 25 — Calling convention and the IPC call path (Lane 8)

Owner-side static analysis of the two decrypted radio images on disk. No device,
serial, USB or flash access; nothing was written to a radio. MAIN offsets equal
mapped addresses (base 0, big-endian, `h8s300a`). SUB is RX little-endian, base
`0xFFC00000` (file offset = address − `0xFFC00000`). Machine-readable dumps under
`ida\out\abi-ipc\` are named in-line.

## Verdict

Both cores use the stock Renesas ABIs, unmodified. **MAIN (H8S/H8SX C compiler):**
arguments in **ER0** (then ER1/ER2), return in **ER0/R0/R0L** — with a large share
of predicate helpers returning status in the **CCR** instead; **ER0–ER3 caller-saved,
ER4–ER6 callee-saved, ER7 = SP**; stack grows down via `@-sp` pre-decrement with
`stm.l`/`push`; calls are overwhelmingly `jsr @aa:24` absolute (5820) or `bsr` (753),
with `jsr @ern` (56) for indirect and exactly **one** `jsr @@aa:8` memory-indirect
vector call. A hand-written assembler HAL layer (bit-bang I/O, frame builders) coexists
and uses R4 as its scratch/return register — a new C routine must treat those as
clobber-everything. **SUB (Renesas CC-RX):** arguments in **R1–R4** (R1 dominant),
return in **R1**; **R6–R13 callee-saved** (with R14/R15 preserved when used), **R0 = SP**;
frames via `add #-imm, sp, sp` and released with **`rtsd`** (which also pops the saved
register block); `bsr` for direct calls; RX hardware MUL/DIV/FPU means there is no
prominent `__mul`/`__div` runtime helper.

The MAIN→SUB link is one checksummed frame protocol over SCI_6 (`0xFFF610`) → SUB SCI0
(`0x0008A000`). **A new MAIN routine sends a frame not by passing registers but by
filling a fixed RAM staging mailbox at `0xFF3D72` (total len), `0xFF3D74` (opcode, BE),
`0xFF3D76` (len = total−10), `0xFF3D7A`+ (payload) and calling `sub_B6B6` (`0x0000B6B6`)
— which takes no register arguments.** On the SUB side the receive dispatcher is
**`sub_FFEDF1D8`** (`0xFFEDF1D8`), a 16-slot opcode-family table (`jpt_FFEDF1F6`,
opcodes `0xF0`–`0xFF`); **12 of 16 families are implemented, 4 are unused** (`0xF9`–`0xFC`).
The `0xF0` family fans out through `sub_FFEDF269` (`0xFFEDF269`), a 12-slot sub-table
(`jpt_FFEDF290`, `0xF000`–`0xF00B`) with all 12 slots used.

## Method

Two private IDA 9.1 databases via `run_job.py --copy-from`: `ABI_IPC_MAIN`
(from `MAIN_FULL`, 3899 funcs) and `ABI_IPC_SUB` (from `SUB_VEC`, 3806 funcs). Scripts
`ida\jobs\full_l8_main_abi.py`, `full_l8_main_abi2.py`, `full_l8_main_abi3.py`,
`full_l8_sub_abi.py`, `full_l8_sub_xref.py`. Outputs:
`ida\out\abi-ipc\MAIN_abi.txt`, `MAIN_abi2.txt`, `MAIN_abi3.txt`, `SUB_abi.txt`,
`SUB_xref.txt`.

Ran, over the whole function set of each core: a prologue/epilogue register-save census
(`stm.l`/`ldm.l`, `push`/`pop` on MAIN; `pushm`/`popm`/`rtsd` on SUB); a function-terminator
census; a live-in register census on the entry block (register read before written =
candidate argument); a call-site addressing-mode census; a call-frequency ranking to
surface runtime helpers; and full disassembly of the IPC send builder + DMA driver on
MAIN and the receive dequeue/dispatch chain + handler tables on SUB. Return-register
determination was cross-checked by classifying the single instruction after every call
site (branch-on-flags vs. reads-R0 vs. overwrites-R0).

Not run: no Hex-Rays (none exists for H8S/RX); the SUB→MAIN return byte-stream parser
(`0x47560` consumer, doc-09) was not re-reversed — out of this lane's scope. The DSP
boot personality and loader stay closed per session rules; `0xF008`/DSP-WRITE is cited
only as an already-settled opcode example, not followed into the loader.

## Findings

### 1. MAIN calling convention (H8S / Renesas H8S,H8/300 C/C++ compiler)

**Register roles (confirmed by the census + representative functions):**

| Reg | Role | Evidence |
| --- | --- | --- |
| ER0 | 1st argument + return value | live-in in 441 funcs (top); `sub_20AF6` `0x20AFA` reads its arg struct as `mov.w @(0xA:16,er0),r1`, writes back `@(0xC:16,er0)`; callers read R0/ER0 after calls to consume returns (`MAIN_abi3.txt`) |
| ER1, ER2 | further args / work | live-in 99 / 93 funcs |
| ER3 | work / scratch | high live-in count is partial-register aliasing noise |
| ER4, ER5, ER6 | **callee-saved (guaranteed)** | `sub_3347E` `0x3347E`: `stm.l er4-er6,@-sp` … `ldm.l @sp+,er4-er6; rts` around a `bsr`; 16 funcs save er4-5/er4-6 with matching `ldm` epilogues (17× `ldm er4-er6`, 11× `ldm er4-er5`) |
| ER7 | stack pointer | never saved (0 occurrences) |

- **Caller-saved / argument set ER0–ER3:** 194 functions open with `stm.l er0-er3,@-sp`
  and close with `ldm.l @sp+,er0-er3; rts` (e.g. `sub_1CD26` `0x1CD26`) — they preserve
  the volatile argument registers across internal calls. This is the idiom
  `compiler.md` flagged.
- **Return in CCR is common.** Over all 6590 call sites, the single next instruction is a
  conditional/again branch 44.2% of the time and reads R0/ER0 only 2.2% — many predicate
  helpers (e.g. `sub_1C82E` `0x1C82E`, `sub_3F5EE`) return the result in the condition
  flags (caller branches `beq`/`bne`/`bcs` directly) and/or in R4L.
- **Two code layers.** Compiler C functions follow the table above. A **hand-written
  assembler HAL** (e.g. `sub_3AB80`/`sub_3AD20` — bit-bang serial with hundreds of `nop`
  timing pads on port `0xFFFFFBA4`; `sub_3FFA0`, `sub_7C20` frame builders) uses R2–R6 as
  free scratch, ignores ER4–ER6 callee-save, and returns in R4L. A new C caller must
  treat any call as clobbering all volatiles.
- **Stack / frame:** grows down; saves via `@-sp` pre-decrement (`stm.l`, `push.w`,
  `push.l`). No large `sub #imm,sp` frame allocations were seen in prologues — locals are
  register-resident or minimal; `push.w`/`push.l` spill single values (e.g. `sub_8532`
  `0x8532` `push.w r3` … `pop.w r3`).
- **Terminators:** `rts` 3073, `rte` 29 (ISRs), `bra`/`jmp` tail-calls 334/84.
- **Call reach:** `jsr @aa:24` absolute 5820, `bsr` (pc-rel) 753, `jsr @ern` (register-
  indirect, e.g. dispatch through a pointer) 56, and exactly one `jsr @@aa:8`
  memory-indirect (vector-table) call in the whole image.
- **Runtime/most-called helpers (MAIN):** these are application/HAL routines, not
  arithmetic runtime — top: `sub_3FFA0` (263 callers, reset a UI flag block),
  `sub_7C20` (114, `0xF0` status-frame payload filler), `sub_3AB80`/`sub_3AD20`
  (77/55, bit-bang I/O), `sub_3F5EE`/`sub_3F5B2` (range-check predicates returning in
  CCR/R4L). No `__mul`/`__div` thunk dominates — the H8S multiply/divide are inline.

### 2. SUB calling convention (Renesas CC-RX)

| Reg | Role | Evidence |
| --- | --- | --- |
| R1–R4 | arguments (R1 first) | live-in 1340 / 770 / 544 / 188 funcs; `sub_FFEFB268` memcpy takes dst=R1, src=R2, count=R3 |
| R1 | return value | dispatchers end `movu.b r1,r1; rtsd` returning the result in R1 (`sub_FFEDF1D8` `0xFFEDF267`) |
| R5, R14, R15 | scratch (R15/R14 also preserved when used) | `pushm r14-r15` in 14 funcs with matching `popm` |
| R6–R13 | **callee-saved** | `pushm r6-r7` (31), `r6-r13` (13), `r6-r14` (9), `r6-r9`/`r6-r10` (6/5); `rtsd #Ch, r6-r6` pops the saved block on return |
| R0 | stack pointer | `add #-imm, sp, sp` frames; `rtsd` releases them |

- **Frames:** allocated with `add #-imm, sp, sp` (e.g. `sub_FFEF1B23` `add #-14h,sp,sp`),
  arguments spilled to stack; released and returned in one op by **`rtsd #imm`** (1857
  functions end in `rtsd`; the `rtsd #imm, r6-rN` form also restores callee-saved regs).
  Plain `rts` 316, `rte` 222 (ISRs).
- **Calls:** `bsr` 8863 (direct pc-rel), `jsr rN` 309 (register-indirect / table dispatch).
- **Runtime helpers:** RX64M has hardware MUL/DIV and an FPU, so CC-RX emits no
  `__mul`/`__div` helper; inline `mul #imm,r1` and `div` are used directly (e.g.
  `0xFFEEFA17 mul #25800h,r1`). The startup runtime is `_INITSCT` `sub_FFF45DBC` (from
  `resetprg`, per `compiler.md`). The generic **memcpy is `sub_FFEFB268`**
  (`memcpy(r1=dst, r2=src, r3=count)`, byte loop, `rtsd #5`). The most-called routines
  (`sub_FFEF1B23` 414, `sub_FFF1EE20` 394, `sub_FFEF1C48` 270 …) are application
  accessors, not arithmetic runtime.

### 3. The IPC frame and the MAIN send function

**Physical (confirmed, corroborates doc-09):** MAIN **SCI_6** `0xFFF610` (TDR `0xFFF613`),
init `sub_446BE` (`0x446BE`: SCR `0xFFF612`=`0x30`, then TIE via `bset #6`); TX by **DMAC
ch0** in `sub_482D4` (`0x482D4`: DAR=`0xFFF613`, MAR=source, count word, trigger
`0xFFFD20=0xE1`, then `bset #7 @0xFFF612`). SUB end = SCI0 `0x0008A000`, opened by
`sub_FFEDAB4C`.

**Frame builder `sub_B6B6` (`0x0000B6B6`) — the send API. No register arguments.** The
caller fills a fixed RAM staging mailbox and calls it:

| Field | Addr | Meaning | Set by |
| --- | --- | --- | --- |
| total | `0xFF3D72` word | transmitted byte count from opcode; `sub_B6B6` returns early if 0 | caller |
| opcode | `0xFF3D74` word, **big-endian** | e.g. `0xF008`, `0xF000`, `0xF3D6`, `0xFC00` | caller |
| len | `0xFF3D76` word | nominal length = total − 10 | caller |
| hdr_cksum | `0xFF3D78` word | byte-sum of the 4 bytes at `0xFF3D74` (opcode+len), BE | **sub_B6B6** (`0x B718–B736`) |
| payload | `0xFF3D7A` + | family-specific | caller (often via a filler, e.g. `sub_7C20`) |
| frame_cksum | `0xFF3D74 + (total−8)` word | byte-sum of (total−8) bytes from `0xFF3D74`, BE | **sub_B6B6** (`0xB73C–B766`) |
| pad | after cksum | six `0x00` bytes | **sub_B6B6** (`0xB76A–B776`) |

`sub_B6B6` then: (a) optionally mirrors the whole block to `0xFF95F8` for the DATA-jack
pass-through when `0xFFBC2B.0` is set; (b) **de-duplicates** against the last frame at
`0xFF4176` — an identical frame is dropped unless the force flag `0xFFBBE5` ≠ 0
(`0xB776`–`0xB79A`); (c) copies the frame to the active TX buffer `0xFF4176` (length in
`0xFF4174`), sets `0xFFBBE4=1`, and calls `sub_482D4` (DMA ch0) with `er5 = 0xFF4176`
(source) and `r3` = length; (d) clears `0xFF3D72` to release the mailbox.

**Worked example** (`sub_8532` `0x8532`, the DSP-write status frame — cited only as a
byte example): `0xFF3D72=0x2A`, `0xFF3D74=0xF008`, `0xFF3D76=0x20`, payload via
`sub_7C20`, phase→`0xFF3D94` (+0x20), progress→`0xFF3D95` (+0x21); frame checksum lands
at `0xFF3D96`, 6 zero pad at `0xFF3D98`–`0xFF3D9D`, 42 bytes transmitted from `0xFF3D74`.

**Confirmed callers** all follow the same contract: set `0xFF3D72/74/76`, fill payload,
optionally set `0xFFBBE5=1` to force send, then `jsr sub_B6B6` — e.g. `sub_7FCE`
(opcode `0xF000`, `0x28`/`0x1E`), `sub_D2B2` (`0xF3D6`, `0x4C`/`0x42`), `sub_D53A`
(bulk `0xFC00`, variable, via filler `sub_71196`). This is the exact template a new MAIN
routine must match; the send is a memory-mailbox ABI, not a register-argument call.

### 4. SUB receive dispatcher and opcode table

Receive path (all confirmed): SCI0 RX callback `sub_FFEDB131` assembles bytes into a
4-deep, 300-byte-slot ring (control block base `0x00012D44`, per-slot stride `0x12C`);
the main-loop pump `sub_FFF36CA2` calls the **dequeue `sub_FFEDC1F6`** (`0xFFEDC1F6`),
which mirrors the frame's first two bytes to `0x84C8/0x84C9` and copies the 300-byte slot
to the pending buffer **`0x8E46`** via `sub_FFEF0385` → `sub_FFEFB268`
(`memcpy(0x8E46, slot, 0x12C)`).

**Top-level dispatcher `sub_FFEDF1D8` (`0xFFEDF1D8`), called from frame processor
`sub_FFEDF016` (`0xFFEDF037`).** It reads the opcode high byte at `0x8E46`, subtracts
`0xF0`, bounds-checks `≤ 0x0F`, and jumps through the 16-entry byte table
**`jpt_FFEDF1F6`**:

| Opcode | Slot | Handler | Status |
| --- | --- | --- | --- |
| `0xF0` | 0 | `sub_FFEDF269` (F0 sub-dispatch) | implemented |
| `0xF1` | 1 | `sub_FFEDF2E0` | implemented |
| `0xF2` | 2 | `sub_FFEDF36A` | implemented |
| `0xF3`,`0xF4` | 3,4 | `sub_FFEDF3A7` (shared) | implemented |
| `0xF5` | 5 | `sub_FFEDF447` | implemented |
| `0xF6` | 6 | `sub_FFEDF4B8` | implemented |
| `0xF7` | 7 | `sub_FFEDF53E` | implemented |
| `0xF8` | 8 | `sub_FFEDF56F` | implemented |
| `0xF9`–`0xFC` | 9–12 | default (no-op) | **unused** |
| `0xFD` | 13 | `sub_FFEDF61B` | implemented |
| `0xFE`,`0xFF` | 14,15 | `sub_FFEDF645` (shared) | implemented |

So **16 opcode-family slots, 12 implemented, 4 unused (`0xF9`,`0xFA`,`0xFB`,`0xFC`).**
(The bulk settings/memory block `0xFC00` is not applied here — it lands via the pending
buffer and the field-by-field apply `sub_FFEF4142`; `0xFC` is genuinely dead in this
dispatcher.) Each family handler re-verifies its exact high byte, then sub-dispatches on
the opcode low byte at `0x8E47`.

**F0 sub-dispatcher `sub_FFEDF269` (`0xFFEDF269`)**: verifies `0x8E46 == 0xF0`, reads the
low byte at `0x8E47`, bounds-checks `≤ 0x0B`, jumps through the 12-entry table
**`jpt_FFEDF290`**. All 12 slots (`0xF000`–`0xF00B`) are used, mapping to UI screen ids
(`0xF002`→0x12 … `0xF008`→0x18 "DSP WRITE" … `0xF00B`→0x1B). **12 slots, 12 implemented,
0 unused.**

(The pointer table at `0xFFED4050` referenced by earlier docs is the UI *screen-handler*
table indexed by screen id — most-common target `sub_FFF0CDFC` ×7 — not the IPC opcode
table; it is listed in `SUB_abi.txt` for completeness.)

## Extension

A later owner-added feature attaches at two well-defined seams, both matching stock ABIs:

- **To send MAIN→SUB:** a new MAIN routine (compiler C, args in ER0/ER1, return ER0,
  preserve ER4–ER6) writes total/opcode/len/payload into the `0xFF3D72` mailbox, sets the
  force flag `0xFFBBE5=1` if it must not be de-duplicated, and calls `sub_B6B6`
  (`0x0000B6B6`). Choosing an opcode in an **unused SUB family (`0xF9`–`0xFC`)** would be
  dropped silently by `sub_FFEDF1D8` today; a new feature that needs SUB to act must also
  add a handler slot there or reuse an implemented family.
- **To handle it on SUB:** a new CC-RX routine (args R1–R4, return R1, preserve R6–R13)
  is reached by pointing an opcode slot in `jpt_FFEDF1F6` (or a low-byte slot in a family
  sub-table such as `jpt_FFEDF290`) at it; it reads the frame from the pending buffer
  `0x8E46`. This lane maps the contract only; it writes no such routine and emits no
  assembly, per the session boundary.

## Counts

- **MAIN convention:** functions sampled **3899**; clean C-ABI return (`rts`/`rte`)
  3102 = **79.6%**, or **90.3%** including `bra`/`jmp` tail-calls; the remainder are
  IDA-fragmented tails, not ABI violations. Of functions with a recognizable
  save/restore prologue (227), the `stm.l`/`ldm.l` pairs are balanced and use only the
  expected register sets → **100% conforming** where a prologue exists.
- **SUB convention:** functions sampled **3806**; clean return (`rtsd`/`rts`/`rte`)
  2395 = **62.9%**, or **71.6%** including `bra` tail-calls; the shortfall is RX
  auto-analysis fragmentation (functions left ending on a data-like `movu`/`mov`), not
  ABI violations. Prologues that exist (95 `pushm` + `add #-imm,sp` frames) conform 100%.
- **IPC opcodes (SUB side):** top-level family table `jpt_FFEDF1F6` = **16 slots,
  12 implemented, 4 unused (`0xF9`–`0xFC`)**; F0 sub-table `jpt_FFEDF290` = **12 slots,
  12 implemented, 0 unused**.
- **Functions given/confirmed a purpose (for lane reconciliation):**
  - MAIN: `sub_B6B6` `0x0000B6B6` (IPC frame builder/sender), `sub_482D4` `0x000482D4`
    (DMAC-ch0 → SCI_6 TX), `sub_446BE` `0x000446BE` (SCI_6 init), `sub_7C20` `0x00007C20`
    (F0 status payload filler), `sub_8532` `0x00008532` / `sub_976A` `0x0000976A` /
    `sub_5E9E2` `0x0005E9E2` (F0/status-frame builders).
  - SUB: `sub_FFEDF016` `0xFFEDF016` (frame processor), `sub_FFEDF1D8` `0xFFEDF1D8`
    (opcode-family dispatcher), `sub_FFEDF269` `0xFFEDF269` (F0 sub-dispatcher),
    `sub_FFEDC1F6` `0xFFEDC1F6` (IPC ring dequeue), `sub_FFEF0385` `0xFFEF0385`
    (slot→`0x8E46` copy), `sub_FFEFB268` `0xFFEFB268` (memcpy(r1,r2,r3)),
    `sub_FFF36CA2` `0xFFF36CA2` (main-loop IPC pump), and family handlers
    `sub_FFEDF2E0`/`36A`/`3A7`/`447`/`4B8`/`53E`/`56F`/`61B`/`645`.

## Open

1. The SUB→MAIN direction (return byte-stream): its consumer `0x47560` on MAIN and the
   SUB-side transmit path (`sub_FFEDB081` TX callback) were not reversed for opcode/ack
   semantics — the send half of a round-trip contract.
2. Payloads of the four *implemented* non-F0 families (`0xF1`,`0xF2`,`0xF3/F4`,`0xF5`–`0xF8`,
   `0xFD`,`0xFE/FF`) — each handler's field layout was not decoded here (subject of the
   opcode/menu lanes).
3. Whether any of the 4 unused SUB families (`0xF9`–`0xFC`) is referenced by a MAIN
   builder that is itself dead — a cheap cross-check for the function lanes.
