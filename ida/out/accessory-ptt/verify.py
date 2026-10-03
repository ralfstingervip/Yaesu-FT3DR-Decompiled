# -*- coding: utf-8 -*-
"""Lane L10: re-read every byte run cited in docs/deep/107-accessory-ptt.md from the images.
Read-only. MAIN file offset = address; SUB file offset = address - 0xFFC00000.
Writes verify.tsv next to this script."""
import sys
from pathlib import Path as _Path
_REPO_S = _Path(__file__).resolve().parents[3].as_posix()
import hashlib, os

ROOT = _REPO_S
sys.exit("The firmware image is not in this repository.")
sys.exit("The firmware image is not in this repository.")

CITES = [
    # --- MAIN: SCI_6 (SCI-D) receive ISR and ring ---
    ("M", 0x000380, "00 04 4a 70", "vector 224 -> 0x044A70"),
    ("M", 0x000388, "00 04 4a 70", "vector 226 -> 0x044A70"),
    ("M", 0x044A74, "6a 0d f6 14", "ISR reads SSR 0xFFF614"),
    ("M", 0x044A7A, "ed 38", "error mask 0x38"),
    ("M", 0x044A84, "6a 0d f6 15", "ISR reads RDR 0xFFF615"),
    ("M", 0x044A88, "01 00 6b 04 81 46 68 cd", "store byte at ring head FF8146"),
    ("M", 0x044A92, "7a 24 00 ff 3c 6b", "ring end FF3C6B"),
    ("M", 0x044A9A, "7a 04 00 ff 30 6a", "ring wrap to FF306A"),
    ("M", 0x044AAA, "56 70", "rte"),
    # --- MAIN: deframer ---
    ("M", 0x047560, "01 00 6b 04 81 42 6b 06 81 48", "tail FF8142 vs head FF8148"),
    ("M", 0x04756E, "6c 4a", "take byte from ring"),
    ("M", 0x047584, "6a 0b 9d 2d", "state FF9D2D"),
    ("M", 0x047590, "78 b0 6b 26 00 04 75 c8 59 60", "jmp via table 0x0475C8"),
    ("M", 0x0475C8, "00 04 75 f8 00 04 76 1e 00 04 77 92 00 04 7b 7c 00 04 78 aa 00 04 7a 7e "
                    "00 04 79 9a 00 04 7e 2c 00 04 7f 4e 00 04 80 2e 00 04 81 1e 00 04 81 fe",
     "state table 0..0xB"),
    ("M", 0x04761E, "0c ac 47 d8", "state 1: zero bytes skipped"),
    ("M", 0x04763C, "aa e6 58 70 01 0a", "start byte E6 -> 0x04774C"),
    ("M", 0x04774C, "7a 01 00 00 00 00 6e 9a 98 00", "E6 start stored at FF9800"),
    ("M", 0x04775C, "fc 0d 6a 8c 9d 2c fc 0a 6a 8c 9d 2d", "E6 count 0x0D, state 0x0A"),
    ("M", 0x047636, "aa e4 58 70 01 2e", "start byte E4 -> 0x04776A"),
    ("M", 0x04777A, "fc 29 6a 8c 9d 2c fc 09 6a 8c 9d 2d", "E4 count 0x29, state 9"),
    ("M", 0x0476A6, "79 04 01 10 6b 84 bc 4c", "FF frame count 0x110"),
    ("M", 0x047720, "fc c7", "FE frame count 0xC7"),
    # --- MAIN: E6 handler sub_4811E ---
    ("M", 0x04811E, "6b 01 9d 2a", "index FF9D2A"),
    ("M", 0x04812C, "aa e6 47 e4", "re-sync on E6"),
    ("M", 0x048162, "aa 00", "idx4 (hdr-sum hi) == 0"),
    ("M", 0x048168, "aa 0a", "idx3 length == 0x0A"),
    ("M", 0x04816E, "aa 00", "idx2 == 0"),
    ("M", 0x048174, "aa 00", "idx1 == 0"),
    ("M", 0x048148, "7a 05 00 ff 98 00 fe 04", "header sum over 4 bytes"),
    ("M", 0x048158, "6c 54 0c ac 1d 34", "compare sum with [4]:[5]"),
    ("M", 0x0481A2, "6e 9a 98 00", "body store FF9800+idx"),
    ("M", 0x0481C0, "7a 05 00 ff 98 00 6e 5a 00 03 0c ae 8e 02", "frame sum over [3]+2 bytes"),
    ("M", 0x0481D6, "6c 54 68 5c 1d 34 46 9a", "compare frame sum"),
    ("M", 0x0481DE, "6a 18 ba 92 70 30 6a 0c 98 0b 6a 8c bb 91", "BA92.b3=1; BB91=FF980B"),
    # --- MAIN: other single-byte handlers ---
    ("M", 0x04803C, "aa e4 47 e4", "E4 re-sync"),
    ("M", 0x048072, "aa 01", "E4 idx4 == 1"),
    ("M", 0x048078, "aa 26", "E4 length 0x26"),
    ("M", 0x0480EE, "6a 18 ba 92 70 20 79 04 00 1d 7a 05 00 ff 98 0b 7a 06 00 ff bb 71", "E4: 29 B FF980B->FFBB71"),
    ("M", 0x04820C, "aa e5", "E5 re-sync"),
    ("M", 0x048248, "aa 0a", "E5 length 0x0A"),
    ("M", 0x0482BE, "6a 18 ba 92 70 40 6a 0c 98 0b 6a 8c bb 92", "E5: FF980B->FFBB92"),
    ("M", 0x047F5C, "aa ea", "EA re-sync"),
    ("M", 0x047F98, "aa 0a", "EA length 0x0A"),
    ("M", 0x04800E, "6a 18 ba 92 70 10 6a 0c 98 0b 6a 8c ba d7", "EA: FF980B->FFBAD7"),
    ("M", 0x0479A8, "aa e2", "E2 re-sync"),
    ("M", 0x0479E4, "aa 0b", "E2 length 0x0B"),
    ("M", 0x047A5A, "6a 24 00 ff 98 0b 6a 2c 00 ff 98 0c 6b 84 bc 60", "E2: FF980B:0C->FFBC60"),
    ("M", 0x0478B8, "aa e3", "E3 re-sync"),
    ("M", 0x0478F4, "aa 0c", "E3 length 0x0C"),
    ("M", 0x04796E, "7a 05 00 ff 98 06 7a 06 00 ff 81 3f", "E3: FF9806..08->FF813F"),
    ("M", 0x0477A0, "aa e0", "E0 re-sync"),
    ("M", 0x0477E0, "aa 0e", "E0 length 0x0E"),
    ("M", 0x047864, "7a 06 00 ff bb c8", "E0 -> FFBBC8"),
    ("M", 0x047F16, "6a 18 ba 92 70 00", "FE: BA92.b0"),
    # --- MAIN: E1 NMEA compaction (second writer of FF9800) ---
    ("M", 0x047C74, "7a 05 00 ff 98 0b 7a 06 00 ff 98 00 f4 00 7b d4 59 8f", "eepmov FF980B->FF9800"),
    ("M", 0x047C8A, "fc 0a 68 ec", "append 0x0A"),
    ("M", 0x047CA0, "7a 25 50 47 47 41", "cmp 'PGGA'"),
    ("M", 0x047CAA, "7a 25 50 52 4d 43", "cmp 'PRMC'"),
    # --- MAIN: key scan, BT PTT poll ---
    ("M", 0x00FAF6, "6a 0c 80 04 ac 02 44 e8", "FF8004>=2 -> reset, rts"),
    ("M", 0x00FAFE, "6a 0c 89 bb 47 14 6a 10 89 20 73 00 46 0c", "VOX hold skipped when FF8920.b0"),
    ("M", 0x00FB18, "5e 00 fc 66 6a 0c a9 ed 58 a0 00 a4", "hardware PTT FSM first; event wins"),
    ("M", 0x00FB2C, "6a 10 89 20 73 00 47 0c 5e 00 fd 22 6a 0c a9 ed 58 a0 00 88", "FF8920.b0 -> jsr sub_FD22"),
    ("M", 0x00FD22, "6a 10 ba 92 73 30 47 32 6a 18 ba 92 72 30 6a 0c bb 91 ec 01 71 0c 8c 17 "
                    "ac 17 47 14 ac 18 46 1a 6a 10 aa d2 73 00 46 0e fc ff 6a 8c a9 ed 40 0a "
                    "6a 18 aa d2 70 00 6a 8c a9 ed 54 70", "sub_FD22 whole"),
    ("M", 0x00FBC8, "ac 0a 44 08", "raw >= 0x0A"),
    ("M", 0x00FBD4, "fb 09 18 bc 6a 8c a9 ed", "event = raw - 9"),
    ("M", 0x00FCC2, "6a 18 aa d2 72 00 6a 18 aa d2 72 10 fc 17", "hardware press clears AAD2.b0/b1"),
    ("M", 0x00FD06, "6a 18 aa d2 72 00", "delayed hardware press clears AAD2.b0"),
    # --- MAIN: Bluetooth setting byte ---
    ("M", 0x0122A8, "00 01 9c fe 00 01 9d 10", "item handlers 0x019CFE, 0x019D10"),
    ("M", 0x019D04, "6a 18 89 20 71 00", "bnot FF8920.b0"),
    ("M", 0x019D16, "6a 18 89 20 71 70", "bnot FF8920.b7"),
    ("M", 0x02C0C8, "6a 18 89 20 70 00", "bset FF8920.b0"),
    ("M", 0x007DC8, "6a 10 89 20 77 00 67 7b", "frame byte b7 = FF8920.b0"),
    ("M", 0x007DD0, "6a 10 89 20 73 00 47 02 55 58", "bsr sub_7E32 if BT on"),
    ("M", 0x007E38, "6a 10 89 20 73 70 46 0c", "FF8920.b7 test"),
    ("M", 0x007E4C, "70 5b 6a 10 bb 8f 77 70 67 eb", "b5 set; b6 = !BB8F.b7"),
    ("M", 0x007DFE, "6a ab 00 ff 3d 8c", "store FF3D8C"),
    ("M", 0x009774, "6b ab 00 ff 3d 74", "opcode word at FF3D74"),
    ("M", 0x034D70, "6a 10 aa d2 73 10 46 38 6a 0c ac 0a 46 1e 6a 0c a9 ea ac 02 46 2a", "TX hold test"),
    # --- SUB: SUB->MAIN frame builder ---
    ("S", 0xFFEDD528, "71 00 f0 83 89 83 82 a0 83 90 8c", "args type,b1,ptr,len"),
    ("S", 0xFFEDD539, "c9 0e 0f f6 95", "[0]=type"),
    ("S", 0xFFEDD549, "b8 89 62 91", "len+9"),
    ("S", 0xFFEDD5AE, "fa e4 fc 95 01", "[6]=01"),
    ("S", 0xFFEDD5B9, "fa e4 fd 95 02", "[7]=02"),
    ("S", 0xFFEDD5C4, "fa e4 fe 95 00", "[8]=00"),
    ("S", 0xFFEDD6F3, "66 01 05 38 d8 ff", "channel 0, bsr.a sub_FFEDAF2D"),
    # --- SUB: E6 senders ---
    ("S", 0xFFF37FAD, "75 41 e6 05 78 55 fa", "E6 (F3D2 path)"),
    ("S", 0xFFF38212, "75 41 e6 05 13 53 fa", "E6 (F3D6 path)"),
    ("S", 0xFFF38FCF, "75 41 e6 05 56 45 fa", "E6=1 on SCO open"),
    ("S", 0xFFF3906C, "75 41 e6 05 b9 44 fa", "E6=0 on SCO closed by radio"),
    ("S", 0xFFF39225, "61 61", "callback acts on code 6 only"),
    ("S", 0xFFF3922A, "fb e2 9d 22 01 00 58 ee 75 5e 20", "1229D == 0x20"),
    ("S", 0xFFF39238, "fb f2 bc 2c 01 00 5c ff 61 2f", "12CBC == 2 ?"),
    ("S", 0xFFF39261, "66 15 fe 0f e5", "payload 1"),
    ("S", 0xFFF39274, "f8 e5 02", "12CBC = 2"),
    ("S", 0xFFF39281, "75 41 e6 05 a4 42 fa", "send E6 (1)"),
    ("S", 0xFFF392AF, "fb 12 fb 8e f3 ff 05 07 08 00", "SCOL=1 with callback"),
    ("S", 0xFFF3930F, "75 41 e6 05 16 42 fa", "send E6 (1), second branch"),
    ("S", 0xFFF39395, "66 0f fe 0e 1f", "payload 0"),
    ("S", 0xFFF393A6, "f8 e5 03", "12CBC = 3"),
    ("S", 0xFFF393B3, "75 41 e6 05 72 41 fa", "send E6 (0)"),
    ("S", 0xFFF393F1, "75 41 e6 05 34 41 fa", "send E6 (0), second branch"),
    # --- SUB: RXAT=CKPD=200 recogniser ---
    ("S", 0xFFF3A96A, "fb e2 4b af f4 ff", "echo 'RXAT='"),
    ("S", 0xFFF4AF4B, "52 58 41 54 3d 00", "'RXAT='"),
    ("S", 0xFFF3A9CF, "a8 89 b1 19 75 51 43", "[5]=='C'"),
    ("S", 0xFFF3A9DA, "b1 91 75 51 4b", "[6]=='K'"),
    ("S", 0xFFF3A9EF, "b1 99 75 51 50", "[7]=='P'"),
    ("S", 0xFFF3AA04, "b2 11 75 51 44", "[8]=='D'"),
    ("S", 0xFFF3AA19, "b2 19 75 51 3d", "[9]=='='"),
    ("S", 0xFFF3AA2E, "b2 91 75 51 32", "[10]=='2'"),
    ("S", 0xFFF3AA43, "b2 99 75 51 30", "[11]=='0'"),
    ("S", 0xFFF3AA58, "b3 11 75 51 30", "[12]=='0'"),
    ("S", 0xFFF3AA6B, "fb e2 c4 83 06 00 ec ee fb 22 6c 05 01 00 66 61 7f 1e", "callback[683C4](6)"),
    ("S", 0xFFF3A27E, "61 51 20 7f", "classifier B index 5 -> 0xFFF3A2FF"),
    ("S", 0xFFF3A2FF, "fb e2 78 05 01 00 58 ee 61 1e 21 36 a8 81 39 4e 06", "RXAT only when [10578]==1"),
    ("S", 0xFFF3AEAB, "ec 01 b1 19 75 51 31", "TXAT reply '1'"),
    ("S", 0xFFF3AEB4, "fb e2 78 05 01 00 f8 e4 01", "[10578]=1"),
    ("S", 0xFFF39BB3, "3c 05 01", "TXAT argument 1"),
    ("S", 0xFFF39BE0, "fb e2 da ae f4 ff", "'TXAT=%d'"),
    ("S", 0xFFF4AEDA, "54 58 41 54 3d 25 64 0d 0a", "'TXAT=%d\\r\\n'"),
    ("S", 0xFFF39BF6, "fb e2 c4 83 06 00 e1 0e 02", "store callback at 683C4"),
    ("S", 0xFFF384E9, "fb 12 16 92 f3 ff 05 c0 16 00", "TXAT with callback sub_FFF39216"),
    ("S", 0xFFF37DF7, "39 eb 06", "F3D2 handler calls sub_FFF384E2"),
    ("S", 0xFFEDCFE2, "75 51 d2 21 2c", "MAIN->SUB opcode F3D2"),
    ("S", 0xFFEDCFF1, "05 97 ad 05", "bsr.a sub_FFF37D88"),
    ("S", 0xFFF3B652, "66 21 05 d9 f8 f9", "BT printf -> channel 2"),
    ("S", 0xFFF3A7BC, "a8 09 b1 19 75 51 30", "SCOI='0'"),
    ("S", 0xFFF3A805, "75 51 31", "SCOI='1'"),
    ("S", 0xFFF3A820, "66 11 7f 1e", "callback[683C0](1)"),
    ("S", 0xFFF3851D, "b6 11 75 21 20 fb e2 9d 22 01 00 c3 e1", "1229D = frame[0x18] & 0x20"),
    ("S", 0xFFF3959C, "76 0e e8 03", "idle count 1000"),
    ("S", 0xFFF3A8B4, "66 51 7f 1e", "ERAT -> callback(5)"),
    ("M", 0x007E0A, "78 50 6a 2b 00 00 7e 2c", "lookup 0x7E2C[r5]"),
    ("M", 0x007E2C, "00 28 14 2d 18 00", "candidate 6-B table"),
    ("S", 0xFFF38627, "fb e2 b8 2c 01 00 f8 e5 02", "12CB8=2 (BT off edge)"),
    ("S", 0xFFF3865A, "fb e2 b8 2c 01 00 f8 e5 02", "12CB8=2 (BT on edge)"),
    ("S", 0xFFF38F75, "fb e2 b8 2c 01 00 f8 e5 01", "12CB8=1"),
    ("M", 0x0122AC, "00 01 9d 10", "item handler 0x019D10"),
    # --- addendum: E6 site reconciliation ---
    ("S", 0xFFF38F06, "b9 89 61 11 3b cc 00", "SCOL cb: code==1"),
    ("S", 0xFFF38F1F, "fb e2 a0 22 01 00 58 ee 61 4e 20 57 61 3e 20 79", "switch [122A0]: 4,3"),
    ("S", 0xFFF38FB1, "66 1f fe 0e 1f", "payload 1"),
    ("S", 0xFFF38FBC, "fb e2 bc 2c 01 00 f8 e5 02", "12CBC=2"),
    ("S", 0xFFF38FD6, "b9 89 61 31 3b c8 00", "code==3"),
    ("S", 0xFFF39005, "58 ee 61 4e 20 6c 61 3e 20 36", "switch [122A0]: 4,3"),
    ("S", 0xFFF3904E, "66 0f fe 0e 1f", "payload 0"),
    ("S", 0xFFF39059, "fb e2 bc 2c 01 00 f8 e5 03", "12CBC=3"),
    ("S", 0xFFF39099, "fb e2 a0 22 01 00 f8 e4 00", "122A0=0 after code 3"),
    ("S", 0xFFF390A4, "61 51 3b c7 00", "code==5 block"),
    ("S", 0xFFF390A9, "fb e2 a0 22 01 00 f8 e4 00", "122A0=0 on code 5"),
    ("S", 0xFFF3A7DA, "fb e2 c2 2c 01 00 5c ee 61 1e fb e2 c0 83 06 00 ec ee 1e 66 31 7f 1e 0d 66 51 7f 1e", "SCOI=0: code 3 if [12CC2]==1 else 5"),
    ("S", 0xFFF39B62, "fb e2 c2 2c 01 00 f8 e5 01", "SCOL=0 sender sets 12CC2=1"),
    ("S", 0xFFF39B95, "fb e2 c2 2c 01 00 f8 e5 01", "SCOL=0 sender sets 12CC2=1"),
    ("S", 0xFFF392C3, "fb e2 a0 22 01 00 f8 e4 03", "122A0=3 (CKPD)"),
    ("S", 0xFFF3935D, "fb e2 a0 22 01 00 f8 e4 03", "122A0=3 (CKPD)"),
    ("S", 0xFFF3943C, "fb e2 a0 22 01 00 f8 e4 03", "122A0=3 (CKPD, unkey branch)"),
    ("S", 0xFFF37E53, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF384C0, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF386EF, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF38997, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF39101, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF3915B, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF39173, "fb e2 a0 22 01 00 f8 e4 00", "122A0=0"),
    ("S", 0xFFF391A4, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF39367, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF39446, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF39486, "fb e2 a0 22 01 00 f8 e4 04", "122A0=4"),
    ("S", 0xFFF39547, "fb e2 a0 22 01 00 f8 e4 02", "122A0=2"),
    ("S", 0xFFF37D58, "fb e2 a0 22 01 00 f8 e4 00", "122A0=0 init"),
    ("S", 0xFFF37EB9, "fb e2 a0 22 01 00 f8 e4 00", "122A0=0"),
    ("S", 0xFFF3885F, "fb e2 a0 22 01 00 f8 e4 01", "122A0=1 (dead fn)"),
    ("S", 0xFFF37F78, "fb e2 bc 2c 01 00 5c ee 61 2e 21 32", "F3D2: E6=0 only if 12CBC==2"),
    ("S", 0xFFF381DD, "fb e2 bc 2c 01 00 5c ee 61 2e 21 32", "F3D6: E6=0 only if 12CBC==2"),
    ("S", 0xFFF37EF0, "fb e2 bc 2c 01 00 f8 e5 03", "F3D2 sub-op1: 12CBC=3 without E6"),
    ("S", 0xFFF38CDB, "fb e2 bc 2c 01 00 f8 e5 03", "12CBC=3 without E6"),
    ("S", 0xFFF38EB6, "fb e2 bc 2c 01 00 f8 e5 03", "12CBC=3 without E6"),
    ("S", 0xFFF3926E, "fb e2 bc 2c 01 00 f8 e5 02", "12CBC=2 (CKPD)"),
    ("S", 0xFFF392FC, "fb e2 bc 2c 01 00 f8 e5 02", "12CBC=2 (CKPD)"),
    ("S", 0xFFF393C4, "61 2e 21 32", "unkey branch needs 12CB8==2"),
    ("S", 0xFFF393F8, "fb e2 ab 22 01 00 58 ee 75 5e 19", "SCOL only if 122AB not 19/18"),
    ("S", 0xFFF39430, "fb e2 b8 2c 01 00 5c ee 61 2e 21 0c", "12CB8==2 -> 122A0=3"),
    ("M", 0x011998, "00 02 29 d2 00 02 27 18", "TX-time ev14 sub_229D2, ev15 sub_22718"),
    ("M", 0x011AEC, "00 02 29 d2 00 02 27 18", "TX-time table 2"),
    ("M", 0x011B30, "00 02 29 d2 00 02 27 18", "TX-time table 3"),
    ("M", 0x011B74, "00 03 ff a0 00 02 27 18", "TX-time table 4"),
    ("M", 0x0229D2, "6a 0c aa d5 ac 10 45 0a ac 15 44 06 5e 03 ff 9c 40 04 5e 03 ff a0 54 70", "sub_229D2: no TX request"),
    ("M", 0x03266E, "6a 0c aa d2 ec 9d 6a 8c aa d2", "AAD2 &= 0x9D keeps b0"),
]


def main():
    rows = ["img\taddr\tfile_off\texpected\tactual\tok\tnote"]
    ok = 0
    for img, a, exp, note in CITES:
        b = bytes.fromhex(exp.replace(" ", ""))
        if img == "M":
            off, data = a, MAIN
        else:
            off, data = a - 0xFFC00000, SUB
        act = data[off:off + len(b)]
        good = act == b
        ok += good
        rows.append("%s\t0x%06X\t0x%06X\t%s\t%s\t%s\t%s" % (
            "MAIN" if img == "M" else "SUB", a, off, exp, act.hex(" "), "PASS" if good else "FAIL", note))
    rows.append("# %d/%d pass; MAIN sha256 %s; SUB sha256 %s" % (
        ok, len(CITES), hashlib.sha256(MAIN).hexdigest(), hashlib.sha256(SUB).hexdigest()))
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "verify.tsv")
    with open(out, "w", encoding="utf-8", newline="\n") as h:
        h.write("\n".join(rows) + "\n")
    print(rows[-1])
    for r in rows:
        if "\tFAIL\t" in r:
            print(r)


main()
