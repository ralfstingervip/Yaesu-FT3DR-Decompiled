; ==== blk_338a  FFF38A80-FFF39300  (file 338A80-339300) ====
FFF38A80  c32e                   sub_FFF38A80 mov.b   r14, [r2]   ; <<<< FUNC sub_FFF38A80
FFF38A82  fbf269030100                      mov.l   #10369h, r15
FFF38A88  fe01fe                            mov.b   r14, [r1, r15]
FFF38A8B  2e0e                              bra.b   loc_FFF38A99
FFF38A8D  fbe269030100           loc_FFF38A8D mov.l   #10369h, r14
FFF38A93  fbf6ff                            mov.l   #-1, r15
FFF38A96  fe01ef                            mov.b   r15, [r1, r14]
FFF38A99  a809                   loc_FFF38A99 mov.l   arg_0[sp], r1
FFF38A9B  6211                              add     #1, r1
FFF38A9D  a009                              mov.l   r1, arg_0[sp]
FFF38A9F  a881                              mov.l   arg_4[sp], r1
FFF38AA1  6211                              add     #1, r1
FFF38AA3  a081                              mov.l   r1, arg_4[sp]
FFF38AA5  a881                   loc_FFF38AA5 mov.l   arg_4[sp], r1
FFF38AA7  61c1                              cmp     #0Ch, r1
FFF38AA9  23c9                              bltu.b  loc_FFF38A72
FFF38AAB  b589                              movu.b  arg_13[sp], r1
FFF38AAD  755113                            cmp     #13h, r1
FFF38AB0  201a                              beq.b   loc_FFF38ACA
FFF38AB2  6191                              cmp     #9, r1
FFF38AB4  2020                              beq.b   loc_FFF38AD4
FFF38AB6  755110                            cmp     #10h, r1
FFF38AB9  2011                              beq.b   loc_FFF38ACA
FFF38ABB  6151                              cmp     #5, r1
FFF38ABD  2420                              bgtu.b  loc_FFF38ADD
FFF38ABF  fbe2a7220100                      mov.l   #122A7h, r14
FFF38AC5  c10e17                            mov.b   arg_13[sp], [r14]
FFF38AC8  2e15                              bra.b   loc_FFF38ADD
FFF38ACA  fbe2a9220100           loc_FFF38ACA mov.l   #122A9h, r14
FFF38AD0  c10e17                            mov.b   arg_13[sp], [r14]
FFF38AD3  0a                                bra.s   loc_FFF38ADD
FFF38AD4  fbe2aa220100           loc_FFF38AD4 mov.l   #122AAh, r14
FFF38ADA  c10e17                            mov.b   arg_13[sp], [r14]
FFF38ADD  b884                   loc_FFF38ADD movu.w  arg_0[sp], r4
FFF38ADF  fb3269030100                      mov.l   #10369h, r3
FFF38AE5  6602                              mov.l   #0, r2
FFF38AE7  7541e4                            mov.l   #-1Ch, r1
FFF38AEA  053e4afa                          bsr.a   sub_FFEDD528
FFF38AEE  6706                              rtsd    #6
FFF38AF0  60c0                   sub_FFF38AF0 sub     #0Ch, sp   ; <<<< FUNC sub_FFF38AF0
FFF38AF2  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF38AF4  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF38AF6  e303                              mov.l   r3, 0Ch+var_C[sp]
FFF38AF8  b909                              movu.w  0Ch+var_2[sp], r1
FFF38AFA  6151                              cmp     #5, r1
FFF38AFC  2110                              bne.b   loc_FFF38B0C
FFF38AFE  fb226caef4ff                      mov.l   #unk_FFF4AE6C, r2
FFF38B04  754110                            mov.l   #10h, r1
FFF38B07  ef23                              mov.l   r2, r3
FFF38B09  39defe                            bsr.w   sub_FFF389E7
FFF38B0C  b909                   loc_FFF38B0C movu.w  0Ch+var_2[sp], r1
FFF38B0E  6161                              cmp     #6, r1
FFF38B10  1a                                bne.s   loc_FFF38B1A
FFF38B11  fbe2a9220100                      mov.l   #122A9h, r14
FFF38B17  f8e413                            mov.b   #13h, [r14]
FFF38B1A  b909                   loc_FFF38B1A movu.w  0Ch+var_2[sp], r1
FFF38B1C  6111                              cmp     #1, r1
FFF38B1E  2117                              bne.b   loc_FFF38B35
FFF38B20  ec02                              mov.l   0Ch+var_C[sp], r2
FFF38B22  75121c                            mul     #1Ch, r2
FFF38B25  06890201                          add     0Ch+var_8[sp].l, r2
FFF38B29  7123e4                            add     #-1Ch, r2, r3
FFF38B2C  7122f0                            add     #-10h, r2, r2
FFF38B2F  754112                            mov.l   #12h, r1
FFF38B32  39b5fe                            bsr.w   sub_FFF389E7
FFF38B35  b909                   loc_FFF38B35 movu.w  0Ch+var_2[sp], r1
FFF38B37  6121                              cmp     #2, r1
FFF38B39  2119                              bne.b   loc_FFF38B52
FFF38B3B  fbe2a9220100                      mov.l   #122A9h, r14
FFF38B41  f8e413                            mov.b   #13h, [r14]
FFF38B44  fb226caef4ff                      mov.l   #unk_FFF4AE6C, r2
FFF38B4A  754111                            mov.l   #11h, r1
FFF38B4D  ef23                              mov.l   r2, r3
FFF38B4F  3998fe                            bsr.w   sub_FFF389E7
FFF38B52  b909                   loc_FFF38B52 movu.w  0Ch+var_2[sp], r1
FFF38B54  6131                              cmp     #3, r1
FFF38B56  2110                              bne.b   loc_FFF38B66
FFF38B58  fb226caef4ff                      mov.l   #unk_FFF4AE6C, r2
FFF38B5E  754113                            mov.l   #13h, r1
FFF38B61  ef23                              mov.l   r2, r3
FFF38B63  3984fe                            bsr.w   sub_FFF389E7
FFF38B66  b909                   loc_FFF38B66 movu.w  0Ch+var_2[sp], r1
FFF38B68  6141                              cmp     #4, r1
FFF38B6A  2112                              bne.b   loc_FFF38B7C
FFF38B6C  fb226caef4ff                      mov.l   #unk_FFF4AE6C, r2
FFF38B72  754113                            mov.l   #13h, r1
FFF38B75  ef23                              mov.l   r2, r3
FFF38B77  3970fe                            bsr.w   sub_FFF389E7
FFF38B7A  6703                              rtsd    #3
FFF38B7C  6703                   loc_FFF38B7C rtsd    #3
FFF38B7E  6080                   sub_FFF38B7E sub     #8, sp   ; <<<< FUNC sub_FFF38B7E
FFF38B80  9089                              mov.w   r1, 8+var_2[sp]
FFF38B82  f80600                            mov.l   #0, 8+var_8[sp]
FFF38B85  fb322d030100                      mov.l   #1032Dh, r3
FFF38B8B  fb223a030100                      mov.l   #1033Ah, r2
FFF38B91  6691                              mov.l   #9, r1
FFF38B93  3954fe                            bsr.w   sub_FFF389E7
FFF38B96  b889                              movu.w  8+var_2[sp], r1
FFF38B98  6111                              cmp     #1, r1
FFF38B9A  213e                              bne.b   loc_FFF38BD8
FFF38B9C  f80600                            mov.l   #0, 8+var_8[sp]
FFF38B9F  2e15                              bra.b   loc_FFF38BB4
FFF38BA1  ec01                   loc_FFF38BA1 mov.l   8+var_8[sp], r1
FFF38BA3  fbe23a030100                      mov.l   #1033Ah, r14
FFF38BA9  660f                              mov.l   #0, r15
FFF38BAB  fe0e1f                            mov.b   r15, [r14, r1]
FFF38BAE  ec01                              mov.l   8+var_8[sp], r1
FFF38BB0  6211                              add     #1, r1
FFF38BB2  e301                              mov.l   r1, 8+var_8[sp]
FFF38BB4  ec01                   loc_FFF38BB4 mov.l   8+var_8[sp], r1
FFF38BB6  61f1                              cmp     #0Fh, r1
FFF38BB8  25e9                              bleu.b  loc_FFF38BA1
FFF38BBA  f80600                            mov.l   #0, 8+var_8[sp]
FFF38BBD  2e15                              bra.b   loc_FFF38BD2
FFF38BBF  ec01                   loc_FFF38BBF mov.l   8+var_8[sp], r1
FFF38BC1  fbe22d030100                      mov.l   #1032Dh, r14
FFF38BC7  660f                              mov.l   #0, r15
FFF38BC9  fe0e1f                            mov.b   r15, [r14, r1]
FFF38BCC  ec01                              mov.l   8+var_8[sp], r1
FFF38BCE  6211                              add     #1, r1
FFF38BD0  e301                              mov.l   r1, 8+var_8[sp]
FFF38BD2  ec01                   loc_FFF38BD2 mov.l   8+var_8[sp], r1
FFF38BD4  61c1                              cmp     #0Ch, r1
FFF38BD6  23e9                              bltu.b  loc_FFF38BBF
FFF38BD8  6702                   loc_FFF38BD8 rtsd    #2
FFF38BDA  60c0                   sub_FFF38BDA sub     #0Ch, sp   ; <<<< FUNC sub_FFF38BDA
FFF38BDC  9109                              mov.w   r1, 0Ch+var_2[sp]
FFF38BDE  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38BE1  f80600                            mov.l   #0, 0Ch+var_C[sp]
FFF38BE4  b909                              movu.w  0Ch+var_2[sp], r1
FFF38BE6  6151                              cmp     #5, r1
FFF38BE8  3bba00                            bne.w   loc_FFF38CA2
FFF38BEB  fbe2a7220100                      mov.l   #122A7h, r14
FFF38BF1  58ee                              movu.b  [r14], r14
FFF38BF3  612e                              cmp     #2, r14
FFF38BF5  210d                              bne.b   loc_FFF38C02
FFF38BF7  fbe2a7220100                      mov.l   #122A7h, r14
FFF38BFD  f8e402                            mov.b   #2, [r14]
FFF38C00  2e21                              bra.b   loc_FFF38C21
FFF38C02  fbe2a7220100           loc_FFF38C02 mov.l   #122A7h, r14
FFF38C08  58ee                              movu.b  [r14], r14
FFF38C0A  611e                              cmp     #1, r14
FFF38C0C  210c                              bne.b   loc_FFF38C18
FFF38C0E  fbe2a7220100                      mov.l   #122A7h, r14
FFF38C14  f8e401                            mov.b   #1, [r14]
FFF38C17  0a                                bra.s   loc_FFF38C21
FFF38C18  fbe2a7220100           loc_FFF38C18 mov.l   #122A7h, r14
FFF38C1E  f8e403                            mov.b   #3, [r14]
FFF38C21  f80600                 loc_FFF38C21 mov.l   #0, 0Ch+var_C[sp]
FFF38C24  ec01                              mov.l   0Ch+var_C[sp], r1
FFF38C26  fbe269030100                      mov.l   #10369h, r14
FFF38C2C  663f                              mov.l   #3, r15
FFF38C2E  fe0e1f                            mov.b   r15, [r14, r1]
FFF38C31  ec01                              mov.l   0Ch+var_C[sp], r1
FFF38C33  6211                              add     #1, r1
FFF38C35  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF38C37  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38C3A  2e24                              bra.b   loc_FFF38C5E
FFF38C3C  a809                   loc_FFF38C3C mov.l   0Ch+var_8[sp], r1
FFF38C3E  fbe258030100                      mov.l   #10358h, r14
FFF38C44  fece1e                            movu.b  [r14, r1], r14
FFF38C47  fbf269030100                      mov.l   #10369h, r15
FFF38C4D  ec01                              mov.l   0Ch+var_C[sp], r1
FFF38C4F  fe0f1e                            mov.b   r14, [r15, r1]
FFF38C52  ec01                              mov.l   0Ch+var_C[sp], r1
FFF38C54  6211                              add     #1, r1
FFF38C56  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF38C58  a809                              mov.l   0Ch+var_8[sp], r1
FFF38C5A  6211                              add     #1, r1
FFF38C5C  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38C5E  a809                   loc_FFF38C5E mov.l   0Ch+var_8[sp], r1
FFF38C60  61f1                              cmp     #0Fh, r1
FFF38C62  25da                              bleu.b  loc_FFF38C3C
FFF38C64  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38C67  2e22                              bra.b   loc_FFF38C89
FFF38C69  a80a                   loc_FFF38C69 mov.l   0Ch+var_8[sp], r2
FFF38C6B  fbe24b030100                      mov.l   #1034Bh, r14
FFF38C71  fece2e                            movu.b  [r14, r2], r14
FFF38C74  fbf269030100                      mov.l   #10369h, r15
FFF38C7A  fe0f1e                            mov.b   r14, [r15, r1]
FFF38C7D  ec01                              mov.l   0Ch+var_C[sp], r1
FFF38C7F  6211                              add     #1, r1
FFF38C81  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF38C83  a809                              mov.l   0Ch+var_8[sp], r1
FFF38C85  6211                              add     #1, r1
FFF38C87  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38C89  a809                   loc_FFF38C89 mov.l   0Ch+var_8[sp], r1
FFF38C8B  61c1                              cmp     #0Ch, r1
FFF38C8D  ec01                              mov.l   0Ch+var_C[sp], r1
FFF38C8F  23da                              bltu.b  loc_FFF38C69
FFF38C91  5f14                              movu.w  r1, r4
FFF38C93  fb3269030100                      mov.l   #10369h, r3
FFF38C99  6602                              mov.l   #0, r2
FFF38C9B  7541e4                            mov.l   #-1Ch, r1
FFF38C9E  058a48fa                          bsr.a   sub_FFEDD528
FFF38CA2  b909                   loc_FFF38CA2 movu.w  0Ch+var_2[sp], r1
FFF38CA4  6111                              cmp     #1, r1
FFF38CA6  212e                              bne.b   loc_FFF38CD4
FFF38CA8  fbe2c02c0100                      mov.l   #12CC0h, r14
FFF38CAE  f8e500                            mov.w   #0, [r14]
FFF38CB1  fbe2a5220100                      mov.l   #122A5h, r14
FFF38CB7  f8e400                            mov.b   #0, [r14]
FFF38CBA  fbe2a1220100                      mov.l   #122A1h, r14
FFF38CC0  f8e400                            mov.b   #0, [r14]
FFF38CC3  fb324b030100                      mov.l   #1034Bh, r3
FFF38CC9  fb2258030100                      mov.l   #10358h, r2
FFF38CCF  6601                              mov.l   #0, r1
FFF38CD1  3916fd                            bsr.w   sub_FFF389E7
FFF38CD4  b909                   loc_FFF38CD4 movu.w  0Ch+var_2[sp], r1
FFF38CD6  6121                              cmp     #2, r1
FFF38CD8  3b9d01                            bne.w   loc_FFF38E75
FFF38CDB  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF38CE1  f8e503                            mov.w   #3, [r14]
FFF38CE4  fbe2be2c0100                      mov.l   #12CBEh, r14
FFF38CEA  f8e501                            mov.w   #1, [r14]
FFF38CED  fbe2a8220100                      mov.l   #122A8h, r14
FFF38CF3  f8e424                            mov.b   #24h, [r14] ; '$'
FFF38CF6  fbe2a7220100                      mov.l   #122A7h, r14
FFF38CFC  58ee                              movu.b  [r14], r14
FFF38CFE  613e                              cmp     #3, r14
FFF38D00  3aa700                            beq.w   loc_FFF38DA7
FFF38D03  612e                              cmp     #2, r14
FFF38D05  3b3f01                            bne.w   loc_FFF38E44
FFF38D08  fbe2c02c0100                      mov.l   #12CC0h, r14
FFF38D0E  5cee                              movu.w  [r14], r14
FFF38D10  755e22                            cmp     #22h, r14 ; '"'
FFF38D13  2a29                              bgt.b   loc_FFF38D3C
FFF38D15  fbe226250100                      mov.l   #12526h, r14
FFF38D1B  5ce1                              movu.w  [r14], r1
FFF38D1D  fb32da8bf3ff                      mov.l   #sub_FFF38BDA, r3
FFF38D23  fb224b030100                      mov.l   #1034Bh, r2
FFF38D29  05050c00                          bsr.a   sub_FFF3992E
FFF38D2D  fbe2c02c0100                      mov.l   #12CC0h, r14
FFF38D33  dcef                              mov.w   [r14], r15
FFF38D35  621f                              add     #1, r15
FFF38D37  d3ef                              mov.w   r15, [r14]
FFF38D39  383c01                            bra.w   loc_FFF38E75
FFF38D3C  fbe2c02c0100           loc_FFF38D3C mov.l   #12CC0h, r14
FFF38D42  f8e500                            mov.w   #0, [r14]
FFF38D45  fbe2a1220100                      mov.l   #122A1h, r14
FFF38D4B  f8e400                            mov.b   #0, [r14]
FFF38D4E  fbe2a8220100                      mov.l   #122A8h, r14
FFF38D54  f8e424                            mov.b   #24h, [r14] ; '$'
FFF38D57  fb324b030100                      mov.l   #1034Bh, r3
FFF38D5D  fb2258030100                      mov.l   #10358h, r2
FFF38D63  6651                              mov.l   #5, r1
FFF38D65  3982fc                            bsr.w   sub_FFF389E7
FFF38D68  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38D6B  2e15                              bra.b   loc_FFF38D80
FFF38D6D  a809                   loc_FFF38D6D mov.l   0Ch+var_8[sp], r1
FFF38D6F  fbe258030100                      mov.l   #10358h, r14
FFF38D75  660f                              mov.l   #0, r15
FFF38D77  fe0e1f                            mov.b   r15, [r14, r1]
FFF38D7A  a809                              mov.l   0Ch+var_8[sp], r1
FFF38D7C  6211                              add     #1, r1
FFF38D7E  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38D80  a809                   loc_FFF38D80 mov.l   0Ch+var_8[sp], r1
FFF38D82  61f1                              cmp     #0Fh, r1
FFF38D84  25e9                              bleu.b  loc_FFF38D6D
FFF38D86  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38D89  2e15                              bra.b   loc_FFF38D9E
FFF38D8B  a809                   loc_FFF38D8B mov.l   0Ch+var_8[sp], r1
FFF38D8D  fbe24b030100                      mov.l   #1034Bh, r14
FFF38D93  660f                              mov.l   #0, r15
FFF38D95  fe0e1f                            mov.b   r15, [r14, r1]
FFF38D98  a809                              mov.l   0Ch+var_8[sp], r1
FFF38D9A  6211                              add     #1, r1
FFF38D9C  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38D9E  a809                   loc_FFF38D9E mov.l   0Ch+var_8[sp], r1
FFF38DA0  61c1                              cmp     #0Ch, r1
FFF38DA2  23e9                              bltu.b  loc_FFF38D8B
FFF38DA4  38d100                            bra.w   loc_FFF38E75
FFF38DA7  fbe2c02c0100           loc_FFF38DA7 mov.l   #12CC0h, r14
FFF38DAD  5cee                              movu.w  [r14], r14
FFF38DAF  612e                              cmp     #2, r14
FFF38DB1  2a29                              bgt.b   loc_FFF38DDA
FFF38DB3  fbe226250100                      mov.l   #12526h, r14
FFF38DB9  5ce1                              movu.w  [r14], r1
FFF38DBB  fb32da8bf3ff                      mov.l   #sub_FFF38BDA, r3
FFF38DC1  fb224b030100                      mov.l   #1034Bh, r2
FFF38DC7  05670b00                          bsr.a   sub_FFF3992E
FFF38DCB  fbe2c02c0100                      mov.l   #12CC0h, r14
FFF38DD1  dcef                              mov.w   [r14], r15
FFF38DD3  621f                              add     #1, r15
FFF38DD5  d3ef                              mov.w   r15, [r14]
FFF38DD7  389e00                            bra.w   loc_FFF38E75
FFF38DDA  fbe2c02c0100           loc_FFF38DDA mov.l   #12CC0h, r14
FFF38DE0  f8e500                            mov.w   #0, [r14]
FFF38DE3  fbe2a1220100                      mov.l   #122A1h, r14
FFF38DE9  f8e400                            mov.b   #0, [r14]
FFF38DEC  fbe2a8220100                      mov.l   #122A8h, r14
FFF38DF2  f8e424                            mov.b   #24h, [r14] ; '$'
FFF38DF5  fb324b030100                      mov.l   #1034Bh, r3
FFF38DFB  fb2258030100                      mov.l   #10358h, r2
FFF38E01  6651                              mov.l   #5, r1
FFF38E03  39e4fb                            bsr.w   sub_FFF389E7
FFF38E06  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38E09  2e15                              bra.b   loc_FFF38E1E
FFF38E0B  a809                   loc_FFF38E0B mov.l   0Ch+var_8[sp], r1
FFF38E0D  fbe258030100                      mov.l   #10358h, r14
FFF38E13  660f                              mov.l   #0, r15
FFF38E15  fe0e1f                            mov.b   r15, [r14, r1]
FFF38E18  a809                              mov.l   0Ch+var_8[sp], r1
FFF38E1A  6211                              add     #1, r1
FFF38E1C  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38E1E  a809                   loc_FFF38E1E mov.l   0Ch+var_8[sp], r1
FFF38E20  61f1                              cmp     #0Fh, r1
FFF38E22  25e9                              bleu.b  loc_FFF38E0B
FFF38E24  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38E27  2e15                              bra.b   loc_FFF38E3C
FFF38E29  a809                   loc_FFF38E29 mov.l   0Ch+var_8[sp], r1
FFF38E2B  fbe24b030100                      mov.l   #1034Bh, r14
FFF38E31  660f                              mov.l   #0, r15
FFF38E33  fe0e1f                            mov.b   r15, [r14, r1]
FFF38E36  a809                              mov.l   0Ch+var_8[sp], r1
FFF38E38  6211                              add     #1, r1
FFF38E3A  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38E3C  a809                   loc_FFF38E3C mov.l   0Ch+var_8[sp], r1
FFF38E3E  61c1                              cmp     #0Ch, r1
FFF38E40  23e9                              bltu.b  loc_FFF38E29
FFF38E42  2e33                              bra.b   loc_FFF38E75
FFF38E44  fb324b030100           loc_FFF38E44 mov.l   #1034Bh, r3
FFF38E4A  fb2258030100                      mov.l   #10358h, r2
FFF38E50  6651                              mov.l   #5, r1
FFF38E52  3995fb                            bsr.w   sub_FFF389E7
FFF38E55  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38E58  0f                                bra.s   loc_FFF38E5F
FFF38E59  a809                   loc_FFF38E59 mov.l   0Ch+var_8[sp], r1
FFF38E5B  6211                              add     #1, r1
FFF38E5D  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38E5F  a809                   loc_FFF38E5F mov.l   0Ch+var_8[sp], r1
FFF38E61  61f1                              cmp     #0Fh, r1
FFF38E63  25f6                              bleu.b  loc_FFF38E59
FFF38E65  3e0100                            mov.l   #0, 0Ch+var_8[sp]
FFF38E68  0f                                bra.s   loc_FFF38E6F
FFF38E69  a809                   loc_FFF38E69 mov.l   0Ch+var_8[sp], r1
FFF38E6B  6211                              add     #1, r1
FFF38E6D  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF38E6F  a809                   loc_FFF38E6F mov.l   0Ch+var_8[sp], r1
FFF38E71  61c1                              cmp     #0Ch, r1
FFF38E73  23f6                              bltu.b  loc_FFF38E69
FFF38E75  b909                   loc_FFF38E75 movu.w  0Ch+var_2[sp], r1
FFF38E77  6191                              cmp     #9, r1
FFF38E79  2137                              bne.b   loc_FFF38EB0
FFF38E7B  fbe2be2c0100                      mov.l   #12CBEh, r14
FFF38E81  f8e501                            mov.w   #1, [r14]
FFF38E84  fbe2ab220100                      mov.l   #122ABh, r14
FFF38E8A  f8e417                            mov.b   #17h, [r14]
FFF38E8D  fbe2a8220100                      mov.l   #122A8h, r14
FFF38E93  f8e424                            mov.b   #24h, [r14] ; '$'
FFF38E96  fbe2a7220100                      mov.l   #122A7h, r14
FFF38E9C  f8e402                            mov.b   #2, [r14]
FFF38E9F  fb324b030100                      mov.l   #1034Bh, r3
FFF38EA5  fb2258030100                      mov.l   #10358h, r2
FFF38EAB  6621                              mov.l   #2, r1
FFF38EAD  393afb                            bsr.w   sub_FFF389E7
FFF38EB0  b909                   loc_FFF38EB0 movu.w  0Ch+var_2[sp], r1
FFF38EB2  6131                              cmp     #3, r1
FFF38EB4  2145                              bne.b   loc_FFF38EF9
FFF38EB6  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF38EBC  f8e503                            mov.w   #3, [r14]
FFF38EBF  fbe2be2c0100                      mov.l   #12CBEh, r14
FFF38EC5  f8e501                            mov.w   #1, [r14]
FFF38EC8  fbe2a8220100                      mov.l   #122A8h, r14
FFF38ECE  f8e424                            mov.b   #24h, [r14] ; '$'
FFF38ED1  fbe2a7220100                      mov.l   #122A7h, r14
FFF38ED7  58ee                              movu.b  [r14], r14
FFF38ED9  612e                              cmp     #2, r14
FFF38EDB  201e                              beq.b   loc_FFF38EF9
FFF38EDD  fbe2a7220100                      mov.l   #122A7h, r14
FFF38EE3  f8e401                            mov.b   #1, [r14]
FFF38EE6  fb324b030100                      mov.l   #1034Bh, r3
FFF38EEC  fb2258030100                      mov.l   #10358h, r2
FFF38EF2  6611                              mov.l   #1, r1
FFF38EF4  39f3fa                            bsr.w   sub_FFF389E7
FFF38EF7  6703                              rtsd    #3
FFF38EF9  6703                   loc_FFF38EF9 rtsd    #3
FFF38EFB  7100f0                 sub_FFF38EFB add     #-10h, sp, sp   ; <<<< FUNC sub_FFF38EFB
FFF38EFE  9189                              mov.w   r1, 10h+var_2[sp]
FFF38F00  3e0200                            mov.l   #0, 10h+var_8[sp]
FFF38F03  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF38F06  b989                              movu.w  10h+var_2[sp], r1
FFF38F08  6111                              cmp     #1, r1
FFF38F0A  3bcc00                            bne.w   loc_FFF38FD6
FFF38F0D  fbe2be2c0100                      mov.l   #12CBEh, r14
FFF38F13  f8e502                            mov.w   #2, [r14]
FFF38F16  fbe2ab220100                      mov.l   #122ABh, r14
FFF38F1C  f8e419                            mov.b   #19h, [r14]
FFF38F1F  fbe2a0220100                      mov.l   #122A0h, r14
FFF38F25  58ee                              movu.b  [r14], r14
FFF38F27  614e                              cmp     #4, r14
FFF38F29  2057                              beq.b   loc_FFF38F80
FFF38F2B  613e                              cmp     #3, r14
FFF38F2D  2079                              beq.b   loc_FFF38FA6
FFF38F2F  611e                              cmp     #1, r14
FFF38F31  3ba500                            bne.w   loc_FFF38FD6
FFF38F34  fbe21e250100                      mov.l   #1251Eh, r14
FFF38F3A  f8e505                            mov.w   #5, [r14]
FFF38F3D  fbe220250100                      mov.l   #12520h, r14
FFF38F43  f8e401                            mov.b   #1, [r14]
FFF38F46  6080                              sub     #8, sp
FFF38F48  fbe220250100                      mov.l   #12520h, r14
FFF38F4E  d5e00202                          mov.w   4[r14], 18h+var_14[sp]
FFF38F52  e0e0                              mov.l   [r14], 18h+var_18[sp]
FFF38F54  fb225c94f3ff                      mov.l   #unk_FFF3945C, r2
FFF38F5A  6611                              mov.l   #1, r1
FFF38F5C  050f0e00                          bsr.a   sub_FFF39D6B
FFF38F60  6280                              add     #8, sp
FFF38F62  a009                              mov.l   r1, 10h+var_C[sp]
FFF38F64  a809                              mov.l   10h+var_C[sp], r1
FFF38F66  6101                              cmp     #0, r1
FFF38F68  200d                              beq.b   loc_FFF38F75
FFF38F6A  fbe21e250100                      mov.l   #1251Eh, r14
FFF38F70  f8e507                            mov.w   #7, [r14]
FFF38F73  6704                              rtsd    #4
FFF38F75  fbe2b82c0100           loc_FFF38F75 mov.l   #12CB8h, r14
FFF38F7B  f8e501                            mov.w   #1, [r14]
FFF38F7E  2e58                              bra.b   loc_FFF38FD6
FFF38F80  a881                   loc_FFF38F80 mov.l   10h+var_8[sp], r1
FFF38F82  fbe269030100                      mov.l   #10369h, r14
FFF38F88  661f                              mov.l   #1, r15
FFF38F8A  fe0e1f                            mov.b   r15, [r14, r1]
FFF38F8D  a881                              mov.l   10h+var_8[sp], r1
FFF38F8F  6211                              add     #1, r1
FFF38F91  a081                              mov.l   r1, 10h+var_8[sp]
FFF38F93  b904                              movu.w  10h+var_8[sp], r4
FFF38F95  fb3269030100                      mov.l   #10369h, r3
FFF38F9B  6602                              mov.l   #0, r2
FFF38F9D  7541e5                            mov.l   #-1Bh, r1
FFF38FA0  058845fa                          bsr.a   sub_FFEDD528
FFF38FA4  2e32                              bra.b   loc_FFF38FD6
FFF38FA6  3e0200                 loc_FFF38FA6 mov.l   #0, 10h+var_8[sp]
FFF38FA9  a881                              mov.l   10h+var_8[sp], r1
FFF38FAB  fbe269030100                      mov.l   #10369h, r14
FFF38FB1  661f                              mov.l   #1, r15
FFF38FB3  fe0e1f                            mov.b   r15, [r14, r1]
FFF38FB6  a881                              mov.l   10h+var_8[sp], r1
FFF38FB8  6211                              add     #1, r1
FFF38FBA  a081                              mov.l   r1, 10h+var_8[sp]
FFF38FBC  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF38FC2  f8e502                            mov.w   #2, [r14]
FFF38FC5  b904                              movu.w  10h+var_8[sp], r4
FFF38FC7  fb3269030100                      mov.l   #10369h, r3
FFF38FCD  6602                              mov.l   #0, r2
FFF38FCF  7541e6                            mov.l   #-1Ah, r1
FFF38FD2  055645fa                          bsr.a   sub_FFEDD528
FFF38FD6  b989                   loc_FFF38FD6 movu.w  10h+var_2[sp], r1
FFF38FD8  6131                              cmp     #3, r1
FFF38FDA  3bc800                            bne.w   loc_FFF390A2
FFF38FDD  fbe2ab220100                      mov.l   #122ABh, r14
FFF38FE3  f8e417                            mov.b   #17h, [r14]
FFF38FE6  fbe2a2220100                      mov.l   #122A2h, r14
FFF38FEC  58ee                              movu.b  [r14], r14
FFF38FEE  611e                              cmp     #1, r14
FFF38FF0  210f                              bne.b   loc_FFF38FFF
FFF38FF2  05070a00                          bsr.a   sub_FFF399F9
FFF38FF6  fbe2a2220100                      mov.l   #122A2h, r14
FFF38FFC  f8e400                            mov.b   #0, [r14]
FFF38FFF  fbe2a0220100           loc_FFF38FFF mov.l   #122A0h, r14
FFF39005  58ee                              movu.b  [r14], r14
FFF39007  614e                              cmp     #4, r14
FFF39009  206c                              beq.b   loc_FFF39075
FFF3900B  613e                              cmp     #3, r14
FFF3900D  2036                              beq.b   loc_FFF39043
FFF3900F  611e                              cmp     #1, r14
FFF39011  3b8800                            bne.w   loc_FFF39099
FFF39014  a881                              mov.l   10h+var_8[sp], r1
FFF39016  fbe269030100                      mov.l   #10369h, r14
FFF3901C  660f                              mov.l   #0, r15
FFF3901E  fe0e1f                            mov.b   r15, [r14, r1]
FFF39021  a881                              mov.l   10h+var_8[sp], r1
FFF39023  6211                              add     #1, r1
FFF39025  a081                              mov.l   r1, 10h+var_8[sp]
FFF39027  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF3902D  f8e501                            mov.w   #1, [r14]
FFF39030  b904                              movu.w  10h+var_8[sp], r4
FFF39032  fb3269030100                      mov.l   #10369h, r3
FFF39038  6602                              mov.l   #0, r2
FFF3903A  7541e5                            mov.l   #-1Bh, r1
FFF3903D  05eb44fa                          bsr.a   sub_FFEDD528
FFF39041  2e58                              bra.b   loc_FFF39099
FFF39043  3e0200                 loc_FFF39043 mov.l   #0, 10h+var_8[sp]
FFF39046  a881                              mov.l   10h+var_8[sp], r1
FFF39048  fbe269030100                      mov.l   #10369h, r14
FFF3904E  660f                              mov.l   #0, r15
FFF39050  fe0e1f                            mov.b   r15, [r14, r1]
FFF39053  a881                              mov.l   10h+var_8[sp], r1
FFF39055  6211                              add     #1, r1
FFF39057  a081                              mov.l   r1, 10h+var_8[sp]
FFF39059  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF3905F  f8e503                            mov.w   #3, [r14]
FFF39062  b904                              movu.w  10h+var_8[sp], r4
FFF39064  fb3269030100                      mov.l   #10369h, r3
FFF3906A  6602                              mov.l   #0, r2
FFF3906C  7541e6                            mov.l   #-1Ah, r1
FFF3906F  05b944fa                          bsr.a   sub_FFEDD528
FFF39073  2e26                              bra.b   loc_FFF39099
FFF39075  a881                   loc_FFF39075 mov.l   10h+var_8[sp], r1
FFF39077  fbe269030100                      mov.l   #10369h, r14
FFF3907D  660f                              mov.l   #0, r15
FFF3907F  fe0e1f                            mov.b   r15, [r14, r1]
FFF39082  a881                              mov.l   10h+var_8[sp], r1
FFF39084  6211                              add     #1, r1
FFF39086  a081                              mov.l   r1, 10h+var_8[sp]
FFF39088  b904                              movu.w  10h+var_8[sp], r4
FFF3908A  fb3269030100                      mov.l   #10369h, r3
FFF39090  6602                              mov.l   #0, r2
FFF39092  7541e5                            mov.l   #-1Bh, r1
FFF39095  059344fa                          bsr.a   sub_FFEDD528
FFF39099  fbe2a0220100           loc_FFF39099 mov.l   #122A0h, r14
FFF3909F  f8e400                            mov.b   #0, [r14]
FFF390A2  b989                   loc_FFF390A2 movu.w  10h+var_2[sp], r1
FFF390A4  6151                              cmp     #5, r1
FFF390A6  3bc700                            bne.w   loc_FFF3916D
FFF390A9  fbe2a0220100                      mov.l   #122A0h, r14
FFF390AF  f8e400                            mov.b   #0, [r14]
FFF390B2  fbe2ab220100                      mov.l   #122ABh, r14
FFF390B8  f8e417                            mov.b   #17h, [r14]
FFF390BB  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF390C1  5cee                              movu.w  [r14], r14
FFF390C3  612e                              cmp     #2, r14
FFF390C5  2150                              bne.b   loc_FFF39115
FFF390C7  fbe2ab220100                      mov.l   #122ABh, r14
FFF390CD  58ee                              movu.b  [r14], r14
FFF390CF  755e19                            cmp     #19h, r14
FFF390D2  200e                              beq.b   loc_FFF390E0
FFF390D4  fbe2ab220100                      mov.l   #122ABh, r14
FFF390DA  58ee                              movu.b  [r14], r14
FFF390DC  755e18                            cmp     #18h, r14
FFF390DF  1d                                bne.s   loc_FFF390E4
FFF390E0  f80601                 loc_FFF390E0 mov.l   #1, 10h+var_10[sp]
FFF390E3  0c                                bra.s   loc_FFF390E7
FFF390E4  f80600                 loc_FFF390E4 mov.l   #0, 10h+var_10[sp]
FFF390E7  ec01                   loc_FFF390E7 mov.l   10h+var_10[sp], r1
FFF390E9  6101                              cmp     #0, r1
FFF390EB  3bf500                            bne.w   loc_FFF391E0
FFF390EE  fb12fb8ef3ff                      mov.l   #sub_FFF38EFB, r1
FFF390F4  05c80900                          bsr.a   sub_FFF39ABC
FFF390F8  a009                              mov.l   r1, 10h+var_C[sp]
FFF390FA  a809                              mov.l   10h+var_C[sp], r1
FFF390FC  6101                              cmp     #0, r1
FFF390FE  3be200                            bne.w   loc_FFF391E0
FFF39101  fbe2a0220100                      mov.l   #122A0h, r14
FFF39107  f8e402                            mov.b   #2, [r14]
FFF3910A  fbe2ab220100                      mov.l   #122ABh, r14
FFF39110  f8e418                            mov.b   #18h, [r14]
FFF39113  2e5a                              bra.b   loc_FFF3916D
FFF39115  fbe2a4220100           loc_FFF39115 mov.l   #122A4h, r14
FFF3911B  58ee                              movu.b  [r14], r14
FFF3911D  611e                              cmp     #1, r14
FFF3911F  214e                              bne.b   loc_FFF3916D
FFF39121  fbe2ab220100                      mov.l   #122ABh, r14
FFF39127  58ee                              movu.b  [r14], r14
FFF39129  755e19                            cmp     #19h, r14
FFF3912C  200e                              beq.b   loc_FFF3913A
FFF3912E  fbe2ab220100                      mov.l   #122ABh, r14
FFF39134  58ee                              movu.b  [r14], r14
FFF39136  755e18                            cmp     #18h, r14
FFF39139  1d                                bne.s   loc_FFF3913E
FFF3913A  f80601                 loc_FFF3913A mov.l   #1, 10h+var_10[sp]
FFF3913D  0c                                bra.s   loc_FFF39141
FFF3913E  f80600                 loc_FFF3913E mov.l   #0, 10h+var_10[sp]
FFF39141  ec01                   loc_FFF39141 mov.l   10h+var_10[sp], r1
FFF39143  6101                              cmp     #0, r1
FFF39145  3b9b00                            bne.w   loc_FFF391E0
FFF39148  fb12fb8ef3ff                      mov.l   #sub_FFF38EFB, r1
FFF3914E  056e0900                          bsr.a   sub_FFF39ABC
FFF39152  a009                              mov.l   r1, 10h+var_C[sp]
FFF39154  a809                              mov.l   10h+var_C[sp], r1
FFF39156  6101                              cmp     #0, r1
FFF39158  3b8800                            bne.w   loc_FFF391E0
FFF3915B  fbe2a0220100                      mov.l   #122A0h, r14
FFF39161  f8e402                            mov.b   #2, [r14]
FFF39164  fbe2ab220100                      mov.l   #122ABh, r14
FFF3916A  f8e418                            mov.b   #18h, [r14]
FFF3916D  b989                   loc_FFF3916D movu.w  10h+var_2[sp], r1
FFF3916F  6121                              cmp     #2, r1
FFF39171  2145                              bne.b   loc_FFF391B6
FFF39173  fbe2a0220100                      mov.l   #122A0h, r14
FFF39179  f8e400                            mov.b   #0, [r14]
FFF3917C  fbe2ab220100                      mov.l   #122ABh, r14
FFF39182  f8e417                            mov.b   #17h, [r14]
FFF39185  fbe29d220100                      mov.l   #1229Dh, r14
FFF3918B  58ee                              movu.b  [r14], r14
FFF3918D  755e20                            cmp     #20h, r14 ; ' '
FFF39190  2026                              beq.b   loc_FFF391B6
FFF39192  fb12fb8ef3ff                      mov.l   #sub_FFF38EFB, r1
FFF39198  05240900                          bsr.a   sub_FFF39ABC
FFF3919C  a009                              mov.l   r1, 10h+var_C[sp]
FFF3919E  a809                              mov.l   10h+var_C[sp], r1
FFF391A0  6101                              cmp     #0, r1
FFF391A2  213e                              bne.b   loc_FFF391E0
FFF391A4  fbe2a0220100                      mov.l   #122A0h, r14
FFF391AA  f8e402                            mov.b   #2, [r14]
FFF391AD  fbe2ab220100                      mov.l   #122ABh, r14
FFF391B3  f8e418                            mov.b   #18h, [r14]
FFF391B6  b989                   loc_FFF391B6 movu.w  10h+var_2[sp], r1
FFF391B8  6141                              cmp     #4, r1
FFF391BA  2126                              bne.b   loc_FFF391E0
FFF391BC  fbe2ab220100                      mov.l   #122ABh, r14
FFF391C2  f8e417                            mov.b   #17h, [r14]
FFF391C5  fbe2a2220100                      mov.l   #122A2h, r14
FFF391CB  58ee                              movu.b  [r14], r14
FFF391CD  611e                              cmp     #1, r14
FFF391CF  2111                              bne.b   loc_FFF391E0
FFF391D1  05280800                          bsr.a   sub_FFF399F9
FFF391D5  fbe2a2220100                      mov.l   #122A2h, r14
FFF391DB  f8e400                            mov.b   #0, [r14]
FFF391DE  6704                              rtsd    #4
FFF391E0  6704                   loc_FFF391E0 rtsd    #4
FFF391E2  6040                   sub_FFF391E2 sub     #4, sp   ; <<<< FUNC sub_FFF391E2
FFF391E4  9009                              mov.w   r1, 4+var_2[sp]
FFF391E6  6101                              cmp     #0, r1
FFF391E8  2118                              bne.b   loc_FFF39200
FFF391EA  fbe2a6220100                      mov.l   #122A6h, r14
FFF391F0  f8e414                            mov.b   #14h, [r14]
FFF391F3  fb226caef4ff                      mov.l   #unk_FFF4AE6C, r2
FFF391F9  6611                              mov.l   #1, r1
FFF391FB  ef23                              mov.l   r2, r3
FFF391FD  39eaf7                            bsr.w   sub_FFF389E7
FFF39200  b809                   loc_FFF39200 movu.w  4+var_2[sp], r1
FFF39202  7701ffff00                        cmp     #0FFFFh, r1
FFF39207  210d                              bne.b   loc_FFF39214
FFF39209  fbe2a6220100                      mov.l   #122A6h, r14
FFF3920F  f8e415                            mov.b   #15h, [r14]
FFF39212  6701                              rtsd    #1
FFF39214  6701                   loc_FFF39214 rtsd    #1
FFF39216  7100ec                 sub_FFF39216 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF39216
FFF39219  9209                              mov.w   r1, 14h+var_2[sp]
FFF3921B  a08a                              mov.l   r2, 14h+var_8[sp]
FFF3921D  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF39220  3d0300                            mov.w   #0, 14h+var_E[sp]
FFF39223  ba09                              movu.w  14h+var_2[sp], r1
FFF39225  6161                              cmp     #6, r1
FFF39227  3b3302                            bne.w   loc_FFF3945A
FFF3922A  fbe29d220100                      mov.l   #1229Dh, r14
FFF39230  58ee                              movu.b  [r14], r14
FFF39232  755e20                            cmp     #20h, r14 ; ' '
FFF39235  fcdbe0                            sceq.l  r14
FFF39238  fbf2bc2c0100                      mov.l   #12CBCh, r15
FFF3923E  5cff                              movu.w  [r15], r15
FFF39240  612f                              cmp     #2, r15
FFF39242  3a3901                            beq.w   loc_FFF3937B
FFF39245  5bee                              movu.b  r14, r14
FFF39247  610e                              cmp     #0, r14
FFF39249  3a8e00                            beq.w   loc_FFF392D7
FFF3924C  fbe2a4220100                      mov.l   #122A4h, r14
FFF39252  f8e400                            mov.b   #0, [r14]
FFF39255  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF39258  ed0e02                            mov.l   14h+var_C[sp], r14
FFF3925B  fbf269030100                      mov.l   #10369h, r15
FFF39261  6615                              mov.l   #1, r5
FFF39263  fe0fe5                            mov.b   r5, [r15, r14]
FFF39266  ed0e02                            mov.l   14h+var_C[sp], r14
FFF39269  621e                              add     #1, r14
FFF3926B  e70e02                            mov.l   r14, 14h+var_C[sp]
FFF3926E  fbe2bc2c0100                      mov.l   #12CBCh, r14
FFF39274  f8e502                            mov.w   #2, [r14]
FFF39277  b904                              movu.w  14h+var_C[sp], r4
FFF39279  fb3269030100                      mov.l   #10369h, r3
FFF3927F  6602                              mov.l   #0, r2
FFF39281  7541e6                            mov.l   #-1Ah, r1
FFF39284  05a442fa                          bsr.a   sub_FFEDD528
FFF39288  fbe2ab220100                      mov.l   #122ABh, r14
FFF3928E  58ee                              movu.b  [r14], r14
FFF39290  755e19                            cmp     #19h, r14
FFF39293  200e                              beq.b   loc_FFF392A1
FFF39295  fbe2ab220100                      mov.l   #122ABh, r14
FFF3929B  58ee                              movu.b  [r14], r14
FFF3929D  755e18                            cmp     #18h, r14
FFF392A0  1d                                bne.s   loc_FFF392A5
FFF392A1  f80601                 loc_FFF392A1 mov.l   #1, 14h+var_14[sp]
FFF392A4  0c                                bra.s   loc_FFF392A8
FFF392A5  f80600                 loc_FFF392A5 mov.l   #0, 14h+var_14[sp]
FFF392A8  ec0e                   loc_FFF392A8 mov.l   14h+var_14[sp], r14
FFF392AA  610e                              cmp     #0, r14
FFF392AC  3bae01                            bne.w   loc_FFF3945A
FFF392AF  fb12fb8ef3ff                      mov.l   #sub_FFF38EFB, r1
FFF392B5  05070800                          bsr.a   sub_FFF39ABC
FFF392B9  9089                              mov.w   r1, 14h+var_E[sp]
FFF392BB  5d0e03                            movu.w  14h+var_E[sp], r14
FFF392BE  610e                              cmp     #0, r14
FFF392C0  3b9a01                            bne.w   loc_FFF3945A
FFF392C3  fbe2a0220100                      mov.l   #122A0h, r14
FFF392C9  f8e403                            mov.b   #3, [r14]
FFF392CC  fbe2ab220100                      mov.l   #122ABh, r14
FFF392D2  f8e418                            mov.b   #18h, [r14]
FFF392D5  6705                              rtsd    #5
FFF392D7  fbe2b82c0100           loc_FFF392D7 mov.l   #12CB8h, r14
FFF392DD  5cee                              movu.w  [r14], r14
FFF392DF  612e                              cmp     #2, r14
FFF392E1  2135                              bne.b   loc_FFF39316
FFF392E3  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF392E6  ed0e02                            mov.l   14h+var_C[sp], r14
FFF392E9  fbf269030100                      mov.l   #10369h, r15
FFF392EF  6615                              mov.l   #1, r5
FFF392F1  fe0fe5                            mov.b   r5, [r15, r14]
FFF392F4  ed0e02                            mov.l   14h+var_C[sp], r14
FFF392F7  621e                              add     #1, r14
FFF392F9  e70e02                            mov.l   r14, 14h+var_C[sp]
FFF392FC  fbe2bc2c0100                      mov.l   #12CBCh, r14
