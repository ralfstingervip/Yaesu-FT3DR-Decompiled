# 112 — Hand-reconstructed C for the mission routines (lane L15)

> Lane L15. Private DB `L15_C_RECON` (`--copy-from ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`),
> one read-only IDAPython dumper `ida\jobs\l15_dump.py` (a copy of K11's generic `dis`/`func`/`xref`/
> `callers` pattern; window `0x078106`–`0x07B753` skipped), seeded once and run once (exit 0, no
> traceback). Image `decrypted\FT3D_MAIN_ver102_EXP.bin`, 1,048,576 bytes, H8SX big-endian, base 0,
> file offset = mapped address; sha256 `8e3ecd05409b2c31…` (re-checked, unchanged). No image was
> modified; nothing was connected to or written to a radio; the closed service window was not entered.
> There is no Hex-Rays for H8SX, so the C below is hand transcription from disassembly, every
> statement block carrying the address of the bytes it stands for. Model: `claude-opus-5-5`.
>
> Deliverables: this doc, the dumper `ida\jobs\l15_dump.py`, the request `ida\out\c-recon\l15_req.txt`,
> the raw disassembly `ida\out\c-recon\l15_dump.txt`, the 65-row byte-citation file
> `ida\out\c-recon\citations.tsv` (re-read from the image, `cites 65 mismatch 0`), and three C files:
> `ida\out\c-recon\l15_usb_vendor.c`, `l15_tx_gate.c`, `l15_keyseq.c`.

## Verdict

The three mission routine families that lacked C now have it, reconstructed by hand from the bytes and
cross-checked against the earlier descriptive docs. **~370 lines of C over ~30 routines**, all
Confirmed from disassembly:

1. **The MAIN vendor-class USB device path** (`l15_usb_vendor.c`): the three interrupt handlers
   (vectors 234/235/238 → `0x054D50`/`0x054EC2`/`0x054CFA`), the init/reset (`sub_54C44`/`sub_54CAE`/
   `sub_54BF8`), the 12-state control-transfer FSM (`sub_54FEC` → table `0x055002`, state byte
   `FF8183`), the SETUP+GET_DESCRIPTOR handler, all five accepted requests (`80 06`, `C1 D4`, `41 D1`,
   `41 D2`, `41 D3`), the EP1 bulk-OUT copy loop at `0x055684` with the `cmp.w #0x400`-after-the-packet
   wrap check (the 63-byte overrun), and the 3-byte EP `0x83` status report `[FF8184, FF89CE,
   code(FF89CD)]`.
2. **The TX gate** (`l15_tx_gate.c`): the PTT debounce FSM (`sub_FC66` + its 4-state table), the TX
   request `sub_2244C` with PTT LOCK (`sub_22562`) and the frequency-range gate, the TX state-machine
   state 1 (`sub_34966`) including the `0xFFFF4D` b3 RF-status interlock at `0x034984` and the
   `FFA4F0` TX-request bits at `0x034A5A`/`0x034A62`, and the range check `sub_34E42` itself.
3. **The 8-step hidden key machine** at `0x01494C` (`l15_keyseq.c`): **doc 49's existing C was checked
   line by line against the bytes and is CORRECT** — no rewrite required (details below).

**One disagreement with an earlier doc, flagged with bytes:** doc 93 calls the PTT pin `0xFFFF4E` b7
"active low", but `sub_FC66` treats the register bit **set** (`(P4E & 0x80) != 0`) as *pressed*. This
is a pin-vs-register sense nuance, not a behavioural contradiction (see Findings §2). Everything else
matched docs 64/73/74/75/93/97 at the byte level.

## Method

- Seeded `L15_C_RECON` from `K1_MAIN_FINAL4` and ran `l15_dump.py` over the target ranges
  (`l15_req.txt`): the whole vendor stack `0x054B00`–`0x056100`, the key-scan/PTT/D3 region
  `0x00FB00`–`0x00FEA0`, the TX request/state-machine `0x022440`–`0x022760` and `0x034780`–`0x035010`,
  the range check `sub_34E42`, and the key machine `0x014940`–`0x014AB0`, plus `func`/`xref`/`callers`
  for the entry points. Output in `l15_dump.txt` (3,207 lines).
- Independently re-read 65 load-bearing byte runs straight from the image with a Python decoder
  (`citations.tsv`, `cites 65 mismatch 0`), after confirming the sha256. The C was written from the
  disassembly, not from the prose of the earlier docs; the earlier docs were used only to name RAM
  cells and to check I had not missed a path.
- **Calling / register model** (Renesas H8S C compiler, `docs\compiler.md`, and as observed): the band
  / channel-record / screen-context pointer is carried in `er0` and read as `er0+disp` fields
  (`@(1,er0)` = screen/mode id, `@(0x86,er0)` = record flag byte, `@(0x15/0x1A/0x1E/0x46,er0)` =
  shift/RX/TX/keep fields). The TX range predicate returns in **both** the CCR Z flag and `r4l`
  (`fc 00` allow / `fc 01` block); callers branch on Z. The USB stack is a polled cooperative machine
  plus three ISRs communicating through RAM, not through return registers. Each C file's header has the
  full RAM-globals table (address, name, meaning, source doc) for its routines.
- **Not done:** the closed window (`0x07827C` CDC hand-off from ISR 234, and boot `0x078106`) was never
  entered; `sub_325FA`'s ROM-map arithmetic and the non-vendor IFR2 tail past `0x054FC6` were read only
  as far as the mission paths need (they are owned by docs 97 and 64 respectively). No host code was
  written or run.

## Findings

### 1. USB vendor device path (`l15_usb_vendor.c`) — Confirmed

**The 12-slot FSM table** `off_55002` (`sub_54FEC` at `0x054FEC`: `6a 0b 81 83` reads `FF8183`, `×4`,
indexed `jmp`). Re-read from the image:

```
055002  00 05 50 34  00 05 50 42  00 05 51 96  00 05 51 aa   ; states 0,1,2,3
055012  00 05 51 c2  00 05 50 42  00 05 51 da  00 05 53 06   ; states 4,5,6,7
055022  00 05 55 20  00 05 55 52  00 05 53 06  00 05 56 c8   ; states 8,9,10,11
```

So state 5 shares the handler of state 1 (`0x055042`), and state 10 shares state 7 (`0x055306`) — the
two SETUP/request states are each entered from two FSM states, exactly as the request table in doc 64
§4 implies. The C mirrors this with `st_setup_descr()` and `st7_d1_d3()` called from both.

**The three ISRs are fully reconstructed** (doc 64 §2 gave the semantics; this lane has the bodies):

- Vector 234 `usb_isr_main` (`0x054D50`): `6a 0c 81 3a 58 60 01 4c` — if `FF813A != 0` it jumps to the
  CDC hand-off (`0x054EA8` → `jsr 0x07827C`); otherwise it services IFR0 b7/b3/b2/b1/b0 (bus reset,
  SETUP read of 8 B from `EE0E` into the 16-slot ring with the `0x3D6A` wrap, EP0-OUT, EP0-IN request
  ZLP in state 4, EP0-IN continuation). The bus-reset path (`0x054D64`) resets the ring and `FF8180.6`
  but **not** `FF8183` — confirmed, which is why a bus reset alone does not re-enumerate.
- Vector 235 `usb_isr_vbus` (`0x054EC2`): IFR1 b0 copies VBUS (IFR1 b3) into `FF8180.0`, sets
  `FF8183 = 0`, and on VBUS-loss does the full soft reset including `FF8184 = 0x0100FFFF` (`0x054F1C`).
  The EP3-report writer at `0x054F3A` is **dead** (`0x054ECC beq 0x054F88` skips it and IER1 = `0x03`
  masks IFR1 b2) — confirmed; it is a verbatim copy of the live 3-byte report.
- Vector 238 `usb_isr_ifr2` (`0x054CFA`): sets `FF8180.1`, acks IFR2 b4. The `EE2F` `#8`→`#0` resume
  pulse at `0x054D22` is **dead** (`0x054D1E bne` / `0x054D20 bra` both jump past it).

**The EP1 bulk-OUT copy loop and the 63-byte overrun** (state 9, `0x055684`), re-read:

```
05567E  7a 15 00 ff 58 06   add.l #0xFF5806, er5     ; dst = base + push_index
055684  6a 0c ee 10         mov.b @EPDR1, r4l         ; one byte from EP1 FIFO
055688  68 dc / 0b 05 / 1a 04 / 46 f4                 ; *dst++ = b; --count; loop
05569E  79 25 04 00  45 1c  cmp.w #0x400, r5 / bcs    ; WRAP CHECK AFTER THE PACKET
```

Because the `cmp.w #0x400` runs only *after* a whole packet is copied, an index that starts below
`0x400` but takes a 64-byte packet writes up to `0xFF5806 + 0x43E = 0xFF5C44`, i.e. **63 bytes past**
the 1 KB window end `0xFF5C05` (unowned slack, doc 75). The C marks this at the loop with the exact
arithmetic. A host that sends full 64-byte packets on `0x100`-aligned boundaries never reaches it.

**The 3-byte EP `0x83` report** appears verbatim in three live builders (`0x055202`, `0x05532E`,
`sub_557A2`) and the dead one (`0x054F4E`); the state-7 copy re-read: byte0 `FF8184` → `EE18`
(`0x055336`), byte1 `FF89CE` → `EE18` (`0x055342`), byte2 quality `0x18`/`0x30`/`0x50` from `FF89CD`
→ `EE18` (`0x05535E`), word shadow `FF8186`, `TRG = 0x40` (`0x055366`), gated by `DASTS EE27` b5 and
the send-on-change compare against `FF8185`/`FF8186`. Matches doc 64 §6 and doc 73 exactly.

**The `41 D1` gates** (`0x055414`): refuse on `FF94C0 != 0` (TX), KEY LOCK with `FF89AB` b0 = 0,
`FF2EC9 != 0` (busy), or size 0 — then drain into state 11. Accept kicks the audio machine
(`FFA9E3 |= 0x10`, `0x055488`), posts the upload beep (`FFAAE0 = 0x4F`, `0x05548E`), sets report byte 0
(`FF8184 = 1`, `0x055496`) and advances to state 8, which NAKs the status stage until `FFAAE8 == 0`
(the beep finishes). `41 D3` stores the button level in `FFB096` (`0x0554E6`); the edge detector
`sub_FDC8` (`0x00FDC8`) injects raw key `0x14` on the 0→nonzero edge. All Confirmed.

### 2. TX gate (`l15_tx_gate.c`) — Confirmed; one note on PTT sense

**PTT debounce** `sub_FC66` (`0x00FC66`, `2a 4e ea 80`) → 4-state table `off_FC80`
(`00 00 fc 90 / fc 9c / fc e2 / fc f4`). The state bodies re-read confirm doc 93's table: state 0
advances on release, state 1 emits raw `0x17` (press) or starts the `FF953D` delay from
`byte[0x00FCDC + FF89B0]` (`00 02 05 0a 14` = OFF/20/50/100/200 ms), state 2 emits raw `0x18`
(release), state 3 emits the delayed press.

> **Disagreement with doc 93, with bytes.** Doc 93 labels `0xFFFF4E` b7 "active low". In the firmware
> the sense is inverted at the register: `0x00FC90 aa 00 46 06` (state 0 advances when `r2l == 0`) and
> `0x00FC9C aa 00 47 3a` (state 1 emits the press only when `r2l != 0`). So `sub_FC66` treats
> **bit7 = 1 as pressed**. Either an inverting buffer sits between the PTT pin and the port, or doc
> 93's "active low" describes the external switch (switch-to-ground) while the port reads inverted.
> The firmware-visible rule is unambiguous: pressed ⇔ `(P4E & 0x80) != 0`. This does not change any
> behaviour doc 93 states; it only pins the register polarity.

**TX request** `sub_2244C` (`0x02244C`) and **PTT LOCK** `sub_22562` (`0x022562`): reconstructed with
the digital/DSP precondition (`FFB0A4` b2), PTT LOCK (`FF89C1` b3 + `FF89AB >= 3`), busy-channel
lockout (`FF89BF` b4 + band `0x90 != 2`), slot-consistency (`FF8EA6`), and the range gate. The gate's
two call sites and the block arm are re-read: `0x022504 5e 03 4d c2 46 44` (`jsr sub_34DC2` / `bne`),
block `0x02254E fc 02 6a 8c 94 c0 fc 1d …` (`FF94C0 = 2`, tone `0x1D`), allow `0x022542 6a 8c 94 c0`
(`FF94C0 = 1`). Matches doc 97 §4.

**TX state 1** `sub_34966` (`0x034966`): node-keyed mode (`FF8DDE < 0` with `FF8DE0` b7 or `FFB3D9` b2)
skips the interlock; otherwise it waits for the settle timer `FF956D == 0` and then the RF-status line
`0x034984 7e 4d 73 30` (`btst #3, @0x4D:8`) — **low = OK, keys the PA**; if it stays high past the
fault timer `FF9568` it aborts via `sub_34FF4` (`0x034A70`). The data/APRS TX-request bits
`0x034A5A 6a 18 a4 f0 70 60` (`FFA4F0` b6) and `0x034A62 … 70 70` (b7) are the data and APRS paths
reached from the `FFAAD3` b0/b2 tests. All Confirmed.

**Range check** `sub_34E42` (`0x034E42`, 64 B): allow if `FFAAAE` ∈ window A (`FF92CE`) **or** window B
(`FF92D6`), else block; sets/clears record bit `er0+0x86` b4 and returns `r4l = 0`/Z (allow) or
`r4l = 1`/Z-clear (block). Byte-identical to doc 97 §1 (re-cited: `0x034E42 01 00 6b 05 aa ae`,
`0x034E6A 70 4c … fc 00`, `0x034E7E fc 01 54 70`).

### 3. The 8-step key machine (`l15_keyseq.c`) — doc 49's C verified CORRECT

Doc 49 (`49-key-sequence-hidden.md` §F7) already carries hand-written C. Lane L15 checked it line by
line against `0x01494C`–`0x014AA6`. **It is correct.** Each checked point, with the byte:

| Doc 49 C line | Bytes | Verdict |
| --- | --- | --- |
| `if (!(FF89C1 & 0x08)) return;` | `0x01494C 6a 10 89 c1 73 30 … 47 7c` | ✓ |
| `if (FFBC8A & 0x80) return;` | `0x014954 6a 10 bc 8a 73 70 46 74` | ✓ |
| `if (scr->id != 0x0C) return;` | `0x01495C 6e 0c 00 01 ac 0c 46 6c` | ✓ |
| `FFBC8A = 0;` + switch(`FF8F2E`) | `0x014964 fc 00 … 0x01496A 6a 0c 8f 2e` | ✓ |
| case 0 → `|= 0x10` | `0x0149B6 6a 18 bc 8a 70 40` | ✓ |
| case 5 → `|= 0x08` | `0x0149BE … 70 30` | ✓ |
| case 8 guard + `|= 0x20` | `0x01499A 01 00 6b 04 91 0a / 7a 24 00 06 66 00`; `0x0149AE … 70 50` | ✓ |
| case 10 guard + `|= 0x40` | `0x01497E … 91 0a / 7a 24 00 06 66 00`; `0x014992 … 70 60` | ✓ |
| `|= 0x80; FFBC8B = 8;` | `0x0149C4 6a 18 bc 8a 70 70 fc 08 6a 8c bc 8b` | ✓ |
| step slot6 expects 6 | `0x0149D2 … ac 06` | ✓ |
| step slot1 expects 5 | `0x0149EA … ac 05` | ✓ |
| step slot8 expects {8,3,2} | `0x014A02 … ac 08 / ac 03 / ac 02` | ✓ |
| step slot5 expects {7,4}, 1=complete | `0x014A1E … ac 07 / ac 04 / ac 01 46 60` | ✓ |
| complete bit3 → `FFB0C8 = 1` | `0x014A36 6a 10 bc 8a 73 30 46 32`; `0x014A70 fc 01 6a 8c b0 c8` | ✓ |
| complete bit4 → ext SW-VER | `0x014A3E … 73 40`; `0x014A62 6a 18 bc 8a 70 00` | ✓ |
| complete bit5 → `sub_1645E` | `0x014A46 … 73 50 46 0e`; `0x014A5C 5e 01 64 5e` | ✓ |
| complete bit6 → `sub_16456` | `0x014A4E … 73 60`; `0x014A56 5e 01 64 56` | ✓ |
| dec + consume | `0x014A8A 1a 0c 6a 8c bc 8b 5e 03 ff a0` | ✓ |
| reset clears **bit 0 only** | `0x014A96 6a 18 bc 8a 72 00 fc ff 6a 8c bc 8b 5e 01 4b ba` | ✓ |

Required slot order for counter 8→1 (read from the expected-counter values): **8, 5, 6, 1, 5, 8, 8, 5**
— identical to doc 49. Two framing clarifications only, both consistent with doc 49's prose, not
errors: (a) the "`keyseq_step(keyslot)`" switch is in reality four separate functions at the addresses
in the table; (b) completion (`0x014A36`) falls through to reset (`0x014A96`) if none of bits 3–6 is
set (`0x014A54 47 40`).

## USB relevance

- **Q1 (everything USB).** The vendor device path now has byte-anchored C end to end: the three ISRs,
  the 12-state FSM, every accepted request, the EP1 copy loop with its overrun, and the 3-byte EP `0x83`
  report. This adds no new USB surface — it is the same four-request camera/image personality docs 64/
  73/74/75 describe, now in reconstructed C with every branch preserved. The CDC personality behind
  `FF813A != 0` (`jsr 0x07827C`) was left at the window edge, per the rule.
- **Q2 (USB SDR): unchanged no.** The only IN endpoints are EP0 (fixed descriptors + the 1-byte `D4`
  reply) and EP `0x83` (3 status bytes on change over a 20 ms interrupt). The EP1 pipe is bulk **OUT**.
  Nothing on this path moves samples; the C makes the data flow explicit.
- **Q3 (DSP): unchanged.** The TX gate's only DSP touch is tone `0x1D` on refuse; the range check and
  key machine do not touch SCI-C.

## Open (most valuable first)

1. **The CDC personality past `0x07827C`.** It is the other half of the USB surface and sits behind the
   closed window; reconstructing it needs a decision to enter `0x078106`–`0x07B753` beyond doc 95.
2. **Pin the PTT register polarity** against a schematic/service manual to resolve the active-low
   (pin) vs bit-set-is-pressed (register) note in Findings §2.
3. **`FF910A == 0x00066600`** (key-machine cases 8/10 guard): still only narrowed, not identified
   (doc 49 Open 4). It is the sole use of that immediate and of abs16 `FF910A`.
4. **`er0+0x86` b4 reader** (`0x010674`) and `er0+0x46` b0 writer: the range-check's output bit and the
   keep-shift flag are named only structurally (doc 97 Open 1/3).
