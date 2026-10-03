; ==== feat_c  FFF10000-FFF12000  (file 310000-312000) ====
FFF10000  13                                mov.l   #1, r3
FFF10001  05d468fe               sub_FFF10001 bsr.a   sub_FFEF68D5   ; <<<< FUNC sub_FFF10001
FFF10005  2e16                              bra.b   loc_FFF1001B
FFF10007  5f1e                   loc_FFF10007 movu.w  r1, r14
FFF10009  621e                              add     #1, r14
FFF1000B  5fe2                              movu.w  r14, r2
FFF1000D  5f31                              movu.w  r3, r1
FFF1000F  fb425c20edff                      mov.l   #unk_FFED205C, r4
FFF10015  6613                              mov.l   #1, r3
FFF10017  05be68fe                          bsr.a   sub_FFEF68D5
FFF1001B  3d0130                 loc_FFF1001B mov.w   #30h, 2[sp] ; '0'
FFF1001E  f80501                            mov.w   #1, 0[sp]
FFF10021  5c02                              movu.w  0[sp], r2
FFF10023  b809                              movu.w  2[sp], r1
FFF10025  60c0                              sub     #0Ch, sp
FFF10027  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF1002D  713320                            add     #20h, r3, r3 ; ' '
FFF10030  a00b                              mov.l   r3, 0Ch+var_8[sp]
FFF10032  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF10035  f80413                            mov.b   #13h, 0Ch+var_C[sp]
FFF10038  6604                              mov.l   #0, r4
FFF1003A  66d3                              mov.l   #0Dh, r3
FFF1003C  05e71afe                          bsr.a   sub_FFEF1B23
FFF10040  62c0                              add     #0Ch, sp
FFF10042  f8051e                            mov.w   #1Eh, 0[sp]
FFF10045  5c01                              movu.w  0[sp], r1
FFF10047  6602                              mov.l   #0, r2
FFF10049  0525ffff                          bsr.a   sub_FFF0FF6E
FFF1004D  6661                              mov.l   #6, r1
FFF1004F  05409efe                          bsr.a   sub_FFEF9E8F
FFF10053  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10059  58ef                              movu.b  [r14], r15
FFF1005B  621f                              add     #1, r15
FFF1005D  c3ef                              mov.b   r15, [r14]
FFF1005F  6701                              rtsd    #1
FFF10061  6040                   sub_FFF10061 sub     #4, sp   ; <<<< FUNC sub_FFF10061
FFF10063  6040                              sub     #4, sp
FFF10065  3d00f0                            mov.w   #-10h, [sp]
FFF10068  fb4a4001                          mov.l   #140h, r4
FFF1006C  6602                              mov.l   #0, r2
FFF1006E  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10074  ef23                              mov.l   r2, r3
FFF10076  0545f9fd                          bsr.a   sub_FFEEF9BB
FFF1007A  6240                              add     #4, sp
FFF1007C  8089                              mov.b   r1, 4+var_1[sp]
FFF1007E  b089                              movu.b  4+var_1[sp], r1
FFF10080  6111                              cmp     #1, r1
FFF10082  1a                                bne.s   loc_FFF1008C
FFF10083  39b602                            bsr.w   sub_FFF10339
FFF10086  05e902fe                          bsr.a   sub_FFEF036F
FFF1008A  6701                              rtsd    #1
FFF1008C  6701                   loc_FFF1008C rtsd    #1
FFF1008E  6040                   sub_FFF1008E sub     #4, sp   ; <<<< FUNC sub_FFF1008E
FFF10090  6040                              sub     #4, sp
FFF10092  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF10095  fb4a4001                          mov.l   #140h, r4
FFF10099  75431e                            mov.l   #1Eh, r3
FFF1009C  6602                              mov.l   #0, r2
FFF1009E  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF100A4  0517f9fd                          bsr.a   sub_FFEEF9BB
FFF100A8  6240                              add     #4, sp
FFF100AA  8089                              mov.b   r1, 4+var_1[sp]
FFF100AC  b089                              movu.b  4+var_1[sp], r1
FFF100AE  6111                              cmp     #1, r1
FFF100B0  2123                              bne.b   loc_FFF100D3
FFF100B2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF100B8  59e337                            movu.b  37h[r14], r3
FFF100BB  6040                              sub     #4, sp
FFF100BD  f80400                            mov.b   #0, 8+var_8[sp]
FFF100C0  75421e                            mov.l   #1Eh, r2
FFF100C3  6601                              mov.l   #0, r1
FFF100C5  ef14                              mov.l   r1, r4
FFF100C7  05aafcff                          bsr.a   sub_FFF0FD71
FFF100CB  6240                              add     #4, sp
FFF100CD  05a202fe                          bsr.a   sub_FFEF036F
FFF100D1  6701                              rtsd    #1
FFF100D3  6701                   loc_FFF100D3 rtsd    #1
FFF100D5  6040                   sub_FFF100D5 sub     #4, sp   ; <<<< FUNC sub_FFF100D5
FFF100D7  6040                              sub     #4, sp
FFF100D9  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF100DC  fb4a4001                          mov.l   #140h, r4
FFF100E0  75433c                            mov.l   #3Ch, r3 ; '<'
FFF100E3  6602                              mov.l   #0, r2
FFF100E5  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF100EB  05d0f8fd                          bsr.a   sub_FFEEF9BB
FFF100EF  6240                              add     #4, sp
FFF100F1  8089                              mov.b   r1, 4+var_1[sp]
FFF100F3  b089                              movu.b  4+var_1[sp], r1
FFF100F5  6111                              cmp     #1, r1
FFF100F7  2123                              bne.b   loc_FFF1011A
FFF100F9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF100FF  59e337                            movu.b  37h[r14], r3
FFF10102  6040                              sub     #4, sp
FFF10104  f80401                            mov.b   #1, 8+var_8[sp]
FFF10107  6614                              mov.l   #1, r4
FFF10109  75423c                            mov.l   #3Ch, r2 ; '<'
FFF1010C  6601                              mov.l   #0, r1
FFF1010E  0563fcff                          bsr.a   sub_FFF0FD71
FFF10112  6240                              add     #4, sp
FFF10114  055b02fe                          bsr.a   sub_FFEF036F
FFF10118  6701                              rtsd    #1
FFF1011A  6701                   loc_FFF1011A rtsd    #1
FFF1011C  6040                   sub_FFF1011C sub     #4, sp   ; <<<< FUNC sub_FFF1011C
FFF1011E  6040                              sub     #4, sp
FFF10120  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF10123  fb4a4001                          mov.l   #140h, r4
FFF10127  754396                            mov.l   #-6Ah, r3
FFF1012A  6602                              mov.l   #0, r2
FFF1012C  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10132  0589f8fd                          bsr.a   sub_FFEEF9BB
FFF10136  6240                              add     #4, sp
FFF10138  8089                              mov.b   r1, 4+var_1[sp]
FFF1013A  b089                              movu.b  4+var_1[sp], r1
FFF1013C  6111                              cmp     #1, r1
FFF1013E  2123                              bne.b   loc_FFF10161
FFF10140  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10146  59e337                            movu.b  37h[r14], r3
FFF10149  6040                              sub     #4, sp
FFF1014B  f80403                            mov.b   #3, 8+var_8[sp]
FFF1014E  6624                              mov.l   #2, r4
FFF10150  754296                            mov.l   #-6Ah, r2
FFF10153  6601                              mov.l   #0, r1
FFF10155  051cfcff                          bsr.a   sub_FFF0FD71
FFF10159  6240                              add     #4, sp
FFF1015B  051402fe                          bsr.a   sub_FFEF036F
FFF1015F  6701                              rtsd    #1
FFF10161  6701                   loc_FFF10161 rtsd    #1
FFF10163  66f1                   sub_FFF10163 mov.l   #0Fh, r1   ; <<<< FUNC sub_FFF10163
FFF10165  0595fdff                          bsr.a   sub_FFF0FEFA
FFF10169  02                                rts
FFF1016A  6040                   sub_FFF1016A sub     #4, sp   ; <<<< FUNC sub_FFF1016A
FFF1016C  05d3fefd                          bsr.a   sub_FFEF003F
FFF10170  fbe2738f0000                      mov.l   #8F73h, r14
FFF10176  c3e1                              mov.b   r1, [r14]
FFF10178  fbe2738f0000                      mov.l   #8F73h, r14
FFF1017E  58ee                              movu.b  [r14], r14
FFF10180  755eff                            cmp     #-1, r14
FFF10183  1e                                bne.s   loc_FFF10189
FFF10184  6601                              mov.l   #0, r1
FFF10186  396a00                            bsr.w   sub_FFF101F0
FFF10189  fbe2738f0000           loc_FFF10189 mov.l   #8F73h, r14
FFF1018F  58ee                              movu.b  [r14], r14
FFF10191  755eff                            cmp     #-1, r14
FFF10194  2013                              beq.b   loc_FFF101A7
FFF10196  fbe2738f0000                      mov.l   #8F73h, r14
FFF1019C  58ee                              movu.b  [r14], r14
FFF1019E  755e12                            cmp     #12h, r14
FFF101A1  2406                              bgtu.b  loc_FFF101A7
FFF101A3  f80601                            mov.l   #1, 4+var_4[sp]
FFF101A6  0c                                bra.s   loc_FFF101AA
FFF101A7  f80600                 loc_FFF101A7 mov.l   #0, 4+var_4[sp]
FFF101AA  ec01                   loc_FFF101AA mov.l   4+var_4[sp], r1
FFF101AC  6101                              cmp     #0, r1
FFF101AE  2029                              beq.b   loc_FFF101D7
FFF101B0  05d4f9fd                          bsr.a   sub_FFEEFB84
FFF101B4  6101                              cmp     #0, r1
FFF101B6  2121                              bne.b   loc_FFF101D7
FFF101B8  fbe2738f0000                      mov.l   #8F73h, r14
FFF101BE  58e1                              movu.b  [r14], r1
FFF101C0  052afefd                          bsr.a   sub_FFEEFFEA
FFF101C4  fbe2738f0000                      mov.l   #8F73h, r14
FFF101CA  58ee                              movu.b  [r14], r14
FFF101CC  fbf2f47aedff                      mov.l   #off_FFED7AF4, r15
FFF101D2  fe6efe                            mov.l   [r14, r15], r14
FFF101D5  7f1e                              jsr     r14
FFF101D7  fbe24c8c0000           loc_FFF101D7 mov.l   #8C4Ch, r14
FFF101DD  58ee                              movu.b  [r14], r14
FFF101DF  614e                              cmp     #4, r14
FFF101E1  290d                              blt.b   loc_FFF101EE
FFF101E3  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF101E9  f8e403                            mov.b   #3, [r14]
FFF101EC  6701                              rtsd    #1
FFF101EE  6701                   loc_FFF101EE rtsd    #1
FFF101F0  6040                   sub_FFF101F0 sub     #4, sp   ; <<<< FUNC sub_FFF101F0
FFF101F2  8089                              mov.b   r1, 4+var_1[sp]
FFF101F4  05753efe                          bsr.a   sub_FFEF4069
FFF101F8  391400                            bsr.w   sub_FFF1020C
FFF101FB  05bf3efe                          bsr.a   sub_FFEF40BA
FFF101FF  b089                              movu.b  4+var_1[sp], r1
FFF10201  6111                              cmp     #1, r1
FFF10203  1f                                bne.s   loc_FFF1020A
FFF10204  0528fefd                          bsr.a   sub_FFEF002C
FFF10208  6701                              rtsd    #1
FFF1020A  6701                   loc_FFF1020A rtsd    #1
FFF1020C  fb22468e0000           sub_FFF1020C mov.l   #8E46h, r2   ; <<<< FUNC sub_FFF1020C
FFF10212  712239                            add     #39h, r2, r2 ; '9'
FFF10215  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF1021B  711139                            add     #39h, r1, r1 ; '9'
FFF1021E  6613                              mov.l   #1, r3
FFF10220  ef34                              mov.l   r3, r4
FFF10222  056b1efe                          bsr.a   sub_FFEF208D
FFF10226  fb22468e0000                      mov.l   #8E46h, r2
FFF1022C  712220                            add     #20h, r2, r2 ; ' '
FFF1022F  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF10235  711120                            add     #20h, r1, r1 ; ' '
FFF10238  6614                              mov.l   #1, r4
FFF1023A  754317                            mov.l   #17h, r3
FFF1023D  05501efe                          bsr.a   sub_FFEF208D
FFF10241  fbe2468e0000                      mov.l   #8E46h, r14
FFF10247  59ef37                            movu.b  37h[r14], r15
FFF1024A  eff5                              mov.l   r15, r5
FFF1024C  fd749503                          divu    #3, r5
FFF10250  6335                              mul     #3, r5
FFF10252  435f                              sub     r5, r15
FFF10254  c7ef37                            mov.b   r15, 37h[r14]
FFF10257  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1025D  59ee37                            movu.b  37h[r14], r14
FFF10260  fbf2468e0000                      mov.l   #8E46h, r15
FFF10266  45fe37                            cmp     37h[r15], r14
FFF10269  2037                              beq.b   loc_FFF102A0
FFF1026B  fbe2468e0000                      mov.l   #8E46h, r14
FFF10271  59ee37                            movu.b  37h[r14], r14
FFF10274  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF1027A  59ff37                            movu.b  37h[r15], r15
FFF1027D  fb5e000001                        mov.l   #10000h, r5
FFF10282  ef51                              mov.l   r5, r1
FFF10284  fd62f1                            shll    r15, r1
FFF10287  fd62e5                            shll    r14, r5
FFF1028A  5751                              or      r5, r1
FFF1028C  0518fcfd                          bsr.a   sub_FFEEFEA4
FFF10290  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10296  fbf2468e0000                      mov.l   #8E46h, r15
FFF1029C  c5fe3737                          mov.b   37h[r15], 37h[r14]
FFF102A0  fb12468e0000           loc_FFF102A0 mov.l   #8E46h, r1
FFF102A6  b499                              movu.b  13h[r1], r1
FFF102A8  755120                            cmp     #20h, r1 ; ' '
FFF102AB  212f                              bne.b   loc_FFF102DA
FFF102AD  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF102B3  59ee38                            movu.b  38h[r14], r14
FFF102B6  fbf2468e0000                      mov.l   #8E46h, r15
FFF102BC  45fe38                            cmp     38h[r15], r14
FFF102BF  201b                              beq.b   loc_FFF102DA
FFF102C1  fbe27a8d0000                      mov.l   #8D7Ah, r14
FFF102C7  f8e401                            mov.b   #1, [r14]
FFF102CA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF102D0  fbf2468e0000                      mov.l   #8E46h, r15
FFF102D6  c5fe3838                          mov.b   38h[r15], 38h[r14]
FFF102DA  fbe24d8c0000           loc_FFF102DA mov.l   #8C4Dh, r14
FFF102E0  59ee3a                            movu.b  3Ah[r14], r14
FFF102E3  fbf2468e0000                      mov.l   #8E46h, r15
FFF102E9  45fe3a                            cmp     3Ah[r15], r14
FFF102EC  201b                              beq.b   loc_FFF10307
FFF102EE  fb1e008000                        mov.l   #8000h, r1
FFF102F3  05b1fbfd                          bsr.a   sub_FFEEFEA4
FFF102F7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF102FD  fbf2468e0000                      mov.l   #8E46h, r15
FFF10303  c5fe3a3a                          mov.b   3Ah[r15], 3Ah[r14]
FFF10307  fbe24d8c0000           loc_FFF10307 mov.l   #8C4Dh, r14
FFF1030D  59ee3b                            movu.b  3Bh[r14], r14
FFF10310  fbf2468e0000                      mov.l   #8E46h, r15
FFF10316  45fe3b                            cmp     3Bh[r15], r14
FFF10319  201b                              beq.b   loc_FFF10334
FFF1031B  fb1e008000                        mov.l   #8000h, r1
FFF10320  0584fbfd                          bsr.a   sub_FFEEFEA4
FFF10324  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1032A  fbf2468e0000                      mov.l   #8E46h, r15
FFF10330  c5fe3b3b                          mov.b   3Bh[r15], 3Bh[r14]
FFF10334  0560fffd               loc_FFF10334 bsr.a   sub_FFEF0294
FFF10338  02                                rts
FFF10339  6040                   sub_FFF10339 sub     #4, sp   ; <<<< FUNC sub_FFF10339
FFF1033B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10341  c5e03703                          mov.b   37h[r14], 4+var_1[sp]
FFF10345  fbe2798d0000                      mov.l   #8D79h, r14
FFF1034B  f8e400                            mov.b   #0, [r14]
FFF1034E  6601                              mov.l   #0, r1
FFF10350  ef12                              mov.l   r1, r2
FFF10352  05b600fe                          bsr.a   sub_FFEF0408
FFF10356  b08b                              movu.b  4+var_1[sp], r3
FFF10358  6040                              sub     #4, sp
FFF1035A  f80400                            mov.b   #0, 8+var_8[sp]
FFF1035D  75421e                            mov.l   #1Eh, r2
FFF10360  6601                              mov.l   #0, r1
FFF10362  ef14                              mov.l   r1, r4
FFF10364  050dfaff                          bsr.a   sub_FFF0FD71
FFF10368  6240                              add     #4, sp
FFF1036A  b08b                              movu.b  4+var_1[sp], r3
FFF1036C  6040                              sub     #4, sp
FFF1036E  f80401                            mov.b   #1, 8+var_8[sp]
FFF10371  6614                              mov.l   #1, r4
FFF10373  75423c                            mov.l   #3Ch, r2 ; '<'
FFF10376  6601                              mov.l   #0, r1
FFF10378  05f9f9ff                          bsr.a   sub_FFF0FD71
FFF1037C  6240                              add     #4, sp
FFF1037E  b08b                              movu.b  4+var_1[sp], r3
FFF10380  6040                              sub     #4, sp
FFF10382  f80403                            mov.b   #3, 8+var_8[sp]
FFF10385  6624                              mov.l   #2, r4
FFF10387  754296                            mov.l   #-6Ah, r2
FFF1038A  6601                              mov.l   #0, r1
FFF1038C  05e5f9ff                          bsr.a   sub_FFF0FD71
FFF10390  6240                              add     #4, sp
FFF10392  6601                              mov.l   #0, r1
FFF10394  057121fe                          bsr.a   sub_FFEF2505
FFF10398  6701                              rtsd    #1
FFF1039A  fbe24c8c0000           sub_FFF1039A mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF1039A
FFF103A0  58ee                              movu.b  [r14], r14
FFF103A2  613e                              cmp     #3, r14
FFF103A4  2a16                              bgt.b   loc_FFF103BA
FFF103A6  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF103AC  58ee                              movu.b  [r14], r14
FFF103AE  fbf2407bedff                      mov.l   #off_FFED7B40, r15
FFF103B4  fe6efe                            mov.l   [r14, r15], r14
FFF103B7  7f1e                              jsr     r14
FFF103B9  02                                rts
FFF103BA  fbe24c8c0000           loc_FFF103BA mov.l   #8C4Ch, r14
FFF103C0  f8e403                            mov.b   #3, [r14]
FFF103C3  02                                rts
FFF103C4  6611                   sub_FFF103C4 mov.l   #1, r1   ; <<<< FUNC sub_FFF103C4
FFF103C6  395c02                            bsr.w   sub_FFF10622
FFF103C9  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF103CF  58ef                              movu.b  [r14], r15
FFF103D1  621f                              add     #1, r15
FFF103D3  c3ef                              mov.b   r15, [r14]
FFF103D5  02                                rts
FFF103D6  6080                   sub_FFF103D6 sub     #8, sp   ; <<<< FUNC sub_FFF103D6
FFF103D8  0555fffd                          bsr.a   sub_FFEF032D
FFF103DC  056ba3fe                          bsr.a   sub_FFEFA747
FFF103E0  3d0306                            mov.w   #6, 8+var_2[sp]
FFF103E3  3d0200                            mov.w   #0, 8+var_4[sp]
FFF103E6  b882                              movu.w  8+var_4[sp], r2
FFF103E8  b889                              movu.w  8+var_2[sp], r1
FFF103EA  60c0                              sub     #0Ch, sp
FFF103EC  fb3244adf4ff                      mov.l   #aAddToCategory, r3; "ADD TO CATEGORY"
FFF103F2  a00b                              mov.l   r3, 14h+var_10[sp]
FFF103F4  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF103F7  f8040f                            mov.b   #0Fh, 14h+var_14[sp]
FFF103FA  6212                              add     #1, r2
FFF103FC  5f22                              movu.w  r2, r2
FFF103FE  6604                              mov.l   #0, r4
FFF10400  66d3                              mov.l   #0Dh, r3
FFF10402  052117fe                          bsr.a   sub_FFEF1B23
FFF10406  62c0                              add     #0Ch, sp
FFF10408  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF1040B  b882                              movu.w  8+var_4[sp], r2
FFF1040D  b889                              movu.w  8+var_2[sp], r1
FFF1040F  60c0                              sub     #0Ch, sp
FFF10411  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF10417  713320                            add     #20h, r3, r3 ; ' '
FFF1041A  a00b                              mov.l   r3, 14h+var_10[sp]
FFF1041C  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF1041F  f80413                            mov.b   #13h, 14h+var_14[sp]
FFF10422  6212                              add     #1, r2
FFF10424  5f22                              movu.w  r2, r2
FFF10426  6604                              mov.l   #0, r4
FFF10428  66d3                              mov.l   #0Dh, r3
FFF1042A  05f916fe                          bsr.a   sub_FFEF1B23
FFF1042E  62c0                              add     #0Ch, sp
FFF10430  3d023c                            mov.w   #3Ch, 8+var_4[sp] ; '<'
FFF10433  3c0300                            mov.b   #0, 8+var_5[sp]
FFF10436  2e17                              bra.b   loc_FFF1044D
FFF10438  b881                   loc_FFF10438 movu.w  8+var_4[sp], r1
FFF1043A  6602                              mov.l   #0, r2
FFF1043C  0532fbff                          bsr.a   sub_FFF0FF6E
FFF10440  b881                              movu.w  8+var_4[sp], r1
FFF10442  71111e                            add     #1Eh, r1, r1
FFF10445  9081                              mov.w   r1, 8+var_4[sp]
FFF10447  b089                              movu.b  8+var_5[sp], r1
FFF10449  6211                              add     #1, r1
FFF1044B  8089                              mov.b   r1, 8+var_5[sp]
FFF1044D  b089                   loc_FFF1044D movu.b  8+var_5[sp], r1
FFF1044F  6161                              cmp     #6, r1
FFF10451  29e7                              blt.b   loc_FFF10438
FFF10453  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10459  58ef                              movu.b  [r14], r15
FFF1045B  621f                              add     #1, r15
FFF1045D  c3ef                              mov.b   r15, [r14]
FFF1045F  6702                              rtsd    #2
FFF10461  6040                   sub_FFF10461 sub     #4, sp   ; <<<< FUNC sub_FFF10461
FFF10463  6040                              sub     #4, sp
FFF10465  3d00f0                            mov.w   #-10h, [sp]
FFF10468  fb4a4001                          mov.l   #140h, r4
FFF1046C  6602                              mov.l   #0, r2
FFF1046E  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10474  ef23                              mov.l   r2, r3
FFF10476  0545f5fd                          bsr.a   sub_FFEEF9BB
FFF1047A  6240                              add     #4, sp
FFF1047C  8089                              mov.b   r1, 4+var_1[sp]
FFF1047E  b089                              movu.b  4+var_1[sp], r1
FFF10480  6111                              cmp     #1, r1
FFF10482  1a                                bne.s   loc_FFF1048C
FFF10483  39a102                            bsr.w   sub_FFF10724
FFF10486  05e9fefd                          bsr.a   sub_FFEF036F
FFF1048A  6701                              rtsd    #1
FFF1048C  6701                   loc_FFF1048C rtsd    #1
FFF1048E  6040                   sub_FFF1048E sub     #4, sp   ; <<<< FUNC sub_FFF1048E
FFF10490  6040                              sub     #4, sp
FFF10492  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF10495  fb4a4001                          mov.l   #140h, r4
FFF10499  75433c                            mov.l   #3Ch, r3 ; '<'
FFF1049C  6602                              mov.l   #0, r2
FFF1049E  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF104A4  0517f5fd                          bsr.a   sub_FFEEF9BB
FFF104A8  6240                              add     #4, sp
FFF104AA  8089                              mov.b   r1, 4+var_1[sp]
FFF104AC  b089                              movu.b  4+var_1[sp], r1
FFF104AE  6111                              cmp     #1, r1
FFF104B0  2112                              bne.b   loc_FFF104C2
FFF104B2  75423c                            mov.l   #3Ch, r2 ; '<'
FFF104B5  6601                              mov.l   #0, r1
FFF104B7  ef13                              mov.l   r1, r3
FFF104B9  39a202                            bsr.w   sub_FFF1075B
FFF104BC  05b3fefd                          bsr.a   sub_FFEF036F
FFF104C0  6701                              rtsd    #1
FFF104C2  6701                   loc_FFF104C2 rtsd    #1
FFF104C4  6040                   sub_FFF104C4 sub     #4, sp   ; <<<< FUNC sub_FFF104C4
FFF104C6  6040                              sub     #4, sp
FFF104C8  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF104CB  fb4a4001                          mov.l   #140h, r4
FFF104CF  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF104D2  6602                              mov.l   #0, r2
FFF104D4  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF104DA  05e1f4fd                          bsr.a   sub_FFEEF9BB
FFF104DE  6240                              add     #4, sp
FFF104E0  8089                              mov.b   r1, 4+var_1[sp]
FFF104E2  b089                              movu.b  4+var_1[sp], r1
FFF104E4  6111                              cmp     #1, r1
FFF104E6  2112                              bne.b   loc_FFF104F8
FFF104E8  6613                              mov.l   #1, r3
FFF104EA  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF104ED  6601                              mov.l   #0, r1
FFF104EF  396c02                            bsr.w   sub_FFF1075B
FFF104F2  057dfefd                          bsr.a   sub_FFEF036F
FFF104F6  6701                              rtsd    #1
FFF104F8  6701                   loc_FFF104F8 rtsd    #1
FFF104FA  6040                   sub_FFF104FA sub     #4, sp   ; <<<< FUNC sub_FFF104FA
FFF104FC  6040                              sub     #4, sp
FFF104FE  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF10501  fb4a4001                          mov.l   #140h, r4
FFF10505  754378                            mov.l   #78h, r3 ; 'x'
FFF10508  6602                              mov.l   #0, r2
FFF1050A  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10510  05abf4fd                          bsr.a   sub_FFEEF9BB
FFF10514  6240                              add     #4, sp
FFF10516  8089                              mov.b   r1, 4+var_1[sp]
FFF10518  b089                              movu.b  4+var_1[sp], r1
FFF1051A  6111                              cmp     #1, r1
FFF1051C  2112                              bne.b   loc_FFF1052E
FFF1051E  6623                              mov.l   #2, r3
FFF10520  754278                            mov.l   #78h, r2 ; 'x'
FFF10523  6601                              mov.l   #0, r1
FFF10525  393602                            bsr.w   sub_FFF1075B
FFF10528  0547fefd                          bsr.a   sub_FFEF036F
FFF1052C  6701                              rtsd    #1
FFF1052E  6701                   loc_FFF1052E rtsd    #1
FFF10530  6040                   sub_FFF10530 sub     #4, sp   ; <<<< FUNC sub_FFF10530
FFF10532  6040                              sub     #4, sp
FFF10534  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF10537  fb4a4001                          mov.l   #140h, r4
FFF1053B  754396                            mov.l   #-6Ah, r3
FFF1053E  6602                              mov.l   #0, r2
FFF10540  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10546  0575f4fd                          bsr.a   sub_FFEEF9BB
FFF1054A  6240                              add     #4, sp
FFF1054C  8089                              mov.b   r1, 4+var_1[sp]
FFF1054E  b089                              movu.b  4+var_1[sp], r1
FFF10550  6111                              cmp     #1, r1
FFF10552  2112                              bne.b   loc_FFF10564
FFF10554  6633                              mov.l   #3, r3
FFF10556  754296                            mov.l   #-6Ah, r2
FFF10559  6601                              mov.l   #0, r1
FFF1055B  390002                            bsr.w   sub_FFF1075B
FFF1055E  0511fefd                          bsr.a   sub_FFEF036F
FFF10562  6701                              rtsd    #1
FFF10564  6701                   loc_FFF10564 rtsd    #1
FFF10566  6040                   sub_FFF10566 sub     #4, sp   ; <<<< FUNC sub_FFF10566
FFF10568  6040                              sub     #4, sp
FFF1056A  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF1056D  fb4a4001                          mov.l   #140h, r4
FFF10571  7543b4                            mov.l   #-4Ch, r3
FFF10574  6602                              mov.l   #0, r2
FFF10576  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF1057C  053ff4fd                          bsr.a   sub_FFEEF9BB
FFF10580  6240                              add     #4, sp
FFF10582  8089                              mov.b   r1, 4+var_1[sp]
FFF10584  b089                              movu.b  4+var_1[sp], r1
FFF10586  6111                              cmp     #1, r1
FFF10588  2112                              bne.b   loc_FFF1059A
FFF1058A  6643                              mov.l   #4, r3
FFF1058C  7542b4                            mov.l   #-4Ch, r2
FFF1058F  6601                              mov.l   #0, r1
FFF10591  39ca01                            bsr.w   sub_FFF1075B
FFF10594  05dbfdfd                          bsr.a   sub_FFEF036F
FFF10598  6701                              rtsd    #1
FFF1059A  6701                   loc_FFF1059A rtsd    #1
FFF1059C  6040                   sub_FFF1059C sub     #4, sp   ; <<<< FUNC sub_FFF1059C
FFF1059E  05a1fafd                          bsr.a   sub_FFEF003F
FFF105A2  fbe2738f0000                      mov.l   #8F73h, r14
FFF105A8  c3e1                              mov.b   r1, [r14]
FFF105AA  fbe2738f0000                      mov.l   #8F73h, r14
FFF105B0  58ee                              movu.b  [r14], r14
FFF105B2  755eff                            cmp     #-1, r14
FFF105B5  1e                                bne.s   loc_FFF105BB
FFF105B6  6601                              mov.l   #0, r1
FFF105B8  396a00                            bsr.w   sub_FFF10622
FFF105BB  fbe2738f0000           loc_FFF105BB mov.l   #8F73h, r14
FFF105C1  58ee                              movu.b  [r14], r14
FFF105C3  755eff                            cmp     #-1, r14
FFF105C6  2013                              beq.b   loc_FFF105D9
FFF105C8  fbe2738f0000                      mov.l   #8F73h, r14
FFF105CE  58ee                              movu.b  [r14], r14
FFF105D0  755e13                            cmp     #13h, r14
FFF105D3  2406                              bgtu.b  loc_FFF105D9
FFF105D5  f80601                            mov.l   #1, 4+var_4[sp]
FFF105D8  0c                                bra.s   loc_FFF105DC
FFF105D9  f80600                 loc_FFF105D9 mov.l   #0, 4+var_4[sp]
FFF105DC  ec01                   loc_FFF105DC mov.l   4+var_4[sp], r1
FFF105DE  6101                              cmp     #0, r1
FFF105E0  2029                              beq.b   loc_FFF10609
FFF105E2  05a2f5fd                          bsr.a   sub_FFEEFB84
FFF105E6  6101                              cmp     #0, r1
FFF105E8  2121                              bne.b   loc_FFF10609
FFF105EA  fbe2738f0000                      mov.l   #8F73h, r14
FFF105F0  58e1                              movu.b  [r14], r1
FFF105F2  05f8f9fd                          bsr.a   sub_FFEEFFEA
FFF105F6  fbe2738f0000                      mov.l   #8F73h, r14
FFF105FC  58ee                              movu.b  [r14], r14
FFF105FE  fbf2507bedff                      mov.l   #off_FFED7B50, r15
FFF10604  fe6efe                            mov.l   [r14, r15], r14
FFF10607  7f1e                              jsr     r14
FFF10609  fbe24c8c0000           loc_FFF10609 mov.l   #8C4Ch, r14
FFF1060F  58ee                              movu.b  [r14], r14
FFF10611  614e                              cmp     #4, r14
FFF10613  290d                              blt.b   loc_FFF10620
FFF10615  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1061B  f8e403                            mov.b   #3, [r14]
FFF1061E  6701                              rtsd    #1
FFF10620  6701                   loc_FFF10620 rtsd    #1
FFF10622  6040                   sub_FFF10622 sub     #4, sp   ; <<<< FUNC sub_FFF10622
FFF10624  8089                              mov.b   r1, 4+var_1[sp]
FFF10626  05433afe                          bsr.a   sub_FFEF4069
FFF1062A  391400                            bsr.w   sub_FFF1063E
FFF1062D  058d3afe                          bsr.a   sub_FFEF40BA
FFF10631  b089                              movu.b  4+var_1[sp], r1
FFF10633  6111                              cmp     #1, r1
FFF10635  1f                                bne.s   loc_FFF1063C
FFF10636  05f6f9fd                          bsr.a   sub_FFEF002C
FFF1063A  6701                              rtsd    #1
FFF1063C  6701                   loc_FFF1063C rtsd    #1
FFF1063E  6040                   sub_FFF1063E sub     #4, sp   ; <<<< FUNC sub_FFF1063E
FFF10640  fb22468e0000                      mov.l   #8E46h, r2
FFF10646  712220                            add     #20h, r2, r2 ; ' '
FFF10649  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF1064F  711120                            add     #20h, r1, r1 ; ' '
FFF10652  6614                              mov.l   #1, r4
FFF10654  754313                            mov.l   #13h, r3
FFF10657  05361afe                          bsr.a   sub_FFEF208D
FFF1065B  fbe2468e0000                      mov.l   #8E46h, r14
FFF10661  59ef33                            movu.b  33h[r14], r15
FFF10664  eff5                              mov.l   r15, r5
FFF10666  fd749505                          divu    #5, r5
FFF1066A  6355                              mul     #5, r5
FFF1066C  435f                              sub     r5, r15
FFF1066E  c7ef33                            mov.b   r15, 33h[r14]
FFF10671  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10677  59ee33                            movu.b  33h[r14], r14
FFF1067A  fbf2468e0000                      mov.l   #8E46h, r15
FFF10680  45fe33                            cmp     33h[r15], r14
FFF10683  2037                              beq.b   loc_FFF106BA
FFF10685  fbe2468e0000                      mov.l   #8E46h, r14
FFF1068B  59ee33                            movu.b  33h[r14], r14
FFF1068E  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF10694  59ff33                            movu.b  33h[r15], r15
FFF10697  fb5e008000                        mov.l   #8000h, r5
FFF1069C  ef51                              mov.l   r5, r1
FFF1069E  fd62f1                            shll    r15, r1
FFF106A1  fd62e5                            shll    r14, r5
FFF106A4  5751                              or      r5, r1
FFF106A6  05fef7fd                          bsr.a   sub_FFEEFEA4
FFF106AA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF106B0  fbf2468e0000                      mov.l   #8E46h, r15
FFF106B6  c5fe3333                          mov.b   33h[r15], 33h[r14]
FFF106BA  3c0300                 loc_FFF106BA mov.b   #0, 4+var_1[sp]
FFF106BD  2e5b                              bra.b   loc_FFF10718
FFF106BF  b08b                   loc_FFF106BF movu.b  4+var_1[sp], r3
FFF106C1  fb4e008000                        mov.l   #8000h, r4
FFF106C6  fd6234                            shll    r3, r4
FFF106C9  751311                            mul     #11h, r3
FFF106CC  fb22468e0000                      mov.l   #8E46h, r2
FFF106D2  4b32                              add     r3, r2
FFF106D4  712234                            add     #34h, r2, r2 ; '4'
FFF106D7  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF106DD  4b31                              add     r3, r1
FFF106DF  711134                            add     #34h, r1, r1 ; '4'
FFF106E2  6613                              mov.l   #1, r3
FFF106E4  05a919fe                          bsr.a   sub_FFEF208D
FFF106E8  b08b                              movu.b  4+var_1[sp], r3
FFF106EA  fb4e008000                        mov.l   #8000h, r4
FFF106EF  fd6234                            shll    r3, r4
FFF106F2  751311                            mul     #11h, r3
FFF106F5  fb22468e0000                      mov.l   #8E46h, r2
FFF106FB  4b32                              add     r3, r2
FFF106FD  712235                            add     #35h, r2, r2 ; '5'
FFF10700  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF10706  4b31                              add     r3, r1
FFF10708  711135                            add     #35h, r1, r1 ; '5'
FFF1070B  754310                            mov.l   #10h, r3
FFF1070E  057f19fe                          bsr.a   sub_FFEF208D
FFF10712  b089                              movu.b  4+var_1[sp], r1
FFF10714  6211                              add     #1, r1
FFF10716  8089                              mov.b   r1, 4+var_1[sp]
FFF10718  b089                   loc_FFF10718 movu.b  4+var_1[sp], r1
FFF1071A  6151                              cmp     #5, r1
FFF1071C  29a3                              blt.b   loc_FFF106BF
FFF1071E  0576fbfd                          bsr.a   sub_FFEF0294
FFF10722  6701                              rtsd    #1
FFF10724  6040                   sub_FFF10724 sub     #4, sp   ; <<<< FUNC sub_FFF10724
FFF10726  fbe2798d0000                      mov.l   #8D79h, r14
FFF1072C  f8e400                            mov.b   #0, [r14]
FFF1072F  6601                              mov.l   #0, r1
FFF10731  ef12                              mov.l   r1, r2
FFF10733  05d5fcfd                          bsr.a   sub_FFEF0408
FFF10737  3c0300                            mov.b   #0, 4+var_1[sp]
FFF1073A  2e19                              bra.b   loc_FFF10753
FFF1073C  b08b                   loc_FFF1073C movu.b  4+var_1[sp], r3
FFF1073E  ef3e                              mov.l   r3, r14
FFF10740  751e1e                            mul     #1Eh, r14
FFF10743  71ee3c                            add     #3Ch, r14, r14 ; '<'
FFF10746  5fe2                              movu.w  r14, r2
FFF10748  6601                              mov.l   #0, r1
FFF1074A  391100                            bsr.w   sub_FFF1075B
FFF1074D  b089                              movu.b  4+var_1[sp], r1
FFF1074F  6211                              add     #1, r1
FFF10751  8089                              mov.b   r1, 4+var_1[sp]
FFF10753  b089                   loc_FFF10753 movu.b  4+var_1[sp], r1
FFF10755  6151                              cmp     #5, r1
FFF10757  29e5                              blt.b   loc_FFF1073C
FFF10759  6701                              rtsd    #1
FFF1075B  6080                   sub_FFF1075B sub     #8, sp   ; <<<< FUNC sub_FFF1075B
FFF1075D  9089                              mov.w   r1, 8+var_2[sp]
FFF1075F  9082                              mov.w   r2, 8+var_4[sp]
FFF10761  808b                              mov.b   r3, 8+var_5[sp]
FFF10763  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10769  c5e03302                          mov.b   33h[r14], 8+var_6[sp]
FFF1076D  b089                              movu.b  8+var_5[sp], r1
FFF1076F  751111                            mul     #11h, r1
FFF10772  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10778  4b1e                              add     r1, r14
FFF1077A  c5e03401                          mov.b   34h[r14], 8+var_7[sp]
FFF1077E  b881                              movu.w  8+var_4[sp], r1
FFF10780  6211                              add     #1, r1
FFF10782  5f12                              movu.w  r1, r2
FFF10784  75441d                            mov.l   #1Dh, r4
FFF10787  fb3a4001                          mov.l   #140h, r3
FFF1078B  6601                              mov.l   #0, r1
FFF1078D  056afdfd                          bsr.a   sub_FFEF04F7
FFF10791  b081                              movu.b  8+var_6[sp], r1
FFF10793  450103                            cmp     8+var_5[sp], r1
FFF10796  211d                              bne.b   loc_FFF107B3
FFF10798  b881                              movu.w  8+var_4[sp], r1
FFF1079A  6040                              sub     #4, sp
FFF1079C  f80980f9                          mov.w   #-680h, 0Ch+var_C[sp]
FFF107A0  6211                              add     #1, r1
FFF107A2  5f12                              movu.w  r1, r2
FFF107A4  75441d                            mov.l   #1Dh, r4
FFF107A7  fb3a3401                          mov.l   #134h, r3
FFF107AB  6661                              mov.l   #6, r1
FFF107AD  059b14fe                          bsr.a   sub_FFEF1C48
FFF107B1  6240                              add     #4, sp
FFF107B3  b009                   loc_FFF107B3 movu.b  8+var_7[sp], r1
FFF107B5  6111                              cmp     #1, r1
FFF107B7  2133                              bne.b   loc_FFF107EA
FFF107B9  3d0330                            mov.w   #30h, 8+var_2[sp] ; '0'
FFF107BC  b08a                              movu.b  8+var_5[sp], r2
FFF107BE  b883                              movu.w  8+var_4[sp], r3
FFF107C0  b889                              movu.w  8+var_2[sp], r1
FFF107C2  60c0                              sub     #0Ch, sp
FFF107C4  751211                            mul     #11h, r2
FFF107C7  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF107CD  4b24                              add     r2, r4
FFF107CF  714435                            add     #35h, r4, r4 ; '5'
FFF107D2  a00c                              mov.l   r4, 14h+var_10[sp]
FFF107D4  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF107D7  f80410                            mov.b   #10h, 14h+var_14[sp]
FFF107DA  6213                              add     #1, r3
FFF107DC  5f32                              movu.w  r3, r2
FFF107DE  6604                              mov.l   #0, r4
FFF107E0  66d3                              mov.l   #0Dh, r3
FFF107E2  054113fe                          bsr.a   sub_FFEF1B23
FFF107E6  62c0                              add     #0Ch, sp
FFF107E8  6702                              rtsd    #2
FFF107EA  6702                   loc_FFF107EA rtsd    #2
FFF107EC  fbe24c8c0000           sub_FFF107EC mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF107EC
FFF107F2  58ee                              movu.b  [r14], r14
FFF107F4  613e                              cmp     #3, r14
FFF107F6  2a16                              bgt.b   loc_FFF1080C
FFF107F8  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF107FE  58ee                              movu.b  [r14], r14
FFF10800  fbf2a07bedff                      mov.l   #off_FFED7BA0, r15
FFF10806  fe6efe                            mov.l   [r14, r15], r14
FFF10809  7f1e                              jsr     r14
FFF1080B  02                                rts
FFF1080C  fbe24c8c0000           loc_FFF1080C mov.l   #8C4Ch, r14
FFF10812  f8e403                            mov.b   #3, [r14]
FFF10815  02                                rts
FFF10816  6611                   sub_FFF10816 mov.l   #1, r1   ; <<<< FUNC sub_FFF10816
FFF10818  394402                            bsr.w   sub_FFF10A5C
FFF1081B  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10821  58ef                              movu.b  [r14], r15
FFF10823  621f                              add     #1, r15
FFF10825  c3ef                              mov.b   r15, [r14]
FFF10827  02                                rts
FFF10828  6080                   sub_FFF10828 sub     #8, sp   ; <<<< FUNC sub_FFF10828
FFF1082A  0503fbfd                          bsr.a   sub_FFEF032D
FFF1082E  05199ffe                          bsr.a   sub_FFEFA747
FFF10832  3d0306                            mov.w   #6, 8+var_2[sp]
FFF10835  3d0200                            mov.w   #0, 8+var_4[sp]
FFF10838  b882                              movu.w  8+var_4[sp], r2
FFF1083A  b889                              movu.w  8+var_2[sp], r1
FFF1083C  60c0                              sub     #0Ch, sp
FFF1083E  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF10844  713320                            add     #20h, r3, r3 ; ' '
FFF10847  a00b                              mov.l   r3, 14h+var_10[sp]
FFF10849  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF1084C  f80413                            mov.b   #13h, 14h+var_14[sp]
FFF1084F  6212                              add     #1, r2
FFF10851  5f22                              movu.w  r2, r2
FFF10853  6604                              mov.l   #0, r4
FFF10855  66d3                              mov.l   #0Dh, r3
FFF10857  05cc12fe                          bsr.a   sub_FFEF1B23
FFF1085B  62c0                              add     #0Ch, sp
FFF1085D  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF10860  3c0300                            mov.b   #0, 8+var_5[sp]
FFF10863  2e17                              bra.b   loc_FFF1087A
FFF10865  b881                   loc_FFF10865 movu.w  8+var_4[sp], r1
FFF10867  6602                              mov.l   #0, r2
FFF10869  0505f7ff                          bsr.a   sub_FFF0FF6E
FFF1086D  b881                              movu.w  8+var_4[sp], r1
FFF1086F  71111e                            add     #1Eh, r1, r1
FFF10872  9081                              mov.w   r1, 8+var_4[sp]
FFF10874  b089                              movu.b  8+var_5[sp], r1
FFF10876  6211                              add     #1, r1
FFF10878  8089                              mov.b   r1, 8+var_5[sp]
FFF1087A  b089                   loc_FFF1087A movu.b  8+var_5[sp], r1
FFF1087C  6151                              cmp     #5, r1
FFF1087E  29e7                              blt.b   loc_FFF10865
FFF10880  6661                              mov.l   #6, r1
FFF10882  050d96fe                          bsr.a   sub_FFEF9E8F
FFF10886  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1088C  58ef                              movu.b  [r14], r15
FFF1088E  621f                              add     #1, r15
FFF10890  c3ef                              mov.b   r15, [r14]
FFF10892  6702                              rtsd    #2
FFF10894  6040                   sub_FFF10894 sub     #4, sp   ; <<<< FUNC sub_FFF10894
FFF10896  6040                              sub     #4, sp
FFF10898  3d00f0                            mov.w   #-10h, [sp]
FFF1089B  fb4a4001                          mov.l   #140h, r4
FFF1089F  6602                              mov.l   #0, r2
FFF108A1  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF108A7  ef23                              mov.l   r2, r3
FFF108A9  0512f1fd                          bsr.a   sub_FFEEF9BB
FFF108AD  6240                              add     #4, sp
FFF108AF  8089                              mov.b   r1, 4+var_1[sp]
FFF108B1  b089                              movu.b  4+var_1[sp], r1
FFF108B3  6111                              cmp     #1, r1
FFF108B5  1a                                bne.s   loc_FFF108BF
FFF108B6  393903                            bsr.w   sub_FFF10BEF
FFF108B9  05b6fafd                          bsr.a   sub_FFEF036F
FFF108BD  6701                              rtsd    #1
FFF108BF  6701                   loc_FFF108BF rtsd    #1
FFF108C1  6040                   sub_FFF108C1 sub     #4, sp   ; <<<< FUNC sub_FFF108C1
FFF108C3  6040                              sub     #4, sp
FFF108C5  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF108C8  fb4a4001                          mov.l   #140h, r4
FFF108CC  75431e                            mov.l   #1Eh, r3
FFF108CF  6602                              mov.l   #0, r2
FFF108D1  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF108D7  05e4f0fd                          bsr.a   sub_FFEEF9BB
FFF108DB  6240                              add     #4, sp
FFF108DD  8089                              mov.b   r1, 4+var_1[sp]
FFF108DF  b089                              movu.b  4+var_1[sp], r1
FFF108E1  6111                              cmp     #1, r1
FFF108E3  2112                              bne.b   loc_FFF108F5
FFF108E5  75421e                            mov.l   #1Eh, r2
FFF108E8  6601                              mov.l   #0, r1
FFF108EA  ef13                              mov.l   r1, r3
FFF108EC  394603                            bsr.w   sub_FFF10C32
FFF108EF  0580fafd                          bsr.a   sub_FFEF036F
FFF108F3  6701                              rtsd    #1
FFF108F5  6701                   loc_FFF108F5 rtsd    #1
FFF108F7  6040                   sub_FFF108F7 sub     #4, sp   ; <<<< FUNC sub_FFF108F7
FFF108F9  6040                              sub     #4, sp
FFF108FB  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF108FE  fb4a4001                          mov.l   #140h, r4
FFF10902  75433c                            mov.l   #3Ch, r3 ; '<'
FFF10905  6602                              mov.l   #0, r2
FFF10907  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF1090D  05aef0fd                          bsr.a   sub_FFEEF9BB
FFF10911  6240                              add     #4, sp
FFF10913  8089                              mov.b   r1, 4+var_1[sp]
FFF10915  b089                              movu.b  4+var_1[sp], r1
FFF10917  6111                              cmp     #1, r1
FFF10919  2112                              bne.b   loc_FFF1092B
FFF1091B  6613                              mov.l   #1, r3
FFF1091D  75423c                            mov.l   #3Ch, r2 ; '<'
FFF10920  6601                              mov.l   #0, r1
FFF10922  391003                            bsr.w   sub_FFF10C32
FFF10925  054afafd                          bsr.a   sub_FFEF036F
FFF10929  6701                              rtsd    #1
FFF1092B  6701                   loc_FFF1092B rtsd    #1
FFF1092D  6040                   sub_FFF1092D sub     #4, sp   ; <<<< FUNC sub_FFF1092D
FFF1092F  6040                              sub     #4, sp
FFF10931  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF10934  fb4a4001                          mov.l   #140h, r4
FFF10938  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF1093B  6602                              mov.l   #0, r2
FFF1093D  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10943  0578f0fd                          bsr.a   sub_FFEEF9BB
FFF10947  6240                              add     #4, sp
FFF10949  8089                              mov.b   r1, 4+var_1[sp]
FFF1094B  b089                              movu.b  4+var_1[sp], r1
FFF1094D  6111                              cmp     #1, r1
FFF1094F  2112                              bne.b   loc_FFF10961
FFF10951  6623                              mov.l   #2, r3
FFF10953  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF10956  6601                              mov.l   #0, r1
FFF10958  39da02                            bsr.w   sub_FFF10C32
FFF1095B  0514fafd                          bsr.a   sub_FFEF036F
FFF1095F  6701                              rtsd    #1
FFF10961  6701                   loc_FFF10961 rtsd    #1
FFF10963  6040                   sub_FFF10963 sub     #4, sp   ; <<<< FUNC sub_FFF10963
FFF10965  6040                              sub     #4, sp
FFF10967  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF1096A  fb4a4001                          mov.l   #140h, r4
FFF1096E  754378                            mov.l   #78h, r3 ; 'x'
FFF10971  6602                              mov.l   #0, r2
FFF10973  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10979  0542f0fd                          bsr.a   sub_FFEEF9BB
FFF1097D  6240                              add     #4, sp
FFF1097F  8089                              mov.b   r1, 4+var_1[sp]
FFF10981  b089                              movu.b  4+var_1[sp], r1
FFF10983  6111                              cmp     #1, r1
FFF10985  2112                              bne.b   loc_FFF10997
FFF10987  6633                              mov.l   #3, r3
FFF10989  754278                            mov.l   #78h, r2 ; 'x'
FFF1098C  6601                              mov.l   #0, r1
FFF1098E  39a402                            bsr.w   sub_FFF10C32
FFF10991  05def9fd                          bsr.a   sub_FFEF036F
FFF10995  6701                              rtsd    #1
FFF10997  6701                   loc_FFF10997 rtsd    #1
FFF10999  6040                   sub_FFF10999 sub     #4, sp   ; <<<< FUNC sub_FFF10999
FFF1099B  6040                              sub     #4, sp
FFF1099D  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF109A0  fb4a4001                          mov.l   #140h, r4
FFF109A4  754396                            mov.l   #-6Ah, r3
FFF109A7  6602                              mov.l   #0, r2
FFF109A9  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF109AF  050cf0fd                          bsr.a   sub_FFEEF9BB
FFF109B3  6240                              add     #4, sp
FFF109B5  8089                              mov.b   r1, 4+var_1[sp]
FFF109B7  b089                              movu.b  4+var_1[sp], r1
FFF109B9  6111                              cmp     #1, r1
FFF109BB  2112                              bne.b   loc_FFF109CD
FFF109BD  6643                              mov.l   #4, r3
FFF109BF  754296                            mov.l   #-6Ah, r2
FFF109C2  6601                              mov.l   #0, r1
FFF109C4  396e02                            bsr.w   sub_FFF10C32
FFF109C7  05a8f9fd                          bsr.a   sub_FFEF036F
FFF109CB  6701                              rtsd    #1
FFF109CD  6701                   loc_FFF109CD rtsd    #1
FFF109CF  66f1                   sub_FFF109CF mov.l   #0Fh, r1   ; <<<< FUNC sub_FFF109CF
FFF109D1  0529f5ff                          bsr.a   sub_FFF0FEFA
FFF109D5  02                                rts
FFF109D6  6040                   sub_FFF109D6 sub     #4, sp   ; <<<< FUNC sub_FFF109D6
FFF109D8  0567f6fd                          bsr.a   sub_FFEF003F
FFF109DC  fbe2738f0000                      mov.l   #8F73h, r14
FFF109E2  c3e1                              mov.b   r1, [r14]
FFF109E4  fbe2738f0000                      mov.l   #8F73h, r14
FFF109EA  58ee                              movu.b  [r14], r14
FFF109EC  755eff                            cmp     #-1, r14
FFF109EF  1e                                bne.s   loc_FFF109F5
FFF109F0  6601                              mov.l   #0, r1
FFF109F2  396a00                            bsr.w   sub_FFF10A5C
FFF109F5  fbe2738f0000           loc_FFF109F5 mov.l   #8F73h, r14
FFF109FB  58ee                              movu.b  [r14], r14
FFF109FD  755eff                            cmp     #-1, r14
FFF10A00  2013                              beq.b   loc_FFF10A13
FFF10A02  fbe2738f0000                      mov.l   #8F73h, r14
FFF10A08  58ee                              movu.b  [r14], r14
FFF10A0A  755e15                            cmp     #15h, r14
FFF10A0D  2406                              bgtu.b  loc_FFF10A13
FFF10A0F  f80601                            mov.l   #1, 4+var_4[sp]
FFF10A12  0c                                bra.s   loc_FFF10A16
FFF10A13  f80600                 loc_FFF10A13 mov.l   #0, 4+var_4[sp]
FFF10A16  ec01                   loc_FFF10A16 mov.l   4+var_4[sp], r1
FFF10A18  6101                              cmp     #0, r1
FFF10A1A  2029                              beq.b   loc_FFF10A43
FFF10A1C  0568f1fd                          bsr.a   sub_FFEEFB84
FFF10A20  6101                              cmp     #0, r1
FFF10A22  2121                              bne.b   loc_FFF10A43
FFF10A24  fbe2738f0000                      mov.l   #8F73h, r14
FFF10A2A  58e1                              movu.b  [r14], r1
FFF10A2C  05bef5fd                          bsr.a   sub_FFEEFFEA
FFF10A30  fbe2738f0000                      mov.l   #8F73h, r14
FFF10A36  58ee                              movu.b  [r14], r14
FFF10A38  fbf2b07bedff                      mov.l   #off_FFED7BB0, r15
FFF10A3E  fe6efe                            mov.l   [r14, r15], r14
FFF10A41  7f1e                              jsr     r14
FFF10A43  fbe24c8c0000           loc_FFF10A43 mov.l   #8C4Ch, r14
FFF10A49  58ee                              movu.b  [r14], r14
FFF10A4B  614e                              cmp     #4, r14
FFF10A4D  290d                              blt.b   loc_FFF10A5A
FFF10A4F  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10A55  f8e403                            mov.b   #3, [r14]
FFF10A58  6701                              rtsd    #1
FFF10A5A  6701                   loc_FFF10A5A rtsd    #1
FFF10A5C  6040                   sub_FFF10A5C sub     #4, sp   ; <<<< FUNC sub_FFF10A5C
FFF10A5E  8089                              mov.b   r1, 4+var_1[sp]
FFF10A60  050936fe                          bsr.a   sub_FFEF4069
FFF10A64  391400                            bsr.w   sub_FFF10A78
FFF10A67  055336fe                          bsr.a   sub_FFEF40BA
FFF10A6B  b089                              movu.b  4+var_1[sp], r1
FFF10A6D  6111                              cmp     #1, r1
FFF10A6F  1f                                bne.s   loc_FFF10A76
FFF10A70  05bcf5fd                          bsr.a   sub_FFEF002C
FFF10A74  6701                              rtsd    #1
FFF10A76  6701                   loc_FFF10A76 rtsd    #1
FFF10A78  6040                   sub_FFF10A78 sub     #4, sp   ; <<<< FUNC sub_FFF10A78
FFF10A7A  fb22468e0000                      mov.l   #8E46h, r2
FFF10A80  712220                            add     #20h, r2, r2 ; ' '
FFF10A83  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF10A89  711120                            add     #20h, r1, r1 ; ' '
FFF10A8C  6614                              mov.l   #1, r4
FFF10A8E  754313                            mov.l   #13h, r3
FFF10A91  05fc15fe                          bsr.a   sub_FFEF208D
FFF10A95  fbe2468e0000                      mov.l   #8E46h, r14
FFF10A9B  59ef33                            movu.b  33h[r14], r15
FFF10A9E  eff5                              mov.l   r15, r5
FFF10AA0  fd749505                          divu    #5, r5
FFF10AA4  6355                              mul     #5, r5
FFF10AA6  435f                              sub     r5, r15
FFF10AA8  c7ef33                            mov.b   r15, 33h[r14]
FFF10AAB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10AB1  59ee33                            movu.b  33h[r14], r14
FFF10AB4  fbf2468e0000                      mov.l   #8E46h, r15
FFF10ABA  45fe33                            cmp     33h[r15], r14
FFF10ABD  2037                              beq.b   loc_FFF10AF4
FFF10ABF  fbe2468e0000                      mov.l   #8E46h, r14
FFF10AC5  59ee33                            movu.b  33h[r14], r14
FFF10AC8  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF10ACE  59ff33                            movu.b  33h[r15], r15
FFF10AD1  fb5e000002                        mov.l   #20000h, r5
FFF10AD6  ef51                              mov.l   r5, r1
FFF10AD8  fd62f1                            shll    r15, r1
FFF10ADB  fd62e5                            shll    r14, r5
FFF10ADE  5751                              or      r5, r1
FFF10AE0  05c4f3fd                          bsr.a   sub_FFEEFEA4
FFF10AE4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10AEA  fbf2468e0000                      mov.l   #8E46h, r15
FFF10AF0  c5fe3333                          mov.b   33h[r15], 33h[r14]
FFF10AF4  3c0300                 loc_FFF10AF4 mov.b   #0, 4+var_1[sp]
FFF10AF7  2e5b                              bra.b   loc_FFF10B52
FFF10AF9  b08b                   loc_FFF10AF9 movu.b  4+var_1[sp], r3
FFF10AFB  fb4e000002                        mov.l   #20000h, r4
FFF10B00  fd6234                            shll    r3, r4
FFF10B03  751318                            mul     #18h, r3
FFF10B06  fb22468e0000                      mov.l   #8E46h, r2
FFF10B0C  4b32                              add     r3, r2
FFF10B0E  712234                            add     #34h, r2, r2 ; '4'
FFF10B11  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF10B17  4b31                              add     r3, r1
FFF10B19  711134                            add     #34h, r1, r1 ; '4'
FFF10B1C  6613                              mov.l   #1, r3
FFF10B1E  056f15fe                          bsr.a   sub_FFEF208D
FFF10B22  b08b                              movu.b  4+var_1[sp], r3
FFF10B24  fb4e000002                        mov.l   #20000h, r4
FFF10B29  fd6234                            shll    r3, r4
FFF10B2C  751318                            mul     #18h, r3
FFF10B2F  fb22468e0000                      mov.l   #8E46h, r2
FFF10B35  4b32                              add     r3, r2
FFF10B37  712235                            add     #35h, r2, r2 ; '5'
FFF10B3A  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF10B40  4b31                              add     r3, r1
FFF10B42  711135                            add     #35h, r1, r1 ; '5'
FFF10B45  754317                            mov.l   #17h, r3
FFF10B48  054515fe                          bsr.a   sub_FFEF208D
FFF10B4C  b089                              movu.b  4+var_1[sp], r1
FFF10B4E  6211                              add     #1, r1
FFF10B50  8089                              mov.b   r1, 4+var_1[sp]
FFF10B52  b089                   loc_FFF10B52 movu.b  4+var_1[sp], r1
FFF10B54  6151                              cmp     #5, r1
FFF10B56  29a3                              blt.b   loc_FFF10AF9
FFF10B58  3c0300                            mov.b   #0, 4+var_1[sp]
FFF10B5B  388500                            bra.w   loc_FFF10BE0
FFF10B5E  b089                   loc_FFF10B5E movu.b  4+var_1[sp], r1
FFF10B60  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10B66  4b1e                              add     r1, r14
FFF10B68  59eeac                            movu.b  0ACh[r14], r14
FFF10B6B  fbf2468e0000                      mov.l   #8E46h, r15
FFF10B71  4b1f                              add     r1, r15
FFF10B73  45feac                            cmp     0ACh[r15], r14
FFF10B76  2026                              beq.b   loc_FFF10B9C
FFF10B78  b08a                              movu.b  4+var_1[sp], r2
FFF10B7A  fb1e008000                        mov.l   #8000h, r1
FFF10B7F  fd6221                            shll    r2, r1
FFF10B82  0522f3fd                          bsr.a   sub_FFEEFEA4
FFF10B86  b089                              movu.b  4+var_1[sp], r1
FFF10B88  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10B8E  4b1e                              add     r1, r14
FFF10B90  fbf2468e0000                      mov.l   #8E46h, r15
FFF10B96  4b1f                              add     r1, r15
FFF10B98  c5feacac                          mov.b   0ACh[r15], 0ACh[r14]
FFF10B9C  b089                   loc_FFF10B9C movu.b  4+var_1[sp], r1
FFF10B9E  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10BA4  4b1e                              add     r1, r14
FFF10BA6  59eeae                            movu.b  0AEh[r14], r14
FFF10BA9  fbf2468e0000                      mov.l   #8E46h, r15
FFF10BAF  4b1f                              add     r1, r15
FFF10BB1  45feae                            cmp     0AEh[r15], r14
FFF10BB4  2026                              beq.b   loc_FFF10BDA
FFF10BB6  b08a                              movu.b  4+var_1[sp], r2
FFF10BB8  fb1e008000                        mov.l   #8000h, r1
FFF10BBD  fd6221                            shll    r2, r1
FFF10BC0  05e4f2fd                          bsr.a   sub_FFEEFEA4
FFF10BC4  b089                              movu.b  4+var_1[sp], r1
FFF10BC6  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10BCC  4b1e                              add     r1, r14
FFF10BCE  fbf2468e0000                      mov.l   #8E46h, r15
FFF10BD4  4b1f                              add     r1, r15
FFF10BD6  c5feaeae                          mov.b   0AEh[r15], 0AEh[r14]
FFF10BDA  b089                   loc_FFF10BDA movu.b  4+var_1[sp], r1
FFF10BDC  6211                              add     #1, r1
FFF10BDE  8089                              mov.b   r1, 4+var_1[sp]
FFF10BE0  b089                   loc_FFF10BE0 movu.b  4+var_1[sp], r1
FFF10BE2  6121                              cmp     #2, r1
FFF10BE4  2805                              bge.b   loc_FFF10BE9
FFF10BE6  3878ff                            bra.w   loc_FFF10B5E
FFF10BE9  05abf6fd               loc_FFF10BE9 bsr.a   sub_FFEF0294
FFF10BED  6701                              rtsd    #1
FFF10BEF  6040                   sub_FFF10BEF sub     #4, sp   ; <<<< FUNC sub_FFF10BEF
FFF10BF1  fbe2798d0000                      mov.l   #8D79h, r14
FFF10BF7  f8e400                            mov.b   #0, [r14]
FFF10BFA  6601                              mov.l   #0, r1
FFF10BFC  ef12                              mov.l   r1, r2
FFF10BFE  050af8fd                          bsr.a   sub_FFEF0408
FFF10C02  3c0300                            mov.b   #0, 4+var_1[sp]
FFF10C05  2e19                              bra.b   loc_FFF10C1E
FFF10C07  b08b                   loc_FFF10C07 movu.b  4+var_1[sp], r3
FFF10C09  ef3e                              mov.l   r3, r14
FFF10C0B  751e1e                            mul     #1Eh, r14
FFF10C0E  71ee1e                            add     #1Eh, r14, r14
FFF10C11  5fe2                              movu.w  r14, r2
FFF10C13  6601                              mov.l   #0, r1
FFF10C15  391d00                            bsr.w   sub_FFF10C32
FFF10C18  b089                              movu.b  4+var_1[sp], r1
FFF10C1A  6211                              add     #1, r1
FFF10C1C  8089                              mov.b   r1, 4+var_1[sp]
FFF10C1E  b089                   loc_FFF10C1E movu.b  4+var_1[sp], r1
FFF10C20  6151                              cmp     #5, r1
FFF10C22  29e5                              blt.b   loc_FFF10C07
FFF10C24  6601                              mov.l   #0, r1
FFF10C26  05df18fe                          bsr.a   sub_FFEF2505
FFF10C2A  6611                              mov.l   #1, r1
FFF10C2C  05d918fe                          bsr.a   sub_FFEF2505
FFF10C30  6701                              rtsd    #1
FFF10C32  6080                   sub_FFF10C32 sub     #8, sp   ; <<<< FUNC sub_FFF10C32
FFF10C34  9089                              mov.w   r1, 8+var_2[sp]
FFF10C36  9082                              mov.w   r2, 8+var_4[sp]
FFF10C38  808b                              mov.b   r3, 8+var_5[sp]
FFF10C3A  b089                              movu.b  8+var_5[sp], r1
FFF10C3C  751118                            mul     #18h, r1
FFF10C3F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10C45  4b1e                              add     r1, r14
FFF10C47  c5e03402                          mov.b   34h[r14], 8+var_6[sp]
FFF10C4B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10C51  c5e03301                          mov.b   33h[r14], 8+var_7[sp]
FFF10C55  b881                              movu.w  8+var_4[sp], r1
FFF10C57  6211                              add     #1, r1
FFF10C59  5f12                              movu.w  r1, r2
FFF10C5B  75441d                            mov.l   #1Dh, r4
FFF10C5E  fb3a4001                          mov.l   #140h, r3
FFF10C62  6601                              mov.l   #0, r1
FFF10C64  0593f8fd                          bsr.a   sub_FFEF04F7
FFF10C68  b081                              movu.b  8+var_6[sp], r1
FFF10C6A  6101                              cmp     #0, r1
FFF10C6C  2055                              beq.b   loc_FFF10CC1
FFF10C6E  b009                              movu.b  8+var_7[sp], r1
FFF10C70  450103                            cmp     8+var_5[sp], r1
FFF10C73  211d                              bne.b   loc_FFF10C90
FFF10C75  b881                              movu.w  8+var_4[sp], r1
FFF10C77  6040                              sub     #4, sp
FFF10C79  f80980f9                          mov.w   #-680h, 0Ch+var_C[sp]
FFF10C7D  6211                              add     #1, r1
FFF10C7F  5f12                              movu.w  r1, r2
FFF10C81  75441d                            mov.l   #1Dh, r4
FFF10C84  fb3a3401                          mov.l   #134h, r3
FFF10C88  6661                              mov.l   #6, r1
FFF10C8A  05be0ffe                          bsr.a   sub_FFEF1C48
FFF10C8E  6240                              add     #4, sp
FFF10C90  3d0314                 loc_FFF10C90 mov.w   #14h, 8+var_2[sp]
FFF10C93  b08a                              movu.b  8+var_5[sp], r2
FFF10C95  b883                              movu.w  8+var_4[sp], r3
FFF10C97  b889                              movu.w  8+var_2[sp], r1
FFF10C99  60c0                              sub     #0Ch, sp
FFF10C9B  751218                            mul     #18h, r2
FFF10C9E  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF10CA4  4b24                              add     r2, r4
FFF10CA6  714435                            add     #35h, r4, r4 ; '5'
FFF10CA9  a00c                              mov.l   r4, 14h+var_10[sp]
FFF10CAB  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF10CAE  f80415                            mov.b   #15h, 14h+var_14[sp]
FFF10CB1  6213                              add     #1, r3
FFF10CB3  5f32                              movu.w  r3, r2
FFF10CB5  6604                              mov.l   #0, r4
FFF10CB7  66d3                              mov.l   #0Dh, r3
FFF10CB9  056a0efe                          bsr.a   sub_FFEF1B23
FFF10CBD  62c0                              add     #0Ch, sp
FFF10CBF  6702                              rtsd    #2
FFF10CC1  6702                   loc_FFF10CC1 rtsd    #2
FFF10CC3  fbe24c8c0000           sub_FFF10CC3 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF10CC3
FFF10CC9  58ee                              movu.b  [r14], r14
FFF10CCB  613e                              cmp     #3, r14
FFF10CCD  2a16                              bgt.b   loc_FFF10CE3
FFF10CCF  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10CD5  58ee                              movu.b  [r14], r14
FFF10CD7  fbf2087cedff                      mov.l   #off_FFED7C08, r15
FFF10CDD  fe6efe                            mov.l   [r14, r15], r14
FFF10CE0  7f1e                              jsr     r14
FFF10CE2  02                                rts
FFF10CE3  fbe24c8c0000           loc_FFF10CE3 mov.l   #8C4Ch, r14
FFF10CE9  f8e403                            mov.b   #3, [r14]
FFF10CEC  02                                rts
FFF10CED  6611                   sub_FFF10CED mov.l   #1, r1   ; <<<< FUNC sub_FFF10CED
FFF10CEF  394c02                            bsr.w   sub_FFF10F3B
FFF10CF2  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10CF8  58ef                              movu.b  [r14], r15
FFF10CFA  621f                              add     #1, r15
FFF10CFC  c3ef                              mov.b   r15, [r14]
FFF10CFE  02                                rts
FFF10CFF  6040                   sub_FFF10CFF sub     #4, sp   ; <<<< FUNC sub_FFF10CFF
FFF10D01  052cf6fd                          bsr.a   sub_FFEF032D
FFF10D05  05429afe                          bsr.a   sub_FFEFA747
FFF10D09  3d0102                            mov.w   #2, 4+var_2[sp]
FFF10D0C  f80504                            mov.w   #4, 4+var_4[sp]
FFF10D0F  5c02                              movu.w  4+var_4[sp], r2
FFF10D11  b809                              movu.w  4+var_2[sp], r1
FFF10D13  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF10D19  6613                              mov.l   #1, r3
FFF10D1B  05ba5bfe                          bsr.a   sub_FFEF68D5
FFF10D1F  3d0130                            mov.w   #30h, 4+var_2[sp] ; '0'
FFF10D22  f80502                            mov.w   #2, 4+var_4[sp]
FFF10D25  5c02                              movu.w  4+var_4[sp], r2
FFF10D27  b809                              movu.w  4+var_2[sp], r1
FFF10D29  60c0                              sub     #0Ch, sp
FFF10D2B  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF10D31  713320                            add     #20h, r3, r3 ; ' '
FFF10D34  a00b                              mov.l   r3, 10h+var_C[sp]
FFF10D36  3c0801                            mov.b   #1, 10h+var_8[sp]
FFF10D39  f80413                            mov.b   #13h, 10h+var_10[sp]
FFF10D3C  6604                              mov.l   #0, r4
FFF10D3E  66d3                              mov.l   #0Dh, r3
FFF10D40  05e30dfe                          bsr.a   sub_FFEF1B23
FFF10D44  62c0                              add     #0Ch, sp
FFF10D46  f8051e                            mov.w   #1Eh, 4+var_4[sp]
FFF10D49  5c01                              movu.w  4+var_4[sp], r1
FFF10D4B  6602                              mov.l   #0, r2
FFF10D4D  0521f2ff                          bsr.a   sub_FFF0FF6E
FFF10D51  6661                              mov.l   #6, r1
FFF10D53  053c91fe                          bsr.a   sub_FFEF9E8F
FFF10D57  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10D5D  58ef                              movu.b  [r14], r15
FFF10D5F  621f                              add     #1, r15
FFF10D61  c3ef                              mov.b   r15, [r14]
FFF10D63  6701                              rtsd    #1
FFF10D65  6040                   sub_FFF10D65 sub     #4, sp   ; <<<< FUNC sub_FFF10D65
FFF10D67  6040                              sub     #4, sp
FFF10D69  3d00f0                            mov.w   #-10h, [sp]
FFF10D6C  fb4a4001                          mov.l   #140h, r4
FFF10D70  6602                              mov.l   #0, r2
FFF10D72  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10D78  ef23                              mov.l   r2, r3
FFF10D7A  0541ecfd                          bsr.a   sub_FFEEF9BB
FFF10D7E  6240                              add     #4, sp
FFF10D80  8089                              mov.b   r1, 4+var_1[sp]
FFF10D82  b089                              movu.b  4+var_1[sp], r1
FFF10D84  6111                              cmp     #1, r1
FFF10D86  1a                                bne.s   loc_FFF10D90
FFF10D87  391503                            bsr.w   sub_FFF1109C
FFF10D8A  05e5f5fd                          bsr.a   sub_FFEF036F
FFF10D8E  6701                              rtsd    #1
FFF10D90  6701                   loc_FFF10D90 rtsd    #1
FFF10D92  6040                   sub_FFF10D92 sub     #4, sp   ; <<<< FUNC sub_FFF10D92
FFF10D94  6040                              sub     #4, sp
FFF10D96  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF10D99  fb4a4001                          mov.l   #140h, r4
FFF10D9D  75431e                            mov.l   #1Eh, r3
FFF10DA0  6602                              mov.l   #0, r2
FFF10DA2  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10DA8  0513ecfd                          bsr.a   sub_FFEEF9BB
FFF10DAC  6240                              add     #4, sp
FFF10DAE  8089                              mov.b   r1, 4+var_1[sp]
FFF10DB0  b089                              movu.b  4+var_1[sp], r1
FFF10DB2  6111                              cmp     #1, r1
FFF10DB4  2123                              bne.b   loc_FFF10DD7
FFF10DB6  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10DBC  59e337                            movu.b  37h[r14], r3
FFF10DBF  6040                              sub     #4, sp
FFF10DC1  f80400                            mov.b   #0, 8+var_8[sp]
FFF10DC4  75421e                            mov.l   #1Eh, r2
FFF10DC7  6601                              mov.l   #0, r1
FFF10DC9  ef14                              mov.l   r1, r4
FFF10DCB  05a6efff                          bsr.a   sub_FFF0FD71
FFF10DCF  6240                              add     #4, sp
FFF10DD1  059ef5fd                          bsr.a   sub_FFEF036F
FFF10DD5  6701                              rtsd    #1
FFF10DD7  6701                   loc_FFF10DD7 rtsd    #1
FFF10DD9  6040                   sub_FFF10DD9 sub     #4, sp   ; <<<< FUNC sub_FFF10DD9
FFF10DDB  6040                              sub     #4, sp
FFF10DDD  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF10DE0  fb4a4001                          mov.l   #140h, r4
FFF10DE4  75433c                            mov.l   #3Ch, r3 ; '<'
FFF10DE7  6602                              mov.l   #0, r2
FFF10DE9  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10DEF  05ccebfd                          bsr.a   sub_FFEEF9BB
FFF10DF3  6240                              add     #4, sp
FFF10DF5  8089                              mov.b   r1, 4+var_1[sp]
FFF10DF7  b089                              movu.b  4+var_1[sp], r1
FFF10DF9  6111                              cmp     #1, r1
FFF10DFB  2123                              bne.b   loc_FFF10E1E
FFF10DFD  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10E03  59e337                            movu.b  37h[r14], r3
FFF10E06  6040                              sub     #4, sp
FFF10E08  f80401                            mov.b   #1, 8+var_8[sp]
FFF10E0B  6614                              mov.l   #1, r4
FFF10E0D  75423c                            mov.l   #3Ch, r2 ; '<'
FFF10E10  6601                              mov.l   #0, r1
FFF10E12  055fefff                          bsr.a   sub_FFF0FD71
FFF10E16  6240                              add     #4, sp
FFF10E18  0557f5fd                          bsr.a   sub_FFEF036F
FFF10E1C  6701                              rtsd    #1
FFF10E1E  6701                   loc_FFF10E1E rtsd    #1
FFF10E20  6040                   sub_FFF10E20 sub     #4, sp   ; <<<< FUNC sub_FFF10E20
FFF10E22  6040                              sub     #4, sp
FFF10E24  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF10E27  fb4a4001                          mov.l   #140h, r4
FFF10E2B  754378                            mov.l   #78h, r3 ; 'x'
FFF10E2E  6602                              mov.l   #0, r2
FFF10E30  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10E36  0585ebfd                          bsr.a   sub_FFEEF9BB
FFF10E3A  6240                              add     #4, sp
FFF10E3C  8089                              mov.b   r1, 4+var_1[sp]
FFF10E3E  b089                              movu.b  4+var_1[sp], r1
FFF10E40  6111                              cmp     #1, r1
FFF10E42  2123                              bne.b   loc_FFF10E65
FFF10E44  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10E4A  59e337                            movu.b  37h[r14], r3
FFF10E4D  6040                              sub     #4, sp
FFF10E4F  f80402                            mov.b   #2, 8+var_8[sp]
FFF10E52  6624                              mov.l   #2, r4
FFF10E54  754278                            mov.l   #78h, r2 ; 'x'
FFF10E57  6601                              mov.l   #0, r1
FFF10E59  0518efff                          bsr.a   sub_FFF0FD71
FFF10E5D  6240                              add     #4, sp
FFF10E5F  0510f5fd                          bsr.a   sub_FFEF036F
FFF10E63  6701                              rtsd    #1
FFF10E65  6701                   loc_FFF10E65 rtsd    #1
FFF10E67  6040                   sub_FFF10E67 sub     #4, sp   ; <<<< FUNC sub_FFF10E67
FFF10E69  6040                              sub     #4, sp
FFF10E6B  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF10E6E  fb4a4001                          mov.l   #140h, r4
FFF10E72  754396                            mov.l   #-6Ah, r3
FFF10E75  6602                              mov.l   #0, r2
FFF10E77  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF10E7D  053eebfd                          bsr.a   sub_FFEEF9BB
FFF10E81  6240                              add     #4, sp
FFF10E83  8089                              mov.b   r1, 4+var_1[sp]
FFF10E85  b089                              movu.b  4+var_1[sp], r1
FFF10E87  6111                              cmp     #1, r1
FFF10E89  2123                              bne.b   loc_FFF10EAC
FFF10E8B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10E91  59e337                            movu.b  37h[r14], r3
FFF10E94  6040                              sub     #4, sp
FFF10E96  f80403                            mov.b   #3, 8+var_8[sp]
FFF10E99  6634                              mov.l   #3, r4
FFF10E9B  754296                            mov.l   #-6Ah, r2
FFF10E9E  6601                              mov.l   #0, r1
FFF10EA0  05d1eeff                          bsr.a   sub_FFF0FD71
FFF10EA4  6240                              add     #4, sp
FFF10EA6  05c9f4fd                          bsr.a   sub_FFEF036F
FFF10EAA  6701                              rtsd    #1
FFF10EAC  6701                   loc_FFF10EAC rtsd    #1
FFF10EAE  66f1                   sub_FFF10EAE mov.l   #0Fh, r1   ; <<<< FUNC sub_FFF10EAE
FFF10EB0  054af0ff                          bsr.a   sub_FFF0FEFA
FFF10EB4  02                                rts
FFF10EB5  6040                   sub_FFF10EB5 sub     #4, sp   ; <<<< FUNC sub_FFF10EB5
FFF10EB7  0588f1fd                          bsr.a   sub_FFEF003F
FFF10EBB  fbe2738f0000                      mov.l   #8F73h, r14
FFF10EC1  c3e1                              mov.b   r1, [r14]
FFF10EC3  fbe2738f0000                      mov.l   #8F73h, r14
FFF10EC9  58ee                              movu.b  [r14], r14
FFF10ECB  755eff                            cmp     #-1, r14
FFF10ECE  1e                                bne.s   loc_FFF10ED4
FFF10ECF  6601                              mov.l   #0, r1
FFF10ED1  396a00                            bsr.w   sub_FFF10F3B
FFF10ED4  fbe2738f0000           loc_FFF10ED4 mov.l   #8F73h, r14
FFF10EDA  58ee                              movu.b  [r14], r14
FFF10EDC  755eff                            cmp     #-1, r14
FFF10EDF  2013                              beq.b   loc_FFF10EF2
FFF10EE1  fbe2738f0000                      mov.l   #8F73h, r14
FFF10EE7  58ee                              movu.b  [r14], r14
FFF10EE9  755e14                            cmp     #14h, r14
FFF10EEC  2406                              bgtu.b  loc_FFF10EF2
FFF10EEE  f80601                            mov.l   #1, 4+var_4[sp]
FFF10EF1  0c                                bra.s   loc_FFF10EF5
FFF10EF2  f80600                 loc_FFF10EF2 mov.l   #0, 4+var_4[sp]
FFF10EF5  ec01                   loc_FFF10EF5 mov.l   4+var_4[sp], r1
FFF10EF7  6101                              cmp     #0, r1
FFF10EF9  2029                              beq.b   loc_FFF10F22
FFF10EFB  0589ecfd                          bsr.a   sub_FFEEFB84
FFF10EFF  6101                              cmp     #0, r1
FFF10F01  2121                              bne.b   loc_FFF10F22
FFF10F03  fbe2738f0000                      mov.l   #8F73h, r14
FFF10F09  58e1                              movu.b  [r14], r1
FFF10F0B  05dff0fd                          bsr.a   sub_FFEEFFEA
FFF10F0F  fbe2738f0000                      mov.l   #8F73h, r14
FFF10F15  58ee                              movu.b  [r14], r14
FFF10F17  fbf2187cedff                      mov.l   #off_FFED7C18, r15
FFF10F1D  fe6efe                            mov.l   [r14, r15], r14
FFF10F20  7f1e                              jsr     r14
FFF10F22  fbe24c8c0000           loc_FFF10F22 mov.l   #8C4Ch, r14
FFF10F28  58ee                              movu.b  [r14], r14
FFF10F2A  614e                              cmp     #4, r14
FFF10F2C  290d                              blt.b   loc_FFF10F39
FFF10F2E  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF10F34  f8e403                            mov.b   #3, [r14]
FFF10F37  6701                              rtsd    #1
FFF10F39  6701                   loc_FFF10F39 rtsd    #1
FFF10F3B  6040                   sub_FFF10F3B sub     #4, sp   ; <<<< FUNC sub_FFF10F3B
FFF10F3D  8089                              mov.b   r1, 4+var_1[sp]
FFF10F3F  052a31fe                          bsr.a   sub_FFEF4069
FFF10F43  391400                            bsr.w   sub_FFF10F57
FFF10F46  057431fe                          bsr.a   sub_FFEF40BA
FFF10F4A  b089                              movu.b  4+var_1[sp], r1
FFF10F4C  6111                              cmp     #1, r1
FFF10F4E  1f                                bne.s   loc_FFF10F55
FFF10F4F  05ddf0fd                          bsr.a   sub_FFEF002C
FFF10F53  6701                              rtsd    #1
FFF10F55  6701                   loc_FFF10F55 rtsd    #1
FFF10F57  6040                   sub_FFF10F57 sub     #4, sp   ; <<<< FUNC sub_FFF10F57
FFF10F59  fb22468e0000                      mov.l   #8E46h, r2
FFF10F5F  712220                            add     #20h, r2, r2 ; ' '
FFF10F62  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF10F68  711120                            add     #20h, r1, r1 ; ' '
FFF10F6B  6614                              mov.l   #1, r4
FFF10F6D  754317                            mov.l   #17h, r3
FFF10F70  051d11fe                          bsr.a   sub_FFEF208D
FFF10F74  fbe2468e0000                      mov.l   #8E46h, r14
FFF10F7A  59ef37                            movu.b  37h[r14], r15
FFF10F7D  643f                              and     #3, r15
FFF10F7F  c7ef37                            mov.b   r15, 37h[r14]
FFF10F82  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10F88  59ee37                            movu.b  37h[r14], r14
FFF10F8B  fbf2468e0000                      mov.l   #8E46h, r15
FFF10F91  45fe37                            cmp     37h[r15], r14
FFF10F94  2037                              beq.b   loc_FFF10FCB
FFF10F96  fbe2468e0000                      mov.l   #8E46h, r14
FFF10F9C  59ee37                            movu.b  37h[r14], r14
FFF10F9F  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF10FA5  59ff37                            movu.b  37h[r15], r15
FFF10FA8  fb5e000002                        mov.l   #20000h, r5
FFF10FAD  ef51                              mov.l   r5, r1
FFF10FAF  fd62f1                            shll    r15, r1
FFF10FB2  fd62e5                            shll    r14, r5
FFF10FB5  5751                              or      r5, r1
FFF10FB7  05edeefd                          bsr.a   sub_FFEEFEA4
FFF10FBB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10FC1  fbf2468e0000                      mov.l   #8E46h, r15
FFF10FC7  c5fe3737                          mov.b   37h[r15], 37h[r14]
FFF10FCB  fb12468e0000           loc_FFF10FCB mov.l   #8E46h, r1
FFF10FD1  b499                              movu.b  13h[r1], r1
FFF10FD3  755120                            cmp     #20h, r1 ; ' '
FFF10FD6  212f                              bne.b   loc_FFF11005
FFF10FD8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10FDE  59ee38                            movu.b  38h[r14], r14
FFF10FE1  fbf2468e0000                      mov.l   #8E46h, r15
FFF10FE7  45fe38                            cmp     38h[r15], r14
FFF10FEA  201b                              beq.b   loc_FFF11005
FFF10FEC  fbe27a8d0000                      mov.l   #8D7Ah, r14
FFF10FF2  f8e401                            mov.b   #1, [r14]
FFF10FF5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF10FFB  fbf2468e0000                      mov.l   #8E46h, r15
FFF11001  c5fe3838                          mov.b   38h[r15], 38h[r14]
FFF11005  3c0300                 loc_FFF11005 mov.b   #0, 4+var_1[sp]
FFF11008  388500                            bra.w   loc_FFF1108D
FFF1100B  b089                   loc_FFF1100B movu.b  4+var_1[sp], r1
FFF1100D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11013  4b1e                              add     r1, r14
FFF11015  59ee39                            movu.b  39h[r14], r14
FFF11018  fbf2468e0000                      mov.l   #8E46h, r15
FFF1101E  4b1f                              add     r1, r15
FFF11020  45fe39                            cmp     39h[r15], r14
FFF11023  2026                              beq.b   loc_FFF11049
FFF11025  b08a                              movu.b  4+var_1[sp], r2
FFF11027  fb1e008000                        mov.l   #8000h, r1
FFF1102C  fd6221                            shll    r2, r1
FFF1102F  0575eefd                          bsr.a   sub_FFEEFEA4
FFF11033  b089                              movu.b  4+var_1[sp], r1
FFF11035  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1103B  4b1e                              add     r1, r14
FFF1103D  fbf2468e0000                      mov.l   #8E46h, r15
FFF11043  4b1f                              add     r1, r15
FFF11045  c5fe3939                          mov.b   39h[r15], 39h[r14]
FFF11049  b089                   loc_FFF11049 movu.b  4+var_1[sp], r1
FFF1104B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11051  4b1e                              add     r1, r14
FFF11053  59ee3b                            movu.b  3Bh[r14], r14
FFF11056  fbf2468e0000                      mov.l   #8E46h, r15
FFF1105C  4b1f                              add     r1, r15
FFF1105E  45fe3b                            cmp     3Bh[r15], r14
FFF11061  2026                              beq.b   loc_FFF11087
FFF11063  b08a                              movu.b  4+var_1[sp], r2
FFF11065  fb1e008000                        mov.l   #8000h, r1
FFF1106A  fd6221                            shll    r2, r1
FFF1106D  0537eefd                          bsr.a   sub_FFEEFEA4
FFF11071  b089                              movu.b  4+var_1[sp], r1
FFF11073  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11079  4b1e                              add     r1, r14
FFF1107B  fbf2468e0000                      mov.l   #8E46h, r15
FFF11081  4b1f                              add     r1, r15
FFF11083  c5fe3b3b                          mov.b   3Bh[r15], 3Bh[r14]
FFF11087  b089                   loc_FFF11087 movu.b  4+var_1[sp], r1
FFF11089  6211                              add     #1, r1
FFF1108B  8089                              mov.b   r1, 4+var_1[sp]
FFF1108D  b089                   loc_FFF1108D movu.b  4+var_1[sp], r1
FFF1108F  6121                              cmp     #2, r1
FFF11091  2805                              bge.b   loc_FFF11096
FFF11093  3878ff                            bra.w   loc_FFF1100B
FFF11096  05fef1fd               loc_FFF11096 bsr.a   sub_FFEF0294
FFF1109A  6701                              rtsd    #1
FFF1109C  6040                   sub_FFF1109C sub     #4, sp   ; <<<< FUNC sub_FFF1109C
FFF1109E  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF110A4  c5e03703                          mov.b   37h[r14], 4+var_1[sp]
FFF110A8  fbe2798d0000                      mov.l   #8D79h, r14
FFF110AE  f8e400                            mov.b   #0, [r14]
FFF110B1  6601                              mov.l   #0, r1
FFF110B3  ef12                              mov.l   r1, r2
FFF110B5  0553f3fd                          bsr.a   sub_FFEF0408
FFF110B9  b08b                              movu.b  4+var_1[sp], r3
FFF110BB  6040                              sub     #4, sp
FFF110BD  f80400                            mov.b   #0, 8+var_8[sp]
FFF110C0  75421e                            mov.l   #1Eh, r2
FFF110C3  6601                              mov.l   #0, r1
FFF110C5  ef14                              mov.l   r1, r4
FFF110C7  05aaecff                          bsr.a   sub_FFF0FD71
FFF110CB  6240                              add     #4, sp
FFF110CD  b08b                              movu.b  4+var_1[sp], r3
FFF110CF  6040                              sub     #4, sp
FFF110D1  f80401                            mov.b   #1, 8+var_8[sp]
FFF110D4  6614                              mov.l   #1, r4
FFF110D6  75423c                            mov.l   #3Ch, r2 ; '<'
FFF110D9  6601                              mov.l   #0, r1
FFF110DB  0596ecff                          bsr.a   sub_FFF0FD71
FFF110DF  6240                              add     #4, sp
FFF110E1  b08b                              movu.b  4+var_1[sp], r3
FFF110E3  6040                              sub     #4, sp
FFF110E5  f80402                            mov.b   #2, 8+var_8[sp]
FFF110E8  6624                              mov.l   #2, r4
FFF110EA  754278                            mov.l   #78h, r2 ; 'x'
FFF110ED  6601                              mov.l   #0, r1
FFF110EF  0582ecff                          bsr.a   sub_FFF0FD71
FFF110F3  6240                              add     #4, sp
FFF110F5  b08b                              movu.b  4+var_1[sp], r3
FFF110F7  6040                              sub     #4, sp
FFF110F9  f80403                            mov.b   #3, 8+var_8[sp]
FFF110FC  6634                              mov.l   #3, r4
FFF110FE  754296                            mov.l   #-6Ah, r2
FFF11101  6601                              mov.l   #0, r1
FFF11103  056eecff                          bsr.a   sub_FFF0FD71
FFF11107  6240                              add     #4, sp
FFF11109  6601                              mov.l   #0, r1
FFF1110B  05fa13fe                          bsr.a   sub_FFEF2505
FFF1110F  6611                              mov.l   #1, r1
FFF11111  05f413fe                          bsr.a   sub_FFEF2505
FFF11115  6701                              rtsd    #1
FFF11117  fbe24c8c0000           sub_FFF11117 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF11117
FFF1111D  58ee                              movu.b  [r14], r14
FFF1111F  613e                              cmp     #3, r14
FFF11121  2a16                              bgt.b   loc_FFF11137
FFF11123  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11129  58ee                              movu.b  [r14], r14
FFF1112B  fbf26c7cedff                      mov.l   #off_FFED7C6C, r15
FFF11131  fe6efe                            mov.l   [r14, r15], r14
FFF11134  7f1e                              jsr     r14
FFF11136  02                                rts
FFF11137  fbe24c8c0000           loc_FFF11137 mov.l   #8C4Ch, r14
FFF1113D  f8e403                            mov.b   #3, [r14]
FFF11140  02                                rts
FFF11141  6611                   sub_FFF11141 mov.l   #1, r1   ; <<<< FUNC sub_FFF11141
FFF11143  391202                            bsr.w   sub_FFF11355
FFF11146  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1114C  58ef                              movu.b  [r14], r15
FFF1114E  621f                              add     #1, r15
FFF11150  c3ef                              mov.b   r15, [r14]
FFF11152  02                                rts
FFF11153  6080                   sub_FFF11153 sub     #8, sp   ; <<<< FUNC sub_FFF11153
FFF11155  05d8f1fd                          bsr.a   sub_FFEF032D
FFF11159  05ee95fe                          bsr.a   sub_FFEFA747
FFF1115D  3d0302                            mov.w   #2, 8+var_2[sp]
FFF11160  3d0204                            mov.w   #4, 8+var_4[sp]
FFF11163  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11169  59ee3a                            movu.b  3Ah[r14], r14
FFF1116C  610e                              cmp     #0, r14
FFF1116E  9881                              mov.w   8+var_4[sp], r1
FFF11170  988b                              mov.w   8+var_2[sp], r3
FFF11172  2114                              bne.b   loc_FFF11186
FFF11174  5f12                              movu.w  r1, r2
FFF11176  5f31                              movu.w  r3, r1
FFF11178  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF1117E  6613                              mov.l   #1, r3
FFF11180  055557fe                          bsr.a   sub_FFEF68D5
FFF11184  2e16                              bra.b   loc_FFF1119A
FFF11186  5f1e                   loc_FFF11186 movu.w  r1, r14
FFF11188  621e                              add     #1, r14
FFF1118A  5fe2                              movu.w  r14, r2
FFF1118C  5f31                              movu.w  r3, r1
FFF1118E  fb425c20edff                      mov.l   #unk_FFED205C, r4
FFF11194  6613                              mov.l   #1, r3
FFF11196  053f57fe                          bsr.a   sub_FFEF68D5
FFF1119A  3d0330                 loc_FFF1119A mov.w   #30h, 8+var_2[sp] ; '0'
FFF1119D  3d0202                            mov.w   #2, 8+var_4[sp]
FFF111A0  b882                              movu.w  8+var_4[sp], r2
FFF111A2  b889                              movu.w  8+var_2[sp], r1
FFF111A4  60c0                              sub     #0Ch, sp
FFF111A6  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF111AC  713320                            add     #20h, r3, r3 ; ' '
FFF111AF  a00b                              mov.l   r3, 14h+var_10[sp]
FFF111B1  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF111B4  f80413                            mov.b   #13h, 14h+var_14[sp]
FFF111B7  6604                              mov.l   #0, r4
FFF111B9  66d3                              mov.l   #0Dh, r3
FFF111BB  056809fe                          bsr.a   sub_FFEF1B23
FFF111BF  62c0                              add     #0Ch, sp
FFF111C1  3d0332                            mov.w   #32h, 8+var_2[sp] ; '2'
FFF111C4  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF111C7  fb12647aedff                      mov.l   #off_FFED7A64, r1
FFF111CD  a914                              mov.l   10h[r1], r4
FFF111CF  b882                              movu.w  8+var_4[sp], r2
FFF111D1  b889                              movu.w  8+var_2[sp], r1
FFF111D3  6242                              add     #4, r2
FFF111D5  5f22                              movu.w  r2, r2
FFF111D7  6613                              mov.l   #1, r3
FFF111D9  05fc56fe                          bsr.a   sub_FFEF68D5
FFF111DD  3d035a                            mov.w   #5Ah, 8+var_2[sp] ; 'Z'
FFF111E0  b882                              movu.w  8+var_4[sp], r2
FFF111E2  b889                              movu.w  8+var_2[sp], r1
FFF111E4  60c0                              sub     #0Ch, sp
FFF111E6  fb32647aedff                      mov.l   #off_FFED7A64, r3
FFF111EC  713314                            add     #14h, r3, r3
FFF111EF  a00b                              mov.l   r3, 14h+var_10[sp]
FFF111F1  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF111F4  f8040c                            mov.b   #0Ch, 14h+var_14[sp]
FFF111F7  6222                              add     #2, r2
FFF111F9  5f22                              movu.w  r2, r2
FFF111FB  6604                              mov.l   #0, r4
FFF111FD  66d3                              mov.l   #0Dh, r3
FFF111FF  052409fe                          bsr.a   sub_FFEF1B23
FFF11203  62c0                              add     #0Ch, sp
FFF11205  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF11208  3c0300                            mov.b   #0, 8+var_5[sp]
FFF1120B  2e17                              bra.b   loc_FFF11222
FFF1120D  b881                   loc_FFF1120D movu.w  8+var_4[sp], r1
FFF1120F  6602                              mov.l   #0, r2
FFF11211  055dedff                          bsr.a   sub_FFF0FF6E
FFF11215  b881                              movu.w  8+var_4[sp], r1
FFF11217  71111e                            add     #1Eh, r1, r1
FFF1121A  9081                              mov.w   r1, 8+var_4[sp]
FFF1121C  b089                              movu.b  8+var_5[sp], r1
FFF1121E  6211                              add     #1, r1
FFF11220  8089                              mov.b   r1, 8+var_5[sp]
FFF11222  b089                   loc_FFF11222 movu.b  8+var_5[sp], r1
FFF11224  6151                              cmp     #5, r1
FFF11226  29e7                              blt.b   loc_FFF1120D
FFF11228  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1122E  58ef                              movu.b  [r14], r15
FFF11230  621f                              add     #1, r15
FFF11232  c3ef                              mov.b   r15, [r14]
FFF11234  6702                              rtsd    #2
FFF11236  6040                   sub_FFF11236 sub     #4, sp   ; <<<< FUNC sub_FFF11236
FFF11238  6040                              sub     #4, sp
FFF1123A  3d00f0                            mov.w   #-10h, [sp]
FFF1123D  fb4a4001                          mov.l   #140h, r4
FFF11241  6602                              mov.l   #0, r2
FFF11243  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11249  ef23                              mov.l   r2, r3
FFF1124B  0570e7fd                          bsr.a   sub_FFEEF9BB
FFF1124F  6240                              add     #4, sp
FFF11251  8089                              mov.b   r1, 4+var_1[sp]
FFF11253  b089                              movu.b  4+var_1[sp], r1
FFF11255  6111                              cmp     #1, r1
FFF11257  1a                                bne.s   loc_FFF11261
FFF11258  390402                            bsr.w   sub_FFF1145C
FFF1125B  0514f1fd                          bsr.a   sub_FFEF036F
FFF1125F  6701                              rtsd    #1
FFF11261  6701                   loc_FFF11261 rtsd    #1
FFF11263  6040                   sub_FFF11263 sub     #4, sp   ; <<<< FUNC sub_FFF11263
FFF11265  6040                              sub     #4, sp
FFF11267  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF1126A  fb4a4001                          mov.l   #140h, r4
FFF1126E  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF11271  6602                              mov.l   #0, r2
FFF11273  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11279  0542e7fd                          bsr.a   sub_FFEEF9BB
FFF1127D  6240                              add     #4, sp
FFF1127F  8089                              mov.b   r1, 4+var_1[sp]
FFF11281  b089                              movu.b  4+var_1[sp], r1
FFF11283  6111                              cmp     #1, r1
FFF11285  2112                              bne.b   loc_FFF11297
FFF11287  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF1128A  6601                              mov.l   #0, r1
FFF1128C  ef13                              mov.l   r1, r3
FFF1128E  39f401                            bsr.w   sub_FFF11482
FFF11291  05def0fd                          bsr.a   sub_FFEF036F
FFF11295  6701                              rtsd    #1
FFF11297  6701                   loc_FFF11297 rtsd    #1
FFF11299  6040                   sub_FFF11299 sub     #4, sp   ; <<<< FUNC sub_FFF11299
FFF1129B  6040                              sub     #4, sp
FFF1129D  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF112A0  fb4a4001                          mov.l   #140h, r4
FFF112A4  754378                            mov.l   #78h, r3 ; 'x'
FFF112A7  6602                              mov.l   #0, r2
FFF112A9  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF112AF  050ce7fd                          bsr.a   sub_FFEEF9BB
FFF112B3  6240                              add     #4, sp
FFF112B5  8089                              mov.b   r1, 4+var_1[sp]
FFF112B7  b089                              movu.b  4+var_1[sp], r1
FFF112B9  6111                              cmp     #1, r1
FFF112BB  2112                              bne.b   loc_FFF112CD
FFF112BD  6613                              mov.l   #1, r3
FFF112BF  754278                            mov.l   #78h, r2 ; 'x'
FFF112C2  6601                              mov.l   #0, r1
FFF112C4  39be01                            bsr.w   sub_FFF11482
FFF112C7  05a8f0fd                          bsr.a   sub_FFEF036F
FFF112CB  6701                              rtsd    #1
FFF112CD  6701                   loc_FFF112CD rtsd    #1
FFF112CF  6040                   sub_FFF112CF sub     #4, sp   ; <<<< FUNC sub_FFF112CF
FFF112D1  056eedfd                          bsr.a   sub_FFEF003F
FFF112D5  fbe2738f0000                      mov.l   #8F73h, r14
FFF112DB  c3e1                              mov.b   r1, [r14]
FFF112DD  fbe2738f0000                      mov.l   #8F73h, r14
FFF112E3  58ee                              movu.b  [r14], r14
FFF112E5  755eff                            cmp     #-1, r14
FFF112E8  1e                                bne.s   loc_FFF112EE
FFF112E9  6601                              mov.l   #0, r1
FFF112EB  396a00                            bsr.w   sub_FFF11355
FFF112EE  fbe2738f0000           loc_FFF112EE mov.l   #8F73h, r14
FFF112F4  58ee                              movu.b  [r14], r14
FFF112F6  755eff                            cmp     #-1, r14
FFF112F9  2013                              beq.b   loc_FFF1130C
FFF112FB  fbe2738f0000                      mov.l   #8F73h, r14
FFF11301  58ee                              movu.b  [r14], r14
FFF11303  755e10                            cmp     #10h, r14
FFF11306  2406                              bgtu.b  loc_FFF1130C
FFF11308  f80601                            mov.l   #1, 4+var_4[sp]
FFF1130B  0c                                bra.s   loc_FFF1130F
FFF1130C  f80600                 loc_FFF1130C mov.l   #0, 4+var_4[sp]
FFF1130F  ec01                   loc_FFF1130F mov.l   4+var_4[sp], r1
FFF11311  6101                              cmp     #0, r1
FFF11313  2029                              beq.b   loc_FFF1133C
FFF11315  056fe8fd                          bsr.a   sub_FFEEFB84
FFF11319  6101                              cmp     #0, r1
FFF1131B  2121                              bne.b   loc_FFF1133C
FFF1131D  fbe2738f0000                      mov.l   #8F73h, r14
FFF11323  58e1                              movu.b  [r14], r1
FFF11325  05c5ecfd                          bsr.a   sub_FFEEFFEA
FFF11329  fbe2738f0000                      mov.l   #8F73h, r14
FFF1132F  58ee                              movu.b  [r14], r14
FFF11331  fbf27c7cedff                      mov.l   #off_FFED7C7C, r15
FFF11337  fe6efe                            mov.l   [r14, r15], r14
FFF1133A  7f1e                              jsr     r14
FFF1133C  fbe24c8c0000           loc_FFF1133C mov.l   #8C4Ch, r14
FFF11342  58ee                              movu.b  [r14], r14
FFF11344  614e                              cmp     #4, r14
FFF11346  290d                              blt.b   loc_FFF11353
FFF11348  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1134E  f8e403                            mov.b   #3, [r14]
FFF11351  6701                              rtsd    #1
FFF11353  6701                   loc_FFF11353 rtsd    #1
FFF11355  6040                   sub_FFF11355 sub     #4, sp   ; <<<< FUNC sub_FFF11355
FFF11357  8089                              mov.b   r1, 4+var_1[sp]
FFF11359  05102dfe                          bsr.a   sub_FFEF4069
FFF1135D  391400                            bsr.w   sub_FFF11371
FFF11360  055a2dfe                          bsr.a   sub_FFEF40BA
FFF11364  b089                              movu.b  4+var_1[sp], r1
FFF11366  6111                              cmp     #1, r1
FFF11368  1f                                bne.s   loc_FFF1136F
FFF11369  05c3ecfd                          bsr.a   sub_FFEF002C
FFF1136D  6701                              rtsd    #1
FFF1136F  6701                   loc_FFF1136F rtsd    #1
FFF11371  fb22468e0000           sub_FFF11371 mov.l   #8E46h, r2   ; <<<< FUNC sub_FFF11371
FFF11377  71223a                            add     #3Ah, r2, r2 ; ':'
FFF1137A  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF11380  71113a                            add     #3Ah, r1, r1 ; ':'
FFF11383  6613                              mov.l   #1, r3
FFF11385  ef34                              mov.l   r3, r4
FFF11387  05060dfe                          bsr.a   sub_FFEF208D
FFF1138B  fb22468e0000                      mov.l   #8E46h, r2
FFF11391  712220                            add     #20h, r2, r2 ; ' '
FFF11394  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF1139A  711120                            add     #20h, r1, r1 ; ' '
FFF1139D  6614                              mov.l   #1, r4
FFF1139F  754317                            mov.l   #17h, r3
FFF113A2  05eb0cfe                          bsr.a   sub_FFEF208D
FFF113A6  fbe2468e0000                      mov.l   #8E46h, r14
FFF113AC  59ef37                            movu.b  37h[r14], r15
FFF113AF  641f                              and     #1, r15
FFF113B1  c7ef37                            mov.b   r15, 37h[r14]
FFF113B4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF113BA  59ee37                            movu.b  37h[r14], r14
FFF113BD  fbf2468e0000                      mov.l   #8E46h, r15
FFF113C3  45fe37                            cmp     37h[r15], r14
FFF113C6  2037                              beq.b   loc_FFF113FD
FFF113C8  fbe2468e0000                      mov.l   #8E46h, r14
FFF113CE  59ee37                            movu.b  37h[r14], r14
FFF113D1  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF113D7  59ff37                            movu.b  37h[r15], r15
FFF113DA  fb5e008000                        mov.l   #8000h, r5
FFF113DF  ef51                              mov.l   r5, r1
FFF113E1  fd62f1                            shll    r15, r1
FFF113E4  fd62e5                            shll    r14, r5
FFF113E7  5751                              or      r5, r1
FFF113E9  05bbeafd                          bsr.a   sub_FFEEFEA4
FFF113ED  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF113F3  fbf2468e0000                      mov.l   #8E46h, r15
FFF113F9  c5fe3737                          mov.b   37h[r15], 37h[r14]
FFF113FD  fbe24d8c0000           loc_FFF113FD mov.l   #8C4Dh, r14
FFF11403  59ee38                            movu.b  38h[r14], r14
FFF11406  fbf2468e0000                      mov.l   #8E46h, r15
FFF1140C  45fe38                            cmp     38h[r15], r14
FFF1140F  201b                              beq.b   loc_FFF1142A
FFF11411  fb1e008000                        mov.l   #8000h, r1
FFF11416  058eeafd                          bsr.a   sub_FFEEFEA4
FFF1141A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11420  fbf2468e0000                      mov.l   #8E46h, r15
FFF11426  c5fe3838                          mov.b   38h[r15], 38h[r14]
FFF1142A  fbe24d8c0000           loc_FFF1142A mov.l   #8C4Dh, r14
FFF11430  59ee39                            movu.b  39h[r14], r14
FFF11433  fbf2468e0000                      mov.l   #8E46h, r15
FFF11439  45fe39                            cmp     39h[r15], r14
FFF1143C  201b                              beq.b   loc_FFF11457
FFF1143E  fb1e000001                        mov.l   #10000h, r1
FFF11443  0561eafd                          bsr.a   sub_FFEEFEA4
FFF11447  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1144D  fbf2468e0000                      mov.l   #8E46h, r15
FFF11453  c5fe3939                          mov.b   39h[r15], 39h[r14]
FFF11457  053deefd               loc_FFF11457 bsr.a   sub_FFEF0294
FFF1145B  02                                rts
FFF1145C  fbe2798d0000           sub_FFF1145C mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF1145C
FFF11462  f8e400                            mov.b   #0, [r14]
FFF11465  6601                              mov.l   #0, r1
FFF11467  ef12                              mov.l   r1, r2
FFF11469  059feffd                          bsr.a   sub_FFEF0408
FFF1146D  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF11470  6601                              mov.l   #0, r1
FFF11472  ef13                              mov.l   r1, r3
FFF11474  390e00                            bsr.w   sub_FFF11482
FFF11477  6613                              mov.l   #1, r3
FFF11479  754278                            mov.l   #78h, r2 ; 'x'
FFF1147C  6601                              mov.l   #0, r1
FFF1147E  390400                            bsr.w   sub_FFF11482
FFF11481  02                                rts
FFF11482  7100f0                 sub_FFF11482 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF11482
FFF11485  9189                              mov.w   r1, 10h+var_2[sp]
FFF11487  9182                              mov.w   r2, 10h+var_4[sp]
FFF11489  828b                              mov.b   r3, 10h+var_5[sp]
FFF1148B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11491  c5e03703                          mov.b   37h[r14], 10h+var_D[sp]
FFF11495  b981                              movu.w  10h+var_4[sp], r1
FFF11497  6211                              add     #1, r1
FFF11499  5f12                              movu.w  r1, r2
FFF1149B  75441d                            mov.l   #1Dh, r4
FFF1149E  fb3a4001                          mov.l   #140h, r3
FFF114A2  6601                              mov.l   #0, r1
FFF114A4  0553f0fd                          bsr.a   sub_FFEF04F7
FFF114A8  b089                              movu.b  10h+var_D[sp], r1
FFF114AA  45010b                            cmp     10h+var_5[sp], r1
FFF114AD  211d                              bne.b   loc_FFF114CA
FFF114AF  b981                              movu.w  10h+var_4[sp], r1
FFF114B1  6040                              sub     #4, sp
FFF114B3  f80980f9                          mov.w   #-680h, 14h+var_14[sp]
FFF114B7  6221                              add     #2, r1
FFF114B9  5f12                              movu.w  r1, r2
FFF114BB  75441c                            mov.l   #1Ch, r4
FFF114BE  fb3a3401                          mov.l   #134h, r3
FFF114C2  6661                              mov.l   #6, r1
FFF114C4  058407fe                          bsr.a   sub_FFEF1C48
FFF114C8  6240                              add     #4, sp
FFF114CA  b289                   loc_FFF114CA movu.b  10h+var_5[sp], r1
FFF114CC  6101                              cmp     #0, r1
FFF114CE  2126                              bne.b   loc_FFF114F4
FFF114D0  3c0200                            mov.b   #0, 10h+var_E[sp]
FFF114D3  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF114D9  59ee38                            movu.b  38h[r14], r14
FFF114DC  610e                              cmp     #0, r14
FFF114DE  210c                              bne.b   loc_FFF114EA
FFF114E0  fb120c34edff                      mov.l   #unk_FFED340C, r1
FFF114E6  a009                              mov.l   r1, 10h+var_C[sp]
FFF114E8  2e2c                              bra.b   loc_FFF11514
FFF114EA  fb12bc2dedff           loc_FFF114EA mov.l   #unk_FFED2DBC, r1
FFF114F0  a009                              mov.l   r1, 10h+var_C[sp]
FFF114F2  2e22                              bra.b   loc_FFF11514
FFF114F4  3c0201                 loc_FFF114F4 mov.b   #1, 10h+var_E[sp]
FFF114F7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF114FD  59ee39                            movu.b  39h[r14], r14
FFF11500  610e                              cmp     #0, r14
FFF11502  1a                                bne.s   loc_FFF1150C
FFF11503  fb12ec33edff                      mov.l   #unk_FFED33EC, r1
FFF11509  a009                              mov.l   r1, 10h+var_C[sp]
FFF1150B  09                                bra.s   loc_FFF11514
FFF1150C  fb128c2dedff           loc_FFF1150C mov.l   #unk_FFED2D8C, r1
FFF11512  a009                              mov.l   r1, 10h+var_C[sp]
FFF11514  3d0732                 loc_FFF11514 mov.w   #32h, 10h+var_2[sp] ; '2'
FFF11517  a80c                              mov.l   10h+var_C[sp], r4
FFF11519  b982                              movu.w  10h+var_4[sp], r2
FFF1151B  b989                              movu.w  10h+var_2[sp], r1
FFF1151D  6242                              add     #4, r2
FFF1151F  5f22                              movu.w  r2, r2
FFF11521  6613                              mov.l   #1, r3
FFF11523  05b253fe                          bsr.a   sub_FFEF68D5
FFF11527  3d075a                            mov.w   #5Ah, 10h+var_2[sp] ; 'Z'
FFF1152A  b082                              movu.b  10h+var_E[sp], r2
FFF1152C  b983                              movu.w  10h+var_4[sp], r3
FFF1152E  b989                              movu.w  10h+var_2[sp], r1
FFF11530  60c0                              sub     #0Ch, sp
FFF11532  6392                              mul     #9, r2
FFF11534  fb427ce8c3ff                      mov.l   #aUpload, r4; "UPLOAD  "
FFF1153A  4b24                              add     r2, r4
FFF1153C  a00c                              mov.l   r4, 1Ch+var_18[sp]
FFF1153E  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF11541  f80408                            mov.b   #8, 1Ch+var_1C[sp]
FFF11544  6223                              add     #2, r3
FFF11546  5f32                              movu.w  r3, r2
FFF11548  6604                              mov.l   #0, r4
FFF1154A  66d3                              mov.l   #0Dh, r3
FFF1154C  05d705fe                          bsr.a   sub_FFEF1B23
FFF11550  62c0                              add     #0Ch, sp
FFF11552  6704                              rtsd    #4
FFF11554  fbe24c8c0000           sub_FFF11554 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF11554
FFF1155A  58ee                              movu.b  [r14], r14
FFF1155C  613e                              cmp     #3, r14
FFF1155E  2a16                              bgt.b   loc_FFF11574
FFF11560  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11566  58ee                              movu.b  [r14], r14
FFF11568  fbf2c07cedff                      mov.l   #off_FFED7CC0, r15
FFF1156E  fe6efe                            mov.l   [r14, r15], r14
FFF11571  7f1e                              jsr     r14
FFF11573  02                                rts
FFF11574  fbe24c8c0000           loc_FFF11574 mov.l   #8C4Ch, r14
FFF1157A  f8e403                            mov.b   #3, [r14]
FFF1157D  02                                rts
FFF1157E  6611                   sub_FFF1157E mov.l   #1, r1   ; <<<< FUNC sub_FFF1157E
FFF11580  39db02                            bsr.w   sub_FFF1185B
FFF11583  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11589  58ef                              movu.b  [r14], r15
FFF1158B  621f                              add     #1, r15
FFF1158D  c3ef                              mov.b   r15, [r14]
FFF1158F  02                                rts
FFF11590  6080                   sub_FFF11590 sub     #8, sp   ; <<<< FUNC sub_FFF11590
FFF11592  059bedfd                          bsr.a   sub_FFEF032D
FFF11596  05c891fe                          bsr.a   sub_FFEFA75E
FFF1159A  3d0206                            mov.w   #6, 8+var_4[sp]
FFF1159D  3d0100                            mov.w   #0, 8+var_6[sp]
FFF115A0  3d034c                            mov.w   #4Ch, 8+var_2[sp] ; 'L'
FFF115A3  3c0100                            mov.b   #0, 8+var_7[sp]
FFF115A6  2e51                              bra.b   loc_FFF115F7
FFF115A8  fbe284930600           loc_FFF115A8 mov.l   #69384h, r14
FFF115AE  b009                              movu.b  8+var_7[sp], r1
FFF115B0  fe61e4                            mov.l   [r1, r14], r4
FFF115B3  b882                              movu.w  8+var_4[sp], r2
FFF115B5  b889                              movu.w  8+var_2[sp], r1
FFF115B7  6613                              mov.l   #1, r3
FFF115B9  051c53fe                          bsr.a   sub_FFEF68D5
FFF115BD  fbe284930600                      mov.l   #69384h, r14
FFF115C3  b009                              movu.b  8+var_7[sp], r1
FFF115C5  fe61ee                            mov.l   [r1, r14], r14
FFF115C8  5ce1                              movu.w  [r14], r1
FFF115CA  06c90101                          add     8+var_6[sp].uw, r1
FFF115CE  06c90103                          add     8+var_2[sp].uw, r1
FFF115D2  9089                              mov.w   r1, 8+var_2[sp]
FFF115D4  b009                              movu.b  8+var_7[sp], r1
FFF115D6  6141                              cmp     #4, r1
FFF115D8  2119                              bne.b   loc_FFF115F1
FFF115DA  fbe284930600                      mov.l   #69384h, r14
FFF115E0  b009                              movu.b  8+var_7[sp], r1
FFF115E2  fe61ee                            mov.l   [r1, r14], r14
FFF115E5  5ce1                              movu.w  [r14], r1
FFF115E7  06c90101                          add     8+var_6[sp].uw, r1
FFF115EB  06c90103                          add     8+var_2[sp].uw, r1
FFF115EF  9089                              mov.w   r1, 8+var_2[sp]
FFF115F1  b009                   loc_FFF115F1 movu.b  8+var_7[sp], r1
FFF115F3  6211                              add     #1, r1
FFF115F5  8009                              mov.b   r1, 8+var_7[sp]
FFF115F7  b009                   loc_FFF115F7 movu.b  8+var_7[sp], r1
FFF115F9  61d1                              cmp     #0Dh, r1
FFF115FB  29ad                              blt.b   loc_FFF115A8
FFF115FD  3d023c                            mov.w   #3Ch, 8+var_4[sp] ; '<'
FFF11600  3c0100                            mov.b   #0, 8+var_7[sp]
FFF11603  2e17                              bra.b   loc_FFF1161A
FFF11605  b881                   loc_FFF11605 movu.w  8+var_4[sp], r1
FFF11607  6602                              mov.l   #0, r2
FFF11609  0565e9ff                          bsr.a   sub_FFF0FF6E
FFF1160D  b881                              movu.w  8+var_4[sp], r1
FFF1160F  71111e                            add     #1Eh, r1, r1
FFF11612  9081                              mov.w   r1, 8+var_4[sp]
FFF11614  b009                              movu.b  8+var_7[sp], r1
FFF11616  6211                              add     #1, r1
FFF11618  8009                              mov.b   r1, 8+var_7[sp]
FFF1161A  b009                   loc_FFF1161A movu.b  8+var_7[sp], r1
FFF1161C  6141                              cmp     #4, r1
FFF1161E  29e7                              blt.b   loc_FFF11605
FFF11620  6661                              mov.l   #6, r1
FFF11622  056d88fe                          bsr.a   sub_FFEF9E8F
FFF11626  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1162C  58ef                              movu.b  [r14], r15
FFF1162E  621f                              add     #1, r15
FFF11630  c3ef                              mov.b   r15, [r14]
FFF11632  6702                              rtsd    #2
FFF11634  6040                   sub_FFF11634 sub     #4, sp   ; <<<< FUNC sub_FFF11634
FFF11636  6040                              sub     #4, sp
FFF11638  3d00f0                            mov.w   #-10h, [sp]
FFF1163B  fb4a4001                          mov.l   #140h, r4
FFF1163F  6602                              mov.l   #0, r2
FFF11641  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11647  ef23                              mov.l   r2, r3
FFF11649  0572e3fd                          bsr.a   sub_FFEEF9BB
FFF1164D  6240                              add     #4, sp
FFF1164F  8089                              mov.b   r1, 4+var_1[sp]
FFF11651  b089                              movu.b  4+var_1[sp], r1
FFF11653  6111                              cmp     #1, r1
FFF11655  1a                                bne.s   loc_FFF1165F
FFF11656  395303                            bsr.w   sub_FFF119A9
FFF11659  0516edfd                          bsr.a   sub_FFEF036F
FFF1165D  6701                              rtsd    #1
FFF1165F  6701                   loc_FFF1165F rtsd    #1
FFF11661  6040                   sub_FFF11661 sub     #4, sp   ; <<<< FUNC sub_FFF11661
FFF11663  6040                              sub     #4, sp
FFF11665  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF11668  fb4a4001                          mov.l   #140h, r4
FFF1166C  75431e                            mov.l   #1Eh, r3
FFF1166F  6602                              mov.l   #0, r2
FFF11671  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11677  0544e3fd                          bsr.a   sub_FFEEF9BB
FFF1167B  6240                              add     #4, sp
FFF1167D  8089                              mov.b   r1, 4+var_1[sp]
FFF1167F  b089                              movu.b  4+var_1[sp], r1
FFF11681  6111                              cmp     #1, r1
FFF11683  2125                              bne.b   loc_FFF116A8
FFF11685  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1168B  59e320                            movu.b  20h[r14], r3
FFF1168E  6040                              sub     #4, sp
FFF11690  71ee21                            add     #21h, r14, r14 ; '!'
FFF11693  e30e                              mov.l   r14, 8+var_8[sp]
FFF11695  75421e                            mov.l   #1Eh, r2
FFF11698  6601                              mov.l   #0, r1
FFF1169A  ef14                              mov.l   r1, r4
FFF1169C  05c1e7ff                          bsr.a   sub_FFF0FE5D
FFF116A0  6240                              add     #4, sp
FFF116A2  05cdecfd                          bsr.a   sub_FFEF036F
FFF116A6  6701                              rtsd    #1
FFF116A8  6701                   loc_FFF116A8 rtsd    #1
FFF116AA  6040                   sub_FFF116AA sub     #4, sp   ; <<<< FUNC sub_FFF116AA
FFF116AC  6040                              sub     #4, sp
FFF116AE  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF116B1  fb4a4001                          mov.l   #140h, r4
FFF116B5  75433c                            mov.l   #3Ch, r3 ; '<'
FFF116B8  6602                              mov.l   #0, r2
FFF116BA  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF116C0  05fbe2fd                          bsr.a   sub_FFEEF9BB
FFF116C4  6240                              add     #4, sp
FFF116C6  8089                              mov.b   r1, 4+var_1[sp]
FFF116C8  b089                              movu.b  4+var_1[sp], r1
FFF116CA  6111                              cmp     #1, r1
FFF116CC  2125                              bne.b   loc_FFF116F1
FFF116CE  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF116D4  59e320                            movu.b  20h[r14], r3
FFF116D7  6040                              sub     #4, sp
FFF116D9  71ee31                            add     #31h, r14, r14 ; '1'
FFF116DC  e30e                              mov.l   r14, 8+var_8[sp]
FFF116DE  6614                              mov.l   #1, r4
FFF116E0  75423c                            mov.l   #3Ch, r2 ; '<'
FFF116E3  6601                              mov.l   #0, r1
FFF116E5  0578e7ff                          bsr.a   sub_FFF0FE5D
FFF116E9  6240                              add     #4, sp
FFF116EB  0584ecfd                          bsr.a   sub_FFEF036F
FFF116EF  6701                              rtsd    #1
FFF116F1  6701                   loc_FFF116F1 rtsd    #1
FFF116F3  6040                   sub_FFF116F3 sub     #4, sp   ; <<<< FUNC sub_FFF116F3
FFF116F5  6040                              sub     #4, sp
FFF116F7  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF116FA  fb4a4001                          mov.l   #140h, r4
FFF116FE  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF11701  6602                              mov.l   #0, r2
FFF11703  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11709  05b2e2fd                          bsr.a   sub_FFEEF9BB
FFF1170D  6240                              add     #4, sp
FFF1170F  8089                              mov.b   r1, 4+var_1[sp]
FFF11711  b089                              movu.b  4+var_1[sp], r1
FFF11713  6111                              cmp     #1, r1
FFF11715  2125                              bne.b   loc_FFF1173A
FFF11717  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1171D  59e320                            movu.b  20h[r14], r3
FFF11720  6040                              sub     #4, sp
FFF11722  71ee41                            add     #41h, r14, r14 ; 'A'
FFF11725  e30e                              mov.l   r14, 8+var_8[sp]
FFF11727  6624                              mov.l   #2, r4
FFF11729  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF1172C  6601                              mov.l   #0, r1
FFF1172E  052fe7ff                          bsr.a   sub_FFF0FE5D
FFF11732  6240                              add     #4, sp
FFF11734  053becfd                          bsr.a   sub_FFEF036F
FFF11738  6701                              rtsd    #1
FFF1173A  6701                   loc_FFF1173A rtsd    #1
FFF1173C  6040                   sub_FFF1173C sub     #4, sp   ; <<<< FUNC sub_FFF1173C
FFF1173E  6040                              sub     #4, sp
FFF11740  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF11743  fb4a4001                          mov.l   #140h, r4
FFF11747  754378                            mov.l   #78h, r3 ; 'x'
FFF1174A  6602                              mov.l   #0, r2
FFF1174C  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11752  0569e2fd                          bsr.a   sub_FFEEF9BB
FFF11756  6240                              add     #4, sp
FFF11758  8089                              mov.b   r1, 4+var_1[sp]
FFF1175A  b089                              movu.b  4+var_1[sp], r1
FFF1175C  6111                              cmp     #1, r1
FFF1175E  2125                              bne.b   loc_FFF11783
FFF11760  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11766  59e320                            movu.b  20h[r14], r3
FFF11769  6040                              sub     #4, sp
FFF1176B  71ee51                            add     #51h, r14, r14 ; 'Q'
FFF1176E  e30e                              mov.l   r14, 8+var_8[sp]
FFF11770  6634                              mov.l   #3, r4
FFF11772  754278                            mov.l   #78h, r2 ; 'x'
FFF11775  6601                              mov.l   #0, r1
FFF11777  05e6e6ff                          bsr.a   sub_FFF0FE5D
FFF1177B  6240                              add     #4, sp
FFF1177D  05f2ebfd                          bsr.a   sub_FFEF036F
FFF11781  6701                              rtsd    #1
FFF11783  6701                   loc_FFF11783 rtsd    #1
FFF11785  6040                   sub_FFF11785 sub     #4, sp   ; <<<< FUNC sub_FFF11785
FFF11787  6040                              sub     #4, sp
FFF11789  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF1178C  fb4a4001                          mov.l   #140h, r4
FFF11790  754396                            mov.l   #-6Ah, r3
FFF11793  6602                              mov.l   #0, r2
FFF11795  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF1179B  0520e2fd                          bsr.a   sub_FFEEF9BB
FFF1179F  6240                              add     #4, sp
FFF117A1  8089                              mov.b   r1, 4+var_1[sp]
FFF117A3  b089                              movu.b  4+var_1[sp], r1
FFF117A5  6111                              cmp     #1, r1
FFF117A7  2125                              bne.b   loc_FFF117CC
FFF117A9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF117AF  59e320                            movu.b  20h[r14], r3
FFF117B2  6040                              sub     #4, sp
FFF117B4  71ee61                            add     #61h, r14, r14 ; 'a'
FFF117B7  e30e                              mov.l   r14, 8+var_8[sp]
FFF117B9  6644                              mov.l   #4, r4
FFF117BB  754296                            mov.l   #-6Ah, r2
FFF117BE  6601                              mov.l   #0, r1
FFF117C0  059de6ff                          bsr.a   sub_FFF0FE5D
FFF117C4  6240                              add     #4, sp
FFF117C6  05a9ebfd                          bsr.a   sub_FFEF036F
FFF117CA  6701                              rtsd    #1
FFF117CC  6701                   loc_FFF117CC rtsd    #1
FFF117CE  66f1                   sub_FFF117CE mov.l   #0Fh, r1   ; <<<< FUNC sub_FFF117CE
FFF117D0  052ae7ff                          bsr.a   sub_FFF0FEFA
FFF117D4  02                                rts
FFF117D5  6040                   sub_FFF117D5 sub     #4, sp   ; <<<< FUNC sub_FFF117D5
FFF117D7  0568e8fd                          bsr.a   sub_FFEF003F
FFF117DB  fbe2738f0000                      mov.l   #8F73h, r14
FFF117E1  c3e1                              mov.b   r1, [r14]
FFF117E3  fbe2738f0000                      mov.l   #8F73h, r14
FFF117E9  58ee                              movu.b  [r14], r14
FFF117EB  755eff                            cmp     #-1, r14
FFF117EE  1e                                bne.s   loc_FFF117F4
FFF117EF  6601                              mov.l   #0, r1
FFF117F1  396a00                            bsr.w   sub_FFF1185B
FFF117F4  fbe2738f0000           loc_FFF117F4 mov.l   #8F73h, r14
FFF117FA  58ee                              movu.b  [r14], r14
FFF117FC  755eff                            cmp     #-1, r14
FFF117FF  2013                              beq.b   loc_FFF11812
FFF11801  fbe2738f0000                      mov.l   #8F73h, r14
FFF11807  58ee                              movu.b  [r14], r14
FFF11809  755e16                            cmp     #16h, r14
FFF1180C  2406                              bgtu.b  loc_FFF11812
FFF1180E  f80601                            mov.l   #1, 4+var_4[sp]
FFF11811  0c                                bra.s   loc_FFF11815
FFF11812  f80600                 loc_FFF11812 mov.l   #0, 4+var_4[sp]
FFF11815  ec01                   loc_FFF11815 mov.l   4+var_4[sp], r1
FFF11817  6101                              cmp     #0, r1
FFF11819  2029                              beq.b   loc_FFF11842
FFF1181B  0569e3fd                          bsr.a   sub_FFEEFB84
FFF1181F  6101                              cmp     #0, r1
FFF11821  2121                              bne.b   loc_FFF11842
FFF11823  fbe2738f0000                      mov.l   #8F73h, r14
FFF11829  58e1                              movu.b  [r14], r1
FFF1182B  05bfe7fd                          bsr.a   sub_FFEEFFEA
FFF1182F  fbe2738f0000                      mov.l   #8F73h, r14
FFF11835  58ee                              movu.b  [r14], r14
FFF11837  fbf2d07cedff                      mov.l   #off_FFED7CD0, r15
FFF1183D  fe6efe                            mov.l   [r14, r15], r14
FFF11840  7f1e                              jsr     r14
FFF11842  fbe24c8c0000           loc_FFF11842 mov.l   #8C4Ch, r14
FFF11848  58ee                              movu.b  [r14], r14
FFF1184A  614e                              cmp     #4, r14
FFF1184C  290d                              blt.b   loc_FFF11859
FFF1184E  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11854  f8e403                            mov.b   #3, [r14]
FFF11857  6701                              rtsd    #1
FFF11859  6701                   loc_FFF11859 rtsd    #1
FFF1185B  6040                   sub_FFF1185B sub     #4, sp   ; <<<< FUNC sub_FFF1185B
FFF1185D  8089                              mov.b   r1, 4+var_1[sp]
FFF1185F  050a28fe                          bsr.a   sub_FFEF4069
FFF11863  391400                            bsr.w   sub_FFF11877
FFF11866  055428fe                          bsr.a   sub_FFEF40BA
FFF1186A  b089                              movu.b  4+var_1[sp], r1
FFF1186C  6111                              cmp     #1, r1
FFF1186E  1f                                bne.s   loc_FFF11875
FFF1186F  05bde7fd                          bsr.a   sub_FFEF002C
FFF11873  6701                              rtsd    #1
FFF11875  6701                   loc_FFF11875 rtsd    #1
FFF11877  6040                   sub_FFF11877 sub     #4, sp   ; <<<< FUNC sub_FFF11877
FFF11879  fbe2468e0000                      mov.l   #8E46h, r14
FFF1187F  59ef20                            movu.b  20h[r14], r15
FFF11882  eff5                              mov.l   r15, r5
FFF11884  fd749505                          divu    #5, r5
FFF11888  6355                              mul     #5, r5
FFF1188A  435f                              sub     r5, r15
FFF1188C  c7ef20                            mov.b   r15, 20h[r14]
FFF1188F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11895  59ee20                            movu.b  20h[r14], r14
FFF11898  fbf2468e0000                      mov.l   #8E46h, r15
FFF1189E  45fe20                            cmp     20h[r15], r14
FFF118A1  2037                              beq.b   loc_FFF118D8
FFF118A3  fbe2468e0000                      mov.l   #8E46h, r14
FFF118A9  59ee20                            movu.b  20h[r14], r14
FFF118AC  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF118B2  59ff20                            movu.b  20h[r15], r15
FFF118B5  fb5e000004                        mov.l   #40000h, r5
FFF118BA  ef51                              mov.l   r5, r1
FFF118BC  fd62f1                            shll    r15, r1
FFF118BF  fd62e5                            shll    r14, r5
FFF118C2  5751                              or      r5, r1
FFF118C4  05e0e5fd                          bsr.a   sub_FFEEFEA4
FFF118C8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF118CE  fbf2468e0000                      mov.l   #8E46h, r15
FFF118D4  c5fe2020                          mov.b   20h[r15], 20h[r14]
FFF118D8  3c0300                 loc_FFF118D8 mov.b   #0, 4+var_1[sp]
FFF118DB  2e31                              bra.b   loc_FFF1190C
FFF118DD  b08b                   loc_FFF118DD movu.b  4+var_1[sp], r3
FFF118DF  fb4e000004                        mov.l   #40000h, r4
FFF118E4  fd6234                            shll    r3, r4
FFF118E7  6c43                              shll    #4, r3
FFF118E9  fb22468e0000                      mov.l   #8E46h, r2
FFF118EF  4b32                              add     r3, r2
FFF118F1  712221                            add     #21h, r2, r2 ; '!'
FFF118F4  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF118FA  4b31                              add     r3, r1
FFF118FC  711121                            add     #21h, r1, r1 ; '!'
FFF118FF  754310                            mov.l   #10h, r3
FFF11902  058b07fe                          bsr.a   sub_FFEF208D
FFF11906  b089                              movu.b  4+var_1[sp], r1
FFF11908  6211                              add     #1, r1
FFF1190A  8089                              mov.b   r1, 4+var_1[sp]
FFF1190C  b089                   loc_FFF1190C movu.b  4+var_1[sp], r1
FFF1190E  6151                              cmp     #5, r1
FFF11910  29cd                              blt.b   loc_FFF118DD
FFF11912  3c0300                            mov.b   #0, 4+var_1[sp]
FFF11915  388500                            bra.w   loc_FFF1199A
FFF11918  b089                   loc_FFF11918 movu.b  4+var_1[sp], r1
FFF1191A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11920  4b1e                              add     r1, r14
FFF11922  59ee71                            movu.b  71h[r14], r14
FFF11925  fbf2468e0000                      mov.l   #8E46h, r15
FFF1192B  4b1f                              add     r1, r15
FFF1192D  45fe71                            cmp     71h[r15], r14
FFF11930  2026                              beq.b   loc_FFF11956
FFF11932  b08a                              movu.b  4+var_1[sp], r2
FFF11934  fb1e008000                        mov.l   #8000h, r1
FFF11939  fd6221                            shll    r2, r1
FFF1193C  0568e5fd                          bsr.a   sub_FFEEFEA4
FFF11940  b089                              movu.b  4+var_1[sp], r1
FFF11942  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11948  4b1e                              add     r1, r14
FFF1194A  fbf2468e0000                      mov.l   #8E46h, r15
FFF11950  4b1f                              add     r1, r15
FFF11952  c5fe7171                          mov.b   71h[r15], 71h[r14]
FFF11956  b089                   loc_FFF11956 movu.b  4+var_1[sp], r1
FFF11958  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1195E  4b1e                              add     r1, r14
FFF11960  59ee74                            movu.b  74h[r14], r14
FFF11963  fbf2468e0000                      mov.l   #8E46h, r15
FFF11969  4b1f                              add     r1, r15
FFF1196B  45fe74                            cmp     74h[r15], r14
FFF1196E  2026                              beq.b   loc_FFF11994
FFF11970  b08a                              movu.b  4+var_1[sp], r2
FFF11972  fb1e008000                        mov.l   #8000h, r1
FFF11977  fd6221                            shll    r2, r1
FFF1197A  052ae5fd                          bsr.a   sub_FFEEFEA4
FFF1197E  b089                              movu.b  4+var_1[sp], r1
FFF11980  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11986  4b1e                              add     r1, r14
FFF11988  fbf2468e0000                      mov.l   #8E46h, r15
FFF1198E  4b1f                              add     r1, r15
FFF11990  c5fe7474                          mov.b   74h[r15], 74h[r14]
FFF11994  b089                   loc_FFF11994 movu.b  4+var_1[sp], r1
FFF11996  6211                              add     #1, r1
FFF11998  8089                              mov.b   r1, 4+var_1[sp]
FFF1199A  b089                   loc_FFF1199A movu.b  4+var_1[sp], r1
FFF1199C  6131                              cmp     #3, r1
FFF1199E  2805                              bge.b   loc_FFF119A3
FFF119A0  3878ff                            bra.w   loc_FFF11918
FFF119A3  05f1e8fd               loc_FFF119A3 bsr.a   sub_FFEF0294
FFF119A7  6701                              rtsd    #1
FFF119A9  6040                   sub_FFF119A9 sub     #4, sp   ; <<<< FUNC sub_FFF119A9
FFF119AB  fbe2798d0000                      mov.l   #8D79h, r14
FFF119B1  f8e400                            mov.b   #0, [r14]
FFF119B4  6601                              mov.l   #0, r1
FFF119B6  ef12                              mov.l   r1, r2
FFF119B8  0550eafd                          bsr.a   sub_FFEF0408
FFF119BC  3c0300                            mov.b   #0, 4+var_1[sp]
FFF119BF  2e31                              bra.b   loc_FFF119F0
FFF119C1  fbe24d8c0000           loc_FFF119C1 mov.l   #8C4Dh, r14
FFF119C7  59e320                            movu.b  20h[r14], r3
FFF119CA  b08c                              movu.b  4+var_1[sp], r4
FFF119CC  6040                              sub     #4, sp
FFF119CE  fdc44f                            shll    #4, r4, r15
FFF119D1  4bfe                              add     r15, r14
FFF119D3  71ee21                            add     #21h, r14, r14 ; '!'
FFF119D6  e30e                              mov.l   r14, 8+var_8[sp]
FFF119D8  ef4e                              mov.l   r4, r14
FFF119DA  751e1e                            mul     #1Eh, r14
FFF119DD  71ee1e                            add     #1Eh, r14, r14
FFF119E0  5fe2                              movu.w  r14, r2
FFF119E2  6601                              mov.l   #0, r1
FFF119E4  0579e4ff                          bsr.a   sub_FFF0FE5D
FFF119E8  6240                              add     #4, sp
FFF119EA  b089                              movu.b  4+var_1[sp], r1
FFF119EC  6211                              add     #1, r1
FFF119EE  8089                              mov.b   r1, 4+var_1[sp]
FFF119F0  b089                   loc_FFF119F0 movu.b  4+var_1[sp], r1
FFF119F2  6151                              cmp     #5, r1
FFF119F4  29cd                              blt.b   loc_FFF119C1
FFF119F6  6601                              mov.l   #0, r1
FFF119F8  050d0bfe                          bsr.a   sub_FFEF2505
FFF119FC  6611                              mov.l   #1, r1
FFF119FE  05070bfe                          bsr.a   sub_FFEF2505
FFF11A02  6621                              mov.l   #2, r1
FFF11A04  05010bfe                          bsr.a   sub_FFEF2505
FFF11A08  6701                              rtsd    #1
FFF11A0A  fbe24c8c0000           sub_FFF11A0A mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF11A0A
FFF11A10  58ee                              movu.b  [r14], r14
FFF11A12  613e                              cmp     #3, r14
FFF11A14  2a16                              bgt.b   loc_FFF11A2A
FFF11A16  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11A1C  58ee                              movu.b  [r14], r14
FFF11A1E  fbf22c7dedff                      mov.l   #off_FFED7D2C, r15
FFF11A24  fe6efe                            mov.l   [r14, r15], r14
FFF11A27  7f1e                              jsr     r14
FFF11A29  02                                rts
FFF11A2A  fbe24c8c0000           loc_FFF11A2A mov.l   #8C4Ch, r14
FFF11A30  f8e403                            mov.b   #3, [r14]
FFF11A33  02                                rts
FFF11A34  6611                   sub_FFF11A34 mov.l   #1, r1   ; <<<< FUNC sub_FFF11A34
FFF11A36  398701                            bsr.w   sub_FFF11BBD
FFF11A39  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11A3F  58ef                              movu.b  [r14], r15
FFF11A41  621f                              add     #1, r15
FFF11A43  c3ef                              mov.b   r15, [r14]
FFF11A45  02                                rts
FFF11A46  6080                   sub_FFF11A46 sub     #8, sp   ; <<<< FUNC sub_FFF11A46
FFF11A48  05e5e8fd                          bsr.a   sub_FFEF032D
FFF11A4C  05fb8cfe                          bsr.a   sub_FFEFA747
FFF11A50  3d0306                            mov.w   #6, 8+var_2[sp]
FFF11A53  3d0200                            mov.w   #0, 8+var_4[sp]
FFF11A56  b882                              movu.w  8+var_4[sp], r2
FFF11A58  b889                              movu.w  8+var_2[sp], r1
FFF11A5A  60c0                              sub     #0Ch, sp
FFF11A5C  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF11A62  713320                            add     #20h, r3, r3 ; ' '
FFF11A65  a00b                              mov.l   r3, 14h+var_10[sp]
FFF11A67  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF11A6A  f80416                            mov.b   #16h, 14h+var_14[sp]
FFF11A6D  6212                              add     #1, r2
FFF11A6F  5f22                              movu.w  r2, r2
FFF11A71  6604                              mov.l   #0, r4
FFF11A73  66d3                              mov.l   #0Dh, r3
FFF11A75  05ae00fe                          bsr.a   sub_FFEF1B23
FFF11A79  62c0                              add     #0Ch, sp
FFF11A7B  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF11A7E  3c0300                            mov.b   #0, 8+var_5[sp]
FFF11A81  2e17                              bra.b   loc_FFF11A98
FFF11A83  b881                   loc_FFF11A83 movu.w  8+var_4[sp], r1
FFF11A85  6612                              mov.l   #1, r2
FFF11A87  05e7e4ff                          bsr.a   sub_FFF0FF6E
FFF11A8B  b881                              movu.w  8+var_4[sp], r1
FFF11A8D  71111e                            add     #1Eh, r1, r1
FFF11A90  9081                              mov.w   r1, 8+var_4[sp]
FFF11A92  b089                              movu.b  8+var_5[sp], r1
FFF11A94  6211                              add     #1, r1
FFF11A96  8089                              mov.b   r1, 8+var_5[sp]
FFF11A98  b089                   loc_FFF11A98 movu.b  8+var_5[sp], r1
FFF11A9A  6151                              cmp     #5, r1
FFF11A9C  29e7                              blt.b   loc_FFF11A83
FFF11A9E  7542b3                            mov.l   #-4Dh, r2
FFF11AA1  754122                            mov.l   #22h, r1 ; '"'
FFF11AA4  05ab8afe                          bsr.a   sub_FFEFA54F
FFF11AA8  6661                              mov.l   #6, r1
FFF11AAA  05e583fe                          bsr.a   sub_FFEF9E8F
FFF11AAE  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11AB4  58ef                              movu.b  [r14], r15
FFF11AB6  621f                              add     #1, r15
FFF11AB8  c3ef                              mov.b   r15, [r14]
FFF11ABA  6702                              rtsd    #2
FFF11ABC  6040                   sub_FFF11ABC sub     #4, sp   ; <<<< FUNC sub_FFF11ABC
FFF11ABE  6040                              sub     #4, sp
FFF11AC0  3d00f0                            mov.w   #-10h, [sp]
FFF11AC3  fb4a4001                          mov.l   #140h, r4
FFF11AC7  6602                              mov.l   #0, r2
FFF11AC9  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11ACF  ef23                              mov.l   r2, r3
FFF11AD1  05eadefd                          bsr.a   sub_FFEEF9BB
FFF11AD5  6240                              add     #4, sp
FFF11AD7  8089                              mov.b   r1, 4+var_1[sp]
FFF11AD9  b089                              movu.b  4+var_1[sp], r1
FFF11ADB  6111                              cmp     #1, r1
FFF11ADD  1a                                bne.s   loc_FFF11AE7
FFF11ADE  397202                            bsr.w   sub_FFF11D50
FFF11AE1  058ee8fd                          bsr.a   sub_FFEF036F
FFF11AE5  6701                              rtsd    #1
FFF11AE7  6701                   loc_FFF11AE7 rtsd    #1
FFF11AE9  6040                   sub_FFF11AE9 sub     #4, sp   ; <<<< FUNC sub_FFF11AE9
FFF11AEB  fbe2738f0000                      mov.l   #8F73h, r14
FFF11AF1  58e1                              movu.b  [r14], r1
FFF11AF3  7111ee                            add     #-12h, r1, r1
FFF11AF6  8081                              mov.b   r1, 4+var_2[sp]
FFF11AF8  b081                              movu.b  4+var_2[sp], r1
FFF11AFA  75111e                            mul     #1Eh, r1
FFF11AFD  71111e                            add     #1Eh, r1, r1
FFF11B00  d301                              mov.w   r1, 4+var_4[sp]
FFF11B02  5c03                              movu.w  4+var_4[sp], r3
FFF11B04  6040                              sub     #4, sp
FFF11B06  f80523                            mov.w   #23h, 8+var_8[sp] ; '#'
FFF11B09  fb4a4001                          mov.l   #140h, r4
FFF11B0D  6602                              mov.l   #0, r2
FFF11B0F  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11B15  05a6defd                          bsr.a   sub_FFEEF9BB
FFF11B19  6240                              add     #4, sp
FFF11B1B  8089                              mov.b   r1, 4+var_1[sp]
FFF11B1D  b089                              movu.b  4+var_1[sp], r1
FFF11B1F  6111                              cmp     #1, r1
FFF11B21  210d                              bne.b   loc_FFF11B2E
FFF11B23  b081                              movu.b  4+var_2[sp], r1
FFF11B25  396802                            bsr.w   sub_FFF11D8D
FFF11B28  0547e8fd                          bsr.a   sub_FFEF036F
FFF11B2C  6701                              rtsd    #1
FFF11B2E  6701                   loc_FFF11B2E rtsd    #1
FFF11B30  66f1                   sub_FFF11B30 mov.l   #0Fh, r1   ; <<<< FUNC sub_FFF11B30
FFF11B32  05c8e3ff                          bsr.a   sub_FFF0FEFA
FFF11B36  02                                rts
FFF11B37  6040                   sub_FFF11B37 sub     #4, sp   ; <<<< FUNC sub_FFF11B37
FFF11B39  0506e5fd                          bsr.a   sub_FFEF003F
FFF11B3D  fbe2738f0000                      mov.l   #8F73h, r14
FFF11B43  c3e1                              mov.b   r1, [r14]
FFF11B45  fbe2738f0000                      mov.l   #8F73h, r14
FFF11B4B  58ee                              movu.b  [r14], r14
FFF11B4D  755eff                            cmp     #-1, r14
FFF11B50  1e                                bne.s   loc_FFF11B56
FFF11B51  6601                              mov.l   #0, r1
FFF11B53  396a00                            bsr.w   sub_FFF11BBD
FFF11B56  fbe2738f0000           loc_FFF11B56 mov.l   #8F73h, r14
FFF11B5C  58ee                              movu.b  [r14], r14
FFF11B5E  755eff                            cmp     #-1, r14
FFF11B61  2013                              beq.b   loc_FFF11B74
FFF11B63  fbe2738f0000                      mov.l   #8F73h, r14
FFF11B69  58ee                              movu.b  [r14], r14
FFF11B6B  755e16                            cmp     #16h, r14
FFF11B6E  2406                              bgtu.b  loc_FFF11B74
FFF11B70  f80601                            mov.l   #1, 4+var_4[sp]
FFF11B73  0c                                bra.s   loc_FFF11B77
FFF11B74  f80600                 loc_FFF11B74 mov.l   #0, 4+var_4[sp]
FFF11B77  ec01                   loc_FFF11B77 mov.l   4+var_4[sp], r1
FFF11B79  6101                              cmp     #0, r1
FFF11B7B  2029                              beq.b   loc_FFF11BA4
FFF11B7D  0507e0fd                          bsr.a   sub_FFEEFB84
FFF11B81  6101                              cmp     #0, r1
FFF11B83  2121                              bne.b   loc_FFF11BA4
FFF11B85  fbe2738f0000                      mov.l   #8F73h, r14
FFF11B8B  58e1                              movu.b  [r14], r1
FFF11B8D  055de4fd                          bsr.a   sub_FFEEFFEA
FFF11B91  fbe2738f0000                      mov.l   #8F73h, r14
FFF11B97  58ee                              movu.b  [r14], r14
FFF11B99  fbf23c7dedff                      mov.l   #off_FFED7D3C, r15
FFF11B9F  fe6efe                            mov.l   [r14, r15], r14
FFF11BA2  7f1e                              jsr     r14
FFF11BA4  fbe24c8c0000           loc_FFF11BA4 mov.l   #8C4Ch, r14
FFF11BAA  58ee                              movu.b  [r14], r14
FFF11BAC  614e                              cmp     #4, r14
FFF11BAE  290d                              blt.b   loc_FFF11BBB
FFF11BB0  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11BB6  f8e403                            mov.b   #3, [r14]
FFF11BB9  6701                              rtsd    #1
FFF11BBB  6701                   loc_FFF11BBB rtsd    #1
FFF11BBD  6040                   sub_FFF11BBD sub     #4, sp   ; <<<< FUNC sub_FFF11BBD
FFF11BBF  8089                              mov.b   r1, 4+var_1[sp]
FFF11BC1  05a824fe                          bsr.a   sub_FFEF4069
FFF11BC5  391400                            bsr.w   sub_FFF11BD9
FFF11BC8  05f224fe                          bsr.a   sub_FFEF40BA
FFF11BCC  b089                              movu.b  4+var_1[sp], r1
FFF11BCE  6111                              cmp     #1, r1
FFF11BD0  1f                                bne.s   loc_FFF11BD7
FFF11BD1  055be4fd                          bsr.a   sub_FFEF002C
FFF11BD5  6701                              rtsd    #1
FFF11BD7  6701                   loc_FFF11BD7 rtsd    #1
FFF11BD9  6040                   sub_FFF11BD9 sub     #4, sp   ; <<<< FUNC sub_FFF11BD9
FFF11BDB  fb22468e0000                      mov.l   #8E46h, r2
FFF11BE1  712220                            add     #20h, r2, r2 ; ' '
FFF11BE4  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF11BEA  711120                            add     #20h, r1, r1 ; ' '
FFF11BED  6614                              mov.l   #1, r4
FFF11BEF  754317                            mov.l   #17h, r3
FFF11BF2  059b04fe                          bsr.a   sub_FFEF208D
FFF11BF6  fbe2468e0000                      mov.l   #8E46h, r14
FFF11BFC  59ef37                            movu.b  37h[r14], r15
FFF11BFF  eff5                              mov.l   r15, r5
FFF11C01  fd749505                          divu    #5, r5
FFF11C05  6355                              mul     #5, r5
FFF11C07  435f                              sub     r5, r15
FFF11C09  c7ef37                            mov.b   r15, 37h[r14]
FFF11C0C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11C12  59ee37                            movu.b  37h[r14], r14
FFF11C15  fbf2468e0000                      mov.l   #8E46h, r15
FFF11C1B  45fe37                            cmp     37h[r15], r14
FFF11C1E  2037                              beq.b   loc_FFF11C55
FFF11C20  fbe2468e0000                      mov.l   #8E46h, r14
FFF11C26  59ee37                            movu.b  37h[r14], r14
FFF11C29  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF11C2F  59ff37                            movu.b  37h[r15], r15
FFF11C32  fb5e000004                        mov.l   #40000h, r5
FFF11C37  ef51                              mov.l   r5, r1
FFF11C39  fd62f1                            shll    r15, r1
FFF11C3C  fd62e5                            shll    r14, r5
FFF11C3F  5751                              or      r5, r1
FFF11C41  0563e2fd                          bsr.a   sub_FFEEFEA4
FFF11C45  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11C4B  fbf2468e0000                      mov.l   #8E46h, r15
FFF11C51  c5fe3737                          mov.b   37h[r15], 37h[r14]
FFF11C55  3c0300                 loc_FFF11C55 mov.b   #0, 4+var_1[sp]
FFF11C58  2e5b                              bra.b   loc_FFF11CB3
FFF11C5A  b08b                   loc_FFF11C5A movu.b  4+var_1[sp], r3
FFF11C5C  fb4e000004                        mov.l   #40000h, r4
FFF11C61  fd6234                            shll    r3, r4
FFF11C64  751318                            mul     #18h, r3
FFF11C67  fb22468e0000                      mov.l   #8E46h, r2
FFF11C6D  4b32                              add     r3, r2
FFF11C6F  712238                            add     #38h, r2, r2 ; '8'
FFF11C72  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF11C78  4b31                              add     r3, r1
FFF11C7A  711138                            add     #38h, r1, r1 ; '8'
FFF11C7D  6613                              mov.l   #1, r3
FFF11C7F  050e04fe                          bsr.a   sub_FFEF208D
FFF11C83  b08b                              movu.b  4+var_1[sp], r3
FFF11C85  fb4e000004                        mov.l   #40000h, r4
FFF11C8A  fd6234                            shll    r3, r4
FFF11C8D  751318                            mul     #18h, r3
FFF11C90  fb22468e0000                      mov.l   #8E46h, r2
FFF11C96  4b32                              add     r3, r2
FFF11C98  712239                            add     #39h, r2, r2 ; '9'
FFF11C9B  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF11CA1  4b31                              add     r3, r1
FFF11CA3  711139                            add     #39h, r1, r1 ; '9'
FFF11CA6  754317                            mov.l   #17h, r3
FFF11CA9  05e403fe                          bsr.a   sub_FFEF208D
FFF11CAD  b089                              movu.b  4+var_1[sp], r1
FFF11CAF  6211                              add     #1, r1
FFF11CB1  8089                              mov.b   r1, 4+var_1[sp]
FFF11CB3  b089                   loc_FFF11CB3 movu.b  4+var_1[sp], r1
FFF11CB5  6151                              cmp     #5, r1
FFF11CB7  29a3                              blt.b   loc_FFF11C5A
FFF11CB9  3c0300                            mov.b   #0, 4+var_1[sp]
FFF11CBC  388500                            bra.w   loc_FFF11D41
FFF11CBF  b089                   loc_FFF11CBF movu.b  4+var_1[sp], r1
FFF11CC1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11CC7  4b1e                              add     r1, r14
FFF11CC9  59eeb0                            movu.b  0B0h[r14], r14
FFF11CCC  fbf2468e0000                      mov.l   #8E46h, r15
FFF11CD2  4b1f                              add     r1, r15
FFF11CD4  45feb0                            cmp     0B0h[r15], r14
FFF11CD7  2026                              beq.b   loc_FFF11CFD
FFF11CD9  b08a                              movu.b  4+var_1[sp], r2
FFF11CDB  fb1e008000                        mov.l   #8000h, r1
FFF11CE0  fd6221                            shll    r2, r1
FFF11CE3  05c1e1fd                          bsr.a   sub_FFEEFEA4
FFF11CE7  b089                              movu.b  4+var_1[sp], r1
FFF11CE9  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11CEF  4b1e                              add     r1, r14
FFF11CF1  fbf2468e0000                      mov.l   #8E46h, r15
FFF11CF7  4b1f                              add     r1, r15
FFF11CF9  c5feb0b0                          mov.b   0B0h[r15], 0B0h[r14]
FFF11CFD  b089                   loc_FFF11CFD movu.b  4+var_1[sp], r1
FFF11CFF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11D05  4b1e                              add     r1, r14
FFF11D07  59eeb3                            movu.b  0B3h[r14], r14
FFF11D0A  fbf2468e0000                      mov.l   #8E46h, r15
FFF11D10  4b1f                              add     r1, r15
FFF11D12  45feb3                            cmp     0B3h[r15], r14
FFF11D15  2026                              beq.b   loc_FFF11D3B
FFF11D17  b08a                              movu.b  4+var_1[sp], r2
FFF11D19  fb1e008000                        mov.l   #8000h, r1
FFF11D1E  fd6221                            shll    r2, r1
FFF11D21  0583e1fd                          bsr.a   sub_FFEEFEA4
FFF11D25  b089                              movu.b  4+var_1[sp], r1
FFF11D27  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11D2D  4b1e                              add     r1, r14
FFF11D2F  fbf2468e0000                      mov.l   #8E46h, r15
FFF11D35  4b1f                              add     r1, r15
FFF11D37  c5feb3b3                          mov.b   0B3h[r15], 0B3h[r14]
FFF11D3B  b089                   loc_FFF11D3B movu.b  4+var_1[sp], r1
FFF11D3D  6211                              add     #1, r1
FFF11D3F  8089                              mov.b   r1, 4+var_1[sp]
FFF11D41  b089                   loc_FFF11D41 movu.b  4+var_1[sp], r1
FFF11D43  6131                              cmp     #3, r1
FFF11D45  2805                              bge.b   loc_FFF11D4A
FFF11D47  3878ff                            bra.w   loc_FFF11CBF
FFF11D4A  054ae5fd               loc_FFF11D4A bsr.a   sub_FFEF0294
FFF11D4E  6701                              rtsd    #1
FFF11D50  6040                   sub_FFF11D50 sub     #4, sp   ; <<<< FUNC sub_FFF11D50
FFF11D52  fbe2798d0000                      mov.l   #8D79h, r14
FFF11D58  f8e400                            mov.b   #0, [r14]
FFF11D5B  6601                              mov.l   #0, r1
FFF11D5D  ef12                              mov.l   r1, r2
FFF11D5F  05a9e6fd                          bsr.a   sub_FFEF0408
FFF11D63  3c0300                            mov.b   #0, 4+var_1[sp]
FFF11D66  2e0d                              bra.b   loc_FFF11D73
FFF11D68  b089                   loc_FFF11D68 movu.b  4+var_1[sp], r1
FFF11D6A  392300                            bsr.w   sub_FFF11D8D
FFF11D6D  b089                              movu.b  4+var_1[sp], r1
FFF11D6F  6211                              add     #1, r1
FFF11D71  8089                              mov.b   r1, 4+var_1[sp]
FFF11D73  b089                   loc_FFF11D73 movu.b  4+var_1[sp], r1
FFF11D75  6151                              cmp     #5, r1
FFF11D77  29f1                              blt.b   loc_FFF11D68
FFF11D79  6601                              mov.l   #0, r1
FFF11D7B  058a07fe                          bsr.a   sub_FFEF2505
FFF11D7F  6611                              mov.l   #1, r1
FFF11D81  058407fe                          bsr.a   sub_FFEF2505
FFF11D85  6621                              mov.l   #2, r1
FFF11D87  057e07fe                          bsr.a   sub_FFEF2505
FFF11D8B  6701                              rtsd    #1
FFF11D8D  6080                   sub_FFF11D8D sub     #8, sp   ; <<<< FUNC sub_FFF11D8D
FFF11D8F  8189                              mov.b   r1, 8+var_1[sp]
FFF11D91  b189                              movu.b  8+var_1[sp], r1
FFF11D93  751118                            mul     #18h, r1
FFF11D96  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11D9C  4b1e                              add     r1, r14
FFF11D9E  c5e03806                          mov.b   38h[r14], 8+var_2[sp]
FFF11DA2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11DA8  c5e03705                          mov.b   37h[r14], 8+var_3[sp]
FFF11DAC  3d0106                            mov.w   #6, 8+var_6[sp]
FFF11DAF  b189                              movu.b  8+var_1[sp], r1
FFF11DB1  75111e                            mul     #1Eh, r1
FFF11DB4  71111e                            add     #1Eh, r1, r1
FFF11DB7  d301                              mov.w   r1, 8+var_8[sp]
FFF11DB9  5c01                              movu.w  8+var_8[sp], r1
FFF11DBB  6211                              add     #1, r1
FFF11DBD  5f12                              movu.w  r1, r2
FFF11DBF  75441d                            mov.l   #1Dh, r4
FFF11DC2  fb3a4001                          mov.l   #140h, r3
FFF11DC6  6601                              mov.l   #0, r1
FFF11DC8  052fe7fd                          bsr.a   sub_FFEF04F7
FFF11DCC  b181                              movu.b  8+var_2[sp], r1
FFF11DCE  6101                              cmp     #0, r1
FFF11DD0  2052                              beq.b   loc_FFF11E22
FFF11DD2  b109                              movu.b  8+var_3[sp], r1
FFF11DD4  450107                            cmp     8+var_1[sp], r1
FFF11DD7  211d                              bne.b   loc_FFF11DF4
FFF11DD9  5c01                              movu.w  8+var_8[sp], r1
FFF11DDB  6040                              sub     #4, sp
FFF11DDD  f80980f9                          mov.w   #-680h, 0Ch+var_C[sp]
FFF11DE1  6211                              add     #1, r1
FFF11DE3  5f12                              movu.w  r1, r2
FFF11DE5  75441d                            mov.l   #1Dh, r4
FFF11DE8  fb3a2d01                          mov.l   #12Dh, r3
FFF11DEC  6661                              mov.l   #6, r1
FFF11DEE  055afefd                          bsr.a   sub_FFEF1C48
FFF11DF2  6240                              add     #4, sp
FFF11DF4  b18a                   loc_FFF11DF4 movu.b  8+var_1[sp], r2
FFF11DF6  5c03                              movu.w  8+var_8[sp], r3
FFF11DF8  b809                              movu.w  8+var_6[sp], r1
FFF11DFA  60c0                              sub     #0Ch, sp
FFF11DFC  751218                            mul     #18h, r2
FFF11DFF  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF11E05  4b24                              add     r2, r4
FFF11E07  714439                            add     #39h, r4, r4 ; '9'
FFF11E0A  a00c                              mov.l   r4, 14h+var_10[sp]
FFF11E0C  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF11E0F  f80416                            mov.b   #16h, 14h+var_14[sp]
FFF11E12  6213                              add     #1, r3
FFF11E14  5f32                              movu.w  r3, r2
FFF11E16  6604                              mov.l   #0, r4
FFF11E18  66d3                              mov.l   #0Dh, r3
FFF11E1A  0509fdfd                          bsr.a   sub_FFEF1B23
FFF11E1E  62c0                              add     #0Ch, sp
FFF11E20  6702                              rtsd    #2
FFF11E22  6702                   loc_FFF11E22 rtsd    #2
FFF11E24  fbe24c8c0000           sub_FFF11E24 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF11E24
FFF11E2A  58ee                              movu.b  [r14], r14
FFF11E2C  613e                              cmp     #3, r14
FFF11E2E  2a16                              bgt.b   loc_FFF11E44
FFF11E30  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11E36  58ee                              movu.b  [r14], r14
FFF11E38  fbf2987dedff                      mov.l   #off_FFED7D98, r15
FFF11E3E  fe6efe                            mov.l   [r14, r15], r14
FFF11E41  7f1e                              jsr     r14
FFF11E43  02                                rts
FFF11E44  fbe24c8c0000           loc_FFF11E44 mov.l   #8C4Ch, r14
FFF11E4A  f8e403                            mov.b   #3, [r14]
FFF11E4D  02                                rts
FFF11E4E  6611                   sub_FFF11E4E mov.l   #1, r1   ; <<<< FUNC sub_FFF11E4E
FFF11E50  392202                            bsr.w   sub_FFF12072
FFF11E53  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11E59  58ef                              movu.b  [r14], r15
FFF11E5B  621f                              add     #1, r15
FFF11E5D  c3ef                              mov.b   r15, [r14]
FFF11E5F  02                                rts
FFF11E60  6080                   sub_FFF11E60 sub     #8, sp   ; <<<< FUNC sub_FFF11E60
FFF11E62  05cbe4fd                          bsr.a   sub_FFEF032D
FFF11E66  052287fe                          bsr.a   sub_FFEFA588
FFF11E6A  754432                            mov.l   #32h, r4 ; '2'
FFF11E6D  fb3a3c01                          mov.l   #13Ch, r3
FFF11E71  754256                            mov.l   #56h, r2 ; 'V'
FFF11E74  6621                              mov.l   #2, r1
FFF11E76  05a290fe                          bsr.a   sub_FFEFAF18
FFF11E7A  3d0337                            mov.w   #37h, 8+var_2[sp] ; '7'
FFF11E7D  3d028b                            mov.w   #-75h, 8+var_4[sp]
FFF11E80  3c0300                            mov.b   #0, 8+var_5[sp]
FFF11E83  2e1d                              bra.b   loc_FFF11EA0
FFF11E85  b882                   loc_FFF11E85 movu.w  8+var_4[sp], r2
FFF11E87  490203                            add     8+var_5[sp], r2
FFF11E8A  b889                              movu.w  8+var_2[sp], r1
FFF11E8C  5f22                              movu.w  r2, r2
FFF11E8E  fb427c35edff                      mov.l   #unk_FFED357C, r4
FFF11E94  6613                              mov.l   #1, r3
FFF11E96  053f4afe                          bsr.a   sub_FFEF68D5
FFF11E9A  b089                              movu.b  8+var_5[sp], r1
FFF11E9C  6211                              add     #1, r1
FFF11E9E  8089                              mov.b   r1, 8+var_5[sp]
FFF11EA0  b089                   loc_FFF11EA0 movu.b  8+var_5[sp], r1
FFF11EA2  755130                            cmp     #30h, r1 ; '0'
FFF11EA5  29e0                              blt.b   loc_FFF11E85
FFF11EA7  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF11EAD  58ef                              movu.b  [r14], r15
FFF11EAF  621f                              add     #1, r15
FFF11EB1  c3ef                              mov.b   r15, [r14]
FFF11EB3  6702                              rtsd    #2
FFF11EB5  6040                   sub_FFF11EB5 sub     #4, sp   ; <<<< FUNC sub_FFF11EB5
FFF11EB7  6040                              sub     #4, sp
FFF11EB9  3d00f0                            mov.w   #-10h, [sp]
FFF11EBC  fb4a4001                          mov.l   #140h, r4
FFF11EC0  6602                              mov.l   #0, r2
FFF11EC2  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11EC8  ef23                              mov.l   r2, r3
FFF11ECA  05f1dafd                          bsr.a   sub_FFEEF9BB
FFF11ECE  6240                              add     #4, sp
FFF11ED0  8089                              mov.b   r1, 4+var_1[sp]
FFF11ED2  b089                              movu.b  4+var_1[sp], r1
FFF11ED4  6111                              cmp     #1, r1
FFF11ED6  1a                                bne.s   loc_FFF11EE0
FFF11ED7  391b03                            bsr.w   sub_FFF121F2
FFF11EDA  0595e4fd                          bsr.a   sub_FFEF036F
FFF11EDE  6701                              rtsd    #1
FFF11EE0  6701                   loc_FFF11EE0 rtsd    #1
FFF11EE2  6040                   sub_FFF11EE2 sub     #4, sp   ; <<<< FUNC sub_FFF11EE2
FFF11EE4  6040                              sub     #4, sp
FFF11EE6  f80532                            mov.w   #32h, 8+var_8[sp] ; '2'
FFF11EE9  754428                            mov.l   #28h, r4 ; '('
FFF11EEC  75438f                            mov.l   #-71h, r3
FFF11EEF  6672                              mov.l   #7, r2
FFF11EF1  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11EF7  05c4dafd                          bsr.a   sub_FFEEF9BB
FFF11EFB  6240                              add     #4, sp
FFF11EFD  8089                              mov.b   r1, 4+var_1[sp]
FFF11EFF  b089                              movu.b  4+var_1[sp], r1
FFF11F01  6111                              cmp     #1, r1
FFF11F03  2119                              bne.b   loc_FFF11F1C
FFF11F05  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF11F0B  59e381                            movu.b  81h[r14], r3
FFF11F0E  75428f                            mov.l   #-71h, r2
FFF11F11  6671                              mov.l   #7, r1
FFF11F13  399203                            bsr.w   sub_FFF122A5
FFF11F16  0559e4fd                          bsr.a   sub_FFEF036F
FFF11F1A  6701                              rtsd    #1
FFF11F1C  6701                   loc_FFF11F1C rtsd    #1
FFF11F1E  6040                   sub_FFF11F1E sub     #4, sp   ; <<<< FUNC sub_FFF11F1E
FFF11F20  6040                              sub     #4, sp
FFF11F22  f80532                            mov.w   #32h, 8+var_8[sp] ; '2'
FFF11F25  fb4a3e01                          mov.l   #13Eh, r4
FFF11F29  754356                            mov.l   #56h, r3 ; 'V'
FFF11F2C  6622                              mov.l   #2, r2
FFF11F2E  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11F34  0587dafd                          bsr.a   sub_FFEEF9BB
FFF11F38  6240                              add     #4, sp
FFF11F3A  8089                              mov.b   r1, 4+var_1[sp]
FFF11F3C  b089                              movu.b  4+var_1[sp], r1
FFF11F3E  6111                              cmp     #1, r1
FFF11F40  2126                              bne.b   loc_FFF11F66
FFF11F42  6040                              sub     #4, sp
FFF11F44  3c010a                            mov.b   #0Ah, 8+var_7[sp]
FFF11F47  f8040a                            mov.b   #0Ah, 8+var_8[sp]
FFF11F4A  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF11F50  713476                            add     #76h, r3, r4 ; 'v'
FFF11F53  71336c                            add     #6Ch, r3, r3 ; 'l'
FFF11F56  754256                            mov.l   #56h, r2 ; 'V'
FFF11F59  6621                              mov.l   #2, r1
FFF11F5B  396f03                            bsr.w   sub_FFF122CA
FFF11F5E  6240                              add     #4, sp
FFF11F60  050fe4fd                          bsr.a   sub_FFEF036F
FFF11F64  6701                              rtsd    #1
FFF11F66  6701                   loc_FFF11F66 rtsd    #1
FFF11F68  6040                   sub_FFF11F68 sub     #4, sp   ; <<<< FUNC sub_FFF11F68
FFF11F6A  6040                              sub     #4, sp
FFF11F6C  f80532                            mov.w   #32h, 8+var_8[sp] ; '2'
FFF11F6F  fb4a0a01                          mov.l   #10Ah, r4
FFF11F73  75438a                            mov.l   #-76h, r3
FFF11F76  754236                            mov.l   #36h, r2 ; '6'
FFF11F79  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11F7F  053cdafd                          bsr.a   sub_FFEEF9BB
FFF11F83  6240                              add     #4, sp
FFF11F85  8089                              mov.b   r1, 4+var_1[sp]
FFF11F87  b089                              movu.b  4+var_1[sp], r1
FFF11F89  6111                              cmp     #1, r1
FFF11F8B  2111                              bne.b   loc_FFF11F9C
FFF11F8D  75428a                            mov.l   #-76h, r2
FFF11F90  754136                            mov.l   #36h, r1 ; '6'
FFF11F93  399e03                            bsr.w   sub_FFF12331
FFF11F96  05d9e3fd                          bsr.a   sub_FFEF036F
FFF11F9A  6701                              rtsd    #1
FFF11F9C  6701                   loc_FFF11F9C rtsd    #1
FFF11F9E  6040                   sub_FFF11F9E sub     #4, sp   ; <<<< FUNC sub_FFF11F9E
FFF11FA0  6040                              sub     #4, sp
FFF11FA2  f80532                            mov.w   #32h, 8+var_8[sp] ; '2'
FFF11FA5  fb4a3e01                          mov.l   #13Eh, r4
FFF11FA9  7543be                            mov.l   #-42h, r3
FFF11FAC  6622                              mov.l   #2, r2
FFF11FAE  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF11FB4  0507dafd                          bsr.a   sub_FFEEF9BB
FFF11FB8  6240                              add     #4, sp
FFF11FBA  8089                              mov.b   r1, 4+var_1[sp]
FFF11FBC  b089                              movu.b  4+var_1[sp], r1
FFF11FBE  6111                              cmp     #1, r1
FFF11FC0  212a                              bne.b   loc_FFF11FEA
FFF11FC2  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF11FC8  593e82                            movu.b  82h[r3], r14
FFF11FCB  6040                              sub     #4, sp
FFF11FCD  c5308001                          mov.b   80h[r3], 8+var_7[sp]
FFF11FD1  c30e                              mov.b   r14, 8+var_8[sp]
FFF11FD3  72338300                          add     #83h, r3, r3
FFF11FD7  754415                            mov.l   #15h, r4
FFF11FDA  7542be                            mov.l   #-42h, r2
FFF11FDD  6621                              mov.l   #2, r1
FFF11FDF  39a703                            bsr.w   sub_FFF12386
FFF11FE2  6240                              add     #4, sp
FFF11FE4  058be3fd                          bsr.a   sub_FFEF036F
FFF11FE8  6701                              rtsd    #1
FFF11FEA  6701                   loc_FFF11FEA rtsd    #1
FFF11FEC  6040                   sub_FFF11FEC sub     #4, sp   ; <<<< FUNC sub_FFF11FEC
FFF11FEE  0551e0fd                          bsr.a   sub_FFEF003F
FFF11FF2  fbe2738f0000                      mov.l   #8F73h, r14
FFF11FF8  c3e1                              mov.b   r1, [r14]
FFF11FFA  fbe2738f0000                      mov.l   #8F73h, r14
