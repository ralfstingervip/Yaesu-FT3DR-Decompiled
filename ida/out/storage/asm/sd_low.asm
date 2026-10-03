; ==== sd_low  FFF32000-FFF32980  (file 332000-332980) ====
FFF32000  ed0120                 sub_FFF32000 mov.l   arg_7C[sp], r1   ; <<<< FUNC sub_FFF32000
FFF32003  6101                              cmp     #0, r1
FFF32005  2017                              beq.b   loc_FFF3201C
FFF32007  ed0120                            mov.l   arg_7C[sp], r1
FFF3200A  6602                              mov.l   #0, r2
FFF3200C  0514cefe                          bsr.a   sub_FFF1EE20
FFF32010  ab09                              mov.l   arg_30[sp], r1
FFF32012  fa14420400                        mov.b   #0, 442h[r1]
FFF32017  3e0100                            mov.l   #0, arg_0[sp]
FFF3201A  2e0d                              bra.b   loc_FFF32027
FFF3201C  ab09                   loc_FFF3201C mov.l   arg_30[sp], r1
FFF3201E  fa14420400                        mov.b   #0, 442h[r1]
FFF32023  e5001301                          mov.l   arg_48[sp], arg_0[sp]
FFF32027  a809                   loc_FFF32027 mov.l   arg_0[sp], r1
FFF32029  e70121                            mov.l   r1, arg_80[sp]
FFF3202C  3f6627                            rtsd    #9Ch, r6-r6
FFF3202F  7100e0                 sub_FFF3202F add     #-20h, sp, sp   ; <<<< FUNC sub_FFF3202F
FFF32032  a189                              mov.l   r1, 20h+var_4[sp]
FFF32034  a182                              mov.l   r2, 20h+var_8[sp]
FFF32036  a10b                              mov.l   r3, 20h+var_C[sp]
FFF32038  a104                              mov.l   r4, 20h+var_10[sp]
FFF3203A  055c3efe                          bsr.a   sub_FFF15E96
FFF3203E  a009                              mov.l   r1, 20h+var_1C[sp]
FFF32040  a809                              mov.l   20h+var_1C[sp], r1
FFF32042  6101                              cmp     #0, r1
FFF32044  210f                              bne.b   loc_FFF32053
FFF32046  6602                              mov.l   #0, r2
FFF32048  fb16e1                            mov.l   #-1Fh, r1
FFF3204B  05d5cdfe                          bsr.a   sub_FFF1EE20
FFF3204F  e301                              mov.l   r1, 20h+var_20[sp]
FFF32051  2e20                              bra.b   loc_FFF32071
FFF32053  a80d                   loc_FFF32053 mov.l   20h+var_1C[sp], r5
FFF32055  a904                              mov.l   20h+var_10[sp], r4
FFF32057  a90b                              mov.l   20h+var_C[sp], r3
FFF32059  a982                              mov.l   20h+var_8[sp], r2
FFF3205B  a989                              mov.l   20h+var_4[sp], r1
FFF3205D  6040                              sub     #4, sp
FFF3205F  e305                              mov.l   r5, 24h+var_24[sp]
FFF32061  391600                            bsr.w   sub_FFF32077
FFF32064  6240                              add     #4, sp
FFF32066  a081                              mov.l   r1, 20h+var_18[sp]
FFF32068  a809                              mov.l   20h+var_1C[sp], r1
FFF3206A  053c3efe                          bsr.a   sub_FFF15EA6
FFF3206E  e10002                            mov.l   20h+var_18[sp], 20h+var_20[sp]
FFF32071  ec01                   loc_FFF32071 mov.l   20h+var_20[sp], r1
FFF32073  a089                              mov.l   r1, 20h+var_14[sp]
FFF32075  6708                              rtsd    #8
FFF32077  7ea6                   sub_FFF32077 push.l  r6   ; <<<< FUNC sub_FFF32077
FFF32079  7100d4                            add     #-2Ch, sp, sp
FFF3207C  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF3207E  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF32080  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF32082  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF32084  e5000d06                          mov.l   2Ch+arg_0[sp], 2Ch+var_14[sp]
FFF32088  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF3208E  e4e002                            mov.l   [r14], 2Ch+var_24[sp]
FFF32091  055a2fff                          bsr.a   sub_FFF24FEB
FFF32095  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF32097  a901                              mov.l   2Ch+var_1C[sp], r1
FFF32099  6101                              cmp     #0, r1
FFF3209B  200f                              beq.b   loc_FFF320AA
FFF3209D  a901                              mov.l   2Ch+var_1C[sp], r1
FFF3209F  6602                              mov.l   #0, r2
FFF320A1  057fcdfe                          bsr.a   sub_FFF1EE20
FFF320A5  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF320A7  38a801                            bra.w   loc_FFF3224F
FFF320AA  aa81                   loc_FFF320AA mov.l   2Ch+var_4[sp], r1
FFF320AC  6101                              cmp     #0, r1
FFF320AE  16                                beq.s   loc_FFF320B4
FFF320AF  aa09                              mov.l   2Ch+var_8[sp], r1
FFF320B1  6101                              cmp     #0, r1
FFF320B3  1d                                bne.s   loc_FFF320B8
FFF320B4  f80601                 loc_FFF320B4 mov.l   #1, 2Ch+var_2C[sp]
FFF320B7  0c                                bra.s   loc_FFF320BB
FFF320B8  f80600                 loc_FFF320B8 mov.l   #0, 2Ch+var_2C[sp]
FFF320BB  ec01                   loc_FFF320BB mov.l   2Ch+var_2C[sp], r1
FFF320BD  6101                              cmp     #0, r1
FFF320BF  2010                              beq.b   loc_FFF320CF
FFF320C1  6602                              mov.l   #0, r2
FFF320C3  fb16ff                            mov.l   #-1, r1
FFF320C6  055acdfe                          bsr.a   sub_FFF1EE20
FFF320CA  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF320CC  388301                            bra.w   loc_FFF3224F
FFF320CF  aa81                   loc_FFF320CF mov.l   2Ch+var_4[sp], r1
FFF320D1  052a16ff                          bsr.a   sub_FFF236FB
FFF320D5  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF320D7  a901                              mov.l   2Ch+var_1C[sp], r1
FFF320D9  6101                              cmp     #0, r1
FFF320DB  200f                              beq.b   loc_FFF320EA
FFF320DD  a901                              mov.l   2Ch+var_1C[sp], r1
FFF320DF  6602                              mov.l   #0, r2
FFF320E1  053fcdfe                          bsr.a   sub_FFF1EE20
FFF320E5  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF320E7  386801                            bra.w   loc_FFF3224F
FFF320EA  aa09                   loc_FFF320EA mov.l   2Ch+var_8[sp], r1
FFF320EC  050f16ff                          bsr.a   sub_FFF236FB
FFF320F0  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF320F2  a901                              mov.l   2Ch+var_1C[sp], r1
FFF320F4  6101                              cmp     #0, r1
FFF320F6  200f                              beq.b   loc_FFF32105
FFF320F8  a901                              mov.l   2Ch+var_1C[sp], r1
FFF320FA  6602                              mov.l   #0, r2
FFF320FC  0524cdfe                          bsr.a   sub_FFF1EE20
FFF32100  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF32102  384d01                            bra.w   loc_FFF3224F
FFF32105  aa82                   loc_FFF32105 mov.l   2Ch+var_4[sp], r2
FFF32107  a981                              mov.l   2Ch+var_14[sp], r1
FFF32109  72110c10                          add     #100Ch, r1, r1
FFF3210D  0538cbff                          bsr.a   sub_FFF2EC45
FFF32111  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF32113  a981                              mov.l   2Ch+var_14[sp], r1
FFF32115  72111212                          add     #1212h, r1, r1
FFF32119  052ccbff                          bsr.a   sub_FFF2EC45
FFF3211D  a981                              mov.l   2Ch+var_14[sp], r1
FFF3211F  72110c10                          add     #100Ch, r1, r1
FFF32123  05f914ff                          bsr.a   sub_FFF2361C
FFF32127  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF32129  a901                              mov.l   2Ch+var_1C[sp], r1
FFF3212B  6101                              cmp     #0, r1
FFF3212D  200f                              beq.b   loc_FFF3213C
FFF3212F  a901                              mov.l   2Ch+var_1C[sp], r1
FFF32131  6602                              mov.l   #0, r2
FFF32133  05edccfe                          bsr.a   sub_FFF1EE20
FFF32137  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF32139  381601                            bra.w   loc_FFF3224F
FFF3213C  a981                   loc_FFF3213C mov.l   2Ch+var_14[sp], r1
FFF3213E  72111212                          add     #1212h, r1, r1
FFF32142  05da14ff                          bsr.a   sub_FFF2361C
FFF32146  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF32148  a901                              mov.l   2Ch+var_1C[sp], r1
FFF3214A  6101                              cmp     #0, r1
FFF3214C  200f                              beq.b   loc_FFF3215B
FFF3214E  a901                              mov.l   2Ch+var_1C[sp], r1
FFF32150  6602                              mov.l   #0, r2
FFF32152  05ceccfe                          bsr.a   sub_FFF1EE20
FFF32156  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF32158  38f700                            bra.w   loc_FFF3224F
FFF3215B  a981                   loc_FFF3215B mov.l   2Ch+var_14[sp], r1
FFF3215D  ce110c10                          mov.b   100Ch[r1], r1
FFF32161  052ac6ff                          bsr.a   sub_FFF2E78B
FFF32165  ef16                              mov.l   r1, r6
FFF32167  a981                              mov.l   2Ch+var_14[sp], r1
FFF32169  ce111212                          mov.b   1212h[r1], r1
FFF3216D  051ec6ff                          bsr.a   sub_FFF2E78B
FFF32171  4716                              cmp     r1, r6
FFF32173  2010                              beq.b   loc_FFF32183
FFF32175  6602                              mov.l   #0, r2
FFF32177  fb16f4                            mov.l   #-0Ch, r1
FFF3217A  05a6ccfe                          bsr.a   sub_FFF1EE20
FFF3217E  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF32180  38cf00                            bra.w   loc_FFF3224F
FFF32183  a981                   loc_FFF32183 mov.l   2Ch+var_14[sp], r1
FFF32185  72121212                          add     #1212h, r1, r2
FFF32189  72110c10                          add     #100Ch, r1, r1
FFF3218D  05331bff                          bsr.a   sub_FFF23CC0
FFF32191  6101                              cmp     #0, r1
FFF32193  2110                              bne.b   loc_FFF321A3
FFF32195  6602                              mov.l   #0, r2
FFF32197  fb16f3                            mov.l   #-0Dh, r1
FFF3219A  0586ccfe                          bsr.a   sub_FFF1EE20
FFF3219E  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF321A0  38af00                            bra.w   loc_FFF3224F
FFF321A3  aa01                   loc_FFF321A3 mov.l   2Ch+var_C[sp], r1
FFF321A5  6101                              cmp     #0, r1
FFF321A7  16                                beq.s   loc_FFF321AD
FFF321A8  a989                              mov.l   2Ch+var_10[sp], r1
FFF321AA  6101                              cmp     #0, r1
FFF321AC  1d                                bne.s   loc_FFF321B1
FFF321AD  f80601                 loc_FFF321AD mov.l   #1, 2Ch+var_2C[sp]
FFF321B0  0c                                bra.s   loc_FFF321B4
FFF321B1  f80600                 loc_FFF321B1 mov.l   #0, 2Ch+var_2C[sp]
FFF321B4  ec01                   loc_FFF321B4 mov.l   2Ch+var_2C[sp], r1
FFF321B6  6101                              cmp     #0, r1
FFF321B8  2010                              beq.b   loc_FFF321C8
FFF321BA  6602                              mov.l   #0, r2
FFF321BC  fb16f3                            mov.l   #-0Dh, r1
FFF321BF  0561ccfe                          bsr.a   sub_FFF1EE20
FFF321C3  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF321C5  388a00                            bra.w   loc_FFF3224F
FFF321C8  a981                   loc_FFF321C8 mov.l   2Ch+var_14[sp], r1
FFF321CA  ce110c10                          mov.b   100Ch[r1], r1
FFF321CE  05bdc5ff                          bsr.a   sub_FFF2E78B
FFF321D2  8389                              mov.b   r1, 2Ch+var_1D[sp]
FFF321D4  b389                              movu.b  2Ch+var_1D[sp], r1
FFF321D6  710208                            add     #2Ch+var_24, sp, r2
FFF321D9  0546cdfe                          bsr.a   sub_FFF1EF1F
FFF321DD  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF321DF  a901                              mov.l   2Ch+var_1C[sp], r1
FFF321E1  6101                              cmp     #0, r1
FFF321E3  200e                              beq.b   loc_FFF321F1
FFF321E5  a901                              mov.l   2Ch+var_1C[sp], r1
FFF321E7  6602                              mov.l   #0, r2
FFF321E9  0537ccfe                          bsr.a   sub_FFF1EE20
FFF321ED  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF321EF  2e60                              bra.b   loc_FFF3224F
FFF321F1  a881                   loc_FFF321F1 mov.l   2Ch+var_24[sp], r1
FFF321F3  05fa3afe                          bsr.a   sub_FFF15CED
FFF321F7  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF321F9  a901                              mov.l   2Ch+var_1C[sp], r1
FFF321FB  6101                              cmp     #0, r1
FFF321FD  200f                              beq.b   loc_FFF3220C
FFF321FF  6602                              mov.l   #0, r2
FFF32201  fb16db                            mov.l   #-25h, r1
FFF32204  051cccfe                          bsr.a   sub_FFF1EE20
FFF32208  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF3220A  2e45                              bra.b   loc_FFF3224F
FFF3220C  a981                   loc_FFF3220C mov.l   2Ch+var_14[sp], r1
FFF3220E  a98c                              mov.l   2Ch+var_10[sp], r4
FFF32210  aa03                              mov.l   2Ch+var_C[sp], r3
FFF32212  6040                              sub     #4, sp
FFF32214  e301                              mov.l   r1, 30h+var_30[sp]
FFF32216  72121212                          add     #1212h, r1, r2
FFF3221A  72110c10                          add     #100Ch, r1, r1
FFF3221E  393800                            bsr.w   sub_FFF32256
FFF32221  6240                              add     #4, sp
FFF32223  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF32225  a881                              mov.l   2Ch+var_24[sp], r1
FFF32227  05d13afe                          bsr.a   sub_FFF15CF8
FFF3222B  a901                              mov.l   2Ch+var_1C[sp], r1
FFF3222D  6101                              cmp     #0, r1
FFF3222F  200e                              beq.b   loc_FFF3223D
FFF32231  a901                              mov.l   2Ch+var_1C[sp], r1
FFF32233  6602                              mov.l   #0, r2
FFF32235  05ebcbfe                          bsr.a   sub_FFF1EE20
FFF32239  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF3223B  2e14                              bra.b   loc_FFF3224F
FFF3223D  a881                   loc_FFF3223D mov.l   2Ch+var_24[sp], r1
FFF3223F  059da9fe                          bsr.a   sub_FFF1CBDC
FFF32243  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF32245  a901                              mov.l   2Ch+var_1C[sp], r1
FFF32247  6602                              mov.l   #0, r2
FFF32249  05d7cbfe                          bsr.a   sub_FFF1EE20
FFF3224D  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF3224F  a809                   loc_FFF3224F mov.l   2Ch+var_28[sp], r1
FFF32251  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF32253  3f660c                            rtsd    #30h, r6-r6
FFF32256  7ea6                   sub_FFF32256 push.l  r6   ; <<<< FUNC sub_FFF32256
FFF32258  720070ff                          add     #-90h, sp, sp
FFF3225C  e70123                            mov.l   r1, 90h+var_4[sp]
FFF3225F  e70222                            mov.l   r2, 90h+var_8[sp]
FFF32262  e70321                            mov.l   r3, 90h+var_C[sp]
FFF32265  e70420                            mov.l   r4, 90h+var_10[sp]
FFF32268  e500261f                          mov.l   90h+arg_0[sp], 90h+var_14[sp]
FFF3226C  f9046700                          mov.b   #0, 90h+var_29[sp]
FFF32270  3e8800                            mov.l   #0, 90h+var_30[sp]
FFF32273  3e8700                            mov.l   #0, 90h+var_34[sp]
FFF32276  3e8600                            mov.l   #0, 90h+var_38[sp]
FFF32279  3e8500                            mov.l   #0, 90h+var_3C[sp]
FFF3227C  3e8400                            mov.l   #0, 90h+var_40[sp]
FFF3227F  3e8000                            mov.l   #0, 90h+var_50[sp]
FFF32282  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF32288  e4e00c                            mov.l   [r14], 90h+var_60[sp]
FFF3228B  fbe2245e0600                      mov.l   #65E24h, r14
FFF32291  e4e00b                            mov.l   [r14], 90h+var_64[sp]
FFF32294  3e0a00                            mov.l   #0, 90h+var_68[sp]
FFF32297  05d23afe                          bsr.a   sub_FFF15D69
FFF3229B  a709                              mov.l   r1, 90h+var_1C[sp]
FFF3229D  af09                              mov.l   90h+var_1C[sp], r1
FFF3229F  6101                              cmp     #0, r1
FFF322A1  10                                beq.s   loc_FFF322A9
FFF322A2  f90601d8                          mov.l   #-28h, 90h+var_8C[sp]
FFF322A6  383307                            bra.w   loc_FFF329D9
FFF322A9  3e8c00                 loc_FFF322A9 mov.l   #0, 90h+var_20[sp]
FFF322AC  2e6f                              bra.b   loc_FFF3231B
FFF322AE  aa89                   loc_FFF322AE mov.l   90h+var_64[sp], r1
FFF322B0  ce1e4204                          mov.b   442h[r1], r14
FFF322B4  610e                              cmp     #0, r14
FFF322B6  210c                              bne.b   loc_FFF322C2
FFF322B8  590167                            movu.b  90h+var_29[sp], r1
FFF322BB  6101                              cmp     #0, r1
FFF322BD  1d                                bne.s   loc_FFF322C2
FFF322BE  f80601                            mov.l   #1, 90h+var_90[sp]
FFF322C1  0c                                bra.s   loc_FFF322C5
FFF322C2  f80600                 loc_FFF322C2 mov.l   #0, 90h+var_90[sp]
FFF322C5  ec01                   loc_FFF322C5 mov.l   90h+var_90[sp], r1
FFF322C7  6101                              cmp     #0, r1
FFF322C9  200c                              beq.b   loc_FFF322D5
FFF322CB  f9046701                          mov.b   #1, 90h+var_29[sp]
FFF322CF  e5000b0a                          mov.l   90h+var_64[sp], 90h+var_68[sp]
FFF322D3  2e3a                              bra.b   locret_FFF3230D
FFF322D5  ed0223                 loc_FFF322D5 mov.l   90h+var_4[sp], r2
FFF322D8  aa89                              mov.l   90h+var_64[sp], r1
FFF322DA  72113c02                          add     #23Ch, r1, r1
FFF322DE  05e219ff                          bsr.a   sub_FFF23CC0
FFF322E2  6101                              cmp     #0, r1
FFF322E4  210d                              bne.b   loc_FFF322F1
FFF322E6  058e3afe                          bsr.a   sub_FFF15D74
FFF322EA  f90601f9                          mov.l   #-7, 90h+var_8C[sp]
FFF322EE  38eb06                            bra.w   loc_FFF329D9
FFF322F1  ed0222                 loc_FFF322F1 mov.l   90h+var_8[sp], r2
FFF322F4  aa89                              mov.l   90h+var_64[sp], r1
FFF322F6  72113c02                          add     #23Ch, r1, r1
FFF322FA  05c619ff                          bsr.a   sub_FFF23CC0
FFF322FE  6101                              cmp     #0, r1
FFF32300  210d                              bne.b   locret_FFF3230D
FFF32302  05723afe                          bsr.a   sub_FFF15D74
FFF32306  f90601f9                          mov.l   #-7, 90h+var_8C[sp]
FFF3230A  38cf06                            bra.w   loc_FFF329D9
FFF3230D  af01                   locret_FFF3230D mov.l   90h+var_20[sp], r1
FFF3230F  6211                              add     #1, r1
FFF32311  a701                              mov.l   r1, 90h+var_20[sp]
FFF32313  aa89                              mov.l   90h+var_64[sp], r1
FFF32315  72116804                          add     #468h, r1, r1
FFF32319  a289                              mov.l   r1, 90h+var_64[sp]
FFF3231B  fbe212250100           loc_FFF3231B mov.l   #12512h, r14
FFF32321  dcee                              mov.w   [r14], r14
FFF32323  06850e1c                          cmp     90h+var_20[sp].l, r14
FFF32327  2a87                              bgt.b   loc_FFF322AE
FFF32329  590167                            movu.b  90h+var_29[sp], r1
FFF3232C  6101                              cmp     #0, r1
FFF3232E  210d                              bne.b   loc_FFF3233B
FFF32330  05443afe                          bsr.a   sub_FFF15D74
FFF32334  f90601f6                          mov.l   #-0Ah, 90h+var_8C[sp]
FFF32338  38a106                            bra.w   loc_FFF329D9
FFF3233B  aa81                   loc_FFF3233B mov.l   90h+var_68[sp], r1
FFF3233D  6101                              cmp     #0, r1
FFF3233F  210d                              bne.b   loc_FFF3234C
FFF32341  05333afe                          bsr.a   sub_FFF15D74
FFF32345  f90601f3                          mov.l   #-0Dh, 90h+var_8C[sp]
FFF32349  389006                            bra.w   loc_FFF329D9
FFF3234C  ed0123                 loc_FFF3234C mov.l   90h+var_4[sp], r1
FFF3234F  cc11                              mov.b   [r1], r1
FFF32351  053ac4ff                          bsr.a   sub_FFF2E78B
FFF32355  c7016f                            mov.b   r1, 90h+var_21[sp]
FFF32358  59016f                            movu.b  90h+var_21[sp], r1
FFF3235B  710230                            add     #90h+var_60, sp, r2
FFF3235E  05c1cbfe                          bsr.a   sub_FFF1EF1F
FFF32362  a709                              mov.l   r1, 90h+var_1C[sp]
FFF32364  af09                              mov.l   90h+var_1C[sp], r1
FFF32366  6101                              cmp     #0, r1
FFF32368  200d                              beq.b   loc_FFF32375
FFF3236A  050a3afe                          bsr.a   sub_FFF15D74
FFF3236E  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF32372  386706                            bra.w   loc_FFF329D9
FFF32375  e5000a0b               loc_FFF32375 mov.l   90h+var_68[sp], 90h+var_64[sp]
FFF32379  ab01                              mov.l   90h+var_60[sp], r1
FFF3237B  ad9c                              mov.l   5Ch[r1], r4
FFF3237D  aa89                              mov.l   90h+var_64[sp], r1
FFF3237F  fb3a6804                          mov.l   #468h, r3
FFF32383  6602                              mov.l   #0, r2
FFF32385  052ac1ff                          bsr.a   sub_FFF2E4AF
FFF32389  aa89                              mov.l   90h+var_64[sp], r1
FFF3238B  fa144204ff                        mov.b   #-1, 442h[r1]
FFF32390  05e439fe                          bsr.a   sub_FFF15D74
FFF32394  ab01                              mov.l   90h+var_60[sp], r1
FFF32396  b892                              movu.w  4[r1], r2
FFF32398  068d1217                          mul     5Ch[r1].l, r2
FFF3239C  a382                              mov.l   r2, 90h+var_58[sp]
FFF3239E  ab01                              mov.l   90h+var_60[sp], r1
FFF323A0  05bdcbfe                          bsr.a   sub_FFF1EF5D
FFF323A4  a709                              mov.l   r1, 90h+var_1C[sp]
FFF323A6  af09                              mov.l   90h+var_1C[sp], r1
FFF323A8  6101                              cmp     #0, r1
FFF323AA  2010                              beq.b   loc_FFF323BA
FFF323AC  aa89                              mov.l   90h+var_64[sp], r1
FFF323AE  fa14420400                        mov.b   #0, 442h[r1]
FFF323B3  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF323B7  382206                            bra.w   loc_FFF329D9
FFF323BA  ab01                   loc_FFF323BA mov.l   90h+var_60[sp], r1
FFF323BC  05d5cbfe                          bsr.a   sub_FFF1EF91
FFF323C0  a709                              mov.l   r1, 90h+var_1C[sp]
FFF323C2  af09                              mov.l   90h+var_1C[sp], r1
FFF323C4  6101                              cmp     #0, r1
FFF323C6  aa89                              mov.l   90h+var_64[sp], r1
FFF323C8  200e                              beq.b   loc_FFF323D6
FFF323CA  fa14420400                        mov.b   #0, 442h[r1]
FFF323CF  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF323D3  380606                            bra.w   loc_FFF329D9
FFF323D6  e1010c                 loc_FFF323D6 mov.l   90h+var_60[sp], [r1]
FFF323D9  ed0123                            mov.l   90h+var_4[sp], r1
FFF323DC  6241                              add     #4, r1
FFF323DE  a681                              mov.l   r1, 90h+var_28[sp]
FFF323E0  ab01                              mov.l   90h+var_60[sp], r1
FFF323E2  e5100d18                          mov.l   34h[r1], 90h+var_30[sp]
FFF323E6  ab01                              mov.l   90h+var_60[sp], r1
FFF323E8  8c11                              mov.b   10h[r1], r1
FFF323EA  755120                            cmp     #20h, r1 ; ' '
FFF323ED  3a4c01                            beq.w   loc_FFF32539
FFF323F0  af8a                              mov.l   90h+var_14[sp], r2
FFF323F2  ae81                              mov.l   90h+var_28[sp], r1
FFF323F4  051f10ff                          bsr.a   sub_FFF23413
FFF323F8  a681                              mov.l   r1, 90h+var_28[sp]
FFF323FA  ae81                              mov.l   90h+var_28[sp], r1
FFF323FC  6101                              cmp     #0, r1
FFF323FE  2110                              bne.b   locret_FFF3240E
FFF32400  aa89                              mov.l   90h+var_64[sp], r1
FFF32402  fa14420400                        mov.b   #0, 442h[r1]
FFF32407  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF3240B  38ce05                            bra.w   loc_FFF329D9
FFF3240E  af89                   locret_FFF3240E mov.l   90h+var_14[sp], r1
FFF32410  cc1e                              mov.b   [r1], r14
FFF32412  610e                              cmp     #0, r14
FFF32414  210d                              bne.b   loc_FFF32421
FFF32416  af89                              mov.l   90h+var_14[sp], r1
FFF32418  8819                              mov.b   1[r1], r1
FFF3241A  6101                              cmp     #0, r1
FFF3241C  1d                                bne.s   loc_FFF32421
FFF3241D  f80601                            mov.l   #1, 90h+var_90[sp]
FFF32420  0c                                bra.s   loc_FFF32424
FFF32421  f80600                 loc_FFF32421 mov.l   #0, 90h+var_90[sp]
FFF32424  ec01                   loc_FFF32424 mov.l   90h+var_90[sp], r1
FFF32426  6101                              cmp     #0, r1
FFF32428  2010                              beq.b   locret_FFF32438
FFF3242A  aa89                              mov.l   90h+var_64[sp], r1
FFF3242C  fa14420400                        mov.b   #0, 442h[r1]
FFF32431  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF32435  38a405                            bra.w   loc_FFF329D9
FFF32438  af8a                   locret_FFF32438 mov.l   90h+var_14[sp], r2
FFF3243A  ab01                              mov.l   90h+var_60[sp], r1
FFF3243C  60c0                              sub     #0Ch, sp
FFF3243E  a082                              mov.l   r2, 9Ch+var_94[sp]
FFF32440  710360                            add     #9Ch+var_3C, sp, r3
FFF32443  a00b                              mov.l   r3, 9Ch+var_98[sp]
FFF32445  f80400                            mov.b   #0, 9Ch+var_9C[sp]
FFF32448  6604                              mov.l   #0, r4
FFF3244A  710314                            add     #9Ch+var_88, sp, r3
FFF3244D  057d02ff                          bsr.a   sub_FFF226CA
FFF32451  62c0                              add     #0Ch, sp
FFF32453  a709                              mov.l   r1, 90h+var_1C[sp]
FFF32455  af09                              mov.l   90h+var_1C[sp], r1
FFF32457  6101                              cmp     #0, r1
FFF32459  201e                              beq.b   loc_FFF32477
FFF3245B  ae81                              mov.l   90h+var_28[sp], r1
FFF3245D  cc1e                              mov.b   [r1], r14
FFF3245F  aa89                              mov.l   90h+var_64[sp], r1
FFF32461  fa14420400                        mov.b   #0, 442h[r1]
FFF32466  610e                              cmp     #0, r14
FFF32468  10                                beq.s   loc_FFF32470
FFF32469  f90601fc                          mov.l   #-4, 90h+var_8C[sp]
FFF3246D  386c05                            bra.w   loc_FFF329D9
FFF32470  f90601fd               loc_FFF32470 mov.l   #-3, 90h+var_8C[sp]
FFF32474  386505                            bra.w   loc_FFF329D9
FFF32477  ab01                   loc_FFF32477 mov.l   90h+var_60[sp], r1
FFF32479  8c12                              mov.b   10h[r1], r2
FFF3247B  710108                            add     #90h+var_88, sp, r1
FFF3247E  051ae2fe                          bsr.a   sub_FFF20698
FFF32482  a601                              mov.l   r1, 90h+var_30[sp]
FFF32484  38b500                            bra.w   loc_FFF32539
FFF32487  af8a                   locret_FFF32487 mov.l   90h+var_14[sp], r2
FFF32489  ae81                              mov.l   90h+var_28[sp], r1
FFF3248B  05880fff                          bsr.a   sub_FFF23413
FFF3248F  a681                              mov.l   r1, 90h+var_28[sp]
FFF32491  ae81                              mov.l   90h+var_28[sp], r1
FFF32493  6101                              cmp     #0, r1
FFF32495  2110                              bne.b   locret_FFF324A5
FFF32497  aa89                              mov.l   90h+var_64[sp], r1
FFF32499  fa14420400                        mov.b   #0, 442h[r1]
FFF3249E  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF324A2  383705                            bra.w   loc_FFF329D9
FFF324A5  af89                   locret_FFF324A5 mov.l   90h+var_14[sp], r1
FFF324A7  cc1e                              mov.b   [r1], r14
FFF324A9  610e                              cmp     #0, r14
FFF324AB  210d                              bne.b   loc_FFF324B8
FFF324AD  af89                              mov.l   90h+var_14[sp], r1
FFF324AF  8819                              mov.b   1[r1], r1
FFF324B1  6101                              cmp     #0, r1
FFF324B3  1d                                bne.s   loc_FFF324B8
FFF324B4  f80601                            mov.l   #1, 90h+var_90[sp]
FFF324B7  0c                                bra.s   loc_FFF324BB
FFF324B8  f80600                 loc_FFF324B8 mov.l   #0, 90h+var_90[sp]
FFF324BB  ec01                   loc_FFF324BB mov.l   90h+var_90[sp], r1
FFF324BD  6101                              cmp     #0, r1
FFF324BF  2010                              beq.b   loc_FFF324CF
FFF324C1  aa89                              mov.l   90h+var_64[sp], r1
FFF324C3  fa14420400                        mov.b   #0, 442h[r1]
FFF324C8  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF324CC  380d05                            bra.w   loc_FFF329D9
FFF324CF  e5001817               loc_FFF324CF mov.l   90h+var_30[sp], 90h+var_34[sp]
FFF324D3  af8b                              mov.l   90h+var_14[sp], r3
FFF324D5  ae02                              mov.l   90h+var_30[sp], r2
FFF324D7  ab01                              mov.l   90h+var_60[sp], r1
FFF324D9  7100f0                            add     #-10h, sp, sp
FFF324DC  a08b                              mov.l   r3, 0A0h+var_94[sp]
FFF324DE  710460                            add     #0A0h+var_40, sp, r4
FFF324E1  a084                              mov.l   r4, 0A0h+var_98[sp]
FFF324E3  710464                            add     #0A0h+var_3C, sp, r4
FFF324E6  a00c                              mov.l   r4, 0A0h+var_9C[sp]
FFF324E8  3c0100                            mov.b   #0, 0A0h+var_9F[sp]
FFF324EB  f80400                            mov.b   #0, 0A0h+var_A0[sp]
FFF324EE  710418                            add     #0A0h+var_88, sp, r4
FFF324F1  054a06ff                          bsr.a   sub_FFF22B3B
FFF324F5  710010                            add     #10h, sp, sp
FFF324F8  a709                              mov.l   r1, 90h+var_1C[sp]
FFF324FA  af09                              mov.l   90h+var_1C[sp], r1
FFF324FC  6101                              cmp     #0, r1
FFF324FE  202e                              beq.b   loc_FFF3252C
FFF32500  ae81                              mov.l   90h+var_28[sp], r1
FFF32502  cc1e                              mov.b   [r1], r14
FFF32504  610e                              cmp     #0, r14
FFF32506  210c                              bne.b   loc_FFF32512
FFF32508  af09                              mov.l   90h+var_1C[sp], r1
FFF3250A  7501fc                            cmp     #-4, r1
FFF3250D  1d                                bne.s   loc_FFF32512
FFF3250E  f80601                            mov.l   #1, 90h+var_90[sp]
FFF32511  0c                                bra.s   loc_FFF32515
FFF32512  f80600                 loc_FFF32512 mov.l   #0, 90h+var_90[sp]
FFF32515  ec01                   loc_FFF32515 mov.l   90h+var_90[sp], r1
FFF32517  6101                              cmp     #0, r1
FFF32519  15                                beq.s   loc_FFF3251E
FFF3251A  f9061dfd                          mov.l   #-3, 90h+var_1C[sp]
FFF3251E  aa89                   loc_FFF3251E mov.l   90h+var_64[sp], r1
FFF32520  fa14420400                        mov.b   #0, 442h[r1]
FFF32525  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF32529  38b004                            bra.w   loc_FFF329D9
FFF3252C  ab01                   loc_FFF3252C mov.l   90h+var_60[sp], r1
FFF3252E  8c12                              mov.b   10h[r1], r2
FFF32530  710108                            add     #90h+var_88, sp, r1
FFF32533  0565e1fe                          bsr.a   sub_FFF20698
FFF32537  a601                              mov.l   r1, 90h+var_30[sp]
FFF32539  ae81                   loc_FFF32539 mov.l   90h+var_28[sp], r1
FFF3253B  cc1e                              mov.b   [r1], r14
FFF3253D  610e                              cmp     #0, r14
FFF3253F  3b48ff                            bne.w   locret_FFF32487
FFF32542  b489                              movu.b  90h+var_7D[sp], r1
FFF32544  752110                            and     #10h, r1
FFF32547  755110                            cmp     #10h, r1
FFF3254A  aa89                              mov.l   90h+var_64[sp], r1
FFF3254C  210e                              bne.b   loc_FFF3255A
FFF3254E  fa14420400                        mov.b   #0, 442h[r1]
FFF32553  f90601fd                          mov.l   #-3, 90h+var_8C[sp]
FFF32557  388204                            bra.w   loc_FFF329D9
FFF3255A  e5011506               loc_FFF3255A mov.l   90h+var_3C[sp], 18h[r1]
FFF3255E  ad89                              mov.l   90h+var_34[sp], r1
FFF32560  6101                              cmp     #0, r1
FFF32562  aa8e                              mov.l   90h+var_64[sp], r6
FFF32564  200f                              beq.b   loc_FFF32573
FFF32566  fa64440401                        mov.b   #1, 444h[r6]
FFF3256B  ad06                              mov.l   90h+var_40[sp], r6
FFF3256D  aa89                              mov.l   90h+var_64[sp], r1
FFF3256F  a21e                              mov.l   r6, 24h[r1]
FFF32571  2e0c                              bra.b   loc_FFF3257D
FFF32573  ab01                   loc_FFF32573 mov.l   90h+var_60[sp], r1
FFF32575  6602                              mov.l   #0, r2
FFF32577  0535cafe                          bsr.a   sub_FFF1EFAC
FFF3257B  a269                              mov.l   r1, 24h[r6]
FFF3257D  aa8e                   loc_FFF3257D mov.l   90h+var_64[sp], r6
FFF3257F  710124                            add     #90h+var_6C, sp, r1
FFF32582  0598c7ff                          bsr.a   sub_FFF2ED1A
FFF32586  a2e9                              mov.l   r1, 2Ch[r6]
FFF32588  aa89                              mov.l   90h+var_64[sp], r1
FFF3258A  e5110b0c                          mov.l   2Ch[r1], 30h[r1]
FFF3258E  ab01                              mov.l   90h+var_60[sp], r1
FFF32590  8c12                              mov.b   10h[r1], r2
FFF32592  aa8e                              mov.l   90h+var_64[sp], r6
FFF32594  710108                            add     #90h+var_88, sp, r1
FFF32597  0501e1fe                          bsr.a   sub_FFF20698
FFF3259B  a1e9                              mov.l   r1, 1Ch[r6]
FFF3259D  aa8e                              mov.l   90h+var_64[sp], r6
FFF3259F  a9ea                              mov.l   1Ch[r6], r2
FFF325A1  ab01                              mov.l   90h+var_60[sp], r1
FFF325A3  0509cafe                          bsr.a   sub_FFF1EFAC
FFF325A7  a261                              mov.l   r1, 20h[r6]
FFF325A9  b489                              movu.b  90h+var_7D[sp], r1
FFF325AB  aa8a                              mov.l   90h+var_64[sp], r2
FFF325AD  cb214304                          mov.b   r1, 443h[r2]
FFF325B1  aa8e                              mov.l   90h+var_64[sp], r6
FFF325B3  71011e                            add     #90h+var_72, sp, r1
FFF325B6  05eec6ff                          bsr.a   sub_FFF2ECA4
FFF325BA  db611a01                          mov.w   r1, 234h[r6]
FFF325BE  aa8e                              mov.l   90h+var_64[sp], r6
FFF325C0  710120                            add     #90h+var_70, sp, r1
FFF325C3  05e1c6ff                          bsr.a   sub_FFF2ECA4
FFF325C7  db611b01                          mov.w   r1, 236h[r6]
FFF325CB  aa89                              mov.l   90h+var_64[sp], r1
FFF325CD  aa99                              mov.l   2Ch[r1], r1
FFF325CF  6101                              cmp     #0, r1
FFF325D1  2110                              bne.b   loc_FFF325E1
FFF325D3  aa89                              mov.l   90h+var_64[sp], r1
FFF325D5  fa14420400                        mov.b   #0, 442h[r1]
FFF325DA  f90601f3                          mov.l   #-0Dh, 90h+var_8C[sp]
FFF325DE  38fb03                            bra.w   loc_FFF329D9
FFF325E1  ed0122                 loc_FFF325E1 mov.l   90h+var_8[sp], r1
FFF325E4  6241                              add     #4, r1
FFF325E6  a681                              mov.l   r1, 90h+var_28[sp]
FFF325E8  ab01                              mov.l   90h+var_60[sp], r1
FFF325EA  e5100d18                          mov.l   34h[r1], 90h+var_30[sp]
FFF325EE  ab01                              mov.l   90h+var_60[sp], r1
FFF325F0  8c11                              mov.b   10h[r1], r1
FFF325F2  755120                            cmp     #20h, r1 ; ' '
FFF325F5  3a6401                            beq.w   loc_FFF32759
FFF325F8  af8a                              mov.l   90h+var_14[sp], r2
FFF325FA  ae81                              mov.l   90h+var_28[sp], r1
FFF325FC  72220602                          add     #206h, r2, r2
FFF32600  05130eff                          bsr.a   sub_FFF23413
FFF32604  a681                              mov.l   r1, 90h+var_28[sp]
FFF32606  ae81                              mov.l   90h+var_28[sp], r1
FFF32608  6101                              cmp     #0, r1
FFF3260A  2110                              bne.b   locret_FFF3261A
FFF3260C  aa89                              mov.l   90h+var_64[sp], r1
FFF3260E  fa14420400                        mov.b   #0, 442h[r1]
FFF32613  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF32617  38c203                            bra.w   loc_FFF329D9
FFF3261A  af89                   locret_FFF3261A mov.l   90h+var_14[sp], r1
FFF3261C  ce1e0602                          mov.b   206h[r1], r14
FFF32620  610e                              cmp     #0, r14
FFF32622  210f                              bne.b   loc_FFF32631
FFF32624  af89                              mov.l   90h+var_14[sp], r1
FFF32626  ce1e0702                          mov.b   207h[r1], r14
FFF3262A  610e                              cmp     #0, r14
FFF3262C  1d                                bne.s   loc_FFF32631
FFF3262D  f80601                            mov.l   #1, 90h+var_90[sp]
FFF32630  0c                                bra.s   loc_FFF32634
FFF32631  f80600                 loc_FFF32631 mov.l   #0, 90h+var_90[sp]
FFF32634  ec01                   loc_FFF32634 mov.l   90h+var_90[sp], r1
FFF32636  6101                              cmp     #0, r1
FFF32638  2010                              beq.b   locret_FFF32648
FFF3263A  aa89                              mov.l   90h+var_64[sp], r1
FFF3263C  fa14420400                        mov.b   #0, 442h[r1]
FFF32641  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF32645  389403                            bra.w   loc_FFF329D9
FFF32648  af8a                   locret_FFF32648 mov.l   90h+var_14[sp], r2
FFF3264A  ab01                              mov.l   90h+var_60[sp], r1
FFF3264C  60c0                              sub     #0Ch, sp
FFF3264E  710360                            add     #9Ch+var_3C, sp, r3
FFF32651  a00b                              mov.l   r3, 9Ch+var_98[sp]
FFF32653  f80400                            mov.b   #0, 9Ch+var_9C[sp]
FFF32656  a082                              mov.l   r2, 9Ch+var_94[sp]
FFF32658  72220602                          add     #206h, r2, r2
FFF3265C  6604                              mov.l   #0, r4
FFF3265E  710314                            add     #9Ch+var_88, sp, r3
FFF32661  056900ff                          bsr.a   sub_FFF226CA
FFF32665  62c0                              add     #0Ch, sp
FFF32667  a709                              mov.l   r1, 90h+var_1C[sp]
FFF32669  af09                              mov.l   90h+var_1C[sp], r1
FFF3266B  6101                              cmp     #0, r1
FFF3266D  201e                              beq.b   loc_FFF3268B
FFF3266F  ae81                              mov.l   90h+var_28[sp], r1
FFF32671  cc1e                              mov.b   [r1], r14
FFF32673  aa89                              mov.l   90h+var_64[sp], r1
FFF32675  fa14420400                        mov.b   #0, 442h[r1]
FFF3267A  610e                              cmp     #0, r14
FFF3267C  10                                beq.s   loc_FFF32684
FFF3267D  f90601fc                          mov.l   #-4, 90h+var_8C[sp]
FFF32681  385803                            bra.w   loc_FFF329D9
FFF32684  f90601fd               loc_FFF32684 mov.l   #-3, 90h+var_8C[sp]
FFF32688  385103                            bra.w   loc_FFF329D9
FFF3268B  ab01                   loc_FFF3268B mov.l   90h+var_60[sp], r1
FFF3268D  8c12                              mov.b   10h[r1], r2
FFF3268F  710108                            add     #90h+var_88, sp, r1
FFF32692  0506e0fe                          bsr.a   sub_FFF20698
FFF32696  a601                              mov.l   r1, 90h+var_30[sp]
FFF32698  38c100                            bra.w   loc_FFF32759
FFF3269B  af8a                   locret_FFF3269B mov.l   90h+var_14[sp], r2
FFF3269D  ae81                              mov.l   90h+var_28[sp], r1
FFF3269F  72220602                          add     #206h, r2, r2
FFF326A3  05700dff                          bsr.a   sub_FFF23413
FFF326A7  a681                              mov.l   r1, 90h+var_28[sp]
FFF326A9  ae81                              mov.l   90h+var_28[sp], r1
FFF326AB  6101                              cmp     #0, r1
FFF326AD  2110                              bne.b   locret_FFF326BD
FFF326AF  aa89                              mov.l   90h+var_64[sp], r1
FFF326B1  fa14420400                        mov.b   #0, 442h[r1]
FFF326B6  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF326BA  381f03                            bra.w   loc_FFF329D9
FFF326BD  af89                   locret_FFF326BD mov.l   90h+var_14[sp], r1
FFF326BF  ce1e0602                          mov.b   206h[r1], r14
FFF326C3  610e                              cmp     #0, r14
FFF326C5  210f                              bne.b   loc_FFF326D4
FFF326C7  af89                              mov.l   90h+var_14[sp], r1
FFF326C9  ce1e0702                          mov.b   207h[r1], r14
FFF326CD  610e                              cmp     #0, r14
FFF326CF  1d                                bne.s   loc_FFF326D4
FFF326D0  f80601                            mov.l   #1, 90h+var_90[sp]
FFF326D3  0c                                bra.s   loc_FFF326D7
FFF326D4  f80600                 loc_FFF326D4 mov.l   #0, 90h+var_90[sp]
FFF326D7  ec01                   loc_FFF326D7 mov.l   90h+var_90[sp], r1
FFF326D9  6101                              cmp     #0, r1
FFF326DB  2010                              beq.b   loc_FFF326EB
FFF326DD  aa89                              mov.l   90h+var_64[sp], r1
FFF326DF  fa14420400                        mov.b   #0, 442h[r1]
FFF326E4  f90601ff                          mov.l   #-1, 90h+var_8C[sp]
FFF326E8  38f102                            bra.w   loc_FFF329D9
FFF326EB  e5001816               loc_FFF326EB mov.l   90h+var_30[sp], 90h+var_38[sp]
FFF326EF  af8b                              mov.l   90h+var_14[sp], r3
FFF326F1  ae02                              mov.l   90h+var_30[sp], r2
FFF326F3  ab01                              mov.l   90h+var_60[sp], r1
FFF326F5  7100f0                            add     #-10h, sp, sp
FFF326F8  710460                            add     #0A0h+var_40, sp, r4
FFF326FB  a084                              mov.l   r4, 0A0h+var_98[sp]
FFF326FD  710464                            add     #0A0h+var_3C, sp, r4
FFF32700  a00c                              mov.l   r4, 0A0h+var_9C[sp]
FFF32702  3c0100                            mov.b   #0, 0A0h+var_9F[sp]
FFF32705  f80400                            mov.b   #0, 0A0h+var_A0[sp]
FFF32708  a08b                              mov.l   r3, 0A0h+var_94[sp]
FFF3270A  72330602                          add     #206h, r3, r3
FFF3270E  710418                            add     #0A0h+var_88, sp, r4
FFF32711  052a04ff                          bsr.a   sub_FFF22B3B
FFF32715  710010                            add     #10h, sp, sp
FFF32718  a709                              mov.l   r1, 90h+var_1C[sp]
FFF3271A  af09                              mov.l   90h+var_1C[sp], r1
FFF3271C  6101                              cmp     #0, r1
FFF3271E  202e                              beq.b   loc_FFF3274C
FFF32720  ae81                              mov.l   90h+var_28[sp], r1
FFF32722  cc1e                              mov.b   [r1], r14
FFF32724  610e                              cmp     #0, r14
FFF32726  210c                              bne.b   loc_FFF32732
FFF32728  af09                              mov.l   90h+var_1C[sp], r1
FFF3272A  7501fc                            cmp     #-4, r1
FFF3272D  1d                                bne.s   loc_FFF32732
FFF3272E  f80601                            mov.l   #1, 90h+var_90[sp]
FFF32731  0c                                bra.s   loc_FFF32735
FFF32732  f80600                 loc_FFF32732 mov.l   #0, 90h+var_90[sp]
FFF32735  ec01                   loc_FFF32735 mov.l   90h+var_90[sp], r1
FFF32737  6101                              cmp     #0, r1
FFF32739  15                                beq.s   loc_FFF3273E
FFF3273A  f9061dfd                          mov.l   #-3, 90h+var_1C[sp]
FFF3273E  aa89                   loc_FFF3273E mov.l   90h+var_64[sp], r1
FFF32740  fa14420400                        mov.b   #0, 442h[r1]
FFF32745  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF32749  389002                            bra.w   loc_FFF329D9
FFF3274C  ab01                   loc_FFF3274C mov.l   90h+var_60[sp], r1
FFF3274E  8c12                              mov.b   10h[r1], r2
FFF32750  710108                            add     #90h+var_88, sp, r1
FFF32753  0545dffe                          bsr.a   sub_FFF20698
FFF32757  a601                              mov.l   r1, 90h+var_30[sp]
FFF32759  ae81                   loc_FFF32759 mov.l   90h+var_28[sp], r1
FFF3275B  cc1e                              mov.b   [r1], r14
FFF3275D  610e                              cmp     #0, r14
FFF3275F  3b3cff                            bne.w   locret_FFF3269B
FFF32762  b489                              movu.b  90h+var_7D[sp], r1
FFF32764  752110                            and     #10h, r1
FFF32767  755110                            cmp     #10h, r1
FFF3276A  2110                              bne.b   loc_FFF3277A
FFF3276C  aa89                              mov.l   90h+var_64[sp], r1
FFF3276E  fa14420400                        mov.b   #0, 442h[r1]
FFF32773  f90601fd                          mov.l   #-3, 90h+var_8C[sp]
FFF32777  386202                            bra.w   loc_FFF329D9
FFF3277A  710124                 loc_FFF3277A add     #90h+var_6C, sp, r1
FFF3277D  059dc5ff                          bsr.a   sub_FFF2ED1A
FFF32781  a309                              mov.l   r1, 90h+var_5C[sp]
FFF32783  ab09                              mov.l   90h+var_5C[sp], r1
FFF32785  6101                              cmp     #0, r1
FFF32787  aa89                              mov.l   90h+var_64[sp], r1
FFF32789  210e                              bne.b   loc_FFF32797
FFF3278B  fa14420400                        mov.b   #0, 442h[r1]
FFF32790  f90601f3                          mov.l   #-0Dh, 90h+var_8C[sp]
FFF32794  384502                            bra.w   loc_FFF329D9
FFF32797  aa99                   loc_FFF32797 mov.l   2Ch[r1], r1
FFF32799  ab82                              mov.l   90h+var_58[sp], r2
FFF3279B  ef1e                              mov.l   r1, r14
FFF3279D  fc272e                            divu    r2, r14
FFF327A0  4f2e                              mul     r2, r14
FFF327A2  43e1                              sub     r14, r1
FFF327A4  6101                              cmp     #0, r1
FFF327A6  2018                              beq.b   loc_FFF327BE
FFF327A8  aa89                              mov.l   90h+var_64[sp], r1
FFF327AA  aa9a                              mov.l   2Ch[r1], r2
FFF327AC  ab83                              mov.l   90h+var_58[sp], r3
FFF327AE  ef2e                              mov.l   r2, r14
FFF327B0  fc273e                            divu    r3, r14
FFF327B3  4f3e                              mul     r3, r14
FFF327B5  ff0ee2                            sub     r14, r2, r14
FFF327B8  43e3                              sub     r14, r3
FFF327BA  4b32                              add     r3, r2
FFF327BC  a29a                              mov.l   r2, 2Ch[r1]
FFF327BE  aa89                   loc_FFF327BE mov.l   90h+var_64[sp], r1
FFF327C0  aa99                              mov.l   2Ch[r1], r1
FFF327C2  6101                              cmp     #0, r1
FFF327C4  2010                              beq.b   loc_FFF327D4
FFF327C6  660e                              mov.l   #0, r14
FFF327C8  aa89                              mov.l   90h+var_64[sp], r1
FFF327CA  06811e0b                          sub     2Ch[r1].l, r14
FFF327CE  06850e0d                          cmp     90h+var_5C[sp].l, r14
FFF327D2  2206                              bgeu.b  loc_FFF327D8
FFF327D4  f80601                 loc_FFF327D4 mov.l   #1, 90h+var_90[sp]
FFF327D7  0c                                bra.s   loc_FFF327DB
FFF327D8  f80600                 loc_FFF327D8 mov.l   #0, 90h+var_90[sp]
FFF327DB  ec01                   loc_FFF327DB mov.l   90h+var_90[sp], r1
FFF327DD  6101                              cmp     #0, r1
FFF327DF  aa89                              mov.l   90h+var_64[sp], r1
FFF327E1  200e                              beq.b   loc_FFF327EF
FFF327E3  fa14420400                        mov.b   #0, 442h[r1]
FFF327E8  f90601c5                          mov.l   #-3Bh, 90h+var_8C[sp]
FFF327EC  38ed01                            bra.w   loc_FFF329D9
FFF327EF  aa9a                   loc_FFF327EF mov.l   2Ch[r1], r2
FFF327F1  0689020d                          add     90h+var_5C[sp].l, r2
FFF327F5  a29a                              mov.l   r2, 2Ch[r1]
FFF327F7  aa89                              mov.l   90h+var_64[sp], r1
FFF327F9  aa99                              mov.l   2Ch[r1], r1
FFF327FB  6101                              cmp     #0, r1
FFF327FD  1f                                bne.s   loc_FFF32804
FFF327FE  aa89                              mov.l   90h+var_64[sp], r1
FFF32800  f9160bff                          mov.l   #-1, 2Ch[r1]
FFF32804  aa89                   loc_FFF32804 mov.l   90h+var_64[sp], r1
FFF32806  ab11                              mov.l   30h[r1], r1
FFF32808  06a109010e                        divu    90h+var_58[sp].l, r1
FFF3280D  a481                              mov.l   r1, 90h+var_48[sp]
FFF3280F  aa89                              mov.l   90h+var_64[sp], r1
FFF32811  ab11                              mov.l   30h[r1], r1
FFF32813  ab82                              mov.l   90h+var_58[sp], r2
FFF32815  ef1e                              mov.l   r1, r14
FFF32817  fc272e                            divu    r2, r14
FFF3281A  4f2e                              mul     r2, r14
FFF3281C  43e1                              sub     r14, r1
FFF3281E  6101                              cmp     #0, r1
FFF32820  15                                beq.s   loc_FFF32825
FFF32821  f80601                            mov.l   #1, 90h+var_90[sp]
FFF32824  0c                                bra.s   loc_FFF32828
FFF32825  f80600                 loc_FFF32825 mov.l   #0, 90h+var_90[sp]
FFF32828  ac81                   loc_FFF32828 mov.l   90h+var_48[sp], r1
FFF3282A  068801                            add     [sp].l, r1
FFF3282D  a481                              mov.l   r1, 90h+var_48[sp]
FFF3282F  aa89                              mov.l   90h+var_64[sp], r1
FFF32831  e5100713                          mov.l   1Ch[r1], 90h+var_44[sp]
FFF32835  f90210ffffff0f                    mov.l   #0FFFFFFFh, 90h+var_50[sp]
FFF3283C  3e8100                            mov.l   #0, 90h+var_4C[sp]
FFF3283F  2e6f                              bra.b   loc_FFF328AE
FFF32841  af8a                   locret_FFF32841 mov.l   90h+var_14[sp], r2
FFF32843  ac8b                              mov.l   90h+var_44[sp], r3
FFF32845  ab01                              mov.l   90h+var_60[sp], r1
FFF32847  6080                              sub     #8, sp
FFF32849  a00a                              mov.l   r2, 98h+var_94[sp]
FFF3284B  f80472                            mov.b   #72h, 98h+var_98[sp] ; 'r'
FFF3284E  6604                              mov.l   #0, r4
FFF32850  710248                            add     #98h+var_50, sp, r2
FFF32853  05dc1aff                          bsr.a   sub_FFF2432F
FFF32857  6280                              add     #8, sp
FFF32859  a709                              mov.l   r1, 90h+var_1C[sp]
FFF3285B  af09                              mov.l   90h+var_1C[sp], r1
FFF3285D  6101                              cmp     #0, r1
FFF3285F  2010                              beq.b   loc_FFF3286F
FFF32861  aa89                              mov.l   90h+var_64[sp], r1
FFF32863  fa14420400                        mov.b   #0, 442h[r1]
FFF32868  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF3286C  386d01                            bra.w   loc_FFF329D9
FFF3286F  ac01                   loc_FFF3286F mov.l   90h+var_50[sp], r1
FFF32871  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF32877  232f                              bltu.b  loc_FFF328A6
FFF32879  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF3287F  2310                              bltu.b  loc_FFF3288F
FFF32881  ac01                              mov.l   90h+var_50[sp], r1
FFF32883  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF32889  2406                              bgtu.b  loc_FFF3288F
FFF3288B  f80601                            mov.l   #1, 90h+var_90[sp]
FFF3288E  0c                                bra.s   loc_FFF32892
FFF3288F  f80600                 loc_FFF3288F mov.l   #0, 90h+var_90[sp]
FFF32892  ec01                   loc_FFF32892 mov.l   90h+var_90[sp], r1
FFF32894  6101                              cmp     #0, r1
FFF32896  2120                              bne.b   loc_FFF328B6
FFF32898  aa89                              mov.l   90h+var_64[sp], r1
FFF3289A  fa14420400                        mov.b   #0, 442h[r1]
FFF3289F  f90601c3                          mov.l   #-3Dh, 90h+var_8C[sp]
FFF328A3  383601                            bra.w   loc_FFF329D9
FFF328A6  a489                   loc_FFF328A6 mov.l   r1, 90h+var_44[sp]
FFF328A8  ac09                              mov.l   90h+var_4C[sp], r1
FFF328AA  6211                              add     #1, r1
FFF328AC  a409                              mov.l   r1, 90h+var_4C[sp]
FFF328AE  ac09                   loc_FFF328AE mov.l   90h+var_4C[sp], r1
FFF328B0  06850112                          cmp     90h+var_48[sp].l, r1
FFF328B4  238d                              bltu.b  locret_FFF32841
FFF328B6  ac01                   loc_FFF328B6 mov.l   90h+var_50[sp], r1
FFF328B8  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF328BE  2410                              bgtu.b  loc_FFF328CE
FFF328C0  aa89                              mov.l   90h+var_64[sp], r1
FFF328C2  fa14420400                        mov.b   #0, 442h[r1]
FFF328C7  f90601b9                          mov.l   #-47h, 90h+var_8C[sp]
FFF328CB  380e01                            bra.w   loc_FFF329D9
FFF328CE  ab01                   loc_FFF328CE mov.l   90h+var_60[sp], r1
FFF328D0  8c12                              mov.b   10h[r1], r2
FFF328D2  710108                            add     #90h+var_88, sp, r1
FFF328D5  05c3ddfe                          bsr.a   sub_FFF20698
FFF328D9  a401                              mov.l   r1, 90h+var_50[sp]
FFF328DB  ad81                              mov.l   90h+var_38[sp], r1
FFF328DD  6101                              cmp     #0, r1
FFF328DF  ab01                              mov.l   90h+var_60[sp], r1
FFF328E1  202d                              beq.b   locret_FFF3290E
FFF328E3  af8b                              mov.l   90h+var_14[sp], r3
FFF328E5  ad82                              mov.l   90h+var_38[sp], r2
FFF328E7  7100f0                            add     #-10h, sp, sp
FFF328EA  710460                            add     #0A0h+var_40, sp, r4
FFF328ED  a084                              mov.l   r4, 0A0h+var_98[sp]
FFF328EF  710464                            add     #0A0h+var_3C, sp, r4
FFF328F2  a00c                              mov.l   r4, 0A0h+var_9C[sp]
FFF328F4  3c0100                            mov.b   #0, 0A0h+var_9F[sp]
FFF328F7  f80402                            mov.b   #2, 0A0h+var_A0[sp]
FFF328FA  a08b                              mov.l   r3, 0A0h+var_94[sp]
FFF328FC  72330602                          add     #206h, r3, r3
FFF32900  710418                            add     #0A0h+var_88, sp, r4
FFF32903  053802ff                          bsr.a   sub_FFF22B3B
FFF32907  710010                            add     #10h, sp, sp
FFF3290A  a709                              mov.l   r1, 90h+var_1C[sp]
FFF3290C  2e21                              bra.b   locret_FFF3292D
FFF3290E  af8a                   locret_FFF3290E mov.l   90h+var_14[sp], r2
FFF32910  60c0                              sub     #0Ch, sp
FFF32912  710360                            add     #9Ch+var_3C, sp, r3
FFF32915  a00b                              mov.l   r3, 9Ch+var_98[sp]
FFF32917  f80400                            mov.b   #0, 9Ch+var_9C[sp]
FFF3291A  a082                              mov.l   r2, 9Ch+var_94[sp]
FFF3291C  72220602                          add     #206h, r2, r2
FFF32920  6624                              mov.l   #2, r4
FFF32922  710314                            add     #9Ch+var_88, sp, r3
FFF32925  05a5fdfe                          bsr.a   sub_FFF226CA
FFF32929  62c0                              add     #0Ch, sp
FFF3292B  a709                              mov.l   r1, 90h+var_1C[sp]
FFF3292D  af09                   locret_FFF3292D mov.l   90h+var_1C[sp], r1
FFF3292F  6101                              cmp     #0, r1
FFF32931  2010                              beq.b   locret_FFF32941
FFF32933  aa89                              mov.l   90h+var_64[sp], r1
FFF32935  fa14420400                        mov.b   #0, 442h[r1]
FFF3293A  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF3293E  389b00                            bra.w   loc_FFF329D9
FFF32941  af8a                   locret_FFF32941 mov.l   90h+var_14[sp], r2
FFF32943  ac04                              mov.l   90h+var_50[sp], r4
FFF32945  ac8b                              mov.l   90h+var_44[sp], r3
FFF32947  ab01                              mov.l   90h+var_60[sp], r1
FFF32949  6080                              sub     #8, sp
FFF3294B  a00a                              mov.l   r2, 98h+var_94[sp]
FFF3294D  f80477                            mov.b   #77h, 98h+var_98[sp] ; 'w'
FFF32950  710244                            add     #98h+var_54, sp, r2
FFF32953  05dc19ff                          bsr.a   sub_FFF2432F
FFF32957  6280                              add     #8, sp
FFF32959  a709                              mov.l   r1, 90h+var_1C[sp]
FFF3295B  af09                              mov.l   90h+var_1C[sp], r1
FFF3295D  6101                              cmp     #0, r1
FFF3295F  200f                              beq.b   loc_FFF3296E
FFF32961  aa89                              mov.l   90h+var_64[sp], r1
FFF32963  fa14420400                        mov.b   #0, 442h[r1]
FFF32968  e5001d01                          mov.l   90h+var_1C[sp], 90h+var_8C[sp]
FFF3296C  2e6d                              bra.b   loc_FFF329D9
FFF3296E  ab89                   loc_FFF3296E mov.l   90h+var_54[sp], r1
FFF32970  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF32976  aa89                              mov.l   90h+var_64[sp], r1
FFF32978  210d                              bne.b   locret_FFF32985
FFF3297A  fa14420400                        mov.b   #0, 442h[r1]
FFF3297F  f90601c3                          mov.l   #-3Dh, 90h+var_8C[sp]
