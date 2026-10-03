; ==== fat_f  FFF2D900-FFF2E200  (file 32D900-32E200) ====
FFF2D900  00                                brk
FFF2D901  ec01                   loc_FFF2D901 mov.l   50h+var_50[sp], r1
FFF2D903  6101                              cmp     #0, r1
FFF2D905  2034                              beq.b   loc_FFF2D939
FFF2D907  aa09                              mov.l   50h+var_2C[sp], r1
FFF2D909  a89a                              mov.l   0Ch[r1], r2
FFF2D90B  06cd1204                          mul     8[r1].uw, r2
FFF2D90F  06c91203                          add     6[r1].uw, r2
FFF2D913  a202                              mov.l   r2, 50h+var_30[sp]
FFF2D915  ac09                              mov.l   50h+var_C[sp], r1
FFF2D917  a919                              mov.l   14h[r1], r1
FFF2D919  06810108                          sub     50h+var_30[sp].l, r1
FFF2D91D  a181                              mov.l   r1, 50h+var_38[sp]
FFF2D91F  aa09                              mov.l   50h+var_2C[sp], r1
FFF2D921  ad99                              mov.l   5Ch[r1], r1
FFF2D923  6851                              shlr    #5, r1
FFF2D925  068d0106                          mul     50h+var_38[sp].l, r1
FFF2D929  ac0a                              mov.l   50h+var_C[sp], r2
FFF2D92B  06c92108                          add     10h[r2].uw, r1
FFF2D92F  d72120                            mov.w   r1, 40h[r2]
FFF2D932  ac09                              mov.l   50h+var_C[sp], r1
FFF2D934  3e1f00                            mov.l   #0, 3Ch[r1]
FFF2D937  2e43                              bra.b   loc_FFF2D97A
FFF2D939  ac09                   loc_FFF2D939 mov.l   50h+var_C[sp], r1
FFF2D93B  a91a                              mov.l   14h[r1], r2
FFF2D93D  ec11                              mov.l   [r1], r1
FFF2D93F  05a616ff                          bsr.a   sub_FFF1EFE5
FFF2D943  a189                              mov.l   r1, 50h+var_34[sp]
FFF2D945  ac09                              mov.l   50h+var_C[sp], r1
FFF2D947  ec11                              mov.l   [r1], r1
FFF2D949  a98a                              mov.l   50h+var_34[sp], r2
FFF2D94B  056116ff                          bsr.a   sub_FFF1EFAC
FFF2D94F  a201                              mov.l   r1, 50h+var_30[sp]
FFF2D951  ac09                              mov.l   50h+var_C[sp], r1
FFF2D953  a919                              mov.l   14h[r1], r1
FFF2D955  06810108                          sub     50h+var_30[sp].l, r1
FFF2D959  a181                              mov.l   r1, 50h+var_38[sp]
FFF2D95B  aa09                              mov.l   50h+var_2C[sp], r1
FFF2D95D  ad99                              mov.l   5Ch[r1], r1
FFF2D95F  6851                              shlr    #5, r1
FFF2D961  068d0106                          mul     50h+var_38[sp].l, r1
FFF2D965  ac0a                              mov.l   50h+var_C[sp], r2
FFF2D967  06c92108                          add     10h[r2].uw, r1
FFF2D96B  d72120                            mov.w   r1, 40h[r2]
FFF2D96E  ac0e                              mov.l   50h+var_C[sp], r6
FFF2D970  a96a                              mov.l   14h[r6], r2
FFF2D972  ec61                              mov.l   [r6], r1
FFF2D974  057116ff                          bsr.a   sub_FFF1EFE5
FFF2D978  a3e9                              mov.l   r1, 3Ch[r6]
FFF2D97A  e5000c0b               loc_FFF2D97A mov.l   50h+var_20[sp], 50h+var_24[sp]
FFF2D97E  cd012b                            mov.b   50h+var_25[sp], r1
FFF2D981  75111a                            mul     #1Ah, r1
FFF2D984  06890110                          add     50h+var_10[sp].l, r1
FFF2D988  aa8a                              mov.l   50h+var_24[sp], r2
FFF2D98A  6212                              add     #1, r2
FFF2D98C  72111814                          add     #1418h, r1, r1
FFF2D990  66a3                              mov.l   #0Ah, r3
FFF2D992  05e60a00                          bsr.a   sub_FFF2E478
FFF2D996  cd012b                            mov.b   50h+var_25[sp], r1
FFF2D999  75111a                            mul     #1Ah, r1
FFF2D99C  06890110                          add     50h+var_10[sp].l, r1
FFF2D9A0  aa8a                              mov.l   50h+var_24[sp], r2
FFF2D9A2  62e2                              add     #0Eh, r2
FFF2D9A4  72112214                          add     #1422h, r1, r1
FFF2D9A8  66c3                              mov.l   #0Ch, r3
FFF2D9AA  05ce0a00                          bsr.a   sub_FFF2E478
FFF2D9AE  cd012b                            mov.b   50h+var_25[sp], r1
FFF2D9B1  75111a                            mul     #1Ah, r1
FFF2D9B4  06890110                          add     50h+var_10[sp].l, r1
FFF2D9B8  aa8a                              mov.l   50h+var_24[sp], r2
FFF2D9BA  71221c                            add     #1Ch, r2, r2
FFF2D9BD  72112e14                          add     #142Eh, r1, r1
FFF2D9C1  6643                              mov.l   #4, r3
FFF2D9C3  05b50a00                          bsr.a   sub_FFF2E478
FFF2D9C7  59012b                            movu.b  50h+var_25[sp], r1
FFF2D9CA  6211                              add     #1, r1
FFF2D9CC  c7012b                            mov.b   r1, 50h+var_25[sp]
FFF2D9CF  ac02                   loc_FFF2D9CF mov.l   50h+var_10[sp], r2
FFF2D9D1  ac09                              mov.l   50h+var_C[sp], r1
FFF2D9D3  05a9ebff                          bsr.a   sub_FFF2C57C
FFF2D9D7  a301                              mov.l   r1, 50h+var_20[sp]
FFF2D9D9  ab01                              mov.l   50h+var_20[sp], r1
FFF2D9DB  6101                              cmp     #0, r1
FFF2D9DD  3b7cfe                            bne.w   loc_FFF2D859
FFF2D9E0  ab01                   loc_FFF2D9E0 mov.l   50h+var_20[sp], r1
FFF2D9E2  6101                              cmp     #0, r1
FFF2D9E4  1f                                bne.s   loc_FFF2D9EB
FFF2D9E5  3e0100                            mov.l   #0, 50h+var_4C[sp]
FFF2D9E8  38a701                            bra.w   loc_FFF2DB8F
FFF2D9EB  ab01                   loc_FFF2D9EB mov.l   50h+var_20[sp], r1
FFF2D9ED  ac0a                              mov.l   50h+var_C[sp], r2
FFF2D9EF  a3a1                              mov.l   r1, 38h[r2]
FFF2D9F1  cd012b                            mov.b   50h+var_25[sp], r1
FFF2D9F4  6101                              cmp     #0, r1
FFF2D9F6  15                                beq.s   loc_FFF2D9FB
FFF2D9F7  f80600                            mov.l   #0, 50h+var_50[sp]
FFF2D9FA  0c                                bra.s   loc_FFF2D9FE
FFF2D9FB  f80601                 loc_FFF2D9FB mov.l   #1, 50h+var_50[sp]
FFF2D9FE  ec01                   loc_FFF2D9FE mov.l   50h+var_50[sp], r1
FFF2DA00  6101                              cmp     #0, r1
FFF2DA02  3a7901                            beq.w   loc_FFF2DB7B
FFF2DA05  ab01                              mov.l   50h+var_20[sp], r1
FFF2DA07  8b13                              mov.b   0Ch[r1], r3
FFF2DA09  ac09                              mov.l   50h+var_C[sp], r1
FFF2DA0B  ab92                              mov.l   38h[r1], r2
FFF2DA0D  71010a                            add     #50h+var_46, sp, r1
FFF2DA10  058d2dff                          bsr.a   sub_FFF2079D
FFF2DA14  ac02                              mov.l   50h+var_10[sp], r2
FFF2DA16  72220c04                          add     #40Ch, r2, r2
FFF2DA1A  710317                            add     #50h+var_39, sp, r3
FFF2DA1D  71010a                            add     #50h+var_46, sp, r1
FFF2DA20  052a0300                          bsr.a   sub_FFF2DD4A
FFF2DA24  a381                              mov.l   r1, 50h+var_18[sp]
FFF2DA26  ab81                              mov.l   50h+var_18[sp], r1
FFF2DA28  75019d                            cmp     #-63h, r1
FFF2DA2B  2110                              bne.b   loc_FFF2DA3B
FFF2DA2D  6602                              mov.l   #0, r2
FFF2DA2F  fb16ba                            mov.l   #-46h, r1
FFF2DA32  054914ff                          bsr.a   sub_FFF1EE7B
FFF2DA36  a009                              mov.l   r1, 50h+var_4C[sp]
FFF2DA38  385701                            bra.w   loc_FFF2DB8F
FFF2DA3B  f9043700               loc_FFF2DA3B mov.b   #0, 50h+var_19[sp]
FFF2DA3F  2e33                              bra.b   loc_FFF2DA72
FFF2DA41  ac09                   loc_FFF2DA41 mov.l   50h+var_C[sp], r1
FFF2DA43  06c90114                          add     50h+var_28[sp].uw, r1
FFF2DA47  590237                            movu.b  50h+var_19[sp], r2
FFF2DA4A  6c12                              shll    #1, r2
FFF2DA4C  06890210                          add     50h+var_10[sp].l, r2
FFF2DA50  711142                            add     #42h, r1, r1 ; 'B'
FFF2DA53  72220c04                          add     #40Ch, r2, r2
FFF2DA57  393f01                            bsr.w   sub_FFF2DB96
FFF2DA5A  a381                              mov.l   r1, 50h+var_18[sp]
FFF2DA5C  ab81                              mov.l   50h+var_18[sp], r1
FFF2DA5E  6101                              cmp     #0, r1
FFF2DA60  2019                              beq.b   loc_FFF2DA79
FFF2DA62  bd01                              movu.w  50h+var_28[sp], r1
FFF2DA64  06c9011c                          add     50h+var_18[sp].uw, r1
FFF2DA68  9501                              mov.w   r1, 50h+var_28[sp]
FFF2DA6A  590137                            movu.b  50h+var_19[sp], r1
FFF2DA6D  6211                              add     #1, r1
FFF2DA6F  c70137                            mov.b   r1, 50h+var_19[sp]
FFF2DA72  590137                 loc_FFF2DA72 movu.b  50h+var_19[sp], r1
FFF2DA75  61c1                              cmp     #0Ch, r1
FFF2DA77  29ca                              blt.b   loc_FFF2DA41
FFF2DA79  ac09                   loc_FFF2DA79 mov.l   50h+var_C[sp], r1
FFF2DA7B  06c90114                          add     50h+var_28[sp].uw, r1
FFF2DA7F  f9144200                          mov.b   #0, 42h[r1]
FFF2DA83  bd01                              movu.w  50h+var_28[sp], r1
FFF2DA85  06890111                          add     50h+var_C[sp].l, r1
FFF2DA89  f9144300                          mov.b   #0, 43h[r1]
FFF2DA8D  ac09                              mov.l   50h+var_C[sp], r1
FFF2DA8F  a891                              mov.l   8[r1], r1
FFF2DA91  aa0a                              mov.l   50h+var_2C[sp], r2
FFF2DA93  0685210d                          cmp     34h[r2].l, r1
FFF2DA97  210e                              bne.b   loc_FFF2DAA5
FFF2DA99  aa09                              mov.l   50h+var_2C[sp], r1
FFF2DA9B  8c11                              mov.b   10h[r1], r1
FFF2DA9D  755120                            cmp     #20h, r1 ; ' '
FFF2DAA0  15                                beq.s   loc_FFF2DAA5
FFF2DAA1  f80601                            mov.l   #1, 50h+var_50[sp]
FFF2DAA4  0c                                bra.s   loc_FFF2DAA8
FFF2DAA5  f80600                 loc_FFF2DAA5 mov.l   #0, 50h+var_50[sp]
FFF2DAA8  ec01                   loc_FFF2DAA8 mov.l   50h+var_50[sp], r1
FFF2DAAA  6101                              cmp     #0, r1
FFF2DAAC  2035                              beq.b   loc_FFF2DAE1
FFF2DAAE  aa09                              mov.l   50h+var_2C[sp], r1
FFF2DAB0  a89a                              mov.l   0Ch[r1], r2
FFF2DAB2  06cd1204                          mul     8[r1].uw, r2
FFF2DAB6  06c91203                          add     6[r1].uw, r2
FFF2DABA  a202                              mov.l   r2, 50h+var_30[sp]
FFF2DABC  ac09                              mov.l   50h+var_C[sp], r1
FFF2DABE  a919                              mov.l   14h[r1], r1
FFF2DAC0  06810108                          sub     50h+var_30[sp].l, r1
FFF2DAC4  a181                              mov.l   r1, 50h+var_38[sp]
FFF2DAC6  aa09                              mov.l   50h+var_2C[sp], r1
FFF2DAC8  ad99                              mov.l   5Ch[r1], r1
FFF2DACA  6851                              shlr    #5, r1
FFF2DACC  068d0106                          mul     50h+var_38[sp].l, r1
FFF2DAD0  ac0a                              mov.l   50h+var_C[sp], r2
FFF2DAD2  06c92108                          add     10h[r2].uw, r1
FFF2DAD6  d72120                            mov.w   r1, 40h[r2]
FFF2DAD9  ac09                              mov.l   50h+var_C[sp], r1
FFF2DADB  3e1f00                            mov.l   #0, 3Ch[r1]
FFF2DADE  389d00                            bra.w   loc_FFF2DB7B
FFF2DAE1  ac09                   loc_FFF2DAE1 mov.l   50h+var_C[sp], r1
FFF2DAE3  a91a                              mov.l   14h[r1], r2
FFF2DAE5  ec11                              mov.l   [r1], r1
FFF2DAE7  05fe14ff                          bsr.a   sub_FFF1EFE5
FFF2DAEB  a189                              mov.l   r1, 50h+var_34[sp]
FFF2DAED  ac09                              mov.l   50h+var_C[sp], r1
FFF2DAEF  ec11                              mov.l   [r1], r1
FFF2DAF1  a98a                              mov.l   50h+var_34[sp], r2
FFF2DAF3  05b914ff                          bsr.a   sub_FFF1EFAC
FFF2DAF7  a201                              mov.l   r1, 50h+var_30[sp]
FFF2DAF9  ac09                              mov.l   50h+var_C[sp], r1
FFF2DAFB  a919                              mov.l   14h[r1], r1
FFF2DAFD  06810108                          sub     50h+var_30[sp].l, r1
FFF2DB01  a181                              mov.l   r1, 50h+var_38[sp]
FFF2DB03  aa09                              mov.l   50h+var_2C[sp], r1
FFF2DB05  ad99                              mov.l   5Ch[r1], r1
FFF2DB07  6851                              shlr    #5, r1
FFF2DB09  068d0106                          mul     50h+var_38[sp].l, r1
FFF2DB0D  ac0a                              mov.l   50h+var_C[sp], r2
FFF2DB0F  06c92108                          add     10h[r2].uw, r1
FFF2DB13  d72120                            mov.w   r1, 40h[r2]
FFF2DB16  ac0e                              mov.l   50h+var_C[sp], r6
FFF2DB18  a96a                              mov.l   14h[r6], r2
FFF2DB1A  ec61                              mov.l   [r6], r1
FFF2DB1C  05c914ff                          bsr.a   sub_FFF1EFE5
FFF2DB20  a3e9                              mov.l   r1, 3Ch[r6]
FFF2DB22  2e59                              bra.b   loc_FFF2DB7B
FFF2DB24  f9043700               loc_FFF2DB24 mov.b   #0, 50h+var_19[sp]
FFF2DB28  2e37                              bra.b   loc_FFF2DB5F
FFF2DB2A  ac09                   loc_FFF2DB2A mov.l   50h+var_C[sp], r1
FFF2DB2C  06c90114                          add     50h+var_28[sp].uw, r1
FFF2DB30  cd022b                            mov.b   50h+var_25[sp], r2
FFF2DB33  75121a                            mul     #1Ah, r2
FFF2DB36  06890210                          add     50h+var_10[sp].l, r2
FFF2DB3A  490237                            add     50h+var_19[sp], r2
FFF2DB3D  711142                            add     #42h, r1, r1 ; 'B'
FFF2DB40  72221814                          add     #1418h, r2, r2
FFF2DB44  395200                            bsr.w   sub_FFF2DB96
FFF2DB47  a381                              mov.l   r1, 50h+var_18[sp]
FFF2DB49  ab81                              mov.l   50h+var_18[sp], r1
FFF2DB4B  6101                              cmp     #0, r1
FFF2DB4D  201a                              beq.b   loc_FFF2DB67
FFF2DB4F  bd01                              movu.w  50h+var_28[sp], r1
FFF2DB51  06c9011c                          add     50h+var_18[sp].uw, r1
FFF2DB55  9501                              mov.w   r1, 50h+var_28[sp]
FFF2DB57  590137                            movu.b  50h+var_19[sp], r1
FFF2DB5A  6221                              add     #2, r1
FFF2DB5C  c70137                            mov.b   r1, 50h+var_19[sp]
FFF2DB5F  590137                 loc_FFF2DB5F movu.b  50h+var_19[sp], r1
FFF2DB62  755119                            cmp     #19h, r1
FFF2DB65  29c5                              blt.b   loc_FFF2DB2A
FFF2DB67  ac09                   loc_FFF2DB67 mov.l   50h+var_C[sp], r1
FFF2DB69  06c90114                          add     50h+var_28[sp].uw, r1
FFF2DB6D  f9144200                          mov.b   #0, 42h[r1]
FFF2DB71  bd01                              movu.w  50h+var_28[sp], r1
FFF2DB73  06890111                          add     50h+var_C[sp].l, r1
FFF2DB77  f9144300                          mov.b   #0, 43h[r1]
FFF2DB7B  cd012b                 loc_FFF2DB7B mov.b   50h+var_25[sp], r1
FFF2DB7E  7112ff                            add     #-1, r1, r2
FFF2DB81  c7022b                            mov.b   r2, 50h+var_25[sp]
FFF2DB84  6101                              cmp     #0, r1
FFF2DB86  219e                              bne.b   loc_FFF2DB24
FFF2DB88  ac09                              mov.l   50h+var_C[sp], r1
FFF2DB8A  711138                            add     #38h, r1, r1 ; '8'
FFF2DB8D  a009                   sub_FFF2DB8D mov.l   r1, arg_0[sp]   ; <<<< FUNC sub_FFF2DB8D
FFF2DB8F  a809                   loc_FFF2DB8F mov.l   50h+var_4C[sp], r1
FFF2DB91  a389                              mov.l   r1, 50h+var_14[sp]
FFF2DB93  3f6613                            rtsd    #4Ch, r6-r6
FFF2DB96  7100e4                 sub_FFF2DB96 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2DB96
FFF2DB99  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2DB9B  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2DB9D  a08a                              mov.l   r2, 1Ch+var_10[sp]
FFF2DB9F  e5000602                          mov.l   1Ch+var_4[sp], 1Ch+var_14[sp]
FFF2DBA3  a889                              mov.l   1Ch+var_10[sp], r1
FFF2DBA5  5811                              movu.b  [r1], r1
FFF2DBA7  9089                              mov.w   r1, 1Ch+var_16[sp]
FFF2DBA9  a889                              mov.l   1Ch+var_10[sp], r1
FFF2DBAB  b019                              movu.b  1[r1], r1
FFF2DBAD  6c81                              shll    #8, r1
FFF2DBAF  06c90103                          add     1Ch+var_16[sp].uw, r1
FFF2DBB3  9089                              mov.w   r1, 1Ch+var_16[sp]
FFF2DBB5  b889                              movu.w  1Ch+var_16[sp], r1
FFF2DBB7  7701ffff00                        cmp     #0FFFFh, r1
FFF2DBBC  2014                              beq.b   loc_FFF2DBD0
FFF2DBBE  a889                              mov.l   1Ch+var_10[sp], r1
FFF2DBC0  a882                              mov.l   1Ch+var_14[sp], r2
FFF2DBC2  c11201                            mov.b   1[r1], [r2]
FFF2DBC5  a889                              mov.l   1Ch+var_10[sp], r1
FFF2DBC7  a882                              mov.l   1Ch+var_14[sp], r2
FFF2DBC9  c41201                            mov.b   [r1], 1[r2]
FFF2DBCC  f80602                            mov.l   #2, 1Ch+var_1C[sp]
FFF2DBCF  0c                                bra.s   loc_FFF2DBD3
FFF2DBD0  f80600                 loc_FFF2DBD0 mov.l   #0, 1Ch+var_1C[sp]
FFF2DBD3  ec01                   loc_FFF2DBD3 mov.l   1Ch+var_1C[sp], r1
FFF2DBD5  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF2DBD7  6707                              rtsd    #7
FFF2DBD9  7100f0                 sub_FFF2DBD9 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2DBD9
FFF2DBDC  8389                              mov.b   r1, 10h+var_1[sp]
FFF2DBDE  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF2DBE1  b389                              movu.b  10h+var_1[sp], r1
FFF2DBE3  755181                            cmp     #-7Fh, r1
FFF2DBE6  290d                              blt.b   loc_FFF2DBF3
FFF2DBE8  b389                              movu.b  10h+var_1[sp], r1
FFF2DBEA  75519f                            cmp     #-61h, r1
FFF2DBED  2a06                              bgt.b   loc_FFF2DBF3
FFF2DBEF  f80601                            mov.l   #1, 10h+var_10[sp]
FFF2DBF2  0c                                bra.s   loc_FFF2DBF6
FFF2DBF3  f80600                 loc_FFF2DBF3 mov.l   #0, 10h+var_10[sp]
FFF2DBF6  ec01                   loc_FFF2DBF6 mov.l   10h+var_10[sp], r1
FFF2DBF8  6101                              cmp     #0, r1
FFF2DBFA  211c                              bne.b   loc_FFF2DC16
FFF2DBFC  b389                              movu.b  10h+var_1[sp], r1
FFF2DBFE  7551e0                            cmp     #-20h, r1
FFF2DC01  290d                              blt.b   loc_FFF2DC0E
FFF2DC03  b389                              movu.b  10h+var_1[sp], r1
FFF2DC05  7551fc                            cmp     #-4, r1
FFF2DC08  2a06                              bgt.b   loc_FFF2DC0E
FFF2DC0A  f80601                            mov.l   #1, 10h+var_10[sp]
FFF2DC0D  0c                                bra.s   loc_FFF2DC11
FFF2DC0E  f80600                 loc_FFF2DC0E mov.l   #0, 10h+var_10[sp]
FFF2DC11  ec01                   loc_FFF2DC11 mov.l   10h+var_10[sp], r1
FFF2DC13  6101                              cmp     #0, r1
FFF2DC15  15                                beq.s   loc_FFF2DC1A
FFF2DC16  f80601                 loc_FFF2DC16 mov.l   #1, 10h+var_10[sp]
FFF2DC19  0c                                bra.s   loc_FFF2DC1D
FFF2DC1A  f80600                 loc_FFF2DC1A mov.l   #0, 10h+var_10[sp]
FFF2DC1D  ec01                   loc_FFF2DC1D mov.l   10h+var_10[sp], r1
FFF2DC1F  6101                              cmp     #0, r1
FFF2DC21  14                                beq.s   loc_FFF2DC25
FFF2DC22  3e0101                            mov.l   #1, 10h+var_C[sp]
FFF2DC25  a809                   loc_FFF2DC25 mov.l   10h+var_C[sp], r1
FFF2DC27  a081                              mov.l   r1, 10h+var_8[sp]
FFF2DC29  6704                              rtsd    #4
FFF2DC2B  7100ec                 sub_FFF2DC2B add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2DC2B
FFF2DC2E  a101                              mov.l   r1, 14h+var_4[sp]
FFF2DC30  a081                              mov.l   r1, 14h+var_C[sp]
FFF2DC32  a881                              mov.l   14h+var_C[sp], r1
FFF2DC34  5811                              movu.b  [r1], r1
FFF2DC36  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DC38  a881                              mov.l   14h+var_C[sp], r1
FFF2DC3A  581e                              movu.b  [r1], r14
FFF2DC3C  755e20                            cmp     #20h, r14 ; ' '
FFF2DC3F  290f                              blt.b   loc_FFF2DC4E
FFF2DC41  a881                              mov.l   14h+var_C[sp], r1
FFF2DC43  581e                              movu.b  [r1], r14
FFF2DC45  755e7e                            cmp     #7Eh, r14 ; '~'
FFF2DC48  2a06                              bgt.b   loc_FFF2DC4E
FFF2DC4A  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DC4D  0c                                bra.s   loc_FFF2DC51
FFF2DC4E  f80600                 loc_FFF2DC4E mov.l   #0, 14h+var_14[sp]
FFF2DC51  ec01                   loc_FFF2DC51 mov.l   14h+var_14[sp], r1
FFF2DC53  6101                              cmp     #0, r1
FFF2DC55  a881                              mov.l   14h+var_C[sp], r1
FFF2DC57  581e                              movu.b  [r1], r14
FFF2DC59  2019                              beq.b   loc_FFF2DC72
FFF2DC5B  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2DC5E  19                                bne.s   loc_FFF2DC67
FFF2DC5F  f9090300a5                        mov.w   #-5B00h, 14h+var_E[sp]
FFF2DC64  38de00                            bra.w   loc_FFF2DD42
FFF2DC67  dd0e06                 loc_FFF2DC67 mov.w   14h+var_8[sp], r14
FFF2DC6A  6c8e                              shll    #8, r14
FFF2DC6C  d70e03                            mov.w   r14, 14h+var_E[sp]
FFF2DC6F  38d300                            bra.w   loc_FFF2DD42
FFF2DC72  755e81                 loc_FFF2DC72 cmp     #-7Fh, r14
FFF2DC75  290f                              blt.b   loc_FFF2DC84
FFF2DC77  a881                              mov.l   14h+var_C[sp], r1
FFF2DC79  581e                              movu.b  [r1], r14
FFF2DC7B  755e9f                            cmp     #-61h, r14
FFF2DC7E  2a06                              bgt.b   loc_FFF2DC84
FFF2DC80  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DC83  0c                                bra.s   loc_FFF2DC87
FFF2DC84  f80600                 loc_FFF2DC84 mov.l   #0, 14h+var_14[sp]
FFF2DC87  ec01                   loc_FFF2DC87 mov.l   14h+var_14[sp], r1
FFF2DC89  6101                              cmp     #0, r1
FFF2DC8B  2031                              beq.b   loc_FFF2DCBC
FFF2DC8D  9981                              mov.w   14h+var_8[sp], r1
FFF2DC8F  6c81                              shll    #8, r1
FFF2DC91  a882                              mov.l   14h+var_C[sp], r2
FFF2DC93  552101                            or      1[r2], r1
FFF2DC96  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DC98  b981                              movu.w  14h+var_8[sp], r1
FFF2DC9A  7311c07eff                        add     #-8140h, r1, r1
FFF2DC9F  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DCA1  fbe2f06aecff                      mov.l   #unk_FFEC6AF0, r14
FFF2DCA7  b981                              movu.w  14h+var_8[sp], r1
FFF2DCA9  fe51e1                            mov.w   [r1, r14], r1
FFF2DCAC  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DCAE  b981                              movu.w  14h+var_8[sp], r1
FFF2DCB0  fdc812                            shll    #8, r1, r2
FFF2DCB3  6881                              shlr    #8, r1
FFF2DCB5  5712                              or      r1, r2
FFF2DCB7  908a                              mov.w   r2, 14h+var_E[sp]
FFF2DCB9  388900                            bra.w   loc_FFF2DD42
FFF2DCBC  a881                   loc_FFF2DCBC mov.l   14h+var_C[sp], r1
FFF2DCBE  581e                              movu.b  [r1], r14
FFF2DCC0  755ea1                            cmp     #-5Fh, r14
FFF2DCC3  290f                              blt.b   loc_FFF2DCD2
FFF2DCC5  a881                              mov.l   14h+var_C[sp], r1
FFF2DCC7  581e                              movu.b  [r1], r14
FFF2DCC9  755edf                            cmp     #-21h, r14
FFF2DCCC  2a06                              bgt.b   loc_FFF2DCD2
FFF2DCCE  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DCD1  0c                                bra.s   loc_FFF2DCD5
FFF2DCD2  f80600                 loc_FFF2DCD2 mov.l   #0, 14h+var_14[sp]
FFF2DCD5  ec01                   loc_FFF2DCD5 mov.l   14h+var_14[sp], r1
FFF2DCD7  6101                              cmp     #0, r1
FFF2DCD9  2018                              beq.b   loc_FFF2DCF1
FFF2DCDB  b981                              movu.w  14h+var_8[sp], r1
FFF2DCDD  7311c0fe00                        add     #0FEC0h, r1, r1
FFF2DCE2  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DCE4  b981                              movu.w  14h+var_8[sp], r1
FFF2DCE6  fdc812                            shll    #8, r1, r2
FFF2DCE9  6881                              shlr    #8, r1
FFF2DCEB  5712                              or      r1, r2
FFF2DCED  908a                              mov.w   r2, 14h+var_E[sp]
FFF2DCEF  2e53                              bra.b   loc_FFF2DD42
FFF2DCF1  a881                   loc_FFF2DCF1 mov.l   14h+var_C[sp], r1
FFF2DCF3  581e                              movu.b  [r1], r14
FFF2DCF5  755ee0                            cmp     #-20h, r14
FFF2DCF8  290f                              blt.b   loc_FFF2DD07
FFF2DCFA  a881                              mov.l   14h+var_C[sp], r1
FFF2DCFC  581e                              movu.b  [r1], r14
FFF2DCFE  755efc                            cmp     #-4, r14
FFF2DD01  2a06                              bgt.b   loc_FFF2DD07
FFF2DD03  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DD06  0c                                bra.s   loc_FFF2DD0A
FFF2DD07  f80600                 loc_FFF2DD07 mov.l   #0, 14h+var_14[sp]
FFF2DD0A  ec01                   loc_FFF2DD0A mov.l   14h+var_14[sp], r1
FFF2DD0C  6101                              cmp     #0, r1
FFF2DD0E  202f                              beq.b   loc_FFF2DD3D
FFF2DD10  9981                              mov.w   14h+var_8[sp], r1
FFF2DD12  6c81                              shll    #8, r1
FFF2DD14  a882                              mov.l   14h+var_C[sp], r2
FFF2DD16  552101                            or      1[r2], r1
FFF2DD19  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DD1B  b981                              movu.w  14h+var_8[sp], r1
FFF2DD1D  7311c01fff                        add     #-0E040h, r1, r1
FFF2DD22  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DD24  fbe26aa8ecff                      mov.l   #unk_FFECA86A, r14
FFF2DD2A  b981                              movu.w  14h+var_8[sp], r1
FFF2DD2C  fe51e1                            mov.w   [r1, r14], r1
FFF2DD2F  9181                              mov.w   r1, 14h+var_8[sp]
FFF2DD31  b981                              movu.w  14h+var_8[sp], r1
FFF2DD33  fdc812                            shll    #8, r1, r2
FFF2DD36  6881                              shlr    #8, r1
FFF2DD38  5712                              or      r1, r2
FFF2DD3A  908a                              mov.w   r2, 14h+var_E[sp]
FFF2DD3C  0e                                bra.s   loc_FFF2DD42
FFF2DD3D  f90903ffff             loc_FFF2DD3D mov.w   #-1, 14h+var_E[sp]
FFF2DD42  d5000307               loc_FFF2DD42 mov.w   14h+var_E[sp], 14h+var_6[sp]
FFF2DD46  b989                              movu.w  14h+var_6[sp], r1
FFF2DD48  6705                              rtsd    #5
FFF2DD4A  7100e0                 sub_FFF2DD4A add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2DD4A
FFF2DD4D  a189                              mov.l   r1, 20h+var_4[sp]
FFF2DD4F  a182                              mov.l   r2, 20h+var_8[sp]
FFF2DD51  a10b                              mov.l   r3, 20h+var_C[sp]
FFF2DD53  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF2DD56  e5000601                          mov.l   20h+var_8[sp], 20h+var_1C[sp]
FFF2DD5A  2e59                              bra.b   loc_FFF2DDB3
FFF2DD5C  a989                   loc_FFF2DD5C mov.l   20h+var_4[sp], r1
FFF2DD5E  5811                              movu.b  [r1], r1
FFF2DD60  3979fe                            bsr.w   sub_FFF2DBD9
FFF2DD63  6101                              cmp     #0, r1
FFF2DD65  a989                              mov.l   20h+var_4[sp], r1
FFF2DD67  2014                              beq.b   loc_FFF2DD7B
FFF2DD69  39c2fe                            bsr.w   sub_FFF2DC2B
FFF2DD6C  9109                              mov.w   r1, 20h+var_16[sp]
FFF2DD6E  a989                              mov.l   20h+var_4[sp], r1
FFF2DD70  6221                              add     #2, r1
FFF2DD72  a189                              mov.l   r1, 20h+var_4[sp]
FFF2DD74  a909                              mov.l   20h+var_C[sp], r1
FFF2DD76  f81401                            mov.b   #1, [r1]
FFF2DD79  2e0d                              bra.b   loc_FFF2DD86
FFF2DD7B  39b0fe                 loc_FFF2DD7B bsr.w   sub_FFF2DC2B
FFF2DD7E  9109                              mov.w   r1, 20h+var_16[sp]
FFF2DD80  a989                              mov.l   20h+var_4[sp], r1
FFF2DD82  6211                              add     #1, r1
FFF2DD84  a189                              mov.l   r1, 20h+var_4[sp]
FFF2DD86  b909                   loc_FFF2DD86 movu.w  20h+var_16[sp], r1
FFF2DD88  6881                              shlr    #8, r1
FFF2DD8A  a80a                              mov.l   20h+var_1C[sp], r2
FFF2DD8C  c321                              mov.b   r1, [r2]
FFF2DD8E  a809                              mov.l   20h+var_1C[sp], r1
FFF2DD90  6211                              add     #1, r1
FFF2DD92  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2DD94  b281                              movu.b  20h+var_16[sp], r1
FFF2DD96  a80a                              mov.l   20h+var_1C[sp], r2
FFF2DD98  c321                              mov.b   r1, [r2]
FFF2DD9A  a809                              mov.l   20h+var_1C[sp], r1
FFF2DD9C  6211                              add     #1, r1
FFF2DD9E  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2DDA0  b909                              movu.w  20h+var_16[sp], r1
FFF2DDA2  7701ffff00                        cmp     #0FFFFh, r1
FFF2DDA7  1e                                bne.s   loc_FFF2DDAD
FFF2DDA8  f8069d                            mov.l   #-63h, 20h+var_20[sp]
FFF2DDAB  2e23                              bra.b   loc_FFF2DDCE
FFF2DDAD  a889                   loc_FFF2DDAD mov.l   20h+var_14[sp], r1
FFF2DDAF  6211                              add     #1, r1
FFF2DDB1  a089                              mov.l   r1, 20h+var_14[sp]
FFF2DDB3  a989                   loc_FFF2DDB3 mov.l   20h+var_4[sp], r1
FFF2DDB5  cc1e                              mov.b   [r1], r14
FFF2DDB7  610e                              cmp     #0, r14
FFF2DDB9  21a3                              bne.b   loc_FFF2DD5C
FFF2DDBB  a809                              mov.l   20h+var_1C[sp], r1
FFF2DDBD  f81400                            mov.b   #0, [r1]
FFF2DDC0  a809                              mov.l   20h+var_1C[sp], r1
FFF2DDC2  6211                              add     #1, r1
FFF2DDC4  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2DDC6  a809                              mov.l   20h+var_1C[sp], r1
FFF2DDC8  f81400                            mov.b   #0, [r1]
FFF2DDCB  e10003                            mov.l   20h+var_14[sp], 20h+var_20[sp]
FFF2DDCE  ec01                   loc_FFF2DDCE mov.l   20h+var_20[sp], r1
FFF2DDD0  a101                              mov.l   r1, 20h+var_10[sp]
FFF2DDD2  6708                              rtsd    #8
FFF2DDD4  7100e0                 sub_FFF2DDD4 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2DDD4
FFF2DDD7  a189                              mov.l   r1, 20h+var_4[sp]
FFF2DDD9  a182                              mov.l   r2, 20h+var_8[sp]
FFF2DDDB  a102                              mov.l   r2, 20h+var_10[sp]
FFF2DDDD  e5000703                          mov.l   20h+var_4[sp], 20h+var_14[sp]
FFF2DDE1  a901                              mov.l   20h+var_10[sp], r1
FFF2DDE3  5811                              movu.b  [r1], r1
FFF2DDE5  9109                              mov.w   r1, 20h+var_16[sp]
FFF2DDE7  a901                              mov.l   20h+var_10[sp], r1
FFF2DDE9  b019                              movu.b  1[r1], r1
FFF2DDEB  6c81                              shll    #8, r1
FFF2DDED  06c90105                          add     20h+var_16[sp].uw, r1
FFF2DDF1  9109                              mov.w   r1, 20h+var_16[sp]
FFF2DDF3  b909                              movu.w  20h+var_16[sp], r1
FFF2DDF5  6101                              cmp     #0, r1
FFF2DDF7  210d                              bne.b   loc_FFF2DE04
FFF2DDF9  a889                              mov.l   20h+var_14[sp], r1
FFF2DDFB  f81400                            mov.b   #0, [r1]
FFF2DDFE  3e0101                            mov.l   #1, 20h+var_1C[sp]
FFF2DE01  381a01                            bra.w   loc_FFF2DF1B
FFF2DE04  b909                   loc_FFF2DE04 movu.w  20h+var_16[sp], r1
FFF2DE06  7551a5                            cmp     #-5Bh, r1
FFF2DE09  210d                              bne.b   loc_FFF2DE16
FFF2DE0B  a889                              mov.l   20h+var_14[sp], r1
FFF2DE0D  f8145c                            mov.b   #5Ch, [r1] ; '\'
FFF2DE10  3e0101                            mov.l   #1, 20h+var_1C[sp]
FFF2DE13  380801                            bra.w   loc_FFF2DF1B
FFF2DE16  b909                   loc_FFF2DE16 movu.w  20h+var_16[sp], r1
FFF2DE18  76013e20                          cmp     #203Eh, r1
FFF2DE1C  210d                              bne.b   loc_FFF2DE29
FFF2DE1E  a889                              mov.l   20h+var_14[sp], r1
FFF2DE20  f8147e                            mov.b   #7Eh, [r1] ; '~'
FFF2DE23  3e0101                            mov.l   #1, 20h+var_1C[sp]
FFF2DE26  38f500                            bra.w   loc_FFF2DF1B
FFF2DE29  a901                   loc_FFF2DE29 mov.l   20h+var_10[sp], r1
FFF2DE2B  b019                              movu.b  1[r1], r1
FFF2DE2D  7551ff                            cmp     #-1, r1
FFF2DE30  210f                              bne.b   loc_FFF2DE3F
FFF2DE32  a901                              mov.l   20h+var_10[sp], r1
FFF2DE34  581e                              movu.b  [r1], r14
FFF2DE36  755e61                            cmp     #61h, r14 ; 'a'
FFF2DE39  2906                              blt.b   loc_FFF2DE3F
FFF2DE3B  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2DE3E  0c                                bra.s   loc_FFF2DE42
FFF2DE3F  f80600                 loc_FFF2DE3F mov.l   #0, 20h+var_20[sp]
FFF2DE42  ec01                   loc_FFF2DE42 mov.l   20h+var_20[sp], r1
FFF2DE44  6101                              cmp     #0, r1
FFF2DE46  200f                              beq.b   loc_FFF2DE55
FFF2DE48  a901                              mov.l   20h+var_10[sp], r1
FFF2DE4A  581e                              movu.b  [r1], r14
FFF2DE4C  755e9f                            cmp     #-61h, r14
FFF2DE4F  2a06                              bgt.b   loc_FFF2DE55
FFF2DE51  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2DE54  0c                                bra.s   loc_FFF2DE58
FFF2DE55  f80600                 loc_FFF2DE55 mov.l   #0, 20h+var_20[sp]
FFF2DE58  ec01                   loc_FFF2DE58 mov.l   20h+var_20[sp], r1
FFF2DE5A  6101                              cmp     #0, r1
FFF2DE5C  2013                              beq.b   loc_FFF2DE6F
FFF2DE5E  a901                              mov.l   20h+var_10[sp], r1
FFF2DE60  581e                              movu.b  [r1], r14
FFF2DE62  71ee40                            add     #40h, r14, r14 ; '@'
FFF2DE65  a889                              mov.l   20h+var_14[sp], r1
FFF2DE67  c31e                              mov.b   r14, [r1]
FFF2DE69  3e0101                            mov.l   #1, 20h+var_1C[sp]
FFF2DE6C  38af00                            bra.w   loc_FFF2DF1B
FFF2DE6F  b909                   loc_FFF2DE6F movu.w  20h+var_16[sp], r1
FFF2DE71  755120                            cmp     #20h, r1 ; ' '
FFF2DE74  290d                              blt.b   loc_FFF2DE81
FFF2DE76  b909                              movu.w  20h+var_16[sp], r1
FFF2DE78  75517e                            cmp     #7Eh, r1 ; '~'
FFF2DE7B  2a06                              bgt.b   loc_FFF2DE81
FFF2DE7D  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2DE80  0c                                bra.s   loc_FFF2DE84
FFF2DE81  f80600                 loc_FFF2DE81 mov.l   #0, 20h+var_20[sp]
FFF2DE84  ec01                   loc_FFF2DE84 mov.l   20h+var_20[sp], r1
FFF2DE86  6101                              cmp     #0, r1
FFF2DE88  200e                              beq.b   loc_FFF2DE96
FFF2DE8A  a901                              mov.l   20h+var_10[sp], r1
FFF2DE8C  a88a                              mov.l   20h+var_14[sp], r2
FFF2DE8E  c012                              mov.b   [r1], [r2]
FFF2DE90  3e0101                            mov.l   #1, 20h+var_1C[sp]
FFF2DE93  388800                            bra.w   loc_FFF2DF1B
FFF2DE96  3d0400                 loc_FFF2DE96 mov.w   #0, 20h+var_18[sp]
FFF2DE99  2e36                              bra.b   loc_FFF2DECF
FFF2DE9B  fbe2f06aecff           loc_FFF2DE9B mov.l   #unk_FFEC6AF0, r14
FFF2DEA1  b901                              movu.w  20h+var_18[sp], r1
FFF2DEA3  fed1ee                            movu.w  [r1, r14], r14
FFF2DEA6  b909                              movu.w  20h+var_16[sp], r1
FFF2DEA8  47e1                              cmp     r14, r1
FFF2DEAA  211f                              bne.b   loc_FFF2DEC9
FFF2DEAC  b901                              movu.w  20h+var_18[sp], r1
FFF2DEAE  7311408100                        add     #8140h, r1, r1
FFF2DEB3  6881                              shlr    #8, r1
FFF2DEB5  a88a                              mov.l   20h+var_14[sp], r2
FFF2DEB7  c321                              mov.b   r1, [r2]
FFF2DEB9  b901                              movu.w  20h+var_18[sp], r1
FFF2DEBB  7311408100                        add     #8140h, r1, r1
FFF2DEC0  a88a                              mov.l   20h+var_14[sp], r2
FFF2DEC2  8029                              mov.b   r1, 1[r2]
FFF2DEC4  3e0102                            mov.l   #2, 20h+var_1C[sp]
FFF2DEC7  2e54                              bra.b   loc_FFF2DF1B
FFF2DEC9  9901                   loc_FFF2DEC9 mov.w   20h+var_18[sp], r1
FFF2DECB  6211                              add     #1, r1
FFF2DECD  9101                              mov.w   r1, 20h+var_18[sp]
FFF2DECF  b901                   loc_FFF2DECF movu.w  20h+var_18[sp], r1
FFF2DED1  7601bd1e                          cmp     #1EBDh, r1
FFF2DED5  29c6                              blt.b   loc_FFF2DE9B
FFF2DED7  3d0400                            mov.w   #0, 20h+var_18[sp]
FFF2DEDA  2e36                              bra.b   loc_FFF2DF10
FFF2DEDC  fbe26aa8ecff           loc_FFF2DEDC mov.l   #unk_FFECA86A, r14
FFF2DEE2  b901                              movu.w  20h+var_18[sp], r1
FFF2DEE4  fed1ee                            movu.w  [r1, r14], r14
FFF2DEE7  b909                              movu.w  20h+var_16[sp], r1
FFF2DEE9  47e1                              cmp     r14, r1
FFF2DEEB  211f                              bne.b   loc_FFF2DF0A
FFF2DEED  b901                              movu.w  20h+var_18[sp], r1
FFF2DEEF  731140e000                        add     #0E040h, r1, r1
FFF2DEF4  6881                              shlr    #8, r1
FFF2DEF6  a88a                              mov.l   20h+var_14[sp], r2
FFF2DEF8  c321                              mov.b   r1, [r2]
FFF2DEFA  b901                              movu.w  20h+var_18[sp], r1
FFF2DEFC  731140e000                        add     #0E040h, r1, r1
FFF2DF01  a88a                              mov.l   20h+var_14[sp], r2
FFF2DF03  8029                              mov.b   r1, 1[r2]
FFF2DF05  3e0102                            mov.l   #2, 20h+var_1C[sp]
FFF2DF08  2e13                              bra.b   loc_FFF2DF1B
FFF2DF0A  9901                   loc_FFF2DF0A mov.w   20h+var_18[sp], r1
FFF2DF0C  6211                              add     #1, r1
FFF2DF0E  9101                              mov.w   r1, 20h+var_18[sp]
FFF2DF10  b901                   loc_FFF2DF10 movu.w  20h+var_18[sp], r1
FFF2DF12  7601bd1c                          cmp     #1CBDh, r1
FFF2DF16  29c6                              blt.b   loc_FFF2DEDC
FFF2DF18  3e0100                            mov.l   #0, 20h+var_1C[sp]
FFF2DF1B  a809                   loc_FFF2DF1B mov.l   20h+var_1C[sp], r1
FFF2DF1D  a109                              mov.l   r1, 20h+var_C[sp]
FFF2DF1F  6708                              rtsd    #8
FFF2DF21  7100ec                 sub_FFF2DF21 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2DF21
FFF2DF24  a101                              mov.l   r1, 14h+var_4[sp]
FFF2DF26  a089                              mov.l   r1, 14h+var_8[sp]
FFF2DF28  38d603                            bra.w   loc_FFF2E2FE
FFF2DF2B  a889                   loc_FFF2DF2B mov.l   14h+var_8[sp], r1
FFF2DF2D  5811                              movu.b  [r1], r1
FFF2DF2F  39aafc                            bsr.w   sub_FFF2DBD9
FFF2DF32  6101                              cmp     #0, r1
FFF2DF34  3ac403                            beq.w   loc_FFF2E2F8
FFF2DF37  a889                              mov.l   14h+var_8[sp], r1
FFF2DF39  5811                              movu.b  [r1], r1
FFF2DF3B  6c81                              shll    #8, r1
FFF2DF3D  9089                              mov.w   r1, 14h+var_E[sp]
FFF2DF3F  a889                              mov.l   14h+var_8[sp], r1
FFF2DF41  b019                              movu.b  1[r1], r1
FFF2DF43  06c90103                          add     14h+var_E[sp].uw, r1
FFF2DF47  9089                              mov.w   r1, 14h+var_E[sp]
FFF2DF49  b889                              movu.w  14h+var_E[sp], r1
FFF2DF4B  7701908700                        cmp     #8790h, r1
FFF2DF50  290f                              blt.b   loc_FFF2DF5F
FFF2DF52  b889                              movu.w  14h+var_E[sp], r1
FFF2DF54  77019c8700                        cmp     #879Ch, r1
FFF2DF59  2a06                              bgt.b   loc_FFF2DF5F
FFF2DF5B  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DF5E  0c                                bra.s   loc_FFF2DF62
FFF2DF5F  f80600                 loc_FFF2DF5F mov.l   #0, 14h+var_14[sp]
FFF2DF62  ec01                   loc_FFF2DF62 mov.l   14h+var_14[sp], r1
FFF2DF64  6101                              cmp     #0, r1
FFF2DF66  205e                              beq.b   loc_FFF2DFC4
FFF2DF68  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF2DF6B  2e44                              bra.b   loc_FFF2DFAF
FFF2DF6D  a881                   loc_FFF2DF6D mov.l   14h+var_C[sp], r1
FFF2DF6F  6c21                              shll    #2, r1
FFF2DF71  fbe29c6aecff                      mov.l   #unk_FFEC6A9C, r14
FFF2DF77  4b1e                              add     r1, r14
FFF2DF79  b889                              movu.w  14h+var_E[sp], r1
FFF2DF7B  06c4e1                            cmp     [r14].uw, r1
FFF2DF7E  212b                              bne.b   loc_FFF2DFA9
FFF2DF80  a881                              mov.l   14h+var_C[sp], r1
FFF2DF82  6c21                              shll    #2, r1
FFF2DF84  fb229c6aecff                      mov.l   #unk_FFEC6A9C, r2
FFF2DF8A  4b12                              add     r1, r2
FFF2DF8C  b829                              movu.w  2[r2], r1
FFF2DF8E  6881                              shlr    #8, r1
FFF2DF90  a88a                              mov.l   14h+var_8[sp], r2
FFF2DF92  c321                              mov.b   r1, [r2]
FFF2DF94  a881                              mov.l   14h+var_C[sp], r1
FFF2DF96  6c21                              shll    #2, r1
FFF2DF98  fbe29c6aecff                      mov.l   #unk_FFEC6A9C, r14
FFF2DF9E  4b1e                              add     r1, r14
FFF2DFA0  a889                              mov.l   14h+var_8[sp], r1
FFF2DFA2  c5e10201                          mov.b   2[r14], 1[r1]
FFF2DFA6  384c03                            bra.w   loc_FFF2E2F2
FFF2DFA9  a881                   loc_FFF2DFA9 mov.l   14h+var_C[sp], r1
FFF2DFAB  6211                              add     #1, r1
FFF2DFAD  a081                              mov.l   r1, 14h+var_C[sp]
FFF2DFAF  a881                   loc_FFF2DFAF mov.l   14h+var_C[sp], r1
FFF2DFB1  6c21                              shll    #2, r1
FFF2DFB3  fbe29c6aecff                      mov.l   #unk_FFEC6A9C, r14
FFF2DFB9  4b1e                              add     r1, r14
FFF2DFBB  5cee                              movu.w  [r14], r14
FFF2DFBD  610e                              cmp     #0, r14
FFF2DFBF  21ae                              bne.b   loc_FFF2DF6D
FFF2DFC1  383103                            bra.w   loc_FFF2E2F2
FFF2DFC4  b889                   loc_FFF2DFC4 movu.w  14h+var_E[sp], r1
FFF2DFC6  770140ed00                        cmp     #0ED40h, r1
FFF2DFCB  290f                              blt.b   loc_FFF2DFDA
FFF2DFCD  b889                              movu.w  14h+var_E[sp], r1
FFF2DFCF  7701fced00                        cmp     #0EDFCh, r1
FFF2DFD4  2a06                              bgt.b   loc_FFF2DFDA
FFF2DFD6  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DFD9  0c                                bra.s   loc_FFF2DFDD
FFF2DFDA  f80600                 loc_FFF2DFDA mov.l   #0, 14h+var_14[sp]
FFF2DFDD  ec01                   loc_FFF2DFDD mov.l   14h+var_14[sp], r1
FFF2DFDF  6101                              cmp     #0, r1
FFF2DFE1  b889                              movu.w  14h+var_E[sp], r1
FFF2DFE3  3ab100                            beq.w   loc_FFF2E094
FFF2DFE6  770140ed00                        cmp     #0ED40h, r1
FFF2DFEB  290f                              blt.b   loc_FFF2DFFA
FFF2DFED  b889                              movu.w  14h+var_E[sp], r1
FFF2DFEF  770162ed00                        cmp     #0ED62h, r1
FFF2DFF4  2a06                              bgt.b   loc_FFF2DFFA
FFF2DFF6  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2DFF9  0c                                bra.s   loc_FFF2DFFD
FFF2DFFA  f80600                 loc_FFF2DFFA mov.l   #0, 14h+var_14[sp]
FFF2DFFD  ec01                   loc_FFF2DFFD mov.l   14h+var_14[sp], r1
FFF2DFFF  6101                              cmp     #0, r1
FFF2E001  2120                              bne.b   loc_FFF2E021
FFF2E003  b889                              movu.w  14h+var_E[sp], r1
FFF2E005  770180ed00                        cmp     #0ED80h, r1
FFF2E00A  290f                              blt.b   loc_FFF2E019
FFF2E00C  b889                              movu.w  14h+var_E[sp], r1
FFF2E00E  7701e0ed00                        cmp     #0EDE0h, r1
FFF2E013  2a06                              bgt.b   loc_FFF2E019
FFF2E015  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E018  0c                                bra.s   loc_FFF2E01C
FFF2E019  f80600                 loc_FFF2E019 mov.l   #0, 14h+var_14[sp]
FFF2E01C  ec01                   loc_FFF2E01C mov.l   14h+var_14[sp], r1
FFF2E01E  6101                              cmp     #0, r1
FFF2E020  15                                beq.s   loc_FFF2E025
FFF2E021  f80601                 loc_FFF2E021 mov.l   #1, 14h+var_14[sp]
FFF2E024  0c                                bra.s   loc_FFF2E028
FFF2E025  f80600                 loc_FFF2E025 mov.l   #0, 14h+var_14[sp]
FFF2E028  ec01                   loc_FFF2E028 mov.l   14h+var_14[sp], r1
FFF2E02A  6101                              cmp     #0, r1
FFF2E02C  b889                              movu.w  14h+var_E[sp], r1
FFF2E02E  2019                              beq.b   loc_FFF2E047
FFF2E030  72111c0d                          add     #0D1Ch, r1, r1
FFF2E034  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E036  b889                              movu.w  14h+var_E[sp], r1
FFF2E038  6881                              shlr    #8, r1
FFF2E03A  a88a                              mov.l   14h+var_8[sp], r2
FFF2E03C  c321                              mov.b   r1, [r2]
FFF2E03E  b181                              movu.b  14h+var_E[sp], r1
FFF2E040  a88a                              mov.l   14h+var_8[sp], r2
FFF2E042  8029                              mov.b   r1, 1[r2]
FFF2E044  38ae02                            bra.w   loc_FFF2E2F2
FFF2E047  7701e1ed00             loc_FFF2E047 cmp     #0EDE1h, r1
FFF2E04C  290f                              blt.b   loc_FFF2E05B
FFF2E04E  b889                              movu.w  14h+var_E[sp], r1
FFF2E050  770162ee00                        cmp     #0EE62h, r1
FFF2E055  2a06                              bgt.b   loc_FFF2E05B
FFF2E057  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E05A  0c                                bra.s   loc_FFF2E05E
FFF2E05B  f80600                 loc_FFF2E05B mov.l   #0, 14h+var_14[sp]
FFF2E05E  ec01                   loc_FFF2E05E mov.l   14h+var_14[sp], r1
FFF2E060  6101                              cmp     #0, r1
FFF2E062  b889                              movu.w  14h+var_E[sp], r1
FFF2E064  2019                              beq.b   loc_FFF2E07D
FFF2E066  72115f0d                          add     #0D5Fh, r1, r1
FFF2E06A  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E06C  b889                              movu.w  14h+var_E[sp], r1
FFF2E06E  6881                              shlr    #8, r1
FFF2E070  a88a                              mov.l   14h+var_8[sp], r2
FFF2E072  c321                              mov.b   r1, [r2]
FFF2E074  b181                              movu.b  14h+var_E[sp], r1
FFF2E076  a88a                              mov.l   14h+var_8[sp], r2
FFF2E078  8029                              mov.b   r1, 1[r2]
FFF2E07A  387802                            bra.w   loc_FFF2E2F2
FFF2E07D  72111d0d               loc_FFF2E07D add     #0D1Dh, r1, r1
FFF2E081  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E083  b889                              movu.w  14h+var_E[sp], r1
FFF2E085  6881                              shlr    #8, r1
FFF2E087  a88a                              mov.l   14h+var_8[sp], r2
FFF2E089  c321                              mov.b   r1, [r2]
FFF2E08B  b181                              movu.b  14h+var_E[sp], r1
FFF2E08D  a88a                              mov.l   14h+var_8[sp], r2
FFF2E08F  8029                              mov.b   r1, 1[r2]
FFF2E091  386102                            bra.w   loc_FFF2E2F2
FFF2E094  770140ee00             loc_FFF2E094 cmp     #0EE40h, r1
FFF2E099  290f                              blt.b   loc_FFF2E0A8
FFF2E09B  b889                              movu.w  14h+var_E[sp], r1
FFF2E09D  7701fcee00                        cmp     #0EEFCh, r1
FFF2E0A2  2a06                              bgt.b   loc_FFF2E0A8
FFF2E0A4  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E0A7  0c                                bra.s   loc_FFF2E0AB
FFF2E0A8  f80600                 loc_FFF2E0A8 mov.l   #0, 14h+var_14[sp]
FFF2E0AB  ec01                   loc_FFF2E0AB mov.l   14h+var_14[sp], r1
FFF2E0AD  6101                              cmp     #0, r1
FFF2E0AF  b889                              movu.w  14h+var_E[sp], r1
FFF2E0B1  3a9401                            beq.w   loc_FFF2E245
FFF2E0B4  770140ee00                        cmp     #0EE40h, r1
FFF2E0B9  290f                              blt.b   loc_FFF2E0C8
FFF2E0BB  b889                              movu.w  14h+var_E[sp], r1
FFF2E0BD  770162ee00                        cmp     #0EE62h, r1
FFF2E0C2  2a06                              bgt.b   loc_FFF2E0C8
FFF2E0C4  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E0C7  0c                                bra.s   loc_FFF2E0CB
FFF2E0C8  f80600                 loc_FFF2E0C8 mov.l   #0, 14h+var_14[sp]
FFF2E0CB  ec01                   loc_FFF2E0CB mov.l   14h+var_14[sp], r1
FFF2E0CD  6101                              cmp     #0, r1
FFF2E0CF  2120                              bne.b   loc_FFF2E0EF
FFF2E0D1  b889                              movu.w  14h+var_E[sp], r1
FFF2E0D3  770180ee00                        cmp     #0EE80h, r1
FFF2E0D8  290f                              blt.b   loc_FFF2E0E7
FFF2E0DA  b889                              movu.w  14h+var_E[sp], r1
FFF2E0DC  7701e0ee00                        cmp     #0EEE0h, r1
FFF2E0E1  2a06                              bgt.b   loc_FFF2E0E7
FFF2E0E3  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E0E6  0c                                bra.s   loc_FFF2E0EA
FFF2E0E7  f80600                 loc_FFF2E0E7 mov.l   #0, 14h+var_14[sp]
FFF2E0EA  ec01                   loc_FFF2E0EA mov.l   14h+var_14[sp], r1
FFF2E0EC  6101                              cmp     #0, r1
FFF2E0EE  15                                beq.s   loc_FFF2E0F3
FFF2E0EF  f80601                 loc_FFF2E0EF mov.l   #1, 14h+var_14[sp]
FFF2E0F2  0c                                bra.s   loc_FFF2E0F6
FFF2E0F3  f80600                 loc_FFF2E0F3 mov.l   #0, 14h+var_14[sp]
FFF2E0F6  ec01                   loc_FFF2E0F6 mov.l   14h+var_14[sp], r1
FFF2E0F8  6101                              cmp     #0, r1
FFF2E0FA  b889                              movu.w  14h+var_E[sp], r1
FFF2E0FC  2019                              beq.b   loc_FFF2E115
FFF2E0FE  72111c0d                          add     #0D1Ch, r1, r1
FFF2E102  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E104  b889                              movu.w  14h+var_E[sp], r1
FFF2E106  6881                              shlr    #8, r1
FFF2E108  a88a                              mov.l   14h+var_8[sp], r2
FFF2E10A  c321                              mov.b   r1, [r2]
FFF2E10C  b181                              movu.b  14h+var_E[sp], r1
FFF2E10E  a88a                              mov.l   14h+var_8[sp], r2
FFF2E110  8029                              mov.b   r1, 1[r2]
FFF2E112  38e001                            bra.w   loc_FFF2E2F2
FFF2E115  770163ee00             loc_FFF2E115 cmp     #0EE63h, r1
FFF2E11A  290f                              blt.b   loc_FFF2E129
FFF2E11C  b889                              movu.w  14h+var_E[sp], r1
FFF2E11E  77017eee00                        cmp     #0EE7Eh, r1
FFF2E123  2a06                              bgt.b   loc_FFF2E129
FFF2E125  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E128  0c                                bra.s   loc_FFF2E12C
FFF2E129  f80600                 loc_FFF2E129 mov.l   #0, 14h+var_14[sp]
FFF2E12C  ec01                   loc_FFF2E12C mov.l   14h+var_14[sp], r1
FFF2E12E  6101                              cmp     #0, r1
FFF2E130  b889                              movu.w  14h+var_E[sp], r1
FFF2E132  2019                              beq.b   loc_FFF2E14B
FFF2E134  72111d0d                          add     #0D1Dh, r1, r1
FFF2E138  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E13A  b889                              movu.w  14h+var_E[sp], r1
FFF2E13C  6881                              shlr    #8, r1
FFF2E13E  a88a                              mov.l   14h+var_8[sp], r2
FFF2E140  c321                              mov.b   r1, [r2]
FFF2E142  b181                              movu.b  14h+var_E[sp], r1
FFF2E144  a88a                              mov.l   14h+var_8[sp], r2
FFF2E146  8029                              mov.b   r1, 1[r2]
FFF2E148  38aa01                            bra.w   loc_FFF2E2F2
FFF2E14B  7701e1ee00             loc_FFF2E14B cmp     #0EEE1h, r1
FFF2E150  290f                              blt.b   loc_FFF2E15F
FFF2E152  b889                              movu.w  14h+var_E[sp], r1
FFF2E154  7701ecee00                        cmp     #0EEECh, r1
FFF2E159  2a06                              bgt.b   loc_FFF2E15F
FFF2E15B  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E15E  0c                                bra.s   loc_FFF2E162
FFF2E15F  f80600                 loc_FFF2E15F mov.l   #0, 14h+var_14[sp]
FFF2E162  ec01                   loc_FFF2E162 mov.l   14h+var_14[sp], r1
FFF2E164  6101                              cmp     #0, r1
FFF2E166  b889                              movu.w  14h+var_E[sp], r1
FFF2E168  2019                              beq.b   loc_FFF2E181
FFF2E16A  72115f0d                          add     #0D5Fh, r1, r1
FFF2E16E  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E170  b889                              movu.w  14h+var_E[sp], r1
FFF2E172  6881                              shlr    #8, r1
FFF2E174  a88a                              mov.l   14h+var_8[sp], r2
FFF2E176  c321                              mov.b   r1, [r2]
FFF2E178  b181                              movu.b  14h+var_E[sp], r1
FFF2E17A  a88a                              mov.l   14h+var_8[sp], r2
FFF2E17C  8029                              mov.b   r1, 1[r2]
FFF2E17E  387401                            bra.w   loc_FFF2E2F2
FFF2E181  7701efee00             loc_FFF2E181 cmp     #0EEEFh, r1
FFF2E186  290f                              blt.b   loc_FFF2E195
FFF2E188  b889                              movu.w  14h+var_E[sp], r1
FFF2E18A  7701f8ee00                        cmp     #0EEF8h, r1
FFF2E18F  2a06                              bgt.b   loc_FFF2E195
FFF2E191  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E194  0c                                bra.s   loc_FFF2E198
FFF2E195  f80600                 loc_FFF2E195 mov.l   #0, 14h+var_14[sp]
FFF2E198  ec01                   loc_FFF2E198 mov.l   14h+var_14[sp], r1
FFF2E19A  6101                              cmp     #0, r1
FFF2E19C  b889                              movu.w  14h+var_E[sp], r1
FFF2E19E  2019                              beq.b   loc_FFF2E1B7
FFF2E1A0  7211510b                          add     #0B51h, r1, r1
FFF2E1A4  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E1A6  b889                              movu.w  14h+var_E[sp], r1
FFF2E1A8  6881                              shlr    #8, r1
FFF2E1AA  a88a                              mov.l   14h+var_8[sp], r2
FFF2E1AC  c321                              mov.b   r1, [r2]
FFF2E1AE  b181                              movu.b  14h+var_E[sp], r1
FFF2E1B0  a88a                              mov.l   14h+var_8[sp], r2
FFF2E1B2  8029                              mov.b   r1, 1[r2]
FFF2E1B4  383e01                            bra.w   loc_FFF2E2F2
FFF2E1B7  77017fee00             loc_FFF2E1B7 cmp     #0EE7Fh, r1
FFF2E1BC  200e                              beq.b   loc_FFF2E1CA
FFF2E1BE  b889                              movu.w  14h+var_E[sp], r1
FFF2E1C0  7701edee00                        cmp     #0EEEDh, r1
FFF2E1C5  15                                beq.s   loc_FFF2E1CA
FFF2E1C6  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E1C9  0c                                bra.s   loc_FFF2E1CD
FFF2E1CA  f80600                 loc_FFF2E1CA mov.l   #0, 14h+var_14[sp]
FFF2E1CD  ec01                   loc_FFF2E1CD mov.l   14h+var_14[sp], r1
FFF2E1CF  6101                              cmp     #0, r1
FFF2E1D1  200e                              beq.b   loc_FFF2E1DF
FFF2E1D3  b889                              movu.w  14h+var_E[sp], r1
FFF2E1D5  7701eeee00                        cmp     #0EEEEh, r1
FFF2E1DA  15                                beq.s   loc_FFF2E1DF
FFF2E1DB  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E1DE  0c                                bra.s   loc_FFF2E1E2
FFF2E1DF  f80600                 loc_FFF2E1DF mov.l   #0, 14h+var_14[sp]
FFF2E1E2  ec01                   loc_FFF2E1E2 mov.l   14h+var_14[sp], r1
FFF2E1E4  6101                              cmp     #0, r1
FFF2E1E6  3a0c01                            beq.w   loc_FFF2E2F2
FFF2E1E9  3e0200                            mov.l   #0, 14h+var_C[sp]
FFF2E1EC  2e44                              bra.b   loc_FFF2E230
FFF2E1EE  a881                   loc_FFF2E1EE mov.l   14h+var_C[sp], r1
FFF2E1F0  6c21                              shll    #2, r1
FFF2E1F2  fbe2c46aecff                      mov.l   #unk_FFEC6AC4, r14
FFF2E1F8  4b1e                              add     r1, r14
FFF2E1FA  b889                              movu.w  14h+var_E[sp], r1
FFF2E1FC  06c4e1                            cmp     [r14].uw, r1
FFF2E1FF  212b                              bne.b   loc_FFF2E22A
