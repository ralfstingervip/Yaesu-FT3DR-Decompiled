# SUB leftovers — window residue, dead orphans, code past the window (Lane I10)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian,
mapped at `0xFFC00000`, file offset = address − `0xFFC00000`). Private DB `I10_SUB`
(`--copy-from ida\db\jobs\H10_SUB\H10_SUB.i64`); no shared DB opened, no image modified,
nothing written to a radio. Model: claude-opus-5-5.

Tables under `ida\out\sub-residue\`:
- `residue.tsv` — all 108 residue runs, summing to exactly 3,833 B (named in §A).
- `past-window.tsv` — the 6 runs of `0xFFF50000`–`0xFFF509DE` (§C).
- `ledger-delta.tsv` — net delta 0 to the headline, with the no-double-count argument.
- `ida_targetC.txt` — IDA function boundaries, caller, and peripheral scan for §C.

## Verdict

The three SUB leftovers are fully accounted for and none of them reopens a mission answer.
**(A)** The 3,833 B window residue is **100 % unreached code** — 3,692 B of dead
application functions, 43 B of code fragments/stubs, and 98 B of duplicate-prologue
slivers. **Zero bytes are truly unknown**, and zero are padding, literal pool, string or
table (those were already typed as the 56,289 B of window data). **(B)** All **52 "dead"
orphans (3,692 B) are confirmed dead** by an independent whole-image byte scan: not one of
their 52 start addresses occurs anywhere in the 4,194,304-byte image as a little-endian
32-bit value or as a 24-bit `mov.l` immediate prefix, none is an INTB/EXTB vector target,
none is a `bra.l` switch target, and the SUB uses no indirect transfer form that could
reach a code address that does not exist as an absolute value somewhere (H10's 359-site
census: 0 `jmp Rn`, 0 `bsr.l Rn`, every `jsr Rn` loads from memory). They are dead
application UI code the CC-RX linker kept, not library code. **(C)** The code past the
window edge is **2,293 B, a single function tail** — `sub_FFF4FABD`, the JPEG decoder,
called from `sub_FFF4B084`; the remaining 233 B are its JPEG de-zigzag / IDCT-cosine /
switch data. **No SUB byte in any of these regions — residue, the 52 orphans, the
past-window tail, or the below-window descriptor block — touches USB0, flash programming
(FCU/FACI), or the SCI0 used for MAIN↔SUB IPC.** My net delta to the headline coverage is
**0**; I confirm 464,166 / 524,288 code and 520,455 code+typed. **Confirmed.**

## Method

- All byte claims below were byte-verified in Python directly against `decrypted\FT3D_SUB_ver102_ALL.bin`
  (sha256 prefix `b93570b3…`, 4,194,304 B), independent of IDA. Scripts kept in the
  session scratchpad (`i10_verify.py`, `i10_verify2.py`, `i10_build_tables.py`), read-only.
- Residue run list regenerated from H8/H10 outputs: `ida\out\sub-phase\orphans.tsv`
  (52 dead orphans), `ida\out\sub-phase\raw\rej2.tsv` (49 unreached slivers), and the
  fragment list in doc 48 §4. `residue.tsv` sums the three to **3,833 B** (108 rows).
- Target B re-test: for each of the 52 orphan starts I scanned **every byte offset** of the
  whole 4 MB image for its LE32 value and for its 3-byte LE prefix (which covers both LE32
  pointers and the RX sign-extended 24-bit `fb ?e` immediate). I decoded all 256 INTB and
  32 EXTB vector slots and checked membership. I cross-read H10's indirect-transfer census,
  RAM-callback census, `0x00012D20` SCI0 block, and switch-edge set rather than re-deriving
  them — my byte scan is the independent check on their conclusion.
- Target C: one IDA pass on `I10_SUB` (`ida\jobs\i10_residue.py`, via `run_job.py`,
  `--copy-from H10_SUB`, `auto_wait`, `qexit(0)`, UTF-8). It listed every function near the
  window edge, the owner and caller of `0xFFF50000`, scanned the full body
  `FFF4FABD`–`FFF50900` for any `o_imm` in `0x00080000`–`0x000FFFFF`, and classified the
  below-window region `0xFFECE51C`–`0xFFED0000`. A Python peripheral scan (`fb ?e` imm24 /
  `fb ?0` imm32 in `0x80000`–`0xFFFFF`) covered the same ranges independently.
- **Not done:** I built no seed (lane I2 owns SUB_FINAL) and created no instructions or
  functions in the DB — every script is read-only. I did not re-run a full 4 MB
  re-analysis; the H10 seed already carries it.

## Findings

### A. The 3,833 B residue is entirely unreached code (`residue.tsv`)

Regenerated exactly from H8+H10 and classified into the brief's vocabulary:

| Class | Runs | Bytes | What it is |
| --- | --- | --- | --- |
| unreached code — dead application function | 52 | 3,692 | `71 00 xx` frame-prologue functions that call application UI routines (`FFF15E96`, `FFF1EE20/7B`, `FFF24FEB`, `FFF2EC2C`…); 24 are a screen-handler clone family |
| unreached code — fragment/stub | 7 | 43 | lone `02` stubs (`FFEE177F`, `FFF3758F`, `FFF375A4`×2, `FFF47E60`), the complete 3-insn stub `FFEF202A` `75 41 28 05 6b c2 fe 02`, and two head slivers (`FFF13DDA` 21 B, `FFF3B8CB` 9 B) |
| unreached code — duplicate-prologue sliver | 49 | 98 | a 2-byte `60 40` (`sub #4,sp`) in front of a validated function that itself begins `60 40`; the previous function ends in `rtsd` and nothing targets the sliver |
| **Total residue** | **108** | **3,833** | 524,288 − 520,455 |

Verified `3,692 + 43 + 98 = 3,833` to the byte. Fragment bytes all read back from disk
(e.g. `FFF13DDA` = `72 00 e0 fe f9 05 8e 00 f9 05 8d 00 3c 84 00 3e 02 00 3e 01 00`).
**Alignment padding / literal pools / strings / tables: none in the residue** — the window's
`0xFF`/`0x00` padding and its `.data`/switch/string data are already in the 56,289 B typed
figure, not here. **Truly unknown: 0 B.** Every residue byte is well-formed RX code whose
only defect is that nothing reaches it. **Confirmed.**

### B. The 52 dead orphans are confirmed dead by an independent scan

Independent whole-image byte scan (my `i10_verify.py`, not IDA):

- **LE32 value anywhere in the 4 MB image:** 0 hits for any of the 52 starts.
- **3-byte LE prefix (= LE32 pointer + RX 24-bit `fb ?e` immediate) at every offset:** 0 hits.
  This explicitly covers ROM pointer tables, the three CC-RX `.data` initialiser images
  `FFED8E70`–`FFEDAB4C` (DTBL at `FFED8A34`, loader `FFF45DE0`), and the below-window pointer
  tables. **No orphan start appears as a stored pointer or an immediate anywhere.**
- **INTB (256) + EXTB (32) vectors:** decoded all 288 slots (217 distinct INTB targets,
  7 EXTB); **no orphan start is a vector target.**
- **Switch tables, relative branches, indirect transfers:** H10's 643 `bra.l` edges hit no
  orphan; its 359-site indirect census has **0 `jmp Rn`, 0 `bsr.l Rn`**, and every `jsr Rn`
  loads its target from memory — so any live code pointer must exist as an absolute value
  that the prefix scan above would have found. My scan is the independent confirmation.

The two orphans H10 recovered stay recovered — I re-decoded both `bsr.w` sites from disk
with the correct 2-byte `pcdsp16`: `FFF366CB` `39 b0 fb` (disp `0xFBB0` = −1104) → `FFF3627B`,
and `FFF4030C` `39 08 00` (disp +8) → `FFF40314`. The 52 remaining are **dead application
code**: each calls application UI routines, none lies in or calls the CC-RX runtime area, so
they are unreferenced application functions the linker retained (Inferred — a general CC-RX
property, not visible in the image). **Not found** (scope: every byte offset of all
4,194,304 bytes, all 288 vectors, all 643 switch edges). Byte delta from re-testing: **0**.

### C. Code past the window edge — `0xFFF50000`–`0xFFF509DD` (`past-window.tsv`, `ida_targetC.txt`)

IDA (`I10_SUB`) shows **no function starts at or above `0xFFF50000`**. The owner of
`0xFFF50000` is `sub_FFF4FABD` (`FFF4FABD`–`FFF50000` in IDA, its body falling through the
segment edge); its sole caller is **`sub_FFF4B084` at `FFF4BA39`** (a call xref). This is the
JPEG/photo-viewer decoder chain (docs 30, 38, 46). Exact delimitation:

| Range | Len | Class | Content |
| --- | --- | --- | --- |
| `FFF50000`–`FFF508F5` | 2,293 | code | tail of `sub_FFF4FABD` (`FFF50000` = `ed 0f 20 af 09 4b fb 06…`, valid RX) |
| `FFF508F5`–`FFF508F8` | 3 | data | `ff ff ff` pad |
| `FFF508F8`–`FFF50938` | 64 | data | JPEG de-zigzag order `00 01 08 10 09 02 03 0a 11 18…` (ref @`FFF4B967`/`FFF4C533`/`FFF4F500`) |
| `FFF50938`–`FFF50954` | 28 | data | 7× u32 IDCT cosines `2D41 2C63 29CF 25A1 1924 1151 08D4` |
| `FFF50954`–`FFF50960` | 12 | data | 12× `01` (ref @`FFF4FAD1`/`…DA`/`…E3`/`…FD`) |
| `FFF50960`–`FFF509DE` | 126 | data | 63× u16 `bra.l` switch table (from `FFF4C470`, bound `cmp #62`) |

**Peripheral touch: none.** Both the IDA `o_imm` scan and the Python `fb ?e`/`fb ?0` scan of
`FFF4FABD`–`FFF50900` return **0** immediates in `0x00080000`–`0x000FFFFF`. No USB0
(`0x000A0000`), no flash (FCU/FACI), no DMAC, no SCI. The content top is `0xFFF509DD`; above
it is a single `0xFF` erase region to the EXTB table (doc 26). This is a **companion figure**
and does not enter the 524,288 denominator; adding it gives window+tail code
466,459 / 526,814 = 88.5 %.

**Below-window `0xFFECE51C`–`0xFFED0000` (6,884 B): data, no code.** IDA leaves it undefined
(0 code bytes), and the byte layout is unambiguous: back-to-back 12-byte RGB565 bitmap
descriptor records `{u16 w, u16 h, u32 pixel_ptr, u16, u16}`, e.g. `FFECE55C`
`1c 00 14 00 80 eb c3 ff 00 00 ff ff` (w=28, h=20, ptr=`0xFFC3EB80`). This is the continuation
of the RGB565 descriptor atlas (docs 16/21/27 — primary base `0xFFECFDCC`), contiguous with
the `FFED0000`–`FFED3F6C` descriptor table doc 21 already typed as data. The two code
pointers doc 46 saw just below (`FFECE50C`/`FFECE514`) sit in the `CALLBACK_REGINIT` block
`FFECE4E4`–`FFECE51C` (doc 27) and point **into** already-credited window code. **No code
below the window edge.** Confirmed.

### D. The new-touch question, answered with scope

After A–C: **no SUB byte in my scope touches USB0, flash programming (FCU/FACI), or the SCI0
MAIN↔SUB IPC channel in any way not already documented.** Scope = the 3,833 B residue
(52 orphans + 43 B fragments + 98 B slivers), the 2,526 B past-window block
`FFF50000`–`FFF509DE`, and the 6,884 B below-window block `FFECE51C`–`FFED0000`. This matches
and extends H8/H10 (the 25,758 B of newly-reached window code also had none). The SCI0 IPC
path remains confined to the already-credited handlers (`sub_FFEDB131` etc., docs 02/14);
none of the leftovers reference it.

## USB relevance

Nothing here reopens the three mission answers. The leftovers are dead UI code, JPEG-decoder
code/data, and RGB565 glyph descriptors — no sample source, no transport, no USB engine, no
DSP path. The settled SUB negatives (USB0 dark, no SUB-side SDR or DSP path) now rest on a
window that is **99.27 % code-or-typed with the remaining 0.73 % proven to be unreached code
and 0 B unknown**, plus a past-window block that is JPEG decode only. The SUB side contributes
nothing to USB SDR or direct DSP access.

## Open

1. (For lane I2's seed, not a coverage question) the 52 dead functions and the 49 slivers are
   the delete/leave list; `residue.tsv` carries each with its bytes.
2. If the orchestrator ever credits dead-but-well-formed code, the 3,692 B of orphans + 43 B
   fragments move code to 467,858 and the 98 B slivers are the only genuinely-redundant bytes;
   this is the "structural standard" bracket (H10's 467,999 all-well-formed figure).
3. The below-window `FFECE51C`–`FFED0000` descriptor records could be formally typed in a seed
   DB (currently undefined); it is data by content and does not affect any window figure.
