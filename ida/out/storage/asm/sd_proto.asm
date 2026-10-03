; ==== sd_proto  FFF34400-FFF35400  (file 334400-335400) ====
FFF34400  754180                 loc_FFF34400 mov.l   #-80h, r1
FFF34403  a88a                              mov.l   10h+var_4[sp], r2
FFF34405  512103                            and     3[r2], r1
FFF34408  8189                              mov.b   r1, 10h+var_9[sp]
FFF3440A  b189                              movu.b  10h+var_9[sp], r1
FFF3440C  6101                              cmp     #0, r1
FFF3440E  16                                beq.s   loc_FFF34414
FFF3440F  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF34412  2e40                              bra.b   loc_FFF34452
FFF34414  a889                   loc_FFF34414 mov.l   10h+var_4[sp], r1
FFF34416  b119                              movu.b  5[r1], r1
FFF34418  64f1                              and     #0Fh, r1
FFF3441A  8189                              mov.b   r1, 10h+var_9[sp]
FFF3441C  b189                              movu.b  10h+var_9[sp], r1
FFF3441E  61c1                              cmp     #0Ch, r1
FFF34420  2907                              blt.b   loc_FFF34427
FFF34422  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF34425  2e2d                              bra.b   loc_FFF34452
FFF34427  a889                   loc_FFF34427 mov.l   10h+var_4[sp], r1
FFF34429  b311                              movu.b  0Ch[r1], r1
FFF3442B  75211c                            and     #1Ch, r1
FFF3442E  6821                              shlr    #2, r1
FFF34430  8189                              mov.b   r1, 10h+var_9[sp]
FFF34432  b189                              movu.b  10h+var_9[sp], r1
FFF34434  6181                              cmp     #8, r1
FFF34436  2907                              blt.b   loc_FFF3443D
FFF34438  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF3443B  2e17                              bra.b   loc_FFF34452
FFF3443D  a889                   loc_FFF3443D mov.l   10h+var_4[sp], r1
FFF3443F  b391                              movu.b  0Eh[r1], r1
FFF34441  6431                              and     #3, r1
FFF34443  8189                              mov.b   r1, 10h+var_9[sp]
FFF34445  b189                              movu.b  10h+var_9[sp], r1
FFF34447  6121                              cmp     #2, r1
FFF34449  2906                              blt.b   loc_FFF3444F
FFF3444B  f806fb                            mov.l   #-5, 10h+var_10[sp]
FFF3444E  0c                                bra.s   loc_FFF34452
FFF3444F  f80600                 loc_FFF3444F mov.l   #0, 10h+var_10[sp]
FFF34452  ec01                   loc_FFF34452 mov.l   10h+var_10[sp], r1
FFF34454  a081                              mov.l   r1, 10h+var_8[sp]
FFF34456  6704                              rtsd    #4
FFF34458  7100e8                 sub_FFF34458 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF34458
FFF3445B  a109                              mov.l   r1, 18h+var_4[sp]
FFF3445D  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF34460  2e24                              bra.b   loc_FFF34484
FFF34462  a909                   loc_FFF34462 mov.l   18h+var_4[sp], r1
FFF34464  ec14                              mov.l   [r1], r4
FFF34466  de435501                          mov.w   2AAh[r4], r3
FFF3446A  a819                              mov.l   4[r1], r1
FFF3446C  ac95                              mov.l   48h[r1], r5
FFF3446E  6d03                              shll    #10h, r3
FFF34470  6602                              mov.l   #0, r2
FFF34472  66a1                              mov.l   #0Ah, r1
FFF34474  7f15                              jsr     r5
FFF34476  a089                              mov.l   r1, 18h+var_C[sp]
FFF34478  a889                              mov.l   18h+var_C[sp], r1
FFF3447A  6101                              cmp     #0, r1
FFF3447C  200e                              beq.b   loc_FFF3448A
FFF3447E  a809                              mov.l   18h+var_14[sp], r1
FFF34480  6211                              add     #1, r1
FFF34482  a009                              mov.l   r1, 18h+var_14[sp]
FFF34484  a809                   loc_FFF34484 mov.l   18h+var_14[sp], r1
FFF34486  6131                              cmp     #3, r1
FFF34488  29da                              blt.b   loc_FFF34462
FFF3448A  a809                   loc_FFF3448A mov.l   18h+var_14[sp], r1
FFF3448C  6131                              cmp     #3, r1
FFF3448E  2907                              blt.b   loc_FFF34495
FFF34490  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF34493  2e30                              bra.b   loc_FFF344C3
FFF34495  a909                   loc_FFF34495 mov.l   18h+var_4[sp], r1
FFF34497  ec12                              mov.l   [r1], r2
FFF34499  a819                              mov.l   4[r1], r1
FFF3449B  ac9b                              mov.l   4Ch[r1], r3
FFF3449D  6621                              mov.l   #2, r1
FFF3449F  7f13                              jsr     r3
FFF344A1  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF344A4  2e16                              bra.b   loc_FFF344BA
FFF344A6  a909                   loc_FFF344A6 mov.l   18h+var_4[sp], r1
FFF344A8  ec1e                              mov.l   [r1], r14
FFF344AA  06890e02                          add     18h+var_10[sp].l, r14
FFF344AE  caeeb0021102                      mov.b   2B0h[r14], 211h[r14]
FFF344B4  a881                              mov.l   18h+var_10[sp], r1
FFF344B6  6211                              add     #1, r1
FFF344B8  a081                              mov.l   r1, 18h+var_10[sp]
FFF344BA  a881                   loc_FFF344BA mov.l   18h+var_10[sp], r1
FFF344BC  61f1                              cmp     #0Fh, r1
FFF344BE  2be8                              ble.b   loc_FFF344A6
FFF344C0  f80600                            mov.l   #0, 18h+var_18[sp]
FFF344C3  ec01                   loc_FFF344C3 mov.l   18h+var_18[sp], r1
FFF344C5  a101                              mov.l   r1, 18h+var_8[sp]
FFF344C7  6706                              rtsd    #6
FFF344C9  7100f0                 sub_FFF344C9 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF344C9
FFF344CC  a089                              mov.l   r1, 10h+var_4[sp]
FFF344CE  581e                              movu.b  [r1], r14
FFF344D0  610e                              cmp     #0, r14
FFF344D2  210d                              bne.b   loc_FFF344DF
FFF344D4  a889                              mov.l   10h+var_4[sp], r1
FFF344D6  b019                              movu.b  1[r1], r1
FFF344D8  6101                              cmp     #0, r1
FFF344DA  1d                                bne.s   loc_FFF344DF
FFF344DB  f80601                            mov.l   #1, 10h+var_10[sp]
FFF344DE  0c                                bra.s   loc_FFF344E2
FFF344DF  f80600                 loc_FFF344DF mov.l   #0, 10h+var_10[sp]
FFF344E2  ec01                   loc_FFF344E2 mov.l   10h+var_10[sp], r1
FFF344E4  6101                              cmp     #0, r1
FFF344E6  200d                              beq.b   loc_FFF344F3
FFF344E8  a889                              mov.l   10h+var_4[sp], r1
FFF344EA  b091                              movu.b  2[r1], r1
FFF344EC  6101                              cmp     #0, r1
FFF344EE  1d                                bne.s   loc_FFF344F3
FFF344EF  f80601                            mov.l   #1, 10h+var_10[sp]
FFF344F2  0c                                bra.s   loc_FFF344F6
FFF344F3  f80600                 loc_FFF344F3 mov.l   #0, 10h+var_10[sp]
FFF344F6  ec01                   loc_FFF344F6 mov.l   10h+var_10[sp], r1
FFF344F8  6101                              cmp     #0, r1
FFF344FA  10                                beq.s   loc_FFF34502
FFF344FB  f90601fb                          mov.l   #-5, 10h+var_C[sp]
FFF344FF  38ee00                            bra.w   loc_FFF345ED
FFF34502  a889                   loc_FFF34502 mov.l   10h+var_4[sp], r1
FFF34504  b099                              movu.b  3[r1], r1
FFF34506  6101                              cmp     #0, r1
FFF34508  210d                              bne.b   loc_FFF34515
FFF3450A  a889                              mov.l   10h+var_4[sp], r1
FFF3450C  b111                              movu.b  4[r1], r1
FFF3450E  6101                              cmp     #0, r1
FFF34510  1d                                bne.s   loc_FFF34515
FFF34511  f80601                            mov.l   #1, 10h+var_10[sp]
FFF34514  0c                                bra.s   loc_FFF34518
FFF34515  f80600                 loc_FFF34515 mov.l   #0, 10h+var_10[sp]
FFF34518  ec01                   loc_FFF34518 mov.l   10h+var_10[sp], r1
FFF3451A  6101                              cmp     #0, r1
FFF3451C  200d                              beq.b   loc_FFF34529
FFF3451E  a889                              mov.l   10h+var_4[sp], r1
FFF34520  b119                              movu.b  5[r1], r1
FFF34522  6101                              cmp     #0, r1
FFF34524  1d                                bne.s   loc_FFF34529
FFF34525  f80601                            mov.l   #1, 10h+var_10[sp]
FFF34528  0c                                bra.s   loc_FFF3452C
FFF34529  f80600                 loc_FFF34529 mov.l   #0, 10h+var_10[sp]
FFF3452C  ec01                   loc_FFF3452C mov.l   10h+var_10[sp], r1
FFF3452E  6101                              cmp     #0, r1
FFF34530  200d                              beq.b   loc_FFF3453D
FFF34532  a889                              mov.l   10h+var_4[sp], r1
FFF34534  b191                              movu.b  6[r1], r1
FFF34536  6101                              cmp     #0, r1
FFF34538  1d                                bne.s   loc_FFF3453D
FFF34539  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3453C  0c                                bra.s   loc_FFF34540
FFF3453D  f80600                 loc_FFF3453D mov.l   #0, 10h+var_10[sp]
FFF34540  ec01                   loc_FFF34540 mov.l   10h+var_10[sp], r1
FFF34542  6101                              cmp     #0, r1
FFF34544  200d                              beq.b   loc_FFF34551
FFF34546  a889                              mov.l   10h+var_4[sp], r1
FFF34548  b199                              movu.b  7[r1], r1
FFF3454A  6101                              cmp     #0, r1
FFF3454C  1d                                bne.s   loc_FFF34551
FFF3454D  f80601                            mov.l   #1, 10h+var_10[sp]
FFF34550  0c                                bra.s   loc_FFF34554
FFF34551  f80600                 loc_FFF34551 mov.l   #0, 10h+var_10[sp]
FFF34554  ec01                   loc_FFF34554 mov.l   10h+var_10[sp], r1
FFF34556  6101                              cmp     #0, r1
FFF34558  200d                              beq.b   loc_FFF34565
FFF3455A  a889                              mov.l   10h+var_4[sp], r1
FFF3455C  b211                              movu.b  8[r1], r1
FFF3455E  6101                              cmp     #0, r1
FFF34560  1d                                bne.s   loc_FFF34565
FFF34561  f80601                            mov.l   #1, 10h+var_10[sp]
FFF34564  0c                                bra.s   loc_FFF34568
FFF34565  f80600                 loc_FFF34565 mov.l   #0, 10h+var_10[sp]
FFF34568  ec01                   loc_FFF34568 mov.l   10h+var_10[sp], r1
FFF3456A  6101                              cmp     #0, r1
FFF3456C  200d                              beq.b   loc_FFF34579
FFF3456E  a889                              mov.l   10h+var_4[sp], r1
FFF34570  b219                              movu.b  9[r1], r1
FFF34572  6101                              cmp     #0, r1
FFF34574  1d                                bne.s   loc_FFF34579
FFF34575  f80601                            mov.l   #1, 10h+var_10[sp]
FFF34578  0c                                bra.s   loc_FFF3457C
FFF34579  f80600                 loc_FFF34579 mov.l   #0, 10h+var_10[sp]
FFF3457C  ec01                   loc_FFF3457C mov.l   10h+var_10[sp], r1
FFF3457E  6101                              cmp     #0, r1
FFF34580  200d                              beq.b   loc_FFF3458D
FFF34582  a889                              mov.l   10h+var_4[sp], r1
FFF34584  b291                              movu.b  0Ah[r1], r1
FFF34586  6101                              cmp     #0, r1
FFF34588  1d                                bne.s   loc_FFF3458D
FFF34589  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3458C  0c                                bra.s   loc_FFF34590
FFF3458D  f80600                 loc_FFF3458D mov.l   #0, 10h+var_10[sp]
FFF34590  ec01                   loc_FFF34590 mov.l   10h+var_10[sp], r1
FFF34592  6101                              cmp     #0, r1
FFF34594  200d                              beq.b   loc_FFF345A1
FFF34596  a889                              mov.l   10h+var_4[sp], r1
FFF34598  b299                              movu.b  0Bh[r1], r1
FFF3459A  6101                              cmp     #0, r1
FFF3459C  1d                                bne.s   loc_FFF345A1
FFF3459D  f80601                            mov.l   #1, 10h+var_10[sp]
FFF345A0  0c                                bra.s   loc_FFF345A4
FFF345A1  f80600                 loc_FFF345A1 mov.l   #0, 10h+var_10[sp]
FFF345A4  ec01                   loc_FFF345A4 mov.l   10h+var_10[sp], r1
FFF345A6  6101                              cmp     #0, r1
FFF345A8  200d                              beq.b   loc_FFF345B5
FFF345AA  a889                              mov.l   10h+var_4[sp], r1
FFF345AC  b311                              movu.b  0Ch[r1], r1
FFF345AE  6101                              cmp     #0, r1
FFF345B0  1d                                bne.s   loc_FFF345B5
FFF345B1  f80601                            mov.l   #1, 10h+var_10[sp]
FFF345B4  0c                                bra.s   loc_FFF345B8
FFF345B5  f80600                 loc_FFF345B5 mov.l   #0, 10h+var_10[sp]
FFF345B8  ec01                   loc_FFF345B8 mov.l   10h+var_10[sp], r1
FFF345BA  6101                              cmp     #0, r1
FFF345BC  200d                              beq.b   loc_FFF345C9
FFF345BE  a889                              mov.l   10h+var_4[sp], r1
FFF345C0  b319                              movu.b  0Dh[r1], r1
FFF345C2  6101                              cmp     #0, r1
FFF345C4  1d                                bne.s   loc_FFF345C9
FFF345C5  f80601                            mov.l   #1, 10h+var_10[sp]
FFF345C8  0c                                bra.s   loc_FFF345CC
FFF345C9  f80600                 loc_FFF345C9 mov.l   #0, 10h+var_10[sp]
FFF345CC  ec01                   loc_FFF345CC mov.l   10h+var_10[sp], r1
FFF345CE  6101                              cmp     #0, r1
FFF345D0  200d                              beq.b   loc_FFF345DD
FFF345D2  a889                              mov.l   10h+var_4[sp], r1
FFF345D4  b391                              movu.b  0Eh[r1], r1
FFF345D6  6101                              cmp     #0, r1
FFF345D8  1d                                bne.s   loc_FFF345DD
FFF345D9  f80601                            mov.l   #1, 10h+var_10[sp]
FFF345DC  0c                                bra.s   loc_FFF345E0
FFF345DD  f80600                 loc_FFF345DD mov.l   #0, 10h+var_10[sp]
FFF345E0  ec01                   loc_FFF345E0 mov.l   10h+var_10[sp], r1
FFF345E2  6101                              cmp     #0, r1
FFF345E4  16                                beq.s   loc_FFF345EA
FFF345E5  f90601fb                          mov.l   #-5, 10h+var_C[sp]
FFF345E9  0c                                bra.s   loc_FFF345ED
FFF345EA  3e0100                 loc_FFF345EA mov.l   #0, 10h+var_C[sp]
FFF345ED  a809                   loc_FFF345ED mov.l   10h+var_C[sp], r1
FFF345EF  a081                              mov.l   r1, 10h+var_8[sp]
FFF345F1  6704                              rtsd    #4
FFF345F3  7100e8                 sub_FFF345F3 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF345F3
FFF345F6  a109                              mov.l   r1, 18h+var_4[sp]
FFF345F8  a102                              mov.l   r2, 18h+var_8[sp]
FFF345FA  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF345FD  2e24                              bra.b   loc_FFF34621
FFF345FF  a901                   loc_FFF345FF mov.l   18h+var_8[sp], r1
FFF34601  ec14                              mov.l   [r1], r4
FFF34603  de435501                          mov.w   2AAh[r4], r3
FFF34607  a819                              mov.l   4[r1], r1
FFF34609  ac95                              mov.l   48h[r1], r5
FFF3460B  6d03                              shll    #10h, r3
FFF3460D  6602                              mov.l   #0, r2
FFF3460F  66d1                              mov.l   #0Dh, r1
FFF34611  7f15                              jsr     r5
FFF34613  a081                              mov.l   r1, 18h+var_10[sp]
FFF34615  a881                              mov.l   18h+var_10[sp], r1
FFF34617  6101                              cmp     #0, r1
FFF34619  200e                              beq.b   loc_FFF34627
FFF3461B  a809                              mov.l   18h+var_14[sp], r1
FFF3461D  6211                              add     #1, r1
FFF3461F  a009                              mov.l   r1, 18h+var_14[sp]
FFF34621  a809                   loc_FFF34621 mov.l   18h+var_14[sp], r1
FFF34623  6131                              cmp     #3, r1
FFF34625  29da                              blt.b   loc_FFF345FF
FFF34627  a809                   loc_FFF34627 mov.l   18h+var_14[sp], r1
FFF34629  6131                              cmp     #3, r1
FFF3462B  2907                              blt.b   loc_FFF34632
FFF3462D  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF34630  2e36                              bra.b   loc_FFF34666
FFF34632  a901                   loc_FFF34632 mov.l   18h+var_8[sp], r1
FFF34634  ec12                              mov.l   [r1], r2
FFF34636  a819                              mov.l   4[r1], r1
FFF34638  ac9b                              mov.l   4Ch[r1], r3
FFF3463A  6611                              mov.l   #1, r1
FFF3463C  7f13                              jsr     r3
FFF3463E  a901                              mov.l   18h+var_8[sp], r1
FFF34640  ec1e                              mov.l   [r1], r14
FFF34642  5eef6301                          movu.w  2C6h[r14], r15
FFF34646  fb52287fedff                      mov.l   #unk_FFED7F28, r5
FFF3464C  fe6f5f                            mov.l   [r15, r5], r15
FFF3464F  06a10cefac                        tst     2B0h[r14].l, r15
FFF34654  16                                beq.s   loc_FFF3465A
FFF34655  f806e9                            mov.l   #-17h, 18h+var_18[sp]
FFF34658  2e0e                              bra.b   loc_FFF34666
FFF3465A  a901                   loc_FFF3465A mov.l   18h+var_8[sp], r1
FFF3465C  ec1e                              mov.l   [r1], r14
FFF3465E  a909                              mov.l   18h+var_4[sp], r1
FFF34660  e1e1ac                            mov.l   2B0h[r14], [r1]
FFF34663  f80600                            mov.l   #0, 18h+var_18[sp]
FFF34666  ec01                   loc_FFF34666 mov.l   18h+var_18[sp], r1
FFF34668  a089                              mov.l   r1, 18h+var_C[sp]
FFF3466A  6706                              rtsd    #6
FFF3466C  7100e4                 sub_FFF3466C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF3466C
FFF3466F  ef12                              mov.l   r1, r2
FFF34671  a182                              mov.l   r2, 1Ch+var_4[sp]
FFF34673  710108                            add     #1Ch+var_14, sp, r1
FFF34676  397dff                            bsr.w   sub_FFF345F3
FFF34679  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3467B  a901                              mov.l   1Ch+var_C[sp], r1
FFF3467D  6101                              cmp     #0, r1
FFF3467F  10                                beq.s   loc_FFF34687
FFF34680  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF34684  38f200                            bra.w   loc_FFF34776
FFF34687  a881                   loc_FFF34687 mov.l   1Ch+var_14[sp], r1
FFF34689  7621001e                          and     #1E00h, r1
FFF3468D  76010008                          cmp     #800h, r1
FFF34691  1f                                bne.s   loc_FFF34698
FFF34692  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF34695  38e100                            bra.w   loc_FFF34776
FFF34698  a881                   loc_FFF34698 mov.l   1Ch+var_14[sp], r1
FFF3469A  7621001e                          and     #1E00h, r1
FFF3469E  7601000a                          cmp     #0A00h, r1
FFF346A2  2117                              bne.b   loc_FFF346B9
FFF346A4  a982                              mov.l   1Ch+var_4[sp], r2
FFF346A6  6601                              mov.l   #0, r1
FFF346A8  39ef01                            bsr.w   sub_FFF34897
FFF346AB  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF346AD  a901                              mov.l   1Ch+var_C[sp], r1
FFF346AF  6101                              cmp     #0, r1
FFF346B1  10                                beq.s   loc_FFF346B9
FFF346B2  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF346B6  38c000                            bra.w   loc_FFF34776
FFF346B9  a881                   loc_FFF346B9 mov.l   1Ch+var_14[sp], r1
FFF346BB  7621001e                          and     #1E00h, r1
FFF346BF  7601000a                          cmp     #0A00h, r1
FFF346C3  200d                              beq.b   loc_FFF346D0
FFF346C5  a881                              mov.l   1Ch+var_14[sp], r1
FFF346C7  7621001e                          and     #1E00h, r1
FFF346CB  76010006                          cmp     #600h, r1
FFF346CF  1d                                bne.s   loc_FFF346D4
FFF346D0  f80601                 loc_FFF346D0 mov.l   #1, 1Ch+var_1C[sp]
FFF346D3  0c                                bra.s   loc_FFF346D7
FFF346D4  f80600                 loc_FFF346D4 mov.l   #0, 1Ch+var_1C[sp]
FFF346D7  ec01                   loc_FFF346D7 mov.l   1Ch+var_1C[sp], r1
FFF346D9  6101                              cmp     #0, r1
FFF346DB  2021                              beq.b   loc_FFF346FC
FFF346DD  a982                              mov.l   1Ch+var_4[sp], r2
FFF346DF  ec2e                              mov.l   [r2], r14
FFF346E1  5ee15501                          movu.w  2AAh[r14], r1
FFF346E5  39b201                            bsr.w   sub_FFF34897
FFF346E8  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF346EA  a901                              mov.l   1Ch+var_C[sp], r1
FFF346EC  6101                              cmp     #0, r1
FFF346EE  10                                beq.s   loc_FFF346F6
FFF346EF  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF346F3  388300                            bra.w   loc_FFF34776
FFF346F6  3e0100                 loc_FFF346F6 mov.l   #0, 1Ch+var_18[sp]
FFF346F9  387d00                            bra.w   loc_FFF34776
FFF346FC  a881                   loc_FFF346FC mov.l   1Ch+var_14[sp], r1
FFF346FE  7621001e                          and     #1E00h, r1
FFF34702  7601000c                          cmp     #0C00h, r1
FFF34706  216c                              bne.b   loc_FFF34772
FFF34708  a982                              mov.l   1Ch+var_4[sp], r2
FFF3470A  ec21                              mov.l   [r2], r1
FFF3470C  a82a                              mov.l   4[r2], r2
FFF3470E  ad2a                              mov.l   54h[r2], r2
FFF34710  7f12                              jsr     r2
FFF34712  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34714  a901                              mov.l   1Ch+var_C[sp], r1
FFF34716  6101                              cmp     #0, r1
FFF34718  17                                beq.s   loc_FFF3471F
FFF34719  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF3471D  2e59                              bra.b   loc_FFF34776
FFF3471F  3e0300                 loc_FFF3471F mov.l   #0, 1Ch+var_10[sp]
FFF34722  2e42                              bra.b   loc_FFF34764
FFF34724  a982                   loc_FFF34724 mov.l   1Ch+var_4[sp], r2
FFF34726  710108                            add     #1Ch+var_14, sp, r1
FFF34729  39cafe                            bsr.w   sub_FFF345F3
FFF3472C  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3472E  a901                              mov.l   1Ch+var_C[sp], r1
FFF34730  6101                              cmp     #0, r1
FFF34732  17                                beq.s   loc_FFF34739
FFF34733  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF34737  2e3f                              bra.b   loc_FFF34776
FFF34739  a881                   loc_FFF34739 mov.l   1Ch+var_14[sp], r1
FFF3473B  7621001e                          and     #1E00h, r1
FFF3473F  76010008                          cmp     #800h, r1
FFF34743  1e                                bne.s   loc_FFF34749
FFF34744  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF34747  2e2f                              bra.b   loc_FFF34776
FFF34749  a981                   loc_FFF34749 mov.l   1Ch+var_4[sp], r1
FFF3474B  a819                              mov.l   4[r1], r1
FFF3474D  a891                              mov.l   8[r1], r1
FFF3474F  7f11                              jsr     r1
FFF34751  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34753  a901                              mov.l   1Ch+var_C[sp], r1
FFF34755  6101                              cmp     #0, r1
FFF34757  17                                beq.s   loc_FFF3475E
FFF34758  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF3475C  2e1a                              bra.b   loc_FFF34776
FFF3475E  a889                   loc_FFF3475E mov.l   1Ch+var_10[sp], r1
FFF34760  6211                              add     #1, r1
FFF34762  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF34764  a889                   loc_FFF34764 mov.l   1Ch+var_10[sp], r1
FFF34766  7701000004                        cmp     #40000h, r1
FFF3476B  23b9                              bltu.b  loc_FFF34724
FFF3476D  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF34771  0d                                bra.s   loc_FFF34776
FFF34772  f90601f7               loc_FFF34772 mov.l   #-9, 1Ch+var_18[sp]
FFF34776  a809                   loc_FFF34776 mov.l   1Ch+var_18[sp], r1
FFF34778  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF3477A  6707                              rtsd    #7
FFF3477C  7100e8                 sub_FFF3477C add     #-18h, sp, sp   ; <<<< FUNC sub_FFF3477C
FFF3477F  a109                              mov.l   r1, 18h+var_4[sp]
FFF34781  ec11                              mov.l   [r1], r1
FFF34783  72112102                          add     #221h, r1, r1
FFF34787  a009                              mov.l   r1, 18h+var_14[sp]
FFF34789  a909                              mov.l   18h+var_4[sp], r1
FFF3478B  39e1fe                            bsr.w   sub_FFF3466C
FFF3478E  a089                              mov.l   r1, 18h+var_C[sp]
FFF34790  a889                              mov.l   18h+var_C[sp], r1
FFF34792  6101                              cmp     #0, r1
FFF34794  17                                beq.s   loc_FFF3479B
FFF34795  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF34798  38f900                            bra.w   loc_FFF34891
FFF3479B  a909                   loc_FFF3479B mov.l   18h+var_4[sp], r1
FFF3479D  ec13                              mov.l   [r1], r3
FFF3479F  a819                              mov.l   4[r1], r1
FFF347A1  ad14                              mov.l   50h[r1], r4
FFF347A3  6612                              mov.l   #1, r2
FFF347A5  6681                              mov.l   #8, r1
FFF347A7  7f14                              jsr     r4
FFF347A9  a089                              mov.l   r1, 18h+var_C[sp]
FFF347AB  a889                              mov.l   18h+var_C[sp], r1
FFF347AD  6101                              cmp     #0, r1
FFF347AF  17                                beq.s   loc_FFF347B6
FFF347B0  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF347B3  38de00                            bra.w   loc_FFF34891
FFF347B6  3e0200                 loc_FFF347B6 mov.l   #0, 18h+var_10[sp]
FFF347B9  2e60                              bra.b   loc_FFF34819
FFF347BB  a909                   loc_FFF347BB mov.l   18h+var_4[sp], r1
FFF347BD  ec14                              mov.l   [r1], r4
FFF347BF  de435501                          mov.w   2AAh[r4], r3
FFF347C3  a819                              mov.l   4[r1], r1
FFF347C5  ac95                              mov.l   48h[r1], r5
FFF347C7  6d03                              shll    #10h, r3
FFF347C9  6602                              mov.l   #0, r2
FFF347CB  754137                            mov.l   #37h, r1 ; '7'
FFF347CE  7f15                              jsr     r5
FFF347D0  a089                              mov.l   r1, 18h+var_C[sp]
FFF347D2  a889                              mov.l   18h+var_C[sp], r1
FFF347D4  6101                              cmp     #0, r1
FFF347D6  213d                              bne.b   loc_FFF34813
FFF347D8  a909                              mov.l   18h+var_4[sp], r1
FFF347DA  ec12                              mov.l   [r1], r2
FFF347DC  a819                              mov.l   4[r1], r1
FFF347DE  ac9b                              mov.l   4Ch[r1], r3
FFF347E0  6611                              mov.l   #1, r1
FFF347E2  7f13                              jsr     r3
FFF347E4  a909                              mov.l   18h+var_4[sp], r1
FFF347E6  ec1e                              mov.l   [r1], r14
FFF347E8  fbf20880f90f                      mov.l   #0FF98008h, r15
FFF347EE  06a10cefac                        tst     2B0h[r14].l, r15
FFF347F3  17                                beq.s   loc_FFF347FA
FFF347F4  f806e9                            mov.l   #-17h, 18h+var_18[sp]
FFF347F7  389a00                            bra.w   loc_FFF34891
FFF347FA  a909                   loc_FFF347FA mov.l   18h+var_4[sp], r1
FFF347FC  ec14                              mov.l   [r1], r4
FFF347FE  a819                              mov.l   4[r1], r1
FFF34800  ac95                              mov.l   48h[r1], r5
FFF34802  6603                              mov.l   #0, r3
FFF34804  6612                              mov.l   #1, r2
FFF34806  754133                            mov.l   #33h, r1 ; '3'
FFF34809  7f15                              jsr     r5
FFF3480B  a089                              mov.l   r1, 18h+var_C[sp]
FFF3480D  a889                              mov.l   18h+var_C[sp], r1
FFF3480F  6101                              cmp     #0, r1
FFF34811  200e                              beq.b   loc_FFF3481F
FFF34813  a881                   loc_FFF34813 mov.l   18h+var_10[sp], r1
FFF34815  6211                              add     #1, r1
FFF34817  a081                              mov.l   r1, 18h+var_10[sp]
FFF34819  a881                   loc_FFF34819 mov.l   18h+var_10[sp], r1
FFF3481B  6131                              cmp     #3, r1
FFF3481D  299e                              blt.b   loc_FFF347BB
FFF3481F  a881                   loc_FFF3481F mov.l   18h+var_10[sp], r1
FFF34821  6131                              cmp     #3, r1
FFF34823  2907                              blt.b   loc_FFF3482A
FFF34825  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF34828  2e69                              bra.b   loc_FFF34891
FFF3482A  a909                   loc_FFF3482A mov.l   18h+var_4[sp], r1
FFF3482C  ec12                              mov.l   [r1], r2
FFF3482E  a819                              mov.l   4[r1], r1
FFF34830  ac9b                              mov.l   4Ch[r1], r3
FFF34832  6611                              mov.l   #1, r1
FFF34834  7f13                              jsr     r3
FFF34836  a909                              mov.l   18h+var_4[sp], r1
FFF34838  ec1e                              mov.l   [r1], r14
FFF3483A  fbf20880f90f                      mov.l   #0FF98008h, r15
FFF34840  06a10cefac                        tst     2B0h[r14].l, r15
FFF34845  16                                beq.s   loc_FFF3484B
FFF34846  f806e9                            mov.l   #-17h, 18h+var_18[sp]
FFF34849  2e48                              bra.b   loc_FFF34891
FFF3484B  a909                   loc_FFF3484B mov.l   18h+var_4[sp], r1
FFF3484D  a819                              mov.l   4[r1], r1
FFF3484F  ac1a                              mov.l   44h[r1], r2
FFF34851  6641                              mov.l   #4, r1
FFF34853  7f12                              jsr     r2
FFF34855  a089                              mov.l   r1, 18h+var_C[sp]
FFF34857  a889                              mov.l   18h+var_C[sp], r1
FFF34859  6101                              cmp     #0, r1
FFF3485B  16                                beq.s   loc_FFF34861
FFF3485C  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF3485F  2e32                              bra.b   loc_FFF34891
FFF34861  a909                   loc_FFF34861 mov.l   18h+var_4[sp], r1
FFF34863  a819                              mov.l   4[r1], r1
FFF34865  ad9b                              mov.l   5Ch[r1], r3
FFF34867  a809                              mov.l   18h+var_14[sp], r1
FFF34869  6682                              mov.l   #8, r2
FFF3486B  7f13                              jsr     r3
FFF3486D  a089                              mov.l   r1, 18h+var_C[sp]
FFF3486F  a889                              mov.l   18h+var_C[sp], r1
FFF34871  6101                              cmp     #0, r1
FFF34873  16                                beq.s   loc_FFF34879
FFF34874  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF34877  2e1a                              bra.b   loc_FFF34891
FFF34879  a909                   loc_FFF34879 mov.l   18h+var_4[sp], r1
FFF3487B  a819                              mov.l   4[r1], r1
FFF3487D  ac1a                              mov.l   44h[r1], r2
FFF3487F  6621                              mov.l   #2, r1
FFF34881  7f12                              jsr     r2
FFF34883  a089                              mov.l   r1, 18h+var_C[sp]
FFF34885  a889                              mov.l   18h+var_C[sp], r1
FFF34887  6101                              cmp     #0, r1
FFF34889  15                                beq.s   loc_FFF3488E
FFF3488A  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF3488D  0c                                bra.s   loc_FFF34891
FFF3488E  f80600                 loc_FFF3488E mov.l   #0, 18h+var_18[sp]
FFF34891  ec01                   loc_FFF34891 mov.l   18h+var_18[sp], r1
FFF34893  a101                              mov.l   r1, 18h+var_8[sp]
FFF34895  6706                              rtsd    #6
FFF34897  7100e4                 sub_FFF34897 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF34897
FFF3489A  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF3489C  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF3489E  bb09                              movu.w  1Ch+var_2[sp], r1
FFF348A0  6101                              cmp     #0, r1
FFF348A2  15                                beq.s   loc_FFF348A7
FFF348A3  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF348A6  0c                                bra.s   loc_FFF348AA
FFF348A7  f80601                 loc_FFF348A7 mov.l   #1, 1Ch+var_1C[sp]
FFF348AA  ec01                   loc_FFF348AA mov.l   1Ch+var_1C[sp], r1
FFF348AC  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF348AF  6101                              cmp     #0, r1
FFF348B1  2126                              bne.b   loc_FFF348D7
FFF348B3  2e50                              bra.b   loc_FFF34903
FFF348B5  a909                   loc_FFF348B5 mov.l   1Ch+var_8[sp], r1
FFF348B7  ec14                              mov.l   [r1], r4
FFF348B9  a819                              mov.l   4[r1], r1
FFF348BB  ac95                              mov.l   48h[r1], r5
FFF348BD  6602                              mov.l   #0, r2
FFF348BF  6671                              mov.l   #7, r1
FFF348C1  ef23                              mov.l   r2, r3
FFF348C3  7f15                              jsr     r5
FFF348C5  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF348C7  a889                              mov.l   1Ch+var_10[sp], r1
FFF348C9  6101                              cmp     #0, r1
FFF348CB  1e                                bne.s   loc_FFF348D1
FFF348CC  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF348CF  2e71                              bra.b   loc_FFF34940
FFF348D1  a881                   loc_FFF348D1 mov.l   1Ch+var_14[sp], r1
FFF348D3  6211                              add     #1, r1
FFF348D5  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF348D7  a881                   loc_FFF348D7 mov.l   1Ch+var_14[sp], r1
FFF348D9  6131                              cmp     #3, r1
FFF348DB  29da                              blt.b   loc_FFF348B5
FFF348DD  f90601f7                          mov.l   #-9, 1Ch+var_18[sp]
FFF348E1  2e5f                              bra.b   loc_FFF34940
FFF348E3  a909                   loc_FFF348E3 mov.l   1Ch+var_8[sp], r1
FFF348E5  ec14                              mov.l   [r1], r4
FFF348E7  a819                              mov.l   4[r1], r1
FFF348E9  ac95                              mov.l   48h[r1], r5
FFF348EB  9b0b                              mov.w   1Ch+var_2[sp], r3
FFF348ED  6d03                              shll    #10h, r3
FFF348EF  6602                              mov.l   #0, r2
FFF348F1  6671                              mov.l   #7, r1
FFF348F3  7f15                              jsr     r5
FFF348F5  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF348F7  a889                              mov.l   1Ch+var_10[sp], r1
FFF348F9  6101                              cmp     #0, r1
FFF348FB  200e                              beq.b   loc_FFF34909
FFF348FD  a881                              mov.l   1Ch+var_14[sp], r1
FFF348FF  6211                              add     #1, r1
FFF34901  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF34903  a881                   loc_FFF34903 mov.l   1Ch+var_14[sp], r1
FFF34905  6131                              cmp     #3, r1
FFF34907  29dc                              blt.b   loc_FFF348E3
FFF34909  a881                   loc_FFF34909 mov.l   1Ch+var_14[sp], r1
FFF3490B  6131                              cmp     #3, r1
FFF3490D  2908                              blt.b   loc_FFF34915
FFF3490F  f90601f7                          mov.l   #-9, 1Ch+var_18[sp]
FFF34913  2e2d                              bra.b   loc_FFF34940
FFF34915  a909                   loc_FFF34915 mov.l   1Ch+var_8[sp], r1
FFF34917  ec12                              mov.l   [r1], r2
FFF34919  a819                              mov.l   4[r1], r1
FFF3491B  ac9b                              mov.l   4Ch[r1], r3
FFF3491D  6611                              mov.l   #1, r1
FFF3491F  7f13                              jsr     r3
FFF34921  a909                              mov.l   1Ch+var_8[sp], r1
FFF34923  ec1e                              mov.l   [r1], r14
FFF34925  5eef6301                          movu.w  2C6h[r14], r15
FFF34929  fb52187fedff                      mov.l   #unk_FFED7F18, r5
FFF3492F  fe6f5f                            mov.l   [r15, r5], r15
FFF34932  06a10cefac                        tst     2B0h[r14].l, r15
FFF34937  16                                beq.s   loc_FFF3493D
FFF34938  f90601e9                          mov.l   #-17h, 1Ch+var_18[sp]
FFF3493C  0c                                bra.s   loc_FFF34940
FFF3493D  3e0100                 loc_FFF3493D mov.l   #0, 1Ch+var_18[sp]
FFF34940  a809                   loc_FFF34940 mov.l   1Ch+var_18[sp], r1
FFF34942  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34944  6707                              rtsd    #7
FFF34946  7100ec                 sub_FFF34946 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF34946
FFF34949  a101                              mov.l   r1, 14h+var_4[sp]
FFF3494B  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF3494E  388000                            bra.w   loc_FFF349CE
FFF34951  a901                   loc_FFF34951 mov.l   14h+var_4[sp], r1
FFF34953  ec14                              mov.l   [r1], r4
FFF34955  de435501                          mov.w   2AAh[r4], r3
FFF34959  a819                              mov.l   4[r1], r1
FFF3495B  ac95                              mov.l   48h[r1], r5
FFF3495D  6d03                              shll    #10h, r3
FFF3495F  6602                              mov.l   #0, r2
FFF34961  754137                            mov.l   #37h, r1 ; '7'
FFF34964  7f15                              jsr     r5
FFF34966  a081                              mov.l   r1, 14h+var_C[sp]
FFF34968  a881                              mov.l   14h+var_C[sp], r1
FFF3496A  6101                              cmp     #0, r1
FFF3496C  215c                              bne.b   loc_FFF349C8
FFF3496E  a901                              mov.l   14h+var_4[sp], r1
FFF34970  ec12                              mov.l   [r1], r2
FFF34972  a819                              mov.l   4[r1], r1
FFF34974  ac9b                              mov.l   4Ch[r1], r3
FFF34976  6611                              mov.l   #1, r1
FFF34978  7f13                              jsr     r3
FFF3497A  a901                              mov.l   14h+var_4[sp], r1
FFF3497C  ec1e                              mov.l   [r1], r14
FFF3497E  fbf20880f90f                      mov.l   #0FF98008h, r15
FFF34984  06a10cefac                        tst     2B0h[r14].l, r15
FFF34989  16                                beq.s   loc_FFF3498F
FFF3498A  f806e9                            mov.l   #-17h, 14h+var_14[sp]
FFF3498D  2e4d                              bra.b   loc_FFF349DA
FFF3498F  a901                   loc_FFF3498F mov.l   14h+var_4[sp], r1
FFF34991  ec14                              mov.l   [r1], r4
FFF34993  5e435601                          movu.w  2ACh[r4], r3
FFF34997  a819                              mov.l   4[r1], r1
FFF34999  ac95                              mov.l   48h[r1], r5
FFF3499B  6612                              mov.l   #1, r2
FFF3499D  6661                              mov.l   #6, r1
FFF3499F  7f15                              jsr     r5
FFF349A1  a081                              mov.l   r1, 14h+var_C[sp]
FFF349A3  a881                              mov.l   14h+var_C[sp], r1
FFF349A5  6101                              cmp     #0, r1
FFF349A7  2121                              bne.b   loc_FFF349C8
FFF349A9  a901                              mov.l   14h+var_4[sp], r1
FFF349AB  ec12                              mov.l   [r1], r2
FFF349AD  a819                              mov.l   4[r1], r1
FFF349AF  ac9b                              mov.l   4Ch[r1], r3
FFF349B1  6611                              mov.l   #1, r1
FFF349B3  7f13                              jsr     r3
FFF349B5  a902                              mov.l   14h+var_4[sp], r2
FFF349B7  ec2e                              mov.l   [r2], r14
FFF349B9  5ee15601                          movu.w  2ACh[r14], r1
FFF349BD  a82a                              mov.l   4[r2], r2
FFF349BF  aaaa                              mov.l   2Ch[r2], r2
FFF349C1  7f12                              jsr     r2
FFF349C3  f80600                            mov.l   #0, 14h+var_14[sp]
FFF349C6  2e14                              bra.b   loc_FFF349DA
FFF349C8  a809                   loc_FFF349C8 mov.l   14h+var_10[sp], r1
FFF349CA  6211                              add     #1, r1
FFF349CC  a009                              mov.l   r1, 14h+var_10[sp]
FFF349CE  a809                   loc_FFF349CE mov.l   14h+var_10[sp], r1
FFF349D0  6131                              cmp     #3, r1
FFF349D2  2805                              bge.b   loc_FFF349D7
FFF349D4  387dff                            bra.w   loc_FFF34951
FFF349D7  f806f7                 loc_FFF349D7 mov.l   #-9, 14h+var_14[sp]
FFF349DA  ec01                   loc_FFF349DA mov.l   14h+var_14[sp], r1
FFF349DC  a089                              mov.l   r1, 14h+var_8[sp]
FFF349DE  6705                              rtsd    #5
FFF349E0  7100e8                 sub_FFF349E0 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF349E0
FFF349E3  a109                              mov.l   r1, 18h+var_4[sp]
FFF349E5  ec11                              mov.l   [r1], r1
FFF349E7  72112902                          add     #229h, r1, r1
FFF349EB  a009                              mov.l   r1, 18h+var_14[sp]
FFF349ED  a909                              mov.l   18h+var_4[sp], r1
FFF349EF  397dfc                            bsr.w   sub_FFF3466C
FFF349F2  a089                              mov.l   r1, 18h+var_C[sp]
FFF349F4  a889                              mov.l   18h+var_C[sp], r1
FFF349F6  6101                              cmp     #0, r1
FFF349F8  17                                beq.s   loc_FFF349FF
FFF349F9  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF349FC  38fa00                            bra.w   loc_FFF34AF6
FFF349FF  a909                   loc_FFF349FF mov.l   18h+var_4[sp], r1
FFF34A01  ec13                              mov.l   [r1], r3
FFF34A03  a819                              mov.l   4[r1], r1
FFF34A05  ad14                              mov.l   50h[r1], r4
FFF34A07  6612                              mov.l   #1, r2
FFF34A09  754140                            mov.l   #40h, r1 ; '@'
FFF34A0C  7f14                              jsr     r4
FFF34A0E  a089                              mov.l   r1, 18h+var_C[sp]
FFF34A10  a889                              mov.l   18h+var_C[sp], r1
FFF34A12  6101                              cmp     #0, r1
FFF34A14  17                                beq.s   loc_FFF34A1B
FFF34A15  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF34A18  38de00                            bra.w   loc_FFF34AF6
FFF34A1B  3e0200                 loc_FFF34A1B mov.l   #0, 18h+var_10[sp]
FFF34A1E  2e5f                              bra.b   loc_FFF34A7D
FFF34A20  a909                   loc_FFF34A20 mov.l   18h+var_4[sp], r1
FFF34A22  ec14                              mov.l   [r1], r4
FFF34A24  de435501                          mov.w   2AAh[r4], r3
FFF34A28  a819                              mov.l   4[r1], r1
FFF34A2A  ac95                              mov.l   48h[r1], r5
FFF34A2C  6d03                              shll    #10h, r3
FFF34A2E  6602                              mov.l   #0, r2
FFF34A30  754137                            mov.l   #37h, r1 ; '7'
FFF34A33  7f15                              jsr     r5
FFF34A35  a089                              mov.l   r1, 18h+var_C[sp]
FFF34A37  a889                              mov.l   18h+var_C[sp], r1
FFF34A39  6101                              cmp     #0, r1
FFF34A3B  213c                              bne.b   loc_FFF34A77
FFF34A3D  a909                              mov.l   18h+var_4[sp], r1
FFF34A3F  ec12                              mov.l   [r1], r2
FFF34A41  a819                              mov.l   4[r1], r1
FFF34A43  ac9b                              mov.l   4Ch[r1], r3
FFF34A45  6611                              mov.l   #1, r1
FFF34A47  7f13                              jsr     r3
FFF34A49  a909                              mov.l   18h+var_4[sp], r1
FFF34A4B  ec1e                              mov.l   [r1], r14
FFF34A4D  fbf20880f90f                      mov.l   #0FF98008h, r15
FFF34A53  06a10cefac                        tst     2B0h[r14].l, r15
FFF34A58  17                                beq.s   loc_FFF34A5F
FFF34A59  f806e9                            mov.l   #-17h, 18h+var_18[sp]
FFF34A5C  389a00                            bra.w   loc_FFF34AF6
FFF34A5F  a909                   loc_FFF34A5F mov.l   18h+var_4[sp], r1
FFF34A61  ec14                              mov.l   [r1], r4
FFF34A63  a819                              mov.l   4[r1], r1
FFF34A65  ac95                              mov.l   48h[r1], r5
FFF34A67  6603                              mov.l   #0, r3
FFF34A69  6612                              mov.l   #1, r2
FFF34A6B  66d1                              mov.l   #0Dh, r1
FFF34A6D  7f15                              jsr     r5
FFF34A6F  a089                              mov.l   r1, 18h+var_C[sp]
FFF34A71  a889                              mov.l   18h+var_C[sp], r1
FFF34A73  6101                              cmp     #0, r1
FFF34A75  200e                              beq.b   loc_FFF34A83
FFF34A77  a881                   loc_FFF34A77 mov.l   18h+var_10[sp], r1
FFF34A79  6211                              add     #1, r1
FFF34A7B  a081                              mov.l   r1, 18h+var_10[sp]
FFF34A7D  a881                   loc_FFF34A7D mov.l   18h+var_10[sp], r1
FFF34A7F  6131                              cmp     #3, r1
FFF34A81  299f                              blt.b   loc_FFF34A20
FFF34A83  a881                   loc_FFF34A83 mov.l   18h+var_10[sp], r1
FFF34A85  6131                              cmp     #3, r1
FFF34A87  2907                              blt.b   loc_FFF34A8E
FFF34A89  f806f7                            mov.l   #-9, 18h+var_18[sp]
FFF34A8C  2e6a                              bra.b   loc_FFF34AF6
FFF34A8E  a909                   loc_FFF34A8E mov.l   18h+var_4[sp], r1
FFF34A90  ec12                              mov.l   [r1], r2
FFF34A92  a819                              mov.l   4[r1], r1
FFF34A94  ac9b                              mov.l   4Ch[r1], r3
FFF34A96  6611                              mov.l   #1, r1
FFF34A98  7f13                              jsr     r3
FFF34A9A  a909                              mov.l   18h+var_4[sp], r1
FFF34A9C  ec1e                              mov.l   [r1], r14
FFF34A9E  fbf20880f90f                      mov.l   #0FF98008h, r15
FFF34AA4  06a10cefac                        tst     2B0h[r14].l, r15
FFF34AA9  16                                beq.s   loc_FFF34AAF
FFF34AAA  f806e9                            mov.l   #-17h, 18h+var_18[sp]
FFF34AAD  2e49                              bra.b   loc_FFF34AF6
FFF34AAF  a909                   loc_FFF34AAF mov.l   18h+var_4[sp], r1
FFF34AB1  a819                              mov.l   4[r1], r1
FFF34AB3  ac1a                              mov.l   44h[r1], r2
FFF34AB5  6641                              mov.l   #4, r1
FFF34AB7  7f12                              jsr     r2
FFF34AB9  a089                              mov.l   r1, 18h+var_C[sp]
FFF34ABB  a889                              mov.l   18h+var_C[sp], r1
FFF34ABD  6101                              cmp     #0, r1
FFF34ABF  16                                beq.s   loc_FFF34AC5
FFF34AC0  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF34AC3  2e33                              bra.b   loc_FFF34AF6
FFF34AC5  a909                   loc_FFF34AC5 mov.l   18h+var_4[sp], r1
FFF34AC7  a819                              mov.l   4[r1], r1
FFF34AC9  ad9b                              mov.l   5Ch[r1], r3
FFF34ACB  a809                              mov.l   18h+var_14[sp], r1
FFF34ACD  754240                            mov.l   #40h, r2 ; '@'
FFF34AD0  7f13                              jsr     r3
FFF34AD2  a089                              mov.l   r1, 18h+var_C[sp]
FFF34AD4  a889                              mov.l   18h+var_C[sp], r1
FFF34AD6  6101                              cmp     #0, r1
FFF34AD8  16                                beq.s   loc_FFF34ADE
FFF34AD9  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF34ADC  2e1a                              bra.b   loc_FFF34AF6
FFF34ADE  a909                   loc_FFF34ADE mov.l   18h+var_4[sp], r1
FFF34AE0  a819                              mov.l   4[r1], r1
FFF34AE2  ac1a                              mov.l   44h[r1], r2
FFF34AE4  6621                              mov.l   #2, r1
FFF34AE6  7f12                              jsr     r2
FFF34AE8  a089                              mov.l   r1, 18h+var_C[sp]
FFF34AEA  a889                              mov.l   18h+var_C[sp], r1
FFF34AEC  6101                              cmp     #0, r1
FFF34AEE  15                                beq.s   loc_FFF34AF3
FFF34AEF  e10003                            mov.l   18h+var_C[sp], 18h+var_18[sp]
FFF34AF2  0c                                bra.s   loc_FFF34AF6
FFF34AF3  f80600                 loc_FFF34AF3 mov.l   #0, 18h+var_18[sp]
FFF34AF6  ec01                   loc_FFF34AF6 mov.l   18h+var_18[sp], r1
FFF34AF8  a101                              mov.l   r1, 18h+var_8[sp]
FFF34AFA  6706                              rtsd    #6
FFF34AFC  7100f0                 sub_FFF34AFC add     #-10h, sp, sp   ; <<<< FUNC sub_FFF34AFC
FFF34AFF  a089                              mov.l   r1, 10h+var_4[sp]
FFF34B01  ec1e                              mov.l   [r1], r14
FFF34B03  fae5620101                        mov.w   #1, 2C4h[r14]
FFF34B08  a889                              mov.l   10h+var_4[sp], r1
FFF34B0A  ec1e                              mov.l   [r1], r14
FFF34B0C  66ff                              mov.l   #0Fh, r15
FFF34B0E  fc32ef2102                        tst     221h[r14], r15
FFF34B13  1e                                bne.s   loc_FFF34B19
FFF34B14  f80600                            mov.l   #0, 10h+var_10[sp]
FFF34B17  2e4e                              bra.b   loc_FFF34B65
FFF34B19  a889                   loc_FFF34B19 mov.l   10h+var_4[sp], r1
FFF34B1B  ec1e                              mov.l   [r1], r14
FFF34B1D  f6e60502                          btst    #6, 205h[r14].b
FFF34B21  1e                                bne.s   loc_FFF34B27
FFF34B22  f80600                            mov.l   #0, 10h+var_10[sp]
FFF34B25  2e40                              bra.b   loc_FFF34B65
FFF34B27  a889                   loc_FFF34B27 mov.l   10h+var_4[sp], r1
FFF34B29  ec1e                              mov.l   [r1], r14
FFF34B2B  5eee6001                          movu.w  2C0h[r14], r14
FFF34B2F  7c2e                              btst    #2, r14
FFF34B31  2023                              beq.b   loc_FFF34B54
FFF34B33  395001                            bsr.w   sub_FFF34C83
FFF34B36  a009                              mov.l   r1, 10h+var_C[sp]
FFF34B38  a809                              mov.l   10h+var_C[sp], r1
FFF34B3A  6101                              cmp     #0, r1
FFF34B3C  16                                beq.s   loc_FFF34B42
FFF34B3D  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF34B40  2e25                              bra.b   loc_FFF34B65
FFF34B42  a889                   loc_FFF34B42 mov.l   10h+var_4[sp], r1
FFF34B44  39a502                            bsr.w   sub_FFF34DE9
FFF34B47  a009                              mov.l   r1, 10h+var_C[sp]
FFF34B49  a809                              mov.l   10h+var_C[sp], r1
FFF34B4B  6101                              cmp     #0, r1
FFF34B4D  2015                              beq.b   loc_FFF34B62
FFF34B4F  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF34B52  2e13                              bra.b   loc_FFF34B65
FFF34B54  391700                 loc_FFF34B54 bsr.w   sub_FFF34B6B
FFF34B57  a009                              mov.l   r1, 10h+var_C[sp]
FFF34B59  a809                              mov.l   10h+var_C[sp], r1
FFF34B5B  6101                              cmp     #0, r1
FFF34B5D  15                                beq.s   loc_FFF34B62
FFF34B5E  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF34B61  0c                                bra.s   loc_FFF34B65
FFF34B62  e10001                 loc_FFF34B62 mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF34B65  ec01                   loc_FFF34B65 mov.l   10h+var_10[sp], r1
FFF34B67  a081                              mov.l   r1, 10h+var_8[sp]
FFF34B69  6704                              rtsd    #4
FFF34B6B  7100e4                 sub_FFF34B6B add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF34B6B
FFF34B6E  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF34B70  3d0500                            mov.w   #0, 1Ch+var_12[sp]
FFF34B73  a982                              mov.l   1Ch+var_4[sp], r2
FFF34B75  fb12ffffff00                      mov.l   #0FFFFFFh, r1
FFF34B7B  395305                            bsr.w   sub_FFF350CE
FFF34B7E  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34B80  a901                              mov.l   1Ch+var_C[sp], r1
FFF34B82  6101                              cmp     #0, r1
FFF34B84  10                                beq.s   loc_FFF34B8C
FFF34B85  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF34B89  38f400                            bra.w   loc_FFF34C7D
FFF34B8C  a981                   loc_FFF34B8C mov.l   1Ch+var_4[sp], r1
FFF34B8E  ec1e                              mov.l   [r1], r14
FFF34B90  f6e17602                          btst    #1, 276h[r14].b
FFF34B94  1f                                bne.s   loc_FFF34B9B
FFF34B95  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF34B98  38e500                            bra.w   loc_FFF34C7D
FFF34B9B  3e0300                 loc_FFF34B9B mov.l   #0, 1Ch+var_10[sp]
FFF34B9E  38cf00                            bra.w   loc_FFF34C6D
FFF34BA1  a982                   loc_FFF34BA1 mov.l   1Ch+var_4[sp], r2
FFF34BA3  fb12f1ffff00                      mov.l   #0FFFFF1h, r1
FFF34BA9  392505                            bsr.w   sub_FFF350CE
FFF34BAC  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34BAE  a901                              mov.l   1Ch+var_C[sp], r1
FFF34BB0  6101                              cmp     #0, r1
FFF34BB2  10                                beq.s   loc_FFF34BBA
FFF34BB3  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF34BB7  38c600                            bra.w   loc_FFF34C7D
FFF34BBA  a981                   loc_FFF34BBA mov.l   1Ch+var_4[sp], r1
FFF34BBC  ec1e                              mov.l   [r1], r14
FFF34BBE  5ae16902                          movu.b  269h[r14], r1
FFF34BC2  6c81                              shll    #8, r1
FFF34BC4  9109                              mov.w   r1, 1Ch+var_12[sp]
FFF34BC6  a981                              mov.l   1Ch+var_4[sp], r1
FFF34BC8  ec1e                              mov.l   [r1], r14
FFF34BCA  5ae16a02                          movu.b  26Ah[r14], r1
FFF34BCE  06550105                          or      1Ch+var_12[sp].w, r1
FFF34BD2  9109                              mov.w   r1, 1Ch+var_12[sp]
FFF34BD4  b909                              movu.w  1Ch+var_12[sp], r1
FFF34BD6  76012103                          cmp     #321h, r1
FFF34BDA  2908                              blt.b   loc_FFF34BE2
FFF34BDC  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF34BDF  389e00                            bra.w   loc_FFF34C7D
FFF34BE2  a981                   loc_FFF34BE2 mov.l   1Ch+var_4[sp], r1
FFF34BE4  ec1e                              mov.l   [r1], r14
FFF34BE6  5aee7a02                          movu.b  27Ah[r14], r14
FFF34BEA  611e                              cmp     #1, r14
FFF34BEC  210f                              bne.b   loc_FFF34BFB
FFF34BEE  a981                              mov.l   1Ch+var_4[sp], r1
FFF34BF0  ec1e                              mov.l   [r1], r14
FFF34BF2  f6e18602                          btst    #1, 286h[r14].b
FFF34BF6  15                                beq.s   loc_FFF34BFB
FFF34BF7  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF34BFA  0c                                bra.s   loc_FFF34BFE
FFF34BFB  f80600                 loc_FFF34BFB mov.l   #0, 1Ch+var_1C[sp]
FFF34BFE  ec01                   loc_FFF34BFE mov.l   1Ch+var_1C[sp], r1
FFF34C00  6101                              cmp     #0, r1
FFF34C02  2165                              bne.b   loc_FFF34C67
FFF34C04  a981                              mov.l   1Ch+var_4[sp], r1
FFF34C06  ec1e                              mov.l   [r1], r14
FFF34C08  5aee7902                          movu.b  279h[r14], r14
FFF34C0C  64fe                              and     #0Fh, r14
FFF34C0E  61fe                              cmp     #0Fh, r14
FFF34C10  1e                                bne.s   loc_FFF34C16
FFF34C11  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF34C14  2e69                              bra.b   loc_FFF34C7D
FFF34C16  a982                   loc_FFF34C16 mov.l   1Ch+var_4[sp], r2
FFF34C18  fb12f1ffff80                      mov.l   #-7F00000Fh, r1
FFF34C1E  39b004                            bsr.w   sub_FFF350CE
FFF34C21  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34C23  a901                              mov.l   1Ch+var_C[sp], r1
FFF34C25  6101                              cmp     #0, r1
FFF34C27  17                                beq.s   loc_FFF34C2E
FFF34C28  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF34C2C  2e51                              bra.b   loc_FFF34C7D
FFF34C2E  3c0901                 loc_FFF34C2E mov.b   #1, 1Ch+var_13[sp]
FFF34C31  a981                              mov.l   1Ch+var_4[sp], r1
FFF34C33  ec1e                              mov.l   [r1], r14
FFF34C35  5aee7902                          movu.b  279h[r14], r14
FFF34C39  64fe                              and     #0Fh, r14
FFF34C3B  450e09                            cmp     1Ch+var_13[sp], r14
FFF34C3E  a819                              mov.l   4[r1], r1
FFF34C40  2116                              bne.b   loc_FFF34C56
FFF34C42  ab12                              mov.l   30h[r1], r2
FFF34C44  6611                              mov.l   #1, r1
FFF34C46  7f12                              jsr     r2
FFF34C48  a981                              mov.l   1Ch+var_4[sp], r1
FFF34C4A  ec1e                              mov.l   [r1], r14
FFF34C4C  fae5620102                        mov.w   #2, 2C4h[r14]
FFF34C51  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF34C54  2e29                              bra.b   loc_FFF34C7D
FFF34C56  a891                   loc_FFF34C56 mov.l   8[r1], r1
FFF34C58  7f11                              jsr     r1
FFF34C5A  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF34C5C  a901                              mov.l   1Ch+var_C[sp], r1
FFF34C5E  6101                              cmp     #0, r1
FFF34C60  17                                beq.s   loc_FFF34C67
FFF34C61  e5000401                          mov.l   1Ch+var_C[sp], 1Ch+var_18[sp]
FFF34C65  2e18                              bra.b   loc_FFF34C7D
FFF34C67  a889                   loc_FFF34C67 mov.l   1Ch+var_10[sp], r1
FFF34C69  6211                              add     #1, r1
FFF34C6B  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF34C6D  a889                   loc_FFF34C6D mov.l   1Ch+var_10[sp], r1
FFF34C6F  7701000004                        cmp     #40000h, r1
FFF34C74  2205                              bgeu.b  loc_FFF34C79
FFF34C76  382bff                            bra.w   loc_FFF34BA1
FFF34C79  f90601ff               loc_FFF34C79 mov.l   #-1, 1Ch+var_18[sp]
FFF34C7D  a809                   loc_FFF34C7D mov.l   1Ch+var_18[sp], r1
FFF34C7F  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF34C81  6707                              rtsd    #7
FFF34C83  7100dc                 sub_FFF34C83 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF34C83
FFF34C86  a201                              mov.l   r1, 24h+var_4[sp]
FFF34C88  3d0900                            mov.w   #0, 24h+var_12[sp]
FFF34C8B  aa01                              mov.l   24h+var_4[sp], r1
FFF34C8D  a819                              mov.l   4[r1], r1
FFF34C8F  ab1a                              mov.l   34h[r1], r2
FFF34C91  6601                              mov.l   #0, r1
FFF34C93  7f12                              jsr     r2
FFF34C95  aa02                              mov.l   24h+var_4[sp], r2
FFF34C97  fb12ffffff00                      mov.l   #0FFFFFFh, r1
FFF34C9D  393104                            bsr.w   sub_FFF350CE
FFF34CA0  a181                              mov.l   r1, 24h+var_C[sp]
FFF34CA2  a981                              mov.l   24h+var_C[sp], r1
FFF34CA4  6101                              cmp     #0, r1
FFF34CA6  10                                beq.s   loc_FFF34CAE
FFF34CA7  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34CAB  383801                            bra.w   loc_FFF34DE3
FFF34CAE  fbe29ee8c3ff           loc_FFF34CAE mov.l   #unk_FFC3E89E, r14
FFF34CB4  58ee                              movu.b  [r14], r14
FFF34CB6  aa01                              mov.l   24h+var_4[sp], r1
FFF34CB8  ec1f                              mov.l   [r1], r15
FFF34CBA  52fe7202                          and     272h[r15], r14
FFF34CBE  5bee                              movu.b  r14, r14
FFF34CC0  610e                              cmp     #0, r14
FFF34CC2  202f                              beq.b   loc_FFF34CF1
FFF34CC4  fbe2507fedff                      mov.l   #unk_FFED7F50, r14
FFF34CCA  e4e003                            mov.l   [r14], 24h+var_18[sp]
FFF34CCD  fbe29ee8c3ff                      mov.l   #unk_FFC3E89E, r14
FFF34CD3  c4e00b                            mov.b   [r14], 24h+var_19[sp]
FFF34CD6  a889                              mov.l   24h+var_18[sp], r1
FFF34CD8  6881                              shlr    #8, r1
FFF34CDA  64f1                              and     #0Fh, r1
FFF34CDC  8281                              mov.b   r1, 24h+var_1A[sp]
FFF34CDE  aa01                              mov.l   24h+var_4[sp], r1
FFF34CE0  a819                              mov.l   4[r1], r1
FFF34CE2  a992                              mov.l   18h[r1], r2
FFF34CE4  b281                              movu.b  24h+var_1A[sp], r1
FFF34CE6  7f12                              jsr     r2
FFF34CE8  a181                              mov.l   r1, 24h+var_C[sp]
FFF34CEA  a981                              mov.l   24h+var_C[sp], r1
FFF34CEC  6101                              cmp     #0, r1
FFF34CEE  19                                bne.s   loc_FFF34CF7
FFF34CEF  2e0e                              bra.b   loc_FFF34CFD
FFF34CF1  3e0100                 loc_FFF34CF1 mov.l   #0, 24h+var_20[sp]
FFF34CF4  38ef00                            bra.w   loc_FFF34DE3
FFF34CF7  3e0100                 loc_FFF34CF7 mov.l   #0, 24h+var_20[sp]
FFF34CFA  38e900                            bra.w   loc_FFF34DE3
FFF34CFD  3e0500                 loc_FFF34CFD mov.l   #0, 24h+var_10[sp]
FFF34D00  38d300                            bra.w   loc_FFF34DD3
FFF34D03  aa01                   loc_FFF34D03 mov.l   24h+var_4[sp], r1
FFF34D05  a819                              mov.l   4[r1], r1
FFF34D07  a891                              mov.l   8[r1], r1
FFF34D09  7f11                              jsr     r1
FFF34D0B  a181                              mov.l   r1, 24h+var_C[sp]
FFF34D0D  a981                              mov.l   24h+var_C[sp], r1
FFF34D0F  6101                              cmp     #0, r1
FFF34D11  10                                beq.s   loc_FFF34D19
FFF34D12  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34D16  38cd00                            bra.w   loc_FFF34DE3
FFF34D19  aa02                   loc_FFF34D19 mov.l   24h+var_4[sp], r2
FFF34D1B  a889                              mov.l   24h+var_18[sp], r1
FFF34D1D  39b103                            bsr.w   sub_FFF350CE
FFF34D20  a181                              mov.l   r1, 24h+var_C[sp]
FFF34D22  a981                              mov.l   24h+var_C[sp], r1
FFF34D24  6101                              cmp     #0, r1
FFF34D26  10                                beq.s   loc_FFF34D2E
FFF34D27  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34D2B  38b800                            bra.w   loc_FFF34DE3
FFF34D2E  aa01                   loc_FFF34D2E mov.l   24h+var_4[sp], r1
FFF34D30  ec1e                              mov.l   [r1], r14
FFF34D32  5ae16902                          movu.b  269h[r14], r1
FFF34D36  6c81                              shll    #8, r1
FFF34D38  9209                              mov.w   r1, 24h+var_12[sp]
FFF34D3A  aa01                              mov.l   24h+var_4[sp], r1
FFF34D3C  ec1e                              mov.l   [r1], r14
FFF34D3E  5ae16a02                          movu.b  26Ah[r14], r1
FFF34D42  06550109                          or      24h+var_12[sp].w, r1
FFF34D46  9209                              mov.w   r1, 24h+var_12[sp]
FFF34D48  ba09                              movu.w  24h+var_12[sp], r1
FFF34D4A  76012103                          cmp     #321h, r1
FFF34D4E  2908                              blt.b   loc_FFF34D56
FFF34D50  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF34D53  389000                            bra.w   loc_FFF34DE3
FFF34D56  aa01                   loc_FFF34D56 mov.l   24h+var_4[sp], r1
FFF34D58  ec1e                              mov.l   [r1], r14
FFF34D5A  5aee7a02                          movu.b  27Ah[r14], r14
FFF34D5E  611e                              cmp     #1, r14
FFF34D60  2116                              bne.b   loc_FFF34D76
FFF34D62  aa01                              mov.l   24h+var_4[sp], r1
FFF34D64  ec1e                              mov.l   [r1], r14
FFF34D66  5aee8202                          movu.b  282h[r14], r14
FFF34D6A  510e0b                            and     24h+var_19[sp], r14
FFF34D6D  5bee                              movu.b  r14, r14
FFF34D6F  610e                              cmp     #0, r14
FFF34D71  15                                beq.s   loc_FFF34D76
FFF34D72  f80601                            mov.l   #1, 24h+var_24[sp]
FFF34D75  0c                                bra.s   loc_FFF34D79
FFF34D76  f80600                 loc_FFF34D76 mov.l   #0, 24h+var_24[sp]
FFF34D79  ec01                   loc_FFF34D79 mov.l   24h+var_24[sp], r1
FFF34D7B  6101                              cmp     #0, r1
FFF34D7D  2150                              bne.b   loc_FFF34DCD
FFF34D7F  aa01                              mov.l   24h+var_4[sp], r1
FFF34D81  ec1e                              mov.l   [r1], r14
FFF34D83  5aee7802                          movu.b  278h[r14], r14
FFF34D87  64fe                              and     #0Fh, r14
FFF34D89  61fe                              cmp     #0Fh, r14
FFF34D8B  1e                                bne.s   loc_FFF34D91
FFF34D8C  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF34D8F  2e54                              bra.b   loc_FFF34DE3
FFF34D91  aa02                   loc_FFF34D91 mov.l   24h+var_4[sp], r2
FFF34D93  a889                              mov.l   24h+var_18[sp], r1
FFF34D95  79f1                              bset    #1Fh, r1
FFF34D97  393703                            bsr.w   sub_FFF350CE
FFF34D9A  a181                              mov.l   r1, 24h+var_C[sp]
FFF34D9C  a981                              mov.l   24h+var_C[sp], r1
FFF34D9E  6101                              cmp     #0, r1
FFF34DA0  17                                beq.s   loc_FFF34DA7
FFF34DA1  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34DA5  2e3e                              bra.b   loc_FFF34DE3
FFF34DA7  a889                   loc_FFF34DA7 mov.l   24h+var_18[sp], r1
FFF34DA9  6881                              shlr    #8, r1
FFF34DAB  64f1                              and     #0Fh, r1
FFF34DAD  8281                              mov.b   r1, 24h+var_1A[sp]
FFF34DAF  aa01                              mov.l   24h+var_4[sp], r1
FFF34DB1  ec1e                              mov.l   [r1], r14
FFF34DB3  5aee7802                          movu.b  278h[r14], r14
FFF34DB7  64fe                              and     #0Fh, r14
FFF34DB9  450e0a                            cmp     24h+var_1A[sp], r14
FFF34DBC  2111                              bne.b   loc_FFF34DCD
FFF34DBE  aa01                              mov.l   24h+var_4[sp], r1
FFF34DC0  a819                              mov.l   4[r1], r1
FFF34DC2  ab1a                              mov.l   34h[r1], r2
FFF34DC4  6601                              mov.l   #0, r1
FFF34DC6  7f12                              jsr     r2
FFF34DC8  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF34DCB  2e18                              bra.b   loc_FFF34DE3
FFF34DCD  a909                   loc_FFF34DCD mov.l   24h+var_10[sp], r1
FFF34DCF  6211                              add     #1, r1
FFF34DD1  a109                              mov.l   r1, 24h+var_10[sp]
FFF34DD3  a909                   loc_FFF34DD3 mov.l   24h+var_10[sp], r1
FFF34DD5  7701000004                        cmp     #40000h, r1
FFF34DDA  2205                              bgeu.b  loc_FFF34DDF
FFF34DDC  3827ff                            bra.w   loc_FFF34D03
FFF34DDF  f90601ff               loc_FFF34DDF mov.l   #-1, 24h+var_20[sp]
FFF34DE3  a809                   loc_FFF34DE3 mov.l   24h+var_20[sp], r1
FFF34DE5  a189                              mov.l   r1, 24h+var_8[sp]
FFF34DE7  6709                              rtsd    #9
FFF34DE9  7100dc                 sub_FFF34DE9 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF34DE9
FFF34DEC  a201                              mov.l   r1, 24h+var_4[sp]
FFF34DEE  3d0900                            mov.w   #0, 24h+var_12[sp]
FFF34DF1  aa01                              mov.l   24h+var_4[sp], r1
FFF34DF3  a819                              mov.l   4[r1], r1
FFF34DF5  ab9a                              mov.l   3Ch[r1], r2
FFF34DF7  6601                              mov.l   #0, r1
FFF34DF9  7f12                              jsr     r2
FFF34DFB  aa02                              mov.l   24h+var_4[sp], r2
FFF34DFD  fb12ffffff00                      mov.l   #0FFFFFFh, r1
FFF34E03  39cb02                            bsr.w   sub_FFF350CE
FFF34E06  a181                              mov.l   r1, 24h+var_C[sp]
FFF34E08  a981                              mov.l   24h+var_C[sp], r1
FFF34E0A  6101                              cmp     #0, r1
FFF34E0C  10                                beq.s   loc_FFF34E14
FFF34E0D  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34E11  38b702                            bra.w   loc_FFF350C8
FFF34E14  f90203f03fff00         loc_FFF34E14 mov.l   #0FF3FF0h, 24h+var_18[sp]
FFF34E1B  3c0b08                            mov.b   #8, 24h+var_19[sp]
FFF34E1E  aa01                              mov.l   24h+var_4[sp], r1
FFF34E20  ec1e                              mov.l   [r1], r14
FFF34E22  f6e37602                          btst    #3, 276h[r14].b
FFF34E26  2011                              beq.b   loc_FFF34E37
FFF34E28  a889                              mov.l   24h+var_18[sp], r1
FFF34E2A  7431f30fff00                      or      #0FF0FF3h, r1
FFF34E30  a089                              mov.l   r1, 24h+var_18[sp]
FFF34E32  3c0a08                            mov.b   #8, 24h+var_1A[sp]
FFF34E35  2e4f                              bra.b   loc_FFF34E84
FFF34E37  aa01                   loc_FFF34E37 mov.l   24h+var_4[sp], r1
FFF34E39  ec1e                              mov.l   [r1], r14
FFF34E3B  f6e47602                          btst    #4, 276h[r14].b
FFF34E3F  2011                              beq.b   loc_FFF34E50
FFF34E41  a889                              mov.l   24h+var_18[sp], r1
FFF34E43  7431f40fff00                      or      #0FF0FF4h, r1
FFF34E49  a089                              mov.l   r1, 24h+var_18[sp]
FFF34E4B  3c0a10                            mov.b   #10h, 24h+var_1A[sp]
FFF34E4E  2e36                              bra.b   loc_FFF34E84
FFF34E50  aa01                   loc_FFF34E50 mov.l   24h+var_4[sp], r1
FFF34E52  ec1e                              mov.l   [r1], r14
FFF34E54  f6e27602                          btst    #2, 276h[r14].b
FFF34E58  2011                              beq.b   loc_FFF34E69
FFF34E5A  a889                              mov.l   24h+var_18[sp], r1
FFF34E5C  7431f20fff00                      or      #0FF0FF2h, r1
FFF34E62  a089                              mov.l   r1, 24h+var_18[sp]
FFF34E64  3c0a04                            mov.b   #4, 24h+var_1A[sp]
FFF34E67  2e1d                              bra.b   loc_FFF34E84
FFF34E69  aa01                   loc_FFF34E69 mov.l   24h+var_4[sp], r1
FFF34E6B  ec1e                              mov.l   [r1], r14
FFF34E6D  f6e17602                          btst    #1, 276h[r14].b
FFF34E71  200d                              beq.b   loc_FFF34E7E
FFF34E73  f90203f1ffff00                    mov.l   #0FFFFF1h, 24h+var_18[sp]
FFF34E7A  3c0a02                            mov.b   #2, 24h+var_1A[sp]
FFF34E7D  0f                                bra.s   loc_FFF34E84
FFF34E7E  3e0100                 loc_FFF34E7E mov.l   #0, 24h+var_20[sp]
FFF34E81  384702                            bra.w   loc_FFF350C8
FFF34E84  3e0500                 loc_FFF34E84 mov.l   #0, 24h+var_10[sp]
FFF34E87  383102                            bra.w   loc_FFF350B8
FFF34E8A  aa01                   loc_FFF34E8A mov.l   24h+var_4[sp], r1
FFF34E8C  a819                              mov.l   4[r1], r1
FFF34E8E  a891                              mov.l   8[r1], r1
FFF34E90  7f11                              jsr     r1
FFF34E92  a181                              mov.l   r1, 24h+var_C[sp]
FFF34E94  a981                              mov.l   24h+var_C[sp], r1
FFF34E96  6101                              cmp     #0, r1
FFF34E98  10                                beq.s   loc_FFF34EA0
FFF34E99  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34E9D  382b02                            bra.w   loc_FFF350C8
FFF34EA0  aa02                   loc_FFF34EA0 mov.l   24h+var_4[sp], r2
FFF34EA2  a889                              mov.l   24h+var_18[sp], r1
FFF34EA4  392a02                            bsr.w   sub_FFF350CE
FFF34EA7  a181                              mov.l   r1, 24h+var_C[sp]
FFF34EA9  a981                              mov.l   24h+var_C[sp], r1
FFF34EAB  6101                              cmp     #0, r1
FFF34EAD  10                                beq.s   loc_FFF34EB5
FFF34EAE  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34EB2  381602                            bra.w   loc_FFF350C8
FFF34EB5  a889                   loc_FFF34EB5 mov.l   24h+var_18[sp], r1
FFF34EB7  64f1                              and     #0Fh, r1
FFF34EB9  8209                              mov.b   r1, 24h+var_1B[sp]
FFF34EBB  aa01                              mov.l   24h+var_4[sp], r1
FFF34EBD  a819                              mov.l   4[r1], r1
FFF34EBF  a99a                              mov.l   1Ch[r1], r2
FFF34EC1  b209                              movu.b  24h+var_1B[sp], r1
FFF34EC3  7f12                              jsr     r2
FFF34EC5  a181                              mov.l   r1, 24h+var_C[sp]
FFF34EC7  aa01                              mov.l   24h+var_4[sp], r1
FFF34EC9  ec1e                              mov.l   [r1], r14
FFF34ECB  5ae16902                          movu.b  269h[r14], r1
FFF34ECF  6c81                              shll    #8, r1
FFF34ED1  9209                              mov.w   r1, 24h+var_12[sp]
FFF34ED3  aa01                              mov.l   24h+var_4[sp], r1
FFF34ED5  ec1e                              mov.l   [r1], r14
FFF34ED7  5ae16a02                          movu.b  26Ah[r14], r1
FFF34EDB  06550109                          or      24h+var_12[sp].w, r1
FFF34EDF  9209                              mov.w   r1, 24h+var_12[sp]
FFF34EE1  ba09                              movu.w  24h+var_12[sp], r1
FFF34EE3  76012003                          cmp     #320h, r1
FFF34EE7  2a07                              bgt.b   loc_FFF34EEE
FFF34EE9  a981                              mov.l   24h+var_C[sp], r1
FFF34EEB  6101                              cmp     #0, r1
FFF34EED  15                                beq.s   loc_FFF34EF2
FFF34EEE  f80601                 loc_FFF34EEE mov.l   #1, 24h+var_24[sp]
FFF34EF1  0c                                bra.s   loc_FFF34EF5
FFF34EF2  f80600                 loc_FFF34EF2 mov.l   #0, 24h+var_24[sp]
FFF34EF5  ec01                   loc_FFF34EF5 mov.l   24h+var_24[sp], r1
FFF34EF7  6101                              cmp     #0, r1
FFF34EF9  204d                              beq.b   loc_FFF34F46
FFF34EFB  b209                              movu.b  24h+var_1B[sp], r1
FFF34EFD  6141                              cmp     #4, r1
FFF34EFF  2029                              beq.b   loc_FFF34F28
FFF34F01  6131                              cmp     #3, r1
FFF34F03  200c                              beq.b   loc_FFF34F0F
FFF34F05  6111                              cmp     #1, r1
FFF34F07  2130                              bne.b   loc_FFF34F37
FFF34F09  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF34F0C  38bc01                            bra.w   loc_FFF350C8
FFF34F0F  aa01                   loc_FFF34F0F mov.l   24h+var_4[sp], r1
FFF34F11  ec1e                              mov.l   [r1], r14
FFF34F13  f6e47602                          btst    #4, 276h[r14].b
FFF34F17  2020                              beq.b   loc_FFF34F37
FFF34F19  a889                              mov.l   24h+var_18[sp], r1
FFF34F1B  6211                              add     #1, r1
FFF34F1D  a089                              mov.l   r1, 24h+var_18[sp]
FFF34F1F  b281                              movu.b  24h+var_1A[sp], r1
FFF34F21  6c11                              shll    #1, r1
FFF34F23  8281                              mov.b   r1, 24h+var_1A[sp]
FFF34F25  388d01                            bra.w   loc_FFF350B2
FFF34F28  a889                   loc_FFF34F28 mov.l   24h+var_18[sp], r1
FFF34F2A  6021                              sub     #2, r1
FFF34F2C  a089                              mov.l   r1, 24h+var_18[sp]
FFF34F2E  b281                              movu.b  24h+var_1A[sp], r1
FFF34F30  6821                              shlr    #2, r1
FFF34F32  8281                              mov.b   r1, 24h+var_1A[sp]
FFF34F34  387e01                            bra.w   loc_FFF350B2
FFF34F37  a889                   loc_FFF34F37 mov.l   24h+var_18[sp], r1
FFF34F39  6011                              sub     #1, r1
FFF34F3B  a089                              mov.l   r1, 24h+var_18[sp]
FFF34F3D  b281                              movu.b  24h+var_1A[sp], r1
FFF34F3F  6811                              shlr    #1, r1
FFF34F41  8281                              mov.b   r1, 24h+var_1A[sp]
FFF34F43  386f01                            bra.w   loc_FFF350B2
FFF34F46  aa01                   loc_FFF34F46 mov.l   24h+var_4[sp], r1
FFF34F48  ec1e                              mov.l   [r1], r14
FFF34F4A  5aee7a02                          movu.b  27Ah[r14], r14
FFF34F4E  611e                              cmp     #1, r14
FFF34F50  2116                              bne.b   loc_FFF34F66
FFF34F52  aa01                              mov.l   24h+var_4[sp], r1
FFF34F54  ec1e                              mov.l   [r1], r14
FFF34F56  5aee8602                          movu.b  286h[r14], r14
FFF34F5A  510e0a                            and     24h+var_1A[sp], r14
FFF34F5D  5bee                              movu.b  r14, r14
FFF34F5F  610e                              cmp     #0, r14
FFF34F61  15                                beq.s   loc_FFF34F66
FFF34F62  f80601                            mov.l   #1, 24h+var_24[sp]
FFF34F65  0c                                bra.s   loc_FFF34F69
FFF34F66  f80600                 loc_FFF34F66 mov.l   #0, 24h+var_24[sp]
FFF34F69  ec01                   loc_FFF34F69 mov.l   24h+var_24[sp], r1
FFF34F6B  6101                              cmp     #0, r1
FFF34F6D  3b4501                            bne.w   loc_FFF350B2
FFF34F70  a889                              mov.l   24h+var_18[sp], r1
FFF34F72  7401f1ffff00                      cmp     #0FFFFF1h, r1
FFF34F78  202c                              beq.b   loc_FFF34FA4
FFF34F7A  aa01                              mov.l   24h+var_4[sp], r1
FFF34F7C  ec1e                              mov.l   [r1], r14
FFF34F7E  5aee7a02                          movu.b  27Ah[r14], r14
FFF34F82  611e                              cmp     #1, r14
FFF34F84  2116                              bne.b   loc_FFF34F9A
FFF34F86  aa01                              mov.l   24h+var_4[sp], r1
FFF34F88  ec1e                              mov.l   [r1], r14
FFF34F8A  5aee8002                          movu.b  280h[r14], r14
FFF34F8E  510e0b                            and     24h+var_19[sp], r14
FFF34F91  5bee                              movu.b  r14, r14
FFF34F93  610e                              cmp     #0, r14
FFF34F95  15                                beq.s   loc_FFF34F9A
FFF34F96  f80601                            mov.l   #1, 24h+var_24[sp]
FFF34F99  0c                                bra.s   loc_FFF34F9D
FFF34F9A  f80600                 loc_FFF34F9A mov.l   #0, 24h+var_24[sp]
FFF34F9D  ec01                   loc_FFF34F9D mov.l   24h+var_24[sp], r1
FFF34F9F  6101                              cmp     #0, r1
FFF34FA1  3b1101                            bne.w   loc_FFF350B2
FFF34FA4  aa01                   loc_FFF34FA4 mov.l   24h+var_4[sp], r1
FFF34FA6  ec1e                              mov.l   [r1], r14
FFF34FA8  5aee7902                          movu.b  279h[r14], r14
FFF34FAC  64fe                              and     #0Fh, r14
FFF34FAE  61fe                              cmp     #0Fh, r14
FFF34FB0  1f                                bne.s   loc_FFF34FB7
FFF34FB1  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF34FB4  381401                            bra.w   loc_FFF350C8
FFF34FB7  aa01                   loc_FFF34FB7 mov.l   24h+var_4[sp], r1
FFF34FB9  ec1e                              mov.l   [r1], r14
FFF34FBB  5aee7802                          movu.b  278h[r14], r14
FFF34FBF  684e                              shlr    #4, r14
FFF34FC1  61fe                              cmp     #0Fh, r14
FFF34FC3  1f                                bne.s   loc_FFF34FCA
FFF34FC4  3e0100                            mov.l   #0, 24h+var_20[sp]
FFF34FC7  380101                            bra.w   loc_FFF350C8
FFF34FCA  aa02                   loc_FFF34FCA mov.l   24h+var_4[sp], r2
FFF34FCC  a889                              mov.l   24h+var_18[sp], r1
FFF34FCE  79f1                              bset    #1Fh, r1
FFF34FD0  39fe00                            bsr.w   sub_FFF350CE
FFF34FD3  a181                              mov.l   r1, 24h+var_C[sp]
FFF34FD5  a981                              mov.l   24h+var_C[sp], r1
FFF34FD7  6101                              cmp     #0, r1
FFF34FD9  10                                beq.s   loc_FFF34FE1
FFF34FDA  e5000601                          mov.l   24h+var_C[sp], 24h+var_20[sp]
FFF34FDE  38ea00                            bra.w   loc_FFF350C8
FFF34FE1  a889                   loc_FFF34FE1 mov.l   24h+var_18[sp], r1
FFF34FE3  64f1                              and     #0Fh, r1
FFF34FE5  8209                              mov.b   r1, 24h+var_1B[sp]
FFF34FE7  aa01                              mov.l   24h+var_4[sp], r1
FFF34FE9  ec1e                              mov.l   [r1], r14
FFF34FEB  5aee7902                          movu.b  279h[r14], r14
FFF34FEF  64fe                              and     #0Fh, r14
FFF34FF1  450e09                            cmp     24h+var_1B[sp], r14
FFF34FF4  3bbe00                            bne.w   loc_FFF350B2
FFF34FF7  a889                              mov.l   24h+var_18[sp], r1
FFF34FF9  7401f1ffff00                      cmp     #0FFFFF1h, r1
FFF34FFF  201a                              beq.b   loc_FFF35019
FFF35001  a889                              mov.l   24h+var_18[sp], r1
FFF35003  68c1                              shlr    #0Ch, r1
FFF35005  64f1                              and     #0Fh, r1
FFF35007  8209                              mov.b   r1, 24h+var_1B[sp]
FFF35009  aa01                              mov.l   24h+var_4[sp], r1
FFF3500B  ec1e                              mov.l   [r1], r14
FFF3500D  5aee7802                          movu.b  278h[r14], r14
FFF35011  684e                              shlr    #4, r14
FFF35013  450e09                            cmp     24h+var_1B[sp], r14
FFF35016  3b9c00                            bne.w   loc_FFF350B2
FFF35019  aa01                   loc_FFF35019 mov.l   24h+var_4[sp], r1
FFF3501B  ec1e                              mov.l   [r1], r14
FFF3501D  5ae17902                          movu.b  279h[r14], r1
FFF35021  64f1                              and     #0Fh, r1
FFF35023  8209                              mov.b   r1, 24h+var_1B[sp]
FFF35025  b209                              movu.b  24h+var_1B[sp], r1
FFF35027  6141                              cmp     #4, r1
FFF35029  2068                              beq.b   loc_FFF35091
FFF3502B  6121                              cmp     #2, r1
FFF3502D  2028                              beq.b   loc_FFF35055
FFF3502F  6131                              cmp     #3, r1
FFF35031  2042                              beq.b   loc_FFF35073
FFF35033  6111                              cmp     #1, r1
FFF35035  217d                              bne.b   loc_FFF350B2
FFF35037  aa01                              mov.l   24h+var_4[sp], r1
FFF35039  a819                              mov.l   4[r1], r1
FFF3503B  ab9a                              mov.l   3Ch[r1], r2
FFF3503D  6611                              mov.l   #1, r1
FFF3503F  7f12                              jsr     r2
FFF35041  aa01                              mov.l   24h+var_4[sp], r1
FFF35043  ec1e                              mov.l   [r1], r14
FFF35045  fae5610101                        mov.w   #1, 2C2h[r14]
FFF3504A  aa01                              mov.l   24h+var_4[sp], r1
FFF3504C  ec1e                              mov.l   [r1], r14
FFF3504E  fae5620102                        mov.w   #2, 2C4h[r14]
FFF35053  2e5a                              bra.b   loc_FFF350AD
FFF35055  aa01                   loc_FFF35055 mov.l   24h+var_4[sp], r1
FFF35057  a819                              mov.l   4[r1], r1
FFF35059  ab9a                              mov.l   3Ch[r1], r2
FFF3505B  6621                              mov.l   #2, r1
FFF3505D  7f12                              jsr     r2
FFF3505F  aa01                              mov.l   24h+var_4[sp], r1
FFF35061  ec1e                              mov.l   [r1], r14
FFF35063  fae5610102                        mov.w   #2, 2C2h[r14]
FFF35068  aa01                              mov.l   24h+var_4[sp], r1
FFF3506A  ec1e                              mov.l   [r1], r14
FFF3506C  fae5620103                        mov.w   #3, 2C4h[r14]
FFF35071  2e3c                              bra.b   loc_FFF350AD
FFF35073  aa01                   loc_FFF35073 mov.l   24h+var_4[sp], r1
FFF35075  a819                              mov.l   4[r1], r1
FFF35077  ab9a                              mov.l   3Ch[r1], r2
FFF35079  6631                              mov.l   #3, r1
FFF3507B  7f12                              jsr     r2
FFF3507D  aa01                              mov.l   24h+var_4[sp], r1
FFF3507F  ec1e                              mov.l   [r1], r14
FFF35081  fae5610103                        mov.w   #3, 2C2h[r14]
FFF35086  aa01                              mov.l   24h+var_4[sp], r1
FFF35088  ec1e                              mov.l   [r1], r14
FFF3508A  fae5620104                        mov.w   #4, 2C4h[r14]
FFF3508F  2e1e                              bra.b   loc_FFF350AD
FFF35091  aa01                   loc_FFF35091 mov.l   24h+var_4[sp], r1
FFF35093  a819                              mov.l   4[r1], r1
FFF35095  ab9a                              mov.l   3Ch[r1], r2
FFF35097  6641                              mov.l   #4, r1
FFF35099  7f12                              jsr     r2
FFF3509B  aa01                              mov.l   24h+var_4[sp], r1
FFF3509D  ec1e                              mov.l   [r1], r14
FFF3509F  fae5610104                        mov.w   #4, 2C2h[r14]
FFF350A4  aa01                              mov.l   24h+var_4[sp], r1
FFF350A6  ec1e                              mov.l   [r1], r14
FFF350A8  fae5620102                        mov.w   #2, 2C4h[r14]
FFF350AD  3e0100                 loc_FFF350AD mov.l   #0, 24h+var_20[sp]
FFF350B0  2e18                              bra.b   loc_FFF350C8
FFF350B2  a909                   loc_FFF350B2 mov.l   24h+var_10[sp], r1
FFF350B4  6211                              add     #1, r1
FFF350B6  a109                              mov.l   r1, 24h+var_10[sp]
FFF350B8  a909                   loc_FFF350B8 mov.l   24h+var_10[sp], r1
FFF350BA  7701000004                        cmp     #40000h, r1
FFF350BF  2205                              bgeu.b  loc_FFF350C4
FFF350C1  38c9fd                            bra.w   loc_FFF34E8A
FFF350C4  f90601ff               loc_FFF350C4 mov.l   #-1, 24h+var_20[sp]
FFF350C8  a809                   loc_FFF350C8 mov.l   24h+var_20[sp], r1
FFF350CA  a189                              mov.l   r1, 24h+var_8[sp]
FFF350CC  6709                              rtsd    #9
FFF350CE  7100e4                 sub_FFF350CE add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF350CE
FFF350D1  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF350D3  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF350D5  ec21                              mov.l   [r2], r1
FFF350D7  72116902                          add     #269h, r1, r1
FFF350DB  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF350DD  a909                              mov.l   1Ch+var_8[sp], r1
FFF350DF  398df5                            bsr.w   sub_FFF3466C
FFF350E2  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF350E4  a889                              mov.l   1Ch+var_10[sp], r1
FFF350E6  6101                              cmp     #0, r1
FFF350E8  17                                beq.s   loc_FFF350EF
FFF350E9  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF350EC  38bb00                            bra.w   loc_FFF351A7
FFF350EF  a909                   loc_FFF350EF mov.l   1Ch+var_8[sp], r1
FFF350F1  ec13                              mov.l   [r1], r3
FFF350F3  a819                              mov.l   4[r1], r1
FFF350F5  ad14                              mov.l   50h[r1], r4
FFF350F7  6612                              mov.l   #1, r2
FFF350F9  754140                            mov.l   #40h, r1 ; '@'
FFF350FC  7f14                              jsr     r4
FFF350FE  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF35100  a889                              mov.l   1Ch+var_10[sp], r1
FFF35102  6101                              cmp     #0, r1
FFF35104  17                                beq.s   loc_FFF3510B
FFF35105  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF35108  389f00                            bra.w   loc_FFF351A7
FFF3510B  3e0200                 loc_FFF3510B mov.l   #0, 1Ch+var_14[sp]
FFF3510E  2e20                              bra.b   loc_FFF3512E
FFF35110  a909                   loc_FFF35110 mov.l   1Ch+var_8[sp], r1
FFF35112  ec14                              mov.l   [r1], r4
FFF35114  a819                              mov.l   4[r1], r1
FFF35116  ac95                              mov.l   48h[r1], r5
FFF35118  a983                              mov.l   1Ch+var_4[sp], r3
FFF3511A  6602                              mov.l   #0, r2
FFF3511C  6661                              mov.l   #6, r1
FFF3511E  7f15                              jsr     r5
FFF35120  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF35122  a889                              mov.l   1Ch+var_10[sp], r1
FFF35124  6101                              cmp     #0, r1
FFF35126  200e                              beq.b   loc_FFF35134
FFF35128  a881                              mov.l   1Ch+var_14[sp], r1
FFF3512A  6211                              add     #1, r1
FFF3512C  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF3512E  a881                   loc_FFF3512E mov.l   1Ch+var_14[sp], r1
FFF35130  6131                              cmp     #3, r1
FFF35132  29de                              blt.b   loc_FFF35110
FFF35134  a881                   loc_FFF35134 mov.l   1Ch+var_14[sp], r1
FFF35136  6131                              cmp     #3, r1
FFF35138  2907                              blt.b   loc_FFF3513F
FFF3513A  f806f7                            mov.l   #-9, 1Ch+var_1C[sp]
FFF3513D  2e6a                              bra.b   loc_FFF351A7
FFF3513F  a909                   loc_FFF3513F mov.l   1Ch+var_8[sp], r1
FFF35141  ec12                              mov.l   [r1], r2
FFF35143  a819                              mov.l   4[r1], r1
FFF35145  ac9b                              mov.l   4Ch[r1], r3
FFF35147  6611                              mov.l   #1, r1
FFF35149  7f13                              jsr     r3
FFF3514B  a909                              mov.l   1Ch+var_8[sp], r1
FFF3514D  ec1e                              mov.l   [r1], r14
FFF3514F  fbf20800f882                      mov.l   #-7D07FFF8h, r15
FFF35155  06a10cefac                        tst     2B0h[r14].l, r15
FFF3515A  16                                beq.s   loc_FFF35160
FFF3515B  f806e9                            mov.l   #-17h, 1Ch+var_1C[sp]
FFF3515E  2e49                              bra.b   loc_FFF351A7
FFF35160  a909                   loc_FFF35160 mov.l   1Ch+var_8[sp], r1
FFF35162  a819                              mov.l   4[r1], r1
FFF35164  ac1a                              mov.l   44h[r1], r2
FFF35166  6641                              mov.l   #4, r1
FFF35168  7f12                              jsr     r2
FFF3516A  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF3516C  a889                              mov.l   1Ch+var_10[sp], r1
FFF3516E  6101                              cmp     #0, r1
FFF35170  16                                beq.s   loc_FFF35176
FFF35171  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF35174  2e33                              bra.b   loc_FFF351A7
FFF35176  a909                   loc_FFF35176 mov.l   1Ch+var_8[sp], r1
FFF35178  a819                              mov.l   4[r1], r1
FFF3517A  ad9b                              mov.l   5Ch[r1], r3
FFF3517C  a809                              mov.l   1Ch+var_18[sp], r1
FFF3517E  754240                            mov.l   #40h, r2 ; '@'
FFF35181  7f13                              jsr     r3
FFF35183  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF35185  a889                              mov.l   1Ch+var_10[sp], r1
FFF35187  6101                              cmp     #0, r1
FFF35189  16                                beq.s   loc_FFF3518F
FFF3518A  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF3518D  2e1a                              bra.b   loc_FFF351A7
FFF3518F  a909                   loc_FFF3518F mov.l   1Ch+var_8[sp], r1
FFF35191  a819                              mov.l   4[r1], r1
FFF35193  ac1a                              mov.l   44h[r1], r2
FFF35195  6621                              mov.l   #2, r1
FFF35197  7f12                              jsr     r2
FFF35199  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF3519B  a889                              mov.l   1Ch+var_10[sp], r1
FFF3519D  6101                              cmp     #0, r1
FFF3519F  15                                beq.s   loc_FFF351A4
FFF351A0  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF351A3  0c                                bra.s   loc_FFF351A7
FFF351A4  f80600                 loc_FFF351A4 mov.l   #0, 1Ch+var_1C[sp]
FFF351A7  ec01                   loc_FFF351A7 mov.l   1Ch+var_1C[sp], r1
FFF351A9  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF351AB  6707                              rtsd    #7
FFF351AD  7100f0                 sub_FFF351AD add     #-10h, sp, sp   ; <<<< FUNC sub_FFF351AD
FFF351B0  a089                              mov.l   r1, 10h+var_4[sp]
FFF351B2  a819                              mov.l   4[r1], r1
FFF351B4  a891                              mov.l   8[r1], r1
FFF351B6  7f11                              jsr     r1
FFF351B8  a009                              mov.l   r1, 10h+var_C[sp]
FFF351BA  a809                              mov.l   10h+var_C[sp], r1
FFF351BC  6101                              cmp     #0, r1
FFF351BE  17                                beq.s   loc_FFF351C5
FFF351BF  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF351C2  381701                            bra.w   loc_FFF352D9
FFF351C5  a889                   loc_FFF351C5 mov.l   10h+var_4[sp], r1
FFF351C7  ec1e                              mov.l   [r1], r14
FFF351C9  fae5600100                        mov.w   #0, 2C0h[r14]
FFF351CE  a889                              mov.l   10h+var_4[sp], r1
FFF351D0  ec1e                              mov.l   [r1], r14
FFF351D2  fae5610100                        mov.w   #0, 2C2h[r14]
FFF351D7  a889                              mov.l   10h+var_4[sp], r1
FFF351D9  ec1e                              mov.l   [r1], r14
FFF351DB  fae5620100                        mov.w   #0, 2C4h[r14]
FFF351E0  a889                              mov.l   10h+var_4[sp], r1
FFF351E2  ec1e                              mov.l   [r1], r14
FFF351E4  fae5630100                        mov.w   #0, 2C6h[r14]
FFF351E9  a889                              mov.l   10h+var_4[sp], r1
FFF351EB  a819                              mov.l   4[r1], r1
FFF351ED  ab12                              mov.l   30h[r1], r2
FFF351EF  6601                              mov.l   #0, r1
FFF351F1  7f12                              jsr     r2
FFF351F3  a88a                              mov.l   10h+var_4[sp], r2
FFF351F5  6611                              mov.l   #1, r1
FFF351F7  3983ea                            bsr.w   sub_FFF33C7A
FFF351FA  a009                              mov.l   r1, 10h+var_C[sp]
FFF351FC  a809                              mov.l   10h+var_C[sp], r1
FFF351FE  6101                              cmp     #0, r1
FFF35200  17                                beq.s   loc_FFF35207
FFF35201  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF35204  38d500                            bra.w   loc_FFF352D9
FFF35207  66a1                   loc_FFF35207 mov.l   #0Ah, r1
FFF35209  052edaff                          bsr.a   sub_FFF32C37
FFF3520D  a889                              mov.l   10h+var_4[sp], r1
FFF3520F  3996ea                            bsr.w   sub_FFF33CA5
FFF35212  a009                              mov.l   r1, 10h+var_C[sp]
FFF35214  a809                              mov.l   10h+var_C[sp], r1
FFF35216  6101                              cmp     #0, r1
FFF35218  17                                beq.s   loc_FFF3521F
FFF35219  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF3521C  38bd00                            bra.w   loc_FFF352D9
FFF3521F  a889                   loc_FFF3521F mov.l   10h+var_4[sp], r1
FFF35221  3954ec                            bsr.w   sub_FFF33E75
FFF35224  a009                              mov.l   r1, 10h+var_C[sp]
FFF35226  a809                              mov.l   10h+var_C[sp], r1
FFF35228  6101                              cmp     #0, r1
FFF3522A  2137                              bne.b   loc_FFF35261
FFF3522C  a889                              mov.l   10h+var_4[sp], r1
FFF3522E  ec1e                              mov.l   [r1], r14
FFF35230  deef6001                          mov.w   2C0h[r14], r15
FFF35234  781f                              bset    #1, r15
FFF35236  dbef6001                          mov.w   r15, 2C0h[r14]
FFF3523A  fbe2b62c0100                      mov.l   #12CB6h, r14
FFF35240  f8e502                            mov.w   #2, [r14]
FFF35243  a889                              mov.l   10h+var_4[sp], r1
FFF35245  ec1e                              mov.l   [r1], r14
FFF35247  5eee6001                          movu.w  2C0h[r14], r14
FFF3524B  7c2e                              btst    #2, r14
FFF3524D  2068                              beq.b   loc_FFF352B5
FFF3524F  a889                              mov.l   10h+var_4[sp], r1
FFF35251  39e9ed                            bsr.w   sub_FFF3403A
FFF35254  a009                              mov.l   r1, 10h+var_C[sp]
FFF35256  a809                              mov.l   10h+var_C[sp], r1
FFF35258  6101                              cmp     #0, r1
FFF3525A  205b                              beq.b   loc_FFF352B5
FFF3525C  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF3525F  2e7a                              bra.b   loc_FFF352D9
FFF35261  a809                   loc_FFF35261 mov.l   10h+var_C[sp], r1
FFF35263  6111                              cmp     #1, r1
FFF35265  211b                              bne.b   loc_FFF35280
FFF35267  a889                              mov.l   10h+var_4[sp], r1
FFF35269  ec1e                              mov.l   [r1], r14
FFF3526B  deef6001                          mov.w   2C0h[r14], r15
FFF3526F  780f                              bset    #0, r15
FFF35271  dbef6001                          mov.w   r15, 2C0h[r14]
FFF35275  fbe2b62c0100                      mov.l   #12CB6h, r14
FFF3527B  f8e501                            mov.w   #1, [r14]
FFF3527E  2e37                              bra.b   loc_FFF352B5
FFF35280  a809                   loc_FFF35280 mov.l   10h+var_C[sp], r1
FFF35282  7501f7                            cmp     #-9, r1
FFF35285  212b                              bne.b   loc_FFF352B0
FFF35287  a889                              mov.l   10h+var_4[sp], r1
FFF35289  ec1e                              mov.l   [r1], r14
FFF3528B  deef6001                          mov.w   2C0h[r14], r15
FFF3528F  780f                              bset    #0, r15
FFF35291  dbef6001                          mov.w   r15, 2C0h[r14]
FFF35295  fbe2b62c0100                      mov.l   #12CB6h, r14
FFF3529B  f8e501                            mov.w   #1, [r14]
FFF3529E  a889                              mov.l   10h+var_4[sp], r1
FFF352A0  395bea                            bsr.w   sub_FFF33CFB
FFF352A3  a009                              mov.l   r1, 10h+var_C[sp]
FFF352A5  a809                              mov.l   10h+var_C[sp], r1
FFF352A7  6101                              cmp     #0, r1
FFF352A9  200c                              beq.b   loc_FFF352B5
FFF352AB  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF352AE  2e2b                              bra.b   loc_FFF352D9
FFF352B0  e10001                 loc_FFF352B0 mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF352B3  2e26                              bra.b   loc_FFF352D9
FFF352B5  a889                   loc_FFF352B5 mov.l   10h+var_4[sp], r1
FFF352B7  395dee                            bsr.w   sub_FFF34114
FFF352BA  a009                              mov.l   r1, 10h+var_C[sp]
FFF352BC  a809                              mov.l   10h+var_C[sp], r1
FFF352BE  6101                              cmp     #0, r1
FFF352C0  16                                beq.s   loc_FFF352C6
FFF352C1  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF352C4  2e15                              bra.b   loc_FFF352D9
FFF352C6  a889                   loc_FFF352C6 mov.l   10h+var_4[sp], r1
FFF352C8  39bbee                            bsr.w   sub_FFF34183
FFF352CB  a009                              mov.l   r1, 10h+var_C[sp]
FFF352CD  a809                              mov.l   10h+var_C[sp], r1
FFF352CF  6101                              cmp     #0, r1
FFF352D1  15                                beq.s   loc_FFF352D6
FFF352D2  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF352D5  0c                                bra.s   loc_FFF352D9
FFF352D6  f80600                 loc_FFF352D6 mov.l   #0, 10h+var_10[sp]
FFF352D9  ec01                   loc_FFF352D9 mov.l   10h+var_10[sp], r1
FFF352DB  a081                              mov.l   r1, 10h+var_8[sp]
FFF352DD  6704                              rtsd    #4
FFF352DF  7100f0                 sub_FFF352DF add     #-10h, sp, sp   ; <<<< FUNC sub_FFF352DF
FFF352E2  a089                              mov.l   r1, 10h+var_4[sp]
FFF352E4  39a6ef                            bsr.w   sub_FFF3428A
FFF352E7  a009                              mov.l   r1, 10h+var_C[sp]
FFF352E9  a809                              mov.l   10h+var_C[sp], r1
FFF352EB  6101                              cmp     #0, r1
FFF352ED  16                                beq.s   loc_FFF352F3
FFF352EE  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF352F1  2e50                              bra.b   loc_FFF35341
FFF352F3  a889                   loc_FFF352F3 mov.l   10h+var_4[sp], r1
FFF352F5  ec11                              mov.l   [r1], r1
FFF352F7  5e1e6301                          movu.w  2C6h[r1], r14
FFF352FB  72110102                          add     #201h, r1, r1
FFF352FF  611e                              cmp     #1, r14
FFF35301  17                                beq.s   loc_FFF35308
FFF35302  39f9ef                            bsr.w   sub_FFF342FB
FFF35305  a009                              mov.l   r1, 10h+var_C[sp]
FFF35307  0e                                bra.s   loc_FFF3530D
FFF35308  39b2f0                 loc_FFF35308 bsr.w   sub_FFF343BA
FFF3530B  a009                              mov.l   r1, 10h+var_C[sp]
FFF3530D  a809                   loc_FFF3530D mov.l   10h+var_C[sp], r1
FFF3530F  6101                              cmp     #0, r1
FFF35311  16                                beq.s   loc_FFF35317
FFF35312  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF35315  2e2c                              bra.b   loc_FFF35341
FFF35317  a889                   loc_FFF35317 mov.l   10h+var_4[sp], r1
FFF35319  393ff1                            bsr.w   sub_FFF34458
FFF3531C  a009                              mov.l   r1, 10h+var_C[sp]
FFF3531E  a809                              mov.l   10h+var_C[sp], r1
FFF35320  6101                              cmp     #0, r1
FFF35322  16                                beq.s   loc_FFF35328
FFF35323  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF35326  2e1b                              bra.b   loc_FFF35341
FFF35328  a889                   loc_FFF35328 mov.l   10h+var_4[sp], r1
FFF3532A  ec11                              mov.l   [r1], r1
FFF3532C  72111102                          add     #211h, r1, r1
FFF35330  3999f1                            bsr.w   sub_FFF344C9
FFF35333  a009                              mov.l   r1, 10h+var_C[sp]
FFF35335  a809                              mov.l   10h+var_C[sp], r1
FFF35337  6101                              cmp     #0, r1
FFF35339  15                                beq.s   loc_FFF3533E
FFF3533A  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF3533D  0c                                bra.s   loc_FFF35341
FFF3533E  f80600                 loc_FFF3533E mov.l   #0, 10h+var_10[sp]
FFF35341  ec01                   loc_FFF35341 mov.l   10h+var_10[sp], r1
FFF35343  a081                              mov.l   r1, 10h+var_8[sp]
FFF35345  6704                              rtsd    #4
FFF35347  7100e8                 sub_FFF35347 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF35347
FFF3534A  9289                              mov.w   r1, 18h+var_2[sp]
FFF3534C  9282                              mov.w   r2, 18h+var_4[sp]
FFF3534E  920b                              mov.w   r3, 18h+var_6[sp]
FFF35350  a08c                              mov.l   r4, 18h+var_C[sp]
FFF35352  ba89                              movu.w  18h+var_2[sp], r1
FFF35354  ef42                              mov.l   r4, r2
FFF35356  3941f5                            bsr.w   sub_FFF34897
FFF35359  a009                              mov.l   r1, 18h+var_14[sp]
FFF3535B  a809                              mov.l   18h+var_14[sp], r1
FFF3535D  6101                              cmp     #0, r1
FFF3535F  16                                beq.s   loc_FFF35365
FFF35360  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF35363  2e31                              bra.b   loc_FFF35394
FFF35365  a889                   loc_FFF35365 mov.l   18h+var_C[sp], r1
FFF35367  ec13                              mov.l   [r1], r3
FFF35369  a819                              mov.l   4[r1], r1
FFF3536B  ad14                              mov.l   50h[r1], r4
FFF3536D  ba0a                              movu.w  18h+var_6[sp], r2
FFF3536F  ba81                              movu.w  18h+var_4[sp], r1
FFF35371  7f14                              jsr     r4
FFF35373  a009                              mov.l   r1, 18h+var_14[sp]
FFF35375  a809                              mov.l   18h+var_14[sp], r1
FFF35377  6101                              cmp     #0, r1
FFF35379  16                                beq.s   loc_FFF3537F
FFF3537A  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF3537D  2e17                              bra.b   loc_FFF35394
FFF3537F  a88a                   loc_FFF3537F mov.l   18h+var_C[sp], r2
FFF35381  6601                              mov.l   #0, r1
FFF35383  3914f5                            bsr.w   sub_FFF34897
FFF35386  a009                              mov.l   r1, 18h+var_14[sp]
FFF35388  a809                              mov.l   18h+var_14[sp], r1
FFF3538A  6101                              cmp     #0, r1
FFF3538C  15                                beq.s   loc_FFF35391
FFF3538D  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF35390  0c                                bra.s   loc_FFF35394
FFF35391  f80600                 loc_FFF35391 mov.l   #0, 18h+var_18[sp]
FFF35394  ec01                   loc_FFF35394 mov.l   18h+var_18[sp], r1
FFF35396  a081                              mov.l   r1, 18h+var_10[sp]
FFF35398  6706                              rtsd    #6
FFF3539A  7100f0                 sub_FFF3539A add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3539A
FFF3539D  a089                              mov.l   r1, 10h+var_4[sp]
FFF3539F  39ddf3                            bsr.w   sub_FFF3477C
FFF353A2  a009                              mov.l   r1, 10h+var_C[sp]
FFF353A4  a809                              mov.l   10h+var_C[sp], r1
FFF353A6  6101                              cmp     #0, r1
FFF353A8  16                                beq.s   loc_FFF353AE
FFF353A9  e10001                            mov.l   10h+var_C[sp], 10h+var_10[sp]
FFF353AC  2e1c                              bra.b   loc_FFF353C8
FFF353AE  a889                   loc_FFF353AE mov.l   10h+var_4[sp], r1
FFF353B0  ec1e                              mov.l   [r1], r14
FFF353B2  f6e22202                          btst    #2, 222h[r14].b
FFF353B6  12                                beq.s   loc_FFF353C0
FFF353B7  fae5560102                        mov.w   #2, 2ACh[r14]
FFF353BC  f80600                            mov.l   #0, 10h+var_10[sp]
FFF353BF  09                                bra.s   loc_FFF353C8
FFF353C0  fae5560100             loc_FFF353C0 mov.w   #0, 2ACh[r14]
FFF353C5  f80600                            mov.l   #0, 10h+var_10[sp]
FFF353C8  ec01                   loc_FFF353C8 mov.l   10h+var_10[sp], r1
FFF353CA  a081                              mov.l   r1, 10h+var_8[sp]
FFF353CC  6704                              rtsd    #4
FFF353CE  7100dc                 sub_FFF353CE add     #-24h, sp, sp   ; <<<< FUNC sub_FFF353CE
FFF353D1  a201                              mov.l   r1, 24h+var_4[sp]
FFF353D3  a18a                              mov.l   r2, 24h+var_8[sp]
FFF353D5  930b                              mov.w   r3, 24h+var_A[sp]
FFF353D7  a10c                              mov.l   r4, 24h+var_10[sp]
FFF353D9  ec4e                              mov.l   [r4], r14
FFF353DB  5eee6001                          movu.w  2C0h[r14], r14
FFF353DF  7c1e                              btst    #1, r14
FFF353E1  aa01                              mov.l   24h+var_4[sp], r1
FFF353E3  14                                beq.s   loc_FFF353E7
FFF353E4  a081                              mov.l   r1, 24h+var_1C[sp]
FFF353E6  0d                                bra.s   loc_FFF353EB
FFF353E7  6c91                   loc_FFF353E7 shll    #9, r1
FFF353E9  a081                              mov.l   r1, 24h+var_1C[sp]
FFF353EB  a909                   loc_FFF353EB mov.l   24h+var_10[sp], r1
FFF353ED  397ff2                            bsr.w   sub_FFF3466C
FFF353F0  a089                              mov.l   r1, 24h+var_18[sp]
FFF353F2  a889                              mov.l   24h+var_18[sp], r1
FFF353F4  6101                              cmp     #0, r1
FFF353F6  17                                beq.s   loc_FFF353FD
FFF353F7  e5000301                          mov.l   24h+var_18[sp], 24h+var_20[sp]
FFF353FB  2e53                              bra.b   loc_FFF3544E
FFF353FD  a909                   loc_FFF353FD mov.l   24h+var_10[sp], r1
FFF353FF  ec1e                              mov.l   [r1], r14
