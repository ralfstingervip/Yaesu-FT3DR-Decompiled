; ==== feat_a  FFF40100-FFF40B00  (file 340100-340B00) ====
FFF40100  00                                brk
FFF40101  00                                brk
FFF40102  4b1f                              add     r1, r15
FFF40104  c5fe7f7f                          mov.b   7Fh[r15], 7Fh[r14]
FFF40108  b009                              movu.b  14h+var_13[sp], r1
FFF4010A  6211                              add     #1, r1
FFF4010C  8009                              mov.b   r1, 14h+var_13[sp]
FFF4010E  3c0200                 loc_FFF4010E mov.b   #0, 14h+var_12[sp]
FFF40111  2e4e                              bra.b   loc_FFF4015F
FFF40113  b089                   loc_FFF40113 movu.b  14h+var_11[sp], r1
FFF40115  6361                              mul     #6, r1
FFF40117  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4011D  4b1e                              add     r1, r14
FFF4011F  b082                              movu.b  14h+var_12[sp], r2
FFF40121  4b2e                              add     r2, r14
FFF40123  59ee80                            movu.b  80h[r14], r14
FFF40126  fbf2468e0000                      mov.l   #8E46h, r15
FFF4012C  4b1f                              add     r1, r15
FFF4012E  4b2f                              add     r2, r15
FFF40130  45fe80                            cmp     80h[r15], r14
FFF40133  2026                              beq.b   loc_FFF40159
FFF40135  b089                              movu.b  14h+var_11[sp], r1
FFF40137  6361                              mul     #6, r1
FFF40139  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4013F  4b1e                              add     r1, r14
FFF40141  b082                              movu.b  14h+var_12[sp], r2
FFF40143  4b2e                              add     r2, r14
FFF40145  fbf2468e0000                      mov.l   #8E46h, r15
FFF4014B  4b1f                              add     r1, r15
FFF4014D  4b2f                              add     r2, r15
FFF4014F  c5fe8080                          mov.b   80h[r15], 80h[r14]
FFF40153  b009                              movu.b  14h+var_13[sp], r1
FFF40155  6211                              add     #1, r1
FFF40157  8009                              mov.b   r1, 14h+var_13[sp]
FFF40159  b081                   loc_FFF40159 movu.b  14h+var_12[sp], r1
FFF4015B  6211                              add     #1, r1
FFF4015D  8081                              mov.b   r1, 14h+var_12[sp]
FFF4015F  b081                   loc_FFF4015F movu.b  14h+var_12[sp], r1
FFF40161  6141                              cmp     #4, r1
FFF40163  29b0                              blt.b   loc_FFF40113
FFF40165  b089                              movu.b  14h+var_11[sp], r1
FFF40167  6211                              add     #1, r1
FFF40169  8089                              mov.b   r1, 14h+var_11[sp]
FFF4016B  b089                   loc_FFF4016B movu.b  14h+var_11[sp], r1
FFF4016D  6151                              cmp     #5, r1
FFF4016F  2805                              bge.b   loc_FFF40174
FFF40171  3829ff                            bra.w   loc_FFF4009A
FFF40174  b009                   loc_FFF40174 movu.b  14h+var_13[sp], r1
FFF40176  6101                              cmp     #0, r1
FFF40178  17                                beq.s   loc_FFF4017F
FFF40179  6611                              mov.l   #1, r1
FFF4017B  0573fdfa                          bsr.a   sub_FFEEFEEE
FFF4017F  3c0300                 loc_FFF4017F mov.b   #0, 14h+var_11[sp]
FFF40182  2e7e                              bra.b   loc_FFF40200
FFF40184  b089                   loc_FFF40184 movu.b  14h+var_11[sp], r1
FFF40186  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4018C  4b1e                              add     r1, r14
FFF4018E  59ee9c                            movu.b  9Ch[r14], r14
FFF40191  fbf2468e0000                      mov.l   #8E46h, r15
FFF40197  4b1f                              add     r1, r15
FFF40199  45fe9c                            cmp     9Ch[r15], r14
FFF4019C  2023                              beq.b   loc_FFF401BF
FFF4019E  b08a                              movu.b  14h+var_11[sp], r2
FFF401A0  6621                              mov.l   #2, r1
FFF401A2  fd6221                            shll    r2, r1
FFF401A5  0549fdfa                          bsr.a   sub_FFEEFEEE
FFF401A9  b089                              movu.b  14h+var_11[sp], r1
FFF401AB  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF401B1  4b1e                              add     r1, r14
FFF401B3  fbf2468e0000                      mov.l   #8E46h, r15
FFF401B9  4b1f                              add     r1, r15
FFF401BB  c5fe9c9c                          mov.b   9Ch[r15], 9Ch[r14]
FFF401BF  b089                   loc_FFF401BF movu.b  14h+var_11[sp], r1
FFF401C1  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF401C7  4b1e                              add     r1, r14
FFF401C9  59ee9f                            movu.b  9Fh[r14], r14
FFF401CC  fbf2468e0000                      mov.l   #8E46h, r15
FFF401D2  4b1f                              add     r1, r15
FFF401D4  45fe9f                            cmp     9Fh[r15], r14
FFF401D7  2023                              beq.b   loc_FFF401FA
FFF401D9  b08a                              movu.b  14h+var_11[sp], r2
FFF401DB  6621                              mov.l   #2, r1
FFF401DD  fd6221                            shll    r2, r1
FFF401E0  050efdfa                          bsr.a   sub_FFEEFEEE
FFF401E4  b089                              movu.b  14h+var_11[sp], r1
FFF401E6  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF401EC  4b1e                              add     r1, r14
FFF401EE  fbf2468e0000                      mov.l   #8E46h, r15
FFF401F4  4b1f                              add     r1, r15
FFF401F6  c5fe9f9f                          mov.b   9Fh[r15], 9Fh[r14]
FFF401FA  b089                   loc_FFF401FA movu.b  14h+var_11[sp], r1
FFF401FC  6211                              add     #1, r1
FFF401FE  8089                              mov.b   r1, 14h+var_11[sp]
FFF40200  b089                   loc_FFF40200 movu.b  14h+var_11[sp], r1
FFF40202  6131                              cmp     #3, r1
FFF40204  2980                              blt.b   loc_FFF40184
FFF40206  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF4020C  b219                              movu.b  9[r1], r1
FFF4020E  fbe2468e0000                      mov.l   #8E46h, r14
FFF40214  45e109                            cmp     9[r14], r1
FFF40217  2012                              beq.b   loc_FFF40229
FFF40219  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4021F  fbf2468e0000                      mov.l   #8E46h, r15
FFF40225  c5fe0909                          mov.b   9[r15], 9[r14]
FFF40229  056b00fb               loc_FFF40229 bsr.a   sub_FFEF0294
FFF4022D  6701                              rtsd    #1
FFF4022F  fbe2798d0000           sub_FFF4022F mov.l   #8D79h, r14   ; <<<< FUNC sub_FFF4022F
FFF40235  f8e400                            mov.b   #0, [r14]
FFF40238  6601                              mov.l   #0, r1
FFF4023A  ef12                              mov.l   r1, r2
FFF4023C  05cc01fb                          bsr.a   sub_FFEF0408
FFF40240  055f37fb                          bsr.a   sub_FFEF399F
FFF40244  6631                              mov.l   #3, r1
FFF40246  0515c1fa                          bsr.a   sub_FFEEC35B
FFF4024A  392500                            bsr.w   sub_FFF4026F
FFF4024D  7541ff                            mov.l   #-1, r1
FFF40250  050bc1fa                          bsr.a   sub_FFEEC35B
FFF40254  754269                            mov.l   #69h, r2 ; 'i'
FFF40257  6601                              mov.l   #0, r1
FFF40259  397100                            bsr.w   sub_FFF402CA
FFF4025C  6601                              mov.l   #0, r1
FFF4025E  05a722fb                          bsr.a   sub_FFEF2505
FFF40262  6611                              mov.l   #1, r1
FFF40264  05a122fb                          bsr.a   sub_FFEF2505
FFF40268  6621                              mov.l   #2, r1
FFF4026A  059b22fb                          bsr.a   sub_FFEF2505
FFF4026E  02                                rts
FFF4026F  6080                   sub_FFF4026F sub     #8, sp   ; <<<< FUNC sub_FFF4026F
FFF40271  054cc1fa                          bsr.a   sub_FFEEC3BD
FFF40275  a009                              mov.l   r1, 8+var_4[sp]
FFF40277  a809                              mov.l   8+var_4[sp], r1
FFF40279  c41003                            mov.b   [r1], 8+var_5[sp]
FFF4027C  b089                              movu.b  8+var_5[sp], r1
FFF4027E  6121                              cmp     #2, r1
FFF40280  210c                              bne.b   loc_FFF4028C
FFF40282  05b65bfb                          bsr.a   sub_FFEF5E38
FFF40286  05105efb                          bsr.a   sub_FFEF6096
FFF4028A  2e36                              bra.b   loc_FFF402C0
FFF4028C  05424dfb               loc_FFF4028C bsr.a   sub_FFEF4FCE
FFF40290  05724ffb                          bsr.a   sub_FFEF5202
FFF40294  05ca50fb                          bsr.a   sub_FFEF535E
FFF40298  05fc51fb                          bsr.a   sub_FFEF5494
FFF4029C  058551fb                          bsr.a   sub_FFEF5421
FFF402A0  05f65dfb                          bsr.a   sub_FFEF6096
FFF402A4  05945bfb                          bsr.a   sub_FFEF5E38
FFF402A8  05454afb                          bsr.a   sub_FFEF4CED
FFF402AC  6111                              cmp     #1, r1
FFF402AE  1a                                bne.s   loc_FFF402B8
FFF402AF  058d61fb                          bsr.a   sub_FFEF643C
FFF402B3  051f62fb                          bsr.a   sub_FFEF64D2
FFF402B7  09                                bra.s   loc_FFF402C0
FFF402B8  056052fb               loc_FFF402B8 bsr.a   sub_FFEF5518
FFF402BC  052857fb                          bsr.a   sub_FFEF59E4
FFF402C0  05635dfb               loc_FFF402C0 bsr.a   sub_FFEF6023
FFF402C4  05b960fb                          bsr.a   sub_FFEF637D
FFF402C8  6702                              rtsd    #2
FFF402CA  6040                   sub_FFF402CA sub     #4, sp   ; <<<< FUNC sub_FFF402CA
FFF402CC  9009                              mov.w   r1, 4+var_2[sp]
FFF402CE  d302                              mov.w   r2, 4+var_4[sp]
FFF402D0  5c02                              movu.w  4+var_4[sp], r2
FFF402D2  b809                              movu.w  4+var_2[sp], r1
FFF402D4  754eb6                            mov.l   #-4Ah, r14
FFF402D7  432e                              sub     r2, r14
FFF402D9  5fe4                              movu.w  r14, r4
FFF402DB  fbea4001                          mov.l   #140h, r14
FFF402DF  431e                              sub     r1, r14
FFF402E1  5fe3                              movu.w  r14, r3
FFF402E3  051402fb                          bsr.a   sub_FFEF04F7
FFF402E7  3d0103                            mov.w   #3, 4+var_2[sp]
FFF402EA  f8056b                            mov.w   #6Bh, 4+var_4[sp] ; 'k'
FFF402ED  5c02                              movu.w  4+var_4[sp], r2
FFF402EF  b809                              movu.w  4+var_2[sp], r1
FFF402F1  6040                              sub     #4, sp
FFF402F3  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF402F8  f80510                            mov.w   #10h, 8+var_8[sp]
FFF402FB  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF40301  71446c                            add     #6Ch, r4, r4 ; 'l'
FFF40304  6613                              mov.l   #1, r3
FFF40306  0538a8fb                          bsr.a   sub_FFEFAB3E
FFF4030A  6240                              add     #4, sp
FFF4030C  390800                            bsr.w   sub_FFF40314
FFF4030F  391001                            bsr.w   sub_FFF4041F
FFF40312  6701                              rtsd    #1
FFF40314  7100f0                 sub_FFF40314 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF40314
FFF40317  3c0f00                            mov.b   #0, 10h+var_1[sp]
FFF4031A  3c0e00                            mov.b   #0, 10h+var_2[sp]
FFF4031D  3c0d00                            mov.b   #0, 10h+var_3[sp]
FFF40320  3d0500                            mov.w   #0, 10h+var_6[sp]
FFF40323  3d0400                            mov.w   #0, 10h+var_8[sp]
FFF40326  3d0300                            mov.w   #0, 10h+var_A[sp]
FFF40329  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4032F  c5e07d0f                          mov.b   7Dh[r14], 10h+var_1[sp]
FFF40333  b389                              movu.b  10h+var_1[sp], r1
FFF40335  6101                              cmp     #0, r1
FFF40337  210c                              bne.b   loc_FFF40343
FFF40339  3c0f0a                            mov.b   #0Ah, 10h+var_1[sp]
FFF4033C  b309                              movu.b  10h+var_3[sp], r1
FFF4033E  6211                              add     #1, r1
FFF40340  8309                              mov.b   r1, 10h+var_3[sp]
FFF40342  0f                                bra.s   loc_FFF40349
FFF40343  b389                   loc_FFF40343 movu.b  10h+var_1[sp], r1
FFF40345  6011                              sub     #1, r1
FFF40347  8389                              mov.b   r1, 10h+var_1[sp]
FFF40349  fb1a4001               loc_FFF40349 mov.l   #140h, r1
FFF4034D  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40353  fc25e17c                          divu    7Ch[r14], r1
FFF40357  9089                              mov.w   r1, 10h+var_A[sp]
FFF40359  3c0e00                            mov.b   #0, 10h+var_2[sp]
FFF4035C  38b100                            bra.w   loc_FFF4040D
FFF4035F  b889                   loc_FFF4035F movu.w  10h+var_A[sp], r1
FFF40361  ef12                              mov.l   r1, r2
FFF40363  4d020e                            mul     10h+var_2[sp], r2
FFF40366  6811                              shlr    #1, r1
FFF40368  4b12                              add     r1, r2
FFF4036A  910a                              mov.w   r2, 10h+var_6[sp]
FFF4036C  3d04a3                            mov.w   #-5Dh, 10h+var_8[sp]
FFF4036F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40375  59ee7c                            movu.b  7Ch[r14], r14
FFF40378  601e                              sub     #1, r14
FFF4037A  b381                              movu.b  10h+var_2[sp], r1
FFF4037C  47e1                              cmp     r14, r1
FFF4037E  1a                                bne.s   loc_FFF40388
FFF4037F  b309                              movu.b  10h+var_3[sp], r1
FFF40381  6101                              cmp     #0, r1
FFF40383  1d                                bne.s   loc_FFF40388
FFF40384  f80601                            mov.l   #1, 10h+var_10[sp]
FFF40387  0c                                bra.s   loc_FFF4038B
FFF40388  f80600                 loc_FFF40388 mov.l   #0, 10h+var_10[sp]
FFF4038B  b909                   loc_FFF4038B movu.w  10h+var_6[sp], r1
FFF4038D  05fb5600                          bsr.a   sub_FFF45A88
FFF40391  fb4200003ac0                      mov.l   #-3FC60000h, r4
FFF40397  6603                              mov.l   #0, r3
FFF40399  05cc5400                          bsr.a   sub_FFF45865
FFF4039D  05295700                          bsr.a   sub_FFF45AC6
FFF403A1  ec02                              mov.l   10h+var_10[sp], r2
FFF403A3  9109                              mov.w   r1, 10h+var_6[sp]
FFF403A5  6102                              cmp     #0, r2
FFF403A7  9901                              mov.w   10h+var_8[sp], r1
FFF403A9  990b                              mov.w   10h+var_6[sp], r3
FFF403AB  202a                              beq.b   loc_FFF403D5
FFF403AD  b38a                              movu.b  10h+var_1[sp], r2
FFF403AF  6040                              sub     #4, sp
FFF403B1  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF403B6  f80504                            mov.w   #4, 14h+var_14[sp]
FFF403B9  6362                              mul     #6, r2
FFF403BB  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF403C1  4b24                              add     r2, r4
FFF403C3  72448000                          add     #80h, r4, r4
FFF403C7  5f12                              movu.w  r1, r2
FFF403C9  5f31                              movu.w  r3, r1
FFF403CB  6613                              mov.l   #1, r3
FFF403CD  0571a7fb                          bsr.a   sub_FFEFAB3E
FFF403D1  6240                              add     #4, sp
FFF403D3  6704                              rtsd    #4
FFF403D5  b382                   loc_FFF403D5 movu.b  10h+var_2[sp], r2
FFF403D7  6040                              sub     #4, sp
FFF403D9  f90901ffff                        mov.w   #-1, 14h+var_12[sp]
FFF403DE  f80504                            mov.w   #4, 14h+var_14[sp]
FFF403E1  6362                              mul     #6, r2
FFF403E3  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF403E9  4b24                              add     r2, r4
FFF403EB  72448000                          add     #80h, r4, r4
FFF403EF  5f12                              movu.w  r1, r2
FFF403F1  5f31                              movu.w  r3, r1
FFF403F3  6613                              mov.l   #1, r3
FFF403F5  0549a7fb                          bsr.a   sub_FFEFAB3E
FFF403F9  6240                              add     #4, sp
FFF403FB  b381                              movu.b  10h+var_2[sp], r1
FFF403FD  45010f                            cmp     10h+var_1[sp], r1
FFF40400  1f                                bne.s   loc_FFF40407
FFF40401  b309                              movu.b  10h+var_3[sp], r1
FFF40403  6211                              add     #1, r1
FFF40405  8309                              mov.b   r1, 10h+var_3[sp]
FFF40407  b381                   loc_FFF40407 movu.b  10h+var_2[sp], r1
FFF40409  6211                              add     #1, r1
FFF4040B  8381                              mov.b   r1, 10h+var_2[sp]
FFF4040D  fbe24d8c0000           loc_FFF4040D mov.l   #8C4Dh, r14
FFF40413  b381                              movu.b  10h+var_2[sp], r1
FFF40415  45e17c                            cmp     7Ch[r14], r1
FFF40418  2805                              bge.b   loc_FFF4041D
FFF4041A  3845ff                            bra.w   loc_FFF4035F
FFF4041D  6704                   loc_FFF4041D rtsd    #4
FFF4041F  6e67                   sub_FFF4041F pushm   r6-r7   ; <<<< FUNC sub_FFF4041F
FFF40421  7100e8                            add     #-18h, sp, sp
FFF40424  3c8700                            mov.b   #0, 18h+var_1[sp]
FFF40427  3c8600                            mov.b   #0, 18h+var_2[sp]
FFF4042A  3c8500                            mov.b   #0, 18h+var_3[sp]
FFF4042D  3c8400                            mov.b   #0, 18h+var_4[sp]
FFF40430  3d0900                            mov.w   #0, 18h+var_6[sp]
FFF40433  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF40436  3d0700                            mov.w   #0, 18h+var_A[sp]
FFF40439  3d0600                            mov.w   #0, 18h+var_C[sp]
FFF4043C  3d0500                            mov.w   #0, 18h+var_E[sp]
FFF4043F  3d0400                            mov.w   #0, 18h+var_10[sp]
FFF40442  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF40445  fb1a4001                          mov.l   #140h, r1
FFF40449  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4044F  fc25e17c                          divu    7Ch[r14], r1
FFF40453  9101                              mov.w   r1, 18h+var_10[sp]
FFF40455  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4045B  c5e07d14                          mov.b   7Dh[r14], 18h+var_4[sp]
FFF4045F  b501                              movu.b  18h+var_4[sp], r1
FFF40461  6101                              cmp     #0, r1
FFF40463  210c                              bne.b   loc_FFF4046F
FFF40465  3c840a                            mov.b   #0Ah, 18h+var_4[sp]
FFF40468  b509                              movu.b  18h+var_3[sp], r1
FFF4046A  6211                              add     #1, r1
FFF4046C  8509                              mov.b   r1, 18h+var_3[sp]
FFF4046E  0f                                bra.s   loc_FFF40475
FFF4046F  b501                   loc_FFF4046F movu.b  18h+var_4[sp], r1
FFF40471  6011                              sub     #1, r1
FFF40473  8501                              mov.b   r1, 18h+var_4[sp]
FFF40475  fbe24d8c0000           loc_FFF40475 mov.l   #8C4Dh, r14
FFF4047B  59ee7c                            movu.b  7Ch[r14], r14
FFF4047E  615e                              cmp     #5, r14
FFF40480  2024                              beq.b   loc_FFF404A4
FFF40482  612e                              cmp     #2, r14
FFF40484  2013                              beq.b   loc_FFF40497
FFF40486  613e                              cmp     #3, r14
FFF40488  2014                              beq.b   loc_FFF4049C
FFF4048A  614e                              cmp     #4, r14
FFF4048C  2014                              beq.b   loc_FFF404A0
FFF4048E  611e                              cmp     #1, r14
FFF40490  2117                              bne.b   loc_FFF404A7
FFF40492  3d055f                            mov.w   #5Fh, 18h+var_E[sp] ; '_'
FFF40495  2e12                              bra.b   loc_FFF404A7
FFF40497  3d055f                 loc_FFF40497 mov.w   #5Fh, 18h+var_E[sp] ; '_'
FFF4049A  2e0d                              bra.b   loc_FFF404A7
FFF4049C  3d052f                 loc_FFF4049C mov.w   #2Fh, 18h+var_E[sp] ; '/'
FFF4049F  08                                bra.s   loc_FFF404A7
FFF404A0  3d0517                 loc_FFF404A0 mov.w   #17h, 18h+var_E[sp]
FFF404A3  0c                                bra.s   loc_FFF404A7
FFF404A4  3d0517                 loc_FFF404A4 mov.w   #17h, 18h+var_E[sp]
FFF404A7  3c8700                 loc_FFF404A7 mov.b   #0, 18h+var_1[sp]
FFF404AA  381d05                            bra.w   loc_FFF409C7
FFF404AD  b901                   loc_FFF404AD movu.w  18h+var_10[sp], r1
FFF404AF  ef12                              mov.l   r1, r2
FFF404B1  4d0217                            mul     18h+var_1[sp], r2
FFF404B4  6811                              shlr    #1, r1
FFF404B6  4b12                              add     r1, r2
FFF404B8  920a                              mov.w   r2, 18h+var_6[sp]
FFF404BA  3d08a0                            mov.w   #-60h, 18h+var_8[sp]
FFF404BD  b589                              movu.b  18h+var_1[sp], r1
FFF404BF  450114                            cmp     18h+var_4[sp], r1
FFF404C2  3a6003                            beq.w   loc_FFF40822
FFF404C5  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF404CB  59ee7c                            movu.b  7Ch[r14], r14
FFF404CE  601e                              sub     #1, r14
FFF404D0  b589                              movu.b  18h+var_1[sp], r1
FFF404D2  47e1                              cmp     r14, r1
FFF404D4  1a                                bne.s   loc_FFF404DE
FFF404D5  b509                              movu.b  18h+var_3[sp], r1
FFF404D7  6101                              cmp     #0, r1
FFF404D9  1d                                bne.s   loc_FFF404DE
FFF404DA  f80601                            mov.l   #1, 18h+var_18[sp]
FFF404DD  0c                                bra.s   loc_FFF404E1
FFF404DE  f80600                 loc_FFF404DE mov.l   #0, 18h+var_18[sp]
FFF404E1  ec01                   loc_FFF404E1 mov.l   18h+var_18[sp], r1
FFF404E3  6101                              cmp     #0, r1
FFF404E5  3aa001                            beq.w   loc_FFF40685
FFF404E8  b501                              movu.b  18h+var_4[sp], r1
FFF404EA  6361                              mul     #6, r1
FFF404EC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF404F2  4b1e                              add     r1, r14
FFF404F4  59ee7f                            movu.b  7Fh[r14], r14
FFF404F7  601e                              sub     #1, r14
FFF404F9  619e                              cmp     #9, r14; switch 10 cases
FFF404FB  243d                              bgtu.b  def_FFF40506
FFF404FD  fbf22780f4ff                      mov.l   #jpt_FFF40506, r15
FFF40503  fe4efe                            mov.b   [r14, r15], r14
FFF40506  7f4e                              bra.l   r14; switch jump
FFF40508  3d0603                 loc_FFF40508 mov.w   #3, 18h+var_C[sp]; jumptable FFF40506 case 0
FFF4050B  2e30                              bra.b   loc_FFF4053B
FFF4050D  3d0606                 loc_FFF4050D mov.w   #6, 18h+var_C[sp]; jumptable FFF40506 case 1
FFF40510  2e2b                              bra.b   loc_FFF4053B
FFF40512  3d060a                 loc_FFF40512 mov.w   #0Ah, 18h+var_C[sp]
FFF40515  2e26                              bra.b   loc_FFF4053B
FFF40517  3d060d                 loc_FFF40517 mov.w   #0Dh, 18h+var_C[sp]
FFF4051A  2e21                              bra.b   loc_FFF4053B
FFF4051C  3d0610                 loc_FFF4051C mov.w   #10h, 18h+var_C[sp]
FFF4051F  2e1c                              bra.b   loc_FFF4053B
FFF40521  3d0613                 loc_FFF40521 mov.w   #13h, 18h+var_C[sp]
FFF40524  2e17                              bra.b   loc_FFF4053B
FFF40526  3d0616                 loc_FFF40526 mov.w   #16h, 18h+var_C[sp]
FFF40529  2e12                              bra.b   loc_FFF4053B
FFF4052B  3d061a                 loc_FFF4052B mov.w   #1Ah, 18h+var_C[sp]
FFF4052E  2e0d                              bra.b   loc_FFF4053B
FFF40530  3d061d                 loc_FFF40530 mov.w   #1Dh, 18h+var_C[sp]
FFF40533  08                                bra.s   loc_FFF4053B
FFF40534  3d0620                 loc_FFF40534 mov.w   #20h, 18h+var_C[sp] ; ' '
FFF40537  0c                                bra.s   loc_FFF4053B
FFF40538  3d0600                 def_FFF40506 mov.w   #0, 18h+var_C[sp]
FFF4053B  b501                   loc_FFF4053B movu.b  18h+var_4[sp], r1
FFF4053D  6361                              mul     #6, r1
FFF4053F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40545  4b1e                              add     r1, r14
FFF40547  59ee7e                            movu.b  7Eh[r14], r14
FFF4054A  601e                              sub     #1, r14
FFF4054C  619e                              cmp     #9, r14
FFF4054E  2505                              bleu.b  loc_FFF40553
FFF40550  388f00                            bra.w   loc_FFF405DF
FFF40553  fbf23180f4ff           loc_FFF40553 mov.l   #unk_FFF48031, r15
FFF40559  fe4efe                            mov.b   [r14, r15], r14
FFF4055C  7f4e                              bra.l   r14
FFF4055E  3d0703                            mov.w   #3, 18h+var_A[sp]
FFF40561  fb122c36edff                      mov.l   #unk_FFED362C, r1
FFF40567  a009                              mov.l   r1, 18h+var_14[sp]
FFF40569  2e79                              bra.b   loc_FFF405E2
FFF4056B  3d0706                            mov.w   #6, 18h+var_A[sp]
FFF4056E  fb123c36edff                      mov.l   #unk_FFED363C, r1
FFF40574  a009                              mov.l   r1, 18h+var_14[sp]
FFF40576  2e6c                              bra.b   loc_FFF405E2
FFF40578  3d070a                            mov.w   #0Ah, 18h+var_A[sp]
FFF4057B  fb124c36edff                      mov.l   #unk_FFED364C, r1
FFF40581  a009                              mov.l   r1, 18h+var_14[sp]
FFF40583  2e5f                              bra.b   loc_FFF405E2
FFF40585  3d070d                            mov.w   #0Dh, 18h+var_A[sp]
FFF40588  fb125c36edff                      mov.l   #unk_FFED365C, r1
FFF4058E  a009                              mov.l   r1, 18h+var_14[sp]
FFF40590  2e52                              bra.b   loc_FFF405E2
FFF40592  3d0710                            mov.w   #10h, 18h+var_A[sp]
FFF40595  fb126c36edff                      mov.l   #unk_FFED366C, r1
FFF4059B  a009                              mov.l   r1, 18h+var_14[sp]
FFF4059D  2e45                              bra.b   loc_FFF405E2
FFF4059F  3d0713                            mov.w   #13h, 18h+var_A[sp]
FFF405A2  fb127c36edff                      mov.l   #unk_FFED367C, r1
FFF405A8  a009                              mov.l   r1, 18h+var_14[sp]
FFF405AA  2e38                              bra.b   loc_FFF405E2
FFF405AC  3d0716                            mov.w   #16h, 18h+var_A[sp]
FFF405AF  fb128c36edff                      mov.l   #unk_FFED368C, r1
FFF405B5  a009                              mov.l   r1, 18h+var_14[sp]
FFF405B7  2e2b                              bra.b   loc_FFF405E2
FFF405B9  3d071a                            mov.w   #1Ah, 18h+var_A[sp]
FFF405BC  fb129c36edff                      mov.l   #unk_FFED369C, r1
FFF405C2  a009                              mov.l   r1, 18h+var_14[sp]
FFF405C4  2e1e                              bra.b   loc_FFF405E2
FFF405C6  3d071d                            mov.w   #1Dh, 18h+var_A[sp]
FFF405C9  fb12ac36edff                      mov.l   #unk_FFED36AC, r1
FFF405CF  a009                              mov.l   r1, 18h+var_14[sp]
FFF405D1  2e11                              bra.b   loc_FFF405E2
FFF405D3  3d0720                            mov.w   #20h, 18h+var_A[sp] ; ' '
FFF405D6  fb12bc36edff                      mov.l   #unk_FFED36BC, r1
FFF405DC  a009                              mov.l   r1, 18h+var_14[sp]
FFF405DE  0c                                bra.s   loc_FFF405E2
FFF405DF  3d0700                 loc_FFF405DF mov.w   #0, 18h+var_A[sp]
FFF405E2  ba09                   loc_FFF405E2 movu.w  18h+var_6[sp], r1
FFF405E4  05a45400                          bsr.a   sub_FFF45A88
FFF405E8  ef16                              mov.l   r1, r6
FFF405EA  ef27                              mov.l   r2, r7
FFF405EC  b909                              movu.w  18h+var_E[sp], r1
FFF405EE  059a5400                          bsr.a   sub_FFF45A88
FFF405F2  fb420000e0bf                      mov.l   #-40200000h, r4
FFF405F8  6603                              mov.l   #0, r3
FFF405FA  05345600                          bsr.a   sub_FFF45C2E
FFF405FE  ef13                              mov.l   r1, r3
FFF40600  ef24                              mov.l   r2, r4
FFF40602  ef61                              mov.l   r6, r1
FFF40604  ef72                              mov.l   r7, r2
FFF40606  055f5200                          bsr.a   sub_FFF45865
FFF4060A  05bc5400                          bsr.a   sub_FFF45AC6
FFF4060E  9209                              mov.w   r1, 18h+var_6[sp]
FFF40610  b981                              movu.w  18h+var_C[sp], r1
FFF40612  6101                              cmp     #0, r1
FFF40614  200e                              beq.b   loc_FFF40622
FFF40616  b981                              movu.w  18h+var_C[sp], r1
FFF40618  06c50107                          cmp     18h+var_A[sp].uw, r1
FFF4061C  2b06                              ble.b   loc_FFF40622
FFF4061E  f80601                            mov.l   #1, 18h+var_18[sp]
FFF40621  0c                                bra.s   loc_FFF40625
FFF40622  f80600                 loc_FFF40622 mov.l   #0, 18h+var_18[sp]
FFF40625  ec01                   loc_FFF40625 mov.l   18h+var_18[sp], r1
FFF40627  6101                              cmp     #0, r1
FFF40629  2025                              beq.b   loc_FFF4064E
FFF4062B  7541a0                            mov.l   #-60h, r1
FFF4062E  06c10106                          sub     18h+var_C[sp].uw, r1
FFF40632  9201                              mov.w   r1, 18h+var_8[sp]
FFF40634  b984                              movu.w  18h+var_C[sp], r4
FFF40636  06c10407                          sub     18h+var_A[sp].uw, r4
FFF4063A  b90b                              movu.w  18h+var_E[sp], r3
FFF4063C  ba02                              movu.w  18h+var_8[sp], r2
FFF4063E  ba09                              movu.w  18h+var_6[sp], r1
FFF40640  6040                              sub     #4, sp
FFF40642  f809ef7b                          mov.w   #7BEFh, 1Ch+var_1C[sp]
FFF40646  5f44                              movu.w  r4, r4
FFF40648  050016fb                          bsr.a   sub_FFEF1C48
FFF4064C  6240                              add     #4, sp
FFF4064E  b989                   loc_FFF4064E movu.w  18h+var_A[sp], r1
FFF40650  6101                              cmp     #0, r1
FFF40652  3a8503                            beq.w   loc_FFF409D7
FFF40655  7541a0                            mov.l   #-60h, r1
FFF40658  06c10107                          sub     18h+var_A[sp].uw, r1
FFF4065C  9201                              mov.w   r1, 18h+var_8[sp]
FFF4065E  3c8600                            mov.b   #0, 18h+var_2[sp]
FFF40661  2e19                              bra.b   loc_FFF4067A
FFF40663  ba09                   loc_FFF40663 movu.w  18h+var_6[sp], r1
FFF40665  490116                            add     18h+var_2[sp], r1
FFF40668  a80c                              mov.l   18h+var_14[sp], r4
FFF4066A  ba02                              movu.w  18h+var_8[sp], r2
FFF4066C  5f11                              movu.w  r1, r1
FFF4066E  6613                              mov.l   #1, r3
FFF40670  056562fb                          bsr.a   sub_FFEF68D5
FFF40674  b581                              movu.b  18h+var_2[sp], r1
FFF40676  6211                              add     #1, r1
FFF40678  8581                              mov.b   r1, 18h+var_2[sp]
FFF4067A  b581                   loc_FFF4067A movu.b  18h+var_2[sp], r1
FFF4067C  06c50105                          cmp     18h+var_E[sp].uw, r1
FFF40680  29e3                              blt.b   loc_FFF40663
FFF40682  385503                            bra.w   loc_FFF409D7
FFF40685  b589                   loc_FFF40685 movu.b  18h+var_1[sp], r1
FFF40687  6361                              mul     #6, r1
FFF40689  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF4068F  4b1e                              add     r1, r14
FFF40691  59ee7f                            movu.b  7Fh[r14], r14
FFF40694  601e                              sub     #1, r14
FFF40696  619e                              cmp     #9, r14; switch 10 cases
FFF40698  243d                              bgtu.b  def_FFF406A3
FFF4069A  fbf23b80f4ff                      mov.l   #jpt_FFF406A3, r15
FFF406A0  fe4efe                            mov.b   [r14, r15], r14
FFF406A3  7f4e                              bra.l   r14; switch jump
FFF406A5  3d0603                 loc_FFF406A5 mov.w   #3, 18h+var_C[sp]; jumptable FFF406A3 case 0
FFF406A8  2e30                              bra.b   loc_FFF406D8
FFF406AA  3d0606                 loc_FFF406AA mov.w   #6, 18h+var_C[sp]; jumptable FFF406A3 case 1
FFF406AD  2e2b                              bra.b   loc_FFF406D8
FFF406AF  3d060a                 loc_FFF406AF mov.w   #0Ah, 18h+var_C[sp]
FFF406B2  2e26                              bra.b   loc_FFF406D8
FFF406B4  3d060d                 loc_FFF406B4 mov.w   #0Dh, 18h+var_C[sp]
FFF406B7  2e21                              bra.b   loc_FFF406D8
FFF406B9  3d0610                 loc_FFF406B9 mov.w   #10h, 18h+var_C[sp]
FFF406BC  2e1c                              bra.b   loc_FFF406D8
FFF406BE  3d0613                 loc_FFF406BE mov.w   #13h, 18h+var_C[sp]
FFF406C1  2e17                              bra.b   loc_FFF406D8
FFF406C3  3d0616                 loc_FFF406C3 mov.w   #16h, 18h+var_C[sp]
FFF406C6  2e12                              bra.b   loc_FFF406D8
FFF406C8  3d061a                 loc_FFF406C8 mov.w   #1Ah, 18h+var_C[sp]
FFF406CB  2e0d                              bra.b   loc_FFF406D8
FFF406CD  3d061d                 loc_FFF406CD mov.w   #1Dh, 18h+var_C[sp]
FFF406D0  08                                bra.s   loc_FFF406D8
FFF406D1  3d0620                 loc_FFF406D1 mov.w   #20h, 18h+var_C[sp] ; ' '
FFF406D4  0c                                bra.s   loc_FFF406D8
FFF406D5  3d0600                 def_FFF406A3 mov.w   #0, 18h+var_C[sp]
FFF406D8  b589                   loc_FFF406D8 movu.b  18h+var_1[sp], r1
FFF406DA  6361                              mul     #6, r1
FFF406DC  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF406E2  4b1e                              add     r1, r14
FFF406E4  59ee7e                            movu.b  7Eh[r14], r14
FFF406E7  601e                              sub     #1, r14
FFF406E9  619e                              cmp     #9, r14
FFF406EB  2505                              bleu.b  loc_FFF406F0
FFF406ED  388f00                            bra.w   loc_FFF4077C
FFF406F0  fbf24580f4ff           loc_FFF406F0 mov.l   #unk_FFF48045, r15
FFF406F6  fe4efe                            mov.b   [r14, r15], r14
FFF406F9  7f4e                              bra.l   r14
FFF406FB  3d0703                            mov.w   #3, 18h+var_A[sp]
FFF406FE  fb128c35edff                      mov.l   #unk_FFED358C, r1
FFF40704  a009                              mov.l   r1, 18h+var_14[sp]
FFF40706  2e79                              bra.b   loc_FFF4077F
FFF40708  3d0706                            mov.w   #6, 18h+var_A[sp]
FFF4070B  fb129c35edff                      mov.l   #unk_FFED359C, r1
FFF40711  a009                              mov.l   r1, 18h+var_14[sp]
FFF40713  2e6c                              bra.b   loc_FFF4077F
FFF40715  3d070a                            mov.w   #0Ah, 18h+var_A[sp]
FFF40718  fb12ac35edff                      mov.l   #unk_FFED35AC, r1
FFF4071E  a009                              mov.l   r1, 18h+var_14[sp]
FFF40720  2e5f                              bra.b   loc_FFF4077F
FFF40722  3d070d                            mov.w   #0Dh, 18h+var_A[sp]
FFF40725  fb12bc35edff                      mov.l   #unk_FFED35BC, r1
FFF4072B  a009                              mov.l   r1, 18h+var_14[sp]
FFF4072D  2e52                              bra.b   loc_FFF4077F
FFF4072F  3d0710                            mov.w   #10h, 18h+var_A[sp]
FFF40732  fb12cc35edff                      mov.l   #unk_FFED35CC, r1
FFF40738  a009                              mov.l   r1, 18h+var_14[sp]
FFF4073A  2e45                              bra.b   loc_FFF4077F
FFF4073C  3d0713                            mov.w   #13h, 18h+var_A[sp]
FFF4073F  fb12dc35edff                      mov.l   #unk_FFED35DC, r1
FFF40745  a009                              mov.l   r1, 18h+var_14[sp]
FFF40747  2e38                              bra.b   loc_FFF4077F
FFF40749  3d0716                            mov.w   #16h, 18h+var_A[sp]
FFF4074C  fb12ec35edff                      mov.l   #unk_FFED35EC, r1
FFF40752  a009                              mov.l   r1, 18h+var_14[sp]
FFF40754  2e2b                              bra.b   loc_FFF4077F
FFF40756  3d071a                            mov.w   #1Ah, 18h+var_A[sp]
FFF40759  fb12fc35edff                      mov.l   #unk_FFED35FC, r1
FFF4075F  a009                              mov.l   r1, 18h+var_14[sp]
FFF40761  2e1e                              bra.b   loc_FFF4077F
FFF40763  3d071d                            mov.w   #1Dh, 18h+var_A[sp]
FFF40766  fb120c36edff                      mov.l   #unk_FFED360C, r1
FFF4076C  a009                              mov.l   r1, 18h+var_14[sp]
FFF4076E  2e11                              bra.b   loc_FFF4077F
FFF40770  3d0720                            mov.w   #20h, 18h+var_A[sp] ; ' '
FFF40773  fb121c36edff                      mov.l   #unk_FFED361C, r1
FFF40779  a009                              mov.l   r1, 18h+var_14[sp]
FFF4077B  0c                                bra.s   loc_FFF4077F
FFF4077C  3d0700                 loc_FFF4077C mov.w   #0, 18h+var_A[sp]
FFF4077F  ba09                   loc_FFF4077F movu.w  18h+var_6[sp], r1
FFF40781  05075300                          bsr.a   sub_FFF45A88
FFF40785  ef17                              mov.l   r1, r7
FFF40787  ef26                              mov.l   r2, r6
FFF40789  b909                              movu.w  18h+var_E[sp], r1
FFF4078B  05fd5200                          bsr.a   sub_FFF45A88
FFF4078F  fb420000e0bf                      mov.l   #-40200000h, r4
FFF40795  6603                              mov.l   #0, r3
FFF40797  05975400                          bsr.a   sub_FFF45C2E
FFF4079B  ef13                              mov.l   r1, r3
FFF4079D  ef24                              mov.l   r2, r4
FFF4079F  ef71                              mov.l   r7, r1
FFF407A1  ef62                              mov.l   r6, r2
FFF407A3  05c25000                          bsr.a   sub_FFF45865
FFF407A7  051f5300                          bsr.a   sub_FFF45AC6
FFF407AB  9209                              mov.w   r1, 18h+var_6[sp]
FFF407AD  b981                              movu.w  18h+var_C[sp], r1
FFF407AF  6101                              cmp     #0, r1
FFF407B1  200e                              beq.b   loc_FFF407BF
FFF407B3  b981                              movu.w  18h+var_C[sp], r1
FFF407B5  06c50107                          cmp     18h+var_A[sp].uw, r1
FFF407B9  2b06                              ble.b   loc_FFF407BF
FFF407BB  f80601                            mov.l   #1, 18h+var_18[sp]
FFF407BE  0c                                bra.s   loc_FFF407C2
FFF407BF  f80600                 loc_FFF407BF mov.l   #0, 18h+var_18[sp]
FFF407C2  ec01                   loc_FFF407C2 mov.l   18h+var_18[sp], r1
FFF407C4  6101                              cmp     #0, r1
FFF407C6  2025                              beq.b   loc_FFF407EB
FFF407C8  7541a0                            mov.l   #-60h, r1
FFF407CB  06c10106                          sub     18h+var_C[sp].uw, r1
FFF407CF  9201                              mov.w   r1, 18h+var_8[sp]
FFF407D1  b984                              movu.w  18h+var_C[sp], r4
FFF407D3  06c10407                          sub     18h+var_A[sp].uw, r4
FFF407D7  b90b                              movu.w  18h+var_E[sp], r3
FFF407D9  ba02                              movu.w  18h+var_8[sp], r2
FFF407DB  ba09                              movu.w  18h+var_6[sp], r1
FFF407DD  6040                              sub     #4, sp
FFF407DF  f809ef7b                          mov.w   #7BEFh, 1Ch+var_1C[sp]
FFF407E3  5f44                              movu.w  r4, r4
FFF407E5  056314fb                          bsr.a   sub_FFEF1C48
FFF407E9  6240                              add     #4, sp
FFF407EB  b989                   loc_FFF407EB movu.w  18h+var_A[sp], r1
FFF407ED  6101                              cmp     #0, r1
FFF407EF  3ad201                            beq.w   loc_FFF409C1
FFF407F2  7541a0                            mov.l   #-60h, r1
FFF407F5  06c10107                          sub     18h+var_A[sp].uw, r1
FFF407F9  9201                              mov.w   r1, 18h+var_8[sp]
FFF407FB  3c8600                            mov.b   #0, 18h+var_2[sp]
FFF407FE  2e19                              bra.b   loc_FFF40817
FFF40800  ba09                   loc_FFF40800 movu.w  18h+var_6[sp], r1
FFF40802  490116                            add     18h+var_2[sp], r1
FFF40805  a80c                              mov.l   18h+var_14[sp], r4
FFF40807  ba02                              movu.w  18h+var_8[sp], r2
FFF40809  5f11                              movu.w  r1, r1
FFF4080B  6613                              mov.l   #1, r3
FFF4080D  05c860fb                          bsr.a   sub_FFEF68D5
FFF40811  b581                              movu.b  18h+var_2[sp], r1
FFF40813  6211                              add     #1, r1
FFF40815  8581                              mov.b   r1, 18h+var_2[sp]
FFF40817  b581                   loc_FFF40817 movu.b  18h+var_2[sp], r1
FFF40819  06c50105                          cmp     18h+var_E[sp].uw, r1
FFF4081D  29e3                              blt.b   loc_FFF40800
FFF4081F  38a201                            bra.w   loc_FFF409C1
FFF40822  b509                   loc_FFF40822 movu.b  18h+var_3[sp], r1
FFF40824  6211                              add     #1, r1
FFF40826  8509                              mov.b   r1, 18h+var_3[sp]
FFF40828  b501                              movu.b  18h+var_4[sp], r1
FFF4082A  6361                              mul     #6, r1
FFF4082C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40832  4b1e                              add     r1, r14
FFF40834  59ee7f                            movu.b  7Fh[r14], r14
FFF40837  601e                              sub     #1, r14
FFF40839  619e                              cmp     #9, r14; switch 10 cases
FFF4083B  243d                              bgtu.b  def_FFF40846
FFF4083D  fbf24f80f4ff                      mov.l   #jpt_FFF40846, r15
FFF40843  fe4efe                            mov.b   [r14, r15], r14
FFF40846  7f4e                              bra.l   r14; switch jump
FFF40848  3d0603                 loc_FFF40848 mov.w   #3, 18h+var_C[sp]; jumptable FFF40846 case 0
FFF4084B  2e30                              bra.b   loc_FFF4087B
FFF4084D  3d0606                 loc_FFF4084D mov.w   #6, 18h+var_C[sp]; jumptable FFF40846 case 1
FFF40850  2e2b                              bra.b   loc_FFF4087B
FFF40852  3d060a                 loc_FFF40852 mov.w   #0Ah, 18h+var_C[sp]
FFF40855  2e26                              bra.b   loc_FFF4087B
FFF40857  3d060d                 loc_FFF40857 mov.w   #0Dh, 18h+var_C[sp]
FFF4085A  2e21                              bra.b   loc_FFF4087B
FFF4085C  3d0610                 loc_FFF4085C mov.w   #10h, 18h+var_C[sp]
FFF4085F  2e1c                              bra.b   loc_FFF4087B
FFF40861  3d0613                 loc_FFF40861 mov.w   #13h, 18h+var_C[sp]
FFF40864  2e17                              bra.b   loc_FFF4087B
FFF40866  3d0616                 loc_FFF40866 mov.w   #16h, 18h+var_C[sp]
FFF40869  2e12                              bra.b   loc_FFF4087B
FFF4086B  3d061a                 loc_FFF4086B mov.w   #1Ah, 18h+var_C[sp]
FFF4086E  2e0d                              bra.b   loc_FFF4087B
FFF40870  3d061d                 loc_FFF40870 mov.w   #1Dh, 18h+var_C[sp]
FFF40873  08                                bra.s   loc_FFF4087B
FFF40874  3d0620                 loc_FFF40874 mov.w   #20h, 18h+var_C[sp] ; ' '
FFF40877  0c                                bra.s   loc_FFF4087B
FFF40878  3d0600                 def_FFF40846 mov.w   #0, 18h+var_C[sp]
FFF4087B  b501                   loc_FFF4087B movu.b  18h+var_4[sp], r1
FFF4087D  6361                              mul     #6, r1
FFF4087F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40885  4b1e                              add     r1, r14
FFF40887  59ee7e                            movu.b  7Eh[r14], r14
FFF4088A  601e                              sub     #1, r14
FFF4088C  619e                              cmp     #9, r14
FFF4088E  2505                              bleu.b  loc_FFF40893
FFF40890  388f00                            bra.w   loc_FFF4091F
FFF40893  fbf25980f4ff           loc_FFF40893 mov.l   #unk_FFF48059, r15
FFF40899  fe4efe                            mov.b   [r14, r15], r14
FFF4089C  7f4e                              bra.l   r14
FFF4089E  3d0703                            mov.w   #3, 18h+var_A[sp]
FFF408A1  fb122c36edff                      mov.l   #unk_FFED362C, r1
FFF408A7  a009                              mov.l   r1, 18h+var_14[sp]
FFF408A9  2e79                              bra.b   loc_FFF40922
FFF408AB  3d0706                            mov.w   #6, 18h+var_A[sp]
FFF408AE  fb123c36edff                      mov.l   #unk_FFED363C, r1
FFF408B4  a009                              mov.l   r1, 18h+var_14[sp]
FFF408B6  2e6c                              bra.b   loc_FFF40922
FFF408B8  3d070a                            mov.w   #0Ah, 18h+var_A[sp]
FFF408BB  fb124c36edff                      mov.l   #unk_FFED364C, r1
FFF408C1  a009                              mov.l   r1, 18h+var_14[sp]
FFF408C3  2e5f                              bra.b   loc_FFF40922
FFF408C5  3d070d                            mov.w   #0Dh, 18h+var_A[sp]
FFF408C8  fb125c36edff                      mov.l   #unk_FFED365C, r1
FFF408CE  a009                              mov.l   r1, 18h+var_14[sp]
FFF408D0  2e52                              bra.b   loc_FFF40922
FFF408D2  3d0710                            mov.w   #10h, 18h+var_A[sp]
FFF408D5  fb126c36edff                      mov.l   #unk_FFED366C, r1
FFF408DB  a009                              mov.l   r1, 18h+var_14[sp]
FFF408DD  2e45                              bra.b   loc_FFF40922
FFF408DF  3d0713                            mov.w   #13h, 18h+var_A[sp]
FFF408E2  fb127c36edff                      mov.l   #unk_FFED367C, r1
FFF408E8  a009                              mov.l   r1, 18h+var_14[sp]
FFF408EA  2e38                              bra.b   loc_FFF40922
FFF408EC  3d0716                            mov.w   #16h, 18h+var_A[sp]
FFF408EF  fb128c36edff                      mov.l   #unk_FFED368C, r1
FFF408F5  a009                              mov.l   r1, 18h+var_14[sp]
FFF408F7  2e2b                              bra.b   loc_FFF40922
FFF408F9  3d071a                            mov.w   #1Ah, 18h+var_A[sp]
FFF408FC  fb129c36edff                      mov.l   #unk_FFED369C, r1
FFF40902  a009                              mov.l   r1, 18h+var_14[sp]
FFF40904  2e1e                              bra.b   loc_FFF40922
FFF40906  3d071d                            mov.w   #1Dh, 18h+var_A[sp]
FFF40909  fb12ac36edff                      mov.l   #unk_FFED36AC, r1
FFF4090F  a009                              mov.l   r1, 18h+var_14[sp]
FFF40911  2e11                              bra.b   loc_FFF40922
FFF40913  3d0720                            mov.w   #20h, 18h+var_A[sp] ; ' '
FFF40916  fb12bc36edff                      mov.l   #unk_FFED36BC, r1
FFF4091C  a009                              mov.l   r1, 18h+var_14[sp]
FFF4091E  0c                                bra.s   loc_FFF40922
FFF4091F  3d0700                 loc_FFF4091F mov.w   #0, 18h+var_A[sp]
FFF40922  ba09                   loc_FFF40922 movu.w  18h+var_6[sp], r1
FFF40924  05645100                          bsr.a   sub_FFF45A88
FFF40928  ef17                              mov.l   r1, r7
FFF4092A  ef26                              mov.l   r2, r6
FFF4092C  b909                              movu.w  18h+var_E[sp], r1
FFF4092E  055a5100                          bsr.a   sub_FFF45A88
FFF40932  fb420000e0bf                      mov.l   #-40200000h, r4
FFF40938  6603                              mov.l   #0, r3
FFF4093A  05f45200                          bsr.a   sub_FFF45C2E
FFF4093E  ef13                              mov.l   r1, r3
FFF40940  ef24                              mov.l   r2, r4
FFF40942  ef71                              mov.l   r7, r1
FFF40944  ef62                              mov.l   r6, r2
FFF40946  051f4f00                          bsr.a   sub_FFF45865
FFF4094A  057c5100                          bsr.a   sub_FFF45AC6
FFF4094E  9209                              mov.w   r1, 18h+var_6[sp]
FFF40950  b981                              movu.w  18h+var_C[sp], r1
FFF40952  6101                              cmp     #0, r1
FFF40954  200e                              beq.b   loc_FFF40962
FFF40956  b981                              movu.w  18h+var_C[sp], r1
FFF40958  06c50107                          cmp     18h+var_A[sp].uw, r1
FFF4095C  2b06                              ble.b   loc_FFF40962
FFF4095E  f80601                            mov.l   #1, 18h+var_18[sp]
FFF40961  0c                                bra.s   loc_FFF40965
FFF40962  f80600                 loc_FFF40962 mov.l   #0, 18h+var_18[sp]
FFF40965  ec01                   loc_FFF40965 mov.l   18h+var_18[sp], r1
FFF40967  6101                              cmp     #0, r1
FFF40969  2025                              beq.b   loc_FFF4098E
FFF4096B  7541a0                            mov.l   #-60h, r1
FFF4096E  06c10106                          sub     18h+var_C[sp].uw, r1
FFF40972  9201                              mov.w   r1, 18h+var_8[sp]
FFF40974  b984                              movu.w  18h+var_C[sp], r4
FFF40976  06c10407                          sub     18h+var_A[sp].uw, r4
FFF4097A  b90b                              movu.w  18h+var_E[sp], r3
FFF4097C  ba02                              movu.w  18h+var_8[sp], r2
FFF4097E  ba09                              movu.w  18h+var_6[sp], r1
FFF40980  6040                              sub     #4, sp
FFF40982  f809ef7b                          mov.w   #7BEFh, 1Ch+var_1C[sp]
FFF40986  5f44                              movu.w  r4, r4
FFF40988  05c012fb                          bsr.a   sub_FFEF1C48
FFF4098C  6240                              add     #4, sp
FFF4098E  b989                   loc_FFF4098E movu.w  18h+var_A[sp], r1
FFF40990  6101                              cmp     #0, r1
FFF40992  202f                              beq.b   loc_FFF409C1
FFF40994  7541a0                            mov.l   #-60h, r1
FFF40997  06c10107                          sub     18h+var_A[sp].uw, r1
FFF4099B  9201                              mov.w   r1, 18h+var_8[sp]
FFF4099D  3c8600                            mov.b   #0, 18h+var_2[sp]
FFF409A0  2e19                              bra.b   loc_FFF409B9
FFF409A2  ba09                   loc_FFF409A2 movu.w  18h+var_6[sp], r1
FFF409A4  490116                            add     18h+var_2[sp], r1
FFF409A7  a80c                              mov.l   18h+var_14[sp], r4
FFF409A9  ba02                              movu.w  18h+var_8[sp], r2
FFF409AB  5f11                              movu.w  r1, r1
FFF409AD  6613                              mov.l   #1, r3
FFF409AF  05265ffb                          bsr.a   sub_FFEF68D5
FFF409B3  b581                              movu.b  18h+var_2[sp], r1
FFF409B5  6211                              add     #1, r1
FFF409B7  8581                              mov.b   r1, 18h+var_2[sp]
FFF409B9  b581                   loc_FFF409B9 movu.b  18h+var_2[sp], r1
FFF409BB  06c50105                          cmp     18h+var_E[sp].uw, r1
FFF409BF  29e3                              blt.b   loc_FFF409A2
FFF409C1  b589                   loc_FFF409C1 movu.b  18h+var_1[sp], r1
FFF409C3  6211                              add     #1, r1
FFF409C5  8589                              mov.b   r1, 18h+var_1[sp]
FFF409C7  fbe24d8c0000           loc_FFF409C7 mov.l   #8C4Dh, r14
FFF409CD  b589                              movu.b  18h+var_1[sp], r1
FFF409CF  45e17c                            cmp     7Ch[r14], r1
FFF409D2  2805                              bge.b   loc_FFF409D7
FFF409D4  38d9fa                            bra.w   loc_FFF404AD
FFF409D7  3f6708                 loc_FFF409D7 rtsd    #20h, r6-r7
FFF409DA  fbe2468e0000           sub_FFF409DA mov.l   #8E46h, r14   ; <<<< FUNC sub_FFF409DA
FFF409E0  58ee                              movu.b  [r14], r14
FFF409E2  755ef1                            cmp     #-0Fh, r14
FFF409E5  212c                              bne.b   loc_FFF40A11
FFF409E7  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF409ED  58ee                              movu.b  [r14], r14
FFF409EF  613e                              cmp     #3, r14
FFF409F1  2a16                              bgt.b   loc_FFF40A07
FFF409F3  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF409F9  58ee                              movu.b  [r14], r14
FFF409FB  fbf2d883edff                      mov.l   #off_FFED83D8, r15
FFF40A01  fe6efe                            mov.l   [r14, r15], r14
FFF40A04  7f1e                              jsr     r14
FFF40A06  02                                rts
FFF40A07  fbe24c8c0000           loc_FFF40A07 mov.l   #8C4Ch, r14
FFF40A0D  f8e403                            mov.b   #3, [r14]
FFF40A10  02                                rts
FFF40A11  02                     loc_FFF40A11 rts
FFF40A12  6611                   sub_FFF40A12 mov.l   #1, r1   ; <<<< FUNC sub_FFF40A12
FFF40A14  394d01                            bsr.w   sub_FFF40B61
FFF40A17  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF40A1D  58ef                              movu.b  [r14], r15
FFF40A1F  621f                              add     #1, r15
FFF40A21  c3ef                              mov.b   r15, [r14]
FFF40A23  02                                rts
FFF40A24  6080                   sub_FFF40A24 sub     #8, sp   ; <<<< FUNC sub_FFF40A24
FFF40A26  0507f9fa                          bsr.a   sub_FFEF032D
FFF40A2A  055e9bfb                          bsr.a   sub_FFEFA588
FFF40A2E  3d0200                            mov.w   #0, 8+var_4[sp]
FFF40A31  3d036b                            mov.w   #6Bh, 8+var_2[sp] ; 'k'
FFF40A34  3c0300                            mov.b   #0, 8+var_5[sp]
FFF40A37  2e29                              bra.b   loc_FFF40A60
FFF40A39  b881                   loc_FFF40A39 movu.w  8+var_4[sp], r1
FFF40A3B  b88a                              movu.w  8+var_2[sp], r2
FFF40A3D  6040                              sub     #4, sp
FFF40A3F  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF40A43  fbea4001                          mov.l   #140h, r14
FFF40A47  431e                              sub     r1, r14
FFF40A49  5fe3                              movu.w  r14, r3
FFF40A4B  6614                              mov.l   #1, r4
FFF40A4D  05fb11fb                          bsr.a   sub_FFEF1C48
FFF40A51  6240                              add     #4, sp
FFF40A53  b889                              movu.w  8+var_2[sp], r1
FFF40A55  711111                            add     #11h, r1, r1
FFF40A58  9089                              mov.w   r1, 8+var_2[sp]
FFF40A5A  b089                              movu.b  8+var_5[sp], r1
FFF40A5C  6211                              add     #1, r1
FFF40A5E  8089                              mov.b   r1, 8+var_5[sp]
FFF40A60  b089                   loc_FFF40A60 movu.b  8+var_5[sp], r1
FFF40A62  6141                              cmp     #4, r1
FFF40A64  29d5                              blt.b   loc_FFF40A39
FFF40A66  6661                              mov.l   #6, r1
FFF40A68  052794fb                          bsr.a   sub_FFEF9E8F
FFF40A6C  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF40A72  58ef                              movu.b  [r14], r15
FFF40A74  621f                              add     #1, r15
FFF40A76  c3ef                              mov.b   r15, [r14]
FFF40A78  6702                              rtsd    #2
FFF40A7A  6040                   sub_FFF40A7A sub     #4, sp   ; <<<< FUNC sub_FFF40A7A
FFF40A7C  6040                              sub     #4, sp
FFF40A7E  3d00f0                            mov.w   #-10h, [sp]
FFF40A81  fb4a4001                          mov.l   #140h, r4
FFF40A85  6602                              mov.l   #0, r2
FFF40A87  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF40A8D  ef23                              mov.l   r2, r3
FFF40A8F  052ceffa                          bsr.a   sub_FFEEF9BB
FFF40A93  6240                              add     #4, sp
FFF40A95  8089                              mov.b   r1, 4+var_1[sp]
FFF40A97  b089                              movu.b  4+var_1[sp], r1
FFF40A99  6111                              cmp     #1, r1
FFF40A9B  1a                                bne.s   loc_FFF40AA5
FFF40A9C  395106                            bsr.w   sub_FFF410ED
FFF40A9F  05d0f8fa                          bsr.a   sub_FFEF036F
FFF40AA3  6701                              rtsd    #1
FFF40AA5  6701                   loc_FFF40AA5 rtsd    #1
FFF40AA7  6040                   sub_FFF40AA7 sub     #4, sp   ; <<<< FUNC sub_FFF40AA7
FFF40AA9  6040                              sub     #4, sp
FFF40AAB  f80561                            mov.w   #61h, 8+var_8[sp] ; 'a'
FFF40AAE  fb4a4001                          mov.l   #140h, r4
FFF40AB2  754356                            mov.l   #56h, r3 ; 'V'
FFF40AB5  6602                              mov.l   #0, r2
FFF40AB7  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF40ABD  05feeefa                          bsr.a   sub_FFEEF9BB
FFF40AC1  6240                              add     #4, sp
FFF40AC3  8089                              mov.b   r1, 4+var_1[sp]
FFF40AC5  b089                              movu.b  4+var_1[sp], r1
FFF40AC7  6111                              cmp     #1, r1
FFF40AC9  2110                              bne.b   loc_FFF40AD9
FFF40ACB  754256                            mov.l   #56h, r2 ; 'V'
FFF40ACE  6601                              mov.l   #0, r1
FFF40AD0  398506                            bsr.w   sub_FFF41155
FFF40AD3  059cf8fa                          bsr.a   sub_FFEF036F
FFF40AD7  6701                              rtsd    #1
FFF40AD9  6701                   loc_FFF40AD9 rtsd    #1
FFF40ADB  6040                   sub_FFF40ADB sub     #4, sp   ; <<<< FUNC sub_FFF40ADB
FFF40ADD  0562f5fa                          bsr.a   sub_FFEF003F
FFF40AE1  fbe2738f0000                      mov.l   #8F73h, r14
FFF40AE7  c3e1                              mov.b   r1, [r14]
FFF40AE9  fbe2738f0000                      mov.l   #8F73h, r14
FFF40AEF  58ee                              movu.b  [r14], r14
FFF40AF1  755eff                            cmp     #-1, r14
FFF40AF4  1e                                bne.s   loc_FFF40AFA
FFF40AF5  6601                              mov.l   #0, r1
FFF40AF7  396a00                            bsr.w   sub_FFF40B61
FFF40AFA  fbe2738f0000           loc_FFF40AFA mov.l   #8F73h, r14
