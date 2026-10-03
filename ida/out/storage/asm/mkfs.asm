; ==== mkfs  FFF35400-FFF36300  (file 335400-336300) ====
FFF35400  1e                                bne.s   loc_FFF35405+1
FFF35401  5eee6101                          movu.w  2C2h[r14], r14
FFF35405  612e                   loc_FFF35405 cmp     #2, r14
FFF35407  200d                              beq.b   loc_FFF35414
FFF35409  a909                              mov.l   24h+var_10[sp], r1
FFF3540B  ec1e                              mov.l   [r1], r14
FFF3540D  5eee6101                          movu.w  2C2h[r14], r14
FFF35411  613e                              cmp     #3, r14
FFF35413  1d                                bne.s   loc_FFF35418
FFF35414  f80601                 loc_FFF35414 mov.l   #1, 24h+var_24[sp]
FFF35417  0c                                bra.s   loc_FFF3541B
FFF35418  f80600                 loc_FFF35418 mov.l   #0, 24h+var_24[sp]
FFF3541B  ec01                   loc_FFF3541B mov.l   24h+var_24[sp], r1
FFF3541D  6101                              cmp     #0, r1
FFF3541F  2019                              beq.b   loc_FFF35438
FFF35421  a90a                              mov.l   24h+var_10[sp], r2
FFF35423  ec21                              mov.l   [r2], r1
FFF35425  a82a                              mov.l   4[r2], r2
FFF35427  ac22                              mov.l   40h[r2], r2
FFF35429  7f12                              jsr     r2
FFF3542B  a089                              mov.l   r1, 24h+var_18[sp]
FFF3542D  a889                              mov.l   24h+var_18[sp], r1
FFF3542F  6101                              cmp     #0, r1
FFF35431  17                                beq.s   loc_FFF35438
FFF35432  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF35436  2e18                              bra.b   loc_FFF3544E
FFF35438  a909                   loc_FFF35438 mov.l   24h+var_10[sp], r1
FFF3543A  ec14                              mov.l   [r1], r4
FFF3543C  a819                              mov.l   4[r1], r1
FFF3543E  ad95                              mov.l   58h[r1], r5
FFF35440  bb0b                              movu.w  24h+var_A[sp], r3
FFF35442  a98a                              mov.l   24h+var_8[sp], r2
FFF35444  a881                              mov.l   24h+var_1C[sp], r1
FFF35446  7f15                              jsr     r5
FFF35448  a089                              mov.l   r1, 24h+var_18[sp]
FFF3544A  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF3544E  a809                   loc_FFF3544E mov.l   24h+var_20[sp], r1
FFF35450  a101                              mov.l   r1, 24h+var_14[sp]
FFF35452  6709                              rtsd    #9
FFF35454  7100dc                 sub_FFF35454 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF35454
FFF35457  a201                              mov.l   r1, 24h+var_4[sp]
FFF35459  a18a                              mov.l   r2, 24h+var_8[sp]
FFF3545B  930b                              mov.w   r3, 24h+var_A[sp]
FFF3545D  a10c                              mov.l   r4, 24h+var_10[sp]
FFF3545F  a849                              mov.l   4[r4], r1
FFF35461  a899                              mov.l   0Ch[r1], r1
FFF35463  7f11                              jsr     r1
FFF35465  6101                              cmp     #0, r1
FFF35467  200c                              beq.b   loc_FFF35473
FFF35469  f90603f9                          mov.l   #-7, 24h+var_18[sp]
FFF3546D  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF35471  2e79                              bra.b   loc_FFF354EA
FFF35473  a909                   loc_FFF35473 mov.l   24h+var_10[sp], r1
FFF35475  ec1e                              mov.l   [r1], r14
FFF35477  5eee6001                          movu.w  2C0h[r14], r14
FFF3547B  7c1e                              btst    #1, r14
FFF3547D  aa01                              mov.l   24h+var_4[sp], r1
FFF3547F  14                                beq.s   loc_FFF35483
FFF35480  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35482  0d                                bra.s   loc_FFF35487
FFF35483  6c91                   loc_FFF35483 shll    #9, r1
FFF35485  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35487  a909                   loc_FFF35487 mov.l   24h+var_10[sp], r1
FFF35489  39e3f1                            bsr.w   sub_FFF3466C
FFF3548C  a089                              mov.l   r1, 24h+var_18[sp]
FFF3548E  a889                              mov.l   24h+var_18[sp], r1
FFF35490  6101                              cmp     #0, r1
FFF35492  17                                beq.s   loc_FFF35499
FFF35493  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF35497  2e53                              bra.b   loc_FFF354EA
FFF35499  a909                   loc_FFF35499 mov.l   24h+var_10[sp], r1
FFF3549B  ec1e                              mov.l   [r1], r14
FFF3549D  5eee6101                          movu.w  2C2h[r14], r14
FFF354A1  612e                              cmp     #2, r14
FFF354A3  200d                              beq.b   loc_FFF354B0
FFF354A5  a909                              mov.l   24h+var_10[sp], r1
FFF354A7  ec1e                              mov.l   [r1], r14
FFF354A9  5eee6101                          movu.w  2C2h[r14], r14
FFF354AD  613e                              cmp     #3, r14
FFF354AF  1d                                bne.s   loc_FFF354B4
FFF354B0  f80601                 loc_FFF354B0 mov.l   #1, 24h+var_24[sp]
FFF354B3  0c                                bra.s   loc_FFF354B7
FFF354B4  f80600                 loc_FFF354B4 mov.l   #0, 24h+var_24[sp]
FFF354B7  ec01                   loc_FFF354B7 mov.l   24h+var_24[sp], r1
FFF354B9  6101                              cmp     #0, r1
FFF354BB  2019                              beq.b   loc_FFF354D4
FFF354BD  a90a                              mov.l   24h+var_10[sp], r2
FFF354BF  ec21                              mov.l   [r2], r1
FFF354C1  a82a                              mov.l   4[r2], r2
FFF354C3  ac22                              mov.l   40h[r2], r2
FFF354C5  7f12                              jsr     r2
FFF354C7  a089                              mov.l   r1, 24h+var_18[sp]
FFF354C9  a889                              mov.l   24h+var_18[sp], r1
FFF354CB  6101                              cmp     #0, r1
FFF354CD  17                                beq.s   loc_FFF354D4
FFF354CE  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF354D2  2e18                              bra.b   loc_FFF354EA
FFF354D4  a909                   loc_FFF354D4 mov.l   24h+var_10[sp], r1
FFF354D6  ec14                              mov.l   [r1], r4
FFF354D8  a819                              mov.l   4[r1], r1
FFF354DA  ae15                              mov.l   60h[r1], r5
FFF354DC  bb0b                              movu.w  24h+var_A[sp], r3
FFF354DE  a98a                              mov.l   24h+var_8[sp], r2
FFF354E0  a881                              mov.l   24h+var_1C[sp], r1
FFF354E2  7f15                              jsr     r5
FFF354E4  a089                              mov.l   r1, 24h+var_18[sp]
FFF354E6  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF354EA  a809                   loc_FFF354EA mov.l   24h+var_20[sp], r1
FFF354EC  a101                              mov.l   r1, 24h+var_14[sp]
FFF354EE  6709                              rtsd    #9
FFF354F0  6080                   sub_FFF354F0 sub     #8, sp   ; <<<< FUNC sub_FFF354F0
FFF354F2  a009                              mov.l   r1, 8+var_4[sp]
FFF354F4  a819                              mov.l   4[r1], r1
FFF354F6  a891                              mov.l   8[r1], r1
FFF354F8  7f11                              jsr     r1
FFF354FA  e301                              mov.l   r1, 8+var_8[sp]
FFF354FC  6702                              rtsd    #2
FFF354FE  7100dc                 sub_FFF354FE add     #-24h, sp, sp   ; <<<< FUNC sub_FFF354FE
FFF35501  a201                              mov.l   r1, 24h+var_4[sp]
FFF35503  a18a                              mov.l   r2, 24h+var_8[sp]
FFF35505  a183                              mov.l   r3, 24h+var_C[sp]
FFF35507  928c                              mov.w   r4, 24h+var_E[sp]
FFF35509  e5000a04                          mov.l   24h+arg_0[sp], 24h+var_14[sp]
FFF3550D  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF35510  aa01                              mov.l   24h+var_4[sp], r1
FFF35512  a98a                              mov.l   24h+var_8[sp], r2
FFF35514  06851205                          cmp     14h[r1].l, r2
FFF35518  2308                              bltu.b  loc_FFF35520
FFF3551A  f90601fe                          mov.l   #-2, 24h+var_20[sp]
FFF3551E  2e44                              bra.b   loc_FFF35562
FFF35520  3e0200                 loc_FFF35520 mov.l   #0, 24h+var_1C[sp]
FFF35523  2e39                              bra.b   loc_FFF3555C
FFF35525  a901                   loc_FFF35525 mov.l   24h+var_14[sp], r1
FFF35527  a819                              mov.l   4[r1], r1
FFF35529  a891                              mov.l   8[r1], r1
FFF3552B  7f11                              jsr     r1
FFF3552D  a009                              mov.l   r1, 24h+var_20[sp]
FFF3552F  a809                              mov.l   24h+var_20[sp], r1
FFF35531  6101                              cmp     #0, r1
FFF35533  16                                beq.s   loc_FFF35539
FFF35534  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF35537  2e2e                              bra.b   loc_FFF35565
FFF35539  aa01                   loc_FFF35539 mov.l   24h+var_4[sp], r1
FFF3553B  ab11                              mov.l   30h[r1], r1
FFF3553D  06890107                          add     24h+var_8[sp].l, r1
FFF35541  a904                              mov.l   24h+var_14[sp], r4
FFF35543  ba8b                              movu.w  24h+var_E[sp], r3
FFF35545  a982                              mov.l   24h+var_C[sp], r2
FFF35547  3987fe                            bsr.w   sub_FFF353CE
FFF3554A  a009                              mov.l   r1, 24h+var_20[sp]
FFF3554C  a809                              mov.l   24h+var_20[sp], r1
FFF3554E  6101                              cmp     #0, r1
FFF35550  1e                                bne.s   loc_FFF35556
FFF35551  f80600                            mov.l   #0, 24h+var_24[sp]
FFF35554  2e11                              bra.b   loc_FFF35565
FFF35556  a881                   loc_FFF35556 mov.l   24h+var_1C[sp], r1
FFF35558  6211                              add     #1, r1
FFF3555A  a081                              mov.l   r1, 24h+var_1C[sp]
FFF3555C  a881                   loc_FFF3555C mov.l   24h+var_1C[sp], r1
FFF3555E  6131                              cmp     #3, r1
FFF35560  29c5                              blt.b   loc_FFF35525
FFF35562  e10001                 loc_FFF35562 mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF35565  ec01                   loc_FFF35565 mov.l   24h+var_24[sp], r1
FFF35567  a089                              mov.l   r1, 24h+var_18[sp]
FFF35569  6709                              rtsd    #9
FFF3556B  7100dc                 sub_FFF3556B add     #-24h, sp, sp   ; <<<< FUNC sub_FFF3556B
FFF3556E  a201                              mov.l   r1, 24h+var_4[sp]
FFF35570  a18a                              mov.l   r2, 24h+var_8[sp]
FFF35572  a183                              mov.l   r3, 24h+var_C[sp]
FFF35574  928c                              mov.w   r4, 24h+var_E[sp]
FFF35576  e5000a04                          mov.l   24h+arg_0[sp], 24h+var_14[sp]
FFF3557A  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF3557D  aa01                              mov.l   24h+var_4[sp], r1
FFF3557F  a98a                              mov.l   24h+var_8[sp], r2
FFF35581  06851205                          cmp     14h[r1].l, r2
FFF35585  2308                              bltu.b  loc_FFF3558D
FFF35587  f90601fe                          mov.l   #-2, 24h+var_20[sp]
FFF3558B  2e44                              bra.b   loc_FFF355CF
FFF3558D  3e0200                 loc_FFF3558D mov.l   #0, 24h+var_1C[sp]
FFF35590  2e39                              bra.b   loc_FFF355C9
FFF35592  a901                   loc_FFF35592 mov.l   24h+var_14[sp], r1
FFF35594  a819                              mov.l   4[r1], r1
FFF35596  a891                              mov.l   8[r1], r1
FFF35598  7f11                              jsr     r1
FFF3559A  a009                              mov.l   r1, 24h+var_20[sp]
FFF3559C  a809                              mov.l   24h+var_20[sp], r1
FFF3559E  6101                              cmp     #0, r1
FFF355A0  16                                beq.s   loc_FFF355A6
FFF355A1  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF355A4  2e2e                              bra.b   loc_FFF355D2
FFF355A6  aa01                   loc_FFF355A6 mov.l   24h+var_4[sp], r1
FFF355A8  ab11                              mov.l   30h[r1], r1
FFF355AA  06890107                          add     24h+var_8[sp].l, r1
FFF355AE  a904                              mov.l   24h+var_14[sp], r4
FFF355B0  ba8b                              movu.w  24h+var_E[sp], r3
FFF355B2  a982                              mov.l   24h+var_C[sp], r2
FFF355B4  39a0fe                            bsr.w   sub_FFF35454
FFF355B7  a009                              mov.l   r1, 24h+var_20[sp]
FFF355B9  a809                              mov.l   24h+var_20[sp], r1
FFF355BB  6101                              cmp     #0, r1
FFF355BD  1e                                bne.s   loc_FFF355C3
FFF355BE  f80600                            mov.l   #0, 24h+var_24[sp]
FFF355C1  2e11                              bra.b   loc_FFF355D2
FFF355C3  a881                   loc_FFF355C3 mov.l   24h+var_1C[sp], r1
FFF355C5  6211                              add     #1, r1
FFF355C7  a081                              mov.l   r1, 24h+var_1C[sp]
FFF355C9  a881                   loc_FFF355C9 mov.l   24h+var_1C[sp], r1
FFF355CB  6131                              cmp     #3, r1
FFF355CD  29c5                              blt.b   loc_FFF35592
FFF355CF  e10001                 loc_FFF355CF mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF355D2  ec01                   loc_FFF355D2 mov.l   24h+var_24[sp], r1
FFF355D4  a089                              mov.l   r1, 24h+var_18[sp]
FFF355D6  6709                              rtsd    #9
FFF355D8  7100e8                 sub_FFF355D8 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF355D8
FFF355DB  ef24                              mov.l   r2, r4
FFF355DD  a109                              mov.l   r1, 18h+var_4[sp]
FFF355DF  a104                              mov.l   r4, 18h+var_8[sp]
FFF355E1  ec42                              mov.l   [r4], r2
FFF355E3  6212                              add     #1, r2
FFF355E5  6613                              mov.l   #1, r3
FFF355E7  6601                              mov.l   #0, r1
FFF355E9  39e5fd                            bsr.w   sub_FFF353CE
FFF355EC  a081                              mov.l   r1, 18h+var_10[sp]
FFF355EE  a881                              mov.l   18h+var_10[sp], r1
FFF355F0  6101                              cmp     #0, r1
FFF355F2  17                                beq.s   loc_FFF355F9
FFF355F3  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF355F6  388700                            bra.w   loc_FFF3567D
FFF355F9  a901                   loc_FFF355F9 mov.l   18h+var_8[sp], r1
FFF355FB  ec12                              mov.l   [r1], r2
FFF355FD  a909                              mov.l   18h+var_4[sp], r1
FFF355FF  6212                              add     #1, r2
FFF35601  0500eafe                          bsr.a   sub_FFF24001
FFF35605  a081                              mov.l   r1, 18h+var_10[sp]
FFF35607  a881                              mov.l   18h+var_10[sp], r1
FFF35609  6101                              cmp     #0, r1
FFF3560B  16                                beq.s   loc_FFF35611
FFF3560C  f806fc                            mov.l   #-4, 18h+var_18[sp]
FFF3560F  2e6e                              bra.b   loc_FFF3567D
FFF35611  a904                   loc_FFF35611 mov.l   18h+var_8[sp], r4
FFF35613  ec42                              mov.l   [r4], r2
FFF35615  a909                              mov.l   18h+var_4[sp], r1
FFF35617  ab11                              mov.l   30h[r1], r1
FFF35619  6212                              add     #1, r2
FFF3561B  6613                              mov.l   #1, r3
FFF3561D  39b1fd                            bsr.w   sub_FFF353CE
FFF35620  a081                              mov.l   r1, 18h+var_10[sp]
FFF35622  a881                              mov.l   18h+var_10[sp], r1
FFF35624  6101                              cmp     #0, r1
FFF35626  16                                beq.s   loc_FFF3562C
FFF35627  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF3562A  2e53                              bra.b   loc_FFF3567D
FFF3562C  a901                   loc_FFF3562C mov.l   18h+var_8[sp], r1
FFF3562E  ec12                              mov.l   [r1], r2
FFF35630  a909                              mov.l   18h+var_4[sp], r1
FFF35632  6212                              add     #1, r2
FFF35634  05a2e8fe                          bsr.a   sub_FFF23ED6
FFF35638  a009                              mov.l   r1, 18h+var_14[sp]
FFF3563A  a809                              mov.l   18h+var_14[sp], r1
FFF3563C  69f1                              shlr    #1Fh, r1
FFF3563E  6101                              cmp     #0, r1
FFF35640  16                                beq.s   loc_FFF35646
FFF35641  f806fc                            mov.l   #-4, 18h+var_18[sp]
FFF35644  2e39                              bra.b   loc_FFF3567D
FFF35646  a909                   loc_FFF35646 mov.l   18h+var_4[sp], r1
FFF35648  8c11                              mov.b   10h[r1], r1
FFF3564A  755120                            cmp     #20h, r1 ; ' '
FFF3564D  212d                              bne.b   loc_FFF3567A
FFF3564F  a90a                              mov.l   18h+var_4[sp], r2
FFF35651  ab21                              mov.l   30h[r2], r1
FFF35653  06c9211d                          add     3Ah[r2].uw, r1
FFF35657  a904                              mov.l   18h+var_8[sp], r4
FFF35659  ec42                              mov.l   [r4], r2
FFF3565B  6212                              add     #1, r2
FFF3565D  6613                              mov.l   #1, r3
FFF3565F  396ffd                            bsr.w   sub_FFF353CE
FFF35662  a081                              mov.l   r1, 18h+var_10[sp]
FFF35664  a881                              mov.l   18h+var_10[sp], r1
FFF35666  6101                              cmp     #0, r1
FFF35668  16                                beq.s   loc_FFF3566E
FFF35669  e10002                            mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF3566C  2e11                              bra.b   loc_FFF3567D
FFF3566E  a901                   loc_FFF3566E mov.l   18h+var_8[sp], r1
FFF35670  ec12                              mov.l   [r1], r2
FFF35672  a909                              mov.l   18h+var_4[sp], r1
FFF35674  6212                              add     #1, r2
FFF35676  05d6e7fe                          bsr.a   sub_FFF23E4C
FFF3567A  f80600                 loc_FFF3567A mov.l   #0, 18h+var_18[sp]
FFF3567D  ec01                   loc_FFF3567D mov.l   18h+var_18[sp], r1
FFF3567F  a089                              mov.l   r1, 18h+var_C[sp]
FFF35681  6706                              rtsd    #6
FFF35683  7100e4                 sub_FFF35683 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF35683
FFF35686  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF35688  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF3568A  a829                              mov.l   4[r2], r1
FFF3568C  aa19                              mov.l   24h[r1], r1
FFF3568E  7f11                              jsr     r1
FFF35690  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35692  a881                              mov.l   1Ch+var_14[sp], r1
FFF35694  6101                              cmp     #0, r1
FFF35696  10                                beq.s   loc_FFF3569E
FFF35697  e5000201                          mov.l   1Ch+var_14[sp], 1Ch+var_18[sp]
FFF3569B  384401                            bra.w   loc_FFF357DF
FFF3569E  f90602ff               loc_FFF3569E mov.l   #-1, 1Ch+var_14[sp]
FFF356A2  3e0300                            mov.l   #0, 1Ch+var_10[sp]
FFF356A5  382d01                            bra.w   loc_FFF357D2
FFF356A8  a909                   loc_FFF356A8 mov.l   1Ch+var_8[sp], r1
FFF356AA  a819                              mov.l   4[r1], r1
FFF356AC  aa12                              mov.l   20h[r1], r2
FFF356AE  6621                              mov.l   #2, r1
FFF356B0  7f12                              jsr     r2
FFF356B2  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF356B4  a881                              mov.l   1Ch+var_14[sp], r1
FFF356B6  6101                              cmp     #0, r1
FFF356B8  3b1401                            bne.w   loc_FFF357CC
FFF356BB  a909                              mov.l   1Ch+var_8[sp], r1
FFF356BD  39f0fa                            bsr.w   sub_FFF351AD
FFF356C0  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF356C2  a881                              mov.l   1Ch+var_14[sp], r1
FFF356C4  6101                              cmp     #0, r1
FFF356C6  3b0601                            bne.w   loc_FFF357CC
FFF356C9  a909                              mov.l   1Ch+var_8[sp], r1
FFF356CB  3914fc                            bsr.w   sub_FFF352DF
FFF356CE  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF356D0  a881                              mov.l   1Ch+var_14[sp], r1
FFF356D2  6101                              cmp     #0, r1
FFF356D4  3bf800                            bne.w   loc_FFF357CC
FFF356D7  a90c                              mov.l   1Ch+var_8[sp], r4
FFF356D9  ec4e                              mov.l   [r4], r14
FFF356DB  5ee15501                          movu.w  2AAh[r14], r1
FFF356DF  6613                              mov.l   #1, r3
FFF356E1  fb2a0002                          mov.l   #200h, r2
FFF356E5  3962fc                            bsr.w   sub_FFF35347
FFF356E8  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF356EA  a881                              mov.l   1Ch+var_14[sp], r1
FFF356EC  6101                              cmp     #0, r1
FFF356EE  3bde00                            bne.w   loc_FFF357CC
FFF356F1  a90a                              mov.l   1Ch+var_8[sp], r2
FFF356F3  ec2e                              mov.l   [r2], r14
FFF356F5  5ee15501                          movu.w  2AAh[r14], r1
FFF356F9  399ef1                            bsr.w   sub_FFF34897
FFF356FC  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF356FE  a881                              mov.l   1Ch+var_14[sp], r1
FFF35700  6101                              cmp     #0, r1
FFF35702  3bca00                            bne.w   loc_FFF357CC
FFF35705  a909                              mov.l   1Ch+var_8[sp], r1
FFF35707  ec1e                              mov.l   [r1], r14
FFF35709  5eee6301                          movu.w  2C6h[r14], r14
FFF3570D  611e                              cmp     #1, r14
FFF3570F  203a                              beq.b   loc_FFF35749
FFF35711  a909                              mov.l   1Ch+var_8[sp], r1
FFF35713  3987fc                            bsr.w   sub_FFF3539A
FFF35716  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35718  a881                              mov.l   1Ch+var_14[sp], r1
FFF3571A  6101                              cmp     #0, r1
FFF3571C  3bb000                            bne.w   loc_FFF357CC
FFF3571F  a909                              mov.l   1Ch+var_8[sp], r1
FFF35721  3925f2                            bsr.w   sub_FFF34946
FFF35724  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35726  a881                              mov.l   1Ch+var_14[sp], r1
FFF35728  6101                              cmp     #0, r1
FFF3572A  3ba200                            bne.w   loc_FFF357CC
FFF3572D  a909                              mov.l   1Ch+var_8[sp], r1
FFF3572F  39cdf3                            bsr.w   sub_FFF34AFC
FFF35732  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35734  a881                              mov.l   1Ch+var_14[sp], r1
FFF35736  6101                              cmp     #0, r1
FFF35738  3b9400                            bne.w   loc_FFF357CC
FFF3573B  a909                              mov.l   1Ch+var_8[sp], r1
FFF3573D  39a3f2                            bsr.w   sub_FFF349E0
FFF35740  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35742  a881                              mov.l   1Ch+var_14[sp], r1
FFF35744  6101                              cmp     #0, r1
FFF35746  3b8600                            bne.w   loc_FFF357CC
FFF35749  a90a                   loc_FFF35749 mov.l   1Ch+var_8[sp], r2
FFF3574B  6611                              mov.l   #1, r1
FFF3574D  392de5                            bsr.w   sub_FFF33C7A
FFF35750  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35752  a881                              mov.l   1Ch+var_14[sp], r1
FFF35754  6101                              cmp     #0, r1
FFF35756  2176                              bne.b   loc_FFF357CC
FFF35758  a909                              mov.l   1Ch+var_8[sp], r1
FFF3575A  ec1e                              mov.l   [r1], r14
FFF3575C  5eee6101                          movu.w  2C2h[r14], r14
FFF35760  612e                              cmp     #2, r14
FFF35762  200d                              beq.b   loc_FFF3576F
FFF35764  a909                              mov.l   1Ch+var_8[sp], r1
FFF35766  ec1e                              mov.l   [r1], r14
FFF35768  5eee6101                          movu.w  2C2h[r14], r14
FFF3576C  613e                              cmp     #3, r14
FFF3576E  1d                                bne.s   loc_FFF35773
FFF3576F  f80601                 loc_FFF3576F mov.l   #1, 1Ch+var_1C[sp]
FFF35772  0c                                bra.s   loc_FFF35776
FFF35773  f80600                 loc_FFF35773 mov.l   #0, 1Ch+var_1C[sp]
FFF35776  ec01                   loc_FFF35776 mov.l   1Ch+var_1C[sp], r1
FFF35778  6101                              cmp     #0, r1
FFF3577A  2014                              beq.b   loc_FFF3578E
FFF3577C  a90a                              mov.l   1Ch+var_8[sp], r2
FFF3577E  ec21                              mov.l   [r2], r1
FFF35780  a82a                              mov.l   4[r2], r2
FFF35782  ac22                              mov.l   40h[r2], r2
FFF35784  7f12                              jsr     r2
FFF35786  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35788  a881                              mov.l   1Ch+var_14[sp], r1
FFF3578A  6101                              cmp     #0, r1
FFF3578C  2140                              bne.b   loc_FFF357CC
FFF3578E  a90a                   loc_FFF3578E mov.l   1Ch+var_8[sp], r2
FFF35790  a981                              mov.l   1Ch+var_4[sp], r1
FFF35792  3946fe                            bsr.w   sub_FFF355D8
FFF35795  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF35797  a881                              mov.l   1Ch+var_14[sp], r1
FFF35799  6101                              cmp     #0, r1
FFF3579B  2131                              bne.b   loc_FFF357CC
FFF3579D  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF357A0  0540d2ff                          bsr.a   sub_FFF329E0
FFF357A4  a981                              mov.l   1Ch+var_4[sp], r1
FFF357A6  f11758                            bset    #7, 58h[r1].b
FFF357A9  a909                              mov.l   1Ch+var_8[sp], r1
FFF357AB  a819                              mov.l   4[r1], r1
FFF357AD  a899                              mov.l   0Ch[r1], r1
FFF357AF  7f11                              jsr     r1
FFF357B1  6101                              cmp     #0, r1
FFF357B3  a981                              mov.l   1Ch+var_4[sp], r1
FFF357B5  cd1e58                            mov.b   58h[r1], r14
FFF357B8  17                                beq.s   loc_FFF357BF
FFF357B9  785e                              bset    #5, r14
FFF357BB  c71e58                            mov.b   r14, 58h[r1]
FFF357BE  08                                bra.s   loc_FFF357C6
FFF357BF  762edf00               loc_FFF357BF and     #0DFh, r14
FFF357C3  c71e58                            mov.b   r14, 58h[r1]
FFF357C6  0528d2ff               loc_FFF357C6 bsr.a   sub_FFF329EE
FFF357CA  2e11                              bra.b   loc_FFF357DB
FFF357CC  a889                   loc_FFF357CC mov.l   1Ch+var_10[sp], r1
FFF357CE  6211                              add     #1, r1
FFF357D0  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF357D2  a889                   loc_FFF357D2 mov.l   1Ch+var_10[sp], r1
FFF357D4  6131                              cmp     #3, r1
FFF357D6  2805                              bge.b   loc_FFF357DB
FFF357D8  38d0fe                            bra.w   loc_FFF356A8
FFF357DB  e5000201               loc_FFF357DB mov.l   1Ch+var_14[sp], 1Ch+var_18[sp]
FFF357DF  a809                   loc_FFF357DF mov.l   1Ch+var_18[sp], r1
FFF357E1  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF357E3  6707                              rtsd    #7
FFF357E5  60c0                   sub_FFF357E5 sub     #0Ch, sp   ; <<<< FUNC sub_FFF357E5
FFF357E7  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF357E9  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF357EB  a829                              mov.l   4[r2], r1
FFF357ED  aa91                              mov.l   28h[r1], r1
FFF357EF  7f11                              jsr     r1
FFF357F1  05efd1ff                          bsr.a   sub_FFF329E0
FFF357F5  a881                              mov.l   0Ch+var_4[sp], r1
FFF357F7  f11f58                            bclr    #7, 58h[r1].b
FFF357FA  05f4d1ff                          bsr.a   sub_FFF329EE
FFF357FE  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF35801  6601                              mov.l   #0, r1
FFF35803  6703                              rtsd    #3
FFF35805  7100ec                 sub_FFF35805 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF35805
FFF35808  a101                              mov.l   r1, 14h+var_4[sp]
FFF3580A  a08a                              mov.l   r2, 14h+var_8[sp]
FFF3580C  a829                              mov.l   4[r2], r1
FFF3580E  ae19                              mov.l   64h[r1], r1
FFF35810  7f11                              jsr     r1
FFF35812  a009                              mov.l   r1, 14h+var_10[sp]
FFF35814  a809                              mov.l   14h+var_10[sp], r1
FFF35816  6101                              cmp     #0, r1
FFF35818  16                                beq.s   loc_FFF3581E
FFF35819  f806f8                            mov.l   #-8, 14h+var_14[sp]
FFF3581C  2e22                              bra.b   loc_FFF3583E
FFF3581E  a889                   loc_FFF3581E mov.l   14h+var_8[sp], r1
FFF35820  ec1e                              mov.l   [r1], r14
FFF35822  58e2                              movu.b  [r14], r2
FFF35824  a901                              mov.l   14h+var_4[sp], r1
FFF35826  05d4d1ff                          bsr.a   sub_FFF329FA
FFF3582A  a009                              mov.l   r1, 14h+var_10[sp]
FFF3582C  a809                              mov.l   14h+var_10[sp], r1
FFF3582E  6101                              cmp     #0, r1
FFF35830  15                                beq.s   loc_FFF35835
FFF35831  f806f8                            mov.l   #-8, 14h+var_14[sp]
FFF35834  0a                                bra.s   loc_FFF3583E
FFF35835  a889                   loc_FFF35835 mov.l   14h+var_8[sp], r1
FFF35837  a902                              mov.l   14h+var_4[sp], r2
FFF35839  a229                              mov.l   r1, 24h[r2]
FFF3583B  f80600                            mov.l   #0, 14h+var_14[sp]
FFF3583E  ec01                   loc_FFF3583E mov.l   14h+var_14[sp], r1
FFF35840  a081                              mov.l   r1, 14h+var_C[sp]
FFF35842  6705                              rtsd    #5
FFF35844  7100dc                 sub_FFF35844 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF35844
FFF35847  a201                              mov.l   r1, 24h+var_4[sp]
FFF35849  a18a                              mov.l   r2, 24h+var_8[sp]
FFF3584B  a183                              mov.l   r3, 24h+var_C[sp]
FFF3584D  a10c                              mov.l   r4, 24h+var_10[sp]
FFF3584F  d5001409                          mov.w   24h+arg_0[sp], 24h+var_12[sp]
FFF35853  e5000b03                          mov.l   24h+arg_4[sp], 24h+var_18[sp]
FFF35857  a989                              mov.l   24h+var_8[sp], r1
FFF35859  6191                              cmp     #9, r1
FFF3585B  3ab200                            beq.w   loc_FFF3590D
FFF3585E  6121                              cmp     #2, r1
FFF35860  2045                              beq.b   loc_FFF358A5
FFF35862  6151                              cmp     #5, r1
FFF35864  3a9e00                            beq.w   loc_FFF35902
FFF35867  6171                              cmp     #7, r1
FFF35869  206b                              beq.b   loc_FFF358D4
FFF3586B  6181                              cmp     #8, r1
FFF3586D  3a8a00                            beq.w   loc_FFF358F7
FFF35870  6111                              cmp     #1, r1
FFF35872  3ba300                            bne.w   loc_FFF35915
FFF35875  aa01                              mov.l   24h+var_4[sp], r1
FFF35877  f51658                            btst    #6, 58h[r1].b
FFF3587A  15                                beq.s   loc_FFF3587F
FFF3587B  f80600                            mov.l   #0, 24h+var_24[sp]
FFF3587E  0c                                bra.s   loc_FFF35882
FFF3587F  f80601                 loc_FFF3587F mov.l   #1, 24h+var_24[sp]
FFF35882  ec01                   loc_FFF35882 mov.l   24h+var_24[sp], r1
FFF35884  6101                              cmp     #0, r1
FFF35886  10                                beq.s   loc_FFF3588E
FFF35887  f90601fa                          mov.l   #-6, 24h+var_20[sp]
FFF3588B  388e00                            bra.w   loc_FFF35919
FFF3588E  a88d                   loc_FFF3588E mov.l   24h+var_18[sp], r5
FFF35890  ba0c                              movu.w  24h+var_12[sp], r4
FFF35892  a90b                              mov.l   24h+var_10[sp], r3
FFF35894  a982                              mov.l   24h+var_C[sp], r2
FFF35896  aa01                              mov.l   24h+var_4[sp], r1
FFF35898  6040                              sub     #4, sp
FFF3589A  e305                              mov.l   r5, 28h+var_28[sp]
FFF3589C  3962fc                            bsr.w   sub_FFF354FE
FFF3589F  6240                              add     #4, sp
FFF358A1  a009                              mov.l   r1, 24h+var_20[sp]
FFF358A3  2e76                              bra.b   loc_FFF35919
FFF358A5  aa01                   loc_FFF358A5 mov.l   24h+var_4[sp], r1
FFF358A7  f51658                            btst    #6, 58h[r1].b
FFF358AA  15                                beq.s   loc_FFF358AF
FFF358AB  f80600                            mov.l   #0, 24h+var_24[sp]
FFF358AE  0c                                bra.s   loc_FFF358B2
FFF358AF  f80601                 loc_FFF358AF mov.l   #1, 24h+var_24[sp]
FFF358B2  ec01                   loc_FFF358B2 mov.l   24h+var_24[sp], r1
FFF358B4  6101                              cmp     #0, r1
FFF358B6  17                                beq.s   loc_FFF358BD
FFF358B7  f90601fa                          mov.l   #-6, 24h+var_20[sp]
FFF358BB  2e5e                              bra.b   loc_FFF35919
FFF358BD  a88d                   loc_FFF358BD mov.l   24h+var_18[sp], r5
FFF358BF  ba0c                              movu.w  24h+var_12[sp], r4
FFF358C1  a90b                              mov.l   24h+var_10[sp], r3
FFF358C3  a982                              mov.l   24h+var_C[sp], r2
FFF358C5  aa01                              mov.l   24h+var_4[sp], r1
FFF358C7  6040                              sub     #4, sp
FFF358C9  e305                              mov.l   r5, 28h+var_28[sp]
FFF358CB  39a0fc                            bsr.w   sub_FFF3556B
FFF358CE  6240                              add     #4, sp
FFF358D0  a009                              mov.l   r1, 24h+var_20[sp]
FFF358D2  2e47                              bra.b   loc_FFF35919
FFF358D4  aa01                   loc_FFF358D4 mov.l   24h+var_4[sp], r1
FFF358D6  f51658                            btst    #6, 58h[r1].b
FFF358D9  15                                beq.s   loc_FFF358DE
FFF358DA  f80600                            mov.l   #0, 24h+var_24[sp]
FFF358DD  0c                                bra.s   loc_FFF358E1
FFF358DE  f80601                 loc_FFF358DE mov.l   #1, 24h+var_24[sp]
FFF358E1  ec01                   loc_FFF358E1 mov.l   24h+var_24[sp], r1
FFF358E3  6101                              cmp     #0, r1
FFF358E5  17                                beq.s   loc_FFF358EC
FFF358E6  f90601fa                          mov.l   #-6, 24h+var_20[sp]
FFF358EA  2e2f                              bra.b   loc_FFF35919
FFF358EC  a88a                   loc_FFF358EC mov.l   24h+var_18[sp], r2
FFF358EE  aa01                              mov.l   24h+var_4[sp], r1
FFF358F0  3993fd                            bsr.w   sub_FFF35683
FFF358F3  a009                              mov.l   r1, 24h+var_20[sp]
FFF358F5  2e24                              bra.b   loc_FFF35919
FFF358F7  a88a                   loc_FFF358F7 mov.l   24h+var_18[sp], r2
FFF358F9  aa01                              mov.l   24h+var_4[sp], r1
FFF358FB  39eafe                            bsr.w   sub_FFF357E5
FFF358FE  a009                              mov.l   r1, 24h+var_20[sp]
FFF35900  2e19                              bra.b   loc_FFF35919
FFF35902  a88a                   loc_FFF35902 mov.l   24h+var_18[sp], r2
FFF35904  aa01                              mov.l   24h+var_4[sp], r1
FFF35906  39fffe                            bsr.w   sub_FFF35805
FFF35909  a009                              mov.l   r1, 24h+var_20[sp]
FFF3590B  2e0e                              bra.b   loc_FFF35919
FFF3590D  a889                   loc_FFF3590D mov.l   24h+var_18[sp], r1
FFF3590F  39e1fb                            bsr.w   sub_FFF354F0
FFF35912  a009                              mov.l   r1, 24h+var_20[sp]
FFF35914  0d                                bra.s   loc_FFF35919
FFF35915  f90601fd               loc_FFF35915 mov.l   #-3, 24h+var_20[sp]
FFF35919  a809                   loc_FFF35919 mov.l   24h+var_20[sp], r1
FFF3591B  a081                              mov.l   r1, 24h+var_1C[sp]
FFF3591D  6709                              rtsd    #9
FFF3591F  6040                   sub_FFF3591F sub     #4, sp   ; <<<< FUNC sub_FFF3591F
FFF35921  e301                              mov.l   r1, 4+var_4[sp]
FFF35923  ed1ebd                            mov.l   2F4h[r1], r14
FFF35926  610e                              cmp     #0, r14
FFF35928  200e                              beq.b   loc_FFF35936
FFF3592A  ec01                              mov.l   4+var_4[sp], r1
FFF3592C  ed1ebd                            mov.l   2F4h[r1], r14
FFF3592F  601e                              sub     #1, r14
FFF35931  e71ebd                            mov.l   r14, 2F4h[r1]
FFF35934  6701                              rtsd    #1
FFF35936  6701                   loc_FFF35936 rtsd    #1
FFF35938  6080                   sub_FFF35938 sub     #8, sp   ; <<<< FUNC sub_FFF35938
FFF3593A  a009                              mov.l   r1, 8+var_4[sp]
FFF3593C  e302                              mov.l   r2, 8+var_8[sp]
FFF3593E  a809                              mov.l   8+var_4[sp], r1
FFF35940  e721bd                            mov.l   r1, 2F4h[r2]
FFF35943  e721be                            mov.l   r1, 2F8h[r2]
FFF35946  6702                              rtsd    #2
FFF35948  7100dc                 sub_FFF35948 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF35948
FFF3594B  a201                              mov.l   r1, 24h+var_4[sp]
FFF3594D  3e0600                            mov.l   #0, 24h+var_C[sp]
FFF35950  aa01                              mov.l   24h+var_4[sp], r1
FFF35952  ec11                              mov.l   [r1], r1
FFF35954  7211c802                          add     #2C8h, r1, r1
FFF35958  a081                              mov.l   r1, 24h+var_1C[sp]
FFF3595A  aa01                              mov.l   24h+var_4[sp], r1
FFF3595C  ec11                              mov.l   [r1], r1
FFF3595E  6211                              add     #1, r1
FFF35960  fb3a0002                          mov.l   #200h, r3
FFF35964  6602                              mov.l   #0, r2
FFF35966  ef24                              mov.l   r2, r4
FFF35968  05478bff                          bsr.a   sub_FFF2E4AF
FFF3596C  a881                              mov.l   24h+var_1C[sp], r1
FFF3596E  8d11                              mov.b   14h[r1], r1
FFF35970  61c1                              cmp     #0Ch, r1
FFF35972  11                                beq.s   loc_FFF3597B
FFF35973  a881                              mov.l   24h+var_1C[sp], r1
FFF35975  8d11                              mov.b   14h[r1], r1
FFF35977  755110                            cmp     #10h, r1
FFF3597A  1d                                bne.s   loc_FFF3597F
FFF3597B  f80601                 loc_FFF3597B mov.l   #1, 24h+var_24[sp]
FFF3597E  0c                                bra.s   loc_FFF35982
FFF3597F  f80600                 loc_FFF3597F mov.l   #0, 24h+var_24[sp]
FFF35982  ec01                   loc_FFF35982 mov.l   24h+var_24[sp], r1
FFF35984  6101                              cmp     #0, r1
FFF35986  2017                              beq.b   loc_FFF3599D
FFF35988  3e0320                            mov.l   #20h, 24h+var_18[sp] ; ' '
FFF3598B  a881                              mov.l   24h+var_1C[sp], r1
FFF3598D  a892                              mov.l   8[r1], r2
FFF3598F  06c9120e                          add     1Ch[r1].uw, r2
FFF35993  a991                              mov.l   18h[r1], r1
FFF35995  6c11                              shll    #1, r1
FFF35997  4b12                              add     r1, r2
FFF35999  a102                              mov.l   r2, 24h+var_14[sp]
FFF3599B  2e28                              bra.b   loc_FFF359C3
FFF3599D  a881                   loc_FFF3599D mov.l   24h+var_1C[sp], r1
FFF3599F  8d11                              mov.b   14h[r1], r1
FFF359A1  755120                            cmp     #20h, r1 ; ' '
FFF359A4  2119                              bne.b   loc_FFF359BD
FFF359A6  a881                              mov.l   24h+var_1C[sp], r1
FFF359A8  ba11                              movu.w  10h[r1], r1
FFF359AA  a089                              mov.l   r1, 24h+var_18[sp]
FFF359AC  a881                              mov.l   24h+var_1C[sp], r1
FFF359AE  a892                              mov.l   8[r1], r2
FFF359B0  06c9120e                          add     1Ch[r1].uw, r2
FFF359B4  a991                              mov.l   18h[r1], r1
FFF359B6  6c11                              shll    #1, r1
FFF359B8  4b12                              add     r1, r2
FFF359BA  a102                              mov.l   r2, 24h+var_14[sp]
FFF359BC  0f                                bra.s   loc_FFF359C3
FFF359BD  f90601fe               loc_FFF359BD mov.l   #-2, 24h+var_20[sp]
FFF359C1  2e41                              bra.b   loc_FFF35A02
FFF359C3  3e0500                 loc_FFF359C3 mov.l   #0, 24h+var_10[sp]
FFF359C6  2e30                              bra.b   loc_FFF359F6
FFF359C8  aa04                   loc_FFF359C8 mov.l   24h+var_4[sp], r4
FFF359CA  ec42                              mov.l   [r4], r2
FFF359CC  a901                              mov.l   24h+var_14[sp], r1
FFF359CE  6212                              add     #1, r2
FFF359D0  6613                              mov.l   #1, r3
FFF359D2  0582faff                          bsr.a   sub_FFF35454
FFF359D6  a181                              mov.l   r1, 24h+var_C[sp]
FFF359D8  a981                              mov.l   24h+var_C[sp], r1
FFF359DA  6101                              cmp     #0, r1
FFF359DC  17                                beq.s   loc_FFF359E3
FFF359DD  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF359E1  2e21                              bra.b   loc_FFF35A02
FFF359E3  aa01                   loc_FFF359E3 mov.l   24h+var_4[sp], r1
FFF359E5  ec11                              mov.l   [r1], r1
FFF359E7  3938ff                            bsr.w   sub_FFF3591F
FFF359EA  a909                              mov.l   24h+var_10[sp], r1
FFF359EC  6211                              add     #1, r1
FFF359EE  a109                              mov.l   r1, 24h+var_10[sp]
FFF359F0  a901                              mov.l   24h+var_14[sp], r1
FFF359F2  6211                              add     #1, r1
FFF359F4  a101                              mov.l   r1, 24h+var_14[sp]
FFF359F6  a909                   loc_FFF359F6 mov.l   24h+var_10[sp], r1
FFF359F8  06850103                          cmp     24h+var_18[sp].l, r1
FFF359FC  23cc                              bltu.b  loc_FFF359C8
FFF359FE  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF35A02  a809                   loc_FFF35A02 mov.l   24h+var_20[sp], r1
FFF35A04  a189                              mov.l   r1, 24h+var_8[sp]
FFF35A06  6709                              rtsd    #9
FFF35A08  7100dc                 sub_FFF35A08 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF35A08
FFF35A0B  a201                              mov.l   r1, 24h+var_4[sp]
FFF35A0D  3e0600                            mov.l   #0, 24h+var_C[sp]
FFF35A10  3e0300                            mov.l   #0, 24h+var_18[sp]
FFF35A13  3e0200                            mov.l   #0, 24h+var_1C[sp]
FFF35A16  aa01                              mov.l   24h+var_4[sp], r1
FFF35A18  ec11                              mov.l   [r1], r1
FFF35A1A  7211c802                          add     #2C8h, r1, r1
FFF35A1E  a009                              mov.l   r1, 24h+var_20[sp]
FFF35A20  aa01                              mov.l   24h+var_4[sp], r1
FFF35A22  ec11                              mov.l   [r1], r1
FFF35A24  6211                              add     #1, r1
FFF35A26  fb3a0002                          mov.l   #200h, r3
FFF35A2A  6602                              mov.l   #0, r2
FFF35A2C  ef24                              mov.l   r2, r4
FFF35A2E  05818aff                          bsr.a   sub_FFF2E4AF
FFF35A32  a809                              mov.l   24h+var_20[sp], r1
FFF35A34  8d11                              mov.b   14h[r1], r1
FFF35A36  61c1                              cmp     #0Ch, r1
FFF35A38  2116                              bne.b   loc_FFF35A4E
FFF35A3A  aa01                              mov.l   24h+var_4[sp], r1
FFF35A3C  ec11                              mov.l   [r1], r1
FFF35A3E  6211                              add     #1, r1
FFF35A40  6633                              mov.l   #3, r3
FFF35A42  fb224be9c3ff                      mov.l   #unk_FFC3E94B, r2
FFF35A48  05308aff                          bsr.a   sub_FFF2E478
FFF35A4C  2e41                              bra.b   loc_FFF35A8D
FFF35A4E  a809                   loc_FFF35A4E mov.l   24h+var_20[sp], r1
FFF35A50  8d11                              mov.b   14h[r1], r1
FFF35A52  755110                            cmp     #10h, r1
FFF35A55  2116                              bne.b   loc_FFF35A6B
FFF35A57  aa01                              mov.l   24h+var_4[sp], r1
FFF35A59  ec11                              mov.l   [r1], r1
FFF35A5B  6211                              add     #1, r1
FFF35A5D  6643                              mov.l   #4, r3
FFF35A5F  fb2247e9c3ff                      mov.l   #off_FFC3E947, r2
FFF35A65  05138aff                          bsr.a   sub_FFF2E478
FFF35A69  2e24                              bra.b   loc_FFF35A8D
FFF35A6B  a809                   loc_FFF35A6B mov.l   24h+var_20[sp], r1
FFF35A6D  8d11                              mov.b   14h[r1], r1
FFF35A6F  755120                            cmp     #20h, r1 ; ' '
FFF35A72  2115                              bne.b   loc_FFF35A87
FFF35A74  aa01                              mov.l   24h+var_4[sp], r1
FFF35A76  ec11                              mov.l   [r1], r1
FFF35A78  6211                              add     #1, r1
FFF35A7A  66c3                              mov.l   #0Ch, r3
FFF35A7C  fb223be9c3ff                      mov.l   #unk_FFC3E93B, r2
FFF35A82  05f689ff                          bsr.a   sub_FFF2E478
FFF35A86  0f                                bra.s   loc_FFF35A8D
FFF35A87  f806fe                 loc_FFF35A87 mov.l   #-2, 24h+var_24[sp]
FFF35A8A  38ed00                            bra.w   loc_FFF35B77
FFF35A8D  a809                   loc_FFF35A8D mov.l   24h+var_20[sp], r1
FFF35A8F  a892                              mov.l   8[r1], r2
FFF35A91  06c9120e                          add     1Ch[r1].uw, r2
FFF35A95  a08a                              mov.l   r2, 24h+var_18[sp]
FFF35A97  aa04                              mov.l   24h+var_4[sp], r4
FFF35A99  ec42                              mov.l   [r4], r2
FFF35A9B  a889                              mov.l   24h+var_18[sp], r1
FFF35A9D  6212                              add     #1, r2
FFF35A9F  6613                              mov.l   #1, r3
FFF35AA1  05b3f9ff                          bsr.a   sub_FFF35454
FFF35AA5  a181                              mov.l   r1, 24h+var_C[sp]
FFF35AA7  a981                              mov.l   24h+var_C[sp], r1
FFF35AA9  6101                              cmp     #0, r1
FFF35AAB  17                                beq.s   loc_FFF35AB2
FFF35AAC  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35AAF  38c800                            bra.w   loc_FFF35B77
FFF35AB2  a809                   loc_FFF35AB2 mov.l   24h+var_20[sp], r1
FFF35AB4  8d11                              mov.b   14h[r1], r1
FFF35AB6  755140                            cmp     #40h, r1 ; '@'
FFF35AB9  202b                              beq.b   loc_FFF35AE4
FFF35ABB  a809                              mov.l   24h+var_20[sp], r1
FFF35ABD  a892                              mov.l   8[r1], r2
FFF35ABF  06c9120e                          add     1Ch[r1].uw, r2
FFF35AC3  06891206                          add     18h[r1].l, r2
FFF35AC7  a082                              mov.l   r2, 24h+var_1C[sp]
FFF35AC9  aa04                              mov.l   24h+var_4[sp], r4
FFF35ACB  ec42                              mov.l   [r4], r2
FFF35ACD  a881                              mov.l   24h+var_1C[sp], r1
FFF35ACF  6212                              add     #1, r2
FFF35AD1  6613                              mov.l   #1, r3
FFF35AD3  0581f9ff                          bsr.a   sub_FFF35454
FFF35AD7  a181                              mov.l   r1, 24h+var_C[sp]
FFF35AD9  a981                              mov.l   24h+var_C[sp], r1
FFF35ADB  6101                              cmp     #0, r1
FFF35ADD  17                                beq.s   loc_FFF35AE4
FFF35ADE  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35AE1  389600                            bra.w   loc_FFF35B77
FFF35AE4  aa01                   loc_FFF35AE4 mov.l   24h+var_4[sp], r1
FFF35AE6  ec11                              mov.l   [r1], r1
FFF35AE8  3937fe                            bsr.w   sub_FFF3591F
FFF35AEB  aa01                              mov.l   24h+var_4[sp], r1
FFF35AED  ec11                              mov.l   [r1], r1
FFF35AEF  6211                              add     #1, r1
FFF35AF1  fb3a0002                          mov.l   #200h, r3
FFF35AF5  6602                              mov.l   #0, r2
FFF35AF7  ef24                              mov.l   r2, r4
FFF35AF9  05b689ff                          bsr.a   sub_FFF2E4AF
FFF35AFD  a809                              mov.l   24h+var_20[sp], r1
FFF35AFF  a991                              mov.l   18h[r1], r1
FFF35B01  6011                              sub     #1, r1
FFF35B03  a101                              mov.l   r1, 24h+var_14[sp]
FFF35B05  a809                              mov.l   24h+var_20[sp], r1
FFF35B07  8d11                              mov.b   14h[r1], r1
FFF35B09  755140                            cmp     #40h, r1 ; '@'
FFF35B0C  2068                              beq.b   loc_FFF35B74
FFF35B0E  a889                              mov.l   24h+var_18[sp], r1
FFF35B10  6211                              add     #1, r1
FFF35B12  a089                              mov.l   r1, 24h+var_18[sp]
FFF35B14  a881                              mov.l   24h+var_1C[sp], r1
FFF35B16  6211                              add     #1, r1
FFF35B18  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35B1A  3e0500                            mov.l   #0, 24h+var_10[sp]
FFF35B1D  2e4f                              bra.b   loc_FFF35B6C
FFF35B1F  aa04                   loc_FFF35B1F mov.l   24h+var_4[sp], r4
FFF35B21  ec42                              mov.l   [r4], r2
FFF35B23  a889                              mov.l   24h+var_18[sp], r1
FFF35B25  6212                              add     #1, r2
FFF35B27  6613                              mov.l   #1, r3
FFF35B29  052bf9ff                          bsr.a   sub_FFF35454
FFF35B2D  a181                              mov.l   r1, 24h+var_C[sp]
FFF35B2F  a981                              mov.l   24h+var_C[sp], r1
FFF35B31  6101                              cmp     #0, r1
FFF35B33  16                                beq.s   loc_FFF35B39
FFF35B34  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35B37  2e40                              bra.b   loc_FFF35B77
FFF35B39  aa04                   loc_FFF35B39 mov.l   24h+var_4[sp], r4
FFF35B3B  ec42                              mov.l   [r4], r2
FFF35B3D  a881                              mov.l   24h+var_1C[sp], r1
FFF35B3F  6212                              add     #1, r2
FFF35B41  6613                              mov.l   #1, r3
FFF35B43  0511f9ff                          bsr.a   sub_FFF35454
FFF35B47  a181                              mov.l   r1, 24h+var_C[sp]
FFF35B49  a981                              mov.l   24h+var_C[sp], r1
FFF35B4B  6101                              cmp     #0, r1
FFF35B4D  16                                beq.s   loc_FFF35B53
FFF35B4E  e10006                            mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35B51  2e26                              bra.b   loc_FFF35B77
FFF35B53  aa01                   loc_FFF35B53 mov.l   24h+var_4[sp], r1
FFF35B55  ec11                              mov.l   [r1], r1
FFF35B57  39c8fd                            bsr.w   sub_FFF3591F
FFF35B5A  a909                              mov.l   24h+var_10[sp], r1
FFF35B5C  6211                              add     #1, r1
FFF35B5E  a109                              mov.l   r1, 24h+var_10[sp]
FFF35B60  a889                              mov.l   24h+var_18[sp], r1
FFF35B62  6211                              add     #1, r1
FFF35B64  a089                              mov.l   r1, 24h+var_18[sp]
FFF35B66  a881                              mov.l   24h+var_1C[sp], r1
FFF35B68  6211                              add     #1, r1
FFF35B6A  a081                              mov.l   r1, 24h+var_1C[sp]
FFF35B6C  a909                   loc_FFF35B6C mov.l   24h+var_10[sp], r1
FFF35B6E  06850104                          cmp     24h+var_14[sp].l, r1
FFF35B72  23ad                              bltu.b  loc_FFF35B1F
FFF35B74  e10006                 loc_FFF35B74 mov.l   24h+var_C[sp], 24h+var_24[sp]
FFF35B77  ec01                   loc_FFF35B77 mov.l   24h+var_24[sp], r1
FFF35B79  a189                              mov.l   r1, 24h+var_8[sp]
FFF35B7B  6709                              rtsd    #9
FFF35B7D  7100e8                 sub_FFF35B7D add     #-18h, sp, sp   ; <<<< FUNC sub_FFF35B7D
FFF35B80  a109                              mov.l   r1, 18h+var_4[sp]
FFF35B82  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF35B85  a909                              mov.l   18h+var_4[sp], r1
FFF35B87  ec11                              mov.l   [r1], r1
FFF35B89  7211c802                          add     #2C8h, r1, r1
FFF35B8D  a009                              mov.l   r1, 18h+var_14[sp]
FFF35B8F  a909                              mov.l   18h+var_4[sp], r1
FFF35B91  ec11                              mov.l   [r1], r1
FFF35B93  6211                              add     #1, r1
FFF35B95  fb3a0002                          mov.l   #200h, r3
FFF35B99  6602                              mov.l   #0, r2
FFF35B9B  ef24                              mov.l   r2, r4
FFF35B9D  051289ff                          bsr.a   sub_FFF2E4AF
FFF35BA1  fbe240950600                      mov.l   #69540h, r14
FFF35BA7  ece2                              mov.l   [r14], r2
FFF35BA9  a909                              mov.l   18h+var_4[sp], r1
FFF35BAB  ec11                              mov.l   [r1], r1
FFF35BAD  6211                              add     #1, r1
FFF35BAF  6643                              mov.l   #4, r3
FFF35BB1  05c788ff                          bsr.a   sub_FFF2E478
FFF35BB5  fb1240950600                      mov.l   #69540h, r1
FFF35BBB  a81a                              mov.l   4[r1], r2
FFF35BBD  a909                              mov.l   18h+var_4[sp], r1
FFF35BBF  ec11                              mov.l   [r1], r1
FFF35BC1  7211e501                          add     #1E5h, r1, r1
FFF35BC5  6643                              mov.l   #4, r3
FFF35BC7  05b188ff                          bsr.a   sub_FFF2E478
FFF35BCB  a909                              mov.l   18h+var_4[sp], r1
FFF35BCD  ec11                              mov.l   [r1], r1
FFF35BCF  7211e901                          add     #1E9h, r1, r1
FFF35BD3  fb26ff                            mov.l   #-1, r2
FFF35BD6  05fd90ff                          bsr.a   sub_FFF2ECD3
FFF35BDA  a909                              mov.l   18h+var_4[sp], r1
FFF35BDC  ec11                              mov.l   [r1], r1
FFF35BDE  7211ed01                          add     #1EDh, r1, r1
FFF35BE2  fb26ff                            mov.l   #-1, r2
FFF35BE5  05ee90ff                          bsr.a   sub_FFF2ECD3
FFF35BE9  a909                              mov.l   18h+var_4[sp], r1
FFF35BEB  ec1e                              mov.l   [r1], r14
FFF35BED  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF35BF2  a909                              mov.l   18h+var_4[sp], r1
FFF35BF4  ec1e                              mov.l   [r1], r14
FFF35BF6  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF35BFB  a809                              mov.l   18h+var_14[sp], r1
FFF35BFD  a891                              mov.l   8[r1], r1
FFF35BFF  6211                              add     #1, r1
FFF35C01  a081                              mov.l   r1, 18h+var_10[sp]
FFF35C03  a90c                              mov.l   18h+var_4[sp], r4
FFF35C05  ec42                              mov.l   [r4], r2
FFF35C07  a881                              mov.l   18h+var_10[sp], r1
FFF35C09  6212                              add     #1, r2
FFF35C0B  6613                              mov.l   #1, r3
FFF35C0D  0547f8ff                          bsr.a   sub_FFF35454
FFF35C11  a089                              mov.l   r1, 18h+var_C[sp]
FFF35C13  a889                              mov.l   18h+var_C[sp], r1
FFF35C15  6101                              cmp     #0, r1
FFF35C17  17                                beq.s   loc_FFF35C1E
FFF35C18  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35C1B  388200                            bra.w   loc_FFF35C9D
FFF35C1E  a881                   loc_FFF35C1E mov.l   18h+var_10[sp], r1
FFF35C20  6261                              add     #6, r1
FFF35C22  a081                              mov.l   r1, 18h+var_10[sp]
FFF35C24  a90c                              mov.l   18h+var_4[sp], r4
FFF35C26  ec42                              mov.l   [r4], r2
FFF35C28  a881                              mov.l   18h+var_10[sp], r1
FFF35C2A  6212                              add     #1, r2
FFF35C2C  6613                              mov.l   #1, r3
FFF35C2E  0526f8ff                          bsr.a   sub_FFF35454
FFF35C32  a089                              mov.l   r1, 18h+var_C[sp]
FFF35C34  a889                              mov.l   18h+var_C[sp], r1
FFF35C36  6101                              cmp     #0, r1
FFF35C38  16                                beq.s   loc_FFF35C3E
FFF35C39  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35C3C  2e61                              bra.b   loc_FFF35C9D
FFF35C3E  a909                   loc_FFF35C3E mov.l   18h+var_4[sp], r1
FFF35C40  ec11                              mov.l   [r1], r1
FFF35C42  6211                              add     #1, r1
FFF35C44  fb3a0002                          mov.l   #200h, r3
FFF35C48  6602                              mov.l   #0, r2
FFF35C4A  ef24                              mov.l   r2, r4
FFF35C4C  056388ff                          bsr.a   sub_FFF2E4AF
FFF35C50  a909                              mov.l   18h+var_4[sp], r1
FFF35C52  ec1e                              mov.l   [r1], r14
FFF35C54  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF35C59  a909                              mov.l   18h+var_4[sp], r1
FFF35C5B  ec1e                              mov.l   [r1], r14
FFF35C5D  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF35C62  a809                              mov.l   18h+var_14[sp], r1
FFF35C64  a891                              mov.l   8[r1], r1
FFF35C66  6221                              add     #2, r1
FFF35C68  a081                              mov.l   r1, 18h+var_10[sp]
FFF35C6A  a90c                              mov.l   18h+var_4[sp], r4
FFF35C6C  ec42                              mov.l   [r4], r2
FFF35C6E  a881                              mov.l   18h+var_10[sp], r1
FFF35C70  6212                              add     #1, r2
FFF35C72  6613                              mov.l   #1, r3
FFF35C74  05e0f7ff                          bsr.a   sub_FFF35454
FFF35C78  a089                              mov.l   r1, 18h+var_C[sp]
FFF35C7A  a889                              mov.l   18h+var_C[sp], r1
FFF35C7C  6101                              cmp     #0, r1
FFF35C7E  16                                beq.s   loc_FFF35C84
FFF35C7F  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35C82  2e1b                              bra.b   loc_FFF35C9D
FFF35C84  a881                   loc_FFF35C84 mov.l   18h+var_10[sp], r1
FFF35C86  6261                              add     #6, r1
FFF35C88  a081                              mov.l   r1, 18h+var_10[sp]
FFF35C8A  a90c                              mov.l   18h+var_4[sp], r4
FFF35C8C  ec42                              mov.l   [r4], r2
FFF35C8E  a881                              mov.l   18h+var_10[sp], r1
FFF35C90  6212                              add     #1, r2
FFF35C92  6613                              mov.l   #1, r3
FFF35C94  05c0f7ff                          bsr.a   sub_FFF35454
FFF35C98  a089                              mov.l   r1, 18h+var_C[sp]
FFF35C9A  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35C9D  ec01                   loc_FFF35C9D mov.l   18h+var_18[sp], r1
FFF35C9F  a101                              mov.l   r1, 18h+var_8[sp]
FFF35CA1  6706                              rtsd    #6
FFF35CA3  7100cc                 sub_FFF35CA3 add     #-34h, sp, sp   ; <<<< FUNC sub_FFF35CA3
FFF35CA6  3e0200                            mov.l   #0, 34h+var_2C[sp]
FFF35CA9  71010c                            add     #34h+var_28, sp, r1
FFF35CAC  051702fe                          bsr.a   sub_FFF15EC3
FFF35CB0  a989                              mov.l   34h+var_18[sp], r1
FFF35CB2  6211                              add     #1, r1
FFF35CB4  9089                              mov.w   r1, 34h+var_2E[sp]
FFF35CB6  9889                              mov.w   34h+var_2E[sp], r1
FFF35CB8  6c81                              shll    #8, r1
FFF35CBA  9089                              mov.w   r1, 34h+var_2E[sp]
FFF35CBC  9889                              mov.w   34h+var_2E[sp], r1
FFF35CBE  0655010c                          or      34h+var_1C[sp].w, r1
FFF35CC2  9089                              mov.w   r1, 34h+var_2E[sp]
FFF35CC4  a889                              mov.l   34h+var_28[sp], r1
FFF35CC6  9081                              mov.w   r1, 34h+var_30[sp]
FFF35CC8  9881                              mov.w   34h+var_30[sp], r1
FFF35CCA  6c81                              shll    #8, r1
FFF35CCC  9081                              mov.w   r1, 34h+var_30[sp]
FFF35CCE  b889                              movu.w  34h+var_2E[sp], r1
FFF35CD0  06c90102                          add     34h+var_30[sp].uw, r1
FFF35CD4  a081                              mov.l   r1, 34h+var_2C[sp]
FFF35CD6  a881                              mov.l   34h+var_2C[sp], r1
FFF35CD8  6d01                              shll    #10h, r1
FFF35CDA  a081                              mov.l   r1, 34h+var_2C[sp]
FFF35CDC  a909                              mov.l   34h+var_20[sp], r1
FFF35CDE  9009                              mov.w   r1, 34h+var_32[sp]
FFF35CE0  9809                              mov.w   34h+var_32[sp], r1
FFF35CE2  6c81                              shll    #8, r1
FFF35CE4  9009                              mov.w   r1, 34h+var_32[sp]
FFF35CE6  9809                              mov.w   34h+var_32[sp], r1
FFF35CE8  06550108                          or      34h+var_24[sp].w, r1
FFF35CEC  9009                              mov.w   r1, 34h+var_32[sp]
FFF35CEE  aa01                              mov.l   34h+var_14[sp], r1
FFF35CF0  72116c07                          add     #76Ch, r1, r1
FFF35CF4  d301                              mov.w   r1, 34h+var_34[sp]
FFF35CF6  9809                              mov.w   34h+var_32[sp], r1
FFF35CF8  065401                            or      [sp].w, r1
FFF35CFB  9009                              mov.w   r1, 34h+var_32[sp]
FFF35CFD  a881                              mov.l   34h+var_2C[sp], r1
FFF35CFF  06d50101                          or      34h+var_32[sp].uw, r1
FFF35D03  a081                              mov.l   r1, 34h+var_2C[sp]
FFF35D05  a881                              mov.l   34h+var_2C[sp], r1
FFF35D07  a301                              mov.l   r1, 34h+var_4[sp]
FFF35D09  670d                              rtsd    #0Dh
FFF35D0B  7ea6                   sub_FFF35D0B push.l  r6   ; <<<< FUNC sub_FFF35D0B
FFF35D0D  7100e8                            add     #-18h, sp, sp
FFF35D10  a109                              mov.l   r1, 18h+var_4[sp]
FFF35D12  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF35D15  a909                              mov.l   18h+var_4[sp], r1
FFF35D17  ec11                              mov.l   [r1], r1
FFF35D19  7211c802                          add     #2C8h, r1, r1
FFF35D1D  a009                              mov.l   r1, 18h+var_14[sp]
FFF35D1F  a909                              mov.l   18h+var_4[sp], r1
FFF35D21  ec11                              mov.l   [r1], r1
FFF35D23  6211                              add     #1, r1
FFF35D25  fb3a0002                          mov.l   #200h, r3
FFF35D29  6602                              mov.l   #0, r2
FFF35D2B  ef24                              mov.l   r2, r4
FFF35D2D  058287ff                          bsr.a   sub_FFF2E4AF
FFF35D31  a909                              mov.l   18h+var_4[sp], r1
FFF35D33  ec11                              mov.l   [r1], r1
FFF35D35  6211                              add     #1, r1
FFF35D37  a80a                              mov.l   18h+var_14[sp], r2
FFF35D39  8d22                              mov.b   14h[r2], r2
FFF35D3B  755220                            cmp     #20h, r2 ; ' '
FFF35D3E  3af100                            beq.w   loc_FFF35E2F
FFF35D41  75433e                            mov.l   #3Eh, r3 ; '>'
FFF35D44  fb22a3e8c3ff                      mov.l   #unk_FFC3E8A3, r2
FFF35D4A  052e87ff                          bsr.a   sub_FFF2E478
FFF35D4E  a809                              mov.l   18h+var_14[sp], r1
FFF35D50  ba1a                              movu.w  12h[r1], r2
FFF35D52  a909                              mov.l   18h+var_4[sp], r1
FFF35D54  ec11                              mov.l   [r1], r1
FFF35D56  62c1                              add     #0Ch, r1
FFF35D58  05298fff                          bsr.a   sub_FFF2EC81
FFF35D5C  a809                              mov.l   18h+var_14[sp], r1
FFF35D5E  a90a                              mov.l   18h+var_4[sp], r2
FFF35D60  ec2e                              mov.l   [r2], r14
FFF35D62  c51e100e                          mov.b   10h[r1], 0Eh[r14]
FFF35D66  a809                              mov.l   18h+var_14[sp], r1
FFF35D68  bb92                              movu.w  1Ch[r1], r2
FFF35D6A  a909                              mov.l   18h+var_4[sp], r1
FFF35D6C  ec11                              mov.l   [r1], r1
FFF35D6E  62f1                              add     #0Fh, r1
FFF35D70  05118fff                          bsr.a   sub_FFF2EC81
FFF35D74  a809                              mov.l   18h+var_14[sp], r1
FFF35D76  bb12                              movu.w  18h[r1], r2
FFF35D78  a909                              mov.l   18h+var_4[sp], r1
FFF35D7A  ec11                              mov.l   [r1], r1
FFF35D7C  711117                            add     #17h, r1, r1
FFF35D7F  05028fff                          bsr.a   sub_FFF2EC81
FFF35D83  a809                              mov.l   18h+var_14[sp], r1
FFF35D85  5c12                              movu.w  [r1], r2
FFF35D87  a909                              mov.l   18h+var_4[sp], r1
FFF35D89  ec11                              mov.l   [r1], r1
FFF35D8B  711119                            add     #19h, r1, r1
FFF35D8E  05f38eff                          bsr.a   sub_FFF2EC81
FFF35D92  a809                              mov.l   18h+var_14[sp], r1
FFF35D94  b81a                              movu.w  2[r1], r2
FFF35D96  a909                              mov.l   18h+var_4[sp], r1
FFF35D98  ec11                              mov.l   [r1], r1
FFF35D9A  71111b                            add     #1Bh, r1, r1
FFF35D9D  05e48eff                          bsr.a   sub_FFF2EC81
FFF35DA1  a809                              mov.l   18h+var_14[sp], r1
FFF35DA3  a892                              mov.l   8[r1], r2
FFF35DA5  a909                              mov.l   18h+var_4[sp], r1
FFF35DA7  ec11                              mov.l   [r1], r1
FFF35DA9  71111d                            add     #1Dh, r1, r1
FFF35DAC  05278fff                          bsr.a   sub_FFF2ECD3
FFF35DB0  a909                              mov.l   18h+var_4[sp], r1
FFF35DB2  ec11                              mov.l   [r1], r1
FFF35DB4  6211                              add     #1, r1
FFF35DB6  a80a                              mov.l   18h+var_14[sp], r2
FFF35DB8  a8aa                              mov.l   0Ch[r2], r2
FFF35DBA  7702ffff00                        cmp     #0FFFFh, r2
FFF35DBF  240f                              bgtu.b  loc_FFF35DCE
FFF35DC1  a80a                              mov.l   18h+var_14[sp], r2
FFF35DC3  b9a2                              movu.w  0Ch[r2], r2
FFF35DC5  711113                            add     #13h, r1, r1
FFF35DC8  05b98eff                          bsr.a   sub_FFF2EC81
FFF35DCC  2e0d                              bra.b   loc_FFF35DD9
FFF35DCE  a80a                   loc_FFF35DCE mov.l   18h+var_14[sp], r2
FFF35DD0  a8aa                              mov.l   0Ch[r2], r2
FFF35DD2  711120                            add     #20h, r1, r1 ; ' '
FFF35DD5  05fe8eff                          bsr.a   sub_FFF2ECD3
FFF35DD9  a909                   loc_FFF35DD9 mov.l   18h+var_4[sp], r1
FFF35DDB  ec16                              mov.l   [r1], r6
FFF35DDD  39c6fe                            bsr.w   sub_FFF35CA3
FFF35DE0  ef12                              mov.l   r1, r2
FFF35DE2  ef61                              mov.l   r6, r1
FFF35DE4  711128                            add     #28h, r1, r1 ; '('
FFF35DE7  05ec8eff                          bsr.a   sub_FFF2ECD3
FFF35DEB  a809                              mov.l   18h+var_14[sp], r1
FFF35DED  8d11                              mov.b   14h[r1], r1
FFF35DEF  61c1                              cmp     #0Ch, r1
FFF35DF1  19                                bne.s   loc_FFF35DFA
FFF35DF2  a909                              mov.l   18h+var_4[sp], r1
FFF35DF4  ec1e                              mov.l   [r1], r14
FFF35DF6  f9e43b32                          mov.b   #32h, 3Bh[r14] ; '2'
FFF35DFA  a909                   loc_FFF35DFA mov.l   18h+var_4[sp], r1
FFF35DFC  ec1e                              mov.l   [r1], r14
FFF35DFE  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF35E03  a909                              mov.l   18h+var_4[sp], r1
FFF35E05  ec1e                              mov.l   [r1], r14
FFF35E07  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF35E0C  a809                              mov.l   18h+var_14[sp], r1
FFF35E0E  e5100202                          mov.l   8[r1], 18h+var_10[sp]
FFF35E12  a90c                              mov.l   18h+var_4[sp], r4
FFF35E14  ec42                              mov.l   [r4], r2
FFF35E16  a881                              mov.l   18h+var_10[sp], r1
FFF35E18  6212                              add     #1, r2
FFF35E1A  6613                              mov.l   #1, r3
FFF35E1C  0538f6ff                          bsr.a   sub_FFF35454
FFF35E20  a089                              mov.l   r1, 18h+var_C[sp]
FFF35E22  a889                              mov.l   18h+var_C[sp], r1
FFF35E24  6101                              cmp     #0, r1
FFF35E26  3aea00                            beq.w   loc_FFF35F10
FFF35E29  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35E2C  38e700                            bra.w   loc_FFF35F13
FFF35E2F  75435a                 loc_FFF35E2F mov.l   #5Ah, r3 ; 'Z'
FFF35E32  fb22e1e8c3ff                      mov.l   #unk_FFC3E8E1, r2
FFF35E38  054086ff                          bsr.a   sub_FFF2E478
FFF35E3C  a809                              mov.l   18h+var_14[sp], r1
FFF35E3E  ba1a                              movu.w  12h[r1], r2
FFF35E40  a909                              mov.l   18h+var_4[sp], r1
FFF35E42  ec11                              mov.l   [r1], r1
FFF35E44  62c1                              add     #0Ch, r1
FFF35E46  053b8eff                          bsr.a   sub_FFF2EC81
FFF35E4A  a809                              mov.l   18h+var_14[sp], r1
FFF35E4C  a90a                              mov.l   18h+var_4[sp], r2
FFF35E4E  ec2e                              mov.l   [r2], r14
FFF35E50  c51e100e                          mov.b   10h[r1], 0Eh[r14]
FFF35E54  a809                              mov.l   18h+var_14[sp], r1
FFF35E56  bb92                              movu.w  1Ch[r1], r2
FFF35E58  a909                              mov.l   18h+var_4[sp], r1
FFF35E5A  ec11                              mov.l   [r1], r1
FFF35E5C  62f1                              add     #0Fh, r1
FFF35E5E  05238eff                          bsr.a   sub_FFF2EC81
FFF35E62  a809                              mov.l   18h+var_14[sp], r1
FFF35E64  5c12                              movu.w  [r1], r2
FFF35E66  a909                              mov.l   18h+var_4[sp], r1
FFF35E68  ec11                              mov.l   [r1], r1
FFF35E6A  711119                            add     #19h, r1, r1
FFF35E6D  05148eff                          bsr.a   sub_FFF2EC81
FFF35E71  a809                              mov.l   18h+var_14[sp], r1
FFF35E73  b81a                              movu.w  2[r1], r2
FFF35E75  a909                              mov.l   18h+var_4[sp], r1
FFF35E77  ec11                              mov.l   [r1], r1
FFF35E79  71111b                            add     #1Bh, r1, r1
FFF35E7C  05058eff                          bsr.a   sub_FFF2EC81
FFF35E80  a809                              mov.l   18h+var_14[sp], r1
FFF35E82  a892                              mov.l   8[r1], r2
FFF35E84  a909                              mov.l   18h+var_4[sp], r1
FFF35E86  ec11                              mov.l   [r1], r1
FFF35E88  71111d                            add     #1Dh, r1, r1
FFF35E8B  05488eff                          bsr.a   sub_FFF2ECD3
FFF35E8F  a809                              mov.l   18h+var_14[sp], r1
FFF35E91  a89a                              mov.l   0Ch[r1], r2
FFF35E93  a909                              mov.l   18h+var_4[sp], r1
FFF35E95  ec11                              mov.l   [r1], r1
FFF35E97  711121                            add     #21h, r1, r1 ; '!'
FFF35E9A  05398eff                          bsr.a   sub_FFF2ECD3
FFF35E9E  a809                              mov.l   18h+var_14[sp], r1
FFF35EA0  a992                              mov.l   18h[r1], r2
FFF35EA2  a909                              mov.l   18h+var_4[sp], r1
FFF35EA4  ec11                              mov.l   [r1], r1
FFF35EA6  711125                            add     #25h, r1, r1 ; '%'
FFF35EA9  052a8eff                          bsr.a   sub_FFF2ECD3
FFF35EAD  a909                              mov.l   18h+var_4[sp], r1
FFF35EAF  ec16                              mov.l   [r1], r6
FFF35EB1  39f2fd                            bsr.w   sub_FFF35CA3
FFF35EB4  ef12                              mov.l   r1, r2
FFF35EB6  ef61                              mov.l   r6, r1
FFF35EB8  711144                            add     #44h, r1, r1 ; 'D'
FFF35EBB  05188eff                          bsr.a   sub_FFF2ECD3
FFF35EBF  a909                              mov.l   18h+var_4[sp], r1
FFF35EC1  ec1e                              mov.l   [r1], r14
FFF35EC3  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF35EC8  a909                              mov.l   18h+var_4[sp], r1
FFF35ECA  ec1e                              mov.l   [r1], r14
FFF35ECC  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF35ED1  a809                              mov.l   18h+var_14[sp], r1
FFF35ED3  e5100202                          mov.l   8[r1], 18h+var_10[sp]
FFF35ED7  a90c                              mov.l   18h+var_4[sp], r4
FFF35ED9  ec42                              mov.l   [r4], r2
FFF35EDB  a881                              mov.l   18h+var_10[sp], r1
FFF35EDD  6212                              add     #1, r2
FFF35EDF  6613                              mov.l   #1, r3
FFF35EE1  0573f5ff                          bsr.a   sub_FFF35454
FFF35EE5  a089                              mov.l   r1, 18h+var_C[sp]
FFF35EE7  a889                              mov.l   18h+var_C[sp], r1
FFF35EE9  6101                              cmp     #0, r1
FFF35EEB  16                                beq.s   loc_FFF35EF1
FFF35EEC  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35EEF  2e24                              bra.b   loc_FFF35F13
FFF35EF1  a881                   loc_FFF35EF1 mov.l   18h+var_10[sp], r1
FFF35EF3  6261                              add     #6, r1
FFF35EF5  a081                              mov.l   r1, 18h+var_10[sp]
FFF35EF7  a90c                              mov.l   18h+var_4[sp], r4
FFF35EF9  ec42                              mov.l   [r4], r2
FFF35EFB  a881                              mov.l   18h+var_10[sp], r1
FFF35EFD  6212                              add     #1, r2
FFF35EFF  6613                              mov.l   #1, r3
FFF35F01  0553f5ff                          bsr.a   sub_FFF35454
FFF35F05  a089                              mov.l   r1, 18h+var_C[sp]
FFF35F07  a889                              mov.l   18h+var_C[sp], r1
FFF35F09  6101                              cmp     #0, r1
FFF35F0B  15                                beq.s   loc_FFF35F10
FFF35F0C  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35F0F  0c                                bra.s   loc_FFF35F13
FFF35F10  e10003                 loc_FFF35F10 mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF35F13  ec01                   loc_FFF35F13 mov.l   18h+var_18[sp], r1
FFF35F15  a101                              mov.l   r1, 18h+var_8[sp]
FFF35F17  3f6607                            rtsd    #1Ch, r6-r6
FFF35F1A  7100f0                 sub_FFF35F1A add     #-10h, sp, sp   ; <<<< FUNC sub_FFF35F1A
FFF35F1D  a089                              mov.l   r1, 10h+var_4[sp]
FFF35F1F  a082                              mov.l   r2, 10h+var_8[sp]
FFF35F21  f82400                            mov.b   #0, [r2]
FFF35F24  a889                              mov.l   10h+var_4[sp], r1
FFF35F26  5c1e                              movu.w  [r1], r14
FFF35F28  610e                              cmp     #0, r14
FFF35F2A  10                                beq.s   loc_FFF35F32
FFF35F2B  a889                              mov.l   10h+var_4[sp], r1
FFF35F2D  b819                              movu.w  2[r1], r1
FFF35F2F  6101                              cmp     #0, r1
FFF35F31  1d                                bne.s   loc_FFF35F36
FFF35F32  f80601                 loc_FFF35F32 mov.l   #1, 10h+var_10[sp]
FFF35F35  0c                                bra.s   loc_FFF35F39
FFF35F36  f80600                 loc_FFF35F36 mov.l   #0, 10h+var_10[sp]
FFF35F39  ec01                   loc_FFF35F39 mov.l   10h+var_10[sp], r1
FFF35F3B  6101                              cmp     #0, r1
FFF35F3D  213c                              bne.b   loc_FFF35F79
FFF35F3F  a889                              mov.l   10h+var_4[sp], r1
FFF35F41  a891                              mov.l   8[r1], r1
FFF35F43  74010004fb00                      cmp     #0FB0400h, r1
FFF35F49  2309                              bltu.b  loc_FFF35F52
FFF35F4B  a881                              mov.l   10h+var_8[sp], r1
FFF35F4D  f814fe                            mov.b   #-2, [r1]
FFF35F50  6704                              rtsd    #4
FFF35F52  a889                   loc_FFF35F52 mov.l   10h+var_4[sp], r1
FFF35F54  5c1e                              movu.w  [r1], r14
FFF35F56  06cd1e01                          mul     2[r1].uw, r14
FFF35F5A  a891                              mov.l   8[r1], r1
FFF35F5C  ef1f                              mov.l   r1, r15
FFF35F5E  fc27ef                            divu    r14, r15
FFF35F61  4fef                              mul     r14, r15
FFF35F63  43f1                              sub     r15, r1
FFF35F65  a009                              mov.l   r1, 10h+var_C[sp]
FFF35F67  a809                              mov.l   10h+var_C[sp], r1
FFF35F69  a88a                              mov.l   10h+var_4[sp], r2
FFF35F6B  06e00921                          divu    [r2].uw, r1
FFF35F6F  a009                              mov.l   r1, 10h+var_C[sp]
FFF35F71  a809                              mov.l   10h+var_C[sp], r1
FFF35F73  a882                              mov.l   10h+var_8[sp], r2
FFF35F75  c321                              mov.b   r1, [r2]
FFF35F77  6704                              rtsd    #4
FFF35F79  6704                   loc_FFF35F79 rtsd    #4
FFF35F7B  7100ec                 sub_FFF35F7B add     #-14h, sp, sp   ; <<<< FUNC sub_FFF35F7B
FFF35F7E  a101                              mov.l   r1, 14h+var_4[sp]
FFF35F80  a08a                              mov.l   r2, 14h+var_8[sp]
FFF35F82  f82400                            mov.b   #0, [r2]
FFF35F85  a889                              mov.l   14h+var_8[sp], r1
FFF35F87  3c1100                            mov.b   #0, 1[r1]
FFF35F8A  a901                              mov.l   14h+var_4[sp], r1
FFF35F8C  5c1e                              movu.w  [r1], r14
FFF35F8E  610e                              cmp     #0, r14
FFF35F90  10                                beq.s   loc_FFF35F98
FFF35F91  a901                              mov.l   14h+var_4[sp], r1
FFF35F93  b819                              movu.w  2[r1], r1
FFF35F95  6101                              cmp     #0, r1
FFF35F97  1d                                bne.s   loc_FFF35F9C
FFF35F98  f80601                 loc_FFF35F98 mov.l   #1, 14h+var_14[sp]
FFF35F9B  0c                                bra.s   loc_FFF35F9F
FFF35F9C  f80600                 loc_FFF35F9C mov.l   #0, 14h+var_14[sp]
FFF35F9F  ec01                   loc_FFF35F9F mov.l   14h+var_14[sp], r1
FFF35FA1  6101                              cmp     #0, r1
FFF35FA3  2165                              bne.b   loc_FFF36008
FFF35FA5  a901                              mov.l   14h+var_4[sp], r1
FFF35FA7  a891                              mov.l   8[r1], r1
FFF35FA9  74010004fb00                      cmp     #0FB0400h, r1
FFF35FAF  230e                              bltu.b  loc_FFF35FBD
FFF35FB1  a889                              mov.l   14h+var_8[sp], r1
FFF35FB3  f814ff                            mov.b   #-1, [r1]
FFF35FB6  a889                              mov.l   14h+var_8[sp], r1
FFF35FB8  3c11ff                            mov.b   #-1, 1[r1]
FFF35FBB  6705                              rtsd    #5
FFF35FBD  a901                   loc_FFF35FBD mov.l   14h+var_4[sp], r1
FFF35FBF  a892                              mov.l   8[r1], r2
FFF35FC1  5c1e                              movu.w  [r1], r14
FFF35FC3  ef2f                              mov.l   r2, r15
FFF35FC5  fc27ef                            divu    r14, r15
FFF35FC8  4fef                              mul     r14, r15
FFF35FCA  43f2                              sub     r15, r2
FFF35FCC  6212                              add     #1, r2
FFF35FCE  818a                              mov.b   r2, 14h+var_D[sp]
FFF35FD0  a901                              mov.l   14h+var_4[sp], r1
FFF35FD2  5c1e                              movu.w  [r1], r14
FFF35FD4  06cd1e01                          mul     2[r1].uw, r14
FFF35FD8  a891                              mov.l   8[r1], r1
FFF35FDA  fc27e1                            divu    r14, r1
FFF35FDD  a081                              mov.l   r1, 14h+var_C[sp]
FFF35FDF  a881                              mov.l   14h+var_C[sp], r1
FFF35FE1  6881                              shlr    #8, r1
FFF35FE3  8181                              mov.b   r1, 14h+var_E[sp]
FFF35FE5  b181                              movu.b  14h+var_E[sp], r1
FFF35FE7  6c61                              shll    #6, r1
FFF35FE9  8181                              mov.b   r1, 14h+var_E[sp]
FFF35FEB  7541c0                            mov.l   #-40h, r1
FFF35FEE  510106                            and     14h+var_E[sp], r1
FFF35FF1  8181                              mov.b   r1, 14h+var_E[sp]
FFF35FF3  b189                              movu.b  14h+var_D[sp], r1
FFF35FF5  550106                            or      14h+var_E[sp], r1
FFF35FF8  8189                              mov.b   r1, 14h+var_D[sp]
FFF35FFA  b189                              movu.b  14h+var_D[sp], r1
FFF35FFC  a88a                              mov.l   14h+var_8[sp], r2
FFF35FFE  c321                              mov.b   r1, [r2]
FFF36000  a881                              mov.l   14h+var_C[sp], r1
FFF36002  a88a                              mov.l   14h+var_8[sp], r2
FFF36004  8029                              mov.b   r1, 1[r2]
FFF36006  6705                              rtsd    #5
FFF36008  6705                   loc_FFF36008 rtsd    #5
FFF3600A  60c0                   sub_FFF3600A sub     #0Ch, sp   ; <<<< FUNC sub_FFF3600A
FFF3600C  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3600E  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF36010  a881                              mov.l   0Ch+var_4[sp], r1
FFF36012  8d11                              mov.b   14h[r1], r1
FFF36014  61c1                              cmp     #0Ch, r1
FFF36016  11                                beq.s   loc_FFF3601F
FFF36017  a881                              mov.l   0Ch+var_4[sp], r1
FFF36019  8d11                              mov.b   14h[r1], r1
FFF3601B  755110                            cmp     #10h, r1
FFF3601E  1d                                bne.s   loc_FFF36023
FFF3601F  f80601                 loc_FFF3601F mov.l   #1, 0Ch+var_C[sp]
FFF36022  0c                                bra.s   loc_FFF36026
FFF36023  f80600                 loc_FFF36023 mov.l   #0, 0Ch+var_C[sp]
FFF36026  ec01                   loc_FFF36026 mov.l   0Ch+var_C[sp], r1
FFF36028  6101                              cmp     #0, r1
FFF3602A  a881                              mov.l   0Ch+var_4[sp], r1
FFF3602C  2028                              beq.b   loc_FFF36054
FFF3602E  a899                              mov.l   0Ch[r1], r1
FFF36030  7601a77f                          cmp     #7FA7h, r1
FFF36034  2409                              bgtu.b  loc_FFF3603D
FFF36036  a809                              mov.l   0Ch+var_8[sp], r1
FFF36038  f81401                            mov.b   #1, [r1]
FFF3603B  6703                              rtsd    #3
FFF3603D  a881                   loc_FFF3603D mov.l   0Ch+var_4[sp], r1
FFF3603F  a899                              mov.l   0Ch[r1], r1
FFF36041  7701ffff00                        cmp     #0FFFFh, r1
FFF36046  a809                              mov.l   0Ch+var_8[sp], r1
FFF36048  2407                              bgtu.b  loc_FFF3604F
FFF3604A  f81404                            mov.b   #4, [r1]
FFF3604D  6703                              rtsd    #3
FFF3604F  f81406                 loc_FFF3604F mov.b   #6, [r1]
FFF36052  6703                              rtsd    #3
FFF36054  8d11                   loc_FFF36054 mov.b   14h[r1], r1
FFF36056  755120                            cmp     #20h, r1 ; ' '
FFF36059  211a                              bne.b   loc_FFF36073
FFF3605B  a881                              mov.l   0Ch+var_4[sp], r1
FFF3605D  a899                              mov.l   0Ch[r1], r1
FFF3605F  7401ff03fb00                      cmp     #0FB03FFh, r1
FFF36065  a809                              mov.l   0Ch+var_8[sp], r1
FFF36067  2407                              bgtu.b  loc_FFF3606E
FFF36069  f8140b                            mov.b   #0Bh, [r1]
FFF3606C  6703                              rtsd    #3
FFF3606E  f8140c                 loc_FFF3606E mov.b   #0Ch, [r1]
FFF36071  6703                              rtsd    #3
FFF36073  6703                   loc_FFF36073 rtsd    #3
FFF36075  7100f0                 sub_FFF36075 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF36075
FFF36078  a089                              mov.l   r1, 10h+var_4[sp]
FFF3607A  a082                              mov.l   r2, 10h+var_8[sp]
FFF3607C  f82400                            mov.b   #0, [r2]
FFF3607F  a889                              mov.l   10h+var_4[sp], r1
FFF36081  5c1e                              movu.w  [r1], r14
FFF36083  610e                              cmp     #0, r14
FFF36085  10                                beq.s   loc_FFF3608D
FFF36086  a889                              mov.l   10h+var_4[sp], r1
FFF36088  b819                              movu.w  2[r1], r1
FFF3608A  6101                              cmp     #0, r1
FFF3608C  1d                                bne.s   loc_FFF36091
FFF3608D  f80601                 loc_FFF3608D mov.l   #1, 10h+var_10[sp]
FFF36090  0c                                bra.s   loc_FFF36094
FFF36091  f80600                 loc_FFF36091 mov.l   #0, 10h+var_10[sp]
FFF36094  ec01                   loc_FFF36094 mov.l   10h+var_10[sp], r1
FFF36096  6101                              cmp     #0, r1
FFF36098  2148                              bne.b   loc_FFF360E0
FFF3609A  a889                              mov.l   10h+var_4[sp], r1
FFF3609C  a899                              mov.l   0Ch[r1], r1
FFF3609E  74010004fb00                      cmp     #0FB0400h, r1
FFF360A4  2309                              bltu.b  loc_FFF360AD
FFF360A6  a881                              mov.l   10h+var_8[sp], r1
FFF360A8  f814fe                            mov.b   #-2, [r1]
FFF360AB  6704                              rtsd    #4
FFF360AD  a889                   loc_FFF360AD mov.l   10h+var_4[sp], r1
FFF360AF  a892                              mov.l   8[r1], r2
FFF360B1  06891203                          add     0Ch[r1].l, r2
FFF360B5  6012                              sub     #1, r2
FFF360B7  a00a                              mov.l   r2, 10h+var_C[sp]
FFF360B9  a889                              mov.l   10h+var_4[sp], r1
FFF360BB  5c1e                              movu.w  [r1], r14
FFF360BD  06cd1e01                          mul     2[r1].uw, r14
FFF360C1  a809                              mov.l   10h+var_C[sp], r1
FFF360C3  ef1f                              mov.l   r1, r15
FFF360C5  fc27ef                            divu    r14, r15
FFF360C8  4fef                              mul     r14, r15
FFF360CA  43f1                              sub     r15, r1
FFF360CC  a009                              mov.l   r1, 10h+var_C[sp]
FFF360CE  a809                              mov.l   10h+var_C[sp], r1
FFF360D0  a88a                              mov.l   10h+var_4[sp], r2
FFF360D2  06e00921                          divu    [r2].uw, r1
FFF360D6  a009                              mov.l   r1, 10h+var_C[sp]
FFF360D8  a809                              mov.l   10h+var_C[sp], r1
FFF360DA  a882                              mov.l   10h+var_8[sp], r2
FFF360DC  c321                              mov.b   r1, [r2]
FFF360DE  6704                              rtsd    #4
FFF360E0  6704                   loc_FFF360E0 rtsd    #4
FFF360E2  7100ec                 sub_FFF360E2 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF360E2
FFF360E5  a101                              mov.l   r1, 14h+var_4[sp]
FFF360E7  a08a                              mov.l   r2, 14h+var_8[sp]
FFF360E9  f82400                            mov.b   #0, [r2]
FFF360EC  a889                              mov.l   14h+var_8[sp], r1
FFF360EE  3c1100                            mov.b   #0, 1[r1]
FFF360F1  a901                              mov.l   14h+var_4[sp], r1
FFF360F3  5c1e                              movu.w  [r1], r14
FFF360F5  610e                              cmp     #0, r14
FFF360F7  10                                beq.s   loc_FFF360FF
FFF360F8  a901                              mov.l   14h+var_4[sp], r1
FFF360FA  b819                              movu.w  2[r1], r1
FFF360FC  6101                              cmp     #0, r1
FFF360FE  1d                                bne.s   loc_FFF36103
FFF360FF  f80601                 loc_FFF360FF mov.l   #1, 14h+var_14[sp]
FFF36102  0c                                bra.s   loc_FFF36106
FFF36103  f80600                 loc_FFF36103 mov.l   #0, 14h+var_14[sp]
FFF36106  ec01                   loc_FFF36106 mov.l   14h+var_14[sp], r1
FFF36108  6101                              cmp     #0, r1
FFF3610A  2171                              bne.b   loc_FFF3617B
FFF3610C  a901                              mov.l   14h+var_4[sp], r1
FFF3610E  a899                              mov.l   0Ch[r1], r1
FFF36110  74010004fb00                      cmp     #0FB0400h, r1
FFF36116  230e                              bltu.b  loc_FFF36124
FFF36118  a889                              mov.l   14h+var_8[sp], r1
FFF3611A  f814ff                            mov.b   #-1, [r1]
FFF3611D  a889                              mov.l   14h+var_8[sp], r1
FFF3611F  3c11ff                            mov.b   #-1, 1[r1]
FFF36122  6705                              rtsd    #5
FFF36124  a901                   loc_FFF36124 mov.l   14h+var_4[sp], r1
FFF36126  a892                              mov.l   8[r1], r2
FFF36128  06891203                          add     0Ch[r1].l, r2
FFF3612C  6012                              sub     #1, r2
FFF3612E  5c1e                              movu.w  [r1], r14
FFF36130  ef2f                              mov.l   r2, r15
FFF36132  fc27ef                            divu    r14, r15
FFF36135  4fef                              mul     r14, r15
FFF36137  43f2                              sub     r15, r2
FFF36139  6212                              add     #1, r2
FFF3613B  818a                              mov.b   r2, 14h+var_D[sp]
FFF3613D  a901                              mov.l   14h+var_4[sp], r1
FFF3613F  5c1e                              movu.w  [r1], r14
FFF36141  06cd1e01                          mul     2[r1].uw, r14
FFF36145  a892                              mov.l   8[r1], r2
FFF36147  06891203                          add     0Ch[r1].l, r2
FFF3614B  6012                              sub     #1, r2
FFF3614D  fc27e2                            divu    r14, r2
FFF36150  a082                              mov.l   r2, 14h+var_C[sp]
FFF36152  a881                              mov.l   14h+var_C[sp], r1
FFF36154  6881                              shlr    #8, r1
FFF36156  8181                              mov.b   r1, 14h+var_E[sp]
FFF36158  b181                              movu.b  14h+var_E[sp], r1
FFF3615A  6c61                              shll    #6, r1
FFF3615C  8181                              mov.b   r1, 14h+var_E[sp]
FFF3615E  7541c0                            mov.l   #-40h, r1
FFF36161  510106                            and     14h+var_E[sp], r1
FFF36164  8181                              mov.b   r1, 14h+var_E[sp]
FFF36166  b189                              movu.b  14h+var_D[sp], r1
FFF36168  550106                            or      14h+var_E[sp], r1
FFF3616B  8189                              mov.b   r1, 14h+var_D[sp]
FFF3616D  b189                              movu.b  14h+var_D[sp], r1
FFF3616F  a88a                              mov.l   14h+var_8[sp], r2
FFF36171  c321                              mov.b   r1, [r2]
FFF36173  a881                              mov.l   14h+var_C[sp], r1
FFF36175  a88a                              mov.l   14h+var_8[sp], r2
FFF36177  8029                              mov.b   r1, 1[r2]
FFF36179  6705                              rtsd    #5
FFF3617B  6705                   loc_FFF3617B rtsd    #5
FFF3617D  7100ec                 sub_FFF3617D add     #-14h, sp, sp   ; <<<< FUNC sub_FFF3617D
FFF36180  a101                              mov.l   r1, 14h+var_4[sp]
FFF36182  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF36185  a901                              mov.l   14h+var_4[sp], r1
FFF36187  ec11                              mov.l   [r1], r1
FFF36189  7211c802                          add     #2C8h, r1, r1
FFF3618D  e301                              mov.l   r1, 14h+var_14[sp]
FFF3618F  a901                              mov.l   14h+var_4[sp], r1
FFF36191  ec11                              mov.l   [r1], r1
FFF36193  6211                              add     #1, r1
FFF36195  fb3a0002                          mov.l   #200h, r3
FFF36199  6602                              mov.l   #0, r2
FFF3619B  ef24                              mov.l   r2, r4
FFF3619D  051283ff                          bsr.a   sub_FFF2E4AF
FFF361A1  a901                              mov.l   14h+var_4[sp], r1
FFF361A3  ec11                              mov.l   [r1], r1
FFF361A5  7211bf01                          add     #1BFh, r1, r1
FFF361A9  a081                              mov.l   r1, 14h+var_C[sp]
FFF361AB  a882                              mov.l   14h+var_C[sp], r2
FFF361AD  ec01                              mov.l   14h+var_14[sp], r1
FFF361AF  6212                              add     #1, r2
FFF361B1  3969fd                            bsr.w   sub_FFF35F1A
FFF361B4  a882                              mov.l   14h+var_C[sp], r2
FFF361B6  ec01                              mov.l   14h+var_14[sp], r1
FFF361B8  6222                              add     #2, r2
FFF361BA  39c1fd                            bsr.w   sub_FFF35F7B
FFF361BD  a882                              mov.l   14h+var_C[sp], r2
FFF361BF  ec01                              mov.l   14h+var_14[sp], r1
FFF361C1  6242                              add     #4, r2
FFF361C3  3947fe                            bsr.w   sub_FFF3600A
FFF361C6  a882                              mov.l   14h+var_C[sp], r2
FFF361C8  ec01                              mov.l   14h+var_14[sp], r1
FFF361CA  6252                              add     #5, r2
FFF361CC  39a9fe                            bsr.w   sub_FFF36075
FFF361CF  a882                              mov.l   14h+var_C[sp], r2
FFF361D1  ec01                              mov.l   14h+var_14[sp], r1
FFF361D3  6262                              add     #6, r2
FFF361D5  390dff                            bsr.w   sub_FFF360E2
FFF361D8  ec01                              mov.l   14h+var_14[sp], r1
FFF361DA  a892                              mov.l   8[r1], r2
FFF361DC  a881                              mov.l   14h+var_C[sp], r1
FFF361DE  6281                              add     #8, r1
FFF361E0  05f38aff                          bsr.a   sub_FFF2ECD3
FFF361E4  ec01                              mov.l   14h+var_14[sp], r1
FFF361E6  a89a                              mov.l   0Ch[r1], r2
FFF361E8  a881                              mov.l   14h+var_C[sp], r1
FFF361EA  62c1                              add     #0Ch, r1
FFF361EC  05e78aff                          bsr.a   sub_FFF2ECD3
FFF361F0  a901                              mov.l   14h+var_4[sp], r1
FFF361F2  ec1e                              mov.l   [r1], r14
FFF361F4  fae4ff0155                        mov.b   #55h, 1FFh[r14] ; 'U'
FFF361F9  a901                              mov.l   14h+var_4[sp], r1
FFF361FB  ec1e                              mov.l   [r1], r14
FFF361FD  fae40002aa                        mov.b   #-56h, 200h[r14]
FFF36202  a904                              mov.l   14h+var_4[sp], r4
FFF36204  ec42                              mov.l   [r4], r2
FFF36206  6212                              add     #1, r2
FFF36208  6613                              mov.l   #1, r3
FFF3620A  6601                              mov.l   #0, r1
FFF3620C  0548f2ff                          bsr.a   sub_FFF35454
FFF36210  a009                              mov.l   r1, 14h+var_10[sp]
FFF36212  a809                              mov.l   14h+var_10[sp], r1
FFF36214  a089                              mov.l   r1, 14h+var_8[sp]
FFF36216  6705                              rtsd    #5
FFF36218  7100f0                 sub_FFF36218 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF36218
FFF3621B  a089                              mov.l   r1, 10h+var_4[sp]
FFF3621D  3c0700                            mov.b   #0, 10h+var_9[sp]
FFF36220  a889                              mov.l   10h+var_4[sp], r1
FFF36222  b119                              movu.b  5[r1], r1
FFF36224  64f1                              and     #0Fh, r1
FFF36226  8189                              mov.b   r1, 10h+var_9[sp]
FFF36228  b189                              movu.b  10h+var_9[sp], r1
FFF3622A  61a1                              cmp     #0Ah, r1
FFF3622C  1f                                bne.s   loc_FFF36233
FFF3622D  f80a0004                          mov.l   #400h, 10h+var_10[sp]
FFF36231  2e10                              bra.b   loc_FFF36241
FFF36233  b189                   loc_FFF36233 movu.b  10h+var_9[sp], r1
FFF36235  61b1                              cmp     #0Bh, r1
FFF36237  1e                                bne.s   loc_FFF3623D
FFF36238  f80a0008                          mov.l   #800h, 10h+var_10[sp]
FFF3623C  0d                                bra.s   loc_FFF36241
FFF3623D  f80a0002               loc_FFF3623D mov.l   #200h, 10h+var_10[sp]
FFF36241  ec01                   loc_FFF36241 mov.l   10h+var_10[sp], r1
FFF36243  a081                              mov.l   r1, 10h+var_8[sp]
FFF36245  6704                              rtsd    #4
FFF36247  60c0                   sub_FFF36247 sub     #0Ch, sp   ; <<<< FUNC sub_FFF36247
FFF36249  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3624B  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF3624E  a881                              mov.l   0Ch+var_4[sp], r1
FFF36250  b191                              movu.b  6[r1], r1
FFF36252  6431                              and     #3, r1
FFF36254  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF36256  ec01                              mov.l   0Ch+var_C[sp], r1
FFF36258  6c81                              shll    #8, r1
FFF3625A  a882                              mov.l   0Ch+var_4[sp], r2
FFF3625C  552107                            or      7[r2], r1
FFF3625F  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF36261  ec01                              mov.l   0Ch+var_C[sp], r1
FFF36263  6c81                              shll    #8, r1
FFF36265  a882                              mov.l   0Ch+var_4[sp], r2
FFF36267  552108                            or      8[r2], r1
FFF3626A  7521c0                            and     #-40h, r1
FFF3626D  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF3626F  ec01                              mov.l   0Ch+var_C[sp], r1
FFF36271  6861                              shlr    #6, r1
FFF36273  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF36275  ec01                              mov.l   0Ch+var_C[sp], r1
FFF36277  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF36279  6703                              rtsd    #3
FFF3627B  7100f0                 sub_FFF3627B add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3627B
FFF3627E  a089                              mov.l   r1, 10h+var_4[sp]
FFF36280  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF36283  a889                              mov.l   10h+var_4[sp], r1
FFF36285  b219                              movu.b  9[r1], r1
FFF36287  6431                              and     #3, r1
FFF36289  a009                              mov.l   r1, 10h+var_C[sp]
FFF3628B  a809                              mov.l   10h+var_C[sp], r1
FFF3628D  6c81                              shll    #8, r1
FFF3628F  a88a                              mov.l   10h+var_4[sp], r2
FFF36291  55210a                            or      0Ah[r2], r1
FFF36294  752180                            and     #-80h, r1
FFF36297  a009                              mov.l   r1, 10h+var_C[sp]
FFF36299  a809                              mov.l   10h+var_C[sp], r1
FFF3629B  6871                              shlr    #7, r1
FFF3629D  a009                              mov.l   r1, 10h+var_C[sp]
FFF3629F  a809                              mov.l   10h+var_C[sp], r1
FFF362A1  6101                              cmp     #0, r1
FFF362A3  1e                                bne.s   loc_FFF362A9
FFF362A4  f80604                            mov.l   #4, 10h+var_10[sp]
FFF362A7  2e42                              bra.b   loc_FFF362E9
FFF362A9  a809                   loc_FFF362A9 mov.l   10h+var_C[sp], r1
FFF362AB  6111                              cmp     #1, r1
FFF362AD  1e                                bne.s   loc_FFF362B3
FFF362AE  f80608                            mov.l   #8, 10h+var_10[sp]
FFF362B1  2e38                              bra.b   loc_FFF362E9
FFF362B3  a809                   loc_FFF362B3 mov.l   10h+var_C[sp], r1
FFF362B5  6121                              cmp     #2, r1
FFF362B7  1e                                bne.s   loc_FFF362BD
FFF362B8  f80610                            mov.l   #10h, 10h+var_10[sp]
FFF362BB  2e2e                              bra.b   loc_FFF362E9
FFF362BD  a809                   loc_FFF362BD mov.l   10h+var_C[sp], r1
FFF362BF  6131                              cmp     #3, r1
FFF362C1  1e                                bne.s   loc_FFF362C7
FFF362C2  f80620                            mov.l   #20h, 10h+var_10[sp] ; ' '
FFF362C5  2e24                              bra.b   loc_FFF362E9
FFF362C7  a809                   loc_FFF362C7 mov.l   10h+var_C[sp], r1
FFF362C9  6141                              cmp     #4, r1
FFF362CB  1e                                bne.s   loc_FFF362D1
FFF362CC  f80640                            mov.l   #40h, 10h+var_10[sp] ; '@'
FFF362CF  2e1a                              bra.b   loc_FFF362E9
FFF362D1  a809                   loc_FFF362D1 mov.l   10h+var_C[sp], r1
FFF362D3  6151                              cmp     #5, r1
FFF362D5  1e                                bne.s   loc_FFF362DB
FFF362D6  3e0080                            mov.l   #-80h, [sp]
FFF362D9  2e10                              bra.b   loc_FFF362E9
FFF362DB  a809                   loc_FFF362DB mov.l   10h+var_C[sp], r1
FFF362DD  6161                              cmp     #6, r1
FFF362DF  1e                                bne.s   loc_FFF362E5
FFF362E0  f80a0001                          mov.l   #100h, 10h+var_10[sp]
FFF362E4  0d                                bra.s   loc_FFF362E9
FFF362E5  f80a0002               loc_FFF362E5 mov.l   #200h, 10h+var_10[sp]
FFF362E9  ec01                   loc_FFF362E9 mov.l   10h+var_10[sp], r1
FFF362EB  a081                              mov.l   r1, 10h+var_8[sp]
FFF362ED  6704                              rtsd    #4
FFF362EF  6080                   sub_FFF362EF sub     #8, sp   ; <<<< FUNC sub_FFF362EF
FFF362F1  a009                              mov.l   r1, 8+var_4[sp]
FFF362F3  e302                              mov.l   r2, 8+var_8[sp]
FFF362F5  a809                              mov.l   8+var_4[sp], r1
FFF362F7  7701ffff7d                        cmp     #7DFFFFh, r1
FFF362FC  2415                              bgtu.b  loc_FFF36311
FFF362FE  75432c                            mov.l   #2Ch, r3 ; ','
