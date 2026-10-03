; window mstp_a file 336C80-336D40 map FFF36C80-FFF36D40 forced 64
; ==== mstp_a  FFF36C80-FFF36D40 ====
FFF36C80  fa05c20700                        mov.w   #0, 4+arg_F7C[sp]
FFF36C85  054be1fd                          bsr.a   sub_FFF14DD0
FFF36C89  05562900                          bsr.a   sub_FFF395DF
FFF36C8D  054185fa                          bsr.a   sub_FFEDF1CE
FFF36C91  05ff0800                          bsr.a   sub_FFF37590
FFF36C95  7fa8                              setpsw  i
FFF36C97  390500                            bsr.w   sub_FFF36C9C
FFF36C9A  6701                              rtsd    #1
FFF36C9C  05b78f00                 sub_FFF36C9C bsr.a   sub_FFF3FC53  ; <<< FUNC sub_FFF36C9C
FFF36CA0  2efc                              bra.b   sub_FFF36C9C
FFF36CA2  055455fa                 loc_FFF36CA2 bsr.a   sub_FFEDC1F6
FFF36CA6  05f182fa                          bsr.a   sub_FFEDEF97
FFF36CAA  02                                rts
FFF36CAB  0574a6fa                 loc_FFF36CAB bsr.a   sub_FFEE131F
FFF36CAF  05d1a7fa                          bsr.a   sub_FFEE1480
FFF36CB3  05bd8dfa                          bsr.a   sub_FFEDFA70
FFF36CB7  05e44900                          bsr.a   sub_FFF3B69B
FFF36CBB  053359fa                          bsr.a   sub_FFEDC5EE
FFF36CBF  02                                rts
FFF36CC0  390a00                   sub_FFF36CC0 bsr.w   sub_FFF36CCA  ; <<< FUNC sub_FFF36CC0
FFF36CC3  394002                            bsr.w   sub_FFF36F03
FFF36CC6  397c07                            bsr.w   sub_FFF37442
FFF36CC9  02                                rts
FFF36CCA  6040                     sub_FFF36CCA sub     #4, sp  ; <<< FUNC sub_FFF36CCA
FFF36CCC  fbee100008                        mov.l   #80010h, r14
FFF36CD1  fae9f7010ba5                      mov.w   #-5AF5h, 3EEh[r14]
FFF36CD7  fbee100008                        mov.l   #80010h, r14
FFF36CDC  ecef                              mov.l   [r14], r15
FFF36CDE  7adf                              bclr    #0Dh, r15
FFF36CE0  e3ef                              mov.l   r15, [r14]
FFF36CE2  fbee100008                        mov.l   #80010h, r14
FFF36CE7  ecef                              mov.l   [r14], r15
FFF36CE9  7adf                              bclr    #0Dh, r15
FFF36CEB  e3ef                              mov.l   r15, [r14]
FFF36CED  fbee100008                        mov.l   #80010h, r14
FFF36CF2  ecef                              mov.l   [r14], r15
FFF36CF4  7adf                              bclr    #0Dh, r15
FFF36CF6  e3ef                              mov.l   r15, [r14]
FFF36CF8  fbee100008                        mov.l   #80010h, r14
FFF36CFD  ecef                              mov.l   [r14], r15
FFF36CFF  7b3f                              bclr    #13h, r15
FFF36D01  e3ef                              mov.l   r15, [r14]
FFF36D03  fbee100008                        mov.l   #80010h, r14
FFF36D08  ecef                              mov.l   [r14], r15
FFF36D0A  7b1f                              bclr    #11h, r15
FFF36D0C  e3ef                              mov.l   r15, [r14]
FFF36D0E  fbee100008                        mov.l   #80010h, r14
FFF36D13  ecef                              mov.l   [r14], r15
FFF36D15  7b0f                              bclr    #10h, r15
FFF36D17  e3ef                              mov.l   r15, [r14]
FFF36D19  fb1e100008                        mov.l   #80010h, r1
FFF36D1E  a81a                              mov.l   4[r1], r2
FFF36D20  7bf2                              bclr    #1Fh, r2
FFF36D22  a01a                              mov.l   r2, 4[r1]
FFF36D24  fb1e100008                        mov.l   #80010h, r1
FFF36D29  a81a                              mov.l   4[r1], r2
FFF36D2B  7bd2                              bclr    #1Dh, r2
FFF36D2D  a01a                              mov.l   r2, 4[r1]
FFF36D2F  fb1e100008                        mov.l   #80010h, r1
FFF36D34  a89a                              mov.l   0Ch[r1], r2
FFF36D36  7b32                              bclr    #13h, r2
FFF36D38  a09a                              mov.l   r2, 0Ch[r1]
FFF36D3A  fbee100008                        mov.l   #80010h, r14
FFF36D3F  ecef                              mov.l   [r14], r15
