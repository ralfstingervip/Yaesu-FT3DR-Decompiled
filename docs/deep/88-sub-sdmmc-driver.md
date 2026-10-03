# SUB SD/MMC storage driver: SDHI host, 26-slot ops vtable, R1 mask pairs, SD-spec format records (Lane K6)

Owner-side static analysis of `decrypted\FT3D_SUB_ver102_ALL.bin` (RX64M, little-endian, mapped
`0xFFC00000`, file offset = address − `0xFFC00000`). Private DB `K6_SDMMC`, seeded
`--copy-from ida\db\jobs\SUB_FINAL2\SUB_FINAL2.i64`. No shared DB was opened, no image was modified
(sha256 `8e3ecd05…` / `b93570b3…` re-checked after the run), and nothing was written to any device.
Model: claude-opus-5-5.

Tables are in `ida\out\sub-sdmmc\`: `vtable.tsv`, `sd-commands.tsv`, `geometry-records.tsv`,
`mask-table.tsv`, `peripheral-evidence.txt`. Raw material is in `raw\`: `disasm_sd.txt` (full listing
of `0xFFF2E000`–`0xFFF37900`), `periph_all.tsv` (every peripheral access in the DB),
`closure.tsv`, `callers.tsv`, `refs.txt` and `funcs_range.tsv`.

## Verdict

The microSD card hangs off the RX64M's on-chip **SDHI** controller in native SD mode, not SPI. The
module-stop release is `MSTPCRD` bit 19, cleared at `FFF36D36` (`7B 32`). That is the only `MSTPCRD`
bit the image clears. The 19 SDHI registers at `0x0008AC00`–`0x0008ADC0` are addressed only from
`FFF329FA`–`FFF33ADA`. The vectors are 44 (buffer access, which also triggers DMAC3), 111 (card
detect) and 123 (DMAC3 end). The eight pins get PSEL `0x1A`.

Nothing in the 4 MB image addresses RSPI, MMCIF, QSPI or SCI12. RSPI is never released from module
stop either. No SCI or GPIO bit-bang appears anywhere in the driver's 175-function call closure.

**The vtable is resolved.** `FFED7EB0` holds 26 function pointers, `FFED7EB0`–`FFED7F17`. Its only
reference is `FFF32C76`, inside the driver entry `sub_FFF32C56`. That entry builds the handle at RAM
`0x6832C` as `{ctx = 0x68030, ops = FFED7EB0}` and is registered as drive `'I'` (`0x49`) at
`FFF33B5D`/`FFF33B63`. Slot `+0x48` is `send_cmd(cmd, is_acmd, arg, ctx)` (`sub_FFF33538`). Slot
`+0x4C` is `get_response(type, ctx)` (`sub_FFF3355A`). Eleven of the 26 slots are stubs that return
constants.

**J11's "18-entry mask table" is two tables.** The first 14 entries are seven `{SD, MMC}` pairs of R1
card-status error masks, one pair per command class, indexed by the card family at `ctx+0x2C6`. The
last 4 entries are CMD6 SWITCH_FUNC arguments for driver strength (function group 3).

**The 13 × 44-byte records are the SD Association File-System-Spec format parameters.** Each holds
sectors/track, heads, boundary unit, NOM, sectors/cluster, bytes/sector, FAT type and RSC. Records 0–1
cover SDHC (≤ 4032 MiB and above). Records 2–12 cover SDSC from 2 MiB to 4 GiB. They match the
published table entry for entry. Their only consumer is the volume formatter, and that path's root
`sub_FFF36999` has **no inbound reference anywhere in the image**. So in ver 1.02 the records are
carried but never used.

The driver touches **no USB, SCI, RSPI or flash-controller register** anywhere in its closure.

## Method

| Job / script | Role |
| --- | --- |
| `ida\jobs\k6_dump.py` | Whole-DB peripheral scan with intra-function constant propagation (`mov.l #imm` plus `add #imm`, resolving `[rN]` and `disp[rN]`) → `raw\periph_all.tsv`. Every `o_imm`/`o_mem` reference into the driver tables → `raw\refs.txt`. Full listing of `0xFFF2E000`–`0xFFF37900` → `raw\disasm_sd.txt`. |
| `ida\jobs\k6_closure.py` | Forward call closure from the 26 vtable slots, `sub_FFF32C56`, `sub_FFF33AE7`, the three ISRs and the format entries. Covers direct calls and immediate function pointers: 175 functions → `raw\closure.tsv`, plus callers of the entry points. |
| Plain Python over the image | Coverage-independent scans of the whole 4,194,304 bytes for: every `FB`-form `MOV.L #imm,Rd` (li = 24-bit or 32-bit) into the SDHI, RSPI, MMCIF, QSPI, SCI, USB and PDC windows; 32-bit literals of the vtable, mask table, records and format entries; `BSR`/`BRA` `.A`/`.W` displacements targeting the format path. The table generators re-read every cited byte from the image and assert it equals the IDA listing. |

DB coverage: 2,426 functions, 0 orphan code runs. The peripheral and closure results inherit that
coverage, and the byte scans do not depend on it.

Not run:
- No decompilation of the FAT layer above the driver (doc 38's territory).
- No trace of how the setup-menu `FORMAT` action is carried out (see Open).
- No walk of the CSD parser `sub_FFF342FB`/`sub_FFF343BA` or the CID parser `sub_FFF344C9` field by
  field.
- `sub_FFF34DE9` (the UHS access-mode path) was read only far enough to show it is gated off.

## Findings

### 1. Handle, registration and the ops vtable (`vtable.tsv`)

The handle is built on every request, Confirmed from the bytes in `sub_FFF32C56`:

```
FFF32C65  fbe230800600  mov.l #68030h, r14     ; ctx
FFF32C6B  f8e400        mov.b #0, [r14]
FFF32C6E  fb522c830600  mov.l #6832Ch, r5      ; handle
FFF32C74  e35e          mov.l r14, [r5]        ; handle->ctx = 0x68030
FFF32C76  fb12b07eedff  mov.l #FFED7EB0, r1
FFF32C7C  a059          mov.l r1, 4[r5]        ; handle->ops = FFED7EB0
FFF32C8F  05b52b00      bsr.a sub_FFF35844     ; request dispatcher (handle passed on the stack)
```

`sub_FFF33AE7`, called from `sub_FFF12A75` ← `sub_FFF36C53`, registers this entry with
`mov.l #sub_FFF32C56, r3` (`FFF33B5D`, bytes `fb32562cf3ff`) and drive letter `mov.l #49h, r2`
(`FFF33B63`) into the device table at RAM `0x67FC0`. `FFF32C76` is the only reference to `FFED7EB0`.
There is no 32-bit literal of it elsewhere and no `FB` imm24 form (whole-image scan).

`sub_FFF35844` dispatches on the request code: 1 = read (`sub_FFF354FE`), 2 = write
(`sub_FFF3556B`), 5 = host init (`sub_FFF35805` → slot `+0x64`), 7 = mount (`sub_FFF35683`),
8 = unmount (`sub_FFF357E5`), 9 = media present (slot `+0x08`). Any other code returns −3. Read,
write and mount return −6 unless device byte `+0x58` bit 6 is set. The card-detect ISR sets that bit.

| slot | target | role (behaviour Confirmed; name Inferred) |
| --- | --- | --- |
| +00 | `FFF3312D` | `set_clock(mode)`. `SDCLKCR` ← `0x140` for mode 0, `0x101` for modes 1/−1, `0x100` for mode 2. Waits on `SDSTS2` b14/b13. |
| +04 | `FFF331E9` | `clock_stop`: `SDCLKCR` ← `0x200` |
| +08 | `FFF3321C` | `card_detect`: `SDSTS1` b5 → 0, else −6 |
| +0C | `FFF33238` | `write_protect`. **Stub, returns 0.** |
| +10/+14 | `FFF33241`/`FFF3324B` | Stubs returning −9 / −10 (CMD11 path) |
| +18 | `FFF33255` | Stub, returns 4 (driver-strength query) |
| +1C | `FFF33260` | Stub, returns 5 (1.8 V switch) |
| +20 | `FFF3326B` | `soft_reset`: `SDRST` ← 0 then 1 |
| +24 | `FFF33286` | `power_on`. Stub, returns 0. |
| +28 | `FFF3328F` | `power_off`: clock stop |
| +2C | `FFF33293` | `set_bus_width`: `SDOPT` ← `0x40EE` (4-bit) or `0xC0EE` (1-bit) |
| +30/+34/+38/+3C | `FFF332B2`/`B8`/`BE`/`BF` | No-op hooks |
| +40 | `FFF332C5` | Stub, returns −9 (tuning). Called only when `ctx+0x2C2` is 2 or 3. |
| +44 | `FFF332D1` | `wait_event(kind)`: 1 = RSPEND, 2 = ACEND, 3 = BWE, 4 = BRE. Times out after 0x100000 polls. Recovers with an SDRST. |
| **+48** | **`FFF33538`** | **`send_cmd(cmd, is_acmd, arg, ctx)`** → `sub_FFF33421` (`SDARG`, then `SDCMD` from the command-word tables) and `sub_FFF3350F` (wait for RSPEND, return `SDSTS2 & 0x807F`) |
| **+4C** | **`FFF3355A`** | **`get_response(type, ctx)`**. Types 1/3/6/7 copy `SDRSP10` to `ctx+0x2B0`. Type 2 (R2) copies 15 bytes from `SDRSP76`…`10`. |
| +50 | `FFF3365E` | `set_block(len, n)`: `SDSIZE`, `SDBLKCNT`, `SDSTOP`, then CMD16, then mask pair 3 |
| +54 | `FFF336DC` | CMD12, then mask pair 1 |
| +58 | `FFF33760` | `read_blocks`: CMD17/CMD18 with DMA. Two-block reads are split into two CMD17s. |
| +5C | `FFF338D7` | `pio_read`: longword reads from `SDBUFR` |
| +60 | `FFF3393D` | `write_blocks`: CMD24/CMD25 with DMA |
| +64 | `FFF33A61` | `host_init`: pins, SDRST, DMAC3 and ICU setup |

J11 cited `(*(drv+0x48))(7,0,0)` and `(*(drv+0x4C))(1)` in `sub_FFF34897`. Those calls are
**CMD7 deselect** (arg 0) or **CMD7 select** (arg RCA<<16, `FFF348ED`–`FFF348F3`), followed by
reading the R1 response.

The driver context at `0x68030` is laid out as follows. Offsets are Confirmed from the accesses, and
names are Inferred.

```c
struct sd_ctx {                 /* RAM 0x68030, 0x2FC bytes, then the handle at 0x6832C */
    uint8_t  pad0;
    uint8_t  sector[0x200];     /* +0x001 boot-sector / MBR buffer (sub_FFF355D8, sub_FFF35D0B) */
    uint8_t  csd[16];           /* +0x201 CMD9 */
    uint8_t  cid[16];           /* +0x211 CMD10 / CMD2 */
    uint8_t  scr[8];            /* +0x221 ACMD51; +0x222 bit2 = 4-bit bus supported */
    /* ... */                   /* +0x269 CMD6 64-byte switch status */
    uint16_t rca;               /* +0x2AA CMD3 R6 >> 16 */
    uint16_t bus_width;         /* +0x2AC 0 = 1-bit, 2 = 4-bit (ACMD6 argument) */
    uint8_t  resp[16];          /* +0x2B0 last response (R1/R3/R6/R7 u32, or R2 bytes) */
    uint16_t type_flags;        /* +0x2C0 b0 byte-addressed (SDSC v1/v2, MMC), b1 SDHC, b2 1.8 V */
    uint16_t uhs_mode;          /* +0x2C2 */
    int16_t  clock_mode;        /* +0x2C4 0 = identification, 1 = default, 2 = high speed, -1 = MMC */
    uint16_t family;            /* +0x2C6 0 = SD, 1 = MMC: column index into the mask table */
    struct sd_fmt fmt;          /* +0x2C8 format parameters, 0x2C bytes (section 4) */
    uint32_t clr0, clr1;        /* +0x2F4/+0x2F8 set by sub_FFF35938 during format */
};
```

### 2. Physical interface: SDHI (`peripheral-evidence.txt`)

All items below are Confirmed from the bytes. Register names follow the RX64M map (Inferred).

- **Module stop.** `sub_FFF36CCA` is the only writer of `MSTPCRB`/`MSTPCRC`/`MSTPCRD`. It clears
  `MSTPCRD` b19 (`FFF36D34`–`FFF36D38`, `a89a 7b32 a09a`) and `MSTPCRB` b31/b29/b28 (SCI0/2/3) only.
  RSPI0/1 (`MSTPCRB` b17/18), USB0 (b19), MMCIF and QSPI stay stopped.
- **Registers.** The 19 SDHI addresses, with access counts per function, are listed in the evidence
  file. `SDERSTS1/2`, `SDSWAP` and `SDVER` are never addressed.
- **Clock.** `SDCLKCR` ← `0x140` / `0x101` / `0x100` (`FFF331B7`/`BE`/`C5`). With PCLKB = 48 MHz
  (the 12 MHz-crystal reading of docs 02, 03 and 14), that gives **187.5 kHz for identification,
  12 MHz for default speed and 24 MHz for high speed** (Inferred from the CLKSEL coding). This closes
  doc 13's "clock rate not determined". `0x200` is the clock-stop value written by slots 1 and 10.
- **Bus width.** 1-bit for CMD0 (slot `+0x2C(0)` at `FFF33CBD`). 4-bit after ACMD6 when SCR byte
  `ctx+0x222` bit 2 is set (`FFF353B2`).
- **Vectors.**
  - Vector 44 → `FFF32CA7` → `sub_FFF33AA7`, which clears BRE/BWE. It is enabled by `IER05` b4 at
    `FFF32E8B` with IPR 5, and `DMRSR3` = `0x2C` at `FFF32E32` binds DMAC3 to it.
  - Vector 111 → `FFF32C99` → `sub_FFF32A29`, which handles `SDSTS1` b4 (insert) and b3 (remove). It
    is enabled by `IER0D` b7 at `FFF32DF8` with IPR 6, and `0x87674` (`GENBL1`) b3 at `FFF32DEF`.
  - Vector 123 → `FFF32DFB` → `sub_FFF33122` (DMAC3 end). It is enabled by `IER0F` b3 with IPR 4.
- **DMAC3.** `DMTMD` = `0x9201` (block, 32-bit, peripheral trigger). `DMAMD` = **`0x0080`**. `DMINT`
  = `0x10`. `DMAST` = 1.
- **Pins.** `P75`–`P77`, `P80`, `P81` and `PC2`–`PC4` get PSEL `0x1A` (`FFF32D39`…`FFF32DB7`) and
  PMR set. `PC2`–`PC4` get high drive. Mapping these to CLK/CMD/D0–D3/CD/WP is Inferred from the
  datasheet.
- **Alternatives (Not found, scope = whole image).** RSPI `0xD0100`–`0xD01FF`, MMCIF, QSPI and SCI12
  have 0 `FB` immediates, 0 literals and 0 resolved accesses. SCI0/2/3 are used only by the UART
  drivers at `FFEDB300`–`FFEDBD53`, and `SPMR` is never addressed. The driver closure touches PORT/MPC
  only in pin setup (`sub_FFF32CBF`), so there is no bit-bang loop.

**Write protect is never sensed.** No `SDSTS1` reader tests b7 (all four readers listed in the
evidence file). Slot `+0x0C` is `mov.l #0, r1` (`FFF3323D`). So device byte `+0x58` bit 5 is always
cleared at mount (`FFF357AF`–`FFF357C3`), and the write path's −7 at `FFF35469` cannot fire. A pin is
muxed for WP, but the firmware ignores the card's lock tab (Inferred effect).

**A word read-modify-write that misses its target.** The two helpers bracketing mount and unmount
(`sub_FFF329E0`/`sub_FFF329EE`) do `movu.w`/`mov.w` at `0x8720D` and clear or set **bit 15**. In
little-endian order that is `0x8720E` b7 = `IER0E` / vector 119, whose INTB slot is null. They do not
mask vector 111. The instruction semantics are Confirmed. That it is an unintended bit is Inferred.

### 3. Commands, responses and error checks (`sd-commands.tsv`)

There are 28 `send_cmd` call sites. Each is listed with its command index, ACMD flag, argument,
response type, R1 mask and retry count.

**Mount sequence.** `sub_FFF35683` (up to 3 attempts), then `sub_FFF351AD` and `sub_FFF352DF`:

1. Card detect, then clear the flags. Slot `+0x30(0)`, then clock mode 0 (187.5 kHz), then 10 ms.
2. **CMD0** (`FFF33CD2`, 1-bit bus).
3. **CMD8** with `0x1AA` (`FFF33E8D`). The R7 echo must equal `0x1AA`.
4. **CMD5** probe (`FFF33ECA`). If it succeeds, the card is SDIO and the driver returns −5.
5. **CMD55 + ACMD41**: an inquiry (arg 0), then `(OCR & 0xFF8000) | 0x41000000` (`FFF33FA3`) for up to
   100 × 10 ms. Bit 31 means ready, bit 30 (CCS) means SDHC, bit 24 (S18A) is accepted only if slot
   `+0x1C` returns 0, which it never does.
6. If CMD8 got no response: the v1 path (ACMD41 with OCR) runs. If CMD55 gets no response, the MMC
   path runs: **CMD1** `0x00FF8000` (`FFF33D39`), then `family = 1` and `clock_mode = -1`.
7. **CMD2** (CID).
8. **CMD3**: R6 gives the RCA, and `resp & 0xE000` → −8. MMC instead sets RCA 1 with
   `arg 0x10000`.
9. **CMD9** (CSD), **CMD10** (CID).
10. Set the block length to 512 (`sub_FFF35347`: CMD7 select at `FFF35356`, slot `+0x50`, CMD7 deselect at `FFF35383`).
11. **CMD7** select.
12. SD only:
    - **ACMD51** (SCR, 8 bytes, PIO).
    - **ACMD6** (bus width).
    - **CMD6**: query `0x00FFFFFF`, check `0x00FFFFF1`, switch `0x80FFFFF1` (`FFF34C18`). On success,
      `clock_mode = 2` (24 MHz).
    - **ACMD13** (SD status).
13. Clock on at `clock_mode`. Read the boot sector (`sub_FFF355D8`).

**Data path.** Before every transfer, `sub_FFF3466C` sends **CMD13** and acts on the R1 state field:
- tran → proceed;
- data or stby → CMD7;
- rcv → CMD12 (slot `+0x54`).

Reads use **CMD17/CMD18** and writes use **CMD24/CMD25** (3 tries each). Addresses are byte
addresses (`<<9`) unless SDHC (`ctx+0x2C0` b1). Data moves by DMAC3.

**CRC and response handling.** CRC7 and CRC16 are checked by the SDHI hardware. The firmware reads
the result as `SDSTS2 & 0x807F` after each command (`FFF3352B`), which covers CMDE, CRCE, ENDE, DTO,
ILW, ILR, RSPTO and ILA. Any nonzero value fails the try. After the hardware check, the R1 card status
at `ctx+0x2B0` is tested against a per-command mask (section 4). Errors returned:
- −0x16 read;
- −0x15 write;
- −0x17 select, status, set-blocklen and ACMDs;
- −9 for no response or busy;
- −6 no card;
- −5 SDIO.

**Paths that are present but never run.**
- **CMD11 / UHS** (`sub_FFF3403A`, `sub_FFF34DE9`) is gated off. It needs `ctx+0x2C0` b2, which needs
  slot `+0x1C` to return 0, and that slot returns 5 (`FFF33267`, `66 51`).
- The CMD6 driver-strength leg is skipped because slot `+0x18` returns 4.
- The command-word table defines **CMD19, CMD23 and ACMD22**, but none is ever issued. ACMD22's word
  `0x0C56` even encodes the write direction. Doc 13 listed ACMD22 as part of the command set.

### 4. The `FFED7F18` table: 7 R1-mask pairs and 4 CMD6 arguments (`mask-table.tsv`)

Every consumer has the same shape. For example, at `FFF3492F`:

```
movu.w 2C6h[ctx], r15                ; family: 0 = SD, 1 = MMC
mov.l  #base, r5                     ; base = FFED7F18 + 8*pair
mov.l  [r15, r5], r15                ; scaled index: base[family]
tst    2B0h[ctx].l, r15              ; R1 & mask -> error
```

| pair | SD mask | MMC mask | command class | consumer / base-load site |
| --- | --- | --- | --- | --- |
| 0 | `0FF98008` | `00D82000` | CMD7 | `sub_FFF34897` / `FFF34929` |
| 1 | `C6F80008` | `00D80000` | CMD12 | `sub_FFF336DC` / `FFF3371D` |
| 2 | `CFF98008` | `00D80000` | CMD13 | `sub_FFF345F3` / `FFF34646` |
| 3 | `2FF98008` | `20D82000` | CMD16 | `sub_FFF3365E` / `FFF336C0` |
| 4 | `CFF98008` | `E0F82000` | CMD17/18 | `sub_FFF337D7` / `FFF3386E` |
| 5 | `EFF98008` | `00D82000` | **unreferenced** (Not found: no literal or imm24 of `FFED7F40`/`44` in the image) | — |
| 6 | `EFF98008` | `E4D82000` | CMD24/25 | `sub_FFF33961` / `FFF339F8` |

The bits decode to the standard R1 error set, listed per entry in the TSV. For example, `0x0FF98008`
is ERASE_PARAM through ERROR, plus CSD_OVERWRITE, WP_ERASE_SKIP and AKE_SEQ_ERROR. Address and
out-of-range bits are added for the data commands, and BLOCK_LEN_ERROR for CMD16 and the writes. The
MMC column omits the SD-only bits. Inline masks elsewhere are `0x0FF98008` (CMD55/ACMD), `0x00D80000`
(MMC CMD3), `0x02C80008` (CMD11) and `0x82F80008` (CMD6).

Entries 14–17 (`FFED7F50`–`FFED7F5C`) are `0x00FFF0FF`, `0x00FFF1FF`, `0x00FFF2FF` and `0x00FFF3FF`.
These are CMD6 arguments with function group 3 (driver strength) = 0/1/2/3 and every other group
= `0xF`. `sub_FFF34C83` reads only element 0 (`mov.l [r14]` at `FFF34CCA`), and ORs bit 31 for the
switch. Elements 1–3 are never read (Not found).

### 5. The 13 × 44-byte records: SD File-System-Spec format parameters (`geometry-records.tsv`)

The record is copied with `memcpy(ctx+0x2C8, rec, 0x2C)` and then completed in place by
`sub_FFF36469`, which follows the SD Association format algorithm. The boot-sector writer
`sub_FFF35D0B` confirms each field by where it stores it in the BPB. The buffer is `ctx+1`, so
`BS+n` is `ctx+1+n`.

```c
struct sd_fmt {           /* 44 bytes; ctx+0x2C8 */
    uint16_t spt;         /* +0x00 -> BPB SecPerTrk  (BS+0x18, FFF35D85) */
    uint16_t heads;       /* +0x02 -> BPB NumHeads   (BS+0x1A, FFF35D94) */
    uint32_t bu;          /* +0x04 boundary unit (sectors): alignment of the system area */
    uint32_t nom;         /* +0x08 sectors before the partition -> BPB HiddSec (BS+0x1C); boot-sector LBA */
    uint32_t ts;          /* +0x0C total sectors (computed) -> TotSec16/32 */
    uint16_t sc;          /* +0x10 sectors per cluster -> BS+0x0D */
    uint16_t bps;         /* +0x12 bytes per sector (512) -> BS+0x0B */
    uint8_t  fat_bits;    /* +0x14 12/16/32; 32 selects the FAT32 template FFC3E8E1 and the FSInfo writer */
    uint8_t  pad[3];
    uint32_t sf;          /* +0x18 sectors per FAT (iterated) -> BS+0x16 / FAT32 field */
    uint16_t rsc;         /* +0x1C reserved sectors (1 preset for FAT12/16; computed for FAT32) */
    uint16_t pad2;
    uint32_t ssa;         /* +0x20 system-area sectors = RSC + 2*SF (+32 root-dir sectors for FAT12/16) */
    uint32_t max_clus;    /* +0x24 */
    uint32_t sf2;         /* +0x28 recomputed SF; loop until sf == sf2 */
};
```

Selection works as follows:
- **SDHC** (CSD structure 1, `C_SIZE` from CSD bytes 7–9, sectors = `(C_SIZE+1)<<10`,
  `FFF364A9`–`FFF364CE`). Record 0 is used when sectors ≤ `0x7DFFFF` (4032 MiB), record 1 above that
  (`sub_FFF362EF`). At ≥ `0x4000000` sectors (32 GiB) the driver returns −5.
- **SDSC** (CSD structure 0). Capacity in bytes is `(C_SIZE+1) × MULT × BLOCK_LEN`, using
  `sub_FFF36247`, `sub_FFF3627B` and `sub_FFF36218`. Records 2–12 are chosen by `bytes>>9` against
  thresholds of 2, 8, 16, 32, 64, 128, 256, 504, 1008 and 2016 MiB (`sub_FFF36327`).

| rec | class | spt/heads | BU | SC | FAT | RSC preset | NOM preset |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | SDHC ≤ 4032 MiB | 63/128 | 8192 | 64 | 32 | — | 8192 |
| 1 | SDHC > 4032 MiB | 63/255 | 8192 | 64 | 32 | — | 8192 |
| 2–3 | SDSC ≤ 2 / ≤ 8 MiB | 16/2, 32/2 | 16 | 16 | 12 | 1 | — |
| 4–6 | ≤ 16 / 32 / 64 MiB | 32/2, 32/4, 32/8 | 32 | 32 | 12 | 1 | — |
| 7–8 | ≤ 128 / 256 MiB | 32/8, 32/16 | 64 | 32 | 16 | 1 | — |
| 9–10 | ≤ 504 / 1008 MiB | 63/16, 63/32 | 128 | 32 | 16 | 1 | — |
| 11–12 | ≤ 2016 MiB / ≤ 4 GiB | 63/64, 63/128 | 128 | 64 | 16 | 1 | — |

This is exactly the SDA format table: CHS per capacity, BU 16→8192, SC 16/32/64, FAT12 ≤ 64 MB,
FAT16 ≤ 2 GB, FAT32 for SDHC, NOM = BU for SDHC. The record **content** is Confirmed. The match to
the specification is Inferred, from the values plus the algorithm in `sub_FFF36469`.

**Who uses them: only dead code.** The only reader chain is:

`sub_FFF36999` → `sub_FFF369F2` (`FFF369E4`) → `sub_FFF368FF` (`FFF36AFA`) → `sub_FFF36469`
(`FFF3691C`) → `sub_FFF362EF`/`sub_FFF36327`

`sub_FFF368FF` then writes the volume through `sub_FFF35D0B`/`B7D`/`A08`/`948`. The two boot-sector
templates `FFC3E8A3`/`FFC3E8E1` are referenced only in `sub_FFF35D0B` (literal scan). **`sub_FFF36999`
has 0 references**: no 32-bit literal, no `FB` imm24, and no `BSR`/`BRA` `.A`/`.W` displacement
targeting it anywhere in the 4 MB image. J10 already classifies it as dead. So the formatter, and with
it all 13 records, is unreachable in ver 1.02 (Inferred from that complete negative scan).

### 6. Corrections to earlier documents (owning docs not edited)

- **Doc 79 (J11):**
  - The "18-entry status/capability mask table" is **7 `{SD, MMC}` R1 error-mask pairs plus 4 CMD6
    driver-strength arguments**. `ctx+0x2C6` is the **card family** (0 = SD, 1 = MMC), not a status
    index.
  - The `+0x48`/`+0x4C` calls in `sub_FFF34897` are CMD7 plus get-R1.
  - The `0x7DFFFF` split is **within SDHC** (4032 MiB: 128 versus 255 heads), not SDSC/SDHC. SDSC is
    records 2–12.
  - "Field 0" is `{u16 spt, u16 heads}`. "Field 7 = 1" is RSC.
  - The records are reached only from the dead `sub_FFF36999`.
- **Doc 13 / `ida\out\storage\sd_interface.tsv`:**
  - `DMAMD` is `0x0080`, not `0xFF80`. IDA renders the unsigned `#uimm8` of `3D 12 80` as `#-80h`.
  - `SDCLKCR 0x200` is clock stop. The run values are `0x140`/`0x101`/`0x100` (187.5 kHz / 12 MHz /
    24 MHz under the 12 MHz-crystal reading).
  - Write protect is **never** read, beyond the earlier "not seen".
  - ACMD22, CMD19 and CMD23 are table entries only and are never issued.
  - MMC (CMD1) is supported, and SDIO is detected and refused (CMD5 → −5).
  - "FORMAT writes real volumes" holds for the code, but that code is unreachable.
- **Doc 02:** the vector-111 enable path also sets `GENBL1` b3 (`0x87674`). The mount and unmount
  helpers' 16-bit RMW toggles vector 119's IEN, not vector 111's.
- **IDA display trap (adds to BRIEF correction 4):** for RX `MOV.size #uimm8, dsp:5[Rd]` (opcodes
  `3C`/`3D`/`3E`), IDA prints the unsigned 8-bit immediate as signed. `3E 00 80` is `#0x80`, not
  `#-0x80`. Seen at `FFF32E62` and `FFF362D6`.

Byte-count delta: **0**. No function bounds, types or names were applied to the seed. The headline
464,263 is unchanged.

## USB relevance

**USB: confirmed none.** The scope is the 175-function forward closure of the driver: vtable slots,
entry, registration, ISRs 44/111/123 and the format path. It makes 0 accesses to USB0
`0xA0000`–`0xA03FF`, USBA `0xD0000`–`0xD00FF`, any SCI, RSPI or the FCU. It touches only DMAC0–3 and
`DMAST`, ICU `IER`/`IPR`/`DMRSR`/`GENBL1`, SDHI and PORT/MPC (`peripheral-evidence.txt` section 7).

**DSP and the inter-processor link: none.** The DSP belongs to MAIN (SCI-C). The SUB↔MAIN link is
SCI-based, and the driver touches no SCI.

**The three mission questions.**
1. The card is a plain SDHI block device on SUB. It does not appear on the USB surface, which lives
   on MAIN.
2. For SDR, it is a 512-byte-block store on DMAC3 that the driver uses only for file I/O. It is not a
   sample source or a USB transport. It could in principle sink a recording that SUB code produced,
   but no such producer feeds it in ver 1.02.
3. It gives no route to the DSP.

The card-side input surface is unchanged from doc 13 (FAT/boot sector, WAV, `.dat`). This lane adds
one fact to it: **the write-protect tab is ignored**.

## Open

Most valuable first.

1. **How the setup-menu `FORMAT` (label `0xFFC3E70D`, popup `FORMAT?`) is executed.** It cannot reach
   the SD-spec formatter statically. Tracing the confirm action, probably a MAIN→SUB IPC request,
   would show whether the radio formats at all or only clears `I:\FT3D…`.
2. **Callers of the generic registration `sub_FFF25146`** from `sub_FFF2511D`/`sub_FFF257B1`. Check
   whether any other drive besides `'I'` is registered with a different ops table (none was found
   among literals, but those two wrappers were not traced to their callers).
3. **CSD and CID field use** (`sub_FFF342FB`, `sub_FFF343BA`, `sub_FFF344C9`): which fields drive
   capacity and timeouts, and whether a malformed CSD (for example `C_SIZE_MULT` 7) can overflow the
   32-bit SDSC byte count in `sub_FFF36327`. That function is dead, but the mount path computes
   capacity separately.
4. **Vector 119 RMW.** Confirm against the part manual that `0x8720E` b7 has no live source on this
   board, which would make it harmless.
5. **The FAT-layer side of request codes 1, 2, 7, 8 and 9.** Doc 38 owns that. Map who issues
   unmount (code 8) on card removal: the ISR only flips `+0x58` b6.
