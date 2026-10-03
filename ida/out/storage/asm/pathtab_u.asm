; ==== pathtab_u  FFF129C0-FFF12B80  (file 3129C0-312B80) ====
FFF129C0  3803                              mov.b   38h[r14], 3[sp]
FFF129C2  fb                                .byte 0FBh
FFF129C3  e2                                .byte 0E2h
FFF129C4  4d                                .byte  4Dh ; M
FFF129C5  8c                                .byte  8Ch
FFF129C6  00                                .byte    0
FFF129C7  00                     sub_FFF129C7 brk   ; <<<< FUNC sub_FFF129C7
FFF129C8  c5e03702                          mov.b   37h[r14], 8+var_6[sp]
FFF129CC  b389                              movu.b  8+arg_3[sp], r1
FFF129CE  6c41                              shll    #4, r1
FFF129D0  fbe2a47aedff                      mov.l   #unk_FFED7AA4, r14
FFF129D6  4be1                              add     r14, r1
FFF129D8  711110                            add     #10h, r1, r1
FFF129DB  a009                              mov.l   r1, 8+var_4[sp]
FFF129DD  ba01                              movu.w  8+arg_4[sp], r1
FFF129DF  6211                              add     #1, r1
FFF129E1  5f12                              movu.w  r1, r2
FFF129E3  75441d                            mov.l   #1Dh, r4
FFF129E6  fb3a4001                          mov.l   #140h, r3
FFF129EA  6601                              mov.l   #0, r1
FFF129EC  050bdbfd                          bsr.a   sub_FFEF04F7
FFF129F0  b089                              movu.b  8+var_5[sp], r1
FFF129F2  45010f                            cmp     8+arg_3[sp], r1
FFF129F5  211d                              bne.b   loc_FFF12A12
FFF129F7  ba01                              movu.w  8+arg_4[sp], r1
FFF129F9  6040                              sub     #4, sp
FFF129FB  f80980f9                          mov.w   #-680h, 0Ch+var_C[sp]
FFF129FF  6221                              add     #2, r1
FFF12A01  5f12                              movu.w  r1, r2
FFF12A03  75441c                            mov.l   #1Ch, r4
FFF12A06  fb3a3401                          mov.l   #134h, r3
FFF12A0A  6661                              mov.l   #6, r1
FFF12A0C  053cf2fd                          bsr.a   sub_FFEF1C48
FFF12A10  6240                              add     #4, sp
FFF12A12  b081                   loc_FFF12A12 movu.b  8+var_6[sp], r1
FFF12A14  6101                              cmp     #0, r1
FFF12A16  1a                                bne.s   loc_FFF12A20
FFF12A17  fb12bc2dedff                      mov.l   #unk_FFED2DBC, r1
FFF12A1D  a081                              mov.l   r1, 8[sp]
FFF12A1F  09                                bra.s   loc_FFF12A28
FFF12A20  fb128c2dedff           loc_FFF12A20 mov.l   #unk_FFED2D8C, r1
FFF12A26  a081                              mov.l   r1, 8[sp]
FFF12A28  3d0917                 loc_FFF12A28 mov.w   #17h, 8+arg_6[sp]
FFF12A2B  a884                              mov.l   8[sp], r4
FFF12A2D  ba02                              movu.w  8+arg_4[sp], r2
FFF12A2F  ba09                              movu.w  8+arg_6[sp], r1
FFF12A31  6242                              add     #4, r2
FFF12A33  5f22                              movu.w  r2, r2
FFF12A35  6613                              mov.l   #1, r3
FFF12A37  059e3efe                          bsr.a   sub_FFEF68D5
FFF12A3B  3d0933                            mov.w   #33h, 8+arg_6[sp] ; '3'
FFF12A3E  a809                              mov.l   8+var_4[sp], r1
FFF12A40  ec14                              mov.l   [r1], r4
FFF12A42  ba02                              movu.w  8+arg_4[sp], r2
FFF12A44  ba09                              movu.w  8+arg_6[sp], r1
FFF12A46  6242                              add     #4, r2
FFF12A48  5f22                              movu.w  r2, r2
FFF12A4A  6613                              mov.l   #1, r3
FFF12A4C  05893efe                          bsr.a   sub_FFEF68D5
FFF12A50  3d095a                            mov.w   #5Ah, 8+arg_6[sp] ; 'Z'
FFF12A53  a80a                              mov.l   8+var_4[sp], r2
FFF12A55  ba03                              movu.w  8+arg_4[sp], r3
FFF12A57  ba09                              movu.w  8+arg_6[sp], r1
FFF12A59  60c0                              sub     #0Ch, sp
FFF12A5B  6242                              add     #4, r2
FFF12A5D  a00a                              mov.l   r2, 14h+var_10[sp]
FFF12A5F  3c0801                            mov.b   #1, 14h+var_C[sp]
FFF12A62  f80407                            mov.b   #7, 14h+var_14[sp]
FFF12A65  6223                              add     #2, r3
FFF12A67  5f32                              movu.w  r3, r2
FFF12A69  6604                              mov.l   #0, r4
FFF12A6B  66d3                              mov.l   #0Dh, r3
FFF12A6D  05b6f0fd                          bsr.a   sub_FFEF1B23
FFF12A71  62c0                              add     #0Ch, sp
FFF12A73  6705                              rtsd    #5
FFF12A75  6040                   sub_FFF12A75 sub     #4, sp   ; <<<< FUNC sub_FFF12A75
FFF12A77  f80500                            mov.w   #0, 4+var_4[sp]
FFF12A7A  053d0102                          bsr.a   sub_FFF32BB7
FFF12A7E  05691002                          bsr.a   sub_FFF33AE7
FFF12A82  05338d02                          bsr.a   sub_FFF3B7B5
FFF12A86  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF12A89  9809                              mov.w   4+var_2[sp], r1
FFF12A8B  5f11                              movu.w  r1, r1
FFF12A8D  6701                              rtsd    #1
FFF12A8F  7100e8                 sub_FFF12A8F add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12A8F
FFF12A92  3d0a00                            mov.w   #0, 18h+var_4[sp]
FFF12A95  3d0900                            mov.w   #0, 18h+var_6[sp]
FFF12A98  3c8100                            mov.b   #0, 18h+var_7[sp]
FFF12A9B  3c8000                            mov.b   #0, 18h+var_8[sp]
FFF12A9E  754149                            mov.l   #49h, r1 ; 'I'
FFF12AA1  050c6a01                          bsr.a   sub_FFF294AD
FFF12AA5  8409                              mov.b   r1, 18h+var_7[sp]
FFF12AA7  8c09                              mov.b   18h+var_7[sp], r1
FFF12AA9  6101                              cmp     #0, r1
FFF12AAB  10                                beq.s   loc_FFF12AB3
FFF12AAC  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12AB1  2e5f                              bra.b   loc_FFF12B10
FFF12AB3  3c0400                 loc_FFF12AB3 mov.b   #0, 18h+var_14[sp]
FFF12AB6  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12AB9  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF12ABC  710304                            add     #18h+var_14, sp, r3
FFF12ABF  6642                              mov.l   #4, r2
FFF12AC1  754149                            mov.l   #49h, r1 ; 'I'
FFF12AC4  05023001                          bsr.a   sub_FFF25AC6
FFF12AC8  2e36                              bra.b   loc_FFF12AFE
FFF12ACA  fbe2907eedff           loc_FFF12ACA mov.l   #pathtab_drive, r14
FFF12AD0  8c01                              mov.b   18h+var_8[sp], r1
FFF12AD2  fe61e1                            mov.l   [r1, r14], r1
FFF12AD5  39d800                            bsr.w   sub_FFF12BAD
FFF12AD8  9281                              mov.w   r1, 18h+var_4[sp]
FFF12ADA  ba81                              movu.w  18h+var_4[sp], r1
FFF12ADC  6101                              cmp     #0, r1
FFF12ADE  10                                beq.s   loc_FFF12AE6
FFF12ADF  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12AE4  2e2c                              bra.b   loc_FFF12B10
FFF12AE6  3d0900                 loc_FFF12AE6 mov.w   #0, 18h+var_6[sp]
FFF12AE9  0f                                bra.s   loc_FFF12AF0
FFF12AEA  9a09                   loc_FFF12AEA mov.w   18h+var_6[sp], r1
FFF12AEC  6211                              add     #1, r1
FFF12AEE  9209                              mov.w   r1, 18h+var_6[sp]
FFF12AF0  ba09                   loc_FFF12AF0 movu.w  18h+var_6[sp], r1
FFF12AF2  76010020                          cmp     #2000h, r1
FFF12AF6  29f4                              blt.b   loc_FFF12AEA
FFF12AF8  b401                              movu.b  18h+var_8[sp], r1
FFF12AFA  6211                              add     #1, r1
FFF12AFC  8401                              mov.b   r1, 18h+var_8[sp]
FFF12AFE  fbe2907eedff           loc_FFF12AFE mov.l   #pathtab_drive, r14
FFF12B04  8c01                              mov.b   18h+var_8[sp], r1
FFF12B06  fe61ee                            mov.l   [r1, r14], r14
FFF12B09  610e                              cmp     #0, r14
FFF12B0B  21bf                              bne.b   loc_FFF12ACA
FFF12B0D  3d0100                            mov.w   #0, 18h+var_16[sp]
FFF12B10  d500010b               loc_FFF12B10 mov.w   18h+var_16[sp], 18h+var_2[sp]
FFF12B14  ba89                              movu.w  18h+var_2[sp], r1
FFF12B16  6706                              rtsd    #6
FFF12B18  7100e0                 sub_FFF12B18 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF12B18
FFF12B1B  a189                              mov.l   r1, 20h+var_4[sp]
FFF12B1D  3d0c00                            mov.w   #0, 20h+var_8[sp]
FFF12B20  3c8700                            mov.b   #0, 20h+var_9[sp]
FFF12B23  fbe2b62c0100                      mov.l   #12CB6h, r14
FFF12B29  5cee                              movu.w  [r14], r14
FFF12B2B  612e                              cmp     #2, r14
FFF12B2D  200d                              beq.b   loc_FFF12B3A
FFF12B2F  611e                              cmp     #1, r14
FFF12B31  210f                              bne.b   loc_FFF12B40
FFF12B33  a989                              mov.l   20h+var_4[sp], r1
FFF12B35  f81502                            mov.w   #2, [r1]
FFF12B38  2e0d                              bra.b   loc_FFF12B45
FFF12B3A  a989                   loc_FFF12B3A mov.l   20h+var_4[sp], r1
FFF12B3C  f81503                            mov.w   #3, [r1]
FFF12B3F  0e                                bra.s   loc_FFF12B45
FFF12B40  a989                   loc_FFF12B40 mov.l   20h+var_4[sp], r1
FFF12B42  f81501                            mov.w   #1, [r1]
FFF12B45  71030c                 loc_FFF12B45 add     #20h+var_14, sp, r3
FFF12B48  710210                            add     #20h+var_10, sp, r2
FFF12B4B  754149                            mov.l   #49h, r1 ; 'I'
FFF12B4E  051c6101                          bsr.a   sub_FFF28C6A
FFF12B52  8589                              mov.b   r1, 20h+var_9[sp]
FFF12B54  8d89                              mov.b   20h+var_9[sp], r1
FFF12B56  6101                              cmp     #0, r1
FFF12B58  10                                beq.s   loc_FFF12B60
FFF12B59  f90901ffff                        mov.w   #-1, 20h+var_1E[sp]
FFF12B5E  2e47                              bra.b   loc_FFF12BA5
FFF12B60  6604                   loc_FFF12B60 mov.l   #0, r4
FFF12B62  fb3e000010                        mov.l   #100000h, r3
FFF12B67  a902                              mov.l   20h+var_10[sp], r2
FFF12B69  a889                              mov.l   20h+var_14[sp], r1
FFF12B6B  052f2c03                          bsr.a   sub_FFF4579A
FFF12B6F  a98a                              mov.l   20h+var_4[sp], r2
FFF12B71  a029                              mov.l   r1, 4[r2]
FFF12B73  710304                            add     #20h+var_1C, sp, r3
FFF12B76  710208                            add     #20h+var_18, sp, r2
FFF12B79  754149                            mov.l   #49h, r1 ; 'I'
FFF12B7C  05a66201                          bsr.a   sub_FFF28E22
