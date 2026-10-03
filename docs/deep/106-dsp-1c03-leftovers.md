# 106 — DSP opcode 1C 03, the T4 carrier length, and the B0B9 leftovers (lane L9)

> Lane L9. Private DB `L9_DSP_1C03` (`run_job.py --copy-from
> ida\db\jobs\K1_MAIN_FINAL4\K1_MAIN_FINAL4.i64`), read-only dumper
> `ida\jobs\l9_dump.py`, two passes (`--reopen`). Image
> `decrypted\FT3D_MAIN_ver102_EXP.bin`, H8SX, big-endian, base 0, so file offset
> = mapped address; sha256 `8e3ecd05…` (unchanged; SUB `b93570b3…` unchanged). A
> few constants were also read directly from the image with Python (read-only).
> No image was modified, nothing was connected to or written to a radio, and the
> closed window `0x078106`–`0x07B753` was not entered. Model: `claude-opus-5-5`.
>
> Tables in `ida\out\dsp-1c03\`: `opcode-1c.tsv`, `b0b9-writers.tsv`, and the raw
> IDA dumps `l9_pass1.txt` / `l9_pass2.txt`.

## Verdict

**DSP opcode `0x1C` is sent in exactly one place and only ever as sub-op `0x03`
with an empty payload.** The builder `sub_5A040` reads the sub-op from `B0B8`,
and a whole-image scan finds **one** writer of `B0B8`: `0x05C442`, the constant
`3`, inside the session-`0x15` script. The builder can also pack a `[2]` byte for
sub-ops `9` and `0x0D` (from the factory cells `FF8E2B`/`FF8E2C`/`FF8E2D`), but
nothing in ver 1.02 ever sets `B0B8` to `9` or `0x0D`, so those payloads are
dead. The one live `1C 03` frame is step 4 of DSP session `0x15`, the
remote/service TX armed by host command `']'` (`B0CC.b0`); MAIN waits only for the
generic frame ACK/NAK after it. What the DSP does with `1C 03` stays Unknown (no
DSP firmware in the package).

**T4 (the analog answer-back carrier) is paced by `FF9579` and counted by `AACE`,
not by a DSP session.** After a code match the band arms a 2.0 s hold-off
(`FF9578`/`FF9589` = `0xC8` on the 10 ms tier), then keys an analog carrier
(`AACF = 1`) and sets `AACE = 5`. The TX-hold state `sub_34CCE` sends five
alternating-tone elements, each gated by `FF9579` reloaded to `0x32` (50 × 10 ms =
**500 ms**) in `sub_34BCA`; when `AACE` reaches 0 it calls `sub_227BC` and drops
TX. So the answer-back carrier is **≈ 2.5 s (5 × 500 ms)**. No `B0BE` session byte
is involved — it is the analog FM path, keyed through `AACF`.

**B0B9 `0x1E` (the last unattributed GM message, air letter `j`) is
keypress-triggered, not an auto-TX.** `sub_67FCE` → `sub_67FB6` → `sub_664C2`, and
`sub_664C2`'s only caller is the key-event dispatcher `sub_1079E` (key-table slot
`0x0113E4`). It keys TX through `sub_22FEE`→`sub_2244C`, the same software request
the beacon and ACK use, but its root is a key on a WIRES-X screen (state
`B3EA == 7`), gated by `A9EE.b7` and `FF8DD7`. The complete B0B9 census now has
every value attributed; the only writers that transmit with **no** keypress are
`0x16` (GM beacon timer) and `0x19` (RX-triggered delivery ACK), both already in
doc 86.

## Method

- Seeded `L9_DSP_1C03` from `K1_MAIN_FINAL4`; ran `l9_dump.py`
  (`func`/`range`/`xref`/`bytes`) twice. `idat_exit 0` both times, no traceback.
- Read directly, byte-for-byte: the `0x1C` builder `sub_5A040`, the session-`0x15`
  script table `0x05C40A` and its step handlers `sub_5C436`/`sub_5C44C`, the
  session arm `sub_5A2F8`, the `']'` command handler `sub_74396`, the CPU→DSP
  trace formatter `sub_5A506`, the analog answer-back TX states `sub_34CCE` /
  `sub_34D42` / `sub_34BCA`, the TX-release `sub_227BC`, the TX-phase reader
  `sub_3EF6E`, and the full `0x1E` chain `sub_67FCE`/`sub_67FB6`/`sub_664C2` with
  the common GM sender tail `sub_67F6E`.
- Whole-image scans (Python, read-only, cross-checked against IDA xrefs): every
  `B0B8` store (`6a 8x b0 b8`, `00 ff b0 b8`) — one hit, `0x05C442`; every `B0B9`
  store (`6a 8c b0 b9`) — 19 hits, matching `b0b9-census.tsv`; all `AACE`,
  `FF9579`, `FF9578`, `FF9546`, `FF95AC` accesses; the callers of `sub_664C2`.
- Timebase from doc 76 (byte-proven): 5 ms ISR, fast tier (`FF9536`–`FF958D`)
  10 ms, slow tier 100 ms, 1 s tier; script guard 2.2 ms. `FF9579` and `FF9578`
  are both inside the 10 ms fast tier (verified by address bounds).
- Not done: what any `1C`/answer-back byte means *to the DSP* (no DSP firmware);
  the exact UI label of the `j` key action (Inferred as a WIRES-X all/group
  command from the `'*'×10` target and `B3EA==7` gate); re-measuring φ.

## Findings

### 1. Opcode `0x1C` builder `sub_5A040` (Confirmed)

Frame base is `FFB13E` (`[0]`). The builder (`l9_pass1.txt` ll. 5–42):

```
05A040  7a 04 00 00 00 00   mov.l #0,er4
05A046  7a 05 00 ff b1 3e   mov.l #0xFFB13E,er5      ; then 8x (mov.l er4,@er5 ; adds #4) -> clear 32 B
05A07C  f3 1c               mov.b #0x1C,r3h          ; [0] = 0x1C
05A07E  6a 0b b0 b8         mov.b @0xFFB0B8:16,r3l    ; [1] = B0B8 (sub-op)
05A082  6b 83 b1 3e         mov.w r3,@0xFFB13E:16
05A086  6a 0c b0 b8         mov.b @0xFFB0B8:16,r4l
05A08A  ac 09 47 0a         cmp.b #9 ; beq 05A098
05A08E  ac 0d 46 1c         cmp.b #0x0D ; bne 05A0AE  ; sub-op 3: skip [2], leave it 0
05A098  6a 0c 8e 2b … 14 cb [2] = (FF8E2B<<5) | (FF8E2C & 0x1F)   ; sub-op 9
05A092  6a 0b 8e 2d         [2] = FF8E2D                           ; sub-op 0x0D
05A0AA  6a 8b b1 40         mov.b r3l,@0xFFB140:16    ; store [2]
05A0AE  5e 05 8f a2         jsr frame_finish (0x58FA2)
```

So the frame is `1C, B0B8, [2], 0×28, checksum`. For the live sub-op `3`, `[2]`
and the rest are zero.

**Sub-op census (`opcode-1c.tsv`).** The only writer of `B0B8` anywhere in
`0..0x80000` is:

```
05C440  fc 03 6a 8c b0 b8   mov.b #3,r4l ; mov.b r4l,@0xFFB0B8:16
```

`B0B8` is read only by the builder (`0x05A07E`, `0x05A086`). There is no abs16 or
abs32 store of `9` or `0x0D` (Confirmed, whole-image scan). **Sub-op `3` is the
only live value; `9` and `0x0D` are decode-only paths with no writer** — matching
doc 87's finding that `FF8E2B`–`FF8E2D` (opcode `1C [2]`) are factory/EEPROM-only
and their hidden rows `0xCF`/`0xD0`/`0xD1` are unenterable. This is stronger: the
frame that would carry them is never even built.

**Build sites (callers of `sub_5A040`):**

| Site | Caller | Status |
| --- | --- | --- |
| `0x05A38C` | `sub_5A1BE` (dsp_request, `B0B5 ≥ 2` branch) | **Dead** — `B0B5` is only ever 1 (doc 52 §3.6) |
| `0x05C446` | `sub_5C436` (session `0x15`, step 4) | **Live** — the only reachable `1C 03` send |

### 2. Session `0x15` is the only live `1C 03` carrier (Confirmed)

Table `0x05C40A`, 11 steps on counter `B0BF` (`l9_pass1.txt` ll. 44–71):
`12` → WAIT → `1A 01`/`12` → WAIT → **`1C 03`** (`sub_5C436`) → WAIT → TXON →
wait `B0BB.b0` clear (PTT released) → TXOFF → `1A 00` RX ENABLE → END.

Step `sub_5C436` (`0x05C436`): `mov.b @B0A4; bpl skip; btst #3; bne skip`
(link ready and no ACK owed), then `B0B8 = 3`, `jsr sub_5A040`, `B0BF++`. After
it, step 5 is the generic WAIT `sub_5B3E2` (`B0A4 & 0x30`). **The only reply MAIN
parses is the frame-level ACK/NAK (`0xA0`/`0x90`); there is no dedicated `1C`
reply handler.**

**Arming.** `sub_5A2F8` (callers `sub_35872`/`sub_35F6A`, the TX-start
dispatchers) sets `B0B5=1`, `B0B7=0x15` and requests session `0x15` — but only
when `B0CC.b0` is set at the TX-start branch (`0x0358CA`/`0x035EDC`,
`6a 10 b0 cc 73 00`). `B0CC.b0` is set/cleared only by host command `']'`
(slot `0x2D`, `sub_74396`): arg 1 → `B0CC=1` (`0x0743BC fc 01 6a 8c b0 cc`), arg 0
→ `B0CC=0` + DSP re-init `sub_56046` (`0x0743CC`); and it is accepted only when
the operating band's comm mode ≠ 0 and the DSP link is initialised (`B0A4.b2`).
So `1C 03` reaches the air only as a **remote/service-commanded fixed TX**: a host
sends `']' 1`, then a PTT (or software key) in a digital mode runs session `0x15`.
This confirms doc 93 (K11) by code.

**No vendor trace name for `1C`.** The CPU→DSP trace formatter `sub_5A506` has
cases for `06/07/08/09/0A/0B/11/12/15/16/18/19/1A/1D/1F/31/32` but **none for
`0x1C`** — it falls to the default `0x5AD8C`. The "DATA TEXT SET" label that
doc 06 / K11 attached to opcode `1C` is the name of the DSP→MAIN **event `0x9C`**
(doc 52), a different opcode. *Correction, Confirmed.*

### 3. T4 — the analog answer-back carrier (Confirmed constants; role Inferred)

Doc 86 left open "how long the T4 carrier stays up." It is a tone sequence on the
analog path, not a DSP session.

- **Pre-answer hold-off.** On a code match the band arms `FF9578` (band A) /
  `FF9589` (band B) = `0xC8` = 200 ticks. Both are in the 10 ms fast tier, so the
  radio waits **2.0 s** after the match before it answers (doc 86 C24/C26;
  stores `0x03013C`, `0x031BEE`).
- **Keying.** The fire path (`sub_3019E` / `sub_31C52`) sets `AAD1.b0 = 1`,
  `AACE = 5` (`0x030242`/`0x031CD4` `fc 05 6a 8c aa ce`), `AACF = 1`, `FF94C0 = 1`
  — `AACF` is the software TX request (no `B0BE`).
- **Carrier pacing.** The TX-hold state `sub_34CCE` (`l9_pass2.txt` ll. 386–410
  and the state dump) decrements `AACE` once per element, gated by `FF9579 == 0`
  and the TX-phase reader `sub_3EF6E == 7`. Between elements `sub_34BCA` reloads:

  ```
  034BD8  ac 07 46 16         cmp.b #7 ; bne (skip)          ; only when TX phase == 7
  034BDC  fc 32 6a 8c 95 79   mov.b #0x32,r4l ; @0xFF9579    ; FF9579 = 50 (10 ms tier = 500 ms)
  034BE2  6a 0b 89 6a …       tone word = word_35158[FF896A or FF896B]  ; alternating via AAD1.b7
  ```

  When `AACE` hits 0, `sub_34CCE` clears `AAD1.b0` and `jsr sub_227BC`
  (`0x034D16`–`0x034D1C`), the TX release.
- **Carrier length = AACE (5) × FF9579 (0x32 = 50 × 10 ms = 500 ms) ≈ 2.5 s**,
  transmitting an alternating two-tone answer-back (tones `FF896A`/`FF896B`,
  selected per element by toggling `AAD1.b7` at `0x034D22`). The two tone cells
  and the enable `FF89C3.b2` come from the F345 setting packer (doc 86 C28;
  `FF8968`–`FF896B`). The 10 ms tier is byte-proven in doc 76.
- **Session used:** none. T4 is the analog FM path; it never touches a DSP `B0BE`
  session or the `1C` opcode. (Role "answer-back tone burst" Inferred from the
  two-tone generator and the code-match arm; the constants are Confirmed.)

### 4. B0B9 census and the `0x1E` root (Confirmed)

All 19 `B0B9` immediate stores match `b0b9-census.tsv` (`b0b9-writers.tsv` has the
full table). The one row doc 86 left "not traced", `0x1E`:

```
sub_67FCE 0x067FCE : …sub_22FEE->sub_2244C (SW TX req); B0B9=0x1E (067FEE fc 1e);
                     copy 15 B unk_59B3F -> FF1489; FF1498="00"; FF149A=0xFF; jsr sub_67F6E
  unk_59B3F = 20 20 20 20 20 2a 2a 2a 2a 2a 2a 2a 2a 2a 2a  "     **********"  (10-'*' ALL/group)
sub_67FB6 0x067FB6 : btst #7,@A9EE; beq beep; @FF8DD7==0 -> beep; else bsr sub_67FCE
sub_664C2 0x0664C2 : if B3EA==7 -> jsr sub_67FB6        ; B3EA = WIRES-X op state
  only caller: jsr @er6 @0x010982 in sub_1079E (KEY dispatcher); key-table slot .long sub_664C2 @0x0113E4
```

So **`B0B9=0x1E` (GM/WIRES-X air letter `j`, addressed to the all/group target) is
a keypress action on a WIRES-X screen** (state `B3EA==7`, gated by `A9EE.b7` and
`FF8DD7 ≠ 0`). It keys TX through the normal software-request path
(`sub_22FEE`→`sub_2244C`), but its root is a key, so **it cannot transmit without a
keypress.** Its exact UI label (likely a WIRES-X all-call / disconnect-from-all
command) is Inferred from the `'*'×10` target; the instructions are Confirmed.

The complete keyless-TX set among B0B9 writers is unchanged from doc 86: `0x16`
(GM beacon, timer) and `0x19` (delivery ACK, RX-triggered); `0x20` is
host-commanded over SCI-A. Everything else is user/key or flow-internal.

### 5. Proposed labels (proposals only; no ledger change)

All routines here were already named `sub_*` in the K1 seed; this lane added no
reached code (**+0 B**). Proposed RAM-cell names for a future seed:

| Cell | Proposed name | Evidence |
| --- | --- | --- |
| `FFB0B8` | `dsp_op1C_subop` | sole writer `0x05C442`=3; read by `sub_5A040` |
| `FFFFAACE` | `ansback_elem_count` | `=5` at fire; decremented in `sub_34CCE`; 0 → `sub_227BC` |
| `FFFF9579` | `ansback_elem_timer` | `=0x32` in `sub_34BCA`; gates `AACE` decrement |
| `FFFF9578`/`FFFF9589` | `ansback_delay_a`/`_b` | `=0xC8` pre-answer hold-off |
| `FFFF896A`/`FFFF896B` | `ansback_tone_0`/`_1` | indexed into `word_35158` by `AAD1.b7` |

## USB relevance

- **Q1 (USB): none.** Every routine here is outside `0xFFEE00`–`0xFFEE53` and
  outside the closed window. `1C 03` rides the SCI-C DSP link; the answer-back is
  analog FM keying; the `0x1E` path is the MAIN↔SUB/key UI and the SCI-A `']'`
  command.
- **Q2 (SDR): unchanged no.** `1C 03` is a 32-byte control frame with an empty
  payload. The answer-back carries two audio tones, not samples. Nothing here
  moves IQ.
- **Q3 (DSP): narrower, as expected.** The only runtime path to opcode `0x1C` is
  session `0x15`, a fixed 11-step script armed by host command `']'` in a digital
  mode; it always sends sub-op `3` with an empty payload. There is still no path
  from any UI or host frame to an arbitrary `1C` sub-op or payload — the `9`/`0x0D`
  payload branches have no writer. The DSP's interpretation of `1C 03` is Unknown
  (no DSP image in this package).

## Open

1. **DSP-side meaning of `1C 03`.** Unknown without DSP firmware. It sits between
   `12`/`1A 01` and TXON in the remote/service TX (session `0x15`), so it is
   plausibly a "prepare fixed/service transmission" command (Inferred, weak).
2. **The `j` key action's screen and label.** Pin which WIRES-X screen key-table
   slot `0x0113E4` belongs to and what the all/group `j` frame commands (needs the
   home key-table resolver work, RESUME open item 3).
3. **Confirm the answer-back is ARTS/paging answer-back** by naming `FF8968`–`896B`
   and `FF89C3.b2` against the SUB menu (F345); and re-check the first-element
   timing (whether `FF9579` is 0 on entry, which would make the first of the five
   elements shorter than 500 ms).
