# 131 — The 300 B near-duplicate EP0 handlers `0x076ADE`–`0x076C09` (lane N4)

Owner-side, strictly read-only static analysis of the ver 1.02 images already on disk. Nothing was
written, flashed, transmitted, or connected to any radio or device; no image byte was changed; no shared
database was opened; no device was enumerated. MAIN is H8SX, big-endian, base 0, so file offset = mapped
address for every MAIN cite below. Model: **claude-opus-5-5** (exact model ID `claude-opus-5-5`).

Tables in `ida\out\ep0-duplicates\`: `classification.tsv` (per-routine byte classification),
`inbound-edges.tsv` (inbound edge verdict by class), `verify.py` (23 byte-cites re-read from the image,
**0 mismatch**), and `work\` (`disasm.txt` annotated range ±0x30, `heads.tsv` 88 heads, `xrefs.tsv`
every code xref into the range, `edges.tsv` the whole-image byte-scan, `callees.tsv`, `SUMMARY.txt`).
IDA job `ida\jobs\n4_ep0.py`, DB `N4_EP0` seeded `--copy-from M1_MAIN_FINAL6`, idat exit 0, no traceback.

Image sha256 checked at start and finish of the lane, unchanged: MAIN
`8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce`, SUB
`b93570b3c2f69ccb51c113c893b4bc4c414cf78ceddde478748404e0768c6230`.

## Verdict

The range is **300 bytes of dead code: two well-formed but unreachable near-duplicate EP0 handlers.** It
holds exactly two routines — **Handler A `0x076ADE`–`0x076B1F` (66 B)** and **Handler B
`0x076B20`–`0x076C09` (234 B, with `0x076B4E` as an internal continuation of B)** — each a byte-level
near-duplicate of the *live* EP0 handlers that sit immediately above it in the same CDC module block
(`0x0767BE`–`0x076ADC`, reached via the handler-record table). **Neither routine head has any inbound edge
of any class.** A whole-image scan over all eight edge classes (intra-block flow/fall-through, rel8, rel16,
bsr16, abs24 `jsr` 0x5E, abs24 `jmp` 0x5A, BE32 pointer, BE24 pointer) finds **zero** edges into the range
from outside it: IDA records 89 code xrefs into the range and **all 89 are internal**; no `0x5E`/`0x5A`
targets the range; and **no BE32 or BE24 value anywhere in the 1 MB image equals either entry address**
`0x00076ADE` or `0x00076B20`. The handler-record table at `0x07B4B4` (the only indirect mechanism that
reaches this module) points to `0x0784BE`/`0x0769AA`/`0x0768C8`/`0x0767BE`/`0x0768A8` — all below the
range (verify.py). Every byte decodes as valid H8SX code, so **no byte is data**. This closes doc 119's
Open #1 and doc 42's Open #3: the near-duplicate block is **not** reached in DSP-WRITE mode or anywhere
else. Both proposed deltas against the FINAL7 masks are **zero** (named already covers all 300 B; proven
correctly leaves all 300 B clear, which my dead-code verdict confirms).

## Method

One private DB, `N4_EP0`, seeded `--copy-from ida\db\jobs\M1_MAIN_FINAL6\M1_MAIN_FINAL6.i64`, run once
through `ida\run_job.py` (job `ida\jobs\n4_ep0.py`, exit 0, no traceback). The job: (1) force-decodes the
wide neighbourhood `0x076600`–`0x077240` following instruction lengths, so every short/long relative
branch is materialised; (2) dumps 88 heads of the range (`heads.tsv`) and the annotated disassembly
(`work\disasm.txt`); (3) collects every code xref into each byte of the range and splits internal vs
external (`xrefs.tsv`); (4) runs an independent whole-image (`0x0`–`0x100000`) byte scan for every inbound
edge class — rel8 (`0x40`–`0x4F`, `0x55`), rel16 (`0x58 cc`), bsr16 (`0x5C 00`), abs24 `jsr`/`jmp`
(`0x5E`/`0x5A`), BE32 and BE24 pointer values — reporting each hit whose target lands in `[0x076ADE,
0x076C09)` (`edges.tsv`); (5) dumps outbound call targets (`callees.tsv`).

Independently of IDA, `verify.py` re-read **23 load-bearing byte runs** straight from
`decrypted\FT3D_MAIN_ver102_EXP.bin` (sha256 re-checked, unchanged): the two routine heads, the internal
branch instructions and their computed targets, the routine exits, the outbound `jsr` sites, the live
return `0x076ADC` that terminates the preceding block, the live request-parser head `0x076C0A` that
follows the range, and all six handler-record `+6` pointers at `0x07B4B4`. **0 mismatch**, and the table
walk confirms **no handler-record pointer targets the range**.

**Scope / not done.** The outbound callees (`sub_7837C`/`sub_78334`/`sub_783DA`/`sub_7823C`/`sub_7821E`,
all window-internal, `0x078xxx`) were read only to name the edge, per doc 95. Indirect dispatch through a
register-loaded pointer is excluded by the BE32/BE24 result (no pointer to either entry exists to load).
No host code was written or run; no device was touched.

## Findings

### 1. Layout: two routines, and what they duplicate (Confirmed)

The live CDC handler block `0x0767BE`–`0x076ADC` ends at `0x076ADC 54 26 rts/l er4-er6` — a clean return,
**no fall-through** into `0x076ADE`. The range then holds:

| routine | span | bytes | frame | exits | duplicates (live) |
| --- | --- | ---: | --- | --- | --- |
| **Handler A** | `0x076ADE`–`0x076B1F` | 66 | `push.l er2` / `rts/l er2` | `0x076B0A`, `0x076B1E` | the EP0-IN path at live `0x076AA2`–`0x076ADC` / `0x0769AA` |
| **Handler B** | `0x076B20`–`0x076C09` | 234 | `push.w r2` / `pop.w r2`;`rts` | `0x076BF0`, `0x076BF8`, `0x076C08` | the EP0-OUT + SETUP-direction decode at live `0x076A60`–`0x076A92` / `0x0768C8` |

Both reproduce the live idioms exactly — stride-`0x14` endpoint record index onto base `0xFF6304`
(`0x076AE2`/`0x076B32`/`0x076B74`), the `and.w #0x400, e0` EP-interrupt test, IFR0 acks `#0xF8`/`#0xFE`/
`#0xFB`/`#0xFD` at `@0xFFEE00`, `ep0_state` clear `@0xFF6314`, TRG `@0xFFEE2C`, IER `@0xFFEE04/05/06`, and
the SETUP-direction read `@0xFEE000/01` + `and.b #0x60` + `cmp.b #0x20` (`0x076BC8`–`0x076BE8`, identical
to live `0x076A60`–`0x076A86`). **But the frame convention differs**: the live handlers return `rts/l
er4-er6` (entered with `er4-er6` stacked by the record-demux caller), whereas Handler A/B save and restore
only `er2`/`r2` themselves. That makes A and B *independent, separately-compiled* routines, not demux-
called handlers — i.e. duplicate copies, consistent with compiler-emitted/leftover library code.

### 2. Internal control flow — fully resolved, self-contained (Confirmed)

Every one of the 89 code xrefs into the range is internal (`xrefs.tsv`; `SUMMARY.txt` reports 0 external).
The non-fall-through internal branches (byte-verified targets):

- Handler A: `0x076AF4 beq → 0x076B0C`.
- Handler B: `0x076B2A beq → 0x076B4E`; `0x076B5A beq.w → 0x076BFA`; `0x076B70 beq.w → 0x076BF2`;
  `0x076BD4 bne → 0x076BD8`; `0x076BE2 bne → 0x076BE6`; `0x076BE8 beq → 0x076C06`.

`0x076B4E` (doc 42's "live intra-module branch target") is reached **only** from `0x076B2A`, inside
Handler B, and its three exits (`0x076BF0`/`0x076BF8`/`0x076C08`) all `pop.w r2; rts`, balancing the
`push.w r2` at the `0x076B20` entry. So `0x076B4E` is a continuation of Handler B's body, not a routine —
it is live *relative to B*, but inherits B's unreachability. This refines doc 42: the branch edge is real,
the enclosing block is dead.

### 3. Inbound edges — none from outside, all classes (Confirmed)

`inbound-edges.tsv` gives the verdict per class; `edges.tsv` has every raw byte-scan hit.

- **flow / fall-through, rel8, rel16, bsr16:** 0 external. The preceding instruction is a return
  (`0x076ADC`). IDA's instruction-aligned xref set has 0 external crefs. The byte scan's only
  outside-sourced rel8 candidates, `0x076C19` (`48 A8`) and `0x076C23` (`40 A8`), are **mid-instruction**:
  they are the `a8`-prefixed `cmp.b` immediates of the request dispatcher (`0x076C1A a8 80`,
  `0x076C24 a8 20`, doc 119), not branch opcodes — IDA records no cref from either.
- **abs24 `jsr` (0x5E) / `jmp` (0x5A):** 0 hits anywhere in the image targeting the range.
- **BE32 / BE24 pointer:** **no value anywhere equals `0x00076ADE` or `0x00076B20`** (the two entry
  points). The 27 pointer-shaped hits all target *mid-routine* interior addresses (`0x076B84`,
  `0x076B8C`, `0x076BA0`, `0x076BA4`, `0x076C00`, `0x076B07`, `0x076B8D`) and are operand- or table-
  straddle coincidences — e.g. `0x0351A0` is an ascending 16-bit offset table `07 6B / 07 88 / 07 AE …`
  whose entry boundary the 3-byte scan straddles. A pointer into mid-instruction interior is not a call
  target. This matches doc 72's whole-image result ("no in-scope pointer reaches that cluster"; the only
  inbound pointers are the window records to `0x0769AA`/`0x0768C8`/`0x0768A8`).
- **handler-record table `0x07B4B4` (+6 pointer):** six entries → `0x0784BE`/`0x0769AA`/`0x0768C8`/
  `0x0769AA`/`0x0767BE`/`0x0768A8`; **none in range** (verify.py table walk).

### 4. Byte classification (Confirmed)

| range | bytes | classification |
| --- | ---: | --- |
| `0x076ADE`–`0x076B1F` (Handler A) | 66 | **dead code** — valid, unreachable near-duplicate EP0-IN handler |
| `0x076B20`–`0x076C09` (Handler B, incl. `0x076B4E`) | 234 | **dead code** — valid, unreachable near-duplicate EP0-OUT/SETUP-direction handler |
| — | 0 | data (none; the whole range decodes as code with balanced frames and resolved branches) |

### 5. Delta against the FINAL7 masks (proposals only — masks/seeds unchanged)

Measured against `ida\out\m-wave-recon\final7_{proven,named}_mask.bin`:

- **Proven delta: 0 B.** All 300 B are clear in the proven mask, and the dead-code verdict confirms they
  **should stay clear** (proven = reached; this range is unreached). This confirms doc 119's decision to
  exclude the range from its `+1,778 B` proven proposal was correct.
- **Named delta: 0 B.** All 300 B are already set in the named mask (run `0x076ADE`–`0x076C0A`). Nothing
  to add.

Disjoint ranges for both deltas: **none**. Sum: **0**.

## USB relevance

This adds no device, no descriptor, and no sample path. The two routines are unreachable duplicate copies
of EP0 handlers the radio already runs live elsewhere in the CDC module; they introduce no new USB
endpoint, no new control request, and no new host-reachable entry. They cannot be invoked by a host or by
any firmware path, so they do not widen the MAIN USB surface, which remains exactly the two personalities
of docs 64/119 (vendor `26AA:0001`, CDC `26AA:0020`). They carry no ADC/DMA/isochronous source, so they
are irrelevant to Q2 (USB SDR). They touch only the same `0xFFEExx`/`0xFEE0xx`/`0xFF6xxx` USB-module
registers and RAM as the live handlers — no flash-control register — so they are consistent with BRIEF
correction 7 and add nothing to Q3 beyond what doc 119 already established.

## Open (most valuable first)

1. **Provenance (low value, cosmetic).** Confirm whether A/B are a compiler-emitted duplicate pair of the
   live `0x0769AA`/`0x0768C8` handlers (same source, two emissions) or hand-leftover — compare the live
   and dead bodies instruction-for-instruction. Does not change reachability or any mask.
2. **Cross-link with N2/N1.** If a sibling N-lane finds a RAM-resident dispatch vector initialised from
   `.data` that this scan could not see as a static pointer, re-test `0x076ADE`/`0x076B20` against it; the
   present result already excludes every static pointer form, so this is a completeness check only.
