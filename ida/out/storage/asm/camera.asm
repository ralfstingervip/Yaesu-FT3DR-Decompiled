; ==== camera  FFF07E00-FFF08900  (file 307E00-308900) ====
FFF07E00  09                     sub_FFF07E00 bra.s   loc_FFF07E07+2   ; <<<< FUNC sub_FFF07E00
FFF07E01  09                     sub_FFF07E01 bra.s   loc_FFF07E07+3   ; <<<< FUNC sub_FFF07E01
FFF07E02  c600c2090a             sub_FFF07E02 mov.b   arg_9BE[sp], arg_6[sp]   ; <<<< FUNC sub_FFF07E02
FFF07E07  f600db09               loc_FFF07E07 btst    #0, arg_9D7[sp].b
FFF07E0B  1d                                bne.s   loc_FFF07E10
FFF07E0C  f80630                            mov.l   #30h, 0[sp] ; '0'
FFF07E0F  0c                                bra.s   loc_FFF07E13
FFF07E10  f80633                 loc_FFF07E10 mov.l   #33h, 0[sp] ; '3'
FFF07E13  ec01                   loc_FFF07E13 mov.l   0[sp], r1
FFF07E15  8301                              mov.b   r1, arg_8[sp]
FFF07E17  5e02ea04                          movu.w  arg_9D0[sp], r2
FFF07E1B  5e01ec04                          movu.w  arg_9D4[sp], r1
FFF07E1F  710404                            add     #arg_0, sp, r4
FFF07E22  6603                              mov.l   #0, r3
FFF07E24  05c329ff                          bsr.a   sub_FFEFA7E7
FFF07E28  5e02ea04                          movu.w  arg_9D0[sp], r2
FFF07E2C  5e01e904                          movu.w  arg_9CE[sp], r1
FFF07E30  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF07E36  051288fe                          bsr.a   sub_FFEF0648
FFF07E3A  6621                              mov.l   #2, r1
FFF07E3C  39ea09                            bsr.w   sub_FFF08826
FFF07E3F  7200dc09                          add     #9DCh, sp, sp
FFF07E43  02                                rts
FFF07E44  7200dc09               sub_FFF07E44 add     #9DCh, sp, sp   ; <<<< FUNC sub_FFF07E44
FFF07E48  02                                rts
FFF07E49  720014ff               sub_FFF07E49 add     #-0ECh, sp, sp   ; <<<< FUNC sub_FFF07E49
FFF07E4D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF07E53  c5e020eb                          mov.b   20h[r14], 0ECh+var_1[sp]
FFF07E57  f905741b                          mov.w   #1Bh, 0ECh+var_4[sp]
FFF07E5B  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF07E61  b019                              movu.b  1[r1], r1
FFF07E63  7551c4                            cmp     #-3Ch, r1
FFF07E66  3a8800                            beq.w   loc_FFF07EEE
FFF07E69  7551c3                            cmp     #-3Dh, r1
FFF07E6C  207d                              beq.b   loc_FFF07EE9
FFF07E6E  721140ff                          add     #-0C0h, r1, r1
FFF07E72  6111                              cmp     #1, r1
FFF07E74  2505                              bleu.b  loc_FFF07E79
FFF07E76  388903                            bra.w   loc_FFF081FF
FFF07E79  5901eb                 loc_FFF07E79 movu.b  0ECh+var_1[sp], r1
FFF07E7C  6131                              cmp     #3, r1
FFF07E7E  2906                              blt.b   loc_FFF07E84
FFF07E80  f904eb02                          mov.b   #2, 0ECh+var_1[sp]
FFF07E84  fbe2728f0000           loc_FFF07E84 mov.l   #8F72h, r14
FFF07E8A  58ee                              movu.b  [r14], r14
FFF07E8C  610e                              cmp     #0, r14
FFF07E8E  2121                              bne.b   loc_FFF07EAF
FFF07E90  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF07E93  fb2297a3f4ff                      mov.l   #unk_FFF4A397, r2
FFF07E99  72018e00                          add     #0ECh+var_5E, sp, r1
FFF07E9D  7f8f                              smovf
FFF07E9F  5901eb                            movu.b  0ECh+var_1[sp], r1
FFF07EA2  72048e00                          add     #0ECh+var_5E, sp, r4
FFF07EA6  6612                              mov.l   #1, r2
FFF07EA8  ef23                              mov.l   r2, r3
FFF07EAA  39a8b7                            bsr.w   sub_FFF03652
FFF07EAD  2e1d                              bra.b   loc_FFF07ECA
FFF07EAF  75435a                 loc_FFF07EAF mov.l   #5Ah, r3 ; 'Z'
FFF07EB2  fb22f1a3f4ff                      mov.l   #unk_FFF4A3F1, r2
FFF07EB8  710134                            add     #0ECh+var_B8, sp, r1
FFF07EBB  7f8f                              smovf
FFF07EBD  5901eb                            movu.b  0ECh+var_1[sp], r1
FFF07EC0  710434                            add     #0ECh+var_B8, sp, r4
FFF07EC3  6612                              mov.l   #1, r2
FFF07EC5  ef23                              mov.l   r2, r3
FFF07EC7  398bb7                            bsr.w   sub_FFF03652
FFF07ECA  6040                   loc_FFF07ECA sub     #4, sp
FFF07ECC  3c0200                            mov.b   #0, 0F0h+var_EE[sp]
FFF07ECF  3c0105                            mov.b   #5, 0F0h+var_EF[sp]
FFF07ED2  f80405                            mov.b   #5, 0F0h+var_F0[sp]
FFF07ED5  7544b4                            mov.l   #-4Ch, r4
FFF07ED8  6663                              mov.l   #6, r3
FFF07EDA  75423c                            mov.l   #3Ch, r2 ; '<'
FFF07EDD  fb1a3701                          mov.l   #137h, r1
FFF07EE1  054a2bff                          bsr.a   sub_FFEFAA2B
FFF07EE5  6240                              add     #4, sp
FFF07EE7  673b                              rtsd    #3Bh ; ';'
FFF07EE9  39c086                 loc_FFF07EE9 bsr.w   sub_FFF005A9
FFF07EEC  673b                              rtsd    #3Bh ; ';'
FFF07EEE  710120                 loc_FFF07EEE add     #0ECh+var_CC, sp, r1
FFF07EF1  0527ac00                          bsr.a   sub_FFF12B18
FFF07EF5  9389                              mov.w   r1, 0ECh+var_CE[sp]
FFF07EF7  bb89                              movu.w  0ECh+var_CE[sp], r1
FFF07EF9  6101                              cmp     #0, r1
FFF07EFB  3b0403                            bne.w   loc_FFF081FF
FFF07EFE  e5000a06                          mov.l   0ECh+var_C4[sp], 0ECh+var_D4[sp]
FFF07F02  e5000905                          mov.l   0ECh+var_C8[sp], 0ECh+var_D8[sp]
FFF07F06  aa09                              mov.l   0ECh+var_C8[sp], r1
FFF07F08  0681010a                          sub     0ECh+var_C4[sp].l, r1
FFF07F0C  a101                              mov.l   r1, 0ECh+var_DC[sp]
FFF07F0E  6040                              sub     #4, sp
FFF07F10  f809ffff                          mov.w   #-1, 0F0h+var_F0[sp]
FFF07F14  66e4                              mov.l   #0Eh, r4
FFF07F16  fb3a1801                          mov.l   #118h, r3
FFF07F1A  754248                            mov.l   #48h, r2 ; 'H'
FFF07F1D  754114                            mov.l   #14h, r1
FFF07F20  05289dfe                          bsr.a   sub_FFEF1C48
FFF07F24  6240                              add     #4, sp
FFF07F26  06a1150104                        utof    0ECh+var_DC[sp].l, r1
FFF07F2B  06a1150e05                        utof    0ECh+var_D8[sp].l, r14
FFF07F30  fc93e1                            fdiv    r14, r1
FFF07F33  e301                              mov.l   r1, 0ECh+var_EC[sp]
FFF07F35  ec01                              mov.l   0ECh+var_EC[sp], r1
FFF07F37  6040                              sub     #4, sp
FFF07F39  f809ff03                          mov.w   #3FFh, 0F0h+var_F0[sp]
FFF07F3D  fd723100008a43                    fmul    #438A0000h, r1
FFF07F44  fca71e                            ftou    r1, r14
FFF07F47  5fe3                              movu.w  r14, r3
FFF07F49  66a4                              mov.l   #0Ah, r4
FFF07F4B  75424a                            mov.l   #4Ah, r2 ; 'J'
FFF07F4E  754116                            mov.l   #16h, r1
FFF07F51  05f79cfe                          bsr.a   sub_FFEF1C48
FFF07F55  6240                              add     #4, sp
FFF07F57  a902                              mov.l   0ECh+var_DC[sp], r2
FFF07F59  71010b                            add     #0ECh+var_E1, sp, r1
FFF07F5C  05319ffd                          bsr.a   sub_FFEE1E8D
FFF07F60  c5000b05                          mov.b   0ECh+var_E1[sp], 0ECh+var_E7[sp]
FFF07F64  c5000c06                          mov.b   0ECh+var_E0[sp], 0ECh+var_E6[sp]
FFF07F68  b181                              movu.b  0ECh+var_E6[sp], r1
FFF07F6A  755120                            cmp     #20h, r1 ; ' '
FFF07F6D  1d                                bne.s   loc_FFF07F72
FFF07F6E  3c0720                            mov.b   #20h, 0ECh+var_E5[sp] ; ' '
FFF07F71  0c                                bra.s   loc_FFF07F75
FFF07F72  3c072c                 loc_FFF07F72 mov.b   #2Ch, 0ECh+var_E5[sp] ; ','
FFF07F75  c5000d08               loc_FFF07F75 mov.b   0ECh+var_DF[sp], 0ECh+var_E4[sp]
FFF07F79  c5000e09                          mov.b   0ECh+var_DE[sp], 0ECh+var_E3[sp]
FFF07F7D  c5000f0a                          mov.b   0ECh+var_DD[sp], 0ECh+var_E2[sp]
FFF07F81  6040                              sub     #4, sp
FFF07F83  f809ff03                          mov.w   #3FFh, 0F0h+var_F0[sp]
FFF07F87  66c3                              mov.l   #0Ch, r3
FFF07F89  75426d                            mov.l   #6Dh, r2 ; 'm'
FFF07F8C  6661                              mov.l   #6, r1
FFF07F8E  ef34                              mov.l   r3, r4
FFF07F90  05b89cfe                          bsr.a   sub_FFEF1C48
FFF07F94  6240                              add     #4, sp
FFF07F96  60c0                              sub     #0Ch, sp
FFF07F98  710111                            add     #0F8h+var_E7, sp, r1
FFF07F9B  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF07F9D  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF07FA0  f80406                            mov.b   #6, 0F8h+var_F8[sp]
FFF07FA3  6604                              mov.l   #0, r4
FFF07FA5  66d3                              mov.l   #0Dh, r3
FFF07FA7  754265                            mov.l   #65h, r2 ; 'e'
FFF07FAA  7541ae                            mov.l   #-52h, r1
FFF07FAD  05769bfe                          bsr.a   sub_FFEF1B23
FFF07FB1  62c0                              add     #0Ch, sp
FFF07FB3  60c0                              sub     #0Ch, sp
FFF07FB5  fb124ba4f4ff                      mov.l   #unk_FFF4A44B, r1
FFF07FBB  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF07FBD  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF07FC0  f80402                            mov.b   #2, 0F8h+var_F8[sp]
FFF07FC3  6604                              mov.l   #0, r4
FFF07FC5  66d3                              mov.l   #0Dh, r3
FFF07FC7  754265                            mov.l   #65h, r2 ; 'e'
FFF07FCA  fb1a1001                          mov.l   #110h, r1
FFF07FCE  05559bfe                          bsr.a   sub_FFEF1B23
FFF07FD2  62c0                              add     #0Ch, sp
FFF07FD4  a982                              mov.l   0ECh+var_D4[sp], r2
FFF07FD6  71010b                            add     #0ECh+var_E1, sp, r1
FFF07FD9  05b49efd                          bsr.a   sub_FFEE1E8D
FFF07FDD  c5000b05                          mov.b   0ECh+var_E1[sp], 0ECh+var_E7[sp]
FFF07FE1  c5000c06                          mov.b   0ECh+var_E0[sp], 0ECh+var_E6[sp]
FFF07FE5  b181                              movu.b  0ECh+var_E6[sp], r1
FFF07FE7  755120                            cmp     #20h, r1 ; ' '
FFF07FEA  1d                                bne.s   loc_FFF07FEF
FFF07FEB  3c0720                            mov.b   #20h, 0ECh+var_E5[sp] ; ' '
FFF07FEE  0c                                bra.s   loc_FFF07FF2
FFF07FEF  3c072c                 loc_FFF07FEF mov.b   #2Ch, 0ECh+var_E5[sp] ; ','
FFF07FF2  c5000d08               loc_FFF07FF2 mov.b   0ECh+var_DF[sp], 0ECh+var_E4[sp]
FFF07FF6  c5000e09                          mov.b   0ECh+var_DE[sp], 0ECh+var_E3[sp]
FFF07FFA  c5000f0a                          mov.b   0ECh+var_DD[sp], 0ECh+var_E2[sp]
FFF07FFE  6040                              sub     #4, sp
FFF08000  f809ffff                          mov.w   #-1, 0F0h+var_F0[sp]
FFF08004  66c3                              mov.l   #0Ch, r3
FFF08006  754291                            mov.l   #-6Fh, r2
FFF08009  6661                              mov.l   #6, r1
FFF0800B  ef34                              mov.l   r3, r4
FFF0800D  053b9cfe                          bsr.a   sub_FFEF1C48
FFF08011  6240                              add     #4, sp
FFF08013  60c0                              sub     #0Ch, sp
FFF08015  710111                            add     #0F8h+var_E7, sp, r1
FFF08018  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF0801A  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF0801D  f80406                            mov.b   #6, 0F8h+var_F8[sp]
FFF08020  6604                              mov.l   #0, r4
FFF08022  66d3                              mov.l   #0Dh, r3
FFF08024  754289                            mov.l   #-77h, r2
FFF08027  7541ae                            mov.l   #-52h, r1
FFF0802A  05f99afe                          bsr.a   sub_FFEF1B23
FFF0802E  62c0                              add     #0Ch, sp
FFF08030  60c0                              sub     #0Ch, sp
FFF08032  fb124ba4f4ff                      mov.l   #unk_FFF4A44B, r1
FFF08038  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF0803A  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF0803D  f80402                            mov.b   #2, 0F8h+var_F8[sp]
FFF08040  6604                              mov.l   #0, r4
FFF08042  66d3                              mov.l   #0Dh, r3
FFF08044  754289                            mov.l   #-77h, r2
FFF08047  fb1a1001                          mov.l   #110h, r1
FFF0804B  05d89afe                          bsr.a   sub_FFEF1B23
FFF0804F  62c0                              add     #0Ch, sp
FFF08051  a90a                              mov.l   0ECh+var_D8[sp], r2
FFF08053  71010b                            add     #0ECh+var_E1, sp, r1
FFF08056  05379efd                          bsr.a   sub_FFEE1E8D
FFF0805A  c5000b05                          mov.b   0ECh+var_E1[sp], 0ECh+var_E7[sp]
FFF0805E  c5000c06                          mov.b   0ECh+var_E0[sp], 0ECh+var_E6[sp]
FFF08062  b181                              movu.b  0ECh+var_E6[sp], r1
FFF08064  755120                            cmp     #20h, r1 ; ' '
FFF08067  1d                                bne.s   loc_FFF0806C
FFF08068  3c0720                            mov.b   #20h, 0ECh+var_E5[sp] ; ' '
FFF0806B  0c                                bra.s   loc_FFF0806F
FFF0806C  3c072c                 loc_FFF0806C mov.b   #2Ch, 0ECh+var_E5[sp] ; ','
FFF0806F  c5000d08               loc_FFF0806F mov.b   0ECh+var_DF[sp], 0ECh+var_E4[sp]
FFF08073  c5000e09                          mov.b   0ECh+var_DE[sp], 0ECh+var_E3[sp]
FFF08077  c5000f0a                          mov.b   0ECh+var_DD[sp], 0ECh+var_E2[sp]
FFF0807B  60c0                              sub     #0Ch, sp
FFF0807D  710111                            add     #0F8h+var_E7, sp, r1
FFF08080  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF08082  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF08085  f80406                            mov.b   #6, 0F8h+var_F8[sp]
FFF08088  6604                              mov.l   #0, r4
FFF0808A  66d3                              mov.l   #0Dh, r3
FFF0808C  7542ad                            mov.l   #-53h, r2
FFF0808F  7541ae                            mov.l   #-52h, r1
FFF08092  05919afe                          bsr.a   sub_FFEF1B23
FFF08096  62c0                              add     #0Ch, sp
FFF08098  60c0                              sub     #0Ch, sp
FFF0809A  fb124ba4f4ff                      mov.l   #unk_FFF4A44B, r1
FFF080A0  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF080A2  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF080A5  f80402                            mov.b   #2, 0F8h+var_F8[sp]
FFF080A8  6604                              mov.l   #0, r4
FFF080AA  66d3                              mov.l   #0Dh, r3
FFF080AC  7542ad                            mov.l   #-53h, r2
FFF080AF  fb1a1001                          mov.l   #110h, r1
FFF080B3  05709afe                          bsr.a   sub_FFEF1B23
FFF080B7  62c0                              add     #0Ch, sp
FFF080B9  fbe2728f0000                      mov.l   #8F72h, r14
FFF080BF  58ee                              movu.b  [r14], r14
FFF080C1  610e                              cmp     #0, r14
FFF080C3  3ba400                            bne.w   loc_FFF08167
FFF080C6  60c0                              sub     #0Ch, sp
FFF080C8  fb12ea87f4ff                      mov.l   #unk_FFF487EA, r1
FFF080CE  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF080D0  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF080D3  f80401                            mov.b   #1, 0F8h+var_F8[sp]
FFF080D6  6604                              mov.l   #0, r4
FFF080D8  66d3                              mov.l   #0Dh, r3
FFF080DA  754265                            mov.l   #65h, r2 ; 'e'
FFF080DD  754192                            mov.l   #-6Eh, r1
FFF080E0  05439afe                          bsr.a   sub_FFEF1B23
FFF080E4  62c0                              add     #0Ch, sp
FFF080E6  60c0                              sub     #0Ch, sp
FFF080E8  fb12ea87f4ff                      mov.l   #unk_FFF487EA, r1
FFF080EE  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF080F0  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF080F3  f80401                            mov.b   #1, 0F8h+var_F8[sp]
FFF080F6  6604                              mov.l   #0, r4
FFF080F8  66d3                              mov.l   #0Dh, r3
FFF080FA  754289                            mov.l   #-77h, r2
FFF080FD  754192                            mov.l   #-6Eh, r1
FFF08100  05239afe                          bsr.a   sub_FFEF1B23
FFF08104  62c0                              add     #0Ch, sp
FFF08106  60c0                              sub     #0Ch, sp
FFF08108  fb12ea87f4ff                      mov.l   #unk_FFF487EA, r1
FFF0810E  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF08110  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF08113  f80401                            mov.b   #1, 0F8h+var_F8[sp]
FFF08116  6604                              mov.l   #0, r4
FFF08118  66d3                              mov.l   #0Dh, r3
FFF0811A  7542ad                            mov.l   #-53h, r2
FFF0811D  754192                            mov.l   #-6Eh, r1
FFF08120  05039afe                          bsr.a   sub_FFEF1B23
FFF08124  62c0                              add     #0Ch, sp
FFF08126  fb424ea4f4ff                      mov.l   #aHmqnn0h, r4; ";HMQNN0h"
FFF0812C  fb3e00aa00                        mov.l   #0AA00h, r3
FFF08131  754265                            mov.l   #65h, r2 ; 'e'
FFF08134  754114                            mov.l   #14h, r1
FFF08137  05b026ff                          bsr.a   sub_FFEFA7E7
FFF0813B  fb4257a4f4ff                      mov.l   #a6uMfnl, r4; "6u$-MFNL"
FFF08141  fb3e00aa00                        mov.l   #0AA00h, r3
FFF08146  754289                            mov.l   #-77h, r2
FFF08149  754114                            mov.l   #14h, r1
FFF0814C  059b26ff                          bsr.a   sub_FFEFA7E7
FFF08150  fb4260a4f4ff                      mov.l   #aMfnl, r4; "MFNL"
FFF08156  fb3e00a000                        mov.l   #0A000h, r3
FFF0815B  7542ad                            mov.l   #-53h, r2
FFF0815E  754114                            mov.l   #14h, r1
FFF08161  058626ff                          bsr.a   sub_FFEFA7E7
FFF08165  673b                              rtsd    #3Bh ; ';'
FFF08167  60c0                   loc_FFF08167 sub     #0Ch, sp
FFF08169  fb12ea87f4ff                      mov.l   #unk_FFF487EA, r1
FFF0816F  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF08171  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF08174  f80401                            mov.b   #1, 0F8h+var_F8[sp]
FFF08177  6604                              mov.l   #0, r4
FFF08179  66d3                              mov.l   #0Dh, r3
FFF0817B  754265                            mov.l   #65h, r2 ; 'e'
FFF0817E  7541a0                            mov.l   #-60h, r1
FFF08181  05a299fe                          bsr.a   sub_FFEF1B23
FFF08185  62c0                              add     #0Ch, sp
FFF08187  60c0                              sub     #0Ch, sp
FFF08189  fb12ea87f4ff                      mov.l   #unk_FFF487EA, r1
FFF0818F  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF08191  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF08194  f80401                            mov.b   #1, 0F8h+var_F8[sp]
FFF08197  6604                              mov.l   #0, r4
FFF08199  66d3                              mov.l   #0Dh, r3
FFF0819B  754289                            mov.l   #-77h, r2
FFF0819E  7541a0                            mov.l   #-60h, r1
FFF081A1  058299fe                          bsr.a   sub_FFEF1B23
FFF081A5  62c0                              add     #0Ch, sp
FFF081A7  60c0                              sub     #0Ch, sp
FFF081A9  fb12ea87f4ff                      mov.l   #unk_FFF487EA, r1
FFF081AF  a009                              mov.l   r1, 0F8h+var_F4[sp]
FFF081B1  3c0801                            mov.b   #1, 0F8h+var_F0[sp]
FFF081B4  f80401                            mov.b   #1, 0F8h+var_F8[sp]
FFF081B7  6604                              mov.l   #0, r4
FFF081B9  66d3                              mov.l   #0Dh, r3
FFF081BB  7542ad                            mov.l   #-53h, r2
FFF081BE  7541a0                            mov.l   #-60h, r1
FFF081C1  056299fe                          bsr.a   sub_FFEF1B23
FFF081C5  62c0                              add     #0Ch, sp
FFF081C7  fb4265a4f4ff                      mov.l   #aUsedSpace, r4; "Used space"
FFF081CD  6603                              mov.l   #0, r3
FFF081CF  754265                            mov.l   #65h, r2 ; 'e'
FFF081D2  754114                            mov.l   #14h, r1
FFF081D5  051226ff                          bsr.a   sub_FFEFA7E7
FFF081D9  fb4270a4f4ff                      mov.l   #aFreeSpace, r4; "Free space"
FFF081DF  6603                              mov.l   #0, r3
FFF081E1  754289                            mov.l   #-77h, r2
FFF081E4  754114                            mov.l   #14h, r1
FFF081E7  050026ff                          bsr.a   sub_FFEFA7E7
FFF081EB  fb427ba4f4ff                      mov.l   #aCapacity, r4; "Capacity"
FFF081F1  6603                              mov.l   #0, r3
FFF081F3  7542ad                            mov.l   #-53h, r2
FFF081F6  754114                            mov.l   #14h, r1
FFF081F9  05ee25ff                          bsr.a   sub_FFEFA7E7
FFF081FD  673b                              rtsd    #3Bh ; ';'
FFF081FF  673b                   loc_FFF081FF rtsd    #3Bh
FFF08201  7100e0                 sub_FFF08201 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF08201
FFF08204  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0820A  c5e0201f                          mov.b   20h[r14], 20h+var_1[sp]
FFF0820E  3d0e22                            mov.w   #22h, 20h+var_4[sp] ; '"'
FFF08211  3d0dd0                            mov.w   #-30h, 20h+var_6[sp]
FFF08214  3d0c41                            mov.w   #41h, 20h+var_8[sp] ; 'A'
FFF08217  3d0b06                            mov.w   #6, 20h+var_A[sp]
FFF0821A  3d0ab4                            mov.w   #-4Ch, 20h+var_C[sp]
FFF0821D  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF08223  b019                              movu.b  1[r1], r1
FFF08225  7551d4                            cmp     #-2Ch, r1
FFF08228  3a2105                            beq.w   loc_FFF08749
FFF0822B  7551d2                            cmp     #-2Eh, r1
FFF0822E  3aa801                            beq.w   loc_FFF083D6
FFF08231  7551d3                            cmp     #-2Dh, r1
FFF08234  3a3b03                            beq.w   loc_FFF0856F
FFF08237  7551d0                            cmp     #-30h, r1
FFF0823A  3b5005                            bne.w   loc_FFF0878A
FFF0823D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08243  c5e0211f                          mov.b   21h[r14], 20h+var_1[sp]
FFF08247  b789                              movu.b  20h+var_1[sp], r1
FFF08249  6131                              cmp     #3, r1
FFF0824B  2905                              blt.b   loc_FFF08250
FFF0824D  3c8f02                            mov.b   #2, 20h+var_1[sp]
FFF08250  fbe2728f0000           loc_FFF08250 mov.l   #8F72h, r14
FFF08256  58ee                              movu.b  [r14], r14
FFF08258  610e                              cmp     #0, r14
FFF0825A  9b01                              mov.w   20h+var_8[sp], r1
FFF0825C  9b83                              mov.w   20h+var_4[sp], r3
FFF0825E  2117                              bne.b   loc_FFF08275
FFF08260  5f12                              movu.w  r1, r2
FFF08262  5f31                              movu.w  r3, r1
FFF08264  fb4284a4f4ff                      mov.l   #a5, r4; "%5%$%: :"
FFF0826A  fb3e00a800                        mov.l   #0A800h, r3
FFF0826F  057825ff                          bsr.a   sub_FFEFA7E7
FFF08273  2e12                              bra.b   loc_FFF08285
FFF08275  5f12                   loc_FFF08275 movu.w  r1, r2
FFF08277  5f31                              movu.w  r3, r1
FFF08279  fb428da4f4ff                      mov.l   #aSize, r4; "SIZE   :"
FFF0827F  6603                              mov.l   #0, r3
FFF08281  056625ff                          bsr.a   sub_FFEFA7E7
FFF08285  fbe24d8c0000           loc_FFF08285 mov.l   #8C4Dh, r14
FFF0828B  59ee22                            movu.b  22h[r14], r14
FFF0828E  610e                              cmp     #0, r14
FFF08290  9b01                              mov.w   20h+var_8[sp], r1
FFF08292  9b0b                              mov.w   20h+var_6[sp], r3
FFF08294  2114                              bne.b   loc_FFF082A8
FFF08296  5f12                              movu.w  r1, r2
FFF08298  5f31                              movu.w  r3, r1
FFF0829A  fb4296a4f4ff                      mov.l   #a320240, r4; "320*240"
FFF082A0  6603                              mov.l   #0, r3
FFF082A2  054525ff                          bsr.a   sub_FFEFA7E7
FFF082A6  2e12                              bra.b   loc_FFF082B8
FFF082A8  5f12                   loc_FFF082A8 movu.w  r1, r2
FFF082AA  5f31                              movu.w  r3, r1
FFF082AC  fb429ea4f4ff                      mov.l   #a160120, r4; "160*120"
FFF082B2  6603                              mov.l   #0, r3
FFF082B4  053325ff                          bsr.a   sub_FFEFA7E7
FFF082B8  bb01                   loc_FFF082B8 movu.w  20h+var_8[sp], r1
FFF082BA  711124                            add     #24h, r1, r1 ; '$'
FFF082BD  9301                              mov.w   r1, 20h+var_8[sp]
FFF082BF  fbe2728f0000                      mov.l   #8F72h, r14
FFF082C5  58ee                              movu.b  [r14], r14
FFF082C7  610e                              cmp     #0, r14
FFF082C9  9b01                              mov.w   20h+var_8[sp], r1
FFF082CB  9b83                              mov.w   20h+var_4[sp], r3
FFF082CD  2117                              bne.b   loc_FFF082E4
FFF082CF  5f12                              movu.w  r1, r2
FFF082D1  5f31                              movu.w  r3, r1
FFF082D3  fb42a6a4f4ff                      mov.l   #a2hA, r4; "2h<A   :"
FFF082D9  fb3e00a000                        mov.l   #0A000h, r3
FFF082DE  050925ff                          bsr.a   sub_FFEFA7E7
FFF082E2  2e12                              bra.b   loc_FFF082F4
FFF082E4  5f12                   loc_FFF082E4 movu.w  r1, r2
FFF082E6  5f31                              movu.w  r3, r1
FFF082E8  fb42afa4f4ff                      mov.l   #aQuality, r4; "QUALITY:"
FFF082EE  6603                              mov.l   #0, r3
FFF082F0  05f724ff                          bsr.a   sub_FFEFA7E7
FFF082F4  fbe24d8c0000           loc_FFF082F4 mov.l   #8C4Dh, r14
FFF082FA  59ee23                            movu.b  23h[r14], r14
FFF082FD  610e                              cmp     #0, r14
FFF082FF  2114                              bne.b   loc_FFF08313
FFF08301  bb02                              movu.w  20h+var_8[sp], r2
FFF08303  bb09                              movu.w  20h+var_6[sp], r1
FFF08305  fb428289f4ff                      mov.l   #unk_FFF48982, r4
FFF0830B  6603                              mov.l   #0, r3
FFF0830D  05da24ff                          bsr.a   sub_FFEFA7E7
FFF08311  2e35                              bra.b   loc_FFF08346
FFF08313  fbe24d8c0000           loc_FFF08313 mov.l   #8C4Dh, r14
FFF08319  59ee23                            movu.b  23h[r14], r14
FFF0831C  611e                              cmp     #1, r14
FFF0831E  9b01                              mov.w   20h+var_8[sp], r1
FFF08320  9b0b                              mov.w   20h+var_6[sp], r3
FFF08322  2114                              bne.b   loc_FFF08336
FFF08324  5f12                              movu.w  r1, r2
FFF08326  5f31                              movu.w  r3, r1
FFF08328  fb424d8af4ff                      mov.l   #aNormal, r4; "NORMAL"
FFF0832E  6603                              mov.l   #0, r3
FFF08330  05b724ff                          bsr.a   sub_FFEFA7E7
FFF08334  2e12                              bra.b   loc_FFF08346
FFF08336  5f12                   loc_FFF08336 movu.w  r1, r2
FFF08338  5f31                              movu.w  r3, r1
FFF0833A  fb428689f4ff                      mov.l   #aHigh, r4; "HIGH"
FFF08340  6603                              mov.l   #0, r3
FFF08342  05a524ff                          bsr.a   sub_FFEFA7E7
FFF08346  bb01                   loc_FFF08346 movu.w  20h+var_8[sp], r1
FFF08348  711124                            add     #24h, r1, r1 ; '$'
FFF0834B  9301                              mov.w   r1, 20h+var_8[sp]
FFF0834D  bb02                              movu.w  20h+var_8[sp], r2
FFF0834F  bb81                              movu.w  20h+var_4[sp], r1
FFF08351  fb42b8a4f4ff                      mov.l   #aSpSel, r4; "SP SEL :"
FFF08357  6603                              mov.l   #0, r3
FFF08359  058e24ff                          bsr.a   sub_FFEFA7E7
FFF0835D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08363  59ee24                            movu.b  24h[r14], r14
FFF08366  610e                              cmp     #0, r14
FFF08368  9b01                              mov.w   20h+var_8[sp], r1
FFF0836A  9b0b                              mov.w   20h+var_6[sp], r3
FFF0836C  2114                              bne.b   loc_FFF08380
FFF0836E  5f12                              movu.w  r1, r2
FFF08370  5f31                              movu.w  r3, r1
FFF08372  fb42c1a4f4ff                      mov.l   #aCamera, r4; "CAMERA"
FFF08378  6603                              mov.l   #0, r3
FFF0837A  056d24ff                          bsr.a   sub_FFEFA7E7
FFF0837E  2e12                              bra.b   loc_FFF08390
FFF08380  5f12                   loc_FFF08380 movu.w  r1, r2
FFF08382  5f31                              movu.w  r3, r1
FFF08384  fb42c8a4f4ff                      mov.l   #aIntSp, r4; "INT SP"
FFF0838A  6603                              mov.l   #0, r3
FFF0838C  055b24ff                          bsr.a   sub_FFEFA7E7
FFF08390  b789                   loc_FFF08390 movu.b  20h+var_1[sp], r1
FFF08392  751124                            mul     #24h, r1 ; '$'
FFF08395  711141                            add     #41h, r1, r1 ; 'A'
FFF08398  9209                              mov.w   r1, 20h+var_E[sp]
FFF0839A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF083A0  59ee20                            movu.b  20h[r14], r14
FFF083A3  610e                              cmp     #0, r14
FFF083A5  2112                              bne.b   loc_FFF083B7
FFF083A7  ba0a                              movu.w  20h+var_E[sp], r2
FFF083A9  ba89                              movu.w  20h+var_A[sp], r1
FFF083AB  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF083B1  059782fe                          bsr.a   sub_FFEF0648
FFF083B5  2e10                              bra.b   loc_FFF083C5
FFF083B7  ba0a                   loc_FFF083B7 movu.w  20h+var_E[sp], r2
FFF083B9  ba81                              movu.w  20h+var_C[sp], r1
FFF083BB  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF083C1  058782fe                          bsr.a   sub_FFEF0648
FFF083C5  6621                   loc_FFF083C5 mov.l   #2, r1
FFF083C7  395f04                            bsr.w   sub_FFF08826
FFF083CA  6631                              mov.l   #3, r1
FFF083CC  395a04                            bsr.w   sub_FFF08826
FFF083CF  6641                              mov.l   #4, r1
FFF083D1  395504                            bsr.w   sub_FFF08826
FFF083D4  6708                              rtsd    #8
FFF083D6  3d0779                 loc_FFF083D6 mov.w   #79h, 20h+var_12[sp] ; 'y'
FFF083D9  058523ff                          bsr.a   sub_FFEFA75E
FFF083DD  3c0d00                            mov.b   #0, 20h+var_13[sp]
FFF083E0  2e32                              bra.b   loc_FFF08412
FFF083E2  fbe248920600           loc_FFF083E2 mov.l   #69248h, r14
FFF083E8  b309                              movu.b  20h+var_13[sp], r1
FFF083EA  fe61e4                            mov.l   [r1, r14], r4
FFF083ED  b989                              movu.w  20h+var_12[sp], r1
FFF083EF  6613                              mov.l   #1, r3
FFF083F1  6642                              mov.l   #4, r2
FFF083F3  05e2e4fe                          bsr.a   sub_FFEF68D5
FFF083F7  fbe248920600                      mov.l   #69248h, r14
FFF083FD  b309                              movu.b  20h+var_13[sp], r1
FFF083FF  fe61ee                            mov.l   [r1, r14], r14
FFF08402  5ce1                              movu.w  [r14], r1
FFF08404  06c90107                          add     20h+var_12[sp].uw, r1
FFF08408  6211                              add     #1, r1
FFF0840A  9189                              mov.w   r1, 20h+var_12[sp]
FFF0840C  b309                              movu.b  20h+var_13[sp], r1
FFF0840E  6211                              add     #1, r1
FFF08410  8309                              mov.b   r1, 20h+var_13[sp]
FFF08412  b309                   loc_FFF08412 movu.b  20h+var_13[sp], r1
FFF08414  6161                              cmp     #6, r1
FFF08416  29cc                              blt.b   loc_FFF083E2
FFF08418  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0841E  c5e0201f                          mov.b   20h[r14], 20h+var_1[sp]
FFF08422  b789                              movu.b  20h+var_1[sp], r1
FFF08424  6121                              cmp     #2, r1
FFF08426  2905                              blt.b   loc_FFF0842B
FFF08428  3c8f01                            mov.b   #1, 20h+var_1[sp]
FFF0842B  b789                   loc_FFF0842B movu.b  20h+var_1[sp], r1
FFF0842D  6101                              cmp     #0, r1
FFF0842F  9b01                              mov.w   20h+var_8[sp], r1
FFF08431  9b83                              mov.w   20h+var_4[sp], r3
FFF08433  2115                              bne.b   loc_FFF08448
FFF08435  5f12                              movu.w  r1, r2
FFF08437  5f31                              movu.w  r3, r1
FFF08439  fb42dd86f4ff                      mov.l   #unk_FFF486DD, r4
FFF0843F  6603                              mov.l   #0, r3
FFF08441  05a623ff                          bsr.a   sub_FFEFA7E7
FFF08445  381101                            bra.w   loc_FFF08556
FFF08448  5f12                   loc_FFF08448 movu.w  r1, r2
FFF0844A  5f31                              movu.w  r3, r1
FFF0844C  fb428787f4ff                      mov.l   #unk_FFF48787, r4
FFF08452  6603                              mov.l   #0, r3
FFF08454  059323ff                          bsr.a   sub_FFEFA7E7
FFF08458  fbe2728f0000                      mov.l   #8F72h, r14
FFF0845E  58ee                              movu.b  [r14], r14
FFF08460  610e                              cmp     #0, r14
FFF08462  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08468  59ee21                            movu.b  21h[r14], r14
FFF0846B  215f                              bne.b   loc_FFF084CA
FFF0846D  613e                              cmp     #3, r14
FFF0846F  203c                              beq.b   loc_FFF084AB
FFF08471  71efff                            add     #-1, r14, r15
FFF08474  612f                              cmp     #2, r15
FFF08476  231e                              bltu.b  loc_FFF08494
FFF08478  610e                              cmp     #0, r14
FFF0847A  3bba00                            bne.w   loc_FFF08534
FFF0847D  bb81                              movu.w  20h+var_4[sp], r1
FFF0847F  fb42cfa4f4ff                      mov.l   #aB3Q, r4; "@\\B3:Q$_"
FFF08485  fb3e00aa00                        mov.l   #0AA00h, r3
FFF0848A  754265                            mov.l   #65h, r2 ; 'e'
FFF0848D  055a23ff                          bsr.a   sub_FFEFA7E7
FFF08491  38a300                            bra.w   loc_FFF08534
FFF08494  bb81                   loc_FFF08494 movu.w  20h+var_4[sp], r1
FFF08496  fb42d8a4f4ff                      mov.l   #aLB3, r4; "L$@\\B3"
FFF0849C  fb3e00a800                        mov.l   #0A800h, r3
FFF084A1  754265                            mov.l   #65h, r2 ; 'e'
FFF084A4  054323ff                          bsr.a   sub_FFEFA7E7
FFF084A8  388c00                            bra.w   loc_FFF08534
FFF084AB  05477efe               loc_FFF084AB bsr.a   sub_FFEF02F2
FFF084AF  6101                              cmp     #0, r1
FFF084B1  3a8300                            beq.w   loc_FFF08534
FFF084B4  bb81                              movu.w  20h+var_4[sp], r1
FFF084B6  fb42dfa4f4ff                      mov.l   #aB3cf, r4; "@\\B3Cf"
FFF084BC  fb3e00a800                        mov.l   #0A800h, r3
FFF084C1  754265                            mov.l   #65h, r2 ; 'e'
FFF084C4  052323ff                          bsr.a   sub_FFEFA7E7
FFF084C8  2e6c                              bra.b   loc_FFF08534
FFF084CA  613e                   loc_FFF084CA cmp     #3, r14
FFF084CC  2041                              beq.b   loc_FFF0850D
FFF084CE  71efff                            add     #-1, r14, r15
FFF084D1  612f                              cmp     #2, r15
FFF084D3  2319                              bltu.b  loc_FFF084EC
FFF084D5  610e                              cmp     #0, r14
FFF084D7  215d                              bne.b   loc_FFF08534
FFF084D9  bb81                              movu.w  20h+var_4[sp], r1
FFF084DB  fb42e6a4f4ff                      mov.l   #aConnected_0, r4; "Connected"
FFF084E1  6603                              mov.l   #0, r3
FFF084E3  754265                            mov.l   #65h, r2 ; 'e'
FFF084E6  050123ff                          bsr.a   sub_FFEFA7E7
FFF084EA  2e4a                              bra.b   loc_FFF08534
FFF084EC  bb81                   loc_FFF084EC movu.w  20h+var_4[sp], r1
FFF084EE  60c0                              sub     #0Ch, sp
FFF084F0  fb22f0a4f4ff                      mov.l   #aNotConnected_0, r2; "Not Connected"
FFF084F6  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF084F8  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF084FB  f8040d                            mov.b   #0Dh, 2Ch+var_2C[sp]
FFF084FE  6604                              mov.l   #0, r4
FFF08500  66d3                              mov.l   #0Dh, r3
FFF08502  754265                            mov.l   #65h, r2 ; 'e'
FFF08505  051e96fe                          bsr.a   sub_FFEF1B23
FFF08509  62c0                              add     #0Ch, sp
FFF0850B  2e29                              bra.b   loc_FFF08534
FFF0850D  05e57dfe               loc_FFF0850D bsr.a   sub_FFEF02F2
FFF08511  6101                              cmp     #0, r1
FFF08513  2021                              beq.b   loc_FFF08534
FFF08515  bb81                              movu.w  20h+var_4[sp], r1
FFF08517  60c0                              sub     #0Ch, sp
FFF08519  fb22fea4f4ff                      mov.l   #aConnecting, r2; "Connecting"
FFF0851F  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF08521  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF08524  f8040a                            mov.b   #0Ah, 2Ch+var_2C[sp]
FFF08527  6604                              mov.l   #0, r4
FFF08529  66d3                              mov.l   #0Dh, r3
FFF0852B  754265                            mov.l   #65h, r2 ; 'e'
FFF0852E  05f595fe                          bsr.a   sub_FFEF1B23
FFF08532  62c0                              add     #0Ch, sp
FFF08534  bb81                   loc_FFF08534 movu.w  20h+var_4[sp], r1
FFF08536  60c0                              sub     #0Ch, sp
FFF08538  fb224d8c0000                      mov.l   #8C4Dh, r2
FFF0853E  712222                            add     #22h, r2, r2 ; '"'
FFF08541  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF08543  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF08546  f80410                            mov.b   #10h, 2Ch+var_2C[sp]
FFF08549  6604                              mov.l   #0, r4
FFF0854B  66d3                              mov.l   #0Dh, r3
FFF0854D  754289                            mov.l   #-77h, r2
FFF08550  05d395fe                          bsr.a   sub_FFEF1B23
FFF08554  62c0                              add     #0Ch, sp
FFF08556  055380ff               loc_FFF08556 bsr.a   sub_FFF005A9
FFF0855A  bb02                              movu.w  20h+var_8[sp], r2
FFF0855C  ba89                              movu.w  20h+var_A[sp], r1
FFF0855E  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF08564  05e480fe                          bsr.a   sub_FFEF0648
FFF08568  6621                              mov.l   #2, r1
FFF0856A  39bc02                            bsr.w   sub_FFF08826
FFF0856D  6708                              rtsd    #8
FFF0856F  3d0552                 loc_FFF0856F mov.w   #52h, 20h+var_16[sp] ; 'R'
FFF08572  05ec21ff                          bsr.a   sub_FFEFA75E
FFF08576  3c0900                            mov.b   #0, 20h+var_17[sp]
FFF08579  2e32                              bra.b   loc_FFF085AB
FFF0857B  fbe2f8900600           loc_FFF0857B mov.l   #690F8h, r14
FFF08581  b209                              movu.b  20h+var_17[sp], r1
FFF08583  fe61e4                            mov.l   [r1, r14], r4
FFF08586  b909                              movu.w  20h+var_16[sp], r1
FFF08588  6613                              mov.l   #1, r3
FFF0858A  6642                              mov.l   #4, r2
FFF0858C  0549e3fe                          bsr.a   sub_FFEF68D5
FFF08590  fbe2f8900600                      mov.l   #690F8h, r14
FFF08596  b209                              movu.b  20h+var_17[sp], r1
FFF08598  fe61ee                            mov.l   [r1, r14], r14
FFF0859B  5ce1                              movu.w  [r14], r1
FFF0859D  06c90105                          add     20h+var_16[sp].uw, r1
FFF085A1  6211                              add     #1, r1
FFF085A3  9109                              mov.w   r1, 20h+var_16[sp]
FFF085A5  b209                              movu.b  20h+var_17[sp], r1
FFF085A7  6211                              add     #1, r1
FFF085A9  8209                              mov.b   r1, 20h+var_17[sp]
FFF085AB  b209                   loc_FFF085AB movu.b  20h+var_17[sp], r1
FFF085AD  61b1                              cmp     #0Bh, r1
FFF085AF  29cc                              blt.b   loc_FFF0857B
FFF085B1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF085B7  c5e02011                          mov.b   20h[r14], 20h+var_F[sp]
FFF085BB  3d0306                            mov.w   #6, 20h+var_1A[sp]
FFF085BE  3d0219                            mov.w   #19h, 20h+var_1C[sp]
FFF085C1  3d011f                            mov.w   #1Fh, 20h+var_1E[sp]
FFF085C4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF085CA  c5e02101                          mov.b   21h[r14], 20h+var_1F[sp]
FFF085CE  3c8000                            mov.b   #0, 20h+var_10[sp]
FFF085D1  381201                            bra.w   loc_FFF086E3
FFF085D4  b401                   loc_FFF085D4 movu.b  20h+var_10[sp], r1
FFF085D6  6101                              cmp     #0, r1
FFF085D8  fcdbe0                            sceq.l  r14
FFF085DB  450111                            cmp     20h+var_F[sp], r1
FFF085DE  2156                              bne.b   loc_FFF08634
FFF085E0  5bee                              movu.b  r14, r14
FFF085E2  610e                              cmp     #0, r14
FFF085E4  2029                              beq.b   loc_FFF0860D
FFF085E6  b80c                              movu.w  20h+var_1E[sp], r4
FFF085E8  ef4e                              mov.l   r4, r14
FFF085EA  4d0e10                            mul     20h+var_10[sp], r14
FFF085ED  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF085F1  b889                              movu.w  20h+var_1A[sp], r1
FFF085F3  6040                              sub     #4, sp
FFF085F5  f80980f9                          mov.w   #-680h, 24h+var_24[sp]
FFF085F9  fbfa3301                          mov.l   #133h, r15
FFF085FD  431f                              sub     r1, r15
FFF085FF  5ff3                              movu.w  r15, r3
FFF08601  621e                              add     #1, r14
FFF08603  5fe2                              movu.w  r14, r2
FFF08605  054396fe                          bsr.a   sub_FFEF1C48
FFF08609  6240                              add     #4, sp
FFF0860B  2e79                              bra.b   loc_FFF08684
FFF0860D  b80c                   loc_FFF0860D movu.w  20h+var_1E[sp], r4
FFF0860F  ef4e                              mov.l   r4, r14
FFF08611  4d0e10                            mul     20h+var_10[sp], r14
FFF08614  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF08618  b889                              movu.w  20h+var_1A[sp], r1
FFF0861A  6040                              sub     #4, sp
FFF0861C  f80980f9                          mov.w   #-680h, 24h+var_24[sp]
FFF08620  fbfa3301                          mov.l   #133h, r15
FFF08624  431f                              sub     r1, r15
FFF08626  5ff3                              movu.w  r15, r3
FFF08628  622e                              add     #2, r14
FFF0862A  5fe2                              movu.w  r14, r2
FFF0862C  051c96fe                          bsr.a   sub_FFEF1C48
FFF08630  6240                              add     #4, sp
FFF08632  2e52                              bra.b   loc_FFF08684
FFF08634  5bee                   loc_FFF08634 movu.b  r14, r14
FFF08636  610e                              cmp     #0, r14
FFF08638  2028                              beq.b   loc_FFF08660
FFF0863A  b80c                              movu.w  20h+var_1E[sp], r4
FFF0863C  ef4e                              mov.l   r4, r14
FFF0863E  4d0e10                            mul     20h+var_10[sp], r14
FFF08641  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF08645  b889                              movu.w  20h+var_1A[sp], r1
FFF08647  6040                              sub     #4, sp
FFF08649  f80500                            mov.w   #0, 24h+var_24[sp]
FFF0864C  fbfa3301                          mov.l   #133h, r15
FFF08650  431f                              sub     r1, r15
FFF08652  5ff3                              movu.w  r15, r3
FFF08654  621e                              add     #1, r14
FFF08656  5fe2                              movu.w  r14, r2
FFF08658  05f095fe                          bsr.a   sub_FFEF1C48
FFF0865C  6240                              add     #4, sp
FFF0865E  2e26                              bra.b   loc_FFF08684
FFF08660  b80c                   loc_FFF08660 movu.w  20h+var_1E[sp], r4
FFF08662  ef4e                              mov.l   r4, r14
FFF08664  4d0e10                            mul     20h+var_10[sp], r14
FFF08667  06c90e02                          add     20h+var_1C[sp].uw, r14
FFF0866B  b889                              movu.w  20h+var_1A[sp], r1
FFF0866D  6040                              sub     #4, sp
FFF0866F  f80500                            mov.w   #0, 24h+var_24[sp]
FFF08672  fbfa3301                          mov.l   #133h, r15
FFF08676  431f                              sub     r1, r15
FFF08678  5ff3                              movu.w  r15, r3
FFF0867A  622e                              add     #2, r14
FFF0867C  5fe2                              movu.w  r14, r2
FFF0867E  05ca95fe                          bsr.a   sub_FFEF1C48
FFF08682  6240                              add     #4, sp
FFF08684  b401                   loc_FFF08684 movu.b  20h+var_10[sp], r1
FFF08686  fdc41e                            shll    #4, r1, r14
FFF08689  fb224d8c0000                      mov.l   #8C4Dh, r2
FFF0868F  4be2                              add     r14, r2
FFF08691  712222                            add     #22h, r2, r2 ; '"'
FFF08694  ef1e                              mov.l   r1, r14
FFF08696  06cd0e01                          mul     20h+var_1E[sp].uw, r14
FFF0869A  71ee1d                            add     #1Dh, r14, r14
FFF0869D  b00b                              movu.b  20h+var_1F[sp], r3
FFF0869F  fc6b31                            btst    r1, r3
FFF086A2  9889                              mov.w   20h+var_1A[sp], r1
FFF086A4  2021                              beq.b   loc_FFF086C5
FFF086A6  60c0                              sub     #0Ch, sp
FFF086A8  f90905ef7b                        mov.w   #7BEFh, 2Ch+var_22[sp]
FFF086AD  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF086B0  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF086B2  f80410                            mov.b   #10h, 2Ch+var_2C[sp]
FFF086B5  5fe2                              movu.w  r14, r2
FFF086B7  5f11                              movu.w  r1, r1
FFF086B9  6604                              mov.l   #0, r4
FFF086BB  66d3                              mov.l   #0Dh, r3
FFF086BD  05f494fe                          bsr.a   sub_FFEF1BB1
FFF086C1  62c0                              add     #0Ch, sp
FFF086C3  2e1a                              bra.b   loc_FFF086DD
FFF086C5  60c0                   loc_FFF086C5 sub     #0Ch, sp
FFF086C7  3c0801                            mov.b   #1, 2Ch+var_24[sp]
FFF086CA  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF086CC  f80410                            mov.b   #10h, 2Ch+var_2C[sp]
FFF086CF  5fe2                              movu.w  r14, r2
FFF086D1  5f11                              movu.w  r1, r1
FFF086D3  6604                              mov.l   #0, r4
FFF086D5  66d3                              mov.l   #0Dh, r3
FFF086D7  054c94fe                          bsr.a   sub_FFEF1B23
FFF086DB  62c0                              add     #0Ch, sp
FFF086DD  b401                   loc_FFF086DD movu.b  20h+var_10[sp], r1
FFF086DF  6211                              add     #1, r1
FFF086E1  8401                              mov.b   r1, 20h+var_10[sp]
FFF086E3  b401                   loc_FFF086E3 movu.b  20h+var_10[sp], r1
FFF086E5  6151                              cmp     #5, r1
FFF086E7  2805                              bge.b   loc_FFF086EC
FFF086E9  38ebfe                            bra.w   loc_FFF085D4
FFF086EC  3c8001                 loc_FFF086EC mov.b   #1, 20h+var_10[sp]
FFF086EF  2e2e                              bra.b   loc_FFF0871D
FFF086F1  b402                   loc_FFF086F1 movu.b  20h+var_10[sp], r2
FFF086F3  06cd0201                          mul     20h+var_1E[sp].uw, r2
FFF086F7  06c90202                          add     20h+var_1C[sp].uw, r2
FFF086FB  b889                              movu.w  20h+var_1A[sp], r1
FFF086FD  6040                              sub     #4, sp
FFF086FF  f80995ad                          mov.w   #-526Bh, 24h+var_24[sp]
FFF08703  fbea3301                          mov.l   #133h, r14
FFF08707  431e                              sub     r1, r14
FFF08709  5fe3                              movu.w  r14, r3
FFF0870B  6212                              add     #1, r2
FFF0870D  5f22                              movu.w  r2, r2
FFF0870F  6614                              mov.l   #1, r4
FFF08711  053795fe                          bsr.a   sub_FFEF1C48
FFF08715  6240                              add     #4, sp
FFF08717  b401                              movu.b  20h+var_10[sp], r1
FFF08719  6211                              add     #1, r1
FFF0871B  8401                              mov.b   r1, 20h+var_10[sp]
FFF0871D  b401                   loc_FFF0871D movu.b  20h+var_10[sp], r1
FFF0871F  6151                              cmp     #5, r1
FFF08721  29d0                              blt.b   loc_FFF086F1
FFF08723  05867eff                          bsr.a   sub_FFF005A9
FFF08727  b882                              movu.w  20h+var_1C[sp], r2
FFF08729  6040                              sub     #4, sp
FFF0872B  3c0200                            mov.b   #0, 24h+var_22[sp]
FFF0872E  3c0101                            mov.b   #1, 24h+var_23[sp]
FFF08731  f80401                            mov.b   #1, 24h+var_24[sp]
FFF08734  754eb7                            mov.l   #-49h, r14
FFF08737  432e                              sub     r2, r14
FFF08739  5fe4                              movu.w  r14, r4
FFF0873B  6663                              mov.l   #6, r3
FFF0873D  fb1a3701                          mov.l   #137h, r1
FFF08741  05ea22ff                          bsr.a   sub_FFEFAA2B
FFF08745  6240                              add     #4, sp
FFF08747  6708                              rtsd    #8
FFF08749  b789                   loc_FFF08749 movu.b  20h+var_1[sp], r1
FFF0874B  6101                              cmp     #0, r1
FFF0874D  9b01                              mov.w   20h+var_8[sp], r1
FFF0874F  9b83                              mov.w   20h+var_4[sp], r3
FFF08751  2114                              bne.b   loc_FFF08765
FFF08753  5f12                              movu.w  r1, r2
FFF08755  5f31                              movu.w  r3, r1
FFF08757  fb42dd86f4ff                      mov.l   #unk_FFF486DD, r4
FFF0875D  6603                              mov.l   #0, r3
FFF0875F  058820ff                          bsr.a   sub_FFEFA7E7
FFF08763  2e12                              bra.b   loc_FFF08775
FFF08765  5f12                   loc_FFF08765 movu.w  r1, r2
FFF08767  5f31                              movu.w  r3, r1
FFF08769  fb428787f4ff                      mov.l   #unk_FFF48787, r4
FFF0876F  6603                              mov.l   #0, r3
FFF08771  057620ff                          bsr.a   sub_FFEFA7E7
FFF08775  bb02                   loc_FFF08775 movu.w  20h+var_8[sp], r2
FFF08777  ba89                              movu.w  20h+var_A[sp], r1
FFF08779  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF0877F  05c97efe                          bsr.a   sub_FFEF0648
FFF08783  6621                              mov.l   #2, r1
FFF08785  39a100                            bsr.w   sub_FFF08826
FFF08788  6708                              rtsd    #8
FFF0878A  6708                   loc_FFF0878A rtsd    #8
FFF0878C  7100bc                 sub_FFF0878C add     #-44h, sp, sp   ; <<<< FUNC sub_FFF0878C
FFF0878F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF08795  c5e02043                          mov.b   20h[r14], 44h+var_1[sp]
FFF08799  fbe2728f0000                      mov.l   #8F72h, r14
FFF0879F  58ee                              movu.b  [r14], r14
FFF087A1  611e                              cmp     #1, r14
FFF087A3  2116                              bne.b   loc_FFF087B9
FFF087A5  fb4209a5f4ff                      mov.l   #aTxPower, r4; "TX POWER"
FFF087AB  6603                              mov.l   #0, r3
FFF087AD  754220                            mov.l   #20h, r2 ; ' '
FFF087B0  754114                            mov.l   #14h, r1
FFF087B3  053420ff                          bsr.a   sub_FFEFA7E7
FFF087B7  2e17                              bra.b   loc_FFF087CE
FFF087B9  fb4212a5f4ff           loc_FFF087B9 mov.l   #aAwPnoDj, r4; "Aw?.=PNO@_Dj"
FFF087BF  fb3ea0aa00                        mov.l   #0AAA0h, r3
FFF087C4  754220                            mov.l   #20h, r2 ; ' '
FFF087C7  754114                            mov.l   #14h, r1
FFF087CA  051d20ff                          bsr.a   sub_FFEFA7E7
FFF087CE  6611                   loc_FFF087CE mov.l   #1, r1
FFF087D0  395600                            bsr.w   sub_FFF08826
FFF087D3  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF087D9  b019                              movu.b  1[r1], r1
FFF087DB  6101                              cmp     #0, r1
FFF087DD  2147                              bne.b   loc_FFF08824
FFF087DF  754340                            mov.l   #40h, r3 ; '@'
FFF087E2  fb221fa5f4ff                      mov.l   #aLow1, r2; "LOW1"
FFF087E8  710103                            add     #44h+var_41, sp, r1
FFF087EB  7f8f                              smovf
FFF087ED  590143                            movu.b  44h+var_1[sp], r1
FFF087F0  6141                              cmp     #4, r1
FFF087F2  2906                              blt.b   loc_FFF087F8
FFF087F4  f9044303                          mov.b   #3, 44h+var_1[sp]
FFF087F8  590143                 loc_FFF087F8 movu.b  44h+var_1[sp], r1
FFF087FB  6c41                              shll    #4, r1
FFF087FD  710403                            add     #44h+var_41, sp, r4
FFF08800  4b14                              add     r1, r4
FFF08802  6603                              mov.l   #0, r3
FFF08804  754245                            mov.l   #45h, r2 ; 'E'
FFF08807  75411b                            mov.l   #1Bh, r1
FFF0880A  05dd1fff                          bsr.a   sub_FFEFA7E7
FFF0880E  fb32ccfdecff                      mov.l   #unk_FFECFDCC, r3
FFF08814  754245                            mov.l   #45h, r2 ; 'E'
FFF08817  66b1                              mov.l   #0Bh, r1
FFF08819  052f7efe                          bsr.a   sub_FFEF0648
FFF0881D  6621                              mov.l   #2, r1
FFF0881F  390700                            bsr.w   sub_FFF08826
FFF08822  6711                              rtsd    #11h
FFF08824  6711                   loc_FFF08824 rtsd    #11h
FFF08826  6040                   sub_FFF08826 sub     #4, sp   ; <<<< FUNC sub_FFF08826
FFF08828  8089                              mov.b   r1, 4+var_1[sp]
FFF0882A  b089                              movu.b  4+var_1[sp], r1
FFF0882C  6040                              sub     #4, sp
FFF0882E  f80995ad                          mov.w   #-526Bh, 8+var_8[sp]
FFF08832  751124                            mul     #24h, r1 ; '$'
FFF08835  711118                            add     #18h, r1, r1
FFF08838  5f12                              movu.w  r1, r2
FFF0883A  6614                              mov.l   #1, r4
FFF0883C  fb3a3401                          mov.l   #134h, r3
FFF08840  6661                              mov.l   #6, r1
FFF08842  050694fe                          bsr.a   sub_FFEF1C48
FFF08846  6240                              add     #4, sp
FFF08848  6701                              rtsd    #1
FFF0884A  6040                   sub_FFF0884A sub     #4, sp   ; <<<< FUNC sub_FFF0884A
FFF0884C  8089                              mov.b   r1, 4+var_1[sp]
FFF0884E  b089                              movu.b  4+var_1[sp], r1
FFF08850  6040                              sub     #4, sp
FFF08852  f80995ad                          mov.w   #-526Bh, 8+var_8[sp]
FFF08856  751124                            mul     #24h, r1 ; '$'
FFF08859  711118                            add     #18h, r1, r1
FFF0885C  5f12                              movu.w  r1, r2
FFF0885E  6614                              mov.l   #1, r4
FFF08860  fb3a2d01                          mov.l   #12Dh, r3
FFF08864  6661                              mov.l   #6, r1
FFF08866  05e293fe                          bsr.a   sub_FFEF1C48
FFF0886A  6240                              add     #4, sp
FFF0886C  6701                              rtsd    #1
FFF0886E  6080                   sub_FFF0886E sub     #8, sp   ; <<<< FUNC sub_FFF0886E
FFF08870  9089                              mov.w   r1, 8+var_2[sp]
FFF08872  9082                              mov.w   r2, 8+var_4[sp]
FFF08874  808b                              mov.b   r3, 8+var_5[sp]
FFF08876  b882                              movu.w  8+var_4[sp], r2
FFF08878  b889                              movu.w  8+var_2[sp], r1
FFF0887A  6040                              sub     #4, sp
FFF0887C  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF08880  6221                              add     #2, r1
FFF08882  5f11                              movu.w  r1, r1
FFF08884  6624                              mov.l   #2, r4
FFF08886  754314                            mov.l   #14h, r3
FFF08889  05bf93fe                          bsr.a   sub_FFEF1C48
FFF0888D  6240                              add     #4, sp
FFF0888F  b882                              movu.w  8+var_4[sp], r2
FFF08891  b889                              movu.w  8+var_2[sp], r1
FFF08893  6040                              sub     #4, sp
FFF08895  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF08899  754414                            mov.l   #14h, r4
FFF0889C  6623                              mov.l   #2, r3
FFF0889E  05aa93fe                          bsr.a   sub_FFEF1C48
FFF088A2  6240                              add     #4, sp
FFF088A4  b881                              movu.w  8+var_4[sp], r1
FFF088A6  b88b                              movu.w  8+var_2[sp], r3
FFF088A8  6040                              sub     #4, sp
FFF088AA  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF088AE  6221                              add     #2, r1
FFF088B0  5f12                              movu.w  r1, r2
FFF088B2  713314                            add     #14h, r3, r3
FFF088B5  5f31                              movu.w  r3, r1
FFF088B7  754414                            mov.l   #14h, r4
FFF088BA  6623                              mov.l   #2, r3
FFF088BC  058c93fe                          bsr.a   sub_FFEF1C48
FFF088C0  6240                              add     #4, sp
FFF088C2  b882                              movu.w  8+var_4[sp], r2
FFF088C4  b889                              movu.w  8+var_2[sp], r1
FFF088C6  6040                              sub     #4, sp
FFF088C8  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF088CC  712214                            add     #14h, r2, r2
FFF088CF  5f22                              movu.w  r2, r2
FFF088D1  6624                              mov.l   #2, r4
FFF088D3  754314                            mov.l   #14h, r3
FFF088D6  057293fe                          bsr.a   sub_FFEF1C48
FFF088DA  6240                              add     #4, sp
FFF088DC  b089                              movu.b  8+var_5[sp], r1
FFF088DE  6111                              cmp     #1, r1
FFF088E0  211a                              bne.b   loc_FFF088FA
FFF088E2  b881                              movu.w  8+var_4[sp], r1
FFF088E4  b88b                              movu.w  8+var_2[sp], r3
FFF088E6  6211                              add     #1, r1
FFF088E8  5f12                              movu.w  r1, r2
FFF088EA  6213                              add     #1, r3
FFF088EC  5f31                              movu.w  r3, r1
FFF088EE  fb32ac0aedff                      mov.l   #unk_FFED0AAC, r3
FFF088F4  05547dfe                          bsr.a   sub_FFEF0648
FFF088F8  6702                              rtsd    #2
FFF088FA  6702                   loc_FFF088FA rtsd    #2
FFF088FC  60c0                   sub_FFF088FC sub     #0Ch, sp   ; <<<< FUNC sub_FFF088FC
FFF088FE  9109                              mov.w   r1, 0Ch+var_2[sp]
