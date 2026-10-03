# M wave — lane prompts (15 lanes, docs 113–127)

Written 2026-10-03 by the orchestrator after the L wave. At launch, each lane's prompt is the
**Shared preamble** below, followed by that lane's section, sent verbatim to one `general-purpose`
agent with **no model override** (see the memory note on the model selector). All 14 launch in one
message, in the background.

---

## Shared preamble

```text
SCOPE (read first): This is owner-side static reverse engineering of the owner's own Yaesu FT3DR/FT3DE ver 1.02 radio firmware, for the owner's own understanding and documentation. It is strictly read-only static analysis of image files already on disk, using IDA 9.1 and Python. Nothing is ever written, flashed, transmitted to, or connected with any radio or device; no serial/USB/device access or enumeration; no firmware image is modified.

Workspace: the repository root. Read first: docs\deep\BRIEF.md (shared context, tooling, rules, evidence standard, doc format), then the "L wave" section at the top of docs\deep\RESUME-FULL.md, then ida\out\l-wave-recon\README.md. Shell: PowerShell (chain with `;`, never `&&`) or the Bash tool. In Python `re`, escape opcode bytes (0x5E is `^`): prefer bytes.find over regex for byte patterns.

Rules:
- Never modify Firmware\ or decrypted\*.bin (sha256 MAIN 8e3ecd05409b2c31…, SUB b93570b3c2f69ccb…).
- Run IDA only via: python "ida/run_job.py" --script ida\jobs\<yourjob>.py --db <YOURDB> --copy-from ida\db\jobs\<SEED>\<SEED>.i64 ; iterate with --reopen. Your --db name is yours alone. Never open another database directly (not ida\db\radio\*, not ida\db\FT3D_*.i64, not a seed in place, not another lane's DB). Never run run_ida.py. Jobs must auto_wait() after edits, write a traceback file on exception, and end with idc.qexit(0).
- Seeds: MAIN = ida\db\jobs\L1_MAIN_FINAL5\L1_MAIN_FINAL5.i64 ; SUB = ida\db\jobs\K7_SUB_FINAL3\K7_SUB_FINAL3.i64 (SUB labels map via ida\out\sub-final3\alias-final3.tsv and ida\out\sub-final2\alias.tsv).
- Do not edit any existing doc or another lane's output. Write only: your doc under docs\deep\, your dir under ida\out\, your job scripts ida\jobs\<prefix>_*.py, and your scratchpad.
- Evidence: every claim cites file offset / mapped address / bytes, labelled Confirmed / Inferred / Not found (state scope) / Unknown. MAIN is H8SX big-endian, base 0 (h8sxa module; abs16 operands sign-extend to 0xFFFF8xxx). SUB is RX little-endian at 0xFFC00000 (file offset = addr − 0xFFC00000; IDA prints some unsigned imm8 as signed, e.g. #-20h = 0xE0). Byte-check every citation you write against the image with a script, and keep that script in your ida\out dir.
- Current ledger (proposed MAIN_FINAL6 masks, ida\out\l-wave-recon\): MAIN proven 364,786, named 501,656 / 505,684, SUB window code 464,263, headline 965,919 / 1,029,972 = 93.78%. Byte proposals are proposals only: never rewrite published masks or seeds.
- Doc format per BRIEF: Verdict / Method / Findings / USB relevance / Open.
- Final message: compact summary — verdict, top findings with addresses+bytes, exact proven/named byte deltas with ranges, every correction to an earlier doc (with bytes), files written, and the exact model ID you are running as.
```

---

## M1 — MAIN_FINAL6 seed

```text
YOUR LANE — M1, MAIN_FINAL6 seed. Prefix m1_. DB: M1_MAIN_FINAL6. Seed: L1_MAIN_FINAL5. Doc: docs\deep\113-main-final6-seed.md. Tables: ida\out\main-final6\.

Build the next MAIN seed so that its masks equal ida\out\l-wave-recon\final6_proven_mask.bin (364,786 set, sha256 ecd7deaf54da6d21…) and final6_named_mask.bin (501,656 set, sha256 fe8f60996e0a5852…). Follow the recipe in ida\out\l-wave-recon\README.md: drop the H9 fnindex seeds inside drop_runs.tsv; add the 8 entry points (0x018250, 0x018ABE, 0x01A094, 0x05E8E0, 0x066FB4, 0x067250, 0x066FBE, 0x06726A); retype as data the data-mistyped runs from ida\out\fnindex-lo|mid|hi\proposed-demotions.tsv (L2 80 B, L3 144 B, L4 26 B); apply L5's Confirmed typing (ida\out\main-unnamed\proposed-typing.tsv rows with typing_conf = Confirmed; L5's job ida\jobs\l5_apply_typing.py was written for a FINAL4 copy — adapt it and re-check its 22 skipped rows against the opened service window). Read docs 98 (L1), 99–102 and ida\jobs\l1_apply_main_final5.py, ida\out\main-final4\offline\k1_build_masks.py, ida\out\l-wave-recon\recon_descent.py.
Re-derive both masks from ONE run (offline descent + DB typing) and require byte equality with the two published files; if they differ, list every differing byte range and why. Investigate L5's 4 B stale-head gap (0x006A0C 6a 10 8e a0 73 40, 0x0077F8 6a 10 81 7e 77 00): fix the heads in the DB; credit the bytes to proven only if the descent then reaches them. Prove the DB is a fixed point (reopen delta zero, layout hash, 0 odd heads). Report the new seed path, layout hash, popcounts and sha256 of the masks you write to ida\out\main-final6\.
```

## M2 — proven-but-unreached audit, below 0x030000

```text
YOUR LANE — M2, proven-but-unreached runs below 0x030000. Prefix m2_. DB: M2_PUNR_LO. Seed: L1_MAIN_FINAL5. Doc: docs\deep\114-proven-unreached-lo.md. Tables: ida\out\punr-lo\.

Input: ida\out\l-wave-recon\proven-unreached-runs.tsv (80 runs, 1,692 B): bytes set in final4_proven_mask.bin (and still in the proposed final6 mask) that K1's full folded descent does NOT reach. They were proven by H9's analyze rules (ida\out\main-descent\offline\analyze.py — read it and state which rule proves each run), not by the descent. Your scope: the 29 runs (368 B) with start < 0x030000, plus L2's two companion runs 0x0076D8–0x0076DF (8 B) and 0x01C27E–0x01C293 (22 B) (doc 99).
Method as in docs 99/100/101 (read them): for each run find every inbound path whole-image — BE32 pointers at any offset, abs24 jsr/jmp, 8/16-bit relative branches and bsr, @@aa:8, @(d,ERn)/@er6/@er1 table and helper dispatch (doc 70, doc 83 helper rule, L2's sub_15206 er1 rule), RAM-cell callbacks (doc 60), switch tables (ida\out\main-full\jumptables.tsv, switch_tables.tsv), fall-through. Reuse L2's offline tools (ida\out\fnindex-lo\offline\) and L2's descent pickle approach. Classify each run REACHED (cite the edge and say which descent rule is missing) / DEAD / SPLIT-TAIL / DATA-MISTYPED / UNCERTAIN. Write runs.tsv, proposed-demotions.tsv (exact ranges, byte sums), proposed-rules.tsv (any new descent rule that would reach REACHED runs, with every site it would add). Proposals only.
```

## M3 — proven-but-unreached audit, 0x030000–0x057FFF

```text
YOUR LANE — M3, proven-but-unreached runs 0x030000–0x057FFF. Prefix m3_. DB: M3_PUNR_MID. Seed: L1_MAIN_FINAL5. Doc: docs\deep\115-proven-unreached-mid.md. Tables: ida\out\punr-mid\.

Input: ida\out\l-wave-recon\proven-unreached-runs.tsv (80 runs, 1,692 B): bytes set in final4_proven_mask.bin (and still in the proposed final6 mask) that K1's full folded descent does NOT reach. They were proven by H9's analyze rules (ida\out\main-descent\offline\analyze.py — read it and state which rule proves each run), not by the descent. Your scope: the 22 runs (574 B) with 0x030000 <= start < 0x058000. This includes L3's 116 B companions (0x045D88–0x045D8D, 0x0460C2–0x04612F; doc 100) — the 0x0460C2 block is skipped by the unconditional bra at 0x0460C0 (40 6e).
Method as in docs 99/100/101 (read them): for each run find every inbound path whole-image — BE32 pointers at any offset, abs24 jsr/jmp, 8/16-bit relative branches and bsr, @@aa:8, @(d,ERn)/@er6/@er1 table and helper dispatch (doc 70, doc 83 helper rule, L2's sub_15206 er1 rule), RAM-cell callbacks (doc 60), switch tables (ida\out\main-full\jumptables.tsv, switch_tables.tsv), fall-through. Reuse L3's offline tools (ida\out\fnindex-mid\offline\). Classify each run REACHED (cite the edge and say which descent rule is missing) / DEAD / SPLIT-TAIL / DATA-MISTYPED / UNCERTAIN. Write runs.tsv, proposed-demotions.tsv (exact ranges, byte sums), proposed-rules.tsv. Proposals only.
```

## M4 — proven-but-unreached audit, 0x058000 and above

```text
YOUR LANE — M4, proven-but-unreached runs at 0x058000 and above. Prefix m4_. DB: M4_PUNR_HI. Seed: L1_MAIN_FINAL5. Doc: docs\deep\116-proven-unreached-hi.md. Tables: ida\out\punr-hi\.

Input: ida\out\l-wave-recon\proven-unreached-runs.tsv (80 runs, 1,692 B): bytes set in final4_proven_mask.bin (and still in the proposed final6 mask) that K1's full folded descent does NOT reach. They were proven by H9's analyze rules (ida\out\main-descent\offline\analyze.py — read it and state which rule proves each run), not by the descent. Your scope: the 29 runs with start >= 0x058000: 16 runs (530 B) below the service window, including the largest run 0x05C8DC (218 B) and the WIRES-X parser case bodies that call 0x066FB4/0x066FBE/0x067250/0x06726A (callers 0x062808, 0x06723A, 0x06AB1C–0x06AB36, 0x06ADF6–0x06AE10), plus the 13 runs (220 B) inside the service window 0x078106–0x07B753 (the "closed window 220 B" of earlier ledgers; read doc 95 and say how they relate to doc 95's 868 B and to the window's entry conditions).
Method as in docs 99/100/101 (read them): every inbound path whole-image — BE32 pointers at any offset, abs24 jsr/jmp, relative branches and bsr, @@aa:8, @(d,ERn)/@er6/@er1 dispatch (doc 70, doc 83, L2's sub_15206 rule), the node-command tables off_74472 / off_73974 (doc 104), the framed-protocol parser (docs 91/92), RAM-cell callbacks (doc 60), switch tables, fall-through. Reuse L4's offline approach (doc 101). For the WIRES-X parser bodies, establish the real dispatch edge into them (which switch/jump table or indexed jmp) and propose the descent rule that would reach them. Classify each run REACHED / WINDOW-ONLY / DEAD / SPLIT-TAIL / DATA-MISTYPED / UNCERTAIN. Write runs.tsv, proposed-demotions.tsv, proposed-rules.tsv. Proposals only. Flag anything USB-relevant.
```

## M5 — L5's Inferred dead code and proven-data candidates

```text
YOUR LANE — M5, upgrade L5's Inferred dead-code tier. Prefix m5_. DB: M5_DEADCODE. Seed: L1_MAIN_FINAL5. Doc: docs\deep\117-dead-code-tier.md. Tables: ida\out\dead-code-tier\.

Read docs\deep\102-main-unnamed-residue.md and ida\out\main-unnamed\ (runs.tsv, proposed-typing.tsv, proven-data-candidates.tsv). L5 classed 2,880 B in 135 pieces as dead code with typing Inferred (55 unreferenced routines 1,696 B, e.g. 0x00835E 174 B; 76 fragments after a terminator 1,052 B incl. 18 `jsr @0x3FFA0` stubs skipped by `bra .+4`; 4 pieces 132 B reached only from named-but-unproven code: 0x06259A, 0x01758E, 0x076C06, 0x01E1C6).
Task 1: for every piece, re-prove (a) it decodes cleanly as H8SX from its start to a terminator with every instruction boundary inside the piece, and (b) it has no inbound edge whole-image (BE32 at any offset, abs24 jsr/jmp, relative branch/bsr, @@aa:8, table/helper/er1 dispatch, RAM-cell callbacks, switch tables, fall-through). Upgrade to Confirmed where both hold; keep Inferred with the reason otherwise. Under the project convention (I12, doc 69), unreachable code typed as code counts as named — state the named delta exactly.
Task 2: L5's proven-data candidates — 126 B Confirmed are already handled in the L-wave reconciliation (check which ones are in ida\out\l-wave-recon\drop_runs.tsv); decide the other 120 B Inferred candidates with reader evidence (a proven load of the address as data) and propose proven demotions for those that are data.
Apply the Confirmed typing on your private DB to show it is byte-neutral for proven code. Write pieces.tsv, proposed-typing.tsv, proposed-demotions.tsv. Proposals only.
```

## M6 — L5's Inferred tables, records and labels

```text
YOUR LANE — M6, upgrade L5's Inferred table/record tier. Prefix m6_. DB: M6_TABLES. Seed: L1_MAIN_FINAL5. Doc: docs\deep\118-inferred-tables.md. Tables: ida\out\inferred-tables\.

Read docs\deep\102-main-unnamed-residue.md and ida\out\main-unnamed\ (runs.tsv, proposed-typing.tsv, class-summary.tsv). L5's Inferred typing tier, excluding dead code, is ~1,054 B: value tables 957 B (typed from content only), pointer tables 32 B, labels 11 B, and the 54 B record-field target 0x01687E (record 0x01686E = {0x01A17C, NULL, 0x01687E, 0x0168BC} handed to 0x015260 from proven 0x016864 `7a 05 00 01 68 6e 5a 01 52 60`). Also the 43 B unnameable fragment 0x069A7F–0x069AA9.
For each piece: find the reader (a proven instruction that loads the address or a base + bounded index covering it, including mov.l #imm, @(d:32,ERn), @(d:16,ERn) table bases, eepmov sources, sub_3F768 / sub_3F5EE / sub_3F5B2-style list and range helpers) and the element type/stride, and upgrade to Confirmed or explain. For 0x01687E, decode 0x015260 and decide whether field +8 is called (then the 54 B are proven code). For 0x069A7F, find whether a correctly-aligned copy of the same bytes exists elsewhere in the image and say what it is a stale copy of. Write pieces.tsv and proposed-typing.tsv with the named delta; proposed-proven.tsv if 0x01687E is reached. Proposals only.
```

## M7 — the CDC-ACM personality past 0x07827C

```text
YOUR LANE — M7, CDC-ACM device personality. Prefix m7_. DB: M7_CDC. Seed: L1_MAIN_FINAL5 (its service window is opened to 336 code heads). Doc: docs\deep\119-cdc-personality.md. Tables: ida\out\cdc-personality\.

Read docs\deep\95-service-window.md and ida\out\service-window\, 112-c-reconstruction.md and ida\out\c-recon\l15_usb_vendor.c (vector 234 ISR jsr 0x07827C when FF813A != 0), 64, 72 (USB module 0x076C0A–0x076FC7 reachable only from the window via the pointer array 0x07B4C0+), 75, 101 (L4: 0x077CC2 / 0x07778C), 98, and BRIEF correction 1 (CDC descriptor VID 0x26AA PID 0x0020 at 0x07B680).
Task: decode the CDC-ACM personality as far as the bytes go, entirely by static reading: the handler records copied to RAM FF6242 (flash 0x07B4B4, stride 10), each handler's role, the class requests it answers (SET_LINE_CODING / GET_LINE_CODING / SET_CONTROL_LINE_STATE or others — cite the bRequest compares), endpoints and buffer addresses, what bytes flow between the CDC data endpoints and which on-chip link (SCI-C DSP 0xFFFF88, SCI-A, or other) — i.e. what the PC side of this virtual COM port talks to — and the exact entry conditions (0x7D strap at 0x002200, FF813A, DSP-WRITE state >= 5). Write hand-reconstructed C for the CDC request handler and the data pump as documentation only, under ida\out\cdc-personality\. State whether this path can write program flash (BRIEF correction 7 says neither application writes its own flash — re-test it here) and whether it carries any sample/IQ stream (expected no). Report proven/named byte deltas (proposals only).
```

## M8 — AN1 sensor, popup 0x23, and the tone timers

```text
YOUR LANE — M8, AN1 TX foldback sensor and TX tone generation. Prefix m8_. DBs: M8_TONES (MAIN, seed L1_MAIN_FINAL5) and, for labels, M8_TONES_SUB (SUB, seed K7_SUB_FINAL3). Doc: docs\deep\120-an1-and-tones.md. Tables: ida\out\an1-tones\.

Read docs\deep\105-tx-states.md and ida\out\tx-states\ (L8: during TX, AN1 sampled every 80 ms at 0x034544 / 0x034556 into A996; sub_35BAA at 0x035BBA `ac eb 45 54 ac ef 45 1c ac f4 45 20`: 0xEB+ power <= 1, 0xEF+ power 0, 0xF4+ error tone and forced TX end via sub_34F74, trip latched in AAD9; each step plays tone 0x32 and shows popup 0x23), 93, 76 (TPU tick math), 52.
Task 1: identify the AN1 sensor as far as bytes allow — every other AN1 reader outside TX, the A/D channel setup, any display/menu that shows a temperature or a related value, the popup 0x23 text (resolve MAIN popup id 0x23 → SUB string via the MAIN→SUB opcode and SUB's popup/label tables), and how AAD9 is cleared. Label PA temperature Confirmed only if a string or unit proves it.
Task 2: decode the TX tone generators L8 left Inferred: the TPU0, TPU1 and 8-bit-timer interrupt handlers (vector table at file 0x0), the CTCSS table word_35158 (50 entries ×10 Hz) through TPU1 TGRA1 = 0x0989, DCS (tone class 3, TSTR(@0xBC) b0), T-CALL (AAD6 machine, compare 0x47 — read the timer clock select to settle whether it is 1750 Hz), and the pager/two-tone class 7 used by the analog answer-back. Give the frequency math from the register values. Write sensor.tsv, tones.tsv. Proposals only for bytes.
```

## M9 — SUB↔MAIN link edge cases

```text
YOUR LANE — M9, SUB↔MAIN link edge cases. Prefix m9_. DBs: M9_LINK_MAIN (MAIN, seed L1_MAIN_FINAL5) and M9_LINK_SUB (SUB, seed K7_SUB_FINAL3). Doc: docs\deep\121-link-edge-cases.md. Tables: ida\out\link-edges\.

Read docs\deep\108-sub-frames-main.md (L11), 109-sub-frames-sub.md (L12), 107-accessory-ptt.md incl. its addendum (L10), 84, 51.
Task 1 — length mismatches (L12): SUB sends E2 as 15 B but MAIN's deframer counts 17; FF 277 vs 273; E1 (13+n) and FE (154 + data) are variable while MAIN's counts are fixed (128 / 200). For each, trace MAIN's byte-at-a-time state machine (sub_4753E, state table 0x0475C8, handlers per doc 108) on the exact byte sequence SUB emits: does the frame validate, is it dropped, does the deframer resynchronise on the next start byte, and can a short/long frame swallow or corrupt the next frame (e.g. an E6 PTT frame following an E2)? Cite the length compares and checksum checks.
Task 2 — SUB state: the meaning of SUB word 12CB8 (gate on the headset-PTT path, doc 107), which link E5 tracks (7 send sites, doc 109), and the GPS mode flag 0x8A86 set by MAIN F301/F3C0/F3C1 with frame byte +0x13 == 3, which also reprograms TPU3 (SUB 0xFFF36BE2 `f9 e9 04 1a b7`). Write frames-sim.tsv (per type: SUB bytes, MAIN state trace, outcome) and sub-state.tsv. Flag anything that can cause or prevent a TX key/unkey. Proposals only for bytes.
```

## M10 — touch and key leftovers

```text
YOUR LANE — M10, touch / key-table leftovers. Prefix m10_. DBs: M10_KEYS (MAIN, seed L1_MAIN_FINAL5) and, for labels, M10_KEYS_SUB (SUB, seed K7_SUB_FINAL3). Doc: docs\deep\122-touch-key-leftovers.md. Tables: ida\out\touch-key-leftovers\.

Read docs\deep\103-home-keytable.md and ida\out\home-keytable\ (L6; its gen\resolver.py models the resolver), 85, 84, 71, 58, 49-hidden-settings.md.
Tasks: (1) name operating modes [A9F9] = 1, 3, 8 and 10 and the F7 pages (state 7 → F701, state 8 → F703; GM is a candidate for mode 10, unproven) from SUB labels reached by each page's screen-handler closure; (2) decode band-record byte rec+5 used by sub_10CC4's home-table choice; (3) re-check with L6's resolver the 156 K3-joined rows on the F0/F2/F3/F5 pages that L6 left on K3's join, and correct any; (4) resolve the 37 indirect @erN sites inside L6's depth-4 descent of the zone handlers; (5) name records 0x0296E8 (16-char name) and 0x029712 (4-char item) on page F112 / screen 0x0A. Re-test at every new edge that no zone or key opens a hidden or service screen, the service window, a USB register or SCI-C. Update counts of the 511 zones by status in zones-final.tsv. Proposals only for bytes.
```

## M11 — MAIN small unknowns

```text
YOUR LANE — M11, MAIN small unknowns. Prefix m11_. DB: M11_SMALL. Seed: L1_MAIN_FINAL5. Doc: docs\deep\123-main-small-unknowns.md. Tables: ida\out\main-small\.

Resolve each with bytes, or say Unknown with the scope searched:
1. The key-machine guard FF910A == 0x00066600 (docs 49-key-sequence-hidden.md, 112): every writer of FF910A–FF910D, what the value means (a frequency in BCD/10 Hz? a model code?), and when the guard is true.
2. Key event 13 (doc 105: sub_346DE skips the tone-sequencer wait): the raw key code behind it and its translator path (0x00FBD4 table, doc 107).
3. Labels for FF8920 bit 7 and BB8F bit 7 (doc 107) and the SUB status byte FF3D8C bit 5 gate.
4. The VOX-value table 0x007E2C–0x007E31 `00 28 14 2d 18 00` read via 0x007E0A `78 50 6a 2b 00 00 7e 2c` (doc 107 candidate, 6 B): prove the index bound and propose named/proven credit.
5. AAD2 bit 0 headset-ownership flag (doc 107 addendum): confirm every writer image-wide and whether any path clears it at TX end.
6. The node-command `'@'` arg 0x11 flag AA30 bit 4 set at 0x034A52 (doc 105 correction to doc 104): who reads AA30 b4 and what it does.
Write findings.tsv. Proposals only for bytes.
```

## M12 — SUB Bluetooth module protocol

```text
YOUR LANE — M12, Bluetooth module protocol on SUB. Prefix m12_. DBs: M12_BT_SUB (SUB, seed K7_SUB_FINAL3) and M12_BT_MAIN (MAIN, seed L1_MAIN_FINAL5) for the MAIN side. Doc: docs\deep\124-bluetooth-protocol.md. Tables: ida\out\bluetooth\.

Read docs\deep\107-accessory-ptt.md incl. addendum and ida\out\accessory-ptt\ (e6-sites.tsv), 109-sub-frames-sub.md (Bluetooth on SUB channel 2 = SCI3 at 0x8A060, command sender sub_FFF3B630, E4 29-B records, codes 0–5, 9, 0x10–0x13), 108, 14-bluetooth-gps-wiresx.md and its bt_commands table.
Task: decode the full host↔module protocol: every command string SUB sends (SCAN=, SCOL=, LINK=, PAIR=, TXAT=, …) with the trigger, every response/indication line the line classifier accepts (RXAT=, SCOI=, …) with its handler and state effect, the pairing / link state machine (states in 122A0, 12CBC, 12CB8, 12CC2, 1229D), and the MAIN→SUB ops F3D2 / F3D5 / F3D6 that drive it. Name the module family only if a string proves it (else Inferred). Owner-relevant: list every path by which anything received from the Bluetooth module can change radio state on MAIN (PTT, audio routing, settings), with the gates; confirm or refute that CKPD=200 is the only TX-keying input. No USB expected — confirm. Write commands.tsv, indications.tsv, states.tsv. Proposals only for bytes.
```

## M13 — L-wave re-verification

```text
YOUR LANE — M13, independent re-verification of the L wave. Prefix m13_. DB only if needed (M13_REVERIFY_MAIN / _SUB). Doc: docs\deep\125-ledger-reverify-l.md. Tables: ida\out\ledger-reverify-l\.

Model this on docs\deep\110-ledger-reverify-k.md and 94-ledger-reverify-j.md.
(1) Re-derive the L-wave ledger from disk independently: L1's final5 masks (369,214 / 498,319; diffs −278 at 0x054AE2–0x054BF7 and +868 in the 13 window ranges), and the proposed final6 masks in ida\out\l-wave-recon\ (364,786 / 501,656): reproduce them yourself from fnindex-only-runs.tsv, the L2/L3/L4 classifications, the 8 entry points, the descent (ida\out\l-wave-recon\recon_descent.py and K1's builder) and L5's Confirmed typing — do not just re-count the files. Check proven ⊆ named, nothing above 0x07B754, the per-lane split 884 / 2,532 / 1,012, and the headline 965,919 / 1,029,972.
(2) Extract every byte citation from docs 98–112 and the L-wave section of RESUME-FULL.md and check each against the images: pass / right bytes wrong address (give the true address) / fail / uncheckable. Include L10's addendum and ida\out\l-wave-recon\README.md.
(3) Re-run every offline checker the L lanes left (e.g. ida\out\accessory-ptt\verify.py, ida\out\errata-j\l14_errata_check.py, ida\out\ledger-reverify-k\*.py, ida\out\tx-states\build_tables.py, ida\out\c-recon\citations.tsv) from a scratch copy with redirected outputs and compare.
Write citations.tsv, counts.tsv, rerun.tsv. Errata go in your doc only.
```

## M14 — errata and correction index for the K and L waves

```text
YOUR LANE — M14, consolidated errata and correction index. Prefix m14_ (Python only; IDA not normally needed). Doc: docs\deep\126-errata-k-l.md. Tables: ida\out\errata-k-l\. OWNER DECISION: do not edit any existing doc; write a separate errata document only.

Model this on docs\deep\111-errata-j.md and ida\out\errata-j\.
Section 1 — K wave and follow-up docs 83–97: every non-pass item in docs\deep\110-ledger-reverify-k.md / ida\out\ledger-reverify-k\citations.tsv and counts.tsv (5 address slips, 2 mnemonic slips, 3 wrong counts, the doc 83:200 wording item and the doc 93:99 scope note): re-read the bytes yourself and write the corrected citation (doc, line, as written, corrected, class, credited byte affected?).
Section 2 — L-wave lane citation slips recorded in RESUME-FULL.md's L-wave section (L7: 0x073E86, 0x073E8E, table load 0x073A34; L9: 0x0743BA, 0x030240, 0x031CD2): verify each against the image and against the line in the owning doc (docs 104, 106).
Section 3 — index of every L-wave correction to older docs (RESUME-FULL.md "Corrections recorded this wave" under the L wave: docs 06, 14, 51, 57, 77, 84, 85, 86, 93, 95, 104): for each, the statement in the old doc (doc and line, quoted and text-checked), the superseding doc and line, and one anchor byte run re-read from the image.
Byte-check and text-check every row with a script kept in your ida\out dir. Write errata.tsv, bytecheck.tsv, index.tsv.
```

## M15 — SUB code-window residue and SUB ledger (added 2026-10-03 at launch)

```text
YOUR LANE — M15, SUB code-window residue and SUB ledger. Prefix m15_. DB: M15_SUB_RESIDUE. Seed: K7_SUB_FINAL3. Doc: docs\deep\127-sub-residue-final.md. Tables: ida\out\sub-residue-final\.

Re-prove each run of I10's 3,736 B SUB residue (3,692 dead-orphan + 43 fragment + 1) as DEAD / REACHED / DATA / FRAGMENT / UNCERTAIN with a whole-image inbound-edge search (LE32 pointers, branches/calls, jsr/jmp Rn from constants, switch tables, fixed and relocatable vector tables, RAM callbacks); recount the 524,288 B window and the 60,025 B gap by class; propose (only) what SUB's figure would be under the MAIN I12 convention and with code + typed data. Confirm no residue run touches the USB module.
```

---

## Orchestrator steps at launch and after

1. Re-check both image sha256 (`8e3ecd05…`, `b93570b3…`) and that `L1_MAIN_FINAL5.i64` and `K7_SUB_FINAL3.i64` exist.
2. Launch all 15 lanes in one message (preamble + lane section, verbatim; no model override).
3. As each lane reports: re-read its key byte runs from the images, re-run any checker it left, and
   note conflicts between lanes (M2–M4 with M1; M5/M6 with M1's typing; M9/M12 with L10–L12).
4. When all 15 are in: decide every proposal with bytes, re-derive the masks from one descent (as in
   `ida\out\l-wave-recon\`), update `docs\deep\RESUME-FULL.md` and `resume.md`, record each lane's
   reported model, and report to the owner.
