# APRS / AX.25 on MAIN: FCS routine, packet path, automatic APRS transmissions

> Lane K8. Private DB `K8_APRS` (`ida\db\jobs\K8_APRS\K8_APRS.i64`), seeded with
> `--copy-from ida\db\jobs\J1_MAIN_FINAL3\J1_MAIN_FINAL3.i64` and iterated with `--reopen`.
> Job script `ida\jobs\k8_q.py` is a read-only query runner. Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin`, base 0, so file offset = address, big-endian; sha256
> `8e3ecd05409b2c31…`, re-checked after the work. No other database was opened, no image was
> modified, and nothing was connected to or sent to a radio. The closed window
> `0x078106`–`0x07B753` was not entered. Model: **claude-opus-5-5**.
>
> Tables and evidence are in `ida\out\aprs-ax25\`:
> - `fcs.c`: hand-reconstructed C for the FCS check (`sub_4986A`) and the HDLC transmit encoder (`sub_49494`), plus a self-test.
> - `fcs_test.py`: an independent Python port. It reads the image read-only to confirm the immediates.
> - `fcs_test_result.txt`: output of both tests (**ALL PASS**).
> - `aprs-rx-path.tsv`: the receive chain, step by step.
> - `aprs-tx-sources.tsv`: every APRS transmit source, with its trigger, gate, timing and status.
> - `aprs-tx-sequence.tsv`: the keying sequence from the request to the return to receive.
> - `k8-disasm-excerpts.txt`, `requests\*.json`: every raw disassembly dump this lane used, and the queries that produced them.
> - `usb-check.txt`: the scan for USB-register operands in the APRS routines.

## Verdict

**The AX.25 FCS is CRC-16/X.25, and it is Confirmed.** MAIN does all the AX.25/HDLC work in
software. On receive it runs a bit-level flag hunt, unstuffs the bits, checks the FCS
(`sub_4986A`, residue `0xF0B8`) and parses the frame as UI-only AX.25 and then APRS. On transmit
it computes the FCS, stuffs the bits and adds the closing flags (`sub_49494`). The code keeps
the CRC in a byte-swapped register, so the polynomial appears in the code as `mov.w #0x0884,e2`.
The earlier "0x8408 at `0x494AA`/`0x49894`" hits were those two bytes read little-endian.

The modem's far end is **SCI-B `0xFFFF60`** (38400 8N1). Doc 05 left SCI-B as an
"unidentified module". It carries raw, NRZI-decoded HDLC bits in both directions, and it is
switched on only when `FF8AA0` (F3A3, the APRS modem setting: 0 off, 1 = 1200, 2 = 9600) is
non-zero. Neither direction has an NRZI or AFSK step on MAIN.

**The radio transmits APRS on its own in four ways:**

1. the beacon timer (BEACON TX AUTO; interval table 30 s to 60 min, default 5 min);
2. SmartBeaconing, evaluated on every GPS `$GPRMC` fix;
3. message retransmission every 60 s until an `ack`/`rej` arrives;
4. an automatic `ack` 3 s after any received message that is addressed to the radio and carries
   a message number. **No setting turns this off except the APRS modem itself.**

An auto-reply path exists and can be armed (`FF8CFA`), but its sender task `0x054AC0` has
**no caller anywhere**. There is no digipeater: no code copies a received frame into the
transmit buffer.

All four sources key the radio through the ordinary TX state machine (`FFAACF = 1` →
`FFAAD5` states 13 → 14 → 1 → 2), the same one J9 traced from the PTT. They do not go through
J9's DSP session dispatcher `sub_35872`. Instead the APRS sender `sub_4927A` asks the DSP to
change mode, writes the synthesizer/RF latch itself (`sub_3490`), and pushes the bit stream out
SCI-B. **This corrects J9's "only PTT and SCI-A key the radio":** that list counted DSP voice
and data sessions only.

## Method

- Seeded the DB from `J1_MAIN_FINAL3` and ran 25 `--reopen` query passes with `k8_q.py`. It
  produces function dumps, IDA cross-references, upward caller walks, and operand-text scans
  over every recovered function in `0x000000`–`0x078106`, with spot scans of `0x07B754`–`0x080000`.
- Covered:
  - all of `sub_48C44`, `sub_48FE0`, `sub_490C4`, `sub_49122`, `sub_4986A` and `sub_49494`;
  - the APRS state machine `sub_4927A` with all 8 states;
  - the SCI-B and SCI-A ISRs;
  - the TX state machine `sub_34538`, `sub_34966`, `sub_34CCE`, `sub_34D42`, `sub_34782` and `sub_378A2`;
  - the request functions `sub_22ACC`, `sub_22C44`, `sub_22CA0`, `sub_22CF4`, `sub_22D76`, `sub_22DB8` and `sub_2244C`;
  - the periodic tasks `sub_545AC`, `sub_5469C`, `sub_548BE` and `0x054AC0`;
  - SmartBeaconing `sub_4477E`, `sub_44960` and `sub_449C0`;
  - the frame builders `sub_495A2`, `sub_50E1E`, `sub_50E82`, `sub_51094`, `sub_51108` and `sub_51148`;
  - the parsers `sub_518AE`, `sub_5017C`, `sub_4A3E2`, `sub_4A47C` and `sub_4A5C8`.
- Operand-text census of the writers and readers of `FFA4F0`, `FFA4F1`, `FFAAD3`, `FFAACF`,
  `FFA330`, `FFA332`, `FFA1B6`, `FF814A`/`FF814E`, `FF95F8`, `FFB0D2`/`D4`, `0xFFFF4D`, the beacon
  timers and the setting bytes (`k8-disasm-excerpts.txt`).
- Whole-image byte search for 32-bit pointers to `0x054AC0`, `0x054ADE`, `0x054AE2` and `0x022CE0`.
- Settings cross-checked against `ida\out\settings\settings-bytes.tsv` and `default-init.txt`.
  Timer tiers are from doc 76 / doc 57: 10 ms for bytes `FF9536`–`8D` and words `FF95B2`–`CD`,
  100 ms for bytes `FF958E`–`B1`, and 1 s for words `FF95EA`–.
- FCS validated offline in two independent implementations, C (`gcc`) and Python.
- **Not covered:**
  - what the DSP does with the SCI-B bits and the `B0CE` requests (no DSP firmware in the package);
  - the SUB-side display of stations and messages;
  - the full per-DTI parsers below `sub_5017C`;
  - the menu-label mapping of the APRS setting bytes (the SUB F3xx→label decode is still open);
  - the initial retry count of a new message.

## Findings

### 1. FCS = CRC-16/X.25 (Confirmed, tested)

Receive check, `sub_4986A`:

```
04986A  6b 06 a3 2e        mov.w @FFA32E,r6        ; index after the closing flag
049874  6e eb a1 ae        mov.b r3l,@(FFA1AE+r6)  ; overwrite the closing flag with 0 ...
049878  6e eb a1 af        mov.b r3l,@(FFA1AF+r6)  ; ... and one more 0 (augmentation)
04988A  6b 02 a1 b6        mov.w @FFA1B6,r2        ; first two frame bytes
04988E  79 52 ff ff        xor.w #0xFFFF,r2        ; = init 0xFFFF
049892  79 0a 08 84        mov.w #0x0884,e2        ; poly, byte-swapped = 0x8408
049896  6c 5b              mov.b @er5+,r3l         ; 8x: shlr.b r3l / rotxr.b r2l / rotxr.b r2h / bcc / xor.w e2,r2
049904  79 22 b8 f0        cmp.w #0xB8F0,r2        ; swapped 0xF0B8 = X.25 good residue
049908  58 60 03 24        bne   loc_49C30         ; reject
```

The transmit side, `sub_49494`, uses the same register shape (`0x0494A8 79 0a 08 84`,
`0x0494B0 17 12 not.w r2`). It appends the FCS as `not.b r2h` (`0x04954A`) followed by
`not.b r2l` (`0x049556`), which puts the low byte on air first. Hand-written C for both routines
is in `fcs.c`. In outline:

```c
/* r2 holds the logical CRC with bytes swapped: logical = (r2l<<8)|r2h */
uint16_t rx_fcs_check(const uint8_t *f, size_t n) {   /* n includes 2 FCS bytes */
    r2h = ~f[0]; r2l = ~f[1];
    for (i = 2; i < n + 2; i++)                       /* +2 appended zero bytes */
        for (bit in LSB-first(f[i] or 0))
            { out = r2h & 1; r2 = (bit<<15 | logical>>1); if (out) r2 ^= 0x8408; }
    return r2;                                        /* firmware accepts iff 0xB8F0 */
}
```

Test results (`fcs_test_result.txt`):

- the catalogue CRC-16/X.25 of `"123456789"` is `0x906E`;
- the firmware-form encoder emits `6E 90`;
- the firmware RX check returns `0xB8F0` on that frame;
- on a 55-byte APRS UI frame (`APY03D` ← `N0CALL-7` via `WIDE1-1`) the reference FCS is
  `0xEA8F`, the firmware encoder produces the same bytes, and the payload round-trips through
  the bit-stuffed stream;
- a 1-bit corruption is rejected;
- 2000 random frames of 15–323 bytes, a seventh of them all-`0xFF` to stress the bit stuffing,
  give **0 mismatches**.

The image immediates `0x049892`, `0x0494A8` and `0x049904` were byte-checked by `fcs_test.py`.

### 2. Receive path (Confirmed; `aprs-rx-path.tsv`)

```
SCI-B RXI/ERI ISR sub_45520 (vec 152/153) -> ring FF1AC8..FF23C7, wptr FF814E
sub_2070 -> sub_30A2 -> sub_30CE6 -> sub_316B8: if FF8AA0 -> sub_48C44 (rptr FF814A)
  sub_48C44: per byte bit-reverse, LSB-first shift, 0x7E flag hunt, unstuff after 5 ones,
             abort on >=7 ones, reset while squelch closed ((0x90,er0)==2);
             frame -> FFA1B6.., accept 12..324 bytes (index 0x14..0x14C)
  sub_4986A: FCS (above) -> sub_518AE (UI only: ctl/PID 03F0 or 13F0; '}' 3rd-party)
          -> sub_5017C (DTI: ':' msg, 0x27/0x60 Mic-E, table 0x3CA2 = / @ ! = ; ) _ >)
          -> class table 0x3EC4 vs filter mask FF8AAE (default 0x3F)
          -> sub_49D72 duplicate filter, station store, sub_4558E $GPWPL to DATA jack
          -> ':' : addressee == own call FFA8D0? (sub_4A3E2) ; :ack/:rej (sub_4A47C)
                   ; sub_4A5C8 schedules ACK (+ auto-reply if FF8CFA)
```

The receive path has no NRZI step. The ring bytes go straight to the `0x7E` comparison after a
bit-order reversal, so whatever is at the far end of SCI-B has already NRZI-decoded the bits
(Confirmed for MAIN). In the other direction, `sub_49494` emits NRZ bits packed MSB-first, with
**no opening flag** and with 8 trailing-flag counts (32 at 9600, `FF9DDE`). The far end must
therefore supply the NRZI coding, the preamble/TXDELAY and the AFSK or GMSK modulation.

The far end is **Inferred to be the DSP's packet port**, for three reasons:

- the modem rate is told to the DSP: J9 decoded opcode `0x32` byte[1] as a packing of `FF8AA0`;
- every APRS transmission first asks the DSP for a mode change through `B0CE` b7/b6 and waits
  for its acknowledgement `B0CE` b5 (`0x05B2CA`);
- the transmit handshake runs on two port lines: `FFFBA4` b5 is the start strobe and `FFFF41` b1
  is the busy indication.

A separate modem chip is not excluded.

### 3. Transmit sender `sub_4927A` (Confirmed; `aprs-tx-sequence.tsv`)

```c
void aprs_tx_task(void) {                 /* sub_4927A, main loop 0x002CB8 */
    if (A4F0 & 0xC0) A4F1 = 0;            /* new request restarts */
    switch (A4F1) {                        /* table 0x0492B4 */
    case 0: if (FF8AA0 && (A4F0&0xC0)) {   /* sub_492D4 */
              B0CE |= 0xC0; B0CE &= ~0x20;           /* ask DSP (sub_5B28C->sub_59E16) */
              if (A4F0 & 0x40) { build_beacon(); AAD3 |= 2; } else AAD3 |= 8;
              A9E3 = (A9E3|0x88)&~3; A99D = 0; synth_latch_write();  /* sub_3490 */
              A4F1 = 1; } break;
    case 1: if ((B0CE&0x20) && (AAE1&0x80)) {          /* sub_49344: DSP acked */
              if (AA35&0x80) { B0CE|=8; T95A0=10; A4F1=6; }       /* alt path, Unknown */
              else { hdlc_encode(A332,A330 -> FF95F8); B0D2=n-1; B0D4=1; A4F1=2; } } break;
    case 2: if (SSR_B&TDRE) { TDR_B=FF95F8[0]; SCR_B|=TIE; A4F1=3; } break;
    case 3: if (!B0D2 && (SSR_B&TDRE)) { spin(1000); FBA4|=0x20; T95A0=10; A4F1=4; } break;
    case 4: if (P41&2) { T95A0=80; A4F1=5; } else if (!T95A0) { AAE0=0x1D; end(); } break;
    case 5: if (!(P41&2)) end(); else if (!T95A0) { AAE0=0x1D; end(); } break;
    /* 6,7: alt completion via B0CE b3 / FFFF4E b7 */
    }
    A4F0 &= ~0xC0;
}
end(): FBA4&=~0x20; A9E3=(A9E3|0x80)&~8; B0CE=(B0CE|0x80)&~0x60; sub_22718(); AAD3=0; A4F1=0;
```

The only writes to `FFA4F0` b6/b7 are at `0x034A5A`/`0x034A62` inside the TX state handler
`sub_34966`. They run after `FFAAD3` b0 (beacon) or b2 (message/ack) has steered an ordinary TX
request there. `sub_2244C` raises that request (`AACF = 1` at `0x02253C`). The request functions
are `sub_22ACC` (beacon) and `sub_22CF4`/`sub_22D76`/`sub_22DB8` (message, retry, ack).

`FF8C52` and `FF8C53` (ROM defaults `01`) only decide whether the ringer tone `'M'`/`'N'`
(`AAE0`) plays before keying (`0x0345B2`–`0x0345CC`). They do not gate transmission.

Only four frame builders write the transmit buffer `FFA332`/`FFA330`:

| Builder | Frame |
| --- | --- |
| `sub_495A2`/`0x0495DE` | Mic-E beacon: DTI byte `0x60`, destination from `sub_51148`, `"_0"` suffix, optional status text |
| `sub_50E1E` | message `:ADDRESSEE:text{NN` |
| `sub_51094` | `:ADDRESSEE:ackNN` |
| `sub_51108` | auto-reply `:ADDRESSEE:` + `FFADDE` text |

Messages use the destination `APY03D` (`0x04B18A`), built by `sub_50E82`.

### 4. Automatic transmissions (`aprs-tx-sources.tsv`)

| Source | Trigger | Gate (default) | Timing | Status |
| --- | --- | --- | --- | --- |
| Beacon AUTO | `sub_545AC` at main loop `0x002C10`. 1 s timer `FF95EC`. | `FF8AA0≠0` (default **0 = off**); `FFA90C==1`, which comes from `FF8AAB` b6 (default `0x04` → off); band/mode check `sub_54568` | `0x003FB0[FF8ABC]` = 30/60/120/180/300/600/900/1200/1800/3600 s, default index 4 = **300 s**. Busy channel (`sub_54630`): retry every 3 s. | Confirmed |
| SmartBeaconing | `sub_4477E` on each `$GPRMC` with status `A` | `FFA90C==2`, i.e. `FF8AAB` b1, `FF8BCC` type 1–3 (default **0**), and `FF8AB8==0` (GPS position) | Speed below low → slow_rate×60 s. Speed above high → fast_rate s. Between → fast×high/speed. Turn threshold = angle + 10·slope/speed, capped at 120°. Minimum turn time = turn_time s. ROM 3×7 presets at `0x00F8BA`. | Confirmed (parameter names Inferred) |
| Message retransmit | `sub_5469C` at `0x002C14` | slot `(0x1A)` b0, retry byte ≥ 2 | every 60 s (`0x1770` × 10 ms); busy → 3 s; stopped by `:ack`/`:rej` (`sub_4A4D0`) | Confirmed; initial count Unknown |
| Message ACK | `sub_4A5C8` on receive, then `sub_548BE` at `0x002C18` | **APRS on only, no ack setting** | 3.00 s after receipt (`FF95B8 = 0x12C`) | Confirmed |
| Auto-reply | `sub_4A5C8` sets b6 when `FF8CFA≠0` | `FF8CFA`, text `FFADDE` | would be 3 s | **Not reachable**: no xref or pointer to `0x054AC0`/`0x054ADE`/`0x054AE2` |
| Digipeat | — | — | — | **Not found** (all `FFA330` writers are builders) |

A beacon is never retransmitted. Each interval sends once, after waiting out any busy channel.

The beacon timer is armed through `FFA50E`:

- at configuration load by `sub_ED16` (`0x00EE92`);
- by the settings-apply routines (`0x017844`, `0x0179CE`, `0x017A8A`, `0x01C8F2`).

The first beacon goes out one interval after arming (`sub_545F6` loads the timer before the
first send).

### 5. The transmit gate at `0xFFFF4D` b3 (contradiction with J9, left open)

Every TX, APRS included, passes `sub_34966` `0x034984 btst #3,@0xFFFF4D:8 ; bne → stop` and the
state-2 test `0x034CCE`. A high level ends TX 40 ms later (`FF9568 = 4`, 10 ms tier). No APRS
code bypasses this test; only node mode (`FF8DDE` b7) does, at `0x03496A`. Automatic beacons
are clearly intended to work: a 1 s interval timer, SmartBeaconing, and no key involvement.
So during an automatic transmission this line must read 0 with no key held.

Either `0xFFFF4D` b3 is not simply the PTT button, or the hardware pulls it low when MAIN
asserts its TX outputs. A candidate is `FFFBA5` b7/b6, which `sub_378A2` sets at TX entry, with
b6 set for APRS. **The line's identity is Unknown from this package.** J9's "PTT (Inferred)"
should be read as "TX-gate input". The TX request itself is the `FFAACF = 1` event from
`sub_2244C`.

### 6. Corrections to earlier docs (owning docs not edited)

- **Doc 11, Open #2:** the AX.25 FCS is now **Confirmed** and tested. The `0x8408` hits were the
  byte-swapped `mov.w #0x0884` immediates. SCI-B, not the DATA-jack SCI, carries the APRS bits.
- **Doc 05 / doc 04:**
  - SCI-B `0xFFFF60` is the **APRS packet-modem link** (parser `sub_48C44` = HDLC deframer), not
    an unidentified module.
  - The "PC → module transparent bridge" reading is wrong. `FF95F8` is only time-shared between
    SCI-A's alternate receive ring (`FF817F` b7; consumers `sub_736E6`, `sub_7374A`, `sub_73930`)
    and the APRS transmit bit stream.
  - SCI-B's transmit count `FFB0D2` is written only at `0x049486` (`sub_49476`) and in the ISR.
- **Doc 77 (J9):**
  - **(a)** The key-up list is incomplete. APRS beacon, SmartBeaconing, message-retry and ACK
    transmissions key the radio through the TX state machine and `sub_4927A` without
    `sub_35872`.
  - **(b)** The `AAD4.b0`/session `0x0A` "APRS packet queued" label is wrong for APRS. APRS uses
    `AAD3` b0/b2 → `A4F0` b6/b7, and the `AAD4.b0` setters are all in the C4FM GM engines.
  - **(c)** `FF8AA0`/F3A3 is the APRS modem selector (0/1200/9600). It is evidenced by
    `sub_48B9A` (`9DDE = (FF8AA0 == 2)`, SCI-B on only when it is non-zero) and by 20+ APRS gates.
  - **(d)** For `0xFFFF4D` b3, see §5.
- **Settings labels (Inferred):**

  | Byte | Meaning |
  | --- | --- |
  | `FF8ABC` | beacon interval index |
  | `FF8AAB` b6/b1 | beacon TX AUTO/SMART |
  | `FF8BCC` | SmartBeaconing type plus 3×7 parameters |
  | `FF8AAE` | APRS filter mask |
  | `FF8CF8` | position ambiguity (0–4 digits) |
  | `FF8AB9`/`FF8ABA` | status text on / every Nth beacon |
  | `FF8AB8` | position source (0 = GPS) |
  | `FF8C42`…`55` | per-type ringer flags |
  | `FF8CFA` | auto-reply enable (vestigial) |
  | `FF8AA9` (F3BC) | Mic-E message code |

- **Ledger note, no change made:** final3's proven run `0x054AE2`–`0x054C12` includes
  `0x054AE2`–`0x054BF7` (278 B). Its only inbound edge is a fall-through from `0x054ADE`, which
  sits inside the unproven run `0x054AC0`–`0x054AE1`. This is a candidate **−278 B**
  over-credit for the ledger owner to re-check. `0x054BF8` itself is reached from `sub_20FA`
  (`0x002214`). Byte-count delta applied by this lane: **0**.

## USB relevance

- **Q1 (USB):** none. No routine in the APRS receive or transmit chain, the TX state handlers or
  the SmartBeaconing code references `0xFFEE00`–`0xFFEE53` (`usb-check.txt`, 4 ranges, 0 hits).
  APRS traffic runs over SCI-B. GPS-out and waypoint output use SCI-A.
- **Q2 (SDR):** unchanged, no. SCI-B carries demodulated 1-bit HDLC data at 38400 baud,
  which is not samples. That is the narrowest possible "receiver output", and it is already
  sliced by the far end.
- **Q3 (DSP):** this sharpens the picture slightly. The DSP is told the APRS modem mode
  (opcode `0x32`), and every APRS transmission performs a `B0CE` request/acknowledge handshake
  with it, so the packet modem is probably DSP-side (Inferred). No path exposes SCI-B to the PC.

## Open

1. **Identify `0xFFFF4D` b3** (§5): find the hardware relation between `FFFBA5` b6/b7, `FFFBA4` b5
   and the PTT line, or find a code path that keeps b3 low during automatic TX. This decides
   whether J9's PTT label stands.
2. **Initial message retry count:** find who fills slot byte `+0x1B` (staging record
   `FF9E08`/`9E23`) when a message is queued, probably a block copy into `FF9E08`.
3. **Confirm the auto-reply task is dead.** Check for any computed call into
   `0x054AC0`–`0x054AE2` (none found), and re-check final3's credit of `0x054AE2`–`0x054BF7`.
4. **Decode the `B0CE` b6 request** (`sub_59E16` vs `sub_59D94`) and the alternate completion,
   states 6/7 (`FFAA35` b7, set by key handler `sub_22676`). This would name what the DSP is
   asked to do around an APRS transmission.
5. **Map the SUB APRS menu labels** to `FF8AA0`, `FF8AAB`, `FF8ABC`, `FF8BCC`, `FF8AAE`,
   `FF8C42`… (SUB F3xx decode). This turns the labels in §6 from Inferred to Confirmed.
