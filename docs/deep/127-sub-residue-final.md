# SUB window residue and SUB ledger, re-proved on K7_SUB_FINAL3 (Lane M15)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped at `0xFFC00000`,
file offset = address − `0xFFC00000`). Private DB `M15_SUB_RESIDUE`, made with `--copy-from
ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64`. Every job was read-only on that copy. No other DB was opened, no image byte
changed (sha256 MAIN `8e3ecd05409b2c31…`, SUB `b93570b3c2f69ccb…`, both re-hashed by `m15_verify.py`), and nothing was
written to a radio or any device. Model: claude-opus-5-5.

Tables are in `ida\out\sub-residue-final\`:

| File | Contents |
| --- | --- |
| `runs.tsv` | The 59 residue runs (3,736 B): bounds, file offset, first bytes, decode result, terminator, entry flow, inbound-edge counts, owning function, peripheral immediates, class |
| `counts.tsv` | Window recount, gap split, and the headline under each counting convention |
| `proposed-typing.tsv` | Task 3 proposal: the 59 DEAD runs as typed code in a SUB named mask (proposal only) |
| `typed-by-type.tsv` | The 56,289 B of typed data by IDA item kind, by fine class, and by group |
| `edges-scan.tsv` | Every raw hit of the whole-image scans (3-byte LE values, long-branch byte patterns) with its disposition |
| `m15_masks.py`, `m15_analyze.py`, `m15_verify.py` | Mask residue, analysis, and the citation byte-checker (97/97 pass) |
| `raw\` | DB exports from `ida\jobs\m15_residue.py` and `ida\jobs\m15_ops.py`: code heads (whole DB), data items, run heads, xrefs, operands, switches, indirect sites, `mvtc` sites, residue operands, logs |

## Verdict

The SUB window residue is **3,736 B in 59 contiguous runs, and all 59 are DEAD**. Each run decodes cleanly in the K7 DB:
its heads tile the run exactly, and no instruction crosses either end. Each run has **no inbound edge of any kind
anywhere in the 4 MB image**. I checked:

- IDA xrefs
- relative branches, both decoded from the image bytes at all 172,739 code heads and searched at every byte offset
- 3-byte LE values at every offset, which cover LE32 pointers at any alignment and every imm24/imm32 form
- all 288 INTB and EXTB vector slots, after locating the `mvtc` sites that set INTB and EXTB
- IDA's 40 switch tables and H8's 643 switch edges
- all 359 indirect `jsr`/`bra.l` sites
- H10's 1,526 RAM-callback addresses
- the three RAM-copied `.data` images, decoded at their RAM destinations

The split is exact: 3,393 B of dead functions, plus the 300 B dead function `FFF2A6D1`, plus 43 B of fragments. The
300 B already includes I2's split byte `FFF2A7FC`, so the residue is 3,692 + 43 + 1 = 3,736 (doc 81).

No residue run touches USB0, USBA, the FCU/flash block or any other peripheral register. The only absolute data address
in the residue is RAM `0x65E2C`.

The window recount reproduces K7 to the byte: window code 464,263 / 524,288 = **88.55 %**, code + typed
520,552 = **99.29 %**. The 60,025 B gap is exactly 56,289 typed + 3,736 residue + **0** other.

Two side corrections:
- The reach-only companion 457,462 includes 120 B inside two Confirmed-dead functions. The strict figure is **457,342**.
- 2 of the 319 `jsr Rn` sites do not load their target from memory, as docs 48 and 62 say. They load the constant 0.

Proposal: under the MAIN I12 convention (dead code typed in the DB counts as named), SUB's named figure would be
**524,288 / 524,288 = 100 %** and the headline **1,025,944 / 1,029,972 = 99.61 %**. The SUB term of the current headline
(464,263) is neither a reach figure nor a named figure, because it already contains 6,801 B of Confirmed-dead code.
**Confirmed.**

## Method

1. **Masks (Python, `m15_masks.py`).** I read the published K7 masks `ida\out\sub-final3\raw\mask_final3_after_*.bin`
   and recounted them:

   | Mask | Bytes |
   | --- | --- |
   | headline | 464,165 |
   | headline_w2 | 464,263 |
   | allwf | 467,999 |
   | reach | 454,692 |
   | reach_w2 | 457,462 |

   headline_w2 is a subset of allwf. The residue is `allwf − headline_w2` = 3,736 B in 59 runs.

2. **IDA (`m15_residue.py`, then `m15_ops.py`; `run_job.py --copy-from K7_SUB_FINAL3`, then `--reopen`; `auto_wait`,
   traceback file, `qexit(0)`).** The jobs exported:
   - every code head in every segment: 172,739 heads, all byte-identical to the image
   - every window data item, including the descriptor record that straddles `FFED0000`
   - the heads in, before and after each run
   - every IDA xref into a residue byte
   - every `o_imm`, `o_displ` (`op.value`), `o_mem` and `o_near` operand in the whole DB whose value lands in a residue
     byte
   - every switch with its case targets (`calc_switch_cases`)
   - every `jsr`/`jmp`/`bsr.l`/`bra.l` Rn site with its 8 predecessors
   - every `mvtc`/`mvfc` site
   - every operand of every residue instruction (2,808 operands)

3. **Independent scans (Python, `m15_analyze.py`, run against the image bytes):**
   - **(a)** A relative-branch decoder. It covers `bra.s`/`beq.s`/`bne.s`, `bcnd.b`/`bra.b`, `bra.w`/`bsr.w`/`beq.w`/`bne.w`
     and `bra.a`/`bsr.a`. I ran it at every DB code head and cross-checked it against IDA's named target on every branch
     head: 0 mismatches.
   - **(b)** The `.a` and `.w` forms at every byte offset of the 4 MB image.
   - **(c)** The 3-byte LE value at every byte offset, tested against all 3,736 residue addresses, not only the run
     starts. Each hit was disposed by DB item.
   - **(d)** All 256 INTB and 32 EXTB slots.
   - **(e)** Every `mvtc`-to-INTB/EXTB byte pattern: `FD 68 xC/xD` and `FD 73/77/7B/7F 0C/0D`.
   - **(f)** The H8 switch edges.
   - **(g)** The register source of each indirect site.
   - **(h)** H10's `ram_cb.tsv`.
   - **(i)** The three DTBL images, decoded as `bra.a`/`bsr.a` at their RAM destination addresses.

4. **Classification rule.** A run is DEAD if all four of these hold:
   - It decodes cleanly: its heads tile it, and the last head ends exactly at the run end.
   - Its predecessor head is a stop or is not code, so nothing falls into it.
   - It has no inbound edge from outside the run under any of (a)–(i).
   - No hit from (b) or (c) lies at a real instruction operand or an aligned FF-topped pointer.

   The other classes were REACHED (a live edge exists), DATA, FRAGMENT (kept as a subclass of DEAD) and UNCERTAIN.

5. **Not done.** I made no DB edit, no mask edit and no seed. I ran no fresh decoder independent of IDA's RX module for
   non-branch instructions; the tiling test and the byte-identical head export are the decode check. I did not assess
   computed addresses built by `add`-arithmetic from a non-immediate base. The image contains no `mvfc pc`, so no
   PC-relative address is materialised except by branches and `bra.l` switch tables.

## Findings

### 1. The 59 runs: all DEAD (Confirmed; `runs.tsv`)

| Subclass | Runs | Bytes |
| --- | --- | --- |
| Dead application function (I10's 52 `71 00 xx`-prologue orphans, less `FFF2A6D1`) | 51 | 3,393 |
| Dead function `FFF2A6D1`–`FFF2A7FD`, including split byte `FFF2A7FC` | 1 | 300 |
| Fragment | 7 | 43 |
| **Total** | **59** | **3,736** |

The run list equals I10's `residue.tsv` minus its 49 two-byte `60 40` slivers (98 B), which I2 found are pointer-table
targets and credited as w2. The only other difference is `FFF2A6D1`, which grows from 299 to 300 B. Every run start is a
K7 function named `dead_<start>`, and every run is the head chunk of one of K7's 125 dead functions.

**Decode.** In all 59 runs the K7 heads tile the run and the last instruction ends exactly at the run end.

- **45 runs** end in a stop: `rtsd`, `rts`, or `bra.b`. The `bra.b` cases are `FFEF05DD`, `FFF1ED7B`, `FFF256BD`,
  `FFF2A6D1` and `FFF387C9`. For example, `FFEF05DD` is `71 00 ec a1 01 91 8a 91 83 3d 04 00 2e 53`, which ends with
  `bra.b` to `FFEF063C` (+0x53).
- **14 runs** fall through at their end into the head of credited-unreached code. These are the "true head of a lane-4
  body" cases:

  | Run | Body |
  | --- | --- |
  | `FFEF13A1` | `FFEF13F4` |
  | `FFEF6A78` | `FFEF6A92` |
  | `FFF13DDA` | `FFF13DEF` |
  | `FFF1EB84` | `FFF1ECA0` |
  | `FFF2511D` | `FFF25134` |
  | `FFF253AC` | `FFF253AF` |
  | `FFF257B1` | `FFF257D9` |
  | `FFF2ED6E` | `FFF2ED9C` |
  | `FFF301DD` | `FFF3020B` |
  | `FFF30B28` | `FFF30B56` |
  | `FFF3202F` | `FFF3205D` |
  | `FFF33BF8`, `FFF36999`, `FFF3B8CB` | `FFF33C02`, `FFF3699E`, `FFF3B8D4` |

  None of these bodies is reached, which is consistent: the dead head is the only way in.

**Entry flow.** In all 59 runs the predecessor head is a stop:
- `rtsd` in 54 runs
- `rts` in 4 runs (`FFEF2029` before `FFEF202A`, `FFEF2032` `02` before `FFEF2033`, `FFF3758E` before `FFF3758F`,
  `FFF375A3` before `FFF375A4`)
- `rte` once (`FFF47E5E` `7f 95` before `FFF47E60`)

So no run is entered by fall-through.

**Inbound edges, whole image** (`raw\analyze_log.txt`):

| Test | Scope | Into residue from outside the run |
| --- | --- | --- |
| IDA xrefs (code + data) | every residue byte | **0** |
| IDA operand values (`o_imm`/`o_displ`/`o_mem`/`o_near`) | all 172,739 code heads | **0** (166 hits, all internal branches of the run itself) |
| Byte-decoded relative branches | 32,479 branch heads | **0** |
| `.a`/`.w` branch byte patterns | every offset of 4,194,304 B | 21 patterns, **0 at an instruction head** |
| 3-byte LE value (LE32 any alignment, imm24, imm32) | every offset, all 3,736 residue addresses | 46 hits, **0 pointers or operands** (below) |
| INTB 256 + EXTB 32 slots | 224 distinct targets | **0** |
| IDA switches (40) / H8 switch edges (643) | all cases | **0** / **0** |
| Indirect sites (319 `jsr Rn`, 40 `bra.l Rn`, 0 `jmp Rn`, 0 `bsr.l Rn`) | register source | 317 from memory, 2 constant `0` (not residue), 40 switch `bra.l` all with switch info |
| H10 RAM-callback census | 1,526 code addresses | **0** |
| DTBL images decoded at their RAM destination | `bra.a`/`bsr.a` at every offset | **0** |

The 46 three-byte hits (`edges-scan.tsv`) fall into three groups:

- **39 straddle instruction fields inside live code.** None is an operand value. Examples:
  - `FFF0F2F6 fb 5e 00 00 04 | ef…`: `mov.l #40000h,r5` followed by the next opcode reads as `FFEF0400`.
  - `FFEDF024 05 04 ef ff` (`bsr.a` to `FFEDDF28`) reads as `FFEF0405`.
- **5 lie in RES bitmap pixels.** These are `FFC46712 96 b5 ef 7b`, `FFEB87A6`, `FFEB91F2`, `FFEBD386` and `FFEBED92`.
  The 4th byte is `7B`/`01`/`03`, and there is no code in RES.
- **2 lie in window data, unaligned, with a 4th byte other than FF.**
  - `FFED222F 00 78 f1 d9` is inside descriptor struct `FFED222C`.
  - `FFED9B0B ff bc f1 ec` is inside the DTBL image `FFED8FFC`–`FFED9762`.

**INTB/EXTB located (Confirmed).** In the reset stub:
- `FFC00017 fb e2 70 8a ed ff` (`mov.l #FFED8A70,r14`), then `FFC0001D fd 68 ec` (`mvtc r14,intb`)
- `FFC0000E fb e2 80 ff ff ff` (`mov.l #FFFFFF80,r14`), then `FFC00014 fd 68 ed` (`mvtc r14,extb`)

These are the only two `mvtc`-to-INTB/EXTB patterns at any offset of the image. The BRIEF's INTB `0xFFED8A70` and EXTB
`0xFFFFFF80` stand. The EXTB targets are `FFC00000` and the `rte` stubs `FFF47E34`…`FFF47E3E`; `FFF47E60` is not among
them.

**DATA / REACHED / UNCERTAIN: none.** No run is referenced as data, and every run decodes as code in the DB.

### 2. The 43 B of fragments and the single byte (Confirmed)

| Run | Bytes | Content |
| --- | --- | --- |
| `FFEE177F` | 1 | `02` `rts` (an empty function) between `rtsd` `FFEE177D 67 02` and credited-unreached `FFEE1780` |
| `FFF3758F` | 1 | `02`; the predecessor `FFF3758E` `02` is credited-unreached |
| `FFF375A4` | 2 | `02 02`; the predecessor `FFF375A3` `02` is reached |
| `FFF47E60` | 1 | `02` inside the `rte` stub run: `FFF47E5E 7f 95 02 7f 95` |
| `FFEF202A` | 8 | `75 41 28 05 6b c2 fe 02`: `mov.l #40,r1`, `bsr.a`, `rts`. `FFEF2032` `02` after it is reached and is not residue |
| `FFF13DDA` | 21 | `72 00 e0 fe f9 05 8e 00 f9 05 8d 00 3c 84 00 3e 02 00 3e 01 00`; falls into `FFF13DEF fb e2 78 02 02 00` (credited-unreached) |
| `FFF3B8CB` | 9 | `75 42 64 66 51 05 08 e6 ff` (`mov.l #64h,r2`, `mov.l #5,r1`, `bsr.a FFF39ED8`); falls into `FFF3B8D4 fb e2 60 08 01 00` |

The fragment total is 1 + 1 + 2 + 1 + 8 + 21 + 9 = **43**.

**The single byte is `FFF2A7FC`**, the second byte of the dead `bra.b` at `FFF2A7FB` (`FFF2A7F9 a0 09 2e 7e a9 8c 72 41
0c 10`; `2e 7e` jumps to `FFF2A879`). Lane-4 started a function at `FFF2A7FC`, out of phase. I2 removed that byte from
the headline, so it now closes the run `FFF2A6D1`–`FFF2A7FD`. Its neighbour `FFF2A7FD` stays credited-unreached: it is
the target of `FFF2A7EE 20 0f` `beq.b`, which sits inside the same dead function. So 3,692 + 43 + 1 = 3,736.

### 3. Window recount and the 60,025 B gap (Confirmed; `counts.tsv`, `typed-by-type.tsv`)

**Bounds.** The window is `FFED0000`–`FFF50000` (`0x80000` = 524,288 B, file `0x2D0000`–`0x350000`). Both edges are
64 KB-aligned, chosen in doc 02 from per-block entropy:
- Above `FFF50000` the flash is erased, except the 2,526 B JPEG-decoder tail `FFF50000`–`FFF509DE` (I10). That tail is
  outside the denominator, and its 2,293 B of code are not credited.
- Below `FFED0000` lies RGB565 descriptor and pixel data. The descriptor record `FFECFFFC` straddles the edge with
  12 B in the window.

The first window code head is `FFEDAB4C`, right after the DTBL source images end. In the whole DB the only code outside
the window is the reset stub `FFC00000`–`FFC0003B` and the past-window tail.

| Figure | Bytes | % of 524,288 |
| --- | --- | --- |
| Window code, headline (`headline_w2`) | **464,263** | **88.5511 %** |
| — reached (`reach_w2`, H10 rule) | 457,462 | 87.2540 % |
| — credited-unreached | 6,801 | |
| Gap = window − code | **60,025** | |
| — typed data (window − allwf) | **56,289** | |
| — residue (allwf − headline_w2), all DEAD | **3,736** | |
| — anything else (unexplored, or neither code nor typed) | **0** | |
| Code + typed | **520,552** | **99.2874 %** |
| All-well-formed (DB code outside typed) | 467,999 | 89.2637 % |

This reconciles with `ida\out\sub-final3\counts.txt` line for line: 464,165 / 464,263 / 454,692 / 457,462 / 56,289 /
467,999 / 520,454 / 520,552. DB code bytes in the window are 468,012: 13 of them lie inside the typed mask (the code
twin `FFF4B077`–`FFF4B084`), and 0 window bytes are unexplored. DB data bytes are 56,276, which is 56,289 − 13.

**The typed 56,289 B by type:**

| Group | Bytes |
| --- | --- |
| Graphics descriptors and records (RGB565 descriptors 16,236; icon/indicator 7,112; 1-bpp glyph/font 1,284; descriptor pointers 76) | 24,708 |
| Strings and string slots (string-pool residual including its 37 switch tables and the 13 B code twin 4,950; `char[n]` slots 5,364; C strings 1,937; `char*` lists 96; NUL pad 52) | 12,399 |
| UI layout and zero-heavy low tables (doc 21 regions `FFED3F6C`–`FFED8A70`, I2 items, not re-classed by I17) | 8,416 |
| CC-RX `.data` initializer images (DTBL 7,385; RAM-default 264; RAM-pointer records 288; local array 78) | 8,015 |
| Other constant tables (storage driver 644, menu 192, runtime 192, sine/cosine/constant 384, records 124, index 80, linker list 52, bytes 8) | 1,676 |
| INTB vector table `FFED8A70`–`FFED8E70` | 1,024 |
| Switch tables in the H8 gap | 47 |
| Alignment pad | 4 |

By IDA item kind:

| Kind | Bytes |
| --- | --- |
| struct | 26,164 |
| byte | 10,820 |
| offset | 10,482 |
| strlit | 8,280 |
| dword | 456 |
| double | 72 |
| word | 2 |
| code twin | 13 |

**K7's 125 dead functions** (`sub-final3\dead.tsv`, 10,670 B) decompose exactly:

| Part | Bytes |
| --- | --- |
| Residue | 3,736 |
| Credited-unreached | 6,801 |
| `reach_w2` | 120 |
| Typed (the twin) | 13 |

All 6,801 credited-unreached bytes of the headline lie inside those dead functions.

**The 120 `reach_w2` bytes** are:
- `FFF2570F`–`FFF25771` (98 B), inside `dead_FFF256BD`
- `FFF38800`–`FFF3880B` and `FFF38871`–`FFF3887C` (22 B), inside `dead_FFF387C9`

They are "reached" only because lane 4 validated `FFF2570F` and `FFF38800` as `xref` roots (`sub-window\functions.tsv`).
I17 flagged both as "reachable only as a lane-4 'xref' root" (`sub-final2\ambiguous.tsv`). No byte-decoded branch from
outside those functions, and no 3-byte LE value anywhere in the image, reaches them. **The strict reach figure is
457,342** (87.2311 %).

### 4. Task 3: what SUB would be under MAIN's convention (proposal only; `proposed-typing.tsv`, `counts.tsv`)

**What MAIN credits.** MAIN's named figure counts code and typed data in the seed DB. Unreachable code that stays typed
as code keeps its credit: the I12 demotions of 120 B and 278 B in docs 69 and 98. MAIN's L5 Inferred dead code
(2,880 B) is not yet credited only because it is not yet typed in a seed.

**Why the residue qualifies.** All 3,736 residue bytes are already DB code in K7: allwf is DB code outside the typed
mask, and allwf − DB code = 0. Their class is Confirmed DEAD (§1).

| Convention for the SUB term | SUB bytes | SUB % | Headline (MAIN named 501,656 + SUB) / 1,029,972 |
| --- | --- | --- | --- |
| A. Now: window code (`headline_w2`) | 464,263 | 88.5511 % | 965,919 = **93.7811 %** |
| B. Window code + DEAD residue as code | 467,999 | 89.2637 % | 969,655 = 94.1438 % |
| C. Code + typed data (residue left out) | 520,552 | 99.2874 % | 1,022,208 = 99.2462 % |
| **D. Code + typed + DEAD residue (I12 convention)** | **524,288** | **100.0000 %** | **1,025,944 = 99.6089 %** |
| E. Strict reach on both sides (MAIN proven 364,786 + SUB 457,342) | 457,342 | 87.2311 % | 822,128 = 79.8204 % |

**Proposed typing** (`proposed-typing.tsv`): credit the 59 runs listed in §1 (3,736 B, every range given with its
file offset) as typed code in a SUB named mask. This needs no DB edit, because they are already DB code. `headline_w2`
stays as it is.

**Code only, or code + typed?** The present headline adds a MAIN named/typed figure to a SUB code-only figure. That SUB
term is not a strict reach figure either: it carries 6,801 B (plus 120 B through stale roots) of Confirmed-dead code
credited under the H8/H10 structural rule.

If the headline is meant to measure "named", the consistent SUB term is code + typed:
- 520,552, giving 99.25 % (C), or
- 524,288 with the DEAD residue counted as typed code exactly as MAIN counts its demoted ranges, giving 99.61 % (D).

If it is meant to measure "proven", the consistent pair is MAIN proven + SUB strict reach, giving 79.82 % (E).

My recommendation is D for named and E for proven, published side by side. No headline was changed here.

## USB relevance

None of the three mission answers changes.

- **USB.** Not found. The scope was every operand of every residue instruction (2,808 operands of `o_imm`, `o_displ`
  `op.value` and `o_near` type) plus the byte-decoded `FB` `mov.l #imm` forms (44 heads). The result is 0 values in
  `0x80000`–`0x100000` (USB0 `0xA0000`, USBA `0xD0000`, SYSTEM/MSTPCR `0x80010`–`0x8001F`, PRCR) and 0 in FCU/flash
  `0x7E0000`–`0x800000`.
  - The only absolute data address in the residue is RAM `0x65E2C` (`FFF2A718 fb e2 2c 5e 06 00`).
  - The other large immediate is `FFEF03F1 70 11 00 00 00 07` (`add #7000000h,r1,r1`), which is arithmetic.
  - The `o_near` call/branch targets that leave the runs are UI routines, most often `FFF1EE20` ×41, `FFF15E96` ×27 and
    `FFF15EA6` ×23 (`rawesidue-operands.tsv`).
  - This agrees with K7's whole-image `usb-scan.tsv`, and with doc `sub-usb.md`: SUB's USB is dark.
- **SDR / DSP.** The residue is dead UI and screen-handler code (the `fb 16 e1` `mov.l #-31,r1` / `bsr` `FFF15E96`
  clone family, for example `FFF1743B 71 00 ec … FFF17440 05 56 ea ff`) and empty `rts` stubs. There is no sample path,
  no transport, and no DSP framing.

## Open

1. **Adopt one convention for the headline (orchestrator).** Table §4 gives exact bytes for each option. If D is
   adopted, the SUB named mask is `headline_w2 ∪ typed ∪ runs.tsv`, which is all 524,288 window bytes
   (`allwf` ∪ its complement).
2. **Correct the reach-only companion to 457,342.** Drop lane-4 `xref` roots that the current DB does not reach
   (`FFF2570F`, `FFF38800`). Then re-run the reach closure to check whether other stale `xref` roots outside the 125 dead
   functions inflate it. I only tested the dead-function set.
3. **The live `jsr` to address 0.** The sequence is `FFEE2220 66 03 7f 13` and `FFEE223B 66 03 7f 13`
   (`mov.l #0,r3 ; jsr r3`), and both sites are in the reach mask. RAM `0x0`–`0x3` is neither DTBL-initialised nor
   BTBL-zeroed (the lowest BTBL range starts at `0x4`). What runs there is Unknown, and it is probably a deliberate trap.
   It is not residue.
4. **The past-window JPEG tail** `FFF50000`–`FFF508F5` (2,293 B of DB code) stays outside the 524,288 denominator. If
   the window is ever redefined as content-bounded (`FFED0000`–`FFF509DE`), it adds 2,293 code + 233 typed.

### Corrections to earlier docs (owning docs not edited)

- **Docs 48 §4 (H10) and 62 §B (I10).** These say "every `jsr` loads its target from memory". In fact 317 of the 319
  `jsr Rn` sites do, and 2 load the constant 0: `FFEE2220 66 03` → `FFEE2222 7f 13`, and `FFEE223B 66 03` →
  `FFEE223D 7f 13`. H10's own `indirect.tsv` rows are right; only the prose is wrong. The 0-into-residue result does not
  change.
- **Docs 68 (I17) and 89 (K7) `counts.txt`.** The reach-only companion 457,462 includes 120 B inside Confirmed-dead
  functions (§3). The strict figure is 457,342.
- **Doc 62 §A.** I10's 98 B "never targeted" `60 40` slivers are pointer-table targets, and its `FFF2A6D1` is 300 B, not
  299. Both were already recorded by I2 (doc 54, `sub-final\ledger-delta.tsv`). They are restated here only so that
  3,736 = 3,692 + 43 + 1 can be traced to bytes.
