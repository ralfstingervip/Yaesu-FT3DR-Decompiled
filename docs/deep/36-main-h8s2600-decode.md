# MAIN instruction-decode gap — the missing forms are H8SX, and IDA can decode them

> Lane G1. Private DB `G1_H8S` (`ida\db\jobs\G1_H8S\G1_H8S.i64`), seeded with
> `--copy-from ida\db\jobs\MAIN_FULL\MAIN_FULL.i64`. No other database was opened. Job scripts:
> `ida\jobs\g1_dump.py`, `g1_probe.py`, `g1_sx_switch.py`, `g1_absorb.py`, `g1_funcs.py`, `g1_extend.py`,
> `g1_cleanup.py`, `g1_validate.py`, `g1_text.py`, `g1_query.py`. Machine tables: `ida\out\h8s-decode\`
> (`sites.tsv`, `absorbed.tsv`, `coverage.txt`; intermediates in `work\`, the offline Python in
> `offline\`, the decoder oracle sources in `oracle\`). Image: `decrypted\FT3D_MAIN_ver102_EXP.bin`
> (base 0, so file offset = address). This is static analysis only. No image was modified, and nothing
> was connected to or written to a radio. Model: claude-opus-5-5 (Claude Opus 5.5).

## Verdict

**The instructions IDA's `h8s300a` module could not decode are H8SX instructions, not H8S/2600 ones.
IDA 9.1 already ships an H8SX decoder.** Switching only the private database to IDA's
`h8sxa` variant ("Hitachi H8SX advanced") decodes every site. IDA's lengths match an independent
GNU-binutils H8SX decoder on all 733 code sites, and a hand decoder gives the same text on the 487
sites it covers. No IDP hook was needed.

- **The `78 ?0 6B 2?` form is `MOV.L @(d:32,ERs),ERd`, not `MOV.W`.** Its encoding is
  `78 [1sss]0 6B 2[0ddd] d32`, 8 bytes long. That is the H8SX short form; the H8S/2600 form needs a
  `01 00` prefix and is 10 bytes. The image has **246** of them, all in real code, and **zero** of the
  10-byte H8S form. F2's "280" also counted 34 legal H8S `MOV.W @(d:32,ERs),Rd`
  (`78 [0sss]0 6B 2d`), which IDA always decoded. All of this is Confirmed.
- **There are 663 H8SX-only code sites outside the closed window, in 50 distinct forms.** 443 are reached
  by flow from proven entry points (tier A) and 220 are code by structure (tier B). Another 70 sites are
  inside the closed service window `0x078106`–`0x07B753`. Those were enumerated but not absorbed.
  298 byte-pattern matches sit in data (tables and ASCII) and were rejected. Everything except the 246
  MOV.L sites lies in one block, `0x075F36`–`0x078105`. That block is an **H8SX-compiled USB/SCI
  module**, and before this lane only 26 % of it was code in IDA (2,240 of 8,656 B).
- **Absorbed:** 2,847 planned instructions plus IDA's own flow from them. IDA instruction bytes go from
  380,738 to 391,452. **10,701 B of new code is credited**: 7,219 B tier A and 3,482 B tier B. Another
  38 B are IDA side effects and are not credited, and 25 B of junk code were displaced. Functions go
  from 3,899 to 4,019: 164 new, 9 extended and 44 bogus starts removed. 42 of those 44 started 2 bytes
  inside an H8SX MOV.L. Every function created or extended passes the validation in
  `absorbed.tsv`.
- **Metric deltas:**
  - **MAIN proven code goes from 369,071 / 380,782 to 376,290 / 391,458** (+7,219 B, tier A only).
    As a share of the 505,684 B content that is 72.98 % → 74.41 %.
  - **The 930,393 headline numerator rises by only +794 B**, to 931,187, which is 90.41 %. That is
    632 B tier A and 162 B tier B; 931,025 (90.39 %) if only tier A is counted.
  - 9,907 of the new code bytes were already credited under another type: W2-8 had typed 9,201 B of this
    code as "parameter table". Retyping does not move the numerator.
- **Part:** the instruction set **Confirms an H8SX CPU core.** That excludes every H8S/2xxx candidate,
  the H8S/2456 included, independently of pc-07's register-map argument. The instruction set cannot
  separate H8SX family members, so the specific part stays pc-07's H8SX/1668R (Inferred).

## Method

1. **Decoder oracle (Confirmed tooling).** `objdump` here is x86-only. I fetched GNU binutils
   `include/opcode/h8300.h` and `opcodes/h8300-dis.c` from sourceware and built them standalone with
   gcc. The build uses stub headers and a driver. The sources are in `ida\out\h8s-decode\oracle\`.
   `h8300-dis.c` matches the whole table, H8SX (`AV_H8SX`) rows included, so it is an H8SX
   disassembler. I ran it at every address `0x000000`–`0x07B753` (`work\bu_all.tsv`).
   - On all 121,773 IDA code heads, its length equals IDA's wherever it decodes.
   - It refuses 352 IDA heads. All of them are Bcc with an odd displacement, sitting over ASCII. That is
     IDA mis-decoding data.
2. **IDA probe (`g1_probe.py`).** IDA's H8 module already lists the H8SX mnemonics: `rts/l`, `rte/l`,
   `bra/s`, `mova`, `movmd`, `bfld` and others. `procs\h8.dll` offers the variants `h8sxn`, `h8sxm`,
   `h8sxa` and `h8sx`. So the preferred plan of writing an IDP hook was replaced by **switching the
   private DB's processor variant to `h8sxa`** (`g1_sx_switch.py`). The switch queues a re-analysis of
   the whole image, so the script clears every auto-analysis queue (`auto_unmark` on all `AU_*`). The
   h8s300a items therefore stay exactly as MAIN_FULL had them. `items_sx0.tsv` differs from
   `items_before.tsv` only in four mnemonics, three `bra`→`bra/s` among them. On every byte where
   h8s300a decoded, h8sxa gives the same length, and no IDA code head became undecodable.
3. **Site enumeration (offline, `offline\*.py`).** A site is an even address where `h8s300a` returns
   size 0 and the oracle decodes. Candidates came from:
   - recursive descent with the oracle;
   - a raw scan for all `78 [1sss]0 6B 2d` patterns;
   - a linear sweep of the ten gaps left inside the H8SX module.

   Tiers:
   - **A:** reached by flow from 3,264 fnindex-validated starts, 444 `proved.tsv` starts, the 27
     vector handlers, and the dispatch tables whose load is a decoded MOV.L followed by `jmp/jsr @ERd`.
     107 such tables were used. The 45 cases of the verified `bra r0.w` switch at `0x076308` are also
     tier A (see Findings 1).
   - **B:** a 78 MOV.L with a clean decode chain on both sides, or any form inside the H8SX module
     `0x075F36`–`0x078105`, where the decode is clean to a terminator.
   - **W:** inside the closed window, reached from IDA's existing window code. Recorded byte-class
     only.
   - **X:** everything else, which all sits in typed data. Rejected.
4. **Absorption (`g1_absorb.py`).** The plan is every A/B site plus every instruction downstream of it,
   stopping where flow rejoins existing IDA code, plus the module gaps: 2,847 instructions, 10,126 B.
   For each one, the script deletes overlapping items and calls `create_insn`, then checks the length.
   - Result: 2,847 of 2,847 created at the planned length.
   - 35 odd-aligned IDA code heads that overlapped planned code were deleted. H8 instructions are
     word-aligned.
   - Functions whose chunk ended on a planned instruction were re-derived; the 4 that shrank got their
     old end back.
5. **Functions.**
   - `g1_funcs.py`: `add_func` at every absorbed run start that is a `jsr/bsr` target or a verified
     dispatch-table entry. 93 were created and 5 were already inside a function.
   - `g1_extend.py`: grows the predecessor's chunk when the run is fall-through.
   - `g1_cleanup.py`: removes one IDA side effect, ASCII at `0x0458D8`.
   - `g1_validate.py` dumps bounds, chunk ends, xrefs and data-reference targets for the
     164 + 10 changed functions.
6. **Not done / limits.**
   - The 70 window sites were **not** absorbed, and no window protocol detail was read. One
     offset table *inside* the window (`0x078546`) was read as data, to verify a switch *outside* it.
   - The W tier only covers window code IDA already had; window data was not swept.
   - 203 of the 663 sites (27 tier A, 176 tier B) remain in code with no IDA function. They were
     outside functions in MAIN_FULL too, and no call or table proves an entry for them.
   - The hand decoder covers 11 families (487 sites), not all 54 forms (50 outside the window, 4 more
     seen only inside it).

**Pipeline (re-run in this order):**

1. `g1_dump.py` (TAG `before`, on the fresh copy)
2. `g1_sx_switch.py` with `--copy-from MAIN_FULL`
3. Offline: `final_sites.py`, then `absorb_plan.py`
4. `g1_absorb.py`, then `g1_dump.py` (TAG `after`)
5. Offline: `entries.py`
6. `g1_funcs.py`, `g1_extend.py`, `g1_cleanup.py`, then `g1_dump.py` (TAG `after`)
7. `g1_validate.py`, `g1_text.py`
8. Offline: `valid.py`, `outputs.py`, `outputs2.py`, `cov.py`

Every IDA step runs as `python ida\run_job.py --script ida\jobs\<job>.py --db G1_H8S --reopen`, apart
from the two seeded with `--copy-from`.

## Findings

### 1. The forms, decoded by hand against the H8SX encodings

Encodings follow the Renesas H8SX instruction formats, as carried in binutils `h8300.h`. "Agree" means
the hand decoder, the binutils oracle and IDA h8sxa give the same length and operands
(`sites.tsv` `hand_check`).

| Family (H8SX only) | Encoding / length | A | B | W | Example (addr: bytes → text) | Status |
| --- | --- | ---: | ---: | ---: | --- | --- |
| `MOV.L @(d:32,ERs),ERd` | `78 [1sss]0 6B 2[0ddd] d32`, 8 B (H8S: `01 00 78 [0sss]0 6B 2d d32`, 10 B) | 161 | 85 | 0 | `0562C8: 78 b0 6b 26 00 05 64 70` → `mov.l @(0x56470:32,er3),er6` | Confirmed, 246/246 agree |
| `RTS/L ERm-ERn` / `RTS/L ERn` | `54 [cnt-1][0 last]`, 2 B | 23 | 24 | 8 | `076EF6: 54 26` → `rts/l er4-er6` | Confirmed, 55/55 agree |
| `EXTU.L #2,ERd` | `17 6[0ddd]`, 2 B | 57 | 23 | 11 | `075F54: 17 61` → `extu.l #2,er1` | Confirmed (F2 `17 6x`) |
| `SHLL.L #8` / `#16` | `10 7[1ddd]` / `10 F[1ddd]`, 2 B (`10 7[0ddd]` is H8S `#2`) | 6 | 10 | 8 | `076810: 10 f9` → `shll.l #16,er1` | Confirmed |
| `SHLL/SHLR.{B,W,L}` by `#4/#8` or `#imm5`, `SHLL.W Rs,Rd` | `10/11 [..]`, 2 B; `03 [..] 10/11 [..]`, 4 B; `78 [rs]8 10 1d`, 4 B | 31 | 6 | 4 | `076B98: 03 98 10 31` → `shll.l #0x18,er1` | Confirmed (oracle = IDA) |
| `MOV.L #imm3,ERd` / `MOV.L #imm16,ERd` | `0F [1iii][1ddd]`, 2 B; `7A 0[1ddd] i16`, 4 B | 8 | 2 | 5 | `075F64: 0f 98` → `mov.l #1,er0` | Confirmed |
| `MOV.W #imm3,Rd` | `0F [0iii][dddd]`, 2 B | 11 | 4 | 1 | `076BD6: 0f 18` → `mov.w #1,e0` (F2's `0f18`) | Confirmed |
| `CMP.W #imm3,Rd` | `1F [0iii][dddd]`, 2 B | 2 | 5 | 0 | `076B6E: 1f 10` → `cmp.w #1,r0` (F2's `1f 10`) | Confirmed |
| `MOV.B #imm8,@aa:16` / `@ERd` / `@(d,ERd)` | `01 7D [EA] ii [ext]`, 4–8 B | 11 | 13 | 1 | `076BFA: 01 7d 40 fe ee 00` → `mov.b #0xFE,@0xFFEE00` (F2's `01 7d`) | Confirmed |
| `MOV.B/W #imm4,@aa:16/32` | `6A D/F[iiii] aa`, `6B D/F[iiii] aa`, 4/6 B | 16 | 10 | 8 | `076830: 6a f0 00 ff 62 40` → `mov.b #0,@0xFF6240:32` | Confirmed |
| `MOV.W/L #imm,@ERd…` | `79 74 i16 [EA]`, `7A 74 i32 [EA]`, `01 5D [EA] i8`, 4–10 B | 24 | 6 | 0 | `0771EA: 79 74 01 01 00 00` → `mov.w #0x101,@er0` | Confirmed (oracle = IDA) |
| `MOV.L @(d:2,ERs),ERd` / `ERs,@(d:2,ERd)` | `01 0[d] 69 [..]`, 4 B | 6 | 23 | 17 | `076C80: 01 01 69 d0` → `mov.l er0,@(4:2,er5)` | Confirmed |
| Memory-to-memory `MOV.{B,W,L}` | `01 78`/`01 58`/`01 08` + src EA + dst insn, 4–10 B | 18 | 2 | 2 | `075F66: 01 78 11 01` → `mov.b @(1:2,er1),@er1` | Confirmed (oracle = IDA) |
| Indexed `@(d:32,Rn.B/W/L)`, `MOVA/L.L` | `78 [r][1/2/3] 6A/6B 2d d32`; `78 [r]8 7A [..] d32`, 8 B | 56 | 4 | 1 | `0767AE: 78 03 6b 21 00 07 b1 20` → `mov.w @(0x7b120:32,er0.l),r1` | Confirmed |
| `STM.L` outside the H8S register sets | `01 30 6D F[2/3]`, 4 B (`er2-er5`, `er3-er6`) | 8 | 3 | 1 | `075FC6: 01 30 6d f2` → `stm.l er2-er5,@-sp` | Confirmed (h8s300a refuses; H8S allows only ER0-3/ER4-7: Inferred from the H8S manual) |
| `BRA Rn.W` | `59 [0nnn]6`, 2 B | 1 | 0 | 0 | `076308: 59 06` → `bra r0.w` | Confirmed |
| Other singletons: `SUB.W/ADD.W #imm3`, `OR.W Rs,@ERd`, `MULXU.B #imm`, `ADD.L ERs,@ERd`, `MOV.L #imm,@ERd` | see `sites.tsv` | 4 | 0 | 3 | `077E7A: 7d d0 64 20` → `or.w r2,@er0` | Confirmed (oracle = IDA) |

Totals: **A 443, B 220, W 70**, giving 733 code sites with **0 length disagreements** between IDA
h8sxa and binutils. Of these, **487 also match the hand decoder exactly** (Confirmed). The 298 X rows
were rejected:

- 296 sit in runs typed as data: 255 "parameter table", 29 "other", 12 "string";
- 242 of them are `1A 1x` byte runs in the table at `0x036xxx`;
- 14 are encodings IDA h8sxa itself rejects (`stmac`, `ldmac`, and `rts/l er0-er5` over ASCII);
- the other 2 are not instruction starts: `0x00A37A` is inside `0x00A378: 5e 00 5d 96`
  (`jsr @0x5d96`), and `0x015186` sits on a chain that runs into an undecodable word;
- `sites.tsv` gives the reason for each.

**Operand semantics checked against code flow:**

- **MOV.L is a 32-bit load (Confirmed).**
  - `0x00481A: 10 73` (`shll.l #2,er3`), then `0x00481C: 78 b0 6b 26 00 00 78 2c`, then
    `0x004826: 5d 60` (`jsr @er6`).
  - Table `0x00782C` = `00004892 00004C0C 00004C2A 00004C76…`. Every entry is an IDA code address.
  - A 16-bit load could not produce these 24-bit targets.
  - Across all 246: 212 are preceded by `shll.l #2,ERs`; 123 are followed by `jmp @ERd` (121 table
    bases), 55 by `jsr @ERd` (43 bases), and 68 use the pointer as data (49 bases).
  - **This corrects docs 29 and RESUME-FULL, which call it `MOV.W`.**
- **RTS/L pops the set the prologue pushed (Confirmed).**
  - 52 of 55 `rts/l` find a matching `stm.l`/push in the same routine automatically
    (`offline\rtsl.py`).
  - The other 3 were checked by hand:
    - `0x0767BC 54 13` ↔ `0x0762DC 01 10 6d f2` (`stm.l er2-er3`);
    - `0x076EF6 54 26` ↔ `0x076C0A 01 20 6d f4` (`stm.l er4-er6`, with `sub.w #8,r7` / `add.w #8,r7`);
    - `0x076FC2 54 36` ↔ `0x076EF8 01 30 6d f3` (`stm.l er3-er6`).
- **BRA Rn.W is a register-relative switch (Confirmed / Inferred).**
  - `0x0762FE: 78 01 6b 20 00 07 85 46` (`mov.w @(0x78546:32,r0l.b),r0`), then `0x076306 11 10`
    (`shlr.w r0`), then `0x076308 59 06`.
  - The table holds 45 even byte offsets: `0000 001C 0036 0050…`. With PC+2·Rn every target lands on
    an instruction start. With PC+Rn only 25 of 45 do.
  - IDA h8sxa resolves the same switch on its own ("jumptable 00076308 case 0", dref from `0x078546`).
    The cases at `0x07630A`–`0x0767B6` (1,196 B) were W2-8 "parameter table". Confirmed.
  - The PC+2·Rn semantics is Inferred from this flow.
- **BRA/S is a delayed branch (Confirmed encoding).** `0x076210: 40 37`, an odd displacement, is
  `bra/s .+54`, with the slot instruction `0x076212 69 05`. There are 5 in tier-A/B code. h8s300a had
  decoded `0x076FEC: 40 1b` as plain `bra` and left its slot `0x076FEE 19 1a` undecoded.
- **F2's `016a` island is not an instruction (Confirmed).** `0x076BA7` is odd, inside
  `0x076BA4: 01 f0 64 01` (`or.l er0,er1`). It was an artifact of F2's byte resync.

### 2. Where the forms are: one H8SX module and one bulk idiom

| Region | Bytes | H8SX-only code sites | Forms |
| --- | ---: | ---: | --- |
| Bulk `0x000000`–`0x075F35` | 483,126 | 246 | **only** the 8-byte MOV.L |
| H8SX module `0x075F36`–`0x078105` | 8,656 | 417 | 49 forms (all the rest) |
| Closed window `0x078106`–`0x07B753` | 13,902 | 70 (enumerated, not absorbed) | same family as the module |

The facts (Confirmed):

- The bulk never uses the 10-byte H8S MOV.L @(d:32) form; there are 0 hits for
  `01 00 78 s0 6B 2d`, and 0 for the store form either.
- The bulk uses H8S encodings everywhere else. There are 32 six-byte `7A 0d 00 00 00 0n` for small
  constants, where the module uses the 2-byte `0F [1iii][1ddd]`.
- In tier-A/B and proven code, RAM is addressed `@aa:16` 14,640 times and `@aa:32` 754 times in the
  bulk. In the module it is 59 and 152 times.
- The module starts right after the `rts` at `0x075F34`, at `0x075F36: 01 20 6d f4`.

Inferred: the module was compiled separately with full H8SX code generation. It is the USB/SCI library
next to the CDC-ACM/DSP-download window. The bulk was built by an H8S-style code generator whose
MOV.L @(d:32) loads were nonetheless emitted, or assembled, in the H8SX short form. Which tool did that
is Unknown.

### 3. What was absorbed

| Item | Count | Bytes | Validation |
| --- | ---: | ---: | --- |
| Planned instructions created (`create_insn` length = plan) | 2,847 / 2,847 | 10,126 (353 were already IDA code, the wrong mis-split decodes) | `work\absorb_result.tsv` |
| IDA flow from tier-A planned code | — | 928 | case heads of the 45-case switch at `0x076308` (488 B); jsr/bsr targets `0x02F2E0`, `0x030E00`, `0x038074`, `0x0380EA`, `0x05AF70`, `0x077A1C` (all called from tier-A code) |
| New functions | 164 | 6,234 new-H8SX B inside | all `ok`: every chunk ends in rts/rte/rts-l/jmp/bra or falls into code; entry = call (118), table (38), data ref (33), F1 table (2) |
| Extended functions | 9 | 540 | `ok`; 2 are pre-existing unreferenced IDA functions (`0x03906A`, `0x0486C4`) |
| Shrunk | 1 | 0 | `0x006D0A`: its tail `0x006E2E` is now its own function, a call target |
| Removed IDA functions | 44 | — | 42 started mid-instruction, 2 bytes into an H8SX MOV.L (e.g. `0x00481E`, whose body was the tail `6b 26 00 00 78 2c` misread as `mov.w @0x782c:32,r6`); 2 started on ASCII (`0x04DE6E`, `0x04DF72`) |
| Absorbed code runs left outside functions | 121 | 3,228 | 96 end in a terminator and 25 flow into existing code; tier A 406 B, B 2,822 B |
| Displaced junk | — | −25 | odd-aligned heads (`0x025463`, `0x06B515`…) and IDA "code" over tables that the new MOV.L data refs typed |
| Not credited | — | 38 | `0x01A432` (4 B, lane-1 `sub_1A432`, IDA made it code during re-analysis), `0x0703C4` (34 B, data-offset side effect) |

**Operand plausibility (Confirmed).** All data-reference targets of the new and changed functions fall in
ROM (< `0x07B754`), RAM (`0xFEE000`–`0xFFBFFF`) or I/O (`0xFFEA00`–`0xFFFFFF`). There are 4 exceptions:
`#0x82000`, `#0x23102`, `#0x93402` and `#0xA3402` at `0x07710A`, `0x077216`, `0x077278` and `0x077280`.
These are immediates that IDA auto-offset, not memory operands.

**Notable regions now decoded (Confirmed bytes):**

- **F2 block 3, the USB stack-A dispatcher.** `0x0562C8`–`0x0563E7` (287 B) is code, and function
  `0x056272` grows to `0x05645C`. Its dispatch table bases are now confirmed 32-bit pointer tables:
  - `0x05645C` and `0x056470` (= `000565C0 000565C0 000566C2…`);
  - `0x05EBD2`, `0x05B310` and `0x05AE32`.
- **F2 block 4**: `0x076B50`–`0x076BED` (157 B). It is the tail of a module gap,
  `0x076B20`–`0x076C04`.
- **Interrupt-context bit-serial handlers** at `0x000794`–`0x000A10`: 118 → 466 B of code. They hold
  12 MOV.L sites on tables `0xD32`/`0xD72`/`0xDB2`/`0xDEA` and write `0xFFFF69` (DADR1 per pc-07).
- **The whole H8SX module**: 2,240 → 8,656 B of code, 10 → 42 functions.

### 4. Coverage before and after (`coverage.txt`)

| Metric | Before | After | Delta | Note |
| --- | ---: | ---: | ---: | --- |
| IDA is_code in G1_H8S | 380,738 | 391,452 | +10,714 | gained 10,739, lost 25 |
| Decodable-instruction companion | 380,782 | **391,458** | +10,676 | 10,701 credited new − 25 junk |
| MAIN proven code | 369,071 | **376,290** | **+7,219** | tier A only; 0 B fall in `proved.tsv` extents |
| …% of decodable | 96.9 % | 96.13 % | | tier-B code enters the denominator only |
| …% of 505,684 content | 72.98 % | 74.41 % | | |
| Headline numerator | 930,393 | **931,187** | **+794** | 632 B tier A + 162 B tier B; tier A only gives 931,025 (90.39 %) |

**Why the headline moves by so little.** Of the 10,701 new code bytes, 9,907 were already in the
numerator under another type:

- 9,201 B "parameter table" (W2-8 typed this code as tables);
- 444 B in F2's newly typed blocks 3 and 4;
- 234 B "recovered code";
- 24 B "string" and 4 B "pointer table", which are boundary slivers.

Only bytes that were uncredited count:

- 714 B of F2 `other` fragments (710 `code-region-interstitial`, 4 `code-proven`);
- 74 B inside MAIN_FULL functions that were never validated (`0x02F36C`, `0x030E6A`, `0x04CE4C`,
  `0x04DE0A`);
- 6 B inside validated extents that were not is_code: the prefix bytes `78 b0` at `0x03D19A`,
  `0x03D1CE` and `0x05CF32`.

**Cross-check with `split.tsv` (F2).** F2's "1,867 B of code-region fragments" resolves as follows:

- **714 B are now provable code.**
- 27 B were already code.
- **1,126 B are still not reached by any flow.** By content they look like data: high halves of
  pointers (`0005`, `0001`, `000e`…), ASCII, and `1a1a` table bytes. So they are Inferred not code,
  and F2's estimate was high.
- None of the 898 window bytes, the 225 small-data bytes or the 47 fill bytes changed.

**Cross-check with `proved.tsv` (F1).**

- No new byte falls inside an F1 extent, so nothing is double-counted.
- F1 rows `034644`, `038104`, `04F3A4` and `06AC14` start **2 bytes inside** an H8SX MOV.L. The real
  instruction starts at `0x034642`, `0x038102`, `0x04F3A2` and `0x06AC12`.
- F1 rows `04DE6E` and `04DF72` start on **ASCII**:
  - `0x04DE6E`–`0x04DE93` is `"10  20  40  80…"` and `0x04DF72`–`0x04DF97` is similar, 38 B each;
  - the table `0x04DE44` they hang off is loaded by `0x04DE0A mov.l @(0x4de44:32,er3),er4` and used
    as data;
  - their real entries are `0x04DE94` and `0x04DF98`, which F1 itself noted as "inside->", and are now
    functions;
  - **76 B of F1's 19,848 are text.** This correction is reported, not applied above.

### 5. Exact part: what the instruction set adds to pc-07

| Claim | Evidence | Status |
| --- | --- | --- |
| The CPU core is **H8SX**, not H8S/2600 | 733 code sites use encodings that exist only in the H8SX instruction set. The bulk's own dispatch loads (`78 [1sss]0 6B 2d`, 246×) would be different or invalid instructions on an H8S/2600, so the image cannot run on one. | **Confirmed** |
| All H8S/2xxx candidates (H8S/2456, 2215, 2218, 2212, 2472, 237x) are excluded | They follow from the row above, independently of the register map | **Confirmed** |
| The member is H8SX/1668R (or 1668M) | The instruction set is common to the H8SX family, so the choice rests on pc-07's register map, vectors and memory size | Inferred (unchanged) |
| Advanced mode | IDA `h8sxa` fits everywhere; code addresses are 24-bit (`jsr @aa:24`, pointer tables `0x0000xxxx`/`0x0005xxxx`); the mode pins are not visible | Inferred |
| VBR and SBR stay at reset values | Scope: all proven + absorbed code. There are 0 `ldc`/`stc` to VBR, SBR or EXR; only CCR is touched (`ldc #imm,ccr` ×7, `andc`/`orc`/`xorc` ×31). So the vectors at `0x000000` and `@aa:8` → `0xFFFFxx` (650 uses in the bulk) hold. | Confirmed (scope stated) |
| H8SX forms never used | Scope: proven + absorbed code. Absent: `RTE/L`, `MOVMD`/`MOVSD`, 32-bit `MULU/MULS/DIVU/DIVS(.W/.L)`, `BSET/EQ`-type conditional bit ops, `BSTZ`/`BISTZ`, `BFLD`/`BFST`, `BRA/BC`/`BRA/BS`/`BSR/BC`, `TAS`, `MOVFPE`/`MOVTPE`. Only H8S `MULXU`/`DIVXU` are used (120/266/65/48 by width). | Not found (scope stated) |
| MAC unit use | Scope as above. The one `stmac` (`0x00C44C`) is inside lane-1 "validated" `sub_C448` (`0x00C448`–`0x00C456`), which is table bytes (`02 02 02 02 02 22 74 00 6c 69 5a 49 5c 62`) ending in `jmp @0x495C62`, outside the 16 MB space. IDA h8sxa rejects `stmac`/`ldmac` outright. | Not found in real code |

## USB relevance

1. **Everything USB.**
   - The H8SX module `0x075F36`–`0x078105` is the USB function-module service code. Before this
     lane, 74 % of it was not code in IDA, and W2-8 typed much of it as "parameter table".
   - The newly decoded instructions touch these USB registers (pc-07 names):
     - `0xFFEE00` IFR0, 12 sites. The writes clear flag bits, e.g. `0x0768CC 01 7d 40 f7 ee 00` and
       `0x076BFA … fe ee 00`.
     - `0xFFEE04`–`06`, 35 sites.
     - FCLR `0xFFEE28` (`0x0768EE`), EPSTL `0xFFEE2A` (`0x07696A`) and TRG `0xFFEE2C` (`0x076B88`).
   - Stack-A's dispatcher (`0x056272`–`0x05645C`) and its tables are now fully decoded. That is the
     unlock for naming the stack-A sub-handlers (F2 Open #2).
   - No USB register outside pc-07's map appears in the newly decoded code (Not found, scope: those
     10,701 B).
2. **USB SDR.** The new code reads and writes only USB, RAM, SCI_1, P3DR, D/A `0xFFFF69`, and two
   unnamed I/O words, `0xFFFD54`/`0xFFFD62`. No A/D, sample buffer or isochronous path appears.
   The earlier "no" stands (Not found, scope: the 10,701 B newly decoded).
3. **DSP reachability.**
   - The module, **outside the closed window**, contains a polled **SCI_1 byte pump**. SCI_1 is the
     DSP channel, "SCI-C" in doc 05.
     - **Main loop `0x077018`–`0x077028`:** it takes the next byte from a buffer
       (`01 01 69 31`, `mov.l @(4:2,er3),er1`), waits for TDRE (`29 8c`, `4a fc`), writes TDR
       (`30 8b`) and clears TDRE (`7f 8c 72 70`). The chunk size is clamped to `0x40` = 64 bytes,
       one USB full-speed bulk packet (`0x077008: 79 2a 00 40`).
     - **Single-byte variant:** `0x0771D6`–`0x0771E0`.
     - **SCI_1 RE toggle:** `0x07713C`/`0x07714C` (`bclr/bset #4,@0xFFFF8A`), next to writes of
       `0x0070`/`0x0060` to `0xFFFD62` and of 6/7 to `0xFFFD54`.
   - The read: a USB-packet-sized forwarder into the DSP serial port, located in the library that
     borders the DSP-download window. This is Inferred as the transport of that path. The bytes and
     registers are Confirmed; which buffer feeds it lives in the window (closed).
   - The stack-A tail also tests `P3DR` bit 0 (`0x056450: 7e 52 73 00`, `btst #0,@0xFFFF52`), which is
     the DSP reset/boot line of doc 09. That is Confirmed bytes, with purpose Inferred.

## Open

1. **Open the window with h8sxa.** The 70 W sites decode cleanly. A lane that is allowed into
   `0x078106`–`0x07B753` can absorb it with the same pipeline (`absorb_plan.py` minus the `W0` stop)
   and settle who calls the SCI_1 pump and the four unreferenced module routines: `0x07801C`,
   `0x0773E8`, `0x0779C4` and `0x076B4E`.
2. **Re-validate proven code against h8sxa.** Apply the F1 corrections (4 mid-instruction starts, 76 B
   of ASCII) and the junk `sub_C448`. Re-run the fnindex validation over the 164 new functions, so
   that the 3,482 B of tier-B code can be promoted where a reference exists.
3. **Retype in the run tables.** Move the 9,201 B W2-8 called "parameter table" to code. This does not
   change the headline, but it makes `main-raw-types.tsv` true.
4. **Name `0xFFFD54`/`0xFFFD62`** against the H8SX/1668R register list. These registers are not in
   pc-07's table.
5. **Clean the decodable-byte companion.** 1,501 odd-aligned IDA code heads (3,102 B) in MAIN_FULL are
   impossible instructions. They inflate 380,782; only 35 were removed here.
6. **Follow the 121 dispatch tables** now confirmed as 32-bit (`jmp @ERd` bases), stack-A's
   `0x056470`/`0x05EBD2`/`0x05B310`/`0x05AE32` first.
