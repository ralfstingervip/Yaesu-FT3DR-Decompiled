# SUB tier-2 large routines — hand disassembly (Lane F7)

Hand-reconstruction of the next tier of large, xref-reached SUB-window functions,
below the three biggest bodies (`sub_FFF4C9D1`, `sub_FFEF6C42`, `sub_FFF40C3E`,
owned by other lanes and untouched here). Owner-side static analysis of
`decrypted\FT3D_SUB_ver102_ALL.bin` only; no device, no writes, no image change.

Model id: **claude-opus-4-8** (Claude Opus family — proceeded per the brief).

Private DB `FIN_SUB_T2`, seeded `--copy-from ida\db\jobs\SUB_WINDOW\SUB_WINDOW.i64`.
Job script `ida\jobs\fin_sub_t2.py`. Per-routine full annotated listings and
hand-C live in `ida\out\sub-tier2\`:

| Routine | Listing | Hand-C |
| --- | --- | --- |
| `sub_FFF4B084` | `fff4b084.lst` | `fff4b084.c` |
| `sub_FFEF2724` | `ffef2724.lst` | `ffef2724.c` |
| `sub_FFF1F752` | `fff1f752.lst` | `fff1f752.c` |
| `sub_FFF162CD` | `fff162cd.lst` | `fff162cd.c` |
| `sub_FFF1898D` | `fff1898d.lst` | `fff1898d.c` |

Supporting: `callees.txt` (capped dumps of all 63 external callees), `tables.txt`
(referenced flash tables + the printable-run scan), `job_status.txt`.

## Verdict

- **`sub_FFF4B084` (0xFFF4B084–0xFFF4C226, 4514 B) = baseline JPEG decoder core.**
  Marker FSM (SOI 0xFFD8, SOF0 0xFFC0, SOS 0xFFDA, EOI 0xFFD9, RSTn 0xFFD0–D7),
  buffered byte reader `sub_FFF4C3A2`, de-zigzag table `0xFFF508F8`, Huffman
  receive/extend + IDCT (`div`/`mul`/variable `shll`). Real logic — the densest
  routine in this lane. Serves image display (stored/received pictures to LCD).
- **`sub_FFEF2724` (0xFFEF2724–0xFFEF34B1, 3469 B) = menu/settings field-fetch
  dispatcher.** Two-level computed jump: 14-entry table `0xFFF480CE` on descriptor
  kind 0xF0–0xFD, 22-entry table `0xFFF480EA` for kind 0xF1; copies two bytes from
  the settings RAM shadow `0x00008C4D` into the row descriptor and tags a value
  type; reads sub-mode `0x00008CBA`. Pure leaf (0 callees, 0 loops). Real but
  repetitive — a big hand-written switch whose per-case bodies are trivial copies.
- **`sub_FFF1F752` (0xFFF1F752–0xFFF20186, 2612 B) = FAT long-file-name directory
  path resolver** (`follow_path`/`create_name`/`dir_register` core). Builds the
  11-byte 8.3 SFN, counts LFN slots via `div #13`, validates name chars against the
  table `0xFFF4ADEE`, scans 512-byte dir/FAT windows at `fs+0x60C/0x80C/0xA0C`.
  20 call sites — the shared name-lookup engine. Real, heavy logic.
- **`sub_FFF162CD` (0xFFF162CD–0xFFF16CAD, 2528 B) = `f_open()`.** Scans the
  open-file handle table (count `*0x00012512`, base `*0x00065E24`, stride 0x468),
  compares the request against each record name `+0x23C`, tracks a free slot
  (flags `+0x442`), parses mode `r`/`w`/`a`/`+`, returns a FatFs-style negative
  errno via `sub_FFF1EE7B`. Real logic; calls `sub_FFF1F752`.
- **`sub_FFF1898D` (0xFFF1898D–0xFFF192BE, 2353 B) = `f_write()`.** `total =
  size*count`, the classic `0xFFFFFFFF - fptr` overflow clamp, cluster/sector walk,
  `memcpy` user→window (`sub_FFF2E478`), multi-sector disk path
  `sub_FFF24802/FFF24892`, file-size extension, dirty flag `fp+0x464`. Real, heavy
  logic.

**Real logic vs glue:** all five carry real logic; none is table-copy glue. Four of
the five (`FFF4B084`, `FFF1F752`, `FFF162CD`, `FFF1898D`) are the SD-card /
FAT-filesystem + JPEG image stack; the fifth (`FFEF2724`) is the UI/menu settings
layer. Densest: `FFF4B084` (JPEG) and `FFF1F752` (LFN path). `FFEF2724` is the one
that is structurally real but per-case trivial. **None of the five touches any
hardware peripheral, USB, or the DSP** — they are the RAM/compute logic layer; the
63 external callees contain zero peripheral-register access (verified: only false
hit is `cmp #0xF4240` = decimal 1,000,000, not an address).

## Method

`fin_sub_t2.py` reopens `FIN_SUB_T2` and, per target, emits a linear annotated
disassembly (address, raw bytes, IDA disasm, decoded operands, callees, IDA data
xrefs, loop back-edges) plus a light RX register-pointer tracker that resolves
`mov.l #imm,Rn` then `[Rn]`/`disp[Rn]` effective addresses. It then dumps every
direct external callee (capped 0x400) and every referenced flash table.

Scope covered: all five target bodies fully disassembled and structurally resolved
(prologue/args, dispatch, loops, callees, RAM/flash touched); both `FFEF2724` jump
tables decoded from the image with PC-relative targets; all 63 callees labelled
from `sub-xref.tsv` and inspected for peripheral access. Not done: exhaustive
per-case C for every `FFEF2724` arm (representative set given; the `.lst` has the
full offset map), and no Hex-Rays (none exists for RX — C is hand-written).

**RX traps honored.** `o_displ` byte displacement read from `op.value` (not
`op.addr`). `mov.l #imm24,Rd` sign-extends: byte stream `00 00 DA` → `0xFFDA0000`
(so the `FFDAxxxx` ROM-table refs are genuine, confirmed by IDA `->data` xrefs).
`bra.l rN` / `bsr.l rN` are **PC-relative** (target = insn_ea + rN) — that is how
`FFEF2724`'s 16-bit jump-table entries resolve into the body. **Caveat:** the
tracker's `imm->flash`/`imm->ram` range flags include false positives for negative
immediates (e.g. the SP adjust `0xFFFFFF88`) and for JPEG marker constants
(`0xFFC0`, `0xFFD8`); every address claim below rests on IDA's resolved operand or
a `->data` xref, not on those flags.

## sub_FFF4B084 — baseline JPEG decoder

**Signature (inferred):** `int jpeg_decode(src, out_info1, out_info2, mode, dest)`.
`pushm r6-r13`, 0xD0 frame, `rtsd #0F0h, r6-r13` (@FFF4B683). Callers FFF4B071 /
FFF4B07E (public shim FFF4B06C). `R7` = decoder context = `R1[0x18]` (@FFF4B0B7).

**Structure (addresses in `fff4b084.lst`):**
- Argument validation returning large negatives in `R6`: −1000/−2000/−3000 for null
  R1/R2/R3 (@FFF4B08E–B09E), −4000 bad mode (@FFF4B0A6, `mode<2` gate @FFF4B0AA),
  −0x42E null ctx (@FFF4B0B9), −0x438/−0x492/−0x46A bad source (@FFF4B0DC–F3).
- Three tight clear loops zero the output/work structs (@FFF4B133, B14D, B211 —
  back-edges), then explicit field inits for `oi1`/`oi2`/`ctx`.
- **Byte reader `sub_FFF4C3A2`** (41 callers): count at `ctx+0x20`; if >0, decrement
  and return `ctx[…+0x1E]`; else refill via `sub_FFF4C226` (loop @FFF4C3D2) — a
  buffered `getc()`. `sub_FFF4C408` reads a marker word; `sub_FFF4C442` fills input.
- **Marker FSM:** skip `0xFF` fill (loop @FFF4B295), form `byte|0xFF00`, test
  SOI `0xFFD8` (@FFF4B267), SOF0 `0xFFC0` (@FFF4B2A6, baseline only — no 0xFFC1/C2),
  SOS `0xFFDA` (@FFF4B63D), EOI `0xFFD9` (@FFF4BB55/C207/C216), RSTn `0xFFD0–D7`
  (@FFF4BC75), `0xFFDC` (@FFF4BB5D/BCB5), stuffed `0xFF00` (@FFF4BEFD/BF11).
- **Segment length:** big-endian hi/lo via `shll #8` + `or`, then `sub #2`
  (@FFF4B2BD–C9, FFF4B647–57).
- **De-zigzag table `0xFFF508F8`** = `00 01 08 10 09 02 03 0A 11 18 20 …` (JPEG scan
  order), loaded @FFF4B965. ROM tables/sentinels at `0xFFDA0000/0100/0200/0300/0400/
  0800`, `0xFFDB0300`, `0xFFDC0000/0100`, `0xFFD0FF00`, `0xFFFF0100` referenced in
  table & component set-up (content is mostly 0xFF/0x00 — default / "not present"
  tables).
- **Entropy + IDCT:** variable `shll r14,rN` (Huffman receive/extend, @FFF4BEF1/
  BF11), `mul`/`div`/`divu` (IDCT and component up-sampling, @FFF4BB8E, FFF4B5B9).
  65 loop back-edges total (clear, marker scan, component/MCU scans, IDCT).
- A code pointer `sub_FFF4FABD` is stored into the context (@FFF4BA39) — an
  output/decode callback. (This is the byte sequence a printable-run scan
  mis-reported as the string "nmXNr"; it is code, not data.)

Hand-C: `ida\out\sub-tier2\fff4b084.c`.

## sub_FFEF2724 — menu/settings field-fetch dispatcher

**Signature:** `void fetch(menu_row_t *d)` in `R1`. `sub #4,sp`; pure leaf (external
callees = 0); 0 loops. 20 callers — the "sequencer/coordinator" family
(FFEE24DC, FFEE2FF5, …, FFF41C99, FFF4448B) that touch RAM `0x8C4D`/`0x8F73`.

**Descriptor (`R1`):** `[0]`=category 0xF0–0xFD, `[1]`=sub-index, `[2]`=OUT type tag,
`[3]`=base adjust (VFO/band/slot), `[4]`/`[5]`=OUT value bytes.

**Structure:** `cat = d[0]-0xF0; if (cat>0x0D) return` (@FFEF272E). Primary dispatch
reads `*(u16*)(0xFFF480CE + cat*2)` and `bra.l` (PC-relative from @FFEF273E). For
category 0xF1 a secondary dispatch reads `*(u16*)(0xFFF480EA + d[1]*2)` and `bra.l`
(from @FFEF282C). Each arm computes `rec = (u8*)(0x00008C4D + d[3])` and does
`d[4]=rec[OFF_A]; d[5]=rec[OFF_B]; d[2]=TYPE;` — a settings-shadow field pair plus a
value-type tag. Several arms branch on the sub-mode byte `*(u8*)0x00008CBA`
(= shadow[0x6D]) comparing 0/1/2 (@FFEF2981, FFEF2A23). Category 0xF3 (@FFEF2BA1)
uses an explicit `cmp`-chain on `d[1]` instead of a table.

**Jump tables (decoded from the image, PC-relative targets):**

```
FFF480CE  (bra.l @FFEF273E), d[0] = 0xF0..0xFD:
  F0->FFEF2740  F1->FFEF2817  F2->FFEF2B4E  F3->FFEF2BA1  F4->FFEF2E02
  F5->FFEF2EAB  F6->FFEF30D9  F7->FFEF325E  F8->FFEF3318  F9..FC->FFEF34AF(def)
  FD->FFEF3482
FFF480EA  (bra.l @FFEF282C), category 0xF1, d[1] = 0..0x15:
  0->282E 1->2853 2->34AF 3->2878 4,5->289D 6->28C2 7->28E7 8->290C 9->2931
  10->2956 11->297B 12->2A94 13->2AB9 14->2ADE 15->2B04 16,17->34AF 18->29F5
  19->2A1A 20->2B29 21->2853    (all FFEFxxxx)
```

Representative field map (category 0xF0): sub 3/4 → shadow[+0x3F],[+0x2B] type 0x02;
sub 6 → [+0x3A],[+0x26] type 0x13; sub 9 → [+0x24],[+0x22] type 0x13; sub 0xB →
[+0x24],[+0x22] type 0x0A. Full per-case offset map is in `ffef2724.lst`.

Hand-C: `ida\out\sub-tier2\ffef2724.c`.

## sub_FFF1F752 — FAT long-file-name directory path resolver

**Signature:** large frame (0xF4); args `R1`=dir/file object (`obj[0x5C]`=fs context)
plus R2–R4 and five stack args. 20 callers (FFF1668E/FFF16871 from `f_open`,
FFF1A0A6…, FFF27133…, FFF30665…). 7 loops.

**Structure (`fff1f752.lst`):**
- Builds an 8.3 short name in an 11-byte buffer: `blkset(buf,' ',0x0B)` then
  `buf[0]='.'` (@FFF1F786/90). 0x0B=11 = SFN length.
- Clears two 512-byte windows in the fs object `fs=obj[0x20]` at `fs+0x80C` and
  `fs+0xA0C` (`memset(.,0,0x200)` @FFF1F7C7/7DD); directory window at `fs+0x60C`.
- Tokenises the path (`sub_FFF2432F`, pushes `'r'`, @FFF1F83A); empty path → −0x47.
- Descends a component (`sub_FFF2DD4A`, @FFF1F86A); not-found −0x63 → −0x46.
- **LFN slot count:** `n = (len-1)/13 + 1` via `div #0Dh` (@FFF1F8ED), accumulated in
  `var_9E`. 13 = UCS-2 chars per LFN slot — definitive LFN handling.
- Name generation/validation via `sub_FFF20BA2` using the special-character table
  `0xFFF4ADEE` (`+,;=[]` …, @FFF1F8BE/8CF).
- Directory-entry scan loops: `sub_FFF20410` (dir_read next), `sub_FFF2E478`
  (memcpy 13-char fragment), `sub_FFF2E7EF` (name compare), `sub_FFF20698`
  (cluster→sector / get_fat for window refill, @FFF1F9C2). Errors −0x47/−0x46/−0x63.

Hand-C: `ida\out\sub-tier2\fff1f752.c`.

## sub_FFF162CD — f_open()

**Signature:** `void *f_open(path, mode, arg3)` (R1/R2/R3). `push.l r6`, 0x78 frame.
Single caller FFF162AC (public shim). 2 loops.

**Structure (`fff162cd.lst`):**
- Handle table: `count = *(s16*)0x00012512`, `base = *0x00065E24` (walker, stride
  **0x468**), context `*0x00065E2C`. Record fields: name `+0x23C`, flags `+0x442`
  (0=free, 0xFF=opening, 0x20=open, bit0=write), fs context `+0x5C`.
- Acquire lock `sub_FFF15D69`; on failure return `mk_result(-40)` (@FFF16303–16).
- Loop @FFF163CB `for (i=0; i<count; i++, rec+=0x468)`: track first free slot
  (`rec[0x442]==0`); compare `name_cmp(rec+0x23C, path)` via `sub_FFF224CF` (0=match).
- Already-open handle → allow only `"r+"` (`cmp 'r'`,`cmp '+'` @FFF1635E/66), else
  `mk_result(-7)`. Table full → `mk_result(-10)` (@FFF163F5).
- Claim slot: `rec[0x442]=0xFF`, `blkcopy` (`sub_FFF2E4AF`), mode dispatch
  (`r`/`w`/`a`/`+` @FFF16768/16822/168E9), create/truncate via
  `sub_FFF26289/FFF26346`, final flags `rec[0x442]=0x20 | (mode has '+' ? bit0 : 0)`
  (@FFF168E0/EF), unlock `sub_FFF15D74`. Negative errno −1…−5,−7,−10,−13,−40 built
  by `sub_FFF1EE7B`.
- Calls Lane F7's own `sub_FFF1F752` (path resolver) at @FFF1668E and @FFF16871.

Hand-C: `ida\out\sub-tier2\fff162cd.c`.

## sub_FFF1898D — f_write()

**Signature:** `void *f_write(fp, size, count, …, userbuf)`; `R4`=FIL*, stack arg_0 =
user buffer. 0x64 frame. 3 callers FFF188F6/FFF28945/FFF2899B. 7 loops.

**Structure (`fff1898d.lst`):**
- `total = size*count` (@FFF189AA `mul`). Object fields: fs `[0]`, window `[4]`,
  valid flag `[8]`, window offset `[0x14]`, cluster `[0x20]`, fptr `[0x28]`, size
  `[0x2C]`, large field `[0x238]`, first-cluster flag `[0x44C]`, dirty word `[0x464]`;
  `fs[0x5C]` = cluster size (used in `divu`, @FFF189BE).
- `if (fptr == -1) return mk(-0x3B)` (@FFF189E8). **Overflow clamp:** `avail =
  0xFFFFFFFF - fptr; if (total>avail){ total=avail; count=total/size; }`
  (@FFF189FA/A05/A11) — the exact FatFs `f_write` clamp, so this is write not read.
- Cluster/sector loop: allocate/extend chain via `sub_FFF1F0A2` (create) /
  `sub_FFF1F011` (follow) when at a cluster boundary (`sub_FFF1EED8` tests need);
  full-sector fast path writes straight from the user buffer via
  `sub_FFF24802`/`sub_FFF24892` (multi-sector disk I/O); partial writes
  `memcpy(window+off, userbuf, chunk)` (user→window) via `sub_FFF2E478` (@FFF18B64).
- Advance fptr/win_off; extend `fsize` when `fptr>fsize` (@FFF18B92); set dirty
  `fp[0x464]=1` (@FFF18BA5). Alloc failure → −0x0B. Finalise via `sub_FFF1EE20`.

Hand-C: `ida\out\sub-tier2\fff1898d.c`.

## Open

1. **JPEG table semantics (`FFF4B084`).** The ROM tables at `0xFFDA0000`–`0xFFDCFFFF`
   (default Huffman/quant/sentinel) and the exact IDCT variant were not fully
   expanded — the entropy/IDCT inner loops are characterized but not reconstructed
   coefficient-by-coefficient. The decoder clearly cooperates with the 10 KB
   dispatcher `sub_FFF4C9D1` (another lane) — a joint pass would nail the segment
   handler table.
2. **`FFEF2724` full case map.** Categories 0xF2,0xF4–0xF8,0xFD (and the 0xF1 arms
   0x0C–0x15) are dispatched and located but their per-field offsets are only in the
   listing, not transcribed to C. A mechanical pass over `ffef2724.lst` would yield
   the complete menu-row → settings-offset table (useful for the menu-extension work
   in doc 23).
3. **Confirm the settings-shadow identity.** `0x00008C4D` is treated here as the
   settings/EEPROM shadow base; cross-check against the EEPROM map in doc 23
   (`0xFF8920`…) to pin the exact field meanings behind the offsets.
4. **Mission relevance (USB / SDR / DSP): negative, and clean.** These five routines
   are the SD-card/FAT filesystem, a JPEG image decoder, and the menu/settings UI.
   None reads or writes any peripheral register, USB, or DSP interface; their 63
   callees contain no peripheral access. This is consistent with doc 21/doc 02: the
   SUB side's data path here is SD ↔ RAM ↔ LCD, with no USB or IQ/vocoder surface.
   The JPEG decoder is the one component that moves large pixel buffers — but to the
   LCD, from the SD/file layer, not to any external port.
