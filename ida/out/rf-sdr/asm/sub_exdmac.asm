; window exdmac file 2F1C80-2F2040 map FFEF1C80-FFEF2040 forced 361
; ==== exdmac  FFEF1C80-FFEF2040 ====
FFEF1C80  940b                              mov.w   r3, 22h[sp]
FFEF1C82  9404                              mov.w   r4, 20h[sp]
FFEF1C84  d500160f                          mov.w   2Ch[sp], 1Eh[sp]
FFEF1C88  d500170e                          mov.w   2Eh[sp], 1Ch[sp]
FFEF1C8C  fbe2c8d30100                      mov.l   #1D3C8h, r14
FFEF1C92  ece1                              mov.l   [r14], r1
FFEF1C94  e5100306                          mov.l   0Ch[r1], 18h[sp]
FFEF1C98  bb89                              movu.w  1Eh[sp], r1
FFEF1C9A  68b1                              shlr    #0Bh, r1
FFEF1C9C  8289                              mov.b   r1, 0Bh[sp]
FFEF1C9E  bb89                              movu.w  1Eh[sp], r1
FFEF1CA0  7621e007                          and     #7E0h, r1
FFEF1CA4  6851                              shlr    #5, r1
FFEF1CA6  8281                              mov.b   r1, 0Ah[sp]
FFEF1CA8  bb89                              movu.w  1Eh[sp], r1
FFEF1CAA  75211f                            and     #1Fh, r1
FFEF1CAD  8209                              mov.b   r1, 9[sp]
FFEF1CAF  bb81                              movu.w  1Ch[sp], r1
FFEF1CB1  68b1                              shlr    #0Bh, r1
FFEF1CB3  8201                              mov.b   r1, 8[sp]
FFEF1CB5  bb81                              movu.w  1Ch[sp], r1
FFEF1CB7  7621e007                          and     #7E0h, r1
FFEF1CBB  6851                              shlr    #5, r1
FFEF1CBD  8189                              mov.b   r1, 7[sp]
FFEF1CBF  bb81                              movu.w  1Ch[sp], r1
FFEF1CC1  75211f                            and     #1Fh, r1
FFEF1CC4  8181                              mov.b   r1, 6[sp]
FFEF1CC6  3d0800                            mov.w   #0, 10h[sp]
FFEF1CC9  380401                            bra.w   loc_FFEF1DCD
FFEF1CCC  ba01                     loc_FFEF1CCC movu.w  10h[sp], r1
FFEF1CCE  6101                              cmp     #0, r1
FFEF1CD0  1e                                bne.s   loc_FFEF1CD6
FFEF1CD1  3c0264                            mov.b   #64h, 2[sp] ; 'd'
FFEF1CD4  2e2f                              bra.b   loc_FFEF1D03
FFEF1CD6  bc01                     loc_FFEF1CD6 movu.w  20h[sp], r1
FFEF1CD8  6011                              sub     #1, r1
FFEF1CDA  ba02                              movu.w  10h[sp], r2
FFEF1CDC  4712                              cmp     r1, r2
FFEF1CDE  1e                                bne.s   loc_FFEF1CE4
FFEF1CDF  3c0200                            mov.b   #0, 2[sp]
FFEF1CE2  2e21                              bra.b   loc_FFEF1D03
FFEF1CE4  bc01                     loc_FFEF1CE4 movu.w  20h[sp], r1
FFEF1CE6  6011                              sub     #1, r1
FFEF1CE8  fb2e40420f                        mov.l   #0F4240h, r2
FFEF1CED  fc2312                            div     r1, r2
FFEF1CF0  06cd0208                          mul     10h[sp].uw, r2
FFEF1CF4  fd78821027                        div     #2710h, r2
FFEF1CF9  8082                              mov.b   r2, 2[sp]
FFEF1CFB  754164                            mov.l   #64h, r1 ; 'd'
FFEF1CFE  410102                            sub     2[sp], r1
FFEF1D01  8081                              mov.b   r1, 2[sp]
FFEF1D03  b201                     loc_FFEF1D03 movu.b  8[sp], r1
FFEF1D05  b28a                              movu.b  0Bh[sp], r2
FFEF1D07  4721                              cmp     r2, r1
FFEF1D09  2b14                              ble.b   loc_FFEF1D1D
FFEF1D0B  b201                              movu.b  8[sp], r1
FFEF1D0D  41010b                            sub     0Bh[sp], r1
FFEF1D10  4d0102                            mul     2[sp], r1
FFEF1D13  fd748164                          div     #64h, r1 ; 'd'
FFEF1D17  4b12                              add     r1, r2
FFEF1D19  810a                              mov.b   r2, 5[sp]
FFEF1D1B  2e12                              bra.b   loc_FFEF1D2D
FFEF1D1D  b289                     loc_FFEF1D1D movu.b  0Bh[sp], r1
FFEF1D1F  410108                            sub     8[sp], r1
FFEF1D22  4d0102                            mul     2[sp], r1
FFEF1D25  fd748164                          div     #64h, r1 ; 'd'
FFEF1D29  4312                              sub     r1, r2
FFEF1D2B  810a                              mov.b   r2, 5[sp]
FFEF1D2D  b189                     loc_FFEF1D2D movu.b  7[sp], r1
FFEF1D2F  b282                              movu.b  0Ah[sp], r2
FFEF1D31  4721                              cmp     r2, r1
FFEF1D33  2b14                              ble.b   loc_FFEF1D47
FFEF1D35  b189                              movu.b  7[sp], r1
FFEF1D37  41010a                            sub     0Ah[sp], r1
FFEF1D3A  4d0102                            mul     2[sp], r1
FFEF1D3D  fd748164                          div     #64h, r1 ; 'd'
FFEF1D41  4b12                              add     r1, r2
FFEF1D43  8102                              mov.b   r2, 4[sp]
FFEF1D45  2e12                              bra.b   loc_FFEF1D57
FFEF1D47  b281                     loc_FFEF1D47 movu.b  0Ah[sp], r1
FFEF1D49  410107                            sub     7[sp], r1
FFEF1D4C  4d0102                            mul     2[sp], r1
FFEF1D4F  fd748164                          div     #64h, r1 ; 'd'
FFEF1D53  4312                              sub     r1, r2
FFEF1D55  8102                              mov.b   r2, 4[sp]
FFEF1D57  b181                     loc_FFEF1D57 movu.b  6[sp], r1
FFEF1D59  b20a                              movu.b  9[sp], r2
FFEF1D5B  4721                              cmp     r2, r1
FFEF1D5D  2b14                              ble.b   loc_FFEF1D71
FFEF1D5F  b181                              movu.b  6[sp], r1
FFEF1D61  410109                            sub     9[sp], r1
FFEF1D64  4d0102                            mul     2[sp], r1
FFEF1D67  fd748164                          div     #64h, r1 ; 'd'
FFEF1D6B  4b12                              add     r1, r2
FFEF1D6D  808a                              mov.b   r2, 3[sp]
FFEF1D6F  2e12                              bra.b   loc_FFEF1D81
FFEF1D71  b209                     loc_FFEF1D71 movu.b  9[sp], r1
FFEF1D73  410106                            sub     6[sp], r1
FFEF1D76  4d0102                            mul     2[sp], r1
FFEF1D79  fd748164                          div     #64h, r1 ; 'd'
FFEF1D7D  4312                              sub     r1, r2
FFEF1D7F  808a                              mov.b   r2, 3[sp]
FFEF1D81  b109                     loc_FFEF1D81 movu.b  5[sp], r1
FFEF1D83  6cb1                              shll    #0Bh, r1
FFEF1D85  b102                              movu.b  4[sp], r2
FFEF1D87  6c52                              shll    #5, r2
FFEF1D89  5721                              or      r2, r1
FFEF1D8B  550103                            or      3[sp], r1
FFEF1D8E  d301                              mov.w   r1, [sp]
FFEF1D90  3d0900                            mov.w   #0, 12h[sp]
FFEF1D93  2e2c                              bra.b   loc_FFEF1DBF
FFEF1D95  bc81                     loc_FFEF1D95 movu.w  24h[sp], r1
FFEF1D97  06c90108                          add     10h[sp].uw, r1
FFEF1D9B  76114001                          mul     #140h, r1
FFEF1D9F  06c90113                          add     26h[sp].uw, r1
FFEF1DA3  06c90109                          add     12h[sp].uw, r1
FFEF1DA7  a089                              mov.l   r1, 0Ch[sp]
FFEF1DA9  a889                              mov.l   0Ch[sp], r1
FFEF1DAB  6c11                              shll    #1, r1
FFEF1DAD  06890106                          add     18h[sp].l, r1
FFEF1DB1  a109                              mov.l   r1, 14h[sp]
FFEF1DB3  dc01                              mov.w   [sp], r1
FFEF1DB5  a90a                              mov.l   14h[sp], r2
FFEF1DB7  d321                              mov.w   r1, [r2]
FFEF1DB9  9a09                              mov.w   12h[sp], r1
FFEF1DBB  6211                              add     #1, r1
FFEF1DBD  9209                              mov.w   r1, 12h[sp]
FFEF1DBF  ba09                     loc_FFEF1DBF movu.w  12h[sp], r1
FFEF1DC1  06c50111                          cmp     22h[sp].uw, r1
FFEF1DC5  29d0                              blt.b   loc_FFEF1D95
FFEF1DC7  9a01                              mov.w   10h[sp], r1
FFEF1DC9  6211                              add     #1, r1
FFEF1DCB  9201                              mov.w   r1, 10h[sp]
FFEF1DCD  ba01                     loc_FFEF1DCD movu.w  10h[sp], r1
FFEF1DCF  06c50110                          cmp     20h[sp].uw, r1
FFEF1DD3  2805                              bge.b   loc_FFEF1DD8
FFEF1DD5  38f7fe                            bra.w   loc_FFEF1CCC
FFEF1DD8  670a                     loc_FFEF1DD8 rtsd    #0Ah
FFEF1DDA  fbee0f7208               loc_FFEF1DDA mov.l   #8720Fh, r14
FFEF1DDF  f0ee                              bclr    #6, [r14].b
FFEF1DE1  fbee102808                        mov.l   #82810h, r14
FFEF1DE6  f1e80c                            bclr    #0, 0Ch[r14].b
FFEF1DE9  fbee102808                        mov.l   #82810h, r14
FFEF1DEE  f9ee01008000                      mov.l   #8000h, 4[r14]
FFEF1DF4  fbee102808                        mov.l   #82810h, r14
FFEF1DF9  f8e90081                          mov.w   #-7F00h, [r14]
FFEF1DFD  fbee102808                        mov.l   #82810h, r14
FFEF1E02  f1e403                            bset    #4, 3[r14].b
FFEF1E05  fbee002a08                        mov.l   #82A00h, r14
FFEF1E0A  f0e0                              bset    #0, [r14].b
FFEF1E0C  fbee102808                        mov.l   #82810h, r14
FFEF1E11  f1e00c                            bset    #0, 0Ch[r14].b
FFEF1E14  fbee0f7208                        mov.l   #8720Fh, r14
FFEF1E19  5aef6f01                          movu.b  16Fh[r14], r15
FFEF1E1D  655f                              or      #5, r15
FFEF1E1F  762ff500                          and     #0F5h, r15
FFEF1E23  cbef6f01                          mov.b   r15, 16Fh[r14]
FFEF1E27  02                                rts
FFEF1E28  7ea1                     loc_FFEF1E28 push.l  r1
FFEF1E2A  fb1e1e2808                        mov.l   #8281Eh, r1
FFEF1E2F  5811                              movu.b  [r1], r1
FFEF1E31  7eb1                              pop     r1
FFEF1E33  7f95                              rte
FFEF1E35  fbee0f7208               sub_FFEF1E35 mov.l   #8720Fh, r14  ; <<< FUNC sub_FFEF1E35
FFEF1E3A  f0e6                              bset    #6, [r14].b
FFEF1E3C  fbee1c2808                        mov.l   #8281Ch, r14
FFEF1E41  f0e0                              bset    #0, [r14].b
FFEF1E43  fb1e1c2808                        mov.l   #8281Ch, r1
FFEF1E48  3c1111                            mov.b   #11h, 1[r1]
FFEF1E4B  02                                rts
FFEF1E4C  fbee0f7208               sub_FFEF1E4C mov.l   #8720Fh, r14  ; <<< FUNC sub_FFEF1E4C
FFEF1E51  f0ee                              bclr    #6, [r14].b
FFEF1E53  fbee1c2808                        mov.l   #8281Ch, r14
FFEF1E58  f0e8                              bclr    #0, [r14].b
FFEF1E5A  fb1e1c2808                        mov.l   #8281Ch, r1
FFEF1E5F  3c1100                            mov.b   #0, 1[r1]
FFEF1E62  02                                rts
FFEF1E63  6040                     loc_FFEF1E63 sub     #4, sp
FFEF1E65  fbee1e2808                        mov.l   #8281Eh, r14
FFEF1E6A  58ee                              movu.b  [r14], r14
FFEF1E6C  684e                              shlr    #4, r14
FFEF1E6E  641e                              and     #1, r14
FFEF1E70  611e                              cmp     #1, r14
FFEF1E72  1d                                bne.s   loc_FFEF1E77
FFEF1E73  3c0201                            mov.b   #1, 2[sp]
FFEF1E76  0c                                bra.s   loc_FFEF1E7A
FFEF1E77  3c0200                   loc_FFEF1E77 mov.b   #0, 2[sp]
FFEF1E7A  c5000203                 loc_FFEF1E7A mov.b   2[sp], 3[sp]
FFEF1E7E  b089                              movu.b  3[sp], r1
FFEF1E80  5b11                              movu.b  r1, r1
FFEF1E82  6701                              rtsd    #1
FFEF1E84  7100ec                   sub_FFEF1E84 add     #-14h, sp, sp  ; <<< FUNC sub_FFEF1E84
FFEF1E87  a101                              mov.l   r1, 14h+var_4[sp]
FFEF1E89  d5100402                          mov.w   8[r1], 14h+var_10[sp]
FFEF1E8D  a901                              mov.l   14h+var_4[sp], r1
FFEF1E8F  d5100303                          mov.w   6[r1], 14h+var_E[sp]
FFEF1E93  3d0500                            mov.w   #0, 14h+var_A[sp]
FFEF1E96  2e4d                              bra.b   loc_FFEF1EE3
FFEF1E98  3d0400                   loc_FFEF1E98 mov.w   #0, 14h+var_C[sp]
FFEF1E9B  2e3a                              bra.b   loc_FFEF1ED5
FFEF1E9D  a901                     loc_FFEF1E9D mov.l   14h+var_4[sp], r1
FFEF1E9F  b892                              movu.w  4[r1], r2
FFEF1EA1  06c90205                          add     14h+var_A[sp].uw, r2
FFEF1EA5  76124001                          mul     #140h, r2
FFEF1EA9  06c91201                          add     2[r1].uw, r2
FFEF1EAD  06c90204                          add     14h+var_C[sp].uw, r2
FFEF1EB1  e302                              mov.l   r2, 14h+var_14[sp]
FFEF1EB3  a901                              mov.l   14h+var_4[sp], r1
FFEF1EB5  a899                              mov.l   0Ch[r1], r1
FFEF1EB7  ec02                              mov.l   14h+var_14[sp], r2
FFEF1EB9  fe521e                            mov.w   [r2, r1], r14
FFEF1EBC  b909                              movu.w  14h+var_A[sp], r1
FFEF1EBE  06cd0103                          mul     14h+var_E[sp].uw, r1
FFEF1EC2  06c90104                          add     14h+var_C[sp].uw, r1
FFEF1EC6  fbf200600907                      mov.l   #7096000h, r15
FFEF1ECC  fe11fe                            mov.w   r14, [r1, r15]
FFEF1ECF  9901                              mov.w   14h+var_C[sp], r1
FFEF1ED1  6211                              add     #1, r1
FFEF1ED3  9101                              mov.w   r1, 14h+var_C[sp]
FFEF1ED5  b901                     loc_FFEF1ED5 movu.w  14h+var_C[sp], r1
FFEF1ED7  06c50103                          cmp     14h+var_E[sp].uw, r1
FFEF1EDB  29c2                              blt.b   loc_FFEF1E9D
FFEF1EDD  9909                              mov.w   14h+var_A[sp], r1
FFEF1EDF  6211                              add     #1, r1
FFEF1EE1  9109                              mov.w   r1, 14h+var_A[sp]
FFEF1EE3  b909                     loc_FFEF1EE3 movu.w  14h+var_A[sp], r1
FFEF1EE5  06c50102                          cmp     14h+var_10[sp].uw, r1
FFEF1EE9  29af                              blt.b   loc_FFEF1E98
FFEF1EEB  f9020300600907                    mov.l   #7096000h, 14h+var_8[sp]
FFEF1EF2  fb1200600907                      mov.l   #7096000h, r1
FFEF1EF8  6705                              rtsd    #5
FFEF1EFA  7100f0                            add     #-10h, sp, sp
FFEF1EFD  a089                              mov.l   r1, 0Ch[sp]
FFEF1EFF  394dff                            bsr.w   sub_FFEF1E4C
FFEF1F02  a889                              mov.l   0Ch[sp], r1
FFEF1F04  b819                              movu.w  2[r1], r1
FFEF1F06  6101                              cmp     #0, r1
FFEF1F08  18                                bne.s   loc_FFEF1F10
FFEF1F09  a889                              mov.l   0Ch[sp], r1
FFEF1F0B  b891                              movu.w  4[r1], r1
FFEF1F0D  6101                              cmp     #0, r1
FFEF1F0F  15                                beq.s   loc_FFEF1F14
FFEF1F10  f80601                   loc_FFEF1F10 mov.l   #1, [sp]
FFEF1F13  0c                                bra.s   loc_FFEF1F17
FFEF1F14  f80600                   loc_FFEF1F14 mov.l   #0, [sp]
FFEF1F17  ec01                     loc_FFEF1F17 mov.l   [sp], r1
FFEF1F19  6101                              cmp     #0, r1
FFEF1F1B  1a                                bne.s   loc_FFEF1F25
FFEF1F1C  a889                              mov.l   0Ch[sp], r1
FFEF1F1E  b899                              movu.w  6[r1], r1
FFEF1F20  76014001                          cmp     #140h, r1
FFEF1F24  15                                beq.s   loc_FFEF1F29
FFEF1F25  f80601                   loc_FFEF1F25 mov.l   #1, [sp]
FFEF1F28  0c                                bra.s   loc_FFEF1F2C
FFEF1F29  f80600                   loc_FFEF1F29 mov.l   #0, [sp]
FFEF1F2C  ec01                     loc_FFEF1F2C mov.l   [sp], r1
FFEF1F2E  6101                              cmp     #0, r1
FFEF1F30  19                                bne.s   loc_FFEF1F39
FFEF1F31  a889                              mov.l   0Ch[sp], r1
FFEF1F33  b911                              movu.w  8[r1], r1
FFEF1F35  7551f0                            cmp     #-10h, r1
FFEF1F38  15                                beq.s   loc_FFEF1F3D
FFEF1F39  f80601                   loc_FFEF1F39 mov.l   #1, [sp]
FFEF1F3C  0c                                bra.s   loc_FFEF1F40
FFEF1F3D  f80600                   loc_FFEF1F3D mov.l   #0, [sp]
FFEF1F40  ec01                     loc_FFEF1F40 mov.l   [sp], r1
FFEF1F42  6101                              cmp     #0, r1
FFEF1F44  a889                              mov.l   0Ch[sp], r1
FFEF1F46  2042                              beq.b   loc_FFEF1F88
FFEF1F48  b819                              movu.w  2[r1], r1
FFEF1F4A  6101                              cmp     #0, r1
FFEF1F4C  210f                              bne.b   loc_FFEF1F5B
FFEF1F4E  a889                              mov.l   0Ch[sp], r1
FFEF1F50  b899                              movu.w  6[r1], r1
FFEF1F52  76014001                          cmp     #140h, r1
FFEF1F56  1d                                bne.s   loc_FFEF1F5B
FFEF1F57  f80601                            mov.l   #1, [sp]
FFEF1F5A  0c                                bra.s   loc_FFEF1F5E
FFEF1F5B  f80600                   loc_FFEF1F5B mov.l   #0, [sp]
FFEF1F5E  ec01                     loc_FFEF1F5E mov.l   [sp], r1
FFEF1F60  6101                              cmp     #0, r1
FFEF1F62  a889                              mov.l   0Ch[sp], r1
FFEF1F64  2019                              beq.b   loc_FFEF1F7D
FFEF1F66  a88a                              mov.l   0Ch[sp], r2
FFEF1F68  b8a2                              movu.w  4[r2], r2
FFEF1F6A  76124001                          mul     #140h, r2
FFEF1F6E  6c12                              shll    #1, r2
FFEF1F70  06891203                          add     0Ch[r1].l, r2
FFEF1F74  fbee002808                        mov.l   #82800h, r14
FFEF1F79  e3e2                              mov.l   r2, [r14]
FFEF1F7B  2e15                              bra.b   loc_FFEF1F90
FFEF1F7D  3907ff                   loc_FFEF1F7D bsr.w   sub_FFEF1E84
FFEF1F80  fbee002808                        mov.l   #82800h, r14
FFEF1F85  e3e1                              mov.l   r1, [r14]
FFEF1F87  09                                bra.s   loc_FFEF1F90
FFEF1F88  fbee002808               loc_FFEF1F88 mov.l   #82800h, r14
FFEF1F8D  e11e03                            mov.l   0Ch[r1], [r14]
FFEF1F90  fbee002808               loc_FFEF1F90 mov.l   #82800h, r14
FFEF1F95  f9e20100000006                    mov.l   #6000000h, 4[r14]
FFEF1F9C  a889                              mov.l   0Ch[sp], r1
FFEF1F9E  b89a                              movu.w  6[r1], r2
FFEF1FA0  06cd1204                          mul     8[r1].uw, r2
FFEF1FA4  a082                              mov.l   r2, 8[sp]
FFEF1FA6  a881                              mov.l   8[sp], r1
FFEF1FA8  76010004                          cmp     #400h, r1
FFEF1FAC  2333                              bltu.b  loc_FFEF1FDF
FFEF1FAE  a889                              mov.l   0Ch[sp], r1
FFEF1FB0  d5100303                          mov.w   6[r1], 6[sp]
FFEF1FB4  a889                              mov.l   0Ch[sp], r1
FFEF1FB6  d5100402                          mov.w   8[r1], 4[sp]
FFEF1FBA  b889                              movu.w  6[sp], r1
FFEF1FBC  06c50102                          cmp     4[sp].uw, r1
FFEF1FC0  2b11                              ble.b   loc_FFEF1FD1
FFEF1FC2  fbee002808                        mov.l   #82800h, r14
FFEF1FC7  d50e0206                          mov.w   4[sp], 0Ch[r14]
FFEF1FCB  b889                              movu.w  6[sp], r1
FFEF1FCD  a081                              mov.l   r1, 8[sp]
FFEF1FCF  2e18                              bra.b   loc_FFEF1FE7
FFEF1FD1  fbee002808               loc_FFEF1FD1 mov.l   #82800h, r14
FFEF1FD6  d50e0306                          mov.w   6[sp], 0Ch[r14]
FFEF1FDA  b881                              movu.w  4[sp], r1
FFEF1FDC  a081                              mov.l   r1, 8[sp]
FFEF1FDE  09                                bra.s   loc_FFEF1FE7
FFEF1FDF  fb1e002808               loc_FFEF1FDF mov.l   #82800h, r1
FFEF1FE4  3d1601                            mov.w   #1, 0Ch[r1]
FFEF1FE7  a881                     loc_FFEF1FE7 mov.l   8[sp], r1
FFEF1FE9  6d01                              shll    #10h, r1
FFEF1FEB  fb2e002808                        mov.l   #82800h, r2
FFEF1FF0  a0a1                              mov.l   r1, 8[r2]
FFEF1FF2  fb1e002808                        mov.l   #82800h, r1
FFEF1FF7  a882                              mov.l   8[sp], r2
FFEF1FF9  06951202                          or      8[r1].l, r2
FFEF1FFD  a092                              mov.l   r2, 8[r1]
FFEF1FFF  a889                              mov.l   0Ch[sp], r1
FFEF2001  b912                              movu.w  8[r1], r2
FFEF2003  b893                              movu.w  4[r1], r3
FFEF2005  b89d                              movu.w  6[r1], r5
FFEF2007  b819                              movu.w  2[r1], r1
FFEF2009  6012                              sub     #1, r2
FFEF200B  5f24                              movu.w  r2, r4
FFEF200D  6015                              sub     #1, r5
FFEF200F  5f52                              movu.w  r5, r2
FFEF2011  05e4c1fe                          bsr.a   sub_FFEDE1F5
FFEF2015  3920fe                            bsr.w   sub_FFEF1E35
FFEF2018  6704                              rtsd    #4
FFEF201A  754129                            mov.l   #29h, r1 ; ')'
FFEF201D  057bc2fe                          bsr.a   sub_FFEDE298
FFEF2021  02                                rts
FFEF2022  754128                            mov.l   #28h, r1 ; '('
FFEF2025  0573c2fe                          bsr.a   sub_FFEDE298
FFEF2029  02                                rts
FFEF202A  754128                            mov.l   #28h, r1 ; '('
FFEF202D  056bc2fe                          bsr.a   sub_FFEDE298
FFEF2031  02                                rts
FFEF2032  02                                rts
FFEF2033  7100ec                            add     #-14h, sp, sp
FFEF2036  a101                              mov.l   r1, 10h[sp]
FFEF2038  838a                              mov.b   r2, 0Fh[sp]
FFEF203A  8383                              mov.b   r3, 0Eh[sp]
FFEF203C  a084                              mov.l   r4, 8[sp]
FFEF203E  b38a                              movu.b  0Fh[sp], r2
