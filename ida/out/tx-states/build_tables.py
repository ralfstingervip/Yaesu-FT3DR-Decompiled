# Repository layout: this script lives under ida/out/; paths below are derived from its location.
from pathlib import Path as _Path
def _no_image():
    import sys
    sys.exit("The firmware image is not in this repository.")
# Lane L8 - builds states.tsv / transitions.tsv for docs\deep\105-tx-states.md.
# Every evidence cell is "0xADDR:<bytes>" read from the image here, so the cited bytes ARE the image bytes.
import os, hashlib
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
IMG = os.path.join(ROOT, "decrypted", _no_image())
OUT = os.path.dirname(os.path.abspath(__file__))
b = open(IMG, "rb").read()
assert hashlib.sha256(b).hexdigest().startswith("8e3ecd05409b2c31")


def ev(*cites):
    return " | ".join("0x%06X:%s" % (a, b[a:a + n].hex(" ")) for a, n in cites)


M, T = "main", "twin"
states = [
# machine, state, handler, entry, actions, next, label, status, evidence
(M, "0x00", "0x0346FA", "dispatcher stores 0 when AACF is not 0/4/7/8, no APRS ringer, AAD4.b7 clear (0x0345A0); also the idle value",
 "if r2l=AACF!=0: sub_34706 reset (sub_2F550 stops TPU0, B0C6=2, clear B0BB b0/b1, AADA/9551/AAD9=0, AAD8=0xFF) then sub_34782 setup: BB95=0; FFAAAA tested against VHF window FF92CE and UHF window FF92D6 (sub_3F5EE); 8176.b0 band latch (sub_37A3A); AAD0 = sub-band index from tables 0x03510A/0x035140 (sub_3F5B2); sub_34838 offset class band.0x8D + FF956D=2 + band.0x94=2 (synth retune in dispatcher tail sub_378A2); sub_3486C port bits 0x52.b5/b7 set, 0x5B.b2/b3, 0x5D.b0/b1, 0x59.b4 (analog voice) and filter latch 8172/8173 from 0x034956/0x03495E (sub_37A1E); FF9568=4; band.0x8F.b3 clr",
 "1 (in a window); 3 (outside both); host-keyed node: 1 via 0x034816 (FBA5.b6 + 0x52.b5/b7 only)", "IDLE/SETUP", "Confirmed",
 ev((0x0346FA, 10), (0x034798, 2), (0x0347AA, 2), (0x0347F2, 4), (0x0347F6, 6), (0x034806, 6), (0x03480E, 6), (0x034816, 6), (0x03486C, 8))),
(M, "0x01", "0x034966", "from setup (0x034806 / 0x034830)",
 "host-keyed node (FF8DDE<0 and (8DE0.b7 or B3D9.b2)) skips settle and interlock; else wait FF956D==0 (10-20 ms) and sample 0xFFFF4D.b3. APRS (AAD3 b0/b2) or analog comm mode: [FF89BB!=0: BB95=3, B0BB.b0, BB94=1] sub_34A7C power level, sub_34B30 band audio path, AA30.b2 (arms TOT), AAD1.b7 clr, sub_34B44 tone encoder, AAD5=2; then A4F0.b6 (APRS beacon) / A4F0.b7 (APRS message) / AAD1.b2 -> AA30.b4 (T-CALL burst FSM AAD6) / AA36.b3 -> tone 0x1F / else sub_34C34 (mic-gain DAC A99D, sub_3490 serial-DAC flush). Digital comm mode: jsr sub_35872 (FF9598=0x1F, power level, session select)",
 "2 (analog/APRS); 0x10/0x13/0x14 (digital via sub_35872); 0xFFFF4D.b3 high until FF9568 (30-40 ms) expires -> sub_34FF4", "TX KEY-UP", "Confirmed",
 ev((0x03496A, 2), (0x03497C, 8), (0x034984, 8), (0x0349D0, 4), (0x034A08, 6), (0x034A18, 6), (0x034A5A, 6), (0x034A62, 6), (0x034A70, 10))),
(M, "0x02", "0x034CCE", "analog key-up (0x034A18), RF line low again (0x034D48), resume (0x034DA8)",
 "each pass: 0xFFFF4D.b3 high -> FF9568=4, state 3; APRS active -> only AAD7=1; AAD1.b1 and FF9546==0 -> sub_34C34; tone class 7 (sub_3EF6E): every FF9579=0x32 (500 ms) toggle AAD1.b7 and re-arm the TPU1 tone from FF896A/FF896B (sub_34BCA); with AAD1.b0 the count AACE runs down and at 0 sub_227BC ends TX; AAD7=1 (enables AN1 check in tail)",
 "3; END after AACE tone pairs; 5 on AACF=7; END via sub_22718->sub_227BC (non-class-3 release); TOT sub_34F74", "ANALOG TX HOLD", "Confirmed",
 ev((0x034CCE, 6), (0x034CF4, 8), (0x034D0A, 10), (0x034D22, 6), (0x034D2C, 4), (0x034D34, 10))),
(M, "0x03", "0x034D42", "0xFFFF4D.b3 high in state 2 (0x034D34); out-of-window setup (0x03480E)",
 "0xFFFF4D.b3 low -> 2; high and FF9568==0 -> sub_34FF4", "2; END", "RF-STATUS GRACE", "Confirmed",
 ev((0x034D42, 10), (0x034D50, 10))),
(M, "0x04", "0x034D5C", "NEVER STORED (44/44 raw aa d5 operand sites checked; the 32 stores write only 0,1,2,3,5,0x0D-0x14)", "same body as state 5", "-", "UNREACHABLE", "Confirmed",
 ev((0x034684, 4), (0x034D5C, 8))),
(M, "0x05", "0x034D66", "AACF=7 with state>=2 (0x0345F4); sub_22718 posts AACF=7 only when tone class==3 (0x02277C)",
 "wait while TSTR(@0xBC:8).b0 is set (TPU0 encoder still running); then sub_34D70: AAD2.b1 -> END; AC0A!=0 -> resume; PTT FSM A9EA!=2 -> sub_227BC END; PTT held again -> AAD1&=0xCF, AAD1.b1, FF9546=5, A99F=AAB7, sub_34C1A re-arm, state 2",
 "2 or END", "RELEASE TAIL (class-3 encoder)", "Confirmed bytes; TSTR and DCS turn-off labels Inferred",
 ev((0x0345F4, 6), (0x02277C, 12), (0x034D66, 8), (0x034D70, 6), (0x034D7E, 8), (0x034DA8, 6), (0x034DB0, 4))),
(M, "0x06", "0x034DB6", "NEVER STORED", "rts", "-", "DEAD SLOT", "Confirmed", ev((0x03468C, 4), (0x034DB6, 2))),
(M, "0x07", "0x034DB8", "NEVER STORED", "rts (same handler as 0x0B)", "-", "DEAD SLOT", "Confirmed", ev((0x034690, 4), (0x034DB8, 2))),
(M, "0x08", "0x034DBA", "NEVER STORED", "rts", "-", "DEAD SLOT", "Confirmed", ev((0x034694, 4), (0x034DBA, 2))),
(M, "0x09", "0x034DBC", "NEVER STORED", "rts", "-", "DEAD SLOT", "Confirmed", ev((0x034698, 4), (0x034DBC, 2))),
(M, "0x0A", "0x034DBE", "NEVER STORED", "rts", "-", "DEAD SLOT", "Confirmed", ev((0x03469C, 4), (0x034DBE, 2))),
(M, "0x0B", "0x034DB8", "NEVER STORED", "rts (same handler as 0x07)", "-", "DEAD SLOT", "Confirmed", ev((0x0346A0, 4))),
(M, "0x0C", "0x034DC0", "NEVER STORED", "rts", "-", "DEAD SLOT", "Confirmed", ev((0x0346A4, 4), (0x034DC0, 2))),
(M, "0x0D", "0x0346C8", "TX request with AAD4.b7 (GM/data senders when FF8997!=0: 0x0631CC, 0x067C30, 0x067EFE) or APRS with ringer FF8C52/FF8C53!=0 (AAE0 = 'M' 0x4D / 'N' 0x4E)",
 "sub_34706 reset", "0x0E", "PRE-KEY RESET", "Confirmed",
 ev((0x034590, 6), (0x034596, 6), (0x0345B8, 2), (0x0345CA, 2), (0x0346C8, 8), (0x0631CC, 6))),
(M, "0x0E", "0x0346D2", "from 0x0D",
 "wait until the tone sequencer state FFAAE8==0 (pending tone finished), then sub_34782 setup; key event 13 handler sub_346DE (TX-time key-table slots 0x011994 and 0x011BB4) cuts the tone: AAE0=0xFF, state 0x0F",
 "1/3 via setup; 0x0F", "WAIT PRE-KEY TONE", "Confirmed", ev((0x0346D2, 8), (0x0346DE, 20), (0x011994, 4), (0x011BB4, 4))),
(M, "0x0F", "0x0346D8", "only from sub_346DE (tone skipped)", "sub_34782 setup on the next pass", "1/3", "SKIP-TONE SETUP", "Confirmed",
 ev((0x0346B0, 4), (0x0346D8, 4), (0x0346EC, 6))),
(M, "0x10", "0x035A04", "sub_35872: voice (sub_5A1BE accepted, 0x0359DA) or B0CC.b0 session 0x15 (sub_5A2F8 accepted)",
 "DSP session runs (TXON = P3DR 0xFFFF52.b2=0 per doc 57); host-keyed node -> AAD7=1 only; else when FF9597 (0x23 = 3.5 s, 100 ms tier) has expired and LOCATION SERVICE FF8D82.b0 and !B0CC.b0 and !AAD4 b2/b3 and AC0A==0 and B11E in {0,2}: sub_5CA34 (when session step B0BF==0x10: B11F++, sub_5C50C block, B0BC=1, FF9597=0x19 = 2.5 s repeat); AAD7=1; B2A5 -> sub_63360 (tone '[' 0x5B); AAD1.b1 and FF9546==0 -> sub_34C34",
 "0x11 on AACF=8; TOT or AN1 trip -> sub_34F74 -> sub_22718 -> AACF=8", "DIGITAL VOICE / 0x15 TX", "Confirmed",
 ev((0x0359DA, 6), (0x035A22, 6), (0x035A2A, 6), (0x035A46, 6), (0x035A5E, 4), (0x05CA34, 8), (0x05CA50, 6))),
(M, "0x11", "0x035A8C", "AACF=8 (digital release) from 0x10 (0x03462A); dispatcher clears B0BB.b0 and sets B0BB.b1 (TXOFF request to the session engine)",
 "wait (AAD7=1, sub_632F4) until B0BB.b7 (set by session TXOFF 0x05BC7C/0x05BF30) or FF9553 (0x64 = 1.0 s, 10 ms tier) expires; then sub_35AA6: B11F++ (sub_3F636 with descriptor 0x05C876: wrap at 0x7F), FF9553=3 (30 ms)",
 "0x12", "TXOFF WAIT", "Confirmed", ev((0x034616, 12), (0x03462A, 12), (0x035A8C, 8), (0x035A94, 6), (0x035AA6, 22))),
(M, "0x12", "0x035ABE", "from 0x11 (0x035AB6), 0x13 done/abort (0x035BA2)",
 "wait FF9553==0, then sub_227BC TX end (FF94C0=0); data (AAD4.b0) -> 817E.b1; host-keyed node with sub_6CA3A()==0 and FF8DD4!=0 -> tone ']' 0x5D; node flags B3D9 b0/b6/b2 cleared, 8EB6/B112/8EB4=2; sub_6163E (AAD4=0, FF9599=0x78); 8EA0.b3 -> sub_21266 band return",
 "terminal (FF94C0=0 stops the dispatcher; AAD5 stays 0x12)", "DIGITAL TX END", "Confirmed",
 ev((0x035ABE, 10), (0x035AF8, 6), (0x035B32, 4), (0x035B44, 4))),
(M, "0x13", "0x035B4A", "sub_35872 with AAD4.b0 (data queued) and sub_5A28A (session 0x0A) accepted (0x0359C0)",
 "AACF=8 is ignored; wait for B0BB.b7 (AAD7=1 meanwhile); AN1 trip AAD9 -> loc_5ECFE abort (B0BA/B258/B25F/B263=0) -> 0x12; B0BA in 1..0x7F (blocks left) -> stay 0x13 (node: sub_6CB32 B3D5.b3, FF9556=0x19); else FF9553=3 -> 0x12",
 "0x13; 0x12", "DIGITAL DATA TX", "Confirmed", ev((0x0359C0, 6), (0x03460A, 4), (0x035B4A, 8), (0x035B5A, 6), (0x035B90, 6), (0x035B9C, 10))),
(M, "0x14", "0x0359EA", "sub_35872 when the dsp_request call returns busy (0x0359E2)",
 "while FF9598 (0x1F = 3.0-3.1 s, 100 ms tier, set at 0x035872) is nonzero, jump back into the session dispatch 0x0358A4 on every pass; on expiry tone 0x1D (only if FF8DDE==0) and sub_34FF4; AACF=8 here -> sub_34FF4",
 "0x10/0x13/0x14; END", "DSP BUSY RETRY", "Confirmed",
 ev((0x035872, 6), (0x0359E2, 6), (0x0359EA, 8), (0x0359F2, 12), (0x0359FE, 4), (0x034622, 8))),
(T, "0x00", "0x035D42", "dispatcher 0x035C64 (AACF not 0/8, AAD4.b7 clear)",
 "r2l!=0: sub_35D4C reset (no TPU0 stop, no B0C6) + sub_35D96 setup (same windows and latch as main, sub_35E14 offset class, FBA5.b6, sub_35E3C 0x52.b5/b7, FF9568=0x19 which the twin never reads; no FF956D, no band.0x94)",
 "1; 3", "IDLE/SETUP (node)", "Confirmed", ev((0x035C64, 6), (0x035D42, 8), (0x035DEC, 10), (0x035E04, 6), (0x035E0C, 6))),
(T, "0x01", "0x035E46", "from setup", "no settle and no 0xFFFF4D sample; always sub_35EC0 digital dispatch (FF9598=0x1F, sub_30A24, B0C7=B3DB from the host)",
 "0x10/0x13/0x14", "KEY-UP (node, digital only)", "Confirmed", ev((0x035E7A, 6), (0x035EC0, 6), (0x035F40, 6), (0x035F5A, 6), (0x035F62, 6))),
(T, "0x02-0x0C", "0x035E86", "3 only from out-of-window setup; 2 and 4-0x0C never stored", "rts (nullsub_34)", "AACF=8 -> 0x11", "DEAD / PARK", "Confirmed",
 ev((0x035CE0, 4), (0x035E86, 2))),
(T, "0x0D", "0x035D2C", "AAD4.b7 (0x035C5A)", "sub_35D4C reset", "0x0E", "PRE-KEY RESET (node)", "Confirmed", ev((0x035C5A, 6), (0x035D2C, 8))),
(T, "0x0E", "0x035D36", "from 0x0D", "FFAAE8==0 -> sub_35D96 setup", "1/3", "WAIT TONE (node)", "Confirmed", ev((0x035D36, 8))),
(T, "0x0F", "0x035D3C", "only sub_346DE stores 0x0F (key tables)", "sub_35D96 setup", "1/3", "SKIP-TONE (node)", "Confirmed", ev((0x035D3C, 4))),
(T, "0x10", "0x035F84", "0x035F5A",
 "'40 30' = bra to rts: no-op. The 8-byte head 0x035F86 (btst B0CC.b0) is skipped and unproven; the LOCATION follow-up body sub_35F8E runs instead from the main loop (0x0039F4)",
 "0x11 on AACF=8", "VOICE TX HOLD (node, empty)", "Confirmed", ev((0x035D18, 4), (0x035F84, 2), (0x035F86, 8), (0x0039F4, 4))),
(T, "0x11", "0x035FB8", "AACF=8 (0x035C9C)", "as main 0x11", "0x12", "TXOFF WAIT (node)", "Confirmed", ev((0x035C9C, 12), (0x035FB8, 10), (0x035FC8, 22))),
(T, "0x12", "0x035FE0", "from 0x11/0x13",
 "FF9553==0 -> sub_35E88 end (writes FF94C0=0 itself; does NOT call sub_227BC); data -> 817E.b1; FF8DD4 -> tone ']'; AAD4=0",
 "terminal", "DIGITAL TX END (node)", "Confirmed", ev((0x035FE0, 10), (0x035E88, 6), (0x036006, 6))),
(T, "0x13", "0x03600E", "0x035F40", "as main 0x13 without the FF8DDE sign test", "0x13; 0x12", "DATA TX (node)", "Confirmed",
 ev((0x03600E, 8), (0x036040, 6), (0x03604C, 10))),
(T, "0x14", "0x035F6A", "0x035F62", "retry 0x035EDC while FF9598; then tone 0x1D only if FF8DDE==0 (never true in the twin loop) and sub_35E88", "0x10/0x13/0x14; END",
 "DSP BUSY RETRY (node)", "Confirmed", ev((0x035F6A, 8), (0x035F72, 6), (0x035F7E, 4))),
]

trans = [
(M, "any", "0x00", "AACF not 0/4/7/8; AAD3 b0/b2 clear; AAD4.b7 clear", ev((0x034562, 8), (0x0345A0, 6))),
(M, "any", "0x0D", "same, with AAD4.b7 set (the bit is cleared)", ev((0x034588, 14), (0x034596, 6))),
(M, "any", "0x0D", "APRS beacon (AAD3.b0) and FF8C52!=0: AAE0=0x4D", ev((0x0345AA, 4), (0x0345B2, 6), (0x0345B8, 2), (0x0345D0, 6))),
(M, "any", "0x0D", "APRS message/ack (AAD3.b2) and FF8C53!=0: AAE0=0x4E", ev((0x0345BC, 4), (0x0345C4, 6), (0x0345CA, 2))),
(M, "any", "0x00", "APRS with ringer flag 0", ev((0x0345B6, 2), (0x0345C8, 2))),
(M, ">=2", "(same)", "AACF=4: re-run tone/encoder arm sub_34B44 (AACF=4 posted by sub_17210 while FF94C0!=0)", ev((0x03456A, 4), (0x0345D8, 12), (0x01725E, 4))),
(M, "<2", "END", "AACF=7 -> sub_34FF4", ev((0x0345E6, 12))),
(M, ">=2", "0x05", "AACF=7", ev((0x0345F4, 6))),
(M, "<2", "END", "AACF=8 -> sub_34FF4", ev((0x0345FC, 12))),
(M, "0x13", "(same)", "AACF=8 ignored", ev((0x03460A, 4))),
(M, "any", "(same)", "AACF=8 ignored while AAD4.b0 (data queued)", ev((0x03460E, 8))),
(M, "0x14", "END", "AACF=8 -> sub_34FF4", ev((0x034622, 8))),
(M, "other", "0x11", "AACF=8: B0BB.b0=0, B0BB.b1=1, FF9553=0x64", ev((0x034616, 12), (0x03462A, 12))),
(M, "0x00", "0x01", "AACF!=0 and FFAAAA inside the VHF or UHF TX window", ev((0x0346FA, 10), (0x034806, 6))),
(M, "0x00", "0x03", "FFAAAA outside both windows (defensive; the request gate sub_34E42 tests the same windows on FFAAAE)", ev((0x0347AA, 2), (0x03480E, 6))),
(M, "0x00", "0x01", "host-keyed node (FF8DDE<0 and (8DE0.b7 or B3D9.b2)): no settle, no offset/port setup", ev((0x0347E2, 16), (0x034830, 6))),
(M, "0x01", "(same)", "FF956D!=0 (settle)", ev((0x03497C, 8))),
(M, "0x01", "END", "0xFFFF4D.b3 high and FF9568==0 -> sub_34FF4", ev((0x034984, 8), (0x034A70, 10))),
(M, "0x01", "0x02", "analog voice / APRS / short-TX key-up complete", ev((0x034A18, 6))),
(M, "0x01", "sub_35872", "digital comm mode and not APRS", ev((0x0349D0, 4), (0x034A6A, 4))),
(M, "sub_35872", "0x10", "B0CC.b0 and sub_5A2F8 (session 0x15) accepted", ev((0x0358CA, 10), (0x0359C8, 8), (0x0359DA, 6))),
(M, "sub_35872", "0x13", "AAD4.b0 and sub_5A28A (session 0x0A) accepted", ev((0x0358D4, 10), (0x0359A8, 6), (0x0359C0, 6))),
(M, "sub_35872", "0x10", "voice: sub_5A1BE (session 0x02/0x0B/0x10 by B0C7) accepted; AA30.b2, FF9597=0x23", ev((0x03596A, 6), (0x03599A, 6), (0x0359A0, 6))),
(M, "sub_35872", "0x14", "dsp_request busy (nonzero return)", ev((0x03596E, 2), (0x0359E2, 6))),
(M, "0x02", "0x03", "0xFFFF4D.b3 high: FF9568=4", ev((0x034CCE, 6), (0x034D34, 10))),
(M, "0x02", "END", "tone class 7 with AAD1.b0: AACE reaches 0 -> sub_227BC", ev((0x034D0A, 22))),
(M, "0x03", "0x02", "0xFFFF4D.b3 low", ev((0x034D42, 12))),
(M, "0x03", "END", "0xFFFF4D.b3 high and FF9568==0 -> sub_34FF4", ev((0x034D50, 10))),
(M, "0x05", "0x02", "TSTR.b0 clear and (AC0A!=0 or PTT held A9EA==2)", ev((0x034D66, 8), (0x034D78, 6), (0x034D7E, 8), (0x034DA8, 6))),
(M, "0x05", "END", "TSTR.b0 clear and (AAD2.b1 or PTT not held) -> sub_227BC", ev((0x034D70, 8), (0x034DB0, 4))),
(M, "0x0D", "0x0E", "always, after sub_34706", ev((0x0346C8, 8))),
(M, "0x0E", "0x01/0x03", "FFAAE8==0 -> sub_34782", ev((0x0346D2, 10))),
(M, "0x0E", "0x0F", "key event 13 (sub_346DE): AAE0=0xFF", ev((0x0346DE, 20), (0x011994, 4), (0x011BB4, 4))),
(M, "0x0F", "0x01/0x03", "sub_34782", ev((0x0346D8, 4))),
(M, "0x10", "(same)", "after 3.5 s, then every 2.5 s: LOCATION block via sub_5CA34", ev((0x035A2A, 6), (0x035A5E, 4), (0x05CA50, 6))),
(M, "0x11", "0x12", "B0BB.b7 or FF9553==0; B11F++, FF9553=3", ev((0x035A8C, 14), (0x035AA6, 22))),
(M, "0x12", "END", "FF9553==0 -> sub_227BC (FF94C0=0)", ev((0x035ABE, 10), (0x022858, 6))),
(M, "0x13", "0x13", "B0BA in 1..0x7F (more blocks)", ev((0x035B60, 8), (0x035B90, 6))),
(M, "0x13", "0x12", "B0BA zero/negative, or AAD9 trip (abort via loc_5ECFE)", ev((0x035B5A, 6), (0x035B98, 4), (0x035B9C, 14))),
(M, "0x14", "sub_35872 retry", "FF9598!=0", ev((0x0359EA, 8))),
(M, "0x14", "END", "FF9598==0: tone 0x1D (if FF8DDE==0) + sub_34FF4", ev((0x0359F2, 16))),
(M, "tail", "END", "AAD7 set, AAD9==0, A996 (AN1) >= 0xF4: tone 0x1D, sub_34F74 forced TX end, AAD9=1", ev((0x03465C, 22), (0x035BC2, 24))),
(M, "tail", "(same)", "A996 0xEB..0xEE -> power level <=1; 0xEF..0xF3 -> power level 0; tone 0x32, popup 0x23 (sub_1BF40)", ev((0x035BB6, 14), (0x035BDE, 14), (0x035BF2, 12))),
(M, "TOT", "END", "FF95EA expired: analog sub_34FF4 / digital sub_22718 (AACF=8 -> 0x11)", ev((0x034F6E, 6), (0x034FAA, 2), (0x034FB4, 4))),
(T, "any", "0x00", "AACF not 0/8 and AAD4.b7 clear", ev((0x035C3E, 8), (0x035C64, 6))),
(T, "any", "0x0D", "AAD4.b7", ev((0x035C4C, 14), (0x035C5A, 6))),
(T, "<2 or 0x14", "END", "AACF=8 -> sub_35E88", ev((0x035C6E, 12), (0x035C98, 4))),
(T, "other", "0x11", "AACF=8 (not 0x13, not AAD4.b0)", ev((0x035C9C, 12))),
(T, "0x00", "0x01/0x03", "sub_35D96", ev((0x035D42, 8), (0x035E04, 6), (0x035E0C, 6))),
(T, "0x01", "0x10/0x13/0x14", "sub_35EC0 dispatch", ev((0x035EDC, 10), (0x035F28, 6), (0x035F48, 6), (0x035F5A, 6), (0x035F62, 6))),
(T, "0x11", "0x12", "B0BB.b7 or FF9553==0", ev((0x035FB8, 18), (0x035FD8, 6))),
(T, "0x12", "END", "FF9553==0 -> sub_35E88", ev((0x035FE0, 10))),
(T, "0x13", "0x13/0x12", "as main", ev((0x036040, 6), (0x03604C, 10))),
(T, "0x14", "retry/END", "FF9598", ev((0x035F6A, 8), (0x035F7E, 4))),
(T, "tail", "-", "no AN1 protection: 'bne +0' at 0x035CD4 where main has 'bne +4 ; jsr sub_35BAA'", ev((0x035CD0, 8), (0x03466C, 6))),
]

with open(os.path.join(OUT, "states.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("machine\tstate\thandler\tentry\tactions\tnext_states\tlabel\tstatus\tevidence\n")
    for r in states:
        h.write("\t".join(r) + "\n")
with open(os.path.join(OUT, "transitions.tsv"), "w", encoding="utf-8", newline="\n") as h:
    h.write("machine\tfrom\tto\tcondition\tevidence\n")
    for r in trans:
        h.write("\t".join(r) + "\n")
print(len(states), len(trans))
