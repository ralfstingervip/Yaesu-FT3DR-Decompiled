
; ######## sub_FFF0B1DB FFF0B1DB-FFF0B399 (file 30B1DB) callers: FFEDF0F6(sub_FFEDF016)
FFF0B1DB  6080                   sub_FFF0B1DB sub     #8, sp   ; <<<< FUNC sub_FFF0B1DB
FFF0B1DD  3c0600                            mov.b   #0, 8+var_2[sp]
FFF0B1E0  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0B1E6  c5e01305                          mov.b   13h[r14], 8+var_3[sp]
FFF0B1EA  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0B1F0  b499                              movu.b  13h[r1], r1
FFF0B1F2  6841                              shlr    #4, r1
FFF0B1F4  8101                              mov.b   r1, 8+var_4[sp]
FFF0B1F6  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF0B1FC  b499                              movu.b  13h[r1], r1
FFF0B1FE  64f1                              and     #0Fh, r1
FFF0B200  8089                              mov.b   r1, 8+var_5[sp]
FFF0B202  b109                              movu.b  8+var_3[sp], r1
FFF0B204  6101                              cmp     #0, r1
FFF0B206  1f                                bne.s   loc_FFF0B20D
FFF0B207  3c0601                            mov.b   #1, 8+var_2[sp]
FFF0B20A  388501                            bra.w   loc_FFF0B38F
FFF0B20D  b101                   loc_FFF0B20D movu.b  8+var_4[sp], r1
FFF0B20F  6c71                              shll    #7, r1
FFF0B211  fb529862ecff                      mov.l   #unk_FFEC6298, r5
FFF0B217  4b15                              add     r1, r5
FFF0B219  b089                              movu.b  8+var_5[sp], r1
FFF0B21B  6c31                              shll    #3, r1
FFF0B21D  4b15                              add     r1, r5
FFF0B21F  b8d4                              movu.w  4[r5], r4
FFF0B221  b85b                              movu.w  2[r5], r3
FFF0B223  5c52                              movu.w  [r5], r2
FFF0B225  6040                              sub     #4, sp
FFF0B227  d15003                            mov.w   6[r5], 0Ch+var_C[sp]
FFF0B22A  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF0B230  058b47fe                          bsr.a   sub_FFEEF9BB
FFF0B234  6240                              add     #4, sp
FFF0B236  8181                              mov.b   r1, 8+var_2[sp]
FFF0B238  b181                              movu.b  8+var_2[sp], r1
FFF0B23A  6111                              cmp     #1, r1
FFF0B23C  3b5301                            bne.w   loc_FFF0B38F
FFF0B23F  b109                              movu.b  8+var_3[sp], r1
FFF0B241  711eff                            add     #-1, r1, r14
FFF0B244  619e                              cmp     #9, r14
FFF0B246  2205                              bgeu.b  loc_FFF0B24B
FFF0B248  38a300                            bra.w   loc_FFF0B2EB
FFF0B24B  721e10ff               loc_FFF0B24B add     #-0F0h, r1, r14
FFF0B24F  613e                              cmp     #3, r14
FFF0B251  2205                              bgeu.b  loc_FFF0B256
FFF0B253  380d01                            bra.w   loc_FFF0B360
FFF0B256  711ef4                 loc_FFF0B256 add     #-0Ch, r1, r14
FFF0B259  613e                              cmp     #3, r14
FFF0B25B  2205                              bgeu.b  loc_FFF0B260
FFF0B25D  388e00                            bra.w   loc_FFF0B2EB
FFF0B260  711ef0                 loc_FFF0B260 add     #-10h, r1, r14
FFF0B263  618e                              cmp     #8, r14
FFF0B265  2205                              bgeu.b  loc_FFF0B26A
FFF0B267  38ab00                            bra.w   loc_FFF0B312
FFF0B26A  711ee0                 loc_FFF0B26A add     #-20h, r1, r14
FFF0B26D  612e                              cmp     #2, r14
FFF0B26F  2205                              bgeu.b  loc_FFF0B274
FFF0B271  38c800                            bra.w   loc_FFF0B339
FFF0B274  711ed0                 loc_FFF0B274 add     #-30h, r1, r14
FFF0B277  613e                              cmp     #3, r14
FFF0B279  2205                              bgeu.b  loc_FFF0B27E
FFF0B27B  38e500                            bra.w   loc_FFF0B360
FFF0B27E  711ec0                 loc_FFF0B27E add     #-40h, r1, r14
FFF0B281  613e                              cmp     #3, r14
FFF0B283  2205                              bgeu.b  loc_FFF0B288
FFF0B285  38db00                            bra.w   loc_FFF0B360
FFF0B288  711ea0                 loc_FFF0B288 add     #-60h, r1, r14
FFF0B28B  613e                              cmp     #3, r14
FFF0B28D  2205                              bgeu.b  loc_FFF0B292
FFF0B28F  38d100                            bra.w   loc_FFF0B360
FFF0B292  711e90                 loc_FFF0B292 add     #-70h, r1, r14
FFF0B295  613e                              cmp     #3, r14
FFF0B297  2205                              bgeu.b  loc_FFF0B29C
FFF0B299  38c700                            bra.w   loc_FFF0B360
FFF0B29C  711e80                 loc_FFF0B29C add     #-80h, r1, r14
FFF0B29F  613e                              cmp     #3, r14
FFF0B2A1  2205                              bgeu.b  loc_FFF0B2A6
FFF0B2A3  38bd00                            bra.w   loc_FFF0B360
FFF0B2A6  721e60ff               loc_FFF0B2A6 add     #-0A0h, r1, r14
FFF0B2AA  61fe                              cmp     #0Fh, r14
FFF0B2AC  253f                              bleu.b  loc_FFF0B2EB
FFF0B2AE  721e50ff                          add     #-0B0h, r1, r14
FFF0B2B2  613e                              cmp     #3, r14
FFF0B2B4  2205                              bgeu.b  loc_FFF0B2B9
FFF0B2B6  38aa00                            bra.w   loc_FFF0B360
FFF0B2B9  721e40ff               loc_FFF0B2B9 add     #-0C0h, r1, r14
FFF0B2BD  613e                              cmp     #3, r14
FFF0B2BF  2205                              bgeu.b  loc_FFF0B2C4
FFF0B2C1  389f00                            bra.w   loc_FFF0B360
FFF0B2C4  721e30ff               loc_FFF0B2C4 add     #-0D0h, r1, r14
FFF0B2C8  613e                              cmp     #3, r14
FFF0B2CA  2205                              bgeu.b  loc_FFF0B2CF
FFF0B2CC  389400                            bra.w   loc_FFF0B360
FFF0B2CF  721e20ff               loc_FFF0B2CF add     #-0E0h, r1, r14
FFF0B2D3  613e                              cmp     #3, r14
FFF0B2D5  2205                              bgeu.b  loc_FFF0B2DA
FFF0B2D7  388900                            bra.w   loc_FFF0B360
FFF0B2DA  60a1                   loc_FFF0B2DA sub     #0Ah, r1
FFF0B2DC  6111                              cmp     #1, r1
FFF0B2DE  2505                              bleu.b  loc_FFF0B2E3
FFF0B2E0  38a500                            bra.w   loc_FFF0B385
FFF0B2E3  fb1a0010               loc_FFF0B2E3 mov.l   #1000h, r1
FFF0B2E7  05bd4bfe                          bsr.a   sub_FFEEFEA4
FFF0B2EB  b101                   loc_FFF0B2EB movu.b  8+var_4[sp], r1
FFF0B2ED  6c71                              shll    #7, r1
FFF0B2EF  fb529862ecff                      mov.l   #unk_FFEC6298, r5
FFF0B2F5  4b15                              add     r1, r5
FFF0B2F7  b089                              movu.b  8+var_5[sp], r1
FFF0B2F9  6c31                              shll    #3, r1
FFF0B2FB  4b15                              add     r1, r5
FFF0B2FD  b8dc                              movu.w  6[r5], r4
FFF0B2FF  b8d3                              movu.w  4[r5], r3
FFF0B301  b85a                              movu.w  2[r5], r2
FFF0B303  5c51                              movu.w  [r5], r1
FFF0B305  b10d                              movu.b  8+var_3[sp], r5
FFF0B307  6040                              sub     #4, sp
FFF0B309  c305                              mov.b   r5, 0Ch+var_C[sp]
FFF0B30B  395a03                            bsr.w   sub_FFF0B665
FFF0B30E  6240                              add     #4, sp
FFF0B310  2e75                              bra.b   loc_FFF0B385
FFF0B312  b101                   loc_FFF0B312 movu.b  8+var_4[sp], r1
FFF0B314  6c71                              shll    #7, r1
FFF0B316  fb529862ecff                      mov.l   #unk_FFEC6298, r5
FFF0B31C  4b15                              add     r1, r5
FFF0B31E  b089                              movu.b  8+var_5[sp], r1
FFF0B320  6c31                              shll    #3, r1
FFF0B322  4b15                              add     r1, r5
FFF0B324  b8dc                              movu.w  6[r5], r4
FFF0B326  b8d3                              movu.w  4[r5], r3
FFF0B328  b85a                              movu.w  2[r5], r2
FFF0B32A  5c51                              movu.w  [r5], r1
FFF0B32C  b10d                              movu.b  8+var_3[sp], r5
FFF0B32E  6040                              sub     #4, sp
FFF0B330  c305                              mov.b   r5, 0Ch+var_C[sp]
FFF0B332  39fc0a                            bsr.w   sub_FFF0BE2E
FFF0B335  6240                              add     #4, sp
FFF0B337  2e4e                              bra.b   loc_FFF0B385
FFF0B339  b101                   loc_FFF0B339 movu.b  8+var_4[sp], r1
FFF0B33B  6c71                              shll    #7, r1
FFF0B33D  fb529862ecff                      mov.l   #unk_FFEC6298, r5
FFF0B343  4b15                              add     r1, r5
FFF0B345  b089                              movu.b  8+var_5[sp], r1
FFF0B347  6c31                              shll    #3, r1
FFF0B349  4b15                              add     r1, r5
FFF0B34B  b8dc                              movu.w  6[r5], r4
FFF0B34D  b8d3                              movu.w  4[r5], r3
FFF0B34F  b85a                              movu.w  2[r5], r2
FFF0B351  5c51                              movu.w  [r5], r1
FFF0B353  b10d                              movu.b  8+var_3[sp], r5
FFF0B355  6040                              sub     #4, sp
FFF0B357  c305                              mov.b   r5, 0Ch+var_C[sp]
FFF0B359  39970e                            bsr.w   sub_FFF0C1F0
FFF0B35C  6240                              add     #4, sp
FFF0B35E  2e27                              bra.b   loc_FFF0B385
FFF0B360  b101                   loc_FFF0B360 movu.b  8+var_4[sp], r1
FFF0B362  6c71                              shll    #7, r1
FFF0B364  fb529862ecff                      mov.l   #unk_FFEC6298, r5
FFF0B36A  4b15                              add     r1, r5
FFF0B36C  b089                              movu.b  8+var_5[sp], r1
FFF0B36E  6c31                              shll    #3, r1
FFF0B370  4b15                              add     r1, r5
FFF0B372  b8dc                              movu.w  6[r5], r4
FFF0B374  b8d3                              movu.w  4[r5], r3
FFF0B376  b85a                              movu.w  2[r5], r2
FFF0B378  5c51                              movu.w  [r5], r1
FFF0B37A  b10d                              movu.b  8+var_3[sp], r5
FFF0B37C  6040                              sub     #4, sp
FFF0B37E  c305                              mov.b   r5, 0Ch+var_C[sp]
FFF0B380  39ef10                            bsr.w   sub_FFF0C46F
FFF0B383  6240                              add     #4, sp
FFF0B385  fb12b8d30100           loc_FFF0B385 mov.l   #1D3B8h, r1
FFF0B38B  051347fe                          bsr.a   sub_FFEEFA9E
FFF0B38F  c5000607               loc_FFF0B38F mov.b   8+var_2[sp], 8+var_1[sp]
FFF0B393  b189                              movu.b  8+var_1[sp], r1
FFF0B395  5b11                              movu.b  r1, r1
FFF0B397  6702                              rtsd    #2

; ######## sub_FFF25B0B FFF25B0B-FFF25DDF (file 325B0B) callers: FFF25AF0(sub_FFF25AC6)
FFF25B0B  7100d0                 sub_FFF25B0B add     #-30h, sp, sp   ; <<<< FUNC sub_FFF25B0B
FFF25B0E  c7012f                            mov.b   r1, 30h+var_1[sp]
FFF25B11  9582                              mov.w   r2, 30h+var_4[sp]
FFF25B13  a283                              mov.l   r3, 30h+var_8[sp]
FFF25B15  a20c                              mov.l   r4, 30h+var_C[sp]
FFF25B17  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF25B1D  e4e006                            mov.l   [r14], 30h+var_18[sp]
FFF25B20  3e0200                            mov.l   #0, 30h+var_28[sp]
FFF25B23  05c8f4ff                          bsr.a   sub_FFF24FEB
FFF25B27  a189                              mov.l   r1, 30h+var_14[sp]
FFF25B29  a989                              mov.l   30h+var_14[sp], r1
FFF25B2B  6101                              cmp     #0, r1
FFF25B2D  10                                beq.s   loc_FFF25B35
FFF25B2E  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25B32  38a702                            bra.w   loc_FFF25DD9
FFF25B35  cd012f                 loc_FFF25B35 mov.b   30h+var_1[sp], r1
FFF25B38  05538c00                          bsr.a   sub_FFF2E78B
FFF25B3C  8489                              mov.b   r1, 30h+var_1D[sp]
FFF25B3E  b489                              movu.b  30h+var_1D[sp], r1
FFF25B40  710218                            add     #30h+var_18, sp, r2
FFF25B43  05dc93ff                          bsr.a   sub_FFF1EF1F
FFF25B47  a189                              mov.l   r1, 30h+var_14[sp]
FFF25B49  a989                              mov.l   30h+var_14[sp], r1
FFF25B4B  6101                              cmp     #0, r1
FFF25B4D  10                                beq.s   loc_FFF25B55
FFF25B4E  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25B52  388702                            bra.w   loc_FFF25DD9
FFF25B55  a981                   loc_FFF25B55 mov.l   30h+var_18[sp], r1
FFF25B57  050694ff                          bsr.a   sub_FFF1EF5D
FFF25B5B  a189                              mov.l   r1, 30h+var_14[sp]
FFF25B5D  a989                              mov.l   30h+var_14[sp], r1
FFF25B5F  6101                              cmp     #0, r1
FFF25B61  10                                beq.s   loc_FFF25B69
FFF25B62  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25B66  387302                            bra.w   loc_FFF25DD9
FFF25B69  aa81                   loc_FFF25B69 mov.l   30h+var_8[sp], r1
FFF25B6B  6101                              cmp     #0, r1
FFF25B6D  18                                bne.s   loc_FFF25B75
FFF25B6E  f90601f3                          mov.l   #-0Dh, 30h+var_2C[sp]
FFF25B72  386702                            bra.w   loc_FFF25DD9
FFF25B75  9d81                   loc_FFF25B75 mov.w   30h+var_4[sp], r1
FFF25B77  6101                              cmp     #0, r1
FFF25B79  2b08                              ble.b   loc_FFF25B81
FFF25B7B  9d81                              mov.w   30h+var_4[sp], r1
FFF25B7D  6151                              cmp     #5, r1
FFF25B7F  2906                              blt.b   loc_FFF25B85
FFF25B81  f80601                 loc_FFF25B81 mov.l   #1, 30h+var_30[sp]
FFF25B84  0c                                bra.s   loc_FFF25B88
FFF25B85  f80600                 loc_FFF25B85 mov.l   #0, 30h+var_30[sp]
FFF25B88  ec01                   loc_FFF25B88 mov.l   30h+var_30[sp], r1
FFF25B8A  6101                              cmp     #0, r1
FFF25B8C  10                                beq.s   loc_FFF25B94
FFF25B8D  f90601f3                          mov.l   #-0Dh, 30h+var_2C[sp]
FFF25B91  384802                            bra.w   loc_FFF25DD9
FFF25B94  a981                   loc_FFF25B94 mov.l   30h+var_18[sp], r1
FFF25B96  b891                              movu.w  4[r1], r1
FFF25B98  6101                              cmp     #0, r1
FFF25B9A  19                                bne.s   loc_FFF25BA3
FFF25B9B  f90a01d2fe                        mov.l   #-12Eh, 30h+var_2C[sp]
FFF25BA0  383902                            bra.w   loc_FFF25DD9
FFF25BA3  a981                   loc_FFF25BA3 mov.l   30h+var_18[sp], r1
FFF25BA5  f11c6c                            bclr    #4, 6Ch[r1].b
FFF25BA8  9d81                              mov.w   30h+var_4[sp], r1
FFF25BAA  a982                              mov.l   30h+var_18[sp], r2
FFF25BAC  a6a1                              mov.l   r1, 68h[r2]
FFF25BAE  a981                              mov.l   30h+var_18[sp], r1
FFF25BB0  ad9b                              mov.l   5Ch[r1], r3
FFF25BB2  aa09                              mov.l   30h+var_C[sp], r1
FFF25BB4  72110c06                          add     #60Ch, r1, r1
FFF25BB8  6602                              mov.l   #0, r2
FFF25BBA  ef34                              mov.l   r3, r4
FFF25BBC  05f38800                          bsr.a   sub_FFF2E4AF
FFF25BC0  a981                              mov.l   30h+var_18[sp], r1
FFF25BC2  ad9c                              mov.l   5Ch[r1], r4
FFF25BC4  aa09                              mov.l   30h+var_C[sp], r1
FFF25BC6  72110c10                          add     #100Ch, r1, r1
FFF25BCA  fb3a0602                          mov.l   #206h, r3
FFF25BCE  6602                              mov.l   #0, r2
FFF25BD0  05df8800                          bsr.a   sub_FFF2E4AF
FFF25BD4  aa09                              mov.l   30h+var_C[sp], r1
FFF25BD6  72110c10                          add     #100Ch, r1, r1
FFF25BDA  6613                              mov.l   #1, r3
FFF25BDC  71022f                            add     #30h+var_1, sp, r2
FFF25BDF  05b58900                          bsr.a   sub_FFF2E594
FFF25BE3  aa09                              mov.l   30h+var_C[sp], r1
FFF25BE5  72110d10                          add     #100Dh, r1, r1
FFF25BE9  fb2238aef4ff                      mov.l   #loc_FFF4AE38, r2
FFF25BEF  05778a00                          bsr.a   sub_FFF2E666
FFF25BF3  aa09                              mov.l   30h+var_C[sp], r1
FFF25BF5  72110c10                          add     #100Ch, r1, r1
FFF25BF9  fb2243aef4ff                      mov.l   #loc_FFF4AE43, r2
FFF25BFF  054903ff                          bsr.a   sub_FFF15F48
FFF25C03  a109                              mov.l   r1, 30h+var_1C[sp]
FFF25C05  a909                              mov.l   30h+var_1C[sp], r1
FFF25C07  6101                              cmp     #0, r1
FFF25C09  3a9501                            beq.w   loc_FFF25D9E
FFF25C0C  a909                              mov.l   30h+var_1C[sp], r1
FFF25C0E  710208                            add     #30h+var_28, sp, r2
FFF25C11  05be2f00                          bsr.a   sub_FFF28BCF
FFF25C15  a189                              mov.l   r1, 30h+var_14[sp]
FFF25C17  a989                              mov.l   30h+var_14[sp], r1
FFF25C19  6101                              cmp     #0, r1
FFF25C1B  10                                beq.s   loc_FFF25C23
FFF25C1C  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25C20  38b901                            bra.w   loc_FFF25DD9
FFF25C23  a909                   loc_FFF25C23 mov.l   30h+var_1C[sp], r1
FFF25C25  05f511ff                          bsr.a   sub_FFF16E1A
FFF25C29  a189                              mov.l   r1, 30h+var_14[sp]
FFF25C2B  a989                              mov.l   30h+var_14[sp], r1
FFF25C2D  6101                              cmp     #0, r1
FFF25C2F  200f                              beq.b   loc_FFF25C3E
FFF25C31  05a800ff                          bsr.a   sub_FFF15CD9
FFF25C35  a189                              mov.l   r1, 30h+var_14[sp]
FFF25C37  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25C3B  389e01                            bra.w   loc_FFF25DD9
FFF25C3E  aa0a                   loc_FFF25C3E mov.l   30h+var_C[sp], r2
FFF25C40  a981                              mov.l   30h+var_18[sp], r1
FFF25C42  39600f                            bsr.w   sub_FFF26BA2
FFF25C45  a189                              mov.l   r1, 30h+var_14[sp]
FFF25C47  a989                              mov.l   30h+var_14[sp], r1
FFF25C49  6101                              cmp     #0, r1
FFF25C4B  10                                beq.s   loc_FFF25C53
FFF25C4C  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25C50  388901                            bra.w   loc_FFF25DD9
FFF25C53  a981                   loc_FFF25C53 mov.l   30h+var_18[sp], r1
FFF25C55  ad99                              mov.l   5Ch[r1], r1
FFF25C57  06850102                          cmp     30h+var_28[sp].l, r1
FFF25C5B  2505                              bleu.b  loc_FFF25C60
FFF25C5D  380f01                            bra.w   loc_FFF25D6C
FFF25C60  aa0c                   loc_FFF25C60 mov.l   30h+var_C[sp], r4
FFF25C62  aa82                              mov.l   30h+var_8[sp], r2
FFF25C64  a981                              mov.l   30h+var_18[sp], r1
FFF25C66  72430c06                          add     #60Ch, r4, r3
FFF25C6A  399b02                            bsr.w   sub_FFF25F05
FFF25C6D  a189                              mov.l   r1, 30h+var_14[sp]
FFF25C6F  a989                              mov.l   30h+var_14[sp], r1
FFF25C71  6101                              cmp     #0, r1
FFF25C73  2050                              beq.b   loc_FFF25CC3
FFF25C75  a989                              mov.l   30h+var_14[sp], r1
FFF25C77  7601d3fe                          cmp     #-12Dh, r1
FFF25C7B  2141                              bne.b   loc_FFF25CBC
FFF25C7D  aa0a                              mov.l   30h+var_C[sp], r2
FFF25C7F  72210c10                          add     #100Ch, r2, r1
FFF25C83  053447ff                          bsr.a   sub_FFF1A3B7
FFF25C87  a189                              mov.l   r1, 30h+var_14[sp]
FFF25C89  a989                              mov.l   30h+var_14[sp], r1
FFF25C8B  6101                              cmp     #0, r1
FFF25C8D  10                                beq.s   loc_FFF25C95
FFF25C8E  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25C92  384701                            bra.w   loc_FFF25DD9
FFF25C95  a981                   loc_FFF25C95 mov.l   30h+var_18[sp], r1
FFF25C97  dd1234                            mov.w   68h[r1], r2
FFF25C9A  aa0c                              mov.l   30h+var_C[sp], r4
FFF25C9C  72430c06                          add     #60Ch, r4, r3
FFF25CA0  393f01                            bsr.w   sub_FFF25DDF
FFF25CA3  a189                              mov.l   r1, 30h+var_14[sp]
FFF25CA5  a989                              mov.l   30h+var_14[sp], r1
FFF25CA7  6101                              cmp     #0, r1
FFF25CA9  10                                beq.s   loc_FFF25CB1
FFF25CAA  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25CAE  382b01                            bra.w   loc_FFF25DD9
FFF25CB1  a981                   loc_FFF25CB1 mov.l   30h+var_18[sp], r1
FFF25CB3  f1146c                            bset    #4, 6Ch[r1].b
FFF25CB6  3e0100                            mov.l   #0, 30h+var_2C[sp]
FFF25CB9  382001                            bra.w   loc_FFF25DD9
FFF25CBC  e5000701               loc_FFF25CBC mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25CC0  381901                            bra.w   loc_FFF25DD9
FFF25CC3  a981                   loc_FFF25CC3 mov.l   30h+var_18[sp], r1
FFF25CC5  ad99                              mov.l   5Ch[r1], r1
FFF25CC7  064d0116                          mul     30h+var_4[sp].w, r1
FFF25CCB  06850102                          cmp     30h+var_28[sp].l, r1
FFF25CCF  216a                              bne.b   loc_FFF25D39
FFF25CD1  3c8200                            mov.b   #0, 30h+var_1E[sp]
FFF25CD4  2e5a                              bra.b   loc_FFF25D2E
FFF25CD6  8c81                   loc_FFF25CD6 mov.b   30h+var_1E[sp], r1
FFF25CD8  6c21                              shll    #2, r1
FFF25CDA  06890109                          add     30h+var_C[sp].l, r1
FFF25CDE  72110c0a                          add     #0A0Ch, r1, r1
FFF25CE2  05389000                          bsr.a   sub_FFF2ED1A
FFF25CE6  a089                              mov.l   r1, 30h+var_24[sp]
FFF25CE8  a889                              mov.l   30h+var_24[sp], r1
FFF25CEA  740106400001                      cmp     #1004006h, r1
FFF25CF0  2038                              beq.b   loc_FFF25D28
FFF25CF2  aa0a                              mov.l   30h+var_C[sp], r2
FFF25CF4  72210c10                          add     #100Ch, r2, r1
FFF25CF8  05bf46ff                          bsr.a   sub_FFF1A3B7
FFF25CFC  a189                              mov.l   r1, 30h+var_14[sp]
FFF25CFE  a989                              mov.l   30h+var_14[sp], r1
FFF25D00  6101                              cmp     #0, r1
FFF25D02  10                                beq.s   loc_FFF25D0A
FFF25D03  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25D07  38d200                            bra.w   loc_FFF25DD9
FFF25D0A  a981                   loc_FFF25D0A mov.l   30h+var_18[sp], r1
FFF25D0C  dd1234                            mov.w   68h[r1], r2
FFF25D0F  aa0c                              mov.l   30h+var_C[sp], r4
FFF25D11  72430c06                          add     #60Ch, r4, r3
FFF25D15  39ca00                            bsr.w   sub_FFF25DDF
FFF25D18  a189                              mov.l   r1, 30h+var_14[sp]
FFF25D1A  a989                              mov.l   30h+var_14[sp], r1
FFF25D1C  6101                              cmp     #0, r1
FFF25D1E  3a9a00                            beq.w   loc_FFF25DB8
FFF25D21  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25D25  38b400                            bra.w   loc_FFF25DD9
FFF25D28  b481                   loc_FFF25D28 movu.b  30h+var_1E[sp], r1
FFF25D2A  6211                              add     #1, r1
FFF25D2C  8481                              mov.b   r1, 30h+var_1E[sp]
FFF25D2E  8c81                   loc_FFF25D2E mov.b   30h+var_1E[sp], r1
FFF25D30  06450116                          cmp     30h+var_4[sp].w, r1
FFF25D34  29a2                              blt.b   loc_FFF25CD6
FFF25D36  388200                            bra.w   loc_FFF25DB8
FFF25D39  aa0a                   loc_FFF25D39 mov.l   30h+var_C[sp], r2
FFF25D3B  72210c10                          add     #100Ch, r2, r1
FFF25D3F  057846ff                          bsr.a   sub_FFF1A3B7
FFF25D43  a189                              mov.l   r1, 30h+var_14[sp]
FFF25D45  a989                              mov.l   30h+var_14[sp], r1
FFF25D47  6101                              cmp     #0, r1
FFF25D49  10                                beq.s   loc_FFF25D51
FFF25D4A  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25D4E  388b00                            bra.w   loc_FFF25DD9
FFF25D51  aa0c                   loc_FFF25D51 mov.l   30h+var_C[sp], r4
FFF25D53  9d82                              mov.w   30h+var_4[sp], r2
FFF25D55  a981                              mov.l   30h+var_18[sp], r1
FFF25D57  72430c06                          add     #60Ch, r4, r3
FFF25D5B  398400                            bsr.w   sub_FFF25DDF
FFF25D5E  a189                              mov.l   r1, 30h+var_14[sp]
FFF25D60  a989                              mov.l   30h+var_14[sp], r1
FFF25D62  6101                              cmp     #0, r1
FFF25D64  2054                              beq.b   loc_FFF25DB8
FFF25D66  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25D6A  2e6f                              bra.b   loc_FFF25DD9
FFF25D6C  aa0a                   loc_FFF25D6C mov.l   30h+var_C[sp], r2
FFF25D6E  72210c10                          add     #100Ch, r2, r1
FFF25D72  054546ff                          bsr.a   sub_FFF1A3B7
FFF25D76  a189                              mov.l   r1, 30h+var_14[sp]
FFF25D78  a989                              mov.l   30h+var_14[sp], r1
FFF25D7A  6101                              cmp     #0, r1
FFF25D7C  17                                beq.s   loc_FFF25D83
FFF25D7D  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25D81  2e58                              bra.b   loc_FFF25DD9
FFF25D83  aa0c                   loc_FFF25D83 mov.l   30h+var_C[sp], r4
FFF25D85  9d82                              mov.w   30h+var_4[sp], r2
FFF25D87  a981                              mov.l   30h+var_18[sp], r1
FFF25D89  72430c06                          add     #60Ch, r4, r3
FFF25D8D  395200                            bsr.w   sub_FFF25DDF
FFF25D90  a189                              mov.l   r1, 30h+var_14[sp]
FFF25D92  a989                              mov.l   30h+var_14[sp], r1
FFF25D94  6101                              cmp     #0, r1
FFF25D96  2022                              beq.b   loc_FFF25DB8
FFF25D98  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25D9C  2e3d                              bra.b   loc_FFF25DD9
FFF25D9E  aa0c                   loc_FFF25D9E mov.l   30h+var_C[sp], r4
FFF25DA0  9d82                              mov.w   30h+var_4[sp], r2
FFF25DA2  a981                              mov.l   30h+var_18[sp], r1
FFF25DA4  72430c06                          add     #60Ch, r4, r3
FFF25DA8  393700                            bsr.w   sub_FFF25DDF
FFF25DAB  a189                              mov.l   r1, 30h+var_14[sp]
FFF25DAD  a989                              mov.l   30h+var_14[sp], r1
FFF25DAF  6101                              cmp     #0, r1
FFF25DB1  17                                beq.s   loc_FFF25DB8
FFF25DB2  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25DB6  2e23                              bra.b   loc_FFF25DD9
FFF25DB8  a981                   loc_FFF25DB8 mov.l   30h+var_18[sp], r1
FFF25DBA  056470ff                          bsr.a   sub_FFF1CE1E
FFF25DBE  a189                              mov.l   r1, 30h+var_14[sp]
FFF25DC0  a989                              mov.l   30h+var_14[sp], r1
FFF25DC2  6101                              cmp     #0, r1
FFF25DC4  200d                              beq.b   loc_FFF25DD1
FFF25DC6  0513fffe                          bsr.a   sub_FFF15CD9
FFF25DCA  a189                              mov.l   r1, 30h+var_14[sp]
FFF25DCC  e5000701                          mov.l   30h+var_14[sp], 30h+var_2C[sp]
FFF25DD0  09                                bra.s   loc_FFF25DD9
FFF25DD1  a981                   loc_FFF25DD1 mov.l   30h+var_18[sp], r1
FFF25DD3  f1146c                            bset    #4, 6Ch[r1].b
FFF25DD6  3e0100                            mov.l   #0, 30h+var_2C[sp]
FFF25DD9  a809                   loc_FFF25DD9 mov.l   30h+var_2C[sp], r1
FFF25DDB  a201                              mov.l   r1, 30h+var_10[sp]
FFF25DDD  670c                              rtsd    #0Ch

; ######## sub_FFF25AC6 FFF25AC6-FFF25B0B (file 325AC6) callers: FFF12AC4(sub_FFF12A8F), FFF26C3C(sub_FFF26C25), FFF3BA12(sub_FFF3B8DE), FFF3BA41(sub_FFF3BA24)
FFF25AC6  7100e8                 sub_FFF25AC6 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF25AC6
FFF25AC9  8589                              mov.b   r1, 18h+var_1[sp]
FFF25ACB  9282                              mov.w   r2, 18h+var_4[sp]
FFF25ACD  a103                              mov.l   r3, 18h+var_8[sp]
FFF25ACF  05c703ff                          bsr.a   sub_FFF15E96
FFF25AD3  a009                              mov.l   r1, 18h+var_14[sp]
FFF25AD5  a809                              mov.l   18h+var_14[sp], r1
FFF25AD7  6101                              cmp     #0, r1
FFF25AD9  210f                              bne.b   loc_FFF25AE8
FFF25ADB  6602                              mov.l   #0, r2
FFF25ADD  fb16e1                            mov.l   #-1Fh, r1
FFF25AE0  054093ff                          bsr.a   sub_FFF1EE20
FFF25AE4  e301                              mov.l   r1, 18h+var_18[sp]
FFF25AE6  2e1f                              bra.b   loc_FFF25B05
FFF25AE8  a80c                   loc_FFF25AE8 mov.l   18h+var_14[sp], r4
FFF25AEA  a903                              mov.l   18h+var_8[sp], r3
FFF25AEC  9a82                              mov.w   18h+var_4[sp], r2
FFF25AEE  b589                              movu.b  18h+var_1[sp], r1
FFF25AF0  391b00                            bsr.w   sub_FFF25B0B
FFF25AF3  a081                              mov.l   r1, 18h+var_10[sp]
FFF25AF5  a809                              mov.l   18h+var_14[sp], r1
FFF25AF7  05af03ff                          bsr.a   sub_FFF15EA6
FFF25AFB  a881                              mov.l   18h+var_10[sp], r1
FFF25AFD  6602                              mov.l   #0, r2
FFF25AFF  052193ff                          bsr.a   sub_FFF1EE20
FFF25B03  e301                              mov.l   r1, 18h+var_18[sp]
FFF25B05  ec01                   loc_FFF25B05 mov.l   18h+var_18[sp], r1
FFF25B07  a089                              mov.l   r1, 18h+var_C[sp]
FFF25B09  6706                              rtsd    #6

; ######## sub_FFF25DDF FFF25DDF-FFF25F05 (file 325DDF) callers: FFF25CA0(sub_FFF25B0B), FFF25D15(sub_FFF25B0B), FFF25D5B(sub_FFF25B0B), FFF25D8D(sub_FFF25B0B), FFF25DA8(sub_FFF25B0B)
FFF25DDF  7100d4                 sub_FFF25DDF add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF25DDF
FFF25DE2  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF25DE4  948a                              mov.w   r2, 2Ch+var_6[sp]
FFF25DE6  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF25DE8  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF25DEA  3e0300                            mov.l   #0, 2Ch+var_20[sp]
FFF25DED  aa01                              mov.l   2Ch+var_C[sp], r1
FFF25DEF  6101                              cmp     #0, r1
FFF25DF1  1f                                bne.s   loc_FFF25DF8
FFF25DF2  f806f3                            mov.l   #-0Dh, 2Ch+var_2C[sp]
FFF25DF5  380a01                            bra.w   loc_FFF25EFF
FFF25DF8  a98c                   loc_FFF25DF8 mov.l   2Ch+var_10[sp], r4
FFF25DFA  9c8b                              mov.w   2Ch+var_6[sp], r3
FFF25DFC  aa81                              mov.l   2Ch+var_4[sp], r1
FFF25DFE  71020c                            add     #2Ch+var_20, sp, r2
FFF25E01  054cfaff                          bsr.a   sub_FFF2584D
FFF25E05  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF25E07  a909                              mov.l   2Ch+var_18[sp], r1
FFF25E09  6101                              cmp     #0, r1
FFF25E0B  10                                beq.s   loc_FFF25E13
FFF25E0C  f80ad4fe                          mov.l   #-12Ch, 2Ch+var_2C[sp]
FFF25E10  38ef00                            bra.w   loc_FFF25EFF
FFF25E13  a889                   loc_FFF25E13 mov.l   2Ch+var_20[sp], r1
FFF25E15  aa82                              mov.l   2Ch+var_4[sp], r2
FFF25E17  a2a1                              mov.l   r1, 28h[r2]
FFF25E19  a989                              mov.l   2Ch+var_10[sp], r1
FFF25E1B  72110c10                          add     #100Ch, r1, r1
FFF25E1F  fb2245aef4ff                      mov.l   #(loc_FFF4AE43+2), r2
FFF25E25  052301ff                          bsr.a   sub_FFF15F48
FFF25E29  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF25E2B  a901                              mov.l   2Ch+var_1C[sp], r1
FFF25E2D  6101                              cmp     #0, r1
FFF25E2F  1a                                bne.s   loc_FFF25E39
FFF25E30  05a9fefe                          bsr.a   sub_FFF15CD9
FFF25E34  e301                              mov.l   r1, 2Ch+var_2C[sp]
FFF25E36  38c900                            bra.w   loc_FFF25EFF
FFF25E39  aa81                   loc_FFF25E39 mov.l   2Ch+var_4[sp], r1
FFF25E3B  ad9a                              mov.l   5Ch[r1], r2
FFF25E3D  064d0213                          mul     2Ch+var_6[sp].w, r2
FFF25E41  a901                              mov.l   2Ch+var_1C[sp], r1
FFF25E43  05262900                          bsr.a   sub_FFF28769
FFF25E47  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF25E49  a909                              mov.l   2Ch+var_18[sp], r1
FFF25E4B  6101                              cmp     #0, r1
FFF25E4D  17                                beq.s   loc_FFF25E54
FFF25E4E  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF25E51  38ae00                            bra.w   loc_FFF25EFF
FFF25E54  a901                   loc_FFF25E54 mov.l   2Ch+var_1C[sp], r1
FFF25E56  05c40fff                          bsr.a   sub_FFF16E1A
FFF25E5A  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF25E5C  a909                              mov.l   2Ch+var_18[sp], r1
FFF25E5E  6101                              cmp     #0, r1
FFF25E60  17                                beq.s   loc_FFF25E67
FFF25E61  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF25E64  389b00                            bra.w   loc_FFF25EFF
FFF25E67  a989                   loc_FFF25E67 mov.l   2Ch+var_10[sp], r1
FFF25E69  72110c10                          add     #100Ch, r1, r1
FFF25E6D  754222                            mov.l   #22h, r2 ; '"'
FFF25E70  05b11900                          bsr.a   sub_FFF27821
FFF25E74  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF25E76  a909                              mov.l   2Ch+var_18[sp], r1
FFF25E78  6101                              cmp     #0, r1
FFF25E7A  17                                beq.s   loc_FFF25E81
FFF25E7B  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF25E7E  388100                            bra.w   loc_FFF25EFF
FFF25E81  a98a                   loc_FFF25E81 mov.l   2Ch+var_10[sp], r2
FFF25E83  aa81                              mov.l   2Ch+var_4[sp], r1
FFF25E85  391d0d                            bsr.w   sub_FFF26BA2
FFF25E88  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF25E8A  a909                              mov.l   2Ch+var_18[sp], r1
FFF25E8C  6101                              cmp     #0, r1
FFF25E8E  16                                beq.s   loc_FFF25E94
FFF25E8F  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF25E92  2e6d                              bra.b   loc_FFF25EFF
FFF25E94  3c0700                 loc_FFF25E94 mov.b   #0, 2Ch+var_25[sp]
FFF25E97  2e5d                              bra.b   loc_FFF25EF4
FFF25E99  aa01                   loc_FFF25E99 mov.l   2Ch+var_C[sp], r1
FFF25E9B  fb2e55aa00                        mov.l   #0AA55h, r2
FFF25EA0  05e18d00                          bsr.a   sub_FFF2EC81
FFF25EA4  aa01                              mov.l   2Ch+var_C[sp], r1
FFF25EA6  6221                              add     #2, r1
FFF25EA8  fb2206400001                      mov.l   #1004006h, r2
FFF25EAE  05258e00                          bsr.a   sub_FFF2ECD3
FFF25EB2  aa81                              mov.l   2Ch+var_4[sp], r1
FFF25EB4  aa02                              mov.l   2Ch+var_C[sp], r2
FFF25EB6  c5121006                          mov.b   10h[r1], 6[r2]
FFF25EBA  aa81                              mov.l   2Ch+var_4[sp], r1
FFF25EBC  ad99                              mov.l   5Ch[r1], r1
FFF25EBE  06890108                          add     2Ch+var_C[sp].l, r1
FFF25EC2  6021                              sub     #2, r1
FFF25EC4  fb2e55aa00                        mov.l   #0AA55h, r2
FFF25EC9  05b88d00                          bsr.a   sub_FFF2EC81
FFF25ECD  aa81                              mov.l   2Ch+var_4[sp], r1
FFF25ECF  ae19                              mov.l   64h[r1], r1
FFF25ED1  490107                            add     2Ch+var_25[sp], r1
FFF25ED4  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF25ED6  aa03                              mov.l   2Ch+var_C[sp], r3
FFF25ED8  a882                              mov.l   2Ch+var_24[sp], r2
FFF25EDA  aa81                              mov.l   2Ch+var_4[sp], r1
FFF25EDC  6614                              mov.l   #1, r4
FFF25EDE  05c491ff                          bsr.a   sub_FFF1F0A2
FFF25EE2  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF25EE4  a909                              mov.l   2Ch+var_18[sp], r1
FFF25EE6  6101                              cmp     #0, r1
FFF25EE8  16                                beq.s   loc_FFF25EEE
FFF25EE9  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF25EEC  2e13                              bra.b   loc_FFF25EFF
FFF25EEE  b189                   loc_FFF25EEE movu.b  2Ch+var_25[sp], r1
FFF25EF0  6211                              add     #1, r1
FFF25EF2  8189                              mov.b   r1, 2Ch+var_25[sp]
FFF25EF4  b189                   loc_FFF25EF4 movu.b  2Ch+var_25[sp], r1
FFF25EF6  06450113                          cmp     2Ch+var_6[sp].w, r1
FFF25EFA  299f                              blt.b   loc_FFF25E99
FFF25EFC  f80600                            mov.l   #0, 2Ch+var_2C[sp]
FFF25EFF  ec01                   loc_FFF25EFF mov.l   2Ch+var_2C[sp], r1
FFF25F01  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF25F03  670b                              rtsd    #0Bh

; ######## sub_FFF3BA24 FFF3BA24-FFF3BA5A (file 33BA24) callers: FFF3FE06(sub_FFF3FC53)
FFF3BA24  7100f0                 sub_FFF3BA24 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3BA24
FFF3BA27  f80400                            mov.b   #0, 10h+var_10[sp]
FFF3BA2A  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF3BA2D  3e0200                            mov.l   #0, 10h+var_8[sp]
FFF3BA30  fb12f7aff4ff                      mov.l   #loc_FFF4AFF7, r1
FFF3BA36  054e77fd                          bsr.a   sub_FFF13184
FFF3BA3A  ef03                              mov.l   sp, r3
FFF3BA3C  6642                              mov.l   #4, r2
FFF3BA3E  754149                            mov.l   #49h, r1 ; 'I'
FFF3BA41  0585a0fe                          bsr.a   sub_FFF25AC6
FFF3BA45  a089                              mov.l   r1, 10h+var_4[sp]
FFF3BA47  a889                              mov.l   10h+var_4[sp], r1
FFF3BA49  6101                              cmp     #0, r1
FFF3BA4B  210d                              bne.b   loc_FFF3BA58
FFF3BA4D  fbe2b2220100                      mov.l   #122B2h, r14
FFF3BA53  f8e401                            mov.b   #1, [r14]
FFF3BA56  6704                              rtsd    #4
FFF3BA58  6704                   loc_FFF3BA58 rtsd    #4

; ######## sub_FFF3FC53 FFF3FC53-FFF3FE0D (file 33FC53) callers: FFF36C9C(sub_FFF36C9C)
FFF3FC53  6080                   sub_FFF3FC53 sub     #8, sp   ; <<<< FUNC sub_FFF3FC53
FFF3FC55  3d0300                            mov.w   #0, 8+var_2[sp]
FFF3FC58  6601                              mov.l   #0, r1
FFF3FC5A  05612eff                          bsr.a   sub_FFF32ABB
FFF3FC5E  fbe2630c0100                      mov.l   #10C63h, r14
FFF3FC64  58ee                              movu.b  [r14], r14
FFF3FC66  fbf29b220100                      mov.l   #1229Bh, r15
FFF3FC6C  44fe                              cmp     [r15], r14
FFF3FC6E  202e                              beq.b   loc_FFF3FC9C
FFF3FC70  fbe29b220100                      mov.l   #1229Bh, r14
FFF3FC76  58ee                              movu.b  [r14], r14
FFF3FC78  611e                              cmp     #1, r14
FFF3FC7A  1e                                bne.s   loc_FFF3FC80
FFF3FC7B  3963bc                            bsr.w   sub_FFF3B8DE
FFF3FC7E  2e10                              bra.b   loc_FFF3FC8E
FFF3FC80  fbe2630c0100           loc_FFF3FC80 mov.l   #10C63h, r14
FFF3FC86  58ee                              movu.b  [r14], r14
FFF3FC88  611e                              cmp     #1, r14
FFF3FC8A  1c                                bne.s   loc_FFF3FC8E
FFF3FC8B  39cfbd                            bsr.w   sub_FFF3BA5A
FFF3FC8E  fbe2630c0100           loc_FFF3FC8E mov.l   #10C63h, r14
FFF3FC94  fbf29b220100                      mov.l   #1229Bh, r15
FFF3FC9A  c0fe                              mov.b   [r15], [r14]
FFF3FC9C  050b36fd               loc_FFF3FC9C bsr.a   sub_FFF132A7
FFF3FCA0  fbe2640c0100                      mov.l   #10C64h, r14
FFF3FCA6  58ee                              movu.b  [r14], r14
FFF3FCA8  611e                              cmp     #1, r14
FFF3FCAA  215a                              bne.b   loc_FFF3FD04
FFF3FCAC  6661                              mov.l   #6, r1
FFF3FCAE  0541a3ff                          bsr.a   sub_FFF39FEF
FFF3FCB2  9089                              mov.w   r1, 8+var_2[sp]
FFF3FCB4  b889                              movu.w  8+var_2[sp], r1
FFF3FCB6  6101                              cmp     #0, r1
FFF3FCB8  1a                                bne.s   loc_FFF3FCC2
FFF3FCB9  fbe2650c0100                      mov.l   #10C65h, r14
FFF3FCBF  f8e401                            mov.b   #1, [r14]
FFF3FCC2  fbe26a250100           loc_FFF3FCC2 mov.l   #1256Ah, r14
FFF3FCC8  5cee                              movu.w  [r14], r14
FFF3FCCA  fbf26e250100                      mov.l   #1256Eh, r15
FFF3FCD0  06c4fe                            cmp     [r15].uw, r14
FFF3FCD3  2031                              beq.b   loc_FFF3FD04
FFF3FCD5  fbe26e250100                      mov.l   #1256Eh, r14
FFF3FCDB  5cee                              movu.w  [r14], r14
FFF3FCDD  610e                              cmp     #0, r14
FFF3FCDF  2011                              beq.b   loc_FFF3FCF0
FFF3FCE1  fbe26e250100                      mov.l   #1256Eh, r14
FFF3FCE7  5ce2                              movu.w  [r14], r2
FFF3FCE9  6661                              mov.l   #6, r1
FFF3FCEB  05eda1ff                          bsr.a   sub_FFF39ED8
FFF3FCEF  0f                                bra.s   loc_FFF3FCF6
FFF3FCF0  6661                   loc_FFF3FCF0 mov.l   #6, r1
FFF3FCF2  0573a2ff                          bsr.a   sub_FFF39F65
FFF3FCF6  fbe26a250100           loc_FFF3FCF6 mov.l   #1256Ah, r14
FFF3FCFC  fbf26e250100                      mov.l   #1256Eh, r15
FFF3FD02  d0fe                              mov.w   [r15], [r14]
FFF3FD04  fbe260080100           loc_FFF3FD04 mov.l   #10860h, r14
FFF3FD0A  58ee                              movu.b  [r14], r14
FFF3FD0C  610e                              cmp     #0, r14
FFF3FD0E  2051                              beq.b   loc_FFF3FD5F
FFF3FD10  613e                              cmp     #3, r14
FFF3FD12  2020                              beq.b   loc_FFF3FD32
FFF3FD14  614e                              cmp     #4, r14
FFF3FD16  2140                              bne.b   loc_FFF3FD56
FFF3FD18  39a4c7                            bsr.w   sub_FFF3C4BC
FFF3FD1B  fbe260080100                      mov.l   #10860h, r14
FFF3FD21  58ee                              movu.b  [r14], r14
FFF3FD23  613e                              cmp     #3, r14
FFF3FD25  203a                              beq.b   loc_FFF3FD5F
FFF3FD27  fbe260080100                      mov.l   #10860h, r14
FFF3FD2D  f8e400                            mov.b   #0, [r14]
FFF3FD30  2e2f                              bra.b   loc_FFF3FD5F
FFF3FD32  6651                   loc_FFF3FD32 mov.l   #5, r1
FFF3FD34  05bba2ff                          bsr.a   sub_FFF39FEF
FFF3FD38  9089                              mov.w   r1, 8+var_2[sp]
FFF3FD3A  b889                              movu.w  8+var_2[sp], r1
FFF3FD3C  6101                              cmp     #0, r1
FFF3FD3E  2121                              bne.b   loc_FFF3FD5F
FFF3FD40  399ebb                            bsr.w   sub_FFF3B8DE
FFF3FD43  fbe260080100                      mov.l   #10860h, r14
FFF3FD49  f8e400                            mov.b   #0, [r14]
FFF3FD4C  fbe2b6220100                      mov.l   #122B6h, r14
FFF3FD52  f8e400                            mov.b   #0, [r14]
FFF3FD55  0a                                bra.s   loc_FFF3FD5F
FFF3FD56  fbe260080100           loc_FFF3FD56 mov.l   #10860h, r14
FFF3FD5C  f8e400                            mov.b   #0, [r14]
FFF3FD5F  fbe2b6220100           loc_FFF3FD5F mov.l   #122B6h, r14
FFF3FD65  58ee                              movu.b  [r14], r14
FFF3FD67  613e                              cmp     #3, r14
FFF3FD69  2030                              beq.b   loc_FFF3FD99
FFF3FD6B  612e                              cmp     #2, r14
FFF3FD6D  2019                              beq.b   loc_FFF3FD86
FFF3FD6F  611e                              cmp     #1, r14
FFF3FD71  214e                              bne.b   loc_FFF3FDBF
FFF3FD73  6641                              mov.l   #4, r1
FFF3FD75  057aa2ff                          bsr.a   sub_FFF39FEF
FFF3FD79  9089                              mov.w   r1, 8+var_2[sp]
FFF3FD7B  b889                              movu.w  8+var_2[sp], r1
FFF3FD7D  6101                              cmp     #0, r1
FFF3FD7F  2140                              bne.b   loc_FFF3FDBF
FFF3FD81  39aff6                            bsr.w   sub_FFF3F430
FFF3FD84  2e3b                              bra.b   loc_FFF3FDBF
FFF3FD86  6641                   loc_FFF3FD86 mov.l   #4, r1
FFF3FD88  0567a2ff                          bsr.a   sub_FFF39FEF
FFF3FD8C  9089                              mov.w   r1, 8+var_2[sp]
FFF3FD8E  b889                              movu.w  8+var_2[sp], r1
FFF3FD90  6101                              cmp     #0, r1
FFF3FD92  212d                              bne.b   loc_FFF3FDBF
FFF3FD94  392df8                            bsr.w   sub_FFF3F5C1
FFF3FD97  2e28                              bra.b   loc_FFF3FDBF
FFF3FD99  6641                   loc_FFF3FD99 mov.l   #4, r1
FFF3FD9B  0554a2ff                          bsr.a   sub_FFF39FEF
FFF3FD9F  9089                              mov.w   r1, 8+var_2[sp]
FFF3FDA1  b889                              movu.w  8+var_2[sp], r1
FFF3FDA3  6101                              cmp     #0, r1
FFF3FDA5  211a                              bne.b   loc_FFF3FDBF
FFF3FDA7  fbe2b4220100                      mov.l   #122B4h, r14
FFF3FDAD  f8e407                            mov.b   #7, [r14]
FFF3FDB0  fbe2b6220100                      mov.l   #122B6h, r14
FFF3FDB6  f8e400                            mov.b   #0, [r14]
FFF3FDB9  6641                              mov.l   #4, r1
FFF3FDBB  05aaa1ff                          bsr.a   sub_FFF39F65
FFF3FDBF  fbe2b5220100           loc_FFF3FDBF mov.l   #122B5h, r14
FFF3FDC5  58ee                              movu.b  [r14], r14
FFF3FDC7  615e                              cmp     #5, r14
FFF3FDC9  210e                              bne.b   loc_FFF3FDD7
FFF3FDCB  3917ed                            bsr.w   sub_FFF3EAE2
FFF3FDCE  fbe2b5220100                      mov.l   #122B5h, r14
FFF3FDD4  f8e400                            mov.b   #0, [r14]
FFF3FDD7  fbe2b2220100           loc_FFF3FDD7 mov.l   #122B2h, r14
FFF3FDDD  58ee                              movu.b  [r14], r14
FFF3FDDF  610e                              cmp     #0, r14
FFF3FDE1  212a                              bne.b   loc_FFF3FE0B
FFF3FDE3  fbe2b3220100                      mov.l   #122B3h, r14
FFF3FDE9  58ee                              movu.b  [r14], r14
FFF3FDEB  611e                              cmp     #1, r14
FFF3FDED  2111                              bne.b   loc_FFF3FDFE
FFF3FDEF  fbe29b220100                      mov.l   #1229Bh, r14
FFF3FDF5  58ee                              movu.b  [r14], r14
FFF3FDF7  611e                              cmp     #1, r14
FFF3FDF9  1d                                bne.s   loc_FFF3FDFE
FFF3FDFA  f80601                            mov.l   #1, 8+var_8[sp]
FFF3FDFD  0c                                bra.s   loc_FFF3FE01
FFF3FDFE  f80600                 loc_FFF3FDFE mov.l   #0, 8+var_8[sp]
FFF3FE01  ec01                   loc_FFF3FE01 mov.l   8+var_8[sp], r1
FFF3FE03  6101                              cmp     #0, r1
FFF3FE05  16                                beq.s   loc_FFF3FE0B
FFF3FE06  391ebc                            bsr.w   sub_FFF3BA24
FFF3FE09  6702                              rtsd    #2
FFF3FE0B  6702                   loc_FFF3FE0B rtsd    #2

; ######## sub_FFF1427F FFF1427F-FFF14433 (file 31427F) callers: FFF3F19D(sub_FFF3F146), FFF3F285(sub_FFF3F1FF), FFF3F71E(sub_FFF3F648)
FFF1427F  7100c8                 sub_FFF1427F add     #-38h, sp, sp   ; <<<< FUNC sub_FFF1427F
FFF14282  a309                              mov.l   r1, 38h+var_4[sp]
FFF14284  a302                              mov.l   r2, 38h+var_8[sp]
FFF14286  a28b                              mov.l   r3, 38h+var_C[sp]
FFF14288  3d8400                            mov.w   #0, 38h+var_10[sp]
FFF1428B  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF1428E  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF14291  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF14294  fbe278020200                      mov.l   #20278h, r14
FFF1429A  5cee                              movu.w  [r14], r14
FFF1429C  612e                              cmp     #2, r14
FFF1429E  19                                bne.s   loc_FFF142A7
FFF1429F  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142A4  388701                            bra.w   loc_FFF1442B
FFF142A7  fb1278020200           loc_FFF142A7 mov.l   #20278h, r1
FFF142AD  b891                              movu.w  4[r1], r1
FFF142AF  6121                              cmp     #2, r1
FFF142B1  2121                              bne.b   loc_FFF142D2
FFF142B3  397105                            bsr.w   sub_FFF14824
FFF142B6  fbe278020200                      mov.l   #20278h, r14
FFF142BC  eeee4dc0                          mov.l   30134h[r14], r14
FFF142C0  610e                              cmp     #0, r14
FFF142C2  2010                              beq.b   loc_FFF142D2
FFF142C4  fbe278020200                      mov.l   #20278h, r14
FFF142CA  eee14dc0                          mov.l   30134h[r14], r1
FFF142CE  054c2b00                          bsr.a   sub_FFF16E1A
FFF142D2  ab09                   loc_FFF142D2 mov.l   38h+var_4[sp], r1
FFF142D4  710210                            add     #38h+var_28, sp, r2
FFF142D7  0529f7ff                          bsr.a   sub_FFF13A00
FFF142DB  9501                              mov.w   r1, 38h+var_10[sp]
FFF142DD  bd01                              movu.w  38h+var_10[sp], r1
FFF142DF  6101                              cmp     #0, r1
FFF142E1  11                                beq.s   loc_FFF142EA
FFF142E2  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142E7  384401                            bra.w   loc_FFF1442B
FFF142EA  ab01                   loc_FFF142EA mov.l   38h+var_8[sp], r1
FFF142EC  06850104                          cmp     38h+var_28[sp].l, r1
FFF142F0  250a                              bleu.b  loc_FFF142FA
FFF142F2  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF142F7  383401                            bra.w   loc_FFF1442B
FFF142FA  fbe2d0940600           loc_FFF142FA mov.l   #694D0h, r14
FFF14300  e10e04                            mov.l   38h+var_28[sp], [r14]
FFF14303  fbe299220100                      mov.l   #12299h, r14
FFF14309  f8e401                            mov.b   #1, [r14]
FFF1430C  ab09                              mov.l   38h+var_4[sp], r1
FFF1430E  fb22d0adf4ff                      mov.l   #loc_FFF4ADD0, r2
FFF14314  05341c00                          bsr.a   sub_FFF15F48
FFF14318  a081                              mov.l   r1, 38h+var_30[sp]
FFF1431A  a881                              mov.l   38h+var_30[sp], r1
FFF1431C  6101                              cmp     #0, r1
FFF1431E  212e                              bne.b   loc_FFF1434C
FFF14320  a882                              mov.l   38h+var_30[sp], r2
FFF14322  ab09                              mov.l   38h+var_4[sp], r1
FFF14324  05f1f7ff                          bsr.a   sub_FFF13B15
FFF14328  ab09                              mov.l   38h+var_4[sp], r1
FFF1432A  fb22d0adf4ff                      mov.l   #loc_FFF4ADD0, r2
FFF14330  05181c00                          bsr.a   sub_FFF15F48
FFF14334  a081                              mov.l   r1, 38h+var_30[sp]
FFF14336  a881                              mov.l   38h+var_30[sp], r1
FFF14338  6101                              cmp     #0, r1
FFF1433A  2112                              bne.b   loc_FFF1434C
FFF1433C  a882                              mov.l   38h+var_30[sp], r2
FFF1433E  ab09                              mov.l   38h+var_4[sp], r1
FFF14340  05d5f7ff                          bsr.a   sub_FFF13B15
FFF14344  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14349  38e200                            bra.w   loc_FFF1442B
FFF1434C  ab01                   loc_FFF1434C mov.l   38h+var_8[sp], r1
FFF1434E  7c01                              btst    #0, r1
FFF14350  17                                beq.s   loc_FFF14357
FFF14351  ab01                              mov.l   38h+var_8[sp], r1
FFF14353  6211                              add     #1, r1
FFF14355  a301                              mov.l   r1, 38h+var_8[sp]
FFF14357  ab01                   loc_FFF14357 mov.l   38h+var_8[sp], r1
FFF14359  71112c                            add     #2Ch, r1, r1 ; ','
FFF1435C  a089                              mov.l   r1, 38h+var_2C[sp]
FFF1435E  a88a                              mov.l   38h+var_2C[sp], r2
FFF14360  a881                              mov.l   38h+var_30[sp], r1
FFF14362  6603                              mov.l   #0, r3
FFF14364  05eb4f00                          bsr.a   sub_FFF1934F
FFF14368  a009                              mov.l   r1, 38h+var_34[sp]
FFF1436A  a809                              mov.l   38h+var_34[sp], r1
FFF1436C  7501ff                            cmp     #-1, r1
FFF1436F  2110                              bne.b   loc_FFF1437F
FFF14371  a881                              mov.l   38h+var_30[sp], r1
FFF14373  05a72a00                          bsr.a   sub_FFF16E1A
FFF14377  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF1437C  38af00                            bra.w   loc_FFF1442B
FFF1437F  ab0a                   loc_FFF1437F mov.l   38h+var_4[sp], r2
FFF14381  fb1278020200                      mov.l   #20278h, r1
FFF14387  6261                              add     #6, r1
FFF14389  05c71103                          bsr.a   sub_FFF45550
FFF1438D  ab01                              mov.l   38h+var_8[sp], r1
FFF1438F  71112c                            add     #2Ch, r1, r1 ; ','
FFF14392  fbe278020200                      mov.l   #20278h, r14
FFF14398  e7e143                            mov.l   r1, 10Ch[r14]
FFF1439B  fbe278020200                      mov.l   #20278h, r14
FFF143A1  e50e0442                          mov.l   38h+var_28[sp], 108h[r14]
FFF143A5  fbe278020200                      mov.l   #20278h, r14
FFF143AB  e90e024dc0                        mov.l   38h+var_30[sp], 30134h[r14]
FFF143B0  3d0a00                            mov.w   #0, 38h+var_24[sp]
FFF143B3  e5000407                          mov.l   38h+var_28[sp], 38h+var_1C[sp]
FFF143B7  ab01                              mov.l   38h+var_8[sp], r1
FFF143B9  71112c                            add     #2Ch, r1, r1 ; ','
FFF143BC  a209                              mov.l   r1, 38h+var_14[sp]
FFF143BE  fb1278020200                      mov.l   #20278h, r1
FFF143C4  72112201                          add     #122h, r1, r1
FFF143C8  a201                              mov.l   r1, 38h+var_18[sp]
FFF143CA  e5000d06                          mov.l   38h+var_4[sp], 38h+var_20[sp]
FFF143CE  fbe278020200                      mov.l   #20278h, r14
FFF143D4  f9e59000                          mov.w   #0, 120h[r14]
FFF143D8  fbe278020200                      mov.l   #20278h, r14
FFF143DE  e90e0b4cc0                        mov.l   38h+var_C[sp], 30130h[r14]
FFF143E3  7100ec                            add     #-14h, sp, sp
FFF143E6  754314                            mov.l   #14h, r3
FFF143E9  710228                            add     #4Ch+var_24, sp, r2
FFF143EC  ef01                              mov.l   sp, r1
FFF143EE  7f8f                              smovf
FFF143F0  0589fcff                          bsr.a   sub_FFF14079
FFF143F4  710014                            add     #14h, sp, sp
FFF143F7  fbe278020200                      mov.l   #20278h, r14
FFF143FD  f8e501                            mov.w   #1, [r14]
FFF14400  fbe278020200                      mov.l   #20278h, r14
FFF14406  f9e58a01                          mov.w   #1, 114h[r14]
FFF1440A  fb1278020200                      mov.l   #20278h, r1
FFF14410  3d1202                            mov.w   #2, 4[r1]
FFF14413  fbe278020200                      mov.l   #20278h, r14
FFF14419  73ee3a0103                        add     #3013Ah, r14, r14
FFF1441E  f8e500                            mov.w   #0, [r14]
FFF14421  39fb0d                            bsr.w   sub_FFF1521C
FFF14424  39630c                            bsr.w   sub_FFF15087
FFF14427  d5001401                          mov.w   38h+var_10[sp], 38h+var_36[sp]
FFF1442B  d5000115               loc_FFF1442B mov.w   38h+var_36[sp], 38h+var_E[sp]
FFF1442F  bd09                              movu.w  38h+var_E[sp], r1
FFF14431  670e                              rtsd    #0Eh

; ######## sub_FFF14576 FFF14576-FFF146FC (file 314576) callers: FFF3F37D(sub_FFF3F30D)
FFF14576  7100c8                 sub_FFF14576 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF14576
FFF14579  a309                              mov.l   r1, 38h+var_4[sp]
FFF1457B  a302                              mov.l   r2, 38h+var_8[sp]
FFF1457D  a28b                              mov.l   r3, 38h+var_C[sp]
FFF1457F  3d8400                            mov.w   #0, 38h+var_10[sp]
FFF14582  3e0400                            mov.l   #0, 38h+var_28[sp]
FFF14585  3e0300                            mov.l   #0, 38h+var_2C[sp]
FFF14588  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF1458B  fbe278020200                      mov.l   #20278h, r14
FFF14591  5cee                              movu.w  [r14], r14
FFF14593  612e                              cmp     #2, r14
FFF14595  19                                bne.s   loc_FFF1459E
FFF14596  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF1459B  385901                            bra.w   loc_FFF146F4
FFF1459E  fb1278020200           loc_FFF1459E mov.l   #20278h, r1
FFF145A4  b891                              movu.w  4[r1], r1
FFF145A6  6121                              cmp     #2, r1
FFF145A8  2121                              bne.b   loc_FFF145C9
FFF145AA  397a02                            bsr.w   sub_FFF14824
FFF145AD  fbe278020200                      mov.l   #20278h, r14
FFF145B3  eeee4dc0                          mov.l   30134h[r14], r14
FFF145B7  610e                              cmp     #0, r14
FFF145B9  2010                              beq.b   loc_FFF145C9
FFF145BB  fbe278020200                      mov.l   #20278h, r14
FFF145C1  eee14dc0                          mov.l   30134h[r14], r1
FFF145C5  05552800                          bsr.a   sub_FFF16E1A
FFF145C9  ab09                   loc_FFF145C9 mov.l   38h+var_4[sp], r1
FFF145CB  710210                            add     #38h+var_28, sp, r2
FFF145CE  0532f4ff                          bsr.a   sub_FFF13A00
FFF145D2  9501                              mov.w   r1, 38h+var_10[sp]
FFF145D4  bd01                              movu.w  38h+var_10[sp], r1
FFF145D6  6101                              cmp     #0, r1
FFF145D8  11                                beq.s   loc_FFF145E1
FFF145D9  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF145DE  381601                            bra.w   loc_FFF146F4
FFF145E1  ab01                   loc_FFF145E1 mov.l   38h+var_8[sp], r1
FFF145E3  06850104                          cmp     38h+var_28[sp].l, r1
FFF145E7  250a                              bleu.b  loc_FFF145F1
FFF145E9  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF145EE  380601                            bra.w   loc_FFF146F4
FFF145F1  fbe2d0940600           loc_FFF145F1 mov.l   #694D0h, r14
FFF145F7  e10e04                            mov.l   38h+var_28[sp], [r14]
FFF145FA  fbe299220100                      mov.l   #12299h, r14
FFF14600  f8e401                            mov.b   #1, [r14]
FFF14603  ab09                              mov.l   38h+var_4[sp], r1
FFF14605  fb22d0adf4ff                      mov.l   #loc_FFF4ADD0, r2
FFF1460B  053d1900                          bsr.a   sub_FFF15F48
FFF1460F  a081                              mov.l   r1, 38h+var_30[sp]
FFF14611  a881                              mov.l   38h+var_30[sp], r1
FFF14613  6101                              cmp     #0, r1
FFF14615  2110                              bne.b   loc_FFF14625
FFF14617  a881                              mov.l   38h+var_30[sp], r1
FFF14619  05012800                          bsr.a   sub_FFF16E1A
FFF1461D  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14622  38d200                            bra.w   loc_FFF146F4
FFF14625  ab01                   loc_FFF14625 mov.l   38h+var_8[sp], r1
FFF14627  7c01                              btst    #0, r1
FFF14629  17                                beq.s   loc_FFF14630
FFF1462A  ab01                              mov.l   38h+var_8[sp], r1
FFF1462C  6211                              add     #1, r1
FFF1462E  a301                              mov.l   r1, 38h+var_8[sp]
FFF14630  e5000c03               loc_FFF14630 mov.l   38h+var_8[sp], 38h+var_2C[sp]
FFF14634  a88a                              mov.l   38h+var_2C[sp], r2
FFF14636  a881                              mov.l   38h+var_30[sp], r1
FFF14638  6603                              mov.l   #0, r3
FFF1463A  05154d00                          bsr.a   sub_FFF1934F
FFF1463E  a009                              mov.l   r1, 38h+var_34[sp]
FFF14640  a809                              mov.l   38h+var_34[sp], r1
FFF14642  7501ff                            cmp     #-1, r1
FFF14645  2110                              bne.b   loc_FFF14655
FFF14647  a881                              mov.l   38h+var_30[sp], r1
FFF14649  05d12700                          bsr.a   sub_FFF16E1A
FFF1464D  f90901ffff                        mov.w   #-1, 38h+var_36[sp]
FFF14652  38a200                            bra.w   loc_FFF146F4
FFF14655  ab0a                   loc_FFF14655 mov.l   38h+var_4[sp], r2
FFF14657  fb1278020200                      mov.l   #20278h, r1
FFF1465D  6261                              add     #6, r1
FFF1465F  05f10e03                          bsr.a   sub_FFF45550
FFF14663  fbe278020200                      mov.l   #20278h, r14
FFF14669  e50e0c43                          mov.l   38h+var_8[sp], 10Ch[r14]
FFF1466D  fbe278020200                      mov.l   #20278h, r14
FFF14673  e50e0442                          mov.l   38h+var_28[sp], 108h[r14]
FFF14677  fbe278020200                      mov.l   #20278h, r14
FFF1467D  e90e024dc0                        mov.l   38h+var_30[sp], 30134h[r14]
FFF14682  3d0a00                            mov.w   #0, 38h+var_24[sp]
FFF14685  e5000407                          mov.l   38h+var_28[sp], 38h+var_1C[sp]
FFF14689  e5000c09                          mov.l   38h+var_8[sp], 38h+var_14[sp]
FFF1468D  fb1278020200                      mov.l   #20278h, r1
FFF14693  72112201                          add     #122h, r1, r1
FFF14697  a201                              mov.l   r1, 38h+var_18[sp]
FFF14699  e5000d06                          mov.l   38h+var_4[sp], 38h+var_20[sp]
FFF1469D  fbe278020200                      mov.l   #20278h, r14
FFF146A3  f9e59000                          mov.w   #0, 120h[r14]
FFF146A7  fbe278020200                      mov.l   #20278h, r14
FFF146AD  e90e0b4cc0                        mov.l   38h+var_C[sp], 30130h[r14]
FFF146B2  7100ec                            add     #-14h, sp, sp
FFF146B5  754314                            mov.l   #14h, r3
FFF146B8  710228                            add     #4Ch+var_24, sp, r2
FFF146BB  ef01                              mov.l   sp, r1
FFF146BD  7f8f                              smovf
FFF146BF  05baf9ff                          bsr.a   sub_FFF14079
FFF146C3  710014                            add     #14h, sp, sp
FFF146C6  fbe278020200                      mov.l   #20278h, r14
FFF146CC  f8e501                            mov.w   #1, [r14]
FFF146CF  fbe278020200                      mov.l   #20278h, r14
FFF146D5  f9e58a01                          mov.w   #1, 114h[r14]
FFF146D9  fb1278020200                      mov.l   #20278h, r1
FFF146DF  3d1202                            mov.w   #2, 4[r1]
FFF146E2  fbe278020200                      mov.l   #20278h, r14
FFF146E8  73ee3a0103                        add     #3013Ah, r14, r14
FFF146ED  f8e500                            mov.w   #0, [r14]
FFF146F0  d5001401                          mov.w   38h+var_10[sp], 38h+var_36[sp]
FFF146F4  d5000115               loc_FFF146F4 mov.w   38h+var_36[sp], 38h+var_E[sp]
FFF146F8  bd09                              movu.w  38h+var_E[sp], r1
FFF146FA  670e                              rtsd    #0Eh

; ######## sub_FFF12E8B FFF12E8B-FFF12F9B (file 312E8B) callers: FFF3CEC1(sub_FFF3CE12), FFF3CED0(sub_FFF3CE12), FFF3FA4F(sub_FFF3F9E6)
FFF12E8B  7100e8                 sub_FFF12E8B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12E8B
FFF12E8E  a109                              mov.l   r1, 18h+var_4[sp]
FFF12E90  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12E93  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12E96  3e0100                            mov.l   #0, 18h+var_14[sp]
FFF12E99  a909                              mov.l   18h+var_4[sp], r1
FFF12E9B  5c1e                              movu.w  [r1], r14
FFF12E9D  610e                              cmp     #0, r14
FFF12E9F  11                                beq.s   loc_FFF12EA8
FFF12EA0  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12EA5  38ee00                            bra.w   loc_FFF12F93
FFF12EA8  a909                   loc_FFF12EA8 mov.l   18h+var_4[sp], r1
FFF12EAA  ba91                              movu.w  14h[r1], r1
FFF12EAC  6111                              cmp     #1, r1
FFF12EAE  204e                              beq.b   loc_FFF12EFC
FFF12EB0  6101                              cmp     #0, r1
FFF12EB2  3bb400                            bne.w   loc_FFF12F66
FFF12EB5  a909                              mov.l   18h+var_4[sp], r1
FFF12EB7  a819                              mov.l   4[r1], r1
FFF12EB9  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12EBF  05893000                          bsr.a   sub_FFF15F48
FFF12EC3  a089                              mov.l   r1, 18h+var_C[sp]
FFF12EC5  a889                              mov.l   18h+var_C[sp], r1
FFF12EC7  6101                              cmp     #0, r1
FFF12EC9  3b9d00                            bne.w   loc_FFF12F66
FFF12ECC  a909                              mov.l   18h+var_4[sp], r1
FFF12ECE  a819                              mov.l   4[r1], r1
FFF12ED0  a88a                              mov.l   18h+var_C[sp], r2
FFF12ED2  39430c                            bsr.w   sub_FFF13B15
FFF12ED5  a909                              mov.l   18h+var_4[sp], r1
FFF12ED7  a819                              mov.l   4[r1], r1
FFF12ED9  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12EDF  05693000                          bsr.a   sub_FFF15F48
FFF12EE3  a089                              mov.l   r1, 18h+var_C[sp]
FFF12EE5  a889                              mov.l   18h+var_C[sp], r1
FFF12EE7  6101                              cmp     #0, r1
FFF12EE9  217d                              bne.b   loc_FFF12F66
FFF12EEB  a909                              mov.l   18h+var_4[sp], r1
FFF12EED  a819                              mov.l   4[r1], r1
FFF12EEF  a88a                              mov.l   18h+var_C[sp], r2
FFF12EF1  39240c                            bsr.w   sub_FFF13B15
FFF12EF4  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12EF9  389a00                            bra.w   loc_FFF12F93
FFF12EFC  a909                   loc_FFF12EFC mov.l   18h+var_4[sp], r1
FFF12EFE  a819                              mov.l   4[r1], r1
FFF12F00  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12F06  05423000                          bsr.a   sub_FFF15F48
FFF12F0A  a089                              mov.l   r1, 18h+var_C[sp]
FFF12F0C  a889                              mov.l   18h+var_C[sp], r1
FFF12F0E  6101                              cmp     #0, r1
FFF12F10  2131                              bne.b   loc_FFF12F41
FFF12F12  a909                              mov.l   18h+var_4[sp], r1
FFF12F14  a819                              mov.l   4[r1], r1
FFF12F16  a88a                              mov.l   18h+var_C[sp], r2
FFF12F18  39fd0b                            bsr.w   sub_FFF13B15
FFF12F1B  a909                              mov.l   18h+var_4[sp], r1
FFF12F1D  a819                              mov.l   4[r1], r1
FFF12F1F  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12F25  05233000                          bsr.a   sub_FFF15F48
FFF12F29  a089                              mov.l   r1, 18h+var_C[sp]
FFF12F2B  a889                              mov.l   18h+var_C[sp], r1
FFF12F2D  6101                              cmp     #0, r1
FFF12F2F  2112                              bne.b   loc_FFF12F41
FFF12F31  a909                              mov.l   18h+var_4[sp], r1
FFF12F33  a819                              mov.l   4[r1], r1
FFF12F35  a88a                              mov.l   18h+var_C[sp], r2
FFF12F37  39de0b                            bsr.w   sub_FFF13B15
FFF12F3A  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F3F  2e54                              bra.b   loc_FFF12F93
FFF12F41  a909                   loc_FFF12F41 mov.l   18h+var_4[sp], r1
FFF12F43  a892                              mov.l   8[r1], r2
FFF12F45  a889                              mov.l   18h+var_C[sp], r1
FFF12F47  6603                              mov.l   #0, r3
FFF12F49  05066400                          bsr.a   sub_FFF1934F
FFF12F4D  a009                              mov.l   r1, 18h+var_14[sp]
FFF12F4F  a809                              mov.l   18h+var_14[sp], r1
FFF12F51  7501ff                            cmp     #-1, r1
FFF12F54  2112                              bne.b   loc_FFF12F66
FFF12F56  a909                              mov.l   18h+var_4[sp], r1
FFF12F58  a819                              mov.l   4[r1], r1
FFF12F5A  a88a                              mov.l   18h+var_C[sp], r2
FFF12F5C  39b90b                            bsr.w   sub_FFF13B15
FFF12F5F  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F64  2e2f                              bra.b   loc_FFF12F93
FFF12F66  a909                   loc_FFF12F66 mov.l   18h+var_4[sp], r1
FFF12F68  a913                              mov.l   10h[r1], r3
FFF12F6A  a899                              mov.l   0Ch[r1], r1
FFF12F6C  a88c                              mov.l   18h+var_C[sp], r4
FFF12F6E  6612                              mov.l   #1, r2
FFF12F70  053f4f00                          bsr.a   sub_FFF17EAF
FFF12F74  a081                              mov.l   r1, 18h+var_10[sp]
FFF12F76  a909                              mov.l   18h+var_4[sp], r1
FFF12F78  a882                              mov.l   18h+var_10[sp], r2
FFF12F7A  06851204                          cmp     10h[r1].l, r2
FFF12F7E  a819                              mov.l   4[r1], r1
FFF12F80  a88a                              mov.l   18h+var_C[sp], r2
FFF12F82  12                                beq.s   loc_FFF12F8C
FFF12F83  39920b                            bsr.w   sub_FFF13B15
FFF12F86  f90901ffff                        mov.w   #-1, 18h+var_16[sp]
FFF12F8B  08                                bra.s   loc_FFF12F93
FFF12F8C  39890b                 loc_FFF12F8C bsr.w   sub_FFF13B15
FFF12F8F  d5000801                          mov.w   18h+var_8[sp], 18h+var_16[sp]
FFF12F93  d5000109               loc_FFF12F93 mov.w   18h+var_16[sp], 18h+var_6[sp]
FFF12F97  ba09                              movu.w  18h+var_6[sp], r1
FFF12F99  6706                              rtsd    #6

; ######## sub_FFF12F9B FFF12F9B-FFF130F3 (file 312F9B) callers: FFF3CBDA(sub_FFF3CAD0), FFF3CEF9(sub_FFF3CE12)
FFF12F9B  7100e8                 sub_FFF12F9B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF12F9B
FFF12F9E  a109                              mov.l   r1, 18h+var_4[sp]
FFF12FA0  3d0800                            mov.w   #0, 18h+var_8[sp]
FFF12FA3  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF12FA6  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF12FA9  a909                              mov.l   18h+var_4[sp], r1
FFF12FAB  5c1e                              movu.w  [r1], r14
FFF12FAD  610e                              cmp     #0, r14
FFF12FAF  11                                beq.s   loc_FFF12FB8
FFF12FB0  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF12FB5  383601                            bra.w   loc_FFF130EB
FFF12FB8  a909                   loc_FFF12FB8 mov.l   18h+var_4[sp], r1
FFF12FBA  ba91                              movu.w  14h[r1], r1
FFF12FBC  61d1                              cmp     #0Dh, r1
FFF12FBE  11                                beq.s   loc_FFF12FC7
FFF12FBF  a909                              mov.l   18h+var_4[sp], r1
FFF12FC1  ba91                              movu.w  14h[r1], r1
FFF12FC3  755110                            cmp     #10h, r1
FFF12FC6  1d                                bne.s   loc_FFF12FCB
FFF12FC7  f80601                 loc_FFF12FC7 mov.l   #1, 18h+var_18[sp]
FFF12FCA  0c                                bra.s   loc_FFF12FCE
FFF12FCB  f80600                 loc_FFF12FCB mov.l   #0, 18h+var_18[sp]
FFF12FCE  ec01                   loc_FFF12FCE mov.l   18h+var_18[sp], r1
FFF12FD0  6101                              cmp     #0, r1
FFF12FD2  206c                              beq.b   loc_FFF1303E
FFF12FD4  a909                              mov.l   18h+var_4[sp], r1
FFF12FD6  a819                              mov.l   4[r1], r1
FFF12FD8  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF12FDE  056a2f00                          bsr.a   sub_FFF15F48
FFF12FE2  fbe274f20100                      mov.l   #1F274h, r14
FFF12FE8  e3e1                              mov.l   r1, [r14]
FFF12FEA  fbe274f20100                      mov.l   #1F274h, r14
FFF12FF0  ecee                              mov.l   [r14], r14
FFF12FF2  610e                              cmp     #0, r14
FFF12FF4  214a                              bne.b   loc_FFF1303E
FFF12FF6  fbe274f20100                      mov.l   #1F274h, r14
FFF12FFC  ece2                              mov.l   [r14], r2
FFF12FFE  a909                              mov.l   18h+var_4[sp], r1
FFF13000  a819                              mov.l   4[r1], r1
FFF13002  39130b                            bsr.w   sub_FFF13B15
FFF13005  a909                              mov.l   18h+var_4[sp], r1
FFF13007  a819                              mov.l   4[r1], r1
FFF13009  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF1300F  05392f00                          bsr.a   sub_FFF15F48
FFF13013  fbe274f20100                      mov.l   #1F274h, r14
FFF13019  e3e1                              mov.l   r1, [r14]
FFF1301B  fbe274f20100                      mov.l   #1F274h, r14
FFF13021  ecee                              mov.l   [r14], r14
FFF13023  610e                              cmp     #0, r14
FFF13025  2119                              bne.b   loc_FFF1303E
FFF13027  fbe274f20100                      mov.l   #1F274h, r14
FFF1302D  ece2                              mov.l   [r14], r2
FFF1302F  a909                              mov.l   18h+var_4[sp], r1
FFF13031  a819                              mov.l   4[r1], r1
FFF13033  39e20a                            bsr.w   sub_FFF13B15
FFF13036  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF1303B  38b000                            bra.w   loc_FFF130EB
FFF1303E  a909                   loc_FFF1303E mov.l   18h+var_4[sp], r1
FFF13040  ba91                              movu.w  14h[r1], r1
FFF13042  61e1                              cmp     #0Eh, r1
FFF13044  11                                beq.s   loc_FFF1304D
FFF13045  a909                              mov.l   18h+var_4[sp], r1
FFF13047  ba91                              movu.w  14h[r1], r1
FFF13049  755110                            cmp     #10h, r1
FFF1304C  1d                                bne.s   loc_FFF13051
FFF1304D  f80601                 loc_FFF1304D mov.l   #1, 18h+var_18[sp]
FFF13050  0c                                bra.s   loc_FFF13054
FFF13051  f80600                 loc_FFF13051 mov.l   #0, 18h+var_18[sp]
FFF13054  ec01                   loc_FFF13054 mov.l   18h+var_18[sp], r1
FFF13056  6101                              cmp     #0, r1
FFF13058  18                                bne.s   loc_FFF13060
FFF13059  a909                              mov.l   18h+var_4[sp], r1
FFF1305B  ba91                              movu.w  14h[r1], r1
FFF1305D  61f1                              cmp     #0Fh, r1
FFF1305F  1d                                bne.s   loc_FFF13064
FFF13060  f80601                 loc_FFF13060 mov.l   #1, 18h+var_18[sp]
FFF13063  0c                                bra.s   loc_FFF13067
FFF13064  f80600                 loc_FFF13064 mov.l   #0, 18h+var_18[sp]
FFF13067  ec01                   loc_FFF13067 mov.l   18h+var_18[sp], r1
FFF13069  6101                              cmp     #0, r1
FFF1306B  2033                              beq.b   loc_FFF1309E
FFF1306D  a909                              mov.l   18h+var_4[sp], r1
FFF1306F  a892                              mov.l   8[r1], r2
FFF13071  fbe274f20100                      mov.l   #1F274h, r14
FFF13077  ece1                              mov.l   [r14], r1
FFF13079  6603                              mov.l   #0, r3
FFF1307B  05d46200                          bsr.a   sub_FFF1934F
FFF1307F  a081                              mov.l   r1, 18h+var_10[sp]
FFF13081  a881                              mov.l   18h+var_10[sp], r1
FFF13083  7501ff                            cmp     #-1, r1
FFF13086  2118                              bne.b   loc_FFF1309E
FFF13088  fbe274f20100                      mov.l   #1F274h, r14
FFF1308E  ece2                              mov.l   [r14], r2
FFF13090  a909                              mov.l   18h+var_4[sp], r1
FFF13092  a819                              mov.l   4[r1], r1
FFF13094  39810a                            bsr.w   sub_FFF13B15
FFF13097  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF1309C  2e4f                              bra.b   loc_FFF130EB
FFF1309E  fbe274f20100           loc_FFF1309E mov.l   #1F274h, r14
FFF130A4  ece4                              mov.l   [r14], r4
FFF130A6  a909                              mov.l   18h+var_4[sp], r1
FFF130A8  a913                              mov.l   10h[r1], r3
FFF130AA  a899                              mov.l   0Ch[r1], r1
FFF130AC  6612                              mov.l   #1, r2
FFF130AE  05014e00                          bsr.a   sub_FFF17EAF
FFF130B2  a089                              mov.l   r1, 18h+var_C[sp]
FFF130B4  a909                              mov.l   18h+var_4[sp], r1
FFF130B6  a88a                              mov.l   18h+var_C[sp], r2
FFF130B8  06851204                          cmp     10h[r1].l, r2
FFF130BC  2016                              beq.b   loc_FFF130D2
FFF130BE  fbe274f20100                      mov.l   #1F274h, r14
FFF130C4  ece2                              mov.l   [r14], r2
FFF130C6  a819                              mov.l   4[r1], r1
FFF130C8  394d0a                            bsr.w   sub_FFF13B15
FFF130CB  f90903ffff                        mov.w   #-1, 18h+var_12[sp]
FFF130D0  2e1b                              bra.b   loc_FFF130EB
FFF130D2  ba91                   loc_FFF130D2 movu.w  14h[r1], r1
FFF130D4  61f1                              cmp     #0Fh, r1
FFF130D6  2111                              bne.b   loc_FFF130E7
FFF130D8  fbe274f20100                      mov.l   #1F274h, r14
FFF130DE  ece2                              mov.l   [r14], r2
FFF130E0  a909                              mov.l   18h+var_4[sp], r1
FFF130E2  a819                              mov.l   4[r1], r1
FFF130E4  39310a                            bsr.w   sub_FFF13B15
FFF130E7  d5000803               loc_FFF130E7 mov.w   18h+var_8[sp], 18h+var_12[sp]
FFF130EB  d5000309               loc_FFF130EB mov.w   18h+var_12[sp], 18h+var_6[sp]
FFF130EF  ba09                              movu.w  18h+var_6[sp], r1
FFF130F1  6706                              rtsd    #6

; ######## sub_FFF130F3 FFF130F3-FFF13159 (file 3130F3) callers: FFF131D1(sub_FFF131AA), FFF13A18(sub_FFF13A00), FFF14C4D(sub_FFF14BFA), FFF14E5D(sub_FFF14E1F), FFF3CB75(sub_FFF3CAD0), FFF3D05A(sub_FFF3CFD8), FFF3FA24(sub_FFF3F9E6), FFF3FB1A(sub_FFF3FAF7)
FFF130F3  7100e8                 sub_FFF130F3 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF130F3
FFF130F6  a109                              mov.l   r1, 18h+var_4[sp]
FFF130F8  a102                              mov.l   r2, 18h+var_8[sp]
FFF130FA  3d0600                            mov.w   #0, 18h+var_C[sp]
FFF130FD  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF13100  3c0300                            mov.b   #0, 18h+var_15[sp]
FFF13103  a909                              mov.l   18h+var_4[sp], r1
FFF13105  fb22b3adf4ff                      mov.l   #(loc_FFF4ADB0+3), r2
FFF1310B  053d2e00                          bsr.a   sub_FFF15F48
FFF1310F  a009                              mov.l   r1, 18h+var_14[sp]
FFF13111  a809                              mov.l   18h+var_14[sp], r1
FFF13113  6101                              cmp     #0, r1
FFF13115  210f                              bne.b   loc_FFF13124
FFF13117  a80a                              mov.l   18h+var_14[sp], r2
FFF13119  a909                              mov.l   18h+var_4[sp], r1
FFF1311B  39fa09                            bsr.w   sub_FFF13B15
FFF1311E  f809ffff                          mov.w   #-1, 18h+var_18[sp]
FFF13122  2e30                              bra.b   loc_FFF13152
FFF13124  a809                   loc_FFF13124 mov.l   18h+var_14[sp], r1
FFF13126  710208                            add     #18h+var_10, sp, r2
FFF13129  05a65a01                          bsr.a   sub_FFF28BCF
FFF1312D  8089                              mov.b   r1, 18h+var_15[sp]
FFF1312F  8889                              mov.b   18h+var_15[sp], r1
FFF13131  6101                              cmp     #0, r1
FFF13133  200f                              beq.b   loc_FFF13142
FFF13135  a80a                              mov.l   18h+var_14[sp], r2
FFF13137  a909                              mov.l   18h+var_4[sp], r1
FFF13139  39dc09                            bsr.w   sub_FFF13B15
FFF1313C  f809ffff                          mov.w   #-1, 18h+var_18[sp]
FFF13140  2e12                              bra.b   loc_FFF13152
FFF13142  a881                   loc_FFF13142 mov.l   18h+var_10[sp], r1
FFF13144  a902                              mov.l   18h+var_8[sp], r2
FFF13146  e321                              mov.l   r1, [r2]
FFF13148  a80a                              mov.l   18h+var_14[sp], r2
FFF1314A  a909                              mov.l   18h+var_4[sp], r1
FFF1314C  39c909                            bsr.w   sub_FFF13B15
FFF1314F  d10006                            mov.w   18h+var_C[sp], 18h+var_18[sp]
FFF13152  d40007                 loc_FFF13152 mov.w   18h+var_18[sp], 18h+var_A[sp]
FFF13155  b989                              movu.w  18h+var_A[sp], r1
FFF13157  6706                              rtsd    #6

; ######## sub_FFF35454 FFF35454-FFF354F0 (file 335454) callers: FFF355B4(sub_FFF3556B), FFF359D2(sub_FFF35948), FFF35AA1(sub_FFF35A08), FFF35AD3(sub_FFF35A08), FFF35B29(sub_FFF35A08), FFF35B43(sub_FFF35A08), FFF35C0D(sub_FFF35B7D), FFF35C2E(sub_FFF35B7D), FFF35C74(sub_FFF35B7D), FFF35C94(sub_FFF35B7D), FFF35E1C(sub_FFF35D0B), FFF35EE1(sub_FFF35D0B), FFF35F01(sub_FFF35D0B), FFF3620C(sub_FFF3617D)
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
