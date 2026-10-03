# Storage and the microSD card (deep-pass item 13)

## Verdict

**The microSD card is a data-storage device only. It is not a firmware-load path,
and no code in either image reads and validates a firmware image from the card.**
This is a confirmed negative, proven from files already on disk three independent
ways:

1. `"FIRM ERROR"` is the **only** firmware-related string in the SUB image
   (mapped `0xFFF4AB3F`, file `0x34AB3F`), and there is **no** firmware string of
   any kind in the MAIN image. Neither image contains a firmware filename, a
   firmware-type extension (`.img`/`.sfl`/`.fda`/`.fw`/`.dfu`/`.mot`/`.hex`), or an
   S-record/Intel-hex/ELF parser.
2. `"FIRM ERROR"` is popup message id `0xAB`. It is raised only by three sibling
   **UI screen handlers** (`sub_FFF0DB03`, `sub_FFF0DE56`, `sub_FFF0E118`) under
   the screen dispatcher `sub_FFF0D6D9`, which switches on the inter-processor
   status byte at SUB RAM `0x00008C4E`. The whole DSP-write screen subtree calls
   **zero** filesystem, SDHI, or path-builder functions (verified three call
   levels deep). `FIRM ERROR` is a passive UI reaction to a status byte MAIN sends
   over the inter-processor link — no file is opened, read, parsed, checksummed,
   or validated on that path.
3. The screen at `sub_FFF0DE56` is `---DSP WRITE MODE----`, the radio's DSP
   firmware-update UI. Per `06-dsp-vocoder.md`, the DSP image **arrives over the
   wire** (MAIN drives the DSP over SCI-A after asserting its reset/boot lines on
   port `0xFFFF52`); SUB only draws the screen. The DSP firmware is not carried in
   this package and is not read from a card file.

What the card **is**: a Renesas RX64M (SUB) on-chip **SDHI** host controller
driving a full read-write **FAT12/16/32** filesystem (exFAT is detected and
explicitly rejected), mounted as drive `I:`. It holds ordinary user data — QSO
logs, APRS messages, received/captured photos, voice `.wav` recordings, GPS track
logs, memory-channel exports, and a settings/clone backup. SUB owns the card
hardware and filesystem; MAIN owns the higher-level `.dat` container formats and
reaches the card through the inter-processor link. Removable-media **data** parsers
do exist (the FAT/exFAT boot-sector reader, a WAV reader/writer, and the `.dat`
container readers), so there is an input surface — but it is data, not code, and
none of it loads or executes firmware.

## Method

Private database `STOR_SUB` (SUB side, RX64M, base `0xFFC00000`). This pass
resolved the priority open item (#4, the FIRM ERROR / SD-firmware lead) from the
interim STORAGE tables plus direct byte/offset analysis of
`decrypted\FT3D_SUB_ver102_ALL.bin` and `decrypted\FT3D_MAIN_ver102_EXP.bin`, and
cross-checked against `docs\deep\06-dsp-vocoder.md`.

- **String scan** of both plaintext images for firmware/loader/update/image
  markers and file-format magics (grep with byte offsets).
- **Message-table reconstruction**: dumped the popup-string region
  `0xFFF4AAD9`–`0xFFF4AB4A` and matched it against the message-id immediates in
  `imm_sites.tsv`; located the id→string switch inside `sub_FFF0B665` by finding
  the little-endian string pointers embedded in its code.
- **Call-graph reachability**: used `callgraph_full.tsv` to enumerate the callees
  of the three FIRM ERROR raisers and their subtree, testing for any edge into the
  fopen wrappers (`0xFFF12xxx`/`0xFFF14xxx`), SDHI driver (`0xFFF33xxx`/`0xFFF35xxx`),
  or path builders (`sub_FFF3B8DE`/`sub_FFF12A8F`).
- **Pointer-reference scan** for the `"Read from SD"` label and the WAV header
  strings.
- The SD/SDHI hardware interface, FAT layer, and command set were fully mapped in
  the earlier STORAGE passes; this pass verified and cites those tables rather than
  re-deriving them.

**Not run this pass:** a fresh IDA disassembly of the three FIRM ERROR handler
bodies. `run_job.py` hardcodes `ROOT = .`, but the workspace was relocated
to the repository root and no `ida` junction exists, so `--reopen`
against `STOR_SUB` cannot find its database without altering the shared filesystem.
`objdump` in this environment has no RX target. The negative was instead proven
from the call graph (no filesystem edges, three levels deep), the string scans, and
the id→string mapping — decisive without a new disassembly. Full RX listings of
`sub_FFF0DB03/DE56/E118` would be confirmatory only.

**Tables** (all under `ida/out/storage/`):
`firm_trace.tsv` (the FIRM ERROR trace and verdict, new this pass),
`sd_interface.tsv`, `sdhi_accesses.tsv`, `sd_commands.tsv`, `fat_layer.tsv`,
`paths.tsv`, `path_owners.tsv`, `string_xrefs.tsv`, `imm_sites.tsv`,
`intb_sd.tsv`, `sd_callers.tsv`, `callgraph_full.tsv`, `functions_full.tsv`.

## Findings

### A. The FIRM ERROR / SD-firmware lead — resolved (no SD firmware path)

**The string and its id.** `"FIRM ERROR"` is at file `0x34AB3F` = mapped
`0xFFF4AB3F` (bytes `46 49 52 4D 20 45 52 52 4F 52 00`). It is the last entry in a
consecutively-numbered popup-message set. Reading the message region
`0xFFF4AAD9`–`0xFFF4AB4A` and pairing it with the id immediates in `imm_sites.tsv`:

| id | string | string addr |
| --- | --- | --- |
| `0xA0` | `W PROTECT` | `0xFFF4AAD9` |
| `0xA1` | `MCH ERROR` | `0xFFF4AAE3` |
| `0xA5` | `MS ERROR` | `0xFFF4AB08` |
| `0xA7` | `NO SD CARD` | `0xFFF4AB1B` |
| `0xA8` | `SD CARD FULL` | `0xFFF4AB26` |
| `0xA9` | `HEAT` | `0xFFF4AB33` |
| `0xAA` | `M-ONLY` | `0xFFF4AB38` |
| `0xAB` | **`FIRM ERROR`** | `0xFFF4AB3F` |

The id→string map is a code switch inside **`sub_FFF0B665`**: `cmp #-55h` (0xAB) at
`0xFFF0B734`, and the immediate `mov.l #0xFFF4AB3F` at `0xFFF0BD4B` (the LE bytes
`3F AB F4 FF` appear in code, not in a data table). So `FIRM ERROR = 0xAB` is
**Confirmed** from two independent structures. (Note: `06-dsp-vocoder.md` cites the
string at `0xFFF4AB44`; the exact address is `0xFFF4AB3F` — a 5-byte discrepancy
that does not affect its conclusions.)

**Who raises it.** From `imm_sites.tsv`, id `0xAB` is loaded only in three
functions, all children of one dispatcher:

| raiser | screen state | id-load sites |
| --- | --- | --- |
| `sub_FFF0DB03` | 7 | `0xFFF0DDA9`, `0xFFF0DDC4`, `0xFFF0DDEF` |
| `sub_FFF0DE56` | 8 = **DSP WRITE MODE** | `0xFFF0E08D`, `0xFFF0E0A6`, `0xFFF0E0CD` |
| `sub_FFF0E118` | 9 | `0xFFF0E34B` |

The dispatcher `sub_FFF0D6D9` selects among screen states by the byte at SUB RAM
`0x00008C4E` (`callgraph_full.tsv`: edges at `0xFFF0D6FD/701/705/709/70D/714/71B`
to states 2/5/7/8/9/A/B). `06-dsp-vocoder.md` traced this same dispatcher and
showed `0x00008C4D`+ is the inter-processor status block into which MAIN deposits
the DSP-write phase/progress (`+0x20`, `+0x21`) and version digits.

**The decisive test — these handlers never touch the card.** From
`callgraph_full.tsv`, the complete callee sets are:

- `sub_FFF0DB03` → `FFEF04F7`, `FFEF190D`, `FFEF1B23`, `FFEF1C48`, `FFEF68D5`
- `sub_FFF0DE56` → `FFEF04F7`, `FFEF1B23`, `FFEF1BB1`, `FFEF1C48`
- `sub_FFF0E118` → `FFEF04F7`, `FFEF68D5`, `FFEF1C48`

Every callee is a `0xFFEF0xxx`–`0xFFEF6xxx` **display/format primitive**. None is a
file opener (`0xFFF12xxx`/`0xFFF14xxx`), an SDHI routine (`0xFFF33xxx`/`0xFFF35xxx`),
or a path builder (`sub_FFF3B8DE`/`sub_FFF12A8F`). Going one level deeper, the
primitives call only `FFEF153B/2184/2261/2317/FFEE5269/FFEF1A16/0581/0648`, and
none of those has a filesystem/SD edge either (`FFEE5269` is a leaf). So the entire
DSP-write screen subtree is **filesystem-free to at least three call levels**. The
FIRM ERROR message is emitted when MAIN reports a bad DSP-write status over the
IPC link; SUB reads a status byte and draws a string. No card file is involved.

**Where the DSP firmware actually comes from.** `sub_FFF0DE56` draws
`---DSP WRITE MODE----` (`0xFFF4ACF8`), `Push DISP Key!` (`0xFFF4AD0E`),
`Loading...` (`0xFFF4AD1D`), `Complete` (`0xFFF4AD28`), `TYPE    : ` (`0xFFF4AD31`),
and `FIRM ERROR` on failure. Per `06-dsp-vocoder.md`, MAIN's `sub_5DD00`
(`0x0005DD00`) drives the DSP write itself: it resets the DSP via port `0xFFFF52`,
switches SCI-A to async, and streams bytes from its queue engine at `0xFF6288` into
the DSP's `TDR`. SUB is a passive display. The DSP image is therefore delivered
over the chip-to-chip wire, not read from the card.

**"Read from SD" is a data label, not firmware.** The string `"Read from SD"`
(`0xFFF4A405`) has **no** 32-bit pointer reference in the image — it is a
computed-index UI menu label (per BRIEF CORRECTION #5, menu labels are reached as
`menu_table[cat].labels[item]`). It sits among the SD-info / camera strings
(`Used space`/`Free space`/`Capacity`/`CAMERA`/`SIZE`), i.e. the card data-transfer
UI, and reaches the ordinary FAT readers, not any firmware loader.

**MAIN side.** No firmware/loader/update/image string in the MAIN image at all
(`sd_interface.tsv` row `main_side_storage`: no `I:`, no FAT strings, no RIFF). MAIN
has no card interface. MAIN's only file names are **data containers** (below).

### B. The SD / SDHI interface (the substance is in the cited tables)

**Owner and controller.** SUB (RX64M) via the on-chip **SDHI** host controller at
base `0x0008AC00` — a dedicated SD host, not SPI mode. 19 distinct SDHI registers
are addressed with offsets matching the RX64M map exactly (`sd_interface.tsv`,
`sdhi_accesses.tsv`): `SDCMD +0x00`, `SDARG +0x08`, `SDSTOP +0x10`, `SDBLKCNT +0x14`,
`SDRSP10/32/54/76 +0x18/0x20/0x28/0x30` (full 136-bit R2 → CID/CSD), `SDSTS1 +0x38`,
`SDSTS2 +0x3C`, `SDIMSK1/2 +0x40/0x44`, `SDCLKCR +0x48`, `SDSIZE +0x4C`,
`SDOPT +0x50`, `SDBUFR +0x60`, `SDDMAEN +0x1B0`, `SDRST +0x1C0`. Released from
module stop via `MSTPCRD.MSTPD19` (`sub_FFF36CCA`, PRCR-guarded).

**Interrupt / DMA.** INTB slot **44** (SDHI SBFAI) is the only vector into the SD
driver → `sub_FFF32CA7` → `sub_FFF33AA7` (clears SDSTS2 BRE/BWE). ICU IER[0x05]
bit 4, IPR level 5. Block transfers use **DMAC channel 3** (base `0x000820C0`,
`DMTMD=0x9201`, `DMRSR3=0x2C`), DMAC3I on vector 123. Card power/detect pins are
configured by `sub_FFF32CBF` (P75/76/77/80/81/PC2/3/4 = CLK,CMD,D0-D3,CD,WP);
card detect is `SDSTS1` bit 5.

**Command set** (`sd_commands.tsv`): a standard SD/SDHC host command word table —
`uint16[64]` at `0xFFECE1E4` (CMD) and `uint16[52]` at `0xFFECE264` (ACMD). Full
init/transfer set present: CMD0/2/3/7/8/9/10/16, READ_SINGLE/MULTIPLE_BLOCK
(CMD17/18), WRITE_BLOCK/MULTIPLE (CMD24/25), CMD6 SWITCH_FUNC (high speed),
ACMD6 SET_BUS_WIDTH, ACMD41 SD_SEND_OP_COND, ACMD51 SEND_SCR. 512-byte blocks,
4-bit bus. Issue routine `sub_FFF33421`; the low `sddev_*` stub layer is the Renesas
SD-driver porting shim. No RSPI/QSPI/MMCIF/PDC — none of those peripheral windows is
ever addressed (`sd_interface.tsv`).

**Filesystem** (`fat_layer.tsv`): read-write **FAT12/16/32** with FSInfo support;
**exFAT is detected then rejected** (`fat_id_fstype` `sub_FFF23DBA` sets type `0x40`
for `"EXFAT"` at BS+3, then `cmp #40h / bne` returns −1). Boot-sector validation
checks the `0x55AA` trailer and `FAT12/16/32` type strings at BS+0x36/+0x52; FAT32
FSInfo is validated by the `RRaA`/`rrAa` signatures. LFN support (two illegal-char
sets plus the FAT DIR_Name checksum `sub_FFF20912`). `FORMAT` writes real volumes,
all three widths (`sub_FFF35A08` / `sub_FFF35D0B`, boot-sector templates at
`0xFFC3E8A3`/`0xFFC3E8E1`). The stack is plumbed into the Renesas CC-RX stdio
library (`<drive C>\stdin`/`stdout`/`stderr` in `_INIT_IOLIB` `sub_FFEE1780`), which is why
the card is drive `I:` (`C:` is reserved by the library). It is **not** ELM FatFs.

**What ordinary data the card holds** (`paths.tsv`, `path_owners.tsv`). Drive `I:`
with an auto-created tree (`sub_FFF3B8DE` walks a 7-entry table and mkdirs each):

| Path | Contents |
| --- | --- |
| `I:\FT3D`, `I:\FT3D\BACKUP` | settings / clone backup (`\Backup.bin` ↔ MAIN `BACKUP.dat`) |
| `I:\FT3D\GPSLOG` | GPS track log (append writer) |
| `I:\FT3D_MEMORY-CH` | memory-channel export/import (↔ MAIN `MEMORY.dat`) |
| `I:\QSOLOG` | Fusion/APRS QSO store (↔ MAIN `QSOMSG*.dat` / `QSOMNG.dat`) |
| `I:\PHOTO` | received/captured images (↔ MAIN `QSOPCT*.dat`) |
| `I:\VOICE` | voice `.wav` recordings (↔ MAIN `QSOWAV*.dat` / `WAVMNG.dat`) |
| `I:\LMREPAIR`, `I:\RECBACKUP` | recovery / voice-recording backup |

fopen modes `r`/`w`/`a`/`r+` are all present, so the card is fully read-write.

**Two-processor storage split.** SUB owns the SDHI hardware, the FAT filesystem, and
the physical file tree (drive `I:`). MAIN owns the logical **data-container** formats
— `QSOMSG.dat`/`QSOMSGDIR.dat`/`QSOMSGFAT.dat` (a FAT-inside-a-file), `QSOPCT*`,
`QSOWAV*`, `QSOMNG.dat`, `WAVMNG.dat`, `BACKUP.dat`, `MEMORY.dat` (all at MAIN file
`0x71412`–`0x726xx`, with no drive letter). The two are joined over the
inter-processor link (BOOT-IPC, doc 09, owns the link mechanics). This is distinct
from the radio's **settings** persistence, which is MAIN's internal store, not the
card (RESUME "SUB has no non-volatile store driver; MAIN owns persistence").

### C. Parsed removable-media formats (the real input surface — all data, no code)

The card does present parsed-file input paths, which matter as an attack/fuzz
surface even though none is firmware:

- **FAT/exFAT boot sector + FSInfo** — validated (`0x55AA`, type strings,
  `RRaA`/`rrAa`); exFAT rejected. This is the first thing parsed from any inserted
  card.
- **WAV / RIFF** — the voice recorder writes and the player reads `.wav`. The header
  magics `RIFF`/`WAVE`/`fmt ` are **inline immediates** in the voice code at
  `0xFFF141E1`/`0xFFF141F7`/`0xFFF14204` (each followed by an RX `mov.l #imm` opcode
  `0xFB`), i.e. `sub_FFF14194` builds the header and `sub_FFF379BC` (VOICE PLAY)
  parses it. Audio data, not code.
- **`.dat` / `\Backup.bin` data containers** — clone/settings restore and
  memory-channel import read structured data from the card back into the radio's
  settings/memory model (the readers use shared path+open helpers; the container
  formats are MAIN's). These are data structures loaded into RAM/settings, never a
  code region, and are not executed.
- **No S-record / Intel-hex / ELF / Motorola image parser** exists. Scattered
  `S0/S1/S2/S3` byte pairs in SUB `0x00030000`–`0x0003F000` are display-resource
  bytes, not ASCII S-record lines, and are referenced by no decoder.

Rigorous content-level validation (header magic / checksum) of the `.dat`/`Backup.bin`
containers is managed on the MAIN side and was not exhaustively proven here; that is
the residual input-validation surface (see Open).

## USB relevance

- **Question 1 (everything USB) / boot path.** The card is not a firmware channel:
  entering DSP WRITE MODE is MAIN's decision and the DSP image comes over the
  chip-to-chip wire, while the Main/Sub application images are written only through
  the Renesas boot-ROM USB path (docs 05/09/10). The card cannot introduce or
  update any of the three firmwares. Removing this lead narrows "paths into the
  radio" to USB boot mode and the DATA-jack command protocol.
- **Question 2 (USB SDR).** The SD path is irrelevant to a sample stream — it is a
  512-byte-block file store on SUB's SDHI/DMAC3, not a sample source or a transport
  to the USB engine (which is on MAIN). No bearing on the IQ-streaming chain.
- **Question 3 (reach the DSP).** Reinforces `06-dsp-vocoder.md`: the DSP is field-
  updatable, but only over MAIN's SCI-A after MAIN sequences the DSP reset — there
  is **no** SD-card route to the DSP. To send your own DSP frames you must modify
  MAIN's firmware over the USB boot path; the card gives no shortcut.

## Open

Most valuable first:

1. **Content-validation of the clone/backup and memory-channel `.dat` containers.**
   These are the one genuine "parsed file from removable media into the radio" input
   surface. Determine, on the MAIN side, whether `BACKUP.dat`/`MEMORY.dat`/`QSO*.dat`
   readers check a header magic, version, length, and checksum before applying the
   contents, or trust the file. A malformed card file cannot run code, but it could
   corrupt settings/memory or overflow a fixed buffer. This is a MAIN-side data-flow
   task (coordinate with MAIN-FULL / BOOT-IPC).
2. **The `\Backup.bin` ↔ `BACKUP.dat` clone format itself** — field layout and how
   much of the radio's configuration it can overwrite on restore. It is the widest
   card→radio data path.
3. **Confirmatory RX disassembly of `sub_FFF0DB03/DE56/E118`** once the
   the repository root path layout is restored (a `ida` junction, or a corrected
   `ROOT` in a private copy of `run_job.py`). Expected to only confirm the
   filesystem-free finding already established from the call graph.
4. **The inter-processor file-transfer protocol** (how MAIN's `.dat` container
   operations become SUB SDHI/FAT I/O) — owned by BOOT-IPC (doc 09); relevant only
   as the mechanism behind the two-processor storage split, not as a firmware path.
