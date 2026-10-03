; ==== lmrepair  FFF25B00-FFF25F80  (file 325B00-325F80) ====
FFF25B00  2193                              bne.b   loc_FFF25A93
FFF25B02  ff                                .byte 0FFh
FFF25B03  e301                   sub_FFF25B03 mov.l   r1, 0[sp]   ; <<<< FUNC sub_FFF25B03
FFF25B05  ec01                   loc_FFF25B05 mov.l   18h+var_18[sp], r1
FFF25B07  a089                              mov.l   r1, 18h+var_C[sp]
FFF25B09  6706                              rtsd    #6
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
FFF25BE9  fb2238aef4ff                      mov.l   #aLmrepair, r2; ":\\LMREPAIR"
FFF25BEF  05778a00                          bsr.a   sub_FFF2E666
FFF25BF3  aa09                              mov.l   30h+var_C[sp], r1
FFF25BF5  72110c10                          add     #100Ch, r1, r1
FFF25BF9  fb2243aef4ff                      mov.l   #aR, r2; "r"
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
FFF25E1F  fb2245aef4ff                      mov.l   #aW, r2; "w"
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
FFF25F05  7100c4                 sub_FFF25F05 add     #-3Ch, sp, sp   ; <<<< FUNC sub_FFF25F05
FFF25F08  a381                              mov.l   r1, 3Ch+var_4[sp]
FFF25F0A  a30a                              mov.l   r2, 3Ch+var_8[sp]
FFF25F0C  a303                              mov.l   r3, 3Ch+var_C[sp]
FFF25F0E  a28c                              mov.l   r4, 3Ch+var_10[sp]
FFF25F10  ab81                              mov.l   3Ch+var_4[sp], r1
FFF25F12  ad99                              mov.l   5Ch[r1], r1
FFF25F14  6851                              shlr    #5, r1
FFF25F16  6011                              sub     #1, r1
FFF25F18  a101                              mov.l   r1, 3Ch+var_2C[sp]
FFF25F1A  3c8600                            mov.b   #0, 3Ch+var_26[sp]
FFF25F1D  38b802                            bra.w   loc_FFF261D5
FFF25F20  ab81                   loc_FFF25F20 mov.l   3Ch+var_4[sp], r1
FFF25F22  ae1a                              mov.l   64h[r1], r2
FFF25F24  490216                            add     3Ch+var_26[sp], r2
FFF25F27  ab03                              mov.l   3Ch+var_C[sp], r3
FFF25F29  39e002                            bsr.w   sub_FFF26209
FFF25F2C  a209                              mov.l   r1, 3Ch+var_18[sp]
FFF25F2E  aa09                              mov.l   3Ch+var_18[sp], r1
FFF25F30  6101                              cmp     #0, r1
FFF25F32  10                                beq.s   loc_FFF25F3A
FFF25F33  e5000901                          mov.l   3Ch+var_18[sp], 3Ch+var_38[sp]
FFF25F37  38cc02                            bra.w   loc_FFF26203
FFF25F3A  ab01                   loc_FFF25F3A mov.l   3Ch+var_C[sp], r1
FFF25F3C  711110                            add     #10h, r1, r1
FFF25F3F  a201                              mov.l   r1, 3Ch+var_1C[sp]
FFF25F41  b581                              movu.b  3Ch+var_26[sp], r1
FFF25F43  aa8a                              mov.l   3Ch+var_10[sp], r2
FFF25F45  cb213116                          mov.b   r1, 1631h[r2]
FFF25F49  ab02                              mov.l   3Ch+var_C[sp], r2
FFF25F4B  aa89                              mov.l   3Ch+var_10[sp], r1
FFF25F4D  fb3a0002                          mov.l   #200h, r3
FFF25F51  05278500                          bsr.a   sub_FFF2E478
FFF25F55  aa8a                              mov.l   3Ch+var_10[sp], r2
FFF25F57  b581                              movu.b  3Ch+var_26[sp], r1
FFF25F59  6c21                              shll    #2, r1
FFF25F5B  4b21                              add     r2, r1
FFF25F5D  72110c0a                          add     #0A0Ch, r1, r1
FFF25F61  6222                              add     #2, r2
FFF25F63  6643                              mov.l   #4, r3
FFF25F65  05138500                          bsr.a   sub_FFF2E478
FFF25F69  ab01                              mov.l   3Ch+var_C[sp], r1
FFF25F6B  b191                              movu.b  6[r1], r1
FFF25F6D  ab82                              mov.l   3Ch+var_4[sp], r2
FFF25F6F  06052110                          cmp     10h[r2].b, r1
FFF25F73  1e                                bne.s   loc_FFF25F79
FFF25F74  3c8501                            mov.b   #1, 3Ch+var_27[sp]
FFF25F77  2e2a                              bra.b   loc_FFF25FA1
FFF25F79  ab81                   loc_FFF25F79 mov.l   3Ch+var_4[sp], r1
FFF25F7B  ab02                              mov.l   3Ch+var_C[sp], r2
FFF25F7D  c5121006                          mov.b   10h[r1], 6[r2]
