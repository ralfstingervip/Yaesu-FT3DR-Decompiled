# 51 — SUB side of the MAIN↔SUB link layer, and the FE00/FFFF block transfer (lane H14)

Owner-side static analysis of the decrypted ver 1.02 images on disk. Nothing was written to any
device, no image byte was changed, and no shared database was opened. SUB is RX64M, little-endian,
mapped at `0xFFC00000` (file offset = address − `0xFFC00000`). MAIN is H8SX, big-endian, base 0
(file offset = address); the closed MAIN window `0x078106`–`0x07B753` was not analysed. Model:
**claude-opus-5-5**.

Private DBs, via `run_job.py` only: `H14_SUB` (`--copy-from ida\db\jobs\H5_SUB\H5_SUB.i64`),
`H14_MAIN` (`--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64`), iterated with `--reopen`. Scripts
`ida\jobs\h14_dump.py` (generic dumper, copy of `h12_dump.py`) and `ida\jobs\h14_readers.py`
(reader-site classifier); both `auto_wait`, try/except→`*_error.txt`, UTF-8, `qexit(0)`. No
traceback was produced. Tables: `ida\out\sub-link\functions.tsv`, `block-transfer.tsv`,
`readers_class.tsv` (all 1160 `mov.l #8E46h` sites), and the raw listings `dump1.txt`,
`dump_main.txt`, `dump_main2.txt`, `dump_sub2.txt`, `dump_sub3.txt`, `dump_sub4.txt`.

## Verdict

**The MAIN↔SUB link is one checksummed, framed, byte-stream protocol over the SCI link, and the
receive path is now fully reversed from the SCI0 byte sink to the screen classifier.** Bytes land in
SUB's SCI0 ring (RX ISR `sub_FFEDB131`); a nine-state deframer `sub_FFEDC615` validates the start
nibble, a 6-byte header (opcode, length, header checksum) and a trailing frame checksum, sets the
"frame ready" state, and on error sends a status frame back to MAIN (`0xFFF0` header-checksum error,
`0xFFF1` length/overrun, `0xFFFE` frame/block checksum). Valid frames are handed to the link-layer
dispatcher `sub_FFEDC976`, which either acts immediately (power-down, block transfer, F3D5/F3D6,
F000/F001) or enqueues the frame to a 4-slot classifier ring that the main loop drains into the
pending buffer `0x8E46`.

**The FE00/FFFF block transfer is a 256-byte-block, 32-bit-checksummed, bidirectional bulk copy into
SUB's external graphics RAM — and it carries display/image data only.** `0xFFFF` writes 256-byte
blocks from MAIN into SUB external memory at `0x070E1000 + (block−1)·256`; `0xFE00` reads a block
back to MAIN; a checksum mismatch on the last block replies `0xFFFE`. The destination `0x070E1000`
is the **input staging buffer of SUB's JPEG/image decoder** (`sub_FFF3CAD0` loads an image there and
`sub_FFEDE804` decodes it into the framebuffer at `0x070BB800`); `0x07000000` is the 320×240
framebuffer surface (descriptor at `0x1D3B8`, set by `sub_FFEF032D`). The MAIN source is a ≤1 KB RAM
window (`0xFF5806`/`5906`/`5A06`/`5B06`) driven from MAIN's `0x559xx`–`0x55Fxx` region. The only SUB
consumer of the buffer is the image-decode-and-blit path; nothing routes it to code, the DSP, USB,
or a sample stream. **It cannot carry anything but image/UI data.**

**F000/F001 and `0x06000000` are the LCD controller, confirmed.** `sub_FFEDE298` writes a command
byte to `0x06000000` bracketed by a strobe on port latch `0x8C028` bit 2; F000 sends `0x28`
(display OFF), F001 sends `0x29` (display ON). The framebuffer is pushed to `0x06000000` by an
external-DMA engine programmed at `0x00082800`.

**Task 4 is closed: all 1160 `mov.l #8E46h` sites decode and every one is a pending-buffer
accessor.** The "145 undecoded" from lane H5 was a database-coverage artefact; at full coverage no
site is ambiguous (537 direct `[rN+disp]` field reads, 623 `add #imm,rN,rN` pointer-arithmetic then
dereference, 0 unresolved). The only writer of `0x8E46` remains the dequeue memcpy.

## Method

- `H14_SUB`/`H14_MAIN` as above. The dumper's `func`/`xref`/`imm`/`ctx` commands were driven by
  request files `ida\out\sub-link\req*.txt`. Every address below was read as bytes + disassembly.
- The four link-layer callees named by H5 (`sub_FFF3BC97`, `sub_FFF38338`, `sub_FFF38107`,
  `sub_FFEDC4DD`) were dumped whole, plus the receive chain (`FFEDB131`, `FFF36C53`, `FFEDC5EE`,
  `FFEDC615`, `FFEDC976`, `FFEDC1F6`, `FFEDD0D4`, `FFEDC493`, `FFEDD182`, `FFEF0385`), the LCD helpers
  (`FFEDE298`, `FFEF2022`, `FFEF201A`), the graphics consumers of `0x070E1000`/`0x07000000`
  (`FFF3CAD0`, `FFEDE804`, `FFEF032D`, `FFEF04F7`, `FFEF1EFA`), and the MAIN senders (`B6B6`, `B610`,
  `B5CE`, `B572`, `D53A`, `71196`) with their callers (`55976`, `559F4`, `55D32`, `55FDE`, `55DEE`).
- Block-transfer sites were cross-checked against a raw-byte scan of `decrypted\FT3D_SUB_ver102_ALL.bin`
  for every `mov.l #8E46h,rN` and every reference to `0x06000000`/`0x07000000`/`0x070E1000`.
- **Not done / Not found.** An immediate scan over recovered SUB functions for BSC registers
  (`CSnCR 0x00083802…`, `CSnMOD 0x00083002…`, SDRAM `0x00083C00`, bus-enable `0x00083000`/`0x00083400`)
  found **no** hits — the external-bus enable/wait-state configuration is not visible as immediates in
  the decoded code (it is likely in startup `_INITSCT` or uses a base-register form). The CS-area
  assignment below therefore rests on the RX64M fixed external-address map plus the firmware's own
  byte accesses, not on a BSC write. The MAIN `0x559xx`–`0x55Fxx` drivers' own callers (what triggers
  an image push) were not traced to the top.

## Findings

### 1. The receive path, SCI byte ISR → frame queue (Confirmed bytes)

Two rings exist. The **SCI0 byte ring** is filled by the RX ISR; the **4-slot classifier ring** (control
block `0x00012D44`, slot stride `0x12C` = 300 bytes, data at `+0x8016`, length at `+0x800E`, write
index `0x84C6`, read index `0x84C7`) holds complete frames for the UI.

- **`sub_FFEDB131`** (`FFEDB131`–`FFEDB1EE`): SCI0 RX byte callback. Channel descriptor table
  `0x00012CD8`, stride `0x18`; writes one received byte into the channel's ring buffer (base at
  desc`+4`, size at desc`+0x14`), advancing the head with wrap. Generic Renesas SCI driver sink.
- **`sub_FFEDC615`** (`FFEDC615`–`FFEDC96D`): the **deframer / framing state machine**. State byte at
  `[0x12D44]`; it pulls one byte at a time (`sub_FFEDB250(buf=0x12D44+4, len=1)`) and jumps through
  `jpt_FFF48064`:

| state | action (frame assembled at `0x12D44+5…`) |
| --- | --- |
| 0 | require `byte & 0xF0 == 0xF0`; `[+5]=byte` (opcode hi), hdr-sum `0x800A=byte`; →1 |
| 1 | `[+6]=byte` (opcode lo), hdr-sum+=byte; →2 |
| 2 | `[+7]=byte` (len hi), hdr-sum+=byte; →3 |
| 3 | `[+8]=byte` (len lo), hdr-sum+=byte, `len 0x8008=(hi<<8)|lo`; if `len>0x7FFF` reset state 0 **and if opcode==FF send `0xFFF1`**; else →4 |
| 4 | `[+9]=byte`, recv-hdr-sum `0x800C=byte<<8`; →5 |
| 5 | `[+0xA]=byte`, `0x800C|=byte`; if `0x800C==0x800A` (header checksum OK) continue sum, counter `0x8006=6`, `len+=2`, →6 (or 7 if already complete); else reset **and if opcode==FF send `0xFFF0`** |
| 6 | payload: `slot[+5+counter]=byte`, frame-sum `0x800A+=byte`, counter++; when `counter>=len` →7 |
| 7 | `0x800C=byte<<8` (recv frame checksum hi); →8 |
| 8 | `0x800C|=byte`; if `0x800C==0x800A` (frame checksum OK) → **state 9 = frame ready**; else reset **and if opcode==FF send `0xFFFE`** carrying the block number `[+0B..0C]`, then enqueue a synthetic 2-byte `FF FE`/`FF FF` to the classifier ring |

  So framing = start nibble `0xF`, a 2-byte big-endian opcode, a 2-byte big-endian length, a 2-byte
  header checksum (sum of the 4 opcode+length bytes), the payload, and a 2-byte frame checksum (sum of
  all bytes from the opcode). Both checksums are the additive byte-sum `sub_B6B6` computes on MAIN.
- **`sub_FFEDC5EE`** calls `sub_FFEDC615` (assemble one frame) then `sub_FFEDC976` (dispatch it); it is
  reached from the SUB main loop `sub_FFF36C53` (reset `0xFFC00036`) via `sub_FFEDC16C`.
- **`sub_FFEDC1F6`** (dequeue, called from pump `sub_FFF36CA2`): if the classifier ring is non-empty,
  mirrors the slot's first two bytes to `0x84C8/0x84C9` and copies the 300-byte slot to the pending
  buffer `0x8E46` (`sub_FFEF0385` → memcpy). `sub_FFEDEF97` then dispatches the screen handler
  through `off_FFED4040[state]`.

```c
/* deframer, faithful to sub_FFEDC615 */
enum { S_OP_HI, S_OP_LO, S_LEN_HI, S_LEN_LO, S_HCK_HI, S_HCK_LO, S_DATA, S_FCK_HI, S_FCK_LO, S_READY };
static uint8_t  *F   = (uint8_t*)0x12D49;      /* frame body: F[0]=opcode hi … (0x12D44+5) */
static uint16_t *st  = (uint16_t*)0x12D44;
void deframe(void) {
    uint8_t b;
    while (sci0_get(&b)) {                      /* sub_FFEDB250, one byte */
        switch (*st) {
        case S_OP_HI: if ((b&0xF0)!=0xF0) break; F[0]=b; hsum=b;              *st=S_OP_LO; break;
        case S_OP_LO: F[1]=b; hsum+=b;                                        *st=S_LEN_HI;break;
        case S_LEN_HI:F[2]=b; hsum+=b;                                        *st=S_LEN_LO;break;
        case S_LEN_LO:F[3]=b; hsum+=b; len=(F[2]<<8)|b;
                      if (len>0x7FFF){ *st=0; if(F[0]==0xFF) reply(0xFFF1);}   else *st=S_HCK_HI; break;
        case S_HCK_HI:rhsum=b<<8;                                             *st=S_HCK_LO;break;
        case S_HCK_LO:rhsum|=b;
                      if (rhsum==hsum){ fsum=hsum+F[4]+F[5]; cnt=6; len+=2;    *st=(cnt>=len)?S_FCK_HI:S_DATA; }
                      else            { *st=0; if(F[0]==0xFF) reply(0xFFF0); } break;
        case S_DATA:  F[cnt++]=b; fsum+=b;       if (cnt>=len) *st=S_FCK_HI;   break;
        case S_FCK_HI:rfsum=b<<8;                                             *st=S_FCK_LO;break;
        case S_FCK_LO:rfsum|=b;
                      if (rfsum==fsum) *st=S_READY;                           /* FFEDC976 then runs */
                      else { *st=0; if(F[0]==0xFF){ reply_block(0xFFFE,blocknum()); enqueue_notify(); } } break;
        }
    }
}
```

The error replies all go out through **`sub_FFEDC493`** → **`sub_FFEDD182`** (the SUB→MAIN frame
transmitter, which builds a reply at `0x12D44+0x85F6` with a type byte, a 2-byte status word, and an
`n+9` length). `sub_FFEDC493` first zeroes the block-transfer accumulators, writes the status opcode
to `0x84CA/0x84CB`, and sends `sub_FFEDD182(0xE2, 0, 2)`.

### 2. The four link-layer callees (Confirmed bytes)

- **`sub_FFF3BC97`** (`FFF3BC97`–`FFF3C165`, called from the FC00 branch `FFEDCDDB`): the FC00 **bulk
  apply**. It clears several name/record buffers (`0x10C66`, `0x10CA6`, `0x10CE6`, `0x10D26`
  [0x40 each], `0x10F66`/`0x11366`/`0x11766`/`0x11B66` [0x400 each], `0x10E66`/`0x10E86`/`0x10EA6`…),
  then unpacks a channel/band record from the frame into the working struct `0x12534`: a frequency
  word (`[+8..+9]`→`[0x12534]`), channel count (`[+0xA..+0xB]`, bounded ≤5), step/mode/tone nibbles
  BCD-decoded through `jpt_FFF3BED3`, and finally rebuilds the band list via `sub_FFF3E4A7`. This is
  memory-channel / band-plan / settings display data, not code.
- **`sub_FFF38338`** (`FFF38338`–`FFF38402`, F3D5 via `FFEDCE43`): a handshake step gated on
  `[0x122A6]==0x15`/`[0x122AA]==0x16` and frame sub-type `[+8]==9`; copies 0xC identity bytes
  (`[+0x19]`→`0x1032D`) and 0x10 bytes (`[+9]`→`0x1033A`), validates against ROM template
  `FFF38B7E` (`sub_FFF39C68`), and advances `[0x122AA]=0x16`.
- **`sub_FFF38107`** (`FFF38107`–`FFF38292`, F3D6 via `FFEDD00D`): the sibling step; copies
  `[+0x22]`→`0x10358` and `[+0x32]`→`0x1034B`, validates against ROM `FFF38BDA`, and transmits ack
  frames back to MAIN (`loc_FFEDD528`, types `0xE6`/`0xE5`) from buffer `0x10369`. F3D5/F3D6 together
  are a multi-frame identity/pairing (clone) handshake over text/ID buffers — display/config data.
- **`sub_FFEDC4DD`** (`FFEDC4DD`–`FFEDC5EE`, FE00 via `FFEDCDC0`): the **block read-back**. Given a
  requested block number `n` (1..total), it computes `src = 0x070E1000 + (n−1)·256`, byte count =
  256 for a middle block or `[0x1CC40]` (the stored last-block count) for the last, builds a reply
  (block#, total#, 32-bit checksum `[0x1CC48]`) at `0x84CA`, copies the block's bytes out of external
  RAM into the reply starting at offset 8, and transmits it to MAIN via `sub_FFEDD182(0xFF,…)`.

### 3. FE00/FFFF block transfer (Confirmed)

**SUB receive of `0xFFFF`** (`sub_FFEDC976`, `FFEDCA70`–`FFEDD0C7`):

```c
/* 0x1CC3A cur_block, 0x1CC3C total, 0x1CC40 run_off, 0x1CC44 run_sum, 0x1CC48 exp_sum, 0x1CC4C state */
if ((*(u32*)0x8281E >> 7) == 1) return;             /* engine-busy guard (DMAC/EXDMAC region) */
u16 blk = (F[6]<<8)|F[7];  *(u16*)0x1CC3A = blk;     /* frame +0x0B..0C : block number, 1-based */
if (blk == 1) { *(u16*)0x1CC3C = (F[8]<<8)|F[9];    /* +0x0D..0E : total block count */
                *(u32*)0x1CC40=0; *(u32*)0x1CC44=0; *(u8*)0x1217F=0; *(u32*)0x1CC4C=1; }
if (*(u32*)0x1CC4C == 1) {
    u8 *dst = (u8*)(0x070E1000 + (blk-1)*256);
    u16 n   = ((F[2]<<8)|F[3]) - 0xC;               /* len field − 0xC = 256 for a full block */
    for (i=0;i<n;i++){ dst[i]=F[0xE+i]; *(u32*)0x1CC44 += F[0xE+i]; }   /* data @ frame +0x13.. */
    if (*(u16*)0x1CC3A == *(u16*)0x1CC3C) {          /* last block: verify 32-bit checksum */
        u32 exp = (F[0xA]<<24)|(F[0xB]<<16)|(F[0xC]<<8)|F[0xD];   /* frame +0x0F..0x12, big-endian */
        if (exp == *(u32*)0x1CC44) *(u32*)0x1CC4C = 2;            /* OK  */
        else { reply(0xFFFE); *(u32*)0x1CC4C = 3; return; }      /* mismatch → FFFE, error */
    }
}
/* then notify the UI: enqueue a synthetic 2-byte FF FE / FF FF frame and set 0x1217F = F[6] */
```

- **Block size** 256 bytes; frame length field `0x10C`, wire total `0x116`. **Checksum** = 32-bit
  running sum of every data byte across all blocks, compared on the last block against the 4-byte
  big-endian value MAIN places at frame `+0x0F`. **Sequencing** by an embedded 1-based block number
  and a total-block count; **ack/error** by the reverse `0xFFFE` frame on mismatch. `0xFE00` reads any
  block back for verification (§2). Incoming `FFFE` and `FFFF` both enter this handler; the opcode low
  byte is echoed in the UI notification.
- **MAIN sender** (`H14_MAIN`): **`sub_B610`** (`0xB610`) builds the `0xFFFF` frame — block number
  `0xFFFFBC40` (incremented per block) → `0xFF3D7A` (frame `+0x0B`), total `0xFFFFBC42` → `0xFF3D7C`
  (`+0x0D`), the running 32-bit checksum `0xFFFFBC44` → `0xFF3D7E` (`+0x0F`), and copies the caller's
  `er5` source into `0xFF3D82` (`+0x13`); `sub_B5CE` (`0xB5DE`) builds the `0xFE00` read-back request.
  Both go through `sub_B6B6`, which special-cases `≥0xFE00` (and `0xFC00`/`0xF3D5`) to skip the normal
  payload fill. **Data source:** `sub_55976` (`0x55976`) selects one of four 256-byte MAIN RAM buffers
  `0xFF5806`/`0xFF5906`/`0xFF5A06`/`0xFF5B06` and feeds `er5`; the remaining-byte counter is
  `0xFFFFB098`. These senders live in MAIN's `0x559xx`–`0x55Fxx` region, immediately adjacent to the
  on-chip USB module (ISRs `0x54CFA`/`0x54D50`/`0x54EC2`, descriptor `0x55818`).
- **Destination = SUB external graphics RAM, image data only (Confirmed).** `0x070E1000` is the input
  staging buffer of the **JPEG/image decoder**: `sub_FFF3CAD0` opens an image file and reads it in
  `0x400`-byte chunks into `0x070E1000`, then `sub_FFEDE804` decodes it (input `0x070E1000` length
  `0x14000`, output framebuffer `0x070BB800` length `0x25800`, clamp routine `FFF4C9D1` — the JPEG
  saturate from doc 50 §3/doc 34) and blits it to the panel. `sub_FFEF032D` initialises the framebuffer
  surface descriptor `0x1D3B8` to base `0x07000000`, `0x140`×`0xF0` (320×240). The block transfer
  writes to the same staging buffer, so the MAIN→SUB path is "push an image to SUB's decoder and show
  it" (received photo / RAM-DISPLAY / camera image). **No SUB code routes `0x070E1000` anywhere except
  the image decoder and the LCD**, so the block transfer cannot carry code, DSP frames, USB data, or a
  sample stream.
- **CS-area mapping.** On the RX64M the external-bus CS areas sit at fixed base addresses, so
  `0x06000000` is the **CS5** area and `0x07000000` the **CS6** area (`0x070E1000 = CS6 + 0xE1000`);
  the firmware's byte/longword accesses to both confirm they are memory-mapped external devices.
  (Inferred for the area numbers; the BSC enable/timing writes were **Not found** — scope: immediate
  scan of recovered functions for `0x00083000`–`0x00083FFF`.)

### 4. F000/F001 and `0x06000000` — the LCD controller (Confirmed)

```c
void lcd_cmd(u8 c){ *(u8*)0x8C028 &= ~(1<<2); *(volatile u8*)0x06000000 = c; *(u8*)0x8C028 |= (1<<2); }
/* F000 → sub_FFEF2022: lcd_cmd(0x28);  F001 → sub_FFEF201A: lcd_cmd(0x29); */
```

`sub_FFEDE298` writes a command byte to `0x06000000` (CS5) framed by a strobe on port latch `0x8C028`
bit 2. F000 sends `0x28` (display OFF), F001 sends `0x29` (display ON) — standard LCD-controller
display-enable commands. The framebuffer is streamed to `0x06000000` by an external-DMA engine
programmed at `0x00082800` (`sub_FFEF1EFA` writes the panel address `0x06000000` into its destination
register). So `0x06000000` = the LCD command/data port on CS5, driven both by F000/F001 (direct
command bytes) and by EXDMAC (pixel data). Confirms the H5 inference.

### 5. The 145 undecoded `0x8E46` readers — closed (Confirmed)

A raw-image scan found 1160 `mov.l #8E46h,rN` sites (H5's "1,163", one encoding form). In a
fully-analysed DB (`readers_class.tsv`) **all 1160 are code**, and every one resolves its first use of
`rN` within 8 instructions: **537** dereference it directly as `[rN+disp]` (settings-shadow field
compares/copies such as `cmp 0x6C[r15],r14` and `mov.b 0x6C[r15],0x6C[r14]`), **623** use it as a base
in `add #imm,rN,rN` pointer arithmetic (e.g. `+0x20`, `+0x21`, `+0x82`) immediately before a
dereference, and **0** are unresolved. 328 are inside IDA-recognised functions and 832 are code heads
not yet grouped into a function (fragmentation, not ambiguity). Every site is a reader of the pending
received-frame buffer; the sole writer of `0x8E46` is the dequeue memcpy (`sub_FFEF0385`). The "145
undecoded" was a coverage artefact of the H5 database, not a hidden code path.

## USB relevance

No USB surface is added or reached by anything in this lane.

- The block transfer is MAIN RAM → SUB external **graphics** RAM over the same SCI link as the rest of
  IPC, feeding the JPEG decoder and the LCD. It is an image/display path, it runs at SCI speed, and it
  terminates in a framebuffer, not a USB endpoint or a sample sink. It is a **no** for question 2 (USB
  SDR): the destination is not a transport and cannot be steered to one.
- It does **not** touch the DSP (question 3). F3D5/F3D6 are an identity/pairing handshake; FC00 is
  settings/channel data; F000/F001 are LCD commands.
- One point of note for question 1: the MAIN-side block-transfer drivers sit inside the `0x55xxx`
  region adjacent to MAIN's on-chip USB module. This lane did not trace what triggers an image push;
  whether any of those `0x559xx`–`0x55Fxx` drivers is fed from the USB CDC path (vs. the DATA jack or
  an internally-generated image) is left open and is worth one pass, because the USB module and the
  image-transfer senders are neighbours in the MAIN image.

## Open (most valuable first)

1. **Trace the top callers of the MAIN block senders** (`sub_55976` via `0x5569A`, `sub_559F4` via
   `0x55612`, and `0x55D0C`/`0x55FB8`/`0x55DEC`) to confirm whether the image they push comes from the
   USB CDC endpoint, the DATA jack, or an internal buffer. This is the only live thread toward USB in
   this subsystem.
2. **Identify `0x0008281E`** (the block-reception busy guard) precisely — it reads as a longword in the
   DMAC/EXDMAC register region; confirm it is the blit-engine status so "reception is blocked while the
   panel DMA is busy" becomes Confirmed rather than Inferred.
3. **Find the BSC/SDRAM configuration** for CS5/CS6 (startup `_INITSCT` or base-register form) to turn
   the CS-area numbers from Inferred to Confirmed and state async-SRAM vs. the exact device timing.
4. **Reverse `sub_FFEDD182` fully** (the SUB→MAIN transmitter) and enumerate the reply type codes
   (`0xE2` status, `0xE5`/`0xE6` acks, `0xFF` block read-back) — the return half of the contract that
   docs 25/09 left open.
