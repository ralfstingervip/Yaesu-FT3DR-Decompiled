; ==== fat_bad  FFF1F100-FFF1F980  (file 31F100-31F980) ====
FFF1F100  d12e2c                            mov.w   58h[r2], [r14]
FFF1F103  a881                   loc_FFF1F103 mov.l   20h+var_18[sp], r1
FFF1F105  6101                              cmp     #0, r1
FFF1F107  200f                              beq.b   loc_FFF1F116
FFF1F109  6602                              mov.l   #0, r2
FFF1F10B  fb16f7                            mov.l   #-9, r1
FFF1F10E  3912fd                            bsr.w   sub_FFF1EE20
FFF1F111  f806f7                            mov.l   #-9, 20h+var_20[sp]
FFF1F114  2e19                              bra.b   loc_FFF1F12D
FFF1F116  6601                   loc_FFF1F116 mov.l   #0, r1
FFF1F118  ef12                              mov.l   r1, r2
FFF1F11A  3906fd                            bsr.w   sub_FFF1EE20
FFF1F11D  f80600                            mov.l   #0, 20h+var_20[sp]
FFF1F120  2e0d                              bra.b   loc_FFF1F12D
FFF1F122  6602                   loc_FFF1F122 mov.l   #0, r2
FFF1F124  fb16f7                            mov.l   #-9, r1
FFF1F127  39f9fc                            bsr.w   sub_FFF1EE20
FFF1F12A  f806f7                 sub_FFF1F12A mov.l   #-9, 0[sp]   ; <<<< FUNC sub_FFF1F12A
FFF1F12D  ec01                   loc_FFF1F12D mov.l   20h+var_20[sp], r1
FFF1F12F  a089                              mov.l   r1, 20h+var_14[sp]
FFF1F131  6708                              rtsd    #8
FFF1F133  7100d8                 sub_FFF1F133 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF1F133
FFF1F136  a209                              mov.l   r1, 28h+var_4[sp]
FFF1F138  a202                              mov.l   r2, 28h+var_8[sp]
FFF1F13A  a18b                              mov.l   r3, 28h+var_C[sp]
FFF1F13C  868c                              mov.b   r4, 28h+var_D[sp]
FFF1F13E  c5002c1a                          mov.b   28h+arg_0[sp], 28h+var_E[sp]
FFF1F142  e5000c05                          mov.l   28h+arg_4[sp], 28h+var_14[sp]
FFF1F146  e5000d04                          mov.l   28h+arg_8[sp], 28h+var_18[sp]
FFF1F14A  aa09                              mov.l   28h+var_4[sp], r1
FFF1F14C  05a16bff                          bsr.a   sub_FFF15CED
FFF1F150  a081                              mov.l   r1, 28h+var_20[sp]
FFF1F152  a881                              mov.l   28h+var_20[sp], r1
FFF1F154  6101                              cmp     #0, r1
FFF1F156  16                                beq.s   loc_FFF1F15C
FFF1F157  f806db                            mov.l   #-25h, 28h+var_28[sp]
FFF1F15A  2e2b                              bra.b   loc_FFF1F185
FFF1F15C  a905                   loc_FFF1F15C mov.l   28h+var_18[sp], r5
FFF1F15E  ed0f05                            mov.l   28h+var_14[sp], r15
FFF1F161  590e1a                            movu.b  28h+var_E[sp], r14
FFF1F164  8e8c                              mov.b   28h+var_D[sp], r4
FFF1F166  a98b                              mov.l   28h+var_C[sp], r3
FFF1F168  aa02                              mov.l   28h+var_8[sp], r2
FFF1F16A  aa09                              mov.l   28h+var_4[sp], r1
FFF1F16C  60c0                              sub     #0Ch, sp
FFF1F16E  a085                              mov.l   r5, 34h+var_2C[sp]
FFF1F170  e70f01                            mov.l   r15, 34h+var_30[sp]
FFF1F173  c30e                              mov.b   r14, 34h+var_34[sp]
FFF1F175  391600                            bsr.w   sub_FFF1F18B
FFF1F178  62c0                              add     #0Ch, sp
FFF1F17A  a009                              mov.l   r1, 28h+var_24[sp]
FFF1F17C  aa09                              mov.l   28h+var_4[sp], r1
FFF1F17E  057a6bff                          bsr.a   sub_FFF15CF8
FFF1F182  e10001                            mov.l   28h+var_24[sp], 28h+var_28[sp]
FFF1F185  ec01                   loc_FFF1F185 mov.l   28h+var_28[sp], r1
FFF1F187  a089                              mov.l   r1, 28h+var_1C[sp]
FFF1F189  670a                              rtsd    #0Ah
FFF1F18B  710080                 sub_FFF1F18B add     #-80h, sp, sp   ; <<<< FUNC sub_FFF1F18B
FFF1F18E  a789                              mov.l   r1, 80h+var_4[sp]
FFF1F190  a782                              mov.l   r2, 80h+var_8[sp]
FFF1F192  a70b                              mov.l   r3, 80h+var_C[sp]
FFF1F194  c70473                            mov.b   r4, 80h+var_D[sp]
FFF1F197  c5008472                          mov.b   80h+arg_0[sp], 80h+var_E[sp]
FFF1F19B  e500221b                          mov.l   80h+arg_4[sp], 80h+var_14[sp]
FFF1F19F  e500231a                          mov.l   80h+arg_8[sp], 80h+var_18[sp]
FFF1F1A3  f9092fffff                        mov.w   #-1, 80h+var_22[sp]
FFF1F1A8  3d8900                            mov.w   #0, 80h+var_4E[sp]
FFF1F1AB  3d8800                            mov.w   #0, 80h+var_50[sp]
FFF1F1AE  3e0800                            mov.l   #0, 80h+var_60[sp]
FFF1F1B1  3e0700                            mov.l   #0, 80h+var_64[sp]
FFF1F1B4  f90606ff                          mov.l   #-1, 80h+var_68[sp]
FFF1F1B8  fbe2e6adf4ff                      mov.l   #unk_FFF4ADE6, r14
FFF1F1BE  c4e010                            mov.b   [r14], 80h+var_70[sp]
FFF1F1C1  c5e00111                          mov.b   1[r14], 80h+var_6F[sp]
FFF1F1C5  c5e00212                          mov.b   2[r14], 80h+var_6E[sp]
FFF1F1C9  c5e00313                          mov.b   3[r14], 80h+var_6D[sp]
FFF1F1CD  c5e00414                          mov.b   4[r14], 80h+var_6C[sp]
FFF1F1D1  c5e00515                          mov.b   5[r14], 80h+var_6B[sp]
FFF1F1D5  c5e00616                          mov.b   6[r14], 80h+var_6A[sp]
FFF1F1D9  c5e00717                          mov.b   7[r14], 80h+var_69[sp]
FFF1F1DD  3e0300                            mov.l   #0, 80h+var_74[sp]
FFF1F1E0  f9045d00                          mov.b   #0, 80h+var_23[sp]
FFF1F1E4  ae81                              mov.l   80h+var_18[sp], r1
FFF1F1E6  72110c0e                          add     #0E0Ch, r1, r1
FFF1F1EA  a081                              mov.l   r1, 80h+var_78[sp]
FFF1F1EC  ae82                              mov.l   80h+var_18[sp], r2
FFF1F1EE  af81                              mov.l   80h+var_8[sp], r1
FFF1F1F0  72220c04                          add     #40Ch, r2, r2
FFF1F1F4  71035d                            add     #80h+var_23, sp, r3
FFF1F1F7  0553eb00                          bsr.a   sub_FFF2DD4A
FFF1F1FB  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F1FD  ae01                              mov.l   80h+var_20[sp], r1
FFF1F1FF  75019d                            cmp     #-63h, r1
FFF1F202  18                                bne.s   locret_FFF1F20A
FFF1F203  f90601ba                          mov.l   #-46h, 80h+var_7C[sp]
FFF1F207  38d704                            bra.w   loc_FFF1F6DE
FFF1F20A  af81                   locret_FFF1F20A mov.l   80h+var_8[sp], r1
FFF1F20C  710310                            add     #80h+var_70, sp, r3
FFF1F20F  71024f                            add     #80h+var_31, sp, r2
FFF1F212  399019                            bsr.w   sub_FFF20BA2
FFF1F215  c7015c                            mov.b   r1, 80h+var_24[sp]
FFF1F218  cd015c                            mov.b   80h+var_24[sp], r1
FFF1F21B  6111                              cmp     #1, r1
FFF1F21D  210e                              bne.b   loc_FFF1F22B
FFF1F21F  ae01                              mov.l   80h+var_20[sp], r1
FFF1F221  6011                              sub     #1, r1
FFF1F223  fd74810d                          div     #0Dh, r1
FFF1F227  6211                              add     #1, r1
FFF1F229  9601                              mov.w   r1, 80h+var_50[sp]
FFF1F22B  cd015c                 loc_FFF1F22B mov.b   80h+var_24[sp], r1
FFF1F22E  6101                              cmp     #0, r1
FFF1F230  2018                              beq.b   loc_FFF1F248
FFF1F232  cd015d                            mov.b   80h+var_23[sp], r1
FFF1F235  6101                              cmp     #0, r1
FFF1F237  15                                beq.s   loc_FFF1F23C
FFF1F238  f80600                            mov.l   #0, 80h+var_80[sp]
FFF1F23B  0c                                bra.s   loc_FFF1F23F
FFF1F23C  f80601                 loc_FFF1F23C mov.l   #1, 80h+var_80[sp]
FFF1F23F  ec01                   loc_FFF1F23F mov.l   80h+var_80[sp], r1
FFF1F241  6101                              cmp     #0, r1
FFF1F243  15                                beq.s   loc_FFF1F248
FFF1F244  f80601                            mov.l   #1, 80h+var_80[sp]
FFF1F247  0c                                bra.s   loc_FFF1F24B
FFF1F248  f80600                 loc_FFF1F248 mov.l   #0, 80h+var_80[sp]
FFF1F24B  ec01                   loc_FFF1F24B mov.l   80h+var_80[sp], r1
FFF1F24D  6101                              cmp     #0, r1
FFF1F24F  201e                              beq.b   loc_FFF1F26D
FFF1F251  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F254  6101                              cmp     #0, r1
FFF1F256  17                                beq.s   loc_FFF1F25D
FFF1F257  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F25A  6121                              cmp     #2, r1
FFF1F25C  1d                                bne.s   loc_FFF1F261
FFF1F25D  f80601                 loc_FFF1F25D mov.l   #1, 80h+var_80[sp]
FFF1F260  0c                                bra.s   loc_FFF1F264
FFF1F261  f80600                 loc_FFF1F261 mov.l   #0, 80h+var_80[sp]
FFF1F264  ec01                   loc_FFF1F264 mov.l   80h+var_80[sp], r1
FFF1F266  6101                              cmp     #0, r1
FFF1F268  15                                beq.s   loc_FFF1F26D
FFF1F269  f80601                            mov.l   #1, 80h+var_80[sp]
FFF1F26C  0c                                bra.s   loc_FFF1F270
FFF1F26D  f80600                 loc_FFF1F26D mov.l   #0, 80h+var_80[sp]
FFF1F270  ec01                   loc_FFF1F270 mov.l   80h+var_80[sp], r1
FFF1F272  6101                              cmp     #0, r1
FFF1F274  201e                              beq.b   loc_FFF1F292
FFF1F276  af82                              mov.l   80h+var_8[sp], r2
FFF1F278  66d3                              mov.l   #0Dh, r3
FFF1F27A  710142                            add     #80h+var_3E, sp, r1
FFF1F27D  05fbf100                          bsr.a   sub_FFF2E478
FFF1F281  710242                            add     #80h+var_3E, sp, r2
FFF1F284  71014f                            add     #80h+var_31, sp, r1
FFF1F287  0568f500                          bsr.a   sub_FFF2E7EF
FFF1F28B  6101                              cmp     #0, r1
FFF1F28D  1d                                bne.s   loc_FFF1F292
FFF1F28E  f9045c00                          mov.b   #0, 80h+var_24[sp]
FFF1F292  9e01                   loc_FFF1F292 mov.w   80h+var_50[sp], r1
FFF1F294  6211                              add     #1, r1
FFF1F296  9601                              mov.w   r1, 80h+var_50[sp]
FFF1F298  3d8700                            mov.w   #0, 80h+var_52[sp]
FFF1F29B  385a03                            bra.w   locret_FFF1F5F5
FFF1F29E  af89                   locret_FFF1F29E mov.l   80h+var_4[sp], r1
FFF1F2A0  ad99                              mov.l   5Ch[r1], r1
FFF1F2A2  6851                              shlr    #5, r1
FFF1F2A4  bd8a                              movu.w  80h+var_52[sp], r2
FFF1F2A6  fc2712                            divu    r1, r2
FFF1F2A9  a282                              mov.l   r2, 80h+var_58[sp]
FFF1F2AB  af89                              mov.l   80h+var_4[sp], r1
FFF1F2AD  ad99                              mov.l   5Ch[r1], r1
FFF1F2AF  6851                              shlr    #5, r1
FFF1F2B1  bd8a                              movu.w  80h+var_52[sp], r2
FFF1F2B3  ef2e                              mov.l   r2, r14
FFF1F2B5  fc271e                            divu    r1, r14
FFF1F2B8  4f1e                              mul     r1, r14
FFF1F2BA  43e2                              sub     r14, r2
FFF1F2BC  6102                              cmp     #0, r2
FFF1F2BE  15                                beq.s   loc_FFF1F2C3
FFF1F2BF  f80600                            mov.l   #0, 80h+var_80[sp]
FFF1F2C2  0c                                bra.s   loc_FFF1F2C6
FFF1F2C3  f80601                 loc_FFF1F2C3 mov.l   #1, 80h+var_80[sp]
FFF1F2C6  ec01                   loc_FFF1F2C6 mov.l   80h+var_80[sp], r1
FFF1F2C8  6101                              cmp     #0, r1
FFF1F2CA  2022                              beq.b   loc_FFF1F2EC
FFF1F2CC  aa82                              mov.l   80h+var_58[sp], r2
FFF1F2CE  af89                              mov.l   80h+var_4[sp], r1
FFF1F2D0  710308                            add     #80h+var_78, sp, r3
FFF1F2D3  396e12                            bsr.w   sub_FFF20541
FFF1F2D6  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F2D8  ae01                              mov.l   80h+var_20[sp], r1
FFF1F2DA  6101                              cmp     #0, r1
FFF1F2DC  10                                beq.s   loc_FFF1F2E4
FFF1F2DD  e5001801                          mov.l   80h+var_20[sp], 80h+var_7C[sp]
FFF1F2E1  38fd03                            bra.w   loc_FFF1F6DE
FFF1F2E4  e5000a06               loc_FFF1F2E4 mov.l   80h+var_58[sp], 80h+var_68[sp]
FFF1F2E8  e5000203                          mov.l   80h+var_78[sp], 80h+var_74[sp]
FFF1F2EC  a889                   loc_FFF1F2EC mov.l   80h+var_74[sp], r1
FFF1F2EE  6101                              cmp     #0, r1
FFF1F2F0  18                                bne.s   loc_FFF1F2F8
FFF1F2F1  f90601f3                          mov.l   #-0Dh, 80h+var_7C[sp]
FFF1F2F5  38e903                            bra.w   loc_FFF1F6DE
FFF1F2F8  a889                   loc_FFF1F2F8 mov.l   80h+var_74[sp], r1
FFF1F2FA  581e                              movu.b  [r1], r14
FFF1F2FC  755ee5                            cmp     #-1Bh, r14
FFF1F2FF  214b                              bne.b   loc_FFF1F34A
FFF1F301  711120                            add     #20h, r1, r1 ; ' '
FFF1F304  a089                              mov.l   r1, 80h+var_74[sp]
FFF1F306  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F309  6101                              cmp     #0, r1
FFF1F30B  17                                beq.s   loc_FFF1F312
FFF1F30C  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F30F  6121                              cmp     #2, r1
FFF1F311  1d                                bne.s   loc_FFF1F316
FFF1F312  f80601                 loc_FFF1F312 mov.l   #1, 80h+var_80[sp]
FFF1F315  0c                                bra.s   loc_FFF1F319
FFF1F316  f80600                 loc_FFF1F316 mov.l   #0, 80h+var_80[sp]
FFF1F319  ec01                   loc_FFF1F319 mov.l   80h+var_80[sp], r1
FFF1F31B  6101                              cmp     #0, r1
FFF1F31D  3bd202                            bne.w   loc_FFF1F5EF
FFF1F320  9e09                              mov.w   80h+var_4E[sp], r1
FFF1F322  6211                              add     #1, r1
FFF1F324  9609                              mov.w   r1, 80h+var_4E[sp]
FFF1F326  be09                              movu.w  80h+var_4E[sp], r1
FFF1F328  06c50118                          cmp     80h+var_50[sp].uw, r1
FFF1F32C  290d                              blt.b   loc_FFF1F339
FFF1F32E  dd012f                            mov.w   80h+var_22[sp], r1
FFF1F331  7501ff                            cmp     #-1, r1
FFF1F334  1d                                bne.s   loc_FFF1F339
FFF1F335  f80601                            mov.l   #1, 80h+var_80[sp]
FFF1F338  0c                                bra.s   loc_FFF1F33C
FFF1F339  f80600                 loc_FFF1F339 mov.l   #0, 80h+var_80[sp]
FFF1F33C  ec01                   loc_FFF1F33C mov.l   80h+var_80[sp], r1
FFF1F33E  6101                              cmp     #0, r1
FFF1F340  3aaf02                            beq.w   loc_FFF1F5EF
FFF1F343  d500172f                          mov.w   80h+var_52[sp], 80h+var_22[sp]
FFF1F347  38a802                            bra.w   loc_FFF1F5EF
FFF1F34A  581e                   loc_FFF1F34A movu.b  [r1], r14
FFF1F34C  610e                              cmp     #0, r14
FFF1F34E  14                                beq.s   loc_FFF1F352
FFF1F34F  3d8900                            mov.w   #0, 80h+var_4E[sp]
FFF1F352  a889                   loc_FFF1F352 mov.l   80h+var_74[sp], r1
FFF1F354  581e                              movu.b  [r1], r14
FFF1F356  610e                              cmp     #0, r14
FFF1F358  3b6101                            bne.w   loc_FFF1F4B9
FFF1F35B  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F35E  6101                              cmp     #0, r1
FFF1F360  17                                beq.s   loc_FFF1F367
FFF1F361  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F364  6121                              cmp     #2, r1
FFF1F366  1d                                bne.s   loc_FFF1F36B
FFF1F367  f80601                 loc_FFF1F367 mov.l   #1, 80h+var_80[sp]
FFF1F36A  0c                                bra.s   loc_FFF1F36E
FFF1F36B  f80600                 loc_FFF1F36B mov.l   #0, 80h+var_80[sp]
FFF1F36E  ec01                   loc_FFF1F36E mov.l   80h+var_80[sp], r1
FFF1F370  6101                              cmp     #0, r1
FFF1F372  10                                beq.s   loc_FFF1F37A
FFF1F373  f90601b9                          mov.l   #-47h, 80h+var_7C[sp]
FFF1F377  386703                            bra.w   loc_FFF1F6DE
FFF1F37A  aa01                   loc_FFF1F37A mov.l   80h+var_60[sp], r1
FFF1F37C  770140420f                        cmp     #0F4240h, r1
FFF1F381  2316                              bltu.b  loc_FFF1F397
FFF1F383  a989                              mov.l   80h+var_64[sp], r1
FFF1F385  6121                              cmp     #2, r1
FFF1F387  2309                              bltu.b  loc_FFF1F390
FFF1F389  a989                              mov.l   80h+var_64[sp], r1
FFF1F38B  6011                              sub     #1, r1
FFF1F38D  a201                              mov.l   r1, 80h+var_60[sp]
FFF1F38F  08                                bra.s   loc_FFF1F397
FFF1F390  f90601be               loc_FFF1F390 mov.l   #-42h, 80h+var_7C[sp]
FFF1F394  384a03                            bra.w   loc_FFF1F6DE
FFF1F397  aa01                   loc_FFF1F397 mov.l   80h+var_60[sp], r1
FFF1F399  6101                              cmp     #0, r1
FFF1F39B  11                                beq.s   locret_FFF1F3A4
FFF1F39C  aa02                              mov.l   80h+var_60[sp], r2
FFF1F39E  710110                            add     #80h+var_70, sp, r1
FFF1F3A1  391116                            bsr.w   sub_FFF209B2
FFF1F3A4  af81                   locret_FFF1F3A4 mov.l   80h+var_8[sp], r1
FFF1F3A6  710310                            add     #80h+var_70, sp, r3
FFF1F3A9  71024f                            add     #80h+var_31, sp, r2
FFF1F3AC  39f617                            bsr.w   sub_FFF20BA2
FFF1F3AF  c7015c                            mov.b   r1, 80h+var_24[sp]
FFF1F3B2  af8b                              mov.l   80h+var_4[sp], r3
FFF1F3B4  71024f                            add     #80h+var_31, sp, r2
FFF1F3B7  710135                            add     #80h+var_4B, sp, r1
FFF1F3BA  39d114                            bsr.w   sub_FFF2088B
FFF1F3BD  590135                            movu.b  80h+var_4B[sp], r1
FFF1F3C0  7551e5                            cmp     #-1Bh, r1
FFF1F3C3  1d                                bne.s   locret_FFF1F3C8
FFF1F3C4  f9043505                          mov.b   #5, 80h+var_4B[sp]
FFF1F3C8  af09                   locret_FFF1F3C8 mov.l   80h+var_C[sp], r1
FFF1F3CA  66b3                              mov.l   #0Bh, r3
FFF1F3CC  710235                            add     #80h+var_4B, sp, r2
FFF1F3CF  05a9f000                          bsr.a   sub_FFF2E478
FFF1F3D3  dd012f                            mov.w   80h+var_22[sp], r1
FFF1F3D6  6101                              cmp     #0, r1
FFF1F3D8  274a                              bn.b    locret_FFF1F422
FFF1F3DA  dd012f                            mov.w   80h+var_22[sp], r1
FFF1F3DD  ae8a                              mov.l   80h+var_14[sp], r2
FFF1F3DF  e321                              mov.l   r1, [r2]
FFF1F3E1  ae89                              mov.l   80h+var_14[sp], r1
FFF1F3E3  ec1e                              mov.l   [r1], r14
FFF1F3E5  ae81                              mov.l   80h+var_18[sp], r1
FFF1F3E7  db1e100b                          mov.w   r14, 1620h[r1]
FFF1F3EB  9e01                              mov.w   80h+var_50[sp], r1
FFF1F3ED  ae82                              mov.l   80h+var_18[sp], r2
FFF1F3EF  db21110b                          mov.w   r1, 1622h[r2]
FFF1F3F3  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F3F6  6131                              cmp     #3, r1
FFF1F3F8  1f                                bne.s   loc_FFF1F3FF
FFF1F3F9  3e0100                            mov.l   #0, 80h+var_7C[sp]
FFF1F3FC  38e202                            bra.w   loc_FFF1F6DE
FFF1F3FF  ae84                   loc_FFF1F3FF mov.l   80h+var_18[sp], r4
FFF1F401  9e05                              mov.w   80h+var_50[sp], r5
FFF1F403  af0b                              mov.l   80h+var_C[sp], r3
FFF1F405  5d022f                            movu.w  80h+var_22[sp], r2
FFF1F408  af89                              mov.l   80h+var_4[sp], r1
FFF1F40A  6080                              sub     #8, sp
FFF1F40C  d305                              mov.w   r5, 88h+var_88[sp]
FFF1F40E  a00c                              mov.l   r4, 88h+var_84[sp]
FFF1F410  72440c04                          add     #40Ch, r4, r4
FFF1F414  390425                            bsr.w   sub_FFF21918
FFF1F417  6280                              add     #8, sp
FFF1F419  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F41B  e5001801                          mov.l   80h+var_20[sp], 80h+var_7C[sp]
FFF1F41F  38bf02                            bra.w   loc_FFF1F6DE
FFF1F422  af89                   locret_FFF1F422 mov.l   80h+var_4[sp], r1
FFF1F424  b919                              movu.w  0Ah[r1], r1
FFF1F426  06c10117                          sub     80h+var_52[sp].uw, r1
FFF1F42A  06c90119                          add     80h+var_4E[sp].uw, r1
FFF1F42E  9581                              mov.w   r1, 80h+var_54[sp]
FFF1F430  be01                              movu.w  80h+var_50[sp], r1
FFF1F432  06c50116                          cmp     80h+var_54[sp].uw, r1
FFF1F436  2b09                              ble.b   loc_FFF1F43F
FFF1F438  f90601be                          mov.l   #-42h, 80h+var_7C[sp]
FFF1F43C  38a202                            bra.w   loc_FFF1F6DE
FFF1F43F  bd89                   loc_FFF1F43F movu.w  80h+var_52[sp], r1
FFF1F441  06c90118                          add     80h+var_50[sp].uw, r1
FFF1F445  6011                              sub     #1, r1
FFF1F447  06c10119                          sub     80h+var_4E[sp].uw, r1
FFF1F44B  ae8a                              mov.l   80h+var_14[sp], r2
FFF1F44D  e321                              mov.l   r1, [r2]
FFF1F44F  ae89                              mov.l   80h+var_14[sp], r1
FFF1F451  ec1e                              mov.l   [r1], r14
FFF1F453  ae81                              mov.l   80h+var_18[sp], r1
FFF1F455  db1e100b                          mov.w   r14, 1620h[r1]
FFF1F459  9e01                              mov.w   80h+var_50[sp], r1
FFF1F45B  ae82                              mov.l   80h+var_18[sp], r2
FFF1F45D  db21110b                          mov.w   r1, 1622h[r2]
FFF1F461  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F464  6131                              cmp     #3, r1
FFF1F466  1f                                bne.s   loc_FFF1F46D
FFF1F467  3e0100                            mov.l   #0, 80h+var_7C[sp]
FFF1F46A  387402                            bra.w   loc_FFF1F6DE
FFF1F46D  bd8a                   loc_FFF1F46D movu.w  80h+var_52[sp], r2
FFF1F46F  06c90218                          add     80h+var_50[sp].uw, r2
FFF1F473  6012                              sub     #1, r2
FFF1F475  06c10219                          sub     80h+var_4E[sp].uw, r2
FFF1F479  cd015c                            mov.b   80h+var_24[sp], r1
FFF1F47C  6111                              cmp     #1, r1
FFF1F47E  af0b                              mov.l   80h+var_C[sp], r3
FFF1F480  af89                              mov.l   80h+var_4[sp], r1
FFF1F482  211b                              bne.b   loc_FFF1F49D
FFF1F484  ae84                              mov.l   80h+var_18[sp], r4
FFF1F486  9e05                              mov.w   80h+var_50[sp], r5
FFF1F488  6080                              sub     #8, sp
FFF1F48A  d305                              mov.w   r5, 88h+var_88[sp]
FFF1F48C  a00c                              mov.l   r4, 88h+var_84[sp]
FFF1F48E  72440c04                          add     #40Ch, r4, r4
FFF1F492  5f22                              movu.w  r2, r2
FFF1F494  398424                            bsr.w   sub_FFF21918
FFF1F497  6280                              add     #8, sp
FFF1F499  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F49B  2e17                              bra.b   loc_FFF1F4B2
FFF1F49D  ae84                   loc_FFF1F49D mov.l   80h+var_18[sp], r4
FFF1F49F  9e05                              mov.w   80h+var_50[sp], r5
FFF1F4A1  6080                              sub     #8, sp
FFF1F4A3  a00c                              mov.l   r4, 88h+var_84[sp]
FFF1F4A5  d305                              mov.w   r5, 88h+var_88[sp]
FFF1F4A7  5f22                              movu.w  r2, r2
FFF1F4A9  6604                              mov.l   #0, r4
FFF1F4AB  396d24                            bsr.w   sub_FFF21918
FFF1F4AE  6280                              add     #8, sp
FFF1F4B0  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F4B2  e5001801               loc_FFF1F4B2 mov.l   80h+var_20[sp], 80h+var_7C[sp]
FFF1F4B6  382802                            bra.w   loc_FFF1F6DE
FFF1F4B9  a889                   loc_FFF1F4B9 mov.l   80h+var_74[sp], r1
FFF1F4BB  f5130b                            btst    #3, 0Bh[r1].b
FFF1F4BE  15                                beq.s   loc_FFF1F4C3
FFF1F4BF  f80600                            mov.l   #0, 80h+var_80[sp]
FFF1F4C2  0c                                bra.s   loc_FFF1F4C6
FFF1F4C3  f80601                 loc_FFF1F4C3 mov.l   #1, 80h+var_80[sp]
FFF1F4C6  ec01                   loc_FFF1F4C6 mov.l   80h+var_80[sp], r1
FFF1F4C8  6101                              cmp     #0, r1
FFF1F4CA  3a1e01                            beq.w   loc_FFF1F5E8
FFF1F4CD  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F4D0  6131                              cmp     #3, r1
FFF1F4D2  3a1601                            beq.w   loc_FFF1F5E8
FFF1F4D5  ae83                              mov.l   80h+var_18[sp], r3
FFF1F4D7  a985                              mov.l   80h+var_68[sp], r5
FFF1F4D9  be04                              movu.w  80h+var_50[sp], r4
FFF1F4DB  bd8a                              movu.w  80h+var_52[sp], r2
FFF1F4DD  af89                              mov.l   80h+var_4[sp], r1
FFF1F4DF  6080                              sub     #8, sp
FFF1F4E1  e305                              mov.l   r5, 88h+var_88[sp]
FFF1F4E3  a00b                              mov.l   r3, 88h+var_84[sp]
FFF1F4E5  72330c04                          add     #40Ch, r3, r3
FFF1F4E9  39f327                            bsr.w   sub_FFF21CDC
FFF1F4EC  6280                              add     #8, sp
FFF1F4EE  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F4F0  af8b                              mov.l   80h+var_4[sp], r3
FFF1F4F2  71024f                            add     #80h+var_31, sp, r2
FFF1F4F5  710135                            add     #80h+var_4B, sp, r1
FFF1F4F8  399313                            bsr.w   sub_FFF2088B
FFF1F4FB  590135                            movu.b  80h+var_4B[sp], r1
FFF1F4FE  7551e5                            cmp     #-1Bh, r1
FFF1F501  1d                                bne.s   loc_FFF1F506
FFF1F502  f9043505                          mov.b   #5, 80h+var_4B[sp]
FFF1F506  a889                   loc_FFF1F506 mov.l   80h+var_74[sp], r1
FFF1F508  710235                            add     #80h+var_4B, sp, r2
FFF1F50B  39bd1a                            bsr.w   sub_FFF20FC8
FFF1F50E  a209                              mov.l   r1, 80h+var_5C[sp]
FFF1F510  aa09                              mov.l   80h+var_5C[sp], r1
FFF1F512  6101                              cmp     #0, r1
FFF1F514  201b                              beq.b   loc_FFF1F52F
FFF1F516  a989                              mov.l   80h+var_64[sp], r1
FFF1F518  6101                              cmp     #0, r1
FFF1F51A  1f                                bne.s   loc_FFF1F521
FFF1F51B  e5000907                          mov.l   80h+var_5C[sp], 80h+var_64[sp]
FFF1F51F  2e10                              bra.b   loc_FFF1F52F
FFF1F521  aa09                   loc_FFF1F521 mov.l   80h+var_5C[sp], r1
FFF1F523  6011                              sub     #1, r1
FFF1F525  06850107                          cmp     80h+var_64[sp].l, r1
FFF1F529  2206                              bgeu.b  loc_FFF1F52F
FFF1F52B  e5000907                          mov.l   80h+var_5C[sp], 80h+var_64[sp]
FFF1F52F  aa09                   loc_FFF1F52F mov.l   80h+var_5C[sp], r1
FFF1F531  06850108                          cmp     80h+var_60[sp].l, r1
FFF1F535  2308                              bltu.b  loc_FFF1F53D
FFF1F537  aa09                              mov.l   80h+var_5C[sp], r1
FFF1F539  6211                              add     #1, r1
FFF1F53B  a201                              mov.l   r1, 80h+var_60[sp]
FFF1F53D  ae01                   loc_FFF1F53D mov.l   80h+var_20[sp], r1
FFF1F53F  6101                              cmp     #0, r1
FFF1F541  2049                              beq.b   loc_FFF1F58A
FFF1F543  af81                              mov.l   80h+var_8[sp], r1
FFF1F545  05ddf000                          bsr.a   sub_FFF2E622
FFF1F549  61c1                              cmp     #0Ch, r1
FFF1F54B  243f                              bgtu.b  loc_FFF1F58A
FFF1F54D  aa01                              mov.l   80h+var_60[sp], r1
FFF1F54F  6101                              cmp     #0, r1
FFF1F551  11                                beq.s   locret_FFF1F55A
FFF1F552  aa02                              mov.l   80h+var_60[sp], r2
FFF1F554  710110                            add     #80h+var_70, sp, r1
FFF1F557  395b14                            bsr.w   sub_FFF209B2
FFF1F55A  af81                   locret_FFF1F55A mov.l   80h+var_8[sp], r1
FFF1F55C  710310                            add     #80h+var_70, sp, r3
FFF1F55F  71024f                            add     #80h+var_31, sp, r2
FFF1F562  394016                            bsr.w   sub_FFF20BA2
FFF1F565  c7015c                            mov.b   r1, 80h+var_24[sp]
FFF1F568  af8b                              mov.l   80h+var_4[sp], r3
FFF1F56A  71024f                            add     #80h+var_31, sp, r2
FFF1F56D  710135                            add     #80h+var_4B, sp, r1
FFF1F570  391b13                            bsr.w   sub_FFF2088B
FFF1F573  590135                            movu.b  80h+var_4B[sp], r1
FFF1F576  7551e5                            cmp     #-1Bh, r1
FFF1F579  1d                                bne.s   locret_FFF1F57E
FFF1F57A  f9043505                          mov.b   #5, 80h+var_4B[sp]
FFF1F57E  af8b                   locret_FFF1F57E mov.l   80h+var_4[sp], r3
FFF1F580  a889                              mov.l   80h+var_74[sp], r1
FFF1F582  710235                            add     #80h+var_4B, sp, r2
FFF1F585  393929                            bsr.w   sub_FFF21EBE
FFF1F588  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F58A  ae01                   loc_FFF1F58A mov.l   80h+var_20[sp], r1
FFF1F58C  6101                              cmp     #0, r1
FFF1F58E  215a                              bne.b   loc_FFF1F5E8
FFF1F590  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F593  6111                              cmp     #1, r1
FFF1F595  18                                bne.s   loc_FFF1F59D
FFF1F596  f90601f3                          mov.l   #-0Dh, 80h+var_7C[sp]
FFF1F59A  384401                            bra.w   loc_FFF1F6DE
FFF1F59D  a88a                   loc_FFF1F59D mov.l   80h+var_74[sp], r2
FFF1F59F  af09                              mov.l   80h+var_C[sp], r1
FFF1F5A1  754320                            mov.l   #20h, r3 ; ' '
FFF1F5A4  05d4ee00                          bsr.a   sub_FFF2E478
FFF1F5A8  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F5AB  6121                              cmp     #2, r1
FFF1F5AD  2116                              bne.b   loc_FFF1F5C3
FFF1F5AF  ae84                              mov.l   80h+var_18[sp], r4
FFF1F5B1  be03                              movu.w  80h+var_50[sp], r3
FFF1F5B3  bd8a                              movu.w  80h+var_52[sp], r2
FFF1F5B5  af89                              mov.l   80h+var_4[sp], r1
FFF1F5B7  391226                            bsr.w   sub_FFF21BC9
FFF1F5BA  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F5BC  e5001801                          mov.l   80h+var_20[sp], 80h+var_7C[sp]
FFF1F5C0  381e01                            bra.w   loc_FFF1F6DE
FFF1F5C3  cd0173                 loc_FFF1F5C3 mov.b   80h+var_D[sp], r1
FFF1F5C6  6101                              cmp     #0, r1
FFF1F5C8  2120                              bne.b   loc_FFF1F5E8
FFF1F5CA  bd89                              movu.w  80h+var_52[sp], r1
FFF1F5CC  ae8a                              mov.l   80h+var_14[sp], r2
FFF1F5CE  e321                              mov.l   r1, [r2]
FFF1F5D0  ae89                              mov.l   80h+var_14[sp], r1
FFF1F5D2  ec1e                              mov.l   [r1], r14
FFF1F5D4  ae81                              mov.l   80h+var_18[sp], r1
FFF1F5D6  db1e100b                          mov.w   r14, 1620h[r1]
FFF1F5DA  9e01                              mov.w   80h+var_50[sp], r1
FFF1F5DC  ae82                              mov.l   80h+var_18[sp], r2
FFF1F5DE  db21110b                          mov.w   r1, 1622h[r2]
FFF1F5E2  3e0100                            mov.l   #0, 80h+var_7C[sp]
FFF1F5E5  38f900                            bra.w   loc_FFF1F6DE
FFF1F5E8  a889                   loc_FFF1F5E8 mov.l   80h+var_74[sp], r1
FFF1F5EA  711120                            add     #20h, r1, r1 ; ' '
FFF1F5ED  a089                              mov.l   r1, 80h+var_74[sp]
FFF1F5EF  9d89                   loc_FFF1F5EF mov.w   80h+var_52[sp], r1
FFF1F5F1  6211                              add     #1, r1
FFF1F5F3  9589                              mov.w   r1, 80h+var_52[sp]
FFF1F5F5  af89                   locret_FFF1F5F5 mov.l   80h+var_4[sp], r1
FFF1F5F7  bd8a                              movu.w  80h+var_52[sp], r2
FFF1F5F9  06c51205                          cmp     0Ah[r1].uw, r2
FFF1F5FD  2805                              bge.b   loc_FFF1F602
FFF1F5FF  389ffc                            bra.w   locret_FFF1F29E
FFF1F602  cd0173                 loc_FFF1F602 mov.b   80h+var_D[sp], r1
FFF1F605  6111                              cmp     #1, r1
FFF1F607  17                                beq.s   loc_FFF1F60E
FFF1F608  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F60B  6131                              cmp     #3, r1
FFF1F60D  1d                                bne.s   loc_FFF1F612
FFF1F60E  f80601                 loc_FFF1F60E mov.l   #1, 80h+var_80[sp]
FFF1F611  0c                                bra.s   loc_FFF1F615
FFF1F612  f80600                 loc_FFF1F612 mov.l   #0, 80h+var_80[sp]
FFF1F615  ec01                   loc_FFF1F615 mov.l   80h+var_80[sp], r1
FFF1F617  6101                              cmp     #0, r1
FFF1F619  200d                              beq.b   loc_FFF1F626
FFF1F61B  dd012f                            mov.w   80h+var_22[sp], r1
FFF1F61E  6101                              cmp     #0, r1
FFF1F620  2706                              bn.b    loc_FFF1F626
FFF1F622  f80601                            mov.l   #1, 80h+var_80[sp]
FFF1F625  0c                                bra.s   loc_FFF1F629
FFF1F626  f80600                 loc_FFF1F626 mov.l   #0, 80h+var_80[sp]
FFF1F629  ec01                   loc_FFF1F629 mov.l   80h+var_80[sp], r1
FFF1F62B  6101                              cmp     #0, r1
FFF1F62D  3aa200                            beq.w   loc_FFF1F6CF
FFF1F630  aa01                              mov.l   80h+var_60[sp], r1
FFF1F632  770140420f                        cmp     #0F4240h, r1
FFF1F637  2316                              bltu.b  loc_FFF1F64D
FFF1F639  a989                              mov.l   80h+var_64[sp], r1
FFF1F63B  6121                              cmp     #2, r1
FFF1F63D  2309                              bltu.b  loc_FFF1F646
FFF1F63F  a989                              mov.l   80h+var_64[sp], r1
FFF1F641  6011                              sub     #1, r1
FFF1F643  a201                              mov.l   r1, 80h+var_60[sp]
FFF1F645  08                                bra.s   loc_FFF1F64D
FFF1F646  f90601be               loc_FFF1F646 mov.l   #-42h, 80h+var_7C[sp]
FFF1F64A  389400                            bra.w   loc_FFF1F6DE
FFF1F64D  aa01                   loc_FFF1F64D mov.l   80h+var_60[sp], r1
FFF1F64F  6101                              cmp     #0, r1
FFF1F651  11                                beq.s   locret_FFF1F65A
FFF1F652  aa02                              mov.l   80h+var_60[sp], r2
FFF1F654  710110                            add     #80h+var_70, sp, r1
FFF1F657  395b13                            bsr.w   sub_FFF209B2
FFF1F65A  af81                   locret_FFF1F65A mov.l   80h+var_8[sp], r1
FFF1F65C  710310                            add     #80h+var_70, sp, r3
FFF1F65F  71024f                            add     #80h+var_31, sp, r2
FFF1F662  394015                            bsr.w   sub_FFF20BA2
FFF1F665  c7015c                            mov.b   r1, 80h+var_24[sp]
FFF1F668  af8b                              mov.l   80h+var_4[sp], r3
FFF1F66A  71024f                            add     #80h+var_31, sp, r2
FFF1F66D  710135                            add     #80h+var_4B, sp, r1
FFF1F670  391b12                            bsr.w   sub_FFF2088B
FFF1F673  590135                            movu.b  80h+var_4B[sp], r1
FFF1F676  7551e5                            cmp     #-1Bh, r1
FFF1F679  1d                                bne.s   locret_FFF1F67E
FFF1F67A  f9043505                          mov.b   #5, 80h+var_4B[sp]
FFF1F67E  af09                   locret_FFF1F67E mov.l   80h+var_C[sp], r1
FFF1F680  66b3                              mov.l   #0Bh, r3
FFF1F682  710235                            add     #80h+var_4B, sp, r2
FFF1F685  05f3ed00                          bsr.a   sub_FFF2E478
FFF1F689  dd012f                            mov.w   80h+var_22[sp], r1
FFF1F68C  ae8a                              mov.l   80h+var_14[sp], r2
FFF1F68E  e321                              mov.l   r1, [r2]
FFF1F690  ae89                              mov.l   80h+var_14[sp], r1
FFF1F692  ec1e                              mov.l   [r1], r14
FFF1F694  ae81                              mov.l   80h+var_18[sp], r1
FFF1F696  db1e100b                          mov.w   r14, 1620h[r1]
FFF1F69A  9e01                              mov.w   80h+var_50[sp], r1
FFF1F69C  ae82                              mov.l   80h+var_18[sp], r2
FFF1F69E  db21110b                          mov.w   r1, 1622h[r2]
FFF1F6A2  cd0173                            mov.b   80h+var_D[sp], r1
FFF1F6A5  6131                              cmp     #3, r1
FFF1F6A7  1e                                bne.s   loc_FFF1F6AD
FFF1F6A8  3e0100                            mov.l   #0, 80h+var_7C[sp]
FFF1F6AB  2e33                              bra.b   loc_FFF1F6DE
FFF1F6AD  ae84                   loc_FFF1F6AD mov.l   80h+var_18[sp], r4
FFF1F6AF  9e05                              mov.w   80h+var_50[sp], r5
FFF1F6B1  af0b                              mov.l   80h+var_C[sp], r3
FFF1F6B3  5d022f                            movu.w  80h+var_22[sp], r2
FFF1F6B6  af89                              mov.l   80h+var_4[sp], r1
FFF1F6B8  6080                              sub     #8, sp
FFF1F6BA  d305                              mov.w   r5, 88h+var_88[sp]
FFF1F6BC  a00c                              mov.l   r4, 88h+var_84[sp]
FFF1F6BE  72440c04                          add     #40Ch, r4, r4
FFF1F6C2  395622                            bsr.w   sub_FFF21918
FFF1F6C5  6280                              add     #8, sp
FFF1F6C7  a601                              mov.l   r1, 80h+var_20[sp]
FFF1F6C9  e5001801                          mov.l   80h+var_20[sp], 80h+var_7C[sp]
FFF1F6CD  2e11                              bra.b   loc_FFF1F6DE
FFF1F6CF  cd0173                 loc_FFF1F6CF mov.b   80h+var_D[sp], r1
FFF1F6D2  6131                              cmp     #3, r1
FFF1F6D4  1e                                bne.s   loc_FFF1F6DA
FFF1F6D5  f90601f5                          mov.l   #-0Bh, 80h+var_7C[sp]
FFF1F6D9  0d                                bra.s   loc_FFF1F6DE
FFF1F6DA  f90601b9               loc_FFF1F6DA mov.l   #-47h, 80h+var_7C[sp]
FFF1F6DE  a809                   loc_FFF1F6DE mov.l   80h+var_7C[sp], r1
FFF1F6E0  a609                              mov.l   r1, 80h+var_1C[sp]
FFF1F6E2  6720                              rtsd    #20h
FFF1F6E4  6e67                   sub_FFF1F6E4 pushm   r6-r7   ; <<<< FUNC sub_FFF1F6E4
FFF1F6E6  7100d0                            add     #-30h, sp, sp
FFF1F6E9  a289                              mov.l   r1, 30h+var_4[sp]
FFF1F6EB  a282                              mov.l   r2, 30h+var_8[sp]
FFF1F6ED  a20b                              mov.l   r3, 30h+var_C[sp]
FFF1F6EF  a204                              mov.l   r4, 30h+var_10[sp]
FFF1F6F1  c5003c1f                          mov.b   30h+arg_0[sp], 30h+var_11[sp]
FFF1F6F5  c5003d1e                          mov.b   30h+arg_1[sp], 30h+var_12[sp]
FFF1F6F9  e5001006                          mov.l   30h+arg_4[sp], 30h+var_18[sp]
FFF1F6FD  e5001105                          mov.l   30h+arg_8[sp], 30h+var_1C[sp]
FFF1F701  e5001204                          mov.l   30h+arg_C[sp], 30h+var_20[sp]
FFF1F705  aa89                              mov.l   30h+var_4[sp], r1
FFF1F707  05e665ff                          bsr.a   sub_FFF15CED
FFF1F70B  a081                              mov.l   r1, 30h+var_28[sp]
FFF1F70D  a881                              mov.l   30h+var_28[sp], r1
FFF1F70F  6101                              cmp     #0, r1
FFF1F711  16                                beq.s   loc_FFF1F717
FFF1F712  f806db                            mov.l   #-25h, 30h+var_30[sp]
FFF1F715  2e36                              bra.b   loc_FFF1F74B
FFF1F717  a905                   loc_FFF1F717 mov.l   30h+var_20[sp], r5
FFF1F719  ed0f05                            mov.l   30h+var_1C[sp], r15
FFF1F71C  ed0e06                            mov.l   30h+var_18[sp], r14
FFF1F71F  b786                              movu.b  30h+var_12[sp], r6
FFF1F721  b78f                              movu.b  30h+var_11[sp], r7
FFF1F723  aa04                              mov.l   30h+var_10[sp], r4
FFF1F725  aa0b                              mov.l   30h+var_C[sp], r3
FFF1F727  aa82                              mov.l   30h+var_8[sp], r2
FFF1F729  aa89                              mov.l   30h+var_4[sp], r1
FFF1F72B  7100f0                            add     #-10h, sp, sp
FFF1F72E  a08d                              mov.l   r5, 40h+var_34[sp]
FFF1F730  e70f02                            mov.l   r15, 40h+var_38[sp]
FFF1F733  e70e01                            mov.l   r14, 40h+var_3C[sp]
FFF1F736  800e                              mov.b   r6, 40h+var_3F[sp]
FFF1F738  c307                              mov.b   r7, 40h+var_40[sp]
FFF1F73A  391800                            bsr.w   sub_FFF1F752
FFF1F73D  710010                            add     #10h, sp, sp
FFF1F740  a009                              mov.l   r1, 30h+var_2C[sp]
FFF1F742  aa89                              mov.l   30h+var_4[sp], r1
FFF1F744  05b465ff                          bsr.a   sub_FFF15CF8
FFF1F748  e10001                            mov.l   30h+var_2C[sp], 30h+var_30[sp]
FFF1F74B  ec01                   loc_FFF1F74B mov.l   30h+var_30[sp], r1
FFF1F74D  a089                              mov.l   r1, 30h+var_24[sp]
FFF1F74F  3f670e                            rtsd    #38h, r6-r7
FFF1F752  72000cff               sub_FFF1F752 add     #-0F4h, sp, sp   ; <<<< FUNC sub_FFF1F752
FFF1F756  e7013c                            mov.l   r1, 0F4h+var_4[sp]
FFF1F759  e7023b                            mov.l   r2, 0F4h+var_8[sp]
FFF1F75C  e7033a                            mov.l   r3, 0F4h+var_C[sp]
FFF1F75F  e70439                            mov.l   r4, 0F4h+var_10[sp]
FFF1F762  c500f8e3                          mov.b   0F4h+arg_0[sp], 0F4h+var_11[sp]
FFF1F766  c500f9e2                          mov.b   0F4h+arg_1[sp], 0F4h+var_12[sp]
FFF1F76A  e5003f37                          mov.l   0F4h+arg_4[sp], 0F4h+var_18[sp]
FFF1F76E  e5004036                          mov.l   0F4h+arg_8[sp], 0F4h+var_1C[sp]
FFF1F772  e5004135                          mov.l   0F4h+arg_C[sp], 0F4h+var_20[sp]
FFF1F776  3e0c00                            mov.l   #0, 0F4h+var_C4[sp]
FFF1F779  3c8f00                            mov.b   #0, 0F4h+var_D5[sp]
FFF1F77C  3e0601                            mov.l   #1, 0F4h+var_DC[sp]
FFF1F77F  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F782  ad9c                              mov.l   5Ch[r1], r4
FFF1F784  66b3                              mov.l   #0Bh, r3
FFF1F786  754220                            mov.l   #20h, r2 ; ' '
FFF1F789  71010d                            add     #0F4h+var_E7, sp, r1
FFF1F78C  0523ed00                          bsr.a   sub_FFF2E4AF
FFF1F790  3c0d2e                            mov.b   #2Eh, 0F4h+var_E7[sp] ; '.'
FFF1F793  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1F796  72110c06                          add     #60Ch, r1, r1
FFF1F79A  e70125                            mov.l   r1, 0F4h+var_60[sp]
FFF1F79D  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1F7A0  72110c08                          add     #80Ch, r1, r1
FFF1F7A4  e70126                            mov.l   r1, 0F4h+var_5C[sp]
FFF1F7A7  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1F7AA  72110c0a                          add     #0A0Ch, r1, r1
FFF1F7AE  e70127                            mov.l   r1, 0F4h+var_58[sp]
FFF1F7B1  f9045900                          mov.b   #0, 0F4h+var_9B[sp]
FFF1F7B5  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F7B8  ad9c                              mov.l   5Ch[r1], r4
FFF1F7BA  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1F7BD  72110c08                          add     #80Ch, r1, r1
FFF1F7C1  fb3a0002                          mov.l   #200h, r3
FFF1F7C5  6602                              mov.l   #0, r2
FFF1F7C7  05e8ec00                          bsr.a   sub_FFF2E4AF
FFF1F7CB  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F7CE  ad9c                              mov.l   5Ch[r1], r4
FFF1F7D0  ed0135                            mov.l   0F4h+var_20[sp], r1
FFF1F7D3  72110c0a                          add     #0A0Ch, r1, r1
FFF1F7D7  fb3a0002                          mov.l   #200h, r3
FFF1F7DB  6602                              mov.l   #0, r2
FFF1F7DD  05d2ec00                          bsr.a   sub_FFF2E4AF
FFF1F7E1  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F7E4  ad9c                              mov.l   5Ch[r1], r4
FFF1F7E6  66c3                              mov.l   #0Ch, r3
FFF1F7E8  6602                              mov.l   #0, r2
FFF1F7EA  710140                            add     #0F4h+var_B4, sp, r1
FFF1F7ED  05c2ec00                          bsr.a   sub_FFF2E4AF
FFF1F7F1  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F7F4  ad9c                              mov.l   5Ch[r1], r4
FFF1F7F6  66c3                              mov.l   #0Ch, r3
FFF1F7F8  6602                              mov.l   #0, r2
FFF1F7FA  710134                            add     #0F4h+var_C0, sp, r1
FFF1F7FD  05b2ec00                          bsr.a   sub_FFF2E4AF
FFF1F801  f9048c31                          mov.b   #31h, 0F4h+var_68[sp] ; '1'
FFF1F805  f9048d00                          mov.b   #0, 0F4h+var_67[sp]
FFF1F809  f9062c00                          mov.l   #0, 0F4h+var_44[sp]
FFF1F80D  f90965ffff                        mov.w   #-1, 0F4h+var_2A[sp]
FFF1F812  f9052b00                          mov.w   #0, 0F4h+var_9E[sp]
FFF1F816  f9055700                          mov.w   #0, 0F4h+var_46[sp]
FFF1F81A  f9062a00                          mov.l   #0, 0F4h+var_4C[sp]
FFF1F81E  f904a700                          mov.b   #0, 0F4h+var_4D[sp]
FFF1F822  3e0800                            mov.l   #0, 0F4h+var_D4[sp]
FFF1F825  ed0235                            mov.l   0F4h+var_20[sp], r2
FFF1F828  ed033b                            mov.l   0F4h+var_8[sp], r3
FFF1F82B  ed013c                            mov.l   0F4h+var_4[sp], r1
FFF1F82E  6080                              sub     #8, sp
FFF1F830  a00a                              mov.l   r2, 0FCh+var_F8[sp]
FFF1F832  f80472                            mov.b   #72h, 0FCh+var_FC[sp] ; 'r'
FFF1F835  6604                              mov.l   #0, r4
FFF1F837  71022c                            add     #0FCh+var_D0, sp, r2
FFF1F83A  05f54a00                          bsr.a   sub_FFF2432F
FFF1F83E  6280                              add     #8, sp
FFF1F840  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1F843  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1F846  6101                              cmp     #0, r1
FFF1F848  10                                beq.s   loc_FFF1F850
FFF1F849  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
FFF1F84D  383209                            bra.w   loc_FFF2017F
FFF1F850  aa09                   loc_FFF1F850 mov.l   0F4h+var_D0[sp], r1
FFF1F852  6101                              cmp     #0, r1
FFF1F854  18                                bne.s   loc_FFF1F85C
FFF1F855  f90601b9                          mov.l   #-47h, 0F4h+var_F0[sp]
FFF1F859  382609                            bra.w   loc_FFF2017F
FFF1F85C  ed0235                 loc_FFF1F85C mov.l   0F4h+var_20[sp], r2
FFF1F85F  ed013a                            mov.l   0F4h+var_C[sp], r1
FFF1F862  72220c04                          add     #40Ch, r2, r2
FFF1F866  7203a700                          add     #0F4h+var_4D, sp, r3
FFF1F86A  05e0e400                          bsr.a   sub_FFF2DD4A
FFF1F86E  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1F871  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1F874  75019d                            cmp     #-63h, r1
FFF1F877  18                                bne.s   loc_FFF1F87F
FFF1F878  f90601ba                          mov.l   #-46h, 0F4h+var_F0[sp]
FFF1F87C  380309                            bra.w   loc_FFF2017F
FFF1F87F  cd01e3                 loc_FFF1F87F mov.b   0F4h+var_11[sp], r1
FFF1F882  6101                              cmp     #0, r1
FFF1F884  17                                beq.s   loc_FFF1F88B
FFF1F885  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1F888  6121                              cmp     #2, r1
FFF1F88A  1d                                bne.s   loc_FFF1F88F
FFF1F88B  f80601                 loc_FFF1F88B mov.l   #1, 0F4h+var_F4[sp]
FFF1F88E  0c                                bra.s   loc_FFF1F892
FFF1F88F  f80600                 loc_FFF1F88F mov.l   #0, 0F4h+var_F4[sp]
FFF1F892  ec01                   loc_FFF1F892 mov.l   0F4h+var_F4[sp], r1
FFF1F894  6101                              cmp     #0, r1
FFF1F896  201e                              beq.b   loc_FFF1F8B4
FFF1F898  ed013a                            mov.l   0F4h+var_C[sp], r1
FFF1F89B  0587ed00                          bsr.a   sub_FFF2E622
FFF1F89F  61c1                              cmp     #0Ch, r1
FFF1F8A1  2413                              bgtu.b  loc_FFF1F8B4
FFF1F8A3  ed023a                            mov.l   0F4h+var_C[sp], r2
FFF1F8A6  710159                            add     #0F4h+var_9B, sp, r1
FFF1F8A9  05bded00                          bsr.a   sub_FFF2E666
FFF1F8AD  710159                            add     #0F4h+var_9B, sp, r1
FFF1F8B0  0507f100                          bsr.a   sub_FFF2E9B7
FFF1F8B4  cd0159                 loc_FFF1F8B4 mov.b   0F4h+var_9B[sp], r1
FFF1F8B7  6101                              cmp     #0, r1
FFF1F8B9  2116                              bne.b   loc_FFF1F8CF
FFF1F8BB  ed013a                            mov.l   0F4h+var_C[sp], r1
FFF1F8BE  fb32eeadf4ff                      mov.l   #unk_FFF4ADEE, r3
FFF1F8C4  71027f                            add     #0F4h+var_75, sp, r2
FFF1F8C7  39db12                            bsr.w   sub_FFF20BA2
FFF1F8CA  e7012d                            mov.l   r1, 0F4h+var_40[sp]
FFF1F8CD  2e14                              bra.b   loc_FFF1F8E1
FFF1F8CF  fb32eeadf4ff           loc_FFF1F8CF mov.l   #unk_FFF4ADEE, r3
FFF1F8D5  71027f                            add     #0F4h+var_75, sp, r2
FFF1F8D8  710159                            add     #0F4h+var_9B, sp, r1
FFF1F8DB  39c712                            bsr.w   sub_FFF20BA2
FFF1F8DE  e7012d                            mov.l   r1, 0F4h+var_40[sp]
FFF1F8E1  ed012d                 loc_FFF1F8E1 mov.l   0F4h+var_40[sp], r1
FFF1F8E4  6111                              cmp     #1, r1
FFF1F8E6  2110                              bne.b   loc_FFF1F8F6
FFF1F8E8  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1F8EB  6011                              sub     #1, r1
FFF1F8ED  fd74810d                          div     #0Dh, r1
FFF1F8F1  6211                              add     #1, r1
FFF1F8F3  d7012b                            mov.w   r1, 0F4h+var_9E[sp]
FFF1F8F6  5d012b                 loc_FFF1F8F6 movu.w  0F4h+var_9E[sp], r1
FFF1F8F9  6211                              add     #1, r1
FFF1F8FB  d7012b                            mov.w   r1, 0F4h+var_9E[sp]
FFF1F8FE  ed012d                            mov.l   0F4h+var_40[sp], r1
FFF1F901  6101                              cmp     #0, r1
FFF1F903  2018                              beq.b   loc_FFF1F91B
FFF1F905  cd01a7                            mov.b   0F4h+var_4D[sp], r1
FFF1F908  6101                              cmp     #0, r1
FFF1F90A  15                                beq.s   loc_FFF1F90F
FFF1F90B  f80600                            mov.l   #0, 0F4h+var_F4[sp]
FFF1F90E  0c                                bra.s   loc_FFF1F912
FFF1F90F  f80601                 loc_FFF1F90F mov.l   #1, 0F4h+var_F4[sp]
FFF1F912  ec01                   loc_FFF1F912 mov.l   0F4h+var_F4[sp], r1
FFF1F914  6101                              cmp     #0, r1
FFF1F916  15                                beq.s   loc_FFF1F91B
FFF1F917  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1F91A  0c                                bra.s   loc_FFF1F91E
FFF1F91B  f80600                 loc_FFF1F91B mov.l   #0, 0F4h+var_F4[sp]
FFF1F91E  ec01                   loc_FFF1F91E mov.l   0F4h+var_F4[sp], r1
FFF1F920  6101                              cmp     #0, r1
FFF1F922  201e                              beq.b   loc_FFF1F940
FFF1F924  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1F927  6101                              cmp     #0, r1
FFF1F929  17                                beq.s   loc_FFF1F930
FFF1F92A  cd01e3                            mov.b   0F4h+var_11[sp], r1
FFF1F92D  6121                              cmp     #2, r1
FFF1F92F  1d                                bne.s   loc_FFF1F934
FFF1F930  f80601                 loc_FFF1F930 mov.l   #1, 0F4h+var_F4[sp]
FFF1F933  0c                                bra.s   loc_FFF1F937
FFF1F934  f80600                 loc_FFF1F934 mov.l   #0, 0F4h+var_F4[sp]
FFF1F937  ec01                   loc_FFF1F937 mov.l   0F4h+var_F4[sp], r1
FFF1F939  6101                              cmp     #0, r1
FFF1F93B  15                                beq.s   loc_FFF1F940
FFF1F93C  f80601                            mov.l   #1, 0F4h+var_F4[sp]
FFF1F93F  0c                                bra.s   loc_FFF1F943
FFF1F940  f80600                 loc_FFF1F940 mov.l   #0, 0F4h+var_F4[sp]
FFF1F943  ec01                   loc_FFF1F943 mov.l   0F4h+var_F4[sp], r1
FFF1F945  6101                              cmp     #0, r1
FFF1F947  201f                              beq.b   loc_FFF1F966
FFF1F949  66d3                              mov.l   #0Dh, r3
FFF1F94B  710259                            add     #0F4h+var_9B, sp, r2
FFF1F94E  710172                            add     #0F4h+var_82, sp, r1
FFF1F951  0527eb00                          bsr.a   sub_FFF2E478
FFF1F955  710272                            add     #0F4h+var_82, sp, r2
FFF1F958  71017f                            add     #0F4h+var_75, sp, r1
FFF1F95B  0594ee00                          bsr.a   sub_FFF2E7EF
FFF1F95F  6101                              cmp     #0, r1
FFF1F961  1d                                bne.s   loc_FFF1F966
FFF1F962  f9062d00                          mov.l   #0, 0F4h+var_40[sp]
FFF1F966  f9063000               loc_FFF1F966 mov.l   #0, 0F4h+var_34[sp]
FFF1F96A  380208                            bra.w   loc_FFF2016C
FFF1F96D  ac8a                   loc_FFF1F96D mov.l   0F4h+var_A8[sp], r2
FFF1F96F  72039400                          add     #0F4h+var_60, sp, r3
FFF1F973  399d0a                            bsr.w   sub_FFF20410
FFF1F976  e70133                            mov.l   r1, 0F4h+var_28[sp]
FFF1F979  ed0133                            mov.l   0F4h+var_28[sp], r1
FFF1F97C  6101                              cmp     #0, r1
FFF1F97E  10                                beq.s   loc_FFF1F986
FFF1F97F  e5003301                          mov.l   0F4h+var_28[sp], 0F4h+var_F0[sp]
