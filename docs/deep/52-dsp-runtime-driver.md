# MAIN's normal-runtime DSP driver, reconstructed as C

> Lane H15. Private DB `H15_MAIN` (`ida\db\jobs\H15_MAIN\H15_MAIN.i64`), seeded
> `--copy-from ida\db\jobs\MAIN_H8SX\MAIN_H8SX.i64` (h8sxa). No other database was opened, no
> image was modified, and nothing was written to a radio. Job script `ida\jobs\h15_dump.py`
> (reopen-only range dumper; it never decodes inside `0x078106`–`0x07B753`). Raw listings are in
> `ida\out\dsp-runtime\work\*.txt`. Tables are `ida\out\dsp-runtime\opcodes.tsv` and
> `ida\out\dsp-runtime\routines.tsv`. Image `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, so file
> offset = address, big-endian. Model: claude-opus-5-5.
>
> Boundary: the CDC-ACM / DSP-download window `0x078106`–`0x07B753` and `sub_5DD00` were not
> analysed. The only edges into them that this document names are `0x0561B0 jsr 0x07711E`, the
> bridge branch of the SCI-C ISR.

## Verdict

MAIN drives the DSP with a small, fully static stack:

- a power state machine on P3DR `0xFFFF52`;
- an IRQ2 handshake line from the DSP;
- a byte-per-interrupt receive ring;
- DMA channel 1 for transmit (32- or 96-byte frames);
- a half-duplex link state machine that sends exactly one frame per turn, with ACK/NAK;
- a fixed 14-step init script, followed by session scripts that the UI selects.

Every frame from the DSP is **32 bytes**. Their opcodes run from `0x86` to `0xBB`. Until the DSP
has announced its version, the only opcode accepted is `0x9F`.

The version word `0xFFB0DC` is written in exactly one place. That is `0x056A0C`, which stores
bytes 1 (high) and 2 (low) of a `0x9F` frame. A word of 0 is NAKed.

The `VER?` query (`0x1F`) is **dead code in ver 1.02**. Its only route is the 44-entry builder
table at `0x05A3CE`, and that table is reached only through `0x05A33E`, which has no caller. So the
DSP must volunteer `0x9F` after its reset is released. If it does not, a watchdog power-cycles it
up to 5 times (§2.3, §3.6).

On the mission questions:

- **Normal mode carries no audio at all.** Nothing crosses the link except control frames, decoded
  frame-header bits and 20/80-byte data-channel blocks (callsigns, IDs, text, data streams). Speech
  is encoded and decoded inside the DSP, behind analog paths.
- **One mode, `0xFF8DDE ≠ 0`, also relays vocoder codec bits.** This is a host-link mode on the
  SCI-A port. The bits travel as 9, 13 or 18 bytes per 20 ms voice slot: opcodes `0x0C`/`0x0D`/`0x0E`
  out and `0xAC`/`0xAD`/`0xAE` in. That is at most 90 bytes per 100 ms, about 7.2 kbit/s, of
  already-compressed speech.
- **No raw samples or IQ cross the link.** No frame anywhere carries PCM, raw samples or IQ, and the
  link cannot carry them at a useful rate.

## Method

- `h15_dump.py` was run on `H15_MAIN` over these ranges:
  - `0x048300`–`0x048420`;
  - `0x055FF0`–`0x058E80`, covering the driver, the ISRs, the receive assembler and the RX state
    handlers;
  - `0x058E80`–`0x05A480`, the builders;
  - `0x05A47E`–`0x05AE1C`, the trace formatters;
  - `0x05AF70`–`0x05C900`, the init and session scripts;
  - `0x05E9E0`–`0x05EC60`;
  - `0x06B700`–`0x06C920` and `0x06CC00`–`0x06CD40`, the host-link codec relay;
  - small windows at `0x2484`, `0x2A00`, `0x32F0`, `0x3560`, `0x9D00`, `0xE4F0` and `0x10540`.
- The H8SX seed decoded all of these ranges natively. No force-decode was needed.
- Python byte scans were run over the whole 1 MB image. They covered every `@aa:16`, `@aa:32` and
  `mov.l #imm` access to `0xFFB13E`, `0xFFB13A`, `0xFFB0B6`, `0xFFB0DC`, `0xFF8DDE`, `0xFFB0DA`,
  `0xFFB0B5`, `0xFFB0BE`, the timer bytes `0xFF9552`/`54`/`96`, and the codec buffers `0xFEE944`,
  `0xFEEAAC`/`B0`/`B4`, `0xFEE900`, `0xFF0BFC`, `0xFF95F8` and `0xFEF920`.
- BE32 pointer and `jsr`/`jmp @aa:24` scans were run for `0x05A33E`, `0x05A376`, `0x05A1BE`,
  `0x058FFE`, `0x05901E` and `0x05903E`.
- Not covered:
  - the 28 RX-state handlers `0x056EE4`–`0x057F1A` were read in sample only, not each field;
  - the session scripts were mapped as tables, but not every step was decoded;
  - the tick period is inferred, not proven (§2.2).

## Findings

### 1. Hardware the driver touches (Confirmed unless marked)

| Register | Use in the normal driver | Evidence |
| --- | --- | --- |
| SCI-C `0xFFFF88` SMR | `0x80`, clocked synchronous | `0x05653C 3c 88` |
| `0xFFFF89` BRR | `0x00` (external clock) | `0x056540` |
| `0xFFFF8A` SCR | `0x02`, then `0x12` (+RIE) to receive; `0x22` to transmit; bit 7 TIE starts the DMA | `0x05652C`, `0x056548`, `0x056706`, `0x0483CA` |
| `0xFFFF8B` TDR | DMAC ch1 destination | `0x048366` |
| `0xFFFF8C` SSR | `&0x87` clear; bit 5 overrun → discard path | `0x05616A`, `0x056196` |
| `0xFFFF8D` RDR | read by ISR | `0x056172` |
| DMAC ch1 `0xFFFC20`/`24`/`2C`/`34`/`38`, activation `0xFFFD21 = 0x96` | DSP transmit only | `0x04835A`–`0x0483C0` |
| DMAC ch0 `0xFFFC00`…, `0xFFFD20 = 0xE1` | **not the DSP**: SCI-D (MAIN→SUB). Its end ISR clears `0xFFF612` TIE. This corrects doc 06's "ch0 = DSP receive channel"; DSP receive is interrupt-per-byte | `0x048300`–`0x048324`, `0x04832C` |
| P3DR `0xFFFF52` | b0 DSP enable; b2 second enable (set at power-up, cleared only at shutdown); b3 reset, high pulse; b1 TX/RX handshake (0 just before DMA TX, 1 when switching to receive); b4 untouched here except the clear at shutdown | `0x056498`, `0x05650A`, `0x05650E`, `0x056526`, `0x0483C6`, `0x05674C`, `0x05606C` |
| IRQ2 (vector 66, `0x000108` → `0x0561C2`) | DSP handshake line. ISCR `0xFFFD6A` bits 5:4 are toggled every edge, so both edges interrupt; the level is latched in `0xFFB0A2` b7; enabled via IER `0xFFFF34` bit 2, flag ISR `0xFFFF36` bit 2 | `0x0561C4`–`0x0561DC`, `0x0564BE`–`0x0564F4` |
| `0xFFFB90` b2, `0xFFFB91` b4/b5 | port direction for the line and the SCI-C pins (Inferred from the DDR range) | `0x0564CE`, `0x05652E` |
| `0xFFFBA4` b2 | toggled around each frame. Unidentified port-control register | `0x056500`, `0x05676C`, `0x056614` |
| TMR `0xFFFEE0`/`E5`/`E6`; TPU `0xFFFFF5`/`F6` | TX-turn timeout (`< 0x7D00`); 3-second receive timeout (`cmp.w #0x8980`) | `0x0561F6`, `0x0565FA` |

### 2. Initialisation and power-on

#### 2.1 Power state machine (`0xFFB0A6`, table `0x05645C`)

Table bytes: `00 05 64 90 | 00 05 64 fa | 00 05 65 20 | 00 05 65 bc | 00 05 65 be`. State 4
(running) is not dispatched (`0x0562A2 cmp #4 ; beq`). State 3 is "failed".

```c
/* 0x056490 */ void pwr_s0_enable(void) {
    B0B2 = 0; irq2_setup();                 /* 0x0564B2 */
    P3DR |= 0x01;                           /* DSP enable */
    T9552 = 10; B0A6 = 1; FF0206 = 0xFF;
}
/* 0x0564B2 */ void irq2_setup(void) {
    B0A2 = 0x80;
    ISCR = (ISCR & 0xFFC0) | 0x10;          /* IRQ2 edge select */
    PxDDR_FB90 |= 0x04; nop3();
    IER |= 1<<2; nop3();                    /* 0xFFFF34 word, bit 2 */
    ISR &= ~(1<<2);                         /* 0xFFFF36 */
}
/* 0x0564FA */ void pwr_s1_assert(void) {
    if (T9552) return;
    FBA4 |= 0x04;
    P3DR |= 0x02; P3DR |= 0x04; P3DR |= 0x08;   /* b3 = reset asserted */
    T9552 = 3; B0A6 = 2;
}
/* 0x056520 */ void pwr_s2_release_and_init_sci(void) {
    if (T9552) return;
    P3DR &= ~0x08;                          /* release reset */
    SCR_C = 0x02;                           /* CKE1: external clock */
    PxDDR_FB91 |= 0x30;
    SMR_C = 0x80; BRR_C = 0x00;             /* clocked sync, slave */
    (void)SSR_C; SSR_C = 0;
    SCR_C = 0x12; nop3(); SCR_C |= 0x40;    /* RE | CKE1, then RIE */
    B0C2 = 1;                               /* trace "DSP POWER:ON & RESET!" */
    T9596 = 0x1E; T9596 = 0x78;             /* version watchdog (second store wins) */
    B0A6 = 4; B0A7 = 1;
}
```

#### 2.2 Timings

- Timer bytes `0xFF9536`–`0xFF958D` count down in the scheduler at `0x003586`. This tier contains
  `0xFF9552`, `0xFF9554` and `0xFF9558`. It ticks whenever the down-counter `0xFF94B8` has reached
  0; the counter is reloaded with 2 at `0x00357C`.
- Bytes `0xFF958E`–`0xFF95B1` count down every 10th such pass (`0xFF9534` reload 10, `0x0035D0`).
  This tier contains `0xFF9596`.
- `0xFF94B8` itself is decremented by the vector-110 ISR `0x002A30`. That ISR acknowledges
  `0xFFFEF5` b0. The same timer block is programmed at `0x002484`: `0xFEF0=0x21`, `0xFEF1=0xC0`,
  `0xFEF4=0x41`, compare word `0xFEF8=0x4E20`.
- **Inferred:** at φ = 16 MHz (doc 05) and φ/8, a compare of 20000 gives a 10 ms ISR, so the fast
  tier runs every 20 ms and the slow tier every 200 ms. The clock-select decode is not proven.

On that assumption:

| Step | Value | Time |
| --- | --- | --- |
| Enable (b0) to reset assert (b1, b2, b3 set) | 10 | ≈ 200 ms |
| Reset pulse (b3 high) | 3 | ≈ 60 ms |
| Version watchdog `0xFF9596` | `0x78` = 120 | ≈ 24 s |

After 5 tries (`0xFFB0B4 = 5`, set in `0x056046`) the driver gives up.

#### 2.3 Version watchdog and retries

```c
/* 0x056574 */ void dsp_version_watchdog(void) {     /* called only while B0A4.bit1 == 0 */
    if (B0A6 < 4 || T9596) return;
    dsp_power_off();                                 /* 0x056056 */
    if (--B0B4) { B0C2 = 2; return; }                /* "TIME OUT:3sec!" trace; tick restarts at state 0 */
    B0C2 = 3; B0A4 |= 0x01; B0A6 = 3;                /* "DSP?" - give up */
    if (A9F9 == 3) F817E |= 0x02;
}
```

### 3. The link: one frame per turn

#### 3.1 Flag bytes

- `0xFFB0A4` (Confirmed from all writers):
  - b0 failed;
  - b1 version known;
  - b2 init script done;
  - b3 ACK/NAK frame owed;
  - b4 NAK received;
  - b5 ACK received;
  - b6 command awaiting reply;
  - b7 link ready for a new command.
- `0xFFB0B2`: b7 command frame queued, b6 ACK/NAK frame queued.
- `0xFFB0A2`: b7 DSP line level, b0 line-edge event.

#### 3.2 ISRs and DMA

```c
/* vector 148/149, 0x05615C */
void isr_scic_rx(void) {
    if (F813A) { bridge_rx_0x07711E(); return; }   /* edge into the closed module, boot-strap only */
    uint8_t s = SSR_C;
    if (s & 0x20) { SSR_C = s & 0xC7; if (s & 0x40) (void)RDR_C; return; }  /* overrun etc. */
    SSR_C = s & 0x87;
    *rx_wptr++ = RDR_C;                              /* 0xFF815E */
    if ((uint16_t)rx_wptr >= 0x27C8) rx_wptr = (uint8_t*)0xFF23C8;  /* 1 KB ring */
}

/* vector 66, 0x0561C2: DSP handshake line, both edges */
void isr_irq2(void) {
    ISR &= ~(1<<2);
    ISCR ^= 0x30;                                    /* flip edge sense */
    B0A2 = (B0A2 & 0x7F) | ((ISCR & 0x10) << 3);     /* bld #4 / bst #7 */
    if (B0A2 & 0x80) {                               /* bcs at 0x0561E2 */
        if (B0A7 == 3 || B0A7 == 5 || B0A7 == 7) B0A2 |= 0x01;
    } else {
        /* turn timeout on TMR 0xFFFEE5/0xFFFEE6 */
        B12C = (TMR_E5 & 0x10) == 0 && TMR_E6 < 0x7D00 ? 1 : 0;   /* simplified */
    }
}

/* 0x04834E */
void dsp_dma_tx(const uint8_t *f /* er5 */) {
    while (!(SSR_C & 0x80)) ;                        /* TDRE */
    DMAC1_CTL = 0x1A0; DMAC1_SAR = f; DMAC1_DAR = &TDR_C;
    uint8_t op = f[0];
    DMAC1_CNT = (op == 0x19 || op == 0x16 || op == 0x15 ||
                 (F8DDE && op >= 0x0C && op < 0x0F)) ? 0x60 : 0x20;
    DMAC1_X38 = 0x200000; DMAC_ACT1 = 0x96;          /* request = SCI-C TXI */
    DMAC1_CTL = 0x800001A0;
    P3DR &= ~0x02;                                   /* strobe low: MAIN talking */
    SCR_C |= 0x80;                                   /* TIE -> DMA runs */
}
/* vector 129, 0x0483D2 */ void isr_dmac1_end(void) { SCR_C &= ~0x80; DMAC1_CTL &= ~1; BC8C = 0; }
/* vector 150, 0x0483D0 */ void isr_scic_txi(void) { }   /* rte */
```

#### 3.3 Link state machine (`0xFFB0A7`, table `0x056470`)

Table: `565C0 565C0 566C2 566C4 566E4 56732 5678E 567DC`.

```c
/* 0x0565C0, states 0/1 */
void link_idle(void) {
    B0A4 &= ~0x80;
    if (!(B0A2 & 0x80)) {                            /* DSP line idle */
        B12C = 0; /* clear TPU timeout bookkeeping */ link_abort_0x0565EE(); return;
    }
    uint8_t next;
    if (B0B2 & 0x40)      next = 6;                  /* ACK/NAK owed */
    else if (B0B2 & 0x80) next = 4;                  /* command queued */
    else { if ((B0A4 & 0x02) && !(B0A4 & 0x40)) B0A4 |= 0x80; return; }  /* ready */
    /* reset TMR 0xFFFEE0/E6, arm turn timeout */
    if (B0A2 & 0x80) B0A7 = next;
}
/* 0x0566E4, state 4 */ void link_tx_cmd(void) {
    if (B0A2 & 0x80) return;
    if (B12C) { B12C = 0; link_abort_0x0565EE(); return; }
    SSR_C &= 0x87; SCR_C = 0x22;                     /* TE | CKE1 */
    BC8C = 1; dsp_dma_tx(*(uint8_t**)0xFFB13A);
    while (BC8C) ;                                   /* spin until DMA end ISR */
    B0C2 = 7; B0A7 = 5; B0A2 &= ~1;
}
/* 0x056732, state 5 */ void link_to_rx(void) {
    if (!(B0A2 & 0x80) && !(B0A2 & 1)) return;  B0A2 &= ~1;
    B0B2 &= ~0x80; P3DR |= 0x02;
    SSR_C &= 0x87; SCR_C = 0x12; nop3(); SCR_C |= 0x40;
    B0A7 = 1; FBA4 |= 0x04; /* restart 3 s TPU timeout (0xFFFFF0/F6, 0xFFBC b3) */
}
/* 0x05678E, state 6: as state 4 but frame 0xFFB1A0, trace 8, next 7 */
/* 0x0567DC, state 7: B0A4 &= ~0x08; B0B2 &= ~0x40; then as state 5 */
```

#### 3.4 Receive assembler: frame parse and dispatch

```c
/* 0x05683E: called once per tick */
void dsp_rx_assemble(void) {
    uint8_t b;
    if (!B0B3) {                                     /* hunting for a start byte */
        if (!ring_get(&b)) return;
        if (!(B0A4 & 0x02) && b != 0x9F) return;     /* before version: only 0x9F */
        if (b < 0x86 || b >= 0xBC) return;
        if (b == 0xAB) { B115 |= 1; T957C = 0x19; }
        if (b == 0xBB) { B115 |= 2; T958D = 0x19; }
        B0DE = 0; B0DB = 0; rx[B0DE++] = b; B0DB += b;
        B0DA = 0x1F; B0B3 = 1; return;               /* 31 more bytes: frame is 32 */
    }
    while (ring_get(&b)) {
        if (--B0DA) { rx[B0DE++] = b; B0DB += b; continue; }
        /* last byte = checksum */
        B0A2 &= ~1; P3DR |= 0x02; FBA4 |= 0x04; /* restart timeout */
        uint8_t sum = B0DB; rx[B0DE++] = b; B0DB += b;
        if (sum != b) { build_nak(); reset_rx_callsigns(); goto done; }
        if (F8DDE) {
            if (rx[0] == 0x9A) { B3D5 |= 1; goto done; }        /* PDN pacing */
            if (pdn_rx_codec_0x06C402()) goto done;              /* 0xAC..0xAE */
        }
        switch (rx[0]) {
        case 0x9F: B0DC = (rx[1] << 8) | rx[2];                  /* 0x056A0C */
                   if (!B0DC) { build_nak(); reset_rx_callsigns(); goto done; }
                   if (A9F9 == 3 && !(B0A4 & 2)) F817E |= 2;
                   B0A4 |= 0x02; B12D |= 0x02;
                   if (B0A4 & 0x40) { B0A4 &= ~0x40; goto done; } /* it was a reply */
                   B0A8 = 1; build_ack(); dsp_rx_frame(); goto done;
        case 0xA0: B0A4 = (B0A4 & ~0x40) | 0x20; goto done;      /* ACK */
        case 0x90: B0A4 = (B0A4 & ~0x40) | 0x10; goto done;      /* NAK */
        case 0x9C: B12D |= 0x01; break;                          /* DATA TEXT SET */
        case 0x9E: B12D |= 0x80; break;                          /* TERM TX */
        }
        if ((rx[0] >= 0xA6 && rx[0] < 0xAC) || (rx[0] >= 0xB6 && rx[0] < 0xBC))
            dsp_rx_frame();                                      /* streamed: no ACK */
        else { build_ack(); dsp_rx_frame(); }
    done:
        B0C2 = 4; B0B3 = 0; return;
    }
}
/* 0x056A94 */ void dsp_rx_frame(void) {
    uint8_t op = rx[0], hi = rx[1] & 0xC0, dt = rx[3] & 3;
    /* gating on 0xFF8EA0 (sub_5D9E6 / 0x05DA00) and the header-repeat counter 0xFFB0C5 */
    /* then: */ rx_state_handlers_0x056B8A[B102](op, hi, dt);   /* 28 handlers */
}
```

The RX state handlers copy payload as follows (Confirmed, sample):

- `0xA6`/`0xB6`: 26 bytes `rx[1..26]` → `0xFEF920` (`0x057130`).
- `0xB7`: 20 bytes `rx[7..26]` → `0xFEF93A` (`0x057312`).
- Other states copy 20 bytes into `0xFEF926` / `0xFEF93A` / `0xFEF94E`, which are three 20-byte
  slots.
- With `0xFF8DDE ≠ 0` a header copy also goes to the host link (`jsr 0x06C200`, tags `'1'`/`'2'`).

The handlers read `rx[1]` bits 5:4 as a frame kind (`== 2` gates at `0x056F10`), bits 3:2 as a
sub-kind, and `rx[3]` bits 1:0 as a data type. That layout matches the C4FM FICH fields FI, CM and
DT (**Inferred** by structure).

#### 3.5 Transmit: builders, frame finish, ACK/NAK

```c
/* 0x058FA2: every builder ends here */
void frame_finish(void) {
    B0A4 &= ~0x30;
    uint8_t op = txb[0];                              /* 0xFFB13E */
    int words = (op == 0x19 || op == 0x16 || op == 0x15 ||
                 (F8DDE && op >= 0x0C && op < 0x0F)) ? 0x2F : 0x0F;
    uint8_t s = 0; uint8_t *p = txb;
    while (words--) { s += p[0]; s += p[1]; p += 2; }
    s += *p++; *p = s;                                /* checksum at [31] or [95] */
    *(uint8_t**)0xFFB13A = txb;
    B0A4 |= 0x40; B0B2 |= 0x80;
}
/* 0x058F86 / 0x058F94: canned ROM frames */
void send_canned(const uint8_t *rom) { *(const uint8_t**)0xFFB13A = rom; B0A4 |= 0x40; B0B2 |= 0x80; }
/* 0x058F2A ACK / 0x058EE6 NAK */
void build_acknak(uint8_t code /*0x20|0x10*/) {
    memset(ackb, 0, 32);                              /* 0xFFB1A0 */
    ackb[0] = code; ackb[1] = rx[0]; ackb[31] = code + rx[0];
    B0A4 |= 0x08; B0B2 |= 0x40;
}
/* 0x059E66 / 0x059EB6 / 0x059D94 / 0x059E16: two-byte commands */
void build2(uint8_t op, uint8_t arg) {
    memset(txb, 0, 32); txb[0] = op; txb[1] = arg; frame_finish();
}   /* 1D 01 MUTE ON, 1D 00 MUTE OFF, 1A 00 RX ENABLE, 1A 01 RX DISABLE */
/* 0x059F40 DTMF: digit = B0C0-1; send 0B 00 (0x80|d), later 0x059FE0 sends 0B 01 (0x80|d) */
/* 0x05A0B4 / 0x05A0C0 */
void build_15(uint8_t sub, uint8_t n, const uint8_t *ram) {   /* (0x01,18,0xFF4576) | (0x11,6,0xFF4696) */
    memset(txb, 0, 96); txb[0] = 0x15; txb[1] = sub;
    uint8_t *d = &txb[2];
    while (n--) { const uint8_t *s = (*ram == 0xFF) ? (const uint8_t*)0x4C14 : ram;
                  memcpy(d, s, 5); d += 5; ram += 0x10; }
    frame_finish();
}
```

The 32/96-byte header and data builders `0x0594FA` and `0x059680` clear the frame and write the
opcode. They then write `[1]` = `0x20 | mode(4 or 0xC) | blk_hi`, `[2]` = `blk_lo << 3`,
`[3]` = DT (`0xFFB121`, 0–3 from `0xFFB11E`), and `[4]`..`[6]` = squelch/ID fields
(`0x0598FE`–`0x05990E`).

Payload layout:

| Opcode | Payload |
| --- | --- |
| `0x16` | 10 + 10 + 20 + 15 + 5 bytes of callsign/ID text from `0xFFA8DA` (own callsign), `0xFFB1E3`, `0xFF01CA`, `0xFF8060` (5-byte ID); or a 60-byte block from `0xFF0BFC` |
| `0x07` / `0x08` | one 20-byte sub-block each |
| `0x09` / `0x19` | the next 20 / up to 80 bytes of a block pointed to by `0xFFB128`, with `0xFFB126` remaining |

Opcode `0x11` (`0x05905E`) packs about 20 setting bytes `0xFF8E20`–`0xFF8E36` plus 12 ROM bytes
(`0x00F9A8` = `39 2a 2a 00 28 04 30 60 3f 6f 19 19`). Opcode `0x32` packs `0xFF8AA0`, `0xFF8ABD`
and `0xFFAA35` b7. Opcode `0x31` is constant: `31 00 30 44 40 A0 A0`.

#### 3.6 Scheduler tick, init script and session scripts

```c
/* 0x056272 (from the scheduler 0x0030B8) and 0x056236 (8 scheduler sites) */
void dsp_tick(void) {
    B0CD = 1;
    if (/* mode gates on 0xFF8D20, 0xFF94C0, 0xFF8EA0, 0xFF8DD5 */ 0) return;
    if (B0A6 != 4) pwr_table_0x05645C[B0A6]();
    link_table_0x056470[B0A7]();
    dsp_rx_assemble();
    if (!(B0A4 & 0x02)) { dsp_version_watchdog(); if (!B0CD) goto trace; }
    else if (!B0CD) { B0CD = 1; if (P3DR & 1) dsp_shutdown(); return; }   /* 0x056450 */
    if (!(B0A4 & 0x04)) dsp_init_script();                               /* 0x05AF70 */
    else { /* B0C9 / B0AB / B0AC / B0CE request bits -> 0x05B184, 0x05B210, 0x05B254, 0x05B28C, 0x05B2D8 */
           if (BB94) tbl_0x05EBD2[B0BF]();                               /* PDN scripts */
           else { if (B0BD) { B0BF = 0; B0BD = 0; sub_5C50C(); }
                  if (B0BE) session_tbl_0x05B310[B0BE](); } }
trace: if ((F8C26 & 0x80) && (F8C28 == 3 || F8C28 == 4 || F8C28 == 5) && B0C2) print_trace(B0C2);
}
```

The init script is driven by `0xFFB0A9`, table `0x05AF92`. Each "send" step runs only when
`B0A4.b7` is set and `b3` is clear. Each "wait" step advances on `B0A4 & 0x30` (ACK or NAK).

| Step | Action |
| --- | --- |
| 0 | wait for `B0A8` (set by the unsolicited `0x9F`), then `0x11` |
| 2 | `0x12` |
| 4 | `0x31` |
| 6 | `0x32` |
| 8 | if `B0DC ≥ 0x041E`, `0x15`/`0x01`; otherwise skip 4 |
| 10 | `0x15`/`0x11` |
| 12 | `0x16` (own block; `0xFF0BF6 = 0x24` if PDN) |
| 13 | after the last ACK, set `B0A4 |= 0x04` and `B0A9 = 0` |

The session scripts are selected by the UI through `0x05A1BE`, `0x05A28A` and `0x05A2F8`, whose
callers are `0x03596A`, `0x035EEE`, `0x0359A8`, `0x035F28`, `0x05F73A`, `0x06CA8E` and others.
These set `0xFFB0B5 = 1` and `0xFFB0BE` to a script code (`0x02`, `0x0A`, `0x0B`, `0x10`, `0x15`).
Table `0x05B310` maps `B0BE` to script bodies (`0x05B442`, `0x05BCCE`, `0x05BD92`, `0x05BFA6`,
`0x05C352`, `0x05C3F4`, `0x05C048`, `0x05C18E`). Each is a step table on `0xFFB0BF`, made of
`0x12`, `0x1A`, `0x16`/`0x07`/`0x08`, `0x09`/`0x19`, `0x1D`, `0x0B`, `0x18` and `0x1C` steps. The
DSP version gates `0x12` variants at `0x05B4E4`/`0x05B52A` (`cmp.w #0x106`).

**Dead path (Confirmed by scans).** `0x05A376` dispatches through the 44-entry builder table
`0x05A3CE` only when `0xFFB0B5 == 0`. Every writer of `0xFFB0B5` stores 1 (`0x05A210`, `0x05A226`,
`0x05A23C`, `0x05A2E4`, `0x05A32A`). The only fall-in without a store is `0x05A33E`, and it has no
code xref, no BE32 pointer and no `jsr`/`jmp @aa:24` in the whole image. So these are unreachable
in ver 1.02:

- the canned `VER?` frame `0x05901E` (`1F 02 … 21`);
- the `0x06` builder `0x059A6E`;
- the 32 per-digit DTMF stubs `0x059F00`–`0x059FDC`.

A third canned frame at `0x058FFE` (`1F 01 00×29 20`) has no reference at all.

**Correction to doc 06.** Doc 06 says `0x059BBA` builds `1F 00`. It actually builds opcode `0x07`
(`f9 07 5e 05 94 fa`).

### 4. The DSP version word `0xFFB0DC` (Confirmed)

- **Single writer:** `0x056A0C 6b 84 b0 dc`, storing `(rx[1] << 8) | rx[2]` of a `0x9F` frame
  (`0x056A04 6a 04 b0 e1`, `0x056A08 6a 0c b0 e2`).
- **Readers:** `0x05B0CC`, `0x05B1A2`, `0x05B4E4` and `0x05B52A` (gates `0x041E` and `0x0106`).
- **Routes to SUB:**
  - `0x074346` sends IPC message `0x5A` (doc 06).
  - `0x009D62` copies the word into IPC frame `0xF31B` at `+0x27`/`+0x28` (`0xFF3D9B`), which doc
    44 traced to the SOFTWARE VERSION screen as `hi.lo`.
- **Not queried:** the query path is dead (§3.6). Before the version is known the assembler drops
  every start byte except `0x9F` (`0x05686C`–`0x056876`). The value therefore comes from a `0x9F`
  frame the DSP sends on its own after reset release (**Inferred**: no live `VER?` sender exists,
  yet the init script waits for `B0A8`, which only the `0x9F` path sets).
- If no `0x9F` arrives, the watchdog power-cycles the DSP, up to 5 times.

### 5. Host-link codec relay, `0xFF8DDE ≠ 0` (Confirmed mechanics, Inferred naming)

`0xFF8DDE` is set at `0x010580` from `r4h` = `0xFF` (entry `0x01054A`) or 1 (entry `0x010556`). It
is cleared at `0x0105B6` and `0x00E516`. The same path re-initialises SCI-A (`jsr 0x045186` at
`0x0105A6`).

The host packets are ASCII-hex. `0x06CC76` sums the packet and appends two hex digits, and the
packet is sent from `0xFEE000` by DMA ch2 to SCI-A `TDR 0xFFFE93` (`0x06B92E`–`0x06B97E`). Host
command letters `B C F E S N W` are parsed at `0x06BAD6` from `0xFF1AC9`. ROM ID strings at
`0x06C538` (`\x01V0030FT3D … 20180418 … 0C01`) and `0x06C570` (`\x01V0020FT2D  JPN Ver0202`) look
like WIRES-X node identification, so this is **Inferred** to be the portable-digital-node mode.

**DSP → host (`0x06C402`, only from `0x05699E`):**

- Accepts `0xAC`–`0xAE` with `rx[3] & 3` = DT ≠ 1.
- Copies `rx[7…]` as 9 bytes (DT 0), 13 bytes (DT 2) or 18 bytes (DT 3) into `0xFEEAB8 + n·len`.
- After 5 frames it moves 45, 65 or 90 bytes to `0xFEE944` and sets `0xFFB3D7` b6.
- `0x06C344` then ASCII-hexes the block into `0xFEE000` behind a 7-byte ROM header
  (`0x06C5D0` = `01 48 30 30 31 45 01 …`).

**Host → DSP (`0x06C850`):**

- Takes host packet `'E'`. Fields `0xFF1ACE`–`0xFF1AD5` are hex-decoded into a 4-slot ring
  (`0xFEE944 + slot·len`, DT at `0xFEEAAC[slot]`, bytes at `0xFEEAB0`/`B4`).
- `0x05BA22` sends one 96-byte frame per DSP `0x9A` request. Opcode comes from `0x05BBD2[DT]` =
  `0C 00 0D 0E`; payload length from `0x05BBD6[DT]` = `2D 00 41 5A`. The frame is
  `op, FEEAB0[s], FEEAB4[s], payload…`.

The voice-slot sizes are 72, 104 and 144 bits per 20 ms slot, five slots per frame. These match the
C4FM V/D-mode-1, V/D-mode-2 and Voice-FR voice channels, so the payload is **vocoder bits**
(**Inferred** from the sizes and DT values; the codec is not named in the image).

### 6. Data path summary

| Direction | Normal mode | Host-link mode (`0xFF8DDE`) |
| --- | --- | --- |
| MAIN → DSP | config `0x11`/`0x12`/`0x31`/`0x32`/`0x15`; control `0x1A`/`0x1D`/`0x18`/`0x0B`/`0x1C`; header and data-channel text `0x16`/`0x07`/`0x08`; data stream `0x09`/`0x19` (≤ 80 B per frame) | plus `0x0C`/`0x0D`/`0x0E`: 45/65/90 B of codec bits per frame |
| DSP → MAIN | ACK/NAK, version `0x9F`, events `0x9C`/`0x9E`, decoded header and data-channel blocks `0xA6`–`0xAB`/`0xB6`–`0xBB` (≤ 26 B per frame, one 32-byte frame per turn) | plus `0xAC`–`0xAE`: 9/13/18 B codec bits per frame, and `0x9A` pacing |

There is no PCM and no sample buffer anywhere on this path. The receive side is a 1 KB byte ring
fed one interrupt per byte, and it holds only 32-byte frames.

The link is half-duplex and strictly one frame per turn. The CPU even spins waiting for DMA end
(`0x056718`). The densest payload in either mode is 90 B per ~100 ms, about 7.2 kbit/s.

## USB relevance

- **Q1 (USB).** The normal driver never touches USB (`0xFFEE00`–`0xFFEE53`) and never touches the
  closed module, except for the boot-strap bridge branch `0x0561B0 → 0x07711E`. The only host relay
  of DSP traffic in normal operation is the `0xFF8DDE` mode, and it runs on **SCI-A** (DMA ch2,
  `0xFFFE93`), not USB.
- **Q2 (USB SDR).** **No, at this link.**
  - Sample source: absent. The DSP returns only decoded frame fields and, in host-link mode,
    compressed vocoder bits.
  - Transport: a half-duplex 32/96-byte frame exchange, at most about 7.2 kbit/s of payload.
  - Firmware: no frame type carries raw or IQ samples. The receive ISR/ring and the 26-byte RX
    payload slots cannot hold a sample stream.

  The missing link is the sample source *behind* the DSP. Nothing in MAIN's interface to it asks for
  or accepts samples.
- **Q3 (DSP reachable).** In normal operation the DSP can be reached only through the fixed
  scripts. Every TX builder is fed from MAIN RAM settings or text, and the request entries are
  UI-only. The `0xFF8DDE` host-link mode is the one runtime path where external bytes, the host
  `'E'` packet on SCI-A, end up inside DSP frames. It is limited to opcodes `0x0C`/`0x0D`/`0x0E`,
  with the opcode chosen from a 4-entry table, so it is a codec-bit relay, not a generic DSP command
  path. The version comes only from the DSP's own `0x9F`.

## Open

1. Decode the 28 RX-state handlers (`0x056B8A` table, `0x056EE4`–`0x057F1A`) field by field,
   especially the header handlers' use of `0xFEF920`–`0xFEF961`, to finish the DSP→MAIN layouts.
2. Pin the tick: decode TMR `0xFFFEF0`/`F1`/`F4` (`0x21`/`0xC0`/`0x41`) against the H8SX/1668R
   manual to turn §2.2 into Confirmed milliseconds.
3. Decode each session script on `0xFFB0BF` (tables `0x05B458`, `0x05C1A4`, `0x05C0C8`, …) into
   named TX sequences, and map script codes `0x02`/`0x0A`/`0x0B`/`0x10`/`0x15` to UI actions via
   callers `0x03596A`, `0x0359A8`, `0x06CA8E`.
4. Confirm `0xFF8DDE` = WIRES-X portable digital node by tracing `0x01054A`/`0x010556` callers
   (mode code dispatch `0x0103C0`) and the `0x06BAD6` host command set.
5. Identify `0xFFFBA4`/`0xFFFBA5` and P3DR b2. Both are driven around DSP power and frames but are
   unnamed.
