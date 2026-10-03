; ==== fat_type  FFF23900-FFF24100  (file 323900-324100) ====
FFF23900  82c3                              mov.b   r3, 0Ah[r4]
FFF23902  2167                              bne.b   loc_FFF23968+1
FFF23904  04670471               sub_FFF23904 bra.a   633D6Bh   ; <<<< FUNC sub_FFF23904
FFF23908  00                     sub_FFF23908 brk   ; <<<< FUNC sub_FFF23908
FFF23909  e4a181                            mov.l   [r10], 204h[r1]
FFF2390C  a10a                              mov.l   r2, 8+arg_8[sp]
FFF2390E  a103                              mov.l   r3, 8+arg_4[sp]
FFF23910  3c0900                            mov.b   #0, 9[sp]
FFF23913  3c0b00                            mov.b   #0, 0Bh[sp]
FFF23916  3c0a00                            mov.b   #0, 0Ah[sp]
FFF23919  2e71                              bra.b   loc_FFF2398A
FFF2391B  b289                   loc_FFF2391B movu.b  0Bh[sp], r1
FFF2391D  a90a                              mov.l   8+arg_8[sp], r2
FFF2391F  fe421e                            mov.b   [r2, r1], r14
FFF23922  610e                              cmp     #0, r14
FFF23924  210f                              bne.b   loc_FFF23933
FFF23926  b289                              movu.b  0Bh[sp], r1
FFF23928  6101                              cmp     #0, r1
FFF2392A  2166                              bne.b   loc_FFF23990
FFF2392C  f906019d                          mov.l   #-63h, 8+var_4[sp]
FFF23930  380f01                            bra.w   loc_FFF23A3F
FFF23933  b289                   loc_FFF23933 movu.b  0Bh[sp], r1
FFF23935  a90a                              mov.l   8+arg_8[sp], r2
FFF23937  fe421e                            mov.b   [r2, r1], r14
FFF2393A  755e20                            cmp     #20h, r14 ; ' '
FFF2393D  18                                bne.s   loc_FFF23945
FFF2393E  f906019d                          mov.l   #-63h, 8+var_4[sp]
FFF23942  38fd00                            bra.w   loc_FFF23A3F
FFF23945  b289                   loc_FFF23945 movu.b  0Bh[sp], r1
FFF23947  a90a                              mov.l   8+arg_8[sp], r2
FFF23949  fe421e                            mov.b   [r2, r1], r14
FFF2394C  755e2e                            cmp     #2Eh, r14 ; '.'
FFF2394F  2135                              bne.b   loc_FFF23984
FFF23951  b289                              movu.b  0Bh[sp], r1
FFF23953  6181                              cmp     #8, r1
FFF23955  2a07                              bgt.b   loc_FFF2395C
FFF23957  b289                              movu.b  0Bh[sp], r1
FFF23959  6101                              cmp     #0, r1
FFF2395B  1d                                bne.s   loc_FFF23960
FFF2395C  f80601                 loc_FFF2395C mov.l   #1, 8+var_8[sp]
FFF2395F  0c                                bra.s   loc_FFF23963
FFF23960  f80600                 loc_FFF23960 mov.l   #0, 8+var_8[sp]
FFF23963  ec01                   loc_FFF23963 mov.l   8+var_8[sp], r1
FFF23965  6101                              cmp     #0, r1
FFF23967  1e                                bne.s   loc_FFF2396D
FFF23968  b281                   loc_FFF23968 movu.b  0Ah[sp], r1
FFF2396A  6101                              cmp     #0, r1
FFF2396C  15                                beq.s   loc_FFF23971
FFF2396D  f80601                 loc_FFF2396D mov.l   #1, 8+var_8[sp]
FFF23970  0c                                bra.s   loc_FFF23974
FFF23971  f80600                 loc_FFF23971 mov.l   #0, 8+var_8[sp]
FFF23974  ec01                   loc_FFF23974 mov.l   8+var_8[sp], r1
FFF23976  6101                              cmp     #0, r1
FFF23978  10                                beq.s   loc_FFF23980
FFF23979  f906019d                          mov.l   #-63h, 8+var_4[sp]
FFF2397D  38c200                            bra.w   loc_FFF23A3F
FFF23980  c5000b0a               loc_FFF23980 mov.b   0Bh[sp], 0Ah[sp]
FFF23984  b289                   loc_FFF23984 movu.b  0Bh[sp], r1
FFF23986  6211                              add     #1, r1
FFF23988  8289                              mov.b   r1, 0Bh[sp]
FFF2398A  b289                   loc_FFF2398A movu.b  0Bh[sp], r1
FFF2398C  61c1                              cmp     #0Ch, r1
FFF2398E  298d                              blt.b   loc_FFF2391B
FFF23990  b281                   loc_FFF23990 movu.b  0Ah[sp], r1
FFF23992  6101                              cmp     #0, r1
FFF23994  200f                              beq.b   loc_FFF239A3
FFF23996  b289                              movu.b  0Bh[sp], r1
FFF23998  41010a                            sub     0Ah[sp], r1
FFF2399B  6151                              cmp     #5, r1
FFF2399D  2906                              blt.b   loc_FFF239A3
FFF2399F  f80601                            mov.l   #1, 8+var_8[sp]
FFF239A2  0c                                bra.s   loc_FFF239A6
FFF239A3  f80600                 loc_FFF239A3 mov.l   #0, 8+var_8[sp]
FFF239A6  ec01                   loc_FFF239A6 mov.l   8+var_8[sp], r1
FFF239A8  6101                              cmp     #0, r1
FFF239AA  10                                beq.s   loc_FFF239B2
FFF239AB  f906019d                          mov.l   #-63h, 8+var_4[sp]
FFF239AF  389000                            bra.w   loc_FFF23A3F
FFF239B2  a901                   loc_FFF239B2 mov.l   8+arg_4[sp], r1
FFF239B4  ad9c                              mov.l   5Ch[r1], r4
FFF239B6  a981                              mov.l   8+arg_C[sp], r1
FFF239B8  66b3                              mov.l   #0Bh, r3
FFF239BA  754220                            mov.l   #20h, r2 ; ' '
FFF239BD  05f2aa00                          bsr.a   sub_FFF2E4AF
FFF239C1  a981                              mov.l   8+arg_C[sp], r1
FFF239C3  3c1b00                            mov.b   #0, 0Bh[r1]
FFF239C6  3c0a00                            mov.b   #0, 0Ah[sp]
FFF239C9  3c0b00                            mov.b   #0, 0Bh[sp]
FFF239CC  2e57                              bra.b   loc_FFF23A23
FFF239CE  b289                   loc_FFF239CE movu.b  0Bh[sp], r1
FFF239D0  a90a                              mov.l   8+arg_8[sp], r2
FFF239D2  fe421e                            mov.b   [r2, r1], r14
FFF239D5  610e                              cmp     #0, r14
FFF239D7  2065                              beq.b   loc_FFF23A3C
FFF239D9  b289                              movu.b  0Bh[sp], r1
FFF239DB  a90a                              mov.l   8+arg_8[sp], r2
FFF239DD  fe421e                            mov.b   [r2, r1], r14
FFF239E0  755e2e                            cmp     #2Eh, r14 ; '.'
FFF239E3  19                                bne.s   loc_FFF239EC
FFF239E4  3c0901                            mov.b   #1, 9[sp]
FFF239E7  3c0a07                            mov.b   #7, 0Ah[sp]
FFF239EA  2e10                              bra.b   loc_FFF239FA
FFF239EC  b289                   loc_FFF239EC movu.b  0Bh[sp], r1
FFF239EE  a90a                              mov.l   8+arg_8[sp], r2
FFF239F0  fec21e                            movu.b  [r2, r1], r14
FFF239F3  b281                              movu.b  0Ah[sp], r1
FFF239F5  a982                              mov.l   8+arg_C[sp], r2
FFF239F7  fe021e                            mov.b   r14, [r2, r1]
FFF239FA  b289                   loc_FFF239FA movu.b  0Bh[sp], r1
FFF239FC  6181                              cmp     #8, r1
FFF239FE  1a                                bne.s   loc_FFF23A08
FFF239FF  b209                              movu.b  9[sp], r1
FFF23A01  6101                              cmp     #0, r1
FFF23A03  1d                                bne.s   loc_FFF23A08
FFF23A04  f80601                            mov.l   #1, 8+var_8[sp]
FFF23A07  0c                                bra.s   loc_FFF23A0B
FFF23A08  f80600                 loc_FFF23A08 mov.l   #0, 8+var_8[sp]
FFF23A0B  ec01                   loc_FFF23A0B mov.l   8+var_8[sp], r1
FFF23A0D  6101                              cmp     #0, r1
FFF23A0F  10                                beq.s   loc_FFF23A17
FFF23A10  a981                              mov.l   8+arg_C[sp], r1
FFF23A12  f81400                            mov.b   #0, [r1]
FFF23A15  2e27                              bra.b   loc_FFF23A3C
FFF23A17  b289                   loc_FFF23A17 movu.b  0Bh[sp], r1
FFF23A19  6211                              add     #1, r1
FFF23A1B  8289                              mov.b   r1, 0Bh[sp]
FFF23A1D  b281                              movu.b  0Ah[sp], r1
FFF23A1F  6211                              add     #1, r1
FFF23A21  8281                              mov.b   r1, 0Ah[sp]
FFF23A23  b289                   loc_FFF23A23 movu.b  0Bh[sp], r1
FFF23A25  61b1                              cmp     #0Bh, r1
FFF23A27  2a0c                              bgt.b   loc_FFF23A33
FFF23A29  b281                              movu.b  0Ah[sp], r1
FFF23A2B  61b1                              cmp     #0Bh, r1
FFF23A2D  2a06                              bgt.b   loc_FFF23A33
FFF23A2F  f80601                            mov.l   #1, 8+var_8[sp]
FFF23A32  0c                                bra.s   loc_FFF23A36
FFF23A33  f80600                 loc_FFF23A33 mov.l   #0, 8+var_8[sp]
FFF23A36  ec01                   loc_FFF23A36 mov.l   8+var_8[sp], r1
FFF23A38  6101                              cmp     #0, r1
FFF23A3A  2194                              bne.b   loc_FFF239CE
FFF23A3C  3e0100                 loc_FFF23A3C mov.l   #0, 8+var_4[sp]
FFF23A3F  a809                   loc_FFF23A3F mov.l   8+var_4[sp], r1
FFF23A41  a089                              mov.l   r1, 8+arg_0[sp]
FFF23A43  6707                              rtsd    #7
FFF23A45  7100d4                 sub_FFF23A45 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF23A45
FFF23A48  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF23A4A  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF23A4C  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF23A4E  e5000a03                          mov.l   2Ch+var_4[sp], 2Ch+var_20[sp]
FFF23A52  710110                            add     #2Ch+var_1C, sp, r1
FFF23A55  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF23A57  aa03                              mov.l   2Ch+var_C[sp], r3
FFF23A59  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF23A5B  710110                            add     #2Ch+var_1C, sp, r1
FFF23A5E  39a9fe                            bsr.w   sub_FFF23904+3
FFF23A61  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF23A63  a809                              mov.l   2Ch+var_28[sp], r1
FFF23A65  6101                              cmp     #0, r1
FFF23A67  16                                beq.s   loc_FFF23A6D
FFF23A68  e10001                            mov.l   2Ch+var_28[sp], 2Ch+var_2C[sp]
FFF23A6B  2e34                              bra.b   loc_FFF23A9F
FFF23A6D  a881                   loc_FFF23A6D mov.l   2Ch+var_24[sp], r1
FFF23A6F  581e                              movu.b  [r1], r14
FFF23A71  610e                              cmp     #0, r14
FFF23A73  2121                              bne.b   loc_FFF23A94
FFF23A75  f8069d                            mov.l   #-63h, 2Ch+var_2C[sp]
FFF23A78  2e27                              bra.b   loc_FFF23A9F
FFF23A7A  a881                   loc_FFF23A7A mov.l   2Ch+var_24[sp], r1
FFF23A7C  581e                              movu.b  [r1], r14
FFF23A7E  6211                              add     #1, r1
FFF23A80  a88a                              mov.l   2Ch+var_20[sp], r2
FFF23A82  582f                              movu.b  [r2], r15
FFF23A84  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF23A86  a889                              mov.l   2Ch+var_20[sp], r1
FFF23A88  6211                              add     #1, r1
FFF23A8A  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF23A8C  47fe                              cmp     r15, r14
FFF23A8E  16                                beq.s   loc_FFF23A94
FFF23A8F  f8069d                            mov.l   #-63h, 2Ch+var_2C[sp]
FFF23A92  2e0d                              bra.b   loc_FFF23A9F
FFF23A94  a881                   loc_FFF23A94 mov.l   2Ch+var_24[sp], r1
FFF23A96  581e                              movu.b  [r1], r14
FFF23A98  610e                              cmp     #0, r14
FFF23A9A  21e0                              bne.b   loc_FFF23A7A
FFF23A9C  f80600                            mov.l   #0, 2Ch+var_2C[sp]
FFF23A9F  ec01                   loc_FFF23A9F mov.l   2Ch+var_2C[sp], r1
FFF23AA1  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF23AA3  670b                              rtsd    #0Bh
FFF23AA5  7100d4                 sub_FFF23AA5 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF23AA5
FFF23AA8  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF23AAA  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF23AAC  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF23AAE  e5000a03                          mov.l   2Ch+var_4[sp], 2Ch+var_20[sp]
FFF23AB2  710110                            add     #2Ch+var_1C, sp, r1
FFF23AB5  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF23AB7  aa03                              mov.l   2Ch+var_C[sp], r3
FFF23AB9  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF23ABB  710110                            add     #2Ch+var_1C, sp, r1
FFF23ABE  3949fe                            bsr.w   sub_FFF23904+3
FFF23AC1  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF23AC3  a809                              mov.l   2Ch+var_28[sp], r1
FFF23AC5  6101                              cmp     #0, r1
FFF23AC7  16                                beq.s   loc_FFF23ACD
FFF23AC8  e10001                            mov.l   2Ch+var_28[sp], 2Ch+var_2C[sp]
FFF23ACB  2e69                              bra.b   loc_FFF23B34
FFF23ACD  a881                   loc_FFF23ACD mov.l   2Ch+var_24[sp], r1
FFF23ACF  581e                              movu.b  [r1], r14
FFF23AD1  610e                              cmp     #0, r14
FFF23AD3  1e                                bne.s   loc_FFF23AD9
FFF23AD4  f8069d                            mov.l   #-63h, 2Ch+var_2C[sp]
FFF23AD7  2e5d                              bra.b   loc_FFF23B34
FFF23AD9  a881                   loc_FFF23AD9 mov.l   2Ch+var_24[sp], r1
FFF23ADB  581e                              movu.b  [r1], r14
FFF23ADD  755ee5                            cmp     #-1Bh, r14
FFF23AE0  2149                              bne.b   loc_FFF23B29
FFF23AE2  a881                              mov.l   2Ch+var_24[sp], r1
FFF23AE4  f81405                            mov.b   #5, [r1]
FFF23AE7  2e42                              bra.b   loc_FFF23B29
FFF23AE9  a881                   loc_FFF23AE9 mov.l   2Ch+var_24[sp], r1
FFF23AEB  5811                              movu.b  [r1], r1
FFF23AED  05eca000                          bsr.a   sub_FFF2DBD9
FFF23AF1  6101                              cmp     #0, r1
FFF23AF3  201c                              beq.b   loc_FFF23B0F
FFF23AF5  a881                              mov.l   2Ch+var_24[sp], r1
FFF23AF7  581e                              movu.b  [r1], r14
FFF23AF9  6211                              add     #1, r1
FFF23AFB  a88a                              mov.l   2Ch+var_20[sp], r2
FFF23AFD  582f                              movu.b  [r2], r15
FFF23AFF  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF23B01  a889                              mov.l   2Ch+var_20[sp], r1
FFF23B03  6211                              add     #1, r1
FFF23B05  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF23B07  47fe                              cmp     r15, r14
FFF23B09  16                                beq.s   loc_FFF23B0F
FFF23B0A  f8069d                            mov.l   #-63h, 2Ch+var_2C[sp]
FFF23B0D  2e27                              bra.b   loc_FFF23B34
FFF23B0F  a881                   loc_FFF23B0F mov.l   2Ch+var_24[sp], r1
FFF23B11  581e                              movu.b  [r1], r14
FFF23B13  6211                              add     #1, r1
FFF23B15  a88a                              mov.l   2Ch+var_20[sp], r2
FFF23B17  582f                              movu.b  [r2], r15
FFF23B19  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF23B1B  a889                              mov.l   2Ch+var_20[sp], r1
FFF23B1D  6211                              add     #1, r1
FFF23B1F  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF23B21  47fe                              cmp     r15, r14
FFF23B23  16                                beq.s   loc_FFF23B29
FFF23B24  f8069d                            mov.l   #-63h, 2Ch+var_2C[sp]
FFF23B27  2e0d                              bra.b   loc_FFF23B34
FFF23B29  a881                   loc_FFF23B29 mov.l   2Ch+var_24[sp], r1
FFF23B2B  581e                              movu.b  [r1], r14
FFF23B2D  610e                              cmp     #0, r14
FFF23B2F  21ba                              bne.b   loc_FFF23AE9
FFF23B31  f80600                            mov.l   #0, 2Ch+var_2C[sp]
FFF23B34  ec01                   loc_FFF23B34 mov.l   2Ch+var_2C[sp], r1
FFF23B36  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF23B38  670b                              rtsd    #0Bh
FFF23B3A  60c0                   sub_FFF23B3A sub     #0Ch, sp   ; <<<< FUNC sub_FFF23B3A
FFF23B3C  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23B3E  b909                              movu.w  0Ch+var_2[sp], r1
FFF23B40  5b1e                              movu.b  r1, r14
FFF23B42  610e                              cmp     #0, r14
FFF23B44  212b                              bne.b   loc_FFF23B6F
FFF23B46  76010061                          cmp     #6100h, r1
FFF23B4A  290e                              blt.b   loc_FFF23B58
FFF23B4C  b909                              movu.w  0Ch+var_2[sp], r1
FFF23B4E  7601007a                          cmp     #7A00h, r1
FFF23B52  2a06                              bgt.b   loc_FFF23B58
FFF23B54  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23B57  0c                                bra.s   loc_FFF23B5B
FFF23B58  f80600                 loc_FFF23B58 mov.l   #0, 0Ch+var_C[sp]
FFF23B5B  ec01                   loc_FFF23B5B mov.l   0Ch+var_C[sp], r1
FFF23B5D  6101                              cmp     #0, r1
FFF23B5F  11                                beq.s   loc_FFF23B68
FFF23B60  b909                              movu.w  0Ch+var_2[sp], r1
FFF23B62  721100e0                          add     #-2000h, r1, r1
FFF23B66  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23B68  d5000503               loc_FFF23B68 mov.w   0Ch+var_2[sp], 0Ch+var_6[sp]
FFF23B6C  384a01                            bra.w   loc_FFF23CB6
FFF23B6F  5b1e                   loc_FFF23B6F movu.b  r1, r14
FFF23B71  755eff                            cmp     #-1, r14
FFF23B74  b909                              movu.w  0Ch+var_2[sp], r1
FFF23B76  212b                              bne.b   loc_FFF23BA1
FFF23B78  7601ff41                          cmp     #41FFh, r1
FFF23B7C  290e                              blt.b   loc_FFF23B8A
FFF23B7E  b909                              movu.w  0Ch+var_2[sp], r1
FFF23B80  7601ff5a                          cmp     #5AFFh, r1
FFF23B84  2a06                              bgt.b   loc_FFF23B8A
FFF23B86  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23B89  0c                                bra.s   loc_FFF23B8D
FFF23B8A  f80600                 loc_FFF23B8A mov.l   #0, 0Ch+var_C[sp]
FFF23B8D  ec01                   loc_FFF23B8D mov.l   0Ch+var_C[sp], r1
FFF23B8F  6101                              cmp     #0, r1
FFF23B91  11                                beq.s   loc_FFF23B9A
FFF23B92  b909                              movu.w  0Ch+var_2[sp], r1
FFF23B94  721100e0                          add     #-2000h, r1, r1
FFF23B98  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23B9A  d5000503               loc_FFF23B9A mov.w   0Ch+var_2[sp], 0Ch+var_6[sp]
FFF23B9E  381801                            bra.w   loc_FFF23CB6
FFF23BA1  5b1e                   loc_FFF23BA1 movu.b  r1, r14
FFF23BA3  613e                              cmp     #3, r14
FFF23BA5  b909                              movu.w  0Ch+var_2[sp], r1
FFF23BA7  2153                              bne.b   loc_FFF23BFA
FFF23BA9  770103b100                        cmp     #0B103h, r1
FFF23BAE  290f                              blt.b   loc_FFF23BBD
FFF23BB0  b909                              movu.w  0Ch+var_2[sp], r1
FFF23BB2  770103c100                        cmp     #0C103h, r1
FFF23BB7  2a06                              bgt.b   loc_FFF23BBD
FFF23BB9  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23BBC  0c                                bra.s   loc_FFF23BC0
FFF23BBD  f80600                 loc_FFF23BBD mov.l   #0, 0Ch+var_C[sp]
FFF23BC0  ec01                   loc_FFF23BC0 mov.l   0Ch+var_C[sp], r1
FFF23BC2  6101                              cmp     #0, r1
FFF23BC4  b909                              movu.w  0Ch+var_2[sp], r1
FFF23BC6  11                                beq.s   loc_FFF23BCF
FFF23BC7  721100e0                          add     #-2000h, r1, r1
FFF23BCB  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23BCD  2e26                              bra.b   loc_FFF23BF3
FFF23BCF  770103c300             loc_FFF23BCF cmp     #0C303h, r1
FFF23BD4  290f                              blt.b   loc_FFF23BE3
FFF23BD6  b909                              movu.w  0Ch+var_2[sp], r1
FFF23BD8  770103c900                        cmp     #0C903h, r1
FFF23BDD  2a06                              bgt.b   loc_FFF23BE3
FFF23BDF  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23BE2  0c                                bra.s   loc_FFF23BE6
FFF23BE3  f80600                 loc_FFF23BE3 mov.l   #0, 0Ch+var_C[sp]
FFF23BE6  ec01                   loc_FFF23BE6 mov.l   0Ch+var_C[sp], r1
FFF23BE8  6101                              cmp     #0, r1
FFF23BEA  11                                beq.s   loc_FFF23BF3
FFF23BEB  b909                              movu.w  0Ch+var_2[sp], r1
FFF23BED  721100e0                          add     #-2000h, r1, r1
FFF23BF1  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23BF3  d5000503               loc_FFF23BF3 mov.w   0Ch+var_2[sp], 0Ch+var_6[sp]
FFF23BF7  38bf00                            bra.w   loc_FFF23CB6
FFF23BFA  5b1e                   loc_FFF23BFA movu.b  r1, r14
FFF23BFC  614e                              cmp     #4, r14
FFF23BFE  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C00  3b8200                            bne.w   loc_FFF23C82
FFF23C03  76010430                          cmp     #3004h, r1
FFF23C07  290e                              blt.b   loc_FFF23C15
FFF23C09  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C0B  76010435                          cmp     #3504h, r1
FFF23C0F  2a06                              bgt.b   loc_FFF23C15
FFF23C11  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23C14  0c                                bra.s   loc_FFF23C18
FFF23C15  f80600                 loc_FFF23C15 mov.l   #0, 0Ch+var_C[sp]
FFF23C18  ec01                   loc_FFF23C18 mov.l   0Ch+var_C[sp], r1
FFF23C1A  6101                              cmp     #0, r1
FFF23C1C  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C1E  11                                beq.s   loc_FFF23C27
FFF23C1F  721100e0                          add     #-2000h, r1, r1
FFF23C23  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23C25  2e57                              bra.b   loc_FFF23C7C
FFF23C27  76010451               loc_FFF23C27 cmp     #5104h, r1
FFF23C2B  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C2D  19                                bne.s   loc_FFF23C36
FFF23C2E  721100b0                          add     #-5000h, r1, r1
FFF23C32  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23C34  2e48                              bra.b   loc_FFF23C7C
FFF23C36  76010436               loc_FFF23C36 cmp     #3604h, r1
FFF23C3A  290e                              blt.b   loc_FFF23C48
FFF23C3C  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C3E  7601043d                          cmp     #3D04h, r1
FFF23C42  2a06                              bgt.b   loc_FFF23C48
FFF23C44  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23C47  0c                                bra.s   loc_FFF23C4B
FFF23C48  f80600                 loc_FFF23C48 mov.l   #0, 0Ch+var_C[sp]
FFF23C4B  ec01                   loc_FFF23C4B mov.l   0Ch+var_C[sp], r1
FFF23C4D  6101                              cmp     #0, r1
FFF23C4F  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C51  11                                beq.s   loc_FFF23C5A
FFF23C52  721100e0                          add     #-2000h, r1, r1
FFF23C56  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23C58  2e24                              bra.b   loc_FFF23C7C
FFF23C5A  7601043e               loc_FFF23C5A cmp     #3E04h, r1
FFF23C5E  290e                              blt.b   loc_FFF23C6C
FFF23C60  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C62  7601044f                          cmp     #4F04h, r1
FFF23C66  2a06                              bgt.b   loc_FFF23C6C
FFF23C68  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23C6B  0c                                bra.s   loc_FFF23C6F
FFF23C6C  f80600                 loc_FFF23C6C mov.l   #0, 0Ch+var_C[sp]
FFF23C6F  ec01                   loc_FFF23C6F mov.l   0Ch+var_C[sp], r1
FFF23C71  6101                              cmp     #0, r1
FFF23C73  11                                beq.s   loc_FFF23C7C
FFF23C74  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C76  721100e0                          add     #-2000h, r1, r1
FFF23C7A  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23C7C  d5000503               loc_FFF23C7C mov.w   0Ch+var_2[sp], 0Ch+var_6[sp]
FFF23C80  2e36                              bra.b   loc_FFF23CB6
FFF23C82  5b1e                   loc_FFF23C82 movu.b  r1, r14
FFF23C84  755e21                            cmp     #21h, r14 ; '!'
FFF23C87  9909                              mov.w   0Ch+var_2[sp], r1
FFF23C89  212b                              bne.b   loc_FFF23CB4
FFF23C8B  5f1e                              movu.w  r1, r14
FFF23C8D  760e2170                          cmp     #7021h, r14
FFF23C91  290e                              blt.b   loc_FFF23C9F
FFF23C93  b909                              movu.w  0Ch+var_2[sp], r1
FFF23C95  76012179                          cmp     #7921h, r1
FFF23C99  2a06                              bgt.b   loc_FFF23C9F
FFF23C9B  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF23C9E  0c                                bra.s   loc_FFF23CA2
FFF23C9F  f80600                 loc_FFF23C9F mov.l   #0, 0Ch+var_C[sp]
FFF23CA2  ec01                   loc_FFF23CA2 mov.l   0Ch+var_C[sp], r1
FFF23CA4  6101                              cmp     #0, r1
FFF23CA6  11                                beq.s   loc_FFF23CAF
FFF23CA7  b909                              movu.w  0Ch+var_2[sp], r1
FFF23CA9  721100f0                          add     #-1000h, r1, r1
FFF23CAD  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF23CAF  d5000503               loc_FFF23CAF mov.w   0Ch+var_2[sp], 0Ch+var_6[sp]
FFF23CB3  0b                                bra.s   loc_FFF23CB6
FFF23CB4  9089                   loc_FFF23CB4 mov.w   r1, 0Ch+var_6[sp]
FFF23CB6  d5000304               loc_FFF23CB6 mov.w   0Ch+var_6[sp], 0Ch+var_4[sp]
FFF23CBA  9901                              mov.w   0Ch+var_4[sp], r1
FFF23CBC  5f11                              movu.w  r1, r1
FFF23CBE  6703                              rtsd    #3
FFF23CC0  7ea6                   sub_FFF23CC0 push.l  r6   ; <<<< FUNC sub_FFF23CC0
FFF23CC2  7100e8                            add     #-18h, sp, sp
FFF23CC5  a109                              mov.l   r1, 18h+var_4[sp]
FFF23CC7  a102                              mov.l   r2, 18h+var_8[sp]
FFF23CC9  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF23CCC  2e50                              bra.b   loc_FFF23D1C
FFF23CCE  b901                   loc_FFF23CCE movu.w  18h+var_10[sp], r1
FFF23CD0  6101                              cmp     #0, r1
FFF23CD2  1d                                bne.s   loc_FFF23CD7
FFF23CD3  f80601                            mov.l   #1, 18h+var_18[sp]
FFF23CD6  0c                                bra.s   loc_FFF23CDA
FFF23CD7  f80600                 loc_FFF23CD7 mov.l   #0, 18h+var_18[sp]
FFF23CDA  ec01                   loc_FFF23CDA mov.l   18h+var_18[sp], r1
FFF23CDC  6101                              cmp     #0, r1
FFF23CDE  2150                              bne.b   loc_FFF23D2E
FFF23CE0  b909                              movu.w  18h+var_E[sp], r1
FFF23CE2  6101                              cmp     #0, r1
FFF23CE4  1f                                bne.s   loc_FFF23CEB
FFF23CE5  f90601ff                          mov.l   #-1, 18h+var_14[sp]
FFF23CE9  2e45                              bra.b   loc_FFF23D2E
FFF23CEB  b901                   loc_FFF23CEB movu.w  18h+var_10[sp], r1
FFF23CED  6101                              cmp     #0, r1
FFF23CEF  1e                                bne.s   loc_FFF23CF5
FFF23CF0  3e0101                            mov.l   #1, 18h+var_14[sp]
FFF23CF3  2e3b                              bra.b   loc_FFF23D2E
FFF23CF5  b909                   loc_FFF23CF5 movu.w  18h+var_E[sp], r1
FFF23CF7  3943fe                            bsr.w   sub_FFF23B3A
FFF23CFA  ef16                              mov.l   r1, r6
FFF23CFC  b901                              movu.w  18h+var_10[sp], r1
FFF23CFE  393cfe                            bsr.w   sub_FFF23B3A
FFF23D01  4316                              sub     r1, r6
FFF23D03  910e                              mov.w   r6, 18h+var_E[sp]
FFF23D05  b909                              movu.w  18h+var_E[sp], r1
FFF23D07  6101                              cmp     #0, r1
FFF23D09  17                                beq.s   loc_FFF23D10
FFF23D0A  b909                              movu.w  18h+var_E[sp], r1
FFF23D0C  a009                              mov.l   r1, 18h+var_14[sp]
FFF23D0E  2e20                              bra.b   loc_FFF23D2E
FFF23D10  a909                   loc_FFF23D10 mov.l   18h+var_4[sp], r1
FFF23D12  6221                              add     #2, r1
FFF23D14  a109                              mov.l   r1, 18h+var_4[sp]
FFF23D16  a901                              mov.l   18h+var_8[sp], r1
FFF23D18  6221                              add     #2, r1
FFF23D1A  a101                              mov.l   r1, 18h+var_8[sp]
FFF23D1C  a909                   loc_FFF23D1C mov.l   18h+var_4[sp], r1
FFF23D1E  d41005                            mov.w   [r1], 18h+var_E[sp]
FFF23D21  a901                              mov.l   18h+var_8[sp], r1
FFF23D23  d41004                            mov.w   [r1], 18h+var_10[sp]
FFF23D26  b909                              movu.w  18h+var_E[sp], r1
FFF23D28  6101                              cmp     #0, r1
FFF23D2A  20a4                              beq.b   loc_FFF23CCE
FFF23D2C  2eab                              bra.b   loc_FFF23CD7
FFF23D2E  a809                   loc_FFF23D2E mov.l   18h+var_14[sp], r1
FFF23D30  a089                              mov.l   r1, 18h+var_C[sp]
FFF23D32  3f6607                            rtsd    #1Ch, r6-r6
FFF23D35  7ea6                   sub_FFF23D35 push.l  r6   ; <<<< FUNC sub_FFF23D35
FFF23D37  7100e0                            add     #-20h, sp, sp
FFF23D3A  a189                              mov.l   r1, 20h+var_4[sp]
FFF23D3C  a182                              mov.l   r2, 20h+var_8[sp]
FFF23D3E  a10b                              mov.l   r3, 20h+var_C[sp]
FFF23D40  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF23D43  3e0100                            mov.l   #0, 20h+var_1C[sp]
FFF23D46  2e65                              bra.b   loc_FFF23DAB
FFF23D48  a989                   loc_FFF23D48 mov.l   20h+var_4[sp], r1
FFF23D4A  d41007                            mov.w   [r1], 20h+var_12[sp]
FFF23D4D  a981                              mov.l   20h+var_8[sp], r1
FFF23D4F  d41006                            mov.w   [r1], 20h+var_14[sp]
FFF23D52  b989                              movu.w  20h+var_12[sp], r1
FFF23D54  6101                              cmp     #0, r1
FFF23D56  1a                                bne.s   loc_FFF23D60
FFF23D57  b981                              movu.w  20h+var_14[sp], r1
FFF23D59  6101                              cmp     #0, r1
FFF23D5B  1d                                bne.s   loc_FFF23D60
FFF23D5C  f80601                            mov.l   #1, 20h+var_20[sp]
FFF23D5F  0c                                bra.s   loc_FFF23D63
FFF23D60  f80600                 loc_FFF23D60 mov.l   #0, 20h+var_20[sp]
FFF23D63  ec01                   loc_FFF23D63 mov.l   20h+var_20[sp], r1
FFF23D65  6101                              cmp     #0, r1
FFF23D67  214c                              bne.b   loc_FFF23DB3
FFF23D69  b989                              movu.w  20h+var_12[sp], r1
FFF23D6B  6101                              cmp     #0, r1
FFF23D6D  1f                                bne.s   loc_FFF23D74
FFF23D6E  f90602ff                          mov.l   #-1, 20h+var_18[sp]
FFF23D72  2e41                              bra.b   loc_FFF23DB3
FFF23D74  b981                   loc_FFF23D74 movu.w  20h+var_14[sp], r1
FFF23D76  6101                              cmp     #0, r1
FFF23D78  1e                                bne.s   loc_FFF23D7E
FFF23D79  3e0201                            mov.l   #1, 20h+var_18[sp]
FFF23D7C  2e37                              bra.b   loc_FFF23DB3
FFF23D7E  b989                   loc_FFF23D7E movu.w  20h+var_12[sp], r1
FFF23D80  39bafd                            bsr.w   sub_FFF23B3A
FFF23D83  ef16                              mov.l   r1, r6
FFF23D85  b981                              movu.w  20h+var_14[sp], r1
FFF23D87  39b3fd                            bsr.w   sub_FFF23B3A
FFF23D8A  4316                              sub     r1, r6
FFF23D8C  918e                              mov.w   r6, 20h+var_12[sp]
FFF23D8E  b989                              movu.w  20h+var_12[sp], r1
FFF23D90  6101                              cmp     #0, r1
FFF23D92  17                                beq.s   loc_FFF23D99
FFF23D93  b989                              movu.w  20h+var_12[sp], r1
FFF23D95  a081                              mov.l   r1, 20h+var_18[sp]
FFF23D97  2e1c                              bra.b   loc_FFF23DB3
FFF23D99  a809                   loc_FFF23D99 mov.l   20h+var_1C[sp], r1
FFF23D9B  6211                              add     #1, r1
FFF23D9D  a009                              mov.l   r1, 20h+var_1C[sp]
FFF23D9F  a989                              mov.l   20h+var_4[sp], r1
FFF23DA1  6221                              add     #2, r1
FFF23DA3  a189                              mov.l   r1, 20h+var_4[sp]
FFF23DA5  a981                              mov.l   20h+var_8[sp], r1
FFF23DA7  6221                              add     #2, r1
FFF23DA9  a181                              mov.l   r1, 20h+var_8[sp]
FFF23DAB  a809                   loc_FFF23DAB mov.l   20h+var_1C[sp], r1
FFF23DAD  06850105                          cmp     20h+var_C[sp].l, r1
FFF23DB1  2397                              bltu.b  loc_FFF23D48
FFF23DB3  a881                   loc_FFF23DB3 mov.l   20h+var_18[sp], r1
FFF23DB5  a101                              mov.l   r1, 20h+var_10[sp]
FFF23DB7  3f6609                            rtsd    #24h, r6-r6
FFF23DBA  7100ec                 sub_FFF23DBA add     #-14h, sp, sp   ; <<<< FUNC sub_FFF23DBA
FFF23DBD  a101                              mov.l   r1, 14h+var_4[sp]
FFF23DBF  a08a                              mov.l   r2, 14h+var_8[sp]
FFF23DC1  a00a                              mov.l   r2, 14h+var_10[sp]
FFF23DC3  a901                              mov.l   14h+var_4[sp], r1
FFF23DC5  3e1c00                            mov.l   #0, 30h[r1]
FFF23DC8  a809                              mov.l   14h+var_10[sp], r1
FFF23DCA  6231                              add     #3, r1
FFF23DCC  6653                              mov.l   #5, r3
FFF23DCE  fb2214aef4ff                      mov.l   #aExfat, r2; "EXFAT"
FFF23DD4  05a91702                          bsr.a   sub_FFF4557D
FFF23DD8  6101                              cmp     #0, r1
FFF23DDA  18                                bne.s   loc_FFF23DE2
FFF23DDB  a901                              mov.l   14h+var_4[sp], r1
FFF23DDD  3c9040                            mov.b   #40h, 10h[r1] ; '@'
FFF23DE0  2e57                              bra.b   loc_FFF23E37
FFF23DE2  a809                   loc_FFF23DE2 mov.l   14h+var_10[sp], r1
FFF23DE4  711152                            add     #52h, r1, r1 ; 'R'
FFF23DE7  6653                              mov.l   #5, r3
FFF23DE9  fb221aaef4ff                      mov.l   #aFat32, r2; "FAT32"
FFF23DEF  058e1702                          bsr.a   sub_FFF4557D
FFF23DF3  6101                              cmp     #0, r1
FFF23DF5  18                                bne.s   loc_FFF23DFD
FFF23DF6  a901                              mov.l   14h+var_4[sp], r1
FFF23DF8  3c9020                            mov.b   #20h, 10h[r1] ; ' '
FFF23DFB  2e3c                              bra.b   loc_FFF23E37
FFF23DFD  a809                   loc_FFF23DFD mov.l   14h+var_10[sp], r1
FFF23DFF  711136                            add     #36h, r1, r1 ; '6'
FFF23E02  6653                              mov.l   #5, r3
FFF23E04  fb2220aef4ff                      mov.l   #aFat12, r2; "FAT12"
FFF23E0A  05731702                          bsr.a   sub_FFF4557D
FFF23E0E  6101                              cmp     #0, r1
FFF23E10  18                                bne.s   loc_FFF23E18
FFF23E11  a901                              mov.l   14h+var_4[sp], r1
FFF23E13  3c900c                            mov.b   #0Ch, 10h[r1]
FFF23E16  2e21                              bra.b   loc_FFF23E37
FFF23E18  a809                   loc_FFF23E18 mov.l   14h+var_10[sp], r1
FFF23E1A  711136                            add     #36h, r1, r1 ; '6'
FFF23E1D  6653                              mov.l   #5, r3
FFF23E1F  fb2226aef4ff                      mov.l   #aFat16, r2; "FAT16"
FFF23E25  05581702                          bsr.a   sub_FFF4557D
FFF23E29  6101                              cmp     #0, r1
FFF23E2B  1f                                bne.s   loc_FFF23E32
FFF23E2C  a901                              mov.l   14h+var_4[sp], r1
FFF23E2E  3c9010                            mov.b   #10h, 10h[r1]
FFF23E31  0e                                bra.s   loc_FFF23E37
FFF23E32  f806ff                 loc_FFF23E32 mov.l   #-1, 14h+var_14[sp]
FFF23E35  2e11                              bra.b   loc_FFF23E46
FFF23E37  a901                   loc_FFF23E37 mov.l   14h+var_4[sp], r1
FFF23E39  8c11                              mov.b   10h[r1], r1
FFF23E3B  755140                            cmp     #40h, r1 ; '@'
FFF23E3E  1d                                bne.s   loc_FFF23E43
FFF23E3F  f806ff                            mov.l   #-1, 14h+var_14[sp]
FFF23E42  0c                                bra.s   loc_FFF23E46
FFF23E43  f80600                 loc_FFF23E43 mov.l   #0, 14h+var_14[sp]
FFF23E46  ec01                   loc_FFF23E46 mov.l   14h+var_14[sp], r1
FFF23E48  a081                              mov.l   r1, 14h+var_C[sp]
FFF23E4A  6705                              rtsd    #5
FFF23E4C  7ea6                   sub_FFF23E4C push.l  r6   ; <<<< FUNC sub_FFF23E4C
FFF23E4E  7100ec                            add     #-14h, sp, sp
FFF23E51  a101                              mov.l   r1, 14h+var_4[sp]
FFF23E53  a08a                              mov.l   r2, 14h+var_8[sp]
FFF23E55  6643                              mov.l   #4, r3
FFF23E57  fbe22caef4ff                      mov.l   #aRraa, r14; "RRaA"
FFF23E5D  ef21                              mov.l   r2, r1
FFF23E5F  efe2                              mov.l   r14, r2
FFF23E61  051c1702                          bsr.a   sub_FFF4557D
FFF23E65  6101                              cmp     #0, r1
FFF23E67  17                                beq.s   loc_FFF23E6E
FFF23E68  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF23E6C  2e63                              bra.b   loc_FFF23ECF
FFF23E6E  a889                   loc_FFF23E6E mov.l   14h+var_8[sp], r1
FFF23E70  7211e401                          add     #1E4h, r1, r1
FFF23E74  6643                              mov.l   #4, r3
FFF23E76  fb2231aef4ff                      mov.l   #aRraa_0, r2; "rrAa"
FFF23E7C  05011702                          bsr.a   sub_FFF4557D
FFF23E80  6101                              cmp     #0, r1
FFF23E82  17                                beq.s   loc_FFF23E89
FFF23E83  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF23E87  2e48                              bra.b   loc_FFF23ECF
FFF23E89  a889                   loc_FFF23E89 mov.l   14h+var_8[sp], r1
FFF23E8B  5a1efe01                          movu.b  1FEh[r1], r14
FFF23E8F  755e55                            cmp     #55h, r14 ; 'U'
FFF23E92  210c                              bne.b   loc_FFF23E9E
FFF23E94  a889                              mov.l   14h+var_8[sp], r1
FFF23E96  5a1eff01                          movu.b  1FFh[r1], r14
FFF23E9A  755eaa                            cmp     #-56h, r14
FFF23E9D  15                                beq.s   loc_FFF23EA2
FFF23E9E  f80601                 loc_FFF23E9E mov.l   #1, 14h+var_14[sp]
FFF23EA1  0c                                bra.s   loc_FFF23EA5
FFF23EA2  f80600                 loc_FFF23EA2 mov.l   #0, 14h+var_14[sp]
FFF23EA5  ec01                   loc_FFF23EA5 mov.l   14h+var_14[sp], r1
FFF23EA7  6101                              cmp     #0, r1
FFF23EA9  17                                beq.s   loc_FFF23EB0
FFF23EAA  f90601ff                          mov.l   #-1, 14h+var_10[sp]
FFF23EAE  2e21                              bra.b   loc_FFF23ECF
FFF23EB0  a889                   loc_FFF23EB0 mov.l   14h+var_8[sp], r1
FFF23EB2  a906                              mov.l   14h+var_4[sp], r6
FFF23EB4  7211e801                          add     #1E8h, r1, r1
FFF23EB8  0562ae00                          bsr.a   sub_FFF2ED1A
FFF23EBC  a3e9                              mov.l   r1, 3Ch[r6]
FFF23EBE  a889                              mov.l   14h+var_8[sp], r1
FFF23EC0  a906                              mov.l   14h+var_4[sp], r6
FFF23EC2  7211ec01                          add     #1ECh, r1, r1
FFF23EC6  0554ae00                          bsr.a   sub_FFF2ED1A
FFF23ECA  a461                              mov.l   r1, 40h[r6]
FFF23ECC  3e0100                            mov.l   #0, 14h+var_10[sp]
FFF23ECF  a809                   loc_FFF23ECF mov.l   14h+var_10[sp], r1
FFF23ED1  a081                              mov.l   r1, 14h+var_C[sp]
FFF23ED3  3f6606                            rtsd    #18h, r6-r6
FFF23ED6  7ea6                   sub_FFF23ED6 push.l  r6   ; <<<< FUNC sub_FFF23ED6
FFF23ED8  7100f0                            add     #-10h, sp, sp
FFF23EDB  a089                              mov.l   r1, 10h+var_4[sp]
FFF23EDD  a082                              mov.l   r2, 10h+var_8[sp]
FFF23EDF  ef21                              mov.l   r2, r1
FFF23EE1  6231                              add     #3, r1
FFF23EE3  6653                              mov.l   #5, r3
FFF23EE5  fb2214aef4ff                      mov.l   #aExfat, r2; "EXFAT"
FFF23EEB  05921602                          bsr.a   sub_FFF4557D
FFF23EEF  6101                              cmp     #0, r1
FFF23EF1  18                                bne.s   loc_FFF23EF9
FFF23EF2  a889                              mov.l   10h+var_4[sp], r1
FFF23EF4  3c9040                            mov.b   #40h, 10h[r1] ; '@'
FFF23EF7  2e58                              bra.b   loc_FFF23F4F
FFF23EF9  a881                   loc_FFF23EF9 mov.l   10h+var_8[sp], r1
FFF23EFB  711152                            add     #52h, r1, r1 ; 'R'
FFF23EFE  6653                              mov.l   #5, r3
FFF23F00  fb221aaef4ff                      mov.l   #aFat32, r2; "FAT32"
FFF23F06  05771602                          bsr.a   sub_FFF4557D
FFF23F0A  6101                              cmp     #0, r1
FFF23F0C  18                                bne.s   loc_FFF23F14
FFF23F0D  a889                              mov.l   10h+var_4[sp], r1
FFF23F0F  3c9020                            mov.b   #20h, 10h[r1] ; ' '
FFF23F12  2e3d                              bra.b   loc_FFF23F4F
FFF23F14  a881                   loc_FFF23F14 mov.l   10h+var_8[sp], r1
FFF23F16  711136                            add     #36h, r1, r1 ; '6'
FFF23F19  6653                              mov.l   #5, r3
FFF23F1B  fb2220aef4ff                      mov.l   #aFat12, r2; "FAT12"
FFF23F21  055c1602                          bsr.a   sub_FFF4557D
FFF23F25  6101                              cmp     #0, r1
FFF23F27  18                                bne.s   loc_FFF23F2F
FFF23F28  a889                              mov.l   10h+var_4[sp], r1
FFF23F2A  3c900c                            mov.b   #0Ch, 10h[r1]
FFF23F2D  2e22                              bra.b   loc_FFF23F4F
FFF23F2F  a881                   loc_FFF23F2F mov.l   10h+var_8[sp], r1
FFF23F31  711136                            add     #36h, r1, r1 ; '6'
FFF23F34  6653                              mov.l   #5, r3
FFF23F36  fb2226aef4ff                      mov.l   #aFat16, r2; "FAT16"
FFF23F3C  05411602                          bsr.a   sub_FFF4557D
FFF23F40  6101                              cmp     #0, r1
FFF23F42  1f                                bne.s   loc_FFF23F49
FFF23F43  a889                              mov.l   10h+var_4[sp], r1
FFF23F45  3c9010                            mov.b   #10h, 10h[r1]
FFF23F48  0f                                bra.s   loc_FFF23F4F
FFF23F49  f806ff                 loc_FFF23F49 mov.l   #-1, 10h+var_10[sp]
FFF23F4C  38ae00                            bra.w   loc_FFF23FFA
FFF23F4F  a889                   loc_FFF23F4F mov.l   10h+var_4[sp], r1
FFF23F51  8c11                              mov.b   10h[r1], r1
FFF23F53  755140                            cmp     #40h, r1 ; '@'
FFF23F56  1f                                bne.s   loc_FFF23F5D
FFF23F57  f806ff                            mov.l   #-1, 10h+var_10[sp]
FFF23F5A  38a000                            bra.w   loc_FFF23FFA
FFF23F5D  a889                   loc_FFF23F5D mov.l   10h+var_4[sp], r1
FFF23F5F  8c11                              mov.b   10h[r1], r1
FFF23F61  755140                            cmp     #40h, r1 ; '@'
FFF23F64  3a9300                            beq.w   loc_FFF23FF7
FFF23F67  a881                              mov.l   10h+var_8[sp], r1
FFF23F69  b319                              movu.b  0Dh[r1], r1
FFF23F6B  a88a                              mov.l   10h+var_4[sp], r2
FFF23F6D  90a1                              mov.w   r1, 4[r2]
FFF23F6F  a881                              mov.l   10h+var_8[sp], r1
FFF23F71  a88e                              mov.l   10h+var_4[sp], r6
FFF23F73  62e1                              add     #0Eh, r1
FFF23F75  052fad00                          bsr.a   sub_FFF2ECA4
FFF23F79  90e9                              mov.w   r1, 6[r6]
FFF23F7B  a881                              mov.l   10h+var_8[sp], r1
FFF23F7D  b411                              movu.b  10h[r1], r1
FFF23F7F  a88a                              mov.l   10h+var_4[sp], r2
FFF23F81  9121                              mov.w   r1, 8[r2]
FFF23F83  a881                              mov.l   10h+var_8[sp], r1
FFF23F85  a88e                              mov.l   10h+var_4[sp], r6
FFF23F87  711111                            add     #11h, r1, r1
FFF23F8A  051aad00                          bsr.a   sub_FFF2ECA4
FFF23F8E  9169                              mov.w   r1, 0Ah[r6]
FFF23F90  a881                              mov.l   10h+var_8[sp], r1
FFF23F92  a88e                              mov.l   10h+var_4[sp], r6
FFF23F94  711113                            add     #13h, r1, r1
FFF23F97  050dad00                          bsr.a   sub_FFF2ECA4
FFF23F9B  a169                              mov.l   r1, 14h[r6]
FFF23F9D  a889                              mov.l   10h+var_4[sp], r1
FFF23F9F  a919                              mov.l   14h[r1], r1
FFF23FA1  6101                              cmp     #0, r1
FFF23FA3  210f                              bne.b   loc_FFF23FB2
FFF23FA5  a881                              mov.l   10h+var_8[sp], r1
FFF23FA7  a88e                              mov.l   10h+var_4[sp], r6
FFF23FA9  711120                            add     #20h, r1, r1 ; ' '
FFF23FAC  056ead00                          bsr.a   sub_FFF2ED1A
FFF23FB0  a169                              mov.l   r1, 14h[r6]
FFF23FB2  a881                   loc_FFF23FB2 mov.l   10h+var_8[sp], r1
FFF23FB4  a88e                              mov.l   10h+var_4[sp], r6
FFF23FB6  711116                            add     #16h, r1, r1
FFF23FB9  05ebac00                          bsr.a   sub_FFF2ECA4
FFF23FBD  a0e9                              mov.l   r1, 0Ch[r6]
FFF23FBF  a889                              mov.l   10h+var_4[sp], r1
FFF23FC1  8c11                              mov.b   10h[r1], r1
FFF23FC3  755120                            cmp     #20h, r1 ; ' '
FFF23FC6  2131                              bne.b   loc_FFF23FF7
FFF23FC8  a889                              mov.l   10h+var_4[sp], r1
FFF23FCA  a899                              mov.l   0Ch[r1], r1
FFF23FCC  6101                              cmp     #0, r1
FFF23FCE  210f                              bne.b   loc_FFF23FDD
FFF23FD0  a881                              mov.l   10h+var_8[sp], r1
FFF23FD2  a88e                              mov.l   10h+var_4[sp], r6
FFF23FD4  711124                            add     #24h, r1, r1 ; '$'
FFF23FD7  0543ad00                          bsr.a   sub_FFF2ED1A
FFF23FDB  a0e9                              mov.l   r1, 0Ch[r6]
FFF23FDD  a881                   loc_FFF23FDD mov.l   10h+var_8[sp], r1
FFF23FDF  a88e                              mov.l   10h+var_4[sp], r6
FFF23FE1  71112c                            add     #2Ch, r1, r1 ; ','
FFF23FE4  0536ad00                          bsr.a   sub_FFF2ED1A
FFF23FE8  a369                              mov.l   r1, 34h[r6]
FFF23FEA  a881                              mov.l   10h+var_8[sp], r1
FFF23FEC  a88e                              mov.l   10h+var_4[sp], r6
FFF23FEE  711130                            add     #30h, r1, r1 ; '0'
FFF23FF1  05b3ac00                          bsr.a   sub_FFF2ECA4
FFF23FF5  9769                              mov.w   r1, 3Ah[r6]
FFF23FF7  f80600                 loc_FFF23FF7 mov.l   #0, 10h+var_10[sp]
FFF23FFA  ec01                   loc_FFF23FFA mov.l   10h+var_10[sp], r1
FFF23FFC  a009                              mov.l   r1, 10h+var_C[sp]
FFF23FFE  3f6605                            rtsd    #14h, r6-r6
FFF24001  7ea6                   sub_FFF24001 push.l  r6   ; <<<< FUNC sub_FFF24001
FFF24003  7100e4                            add     #-1Ch, sp, sp
FFF24006  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF24008  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2400A  5a2efe01                          movu.b  1FEh[r2], r14
FFF2400E  755e55                            cmp     #55h, r14 ; 'U'
FFF24011  210c                              bne.b   loc_FFF2401D
FFF24013  a909                              mov.l   1Ch+var_8[sp], r1
FFF24015  5a1eff01                          movu.b  1FFh[r1], r14
FFF24019  755eaa                            cmp     #-56h, r14
FFF2401C  15                                beq.s   loc_FFF24021
FFF2401D  f80601                 loc_FFF2401D mov.l   #1, 1Ch+var_1C[sp]
FFF24020  0c                                bra.s   loc_FFF24024
FFF24021  f80600                 loc_FFF24021 mov.l   #0, 1Ch+var_1C[sp]
FFF24024  ec01                   loc_FFF24024 mov.l   1Ch+var_1C[sp], r1
FFF24026  6101                              cmp     #0, r1
FFF24028  10                                beq.s   loc_FFF24030
FFF24029  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF2402D  38aa00                            bra.w   loc_FFF240D7
FFF24030  a909                   loc_FFF24030 mov.l   1Ch+var_8[sp], r1
FFF24032  7211be01                          add     #1BEh, r1, r1
FFF24036  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF24038  a889                              mov.l   1Ch+var_10[sp], r1
FFF2403A  a986                              mov.l   1Ch+var_4[sp], r6
FFF2403C  6281                              add     #8, r1
FFF2403E  05dcac00                          bsr.a   sub_FFF2ED1A
FFF24042  a361                              mov.l   r1, 30h[r6]
FFF24044  a981                              mov.l   1Ch+var_4[sp], r1
FFF24046  ab11                              mov.l   30h[r1], r1
FFF24048  6101                              cmp     #0, r1
FFF2404A  15                                beq.s   loc_FFF2404F
FFF2404B  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF2404E  0c                                bra.s   loc_FFF24052
FFF2404F  f80601                 loc_FFF2404F mov.l   #1, 1Ch+var_1C[sp]
FFF24052  ec01                   loc_FFF24052 mov.l   1Ch+var_1C[sp], r1
FFF24054  6101                              cmp     #0, r1
FFF24056  200e                              beq.b   loc_FFF24064
FFF24058  a90a                              mov.l   1Ch+var_8[sp], r2
FFF2405A  a981                              mov.l   1Ch+var_4[sp], r1
FFF2405C  395efd                            bsr.w   sub_FFF23DBA
FFF2405F  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF24061  387600                            bra.w   loc_FFF240D7
FFF24064  a889                   loc_FFF24064 mov.l   1Ch+var_10[sp], r1
FFF24066  c510040b                          mov.b   4[r1], 1Ch+var_11[sp]
FFF2406A  8a89                              mov.b   1Ch+var_11[sp], r1
FFF2406C  6171                              cmp     #7, r1
FFF2406E  18                                bne.s   loc_FFF24076
FFF2406F  a981                              mov.l   1Ch+var_4[sp], r1
FFF24071  3c9040                            mov.b   #40h, 10h[r1] ; '@'
FFF24074  2e60                              bra.b   loc_FFF240D4
FFF24076  8a89                   loc_FFF24076 mov.b   1Ch+var_11[sp], r1
FFF24078  6111                              cmp     #1, r1
FFF2407A  18                                bne.s   loc_FFF24082
FFF2407B  a981                              mov.l   1Ch+var_4[sp], r1
FFF2407D  3c900c                            mov.b   #0Ch, 10h[r1]
FFF24080  2e54                              bra.b   loc_FFF240D4
FFF24082  8a89                   loc_FFF24082 mov.b   1Ch+var_11[sp], r1
FFF24084  6141                              cmp     #4, r1
FFF24086  16                                beq.s   loc_FFF2408C
FFF24087  8a89                              mov.b   1Ch+var_11[sp], r1
FFF24089  6161                              cmp     #6, r1
FFF2408B  1d                                bne.s   loc_FFF24090
FFF2408C  f80601                 loc_FFF2408C mov.l   #1, 1Ch+var_1C[sp]
FFF2408F  0c                                bra.s   loc_FFF24093
FFF24090  f80600                 loc_FFF24090 mov.l   #0, 1Ch+var_1C[sp]
FFF24093  ec01                   loc_FFF24093 mov.l   1Ch+var_1C[sp], r1
FFF24095  6101                              cmp     #0, r1
FFF24097  1e                                bne.s   loc_FFF2409D
FFF24098  8a89                              mov.b   1Ch+var_11[sp], r1
FFF2409A  61e1                              cmp     #0Eh, r1
FFF2409C  1d                                bne.s   loc_FFF240A1
FFF2409D  f80601                 loc_FFF2409D mov.l   #1, 1Ch+var_1C[sp]
FFF240A0  0c                                bra.s   loc_FFF240A4
FFF240A1  f80600                 loc_FFF240A1 mov.l   #0, 1Ch+var_1C[sp]
FFF240A4  ec01                   loc_FFF240A4 mov.l   1Ch+var_1C[sp], r1
FFF240A6  6101                              cmp     #0, r1
FFF240A8  10                                beq.s   loc_FFF240B0
FFF240A9  a981                              mov.l   1Ch+var_4[sp], r1
FFF240AB  3c9010                            mov.b   #10h, 10h[r1]
FFF240AE  2e26                              bra.b   loc_FFF240D4
FFF240B0  8a89                   loc_FFF240B0 mov.b   1Ch+var_11[sp], r1
FFF240B2  61b1                              cmp     #0Bh, r1
FFF240B4  16                                beq.s   loc_FFF240BA
FFF240B5  8a89                              mov.b   1Ch+var_11[sp], r1
FFF240B7  61c1                              cmp     #0Ch, r1
FFF240B9  1d                                bne.s   loc_FFF240BE
FFF240BA  f80601                 loc_FFF240BA mov.l   #1, 1Ch+var_1C[sp]
FFF240BD  0c                                bra.s   loc_FFF240C1
FFF240BE  f80600                 loc_FFF240BE mov.l   #0, 1Ch+var_1C[sp]
FFF240C1  ec01                   loc_FFF240C1 mov.l   1Ch+var_1C[sp], r1
FFF240C3  6101                              cmp     #0, r1
FFF240C5  a981                              mov.l   1Ch+var_4[sp], r1
FFF240C7  15                                beq.s   loc_FFF240CC
FFF240C8  3c9020                            mov.b   #20h, 10h[r1] ; ' '
FFF240CB  09                                bra.s   loc_FFF240D4
FFF240CC  a90a                   loc_FFF240CC mov.l   1Ch+var_8[sp], r2
FFF240CE  39ecfc                            bsr.w   sub_FFF23DBA
FFF240D1  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF240D3  0c                                bra.s   loc_FFF240D7
FFF240D4  3e0100                 loc_FFF240D4 mov.l   #0, 1Ch+var_18[sp]
FFF240D7  a809                   loc_FFF240D7 mov.l   1Ch+var_18[sp], r1
FFF240D9  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF240DB  3f6608                            rtsd    #20h, r6-r6
FFF240DE  7100dc                 sub_FFF240DE add     #-24h, sp, sp   ; <<<< FUNC sub_FFF240DE
FFF240E1  a201                              mov.l   r1, 24h+var_4[sp]
FFF240E3  a18a                              mov.l   r2, 24h+var_8[sp]
FFF240E5  a183                              mov.l   r3, 24h+var_C[sp]
FFF240E7  a10c                              mov.l   r4, 24h+var_10[sp]
FFF240E9  aa01                              mov.l   24h+var_4[sp], r1
FFF240EB  a98a                              mov.l   24h+var_8[sp], r2
FFF240ED  06851203                          cmp     0Ch[r1].l, r2
FFF240F1  2308                              bltu.b  loc_FFF240F9
FFF240F3  f806f5                            mov.l   #-0Bh, 24h+var_24[sp]
FFF240F6  389c00                            bra.w   loc_FFF24192
FFF240F9  aa01                   loc_FFF240F9 mov.l   24h+var_4[sp], r1
FFF240FB  b899                              movu.w  6[r1], r1
FFF240FD  06890107                          add     24h+var_8[sp].l, r1
