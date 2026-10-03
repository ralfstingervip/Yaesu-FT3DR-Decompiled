; ==== fat_cen  FFF22500-FFF22C80  (file 322500-322C80) ====
FFF22500  01                                cmp     #0, r1
FFF22501  1f                                bne.s   loc_FFF22508
FFF22502  3e0301                            mov.l   #1, 20h+var_14[sp]
FFF22505  388900                            bra.w   loc_FFF2258E
FFF22508  b481                   loc_FFF22508 movu.b  20h+var_E[sp], r1
FFF2250A  05cfb600                          bsr.a   sub_FFF2DBD9
FFF2250E  6101                              cmp     #0, r1
FFF22510  2041                              beq.b   loc_FFF22551
FFF22512  a989                              mov.l   20h+var_4[sp], r1
FFF22514  cc12                              mov.b   [r1], r2
FFF22516  6c82                              shll    #8, r2
FFF22518  551201                            or      1[r1], r2
FFF2251B  9102                              mov.w   r2, 20h+var_18[sp]
FFF2251D  a981                              mov.l   20h+var_8[sp], r1
FFF2251F  cc12                              mov.b   [r1], r2
FFF22521  6c82                              shll    #8, r2
FFF22523  551201                            or      1[r1], r2
FFF22526  908a                              mov.w   r2, 20h+var_1A[sp]
FFF22528  b901                              movu.w  20h+var_18[sp], r1
FFF2252A  39d7fe                            bsr.w   sub_FFF22401
FFF2252D  ef16                              mov.l   r1, r6
FFF2252F  b889                              movu.w  20h+var_1A[sp], r1
FFF22531  39d0fe                            bsr.w   sub_FFF22401
FFF22534  4316                              sub     r1, r6
FFF22536  910e                              mov.w   r6, 20h+var_16[sp]
FFF22538  9909                              mov.w   20h+var_16[sp], r1
FFF2253A  6101                              cmp     #0, r1
FFF2253C  17                                beq.s   loc_FFF22543
FFF2253D  f90603ff                          mov.l   #-1, 20h+var_14[sp]
FFF22541  2e4d                              bra.b   loc_FFF2258E
FFF22543  a989                   loc_FFF22543 mov.l   20h+var_4[sp], r1
FFF22545  6211                              add     #1, r1
FFF22547  a189                              mov.l   r1, 20h+var_4[sp]
FFF22549  a981                              mov.l   20h+var_8[sp], r1
FFF2254B  6211                              add     #1, r1
FFF2254D  a181                              mov.l   r1, 20h+var_8[sp]
FFF2254F  2e1f                              bra.b   loc_FFF2256E
FFF22551  8c89                   loc_FFF22551 mov.b   20h+var_D[sp], r1
FFF22553  0538c200                          bsr.a   sub_FFF2E78B
FFF22557  ef16                              mov.l   r1, r6
FFF22559  8c81                              mov.b   20h+var_E[sp], r1
FFF2255B  0530c200                          bsr.a   sub_FFF2E78B
FFF2255F  4316                              sub     r1, r6
FFF22561  848e                              mov.b   r6, 20h+var_D[sp]
FFF22563  8c89                              mov.b   20h+var_D[sp], r1
FFF22565  6101                              cmp     #0, r1
FFF22567  17                                beq.s   loc_FFF2256E
FFF22568  8c89                              mov.b   20h+var_D[sp], r1
FFF2256A  a089                              mov.l   r1, 20h+var_14[sp]
FFF2256C  2e22                              bra.b   loc_FFF2258E
FFF2256E  a989                   loc_FFF2256E mov.l   20h+var_4[sp], r1
FFF22570  6211                              add     #1, r1
FFF22572  a189                              mov.l   r1, 20h+var_4[sp]
FFF22574  a981                              mov.l   20h+var_8[sp], r1
FFF22576  6211                              add     #1, r1
FFF22578  a181                              mov.l   r1, 20h+var_8[sp]
FFF2257A  a989                   loc_FFF2257A mov.l   20h+var_4[sp], r1
FFF2257C  c41013                            mov.b   [r1], 20h+var_D[sp]
FFF2257F  a981                              mov.l   20h+var_8[sp], r1
FFF22581  c41012                            mov.b   [r1], 20h+var_E[sp]
FFF22584  8c89                              mov.b   20h+var_D[sp], r1
FFF22586  6101                              cmp     #0, r1
FFF22588  3a56ff                            beq.w   loc_FFF224DE
FFF2258B  385cff                 sub_FFF2258B bra.w   loc_FFF224E7   ; <<<< FUNC sub_FFF2258B
FFF2258E  a889                   loc_FFF2258E mov.l   20h+var_14[sp], r1
FFF22590  a109                              mov.l   r1, 20h+var_C[sp]
FFF22592  3f6609                            rtsd    #24h, r6-r6
FFF22595  7ea6                   sub_FFF22595 push.l  r6   ; <<<< FUNC sub_FFF22595
FFF22597  7100d8                            add     #-28h, sp, sp
FFF2259A  a209                              mov.l   r1, 28h+var_4[sp]
FFF2259C  a202                              mov.l   r2, 28h+var_8[sp]
FFF2259E  a18b                              mov.l   r3, 28h+var_C[sp]
FFF225A0  3e0400                            mov.l   #0, 28h+var_18[sp]
FFF225A3  3e0300                            mov.l   #0, 28h+var_1C[sp]
FFF225A6  38ba00                            bra.w   loc_FFF22660
FFF225A9  aa09                   loc_FFF225A9 mov.l   28h+var_4[sp], r1
FFF225AB  c41017                            mov.b   [r1], 28h+var_11[sp]
FFF225AE  aa01                              mov.l   28h+var_8[sp], r1
FFF225B0  c41016                            mov.b   [r1], 28h+var_12[sp]
FFF225B3  8d89                              mov.b   28h+var_11[sp], r1
FFF225B5  6101                              cmp     #0, r1
FFF225B7  1a                                bne.s   loc_FFF225C1
FFF225B8  8d81                              mov.b   28h+var_12[sp], r1
FFF225BA  6101                              cmp     #0, r1
FFF225BC  1d                                bne.s   loc_FFF225C1
FFF225BD  f80601                            mov.l   #1, 28h+var_28[sp]
FFF225C0  0c                                bra.s   loc_FFF225C4
FFF225C1  f80600                 loc_FFF225C1 mov.l   #0, 28h+var_28[sp]
FFF225C4  ec01                   loc_FFF225C4 mov.l   28h+var_28[sp], r1
FFF225C6  6101                              cmp     #0, r1
FFF225C8  3ba300                            bne.w   loc_FFF2266B
FFF225CB  8d89                              mov.b   28h+var_11[sp], r1
FFF225CD  6101                              cmp     #0, r1
FFF225CF  18                                bne.s   loc_FFF225D7
FFF225D0  f90604ff                          mov.l   #-1, 28h+var_18[sp]
FFF225D4  389700                            bra.w   loc_FFF2266B
FFF225D7  8d81                   loc_FFF225D7 mov.b   28h+var_12[sp], r1
FFF225D9  6101                              cmp     #0, r1
FFF225DB  1f                                bne.s   loc_FFF225E2
FFF225DC  3e0401                            mov.l   #1, 28h+var_18[sp]
FFF225DF  388c00                            bra.w   loc_FFF2266B
FFF225E2  b581                   loc_FFF225E2 movu.b  28h+var_12[sp], r1
FFF225E4  05f5b500                          bsr.a   sub_FFF2DBD9
FFF225E8  6101                              cmp     #0, r1
FFF225EA  2047                              beq.b   loc_FFF22631
FFF225EC  aa09                              mov.l   28h+var_4[sp], r1
FFF225EE  cc12                              mov.b   [r1], r2
FFF225F0  6c82                              shll    #8, r2
FFF225F2  551201                            or      1[r1], r2
FFF225F5  9102                              mov.w   r2, 28h+var_20[sp]
FFF225F7  aa01                              mov.l   28h+var_8[sp], r1
FFF225F9  cc12                              mov.b   [r1], r2
FFF225FB  6c82                              shll    #8, r2
FFF225FD  551201                            or      1[r1], r2
FFF22600  908a                              mov.w   r2, 28h+var_22[sp]
FFF22602  b901                              movu.w  28h+var_20[sp], r1
FFF22604  39fdfd                            bsr.w   sub_FFF22401
FFF22607  ef16                              mov.l   r1, r6
FFF22609  b889                              movu.w  28h+var_22[sp], r1
FFF2260B  39f6fd                            bsr.w   sub_FFF22401
FFF2260E  4316                              sub     r1, r6
FFF22610  910e                              mov.w   r6, 28h+var_1E[sp]
FFF22612  9909                              mov.w   28h+var_1E[sp], r1
FFF22614  6101                              cmp     #0, r1
FFF22616  17                                beq.s   loc_FFF2261D
FFF22617  f90604ff                          mov.l   #-1, 28h+var_18[sp]
FFF2261B  2e50                              bra.b   loc_FFF2266B
FFF2261D  aa09                   loc_FFF2261D mov.l   28h+var_4[sp], r1
FFF2261F  6211                              add     #1, r1
FFF22621  a209                              mov.l   r1, 28h+var_4[sp]
FFF22623  aa01                              mov.l   28h+var_8[sp], r1
FFF22625  6211                              add     #1, r1
FFF22627  a201                              mov.l   r1, 28h+var_8[sp]
FFF22629  a889                              mov.l   28h+var_1C[sp], r1
FFF2262B  6211                              add     #1, r1
FFF2262D  a089                              mov.l   r1, 28h+var_1C[sp]
FFF2262F  2e1f                              bra.b   loc_FFF2264E
FFF22631  8d89                   loc_FFF22631 mov.b   28h+var_11[sp], r1
FFF22633  0558c100                          bsr.a   sub_FFF2E78B
FFF22637  ef16                              mov.l   r1, r6
FFF22639  8d81                              mov.b   28h+var_12[sp], r1
FFF2263B  0550c100                          bsr.a   sub_FFF2E78B
FFF2263F  4316                              sub     r1, r6
FFF22641  858e                              mov.b   r6, 28h+var_11[sp]
FFF22643  8d89                              mov.b   28h+var_11[sp], r1
FFF22645  6101                              cmp     #0, r1
FFF22647  17                                beq.s   loc_FFF2264E
FFF22648  8d89                              mov.b   28h+var_11[sp], r1
FFF2264A  a101                              mov.l   r1, 28h+var_18[sp]
FFF2264C  2e1f                              bra.b   loc_FFF2266B
FFF2264E  a889                   loc_FFF2264E mov.l   28h+var_1C[sp], r1
FFF22650  6211                              add     #1, r1
FFF22652  a089                              mov.l   r1, 28h+var_1C[sp]
FFF22654  aa09                              mov.l   28h+var_4[sp], r1
FFF22656  6211                              add     #1, r1
FFF22658  a209                              mov.l   r1, 28h+var_4[sp]
FFF2265A  aa01                              mov.l   28h+var_8[sp], r1
FFF2265C  6211                              add     #1, r1
FFF2265E  a201                              mov.l   r1, 28h+var_8[sp]
FFF22660  a889                   loc_FFF22660 mov.l   28h+var_1C[sp], r1
FFF22662  06850107                          cmp     28h+var_C[sp].l, r1
FFF22666  2205                              bgeu.b  loc_FFF2266B
FFF22668  3841ff                            bra.w   loc_FFF225A9
FFF2266B  a901                   loc_FFF2266B mov.l   28h+var_18[sp], r1
FFF2266D  a181                              mov.l   r1, 28h+var_10[sp]
FFF2266F  3f660b                            rtsd    #2Ch, r6-r6
FFF22672  7100d8                 sub_FFF22672 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF22672
FFF22675  a209                              mov.l   r1, 28h+var_4[sp]
FFF22677  a202                              mov.l   r2, 28h+var_8[sp]
FFF22679  a18b                              mov.l   r3, 28h+var_C[sp]
FFF2267B  868c                              mov.b   r4, 28h+var_D[sp]
FFF2267D  c5002c1a                          mov.b   28h+arg_0[sp], 28h+var_E[sp]
FFF22681  e5000c05                          mov.l   28h+arg_4[sp], 28h+var_14[sp]
FFF22685  e5000d04                          mov.l   28h+arg_8[sp], 28h+var_18[sp]
FFF22689  aa09                              mov.l   28h+var_4[sp], r1
FFF2268B  056236ff                          bsr.a   sub_FFF15CED
FFF2268F  a081                              mov.l   r1, 28h+var_20[sp]
FFF22691  a881                              mov.l   28h+var_20[sp], r1
FFF22693  6101                              cmp     #0, r1
FFF22695  16                                beq.s   loc_FFF2269B
FFF22696  f806db                            mov.l   #-25h, 28h+var_28[sp]
FFF22699  2e2b                              bra.b   loc_FFF226C4
FFF2269B  a905                   loc_FFF2269B mov.l   28h+var_18[sp], r5
FFF2269D  ed0f05                            mov.l   28h+var_14[sp], r15
FFF226A0  590e1a                            movu.b  28h+var_E[sp], r14
FFF226A3  8e8c                              mov.b   28h+var_D[sp], r4
FFF226A5  a98b                              mov.l   28h+var_C[sp], r3
FFF226A7  aa02                              mov.l   28h+var_8[sp], r2
FFF226A9  aa09                              mov.l   28h+var_4[sp], r1
FFF226AB  60c0                              sub     #0Ch, sp
FFF226AD  a085                              mov.l   r5, 34h+var_2C[sp]
FFF226AF  e70f01                            mov.l   r15, 34h+var_30[sp]
FFF226B2  c30e                              mov.b   r14, 34h+var_34[sp]
FFF226B4  391600                            bsr.w   sub_FFF226CA
FFF226B7  62c0                              add     #0Ch, sp
FFF226B9  a009                              mov.l   r1, 28h+var_24[sp]
FFF226BB  aa09                              mov.l   28h+var_4[sp], r1
FFF226BD  053b36ff                          bsr.a   sub_FFF15CF8
FFF226C1  e10001                            mov.l   28h+var_24[sp], 28h+var_28[sp]
FFF226C4  ec01                   loc_FFF226C4 mov.l   28h+var_28[sp], r1
FFF226C6  a089                              mov.l   r1, 28h+var_1C[sp]
FFF226C8  670a                              rtsd    #0Ah
FFF226CA  710098                 sub_FFF226CA add     #-68h, sp, sp   ; <<<< FUNC sub_FFF226CA
FFF226CD  a609                              mov.l   r1, 68h+var_4[sp]
FFF226CF  a602                              mov.l   r2, 68h+var_8[sp]
FFF226D1  a58b                              mov.l   r3, 68h+var_C[sp]
FFF226D3  c7045b                            mov.b   r4, 68h+var_D[sp]
FFF226D6  c5006c5a                          mov.b   68h+arg_0[sp], 68h+var_E[sp]
FFF226DA  e5001c15                          mov.l   68h+arg_4[sp], 68h+var_14[sp]
FFF226DE  e5001d14                          mov.l   68h+arg_8[sp], 68h+var_18[sp]
FFF226E2  f90923ffff                        mov.w   #-1, 68h+var_22[sp]
FFF226E7  66d3                              mov.l   #0Dh, r3
FFF226E9  fb22f8adf4ff                      mov.l   #aCen, r2; "        CEN"
FFF226EF  71012a                            add     #68h+var_3E, sp, r1
FFF226F2  7f8f                              smovf
FFF226F4  3d8400                            mov.w   #0, 68h+var_40[sp]
FFF226F7  3d8300                            mov.w   #0, 68h+var_42[sp]
FFF226FA  3e0600                            mov.l   #0, 68h+var_50[sp]
FFF226FD  f90605ff                          mov.l   #-1, 68h+var_54[sp]
FFF22701  3e0400                            mov.l   #0, 68h+var_58[sp]
FFF22704  3e0300                            mov.l   #0, 68h+var_5C[sp]
FFF22707  f9044500                          mov.b   #0, 68h+var_23[sp]
FFF2270B  ad01                              mov.l   68h+var_18[sp], r1
FFF2270D  72110c0e                          add     #0E0Ch, r1, r1
FFF22711  a081                              mov.l   r1, 68h+var_60[sp]
FFF22713  ad02                              mov.l   68h+var_18[sp], r2
FFF22715  ae01                              mov.l   68h+var_8[sp], r1
FFF22717  72220c04                          add     #40Ch, r2, r2
FFF2271B  710345                            add     #68h+var_23, sp, r3
FFF2271E  05ebbb00                          bsr.a   sub_FFF2E309
FFF22722  a481                              mov.l   r1, 68h+var_20[sp]
FFF22724  ac81                              mov.l   68h+var_20[sp], r1
FFF22726  75019d                            cmp     #-63h, r1
FFF22729  18                                bne.s   loc_FFF22731
FFF2272A  f90601ba                          mov.l   #-46h, 68h+var_64[sp]
FFF2272E  389903                            bra.w   loc_FFF22AC7
FFF22731  f9044401               loc_FFF22731 mov.b   #1, 68h+var_24[sp]
FFF22735  ac81                              mov.l   68h+var_20[sp], r1
FFF22737  6011                              sub     #1, r1
FFF22739  fd74810d                          div     #0Dh, r1
FFF2273D  6211                              add     #1, r1
FFF2273F  9489                              mov.w   r1, 68h+var_42[sp]
FFF22741  9c89                              mov.w   68h+var_42[sp], r1
FFF22743  6211                              add     #1, r1
FFF22745  9489                              mov.w   r1, 68h+var_42[sp]
FFF22747  3d8200                            mov.w   #0, 68h+var_44[sp]
FFF2274A  38d302                            bra.w   loc_FFF22A1D
FFF2274D  ae09                   loc_FFF2274D mov.l   68h+var_4[sp], r1
FFF2274F  ad99                              mov.l   5Ch[r1], r1
FFF22751  6851                              shlr    #5, r1
FFF22753  bc82                              movu.w  68h+var_44[sp], r2
FFF22755  fc2712                            divu    r1, r2
FFF22758  a18a                              mov.l   r2, 68h+var_4C[sp]
FFF2275A  ae09                              mov.l   68h+var_4[sp], r1
FFF2275C  ad99                              mov.l   5Ch[r1], r1
FFF2275E  6851                              shlr    #5, r1
FFF22760  bc82                              movu.w  68h+var_44[sp], r2
FFF22762  ef2e                              mov.l   r2, r14
FFF22764  fc271e                            divu    r1, r14
FFF22767  4f1e                              mul     r1, r14
FFF22769  43e2                              sub     r14, r2
FFF2276B  6102                              cmp     #0, r2
FFF2276D  15                                beq.s   loc_FFF22772
FFF2276E  f80600                            mov.l   #0, 68h+var_68[sp]
FFF22771  0c                                bra.s   loc_FFF22775
FFF22772  f80601                 loc_FFF22772 mov.l   #1, 68h+var_68[sp]
FFF22775  ec01                   loc_FFF22775 mov.l   68h+var_68[sp], r1
FFF22777  6101                              cmp     #0, r1
FFF22779  2023                              beq.b   loc_FFF2279C
FFF2277B  a98a                              mov.l   68h+var_4C[sp], r2
FFF2277D  ae09                              mov.l   68h+var_4[sp], r1
FFF2277F  710308                            add     #68h+var_60, sp, r3
FFF22782  05bfddff                          bsr.a   sub_FFF20541
FFF22786  a481                              mov.l   r1, 68h+var_20[sp]
FFF22788  ac81                              mov.l   68h+var_20[sp], r1
FFF2278A  6101                              cmp     #0, r1
FFF2278C  10                                beq.s   loc_FFF22794
FFF2278D  e5001201                          mov.l   68h+var_20[sp], 68h+var_64[sp]
FFF22791  383603                            bra.w   loc_FFF22AC7
FFF22794  e5000705               loc_FFF22794 mov.l   68h+var_4C[sp], 68h+var_54[sp]
FFF22798  e5000203                          mov.l   68h+var_60[sp], 68h+var_5C[sp]
FFF2279C  a889                   loc_FFF2279C mov.l   68h+var_5C[sp], r1
FFF2279E  6101                              cmp     #0, r1
FFF227A0  18                                bne.s   loc_FFF227A8
FFF227A1  f90601f3                          mov.l   #-0Dh, 68h+var_64[sp]
FFF227A5  382203                            bra.w   loc_FFF22AC7
FFF227A8  a889                   loc_FFF227A8 mov.l   68h+var_5C[sp], r1
FFF227AA  581e                              movu.b  [r1], r14
FFF227AC  755ee5                            cmp     #-1Bh, r14
FFF227AF  214b                              bne.b   loc_FFF227FA
FFF227B1  711120                            add     #20h, r1, r1 ; ' '
FFF227B4  a089                              mov.l   r1, 68h+var_5C[sp]
FFF227B6  cd015b                            mov.b   68h+var_D[sp], r1
FFF227B9  6101                              cmp     #0, r1
FFF227BB  17                                beq.s   loc_FFF227C2
FFF227BC  cd015b                            mov.b   68h+var_D[sp], r1
FFF227BF  6121                              cmp     #2, r1
FFF227C1  1d                                bne.s   loc_FFF227C6
FFF227C2  f80601                 loc_FFF227C2 mov.l   #1, 68h+var_68[sp]
FFF227C5  0c                                bra.s   loc_FFF227C9
FFF227C6  f80600                 loc_FFF227C6 mov.l   #0, 68h+var_68[sp]
FFF227C9  ec01                   loc_FFF227C9 mov.l   68h+var_68[sp], r1
FFF227CB  6101                              cmp     #0, r1
FFF227CD  3b4a02                            bne.w   loc_FFF22A17
FFF227D0  9d01                              mov.w   68h+var_40[sp], r1
FFF227D2  6211                              add     #1, r1
FFF227D4  9501                              mov.w   r1, 68h+var_40[sp]
FFF227D6  bd01                              movu.w  68h+var_40[sp], r1
FFF227D8  06c50113                          cmp     68h+var_42[sp].uw, r1
FFF227DC  290d                              blt.b   loc_FFF227E9
FFF227DE  dd0123                            mov.w   68h+var_22[sp], r1
FFF227E1  7501ff                            cmp     #-1, r1
FFF227E4  1d                                bne.s   loc_FFF227E9
FFF227E5  f80601                            mov.l   #1, 68h+var_68[sp]
FFF227E8  0c                                bra.s   loc_FFF227EC
FFF227E9  f80600                 loc_FFF227E9 mov.l   #0, 68h+var_68[sp]
FFF227EC  ec01                   loc_FFF227EC mov.l   68h+var_68[sp], r1
FFF227EE  6101                              cmp     #0, r1
FFF227F0  3a2702                            beq.w   loc_FFF22A17
FFF227F3  d5001223                          mov.w   68h+var_44[sp], 68h+var_22[sp]
FFF227F7  382002                            bra.w   loc_FFF22A17
FFF227FA  581e                   loc_FFF227FA movu.b  [r1], r14
FFF227FC  610e                              cmp     #0, r14
FFF227FE  14                                beq.s   loc_FFF22802
FFF227FF  3d8400                            mov.w   #0, 68h+var_40[sp]
FFF22802  a889                   loc_FFF22802 mov.l   68h+var_5C[sp], r1
FFF22804  581e                              movu.b  [r1], r14
FFF22806  610e                              cmp     #0, r14
FFF22808  3b3f01                            bne.w   loc_FFF22947
FFF2280B  cd015b                            mov.b   68h+var_D[sp], r1
FFF2280E  6101                              cmp     #0, r1
FFF22810  17                                beq.s   loc_FFF22817
FFF22811  cd015b                            mov.b   68h+var_D[sp], r1
FFF22814  6121                              cmp     #2, r1
FFF22816  1d                                bne.s   loc_FFF2281B
FFF22817  f80601                 loc_FFF22817 mov.l   #1, 68h+var_68[sp]
FFF2281A  0c                                bra.s   loc_FFF2281E
FFF2281B  f80600                 loc_FFF2281B mov.l   #0, 68h+var_68[sp]
FFF2281E  ec01                   loc_FFF2281E mov.l   68h+var_68[sp], r1
FFF22820  6101                              cmp     #0, r1
FFF22822  10                                beq.s   loc_FFF2282A
FFF22823  f90601b9                          mov.l   #-47h, 68h+var_64[sp]
FFF22827  38a002                            bra.w   loc_FFF22AC7
FFF2282A  dd0123                 loc_FFF2282A mov.w   68h+var_22[sp], r1
FFF2282D  6101                              cmp     #0, r1
FFF2282F  2765                              bn.b    loc_FFF22894
FFF22831  dd0123                            mov.w   68h+var_22[sp], r1
FFF22834  ad0a                              mov.l   68h+var_14[sp], r2
FFF22836  e321                              mov.l   r1, [r2]
FFF22838  ad09                              mov.l   68h+var_14[sp], r1
FFF2283A  ec1e                              mov.l   [r1], r14
FFF2283C  ad01                              mov.l   68h+var_18[sp], r1
FFF2283E  db1e100b                          mov.w   r14, 1620h[r1]
FFF22842  9c89                              mov.w   68h+var_42[sp], r1
FFF22844  ad02                              mov.l   68h+var_18[sp], r2
FFF22846  db21110b                          mov.w   r1, 1622h[r2]
FFF2284A  cd015b                            mov.b   68h+var_D[sp], r1
FFF2284D  6131                              cmp     #3, r1
FFF2284F  1f                                bne.s   loc_FFF22856
FFF22850  3e0100                            mov.l   #0, 68h+var_64[sp]
FFF22853  387402                            bra.w   loc_FFF22AC7
FFF22856  ad09                   loc_FFF22856 mov.l   68h+var_14[sp], r1
FFF22858  e41006                            mov.l   [r1], 68h+var_50[sp]
FFF2285B  a981                              mov.l   68h+var_50[sp], r1
FFF2285D  6683                              mov.l   #8, r3
FFF2285F  71022a                            add     #68h+var_3E, sp, r2
FFF22862  39d10e                            bsr.w   loc_FFF23733
FFF22865  ad89                              mov.l   68h+var_C[sp], r1
FFF22867  66b3                              mov.l   #0Bh, r3
FFF22869  71022a                            add     #68h+var_3E, sp, r2
FFF2286C  050cbc00                          bsr.a   sub_FFF2E478
FFF22870  ad04                              mov.l   68h+var_18[sp], r4
FFF22872  9c8d                              mov.w   68h+var_42[sp], r5
FFF22874  ad8b                              mov.l   68h+var_C[sp], r3
FFF22876  5d0223                            movu.w  68h+var_22[sp], r2
FFF22879  ae09                              mov.l   68h+var_4[sp], r1
FFF2287B  6080                              sub     #8, sp
FFF2287D  d305                              mov.w   r5, 70h+var_70[sp]
FFF2287F  a00c                              mov.l   r4, 70h+var_6C[sp]
FFF22881  72440c04                          add     #40Ch, r4, r4
FFF22885  0593f0ff                          bsr.a   sub_FFF21918
FFF22889  6280                              add     #8, sp
FFF2288B  a481                              mov.l   r1, 68h+var_20[sp]
FFF2288D  e5001201                          mov.l   68h+var_20[sp], 68h+var_64[sp]
FFF22891  383602                            bra.w   loc_FFF22AC7
FFF22894  ae09                   loc_FFF22894 mov.l   68h+var_4[sp], r1
FFF22896  b919                              movu.w  0Ah[r1], r1
FFF22898  06c10112                          sub     68h+var_44[sp].uw, r1
FFF2289C  06c90114                          add     68h+var_40[sp].uw, r1
FFF228A0  9409                              mov.w   r1, 68h+var_46[sp]
FFF228A2  bc89                              movu.w  68h+var_42[sp], r1
FFF228A4  06c50111                          cmp     68h+var_46[sp].uw, r1
FFF228A8  2b09                              ble.b   loc_FFF228B1
FFF228AA  f90601be                          mov.l   #-42h, 68h+var_64[sp]
FFF228AE  381902                            bra.w   loc_FFF22AC7
FFF228B1  bc81                   loc_FFF228B1 movu.w  68h+var_44[sp], r1
FFF228B3  06c90113                          add     68h+var_42[sp].uw, r1
FFF228B7  6011                              sub     #1, r1
FFF228B9  06c10114                          sub     68h+var_40[sp].uw, r1
FFF228BD  ad0a                              mov.l   68h+var_14[sp], r2
FFF228BF  e321                              mov.l   r1, [r2]
FFF228C1  ad09                              mov.l   68h+var_14[sp], r1
FFF228C3  ec1e                              mov.l   [r1], r14
FFF228C5  ad01                              mov.l   68h+var_18[sp], r1
FFF228C7  db1e100b                          mov.w   r14, 1620h[r1]
FFF228CB  9c89                              mov.w   68h+var_42[sp], r1
FFF228CD  ad02                              mov.l   68h+var_18[sp], r2
FFF228CF  db21110b                          mov.w   r1, 1622h[r2]
FFF228D3  cd015b                            mov.b   68h+var_D[sp], r1
FFF228D6  6131                              cmp     #3, r1
FFF228D8  1f                                bne.s   loc_FFF228DF
FFF228D9  3e0100                            mov.l   #0, 68h+var_64[sp]
FFF228DC  38eb01                            bra.w   loc_FFF22AC7
FFF228DF  ad09                   loc_FFF228DF mov.l   68h+var_14[sp], r1
FFF228E1  e41006                            mov.l   [r1], 68h+var_50[sp]
FFF228E4  a981                              mov.l   68h+var_50[sp], r1
FFF228E6  6683                              mov.l   #8, r3
FFF228E8  71022a                            add     #68h+var_3E, sp, r2
FFF228EB  39480e                            bsr.w   loc_FFF23733
FFF228EE  ad89                              mov.l   68h+var_C[sp], r1
FFF228F0  66b3                              mov.l   #0Bh, r3
FFF228F2  71022a                            add     #68h+var_3E, sp, r2
FFF228F5  0583bb00                          bsr.a   sub_FFF2E478
FFF228F9  bc82                              movu.w  68h+var_44[sp], r2
FFF228FB  06c90213                          add     68h+var_42[sp].uw, r2
FFF228FF  6012                              sub     #1, r2
FFF22901  06c10214                          sub     68h+var_40[sp].uw, r2
FFF22905  cd0144                            mov.b   68h+var_24[sp], r1
FFF22908  6111                              cmp     #1, r1
FFF2290A  ad8b                              mov.l   68h+var_C[sp], r3
FFF2290C  ae09                              mov.l   68h+var_4[sp], r1
FFF2290E  211c                              bne.b   loc_FFF2292A
FFF22910  ad04                              mov.l   68h+var_18[sp], r4
FFF22912  9c8d                              mov.w   68h+var_42[sp], r5
FFF22914  6080                              sub     #8, sp
FFF22916  d305                              mov.w   r5, 70h+var_70[sp]
FFF22918  a00c                              mov.l   r4, 70h+var_6C[sp]
FFF2291A  72440c04                          add     #40Ch, r4, r4
FFF2291E  5f22                              movu.w  r2, r2
FFF22920  05f8efff                          bsr.a   sub_FFF21918
FFF22924  6280                              add     #8, sp
FFF22926  a481                              mov.l   r1, 68h+var_20[sp]
FFF22928  2e18                              bra.b   loc_FFF22940
FFF2292A  ad04                   loc_FFF2292A mov.l   68h+var_18[sp], r4
FFF2292C  9c8d                              mov.w   68h+var_42[sp], r5
FFF2292E  6080                              sub     #8, sp
FFF22930  a00c                              mov.l   r4, 70h+var_6C[sp]
FFF22932  d305                              mov.w   r5, 70h+var_70[sp]
FFF22934  5f22                              movu.w  r2, r2
FFF22936  6604                              mov.l   #0, r4
FFF22938  05e0efff                          bsr.a   sub_FFF21918
FFF2293C  6280                              add     #8, sp
FFF2293E  a481                              mov.l   r1, 68h+var_20[sp]
FFF22940  e5001201               loc_FFF22940 mov.l   68h+var_20[sp], 68h+var_64[sp]
FFF22944  388301                            bra.w   loc_FFF22AC7
FFF22947  a889                   loc_FFF22947 mov.l   68h+var_5C[sp], r1
FFF22949  f5130b                            btst    #3, 0Bh[r1].b
FFF2294C  15                                beq.s   loc_FFF22951
FFF2294D  f80600                            mov.l   #0, 68h+var_68[sp]
FFF22950  0c                                bra.s   loc_FFF22954
FFF22951  f80601                 loc_FFF22951 mov.l   #1, 68h+var_68[sp]
FFF22954  ec01                   loc_FFF22954 mov.l   68h+var_68[sp], r1
FFF22956  6101                              cmp     #0, r1
FFF22958  3ab800                            beq.w   loc_FFF22A10
FFF2295B  cd015b                            mov.b   68h+var_D[sp], r1
FFF2295E  6131                              cmp     #3, r1
FFF22960  3ab000                            beq.w   loc_FFF22A10
FFF22963  ad03                              mov.l   68h+var_18[sp], r3
FFF22965  a90d                              mov.l   68h+var_54[sp], r5
FFF22967  bc8c                              movu.w  68h+var_42[sp], r4
FFF22969  bc82                              movu.w  68h+var_44[sp], r2
FFF2296B  ae09                              mov.l   68h+var_4[sp], r1
FFF2296D  6080                              sub     #8, sp
FFF2296F  e305                              mov.l   r5, 70h+var_70[sp]
FFF22971  a00b                              mov.l   r3, 70h+var_6C[sp]
FFF22973  72330c04                          add     #40Ch, r3, r3
FFF22977  0565f3ff                          bsr.a   sub_FFF21CDC
FFF2297B  6280                              add     #8, sp
FFF2297D  a481                              mov.l   r1, 68h+var_20[sp]
FFF2297F  ac81                              mov.l   68h+var_20[sp], r1
FFF22981  6101                              cmp     #0, r1
FFF22983  202e                              beq.b   loc_FFF229B1
FFF22985  ad01                              mov.l   68h+var_18[sp], r1
FFF22987  72110c04                          add     #40Ch, r1, r1
FFF2298B  05b8bc00                          bsr.a   sub_FFF2E643
FFF2298F  a101                              mov.l   r1, 68h+var_58[sp]
FFF22991  a901                              mov.l   68h+var_58[sp], r1
FFF22993  755118                            cmp     #18h, r1
FFF22996  241b                              bgtu.b  loc_FFF229B1
FFF22998  ad02                              mov.l   68h+var_18[sp], r2
FFF2299A  72220c04                          add     #40Ch, r2, r2
FFF2299E  710137                            add     #68h+var_31, sp, r1
FFF229A1  05dfb900                          bsr.a   sub_FFF2E380
FFF229A5  ae0b                              mov.l   68h+var_4[sp], r3
FFF229A7  a889                              mov.l   68h+var_5C[sp], r1
FFF229A9  710237                            add     #68h+var_31, sp, r2
FFF229AC  399910                            bsr.w   sub_FFF23A45
FFF229AF  a481                              mov.l   r1, 68h+var_20[sp]
FFF229B1  ac81                   loc_FFF229B1 mov.l   68h+var_20[sp], r1
FFF229B3  6101                              cmp     #0, r1
FFF229B5  215b                              bne.b   loc_FFF22A10
FFF229B7  cd015b                            mov.b   68h+var_D[sp], r1
FFF229BA  6111                              cmp     #1, r1
FFF229BC  18                                bne.s   loc_FFF229C4
FFF229BD  f90601f3                          mov.l   #-0Dh, 68h+var_64[sp]
FFF229C1  380601                            bra.w   loc_FFF22AC7
FFF229C4  a88a                   loc_FFF229C4 mov.l   68h+var_5C[sp], r2
FFF229C6  ad89                              mov.l   68h+var_C[sp], r1
FFF229C8  754320                            mov.l   #20h, r3 ; ' '
FFF229CB  05adba00                          bsr.a   sub_FFF2E478
FFF229CF  cd015b                            mov.b   68h+var_D[sp], r1
FFF229D2  6121                              cmp     #2, r1
FFF229D4  2117                              bne.b   loc_FFF229EB
FFF229D6  ad04                              mov.l   68h+var_18[sp], r4
FFF229D8  bc8b                              movu.w  68h+var_42[sp], r3
FFF229DA  bc82                              movu.w  68h+var_44[sp], r2
FFF229DC  ae09                              mov.l   68h+var_4[sp], r1
FFF229DE  05ebf1ff                          bsr.a   sub_FFF21BC9
FFF229E2  a481                              mov.l   r1, 68h+var_20[sp]
FFF229E4  e5001201                          mov.l   68h+var_20[sp], 68h+var_64[sp]
FFF229E8  38df00                            bra.w   loc_FFF22AC7
FFF229EB  cd015b                 loc_FFF229EB mov.b   68h+var_D[sp], r1
FFF229EE  6101                              cmp     #0, r1
FFF229F0  2120                              bne.b   loc_FFF22A10
FFF229F2  bc81                              movu.w  68h+var_44[sp], r1
FFF229F4  ad0a                              mov.l   68h+var_14[sp], r2
FFF229F6  e321                              mov.l   r1, [r2]
FFF229F8  ad09                              mov.l   68h+var_14[sp], r1
FFF229FA  ec1e                              mov.l   [r1], r14
FFF229FC  ad01                              mov.l   68h+var_18[sp], r1
FFF229FE  db1e100b                          mov.w   r14, 1620h[r1]
FFF22A02  9c89                              mov.w   68h+var_42[sp], r1
FFF22A04  ad02                              mov.l   68h+var_18[sp], r2
FFF22A06  db21110b                          mov.w   r1, 1622h[r2]
FFF22A0A  3e0100                            mov.l   #0, 68h+var_64[sp]
FFF22A0D  38ba00                            bra.w   loc_FFF22AC7
FFF22A10  a889                   loc_FFF22A10 mov.l   68h+var_5C[sp], r1
FFF22A12  711120                            add     #20h, r1, r1 ; ' '
FFF22A15  a089                              mov.l   r1, 68h+var_5C[sp]
FFF22A17  9c81                   loc_FFF22A17 mov.w   68h+var_44[sp], r1
FFF22A19  6211                              add     #1, r1
FFF22A1B  9481                              mov.w   r1, 68h+var_44[sp]
FFF22A1D  ae09                   loc_FFF22A1D mov.l   68h+var_4[sp], r1
FFF22A1F  bc82                              movu.w  68h+var_44[sp], r2
FFF22A21  06c51205                          cmp     0Ah[r1].uw, r2
FFF22A25  2805                              bge.b   loc_FFF22A2A
FFF22A27  3826fd                            bra.w   loc_FFF2274D
FFF22A2A  cd015b                 loc_FFF22A2A mov.b   68h+var_D[sp], r1
FFF22A2D  6111                              cmp     #1, r1
FFF22A2F  17                                beq.s   loc_FFF22A36
FFF22A30  cd015b                            mov.b   68h+var_D[sp], r1
FFF22A33  6131                              cmp     #3, r1
FFF22A35  1d                                bne.s   loc_FFF22A3A
FFF22A36  f80601                 loc_FFF22A36 mov.l   #1, 68h+var_68[sp]
FFF22A39  0c                                bra.s   loc_FFF22A3D
FFF22A3A  f80600                 loc_FFF22A3A mov.l   #0, 68h+var_68[sp]
FFF22A3D  ec01                   loc_FFF22A3D mov.l   68h+var_68[sp], r1
FFF22A3F  6101                              cmp     #0, r1
FFF22A41  200d                              beq.b   loc_FFF22A4E
FFF22A43  dd0123                            mov.w   68h+var_22[sp], r1
FFF22A46  6101                              cmp     #0, r1
FFF22A48  2706                              bn.b    loc_FFF22A4E
FFF22A4A  f80601                            mov.l   #1, 68h+var_68[sp]
FFF22A4D  0c                                bra.s   loc_FFF22A51
FFF22A4E  f80600                 loc_FFF22A4E mov.l   #0, 68h+var_68[sp]
FFF22A51  ec01                   loc_FFF22A51 mov.l   68h+var_68[sp], r1
FFF22A53  6101                              cmp     #0, r1
FFF22A55  2063                              beq.b   loc_FFF22AB8
FFF22A57  dd0123                            mov.w   68h+var_22[sp], r1
FFF22A5A  ad0a                              mov.l   68h+var_14[sp], r2
FFF22A5C  e321                              mov.l   r1, [r2]
FFF22A5E  ad09                              mov.l   68h+var_14[sp], r1
FFF22A60  ec1e                              mov.l   [r1], r14
FFF22A62  ad01                              mov.l   68h+var_18[sp], r1
FFF22A64  db1e100b                          mov.w   r14, 1620h[r1]
FFF22A68  9c89                              mov.w   68h+var_42[sp], r1
FFF22A6A  ad02                              mov.l   68h+var_18[sp], r2
FFF22A6C  db21110b                          mov.w   r1, 1622h[r2]
FFF22A70  cd015b                            mov.b   68h+var_D[sp], r1
FFF22A73  6131                              cmp     #3, r1
FFF22A75  1e                                bne.s   loc_FFF22A7B
FFF22A76  3e0100                            mov.l   #0, 68h+var_64[sp]
FFF22A79  2e4e                              bra.b   loc_FFF22AC7
FFF22A7B  ad09                   loc_FFF22A7B mov.l   68h+var_14[sp], r1
FFF22A7D  e41006                            mov.l   [r1], 68h+var_50[sp]
FFF22A80  a981                              mov.l   68h+var_50[sp], r1
FFF22A82  6683                              mov.l   #8, r3
FFF22A84  71022a                            add     #68h+var_3E, sp, r2
FFF22A87  39ac0c                            bsr.w   loc_FFF23733
FFF22A8A  ad89                              mov.l   68h+var_C[sp], r1
FFF22A8C  66b3                              mov.l   #0Bh, r3
FFF22A8E  71022a                            add     #68h+var_3E, sp, r2
FFF22A91  05e7b900                          bsr.a   sub_FFF2E478
FFF22A95  ad04                              mov.l   68h+var_18[sp], r4
FFF22A97  9c8d                              mov.w   68h+var_42[sp], r5
FFF22A99  ad8b                              mov.l   68h+var_C[sp], r3
FFF22A9B  5d0223                            movu.w  68h+var_22[sp], r2
FFF22A9E  ae09                              mov.l   68h+var_4[sp], r1
FFF22AA0  6080                              sub     #8, sp
FFF22AA2  d305                              mov.w   r5, 70h+var_70[sp]
FFF22AA4  a00c                              mov.l   r4, 70h+var_6C[sp]
FFF22AA6  72440c04                          add     #40Ch, r4, r4
FFF22AAA  056eeeff                          bsr.a   sub_FFF21918
FFF22AAE  6280                              add     #8, sp
FFF22AB0  a481                              mov.l   r1, 68h+var_20[sp]
FFF22AB2  e5001201                          mov.l   68h+var_20[sp], 68h+var_64[sp]
FFF22AB6  2e11                              bra.b   loc_FFF22AC7
FFF22AB8  cd015b                 loc_FFF22AB8 mov.b   68h+var_D[sp], r1
FFF22ABB  6131                              cmp     #3, r1
FFF22ABD  1e                                bne.s   loc_FFF22AC3
FFF22ABE  f90601f5                          mov.l   #-0Bh, 68h+var_64[sp]
FFF22AC2  0d                                bra.s   loc_FFF22AC7
FFF22AC3  f90601b9               loc_FFF22AC3 mov.l   #-47h, 68h+var_64[sp]
FFF22AC7  a809                   loc_FFF22AC7 mov.l   68h+var_64[sp], r1
FFF22AC9  a489                              mov.l   r1, 68h+var_1C[sp]
FFF22ACB  671a                              rtsd    #1Ah
FFF22ACD  6e67                   sub_FFF22ACD pushm   r6-r7   ; <<<< FUNC sub_FFF22ACD
FFF22ACF  7100d0                            add     #-30h, sp, sp
FFF22AD2  a289                              mov.l   r1, 30h+var_4[sp]
FFF22AD4  a282                              mov.l   r2, 30h+var_8[sp]
FFF22AD6  a20b                              mov.l   r3, 30h+var_C[sp]
FFF22AD8  a204                              mov.l   r4, 30h+var_10[sp]
FFF22ADA  c5003c1f                          mov.b   30h+arg_0[sp], 30h+var_11[sp]
FFF22ADE  c5003d1e                          mov.b   30h+arg_1[sp], 30h+var_12[sp]
FFF22AE2  e5001006                          mov.l   30h+arg_4[sp], 30h+var_18[sp]
FFF22AE6  e5001105                          mov.l   30h+arg_8[sp], 30h+var_1C[sp]
FFF22AEA  e5001204                          mov.l   30h+arg_C[sp], 30h+var_20[sp]
FFF22AEE  aa89                              mov.l   30h+var_4[sp], r1
FFF22AF0  05fd31ff                          bsr.a   sub_FFF15CED
FFF22AF4  a081                              mov.l   r1, 30h+var_28[sp]
FFF22AF6  a881                              mov.l   30h+var_28[sp], r1
FFF22AF8  6101                              cmp     #0, r1
FFF22AFA  16                                beq.s   loc_FFF22B00
FFF22AFB  f806db                            mov.l   #-25h, 30h+var_30[sp]
FFF22AFE  2e36                              bra.b   loc_FFF22B34
FFF22B00  a905                   loc_FFF22B00 mov.l   30h+var_20[sp], r5
FFF22B02  ed0f05                            mov.l   30h+var_1C[sp], r15
FFF22B05  ed0e06                            mov.l   30h+var_18[sp], r14
FFF22B08  b786                              movu.b  30h+var_12[sp], r6
FFF22B0A  b78f                              movu.b  30h+var_11[sp], r7
FFF22B0C  aa04                              mov.l   30h+var_10[sp], r4
FFF22B0E  aa0b                              mov.l   30h+var_C[sp], r3
FFF22B10  aa82                              mov.l   30h+var_8[sp], r2
FFF22B12  aa89                              mov.l   30h+var_4[sp], r1
FFF22B14  7100f0                            add     #-10h, sp, sp
FFF22B17  a08d                              mov.l   r5, 40h+var_34[sp]
FFF22B19  e70f02                            mov.l   r15, 40h+var_38[sp]
FFF22B1C  e70e01                            mov.l   r14, 40h+var_3C[sp]
FFF22B1F  800e                              mov.b   r6, 40h+var_3F[sp]
FFF22B21  c307                              mov.b   r7, 40h+var_40[sp]
FFF22B23  391800                            bsr.w   sub_FFF22B3B
FFF22B26  710010                            add     #10h, sp, sp
FFF22B29  a009                              mov.l   r1, 30h+var_2C[sp]
FFF22B2B  aa89                              mov.l   30h+var_4[sp], r1
FFF22B2D  05cb31ff                          bsr.a   sub_FFF15CF8
FFF22B31  e10001                            mov.l   30h+var_2C[sp], 30h+var_30[sp]
FFF22B34  ec01                   loc_FFF22B34 mov.l   30h+var_30[sp], r1
FFF22B36  a089                              mov.l   r1, 30h+var_24[sp]
FFF22B38  3f670e                            rtsd    #38h, r6-r7
FFF22B3B  72002cff               sub_FFF22B3B add     #-0D4h, sp, sp   ; <<<< FUNC sub_FFF22B3B
FFF22B3F  e70134                            mov.l   r1, 0D4h+var_4[sp]
FFF22B42  e70233                            mov.l   r2, 0D4h+var_8[sp]
FFF22B45  e70332                            mov.l   r3, 0D4h+var_C[sp]
FFF22B48  e70431                            mov.l   r4, 0D4h+var_10[sp]
FFF22B4B  c500d8c3                          mov.b   0D4h+arg_0[sp], 0D4h+var_11[sp]
FFF22B4F  c500d9c2                          mov.b   0D4h+arg_1[sp], 0D4h+var_12[sp]
FFF22B53  e500372f                          mov.l   0D4h+arg_4[sp], 0D4h+var_18[sp]
FFF22B57  e500382e                          mov.l   0D4h+arg_8[sp], 0D4h+var_1C[sp]
FFF22B5B  e500392d                          mov.l   0D4h+arg_C[sp], 0D4h+var_20[sp]
FFF22B5F  66d3                              mov.l   #0Dh, r3
FFF22B61  fb2205aef4ff                      mov.l   #aCen_0, r2; "        CEN"
FFF22B67  71015a                            add     #0D4h+var_7A, sp, r1
FFF22B6A  7f8f                              smovf
FFF22B6C  3e0d00                            mov.l   #0, 0D4h+var_A0[sp]
FFF22B6F  3e0601                            mov.l   #1, 0D4h+var_BC[sp]
FFF22B72  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22B75  ad9c                              mov.l   5Ch[r1], r4
FFF22B77  66b3                              mov.l   #0Bh, r3
FFF22B79  754220                            mov.l   #20h, r2 ; ' '
FFF22B7C  71010d                            add     #0D4h+var_C7, sp, r1
FFF22B7F  0530b900                          bsr.a   sub_FFF2E4AF
FFF22B83  3c0d2e                            mov.b   #2Eh, 0D4h+var_C7[sp] ; '.'
FFF22B86  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22B89  72110c06                          add     #60Ch, r1, r1
FFF22B8D  a709                              mov.l   r1, 0D4h+var_60[sp]
FFF22B8F  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22B92  72110c08                          add     #80Ch, r1, r1
FFF22B96  a781                              mov.l   r1, 0D4h+var_5C[sp]
FFF22B98  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22B9B  72110c0a                          add     #0A0Ch, r1, r1
FFF22B9F  a789                              mov.l   r1, 0D4h+var_58[sp]
FFF22BA1  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22BA4  ad9c                              mov.l   5Ch[r1], r4
FFF22BA6  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22BA9  72110c08                          add     #80Ch, r1, r1
FFF22BAD  fb3a0002                          mov.l   #200h, r3
FFF22BB1  6602                              mov.l   #0, r2
FFF22BB3  05fcb800                          bsr.a   sub_FFF2E4AF
FFF22BB7  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22BBA  ad9c                              mov.l   5Ch[r1], r4
FFF22BBC  ed012d                            mov.l   0D4h+var_20[sp], r1
FFF22BBF  72110c0a                          add     #0A0Ch, r1, r1
FFF22BC3  fb3a0002                          mov.l   #200h, r3
FFF22BC7  6602                              mov.l   #0, r2
FFF22BC9  05e6b800                          bsr.a   sub_FFF2E4AF
FFF22BCD  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22BD0  ad9c                              mov.l   5Ch[r1], r4
FFF22BD2  66c3                              mov.l   #0Ch, r3
FFF22BD4  6602                              mov.l   #0, r2
FFF22BD6  710144                            add     #0D4h+var_90, sp, r1
FFF22BD9  05d6b800                          bsr.a   sub_FFF2E4AF
FFF22BDD  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22BE0  ad9c                              mov.l   5Ch[r1], r4
FFF22BE2  66c3                              mov.l   #0Ch, r3
FFF22BE4  6602                              mov.l   #0, r2
FFF22BE6  710138                            add     #0D4h+var_9C, sp, r1
FFF22BE9  05c6b800                          bsr.a   sub_FFF2E4AF
FFF22BED  f9062400                          mov.l   #0, 0D4h+var_44[sp]
FFF22BF1  f90955ffff                        mov.w   #-1, 0D4h+var_2A[sp]
FFF22BF6  f9052c00                          mov.w   #0, 0D4h+var_7C[sp]
FFF22BFA  f9054700                          mov.w   #0, 0D4h+var_46[sp]
FFF22BFE  f9062200                          mov.l   #0, 0D4h+var_4C[sp]
FFF22C02  f9048700                          mov.b   #0, 0D4h+var_4D[sp]
FFF22C06  3e0a00                            mov.l   #0, 0D4h+var_AC[sp]
FFF22C09  3e0b00                            mov.l   #0, 0D4h+var_A8[sp]
FFF22C0C  ed022d                            mov.l   0D4h+var_20[sp], r2
FFF22C0F  ed0333                            mov.l   0D4h+var_8[sp], r3
FFF22C12  ed0134                            mov.l   0D4h+var_4[sp], r1
FFF22C15  6080                              sub     #8, sp
FFF22C17  a00a                              mov.l   r2, 0DCh+var_D8[sp]
FFF22C19  f80472                            mov.b   #72h, 0DCh+var_DC[sp] ; 'r'
FFF22C1C  6604                              mov.l   #0, r4
FFF22C1E  710224                            add     #0DCh+var_B8, sp, r2
FFF22C21  050e1700                          bsr.a   sub_FFF2432F
FFF22C25  6280                              add     #8, sp
FFF22C27  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22C2A  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF22C2D  6101                              cmp     #0, r1
FFF22C2F  10                                beq.s   loc_FFF22C37
FFF22C30  e5002b01                          mov.l   0D4h+var_28[sp], 0D4h+var_D0[sp]
FFF22C34  38d807                            bra.w   loc_FFF2340C
FFF22C37  a989                   loc_FFF22C37 mov.l   0D4h+var_B8[sp], r1
FFF22C39  6101                              cmp     #0, r1
FFF22C3B  18                                bne.s   loc_FFF22C43
FFF22C3C  f90601b9                          mov.l   #-47h, 0D4h+var_D0[sp]
FFF22C40  38cc07                            bra.w   loc_FFF2340C
FFF22C43  ed022d                 loc_FFF22C43 mov.l   0D4h+var_20[sp], r2
FFF22C46  ed0132                            mov.l   0D4h+var_C[sp], r1
FFF22C49  72220c04                          add     #40Ch, r2, r2
FFF22C4D  72038700                          add     #0D4h+var_4D, sp, r3
FFF22C51  05b8b600                          bsr.a   sub_FFF2E309
FFF22C55  e7012b                            mov.l   r1, 0D4h+var_28[sp]
FFF22C58  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF22C5B  75019d                            cmp     #-63h, r1
FFF22C5E  18                                bne.s   loc_FFF22C66
FFF22C5F  f90601ba                          mov.l   #-46h, 0D4h+var_D0[sp]
FFF22C63  38a907                            bra.w   loc_FFF2340C
FFF22C66  f9062501               loc_FFF22C66 mov.l   #1, 0D4h+var_40[sp]
FFF22C6A  ed012b                            mov.l   0D4h+var_28[sp], r1
FFF22C6D  6011                              sub     #1, r1
FFF22C6F  fd74810d                          div     #0Dh, r1
FFF22C73  6211                              add     #1, r1
FFF22C75  d7012c                            mov.w   r1, 0D4h+var_7C[sp]
FFF22C78  dd012c                            mov.w   0D4h+var_7C[sp], r1
FFF22C7B  6211                              add     #1, r1
FFF22C7D  d7012c                            mov.w   r1, 0D4h+var_7C[sp]
