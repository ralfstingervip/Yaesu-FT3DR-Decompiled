; ==== fat_e  FFF2C380-FFF2D780  (file 32C380-32D780) ====
FFF2C380  01                                .byte    1
FFF2C381  04a081a9                          bra.a   0FF9C4521h
FFF2C385  09                                bra.s   loc_FFF2C38E
FFF2C386  ad99                              mov.l   5Ch[r1], r1
FFF2C388  6851                              shlr    #5, r1
FFF2C38A  068d0102                          mul     38h+var_30[sp].l, r1
FFF2C38E  ab0a                   loc_FFF2C38E mov.l   38h+var_4[sp], r2
FFF2C390  06c92108                          add     10h[r2].uw, r1
FFF2C394  d72120                            mov.w   r1, 40h[r2]
FFF2C397  ab09                              mov.l   38h+var_4[sp], r1
FFF2C399  3e1f00                            mov.l   #0, 3Ch[r1]
FFF2C39C  2e43                              bra.b   loc_FFF2C3DF
FFF2C39E  ab09                   loc_FFF2C39E mov.l   38h+var_4[sp], r1
FFF2C3A0  a91a                              mov.l   14h[r1], r2
FFF2C3A2  ec11                              mov.l   [r1], r1
FFF2C3A4  05412cff                          bsr.a   sub_FFF1EFE5
FFF2C3A8  a089                              mov.l   r1, 38h+var_2C[sp]
FFF2C3AA  ab09                              mov.l   38h+var_4[sp], r1
FFF2C3AC  ec11                              mov.l   [r1], r1
FFF2C3AE  a88a                              mov.l   38h+var_2C[sp], r2
FFF2C3B0  05fc2bff                          bsr.a   sub_FFF1EFAC
FFF2C3B4  a101                              mov.l   r1, 38h+var_28[sp]
FFF2C3B6  ab09                              mov.l   38h+var_4[sp], r1
FFF2C3B8  a919                              mov.l   14h[r1], r1
FFF2C3BA  06810104                          sub     38h+var_28[sp].l, r1
FFF2C3BE  a081                              mov.l   r1, 38h+var_30[sp]
FFF2C3C0  a909                              mov.l   38h+var_24[sp], r1
FFF2C3C2  ad99                              mov.l   5Ch[r1], r1
FFF2C3C4  6851                              shlr    #5, r1
FFF2C3C6  068d0102                          mul     38h+var_30[sp].l, r1
FFF2C3CA  ab0a                              mov.l   38h+var_4[sp], r2
FFF2C3CC  06c92108                          add     10h[r2].uw, r1
FFF2C3D0  d72120                            mov.w   r1, 40h[r2]
FFF2C3D3  ab0e                              mov.l   38h+var_4[sp], r6
FFF2C3D5  a96a                              mov.l   14h[r6], r2
FFF2C3D7  ec61                              mov.l   [r6], r1
FFF2C3D9  050c2cff                          bsr.a   sub_FFF1EFE5
FFF2C3DD  a3e9                              mov.l   r1, 3Ch[r6]
FFF2C3DF  e5000807               loc_FFF2C3DF mov.l   38h+var_18[sp], 38h+var_1C[sp]
FFF2C3E3  8e89                              mov.b   38h+var_1D[sp], r1
FFF2C3E5  75111a                            mul     #1Ah, r1
FFF2C3E8  0689010c                          add     38h+var_8[sp].l, r1
FFF2C3EC  a98a                              mov.l   38h+var_1C[sp], r2
FFF2C3EE  6212                              add     #1, r2
FFF2C3F0  72111814                          add     #1418h, r1, r1
FFF2C3F4  66a3                              mov.l   #0Ah, r3
FFF2C3F6  05822000                          bsr.a   sub_FFF2E478
FFF2C3FA  8e89                              mov.b   38h+var_1D[sp], r1
FFF2C3FC  75111a                            mul     #1Ah, r1
FFF2C3FF  0689010c                          add     38h+var_8[sp].l, r1
FFF2C403  a98a                              mov.l   38h+var_1C[sp], r2
FFF2C405  62e2                              add     #0Eh, r2
FFF2C407  72112214                          add     #1422h, r1, r1
FFF2C40B  66c3                              mov.l   #0Ch, r3
FFF2C40D  056b2000                          bsr.a   sub_FFF2E478
FFF2C411  8e89                              mov.b   38h+var_1D[sp], r1
FFF2C413  75111a                            mul     #1Ah, r1
FFF2C416  0689010c                          add     38h+var_8[sp].l, r1
FFF2C41A  a98a                              mov.l   38h+var_1C[sp], r2
FFF2C41C  71221c                            add     #1Ch, r2, r2
FFF2C41F  72112e14                          add     #142Eh, r1, r1
FFF2C423  6643                              mov.l   #4, r3
FFF2C425  05532000                          bsr.a   sub_FFF2E478
FFF2C429  b689                              movu.b  38h+var_1D[sp], r1
FFF2C42B  6211                              add     #1, r1
FFF2C42D  8689                              mov.b   r1, 38h+var_1D[sp]
FFF2C42F  ab02                   loc_FFF2C42F mov.l   38h+var_8[sp], r2
FFF2C431  ab09                              mov.l   38h+var_4[sp], r1
FFF2C433  394901                            bsr.w   sub_FFF2C57C
FFF2C436  a201                              mov.l   r1, 38h+var_18[sp]
FFF2C438  aa01                              mov.l   38h+var_18[sp], r1
FFF2C43A  6101                              cmp     #0, r1
FFF2C43C  3b90fe                            bne.w   loc_FFF2C2CC
FFF2C43F  aa01                   loc_FFF2C43F mov.l   38h+var_18[sp], r1
FFF2C441  6101                              cmp     #0, r1
FFF2C443  1f                                bne.s   loc_FFF2C44A
FFF2C444  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF2C447  382e01                            bra.w   loc_FFF2C575
FFF2C44A  aa01                   loc_FFF2C44A mov.l   38h+var_18[sp], r1
FFF2C44C  ab0a                              mov.l   38h+var_4[sp], r2
FFF2C44E  a3a1                              mov.l   r1, 38h[r2]
FFF2C450  8e89                              mov.b   38h+var_1D[sp], r1
FFF2C452  6101                              cmp     #0, r1
FFF2C454  15                                beq.s   loc_FFF2C459
FFF2C455  f80600                            mov.l   #0, 38h+var_38[sp]
FFF2C458  0c                                bra.s   loc_FFF2C45C
FFF2C459  f80601                 loc_FFF2C459 mov.l   #1, 38h+var_38[sp]
FFF2C45C  ec01                   loc_FFF2C45C mov.l   38h+var_38[sp], r1
FFF2C45E  6101                              cmp     #0, r1
FFF2C460  3a0301                            beq.w   loc_FFF2C563
FFF2C463  aa01                              mov.l   38h+var_18[sp], r1
FFF2C465  8b13                              mov.b   0Ch[r1], r3
FFF2C467  ab09                              mov.l   38h+var_4[sp], r1
FFF2C469  ab92                              mov.l   38h[r1], r2
FFF2C46B  711142                            add     #42h, r1, r1 ; 'B'
FFF2C46E  052f43ff                          bsr.a   sub_FFF2079D
FFF2C472  ab09                              mov.l   38h+var_4[sp], r1
FFF2C474  a891                              mov.l   8[r1], r1
FFF2C476  a90a                              mov.l   38h+var_24[sp], r2
FFF2C478  0685210d                          cmp     34h[r2].l, r1
FFF2C47C  210e                              bne.b   loc_FFF2C48A
FFF2C47E  a909                              mov.l   38h+var_24[sp], r1
FFF2C480  8c11                              mov.b   10h[r1], r1
FFF2C482  755120                            cmp     #20h, r1 ; ' '
FFF2C485  15                                beq.s   loc_FFF2C48A
FFF2C486  f80601                            mov.l   #1, 38h+var_38[sp]
FFF2C489  0c                                bra.s   loc_FFF2C48D
FFF2C48A  f80600                 loc_FFF2C48A mov.l   #0, 38h+var_38[sp]
FFF2C48D  ec01                   loc_FFF2C48D mov.l   38h+var_38[sp], r1
FFF2C48F  6101                              cmp     #0, r1
FFF2C491  2035                              beq.b   loc_FFF2C4C6
FFF2C493  a909                              mov.l   38h+var_24[sp], r1
FFF2C495  a89a                              mov.l   0Ch[r1], r2
FFF2C497  06cd1204                          mul     8[r1].uw, r2
FFF2C49B  06c91203                          add     6[r1].uw, r2
FFF2C49F  a102                              mov.l   r2, 38h+var_28[sp]
FFF2C4A1  ab09                              mov.l   38h+var_4[sp], r1
FFF2C4A3  a919                              mov.l   14h[r1], r1
FFF2C4A5  06810104                          sub     38h+var_28[sp].l, r1
FFF2C4A9  a081                              mov.l   r1, 38h+var_30[sp]
FFF2C4AB  a909                              mov.l   38h+var_24[sp], r1
FFF2C4AD  ad99                              mov.l   5Ch[r1], r1
FFF2C4AF  6851                              shlr    #5, r1
FFF2C4B1  068d0102                          mul     38h+var_30[sp].l, r1
FFF2C4B5  ab0a                              mov.l   38h+var_4[sp], r2
FFF2C4B7  06c92108                          add     10h[r2].uw, r1
FFF2C4BB  d72120                            mov.w   r1, 40h[r2]
FFF2C4BE  ab09                              mov.l   38h+var_4[sp], r1
FFF2C4C0  3e1f00                            mov.l   #0, 3Ch[r1]
FFF2C4C3  38a000                            bra.w   loc_FFF2C563
FFF2C4C6  ab09                   loc_FFF2C4C6 mov.l   38h+var_4[sp], r1
FFF2C4C8  a91a                              mov.l   14h[r1], r2
FFF2C4CA  ec11                              mov.l   [r1], r1
FFF2C4CC  05192bff                          bsr.a   sub_FFF1EFE5
FFF2C4D0  a089                              mov.l   r1, 38h+var_2C[sp]
FFF2C4D2  ab09                              mov.l   38h+var_4[sp], r1
FFF2C4D4  ec11                              mov.l   [r1], r1
FFF2C4D6  a88a                              mov.l   38h+var_2C[sp], r2
FFF2C4D8  05d42aff                          bsr.a   sub_FFF1EFAC
FFF2C4DC  a101                              mov.l   r1, 38h+var_28[sp]
FFF2C4DE  ab09                              mov.l   38h+var_4[sp], r1
FFF2C4E0  a919                              mov.l   14h[r1], r1
FFF2C4E2  06810104                          sub     38h+var_28[sp].l, r1
FFF2C4E6  a081                              mov.l   r1, 38h+var_30[sp]
FFF2C4E8  a909                              mov.l   38h+var_24[sp], r1
FFF2C4EA  ad99                              mov.l   5Ch[r1], r1
FFF2C4EC  6851                              shlr    #5, r1
FFF2C4EE  068d0102                          mul     38h+var_30[sp].l, r1
FFF2C4F2  ab0a                              mov.l   38h+var_4[sp], r2
FFF2C4F4  06c92108                          add     10h[r2].uw, r1
FFF2C4F8  d72120                            mov.w   r1, 40h[r2]
FFF2C4FB  ab0e                              mov.l   38h+var_4[sp], r6
FFF2C4FD  a96a                              mov.l   14h[r6], r2
FFF2C4FF  ec61                              mov.l   [r6], r1
FFF2C501  05e42aff                          bsr.a   sub_FFF1EFE5
FFF2C505  a3e9                              mov.l   r1, 3Ch[r6]
FFF2C507  2e5c                              bra.b   loc_FFF2C563
FFF2C509  f9042700               loc_FFF2C509 mov.b   #0, 38h+var_11[sp]
FFF2C50D  2e44                              bra.b   loc_FFF2C551
FFF2C50F  ab09                   loc_FFF2C50F mov.l   38h+var_4[sp], r1
FFF2C511  06c9010c                          add     38h+var_20[sp].uw, r1
FFF2C515  8e8a                              mov.b   38h+var_1D[sp], r2
FFF2C517  75121a                            mul     #1Ah, r2
FFF2C51A  0689020c                          add     38h+var_8[sp].l, r2
FFF2C51E  490227                            add     38h+var_11[sp], r2
FFF2C521  711142                            add     #42h, r1, r1 ; 'B'
FFF2C524  72221814                          add     #1418h, r2, r2
FFF2C528  05ac1800                          bsr.a   sub_FFF2DDD4
FFF2C52C  a281                              mov.l   r1, 38h+var_10[sp]
FFF2C52E  aa81                              mov.l   38h+var_10[sp], r1
FFF2C530  6101                              cmp     #0, r1
FFF2C532  2027                              beq.b   loc_FFF2C559
FFF2C534  ab09                              mov.l   38h+var_4[sp], r1
FFF2C536  06c9010c                          add     38h+var_20[sp].uw, r1
FFF2C53A  591e42                            movu.b  42h[r1], r14
FFF2C53D  610e                              cmp     #0, r14
FFF2C53F  201a                              beq.b   loc_FFF2C559
FFF2C541  bb01                              movu.w  38h+var_20[sp], r1
FFF2C543  06c90114                          add     38h+var_10[sp].uw, r1
FFF2C547  9301                              mov.w   r1, 38h+var_20[sp]
FFF2C549  590127                            movu.b  38h+var_11[sp], r1
FFF2C54C  6221                              add     #2, r1
FFF2C54E  c70127                            mov.b   r1, 38h+var_11[sp]
FFF2C551  590127                 loc_FFF2C551 movu.b  38h+var_11[sp], r1
FFF2C554  755119                            cmp     #19h, r1
FFF2C557  29b8                              blt.b   loc_FFF2C50F
FFF2C559  ab09                   loc_FFF2C559 mov.l   38h+var_4[sp], r1
FFF2C55B  06c9010c                          add     38h+var_20[sp].uw, r1
FFF2C55F  f9144200                          mov.b   #0, 42h[r1]
FFF2C563  8e89                   loc_FFF2C563 mov.b   38h+var_1D[sp], r1
FFF2C565  7112ff                            add     #-1, r1, r2
FFF2C568  868a                              mov.b   r2, 38h+var_1D[sp]
FFF2C56A  6101                              cmp     #0, r1
FFF2C56C  219d                              bne.b   loc_FFF2C509
FFF2C56E  ab09                              mov.l   38h+var_4[sp], r1
FFF2C570  711138                            add     #38h, r1, r1 ; '8'
FFF2C573  a009                   sub_FFF2C573 mov.l   r1, arg_0[sp]   ; <<<< FUNC sub_FFF2C573
FFF2C575  a809                   loc_FFF2C575 mov.l   38h+var_34[sp], r1
FFF2C577  a289                              mov.l   r1, 38h+var_C[sp]
FFF2C579  3f660f                            rtsd    #3Ch, r6-r6
FFF2C57C  7100dc                 sub_FFF2C57C add     #-24h, sp, sp   ; <<<< FUNC sub_FFF2C57C
FFF2C57F  a201                              mov.l   r1, 24h+var_4[sp]
FFF2C581  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2C583  aa01                              mov.l   24h+var_4[sp], r1
FFF2C585  e41003                            mov.l   [r1], 24h+var_18[sp]
FFF2C588  aa01                              mov.l   24h+var_4[sp], r1
FFF2C58A  e5100302                          mov.l   0Ch[r1], 24h+var_1C[sp]
FFF2C58E  aa01                              mov.l   24h+var_4[sp], r1
FFF2C590  8912                              mov.b   4[r1], r2
FFF2C592  7502fe                            cmp     #-2, r2
FFF2C595  2112                              bne.b   loc_FFF2C5A7
FFF2C597  3c14ff                            mov.b   #-1, 4[r1]
FFF2C59A  6601                              mov.l   #0, r1
FFF2C59C  ef12                              mov.l   r1, r2
FFF2C59E  05dd28ff                          bsr.a   sub_FFF1EE7B
FFF2C5A2  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C5A4  383701                            bra.w   loc_FFF2C6DB
FFF2C5A7  8911                   loc_FFF2C5A7 mov.b   4[r1], r1
FFF2C5A9  6111                              cmp     #1, r1
FFF2C5AB  2010                              beq.b   loc_FFF2C5BB
FFF2C5AD  6602                              mov.l   #0, r2
FFF2C5AF  fb16f3                            mov.l   #-0Dh, r1
FFF2C5B2  05c928ff                          bsr.a   sub_FFF1EE7B
FFF2C5B6  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C5B8  382301                            bra.w   loc_FFF2C6DB
FFF2C5BB  aa01                   loc_FFF2C5BB mov.l   24h+var_4[sp], r1
FFF2C5BD  ec11                              mov.l   [r1], r1
FFF2C5BF  059e29ff                          bsr.a   sub_FFF1EF5D
FFF2C5C3  a109                              mov.l   r1, 24h+var_10[sp]
FFF2C5C5  a909                              mov.l   24h+var_10[sp], r1
FFF2C5C7  6101                              cmp     #0, r1
FFF2C5C9  200f                              beq.b   loc_FFF2C5D8
FFF2C5CB  a909                              mov.l   24h+var_10[sp], r1
FFF2C5CD  6602                              mov.l   #0, r2
FFF2C5CF  05ac28ff                          bsr.a   sub_FFF1EE7B
FFF2C5D3  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C5D5  380601                            bra.w   loc_FFF2C6DB
FFF2C5D8  aa04                   loc_FFF2C5D8 mov.l   24h+var_4[sp], r4
FFF2C5DA  b8cb                              movu.w  6[r4], r3
FFF2C5DC  ec41                              mov.l   [r4], r1
FFF2C5DE  a98d                              mov.l   24h+var_8[sp], r5
FFF2C5E0  a882                              mov.l   24h+var_1C[sp], r2
FFF2C5E2  6040                              sub     #4, sp
FFF2C5E4  e305                              mov.l   r5, 28h+var_28[sp]
FFF2C5E6  714418                            add     #18h, r4, r4
FFF2C5E9  39f800                            bsr.w   sub_FFF2C6E1
FFF2C5EC  6240                              add     #4, sp
FFF2C5EE  a109                              mov.l   r1, 24h+var_10[sp]
FFF2C5F0  a909                              mov.l   24h+var_10[sp], r1
FFF2C5F2  6101                              cmp     #0, r1
FFF2C5F4  200f                              beq.b   loc_FFF2C603
FFF2C5F6  a909                              mov.l   24h+var_10[sp], r1
FFF2C5F8  6602                              mov.l   #0, r2
FFF2C5FA  058128ff                          bsr.a   sub_FFF1EE7B
FFF2C5FE  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C600  38db00                            bra.w   loc_FFF2C6DB
FFF2C603  aa01                   loc_FFF2C603 mov.l   24h+var_4[sp], r1
FFF2C605  711118                            add     #18h, r1, r1
FFF2C608  a101                              mov.l   r1, 24h+var_14[sp]
FFF2C60A  a901                              mov.l   24h+var_14[sp], r1
FFF2C60C  cc1e                              mov.b   [r1], r14
FFF2C60E  610e                              cmp     #0, r14
FFF2C610  aa01                              mov.l   24h+var_4[sp], r1
FFF2C612  2112                              bne.b   loc_FFF2C624
FFF2C614  3c14ff                            mov.b   #-1, 4[r1]
FFF2C617  6601                              mov.l   #0, r1
FFF2C619  ef12                              mov.l   r1, r2
FFF2C61B  056028ff                          bsr.a   sub_FFF1EE7B
FFF2C61F  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C621  38ba00                            bra.w   loc_FFF2C6DB
FFF2C624  aa02                   loc_FFF2C624 mov.l   24h+var_4[sp], r2
FFF2C626  d5210308                          mov.w   6[r2], 10h[r1]
FFF2C62A  aa01                              mov.l   24h+var_4[sp], r1
FFF2C62C  e5110305                          mov.l   0Ch[r1], 14h[r1]
FFF2C630  aa01                              mov.l   24h+var_4[sp], r1
FFF2C632  989a                              mov.w   6[r1], r2
FFF2C634  6212                              add     #1, r2
FFF2C636  909a                              mov.w   r2, 6[r1]
FFF2C638  b899                              movu.w  6[r1], r1
FFF2C63A  a88a                              mov.l   24h+var_18[sp], r2
FFF2C63C  adaa                              mov.l   5Ch[r2], r2
FFF2C63E  6852                              shlr    #5, r2
FFF2C640  ef1e                              mov.l   r1, r14
FFF2C642  fc272e                            divu    r2, r14
FFF2C645  4f2e                              mul     r2, r14
FFF2C647  43e1                              sub     r14, r1
FFF2C649  6101                              cmp     #0, r1
FFF2C64B  3b8600                            bne.w   loc_FFF2C6D1
FFF2C64E  aa01                              mov.l   24h+var_4[sp], r1
FFF2C650  3d1300                            mov.w   #0, 6[r1]
FFF2C653  a889                              mov.l   24h+var_18[sp], r1
FFF2C655  a89a                              mov.l   0Ch[r1], r2
FFF2C657  06cd1204                          mul     8[r1].uw, r2
FFF2C65B  06c91203                          add     6[r1].uw, r2
FFF2C65F  b91b                              movu.w  0Ah[r1], r3
FFF2C661  6c53                              shll    #5, r3
FFF2C663  06a1091317                        divu    5Ch[r1].l, r3
FFF2C668  4b32                              add     r3, r2
FFF2C66A  6012                              sub     #1, r2
FFF2C66C  06850202                          cmp     24h+var_1C[sp].l, r2
FFF2C670  250c                              bleu.b  loc_FFF2C67C
FFF2C672  aa01                              mov.l   24h+var_4[sp], r1
FFF2C674  a89a                              mov.l   0Ch[r1], r2
FFF2C676  6212                              add     #1, r2
FFF2C678  a09a                              mov.l   r2, 0Ch[r1]
FFF2C67A  2e57                              bra.b   loc_FFF2C6D1
FFF2C67C  a889                   loc_FFF2C67C mov.l   24h+var_18[sp], r1
FFF2C67E  a89a                              mov.l   0Ch[r1], r2
FFF2C680  06cd1204                          mul     8[r1].uw, r2
FFF2C684  06c91203                          add     6[r1].uw, r2
FFF2C688  b91b                              movu.w  0Ah[r1], r3
FFF2C68A  6c53                              shll    #5, r3
FFF2C68C  06a1091317                        divu    5Ch[r1].l, r3
FFF2C691  4b32                              add     r3, r2
FFF2C693  6012                              sub     #1, r2
FFF2C695  06850202                          cmp     24h+var_1C[sp].l, r2
FFF2C699  aa01                              mov.l   24h+var_4[sp], r1
FFF2C69B  1e                                bne.s   loc_FFF2C6A1
FFF2C69C  3c14fe                            mov.b   #-2, 4[r1]
FFF2C69F  2e32                              bra.b   loc_FFF2C6D1
FFF2C6A1  ec11                   loc_FFF2C6A1 mov.l   [r1], r1
FFF2C6A3  a98c                              mov.l   24h+var_8[sp], r4
FFF2C6A5  a882                              mov.l   24h+var_1C[sp], r2
FFF2C6A7  710304                            add     #24h+var_20, sp, r3
FFF2C6AA  05e881ff                          bsr.a   sub_FFF24892
FFF2C6AE  a109                              mov.l   r1, 24h+var_10[sp]
FFF2C6B0  a909                              mov.l   24h+var_10[sp], r1
FFF2C6B2  6101                              cmp     #0, r1
FFF2C6B4  200e                              beq.b   loc_FFF2C6C2
FFF2C6B6  a909                              mov.l   24h+var_10[sp], r1
FFF2C6B8  6602                              mov.l   #0, r2
FFF2C6BA  05c127ff                          bsr.a   sub_FFF1EE7B
FFF2C6BE  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C6C0  2e1b                              bra.b   loc_FFF2C6DB
FFF2C6C2  a809                   loc_FFF2C6C2 mov.l   24h+var_20[sp], r1
FFF2C6C4  6101                              cmp     #0, r1
FFF2C6C6  aa01                              mov.l   24h+var_4[sp], r1
FFF2C6C8  1d                                bne.s   loc_FFF2C6CD
FFF2C6C9  3c14fe                            mov.b   #-2, 4[r1]
FFF2C6CC  0d                                bra.s   loc_FFF2C6D1
FFF2C6CD  e5010103               loc_FFF2C6CD mov.l   24h+var_20[sp], 0Ch[r1]
FFF2C6D1  a902                   loc_FFF2C6D1 mov.l   24h+var_14[sp], r2
FFF2C6D3  6601                              mov.l   #0, r1
FFF2C6D5  05a627ff                          bsr.a   sub_FFF1EE7B
FFF2C6D9  e301                              mov.l   r1, 24h+var_24[sp]
FFF2C6DB  ec01                   loc_FFF2C6DB mov.l   24h+var_24[sp], r1
FFF2C6DD  a181                              mov.l   r1, 24h+var_C[sp]
FFF2C6DF  6709                              rtsd    #9
FFF2C6E1  7100d8                 sub_FFF2C6E1 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF2C6E1
FFF2C6E4  a209                              mov.l   r1, 28h+var_4[sp]
FFF2C6E6  a202                              mov.l   r2, 28h+var_8[sp]
FFF2C6E8  938b                              mov.w   r3, 28h+var_A[sp]
FFF2C6EA  a184                              mov.l   r4, 28h+var_10[sp]
FFF2C6EC  aa89                              mov.l   28h+arg_0[sp], r1
FFF2C6EE  a109                              mov.l   r1, 28h+var_14[sp]
FFF2C6F0  72110c0e                          add     #0E0Ch, r1, r1
FFF2C6F4  a009                              mov.l   r1, 28h+var_24[sp]
FFF2C6F6  aa02                              mov.l   28h+var_8[sp], r2
FFF2C6F8  aa09                              mov.l   28h+var_4[sp], r1
FFF2C6FA  710304                            add     #28h+var_24, sp, r3
FFF2C6FD  05133dff                          bsr.a   sub_FFF20410
FFF2C701  a089                              mov.l   r1, 28h+var_1C[sp]
FFF2C703  a889                              mov.l   28h+var_1C[sp], r1
FFF2C705  6101                              cmp     #0, r1
FFF2C707  16                                beq.s   loc_FFF2C70D
FFF2C708  e10003                            mov.l   28h+var_1C[sp], 28h+var_28[sp]
FFF2C70B  2e1a                              bra.b   loc_FFF2C725
FFF2C70D  bb89                   loc_FFF2C70D movu.w  28h+var_A[sp], r1
FFF2C70F  6c51                              shll    #5, r1
FFF2C711  06890101                          add     28h+var_24[sp].l, r1
FFF2C715  a081                              mov.l   r1, 28h+var_20[sp]
FFF2C717  a882                              mov.l   28h+var_20[sp], r2
FFF2C719  a981                              mov.l   28h+var_10[sp], r1
FFF2C71B  754320                            mov.l   #20h, r3 ; ' '
FFF2C71E  055a1d00                          bsr.a   sub_FFF2E478
FFF2C722  f80600                            mov.l   #0, 28h+var_28[sp]
FFF2C725  ec01                   loc_FFF2C725 mov.l   28h+var_28[sp], r1
FFF2C727  a101                              mov.l   r1, 28h+var_18[sp]
FFF2C729  670a                              rtsd    #0Ah
FFF2C72B  7100ec                 sub_FFF2C72B add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2C72B
FFF2C72E  a101                              mov.l   r1, 14h+var_4[sp]
FFF2C730  056697fe                          bsr.a   sub_FFF15E96
FFF2C734  a009                              mov.l   r1, 14h+var_10[sp]
FFF2C736  a809                              mov.l   14h+var_10[sp], r1
FFF2C738  6101                              cmp     #0, r1
FFF2C73A  210f                              bne.b   loc_FFF2C749
FFF2C73C  6602                              mov.l   #0, r2
FFF2C73E  fb16e1                            mov.l   #-1Fh, r1
FFF2C741  05df26ff                          bsr.a   sub_FFF1EE20
FFF2C745  e301                              mov.l   r1, 14h+var_14[sp]
FFF2C747  2e14                              bra.b   loc_FFF2C75B
FFF2C749  a80a                   loc_FFF2C749 mov.l   14h+var_10[sp], r2
FFF2C74B  a901                              mov.l   14h+var_4[sp], r1
FFF2C74D  391400                            bsr.w   sub_FFF2C761
FFF2C750  a081                              mov.l   r1, 14h+var_C[sp]
FFF2C752  a809                              mov.l   14h+var_10[sp], r1
FFF2C754  055297fe                          bsr.a   sub_FFF15EA6
FFF2C758  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2C75B  ec01                   loc_FFF2C75B mov.l   14h+var_14[sp], r1
FFF2C75D  a089                              mov.l   r1, 14h+var_8[sp]
FFF2C75F  6705                              rtsd    #5
FFF2C761  7100e0                 sub_FFF2C761 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2C761
FFF2C764  a189                              mov.l   r1, 20h+var_4[sp]
FFF2C766  a182                              mov.l   r2, 20h+var_8[sp]
FFF2C768  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2C76E  e4e003                            mov.l   [r14], 20h+var_14[sp]
FFF2C771  057a88ff                          bsr.a   sub_FFF24FEB
FFF2C775  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C777  a901                              mov.l   20h+var_10[sp], r1
FFF2C779  6101                              cmp     #0, r1
FFF2C77B  200f                              beq.b   loc_FFF2C78A
FFF2C77D  a901                              mov.l   20h+var_10[sp], r1
FFF2C77F  6602                              mov.l   #0, r2
FFF2C781  059f26ff                          bsr.a   sub_FFF1EE20
FFF2C785  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C787  383d01                            bra.w   loc_FFF2C8C4
FFF2C78A  a989                   loc_FFF2C78A mov.l   20h+var_4[sp], r1
FFF2C78C  6101                              cmp     #0, r1
FFF2C78E  2110                              bne.b   loc_FFF2C79E
FFF2C790  6602                              mov.l   #0, r2
FFF2C792  fb16ff                            mov.l   #-1, r1
FFF2C795  058b26ff                          bsr.a   sub_FFF1EE20
FFF2C799  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C79B  382901                            bra.w   loc_FFF2C8C4
FFF2C79E  a989                   loc_FFF2C79E mov.l   20h+var_4[sp], r1
FFF2C7A0  055b6fff                          bsr.a   sub_FFF236FB
FFF2C7A4  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C7A6  a901                              mov.l   20h+var_10[sp], r1
FFF2C7A8  6101                              cmp     #0, r1
FFF2C7AA  200f                              beq.b   loc_FFF2C7B9
FFF2C7AC  a901                              mov.l   20h+var_10[sp], r1
FFF2C7AE  6602                              mov.l   #0, r2
FFF2C7B0  057026ff                          bsr.a   sub_FFF1EE20
FFF2C7B4  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C7B6  380e01                            bra.w   loc_FFF2C8C4
FFF2C7B9  a98a                   loc_FFF2C7B9 mov.l   20h+var_4[sp], r2
FFF2C7BB  a981                              mov.l   20h+var_8[sp], r1
FFF2C7BD  72110c10                          add     #100Ch, r1, r1
FFF2C7C1  05842400                          bsr.a   sub_FFF2EC45
FFF2C7C5  a981                              mov.l   20h+var_8[sp], r1
FFF2C7C7  72110c10                          add     #100Ch, r1, r1
FFF2C7CB  05516eff                          bsr.a   sub_FFF2361C
FFF2C7CF  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C7D1  a901                              mov.l   20h+var_10[sp], r1
FFF2C7D3  6101                              cmp     #0, r1
FFF2C7D5  200f                              beq.b   loc_FFF2C7E4
FFF2C7D7  a901                              mov.l   20h+var_10[sp], r1
FFF2C7D9  6602                              mov.l   #0, r2
FFF2C7DB  054526ff                          bsr.a   sub_FFF1EE20
FFF2C7DF  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C7E1  38e300                            bra.w   loc_FFF2C8C4
FFF2C7E4  a981                   loc_FFF2C7E4 mov.l   20h+var_8[sp], r1
FFF2C7E6  ce110c10                          mov.b   100Ch[r1], r1
FFF2C7EA  05a11f00                          bsr.a   sub_FFF2E78B
FFF2C7EE  8289                              mov.b   r1, 20h+var_15[sp]
FFF2C7F0  b289                              movu.b  20h+var_15[sp], r1
FFF2C7F2  71020c                            add     #20h+var_14, sp, r2
FFF2C7F5  052a27ff                          bsr.a   sub_FFF1EF1F
FFF2C7F9  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C7FB  a901                              mov.l   20h+var_10[sp], r1
FFF2C7FD  6101                              cmp     #0, r1
FFF2C7FF  200f                              beq.b   loc_FFF2C80E
FFF2C801  a901                              mov.l   20h+var_10[sp], r1
FFF2C803  6602                              mov.l   #0, r2
FFF2C805  051b26ff                          bsr.a   sub_FFF1EE20
FFF2C809  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C80B  38b900                            bra.w   loc_FFF2C8C4
FFF2C80E  a889                   loc_FFF2C80E mov.l   20h+var_14[sp], r1
FFF2C810  591e6c                            movu.b  6Ch[r1], r14
FFF2C813  641e                              and     #1, r14
FFF2C815  611e                              cmp     #1, r14
FFF2C817  200e                              beq.b   loc_FFF2C825
FFF2C819  a889                              mov.l   20h+var_14[sp], r1
FFF2C81B  591e6c                            movu.b  6Ch[r1], r14
FFF2C81E  752e10                            and     #10h, r14
FFF2C821  755e10                            cmp     #10h, r14
FFF2C824  1d                                bne.s   loc_FFF2C829
FFF2C825  f80601                 loc_FFF2C825 mov.l   #1, 20h+var_20[sp]
FFF2C828  0c                                bra.s   loc_FFF2C82C
FFF2C829  f80600                 loc_FFF2C829 mov.l   #0, 20h+var_20[sp]
FFF2C82C  ec01                   loc_FFF2C82C mov.l   20h+var_20[sp], r1
FFF2C82E  6101                              cmp     #0, r1
FFF2C830  2030                              beq.b   loc_FFF2C860
FFF2C832  a889                              mov.l   20h+var_14[sp], r1
FFF2C834  05af95fe                          bsr.a   sub_FFF15DE3
FFF2C838  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C83A  a901                              mov.l   20h+var_10[sp], r1
FFF2C83C  6101                              cmp     #0, r1
FFF2C83E  200f                              beq.b   loc_FFF2C84D
FFF2C840  6602                              mov.l   #0, r2
FFF2C842  fb16c1                            mov.l   #-3Fh, r1
FFF2C845  05db25ff                          bsr.a   sub_FFF1EE20
FFF2C849  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C84B  2e79                              bra.b   loc_FFF2C8C4
FFF2C84D  a982                   loc_FFF2C84D mov.l   20h+var_8[sp], r2
FFF2C84F  72210c10                          add     #100Ch, r2, r1
FFF2C853  397700                            bsr.w   sub_FFF2C8CA
FFF2C856  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C858  a889                              mov.l   20h+var_14[sp], r1
FFF2C85A  059495fe                          bsr.a   sub_FFF15DEE
FFF2C85E  2e0d                              bra.b   loc_FFF2C86B
FFF2C860  a982                   loc_FFF2C860 mov.l   20h+var_8[sp], r2
FFF2C862  72210c10                          add     #100Ch, r2, r1
FFF2C866  396400                            bsr.w   sub_FFF2C8CA
FFF2C869  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C86B  a901                   loc_FFF2C86B mov.l   20h+var_10[sp], r1
FFF2C86D  6101                              cmp     #0, r1
FFF2C86F  200e                              beq.b   loc_FFF2C87D
FFF2C871  a901                              mov.l   20h+var_10[sp], r1
FFF2C873  6602                              mov.l   #0, r2
FFF2C875  05ab25ff                          bsr.a   sub_FFF1EE20
FFF2C879  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C87B  2e49                              bra.b   loc_FFF2C8C4
FFF2C87D  a889                   loc_FFF2C87D mov.l   20h+var_14[sp], r1
FFF2C87F  055d03ff                          bsr.a   sub_FFF1CBDC
FFF2C883  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C885  a901                              mov.l   20h+var_10[sp], r1
FFF2C887  6101                              cmp     #0, r1
FFF2C889  200e                              beq.b   loc_FFF2C897
FFF2C88B  a901                              mov.l   20h+var_10[sp], r1
FFF2C88D  6602                              mov.l   #0, r2
FFF2C88F  059125ff                          bsr.a   sub_FFF1EE20
FFF2C893  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C895  2e2f                              bra.b   loc_FFF2C8C4
FFF2C897  a889                   loc_FFF2C897 mov.l   20h+var_14[sp], r1
FFF2C899  591e6c                            movu.b  6Ch[r1], r14
FFF2C89C  752e10                            and     #10h, r14
FFF2C89F  755e10                            cmp     #10h, r14
FFF2C8A2  2118                              bne.b   loc_FFF2C8BA
FFF2C8A4  a984                              mov.l   20h+var_8[sp], r4
FFF2C8A6  5a433216                          movu.b  1632h[r4], r3
FFF2C8AA  5a423116                          movu.b  1631h[r4], r2
FFF2C8AE  a889                              mov.l   20h+var_14[sp], r1
FFF2C8B0  72440c06                          add     #60Ch, r4, r4
FFF2C8B4  05a89bff                          bsr.a   sub_FFF2645C
FFF2C8B8  a101                              mov.l   r1, 20h+var_10[sp]
FFF2C8BA  a901                   loc_FFF2C8BA mov.l   20h+var_10[sp], r1
FFF2C8BC  6602                              mov.l   #0, r2
FFF2C8BE  056225ff                          bsr.a   sub_FFF1EE20
FFF2C8C2  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2C8C4  a809                   loc_FFF2C8C4 mov.l   20h+var_1C[sp], r1
FFF2C8C6  a109                              mov.l   r1, 20h+var_C[sp]
FFF2C8C8  6708                              rtsd    #8
FFF2C8CA  710098                 sub_FFF2C8CA add     #-68h, sp, sp   ; <<<< FUNC sub_FFF2C8CA
FFF2C8CD  a609                              mov.l   r1, 68h+var_4[sp]
FFF2C8CF  a602                              mov.l   r2, 68h+var_8[sp]
FFF2C8D1  3e8200                            mov.l   #0, 68h+var_20[sp]
FFF2C8D4  3e8100                            mov.l   #0, 68h+var_24[sp]
FFF2C8D7  3e8000                            mov.l   #0, 68h+var_28[sp]
FFF2C8DA  3e0f00                            mov.l   #0, 68h+var_2C[sp]
FFF2C8DD  3e0e00                            mov.l   #0, 68h+var_30[sp]
FFF2C8E0  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2C8E6  e4e005                            mov.l   [r14], 68h+var_54[sp]
FFF2C8E9  ae01                              mov.l   68h+var_8[sp], r1
FFF2C8EB  fa14301600                        mov.b   #0, 1630h[r1]
FFF2C8F0  ae09                              mov.l   68h+var_4[sp], r1
FFF2C8F2  cc11                              mov.b   [r1], r1
FFF2C8F4  05971e00                          bsr.a   sub_FFF2E78B
FFF2C8F8  8489                              mov.b   r1, 68h+var_55[sp]
FFF2C8FA  b489                              movu.b  68h+var_55[sp], r1
FFF2C8FC  710214                            add     #68h+var_54, sp, r2
FFF2C8FF  052026ff                          bsr.a   sub_FFF1EF1F
FFF2C903  a581                              mov.l   r1, 68h+var_10[sp]
FFF2C905  ad81                              mov.l   68h+var_10[sp], r1
FFF2C907  6101                              cmp     #0, r1
FFF2C909  10                                beq.s   loc_FFF2C911
FFF2C90A  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2C90E  388b03                            bra.w   loc_FFF2CC99
FFF2C911  a909                   loc_FFF2C911 mov.l   68h+var_54[sp], r1
FFF2C913  054a26ff                          bsr.a   sub_FFF1EF5D
FFF2C917  a581                              mov.l   r1, 68h+var_10[sp]
FFF2C919  ad81                              mov.l   68h+var_10[sp], r1
FFF2C91B  6101                              cmp     #0, r1
FFF2C91D  10                                beq.s   loc_FFF2C925
FFF2C91E  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2C922  387703                            bra.w   loc_FFF2CC99
FFF2C925  a909                   loc_FFF2C925 mov.l   68h+var_54[sp], r1
FFF2C927  056a26ff                          bsr.a   sub_FFF1EF91
FFF2C92B  a581                              mov.l   r1, 68h+var_10[sp]
FFF2C92D  ad81                              mov.l   68h+var_10[sp], r1
FFF2C92F  6101                              cmp     #0, r1
FFF2C931  10                                beq.s   loc_FFF2C939
FFF2C932  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2C936  386303                            bra.w   loc_FFF2CC99
FFF2C939  ae09                   loc_FFF2C939 mov.l   68h+var_4[sp], r1
FFF2C93B  6241                              add     #4, r1
FFF2C93D  a501                              mov.l   r1, 68h+var_18[sp]
FFF2C93F  a909                              mov.l   68h+var_54[sp], r1
FFF2C941  e5100d10                          mov.l   34h[r1], 68h+var_28[sp]
FFF2C945  a909                              mov.l   68h+var_54[sp], r1
FFF2C947  8c11                              mov.b   10h[r1], r1
FFF2C949  755120                            cmp     #20h, r1 ; ' '
FFF2C94C  3a4c01                            beq.w   loc_FFF2CA98
FFF2C94F  ae02                              mov.l   68h+var_8[sp], r2
FFF2C951  ad01                              mov.l   68h+var_18[sp], r1
FFF2C953  05c06aff                          bsr.a   sub_FFF23413
FFF2C957  a501                              mov.l   r1, 68h+var_18[sp]
FFF2C959  ad01                              mov.l   68h+var_18[sp], r1
FFF2C95B  6101                              cmp     #0, r1
FFF2C95D  18                                bne.s   loc_FFF2C965
FFF2C95E  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2C962  383703                            bra.w   loc_FFF2CC99
FFF2C965  ae01                   loc_FFF2C965 mov.l   68h+var_8[sp], r1
FFF2C967  cc1e                              mov.b   [r1], r14
FFF2C969  610e                              cmp     #0, r14
FFF2C96B  210d                              bne.b   loc_FFF2C978
FFF2C96D  ae01                              mov.l   68h+var_8[sp], r1
FFF2C96F  8819                              mov.b   1[r1], r1
FFF2C971  6101                              cmp     #0, r1
FFF2C973  1d                                bne.s   loc_FFF2C978
FFF2C974  f80601                            mov.l   #1, 68h+var_68[sp]
FFF2C977  0c                                bra.s   loc_FFF2C97B
FFF2C978  f80600                 loc_FFF2C978 mov.l   #0, 68h+var_68[sp]
FFF2C97B  ec01                   loc_FFF2C97B mov.l   68h+var_68[sp], r1
FFF2C97D  6101                              cmp     #0, r1
FFF2C97F  10                                beq.s   loc_FFF2C987
FFF2C980  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2C984  381503                            bra.w   loc_FFF2CC99
FFF2C987  ae02                   loc_FFF2C987 mov.l   68h+var_8[sp], r2
FFF2C989  a909                              mov.l   68h+var_54[sp], r1
FFF2C98B  60c0                              sub     #0Ch, sp
FFF2C98D  a082                              mov.l   r2, 74h+var_6C[sp]
FFF2C98F  710354                            add     #74h+var_20, sp, r3
FFF2C992  a00b                              mov.l   r3, 74h+var_70[sp]
FFF2C994  f80400                            mov.b   #0, 74h+var_74[sp]
FFF2C997  6604                              mov.l   #0, r4
FFF2C999  710324                            add     #74h+var_50, sp, r3
FFF2C99C  05d65cff                          bsr.a   sub_FFF22672
FFF2C9A0  62c0                              add     #0Ch, sp
FFF2C9A2  a581                              mov.l   r1, 68h+var_10[sp]
FFF2C9A4  ad01                              mov.l   68h+var_18[sp], r1
FFF2C9A6  cc1e                              mov.b   [r1], r14
FFF2C9A8  610e                              cmp     #0, r14
FFF2C9AA  ad81                              mov.l   68h+var_10[sp], r1
FFF2C9AC  210d                              bne.b   loc_FFF2C9B9
FFF2C9AE  6101                              cmp     #0, r1
FFF2C9B0  212e                              bne.b   loc_FFF2C9DE
FFF2C9B2  f90601fe                          mov.l   #-2, 68h+var_64[sp]
FFF2C9B6  38e302                            bra.w   loc_FFF2CC99
FFF2C9B9  6101                   loc_FFF2C9B9 cmp     #0, r1
FFF2C9BB  10                                beq.s   loc_FFF2C9C3
FFF2C9BC  f90601fc                          mov.l   #-4, 68h+var_64[sp]
FFF2C9C0  38d902                            bra.w   loc_FFF2CC99
FFF2C9C3  cd0123                 loc_FFF2C9C3 mov.b   68h+var_45[sp], r1
FFF2C9C6  754210                            mov.l   #10h, r2
FFF2C9C9  05a43eff                          bsr.a   sub_FFF2086D
FFF2C9CD  6101                              cmp     #0, r1
FFF2C9CF  10                                beq.s   loc_FFF2C9D7
FFF2C9D0  f90601fc                          mov.l   #-4, 68h+var_64[sp]
FFF2C9D4  38c502                            bra.w   loc_FFF2CC99
FFF2C9D7  ae01                   loc_FFF2C9D7 mov.l   68h+var_8[sp], r1
FFF2C9D9  fa14301601                        mov.b   #1, 1630h[r1]
FFF2C9DE  a909                   loc_FFF2C9DE mov.l   68h+var_54[sp], r1
FFF2C9E0  8c12                              mov.b   10h[r1], r2
FFF2C9E2  710118                            add     #68h+var_50, sp, r1
FFF2C9E5  05b33cff                          bsr.a   sub_FFF20698
FFF2C9E9  a401                              mov.l   r1, 68h+var_28[sp]
FFF2C9EB  38ad00                            bra.w   loc_FFF2CA98
FFF2C9EE  ae02                   loc_FFF2C9EE mov.l   68h+var_8[sp], r2
FFF2C9F0  ad01                              mov.l   68h+var_18[sp], r1
FFF2C9F2  05216aff                          bsr.a   sub_FFF23413
FFF2C9F6  a501                              mov.l   r1, 68h+var_18[sp]
FFF2C9F8  ad01                              mov.l   68h+var_18[sp], r1
FFF2C9FA  6101                              cmp     #0, r1
FFF2C9FC  18                                bne.s   loc_FFF2CA04
FFF2C9FD  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2CA01  389802                            bra.w   loc_FFF2CC99
FFF2CA04  ae01                   loc_FFF2CA04 mov.l   68h+var_8[sp], r1
FFF2CA06  cc1e                              mov.b   [r1], r14
FFF2CA08  610e                              cmp     #0, r14
FFF2CA0A  210d                              bne.b   loc_FFF2CA17
FFF2CA0C  ae01                              mov.l   68h+var_8[sp], r1
FFF2CA0E  8819                              mov.b   1[r1], r1
FFF2CA10  6101                              cmp     #0, r1
FFF2CA12  1d                                bne.s   loc_FFF2CA17
FFF2CA13  f80601                            mov.l   #1, 68h+var_68[sp]
FFF2CA16  0c                                bra.s   loc_FFF2CA1A
FFF2CA17  f80600                 loc_FFF2CA17 mov.l   #0, 68h+var_68[sp]
FFF2CA1A  ec01                   loc_FFF2CA1A mov.l   68h+var_68[sp], r1
FFF2CA1C  6101                              cmp     #0, r1
FFF2CA1E  10                                beq.s   loc_FFF2CA26
FFF2CA1F  f90601ff                          mov.l   #-1, 68h+var_64[sp]
FFF2CA23  387602                            bra.w   loc_FFF2CC99
FFF2CA26  e500100f               loc_FFF2CA26 mov.l   68h+var_28[sp], 68h+var_2C[sp]
FFF2CA2A  ae03                              mov.l   68h+var_8[sp], r3
FFF2CA2C  ac02                              mov.l   68h+var_28[sp], r2
FFF2CA2E  a909                              mov.l   68h+var_54[sp], r1
FFF2CA30  7100f0                            add     #-10h, sp, sp
FFF2CA33  a08b                              mov.l   r3, 78h+var_6C[sp]
FFF2CA35  710454                            add     #78h+var_24, sp, r4
FFF2CA38  a084                              mov.l   r4, 78h+var_70[sp]
FFF2CA3A  710458                            add     #78h+var_20, sp, r4
FFF2CA3D  a00c                              mov.l   r4, 78h+var_74[sp]
FFF2CA3F  3c0100                            mov.b   #0, 78h+var_77[sp]
FFF2CA42  f80400                            mov.b   #0, 78h+var_78[sp]
FFF2CA45  710428                            add     #78h+var_50, sp, r4
FFF2CA48  058560ff                          bsr.a   sub_FFF22ACD
FFF2CA4C  710010                            add     #10h, sp, sp
FFF2CA4F  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CA51  ad01                              mov.l   68h+var_18[sp], r1
FFF2CA53  cc1e                              mov.b   [r1], r14
FFF2CA55  610e                              cmp     #0, r14
FFF2CA57  ad81                              mov.l   68h+var_10[sp], r1
FFF2CA59  210d                              bne.b   loc_FFF2CA66
FFF2CA5B  6101                              cmp     #0, r1
FFF2CA5D  212e                              bne.b   loc_FFF2CA8B
FFF2CA5F  f90601fe                          mov.l   #-2, 68h+var_64[sp]
FFF2CA63  383602                            bra.w   loc_FFF2CC99
FFF2CA66  6101                   loc_FFF2CA66 cmp     #0, r1
FFF2CA68  10                                beq.s   loc_FFF2CA70
FFF2CA69  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CA6D  382c02                            bra.w   loc_FFF2CC99
FFF2CA70  cd0123                 loc_FFF2CA70 mov.b   68h+var_45[sp], r1
FFF2CA73  754210                            mov.l   #10h, r2
FFF2CA76  05f73dff                          bsr.a   sub_FFF2086D
FFF2CA7A  6101                              cmp     #0, r1
FFF2CA7C  10                                beq.s   loc_FFF2CA84
FFF2CA7D  f90601fc                          mov.l   #-4, 68h+var_64[sp]
FFF2CA81  381802                            bra.w   loc_FFF2CC99
FFF2CA84  ae01                   loc_FFF2CA84 mov.l   68h+var_8[sp], r1
FFF2CA86  fa14301601                        mov.b   #1, 1630h[r1]
FFF2CA8B  a909                   loc_FFF2CA8B mov.l   68h+var_54[sp], r1
FFF2CA8D  8c12                              mov.b   10h[r1], r2
FFF2CA8F  710118                            add     #68h+var_50, sp, r1
FFF2CA92  05063cff                          bsr.a   sub_FFF20698
FFF2CA96  a401                              mov.l   r1, 68h+var_28[sp]
FFF2CA98  ad01                   loc_FFF2CA98 mov.l   68h+var_18[sp], r1
FFF2CA9A  cc1e                              mov.b   [r1], r14
FFF2CA9C  610e                              cmp     #0, r14
FFF2CA9E  3b50ff                            bne.w   loc_FFF2C9EE
FFF2CAA1  ae01                              mov.l   68h+var_8[sp], r1
FFF2CAA3  5a1e3016                          movu.b  1630h[r1], r14
FFF2CAA7  611e                              cmp     #1, r14
FFF2CAA9  2112                              bne.b   loc_FFF2CABB
FFF2CAAB  a909                              mov.l   68h+var_54[sp], r1
FFF2CAAD  591e6c                            movu.b  6Ch[r1], r14
FFF2CAB0  752e10                            and     #10h, r14
FFF2CAB3  755e10                            cmp     #10h, r14
FFF2CAB6  1d                                bne.s   loc_FFF2CABB
FFF2CAB7  f80601                            mov.l   #1, 68h+var_68[sp]
FFF2CABA  0c                                bra.s   loc_FFF2CABE
FFF2CABB  f80600                 loc_FFF2CABB mov.l   #0, 68h+var_68[sp]
FFF2CABE  ec01                   loc_FFF2CABE mov.l   68h+var_68[sp], r1
FFF2CAC0  6101                              cmp     #0, r1
FFF2CAC2  2073                              beq.b   loc_FFF2CB35
FFF2CAC4  ae02                              mov.l   68h+var_8[sp], r2
FFF2CAC6  ae09                              mov.l   68h+var_4[sp], r1
FFF2CAC8  72220c06                          add     #60Ch, r2, r2
FFF2CACC  0578a1ff                          bsr.a   sub_FFF26C44
FFF2CAD0  8289                              mov.b   r1, 68h+var_5D[sp]
FFF2CAD2  ae03                              mov.l   68h+var_8[sp], r3
FFF2CAD4  a909                              mov.l   68h+var_54[sp], r1
FFF2CAD6  72320c06                          add     #60Ch, r3, r2
FFF2CADA  05af97ff                          bsr.a   sub_FFF26289
FFF2CADE  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CAE0  ad81                              mov.l   68h+var_10[sp], r1
FFF2CAE2  6101                              cmp     #0, r1
FFF2CAE4  2130                              bne.b   loc_FFF2CB14
FFF2CAE6  ae02                              mov.l   68h+var_8[sp], r2
FFF2CAE8  b28d                              movu.b  68h+var_5D[sp], r5
FFF2CAEA  ac84                              mov.l   68h+var_20[sp], r4
FFF2CAEC  ac0b                              mov.l   68h+var_24[sp], r3
FFF2CAEE  a909                              mov.l   68h+var_54[sp], r1
FFF2CAF0  60c0                              sub     #0Ch, sp
FFF2CAF2  a082                              mov.l   r2, 74h+var_6C[sp]
FFF2CAF4  72220c06                          add     #60Ch, r2, r2
FFF2CAF8  a00a                              mov.l   r2, 74h+var_70[sp]
FFF2CAFA  c305                              mov.b   r5, 74h+var_74[sp]
FFF2CAFC  710224                            add     #74h+var_50, sp, r2
FFF2CAFF  054798ff                          bsr.a   sub_FFF26346
FFF2CB03  62c0                              add     #0Ch, sp
FFF2CB05  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CB07  ad81                              mov.l   68h+var_10[sp], r1
FFF2CB09  6101                              cmp     #0, r1
FFF2CB0B  202a                              beq.b   loc_FFF2CB35
FFF2CB0D  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CB11  388801                            bra.w   loc_FFF2CC99
FFF2CB14  ad81                   loc_FFF2CB14 mov.l   68h+var_10[sp], r1
FFF2CB16  7601d3fe                          cmp     #-12Dh, r1
FFF2CB1A  10                                beq.s   loc_FFF2CB22
FFF2CB1B  ad81                              mov.l   68h+var_10[sp], r1
FFF2CB1D  7601d4fe                          cmp     #-12Ch, r1
FFF2CB21  1d                                bne.s   loc_FFF2CB26
FFF2CB22  f80601                 loc_FFF2CB22 mov.l   #1, 68h+var_68[sp]
FFF2CB25  0c                                bra.s   loc_FFF2CB29
FFF2CB26  f80600                 loc_FFF2CB26 mov.l   #0, 68h+var_68[sp]
FFF2CB29  ec01                   loc_FFF2CB29 mov.l   68h+var_68[sp], r1
FFF2CB2B  6101                              cmp     #0, r1
FFF2CB2D  18                                bne.s   loc_FFF2CB35
FFF2CB2E  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CB32  386701                            bra.w   loc_FFF2CC99
FFF2CB35  a909                   loc_FFF2CB35 mov.l   68h+var_54[sp], r1
FFF2CB37  ad9c                              mov.l   5Ch[r1], r4
FFF2CB39  754320                            mov.l   #20h, r3 ; ' '
FFF2CB3C  6602                              mov.l   #0, r2
FFF2CB3E  710118                            add     #68h+var_50, sp, r1
FFF2CB41  056e1900                          bsr.a   sub_FFF2E4AF
FFF2CB45  ae04                              mov.l   68h+var_8[sp], r4
FFF2CB47  a909                              mov.l   68h+var_54[sp], r1
FFF2CB49  71034c                            add     #68h+var_1C, sp, r3
FFF2CB4C  6602                              mov.l   #0, r2
FFF2CB4E  05837aff                          bsr.a   sub_FFF245D1
FFF2CB52  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CB54  ad81                              mov.l   68h+var_10[sp], r1
FFF2CB56  6101                              cmp     #0, r1
FFF2CB58  10                                beq.s   loc_FFF2CB60
FFF2CB59  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CB5D  383c01                            bra.w   loc_FFF2CC99
FFF2CB60  ac89                   loc_FFF2CB60 mov.l   68h+var_1C[sp], r1
FFF2CB62  6101                              cmp     #0, r1
FFF2CB64  18                                bne.s   loc_FFF2CB6C
FFF2CB65  f90601f5                          mov.l   #-0Bh, 68h+var_64[sp]
FFF2CB69  383001                            bra.w   loc_FFF2CC99
FFF2CB6C  e5000f0e               loc_FFF2CB6C mov.l   68h+var_2C[sp], 68h+var_30[sp]
FFF2CB70  a909                              mov.l   68h+var_54[sp], r1
FFF2CB72  8c11                              mov.b   10h[r1], r1
FFF2CB74  755120                            cmp     #20h, r1 ; ' '
FFF2CB77  210f                              bne.b   loc_FFF2CB86
FFF2CB79  a909                              mov.l   68h+var_54[sp], r1
FFF2CB7B  ab19                              mov.l   34h[r1], r1
FFF2CB7D  0685010f                          cmp     68h+var_2C[sp].l, r1
FFF2CB81  1d                                bne.s   loc_FFF2CB86
FFF2CB82  f80601                            mov.l   #1, 68h+var_68[sp]
FFF2CB85  0c                                bra.s   loc_FFF2CB89
FFF2CB86  f80600                 loc_FFF2CB86 mov.l   #0, 68h+var_68[sp]
FFF2CB89  ec01                   loc_FFF2CB89 mov.l   68h+var_68[sp], r1
FFF2CB8B  6101                              cmp     #0, r1
FFF2CB8D  14                                beq.s   loc_FFF2CB91
FFF2CB8E  3e0f00                            mov.l   #0, 68h+var_2C[sp]
FFF2CB91  ae04                   loc_FFF2CB91 mov.l   68h+var_8[sp], r4
FFF2CB93  ab8b                              mov.l   68h+var_2C[sp], r3
FFF2CB95  ac8a                              mov.l   68h+var_1C[sp], r2
FFF2CB97  a909                              mov.l   68h+var_54[sp], r1
FFF2CB99  0535eaff                          bsr.a   sub_FFF2B5CE
FFF2CB9D  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CB9F  ad81                              mov.l   68h+var_10[sp], r1
FFF2CBA1  6101                              cmp     #0, r1
FFF2CBA3  203f                              beq.b   loc_FFF2CBE2
FFF2CBA5  ae02                              mov.l   68h+var_8[sp], r2
FFF2CBA7  ac8b                              mov.l   68h+var_1C[sp], r3
FFF2CBA9  a909                              mov.l   68h+var_54[sp], r1
FFF2CBAB  6080                              sub     #8, sp
FFF2CBAD  a00a                              mov.l   r2, 70h+var_6C[sp]
FFF2CBAF  f80477                            mov.b   #77h, 70h+var_70[sp] ; 'w'
FFF2CBB2  6604                              mov.l   #0, r4
FFF2CBB4  710214                            add     #70h+var_5C, sp, r2
FFF2CBB7  057877ff                          bsr.a   sub_FFF2432F
FFF2CBBB  6280                              add     #8, sp
FFF2CBBD  a509                              mov.l   r1, 68h+var_14[sp]
FFF2CBBF  ad09                              mov.l   68h+var_14[sp], r1
FFF2CBC1  6101                              cmp     #0, r1
FFF2CBC3  10                                beq.s   loc_FFF2CBCB
FFF2CBC4  e5001501                          mov.l   68h+var_14[sp], 68h+var_64[sp]
FFF2CBC8  38d100                            bra.w   loc_FFF2CC99
FFF2CBCB  a909                   loc_FFF2CBCB mov.l   68h+var_54[sp], r1
FFF2CBCD  8c11                              mov.b   10h[r1], r1
FFF2CBCF  755120                            cmp     #20h, r1 ; ' '
FFF2CBD2  19                                bne.s   loc_FFF2CBDB
FFF2CBD3  a909                              mov.l   68h+var_54[sp], r1
FFF2CBD5  ab9a                              mov.l   3Ch[r1], r2
FFF2CBD7  6212                              add     #1, r2
FFF2CBD9  a39a                              mov.l   r2, 3Ch[r1]
FFF2CBDB  e5001601               loc_FFF2CBDB mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CBDF  38ba00                            bra.w   loc_FFF2CC99
FFF2CBE2  e5000e0f               loc_FFF2CBE2 mov.l   68h+var_30[sp], 68h+var_2C[sp]
FFF2CBE6  a909                              mov.l   68h+var_54[sp], r1
FFF2CBE8  8c13                              mov.b   10h[r1], r3
FFF2CBEA  ac8a                              mov.l   68h+var_1C[sp], r2
FFF2CBEC  710118                            add     #68h+var_50, sp, r1
FFF2CBEF  05f53aff                          bsr.a   sub_FFF206E4
FFF2CBF3  f9042310                          mov.b   #10h, 68h+var_45[sp]
FFF2CBF7  6673                              mov.l   #7, r3
FFF2CBF9  6602                              mov.l   #0, r2
FFF2CBFB  710118                            add     #68h+var_50, sp, r1
FFF2CBFE  05e239ff                          bsr.a   sub_FFF205E0
FFF2CC02  ab89                              mov.l   68h+var_2C[sp], r1
FFF2CC04  6101                              cmp     #0, r1
FFF2CC06  a909                              mov.l   68h+var_54[sp], r1
FFF2CC08  2029                              beq.b   loc_FFF2CC31
FFF2CC0A  ae03                              mov.l   68h+var_8[sp], r3
FFF2CC0C  ab8a                              mov.l   68h+var_2C[sp], r2
FFF2CC0E  7100f0                            add     #-10h, sp, sp
FFF2CC11  a08b                              mov.l   r3, 78h+var_6C[sp]
FFF2CC13  710454                            add     #78h+var_24, sp, r4
FFF2CC16  a084                              mov.l   r4, 78h+var_70[sp]
FFF2CC18  710458                            add     #78h+var_20, sp, r4
FFF2CC1B  a00c                              mov.l   r4, 78h+var_74[sp]
FFF2CC1D  3c0100                            mov.b   #0, 78h+var_77[sp]
FFF2CC20  f80401                            mov.b   #1, 78h+var_78[sp]
FFF2CC23  710428                            add     #78h+var_50, sp, r4
FFF2CC26  05a75eff                          bsr.a   sub_FFF22ACD
FFF2CC2A  710010                            add     #10h, sp, sp
FFF2CC2D  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CC2F  2e1d                              bra.b   loc_FFF2CC4C
FFF2CC31  ae02                   loc_FFF2CC31 mov.l   68h+var_8[sp], r2
FFF2CC33  60c0                              sub     #0Ch, sp
FFF2CC35  a082                              mov.l   r2, 74h+var_6C[sp]
FFF2CC37  710354                            add     #74h+var_20, sp, r3
FFF2CC3A  a00b                              mov.l   r3, 74h+var_70[sp]
FFF2CC3C  f80400                            mov.b   #0, 74h+var_74[sp]
FFF2CC3F  6614                              mov.l   #1, r4
FFF2CC41  710324                            add     #74h+var_50, sp, r3
FFF2CC44  052e5aff                          bsr.a   sub_FFF22672
FFF2CC48  62c0                              add     #0Ch, sp
FFF2CC4A  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CC4C  ad81                   loc_FFF2CC4C mov.l   68h+var_10[sp], r1
FFF2CC4E  6101                              cmp     #0, r1
FFF2CC50  a909                              mov.l   68h+var_54[sp], r1
FFF2CC52  203b                              beq.b   loc_FFF2CC8D
FFF2CC54  ae02                              mov.l   68h+var_8[sp], r2
FFF2CC56  ac8b                              mov.l   68h+var_1C[sp], r3
FFF2CC58  6080                              sub     #8, sp
FFF2CC5A  a00a                              mov.l   r2, 70h+var_6C[sp]
FFF2CC5C  f80477                            mov.b   #77h, 70h+var_70[sp] ; 'w'
FFF2CC5F  6604                              mov.l   #0, r4
FFF2CC61  710214                            add     #70h+var_5C, sp, r2
FFF2CC64  05cb76ff                          bsr.a   sub_FFF2432F
FFF2CC68  6280                              add     #8, sp
FFF2CC6A  a509                              mov.l   r1, 68h+var_14[sp]
FFF2CC6C  ad09                              mov.l   68h+var_14[sp], r1
FFF2CC6E  6101                              cmp     #0, r1
FFF2CC70  17                                beq.s   loc_FFF2CC77
FFF2CC71  e5001501                          mov.l   68h+var_14[sp], 68h+var_64[sp]
FFF2CC75  2e24                              bra.b   loc_FFF2CC99
FFF2CC77  a909                   loc_FFF2CC77 mov.l   68h+var_54[sp], r1
FFF2CC79  8c11                              mov.b   10h[r1], r1
FFF2CC7B  755120                            cmp     #20h, r1 ; ' '
FFF2CC7E  19                                bne.s   loc_FFF2CC87
FFF2CC7F  a909                              mov.l   68h+var_54[sp], r1
FFF2CC81  ab9a                              mov.l   3Ch[r1], r2
FFF2CC83  6212                              add     #1, r2
FFF2CC85  a39a                              mov.l   r2, 3Ch[r1]
FFF2CC87  e5001601               loc_FFF2CC87 mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CC8B  2e0e                              bra.b   loc_FFF2CC99
FFF2CC8D  ae02                   loc_FFF2CC8D mov.l   68h+var_8[sp], r2
FFF2CC8F  05937cff                          bsr.a   sub_FFF24922
FFF2CC93  a581                              mov.l   r1, 68h+var_10[sp]
FFF2CC95  e5001601                          mov.l   68h+var_10[sp], 68h+var_64[sp]
FFF2CC99  a809                   loc_FFF2CC99 mov.l   68h+var_64[sp], r1
FFF2CC9B  a589                              mov.l   r1, 68h+var_C[sp]
FFF2CC9D  671a                              rtsd    #1Ah
FFF2CC9F  7100ec                 sub_FFF2CC9F add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2CC9F
FFF2CCA2  a101                              mov.l   r1, 14h+var_4[sp]
FFF2CCA4  05f291fe                          bsr.a   sub_FFF15E96
FFF2CCA8  a009                              mov.l   r1, 14h+var_10[sp]
FFF2CCAA  a809                              mov.l   14h+var_10[sp], r1
FFF2CCAC  6101                              cmp     #0, r1
FFF2CCAE  210f                              bne.b   loc_FFF2CCBD
FFF2CCB0  6602                              mov.l   #0, r2
FFF2CCB2  fb16e1                            mov.l   #-1Fh, r1
FFF2CCB5  056b21ff                          bsr.a   sub_FFF1EE20
FFF2CCB9  e301                              mov.l   r1, 14h+var_14[sp]
FFF2CCBB  2e14                              bra.b   loc_FFF2CCCF
FFF2CCBD  a80a                   loc_FFF2CCBD mov.l   14h+var_10[sp], r2
FFF2CCBF  a901                              mov.l   14h+var_4[sp], r1
FFF2CCC1  391400                            bsr.w   sub_FFF2CCD5
FFF2CCC4  a081                              mov.l   r1, 14h+var_C[sp]
FFF2CCC6  a809                              mov.l   14h+var_10[sp], r1
FFF2CCC8  05de91fe                          bsr.a   sub_FFF15EA6
FFF2CCCC  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2CCCF  ec01                   loc_FFF2CCCF mov.l   14h+var_14[sp], r1
FFF2CCD1  a089                              mov.l   r1, 14h+var_8[sp]
FFF2CCD3  6705                              rtsd    #5
FFF2CCD5  72008cfd               sub_FFF2CCD5 add     #-274h, sp, sp   ; <<<< FUNC sub_FFF2CCD5
FFF2CCD9  e7019c                            mov.l   r1, 274h+var_4[sp]
FFF2CCDC  e7029b                            mov.l   r2, 274h+var_8[sp]
FFF2CCDF  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2CCE5  e4e003                            mov.l   [r14], 274h+var_268[sp]
FFF2CCE8  050383ff                          bsr.a   sub_FFF24FEB
FFF2CCEC  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CCEF  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CCF2  6101                              cmp     #0, r1
FFF2CCF4  2010                              beq.b   loc_FFF2CD04
FFF2CCF6  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CCF9  6602                              mov.l   #0, r2
FFF2CCFB  052521ff                          bsr.a   sub_FFF1EE20
FFF2CCFF  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CD01  38a901                            bra.w   loc_FFF2CEAA
FFF2CD04  ed019c                 loc_FFF2CD04 mov.l   274h+var_4[sp], r1
FFF2CD07  6101                              cmp     #0, r1
FFF2CD09  2110                              bne.b   loc_FFF2CD19
FFF2CD0B  6602                              mov.l   #0, r2
FFF2CD0D  fb16ff                            mov.l   #-1, r1
FFF2CD10  051021ff                          bsr.a   sub_FFF1EE20
FFF2CD14  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CD16  389401                            bra.w   loc_FFF2CEAA
FFF2CD19  ed019c                 loc_FFF2CD19 mov.l   274h+var_4[sp], r1
FFF2CD1C  05df69ff                          bsr.a   sub_FFF236FB
FFF2CD20  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CD23  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CD26  6101                              cmp     #0, r1
FFF2CD28  2010                              beq.b   loc_FFF2CD38
FFF2CD2A  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CD2D  6602                              mov.l   #0, r2
FFF2CD2F  05f120ff                          bsr.a   sub_FFF1EE20
FFF2CD33  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CD35  387501                            bra.w   loc_FFF2CEAA
FFF2CD38  ed029c                 loc_FFF2CD38 mov.l   274h+var_4[sp], r2
FFF2CD3B  ed019b                            mov.l   274h+var_8[sp], r1
FFF2CD3E  72110c10                          add     #100Ch, r1, r1
FFF2CD42  05031f00                          bsr.a   sub_FFF2EC45
FFF2CD46  ed019b                            mov.l   274h+var_8[sp], r1
FFF2CD49  72110c10                          add     #100Ch, r1, r1
FFF2CD4D  05cf68ff                          bsr.a   sub_FFF2361C
FFF2CD51  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CD54  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CD57  6101                              cmp     #0, r1
FFF2CD59  2010                              beq.b   loc_FFF2CD69
FFF2CD5B  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CD5E  6602                              mov.l   #0, r2
FFF2CD60  05c020ff                          bsr.a   sub_FFF1EE20
FFF2CD64  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CD66  384401                            bra.w   loc_FFF2CEAA
FFF2CD69  ed019b                 loc_FFF2CD69 mov.l   274h+var_8[sp], r1
FFF2CD6C  ce110c10                          mov.b   100Ch[r1], r1
FFF2CD70  051b1a00                          bsr.a   sub_FFF2E78B
FFF2CD74  8289                              mov.b   r1, 274h+var_269[sp]
FFF2CD76  b289                              movu.b  274h+var_269[sp], r1
FFF2CD78  71020c                            add     #274h+var_268, sp, r2
FFF2CD7B  05a421ff                          bsr.a   sub_FFF1EF1F
FFF2CD7F  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CD82  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CD85  6101                              cmp     #0, r1
FFF2CD87  2010                              beq.b   loc_FFF2CD97
FFF2CD89  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CD8C  6602                              mov.l   #0, r2
FFF2CD8E  059220ff                          bsr.a   sub_FFF1EE20
FFF2CD92  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CD94  381601                            bra.w   loc_FFF2CEAA
FFF2CD97  3c8800                 loc_FFF2CD97 mov.b   #0, 274h+var_25C[sp]
FFF2CD9A  ed039b                            mov.l   274h+var_8[sp], r3
FFF2CD9D  72310c10                          add     #100Ch, r3, r1
FFF2CDA1  710214                            add     #274h+var_260, sp, r2
FFF2CDA4  393505                            bsr.w   sub_FFF2D2D9
FFF2CDA7  e70198                            mov.l   r1, 274h+var_14[sp]
FFF2CDAA  ed0198                            mov.l   274h+var_14[sp], r1
FFF2CDAD  6101                              cmp     #0, r1
FFF2CDAF  2117                              bne.b   loc_FFF2CDC6
FFF2CDB1  05288ffe                          bsr.a   sub_FFF15CD9
FFF2CDB5  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CDB8  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CDBB  6602                              mov.l   #0, r2
FFF2CDBD  056320ff                          bsr.a   sub_FFF1EE20
FFF2CDC1  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CDC3  38e700                            bra.w   loc_FFF2CEAA
FFF2CDC6  ed029b                 loc_FFF2CDC6 mov.l   274h+var_8[sp], r2
FFF2CDC9  ed0198                            mov.l   274h+var_14[sp], r1
FFF2CDCC  39c009                            bsr.w   sub_FFF2D78C
FFF2CDCF  a101                              mov.l   r1, 274h+var_264[sp]
FFF2CDD1  a901                              mov.l   274h+var_264[sp], r1
FFF2CDD3  6101                              cmp     #0, r1
FFF2CDD5  2010                              beq.b   loc_FFF2CDE5
FFF2CDD7  6602                              mov.l   #0, r2
FFF2CDD9  fb16ec                            mov.l   #-14h, r1
FFF2CDDC  054420ff                          bsr.a   sub_FFF1EE20
FFF2CDE0  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CDE2  38c800                            bra.w   loc_FFF2CEAA
FFF2CDE5  a889                   loc_FFF2CDE5 mov.l   274h+var_268[sp], r1
FFF2CDE7  591e6c                            movu.b  6Ch[r1], r14
FFF2CDEA  641e                              and     #1, r14
FFF2CDEC  611e                              cmp     #1, r14
FFF2CDEE  200e                              beq.b   loc_FFF2CDFC
FFF2CDF0  a889                              mov.l   274h+var_268[sp], r1
FFF2CDF2  591e6c                            movu.b  6Ch[r1], r14
FFF2CDF5  752e10                            and     #10h, r14
FFF2CDF8  755e10                            cmp     #10h, r14
FFF2CDFB  1d                                bne.s   loc_FFF2CE00
FFF2CDFC  f80601                 loc_FFF2CDFC mov.l   #1, 274h+var_274[sp]
FFF2CDFF  0c                                bra.s   loc_FFF2CE03
FFF2CE00  f80600                 loc_FFF2CE00 mov.l   #0, 274h+var_274[sp]
FFF2CE03  ec01                   loc_FFF2CE03 mov.l   274h+var_274[sp], r1
FFF2CE05  6101                              cmp     #0, r1
FFF2CE07  2035                              beq.b   loc_FFF2CE3C
FFF2CE09  a889                              mov.l   274h+var_268[sp], r1
FFF2CE0B  05d88ffe                          bsr.a   sub_FFF15DE3
FFF2CE0F  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CE12  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CE15  6101                              cmp     #0, r1
FFF2CE17  2010                              beq.b   loc_FFF2CE27
FFF2CE19  6602                              mov.l   #0, r2
FFF2CE1B  fb16c1                            mov.l   #-3Fh, r1
FFF2CE1E  050220ff                          bsr.a   sub_FFF1EE20
FFF2CE22  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CE24  388600                            bra.w   loc_FFF2CEAA
FFF2CE27  ed029b                 loc_FFF2CE27 mov.l   274h+var_8[sp], r2
FFF2CE2A  72210c10                          add     #100Ch, r2, r1
FFF2CE2E  398300                            bsr.w   sub_FFF2CEB1
FFF2CE31  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CE34  a889                              mov.l   274h+var_268[sp], r1
FFF2CE36  05b88ffe                          bsr.a   sub_FFF15DEE
FFF2CE3A  2e0f                              bra.b   loc_FFF2CE49
FFF2CE3C  ed029b                 loc_FFF2CE3C mov.l   274h+var_8[sp], r2
FFF2CE3F  72210c10                          add     #100Ch, r2, r1
FFF2CE43  396e00                            bsr.w   sub_FFF2CEB1
FFF2CE46  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CE49  ed0199                 loc_FFF2CE49 mov.l   274h+var_10[sp], r1
FFF2CE4C  6101                              cmp     #0, r1
FFF2CE4E  200f                              beq.b   loc_FFF2CE5D
FFF2CE50  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CE53  6602                              mov.l   #0, r2
FFF2CE55  05cb1fff                          bsr.a   sub_FFF1EE20
FFF2CE59  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CE5B  2e4f                              bra.b   loc_FFF2CEAA
FFF2CE5D  a889                   loc_FFF2CE5D mov.l   274h+var_268[sp], r1
FFF2CE5F  057dfdfe                          bsr.a   sub_FFF1CBDC
FFF2CE63  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CE66  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CE69  6101                              cmp     #0, r1
FFF2CE6B  200f                              beq.b   loc_FFF2CE7A
FFF2CE6D  ed0199                            mov.l   274h+var_10[sp], r1
FFF2CE70  6602                              mov.l   #0, r2
FFF2CE72  05ae1fff                          bsr.a   sub_FFF1EE20
FFF2CE76  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CE78  2e32                              bra.b   loc_FFF2CEAA
FFF2CE7A  a889                   loc_FFF2CE7A mov.l   274h+var_268[sp], r1
FFF2CE7C  591e6c                            movu.b  6Ch[r1], r14
FFF2CE7F  752e10                            and     #10h, r14
FFF2CE82  755e10                            cmp     #10h, r14
FFF2CE85  211a                              bne.b   loc_FFF2CE9F
FFF2CE87  ed049b                            mov.l   274h+var_8[sp], r4
FFF2CE8A  5a433216                          movu.b  1632h[r4], r3
FFF2CE8E  5a423116                          movu.b  1631h[r4], r2
FFF2CE92  a889                              mov.l   274h+var_268[sp], r1
FFF2CE94  72440c06                          add     #60Ch, r4, r4
FFF2CE98  05c495ff                          bsr.a   sub_FFF2645C
FFF2CE9C  e70199                            mov.l   r1, 274h+var_10[sp]
FFF2CE9F  ed0199                 loc_FFF2CE9F mov.l   274h+var_10[sp], r1
FFF2CEA2  6602                              mov.l   #0, r2
FFF2CEA4  057c1fff                          bsr.a   sub_FFF1EE20
FFF2CEA8  a009                              mov.l   r1, 274h+var_270[sp]
FFF2CEAA  a809                   loc_FFF2CEAA mov.l   274h+var_270[sp], r1
FFF2CEAC  e7019a                            mov.l   r1, 274h+var_C[sp]
FFF2CEAF  679d                              rtsd    #-63h
FFF2CEB1  7100ac                 sub_FFF2CEB1 add     #-54h, sp, sp   ; <<<< FUNC sub_FFF2CEB1
FFF2CEB4  a501                              mov.l   r1, 54h+var_4[sp]
FFF2CEB6  a48a                              mov.l   r2, 54h+var_8[sp]
FFF2CEB8  3e0f00                            mov.l   #0, 54h+var_18[sp]
FFF2CEBB  3e0e00                            mov.l   #0, 54h+var_1C[sp]
FFF2CEBE  3e0d00                            mov.l   #0, 54h+var_20[sp]
FFF2CEC1  3e0c00                            mov.l   #0, 54h+var_24[sp]
FFF2CEC4  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2CECA  e4e003                            mov.l   [r14], 54h+var_48[sp]
FFF2CECD  ac89                              mov.l   54h+var_8[sp], r1
FFF2CECF  fa14301600                        mov.b   #0, 1630h[r1]
FFF2CED4  ad01                              mov.l   54h+var_4[sp], r1
FFF2CED6  cc11                              mov.b   [r1], r1
FFF2CED8  05b31800                          bsr.a   sub_FFF2E78B
FFF2CEDC  8289                              mov.b   r1, 54h+var_49[sp]
FFF2CEDE  b289                              movu.b  54h+var_49[sp], r1
FFF2CEE0  71020c                            add     #54h+var_48, sp, r2
FFF2CEE3  053c20ff                          bsr.a   sub_FFF1EF1F
FFF2CEE7  a409                              mov.l   r1, 54h+var_10[sp]
FFF2CEE9  ac09                              mov.l   54h+var_10[sp], r1
FFF2CEEB  6101                              cmp     #0, r1
FFF2CEED  10                                beq.s   loc_FFF2CEF5
FFF2CEEE  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2CEF2  385f02                            bra.w   loc_FFF2D151
FFF2CEF5  a889                   loc_FFF2CEF5 mov.l   54h+var_48[sp], r1
FFF2CEF7  056620ff                          bsr.a   sub_FFF1EF5D
FFF2CEFB  a409                              mov.l   r1, 54h+var_10[sp]
FFF2CEFD  ac09                              mov.l   54h+var_10[sp], r1
FFF2CEFF  6101                              cmp     #0, r1
FFF2CF01  10                                beq.s   loc_FFF2CF09
FFF2CF02  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2CF06  384b02                            bra.w   loc_FFF2D151
FFF2CF09  a889                   loc_FFF2CF09 mov.l   54h+var_48[sp], r1
FFF2CF0B  058620ff                          bsr.a   sub_FFF1EF91
FFF2CF0F  a409                              mov.l   r1, 54h+var_10[sp]
FFF2CF11  ac09                              mov.l   54h+var_10[sp], r1
FFF2CF13  6101                              cmp     #0, r1
FFF2CF15  10                                beq.s   loc_FFF2CF1D
FFF2CF16  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2CF1A  383702                            bra.w   loc_FFF2D151
FFF2CF1D  ad01                   loc_FFF2CF1D mov.l   54h+var_4[sp], r1
FFF2CF1F  6241                              add     #4, r1
FFF2CF21  a401                              mov.l   r1, 54h+var_14[sp]
FFF2CF23  a889                              mov.l   54h+var_48[sp], r1
FFF2CF25  e5100d0d                          mov.l   34h[r1], 54h+var_20[sp]
FFF2CF29  a889                              mov.l   54h+var_48[sp], r1
FFF2CF2B  8c11                              mov.b   10h[r1], r1
FFF2CF2D  755120                            cmp     #20h, r1 ; ' '
FFF2CF30  3afe00                            beq.w   loc_FFF2D02E
FFF2CF33  ac8a                              mov.l   54h+var_8[sp], r2
FFF2CF35  ac01                              mov.l   54h+var_14[sp], r1
FFF2CF37  05dc64ff                          bsr.a   sub_FFF23413
FFF2CF3B  a401                              mov.l   r1, 54h+var_14[sp]
FFF2CF3D  ac01                              mov.l   54h+var_14[sp], r1
FFF2CF3F  6101                              cmp     #0, r1
FFF2CF41  18                                bne.s   loc_FFF2CF49
FFF2CF42  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2CF46  380b02                            bra.w   loc_FFF2D151
FFF2CF49  ac89                   loc_FFF2CF49 mov.l   54h+var_8[sp], r1
FFF2CF4B  cc1e                              mov.b   [r1], r14
FFF2CF4D  610e                              cmp     #0, r14
FFF2CF4F  210d                              bne.b   loc_FFF2CF5C
FFF2CF51  ac89                              mov.l   54h+var_8[sp], r1
FFF2CF53  8819                              mov.b   1[r1], r1
FFF2CF55  6101                              cmp     #0, r1
FFF2CF57  1d                                bne.s   loc_FFF2CF5C
FFF2CF58  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2CF5B  0c                                bra.s   loc_FFF2CF5F
FFF2CF5C  f80600                 loc_FFF2CF5C mov.l   #0, 54h+var_54[sp]
FFF2CF5F  ec01                   loc_FFF2CF5F mov.l   54h+var_54[sp], r1
FFF2CF61  6101                              cmp     #0, r1
FFF2CF63  10                                beq.s   loc_FFF2CF6B
FFF2CF64  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2CF68  38e901                            bra.w   loc_FFF2D151
FFF2CF6B  ac8a                   loc_FFF2CF6B mov.l   54h+var_8[sp], r2
FFF2CF6D  a889                              mov.l   54h+var_48[sp], r1
FFF2CF6F  60c0                              sub     #0Ch, sp
FFF2CF71  a082                              mov.l   r2, 60h+var_58[sp]
FFF2CF73  710348                            add     #60h+var_18, sp, r3
FFF2CF76  a00b                              mov.l   r3, 60h+var_5C[sp]
FFF2CF78  f80400                            mov.b   #0, 60h+var_60[sp]
FFF2CF7B  6604                              mov.l   #0, r4
FFF2CF7D  71031c                            add     #60h+var_44, sp, r3
FFF2CF80  05f256ff                          bsr.a   sub_FFF22672
FFF2CF84  62c0                              add     #0Ch, sp
FFF2CF86  a409                              mov.l   r1, 54h+var_10[sp]
FFF2CF88  ac09                              mov.l   54h+var_10[sp], r1
FFF2CF8A  6101                              cmp     #0, r1
FFF2CF8C  10                                beq.s   loc_FFF2CF94
FFF2CF8D  f90601fc                          mov.l   #-4, 54h+var_50[sp]
FFF2CF91  38c001                            bra.w   loc_FFF2D151
FFF2CF94  a889                   loc_FFF2CF94 mov.l   54h+var_48[sp], r1
FFF2CF96  8c12                              mov.b   10h[r1], r2
FFF2CF98  710110                            add     #54h+var_44, sp, r1
FFF2CF9B  05fd36ff                          bsr.a   sub_FFF20698
FFF2CF9F  a309                              mov.l   r1, 54h+var_20[sp]
FFF2CFA1  ac89                              mov.l   54h+var_8[sp], r1
FFF2CFA3  fa14301601                        mov.b   #1, 1630h[r1]
FFF2CFA8  388600                            bra.w   loc_FFF2D02E
FFF2CFAB  ac8a                   loc_FFF2CFAB mov.l   54h+var_8[sp], r2
FFF2CFAD  ac01                              mov.l   54h+var_14[sp], r1
FFF2CFAF  056464ff                          bsr.a   sub_FFF23413
FFF2CFB3  a401                              mov.l   r1, 54h+var_14[sp]
FFF2CFB5  ac01                              mov.l   54h+var_14[sp], r1
FFF2CFB7  6101                              cmp     #0, r1
FFF2CFB9  18                                bne.s   loc_FFF2CFC1
FFF2CFBA  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2CFBE  389301                            bra.w   loc_FFF2D151
FFF2CFC1  ac89                   loc_FFF2CFC1 mov.l   54h+var_8[sp], r1
FFF2CFC3  cc1e                              mov.b   [r1], r14
FFF2CFC5  610e                              cmp     #0, r14
FFF2CFC7  210d                              bne.b   loc_FFF2CFD4
FFF2CFC9  ac89                              mov.l   54h+var_8[sp], r1
FFF2CFCB  8819                              mov.b   1[r1], r1
FFF2CFCD  6101                              cmp     #0, r1
FFF2CFCF  1d                                bne.s   loc_FFF2CFD4
FFF2CFD0  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2CFD3  0c                                bra.s   loc_FFF2CFD7
FFF2CFD4  f80600                 loc_FFF2CFD4 mov.l   #0, 54h+var_54[sp]
FFF2CFD7  ec01                   loc_FFF2CFD7 mov.l   54h+var_54[sp], r1
FFF2CFD9  6101                              cmp     #0, r1
FFF2CFDB  10                                beq.s   loc_FFF2CFE3
FFF2CFDC  f90601ff                          mov.l   #-1, 54h+var_50[sp]
FFF2CFE0  387101                            bra.w   loc_FFF2D151
FFF2CFE3  e5000d0c               loc_FFF2CFE3 mov.l   54h+var_20[sp], 54h+var_24[sp]
FFF2CFE7  ac8b                              mov.l   54h+var_8[sp], r3
FFF2CFE9  ab0a                              mov.l   54h+var_20[sp], r2
FFF2CFEB  a889                              mov.l   54h+var_48[sp], r1
FFF2CFED  7100f0                            add     #-10h, sp, sp
FFF2CFF0  a08b                              mov.l   r3, 64h+var_58[sp]
FFF2CFF2  710448                            add     #64h+var_1C, sp, r4
FFF2CFF5  a084                              mov.l   r4, 64h+var_5C[sp]
FFF2CFF7  71044c                            add     #64h+var_18, sp, r4
FFF2CFFA  a00c                              mov.l   r4, 64h+var_60[sp]
FFF2CFFC  3c0100                            mov.b   #0, 64h+var_63[sp]
FFF2CFFF  f80400                            mov.b   #0, 64h+var_64[sp]
FFF2D002  710420                            add     #64h+var_44, sp, r4
FFF2D005  05c85aff                          bsr.a   sub_FFF22ACD
FFF2D009  710010                            add     #10h, sp, sp
FFF2D00C  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D00E  ac09                              mov.l   54h+var_10[sp], r1
FFF2D010  6101                              cmp     #0, r1
FFF2D012  10                                beq.s   loc_FFF2D01A
FFF2D013  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2D017  383a01                            bra.w   loc_FFF2D151
FFF2D01A  a889                   loc_FFF2D01A mov.l   54h+var_48[sp], r1
FFF2D01C  8c12                              mov.b   10h[r1], r2
FFF2D01E  710110                            add     #54h+var_44, sp, r1
FFF2D021  057736ff                          bsr.a   sub_FFF20698
FFF2D025  a309                              mov.l   r1, 54h+var_20[sp]
FFF2D027  ac89                              mov.l   54h+var_8[sp], r1
FFF2D029  fa14301601                        mov.b   #1, 1630h[r1]
FFF2D02E  ac01                   loc_FFF2D02E mov.l   54h+var_14[sp], r1
FFF2D030  cc1e                              mov.b   [r1], r14
FFF2D032  610e                              cmp     #0, r14
FFF2D034  3b77ff                            bne.w   loc_FFF2CFAB
FFF2D037  a889                              mov.l   54h+var_48[sp], r1
FFF2D039  8c12                              mov.b   10h[r1], r2
FFF2D03B  710110                            add     #54h+var_44, sp, r1
FFF2D03E  055a36ff                          bsr.a   sub_FFF20698
FFF2D042  a309                              mov.l   r1, 54h+var_20[sp]
FFF2D044  ac89                              mov.l   54h+var_8[sp], r1
FFF2D046  5a1e3016                          movu.b  1630h[r1], r14
FFF2D04A  611e                              cmp     #1, r14
FFF2D04C  2112                              bne.b   loc_FFF2D05E
FFF2D04E  a889                              mov.l   54h+var_48[sp], r1
FFF2D050  591e6c                            movu.b  6Ch[r1], r14
FFF2D053  752e10                            and     #10h, r14
FFF2D056  755e10                            cmp     #10h, r14
FFF2D059  1d                                bne.s   loc_FFF2D05E
FFF2D05A  f80601                            mov.l   #1, 54h+var_54[sp]
FFF2D05D  0c                                bra.s   loc_FFF2D061
FFF2D05E  f80600                 loc_FFF2D05E mov.l   #0, 54h+var_54[sp]
FFF2D061  ec01                   loc_FFF2D061 mov.l   54h+var_54[sp], r1
FFF2D063  6101                              cmp     #0, r1
FFF2D065  2072                              beq.b   loc_FFF2D0D7
FFF2D067  ac8a                              mov.l   54h+var_8[sp], r2
FFF2D069  ad01                              mov.l   54h+var_4[sp], r1
FFF2D06B  72220c06                          add     #60Ch, r2, r2
FFF2D06F  05d59bff                          bsr.a   sub_FFF26C44
FFF2D073  8281                              mov.b   r1, 54h+var_4A[sp]
FFF2D075  ac8b                              mov.l   54h+var_8[sp], r3
FFF2D077  a889                              mov.l   54h+var_48[sp], r1
FFF2D079  72320c06                          add     #60Ch, r3, r2
FFF2D07D  050c92ff                          bsr.a   sub_FFF26289
FFF2D081  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D083  ac09                              mov.l   54h+var_10[sp], r1
FFF2D085  6101                              cmp     #0, r1
FFF2D087  2130                              bne.b   loc_FFF2D0B7
FFF2D089  ac8a                              mov.l   54h+var_8[sp], r2
FFF2D08B  b285                              movu.b  54h+var_4A[sp], r5
FFF2D08D  ab8c                              mov.l   54h+var_18[sp], r4
FFF2D08F  ab83                              mov.l   54h+var_1C[sp], r3
FFF2D091  a889                              mov.l   54h+var_48[sp], r1
FFF2D093  60c0                              sub     #0Ch, sp
FFF2D095  a082                              mov.l   r2, 60h+var_58[sp]
FFF2D097  72220c06                          add     #60Ch, r2, r2
FFF2D09B  a00a                              mov.l   r2, 60h+var_5C[sp]
FFF2D09D  c305                              mov.b   r5, 60h+var_60[sp]
FFF2D09F  71021c                            add     #60h+var_44, sp, r2
FFF2D0A2  05a492ff                          bsr.a   sub_FFF26346
FFF2D0A6  62c0                              add     #0Ch, sp
FFF2D0A8  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D0AA  ac09                              mov.l   54h+var_10[sp], r1
FFF2D0AC  6101                              cmp     #0, r1
FFF2D0AE  2029                              beq.b   loc_FFF2D0D7
FFF2D0B0  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2D0B4  389d00                            bra.w   loc_FFF2D151
FFF2D0B7  ac09                   loc_FFF2D0B7 mov.l   54h+var_10[sp], r1
FFF2D0B9  7601d3fe                          cmp     #-12Dh, r1
FFF2D0BD  10                                beq.s   loc_FFF2D0C5
FFF2D0BE  ac09                              mov.l   54h+var_10[sp], r1
FFF2D0C0  7601d4fe                          cmp     #-12Ch, r1
FFF2D0C4  1d                                bne.s   loc_FFF2D0C9
FFF2D0C5  f80601                 loc_FFF2D0C5 mov.l   #1, 54h+var_54[sp]
FFF2D0C8  0c                                bra.s   loc_FFF2D0CC
FFF2D0C9  f80600                 loc_FFF2D0C9 mov.l   #0, 54h+var_54[sp]
FFF2D0CC  ec01                   loc_FFF2D0CC mov.l   54h+var_54[sp], r1
FFF2D0CE  6101                              cmp     #0, r1
FFF2D0D0  1f                                bne.s   loc_FFF2D0D7
FFF2D0D1  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2D0D5  2e7c                              bra.b   loc_FFF2D151
FFF2D0D7  ab01                   loc_FFF2D0D7 mov.l   54h+var_24[sp], r1
FFF2D0D9  6101                              cmp     #0, r1
FFF2D0DB  a889                              mov.l   54h+var_48[sp], r1
FFF2D0DD  2029                              beq.b   loc_FFF2D106
FFF2D0DF  ac8b                              mov.l   54h+var_8[sp], r3
FFF2D0E1  ab02                              mov.l   54h+var_24[sp], r2
FFF2D0E3  7100f0                            add     #-10h, sp, sp
FFF2D0E6  a08b                              mov.l   r3, 64h+var_58[sp]
FFF2D0E8  710448                            add     #64h+var_1C, sp, r4
FFF2D0EB  a084                              mov.l   r4, 64h+var_5C[sp]
FFF2D0ED  71044c                            add     #64h+var_18, sp, r4
FFF2D0F0  a00c                              mov.l   r4, 64h+var_60[sp]
FFF2D0F2  3c0100                            mov.b   #0, 64h+var_63[sp]
FFF2D0F5  f80402                            mov.b   #2, 64h+var_64[sp]
FFF2D0F8  710420                            add     #64h+var_44, sp, r4
FFF2D0FB  05d259ff                          bsr.a   sub_FFF22ACD
FFF2D0FF  710010                            add     #10h, sp, sp
FFF2D102  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D104  2e1d                              bra.b   loc_FFF2D121
FFF2D106  ac8a                   loc_FFF2D106 mov.l   54h+var_8[sp], r2
FFF2D108  60c0                              sub     #0Ch, sp
FFF2D10A  a082                              mov.l   r2, 60h+var_58[sp]
FFF2D10C  710348                            add     #60h+var_18, sp, r3
FFF2D10F  a00b                              mov.l   r3, 60h+var_5C[sp]
FFF2D111  f80400                            mov.b   #0, 60h+var_60[sp]
FFF2D114  6624                              mov.l   #2, r4
FFF2D116  71031c                            add     #60h+var_44, sp, r3
FFF2D119  055955ff                          bsr.a   sub_FFF22672
FFF2D11D  62c0                              add     #0Ch, sp
FFF2D11F  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D121  ac09                   loc_FFF2D121 mov.l   54h+var_10[sp], r1
FFF2D123  6101                              cmp     #0, r1
FFF2D125  17                                beq.s   loc_FFF2D12C
FFF2D126  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2D12A  2e27                              bra.b   loc_FFF2D151
FFF2D12C  ac8b                   loc_FFF2D12C mov.l   54h+var_8[sp], r3
FFF2D12E  ab0a                              mov.l   54h+var_20[sp], r2
FFF2D130  a889                              mov.l   54h+var_48[sp], r1
FFF2D132  051171ff                          bsr.a   sub_FFF24243
FFF2D136  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D138  ac09                              mov.l   54h+var_10[sp], r1
FFF2D13A  6101                              cmp     #0, r1
FFF2D13C  17                                beq.s   loc_FFF2D143
FFF2D13D  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2D141  2e10                              bra.b   loc_FFF2D151
FFF2D143  ac8a                   loc_FFF2D143 mov.l   54h+var_8[sp], r2
FFF2D145  a889                              mov.l   54h+var_48[sp], r1
FFF2D147  05db77ff                          bsr.a   sub_FFF24922
FFF2D14B  a409                              mov.l   r1, 54h+var_10[sp]
FFF2D14D  e5001101                          mov.l   54h+var_10[sp], 54h+var_50[sp]
FFF2D151  a809                   loc_FFF2D151 mov.l   54h+var_50[sp], r1
FFF2D153  a481                              mov.l   r1, 54h+var_C[sp]
FFF2D155  6715                              rtsd    #15h
FFF2D157  7100ec                 sub_FFF2D157 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2D157
FFF2D15A  a101                              mov.l   r1, 14h+var_4[sp]
FFF2D15C  053a8dfe                          bsr.a   sub_FFF15E96
FFF2D160  a009                              mov.l   r1, 14h+var_10[sp]
FFF2D162  a809                              mov.l   14h+var_10[sp], r1
FFF2D164  6101                              cmp     #0, r1
FFF2D166  210f                              bne.b   loc_FFF2D175
FFF2D168  6602                              mov.l   #0, r2
FFF2D16A  fb16e1                            mov.l   #-1Fh, r1
FFF2D16D  050e1dff                          bsr.a   sub_FFF1EE7B
FFF2D171  e301                              mov.l   r1, 14h+var_14[sp]
FFF2D173  2e14                              bra.b   loc_FFF2D187
FFF2D175  a80a                   loc_FFF2D175 mov.l   14h+var_10[sp], r2
FFF2D177  a901                              mov.l   14h+var_4[sp], r1
FFF2D179  391400                            bsr.w   sub_FFF2D18D
FFF2D17C  a081                              mov.l   r1, 14h+var_C[sp]
FFF2D17E  a809                              mov.l   14h+var_10[sp], r1
FFF2D180  05268dfe                          bsr.a   sub_FFF15EA6
FFF2D184  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2D187  ec01                   loc_FFF2D187 mov.l   14h+var_14[sp], r1
FFF2D189  a089                              mov.l   r1, 14h+var_8[sp]
FFF2D18B  6705                              rtsd    #5
FFF2D18D  7100e0                 sub_FFF2D18D add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2D18D
FFF2D190  a189                              mov.l   r1, 20h+var_4[sp]
FFF2D192  a182                              mov.l   r2, 20h+var_8[sp]
FFF2D194  05577eff                          bsr.a   sub_FFF24FEB
FFF2D198  a101                              mov.l   r1, 20h+var_10[sp]
FFF2D19A  a901                              mov.l   20h+var_10[sp], r1
FFF2D19C  6101                              cmp     #0, r1
FFF2D19E  200f                              beq.b   loc_FFF2D1AD
FFF2D1A0  a901                              mov.l   20h+var_10[sp], r1
FFF2D1A2  6602                              mov.l   #0, r2
FFF2D1A4  05d71cff                          bsr.a   sub_FFF1EE7B
FFF2D1A8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D1AA  382901                            bra.w   loc_FFF2D2D3
FFF2D1AD  a989                   loc_FFF2D1AD mov.l   20h+var_4[sp], r1
FFF2D1AF  6101                              cmp     #0, r1
FFF2D1B1  2110                              bne.b   loc_FFF2D1C1
FFF2D1B3  6602                              mov.l   #0, r2
FFF2D1B5  fb16ff                            mov.l   #-1, r1
FFF2D1B8  05c31cff                          bsr.a   sub_FFF1EE7B
FFF2D1BC  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D1BE  381501                            bra.w   loc_FFF2D2D3
FFF2D1C1  a989                   loc_FFF2D1C1 mov.l   20h+var_4[sp], r1
FFF2D1C3  053865ff                          bsr.a   sub_FFF236FB
FFF2D1C7  a101                              mov.l   r1, 20h+var_10[sp]
FFF2D1C9  a901                              mov.l   20h+var_10[sp], r1
FFF2D1CB  6101                              cmp     #0, r1
FFF2D1CD  200f                              beq.b   loc_FFF2D1DC
FFF2D1CF  a901                              mov.l   20h+var_10[sp], r1
FFF2D1D1  6602                              mov.l   #0, r2
FFF2D1D3  05a81cff                          bsr.a   sub_FFF1EE7B
FFF2D1D7  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D1D9  38fa00                            bra.w   loc_FFF2D2D3
FFF2D1DC  a98a                   loc_FFF2D1DC mov.l   20h+var_4[sp], r2
FFF2D1DE  a981                              mov.l   20h+var_8[sp], r1
FFF2D1E0  72110c10                          add     #100Ch, r1, r1
FFF2D1E4  05611a00                          bsr.a   sub_FFF2EC45
FFF2D1E8  a981                              mov.l   20h+var_8[sp], r1
FFF2D1EA  72110c10                          add     #100Ch, r1, r1
FFF2D1EE  05551400                          bsr.a   sub_FFF2E643
FFF2D1F2  a081                              mov.l   r1, 20h+var_18[sp]
FFF2D1F4  a881                              mov.l   20h+var_18[sp], r1
FFF2D1F6  6121                              cmp     #2, r1
FFF2D1F8  2133                              bne.b   loc_FFF2D22B
FFF2D1FA  a981                              mov.l   20h+var_8[sp], r1
FFF2D1FC  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2D200  755e2f                            cmp     #2Fh, r14 ; '/'
FFF2D203  2010                              beq.b   loc_FFF2D213
FFF2D205  a981                              mov.l   20h+var_8[sp], r1
FFF2D207  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2D20B  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2D20E  15                                beq.s   loc_FFF2D213
FFF2D20F  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2D212  0c                                bra.s   loc_FFF2D216
FFF2D213  f80600                 loc_FFF2D213 mov.l   #0, 20h+var_20[sp]
FFF2D216  ec01                   loc_FFF2D216 mov.l   20h+var_20[sp], r1
FFF2D218  6101                              cmp     #0, r1
FFF2D21A  3aa800                            beq.w   loc_FFF2D2C2
FFF2D21D  6602                              mov.l   #0, r2
FFF2D21F  fb16f4                            mov.l   #-0Ch, r1
FFF2D222  05591cff                          bsr.a   sub_FFF1EE7B
FFF2D226  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D228  38ab00                            bra.w   loc_FFF2D2D3
FFF2D22B  a981                   loc_FFF2D22B mov.l   20h+var_8[sp], r1
FFF2D22D  72110c10                          add     #100Ch, r1, r1
FFF2D231  a882                              mov.l   20h+var_18[sp], r2
FFF2D233  6142                              cmp     #4, r2
FFF2D235  2175                              bne.b   loc_FFF2D2AA
FFF2D237  cc1e                              mov.b   [r1], r14
FFF2D239  755e41                            cmp     #41h, r14 ; 'A'
FFF2D23C  290d                              blt.b   loc_FFF2D249
FFF2D23E  a981                              mov.l   20h+var_8[sp], r1
FFF2D240  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2D244  755e5b                            cmp     #5Bh, r14 ; '['
FFF2D247  2906                              blt.b   loc_FFF2D24D
FFF2D249  f80601                 loc_FFF2D249 mov.l   #1, 20h+var_20[sp]
FFF2D24C  0c                                bra.s   loc_FFF2D250
FFF2D24D  f80600                 loc_FFF2D24D mov.l   #0, 20h+var_20[sp]
FFF2D250  ec01                   loc_FFF2D250 mov.l   20h+var_20[sp], r1
FFF2D252  6101                              cmp     #0, r1
FFF2D254  2028                              beq.b   loc_FFF2D27C
FFF2D256  a981                              mov.l   20h+var_8[sp], r1
FFF2D258  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2D25C  755e61                            cmp     #61h, r14 ; 'a'
FFF2D25F  290d                              blt.b   loc_FFF2D26C
FFF2D261  a981                              mov.l   20h+var_8[sp], r1
FFF2D263  ce1e0c10                          mov.b   100Ch[r1], r14
FFF2D267  755e7b                            cmp     #7Bh, r14 ; '{'
FFF2D26A  2906                              blt.b   loc_FFF2D270
FFF2D26C  f80601                 loc_FFF2D26C mov.l   #1, 20h+var_20[sp]
FFF2D26F  0c                                bra.s   loc_FFF2D273
FFF2D270  f80600                 loc_FFF2D270 mov.l   #0, 20h+var_20[sp]
FFF2D273  ec01                   loc_FFF2D273 mov.l   20h+var_20[sp], r1
FFF2D275  6101                              cmp     #0, r1
FFF2D277  15                                beq.s   loc_FFF2D27C
FFF2D278  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2D27B  0c                                bra.s   loc_FFF2D27F
FFF2D27C  f80600                 loc_FFF2D27C mov.l   #0, 20h+var_20[sp]
FFF2D27F  ec01                   loc_FFF2D27F mov.l   20h+var_20[sp], r1
FFF2D281  6101                              cmp     #0, r1
FFF2D283  200f                              beq.b   loc_FFF2D292
FFF2D285  6602                              mov.l   #0, r2
FFF2D287  fb16f4                            mov.l   #-0Ch, r1
FFF2D28A  05f11bff                          bsr.a   sub_FFF1EE7B
FFF2D28E  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D290  2e43                              bra.b   loc_FFF2D2D3
FFF2D292  a981                   loc_FFF2D292 mov.l   20h+var_8[sp], r1
FFF2D294  ce1e0e10                          mov.b   100Eh[r1], r14
FFF2D298  755e3a                            cmp     #3Ah, r14 ; ':'
FFF2D29B  2027                              beq.b   loc_FFF2D2C2
FFF2D29D  6602                              mov.l   #0, r2
FFF2D29F  fb16ff                            mov.l   #-1, r1
FFF2D2A2  05d91bff                          bsr.a   sub_FFF1EE7B
FFF2D2A6  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D2A8  2e2b                              bra.b   loc_FFF2D2D3
FFF2D2AA  057263ff               loc_FFF2D2AA bsr.a   sub_FFF2361C
FFF2D2AE  a101                              mov.l   r1, 20h+var_10[sp]
FFF2D2B0  a901                              mov.l   20h+var_10[sp], r1
FFF2D2B2  6101                              cmp     #0, r1
FFF2D2B4  200e                              beq.b   loc_FFF2D2C2
FFF2D2B6  a901                              mov.l   20h+var_10[sp], r1
FFF2D2B8  6602                              mov.l   #0, r2
FFF2D2BA  05c11bff                          bsr.a   sub_FFF1EE7B
FFF2D2BE  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2D2C0  2e13                              bra.b   loc_FFF2D2D3
FFF2D2C2  a983                   loc_FFF2D2C2 mov.l   20h+var_8[sp], r3
FFF2D2C4  72310c10                          add     #100Ch, r3, r1
FFF2D2C8  6602                              mov.l   #0, r2
FFF2D2CA  390f00                            bsr.w   sub_FFF2D2D9
FFF2D2CD  a089                              mov.l   r1, 20h+var_14[sp]
FFF2D2CF  e5000301                          mov.l   20h+var_14[sp], 20h+var_1C[sp]
FFF2D2D3  a809                   loc_FFF2D2D3 mov.l   20h+var_1C[sp], r1
FFF2D2D5  a109                              mov.l   r1, 20h+var_C[sp]
FFF2D2D7  6708                              rtsd    #8
FFF2D2D9  7100d4                 sub_FFF2D2D9 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF2D2D9
FFF2D2DC  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF2D2DE  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF2D2E0  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF2D2E2  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2D2E8  e4e003                            mov.l   [r14], 2Ch+var_20[sp]
FFF2D2EB  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2D2ED  cc1e                              mov.b   [r1], r14
FFF2D2EF  755e2f                            cmp     #2Fh, r14 ; '/'
FFF2D2F2  11                                beq.s   loc_FFF2D2FB
FFF2D2F3  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2D2F5  cc1e                              mov.b   [r1], r14
FFF2D2F7  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2D2FA  1d                                bne.s   loc_FFF2D2FF
FFF2D2FB  f80601                 loc_FFF2D2FB mov.l   #1, 2Ch+var_2C[sp]
FFF2D2FE  0c                                bra.s   loc_FFF2D302
FFF2D2FF  f80600                 loc_FFF2D2FF mov.l   #0, 2Ch+var_2C[sp]
FFF2D302  ec01                   loc_FFF2D302 mov.l   2Ch+var_2C[sp], r1
FFF2D304  6101                              cmp     #0, r1
FFF2D306  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2D308  201d                              beq.b   loc_FFF2D325
FFF2D30A  aa03                              mov.l   2Ch+var_C[sp], r3
FFF2D30C  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF2D30E  397e00                            bsr.w   sub_FFF2D38C
FFF2D311  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2D313  05c689fe                          bsr.a   sub_FFF15CD9
FFF2D317  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2D319  a902                              mov.l   2Ch+var_1C[sp], r2
FFF2D31B  a909                              mov.l   2Ch+var_18[sp], r1
FFF2D31D  055e1bff                          bsr.a   sub_FFF1EE7B
FFF2D321  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2D323  2e63                              bra.b   loc_FFF2D386
FFF2D325  cc11                   loc_FFF2D325 mov.b   [r1], r1
FFF2D327  05641400                          bsr.a   sub_FFF2E78B
FFF2D32B  8289                              mov.b   r1, 2Ch+var_21[sp]
FFF2D32D  b289                              movu.b  2Ch+var_21[sp], r1
FFF2D32F  71020c                            add     #2Ch+var_20, sp, r2
FFF2D332  05ed1bff                          bsr.a   sub_FFF1EF1F
FFF2D336  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2D338  a909                              mov.l   2Ch+var_18[sp], r1
FFF2D33A  6101                              cmp     #0, r1
FFF2D33C  200e                              beq.b   loc_FFF2D34A
FFF2D33E  a909                              mov.l   2Ch+var_18[sp], r1
FFF2D340  6602                              mov.l   #0, r2
FFF2D342  05391bff                          bsr.a   sub_FFF1EE7B
FFF2D346  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2D348  2e3e                              bra.b   loc_FFF2D386
FFF2D34A  a889                   loc_FFF2D34A mov.l   2Ch+var_20[sp], r1
FFF2D34C  05a189fe                          bsr.a   sub_FFF15CED
FFF2D350  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF2D352  a981                              mov.l   2Ch+var_14[sp], r1
FFF2D354  6101                              cmp     #0, r1
FFF2D356  200f                              beq.b   loc_FFF2D365
FFF2D358  6602                              mov.l   #0, r2
FFF2D35A  fb16db                            mov.l   #-25h, r1
FFF2D35D  051e1bff                          bsr.a   sub_FFF1EE7B
FFF2D361  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2D363  2e23                              bra.b   loc_FFF2D386
FFF2D365  aa03                   loc_FFF2D365 mov.l   2Ch+var_C[sp], r3
FFF2D367  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF2D369  aa81                              mov.l   2Ch+var_4[sp], r1
FFF2D36B  392100                            bsr.w   sub_FFF2D38C
FFF2D36E  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2D370  056989fe                          bsr.a   sub_FFF15CD9
FFF2D374  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2D376  a889                              mov.l   2Ch+var_20[sp], r1
FFF2D378  058089fe                          bsr.a   sub_FFF15CF8
FFF2D37C  a902                              mov.l   2Ch+var_1C[sp], r2
FFF2D37E  a909                              mov.l   2Ch+var_18[sp], r1
FFF2D380  05fb1aff                          bsr.a   sub_FFF1EE7B
FFF2D384  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2D386  a809                   loc_FFF2D386 mov.l   2Ch+var_28[sp], r1
FFF2D388  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF2D38A  670b                              rtsd    #0Bh
FFF2D38C  7ea6                   sub_FFF2D38C push.l  r6   ; <<<< FUNC sub_FFF2D38C
FFF2D38E  7100a0                            add     #-60h, sp, sp
FFF2D391  a589                              mov.l   r1, 60h+var_4[sp]
FFF2D393  a582                              mov.l   r2, 60h+var_8[sp]
FFF2D395  a50b                              mov.l   r3, 60h+var_C[sp]
FFF2D397  e5001610                          mov.l   60h+var_8[sp], 60h+var_20[sp]
FFF2D39B  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2D3A1  e4e00f                            mov.l   [r14], 60h+var_24[sp]
FFF2D3A4  6601                              mov.l   #0, r1
FFF2D3A6  ef12                              mov.l   r1, r2
FFF2D3A8  05d31aff                          bsr.a   sub_FFF1EE7B
FFF2D3AC  05e789fe                          bsr.a   sub_FFF15D93
FFF2D3B0  a089                              mov.l   r1, 60h+var_54[sp]
FFF2D3B2  a889                              mov.l   60h+var_54[sp], r1
FFF2D3B4  6101                              cmp     #0, r1
FFF2D3B6  2010                              beq.b   loc_FFF2D3C6
FFF2D3B8  6602                              mov.l   #0, r2
FFF2D3BA  fb16d5                            mov.l   #-2Bh, r1
FFF2D3BD  05be1aff                          bsr.a   sub_FFF1EE7B
FFF2D3C1  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D3C3  382603                            bra.w   loc_FFF2D6E9
FFF2D3C6  ac01                   loc_FFF2D3C6 mov.l   60h+var_20[sp], r1
FFF2D3C8  6101                              cmp     #0, r1
FFF2D3CA  2154                              bne.b   loc_FFF2D41E
FFF2D3CC  3e8200                            mov.l   #0, 60h+var_18[sp]
FFF2D3CF  fbe2285e0600                      mov.l   #65E28h, r14
FFF2D3D5  e4e010                            mov.l   [r14], 60h+var_20[sp]
FFF2D3D8  2e18                              bra.b   loc_FFF2D3F0
FFF2D3DA  ac01                   loc_FFF2D3DA mov.l   60h+var_20[sp], r1
FFF2D3DC  8911                              mov.b   4[r1], r1
FFF2D3DE  6101                              cmp     #0, r1
FFF2D3E0  201e                              beq.b   loc_FFF2D3FE
FFF2D3E2  ac81                              mov.l   60h+var_18[sp], r1
FFF2D3E4  6211                              add     #1, r1
FFF2D3E6  a481                              mov.l   r1, 60h+var_18[sp]
FFF2D3E8  ac01                              mov.l   60h+var_20[sp], r1
FFF2D3EA  72114c02                          add     #24Ch, r1, r1
FFF2D3EE  a401                              mov.l   r1, 60h+var_20[sp]
FFF2D3F0  fbe214250100           loc_FFF2D3F0 mov.l   #12514h, r14
FFF2D3F6  dcee                              mov.w   [r14], r14
FFF2D3F8  06850e12                          cmp     60h+var_18[sp].l, r14
FFF2D3FC  2ade                              bgt.b   loc_FFF2D3DA
FFF2D3FE  fbe214250100           loc_FFF2D3FE mov.l   #12514h, r14
FFF2D404  dcee                              mov.w   [r14], r14
FFF2D406  06850e12                          cmp     60h+var_18[sp].l, r14
FFF2D40A  2114                              bne.b   loc_FFF2D41E
FFF2D40C  059289fe                          bsr.a   sub_FFF15D9E
FFF2D410  6602                              mov.l   #0, r2
FFF2D412  fb16f1                            mov.l   #-0Fh, r1
FFF2D415  05661aff                          bsr.a   sub_FFF1EE7B
FFF2D419  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D41B  38ce02                            bra.w   loc_FFF2D6E9
FFF2D41E  ac01                   loc_FFF2D41E mov.l   60h+var_20[sp], r1
FFF2D420  3c14ff                            mov.b   #-1, 4[r1]
FFF2D423  057b89fe                          bsr.a   sub_FFF15D9E
FFF2D427  ab89                              mov.l   60h+var_24[sp], r1
FFF2D429  ad9c                              mov.l   5Ch[r1], r4
FFF2D42B  754320                            mov.l   #20h, r3 ; ' '
FFF2D42E  6602                              mov.l   #0, r2
FFF2D430  71011c                            add     #60h+var_44, sp, r1
FFF2D433  057c1000                          bsr.a   sub_FFF2E4AF
FFF2D437  ab89                              mov.l   60h+var_24[sp], r1
FFF2D439  6101                              cmp     #0, r1
FFF2D43B  2115                              bne.b   loc_FFF2D450
FFF2D43D  ac01                              mov.l   60h+var_20[sp], r1
FFF2D43F  3c1400                            mov.b   #0, 4[r1]
FFF2D442  6602                              mov.l   #0, r2
FFF2D444  fb16ef                            mov.l   #-11h, r1
FFF2D447  05341aff                          bsr.a   sub_FFF1EE7B
FFF2D44B  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D44D  389c02                            bra.w   loc_FFF2D6E9
FFF2D450  ad89                   loc_FFF2D450 mov.l   60h+var_4[sp], r1
FFF2D452  cc1e                              mov.b   [r1], r14
FFF2D454  755e2f                            cmp     #2Fh, r14 ; '/'
FFF2D457  11                                beq.s   loc_FFF2D460
FFF2D458  ad89                              mov.l   60h+var_4[sp], r1
FFF2D45A  cc1e                              mov.b   [r1], r14
FFF2D45C  755e5c                            cmp     #5Ch, r14 ; '\'
FFF2D45F  1d                                bne.s   loc_FFF2D464
FFF2D460  f80601                 loc_FFF2D460 mov.l   #1, 60h+var_60[sp]
FFF2D463  0c                                bra.s   loc_FFF2D467
FFF2D464  f80600                 loc_FFF2D464 mov.l   #0, 60h+var_60[sp]
FFF2D467  ec01                   loc_FFF2D467 mov.l   60h+var_60[sp], r1
FFF2D469  6101                              cmp     #0, r1
FFF2D46B  201f                              beq.b   loc_FFF2D48A
FFF2D46D  ac01                              mov.l   60h+var_20[sp], r1
FFF2D46F  3c1401                            mov.b   #1, 4[r1]
FFF2D472  ac01                              mov.l   60h+var_20[sp], r1
FFF2D474  3c1500                            mov.b   #0, 5[r1]
FFF2D477  ab89                              mov.l   60h+var_24[sp], r1
FFF2D479  ac02                              mov.l   60h+var_20[sp], r2
FFF2D47B  e321                              mov.l   r1, [r2]
FFF2D47D  ac02                              mov.l   60h+var_20[sp], r2
FFF2D47F  6601                              mov.l   #0, r1
FFF2D481  05fa19ff                          bsr.a   sub_FFF1EE7B
FFF2D485  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D487  386202                            bra.w   loc_FFF2D6E9
FFF2D48A  ad89                   loc_FFF2D48A mov.l   60h+var_4[sp], r1
FFF2D48C  cc11                              mov.b   [r1], r1
FFF2D48E  05fd1200                          bsr.a   sub_FFF2E78B
FFF2D492  8289                              mov.b   r1, 60h+var_55[sp]
FFF2D494  b289                              movu.b  60h+var_55[sp], r1
FFF2D496  71023c                            add     #60h+var_24, sp, r2
FFF2D499  05861aff                          bsr.a   sub_FFF1EF1F
FFF2D49D  a489                              mov.l   r1, 60h+var_14[sp]
FFF2D49F  ac89                              mov.l   60h+var_14[sp], r1
FFF2D4A1  6101                              cmp     #0, r1
FFF2D4A3  2014                              beq.b   loc_FFF2D4B7
FFF2D4A5  ac01                              mov.l   60h+var_20[sp], r1
FFF2D4A7  3c1400                            mov.b   #0, 4[r1]
FFF2D4AA  ac89                              mov.l   60h+var_14[sp], r1
FFF2D4AC  6602                              mov.l   #0, r2
FFF2D4AE  05cd19ff                          bsr.a   sub_FFF1EE7B
FFF2D4B2  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D4B4  383502                            bra.w   loc_FFF2D6E9
FFF2D4B7  ab89                   loc_FFF2D4B7 mov.l   60h+var_24[sp], r1
FFF2D4B9  05a41aff                          bsr.a   sub_FFF1EF5D
FFF2D4BD  a489                              mov.l   r1, 60h+var_14[sp]
FFF2D4BF  ac89                              mov.l   60h+var_14[sp], r1
FFF2D4C1  6101                              cmp     #0, r1
FFF2D4C3  2014                              beq.b   loc_FFF2D4D7
FFF2D4C5  ac01                              mov.l   60h+var_20[sp], r1
FFF2D4C7  3c1400                            mov.b   #0, 4[r1]
FFF2D4CA  ac89                              mov.l   60h+var_14[sp], r1
FFF2D4CC  6602                              mov.l   #0, r2
FFF2D4CE  05ad19ff                          bsr.a   sub_FFF1EE7B
FFF2D4D2  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D4D4  381502                            bra.w   loc_FFF2D6E9
FFF2D4D7  ad89                   loc_FFF2D4D7 mov.l   60h+var_4[sp], r1
FFF2D4D9  056a1100                          bsr.a   sub_FFF2E643
FFF2D4DD  6161                              cmp     #6, r1
FFF2D4DF  245c                              bgtu.b  loc_FFF2D53B
FFF2D4E1  ac01                              mov.l   60h+var_20[sp], r1
FFF2D4E3  3c1401                            mov.b   #1, 4[r1]
FFF2D4E6  ac01                              mov.l   60h+var_20[sp], r1
FFF2D4E8  3d1300                            mov.w   #0, 6[r1]
FFF2D4EB  ab89                              mov.l   60h+var_24[sp], r1
FFF2D4ED  ac02                              mov.l   60h+var_20[sp], r2
FFF2D4EF  e321                              mov.l   r1, [r2]
FFF2D4F1  ab89                              mov.l   60h+var_24[sp], r1
FFF2D4F3  ac02                              mov.l   60h+var_20[sp], r2
FFF2D4F5  e5120d02                          mov.l   34h[r1], 8[r2]
FFF2D4F9  ac01                              mov.l   60h+var_20[sp], r1
FFF2D4FB  3c1501                            mov.b   #1, 5[r1]
FFF2D4FE  ab89                              mov.l   60h+var_24[sp], r1
FFF2D500  8c12                              mov.b   10h[r1], r2
FFF2D502  755220                            cmp     #20h, r2 ; ' '
FFF2D505  ac06                              mov.l   60h+var_20[sp], r6
FFF2D507  201d                              beq.b   loc_FFF2D524
FFF2D509  ab8a                              mov.l   60h+var_24[sp], r2
FFF2D50B  a8ab                              mov.l   0Ch[r2], r3
FFF2D50D  06cd2304                          mul     8[r2].uw, r3
FFF2D511  06c91303                          add     6[r1].uw, r3
FFF2D515  a0eb                              mov.l   r3, 0Ch[r6]
FFF2D517  ac02                              mov.l   60h+var_20[sp], r2
FFF2D519  6601                              mov.l   #0, r1
FFF2D51B  056019ff                          bsr.a   sub_FFF1EE7B
FFF2D51F  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D521  38c801                            bra.w   loc_FFF2D6E9
FFF2D524  ac02                   loc_FFF2D524 mov.l   60h+var_20[sp], r2
FFF2D526  a8a2                              mov.l   8[r2], r2
FFF2D528  05841aff                          bsr.a   sub_FFF1EFAC
FFF2D52C  a0e9                              mov.l   r1, 0Ch[r6]
FFF2D52E  ac02                              mov.l   60h+var_20[sp], r2
FFF2D530  6601                              mov.l   #0, r1
FFF2D532  054919ff                          bsr.a   sub_FFF1EE7B
FFF2D536  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D538  38b101                            bra.w   loc_FFF2D6E9
FFF2D53B  ad89                   loc_FFF2D53B mov.l   60h+var_4[sp], r1
FFF2D53D  6241                              add     #4, r1
FFF2D53F  a409                              mov.l   r1, 60h+var_1C[sp]
FFF2D541  ab89                              mov.l   60h+var_24[sp], r1
FFF2D543  e5100d06                          mov.l   34h[r1], 60h+var_48[sp]
FFF2D547  ab89                              mov.l   60h+var_24[sp], r1
FFF2D549  8c11                              mov.b   10h[r1], r1
FFF2D54B  755120                            cmp     #20h, r1 ; ' '
FFF2D54E  3a3901                            beq.w   loc_FFF2D687
FFF2D551  ad0a                              mov.l   60h+var_C[sp], r2
FFF2D553  ac09                              mov.l   60h+var_1C[sp], r1
FFF2D555  05be5eff                          bsr.a   sub_FFF23413
FFF2D559  a409                              mov.l   r1, 60h+var_1C[sp]
FFF2D55B  ac09                              mov.l   60h+var_1C[sp], r1
FFF2D55D  6101                              cmp     #0, r1
FFF2D55F  2115                              bne.b   loc_FFF2D574
FFF2D561  ac01                              mov.l   60h+var_20[sp], r1
FFF2D563  3c1400                            mov.b   #0, 4[r1]
FFF2D566  6602                              mov.l   #0, r2
FFF2D568  fb16ff                            mov.l   #-1, r1
FFF2D56B  051019ff                          bsr.a   sub_FFF1EE7B
FFF2D56F  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D571  387801                            bra.w   loc_FFF2D6E9
FFF2D574  ad09                   loc_FFF2D574 mov.l   60h+var_C[sp], r1
FFF2D576  cc1e                              mov.b   [r1], r14
FFF2D578  610e                              cmp     #0, r14
FFF2D57A  210d                              bne.b   loc_FFF2D587
FFF2D57C  ad09                              mov.l   60h+var_C[sp], r1
FFF2D57E  8819                              mov.b   1[r1], r1
FFF2D580  6101                              cmp     #0, r1
FFF2D582  1d                                bne.s   loc_FFF2D587
FFF2D583  f80601                            mov.l   #1, 60h+var_60[sp]
FFF2D586  0c                                bra.s   loc_FFF2D58A
FFF2D587  f80600                 loc_FFF2D587 mov.l   #0, 60h+var_60[sp]
FFF2D58A  ec01                   loc_FFF2D58A mov.l   60h+var_60[sp], r1
FFF2D58C  6101                              cmp     #0, r1
FFF2D58E  2015                              beq.b   loc_FFF2D5A3
FFF2D590  ac01                              mov.l   60h+var_20[sp], r1
FFF2D592  3c1400                            mov.b   #0, 4[r1]
FFF2D595  6602                              mov.l   #0, r2
FFF2D597  fb16ff                            mov.l   #-1, r1
FFF2D59A  05e118ff                          bsr.a   sub_FFF1EE7B
FFF2D59E  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D5A0  384901                            bra.w   loc_FFF2D6E9
FFF2D5A3  ad0a                   loc_FFF2D5A3 mov.l   60h+var_C[sp], r2
FFF2D5A5  ab89                              mov.l   60h+var_24[sp], r1
FFF2D5A7  60c0                              sub     #0Ch, sp
FFF2D5A9  a082                              mov.l   r2, 6Ch+var_64[sp]
FFF2D5AB  71031c                            add     #6Ch+var_50, sp, r3
FFF2D5AE  a00b                              mov.l   r3, 6Ch+var_68[sp]
FFF2D5B0  f80400                            mov.b   #0, 6Ch+var_6C[sp]
FFF2D5B3  6604                              mov.l   #0, r4
FFF2D5B5  710328                            add     #6Ch+var_44, sp, r3
FFF2D5B8  051251ff                          bsr.a   sub_FFF226CA
FFF2D5BC  62c0                              add     #0Ch, sp
FFF2D5BE  a489                              mov.l   r1, 60h+var_14[sp]
FFF2D5C0  ac89                              mov.l   60h+var_14[sp], r1
FFF2D5C2  6101                              cmp     #0, r1
FFF2D5C4  2015                              beq.b   loc_FFF2D5D9
FFF2D5C6  ac01                              mov.l   60h+var_20[sp], r1
FFF2D5C8  3c1400                            mov.b   #0, 4[r1]
FFF2D5CB  6602                              mov.l   #0, r2
FFF2D5CD  fb16fc                            mov.l   #-4, r1
FFF2D5D0  05ab18ff                          bsr.a   sub_FFF1EE7B
FFF2D5D4  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D5D6  381301                            bra.w   loc_FFF2D6E9
FFF2D5D9  ab89                   loc_FFF2D5D9 mov.l   60h+var_24[sp], r1
FFF2D5DB  8c12                              mov.b   10h[r1], r2
FFF2D5DD  71011c                            add     #60h+var_44, sp, r1
FFF2D5E0  05b830ff                          bsr.a   sub_FFF20698
FFF2D5E4  a181                              mov.l   r1, 60h+var_48[sp]
FFF2D5E6  38a100                            bra.w   loc_FFF2D687
FFF2D5E9  ad0a                   loc_FFF2D5E9 mov.l   60h+var_C[sp], r2
FFF2D5EB  ac09                              mov.l   60h+var_1C[sp], r1
FFF2D5ED  05265eff                          bsr.a   sub_FFF23413
FFF2D5F1  a409                              mov.l   r1, 60h+var_1C[sp]
FFF2D5F3  ac09                              mov.l   60h+var_1C[sp], r1
FFF2D5F5  6101                              cmp     #0, r1
FFF2D5F7  2115                              bne.b   loc_FFF2D60C
FFF2D5F9  ac01                              mov.l   60h+var_20[sp], r1
FFF2D5FB  3c1400                            mov.b   #0, 4[r1]
FFF2D5FE  6602                              mov.l   #0, r2
FFF2D600  fb16ff                            mov.l   #-1, r1
FFF2D603  057818ff                          bsr.a   sub_FFF1EE7B
FFF2D607  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D609  38e000                            bra.w   loc_FFF2D6E9
FFF2D60C  ad09                   loc_FFF2D60C mov.l   60h+var_C[sp], r1
FFF2D60E  cc1e                              mov.b   [r1], r14
FFF2D610  610e                              cmp     #0, r14
FFF2D612  210d                              bne.b   loc_FFF2D61F
FFF2D614  ad09                              mov.l   60h+var_C[sp], r1
FFF2D616  8819                              mov.b   1[r1], r1
FFF2D618  6101                              cmp     #0, r1
FFF2D61A  1d                                bne.s   loc_FFF2D61F
FFF2D61B  f80601                            mov.l   #1, 60h+var_60[sp]
FFF2D61E  0c                                bra.s   loc_FFF2D622
FFF2D61F  f80600                 loc_FFF2D61F mov.l   #0, 60h+var_60[sp]
FFF2D622  ec01                   loc_FFF2D622 mov.l   60h+var_60[sp], r1
FFF2D624  6101                              cmp     #0, r1
FFF2D626  2015                              beq.b   loc_FFF2D63B
FFF2D628  ac01                              mov.l   60h+var_20[sp], r1
FFF2D62A  3c1400                            mov.b   #0, 4[r1]
FFF2D62D  6602                              mov.l   #0, r2
FFF2D62F  fb16ff                            mov.l   #-1, r1
FFF2D632  054918ff                          bsr.a   sub_FFF1EE7B
FFF2D636  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D638  38b100                            bra.w   loc_FFF2D6E9
FFF2D63B  ad0b                   loc_FFF2D63B mov.l   60h+var_C[sp], r3
FFF2D63D  a982                              mov.l   60h+var_48[sp], r2
FFF2D63F  ab89                              mov.l   60h+var_24[sp], r1
FFF2D641  7100f0                            add     #-10h, sp, sp
FFF2D644  a08b                              mov.l   r3, 70h+var_64[sp]
FFF2D646  710424                            add     #70h+var_4C, sp, r4
FFF2D649  a084                              mov.l   r4, 70h+var_68[sp]
FFF2D64B  710420                            add     #70h+var_50, sp, r4
FFF2D64E  a00c                              mov.l   r4, 70h+var_6C[sp]
FFF2D650  3c0100                            mov.b   #0, 70h+var_6F[sp]
FFF2D653  f80400                            mov.b   #0, 70h+var_70[sp]
FFF2D656  71042c                            add     #70h+var_44, sp, r4
FFF2D659  05e254ff                          bsr.a   sub_FFF22B3B
FFF2D65D  710010                            add     #10h, sp, sp
FFF2D660  a489                              mov.l   r1, 60h+var_14[sp]
FFF2D662  ac89                              mov.l   60h+var_14[sp], r1
FFF2D664  6101                              cmp     #0, r1
FFF2D666  2014                              beq.b   loc_FFF2D67A
FFF2D668  ac01                              mov.l   60h+var_20[sp], r1
FFF2D66A  3c1400                            mov.b   #0, 4[r1]
FFF2D66D  6602                              mov.l   #0, r2
FFF2D66F  fb16fc                            mov.l   #-4, r1
FFF2D672  050918ff                          bsr.a   sub_FFF1EE7B
FFF2D676  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D678  2e71                              bra.b   loc_FFF2D6E9
FFF2D67A  ab89                   loc_FFF2D67A mov.l   60h+var_24[sp], r1
FFF2D67C  8c12                              mov.b   10h[r1], r2
FFF2D67E  71011c                            add     #60h+var_44, sp, r1
FFF2D681  051730ff                          bsr.a   sub_FFF20698
FFF2D685  a181                              mov.l   r1, 60h+var_48[sp]
FFF2D687  ac09                   loc_FFF2D687 mov.l   60h+var_1C[sp], r1
FFF2D689  cc1e                              mov.b   [r1], r14
FFF2D68B  610e                              cmp     #0, r14
FFF2D68D  3b5cff                            bne.w   loc_FFF2D5E9
FFF2D690  ab89                              mov.l   60h+var_24[sp], r1
FFF2D692  8c12                              mov.b   10h[r1], r2
FFF2D694  71011c                            add     #60h+var_44, sp, r1
FFF2D697  050130ff                          bsr.a   sub_FFF20698
FFF2D69B  a181                              mov.l   r1, 60h+var_48[sp]
FFF2D69D  f50427                            btst    #4, 60h+var_39[sp].b
FFF2D6A0  15                                beq.s   loc_FFF2D6A5
FFF2D6A1  f80600                            mov.l   #0, 60h+var_60[sp]
FFF2D6A4  0c                                bra.s   loc_FFF2D6A8
FFF2D6A5  f80601                 loc_FFF2D6A5 mov.l   #1, 60h+var_60[sp]
FFF2D6A8  ec01                   loc_FFF2D6A8 mov.l   60h+var_60[sp], r1
FFF2D6AA  6101                              cmp     #0, r1
FFF2D6AC  ac01                              mov.l   60h+var_20[sp], r1
FFF2D6AE  2012                              beq.b   loc_FFF2D6C0
FFF2D6B0  3c1400                            mov.b   #0, 4[r1]
FFF2D6B3  6602                              mov.l   #0, r2
FFF2D6B5  fb16fc                            mov.l   #-4, r1
FFF2D6B8  05c317ff                          bsr.a   sub_FFF1EE7B
FFF2D6BC  a009                              mov.l   r1, 60h+var_5C[sp]
FFF2D6BE  2e2b                              bra.b   loc_FFF2D6E9
FFF2D6C0  3c1501                 loc_FFF2D6C0 mov.b   #1, 5[r1]
FFF2D6C3  ac01                              mov.l   60h+var_20[sp], r1
FFF2D6C5  3c1401                            mov.b   #1, 4[r1]
FFF2D6C8  a981                              mov.l   60h+var_48[sp], r1
FFF2D6CA  ac02                              mov.l   60h+var_20[sp], r2
FFF2D6CC  a0a1                              mov.l   r1, 8[r2]
FFF2D6CE  a982                              mov.l   60h+var_48[sp], r2
FFF2D6D0  ab89                              mov.l   60h+var_24[sp], r1
FFF2D6D2  ac06                              mov.l   60h+var_20[sp], r6
FFF2D6D4  05d818ff                          bsr.a   sub_FFF1EFAC
FFF2D6D8  a0e9                              mov.l   r1, 0Ch[r6]
FFF2D6DA  ac01                              mov.l   60h+var_20[sp], r1
FFF2D6DC  3d1300                            mov.w   #0, 6[r1]
FFF2D6DF  ab89                              mov.l   60h+var_24[sp], r1
FFF2D6E1  ac02                              mov.l   60h+var_20[sp], r2
FFF2D6E3  e321                              mov.l   r1, [r2]
FFF2D6E5  e5001001                          mov.l   60h+var_20[sp], 60h+var_5C[sp]
FFF2D6E9  a809                   loc_FFF2D6E9 mov.l   60h+var_5C[sp], r1
FFF2D6EB  a501                              mov.l   r1, 60h+var_10[sp]
FFF2D6ED  3f6619                            rtsd    #64h, r6-r6
FFF2D6F0  7100ec                 sub_FFF2D6F0 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF2D6F0
FFF2D6F3  a101                              mov.l   r1, 14h+var_4[sp]
FFF2D6F5  05a187fe                          bsr.a   sub_FFF15E96
FFF2D6F9  a009                              mov.l   r1, 14h+var_10[sp]
FFF2D6FB  a809                              mov.l   14h+var_10[sp], r1
FFF2D6FD  6101                              cmp     #0, r1
FFF2D6FF  210f                              bne.b   loc_FFF2D70E
FFF2D701  6602                              mov.l   #0, r2
FFF2D703  fb16e1                            mov.l   #-1Fh, r1
FFF2D706  057517ff                          bsr.a   sub_FFF1EE7B
FFF2D70A  e301                              mov.l   r1, 14h+var_14[sp]
FFF2D70C  2e24                              bra.b   loc_FFF2D730
FFF2D70E  a80a                   loc_FFF2D70E mov.l   14h+var_10[sp], r2
FFF2D710  a901                              mov.l   14h+var_4[sp], r1
FFF2D712  392400                            bsr.w   sub_FFF2D736
FFF2D715  a081                              mov.l   r1, 14h+var_C[sp]
FFF2D717  a809                              mov.l   14h+var_10[sp], r1
FFF2D719  058d87fe                          bsr.a   sub_FFF15EA6
FFF2D71D  6101                              cmp     #0, r1
FFF2D71F  200e                              beq.b   loc_FFF2D72D
FFF2D721  6602                              mov.l   #0, r2
FFF2D723  fb16e0                            mov.l   #-20h, r1
FFF2D726  055517ff                          bsr.a   sub_FFF1EE7B
FFF2D72A  e301                              mov.l   r1, 14h+var_14[sp]
FFF2D72C  0c                                bra.s   loc_FFF2D730
FFF2D72D  e10002                 loc_FFF2D72D mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF2D730  ec01                   loc_FFF2D730 mov.l   14h+var_14[sp], r1
FFF2D732  a089                              mov.l   r1, 14h+var_8[sp]
FFF2D734  6705                              rtsd    #5
FFF2D736  7100e4                 sub_FFF2D736 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2D736
FFF2D739  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2D73B  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2D73D  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF2D741  05aa78ff                          bsr.a   sub_FFF24FEB
FFF2D745  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2D747  a889                              mov.l   1Ch+var_10[sp], r1
FFF2D749  6101                              cmp     #0, r1
FFF2D74B  200e                              beq.b   loc_FFF2D759
FFF2D74D  a889                              mov.l   1Ch+var_10[sp], r1
FFF2D74F  6602                              mov.l   #0, r2
FFF2D751  052a17ff                          bsr.a   sub_FFF1EE7B
FFF2D755  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2D757  2e2f                              bra.b   loc_FFF2D786
FFF2D759  a809                   loc_FFF2D759 mov.l   1Ch+var_18[sp], r1
FFF2D75B  055d17ff                          bsr.a   sub_FFF1EEB8
FFF2D75F  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2D761  a889                              mov.l   1Ch+var_10[sp], r1
FFF2D763  6101                              cmp     #0, r1
FFF2D765  200e                              beq.b   loc_FFF2D773
FFF2D767  a889                              mov.l   1Ch+var_10[sp], r1
FFF2D769  6602                              mov.l   #0, r2
FFF2D76B  051017ff                          bsr.a   sub_FFF1EE7B
FFF2D76F  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2D771  2e15                              bra.b   loc_FFF2D786
FFF2D773  a90a                   loc_FFF2D773 mov.l   1Ch+var_8[sp], r2
FFF2D775  a981                              mov.l   1Ch+var_4[sp], r1
FFF2D777  391500                            bsr.w   sub_FFF2D78C
FFF2D77A  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2D77C  a882                              mov.l   1Ch+var_14[sp], r2
FFF2D77E  a889                              mov.l   1Ch+var_10[sp], r1
