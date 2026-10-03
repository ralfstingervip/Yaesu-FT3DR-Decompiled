; ==== fat_colon2  FFF2D780-FFF2D900  (file 32D780-32D900) ====
FFF2D780  05fb16ff               sub_FFF2D780 bsr.a   sub_FFF1EE7B   ; <<<< FUNC sub_FFF2D780
FFF2D784  e301                              mov.l   r1, 0[sp]
FFF2D786  ec01                              mov.l   0[sp], r1
FFF2D788  a101                              mov.l   r1, arg_C[sp]
FFF2D78A  6707                              rtsd    #7
FFF2D78C  7100e4                 sub_FFF2D78C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2D78C
FFF2D78F  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2D791  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2D793  a981                              mov.l   1Ch+var_4[sp], r1
FFF2D795  e41002                            mov.l   [r1], 1Ch+var_14[sp]
FFF2D798  a881                              mov.l   1Ch+var_14[sp], r1
FFF2D79A  055385fe                          bsr.a   sub_FFF15CED
FFF2D79E  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2D7A0  a889                              mov.l   1Ch+var_10[sp], r1
FFF2D7A2  6101                              cmp     #0, r1
FFF2D7A4  200f                              beq.b   loc_FFF2D7B3
FFF2D7A6  6602                              mov.l   #0, r2
FFF2D7A8  fb16db                            mov.l   #-25h, r1
FFF2D7AB  05d016ff                          bsr.a   sub_FFF1EE7B
FFF2D7AF  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2D7B1  2e14                              bra.b   loc_FFF2D7C5
FFF2D7B3  a90a                   loc_FFF2D7B3 mov.l   1Ch+var_8[sp], r2
FFF2D7B5  a981                              mov.l   1Ch+var_4[sp], r1
FFF2D7B7  391400                            bsr.w   sub_FFF2D7CB
FFF2D7BA  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2D7BC  a881                              mov.l   1Ch+var_14[sp], r1
FFF2D7BE  053a85fe                          bsr.a   sub_FFF15CF8
FFF2D7C2  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF2D7C5  ec01                   loc_FFF2D7C5 mov.l   1Ch+var_1C[sp], r1
FFF2D7C7  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF2D7C9  6707                              rtsd    #7
FFF2D7CB  7ea6                   sub_FFF2D7CB push.l  r6   ; <<<< FUNC sub_FFF2D7CB
FFF2D7CD  7100b8                            add     #-48h, sp, sp
FFF2D7D0  a409                              mov.l   r1, 48h+var_4[sp]
FFF2D7D2  a402                              mov.l   r2, 48h+var_8[sp]
FFF2D7D4  f9042b00                          mov.b   #0, 48h+var_1D[sp]
FFF2D7D8  f9042a00                          mov.b   #0, 48h+var_1E[sp]
FFF2D7DC  3d8400                            mov.w   #0, 48h+var_20[sp]
FFF2D7DF  ac09                              mov.l   48h+var_4[sp], r1
FFF2D7E1  e41009                            mov.l   [r1], 48h+var_24[sp]
FFF2D7E4  3e0800                            mov.l   #0, 48h+var_28[sp]
FFF2D7E7  3e0700                            mov.l   #0, 48h+var_2C[sp]
FFF2D7EA  3e0600                            mov.l   #0, 48h+var_30[sp]
FFF2D7ED  3c8700                            mov.b   #0, 48h+var_31[sp]
FFF2D7F0  ac09                              mov.l   48h+var_4[sp], r1
FFF2D7F2  f9144200                          mov.b   #0, 42h[r1]
FFF2D7F6  ac09                              mov.l   48h+var_4[sp], r1
FFF2D7F8  f9144300                          mov.b   #0, 43h[r1]
FFF2D7FC  ac09                              mov.l   48h+var_4[sp], r1
FFF2D7FE  b119                              movu.b  5[r1], r1
FFF2D800  6101                              cmp     #0, r1
FFF2D802  3bcd01                            bne.w   loc_FFF2D9CF
FFF2D805  ac09                              mov.l   48h+var_4[sp], r1
FFF2D807  ec1e                              mov.l   [r1], r14
FFF2D809  610e                              cmp     #0, r14
FFF2D80B  1f                                bne.s   loc_FFF2D812
FFF2D80C  3e0100                            mov.l   #0, 48h+var_44[sp]
FFF2D80F  388003                            bra.w   loc_FFF2DB8F
FFF2D812  ac09                   loc_FFF2D812 mov.l   48h+var_4[sp], r1
FFF2D814  711218                            add     #18h, r1, r2
FFF2D817  a392                              mov.l   r2, 38h[r1]
FFF2D819  ac09                              mov.l   48h+var_4[sp], r1
FFF2D81B  ab92                              mov.l   38h[r1], r2
FFF2D81D  ec1e                              mov.l   [r1], r14
FFF2D81F  c1e211                            mov.b   11h[r14], [r2]
FFF2D822  ac09                              mov.l   48h+var_4[sp], r1
FFF2D824  ec1e                              mov.l   [r1], r14
FFF2D826  c5e11142                          mov.b   11h[r14], 42h[r1]
FFF2D82A  ac09                              mov.l   48h+var_4[sp], r1
FFF2D82C  ab91                              mov.l   38h[r1], r1
FFF2D82E  6211                              add     #1, r1
FFF2D830  fb224caef4ff                      mov.l   #asc_FFF4AE4C, r2; ":"
FFF2D836  05300e00                          bsr.a   sub_FFF2E666
FFF2D83A  ac09                              mov.l   48h+var_4[sp], r1
FFF2D83C  711143                            add     #43h, r1, r1 ; 'C'
FFF2D83F  fb224caef4ff                      mov.l   #asc_FFF4AE4C, r2; ":"
FFF2D845  05210e00                          bsr.a   sub_FFF2E666
FFF2D849  ac09                              mov.l   48h+var_4[sp], r1
FFF2D84B  ec1e                              mov.l   [r1], r14
FFF2D84D  e0e1                              mov.l   [r14], [r1]
FFF2D84F  ac09                              mov.l   48h+var_4[sp], r1
FFF2D851  711138                            add     #38h, r1, r1 ; '8'
FFF2D854  a009                              mov.l   r1, 48h+var_44[sp]
FFF2D856  383903                            bra.w   loc_FFF2DB8F
FFF2D859  ab01                   loc_FFF2D859 mov.l   48h+var_18[sp], r1
FFF2D85B  581e                              movu.b  [r1], r14
FFF2D85D  755e2e                            cmp     #2Eh, r14 ; '.'
FFF2D860  11                                beq.s   loc_FFF2D869
FFF2D861  ab01                              mov.l   48h+var_18[sp], r1
FFF2D863  581e                              movu.b  [r1], r14
FFF2D865  755ee5                            cmp     #-1Bh, r14
FFF2D868  1d                                bne.s   loc_FFF2D86D
FFF2D869  f80601                 loc_FFF2D869 mov.l   #1, 48h+var_48[sp]
FFF2D86C  0c                                bra.s   loc_FFF2D870
FFF2D86D  f80600                 loc_FFF2D86D mov.l   #0, 48h+var_48[sp]
FFF2D870  ec01                   loc_FFF2D870 mov.l   48h+var_48[sp], r1
FFF2D872  6101                              cmp     #0, r1
FFF2D874  200d                              beq.b   loc_FFF2D881
FFF2D876  f9042a00                          mov.b   #0, 48h+var_1E[sp]
FFF2D87A  f9042b00                          mov.b   #0, 48h+var_1D[sp]
FFF2D87E  385101                            bra.w   loc_FFF2D9CF
FFF2D881  ab01                   loc_FFF2D881 mov.l   48h+var_18[sp], r1
FFF2D883  8a99                              mov.b   0Bh[r1], r1
FFF2D885  61f1                              cmp     #0Fh, r1
FFF2D887  3b5901                            bne.w   loc_FFF2D9E0
FFF2D88A  59012a                            movu.b  48h+var_1E[sp], r1
FFF2D88D  6101                              cmp     #0, r1
FFF2D88F  2022                              beq.b   loc_FFF2D8B1
FFF2D891  754ebf                            mov.l   #-41h, r14
FFF2D894  ab01                              mov.l   48h+var_18[sp], r1
FFF2D896  501e                              and     [r1], r14
FFF2D898  59012a                            movu.b  48h+var_1E[sp], r1
FFF2D89B  6011                              sub     #1, r1
FFF2D89D  471e                              cmp     r1, r14
FFF2D89F  12                                beq.s   loc_FFF2D8A9
FFF2D8A0  f9042a00                          mov.b   #0, 48h+var_1E[sp]
FFF2D8A4  f9042b00                          mov.b   #0, 48h+var_1D[sp]
FFF2D8A8  09                                bra.s   loc_FFF2D8B1
FFF2D8A9  59012a                 loc_FFF2D8A9 movu.b  48h+var_1E[sp], r1
FFF2D8AC  6011                              sub     #1, r1
FFF2D8AE  c7012a                            mov.b   r1, 48h+var_1E[sp]
FFF2D8B1  cd012b                 loc_FFF2D8B1 mov.b   48h+var_1D[sp], r1
FFF2D8B4  755114                            cmp     #14h, r1
FFF2D8B7  290a                              blt.b   loc_FFF2D8C1
FFF2D8B9  f9042a00                          mov.b   #0, 48h+var_1E[sp]
FFF2D8BD  f9042b00                          mov.b   #0, 48h+var_1D[sp]
FFF2D8C1  cd012b                 loc_FFF2D8C1 mov.b   48h+var_1D[sp], r1
FFF2D8C4  6101                              cmp     #0, r1
FFF2D8C6  15                                beq.s   loc_FFF2D8CB
FFF2D8C7  f80600                            mov.l   #0, 48h+var_48[sp]
FFF2D8CA  0c                                bra.s   loc_FFF2D8CE
FFF2D8CB  f80601                 loc_FFF2D8CB mov.l   #1, 48h+var_48[sp]
FFF2D8CE  ec01                   loc_FFF2D8CE mov.l   48h+var_48[sp], r1
FFF2D8D0  6101                              cmp     #0, r1
FFF2D8D2  3aa800                            beq.w   loc_FFF2D97A
FFF2D8D5  ab01                              mov.l   48h+var_18[sp], r1
FFF2D8D7  f416                              btst    #6, [r1].b
FFF2D8D9  3af600                            beq.w   loc_FFF2D9CF
FFF2D8DC  7541bf                            mov.l   #-41h, r1
FFF2D8DF  ab02                              mov.l   48h+var_18[sp], r2
FFF2D8E1  5021                              and     [r2], r1
FFF2D8E3  c7012a                            mov.b   r1, 48h+var_1E[sp]
FFF2D8E6  ac09                              mov.l   48h+var_4[sp], r1
FFF2D8E8  a891                              mov.l   8[r1], r1
FFF2D8EA  aa0a                              mov.l   48h+var_24[sp], r2
FFF2D8EC  0685210d                          cmp     34h[r2].l, r1
FFF2D8F0  210e                              bne.b   loc_FFF2D8FE
FFF2D8F2  aa09                              mov.l   48h+var_24[sp], r1
FFF2D8F4  8c11                              mov.b   10h[r1], r1
FFF2D8F6  755120                            cmp     #20h, r1 ; ' '
FFF2D8F9  15                                beq.s   loc_FFF2D8FE
FFF2D8FA  f80601                            mov.l   #1, 48h+var_48[sp]
FFF2D8FD  0c                                bra.s   loc_FFF2D901
FFF2D8FE  f80600                 loc_FFF2D8FE mov.l   #0, 48h+var_48[sp]
