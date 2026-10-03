; ==== feat_b  FFF12000-FFF129C0  (file 312000-3129C0) ====
FFF12000  58ee                   sub_FFF12000 movu.b  [r14], r14   ; <<<< FUNC sub_FFF12000
FFF12002  755eff                            cmp     #-1, r14
FFF12005  1e                                bne.s   loc_FFF1200B
FFF12006  6601                              mov.l   #0, r1
FFF12008  396a00                            bsr.w   sub_FFF12072
FFF1200B  fbe2738f0000           loc_FFF1200B mov.l   #8F73h, r14
FFF12011  58ee                              movu.b  [r14], r14
FFF12013  755eff                            cmp     #-1, r14
FFF12016  2013                              beq.b   loc_FFF12029
FFF12018  fbe2738f0000                      mov.l   #8F73h, r14
FFF1201E  58ee                              movu.b  [r14], r14
FFF12020  755e23                            cmp     #23h, r14 ; '#'
FFF12023  2406                              bgtu.b  loc_FFF12029
FFF12025  f80601                            mov.l   #1, 0[sp]
FFF12028  0c                                bra.s   loc_FFF1202C
FFF12029  f80600                 loc_FFF12029 mov.l   #0, 0[sp]
FFF1202C  ec01                   loc_FFF1202C mov.l   0[sp], r1
FFF1202E  6101                              cmp     #0, r1
FFF12030  2029                              beq.b   loc_FFF12059
FFF12032  0552dbfd                          bsr.a   sub_FFEEFB84
FFF12036  6101                              cmp     #0, r1
FFF12038  2121                              bne.b   loc_FFF12059
FFF1203A  fbe2738f0000                      mov.l   #8F73h, r14
FFF12040  58e1                              movu.b  [r14], r1
FFF12042  05a8dffd                          bsr.a   sub_FFEEFFEA
FFF12046  fbe2738f0000                      mov.l   #8F73h, r14
FFF1204C  58ee                              movu.b  [r14], r14
FFF1204E  fbf2a87dedff                      mov.l   #off_FFED7DA8, r15
FFF12054  fe6efe                            mov.l   [r14, r15], r14
FFF12057  7f1e                              jsr     r14
FFF12059  fbe24c8c0000           loc_FFF12059 mov.l   #8C4Ch, r14
FFF1205F  58ee                              movu.b  [r14], r14
FFF12061  614e                              cmp     #4, r14
FFF12063  290d                              blt.b   loc_FFF12070
FFF12065  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1206B  f8e403                            mov.b   #3, [r14]
FFF1206E  6701                              rtsd    #1
FFF12070  6701                   loc_FFF12070 rtsd    #1
FFF12072  6040                   sub_FFF12072 sub     #4, sp   ; <<<< FUNC sub_FFF12072
FFF12074  8089                              mov.b   r1, 4+var_1[sp]
FFF12076  05f31ffe                          bsr.a   sub_FFEF4069
FFF1207A  391400                            bsr.w   sub_FFF1208E
FFF1207D  053d20fe                          bsr.a   sub_FFEF40BA
FFF12081  b089                              movu.b  4+var_1[sp], r1
FFF12083  6111                              cmp     #1, r1
FFF12085  1f                                bne.s   loc_FFF1208C
FFF12086  05a6dffd                          bsr.a   sub_FFEF002C
FFF1208A  6701                              rtsd    #1
FFF1208C  6701                   loc_FFF1208C rtsd    #1
FFF1208E  05b420fe               sub_FFF1208E bsr.a   sub_FFEF4142   ; <<<< FUNC sub_FFF1208E
FFF12092  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF12098  b219                              movu.b  9[r1], r1
FFF1209A  752110                            and     #10h, r1
FFF1209D  6841                              shlr    #4, r1
FFF1209F  fb22468e0000                      mov.l   #8E46h, r2
FFF120A5  b22a                              movu.b  9[r2], r2
FFF120A7  752210                            and     #10h, r2
FFF120AA  6842                              shlr    #4, r2
FFF120AC  4721                              cmp     r2, r1
FFF120AE  17                                beq.s   loc_FFF120B5
FFF120AF  6611                              mov.l   #1, r1
FFF120B1  05f3ddfd                          bsr.a   sub_FFEEFEA4
FFF120B5  fbe24d8c0000           loc_FFF120B5 mov.l   #8C4Dh, r14
FFF120BB  71ee20                            add     #20h, r14, r14 ; ' '
FFF120BE  fbf29cd30100                      mov.l   #1D39Ch, r15
FFF120C4  e3fe                              mov.l   r14, [r15]
FFF120C6  fb22468e0000                      mov.l   #8E46h, r2
FFF120CC  712220                            add     #20h, r2, r2 ; ' '
FFF120CF  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF120D5  711120                            add     #20h, r1, r1 ; ' '
FFF120D8  6633                              mov.l   #3, r3
FFF120DA  05cd21fe                          bsr.a   sub_FFEF42A7
FFF120DE  fb22468e0000                      mov.l   #8E46h, r2
FFF120E4  71226c                            add     #6Ch, r2, r2 ; 'l'
FFF120E7  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF120ED  71116c                            add     #6Ch, r1, r1 ; 'l'
FFF120F0  6624                              mov.l   #2, r4
FFF120F2  66a3                              mov.l   #0Ah, r3
FFF120F4  05e9fffd                          bsr.a   sub_FFEF20DD
FFF120F8  fb22468e0000                      mov.l   #8E46h, r2
FFF120FE  712276                            add     #76h, r2, r2 ; 'v'
FFF12101  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF12107  711176                            add     #76h, r1, r1 ; 'v'
FFF1210A  6624                              mov.l   #2, r4
FFF1210C  66a3                              mov.l   #0Ah, r3
FFF1210E  05cffffd                          bsr.a   sub_FFEF20DD
FFF12112  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF12118  59ee80                            movu.b  80h[r14], r14
FFF1211B  fbf2468e0000                      mov.l   #8E46h, r15
FFF12121  45fe80                            cmp     80h[r15], r14
FFF12124  2035                              beq.b   loc_FFF12159
FFF12126  fbe2468e0000                      mov.l   #8E46h, r14
FFF1212C  59ee80                            movu.b  80h[r14], r14
FFF1212F  612e                              cmp     #2, r14
FFF12131  1a                                bne.s   loc_FFF1213B
FFF12132  6602                              mov.l   #0, r2
FFF12134  6681                              mov.l   #8, r1
FFF12136  052de0fd                          bsr.a   sub_FFEF0163
FFF1213A  09                                bra.s   loc_FFF12143
FFF1213B  6602                   loc_FFF1213B mov.l   #0, r2
FFF1213D  6681                              mov.l   #8, r1
FFF1213F  055fe0fd                          bsr.a   sub_FFEF019E
FFF12143  6681                   loc_FFF12143 mov.l   #8, r1
FFF12145  05a9ddfd                          bsr.a   sub_FFEEFEEE
FFF12149  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1214F  fbf2468e0000                      mov.l   #8E46h, r15
FFF12155  c5fe8080                          mov.b   80h[r15], 80h[r14]
FFF12159  fbe24d8c0000           loc_FFF12159 mov.l   #8C4Dh, r14
FFF1215F  59ee81                            movu.b  81h[r14], r14
FFF12162  fbf2468e0000                      mov.l   #8E46h, r15
FFF12168  45fe81                            cmp     81h[r15], r14
FFF1216B  2018                              beq.b   loc_FFF12183
FFF1216D  6611                              mov.l   #1, r1
FFF1216F  057fddfd                          bsr.a   sub_FFEEFEEE
FFF12173  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF12179  fbf2468e0000                      mov.l   #8E46h, r15
FFF1217F  c5fe8181                          mov.b   81h[r15], 81h[r14]
FFF12183  fbe24d8c0000           loc_FFF12183 mov.l   #8C4Dh, r14
FFF12189  59ee82                            movu.b  82h[r14], r14
FFF1218C  fbf2468e0000                      mov.l   #8E46h, r15
FFF12192  45fe82                            cmp     82h[r15], r14
FFF12195  2018                              beq.b   loc_FFF121AD
FFF12197  6681                              mov.l   #8, r1
FFF12199  0555ddfd                          bsr.a   sub_FFEEFEEE
FFF1219D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF121A3  fbf2468e0000                      mov.l   #8E46h, r15
FFF121A9  c5fe8282                          mov.b   82h[r15], 82h[r14]
FFF121AD  fb22468e0000           loc_FFF121AD mov.l   #8E46h, r2
FFF121B3  72228300                          add     #83h, r2, r2
FFF121B7  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF121BD  72118300                          add     #83h, r1, r1
FFF121C1  6684                              mov.l   #8, r4
FFF121C3  754315                            mov.l   #15h, r3
FFF121C6  0517fffd                          bsr.a   sub_FFEF20DD
FFF121CA  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF121D0  b219                              movu.b  9[r1], r1
FFF121D2  fbe2468e0000                      mov.l   #8E46h, r14
FFF121D8  45e109                            cmp     9[r14], r1
FFF121DB  2012                              beq.b   loc_FFF121ED
FFF121DD  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF121E3  fbf2468e0000                      mov.l   #8E46h, r15
FFF121E9  c5fe0909                          mov.b   9[r15], 9[r14]
FFF121ED  05a7e0fd               loc_FFF121ED bsr.a   sub_FFEF0294
FFF121F1  02                                rts
FFF121F2  fbe2798d0000           sub_FFF121F2 mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF121F2
FFF121F8  f8e400                            mov.b   #0, [r14]
FFF121FB  6601                              mov.l   #0, r1
FFF121FD  ef12                              mov.l   r1, r2
FFF121FF  0509e2fd                          bsr.a   sub_FFEF0408
FFF12203  059c17fe                          bsr.a   sub_FFEF399F
FFF12207  6631                              mov.l   #3, r1
FFF12209  0552a1fd                          bsr.a   sub_FFEEC35B
FFF1220D  396500                            bsr.w   sub_FFF12272
FFF12210  7541ff                            mov.l   #-1, r1
FFF12213  0548a1fd                          bsr.a   sub_FFEEC35B
FFF12217  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF1221D  59e381                            movu.b  81h[r14], r3
FFF12220  75428f                            mov.l   #-71h, r2
FFF12223  6671                              mov.l   #7, r1
FFF12225  398000                            bsr.w   sub_FFF122A5
FFF12228  6040                              sub     #4, sp
FFF1222A  3c010a                            mov.b   #0Ah, 4+var_3[sp]
FFF1222D  f8040a                            mov.b   #0Ah, 4+var_4[sp]
FFF12230  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF12236  713476                            add     #76h, r3, r4 ; 'v'
FFF12239  71336c                            add     #6Ch, r3, r3 ; 'l'
FFF1223C  754256                            mov.l   #56h, r2 ; 'V'
FFF1223F  6621                              mov.l   #2, r1
FFF12241  398900                            bsr.w   sub_FFF122CA
FFF12244  6240                              add     #4, sp
FFF12246  75428a                            mov.l   #-76h, r2
FFF12249  754136                            mov.l   #36h, r1 ; '6'
FFF1224C  39e500                            bsr.w   sub_FFF12331
FFF1224F  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF12255  593e82                            movu.b  82h[r3], r14
FFF12258  6040                              sub     #4, sp
FFF1225A  c5308001                          mov.b   80h[r3], 4+var_3[sp]
FFF1225E  c30e                              mov.b   r14, 4+var_4[sp]
FFF12260  72338300                          add     #83h, r3, r3
FFF12264  754415                            mov.l   #15h, r4
FFF12267  7542be                            mov.l   #-42h, r2
FFF1226A  6621                              mov.l   #2, r1
FFF1226C  391a01                            bsr.w   sub_FFF12386
FFF1226F  6240                              add     #4, sp
FFF12271  02                                rts
FFF12272  6080                   sub_FFF12272 sub     #8, sp   ; <<<< FUNC sub_FFF12272
FFF12274  0549a1fd                          bsr.a   sub_FFEEC3BD
FFF12278  a009                              mov.l   r1, 8+var_4[sp]
FFF1227A  a809                              mov.l   8+var_4[sp], r1
FFF1227C  c41003                            mov.b   [r1], 8+var_5[sp]
FFF1227F  b089                              movu.b  8+var_5[sp], r1
FFF12281  6121                              cmp     #2, r1
FFF12283  210c                              bne.b   loc_FFF1228F
FFF12285  05113efe                          bsr.a   sub_FFEF6096
FFF12289  05af3bfe                          bsr.a   sub_FFEF5E38
FFF1228D  2e0e                              bra.b   loc_FFF1229B
FFF1228F  053f2dfe               loc_FFF1228F bsr.a   sub_FFEF4FCE
FFF12293  05033efe                          bsr.a   sub_FFEF6096
FFF12297  05a13bfe                          bsr.a   sub_FFEF5E38
FFF1229B  05883dfe               loc_FFF1229B bsr.a   sub_FFEF6023
FFF1229F  05de40fe                          bsr.a   sub_FFEF637D
FFF122A3  6702                              rtsd    #2
FFF122A5  6080                   sub_FFF122A5 sub     #8, sp   ; <<<< FUNC sub_FFF122A5
FFF122A7  9089                              mov.w   r1, 8+var_2[sp]
FFF122A9  9082                              mov.w   r2, 8+var_4[sp]
FFF122AB  808b                              mov.b   r3, 8+var_5[sp]
FFF122AD  3c0200                            mov.b   #0, 8+var_6[sp]
FFF122B0  b089                              movu.b  8+var_5[sp], r1
FFF122B2  6111                              cmp     #1, r1
FFF122B4  1c                                bne.s   loc_FFF122B8
FFF122B5  3c0201                            mov.b   #1, 8+var_6[sp]
FFF122B8  b083                   loc_FFF122B8 movu.b  8+var_6[sp], r3
FFF122BA  b882                              movu.w  8+var_4[sp], r2
FFF122BC  b889                              movu.w  8+var_2[sp], r1
FFF122BE  fb424c22edff                      mov.l   #unk_FFED224C, r4
FFF122C4  051146fe                          bsr.a   sub_FFEF68D5
FFF122C8  6702                              rtsd    #2
FFF122CA  7100f0                 sub_FFF122CA add     #-10h, sp, sp   ; <<<< FUNC sub_FFF122CA
FFF122CD  9189                              mov.w   r1, 10h+var_2[sp]
FFF122CF  9182                              mov.w   r2, 10h+var_4[sp]
FFF122D1  a083                              mov.l   r3, 10h+var_8[sp]
FFF122D3  a00c                              mov.l   r4, 10h+var_C[sp]
FFF122D5  c5001403                          mov.b   10h+arg_0[sp], 10h+var_D[sp]
FFF122D9  c5001502                          mov.b   10h+arg_1[sp], 10h+var_E[sp]
FFF122DD  b989                              movu.w  10h+var_2[sp], r1
FFF122DF  b982                              movu.w  10h+var_4[sp], r2
FFF122E1  fbea4001                          mov.l   #140h, r14
FFF122E5  431e                              sub     r1, r14
FFF122E7  5fe3                              movu.w  r14, r3
FFF122E9  754432                            mov.l   #32h, r4 ; '2'
FFF122EC  050be2fd                          bsr.a   sub_FFEF04F7
FFF122F0  3d0714                            mov.w   #14h, 10h+var_2[sp]
FFF122F3  3d0661                            mov.w   #61h, 10h+var_4[sp] ; 'a'
FFF122F6  a883                              mov.l   10h+var_8[sp], r3
FFF122F8  b08c                              movu.b  10h+var_D[sp], r4
FFF122FA  b982                              movu.w  10h+var_4[sp], r2
FFF122FC  b989                              movu.w  10h+var_2[sp], r1
FFF122FE  60c0                              sub     #0Ch, sp
FFF12300  a00b                              mov.l   r3, 1Ch+var_18[sp]
FFF12302  c304                              mov.b   r4, 1Ch+var_1C[sp]
FFF12304  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF12307  6604                              mov.l   #0, r4
FFF12309  66d3                              mov.l   #0Dh, r3
FFF1230B  0518f8fd                          bsr.a   sub_FFEF1B23
FFF1230F  62c0                              add     #0Ch, sp
FFF12311  3d07ae                            mov.w   #-52h, 10h+var_2[sp]
FFF12314  a80b                              mov.l   10h+var_C[sp], r3
FFF12316  b084                              movu.b  10h+var_E[sp], r4
FFF12318  b982                              movu.w  10h+var_4[sp], r2
FFF1231A  b989                              movu.w  10h+var_2[sp], r1
FFF1231C  60c0                              sub     #0Ch, sp
FFF1231E  a00b                              mov.l   r3, 1Ch+var_18[sp]
FFF12320  c304                              mov.b   r4, 1Ch+var_1C[sp]
FFF12322  3c0801                            mov.b   #1, 1Ch+var_14[sp]
FFF12325  6604                              mov.l   #0, r4
FFF12327  66d3                              mov.l   #0Dh, r3
FFF12329  05faf7fd                          bsr.a   sub_FFEF1B23
FFF1232D  62c0                              add     #0Ch, sp
FFF1232F  6704                              rtsd    #4
FFF12331  6040                   sub_FFF12331 sub     #4, sp   ; <<<< FUNC sub_FFF12331
FFF12333  9009                              mov.w   r1, 4+var_2[sp]
FFF12335  d302                              mov.w   r2, 4+var_4[sp]
FFF12337  b809                              movu.w  4+var_2[sp], r1
FFF12339  5c02                              movu.w  4+var_4[sp], r2
FFF1233B  fbea4001                          mov.l   #140h, r14
FFF1233F  431e                              sub     r1, r14
FFF12341  5fe3                              movu.w  r14, r3
FFF12343  754432                            mov.l   #32h, r4 ; '2'
FFF12346  05b1e1fd                          bsr.a   sub_FFEF04F7
FFF1234A  3d013a                            mov.w   #3Ah, 4+var_2[sp] ; ':'
FFF1234D  3d0090                            mov.w   #-70h, [sp]
FFF12350  5c02                              movu.w  4+var_4[sp], r2
FFF12352  b809                              movu.w  4+var_2[sp], r1
FFF12354  fb422c22edff                      mov.l   #unk_FFED222C, r4
FFF1235A  6613                              mov.l   #1, r3
FFF1235C  057945fe                          bsr.a   sub_FFEF68D5
FFF12360  3d0168                            mov.w   #68h, 4+var_2[sp] ; 'h'
FFF12363  3d0095                            mov.w   #-6Bh, [sp]
FFF12366  5c02                              movu.w  4+var_4[sp], r2
FFF12368  b809                              movu.w  4+var_2[sp], r1
FFF1236A  60c0                              sub     #0Ch, sp
FFF1236C  fb328ee8c3ff                      mov.l   #aSearchDirect, r3; "SEARCH & DIRECT"
FFF12372  a00b                              mov.l   r3, 10h+var_C[sp]
FFF12374  3c0801                            mov.b   #1, 10h+var_8[sp]
FFF12377  f80410                            mov.b   #10h, 10h+var_10[sp]
FFF1237A  6604                              mov.l   #0, r4
FFF1237C  66d3                              mov.l   #0Dh, r3
FFF1237E  05a5f7fd                          bsr.a   sub_FFEF1B23
FFF12382  62c0                              add     #0Ch, sp
FFF12384  6701                              rtsd    #1
FFF12386  7100e8                 sub_FFF12386 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12386
FFF12389  9289                              mov.w   r1, 18h+var_2[sp]
FFF1238B  9282                              mov.w   r2, 18h+var_4[sp]
FFF1238D  a103                              mov.l   r3, 18h+var_8[sp]
FFF1238F  838c                              mov.b   r4, 18h+var_9[sp]
FFF12391  c5001c0e                          mov.b   18h+arg_0[sp], 18h+var_A[sp]
FFF12395  c5001d0d                          mov.b   18h+arg_1[sp], 18h+var_B[sp]
FFF12399  3c0700                            mov.b   #0, 18h+var_11[sp]
FFF1239C  ba82                              movu.w  18h+var_4[sp], r2
FFF1239E  ba89                              movu.w  18h+var_2[sp], r1
FFF123A0  754ef0                            mov.l   #-10h, r14
FFF123A3  432e                              sub     r2, r14
FFF123A5  5fe4                              movu.w  r14, r4
FFF123A7  fbea4001                          mov.l   #140h, r14
FFF123AB  431e                              sub     r1, r14
FFF123AD  5fe3                              movu.w  r14, r3
FFF123AF  0548e1fd                          bsr.a   sub_FFEF04F7
FFF123B3  b309                              movu.b  18h+var_B[sp], r1
FFF123B5  6111                              cmp     #1, r1
FFF123B7  16                                beq.s   loc_FFF123BD
FFF123B8  b309                              movu.b  18h+var_B[sp], r1
FFF123BA  6121                              cmp     #2, r1
FFF123BC  1d                                bne.s   loc_FFF123C1
FFF123BD  f80601                 loc_FFF123BD mov.l   #1, 18h+var_18[sp]
FFF123C0  0c                                bra.s   loc_FFF123C4
FFF123C1  f80600                 loc_FFF123C1 mov.l   #0, 18h+var_18[sp]
FFF123C4  ec01                   loc_FFF123C4 mov.l   18h+var_18[sp], r1
FFF123C6  6101                              cmp     #0, r1
FFF123C8  206d                              beq.b   loc_FFF12435
FFF123CA  754432                            mov.l   #32h, r4 ; '2'
FFF123CD  fb3a3c01                          mov.l   #13Ch, r3
FFF123D1  7542be                            mov.l   #-42h, r2
FFF123D4  6621                              mov.l   #2, r1
FFF123D6  05428bfe                          bsr.a   sub_FFEFAF18
FFF123DA  3d0b06                            mov.w   #6, 18h+var_2[sp]
FFF123DD  3d0ac9                            mov.w   #-37h, 18h+var_4[sp]
FFF123E0  b381                              movu.b  18h+var_A[sp], r1
FFF123E2  6111                              cmp     #1, r1
FFF123E4  2112                              bne.b   loc_FFF123F6
FFF123E6  ba82                              movu.w  18h+var_4[sp], r2
FFF123E8  ba89                              movu.w  18h+var_2[sp], r1
FFF123EA  fb42ccfdecff                      mov.l   #unk_FFECFDCC, r4
FFF123F0  6613                              mov.l   #1, r3
FFF123F2  05e344fe                          bsr.a   sub_FFEF68D5
FFF123F6  3d0b14                 loc_FFF123F6 mov.w   #14h, 18h+var_2[sp]
FFF123F9  b309                              movu.b  18h+var_B[sp], r1
FFF123FB  6121                              cmp     #2, r1
FFF123FD  2112                              bne.b   loc_FFF1240F
FFF123FF  0566defd                          bsr.a   sub_FFEF0265
FFF12403  a081                              mov.l   r1, 18h+var_10[sp]
FFF12405  a881                              mov.l   18h+var_10[sp], r1
FFF12407  755111                            cmp     #11h, r1
FFF1240A  18                                bne.s   loc_FFF12412
FFF1240B  3c0701                            mov.b   #1, 18h+var_11[sp]
FFF1240E  0c                                bra.s   loc_FFF12412
FFF1240F  3c0701                 loc_FFF1240F mov.b   #1, 18h+var_11[sp]
FFF12412  b189                   loc_FFF12412 movu.b  18h+var_11[sp], r1
FFF12414  6101                              cmp     #0, r1
FFF12416  201f                              beq.b   loc_FFF12435
FFF12418  a903                              mov.l   18h+var_8[sp], r3
FFF1241A  b38c                              movu.b  18h+var_9[sp], r4
FFF1241C  ba82                              movu.w  18h+var_4[sp], r2
FFF1241E  ba89                              movu.w  18h+var_2[sp], r1
FFF12420  60c0                              sub     #0Ch, sp
FFF12422  a00b                              mov.l   r3, 24h+var_20[sp]
FFF12424  c304                              mov.b   r4, 24h+var_24[sp]
FFF12426  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF12429  6604                              mov.l   #0, r4
FFF1242B  66d3                              mov.l   #0Dh, r3
FFF1242D  05f6f6fd                          bsr.a   sub_FFEF1B23
FFF12431  62c0                              add     #0Ch, sp
FFF12433  6706                              rtsd    #6
FFF12435  6706                   loc_FFF12435 rtsd    #6
FFF12437  6080                   sub_FFF12437 sub     #8, sp   ; <<<< FUNC sub_FFF12437
FFF12439  9089                              mov.w   r1, 8+var_2[sp]
FFF1243B  9082                              mov.w   r2, 8+var_4[sp]
FFF1243D  900b                              mov.w   r3, 8+var_6[sp]
FFF1243F  d304                              mov.w   r4, 8+var_8[sp]
FFF12441  5c01                              movu.w  8+var_8[sp], r1
FFF12443  b80a                              movu.w  8+var_6[sp], r2
FFF12445  b885                              movu.w  8+var_4[sp], r5
FFF12447  5d0f03                            movu.w  8+var_2[sp], r15
FFF1244A  6040                              sub     #4, sp
FFF1244C  f809692a                          mov.w   #2A69h, 0Ch+var_C[sp]
FFF12450  6021                              sub     #2, r1
FFF12452  5f14                              movu.w  r1, r4
FFF12454  6022                              sub     #2, r2
FFF12456  5f23                              movu.w  r2, r3
FFF12458  6215                              add     #1, r5
FFF1245A  5f52                              movu.w  r5, r2
FFF1245C  621f                              add     #1, r15
FFF1245E  5ff1                              movu.w  r15, r1
FFF12460  05e8f7fd                          bsr.a   sub_FFEF1C48
FFF12464  6240                              add     #4, sp
FFF12466  b809                              movu.w  8+var_6[sp], r1
FFF12468  b882                              movu.w  8+var_4[sp], r2
FFF1246A  b88c                              movu.w  8+var_2[sp], r4
FFF1246C  6040                              sub     #4, sp
FFF1246E  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF12472  6041                              sub     #4, r1
FFF12474  5f13                              movu.w  r1, r3
FFF12476  6224                              add     #2, r4
FFF12478  5f41                              movu.w  r4, r1
FFF1247A  6614                              mov.l   #1, r4
FFF1247C  05ccf7fd                          bsr.a   sub_FFEF1C48
FFF12480  6240                              add     #4, sp
FFF12482  b882                              movu.w  8+var_4[sp], r2
FFF12484  06c802                            add     [sp].uw, r2
FFF12487  b809                              movu.w  8+var_6[sp], r1
FFF12489  b88c                              movu.w  8+var_2[sp], r4
FFF1248B  6040                              sub     #4, sp
FFF1248D  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF12491  6041                              sub     #4, r1
FFF12493  5f13                              movu.w  r1, r3
FFF12495  6224                              add     #2, r4
FFF12497  5f41                              movu.w  r4, r1
FFF12499  6012                              sub     #1, r2
FFF1249B  5f22                              movu.w  r2, r2
FFF1249D  6614                              mov.l   #1, r4
FFF1249F  05a9f7fd                          bsr.a   sub_FFEF1C48
FFF124A3  6240                              add     #4, sp
FFF124A5  5c02                              movu.w  8+var_8[sp], r2
FFF124A7  b883                              movu.w  8+var_4[sp], r3
FFF124A9  b889                              movu.w  8+var_2[sp], r1
FFF124AB  6040                              sub     #4, sp
FFF124AD  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF124B1  6042                              sub     #4, r2
FFF124B3  5f24                              movu.w  r2, r4
FFF124B5  6223                              add     #2, r3
FFF124B7  5f32                              movu.w  r3, r2
FFF124B9  6613                              mov.l   #1, r3
FFF124BB  058df7fd                          bsr.a   sub_FFEF1C48
FFF124BF  6240                              add     #4, sp
FFF124C1  b889                              movu.w  8+var_2[sp], r1
FFF124C3  06c90101                          add     8+var_6[sp].uw, r1
FFF124C7  5c02                              movu.w  8+var_8[sp], r2
FFF124C9  b883                              movu.w  8+var_4[sp], r3
FFF124CB  6040                              sub     #4, sp
FFF124CD  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF124D1  6042                              sub     #4, r2
FFF124D3  5f24                              movu.w  r2, r4
FFF124D5  6223                              add     #2, r3
FFF124D7  5f32                              movu.w  r3, r2
FFF124D9  6011                              sub     #1, r1
FFF124DB  5f11                              movu.w  r1, r1
FFF124DD  6613                              mov.l   #1, r3
FFF124DF  0569f7fd                          bsr.a   sub_FFEF1C48
FFF124E3  6240                              add     #4, sp
FFF124E5  b881                              movu.w  8+var_4[sp], r1
FFF124E7  b88b                              movu.w  8+var_2[sp], r3
FFF124E9  6040                              sub     #4, sp
FFF124EB  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF124EF  6211                              add     #1, r1
FFF124F1  5f12                              movu.w  r1, r2
FFF124F3  6213                              add     #1, r3
FFF124F5  5f31                              movu.w  r3, r1
FFF124F7  6613                              mov.l   #1, r3
FFF124F9  ef34                              mov.l   r3, r4
FFF124FB  054df7fd                          bsr.a   sub_FFEF1C48
FFF124FF  6240                              add     #4, sp
FFF12501  b882                              movu.w  8+var_4[sp], r2
FFF12503  06c802                            add     [sp].uw, r2
FFF12506  b889                              movu.w  8+var_2[sp], r1
FFF12508  6040                              sub     #4, sp
FFF1250A  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF1250E  6211                              add     #1, r1
FFF12510  5f11                              movu.w  r1, r1
FFF12512  6022                              sub     #2, r2
FFF12514  5f22                              movu.w  r2, r2
FFF12516  6613                              mov.l   #1, r3
FFF12518  ef34                              mov.l   r3, r4
FFF1251A  052ef7fd                          bsr.a   sub_FFEF1C48
FFF1251E  6240                              add     #4, sp
FFF12520  b889                              movu.w  8+var_2[sp], r1
FFF12522  06c90101                          add     8+var_6[sp].uw, r1
FFF12526  b882                              movu.w  8+var_4[sp], r2
FFF12528  6040                              sub     #4, sp
FFF1252A  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF1252E  6212                              add     #1, r2
FFF12530  5f22                              movu.w  r2, r2
FFF12532  6021                              sub     #2, r1
FFF12534  5f11                              movu.w  r1, r1
FFF12536  6613                              mov.l   #1, r3
FFF12538  ef34                              mov.l   r3, r4
FFF1253A  050ef7fd                          bsr.a   sub_FFEF1C48
FFF1253E  6240                              add     #4, sp
FFF12540  b881                              movu.w  8+var_4[sp], r1
FFF12542  06c801                            add     [sp].uw, r1
FFF12545  b88b                              movu.w  8+var_2[sp], r3
FFF12547  06c90301                          add     8+var_6[sp].uw, r3
FFF1254B  6040                              sub     #4, sp
FFF1254D  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF12551  6021                              sub     #2, r1
FFF12553  5f12                              movu.w  r1, r2
FFF12555  6023                              sub     #2, r3
FFF12557  5f31                              movu.w  r3, r1
FFF12559  6613                              mov.l   #1, r3
FFF1255B  ef34                              mov.l   r3, r4
FFF1255D  05ebf6fd                          bsr.a   sub_FFEF1C48
FFF12561  6240                              add     #4, sp
FFF12563  6702                              rtsd    #2
FFF12565  fbe24c8c0000           sub_FFF12565 mov.l   #8C4Ch, r14   ; <<<< FUNC sub_FFF12565
FFF1256B  58ee                              movu.b  [r14], r14
FFF1256D  613e                              cmp     #3, r14
FFF1256F  2a16                              bgt.b   loc_FFF12585
FFF12571  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF12577  58ee                              movu.b  [r14], r14
FFF12579  fbf2387eedff                      mov.l   #off_FFED7E38, r15
FFF1257F  fe6efe                            mov.l   [r14, r15], r14
FFF12582  7f1e                              jsr     r14
FFF12584  02                                rts
FFF12585  fbe24c8c0000           loc_FFF12585 mov.l   #8C4Ch, r14
FFF1258B  f8e403                            mov.b   #3, [r14]
FFF1258E  02                                rts
FFF1258F  6611                   sub_FFF1258F mov.l   #1, r1   ; <<<< FUNC sub_FFF1258F
FFF12591  39d102                            bsr.w   sub_FFF12862
FFF12594  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1259A  58ef                              movu.b  [r14], r15
FFF1259C  621f                              add     #1, r15
FFF1259E  c3ef                              mov.b   r15, [r14]
FFF125A0  02                                rts
FFF125A1  6080                   sub_FFF125A1 sub     #8, sp   ; <<<< FUNC sub_FFF125A1
FFF125A3  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF125A9  c5e03702                          mov.b   37h[r14], 8+var_6[sp]
FFF125AD  0580ddfd                          bsr.a   sub_FFEF032D
FFF125B1  059681fe                          bsr.a   sub_FFEFA747
FFF125B5  3d0302                            mov.w   #2, 8+var_2[sp]
FFF125B8  3d0204                            mov.w   #4, 8+var_4[sp]
FFF125BB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF125C1  59ee3a                            movu.b  3Ah[r14], r14
FFF125C4  610e                              cmp     #0, r14
FFF125C6  9881                              mov.w   8+var_4[sp], r1
FFF125C8  988b                              mov.w   8+var_2[sp], r3
FFF125CA  2114                              bne.b   loc_FFF125DE
FFF125CC  5f12                              movu.w  r1, r2
FFF125CE  5f31                              movu.w  r3, r1
FFF125D0  fb42dc22edff                      mov.l   #unk_FFED22DC, r4
FFF125D6  6613                              mov.l   #1, r3
FFF125D8  05fd42fe                          bsr.a   sub_FFEF68D5
FFF125DC  2e16                              bra.b   loc_FFF125F2
FFF125DE  5f1e                   loc_FFF125DE movu.w  r1, r14
FFF125E0  621e                              add     #1, r14
FFF125E2  5fe2                              movu.w  r14, r2
FFF125E4  5f31                              movu.w  r3, r1
FFF125E6  fb425c20edff                      mov.l   #unk_FFED205C, r4
FFF125EC  6613                              mov.l   #1, r3
FFF125EE  05e742fe                          bsr.a   sub_FFEF68D5
FFF125F2  3d0330                 loc_FFF125F2 mov.w   #30h, 8+var_2[sp] ; '0'
FFF125F5  3d0202                            mov.w   #2, 8+var_4[sp]
FFF125F8  b882                              movu.w  8+var_4[sp], r2
FFF125FA  b889                              movu.w  8+var_2[sp], r1
FFF125FC  60c0                              sub     #0Ch, sp
FFF125FE  fb324d8c0000                      mov.l   #8C4Dh, r3
FFF12604  713320                            add     #20h, r3, r3 ; ' '
FFF12607  a00b                              mov.l   r3, 14h+var_10[sp]
FFF12609  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF1260C  f80413                            mov.b   #13h, 14h+var_14[sp]
FFF1260F  6604                              mov.l   #0, r4
FFF12611  66d3                              mov.l   #0Dh, r3
FFF12613  0510f5fd                          bsr.a   sub_FFEF1B23
FFF12617  62c0                              add     #0Ch, sp
FFF12619  3d0332                            mov.w   #32h, 8+var_2[sp] ; '2'
FFF1261C  3d0222                            mov.w   #22h, 8+var_4[sp] ; '"'
FFF1261F  fb12647aedff                      mov.l   #off_FFED7A64, r1
FFF12625  a914                              mov.l   10h[r1], r4
FFF12627  b882                              movu.w  8+var_4[sp], r2
FFF12629  b889                              movu.w  8+var_2[sp], r1
FFF1262B  6613                              mov.l   #1, r3
FFF1262D  05a842fe                          bsr.a   sub_FFEF68D5
FFF12631  3d035a                            mov.w   #5Ah, 8+var_2[sp] ; 'Z'
FFF12634  3d0220                            mov.w   #20h, 8+var_4[sp] ; ' '
FFF12637  b882                              movu.w  8+var_4[sp], r2
FFF12639  b889                              movu.w  8+var_2[sp], r1
FFF1263B  60c0                              sub     #0Ch, sp
FFF1263D  fb32647aedff                      mov.l   #off_FFED7A64, r3
FFF12643  713314                            add     #14h, r3, r3
FFF12646  a00b                              mov.l   r3, 14h+var_10[sp]
FFF12648  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF1264B  f8040c                            mov.b   #0Ch, 14h+var_14[sp]
FFF1264E  6604                              mov.l   #0, r4
FFF12650  66d3                              mov.l   #0Dh, r3
FFF12652  05d1f4fd                          bsr.a   sub_FFEF1B23
FFF12656  62c0                              add     #0Ch, sp
FFF12658  3d0330                            mov.w   #30h, 8+var_2[sp] ; '0'
FFF1265B  3d023e                            mov.w   #3Eh, 8+var_4[sp] ; '>'
FFF1265E  b081                              movu.b  8+var_6[sp], r1
FFF12660  6101                              cmp     #0, r1
FFF12662  1d                                bne.s   loc_FFF12667
FFF12663  3c0306                            mov.b   #6, 8+var_5[sp]
FFF12666  0c                                bra.s   loc_FFF1266A
FFF12667  3c0308                 loc_FFF12667 mov.b   #8, 8+var_5[sp]
FFF1266A  b882                   loc_FFF1266A movu.w  8+var_4[sp], r2
FFF1266C  b889                              movu.w  8+var_2[sp], r1
FFF1266E  60c0                              sub     #0Ch, sp
FFF12670  fb3254adf4ff                      mov.l   #unk_FFF4AD54, r3
FFF12676  a00b                              mov.l   r3, 14h+var_10[sp]
FFF12678  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF1267B  f80403                            mov.b   #3, 14h+var_14[sp]
FFF1267E  6604                              mov.l   #0, r4
FFF12680  66d3                              mov.l   #0Dh, r3
FFF12682  05a1f4fd                          bsr.a   sub_FFEF1B23
FFF12686  62c0                              add     #0Ch, sp
FFF12688  b889                              movu.w  8+var_2[sp], r1
FFF1268A  71112a                            add     #2Ah, r1, r1 ; '*'
FFF1268D  9089                              mov.w   r1, 8+var_2[sp]
FFF1268F  b083                              movu.b  8+var_6[sp], r3
FFF12691  b08c                              movu.b  8+var_5[sp], r4
FFF12693  b882                              movu.w  8+var_4[sp], r2
FFF12695  b889                              movu.w  8+var_2[sp], r1
FFF12697  60c0                              sub     #0Ch, sp
FFF12699  6393                              mul     #9, r3
FFF1269B  fb527ce8c3ff                      mov.l   #aUpload, r5; "UPLOAD  "
FFF126A1  4b35                              add     r3, r5
FFF126A3  a00d                              mov.l   r5, 14h+var_10[sp]
FFF126A5  c304                              mov.b   r4, 14h+var_14[sp]
FFF126A7  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF126AA  6604                              mov.l   #0, r4
FFF126AC  66d3                              mov.l   #0Dh, r3
FFF126AE  0575f4fd                          bsr.a   sub_FFEF1B23
FFF126B2  62c0                              add     #0Ch, sp
FFF126B4  b089                              movu.b  8+var_5[sp], r1
FFF126B6  63e1                              mul     #0Eh, r1
FFF126B8  06c90103                          add     8+var_2[sp].uw, r1
FFF126BC  9089                              mov.w   r1, 8+var_2[sp]
FFF126BE  b882                              movu.w  8+var_4[sp], r2
FFF126C0  b889                              movu.w  8+var_2[sp], r1
FFF126C2  60c0                              sub     #0Ch, sp
FFF126C4  fb3254adf4ff                      mov.l   #unk_FFF4AD54, r3
FFF126CA  a00b                              mov.l   r3, 14h+var_10[sp]
FFF126CC  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF126CF  f80403                            mov.b   #3, 14h+var_14[sp]
FFF126D2  6604                              mov.l   #0, r4
FFF126D4  66d3                              mov.l   #0Dh, r3
FFF126D6  054df4fd                          bsr.a   sub_FFEF1B23
FFF126DA  62c0                              add     #0Ch, sp
FFF126DC  3d021e                            mov.w   #1Eh, 8+var_4[sp]
FFF126DF  3c0300                            mov.b   #0, 8+var_5[sp]
FFF126E2  2e17                              bra.b   loc_FFF126F9
FFF126E4  b881                   loc_FFF126E4 movu.w  8+var_4[sp], r1
FFF126E6  6602                              mov.l   #0, r2
FFF126E8  0586d8ff                          bsr.a   sub_FFF0FF6E
FFF126EC  b881                              movu.w  8+var_4[sp], r1
FFF126EE  71111e                            add     #1Eh, r1, r1
FFF126F1  9081                              mov.w   r1, 8+var_4[sp]
FFF126F3  b089                              movu.b  8+var_5[sp], r1
FFF126F5  6211                              add     #1, r1
FFF126F7  8089                              mov.b   r1, 8+var_5[sp]
FFF126F9  b089                   loc_FFF126F9 movu.b  8+var_5[sp], r1
FFF126FB  6161                              cmp     #6, r1
FFF126FD  29e7                              blt.b   loc_FFF126E4
FFF126FF  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF12705  58ef                              movu.b  [r14], r15
FFF12707  621f                              add     #1, r15
FFF12709  c3ef                              mov.b   r15, [r14]
FFF1270B  6702                              rtsd    #2
FFF1270D  6040                   sub_FFF1270D sub     #4, sp   ; <<<< FUNC sub_FFF1270D
FFF1270F  6040                              sub     #4, sp
FFF12711  3d00f0                            mov.w   #-10h, [sp]
FFF12714  fb4a4001                          mov.l   #140h, r4
FFF12718  6602                              mov.l   #0, r2
FFF1271A  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF12720  ef23                              mov.l   r2, r3
FFF12722  0599d2fd                          bsr.a   sub_FFEEF9BB
FFF12726  6240                              add     #4, sp
FFF12728  8089                              mov.b   r1, 4+var_1[sp]
FFF1272A  b089                              movu.b  4+var_1[sp], r1
FFF1272C  6111                              cmp     #1, r1
FFF1272E  1a                                bne.s   loc_FFF12738
FFF1272F  395002                            bsr.w   sub_FFF1297F
FFF12732  053ddcfd                          bsr.a   sub_FFEF036F
FFF12736  6701                              rtsd    #1
FFF12738  6701                   loc_FFF12738 rtsd    #1
FFF1273A  6040                   sub_FFF1273A sub     #4, sp   ; <<<< FUNC sub_FFF1273A
FFF1273C  6040                              sub     #4, sp
FFF1273E  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF12741  fb4a4001                          mov.l   #140h, r4
FFF12745  75435a                            mov.l   #5Ah, r3 ; 'Z'
FFF12748  6602                              mov.l   #0, r2
FFF1274A  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF12750  056bd2fd                          bsr.a   sub_FFEEF9BB
FFF12754  6240                              add     #4, sp
FFF12756  8089                              mov.b   r1, 4+var_1[sp]
FFF12758  b089                              movu.b  4+var_1[sp], r1
FFF1275A  6111                              cmp     #1, r1
FFF1275C  2112                              bne.b   loc_FFF1276E
FFF1275E  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF12761  6601                              mov.l   #0, r1
FFF12763  ef13                              mov.l   r1, r3
FFF12765  394a02                            bsr.w   loc_FFF129AF
FFF12768  0507dcfd                          bsr.a   sub_FFEF036F
FFF1276C  6701                              rtsd    #1
FFF1276E  6701                   loc_FFF1276E rtsd    #1
FFF12770  6040                   sub_FFF12770 sub     #4, sp   ; <<<< FUNC sub_FFF12770
FFF12772  6040                              sub     #4, sp
FFF12774  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF12777  fb4a4001                          mov.l   #140h, r4
FFF1277B  754378                            mov.l   #78h, r3 ; 'x'
FFF1277E  6602                              mov.l   #0, r2
FFF12780  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF12786  0535d2fd                          bsr.a   sub_FFEEF9BB
FFF1278A  6240                              add     #4, sp
FFF1278C  8089                              mov.b   r1, 4+var_1[sp]
FFF1278E  b089                              movu.b  4+var_1[sp], r1
FFF12790  6111                              cmp     #1, r1
FFF12792  2112                              bne.b   loc_FFF127A4
FFF12794  6613                              mov.l   #1, r3
FFF12796  754278                            mov.l   #78h, r2 ; 'x'
FFF12799  6601                              mov.l   #0, r1
FFF1279B  391402                            bsr.w   loc_FFF129AF
FFF1279E  05d1dbfd                          bsr.a   sub_FFEF036F
FFF127A2  6701                              rtsd    #1
FFF127A4  6701                   loc_FFF127A4 rtsd    #1
FFF127A6  6040                   sub_FFF127A6 sub     #4, sp   ; <<<< FUNC sub_FFF127A6
FFF127A8  6040                              sub     #4, sp
FFF127AA  f8051f                            mov.w   #1Fh, 8+var_8[sp]
FFF127AD  fb4a4001                          mov.l   #140h, r4
FFF127B1  754396                            mov.l   #-6Ah, r3
FFF127B4  6602                              mov.l   #0, r2
FFF127B6  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF127BC  05ffd1fd                          bsr.a   sub_FFEEF9BB
FFF127C0  6240                              add     #4, sp
FFF127C2  8089                              mov.b   r1, 4+var_1[sp]
FFF127C4  b089                              movu.b  4+var_1[sp], r1
FFF127C6  6111                              cmp     #1, r1
FFF127C8  2112                              bne.b   loc_FFF127DA
FFF127CA  6623                              mov.l   #2, r3
FFF127CC  754296                            mov.l   #-6Ah, r2
FFF127CF  6601                              mov.l   #0, r1
FFF127D1  39de01                            bsr.w   loc_FFF129AF
FFF127D4  059bdbfd                          bsr.a   sub_FFEF036F
FFF127D8  6701                              rtsd    #1
FFF127DA  6701                   loc_FFF127DA rtsd    #1
FFF127DC  6040                   sub_FFF127DC sub     #4, sp   ; <<<< FUNC sub_FFF127DC
FFF127DE  0561d8fd                          bsr.a   sub_FFEF003F
FFF127E2  fbe2738f0000                      mov.l   #8F73h, r14
FFF127E8  c3e1                              mov.b   r1, [r14]
FFF127EA  fbe2738f0000                      mov.l   #8F73h, r14
FFF127F0  58ee                              movu.b  [r14], r14
FFF127F2  755eff                            cmp     #-1, r14
FFF127F5  1e                                bne.s   loc_FFF127FB
FFF127F6  6601                              mov.l   #0, r1
FFF127F8  396a00                            bsr.w   sub_FFF12862
FFF127FB  fbe2738f0000           loc_FFF127FB mov.l   #8F73h, r14
FFF12801  58ee                              movu.b  [r14], r14
FFF12803  755eff                            cmp     #-1, r14
FFF12806  2013                              beq.b   loc_FFF12819
FFF12808  fbe2738f0000                      mov.l   #8F73h, r14
FFF1280E  58ee                              movu.b  [r14], r14
FFF12810  755e11                            cmp     #11h, r14
FFF12813  2406                              bgtu.b  loc_FFF12819
FFF12815  f80601                            mov.l   #1, 4+var_4[sp]
FFF12818  0c                                bra.s   loc_FFF1281C
FFF12819  f80600                 loc_FFF12819 mov.l   #0, 4+var_4[sp]
FFF1281C  ec01                   loc_FFF1281C mov.l   4+var_4[sp], r1
FFF1281E  6101                              cmp     #0, r1
FFF12820  2029                              beq.b   loc_FFF12849
FFF12822  0562d3fd                          bsr.a   sub_FFEEFB84
FFF12826  6101                              cmp     #0, r1
FFF12828  2121                              bne.b   loc_FFF12849
FFF1282A  fbe2738f0000                      mov.l   #8F73h, r14
FFF12830  58e1                              movu.b  [r14], r1
FFF12832  05b8d7fd                          bsr.a   sub_FFEEFFEA
FFF12836  fbe2738f0000                      mov.l   #8F73h, r14
FFF1283C  58ee                              movu.b  [r14], r14
FFF1283E  fbf2487eedff                      mov.l   #off_FFED7E48, r15
FFF12844  fe6efe                            mov.l   [r14, r15], r14
FFF12847  7f1e                              jsr     r14
FFF12849  fbe24c8c0000           loc_FFF12849 mov.l   #8C4Ch, r14
FFF1284F  58ee                              movu.b  [r14], r14
FFF12851  614e                              cmp     #4, r14
FFF12853  290d                              blt.b   loc_FFF12860
FFF12855  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF1285B  f8e403                            mov.b   #3, [r14]
FFF1285E  6701                              rtsd    #1
FFF12860  6701                   loc_FFF12860 rtsd    #1
FFF12862  6040                   sub_FFF12862 sub     #4, sp   ; <<<< FUNC sub_FFF12862
FFF12864  8089                              mov.b   r1, 4+var_1[sp]
FFF12866  050318fe                          bsr.a   sub_FFEF4069
FFF1286A  391400                            bsr.w   sub_FFF1287E
FFF1286D  054d18fe                          bsr.a   sub_FFEF40BA
FFF12871  b089                              movu.b  4+var_1[sp], r1
FFF12873  6111                              cmp     #1, r1
FFF12875  1f                                bne.s   loc_FFF1287C
FFF12876  05b6d7fd                          bsr.a   sub_FFEF002C
FFF1287A  6701                              rtsd    #1
FFF1287C  6701                   loc_FFF1287C rtsd    #1
FFF1287E  fb22468e0000           sub_FFF1287E mov.l   #8E46h, r2   ; <<<< FUNC sub_FFF1287E
FFF12884  71223a                            add     #3Ah, r2, r2 ; ':'
FFF12887  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF1288D  71113a                            add     #3Ah, r1, r1 ; ':'
FFF12890  6613                              mov.l   #1, r3
FFF12892  ef34                              mov.l   r3, r4
FFF12894  05f9f7fd                          bsr.a   sub_FFEF208D
FFF12898  fb22468e0000                      mov.l   #8E46h, r2
FFF1289E  712220                            add     #20h, r2, r2 ; ' '
FFF128A1  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF128A7  711120                            add     #20h, r1, r1 ; ' '
FFF128AA  6614                              mov.l   #1, r4
FFF128AC  754317                            mov.l   #17h, r3
FFF128AF  05def7fd                          bsr.a   sub_FFEF208D
FFF128B3  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF128B9  59ee37                            movu.b  37h[r14], r14
FFF128BC  fbf2468e0000                      mov.l   #8E46h, r15
FFF128C2  45fe37                            cmp     37h[r15], r14
FFF128C5  201c                              beq.b   loc_FFF128E1
FFF128C7  6611                              mov.l   #1, r1
FFF128C9  05dbd5fd                          bsr.a   sub_FFEEFEA4
FFF128CD  fbe2468e0000                      mov.l   #8E46h, r14
FFF128D3  59ee37                            movu.b  37h[r14], r14
FFF128D6  641e                              and     #1, r14
FFF128D8  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF128DE  c7fe37                            mov.b   r14, 37h[r15]
FFF128E1  fbe2468e0000           loc_FFF128E1 mov.l   #8E46h, r14
FFF128E7  59ef38                            movu.b  38h[r14], r15
FFF128EA  eff5                              mov.l   r15, r5
FFF128EC  fd749503                          divu    #3, r5
FFF128F0  6335                              mul     #3, r5
FFF128F2  435f                              sub     r5, r15
FFF128F4  c7ef38                            mov.b   r15, 38h[r14]
FFF128F7  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF128FD  59ee38                            movu.b  38h[r14], r14
FFF12900  fbf2468e0000                      mov.l   #8E46h, r15
FFF12906  45fe38                            cmp     38h[r15], r14
FFF12909  2037                              beq.b   loc_FFF12940
FFF1290B  fbe2468e0000                      mov.l   #8E46h, r14
FFF12911  59ee38                            movu.b  38h[r14], r14
FFF12914  fbf24d8c0000                      mov.l   #8C4Dh, r15
FFF1291A  59ff38                            movu.b  38h[r15], r15
FFF1291D  fb5e008000                        mov.l   #8000h, r5
FFF12922  ef51                              mov.l   r5, r1
FFF12924  fd62f1                            shll    r15, r1
FFF12927  fd62e5                            shll    r14, r5
FFF1292A  5751                              or      r5, r1
FFF1292C  0578d5fd                          bsr.a   sub_FFEEFEA4
FFF12930  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF12936  fbf2468e0000                      mov.l   #8E46h, r15
FFF1293C  c5fe3838                          mov.b   38h[r15], 38h[r14]
FFF12940  fb12468e0000           loc_FFF12940 mov.l   #8E46h, r1
FFF12946  b499                              movu.b  13h[r1], r1
FFF12948  755120                            cmp     #20h, r1 ; ' '
FFF1294B  212f                              bne.b   loc_FFF1297A
FFF1294D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF12953  59ee39                            movu.b  39h[r14], r14
FFF12956  fbf2468e0000                      mov.l   #8E46h, r15
FFF1295C  45fe39                            cmp     39h[r15], r14
FFF1295F  201b                              beq.b   loc_FFF1297A
FFF12961  fbe27a8d0000                      mov.l   #8D7Ah, r14
FFF12967  f8e401                            mov.b   #1, [r14]
FFF1296A  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF12970  fbf2468e0000                      mov.l   #8E46h, r15
FFF12976  c5fe3939                          mov.b   39h[r15], 39h[r14]
FFF1297A  051ad9fd               loc_FFF1297A bsr.a   sub_FFEF0294
FFF1297E  02                                rts
FFF1297F  fbe2798d0000           sub_FFF1297F mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF1297F
FFF12985  f8e400                            mov.b   #0, [r14]
FFF12988  6601                              mov.l   #0, r1
FFF1298A  ef12                              mov.l   r1, r2
FFF1298C  057cdafd                          bsr.a   sub_FFEF0408
FFF12990  75425a                            mov.l   #5Ah, r2 ; 'Z'
FFF12993  6601                              mov.l   #0, r1
FFF12995  ef13                              mov.l   r1, r3
FFF12997  391800                            bsr.w   loc_FFF129AF
FFF1299A  6613                              mov.l   #1, r3
FFF1299C  754278                            mov.l   #78h, r2 ; 'x'
FFF1299F  6601                              mov.l   #0, r1
FFF129A1  390e00                            bsr.w   loc_FFF129AF
FFF129A4  6623                              mov.l   #2, r3
FFF129A6  754296                            mov.l   #-6Ah, r2
FFF129A9  6601                              mov.l   #0, r1
FFF129AB  390400                            bsr.w   loc_FFF129AF
FFF129AE  02                                rts
FFF129AF  7100ec                 loc_FFF129AF add     #-14h, sp, sp
FFF129B2  9209                              mov.w   r1, 12h[sp]
FFF129B4  9202                              mov.w   r2, 10h[sp]
FFF129B6  838b                              mov.b   r3, 0Fh[sp]
FFF129B8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF129BE  c5e03803                          mov.b   38h[r14], 3[sp]
