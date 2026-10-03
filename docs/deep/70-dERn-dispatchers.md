# 70 — The pointer-array-rooted `@(d,ERn)` / `@ERn` dispatchers (Lane J2)

Owner-side static analysis of firmware already on disk. No device, USB, serial or flash
access; nothing was written to or connected with a radio, and no image byte was modified.
MAIN is H8SX (IDA proc `h8sxa`/`h8s300a`), big-endian, base 0, so file offset = mapped
address. Content ends below `0x07B754`. The closed CDC/DSP-download window
`0x078106`–`0x07B753` is a project boundary; its one dispatch site (`0x078308`) is listed,
not resolved. Model: **claude-opus-4-8**.

Private DB `J2_DERN` was prepared (`--copy-from ida\db\jobs\MAIN_FINAL2\MAIN_FINAL2.i64`)
but the task resolved fully from on-disk inputs (the image, H9's reached-instruction stream,
the FINAL2 proven mask, and the I8/H3/I15 tables) without needing an IDA edit pass, so no
DB write or re-plan was performed. No shared DB was opened.

Tables in `ida\out\dern-dispatch\`:
- `sites.tsv` — all 188 sites: jump, kind, jump-reg, load form (d32/d16), table root, load
  address, index reg, **selector variable**, reached Y/N, in-window, I8 form, H3 tier, slot
  count, target count, n_new-vs-FINAL2, new targets, full target set.
- `families.tsv` — the 173 distinct table roots, each with its sites, selector(s), target
  count, reached/unreached split, H3 tier, and net-new count.
- `new-targets.tsv` — the single genuinely-new target (`0x04E2D6`) with code/data extents,
  terminator, the sites and table slots that reach it, and its role.

## Verdict

The "other 174 `@(d,ERn)` register-table dispatchers" are now fully enumerated and the
family boundaries named. A raw-byte scan of `0x400`–`0x7B754` for the H8SX indexed-pointer
load (`78 b0 6b 26` MOV.L `@(d:32,ERs),ERd`, and its 16-bit-displacement sibling
`01 00 6f sd` MOV.L `@(d:16,ERs),ERd`) **immediately feeding a `jmp/jsr @ERd`** finds exactly
**188 sites over 173 distinct table roots**: **174 are reached** (and are *precisely* I8's 166
`rom_table_indexed` + 7 `struct_member` + 1 `closed_window` — zero reached sites fall outside
I8's set, so nothing is double-counted), and **14 are reached-by-nothing** dispatch sites
outside the closed window that I8 never saw because H9's descent never reached the jump
itself. Resolving every one of the 173 table roots against **MAIN_FINAL2's proven mask**
(sum = 368,432 B) yields **exactly one genuinely-new proven target in the whole class**:
`0x04E2D6`, a clean **72-byte** weather/sensor (rain-gauge + barometer) label-display handler
sitting as **slot 68 of the sensor-display dispatch table `0x04ABE4`** (selector = RAM byte
`0xFF9DFF`), reached by `jsr @er6` at `0x052232`. It was missed because **I8's walk of table
`0x04ABE4` truncated before slot 68** and no fall-through path reaches it — it is surrounded
by label-string data. **Net new proven code: +72 B (368,432 → 368,504).** The 14 unreached
dispatchers and all other 173 roots resolve entirely to handlers already in the FINAL2 mask;
I8's own +182 B is already folded into FINAL2 (verified). **No new USB, SDR or DSP surface:**
the one new handler reads `0xFFBBE9` and prints a pressure/rain label — ordinary UI.

## Method

1. **Definition.** The task's "pointer-array root" is the H8SX indexed-pointer load whose
   displacement is the table base and whose index register (`er3`/`er4`) is a scaled table
   index. Two encodings: `78 [1sss]0 6b 2d <d32>` (table base ≥ 0x8000) and
   `01 00 6f [s][d] <d16>` (base < 0x8000). Both appear in H9's reached stream as
   `mov.l @(0x…:32,erS),erD` / `@(0x…:16,erS),erD`. Encodings byte-verified against the image
   (e.g. `0x054FF8 = 78 b0 6b 26 00 05 50 02 59 60`; `0x028D24 = 01 00 6f 16 00 04`).
2. **Raw scan.** For every address in `0x400`–`0x7B754` matching either load form, I required
   a `jmp @erD` (`59 d0`) or `jsr @erD` (`5d d0`) within 14 bytes on the same dest register.
   188 sites, 173 roots. Each site's reached/unreached status is the membership of its jump
   address in H9's `reached_insns.tsv` (2,925,841-byte decoded stream, the same source I8
   used). The selector (the mode/state variable that indexes the table) is the nearest
   preceding `mov.b/@…` before the `and.l #0xFF / shll.l #2 / <load>` idiom.
3. **Target resolution.** Each root is walked as a BE32 array (nulls and the `0x3FFA0`
   frame-builder sentinel skipped, stopping at the first non-pointer slot or the next known
   root). Every slot pointer is checked against FINAL2's `final2_proven_mask.bin` per byte.
4. **New-target proof.** A slot pointer with `proven==0` is only credited when it is
   *sandwiched* — a proven table slot within ±3 slots — which excludes read-past-end false
   positives. One target survived (`0x04E2D6`); it was then hand-decoded from the image to its
   `rts` and its code/data boundary pinned.
5. **Cross-checks.** Reconciled site-by-site against `ida\out\indirect-cb\sites.tsv` (I8),
   `ida\out\ptr-arrays\arrays.tsv` (H3 tiers), and I15's record-dispatcher family.

**Not done / out of scope.** The closed-window site `0x078308` (`jsr @er2`, `@(6,er6)`) is
not resolved (project boundary). The `add.l idx,base; mov.l @base,er6` register-base form
(I8's 30 `reg_table`/`reg_table_unresolved`) and the four RAM-cell callbacks are a different
root class (not a `78 b0 6b 26` pointer-array load) and are left to I8/I15. Exact lengths of
the two largest packed tables (`0x00782C`/`0x007814`) are approximate in `families.tsv`
because they abut other data; I8's bounded resolution of their live index range stands.

## Findings

### 1. The 188 sites (`sites.tsv`), census

| | sites | roots |
| --- | ---: | ---: |
| d32 load (`78 b0 6b 26`) → jump | 178 | — |
| d16 load (`01 00 6f`) → jump | 10 | — |
| **reached** (⊆ I8's 267) | **174** | 165 |
| **unreached, outside closed window** | **14** | 13 |
| in closed window (I8 `closed_window`, not resolved) | 0 reached site `0x078308` counted in the 174 | — |

The 174 reached sites map exactly onto I8's classification: 166 `rom_table_indexed`,
7 `struct_member` (the `@(d,er1)` record-dispatcher family `0x028CBC`, selector `0xFFBBC2`,
I15's domain), and the 1 reached closed-window site. **No reached pointer-array dispatcher
is outside I8's set, so I re-count none of I8's bytes.**

### 2. The single new proven target (`new-targets.tsv`, Confirmed)

Site `0x052232` `jsr @er6` ← `0x05222A mov.l @(0x04ABE4:32,er3),er6`, with `er3 = @0xFF9DFF
<<2`. Table `0x04ABE4` is the sensor-display dispatcher (93+ live slots). Slot 68
(`0x04ACF4`) = `0x0004E2D6`, byte-verified. FINAL2 and H9 both leave `0x04E2D6` unproven and
I8's target list for `0x052232` truncates at `0x04CC84` — it never reached slot 68. The
handler decodes clean:

```
04E2D6 7a 05 00 04 e3 1e   mov.l #0x4E31E,er5      ; -> its own label string
04E2DC 6a 0c bb e9         mov.b @0xFFBBE9:16,r4l   ; sensor state
04E2E0 7a 64 00 00 00 ff   and.l #0xFF,er4
04E2E6 7a 06 00 ff b0 5a   mov.l #0xFFB05A,er6
       …
04E31A 5e 05 27 80         jsr  @0x052780
04E31C 54 70               rts
```

Code `0x04E2D6`–`0x04E31E` = **72 B**; immediately after it is a 16-B embedded label string
(`0x04E31E`–`0x04E32E`, "…Baro␠␠␠␠␠-hPa"; the run just above holds "RainH -.-mm / RainH
-.--in / RainD… / RainN…"). Slot 69 (`0x04E32E`) is the next, already-proven handler, so the
boundary is exact. **This is the proven-code delta: +72 B.** Reached identically as slots
97/163/183 of the overlapping earlier table `0x04AB70` (selector `0xFF9E1F`), site `0x04AB6C`.

### 3. The 14 unreached dispatchers — 0 new bytes (Confirmed)

Thirteen roots feed jumps H9 never reached (e.g. `0x0354C6`←`0x035534`, `0x05CF3A`←`0x05D028`,
the `0x062A*` cluster, and the large `0x06B1*`/`0x06B5*` cluster). **Every slot of every one
resolves to a handler already in the FINAL2 proven mask** (shared handlers such as `0x066CD0`,
`0x06B408`, `0x06B45C` recur across them). Several roots are H3 tier-A arrays
(`0x0629D2`, `0x062A9E`, `0x06B556`, `0x06B582`, `0x06B5AA`). These are alternate/sibling
dispatch entry points into already-proven handler pools, so they add call-graph edges but **no
proven bytes**.

### 4. Named families (`families.tsv`), highest-value first

Every dispatcher is `sel = <RAM/struct byte>; and.l #0xFF; shll.l #2; mov.l @(base,er_idx),er6;
jmp/jsr @er6`. Naming = the selector variable + the table.

| Root | sites | ntargets | selector | role |
| --- | ---: | ---: | --- | --- |
| `0x00782C` / `0x007814` | 4 / 1 | ~60–68 live | `@(1,er0)` / `@(5,er0)` struct field | **top-level command/event dispatcher** (entry points `0x004826`,`0x004DEE`,`0x006C3C`,`0x006C78`,`0x006E9C`) |
| `0x012268` | 1 | 2446 (KNOWN149) | `@0xFFAD68` | the known screen/menu pointer table (G2 owns its xrefs) |
| `0x04ABE4` / `0x04AB70` | 1 / 1 | 93+ | `@0xFF9DFF` / `@0xFF9E1F` | **sensor/weather display dispatcher** (holds the new `0x04E2D6`) |
| `0x061C5A`,`0x0601F4`,`0x0617EA`,`0x0618FE` | 1 each | 50/47/… | `@0xFFB3EA`, `@0xFFB39F`-area | VFO/band/mode state dispatchers (cluster at `0x0601xx`–`0x0619xx`) |
| `0x074472`,`0x0703E6`,`0x05A3CE` | 1 each | 48/45/44 | `@0xFF97FC`,`@0xFFBAA3`,`@0xFFB0B6` | menu/settings-screen dispatchers |
| `0x028CBC` (via `0x028D0C`…`0x028DA0`) | 7 | 8 fields | `@(d,er1)` on key `0xFFBBC2` | key-indexed record dispatcher (I15; +0 here) |
| `0x055002` | 1 | 10 states | `@0xFF8183` | **USB control-transfer state machine** (vector-235 handler) |
| `0x070386`,`0x055BA0`,`0x055BC8`,`0x055BF0` | 1 each | — | — | **USB image-push / vendor-stack sub-dispatch** (see §5) |

The remaining ~150 roots are single-site dispatchers (one selector, one table) and are
tabulated in `families.tsv`; their handlers are all already proven.

## USB relevance

Five of the 174 sites are the USB stack's own dispatchers, all already proven and already
named by I8/H3 — this lane only adds their selector variables:

- `0x055000` `jmp @er6` → table `0x055002`, **10 states**, selector **`@0xFF8183`**: the
  USB control-transfer state machine, immediately after the vector-235 `rte`.
- `0x055BA0` / `0x055BC8` / `0x055BF0` and `0x070386`: the image-push / vendor-class
  sub-dispatch into `0x0559xx`–`0x055Fxx` (I8 `usb-relevant.tsv`; Lane I1's feeder).

No new endpoint, descriptor, bulk/isochronous path, DSP link or self-flash appears. The one
genuinely-new handler (`0x04E2D6`) is a barometer/rain-gauge label printer and touches none of
USB `0xFFEE00`–`0xFFEE53`, SCI-C `0xFFFF88`, or the closed window. **The USB-SDR and
direct-DSP answers are unchanged** — this lane only hardens the MAIN proven figure by 72 B.

## Open

Most valuable first:
1. **Fold `0x04E2D6` (+72 B) into the MAIN proven headline** (368,432 → 368,504) and correct
   I8's table-`0x04ABE4` target set to include slot 68. It is the only byte-accounting change.
2. **Re-check the other large packed tables for I8 truncation.** My sandwich test found only
   `0x04E2D6`, but I8's walks of the biggest tables (`0x00782C`, `0x012268`) were length-capped;
   a bounded re-walk that credits every live index (tracked to each selector's range check)
   would confirm no further slot was dropped.
3. **Name the state selectors.** The dispatcher families are now tied to their selector bytes
   (`0xFF9DFF` sensors, `0xFFB3EA` VFO/band, `0xFF8183` USB control). Decoding the writers of
   each selector would name the ~150 single-site dispatchers by the mode they switch on.
4. The closed-window site `0x078308` stays CLOSED by project boundary.
