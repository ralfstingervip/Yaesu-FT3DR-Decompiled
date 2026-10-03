; ==== mstp  FFF36C00-FFF36E00  (file 336C00-336E00) ====
FFF36C00  cbef0003                          mov.b   r15, 300h[r14]
FFF36C04  fbee887008                        mov.l   #87088h, r14
FFF36C09  f0e8                              bclr    #0, [r14].b
FFF36C0B  fbee887008                        mov.l   #87088h, r14
FFF36C10  f2e08901                          bset    #0, 189h[r14].b
FFF36C14  fbee008108                        mov.l   #88100h, r14
FFF36C19  f0e3                              bset    #3, [r14].b
FFF36C1B  02                                rts
FFF36C1C  6eef                   sub_FFF36C1C pushm   r14-r15   ; <<<< FUNC sub_FFF36C1C
FFF36C1E  6e15                              pushm   r1-r5
FFF36C20  7fa8                              setpsw  i
FFF36C22  fb1e458108                        mov.l   #88145h, r1
FFF36C27  f410                              btst    #0, [r1].b
FFF36C29  10                                beq.s   loc_FFF36C31
FFF36C2A  fb1e458108                        mov.l   #88145h, r1
FFF36C2F  f018                              bclr    #0, [r1].b
FFF36C31  fb1e008108             loc_FFF36C31 mov.l   #88100h, r1
FFF36C36  f01b                              bclr    #3, [r1].b
FFF36C38  fb1e458108                        mov.l   #88145h, r1
FFF36C3D  6211                              add     #1, r1
FFF36C3F  f81500                            mov.w   #0, [r1]
FFF36C42  05600000                          bsr.a   sub_FFF36CA2
FFF36C46  fb1e008108                        mov.l   #88100h, r1
FFF36C4B  f013                              bset    #3, [r1].b
FFF36C4D  6f15                              popm    r1-r5
FFF36C4F  6fef                              popm    r14-r15
FFF36C51  7f95                              rte
FFF36C53  6040                   sub_FFF36C53 sub     #4, sp   ; <<<< FUNC sub_FFF36C53
FFF36C55  8089                              mov.b   r1, 4+var_1[sp]
FFF36C57  7fb8                              clrpsw  i
FFF36C59  05670000                          bsr.a   sub_FFF36CC0
FFF36C5D  0537d5fd                          bsr.a   sub_FFF14194
FFF36C61  0514befd                          bsr.a   sub_FFF12A75
FFF36C65  057ea5fa                          bsr.a   sub_FFEE11E3
FFF36C69  05e33efa                          bsr.a   sub_FFEDAB4C
FFF36C6D  050a8bfa                          bsr.a   sub_FFEDF777
FFF36C71  0522a7fa                          bsr.a   sub_FFEE1393
FFF36C75  05f754fa                          bsr.a   sub_FFEDC16C
FFF36C79  055876fa                          bsr.a   sub_FFEDE2D1
FFF36C7D  057482fa                          bsr.a   sub_FFEDEEF1
FFF36C81  05c20700                          bsr.a   sub_FFF37443
FFF36C85  054be1fd                          bsr.a   sub_FFF14DD0
FFF36C89  05562900                          bsr.a   sub_FFF395DF
FFF36C8D  054185fa                          bsr.a   sub_FFEDF1CE
FFF36C91  05ff0800                          bsr.a   sub_FFF37590
FFF36C95  7fa8                              setpsw  i
FFF36C97  390500                            bsr.w   sub_FFF36C9C
FFF36C9A  6701                              rtsd    #1
FFF36C9C  05b78f00               sub_FFF36C9C bsr.a   sub_FFF3FC53   ; <<<< FUNC sub_FFF36C9C
FFF36CA0  2efc                              bra.b   sub_FFF36C9C
FFF36CA2  055455fa               sub_FFF36CA2 bsr.a   sub_FFEDC1F6   ; <<<< FUNC sub_FFF36CA2
FFF36CA6  05f182fa                          bsr.a   sub_FFEDEF97
FFF36CAA  02                                rts
FFF36CAB  0574a6fa               sub_FFF36CAB bsr.a   sub_FFEE131F   ; <<<< FUNC sub_FFF36CAB
FFF36CAF  05d1a7fa                          bsr.a   sub_FFEE1480
FFF36CB3  05bd8dfa                          bsr.a   sub_FFEDFA70
FFF36CB7  05e44900                          bsr.a   sub_FFF3B69B
FFF36CBB  053359fa                          bsr.a   sub_FFEDC5EE
FFF36CBF  02                                rts
FFF36CC0  390a00                 sub_FFF36CC0 bsr.w   sub_FFF36CCA   ; <<<< FUNC sub_FFF36CC0
FFF36CC3  394002                            bsr.w   sub_FFF36F03
FFF36CC6  397c07                            bsr.w   sub_FFF37442
FFF36CC9  02                                rts
FFF36CCA  6040                   sub_FFF36CCA sub     #4, sp   ; <<<< FUNC sub_FFF36CCA
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
FFF36D41  7bcf                              bclr    #1Ch, r15
FFF36D43  e3ef                              mov.l   r15, [r14]
FFF36D45  fbee100008                        mov.l   #80010h, r14
FFF36D4A  ecef                              mov.l   [r14], r15
FFF36D4C  7a9f                              bclr    #9, r15
FFF36D4E  e3ef                              mov.l   r15, [r14]
FFF36D50  fbee100008                        mov.l   #80010h, r14
FFF36D55  ecef                              mov.l   [r14], r15
FFF36D57  7adf                              bclr    #0Dh, r15
FFF36D59  e3ef                              mov.l   r15, [r14]
FFF36D5B  fbee100008                        mov.l   #80010h, r14
FFF36D60  ecef                              mov.l   [r14], r15
FFF36D62  7aff                              bclr    #0Fh, r15
FFF36D64  e3ef                              mov.l   r15, [r14]
FFF36D66  fbee100008                        mov.l   #80010h, r14
FFF36D6B  ecef                              mov.l   [r14], r15
FFF36D6D  7aff                              bclr    #0Fh, r15
FFF36D6F  e3ef                              mov.l   r15, [r14]
FFF36D71  fb1e100008                        mov.l   #80010h, r1
FFF36D76  a81a                              mov.l   4[r1], r2
FFF36D78  7bc2                              bclr    #1Ch, r2
FFF36D7A  a01a                              mov.l   r2, 4[r1]
FFF36D7C  fbee100008                        mov.l   #80010h, r14
FFF36D81  ecef                              mov.l   [r14], r15
FFF36D83  7aef                              bclr    #0Eh, r15
FFF36D85  e3ef                              mov.l   r15, [r14]
FFF36D87  fbee100008                        mov.l   #80010h, r14
FFF36D8C  fae9f70103a5                      mov.w   #-5AFDh, 3EEh[r14]
FFF36D92  fbee100008                        mov.l   #80010h, r14
FFF36D97  fae484c201                        mov.b   #1, 0C284h[r14]
FFF36D9C  fbee26c408                        mov.l   #8C426h, r14
FFF36DA1  f1e802                            bclr    #0, 2[r14].b
FFF36DA4  3c0300                            mov.b   #0, 4+var_1[sp]
FFF36DA7  2e11                              bra.b   loc_FFF36DB8
FFF36DA9  fbee26c408             loc_FFF36DA9 mov.l   #8C426h, r14
FFF36DAE  c5e00202                          mov.b   2[r14], 4+var_2[sp]
FFF36DB2  b089                              movu.b  4+var_1[sp], r1
FFF36DB4  6211                              add     #1, r1
FFF36DB6  8089                              mov.b   r1, 4+var_1[sp]
FFF36DB8  b089                   loc_FFF36DB8 movu.b  4+var_1[sp], r1
FFF36DBA  6141                              cmp     #4, r1
FFF36DBC  29ed                              blt.b   loc_FFF36DA9
FFF36DBE  fbee26c408                        mov.l   #8C426h, r14
FFF36DC3  f0e8                              bclr    #0, [r14].b
FFF36DC5  3c0300                            mov.b   #0, 4+var_1[sp]
FFF36DC8  2e13                              bra.b   loc_FFF36DDB
FFF36DCA  fbee26c408             loc_FFF36DCA mov.l   #8C426h, r14
FFF36DCF  58e1                              movu.b  [r14], r1
FFF36DD1  6411                              and     #1, r1
FFF36DD3  8081                              mov.b   r1, 4+var_2[sp]
FFF36DD5  b089                              movu.b  4+var_1[sp], r1
FFF36DD7  6211                              add     #1, r1
FFF36DD9  8089                              mov.b   r1, 4+var_1[sp]
FFF36DDB  b089                   loc_FFF36DDB movu.b  4+var_1[sp], r1
FFF36DDD  6141                              cmp     #4, r1
FFF36DDF  29eb                              blt.b   loc_FFF36DCA
FFF36DE1  fbee26c408             loc_FFF36DE1 mov.l   #8C426h, r14
FFF36DE6  f4e0                              btst    #0, [r14].b
FFF36DE8  21f9                              bne.b   loc_FFF36DE1
FFF36DEA  fbee100008                        mov.l   #80010h, r14
FFF36DEF  f9e42301                          mov.b   #1, 23h[r14]
FFF36DF3  fbee100008             loc_FFF36DF3 mov.l   #80010h, r14
FFF36DF8  59ee23                            movu.b  23h[r14], r14
FFF36DFB  611e                              cmp     #1, r14
FFF36DFD  21f6                              bne.b   loc_FFF36DF3
FFF36DFF  fbee100008             loc_FFF36DFF mov.l   #80010h, r14
