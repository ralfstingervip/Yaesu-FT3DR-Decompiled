# C-reconstruction wave (wave C): lane brief

The byte-coverage work is finished (convention D 99.9589%, see `docs/resume.md`). What
`docs/deep/BRIEF.md` calls the owner's real deliverable is still thin: hand-reconstructed C exists
for only three routines (`ida/out/c-recon/`). This wave turns the disassembly of **every function**
into readable, commented C, one address range per lane.

Ground rules are unchanged: owner-side **static** analysis only. Nothing here talks to a radio, a
serial port or USB. No firmware image is in the repo, and none is needed for this wave.

## Your input

- Your listing chunk: `$SCRATCH/chunks/<lane>.lst` (path given in your prompt). It is every
  function in your range, rebuilt by `decomp/tools/build_listings.py` from the IDA dumps under
  `ida/out/`. Each function starts with `;=== <start>-<end> <name> size N`. `.data N` lines are
  inline data heads.
- Whole-image listings for cross-reference (callees outside your range):
  `$SCRATCH/listing/main/*.lst`, `$SCRATCH/listing/sub/*.lst`.
- Prior knowledge: `docs/deep/BRIEF.md` (hardware map, H8SX / RX encoding traps),
  `docs/INDEX.md` and `docs/deep/*.md`. Grep the docs for your addresses
  (e.g. `grep -rn "05540C\|0x05540C" docs`) before naming anything: many functions and RAM
  cells already have names and proven meanings. Reuse them; do not contradict a doc without
  saying why.
- Style reference: `ida/out/c-recon/l15_tx_gate.c` and `l15_usb_vendor.c`.

## Cores, in one paragraph each

- **MAIN**: H8SX (IDA `h8s300a`/`h8sxa` text), big-endian, base 0. Renesas H8S/H8 C compiler.
  Arguments arrive in `er0`, `er1`, `er2` (r0/r1/r2 halves for 16-bit, r0l etc. for bytes);
  return in `er0`/`r0`/`r0l`. `er3`–`er6` are callee-saved; `er7` is SP. `@0xFFxxxx:16/32`
  absolute operands are on-chip RAM/IO; `FFEE00`–`FFEE53` is the USB function module;
  `FFFF88` is SCI to the DSP. `jsr @@n` is a vector-table call.
- **SUB**: RX64M (CC-RX), little-endian, mapped at `0xFFC00000`. Arguments in `r1`–`r4`, return
  in `r1`, `r6`–`r13` callee-saved, `r0` SP. `push`/`pushm`/`popm`/`rtsd` frame idioms.
  Peripheral space is `0x00080000`–`0x000FFFFF`; RAM is low addresses.

## What to write

Into `decomp/<core>/<lane>/` (create it; write **nothing** outside that directory):

1. `<lane>.c`: every function in your chunk, in address order. For each function:
   - a header comment: address range, size, the name you give it (snake_case, descriptive; keep
     the IDA `sub_XXXX` as an alias in the comment), callers if known, one-paragraph purpose;
   - a C body that is a faithful hand-decompilation: real control flow, real constants, globals as
     named `extern` variables (declare them once at the top with their address in a comment),
     calls by their new names. Prefer clarity over line-for-line transliteration, but never invent
     behaviour. Where a routine is too large or too opaque to finish, write the skeleton and a
     `/* TODO(waveC): ... */` saying what is left; do not silently skip it.
   - tiny helpers (≤ 4 instructions, thunks, `rts`-only stubs) may be one-line macros or one-line
     functions.
   - Mark each function's confidence in its header: `Confirmed` (traced fully), `Inferred`
     (meaning guessed from context), or `Skeleton`.
2. `functions.tsv`: tab-separated `start  end  ida_name  new_name  confidence  summary` for every
   function in your chunk (header row included). This is the file the parent merges.
3. `globals.tsv`: `addr  name  width  meaning  evidence` for each RAM/IO cell you named.
4. `NOTES.md`: at most ~80 lines. What the range is (subsystems), the most interesting findings,
   anything that contradicts an existing doc, and what is left undone.

The C is documentation. It does not need to compile, but it should be syntactically plausible C99
with `<stdint.h>` types (`u8`, `u16`, `u32`, `s8`... typedefs at the top are fine).

## Rules

- Do not run `git`. Do not edit any file outside your own `decomp/<core>/<lane>/` directory. The
  parent commits.
- Cover **all** functions in your chunk. Breadth first: get every function a header and at least a
  skeleton, then go back and deepen the important ones.
- Do not quote large manufacturer tables or strings verbatim; short strings needed to identify a
  screen or message are fine.
- If you finish early, deepen: resolve callees, name globals, turn Skeletons into full bodies.
- Your final message to the parent: number of functions covered, counts by confidence, the 3–5
  most notable findings, and anything left undone. Keep it under 25 lines.
