# 86 — DSP session 0x17 and the unattended transmissions (lane K4)

> Lane K4. The IDA dumps and jobs are the lane's (`ida\jobs\k4_dump.py`,
> `k4_graph.py`, `k4_reach.py`; DB `K4_AUTOREPLY`, seeded from
> `J1_MAIN_FINAL3`). The lane was stopped by a safety classifier before it
> wrote this file. This note is the write-up of the tables it left in
> `ida\out\dsp-autoreply\`.
>
> Image `decrypted\FT3D_MAIN_ver102_EXP.bin`, H8SX, big-endian, base 0, file
> offset = address. sha256 `8e3ecd05409b2c314ebed77320ece5930bf31c8333cd84aeef4f6b0264c1bcce`
> (unchanged). Every one of the 2,162 disassembly rows in `call-chains.txt`
> was compared with that image: 2,162 match, 0 differ. A separate scan of the
> image found exactly six `jsr sub_6D052` encodings (`5e 06 d0 52`) and
> exactly 19 `mov.b #imm,@B0B9` stores of the form `fc imm 6a 8c b0 b9`.
> Nothing was written to a radio. The image was not modified. The closed
> window `0x078106`–`0x07B753` was not entered. No new proven bytes, so the
> decompile ledger is unchanged.

## Verdict

**DSP session `0x17` is the PDN form of a WIRES-X request the user or the
host already started.** `sub_6D052` stores `0x17` to `B0BE` and calls
`sub_5A28A` directly. The image contains six calls to it. Each call sits
behind `mov.b @FF8DDE, r4l` / `bpl`, so the call runs only while `FF8DDE` is
negative (PDN mode, the name already used in docs 57 and 77).

Doc 77 read those same callers as receive-message decoders and left open
"which inbound message makes the radio transmit `0x17`". The callers are the
WIRES-X request builders (`]q`, `]#`, `]f`, `]g`, `]*`). A received message
does not enter `sub_6D052`.

The transmissions that do start without a fresh keypress use other message
types. None of them stores session `0x17`:

| Id | What it is | Message type `B0B9` | Session |
| --- | --- | --- | --- |
| T1 | GM beacon on a timer, while GM is active | `0x16` → `G` `c`/`d` | `0x0A` via `AACF` |
| T2 | The same beacon, pulled forward when a new member is heard | `0x16` | `0x0A` |
| T3 | Delivery ACK for a message addressed to this radio | `0x19` → `G` `0` | `0x0A` |
| T4 | Analog answer-back after a code match | none (carrier) | none |
| T6 | WIRES-X search the X key already armed, sent 2.8 s later | `0x12` → `]` `q` | `0x0A`, or `0x17` in PDN |
| T7 | WIRES-X key-up the PTT path already armed | voice `0x02` family | `AACF` |

`B0B9` and `B0BE` are different bytes. `B0B9 = 0x17` is a user GM message
(`G` `e`/`f`, stored at `0x067B9C`). Session `0x17` is `B0BE`, stored only at
`0x06D090`.

## 1. The session-0x17 arm (`sub_6D052`)

Confirmed from `call-chains.txt` C1, bytes checked:

```
06D052  bclr  #0, @AAD4
06D058  jsr   sub_5A28A          ; 5e 05 a2 8a
06D08A  mov.b #0x17, r4l         ; fc 17
06D08C  mov.b r4l, @B0B7
06D090  mov.b r4l, @B0BE         ; session
```

On the success path it also sets `AAD4.b0`, clears `B132`, sets `B0BB.b0`,
clears `B0BB.b1`, sets `B3D9.b7`, clears `B3D9.b6`, stores `B0C6 = 2`, and
clears `B111` and `B113`, then calls `sub_309F2`. It does not go through
`sub_2244C` or the `AACF` TX request.

## 2. The six callers

Whole-image scan. Every site is `6a 0c 8d de 4a xx` (`mov.b @FF8DDE, r4l` /
`bpl`) and then `5e 06 d0 52`. The `bpl` skips the call when `FF8DDE` is
non-negative.

| Call | Builder (lane name) | Air letter once `B0B9` is stored | Extra gate in the 16 bytes before the call |
| --- | --- | --- | --- |
| `0x062DB2` | `sub_62DA4` `]q` | `B0B9=0x12` at `0x062DE6` → `q` | also `B3E4 == 4` (`ac 04` / `bne` at `0x062DAE`) |
| `0x062E2C` | `sub_62E14` `]#` | `B0B9=0x13` at `0x062E72` | sign test alone |
| `0x062EC4` | `sub_62EAC` `]#` | `B0B9=0x13` at `0x062F0C` | sign test alone |
| `0x062F6A` | `sub_62F64` `]*` | `B0B9=0x1D` at `0x062F98` | sign test alone |
| `0x062FD8` | `sub_62FC6` `]f` | `B0B9=0x14` at `0x063006` | sign test alone |
| `0x06304C` | `sub_63040` `]g` | `B0B9=0x15` at `0x06307C` | sign test alone |

`sub_62DA4` is fully listed in C2. In PDN, with `B3E4 == 4`, it calls
`sub_6D052` and then still stores `B0B9 = 0x12` and builds the `]q` body at
`FF0C3D`. With `FF8DDE` non-negative it takes the ordinary path: `sub_22F78`,
`sub_22FEE` (which calls `sub_2244C`), then the same body. The other five
builders follow that shape; only the sign test and the `jsr` were re-read for
them.

The letter byte for each `B0B9` value is the builder reached from
`off_5CE98[B0B9]` (`0x05CB12`, scale 4). Checked heads: `0x12` → `0x05CD6C`
`fb 71` (`q`); `0x16` → `0x05CD86` `c`/`d`; `0x17` → `0x05CDBC` `e`/`f`;
`0x18` → `0x05CDEC` `g`/`h`; `0x19` → `0x05CD82` `fb 30` (`0`); `0x1E` →
`0x05CDB6` `fb 6a` (`j`). Slot `0x20` points at `0x05CE96`, whose first
instruction is `rts`, so this lane does not show a letter for it.

## 3. Who transmits without a new keypress

### T1 — GM beacon

`sub_6802A` calls `sub_67AB0` at `0x068208` (`5e 06 7a b0`). `sub_67AB0`
calls `sub_22FEE` at `0x067B20` and stores `B0B9 = 0x16` at `0x067B48`
(`fc 16`). The letter head at `0x05CD86` sends `c`, or `d` plus a position
block, when `FF8D82.b0` is set and `sub_23038` returns nonzero
(`0x05CD00` is the same test; `0x05CD86` is the slot `0x16` uses).

The interval is `word_5DFD0[B3EF]`, loaded at `0x068226`
(`mov.w @(0x05DFD0, er4), r4` into `FF95BE`). The 24 big-endian words at
`0x05DFD0` are `0x05DC` × 6, then `0x07D0` × 5, then `0x0BB8` × 13. `FF95BE`
is a fast-tier word of `sub_3576` (C36: words `FF95B2`–`FF95CD`). Doc 93
already measured that fast tier as 10 ms, so those words are 15 s, 20 s and
30 s. This lane did not re-measure the tier. The first arm stores `0x64`
(1.0 s on that tier) at `0x0680FC`. After the radio's own transmission, if
fewer than `0xC8` ticks remain it adds `0x190` (`0x068110`–`0x06811A`):
2.0 s and 4.0 s on the same tier.

`sub_67AB0` also defers when `FF94C0 == 1`, when `FF955C != 0`, or when
`sub_22F78` reports the channel busy (`A520 == 1`). The busy counter `B416`
stops the deferral at 2 (`0x067AF0` `cmp.b #2`).

`sub_22F78` (C4) returns failure when the selected comm-mode byte is 0
(`FF8DD5` if `FF8EA0.b6` is set, otherwise `FF8D20`), when `B0A4.b2` is
clear, or when `FF8D26` is negative. Those are the digital-mode, DSP-link
and callsign checks the lane named. No separate on/off setting is tested on
this chain.

### T2 — beacon pulled forward

`sub_689A2` (C17) runs when a member record's byte `+0x0F` has bit 7 set and
byte `+0x12` has bit 5 clear. It sets that bit 5 and stores `FF95BE = 0x32`
at `0x0689C6` (0.5 s on the fast tier). The next beacon is still T1.
`reach-rx-handlers.txt` reaches `0x0689C6` from `sub_6876E` and from
`sub_68672`.

### T3 — delivery ACK

`sub_68304` compares the letter with `e` and `f` (`0x068304` `cmp.b #0x65`,
`0x06830A` `cmp.b #0x66`). `sub_68318` compares `g` and `h`. The shared body
`sub_6832A` (C15):

- Compares 10 bytes at `FFB471` with the ten `*` at `byte_59B44`
  (`0x059B44` is `2a` × 10). A match takes the group branch at `0x068436`
  and does not arm an ACK.
- Otherwise compares 5 bytes at `FFB46C` with `FF8060`, then 10 bytes at
  `FFB471` with `FFA8DA`. Both must match.
- On a match it stores `0x30` (`0`) at `B429`, copies 15 bytes, sets
  `B40D = 1` at `0x068420`, and sets `FF955A = 0xC8` at `0x068426`.

`FF955A` is a fast-tier byte (`FF9536`–`FF958D`), so `0xC8` is 2.0 s on
doc 93's tier. `sub_68242` sends only when `B40D`, `FF955A` and `FF9559` are
all zero (`0x068242`–`0x068254`), then clears `B40D` at `0x06825C`. The
sender `sub_67F18` stores `B0B9 = 0x19` at `0x067F38` and copies 0x15 bytes
from `FFB424`. The `e`/`f` entry also requires `BA93.b6` clear
(`0x06846C`). Picture completion re-arms `FF955A = 0xC8` at `0x05F63C`
while `B40D` is still set (C20).

`reach-rx-handlers.txt`: `sub_68304` reaches `0x068616` (the other arm site,
inside `sub_68468`), and `sub_5F2B0` reaches `0x068420`. The pollers that
call the ACK sender are `sub_6802A` at `0x068238`, `sub_5ED18`, and
`sub_63216`.

### T4 — analog answer-back

Band A's state handler `sub_3008C` tests `FF8F86.b0` at `0x0300E2`. If
`FF89C3.b2` is clear it returns without arming (`0x030128` `btst #2` /
`beq`). If the bit is set it sets the band record `+0x86` bit 7 at
`0x030130` and stores `FF9578 = 0xC8` at `0x03013A`. Band B's mirror is
`sub_31B62`, with the same `FF89C3.b2` test at `0x031BDC` and the same
`0xC8` store at `0x031BEE`. The fire path `sub_3019E` requests TX through
`AACF` (C25). There is no DSP session byte on this path. How long the
carrier stays up was not measured. The lane's "default off" reading of
`FF89C3` was not re-checked here; the bit test itself is Confirmed.

### T6 and T7 — already started by the user

T6. `sub_5FC0E` (the X-key path, C23) sets `B26B.b7` at `0x05FCD6` when the
band had to move to DN. `sub_63216` calls `sub_62DA4` at `0x0632CC` once
`FF95E4` expires. `FF95E4` is a slow-tier word (`FF95CE`–`FF95E9`). The arm
value `0x1C` is 2.8 s, and the later `0x12C` is 30 s, on doc 93's 100 ms
slow tier. In PDN that call is the `0x17` path of T5; otherwise it is an
ordinary `AACF` request. The lane's table is right to call the 100 ms tier
here.

T7. `sub_615AA` stores `FF959B = 0x23` at `0x0615BE` and sets `B3EA = 0x29`.
`sub_63304` calls `sub_61624` when `B3EA == 0x29` and `FF959B` has reached 0
(C33), and `sub_6631E` calls `sub_2244C`. `FF959B` sits in the slow byte
span `FF958E`–`FF95B1` (C36 loads `0x24` bytes from `FF958E`), so `0x23` is
3.5 s on the 100 ms tier. The lane table called this 350 ms on the 10 ms
tier. That label does not match the span.

## 4. The `B0B9` stores

Nineteen stores, scan of `fc imm 6a 8c b0 b9`. This matches
`b0b9-census.tsv`, except the census cites `0x06CAFA` for `0x20` and the
immediate is at `0x06CAF8` (the `mov.b` is at `0x06CAFA`).

| `B0B9` | Immediate | Lane class | Initiator in the lane table |
| --- | --- | --- | --- |
| `0x09` | `0x05F7E2` | `N` `c`/`d` picture start | user |
| `0x0A` | `0x05F98A` | `N` `b` block | user |
| `0x0B` | `0x05FABE` | `N` `e` end | user |
| `0x0C` | `0x05F752` | `N` `r` retry | user, retry |
| `0x0D` | `0x062B06` | `]` `c` | user |
| `0x0E` | `0x062BAC` | `]` `l` | user |
| `0x0F` | `0x062D1E` | `]` `r` | user |
| `0x12` | `0x062DE6` | `]` `q` | user or host; session `0x17` in PDN |
| `0x13` | `0x062E72`, `0x062F0C` | `]` `#` | user; session `0x17` in PDN |
| `0x14` | `0x063006` | `]` `f` | user; session `0x17` in PDN |
| `0x15` | `0x06307C` | `]` `g` | user; session `0x17` in PDN |
| `0x16` | `0x067B48` | `G` `c`/`d` | automatic, T1/T2 |
| `0x17` | `0x067B9C` | `G` `e`/`f` | user |
| `0x18` | `0x067E70` | `G` `g`/`h` | user |
| `0x19` | `0x067F38` | `G` `0` | automatic, T3 |
| `0x1D` | `0x062F98` | `]` `*` | user; session `0x17` in PDN |
| `0x1E` | `0x067FEE` | `G` `j` | caller not traced |
| `0x20` | `0x06CAF8` | node | host |

APRS beacons stay with doc 90. This lane's table marked them not analysed,
and they were not re-opened.

## 5. Correction to doc 77

Doc 77 §3 and its open item 2 say `sub_62DA4` / `sub_62E14` / `sub_62EAC` /
`sub_62F64` / `sub_62FC6` / `sub_63040` are received-message decoders and that
a received message starts session `0x17`. Section 2 of this note is the
replacement: those six are the WIRES-X request builders, and `0x17` runs only
in PDN, on a request that was already armed. The receive-triggered
transmissions are T2 (beacon timing only), T3 (addressed ACK) and T4 (analog
answer-back).

Doc 77's statement that the only external keyers are the hardware PTT and
node command `0x11` is the one doc 90 and doc 93 already widened (APRS, the
`S` frame, remote `']'`). This note adds the GM beacon and the addressed
ACK, both on the ordinary `AACF` path through `sub_2244C`.

## 6. Bounds

The K4 disassembly dump contains no `FFEE` operand, so the routines it lists
do not touch the USB register block. No sample or audio payload is built on
these paths: the beacon and the ACK are short `G` frames, and session `0x17`
is the same `sub_5A28A` data session doc 57 already decoded. The download
window stayed closed.

## Left by this lane

- Length of the T4 carrier.
- Who calls `sub_67FCE` (`B0B9 = 0x1E`, letter `j` is confirmed, the caller is not).
- The GM name is inferred from the member list and the beacon. The instructions are confirmed.
- Wall-clock seconds use doc 93's 10 ms / 100 ms tiers and were not re-measured.
