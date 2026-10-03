# Hidden features, dead code, and lineage in the FT3DR ver 1.02 images

> **COMPLETE.** The resume pass settled every open item: the boot-hold key gate
> that selects the second USB personality (§8.1), the receive-side DATA-jack
> opcode table (§8.3), the region/expanded-RX mechanism (§8.4), and the source of
> the `DSP WRITE MODE` gate byte (§8.5). The boot-hold gate also **resolves the
> project's #1 open question** (RESUME-DEEP): the CDC-ACM USB personality is
> **live, not dead** — its descriptors are copied to RAM at boot and installed by
> a held-key boot path. New gate → feature table:
> `ida\out\hidden\hidden_gates_table.tsv`.
>
> Agent: **HIDDEN**. Databases `HID_MAIN`, `HID_SUB` under `ida\db\jobs\`.
> Job scripts `ida\jobs\hidden_*.py` (resume pass added `hidden_keys.py`).
> Tables `ida\out\hidden\`. NB: the workspace was relocated to
> the repository root; `run_job.py`'s `ROOT` and the job scripts' hardcoded
> `./...` paths are stale — the resume pass ran through a private launcher
> copy with the corrected root, and `hidden_keys.py` uses absolute output paths.

## Verdict

**The one true key-combination gate in this firmware is a boot-hold in MAIN that
switches the USB device personality.** At reset, `sub_20FA` polls the keypad-matrix
port `@0xFFFF4C` up to 200 times; if the held key reads `0x7D` (masked `&0x7F`;
decoded to internal key id `0x11` by `sub_100E4`), it sets selector `@0xFF813A = 1`
and runs the alternate USB init at `0x078106`, which drives the engine from the
CDC-ACM descriptor set (VID `0x26AA`/PID `0x0020`) copied into RAM at boot. With no
key held, it installs the default vendor personality (PID `0x0001`). This is the
answer to two questions at once: it is the sole boot-hold feature gate, and it
proves the **CDC-ACM personality is live, not dead** — settling RESUME-DEEP's
single most important open item in MAIN-IO's favour. Beyond it there is a second
boot-hold path (an 11-entry key table `dword_10216` → index at `0xFFA9EF`; index 6
= a settings/VFO default-reset), and no other key/boot gate exists. **There is no
MARS/CAP-style expanded-RX/TX unlock reachable by key, menu, or jumper**: band
coverage is fixed by a stored destination index (`@0xFF9E1F` → table `@0x3EA2` →
`USA/JPN/EXP` + the per-destination band table at `0x0000F5F0`), changeable only by
rewriting the stored settings (service/clone tool) — no on-radio soft gate, and no
`ADJUST`/`ALIGN`/`CALIB`/`SERVICE`/`FACTORY` vocabulary anywhere in either image.

At the level of **code**, there is essentially no dead functionality in either
image. After raising coverage to 442,143 code bytes in MAIN (87% of the ~505 KB
of content, 4,025 functions) and 229,597 in SUB, and after filtering the naive
orphan list for coherence and for a real function prologue, exactly **15
unreferenced routines survive in MAIN, the largest 330 bytes, ~864 bytes in
total, and zero in SUB**. Every large "orphan" is either a switch-case block
reached by a computed jump or data that the linear sweep decoded as
instructions. So the honest answer to "is there a big compiled-out feature
hiding in here" is **no, not as code**.

The dark corners are instead at the level of **data and gating**, and there they
are real and numerous. MAIN carries a complete, wired-up **USB CDC-ACM virtual
COM port personality** whose descriptors still contain unmodified Renesas sample
boilerplate, including the USB Printer Class specification's literal `ACME
Manufacturing` example device-ID string — vendor sample code shipped in a
production radio. MAIN carries a **shipped ASCII trace of the CPU↔DSP link**
(`CPU>DSP: MUTE ON`, `DSP>CPU: NAK`, `TIME OUT:3sec!`), and one of its two
formatters is among the 15 dead routines. SUB carries a **boot-time screen
dispatcher with seven screens**, one of which is `---DSP WRITE MODE----` /
`Push DISP Key!`, selected by `*(uint8*)0x00008C4E == 8`. The **Renesas CC-RX
`lowsrc.c` standard-I/O library is linked into SUB**, which means a `printf`
path and a character hook exist. And the clone-file record table in MAIN
contains **one template that nothing references: the FT2D header
`V0020FT2D JPN Ver0202 20180418`**, sitting among thirteen FT3D templates that
are all referenced — the cleanest lineage artifact in the package.

On lineage I must **correct a reading that was circulating**: the model-name
table at MAIN `0x04C32C` is *not* shared-codebase evidence. It lists
`TH-D7`, `TM-D700`, `TM-D710`, `TH-D72`, `TH-D74` alongside the Yaesu models —
those are Kenwood radios. It is the **APRS MIC-E device-type decode table**, used
to display the *sender's* radio model on a received packet. Likewise `APY03D` at
`0x04B182` is the FT3D's own registered APRS tocall, not a project codename. The
genuine lineage evidence is narrower and better: the dead FT2D clone template,
and the inherited-but-live camera/snapshot path.

---

## Method

### What I ran

| Pass | Script | Database | Result |
| --- | --- | --- | --- |
| 1 baseline | `ida\jobs\hidden_atlas.py` | `HID_MAIN`, `HID_SUB` (seeded `--copy-from ida\db\radio\{MAIN,SUB}.i64`) | MAIN 1,298 funcs / 39,812 code bytes (3.8% of image); SUB 455 / 39,953 |
| 2 coverage | `ida\jobs\hidden_cover.py` | both, `--reopen` | MAIN 4,025 funcs / 442,143 code bytes; SUB 1,912 / 229,597 |
| 3 atlas + reach | `ida\jobs\hidden_report.py` | both | string xrefs, first reachability cut |
| 4 coherence | `ida\jobs\hidden_gates.py` | both | prologue/coherence-filtered orphans, full listings, caller chains |
| 5 service mode | `ida\jobs\hidden_service.py` | `HID_SUB` | the seven boot screens, 2,394 settings-struct access sites |
| 6 resume | `ida\jobs\hidden_keys.py` (new) | `HID_MAIN`, `HID_SUB`, `--reopen` | boot-hold gates, USB personality selection, DATA-jack RX opcodes, region origin, DSP-write-mode source — outputs `keys_funcdump_{main,sub}.txt`, `keys_dataxref_{main,sub}.txt` |

The resume pass targets are driven by `ida\out\hidden\_keys_targets_{main,sub}.txt`
(TAB-separated `addr / label / opt`, where `opt` is `W=<n>` for an instruction
window or `D` for a data-xref query); edit and `--reopen` to iterate cheaply. The
workspace had been relocated to the repository root, so `run_job.py`'s
`ROOT=.` no longer resolves; I ran through a private launcher copy with the
corrected root and gave `hidden_keys.py` absolute output paths. All whole-image
byte facts below were independently confirmed in plain Python against
`decrypted\FT3D_MAIN_ver102_EXP.bin` (100% coverage, no IDA).

Pure-Python passes (no IDA), scripts in my session scratchpad, outputs in
`ida\out\hidden\`: exhaustive string extraction, a coverage-independent pointer
index, a "who points into this window" query, the atlas join, and a scan for
opcode compare chains.

### The coverage-independent reference test — why the numbers here are trustworthy

An IDA xref only exists where IDA disassembled the referencing instruction, so
on the inherited 3.8% MAIN coverage "unreferenced" meant nothing. I therefore
built `_ptrindex_{main,sub}.tsv`: **every pointer-shaped word at every offset in
the image**, in the image's own byte order, filtered to in-image targets. MAIN
8,353 distinct 32-bit targets, SUB 5,775. This is independent of disassembly
coverage, so a "no pointer anywhere in the image" result is a real negative.

Two corrections I had to make, both of which had been producing false positives:

- **H8S 16-bit absolutes.** `@aa:16` sign-extends, so it reaches ROM only in
  `0x0000`–`0x7FFF`; `0x8000`–`0xFFFF` maps to `0xFF8000`–`0xFFFFFF`, which is
  RAM and I/O. My first index accepted 16-bit targets up to `0xFFFF` and
  produced ~19,000 bogus targets with hit counts in the hundreds (e.g. "119
  references to `0x0000F628`" — all of them RAM accesses to `0xFFF628`).
  Corrected to `0x0100`–`0x7FFF`.
- **Round constants.** A 32-bit target like `0x00040000` shows 54 "sources";
  those are immediates that happen to equal the address. I do not treat a
  single-source hit on a round value as a reference without reading the
  instruction.

### Indexed access — the false-negative pattern

MENU established that SUB's 117 setup labels are reached only as
`menu_table[cat].labels[item]` from base `0xFFED74E8`, so every one has a null
xref while being live. I handled this in the atlas with an **`access`** column:

- `direct` — a pointer lands on the string or inside it;
- `indexed_possible` — no pointer of its own, but the nearest address that *is*
  pointed at is within 1,024 bytes, so `base + index*stride` is plausible;
- `none_found` — nothing pointed at within 1,024 bytes in either direction.

Only `none_found` is a candidate for "compiled out", and even then only after
reading the surrounding bytes. Counts: MAIN 1,152 direct / 5,628
indexed_possible / **138 none_found**; SUB 803 / 8,568 / **7,265 none_found**
(SUB's large `none_found` count is dominated by the RGB565 and glyph regions in
`0xFFC00000`–`0xFFE80000`, which sub-lower classified as 87% bitmap data — those
are printable byte runs inside images, not strings).

### What I could not cover

- The **receive-side opcode table** of the DATA-jack protocol. Localised, not
  enumerated. This is the main gap.
- SUB `0xFFC00000`–`0xFFEC0000` was swept only in the small islands; per
  sub-lower it is 87% RGB565 bitmap and 9% glyph data, so I judged a full sweep
  not worth the cost. If that judgement is wrong, my SUB orphan count of zero is
  scoped to `0xFFEE0000`–`0xFFF50000` plus `0xFFEC0000`–`0xFFEE0000`.
- I did not decode the Japanese strings in the boot-screen pool. They are stored
  as 7-bit JIS with the high bit stripped and my decode attempts failed; they
  are readable with the right table but I ran out of pass.
- I did not determine what writes the value 8 into the boot-mode byte.

---

## Findings

### 1. The string atlas

`ida\out\hidden\strings_main.tsv` (6,918 rows) and `strings_sub.tsv` (16,636
rows). Columns: `offset addr len bytes enc term class n_ptr_refs n_ida_xrefs
nearest_ptr nearest_delta access refs text`. ASCII plus UTF-16 in both byte
orders for each image, minimum length 4.

| class | MAIN | SUB |
| --- | --- | --- |
| unknown | 5,434 | 11,590 |
| status message | 1,141 | 4,104 |
| UI label | 96 | 560 |
| font or resource data | 94 | 259 |
| format string | 131 | 73 |
| protocol constant | 1 | 23 |
| debug text | 18 | 10 |
| file path | 2 | 17 |
| build banner | 1 | 0 |

The large `unknown` bucket is mostly short printable runs inside kanji index
tables and bitmap data; it is not a backlog of undiscovered features. The
`refs` column tags every referencing offset with the function that contains it,
so the tables are directly usable for "who prints this".

Also written: `_raw_strings_{main,sub}.tsv` (the unjoined extraction),
`_ptrindex_{main,sub}.tsv` (the reference index), `strxref_{main,sub}.tsv`
(IDA's own view), `idastrings_{main,sub}.tsv`, `names_*.tsv`, `segments_*.tsv`,
`coverage_*.tsv`, `functions_*.tsv`, `xrefs_*.tsv`, `reach_*.tsv`.

### 2. Lineage — what the other-model names actually mean

**Correction first.** Two artifacts that look like shared-codebase evidence are
not:

- **MAIN `0x04C32C`, 9-byte stride, 17 entries** — `TH-D7`, `TM-D700`,
  `TM-D710`, `McE-Msg`, `YAESU`, `VX-8`, `McE-Trk`, `FTM-350`, `VX-8G`,
  `TH-D72`, `FT1D`, `FTM-400D`, `FT2D`, `FTM-100D`, `FT3D`, `TH-D74`,
  `-------`. Five of these are **Kenwood** models and two (`McE-Msg`,
  `McE-Trk`) are MIC-E message/tracker types, not radios. This is the **APRS
  MIC-E device-type decode table**: it turns the device-ID suffix on a received
  MIC-E packet into a model name for display. Referenced once, from `0x04C2AA`,
  at the table base `0x0004C32C` (the two bytes before `TH-D7` are a header).
  A radio that decodes APRS *must* carry its competitors' names. **Not lineage.**
- **MAIN `0x04B182`** — `00 07 "APY03D"`, and again bare at `0x04B18A`.
  `APY03D` is the **registered APRS tocall for the FT3D** (`APY01D` = FT1D,
  `APY02D` = FT2D, `APY400` = FTM-400). The `00 07` prefix is the length for the
  AX.25 destination field. This is the radio's own identity, **not a codename**.

**The real lineage evidence**, and it is much better because it is *dead*:

MAIN `0x06C538`–`0x06C655` holds the clone/backup record templates for the
DATA-jack protocol. Each is `SOH(0x01) <letter opcode> <4 ASCII-hex length>
<ASCII payload> EOT(0x04)`. I resolved all fourteen and their referencing
emitters:

| template | opcode | referenced from | payload |
| --- | --- | --- | --- |
| `0x06C538` | `V` | `0x06BD44` (`sub_6BD3E`) | `0030` `FT3D … 20180418 0 … 0C01` |
| **`0x06C572`** | **`V`** | **no pointer anywhere in the image** | **`0020` `FT2D    JPN     Ver0202 20180418`** |
| `0x06C598` | `B` | `0x06BEBE` | `0001` `0` |
| `0x06C5A0` | `C` | `0x06BEFC` (`sub_6BED8`) | `000B` `00000000000` |
| `0x06C5B2` | `E` | `0x06BF72` (`sub_6BF6C`) | `0001` `0` |
| `0x06C5BA` | `F` | `0x06BF4A` (`sub_6BF44`) | `0001` `0` |
| `0x06C5C2` | `S` | `0x06BF92` (`sub_6BF8C`) | `0001` `0` |
| `0x06C5CA` | `H` | `0x06C1A6` (`sub_6C19A`) | `001E` |
| `0x06C5D0` | `R` | `0x06C362` (`sub_6C344`) | `0061` `0` |
| `0x06C5D8` | `R` | `0x06C382` (`sub_6C344`) | `0089` `2` |
| `0x06C5E0` | `R` | `0x06C372` (`sub_6C344`) | `00BB` `3` |
| `0x06C5E8` | `P` | `0x06BEDE` (`sub_6BED8`) | `000B` `000000000000` |
| `0x06C5FA` | `N` | `0x06C02E` | `0001` `0` |
| `0x06C602` | `W` | `0x06C3E4` (`sub_6C3DE`) | `0048` lat/long-shaped payload |

**Thirteen of fourteen templates have exactly one referencing emitter. The
fourteenth is the FT2D header and has none.** It names the predecessor model,
its market (`JPN`) and its firmware version (`Ver0202`), and it shares the build
date `20180418` with the FT3D record, so it was assembled by the same build. The
`V` record's length field also gives the version scheme: `0030` = 48 bytes for
FT3D, `0020` = 32 for FT2D.

**The inherited-but-live feature is the camera / snapshot path.** MENU
established that `USB CAMERA` (`0xFFC3E709`) is `menu_table[11].labels[0]` in
`OPTION`, reachable and ungated, with a working settings screen at
`sub_FFF08201`. My side of it, the supporting data, is all present and mostly
live:

- SUB `CAMERA` `0xFFF4A4C1` ← `0xFFF08372` (`sub_FFF08201`) — direct.
- SUB `PICT` `0xFFF4860F` and `0xFFED7AD8`; `PHOTO` `0xFFF4AFE7` ←
  `0x2D832C`; `I:\PHOTO` `0xFFF4AD9A` ← `0x2D7EA4` — both from pointer arrays
  in the `0xFFED7xxx`/`0xFFED8xxx` descriptor region.
- MAIN `Send pictures` `0x00043636`, `PICT` `0x000433E6` / `0x00043408`,
  `_PICT` `0x0006735A`, `.jpg` `0x0006A976` ← `0x0006A5EA` (`sub_6A5C8`),
  `0x0006A824` (`sub_6A802`), `0x00071112` (`sub_710D2`) — three live callers.

So the picture feature is not compiled out on either side: SUB has the menu and
the settings screen, MAIN has the `.jpg` handling and the `PICT` message tag for
C4FM transport. Whether the FT3D's shipped accessory range includes the camera
microphone is a product question, not a firmware one.

Shared between the two images byte-for-byte: the 273-byte and 402-byte JIS index
blobs at MAIN `0x079C9D` / `0x07A400` and SUB `0x03BDB3` / `0x03C516`. The same
kanji table was compiled into both the H8S and the RX build.

### 3. Build and source artifacts

`ida\out\hidden\build_artifacts.tsv`. The headline results:

**No source file paths, no `.c`/`.h` names, no assert strings, no compiler
version banner, and no function-name strings exist in either image.** I searched
the full byte range of both files for `.c`/`.h`/`.cpp`/`.inc`/`.asm`
extensions, for `[A-Za-z]:\`, for `Renesas`/`Hitachi`/`KPIT`/`CC-RX`/`ch38`/
`ch308`, for `Copyright`, and for `assert`/`__FILE__`. Confirmed absent. Both
builds were made with debug information stripped and `NDEBUG` set. The compiler
identification in `docs\compiler.md` stands on instruction idiom, not on a
banner.

What *is* there is library identification, which is nearly as good:

- **The Renesas CC-RX low-level I/O library is linked into SUB.**
  `ENV1=temp01` / `ENV2=temp02` / `ENV9=end` at `0xFFF484B0`/`BC`/`C8` and
  `<drive C>\stdin` / `<drive C>\stdout` / `<drive C>\stderr` at `0xFFF484D1`/`DC`/`E8` are the
  verbatim `env_list[]` and `name_list[]` arrays from Renesas's `lowsrc.c`
  sample. `<drive C>\stdin` is referenced from `0xFFEE17B6` and `0xFFEE18B2`
  (`sub_FFEE18A6`). This means `printf`-family output is compiled in and there
  is a `charput()` character hook somewhere — a latent debug console. I did not
  find where `charput` writes; that is a high-value follow-up.
- **The GPS receiver is a MediaTek MT33xx-class part.** Seventeen `$PMTK`
  commands at `0xFFF483E8`–`0xFFF484AF`, reached through a pointer array at
  `0xFFED4288`: `$PMTK313,1` (SBAS), `$PMTK314,…` (NMEA sentence rates),
  `$PMTK225,0` (periodic power mode), `$PMTK286,1` (active interference
  cancellation), `$PMTK330,0/1/2/212/213` (datum — 212/213 are Japanese datums),
  `$PMTK386,0.6/1.0` (static navigation threshold), `$PMTK301,0/1/2` (DGPS).
  PMTK is MediaTek's proprietary command set. → **WIRELESS**.
- **Unmodified Renesas USB sample boilerplate in MAIN**, covered in §5.
- CC-RX runtime literals: `0123456789abcdef` / `0123456789ABCDEF` at
  `0xFFF4B022`, `false` / `true` at `0xFFF4B04A`.
- A full FAT implementation, not a minimal reader: `RRaA` / `rrAa` (FAT32
  FSInfo signatures) at `0xFFF4AE2A`, `EXFAT`/`FAT32`/`FAT12`/`FAT16` at
  `0xFFF4AE14`, and a **FAT16 boot-sector template `NO NAME    FAT16`** at
  `0xFFC3E8CB` — the firmware can format a volume. → **STORAGE**.
- Build date: `20180418` in both `V` records at MAIN `0x06C538` and `0x06C572`.

### 4. Unreferenced and unreachable code

`ida\out\hidden\orphans.tsv`, merged and ranked, with the per-image censuses in
`orphans_main.tsv` / `orphans_sub.tsv` and full reachability in `reach_*.tsv`.

Reachability roots were the reset entry, every vector-table target (MAIN 256
slots at `0`; SUB `EXTB` 32 at `0xFFFFFF80` and `INTB` 256 at `0xFFED8A70`), and
**every function whose address appears as a data pointer anywhere in the image**
(MAIN 2,856, SUB 15) — that last set is what keeps pointer tables, vector slots
and computed jumps from being miscounted as dead, as the brief requires.

The naive result was 792 MAIN and 318 SUB orphans, and it was **almost entirely
wrong**. Each candidate was then scored for coherence (fraction of bytes decoded
as instructions, distinct mnemonics, printable-ASCII fraction, zero fraction,
whether it ends in a return) and for a real function prologue:

| classification | MAIN | SUB |
| --- | --- | --- |
| **TRUE_ORPHAN** (coherent code, real prologue, ends in a return, zero refs of any kind) | **15** | **0** |
| switch-case or inner block (no prologue — reached by computed jump) | 249 | 4 |
| swept data: table / text / no-return / other | 518 | 79 |
| in a data region (kanji, glyph, RGB565) | 0 | 223 |

Worked examples of the false positives, so the filter can be trusted:

- `0x0003CF7C`, 1,010 bytes, the top of the naive MAIN list: begins `FF F4`
  which is a fragment, contains `.byte` holes, and its body is full of
  `jmp loc_3D1EE:24`. It is a **switch-case block** whose head I mis-detected,
  reached by a computed jump.
- `0xFFEC23E1`, 14,602 bytes, the top of the naive SUB list: begins
  `00 38 00 39 00 3A 00 3B` — a 16-bit index table in the kanji region.
- `0x0000F950`, 422 bytes: begins `05 00 00 00 05 40 00 00` — it is the band
  table of §6.

**The 15 true MAIN orphans, ranked:**

| # | address | size | what it is |
| --- | --- | --- | --- |
| 1 | `0x00059064` | 330 | leaf, `mov.l #0xFFB13E, er5` then `mov.l @er5, er4` chains; a RAM-block accessor |
| 2 | `0x0005A482` | 132 | **the CPU→DSP trace formatter** — `mov.l #0x0005AE1E, er5` (the `PU>DSP: ` prefix), `mov.l #0x00FF2DC8, er6` (the trace buffer), `eepmov.w`. Its DSP→CPU sibling `sub_5A7F2` is live. See §5. |
| 3 | `0x00009F9E` | 114 | `push.w r5/r3`, works on `0xFF3D72` |
| 4 | `0x00067802` | 74 | leaf, calls `0x00061D8C` with `0x000677BA` |
| 5 | `0x00064450` | 66 | leaf, `mov.w #0x0010,e4` + `mov.l #0xFFB4A8, er5` |
| 6 | `0x000175D6` | 62 | leaf, calls `sub_3F628` with `0x00017614` |
| 7 | `0x00056BFE` | 46 | `eepmov.w` stub, `0x00004C14` → `0xFEF926` |
| 8 | `0x00069B6E` | 38 | twin of #5 with buffer `0xFFAE22` |
| 9 | `0x00067796` | 36 | twin of #4 |
| 10 | `0x0006ACA0` | 22 | `push.l er1`, reads `0xFFB05E` — the destination byte of §6 |
| 11–15 | `0x00016AC6`, `0x00016B68`, `0x0004CAA6`, `0x0001889A`, `0x00077202` | 16,16,16,14,12 | one-line copy/set stubs |

Total ~864 bytes. Seven of the fifteen are `eepmov.w`/immediate-load stubs —
the signature of a generated per-buffer helper whose one call site was removed.
Nothing here is a feature. **There is no large compiled-out feature in either
image at the code level**, and given the coverage figures that is now a real
negative rather than a coverage artifact.

### 5. Debug, test, service and factory paths

#### 5.1 The CPU↔DSP ASCII trace facility — MAIN, shipped and live

MAIN `0x0005AE1C`–`0x0005AF6E` holds a direction-prefixed message set and two
pointer tables. Every string is referenced:

| address | string | referenced from |
| --- | --- | --- |
| `0x0005AE1C` | `CPU>DSP: ` | `0x0005A484` (`sub_5A482`), `0x0005A50C` |
| `0x0005AE28` | `DSP>CPU: ` | `0x0005A7F8` (`sub_5A7F2`) |
| `0x0005AE5A` | `DSP POWER:ON & RESET! \r\n` | `0x0005AE36` (table) |
| `0x0005AE72` | `TIME OUT:3sec!\r\n` | `0x0005AE3A` (table) |
| `0x0005AE82` | `DSP?\r\n` | `0x0005AE3E` (table) |
| `0x0005AE88` / `0x96` | `DSP>CPU: ACK` / `NAK` | `0x0005AE46` / `0x4A` (table) |
| `0x0005AEA4` / `0xB2` | `CPU>DSP: ACK` / `NAK` | `0x0005AE52` / `0x56` (table) |
| `0x0005AEC0` | `CPU>DSP: RX DISABLE` | `0x0005A5BE` |
| `0x0005AED6` | `CPU>DSP: RX ENABLE` | `0x0005A5B6` |
| `0x0005AEEA` / `0xFC` | `CPU>DSP: MUTE ON` / `MUTE OFF` | `0x0005A75C` / `0x0005A754` |
| `0x0005AF10` | `CPU>DSP: STOP ENCODE` | `0x0005A5A8` |
| `0x0005AF26` | `CPU>DSP:VER?` | `0x0005A5A0` |
| `0x0005AF34` | `DSP>CPU: DATA TEXT SET` | `0x0005A8B8` (`sub_5A7F2`) |
| `0x0005AF4C` / `0x5E` | `DSP>CPU: TERM TX` / `TERM RX` | `0x0005A8C0` / `0x0005A8C8` |

The indexed table sits at `0x0005AE34`–`0x0005AE5A`; the direct `mov.l #imm`
sites are in `0x0005A4xx`–`0x0005A8xx`. Two functions immediately before the
strings (`0x0005AD82`, `0x0005AE12`) end in `mov.l #0x00FF2DC8, er3 ; rts`, so
**`0x00FF2DC8` is the RAM trace buffer**.

Reachability: `sub_5A7F2` (DSP→CPU direction) is **live** — called from
`0x00056432` in `sub_5642C`, itself entered from loose code at `0x0005640E`.
`sub_5A482` (CPU→DSP direction) has **zero references** and is orphan #2 of §4.
So the receive direction of the trace is wired up and the transmit-direction
formatter is dead, while the CPU→DSP *messages* are still emitted from six other
sites. The coordinator reports the gate as `0xFF8C26` bit 7 with
`0xFF8C28 ∈ {3,4,5}` routing this out of the DATA jack; that is consistent with
what I see and I did not re-derive it. → **DSP-AMBE**, **MAIN-IO**.

This is the most useful debug facility in the package: it names the CPU↔DSP
command vocabulary directly — power/reset, version query, RX enable/disable,
mute, stop encode, data-text set, terminate TX/RX, ACK/NAK, 3-second timeout.

#### 5.2 The boot-screen dispatcher — SUB, seven screens including DSP WRITE MODE

`sub_FFF0D6D9` at `0xFFF0D6D9`, 74 bytes, is a switch on the byte at
`0x00008C4E` (encoded as `mov.l #8C4Dh, r1 ; movu.b 1[r1], r1`):

```
FFF0D6D9  FB 12 4D 8C 00 00   mov.l  #8C4Dh, r1
FFF0D6DF  B0 19               movu.b 1[r1], r1        ; [0x00008C4E]
FFF0D6E1  61 B1  20 38        cmp #0Bh / beq  -> sub_FFF0E617
FFF0D6E5  61 51  20 1A        cmp #5   / beq  -> sub_FFF0DA4B
FFF0D6E9  61 71  20 1A        cmp #7   / beq  -> sub_FFF0DB03
FFF0D6ED  61 81  20 1A        cmp #8   / beq  -> sub_FFF0DE56   <-- DSP WRITE MODE
FFF0D6F1  61 91  20 1A        cmp #9   / beq  -> sub_FFF0E118
FFF0D6F5  61 A1  20 1D        cmp #0Ah / beq  -> sub_FFF0E392
FFF0D6F9  61 21  21 27        cmp #2   / bne  -> return
FFF0D6FD  39 41 00            bsr.w  sub_FFF0D73E
FFF0D722  02                  rts                      ; any other value: nothing
```

| value | handler | size | identifying strings |
| --- | --- | --- | --- |
| 2 | `sub_FFF0D73E` | 781 | `---CALLSIGN  INPUT---`, `Please enter your`, `(Max 10 letters)`, a Japanese line |
| 5 | `sub_FFF0DA4B` | 184 | none |
| 7 | `sub_FFF0DB03` | 851 | four Japanese lines (7-bit JIS, not decoded) |
| **8** | **`sub_FFF0DE56`** | **706** | **`---DSP WRITE MODE----`, `Push DISP Key!`, `Loading...`, `Complete`** |
| 9 | `sub_FFF0E118` | 634 | none |
| 0x0A | `sub_FFF0E392` | 645 | none |
| 0x0B | `sub_FFF0E617` | 457 | `TYPE    : `, `Complete` |

Mode 2 is the documented first-power-on callsign entry. Mode 8 shares its
`---…---` framing, so **`DSP WRITE MODE` is a boot-time mode in the same family
as the first-run wizard.**

`sub_FFF0DE56` (`0xFFF0DE56`–`0xFFF0E118`, coherence 1.00, ends `rtsd`) copies
the four strings onto the stack with `smovf`, assembles `Complete` from the
immediates `#6574656Ch` (`lete`) and `#706D6F43h` (`Comp`), reads
`[0x00008C6D]` and `[0x00008C6E]`, clears a 320-pixel-wide region via
`sub_FFEF04F7`, and draws through `sub_FFEF1B23`.

**The gate, stated exactly.** The entry condition is
`*(uint8*)0x00008C4E == 8`, tested at `0xFFF0D6ED`. That byte is not a secret:
it is the boot-screen selector, read at 2,351 sites across the `0x00008C4D`
settings shadow. The only **write** I found is in `sub_FFEEB057` at
`0xFFEEB09F`:

```
FFEEB09F  mov.l #8C4Dh, r14 ; mov.l #8E46h, r15 ; mov.b 1[r15], 1[r14]
```

i.e. `[0x00008C4E] = [0x00008E47]` — the applied shadow is loaded from the
stored settings image, the same stored/applied pair MENU found for
`RAM DISPLAY`. `sub_FFEE5DCA` at `0xFFEE5DCE` compares the two.
**I did not find any code that writes the constant 8, and I found no key
combination anywhere in this path.** The outer wrapper at
`0xFFF0CF4D`–`0xFFF0CF78` guards the call with
`sub_FFEEF9BB(0x0001D3B8, 0, 0, 0x140)` returning 1, but with `0x140` = the
320-pixel LCD width as an argument that is a display-update predicate, not a
permission check. So: **the gate is a stored settings byte at `0x00008E47`
reaching the shadow at `0x00008C4E`, and I could not determine what sets it
to 8.** → **DSP-AMBE**.

#### 5.3 A second USB personality in MAIN, with Renesas sample boilerplate

MAIN contains **two complete USB device descriptor sets**. The coordinator has
the boot-path gate (poll `0xFFFF4C` up to 200 times, `& 0x7F == 0x7D` →
`0x078106`); my contribution is the descriptors themselves and their reference
status.

Set 1, **vendor-specific, live** — `0x00055818`, referenced from `0x00055134`:

```
12 01 00 02 00 00 00 08 AA 26 01 00 00 00 00 00 00 01
bcdUSB 0x0200, class 00/00/00, EP0 8 bytes, VID 0x26AA, PID 0x0001, 1 config
```

Six configuration descriptors follow at `0x0005582A`, `0x5585E`, `0x5587E`,
`0x5589E`, `0x558BE`, `0x558DE`, identical except the last byte:

```
09 02 20 00 01 01 00 C0 32   config: 32 bytes total, 1 interface, 100 mA
09 04 00 00 02 FF 01 FF 00   interface 0, 2 EPs, class FF/01/FF vendor specific
07 05 01 02 40 00 00         EP 0x01 OUT BULK, 64 bytes
07 05 83 03 08 00 XX         EP 0x83 IN INTERRUPT, 8 bytes, bInterval XX
```

`bInterval` takes 0x64, 0x14, 0x64, 0x96, 0xC8, 0xFA (100, 20, 100, 150, 200,
250 ms) across the six — six pre-built variants differing only in the interrupt
poll rate.

Set 2, **CDC-ACM**, `0x0007B680`, **no pointer anywhere in the image**:

```
12 01 10 01 02 00 00 08 AA 26 20 00 00 01 00 00 03 01
bcdUSB 0x0110, class 0x02 CDC, VID 0x26AA, PID 0x0020, bcdDevice 0x0100,
iSerialNumber 3
```

and its configuration at `0x0007B711`, also with no pointer:

```
09 02 43 00 02 01 00 C0 10   67 bytes, 2 interfaces, 32 mA
09 04 00 00 01 02 02 01 00   interface 0, class 02/02/01  CDC ACM, AT commands
05 24 00 10 01               CS_INTERFACE Header,  bcdCDC 0x0110
04 24 02 06                  CS_INTERFACE ACM,     bmCapabilities 0x06
05 24 06 00 01               CS_INTERFACE Union,   master 0 slave 1
05 24 01 03 01               CS_INTERFACE CallMgmt, caps 3, data interface 1
07 05 83 03 08 00 10         EP 0x83 IN INTERRUPT 8 bytes, 16 ms
09 04 01 00 02 0A 00 00 00   interface 1, class 0x0A CDC-DATA, 2 EPs
07 05 01 02 40 00 00         EP 0x01 OUT BULK 64
07 05 82 02 40 00 00         EP 0x82 IN  BULK 64
```

**This is a textbook USB CDC-ACM virtual COM port** — bulk IN and bulk OUT at
64 bytes plus an 8-byte notification endpoint. It pairs with the SUB setup label
`COM PORT SETTING` at `0xFFC3E5C9`.

The string descriptors for set 2, at `0x0007B272`–`0x0007B29F`, are referenced
from a `(length, pointer)` array at `0x0007B5F8`:

```
0x0007B272  04 03 09 04                      STRING desc 0, LANGID 0x0409
0x0007B276  10 03 "R.e.n.e.s.a.s."           iManufacturer = "Renesas"
0x0007B286  1A 03 "0.0.0.0.0.0.0.0.0.0.0.0." iSerialNumber = "000000000000"
```

and at `0x0007B699`, between the device and configuration descriptors, an
IEEE-1284 device-ID string with a big-endian length `00 79`:

```
MANUFACTURER:ACME Manufacturing;COMMAND SET:PCL,MPL;MODEL:LaserBeam ?;
COMMENT:Anything you like;ACTIVE COMMAND SET:PCL;
```

That is the **literal example string from the USB Device Class Definition for
Printing Devices**, shipped in a production amateur radio. Together with
`iManufacturer = "Renesas"` and a placeholder serial of twelve ASCII zeros, this
identifies set 2 as **Renesas USB peripheral sample code carried through into
the shipped build with its example data unmodified** — a printer-class device ID
in a descriptor block for a CDC device. Whatever set 2 is used for, nobody
edited its descriptors. I confirm the coordinator's point that the `.data`
initialiser at `0x002152` copies `0x07B2A6`–`0x07B753` into RAM at `0xFF6034`,
so the block is not inert; my "no pointer" result refers to ROM pointers to the
descriptor addresses themselves, and the RAM images are what the stack uses.

There is also a pipe-configuration table at `0x0007B578`–`0x0007B5F0`: rows
carrying endpoint attributes, max packet sizes 0x0040 / 0x0010 / 0x0020, and RAM
buffer pointers `0x00FF6420`, `0x00FFEE0E`, `0x00FFEE0C`, `0x00FFEE24`,
`0x00FFEE0D`, `0x00FFEE18`, `0x00FFEE25`, `0x00FFEE10`, `0x00FF640E`,
`0x00FF649F`. → **MAIN-IO**, **HOST-USB**.

#### 5.4 Alignment, calibration and factory vocabulary — confirmed absent

I searched the full byte range of both images for `ADJUST`, `CALIB`,
`CALIBRAT`, `ALIGN`, `TUNE`, `TUNING`, `DEVIATION`, `SQUELCH`, `S-METER`,
`FACTORY`, `TEST MODE`, `TESTMODE`, `DIAG`, `MONITOR`, `TRACE`, `DEBUG`,
`SELF-TEST`, `POST`, `MAINTEN`, `ENGINEER`, `SERVICE`, `TRIM`, `VCO`, `TCXO`,
`XTAL`, `APC`. **Not found**, with these exceptions, all of them ordinary
features:

- `LOCATION SERVICE` at SUB `0xFFC3E7D1` and `In Service` at `0xFFF4A1C6` /
  MAIN `0x0004C52A` — the only `SERVICE` hits.
- `SQL S-METER` at SUB `0xFFC3E155` — a documented squelch setting.
- `PLL REF` at SUB `0xFFED8E74` — a label in the `0xFFED8xxx` descriptor
  region; `access = indexed_possible`, no direct pointer. This is the closest
  thing to an alignment control I found and it is worth one more look.
- MAIN `0x0005039E` contains `TEST` and `DRILL` inside the APRS message-group
  list (`ALL`, `CQ`, `QST`, `QTH`, `SKY`, `SPC`, `SYM`, `TEL`, `TLM`, `ZIP`,
  `DGPS`, `JAVA`, `MAIL`, `MICE`, `RTCM`, `TEST`, `DRILL`, `SPACE`, `BEACON`) —
  APRS group names, not a test mode.

So **if per-unit alignment exists in this firmware it is not labelled**. That is
plausible: alignment data for a radio of this class normally lives in an EEPROM
written on the production line by an external jig, with no on-radio UI. The
absence of the vocabulary is evidence for that model, not against alignment
existing.

#### 5.5 Other engineering paths

- `RAM DISPLAY` (`0xFFC3E759`) — a RAM monitor screen gated on bit 7 of the
  settings byte at `0x00008E4D`, screen `sub_FFF0A86D`. **MENU's finding**, not
  re-derived, recorded here for the inventory.
- The transparent SCI-A→SCI-B serial bridge (`0xFF817F` bit 7, `sub_734F4`) and
  the serial command that arms DMA channel 2 from `0xFEE000` to dump RAM
  (`0x06B91A`–`0x06B984`), plus the software-reset command at `0x06B7DC`.
  **The coordinator's findings**, recorded for the inventory. → **MAIN-IO**.
- Battery/charger state strings at MAIN-side equivalent and SUB
  `0xFFF4ACA8`–`0xFFF4ACFA`: `Now Charging`, `--Complete--`, `Charge Error`,
  `No Battery`, `External DC`.
- A 4-character CRLF command protocol at SUB `0xFFF4AE70`–`0xFFF4AFA0`,
  dispatched through a 4-byte-stride pointer array at `0xFFEDA7A0`:
  `SCAN=%d`, `LINK=%c…` (12 `%c`), `SCOL=1/0`, `TXAT=%d`, `RXAT=`, `PAIR=%c%c%c%c`,
  `FIND=%c%c%c%c`, `FIND=OVER`, `PINF=0,%c…`, `HELL%c`, `ERAT=`, `SCOI=%c`,
  `ERROR`, `ERROR+SCOI`, `ACK ERROR`. `PAIR`/`FIND`/`LINK`/`PINF` is a
  Bluetooth module command set. → **WIRELESS**.
- `I:\LMREPAIR` (`0xFFF4AFF8`) and `I:\RECBACKUP` (`0xFFF4B007`) — two microSD
  paths not in the documented directory set alongside `I:\FT3D`,
  `I:\FT3D\BACKUP`, `I:\FT3D\GPSLOG`, `I:\FT3D_MEMORY-CH`, `I:\QSOLOG`,
  `I:\PHOTO`, `I:\VOICE`, `\Backup.bin`. → **STORAGE**.

### 6. Region, destination and capability gating

Three mechanisms, at three levels. This section is descriptive: it documents how
the firmware expresses its limits. It contains no modified bytes and no
procedure for changing them.

**(a) The destination code lives in MAIN RAM and has three names.** MAIN
`0x0006BE26` holds `"USA "`, `"JPN "`, `"EXP "` on a 4-byte stride. The code
immediately before it, `0x0006BE00`–`0x0006BE24`, reads and writes
`0x00FFB05D`, `0x00FFB05E` and `0x00FFB060`:

```
0006BE00  6A 2C 00 FF B0 5E   mov.b  @0xFFB05E:24, r4l
0006BE06  AC 20               cmp.b  #0x20, r4l
0006BE08  46 08               bne    +8
0006BE0A  FC 30               mov.b  #0x30, r4l
0006BE0C  6A AC 00 FF B0 5E   mov.b  r4l, @0xFFB05E:24
0006BE12  FC 2E               mov.b  #0x2E, r4l
0006BE14  6A AC 00 FF B0 5D   mov.b  r4l, @0xFFB05D:24
0006BE1A  FC 20               mov.b  #0x20, r4l
0006BE1C  6A AC 00 FF B0 60   mov.b  r4l, @0xFFB060:24
0006BE22  54 70               rts
```

The values `0x20` (space), `0x30` (`'0'`) and `0x2E` (`'.'`) are ASCII, so
these bytes are being formatted for a clone record — consistent with the `V`
record at `0x06C538` carrying a market field. Orphan #10, `sub_6ACA0` at
`0x0006ACA0`, also reads `0xFFB05E`.

**(b) The market flag in SUB selects menu contents.** MENU established that
`*(uint8*)0x00008C53 == 0` *removes* SIGNALING item 14, `WX ALERT`, the US-only
NOAA weather-alert feature. `0x8C53` is `0x8C4D + 6`, i.e. offset 6 in the same
applied-settings shadow that holds the boot-screen byte at offset 1. So the
menu lattice itself varies by market, item by item, rather than there being one
"region mode". Recorded, not re-derived.

**(c) A per-destination frequency table in MAIN at `0x0000F5F0`–`0x0000F9AF`.**
Frequencies are 4-byte packed BCD in units of 10 Hz. The table has three parts.

*Blocked receive ranges*, as `(lower, upper)` pairs, in two variants:

| variant at `0x0000F604` | variant at `0x0000F632` |
| --- | --- |
| 823.9950 – 849.0000 MHz | 252.9950 – 276.0000 MHz |
| 868.9950 – 894.0000 MHz | 379.9950 – 383.0000 MHz |
| 940.0095 – 965.1000 MHz | 411.9950 – 416.0000 MHz |
| 985.0000 … | 809.9950 – 846.0000 MHz |
| | 859.9950 – 901.0000 MHz |
| | 914.9950 – 961.0000 MHz |
| | 999.9995 (range top) |

824–849 / 869–894 MHz is the US cellular allocation, which US law requires a
scanning receiver to block. The second variant blocks a different, wider set
including 253–276 MHz and 380–416 MHz. Both are read through a pointer array at
`0x0000F5D8`–`0x0000F5E2`; readers at `0x000356A2`, and `sub_3E864` /
`sub_3E90A` (`0x0003E878`, `0x0003E8B0`, `0x0003E91E`).

*Overall coverage limits* at `0x0000F66A`–`0x0000F677`: 580.0000 – 999.9995,
then `140.0000 – 174.0000` and `420.0000 – 470.0000` MHz. The second and third
pairs are narrower than the receive coverage and correspond to the transceiver
hardware's capability ranges.

*Eight-entry per-destination arrays*, i.e. **eight destination variants**, at:

| address | content |
| --- | --- |
| `0x0000F8F6`+ | 12-byte records `{50.00000, 54.00000 or 52.00000, flags 00 08 00 01}` — the 6 m band edge, 54 MHz for four destinations and 52 MHz for the other four |
| `0x0000F958` | 145.7800, 146.5500, 145.3750, 145.3750, 145.3750, 145.3750, 145.7800, 145.3750 MHz |
| `0x0000F980` | 438.9800, 446.5000, 433.4500, 433.4500, 433.4500, 433.4500, 438.9800, 433.4500 MHz |
| `0x0000F978` | `06 00 04 04 04 00 06 04` — one attribute byte per destination |
| `0x0000F9A0` | `06 07 07 07 07 07 06 07` — one attribute byte per destination |

So: three destination *names* in MAIN (`USA`/`JPN`/`EXP`), eight destination
*columns* in the frequency table, and per-item market gating in the SUB menu.
The three are different granularities of the same concept, and the package
naming matches — the MAIN updater is `EXP` and the SUB updater is `ALL`, i.e.
**MAIN is the region-specific image and SUB is common to all markets.** That is
consistent with everything above: every band limit and destination name I found
is in MAIN, and the only market gating in SUB is one settings byte driving menu
visibility.

**Not region gating:** MAIN `0x00040900`–`0x00040B77` is a 20-byte-stride table
of `{3-byte BCD kHz frequency, attribute 0x10, 16-byte ASCII name}` holding
international shortwave broadcast presets — FINLAND 9.560/11.755/15.400 MHz,
RUSSIA 5.920/5.940/7.200/12.030, ISRAEL 7.465/11.585/15.615/17.535, INDIA
6.045/9.595/11.620/15.020, CHINA 7.190/7.405/9.785/11.685, KOREA
6.135/7.275/9.570/13.670, JAPAN 6.165/7.200/9.750/11.860, AUSTRALIA
5.995/9.580/9.660/12.080. These are real broadcaster frequencies and this is a
preset memory list for the wideband receiver, not a limit table.

### 7. Password, lock and protection

The setup labels are `LOCK` at `0xFFC3E371` and `PASSWORD` at `0xFFC3E3AD`, both
`access = indexed_possible` with no direct pointer, consistent with MENU's
finding that all setup labels are reached as `menu_table[cat].labels[item]`.

The screen strings are `PASSWORD INPUT` at `0xFFF48588` and `PASSWORD ENTRY` at
`0xFFF48597`, both referenced from `sub_FFEE80A9` (`0xFFEE80A9`–`0xFFEE8363`,
698 bytes, coherence 1.00) at `0xFFEE81C8` and `0xFFEE81E8`. Its callers are
`0xFFEE7D78` (loose) and `0xFFEE8063` (`sub_FFEE803D`).

What I established about it:

- It is the **renderer**, not the comparator. It clears a 320-pixel region via
  `sub_FFEF04F7`, then draws label/value pairs through `sub_FFEF1B23` and
  `sub_FFEF190D`, switching on state bytes.
- The state it switches on is `*(uint8*)0x00008F72`, read at `0xFFEE80D9`:
  ```
  FFEE80D9  FB E2 72 8F 00 00   mov.l  #8F72h, r14
  FFEE80DF  58 EE               movu.b [r14], r14
  FFEE80E1  61 0E               cmp    #0, r14
  FFEE80E3  3B CE 00            bne.w  loc_FFEE81B1
  ```
  `0x00008F72` has **43 referencing sites** across the image
  (`ida\out\hidden\modebyte_sub.tsv`, needle `8F72h`), so it is the
  password-feature state variable. When it is zero the routine draws the "not
  set" branch, which renders a `'0'` placeholder at `0xFFF48580` and the two
  short glyph pairs `#4E4Fh` (`ON`) and `#4550h`; when non-zero it takes the
  `0xFFEE81B1` branch that draws `PASSWORD INPUT` / `PASSWORD ENTRY`.
- Like every other screen in this image it reads `[0x00008C6D]` and
  `[0x00008C6E]` (`0x8C4D + 0x20 / +0x21`) for draw attributes.

**What I did not establish, and should be stated as open rather than guessed:
where the secret is stored, how it is compared, and what happens on failure.**
`sub_FFEE80A9` does not contain the comparison. The comparator will be reachable
from the same `sub_FFEE803D` caller cluster, and the stored value is very likely
in the settings image near `0x00008E46`+ given the stored/applied pairing
demonstrated in §5.2. I had not traced it when the session stopped.

Settings-store protection: I found no checksum, CRC or signature over the
settings image in what I covered, but I did not look for one specifically. The
only integrity mechanism I saw anywhere is the **8-bit additive checksum in
`0x00FFB3DC`** on the DATA-jack frame, which the coordinator supplied.

### 8. Key-combination and boot-hold gates (resume pass — the substance)

Machine-readable summary: `ida\out\hidden\hidden_gates_table.tsv`. Full listings:
`keys_funcdump_main.txt`, `keys_funcdump_sub.txt`; data-xref queries:
`keys_dataxref_main.txt`, `keys_dataxref_sub.txt`.

#### 8.1 The boot-hold key that selects the second USB personality — MAIN, confirmed

This is the one real key-combination gate in the firmware, and it settles the
live-vs-dead CDC-ACM conflict. The reset entry at `0x002092` calls `sub_20FA`
(`JSR sub_20FA` at `0x0020A4`). Inside `sub_20FA`, at file `0x0021F8`–`0x002240`:

```
0021F8  FC 00            mov.b  #0, r4l
0021FA  6A 8C 81 3A      mov.b  r4l, @0xFF813A:16     ; selector = 0 (default personality)
0021FE  FE C8            mov.b  #0xC8, r6l            ; r6l = 200  (poll budget)
002200  2C 4C            mov.b  @0xFFFF4C:8, r4l      ; read held-key matrix port (top-page abs)
002202  EC 7F            and.b  #0x7F, r4l            ; mask bit 7
002204  AC 7D            cmp.b  #0x7D, r4l            ; special key held?
002206  47 16            beq    loc_221E             ; YES -> alternate personality
002208  1A 0E            dec.b  r6l
00220A  46 F4            bne    loc_2200             ; poll up to 200 times
; --- not held: default (vendor) personality ---
002214  5E 05 4B F8      jsr    sub_54BF8            ; USB config table copy
002218  5E 05 4C 44      jsr    sub_54C44            ; program USB module for set 1
00221C  40 22            bra    loc_2240
; --- held (loc_221E): alternate (CDC-ACM) personality ---
00221E  6A 8C 81 3B      mov.b  r4l, @0xFF813B:16
002222  FC 01            mov.b  #1, r4l
002224  6A 8C 81 3A      mov.b  r4l, @0xFF813A:16     ; selector = 1
002228  5E 05 5F FE      jsr    sub_55FFE            ; alt USB state block setup
002234  5E 07 81 06      jsr    loc_78106            ; alt USB module init (CDC-ACM RAM structs)
002240  ...continue boot
```

The two arms are mutually exclusive. Key facts, each read from the bytes:

- The port is read with the **8-bit top-page absolute form** `2C 4C`
  (`@0xFF4C:8` → `0xFFFF4C`); this is why earlier 16-/24-bit immediate scans for
  `0xFFFF4C` found nothing. It is read in a code context **exactly once** in the
  whole MAIN image, here (whole-image scan for `2C 4C`).
- `sub_100E4` (`0x000100E4`) is the keypad decoder; at `0x01010E`–`0x010112` it
  maps port `0x7D` → internal key id `0x11` (`mov.b #0x11, r1l ; cmp.b #0x7D`),
  exactly as the earlier notes stated. The physical button that produces matrix
  code `0x7D` is not derivable from firmware (it is a hardware matrix), so I state
  the code, not the key legend.
- **Default path** (`sub_54BF8`/`sub_54C44`) belongs to descriptor **set 1**: the
  responder at `0x055134` does `mov.l #(0x055818+1), er5` (the vendor device
  descriptor, PID `0x0001`) and streams it to EP0 FIFO `@0xFFEE0C`. Confirmed
  reference `0x055818 ← 0x055134`.
- **Held-key path** installs descriptor **set 2 (CDC-ACM)**. Its descriptors are
  not referenced by ROM pointer — they are copied to RAM at boot. The `.data`
  initialiser at `0x002156` is `mov.l #0x07B2A6, er5 ; mov.l #0xFF6034, er6 ;
  mov.w #0x04AE, r4 ; eepmov.w` — **1,198 bytes from ROM `0x07B2A6` to RAM
  `0xFF6034`**. The set-2 device descriptor (ROM `0x07B680` =
  `12 01 10 01 02 … AA 26 20 00`, VID `0x26AA`/PID `0x0020`, `bDeviceClass 0x02`)
  therefore lands at RAM **`0xFF640E`**, its configuration (ROM `0x07B711`) at
  **`0xFF649F`** — and those two RAM addresses are exactly the buffers that
  `loc_78106` and the pipe table (§5.3) drive. The alternate boot path uses the
  CDC-ACM structures.
- The selector is re-read at runtime: `0x0101B2` `mov.b @0xFF813A, r4l ; beq …;
  jsr sub_103C0`, so the personality chosen at boot steers the control handler
  for the whole session.

**Conclusion:** the CDC-ACM virtual COM port is **live**, entered by holding the
`0x7D` key across power-on; the default boot presents the vendor device. DSP-AMBE's
"dead data" reading rested on the absence of *ROM* pointers to the descriptor
addresses; MAIN-IO's RAM-copy evidence is correct and is confirmed here byte for
byte. The descriptors are still the unmodified Renesas sample (§5.3), so the
personality is real but its identity strings were never customised.

#### 8.2 A second boot-hold path — the 11-key action table — MAIN, confirmed

Separate from the USB selector, a power-on key handler (`0x010168`, in `sub_3182`'s
subtree) calls `sub_100E4`, then matches the raw port value against an 11-entry,
4-byte-stride table `dword_10216` = `{0x0F, 0x1F, 0x5F, 0x7B, 0x77, 0x6F, 0x7E,
0x73, 0x7D, 0x37, …}` (`0x010186` `mov.l #dword_10216, er6 ; mov.b #0x0B, r3h`).
The matched **index** is stored to `@0xFFA9EF` (`0x0101CE`), read back by `sub_3182`
at `0x0031C6` (`mov.b @0xFFA9EF, r4l ; cmp.b #6`). Only **index 6** (port `0x7E`,
key id `0x0E`) has a distinct handler, `sub_10444` (`0x00010444`), which loads
defaults into the per-band/VFO settings fields at `0xFF8F31`/`0xFF9039`/`0xFF9141`
and clears `0xFF8EE6`/`0xFF8FEE`/`0xFF90F6` etc. — i.e. **a hold-a-key-at-power-on
partial settings/VFO reset**. The USB key `0x7D` is index 8 in the same table but
is pre-empted by the selector path of §8.1 (`0x0101B2` short-circuits to
`sub_103C0` when the selector is already set). The other indices set only a generic
"a key was held" boot flag. No index reaches an alignment, calibration or
service-menu routine — consistent with the absence of that vocabulary (§5.4).

#### 8.3 The DATA-jack receive-side opcode table — MAIN, confirmed (was the open gap)

The emit side (§2) is a set of clone/backup record templates. The receive side is
**not a jump table** — it is a two-state machine fed by the DATA-jack SCI receive
ISR `sub_6B986` (`0x0006B986`, installed at **interrupt vector 130**, slot
`0x00000208`), which sets the byte-ready flag `@0xFFB3D2.6` and leaves the received
opcode in `@0xFF1AC9`. `sub_6B700` installs the first state handler
(`mov.l #sub_6B9AC, er4 ; mov.l er4, @0xFFB3C6` at `0x0006B72C`). The two states,
each reading the opcode from `@0xFF1AC9`:

| state | function | accepts | notes |
| --- | --- | --- | --- |
| 1 | `sub_6B9AC` `0x0006B9AC` | **`V`** (`0x56`), **`M`** (`0x4D`) | `V` → `sub_6BD3E` (the FT3D `V` record emitter); `M` → `sub_6C680`/`sub_6C652` by flag `@0xFF8DDE`; then `sub_6B73A` advances the state pointer |
| 2 | `sub_6BAC8` `0x0006BAC8` | **`B C E F S N W V`** (`0x42 43 45 46 53 4E 57 56`) | the clone data records `B/C/E/F/S/N/W`, matching the emit templates of §2 |

So the full receive-side opcode set of the clone/backup protocol is **`V M B C E F
S N W`** — reached only over the physical DATA jack, never from the UI. This is the
external control surface: the coordinator's response path at `0x06B91A` arms DMA
ch2 from `0xFEE000` to dump RAM out of the jack, and `0x06B7DC` lets a command
software-reset MAIN. A **second, larger letter-keyed protocol** sits at `0x058098`
(`cmp.b #'A' … #'v'`), opcodes `A B C E F G H L M P Q R S T U V 0 a m v`, each
gated on a fixed record length in `r5` (e.g. `C`→`0x19`, `M`→`0x60`, `V`→`0x60`,
`F`→`<0x40D`) and copying via `eepmov` from `0xFEF920` to `0xFF0BF6`; it shares the
mode flag `@0xFF8DDE` with the state machine above. This is the fuller PC-clone /
memory read-write command set. Full opcode reversal is PROTOCOLS' remit; the opcode
inventory and lengths are in `keys_funcdump_main.txt`.

#### 8.4 Region / expanded-RX / MARS — settled: no soft unlock, destination-driven

Three false leads first, so they are not re-chased: MAIN `MARS` at `0x044226` is an
**APRS symbol description** (in the table `Kenwood HT / Lighthouse / MARS /
Navigation Buoy / Rocket / …`), not the expanded-TX program; SUB `OPEN` at
`0x03DFC5` is `OPENING MESSAGE`; SUB `FULL` at `0x34AAF2` is `BANK FULL`. A
whole-image scan of both binaries for `MARS`/`CAP`/`CELL`/`CELLULAR`/`EXPAND`/
`EXPANDED`/`UNLOCK`/`WIDEBAND` finds no expanded-coverage vocabulary.

The band coverage is fixed by a **stored destination index**, not by any runtime
gate. `sub_52C8C` (`0x00052C8C`) reads settings byte `@0xFF9E1F` (default `0x1D`
if `0xFF`), indexes the destination table at `0x00003EA2`, and copies the
destination block from `0xFF9E10` to `0xFFB05A`/`0xFFB05E` (the `USA `/`JPN `/`EXP `
strings of §6a). The value at `@0xFF9E1F` comes from the persisted settings image
that MAIN owns — **not** from a hardware strap (the only early-boot port straps,
`@0xFFFF40.7` at `0x00239C` and `@0xFFFF45.2` at `0x0023BA`, set timer/oscillator
config, not region), and **not** from any runtime key or menu. So changing RX/TX
coverage requires rewriting that stored destination (a service/clone-tool or
settings-image operation), exactly the route by which MARS/CAP mods are performed
on this class of radio; there is no on-radio soft unlock. The per-destination band
table and the US cellular block (824–849 / 869–894 MHz) documented in §6 are the
data this index selects.

#### 8.5 The `DSP WRITE MODE` gate byte — settled: MAIN-supplied, no SUB writer

The SUB `DSP WRITE MODE` screen `sub_FFF0DE56` has a **single caller** — the
boot-screen dispatcher `sub_FFF0D6D9` at `0xFFF0D709` — so its only entry is the
gate `applied[0x00008C4E] == 8` (§5.2). The applied byte is loaded from the stored
byte by `sub_FFEEB057`: at `0xFFEEB08C`–`0xFFEEB0AB` it reads `applied[0x8C4E]`,
compares it to `stored[0x8E47]`, and on a difference copies
`applied[0x8C4E] = stored[0x8E47]`. **No SUB instruction writes the constant `8`
to either byte** (IDA sees no write; MENU's displacement-resolved scan and my
needle scan agree), and SUB has no non-volatile store. Therefore the value `8`
arrives in the settings block that **MAIN pushes to SUB over the inter-processor
link**; what makes MAIN send it (a service/SD condition on the MAIN side, since the
DSP is MAIN's per correction #6) is a cross-processor question outside this image's
reach — handed to DSP-AMBE / BOOT-IPC. The `Push DISP Key!` / `Loading...` /
`Complete` prompt sequence is consistent with an operator-driven DSP-firmware load
once the mode is active.

---

## USB relevance

**Question 1, everything USB.** The strongest thing I add is that **MAIN carries
two full USB device personalities in descriptor form**, and I have decoded both
byte by byte (§5.3): a live vendor-specific device (VID `0x26AA` PID `0x0001`,
bulk OUT 64 + interrupt IN 8, six bInterval variants) and a **CDC-ACM virtual
COM port** (VID `0x26AA` PID `0x0020`, bulk IN/OUT 64 + interrupt IN 8) whose
descriptors still carry Renesas sample defaults and a USB Printer Class example
device-ID string. The CDC personality pairs with the SUB setup label
`COM PORT SETTING`. This also settles the H8S part question in the affirmative
direction the brief flagged: the MAIN part has a USB function module, so it is
not an H8S/237x.

**The resume pass resolves which personality is live and how you get it (§8.1):
both are, and the choice is a boot-hold key.** Default power-on presents the
vendor device (PID `0x0001`); holding the `0x7D` key across reset selects the
CDC-ACM virtual COM port (PID `0x0020`), whose descriptors are copied to RAM
`0xFF640E`/`0xFF649F` at boot and installed by `loc_78106`. So the CDC-ACM stack
is not dead vendor boilerplate — it is a shipped, boot-selectable USB serial
port. That is the decisive answer to RESUME-DEEP's #1 open question and the
strongest single USB fact in this document.

**Question 2, USB SDR.** Nothing I found improves the case, and one thing
weakens it. The live personality's only IN endpoint is an **8-byte interrupt
endpoint at 20–250 ms**, which is a status channel, not a sample pipe. The CDC
personality does have a 64-byte bulk IN at `0x82`, which is the only bulk IN
endpoint in either descriptor set and therefore the only declared path in this
firmware capable of sustained throughput — and §8.1 confirms that path is
reachable in normal operation via the boot-hold, not just latent. Even so,
full-speed CDC bulk tops out well below what IF sampling needs, and I found no
sample source: no `ADJUST`/`CALIB` path, no IQ buffer, no reference to a high-rate
converter. The missing link remains the sample source, not the transport.

**Question 3, the DSP.** The trace facility in §5.1 is the most direct evidence
yet about the DSP link, because it names the command vocabulary in plain ASCII:
power-on and reset, `VER?`, RX enable/disable, mute on/off, stop encode, data
text set, terminate TX, terminate RX, ACK, NAK, and a 3-second timeout. The
`DSP  Ver.  :  .    ` field at SUB `0xFFF48814`, and `DSP H` / `DSP A` / `DSP D`
at `0xFFF4A059`/`69`/`79`, confirm SUB displays a DSP version it obtains over
that link. And `sub_FFF0DE56` shows the radio has a **DSP firmware write mode**
with a user prompt, which means a path to load DSP code exists in shipped
firmware. That is the single most important thing in this document for
question 3.

---

## Handoff — addresses for other agents

**→ MAIN-IO / HOST-USB (resolves RESUME-DEEP #1).** The CDC-ACM personality is
**live**, boot-hold-selected. Gate: `sub_20FA` at `0x002200` reads keypad port
`@0xFFFF4C:8`, masks `&0x7F`, compares `0x7D`, polls 200×; held → selector
`@0xFF813A = 1` (`0x002224`) + `JSR loc_78106` (`0x002234`); not held → vendor
device via `sub_54BF8`+`sub_54C44`. `.data` copy at `0x002156` moves ROM
`0x07B2A6`..`0x07B753` (1,198 B) to RAM `0xFF6034`, so the set-2 device descriptor
is at RAM `0xFF640E` and its config at `0xFF649F`. Runtime selector re-read at
`0x0101B2` → `sub_103C0`. Keypad decoder `sub_100E4` maps port `0x7D`→id `0x11`.

**→ BOOT-IPC / DSP-AMBE.** SUB `DSP WRITE MODE` (`sub_FFF0DE56`) has one caller,
gate `applied[0x00008C4E]==8`, loaded from `stored[0x00008E47]` by `sub_FFEEB057`
(`0xFFEEB0AB`). No SUB writer of the constant 8; the byte is MAIN-supplied via the
IPC settings push. Find the MAIN condition that sets it.

**→ DSP-AMBE.** `sub_FFF0DE56` at `0xFFF0DE56` is DSP WRITE MODE; gate is
`*(uint8*)0x00008C4E == 8` tested at `0xFFF0D6ED`; the shadow is loaded from
stored `0x00008E47` by `sub_FFEEB057` at `0xFFEEB09F`; comparator of the pair is
`sub_FFEE5DCA` at `0xFFEE5DCE`. The six sibling screens are `sub_FFF0D73E` (2),
`sub_FFF0DA4B` (5), `sub_FFF0DB03` (7), `sub_FFF0E118` (9), `sub_FFF0E392`
(0x0A), `sub_FFF0E617` (0x0B). On the MAIN side, the full CPU↔DSP trace string
table is `0x0005AE1C`–`0x0005AF6E` with the indexed table at `0x0005AE34`, the
RAM trace buffer at `0x00FF2DC8`, the live formatter `sub_5A7F2` at
`0x0005A7F2`, and the dead formatter `sub_5A482` at `0x0005A482`. Per-message
emit sites: `0x0005A5A0` (`VER?`), `0x0005A5A8` (`STOP ENCODE`), `0x0005A5B6`
(`RX ENABLE`), `0x0005A5BE` (`RX DISABLE`), `0x0005A754` (`MUTE OFF`),
`0x0005A75C` (`MUTE ON`).

**→ MAIN-IO / HOST-USB.** Descriptor set 1 device `0x00055818` ← `0x00055134`;
six configs `0x0005582A`, `0x0005585E`, `0x0005587E`, `0x0005589E`,
`0x000558BE`, `0x000558DE`. Descriptor set 2 device `0x0007B680`, config
`0x0007B711`, string array `(len, ptr)` at `0x0007B5F8`, strings `0x0007B272`
/ `0x0007B276` / `0x0007B286`, IEEE-1284 printer ID `0x0007B699`, pipe table
`0x0007B578`–`0x0007B5F0` with RAM buffers `0x00FF6420`, `0x00FFEE0C`–`0x0E`,
`0x00FFEE10`, `0x00FFEE18`, `0x00FFEE24`, `0x00FFEE25`, `0x00FF640E`,
`0x00FF649F`.

**→ MENU.** The lineage question is answered and the answer is narrower than
expected. The model table at `0x0004C32C` is the APRS MIC-E device-type decode
table and includes five Kenwood models, so it cannot support a shared-codebase
argument; `APY03D` at `0x0004B182` is the FT3D's own APRS tocall. The real
artifact is the **unreferenced FT2D clone template at `0x0006C572`**, alone
among fourteen. Your `USB CAMERA` conclusion is corroborated from my side: the
supporting data is live on both processors — MAIN `.jpg` at `0x0006A976` has
three live callers (`sub_6A5C8`, `sub_6A802`, `sub_710D2`), MAIN
`Send pictures` at `0x00043636`, and SUB `PHOTO`/`I:\PHOTO` are reached from
pointer arrays at `0x2D832C` and `0x2D7EA4`.

**→ PROTOCOLS.** The DATA-jack record templates and opcodes are the table in §2;
the **receive side** is now mapped (§8.3): RX ISR `sub_6B986` (vector 130) →
opcode at `@0xFF1AC9` → 2-state machine `sub_6B9AC` (`V`,`M`) → `sub_6BAC8`
(`B C E F S N W V`), state pointer at `@0xFFB3C6`. The larger PC-clone/memory
command set is at `0x058098` (opcodes `A B C E F G H L M P Q R S T U V 0 a m v`,
each with a fixed record length in `r5`). Full opcode-by-opcode reversal is yours.
APRS data in MAIN: symbol-name table `0x000437BE` (3,544 bytes), message groups
`0x0005039E`, digipeater paths `WIDE1`/`WIDE2` at `0x0000F859`, addressee groups
`ALL`/`CQ`/`QST`/`YAESU` at `0x0000F871`, bulletins `BLN*` at `0x0000F89F`,
tocall `0x0004B182`, MIC-E device table `0x0004C32C` ← `0x0004C2AA`.

**→ WIRELESS.** Seventeen MediaTek `$PMTK` GPS commands at
`0xFFF483E8`–`0xFFF484AF` via the pointer array at `0xFFED4288`; the Bluetooth
4-character command set at `0xFFF4AE70`–`0xFFF4AFA0` via the pointer array at
`0xFFEDA7A0`.

**→ STORAGE.** FAT16 boot-sector template `NO NAME    FAT16` at `0xFFC3E8CB`;
FAT32 FSInfo signatures `RRaA`/`rrAa` at `0xFFF4AE2A`; filesystem type names at
`0xFFF4AE14`; undocumented paths `I:\LMREPAIR` `0xFFF4AFF8` and `I:\RECBACKUP`
`0xFFF4B007`; illegal-character set `\/:*?"<>|` at `0xFFF4ADDD`.

**→ SUB-LOWER / MAIN-FULL.** My coverage and function tables are
`coverage_{main,sub}.tsv` and `functions_{main,sub}.tsv`; reachability with
per-function indegree and class is `reach_{main,sub}.tsv`. Note the
methodological correction in Method: H8S 16-bit absolutes reach ROM only below
`0x8000`.

---

## Tables

All under `ida/out/hidden/`.

| file | what |
| --- | --- |
| `strings_main.tsv`, `strings_sub.tsv` | **the string atlas** — 6,918 + 16,636 rows, with class, reference counts and the `access` verdict |
| `build_artifacts.tsv` | 24 build, library and identity artifacts with reference status |
| `orphans.tsv` | merged, ranked, coherence- and prologue-filtered orphan census; `orphans_main.tsv` / `orphans_sub.tsv` are the per-image inputs |
| `reach_main.tsv`, `reach_sub.tsv` | every function with indegree detail, pointer-target flag and reachability class |
| `modebyte_sub.tsv` | 2,394 sites touching the settings shadow `0x00008C4D` / `0x00008F72`, each with the following four instructions |
| `svcdump_sub.txt` | full listings of the boot-screen dispatcher and all seven screens |
| `funcdump_main.txt`, `funcdump_sub.txt` | full listings of the routines named above, with callers, coherence and referenced strings |
| `callchain_main.txt`, `callchain_sub.txt` | caller chains to four levels |
| `listing_main.txt`, `listing_sub.txt` | disassembly windows around each target address |
| `functions_*.tsv`, `xrefs_*.tsv`, `coverage_*.tsv`, `segments_*.tsv`, `names_*.tsv`, `idastrings_*.tsv` | database state after the coverage pass |
| `_raw_strings_*.tsv`, `_ptrindex_*.tsv`, `strxref_*.tsv` | inputs to the atlas; `_ptrindex` is the coverage-independent reference index and is reusable by any pass |
| `_targets_*.txt`, `_funcdump_*.txt`, `_svcdump_*.txt` | the request lists the job scripts read; edit and `--reopen` to iterate cheaply |
| `job{1,2,3,4,5}_log_*.txt` | per-pass logs |
| **`hidden_gates_table.tsv`** | **the gate → feature summary: every key/boot/port/flag gate, its address, condition, and what it unlocks** |
| `keys_funcdump_main.txt`, `keys_funcdump_sub.txt` | resume-pass full listings — boot gate, key decoder, USB personality init, DATA-jack state machine, second protocol, dest-code writers, DSP-write-mode/password screens |
| `keys_dataxref_main.txt`, `keys_dataxref_sub.txt` | reference queries for the gate data addresses (selector `0xFF813A`, dest code `0xFFB05x`, opcode byte `0xFF1AC9`, boot-screen bytes `0x8E47`/`0x8C4E`) |
| `_keys_targets_main.txt`, `_keys_targets_sub.txt` | the target request lists `hidden_keys.py` reads; edit and `--reopen` to iterate |

---

## Open

The resume pass closed the four items that were mid-flight: the boot-hold USB
gate (§8.1), the second boot-hold key path (§8.2), the receive-side DATA-jack
opcode table (§8.3), the region/expanded-RX mechanism (§8.4), and the source of
the `DSP WRITE MODE` gate byte (§8.5, resolved to the SUB side; the MAIN trigger
is the residual). What remains, most valuable first:

1. **The MAIN-side condition that sets the `DSP WRITE MODE` byte.** SUB is only the
   display; nothing in SUB writes the `8`, so MAIN decides. The DSP is MAIN's
   (correction #6). Trace the MAIN DSP loader (`sub_5DD00` per DSP-AMBE, pins
   `0xFFFF52`) and whether it is entered on an SD-card DSP image or a MAIN boot
   condition, then follow how MAIN encodes `boot-screen = 8` into the ~254-byte
   settings block it pushes to SUB. Cross-processor; BOOT-IPC + DSP-AMBE.
2. **Full opcode-by-opcode reversal of the two DATA-jack command sets** (§8.3):
   the clone state machine (`V M B C E F S N W`) and the larger set at `0x058098`
   (`A B C E F G H L M P Q R S T U V 0 a m v`). The opcode inventory and record
   lengths are in `keys_funcdump_main.txt`; PROTOCOLS owns the byte-level reversal.
3. **The `charput()` hook in SUB.** `lowsrc.c` is linked in (§3), so `printf`
   exists. Follow `sub_FFEE18A6` and `0xFFEE17B6` (the `<drive C>\stdin` references) down
   to the character-output primitive. If it writes to an SCI, SUB has an
   undocumented debug console.
4. **The password comparator.** The renderer is `sub_FFEE80A9`, shown when
   `applied[0x00008C4D]==0xF0` (dispatch `sub_FFEE803D` at `0xFFEE805B`); the digit
   comparison against the stored secret is elsewhere in the `sub_FFEE803D` /
   `0xFFEE7D37` cluster and was not traced. A user CONFIG lock, not a hidden mode.
5. `PLL REF` at `0xFFED8E74` — the only alignment-shaped label in either image;
   resolve its indexed access and find its screen. Note MAIN bit-bangs a 3-wire
   PLL from port pins `0xFFFF5A`/`0xFFFF5D` in `sub_3E864` (`0x0003E864`), so the
   synthesiser programming lives on MAIN; `PLL REF` on SUB is likely just a display
   of a MAIN-owned reference-offset setting.
6. Decode the 7-bit JIS strings in `0xFFF4AC60`–`0xFFF4AC9F` (boot screen mode 7)
   and at `0xFFF48795` / `0xFFF487A7`.

**Reproduction.** Databases `HID_MAIN` and `HID_SUB` under
`ida\db\jobs\` (real path `ida/db/jobs/` — the tree was
relocated), both already swept, so always use `--reopen`. The resume pass is:
edit `ida\out\hidden\_keys_targets_{main,sub}.txt`, then
`run_job.py --script ida\jobs\hidden_keys.py --db HID_MAIN --reopen --env YAESU_IMG=MAIN`
(and `HID_SUB`/`SUB`). Because the shared `run_job.py` still has
`ROOT=.`, run it through a copy whose `ROOT` is the repository root
(a one-line change) or fix the shared launcher. To rebuild from scratch:
`--copy-from ida\db\radio\MAIN.i64` / `SUB.i64`, then `hidden_atlas.py`,
`hidden_cover.py`, `hidden_report.py`, `hidden_gates.py`, `hidden_service.py`,
`hidden_keys.py` in order, each with `--env YAESU_IMG=MAIN` or `SUB`. All
whole-image byte facts here were also verified in plain Python with 100% coverage.
