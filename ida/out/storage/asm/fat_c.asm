; ==== fat_c  FFF24100-FFF25B00  (file 324100-325B00) ====
FFF24100  07                                add     24h+var_8[sp].l, r1
FFF24101  a189                              mov.l   r1, 24h+var_8[sp]
FFF24103  aa01                              mov.l   24h+var_4[sp], r1
FFF24105  ac1a                              mov.l   44h[r1], r2
FFF24107  6102                              cmp     #0, r2
FFF24109  a98a                              mov.l   24h+var_8[sp], r2
FFF2410B  2129                              bne.b   loc_FFF24134
FFF2410D  a90b                              mov.l   24h+var_10[sp], r3
FFF2410F  72330c0c                          add     #0C0Ch, r3, r3
FFF24113  6614                              mov.l   #1, r4
FFF24115  05fcaeff                          bsr.a   sub_FFF1F011
FFF24119  a089                              mov.l   r1, 24h+var_18[sp]
FFF2411B  a889                              mov.l   24h+var_18[sp], r1
FFF2411D  6101                              cmp     #0, r1
FFF2411F  16                                beq.s   loc_FFF24125
FFF24120  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF24123  2e6f                              bra.b   loc_FFF24192
FFF24125  a909                   loc_FFF24125 mov.l   24h+var_10[sp], r1
FFF24127  72110c0c                          add     #0C0Ch, r1, r1
FFF2412B  a982                              mov.l   24h+var_C[sp], r2
FFF2412D  e321                              mov.l   r1, [r2]
FFF2412F  f80600                            mov.l   #0, 24h+var_24[sp]
FFF24132  2e60                              bra.b   loc_FFF24192
FFF24134  05a381ff               loc_FFF24134 bsr.a   sub_FFF1C2D7
FFF24138  9081                              mov.w   r1, 24h+var_20[sp]
FFF2413A  b881                              movu.w  24h+var_20[sp], r1
FFF2413C  6101                              cmp     #0, r1
FFF2413E  2119                              bne.b   loc_FFF24157
FFF24140  a98a                              mov.l   24h+var_8[sp], r2
FFF24142  aa01                              mov.l   24h+var_4[sp], r1
FFF24144  710306                            add     #24h+var_1E, sp, r3
FFF24147  051182ff                          bsr.a   sub_FFF1C358
FFF2414B  a089                              mov.l   r1, 24h+var_18[sp]
FFF2414D  a889                              mov.l   24h+var_18[sp], r1
FFF2414F  6101                              cmp     #0, r1
FFF24151  12                                beq.s   loc_FFF2415B
FFF24152  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF24155  2e3d                              bra.b   loc_FFF24192
FFF24157  d5000203               loc_FFF24157 mov.w   24h+var_20[sp], 24h+var_1E[sp]
FFF2415B  b889                   loc_FFF2415B movu.w  24h+var_1E[sp], r1
FFF2415D  6011                              sub     #1, r1
FFF2415F  aa02                              mov.l   24h+var_4[sp], r2
FFF24161  068d2117                          mul     5Ch[r2].l, r1
FFF24165  5d2324                            movu.w  48h[r2], r3
FFF24168  6c23                              shll    #2, r3
FFF2416A  06892311                          add     44h[r2].l, r3
FFF2416E  4b13                              add     r1, r3
FFF24170  a083                              mov.l   r3, 24h+var_1C[sp]
FFF24172  a881                              mov.l   24h+var_1C[sp], r1
FFF24174  a982                              mov.l   24h+var_C[sp], r2
FFF24176  e321                              mov.l   r1, [r2]
FFF24178  b889                              movu.w  24h+var_1E[sp], r1
FFF2417A  6011                              sub     #1, r1
FFF2417C  aa02                              mov.l   24h+var_4[sp], r2
FFF2417E  06e1082125                        div     4Ah[r2].uw, r1
FFF24183  6211                              add     #1, r1
FFF24185  9089                              mov.w   r1, 24h+var_1E[sp]
FFF24187  b88a                              movu.w  24h+var_1E[sp], r2
FFF24189  aa01                              mov.l   24h+var_4[sp], r1
FFF2418B  054783ff                          bsr.a   sub_FFF1C4D2
FFF2418F  f80600                 sub_FFF2418F mov.l   #0, 0[sp]   ; <<<< FUNC sub_FFF2418F
FFF24192  ec01                   loc_FFF24192 mov.l   24h+var_24[sp], r1
FFF24194  a101                              mov.l   r1, 24h+var_14[sp]
FFF24196  6709                              rtsd    #9
FFF24198  7100e0                 sub_FFF24198 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF24198
FFF2419B  a189                              mov.l   r1, 20h+var_4[sp]
FFF2419D  a182                              mov.l   r2, 20h+var_8[sp]
FFF2419F  a10b                              mov.l   r3, 20h+var_C[sp]
FFF241A1  a989                              mov.l   20h+var_4[sp], r1
FFF241A3  e5101101                          mov.l   44h[r1], 20h+var_1C[sp]
FFF241A7  a989                              mov.l   20h+var_4[sp], r1
FFF241A9  a982                              mov.l   20h+var_8[sp], r2
FFF241AB  06851203                          cmp     0Ch[r1].l, r2
FFF241AF  2308                              bltu.b  loc_FFF241B7
FFF241B1  f806f5                            mov.l   #-0Bh, 20h+var_20[sp]
FFF241B4  388900                            bra.w   loc_FFF2423D
FFF241B7  a989                   loc_FFF241B7 mov.l   20h+var_4[sp], r1
FFF241B9  b899                              movu.w  6[r1], r1
FFF241BB  06890106                          add     20h+var_8[sp].l, r1
FFF241BF  a181                              mov.l   r1, 20h+var_8[sp]
FFF241C1  a989                              mov.l   20h+var_4[sp], r1
FFF241C3  ac1a                              mov.l   44h[r1], r2
FFF241C5  6102                              cmp     #0, r2
FFF241C7  a982                              mov.l   20h+var_8[sp], r2
FFF241C9  2136                              bne.b   loc_FFF241FF
FFF241CB  a90b                              mov.l   20h+var_C[sp], r3
FFF241CD  6614                              mov.l   #1, r4
FFF241CF  05d3aeff                          bsr.a   sub_FFF1F0A2
FFF241D3  a089                              mov.l   r1, 20h+var_14[sp]
FFF241D5  a889                              mov.l   20h+var_14[sp], r1
FFF241D7  6101                              cmp     #0, r1
FFF241D9  16                                beq.s   loc_FFF241DF
FFF241DA  e10003                            mov.l   20h+var_14[sp], 20h+var_20[sp]
FFF241DD  2e60                              bra.b   loc_FFF2423D
FFF241DF  a989                   loc_FFF241DF mov.l   20h+var_4[sp], r1
FFF241E1  b911                              movu.w  8[r1], r1
FFF241E3  6111                              cmp     #1, r1
FFF241E5  1e                                bne.s   loc_FFF241EB
FFF241E6  f80600                            mov.l   #0, 20h+var_20[sp]
FFF241E9  2e54                              bra.b   loc_FFF2423D
FFF241EB  a989                   loc_FFF241EB mov.l   20h+var_4[sp], r1
FFF241ED  a89a                              mov.l   0Ch[r1], r2
FFF241EF  06890206                          add     20h+var_8[sp].l, r2
FFF241F3  a90b                              mov.l   20h+var_C[sp], r3
FFF241F5  6614                              mov.l   #1, r4
FFF241F7  05abaeff                          bsr.a   sub_FFF1F0A2
FFF241FB  e301                              mov.l   r1, 20h+var_20[sp]
FFF241FD  2e40                              bra.b   loc_FFF2423D
FFF241FF  05d880ff               loc_FFF241FF bsr.a   sub_FFF1C2D7
FFF24203  9101                              mov.w   r1, 20h+var_18[sp]
FFF24205  b901                              movu.w  20h+var_18[sp], r1
FFF24207  6101                              cmp     #0, r1
FFF24209  1e                                bne.s   loc_FFF2420F
FFF2420A  f806bb                            mov.l   #-45h, 20h+var_20[sp]
FFF2420D  2e30                              bra.b   loc_FFF2423D
FFF2420F  d5000405               loc_FFF2420F mov.w   20h+var_18[sp], 20h+var_16[sp]
FFF24213  b909                              movu.w  20h+var_16[sp], r1
FFF24215  6011                              sub     #1, r1
FFF24217  a98a                              mov.l   20h+var_4[sp], r2
FFF24219  06e1082125                        div     4Ah[r2].uw, r1
FFF2421E  6211                              add     #1, r1
FFF24220  9109                              mov.w   r1, 20h+var_16[sp]
FFF24222  b90a                              movu.w  20h+var_16[sp], r2
FFF24224  a989                              mov.l   20h+var_4[sp], r1
FFF24226  05ac82ff                          bsr.a   sub_FFF1C4D2
FFF2422A  b909                              movu.w  20h+var_16[sp], r1
FFF2422C  6c21                              shll    #2, r1
FFF2422E  06890101                          add     20h+var_1C[sp].l, r1
FFF24232  6041                              sub     #4, r1
FFF24234  ec1e                              mov.l   [r1], r14
FFF24236  79fe                              bset    #1Fh, r14
FFF24238  e31e                              mov.l   r14, [r1]
FFF2423A  f80600                            mov.l   #0, 20h+var_20[sp]
FFF2423D  ec01                   loc_FFF2423D mov.l   20h+var_20[sp], r1
FFF2423F  a101                              mov.l   r1, 20h+var_10[sp]
FFF24241  6708                              rtsd    #8
FFF24243  7100e4                 sub_FFF24243 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF24243
FFF24246  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF24248  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2424A  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF2424C  a981                              mov.l   1Ch+var_4[sp], r1
FFF2424E  05c71aff                          bsr.a   sub_FFF15D15
FFF24252  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24254  a881                              mov.l   1Ch+var_14[sp], r1
FFF24256  6101                              cmp     #0, r1
FFF24258  16                                beq.s   loc_FFF2425E
FFF24259  f806de                            mov.l   #-22h, 1Ch+var_1C[sp]
FFF2425C  2e16                              bra.b   loc_FFF24272
FFF2425E  a903                   loc_FFF2425E mov.l   1Ch+var_C[sp], r3
FFF24260  a90a                              mov.l   1Ch+var_8[sp], r2
FFF24262  a981                              mov.l   1Ch+var_4[sp], r1
FFF24264  391400                            bsr.w   sub_FFF24278
FFF24267  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF24269  a981                              mov.l   1Ch+var_4[sp], r1
FFF2426B  05b51aff                          bsr.a   sub_FFF15D20
FFF2426F  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF24272  ec01                   loc_FFF24272 mov.l   1Ch+var_1C[sp], r1
FFF24274  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF24276  6707                              rtsd    #7
FFF24278  7100dc                 sub_FFF24278 add     #-24h, sp, sp   ; <<<< FUNC sub_FFF24278
FFF2427B  a201                              mov.l   r1, 24h+var_4[sp]
FFF2427D  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2427F  a183                              mov.l   r3, 24h+var_C[sp]
FFF24281  e5000703                          mov.l   24h+var_8[sp], 24h+var_18[sp]
FFF24285  2e70                              bra.b   loc_FFF242F5
FFF24287  f90601c3               loc_FFF24287 mov.l   #-3Dh, 24h+var_20[sp]
FFF2428B  389e00                            bra.w   loc_FFF24329
FFF2428E  a889                   loc_FFF2428E mov.l   24h+var_18[sp], r1
FFF24290  6111                              cmp     #1, r1
FFF24292  2409                              bgtu.b  loc_FFF2429B
FFF24294  f90601c3                          mov.l   #-3Dh, 24h+var_20[sp]
FFF24298  389100                            bra.w   loc_FFF24329
FFF2429B  a983                   loc_FFF2429B mov.l   24h+var_C[sp], r3
FFF2429D  a88a                              mov.l   24h+var_18[sp], r2
FFF2429F  aa01                              mov.l   24h+var_4[sp], r1
FFF242A1  6040                              sub     #4, sp
FFF242A3  e303                              mov.l   r3, 28h+var_28[sp]
FFF242A5  754477                            mov.l   #77h, r4 ; 'w'
FFF242A8  6603                              mov.l   #0, r3
FFF242AA  39d300                            bsr.w   sub_FFF2437D
FFF242AD  6240                              add     #4, sp
FFF242AF  a081                              mov.l   r1, 24h+var_1C[sp]
FFF242B1  a881                              mov.l   24h+var_1C[sp], r1
FFF242B3  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF242B9  1f                                bne.s   loc_FFF242C0
FFF242BA  f90601c3                          mov.l   #-3Dh, 24h+var_20[sp]
FFF242BE  2e6b                              bra.b   loc_FFF24329
FFF242C0  aa01                   loc_FFF242C0 mov.l   24h+var_4[sp], r1
FFF242C2  8c11                              mov.b   10h[r1], r1
FFF242C4  755120                            cmp     #20h, r1 ; ' '
FFF242C7  19                                bne.s   loc_FFF242D0
FFF242C8  aa01                              mov.l   24h+var_4[sp], r1
FFF242CA  ab9a                              mov.l   3Ch[r1], r2
FFF242CC  6212                              add     #1, r2
FFF242CE  a39a                              mov.l   r2, 3Ch[r1]
FFF242D0  a901                   loc_FFF242D0 mov.l   24h+var_14[sp], r1
FFF242D2  7401f8ffff0f                      cmp     #0FFFFFF8h, r1
FFF242D8  2310                              bltu.b  loc_FFF242E8
FFF242DA  a901                              mov.l   24h+var_14[sp], r1
FFF242DC  7401ffffff0f                      cmp     #0FFFFFFFh, r1
FFF242E2  2406                              bgtu.b  loc_FFF242E8
FFF242E4  f80601                            mov.l   #1, 24h+var_24[sp]
FFF242E7  0c                                bra.s   loc_FFF242EB
FFF242E8  f80600                 loc_FFF242E8 mov.l   #0, 24h+var_24[sp]
FFF242EB  ec01                   loc_FFF242EB mov.l   24h+var_24[sp], r1
FFF242ED  6101                              cmp     #0, r1
FFF242EF  212a                              bne.b   loc_FFF24319
FFF242F1  e5000403                          mov.l   24h+var_14[sp], 24h+var_18[sp]
FFF242F5  a983                   loc_FFF242F5 mov.l   24h+var_C[sp], r3
FFF242F7  a88a                              mov.l   24h+var_18[sp], r2
FFF242F9  aa01                              mov.l   24h+var_4[sp], r1
FFF242FB  6040                              sub     #4, sp
FFF242FD  e303                              mov.l   r3, 28h+var_28[sp]
FFF242FF  754472                            mov.l   #72h, r4 ; 'r'
FFF24302  6603                              mov.l   #0, r3
FFF24304  397900                            bsr.w   sub_FFF2437D
FFF24307  6240                              add     #4, sp
FFF24309  a101                              mov.l   r1, 24h+var_14[sp]
FFF2430B  a901                              mov.l   24h+var_14[sp], r1
FFF2430D  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF24313  3a74ff                            beq.w   loc_FFF24287
FFF24316  3878ff                            bra.w   loc_FFF2428E
FFF24319  aa01                   loc_FFF24319 mov.l   24h+var_4[sp], r1
FFF2431B  aa99                              mov.l   2Ch[r1], r1
FFF2431D  6101                              cmp     #0, r1
FFF2431F  1f                                bne.s   loc_FFF24326
FFF24320  a989                              mov.l   24h+var_8[sp], r1
FFF24322  aa02                              mov.l   24h+var_4[sp], r2
FFF24324  a2a9                              mov.l   r1, 2Ch[r2]
FFF24326  3e0100                 loc_FFF24326 mov.l   #0, 24h+var_20[sp]
FFF24329  a809                   loc_FFF24329 mov.l   24h+var_20[sp], r1
FFF2432B  a109                              mov.l   r1, 24h+var_10[sp]
FFF2432D  6709                              rtsd    #9
FFF2432F  7ea6                   sub_FFF2432F push.l  r6   ; <<<< FUNC sub_FFF2432F
FFF24331  7100dc                            add     #-24h, sp, sp
FFF24334  a201                              mov.l   r1, 24h+var_4[sp]
FFF24336  a18a                              mov.l   r2, 24h+var_8[sp]
FFF24338  a183                              mov.l   r3, 24h+var_C[sp]
FFF2433A  a10c                              mov.l   r4, 24h+var_10[sp]
FFF2433C  c5002c13                          mov.b   24h+arg_0[sp], 24h+var_11[sp]
FFF24340  e5000c03                          mov.l   24h+arg_4[sp], 24h+var_18[sp]
FFF24344  aa01                              mov.l   24h+var_4[sp], r1
FFF24346  05cf19ff                          bsr.a   sub_FFF15D15
FFF2434A  a009                              mov.l   r1, 24h+var_20[sp]
FFF2434C  a809                              mov.l   24h+var_20[sp], r1
FFF2434E  6101                              cmp     #0, r1
FFF24350  16                                beq.s   loc_FFF24356
FFF24351  f806de                            mov.l   #-22h, 24h+var_24[sp]
FFF24354  2e22                              bra.b   loc_FFF24376
FFF24356  a88d                   loc_FFF24356 mov.l   24h+var_18[sp], r5
FFF24358  8c8c                              mov.b   24h+var_11[sp], r4
FFF2435A  a90b                              mov.l   24h+var_10[sp], r3
FFF2435C  a982                              mov.l   24h+var_C[sp], r2
FFF2435E  aa01                              mov.l   24h+var_4[sp], r1
FFF24360  a98e                              mov.l   24h+var_8[sp], r6
FFF24362  6040                              sub     #4, sp
FFF24364  e305                              mov.l   r5, 28h+var_28[sp]
FFF24366  391700                            bsr.w   sub_FFF2437D
FFF24369  6240                              add     #4, sp
FFF2436B  e361                              mov.l   r1, [r6]
FFF2436D  aa01                              mov.l   24h+var_4[sp], r1
FFF2436F  05b119ff                          bsr.a   sub_FFF15D20
FFF24373  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF24376  ec01                   loc_FFF24376 mov.l   24h+var_24[sp], r1
FFF24378  a081                              mov.l   r1, 24h+var_1C[sp]
FFF2437A  3f660a                            rtsd    #28h, r6-r6
FFF2437D  7100c8                 sub_FFF2437D add     #-38h, sp, sp   ; <<<< FUNC sub_FFF2437D
FFF24380  a309                              mov.l   r1, 38h+var_4[sp]
FFF24382  a302                              mov.l   r2, 38h+var_8[sp]
FFF24384  a28b                              mov.l   r3, 38h+var_C[sp]
FFF24386  c7042b                            mov.b   r4, 38h+var_D[sp]
FFF24389  e5000f09                          mov.l   38h+arg_0[sp], 38h+var_14[sp]
FFF2438D  ab09                              mov.l   38h+var_4[sp], r1
FFF2438F  8c11                              mov.b   10h[r1], r1
FFF24391  755120                            cmp     #20h, r1 ; ' '
FFF24394  2133                              bne.b   loc_FFF243C7
FFF24396  cd012b                            mov.b   38h+var_D[sp], r1
FFF24399  755177                            cmp     #77h, r1 ; 'w'
FFF2439C  ab02                              mov.l   38h+var_8[sp], r2
FFF2439E  ab09                              mov.l   38h+var_4[sp], r1
FFF243A0  211d                              bne.b   loc_FFF243BD
FFF243A2  aa0c                              mov.l   38h+var_14[sp], r4
FFF243A4  aa8b                              mov.l   38h+var_C[sp], r3
FFF243A6  393b08                            bsr.w   sub_FFF24BE1
FFF243A9  6101                              cmp     #0, r1
FFF243AB  200c                              beq.b   loc_FFF243B7
FFF243AD  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF243B4  381702                            bra.w   loc_FFF245CB
FFF243B7  3e0100                 loc_FFF243B7 mov.l   #0, 38h+var_34[sp]
FFF243BA  381102                            bra.w   loc_FFF245CB
FFF243BD  aa0b                   loc_FFF243BD mov.l   38h+var_14[sp], r3
FFF243BF  39b807                            bsr.w   sub_FFF24B77
FFF243C2  a009                              mov.l   r1, 38h+var_34[sp]
FFF243C4  380702                            bra.w   loc_FFF245CB
FFF243C7  ab09                   loc_FFF243C7 mov.l   38h+var_4[sp], r1
FFF243C9  8c11                              mov.b   10h[r1], r1
FFF243CB  755110                            cmp     #10h, r1
FFF243CE  ab01                              mov.l   38h+var_8[sp], r1
FFF243D0  2124                              bne.b   loc_FFF243F4
FFF243D2  ab0a                              mov.l   38h+var_4[sp], r2
FFF243D4  adaa                              mov.l   5Ch[r2], r2
FFF243D6  6812                              shlr    #1, r2
FFF243D8  fc2721                            divu    r2, r1
FFF243DB  a109                              mov.l   r1, 38h+var_24[sp]
FFF243DD  ab09                              mov.l   38h+var_4[sp], r1
FFF243DF  ad99                              mov.l   5Ch[r1], r1
FFF243E1  6811                              shlr    #1, r1
FFF243E3  ab02                              mov.l   38h+var_8[sp], r2
FFF243E5  ef2e                              mov.l   r2, r14
FFF243E7  fc271e                            divu    r1, r14
FFF243EA  4f1e                              mul     r1, r14
FFF243EC  43e2                              sub     r14, r2
FFF243EE  6c12                              shll    #1, r2
FFF243F0  a182                              mov.l   r2, 38h+var_20[sp]
FFF243F2  2e21                              bra.b   loc_FFF24413
FFF243F4  ab0a                   loc_FFF243F4 mov.l   38h+var_4[sp], r2
FFF243F6  adaa                              mov.l   5Ch[r2], r2
FFF243F8  6c12                              shll    #1, r2
FFF243FA  6331                              mul     #3, r1
FFF243FC  fc2721                            divu    r2, r1
FFF243FF  a109                              mov.l   r1, 38h+var_24[sp]
FFF24401  ab01                              mov.l   38h+var_8[sp], r1
FFF24403  6331                              mul     #3, r1
FFF24405  6811                              shlr    #1, r1
FFF24407  ab0a                              mov.l   38h+var_4[sp], r2
FFF24409  adaa                              mov.l   5Ch[r2], r2
FFF2440B  068d0205                          mul     38h+var_24[sp].l, r2
FFF2440F  4321                              sub     r2, r1
FFF24411  a181                              mov.l   r1, 38h+var_20[sp]
FFF24413  aa0c                   loc_FFF24413 mov.l   38h+var_14[sp], r4
FFF24415  a90a                              mov.l   38h+var_24[sp], r2
FFF24417  ab09                              mov.l   38h+var_4[sp], r1
FFF24419  71030c                            add     #38h+var_2C, sp, r3
FFF2441C  39c2fc                            bsr.w   sub_FFF240DE
FFF2441F  6101                              cmp     #0, r1
FFF24421  200c                              beq.b   loc_FFF2442D
FFF24423  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF2442A  38a101                            bra.w   loc_FFF245CB
FFF2442D  ab09                   loc_FFF2442D mov.l   38h+var_4[sp], r1
FFF2442F  8c11                              mov.b   10h[r1], r1
FFF24431  755110                            cmp     #10h, r1
FFF24434  213f                              bne.b   loc_FFF24473
FFF24436  a889                              mov.l   38h+var_2C[sp], r1
FFF24438  06890106                          add     38h+var_20[sp].l, r1
FFF2443C  0568a800                          bsr.a   sub_FFF2ECA4
FFF24440  9109                              mov.w   r1, 38h+var_2E[sp]
FFF24442  cd012b                            mov.b   38h+var_D[sp], r1
FFF24445  755177                            cmp     #77h, r1 ; 'w'
FFF24448  3b6e01                            bne.w   loc_FFF245B6
FFF2444B  a889                              mov.l   38h+var_2C[sp], r1
FFF2444D  06890106                          add     38h+var_20[sp].l, r1
FFF24451  bd82                              movu.w  38h+var_C[sp], r2
FFF24453  052ea800                          bsr.a   sub_FFF2EC81
FFF24457  a88b                              mov.l   38h+var_2C[sp], r3
FFF24459  a90a                              mov.l   38h+var_24[sp], r2
FFF2445B  ab09                              mov.l   38h+var_4[sp], r1
FFF2445D  393bfd                            bsr.w   sub_FFF24198
FFF24460  a189                              mov.l   r1, 38h+var_1C[sp]
FFF24462  a989                              mov.l   38h+var_1C[sp], r1
FFF24464  6101                              cmp     #0, r1
FFF24466  3a5001                            beq.w   loc_FFF245B6
FFF24469  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF24470  385b01                            bra.w   loc_FFF245CB
FFF24473  a981                   loc_FFF24473 mov.l   38h+var_20[sp], r1
FFF24475  a88a                              mov.l   38h+var_2C[sp], r2
FFF24477  fec211                            movu.b  [r2, r1], r1
FFF2447A  8481                              mov.b   r1, 38h+var_26[sp]
FFF2447C  ab09                              mov.l   38h+var_4[sp], r1
FFF2447E  ad99                              mov.l   5Ch[r1], r1
FFF24480  6011                              sub     #1, r1
FFF24482  06850106                          cmp     38h+var_20[sp].l, r1
FFF24486  2124                              bne.b   loc_FFF244AA
FFF24488  f90606ff                          mov.l   #-1, 38h+var_20[sp]
FFF2448C  a90a                              mov.l   38h+var_24[sp], r2
FFF2448E  6212                              add     #1, r2
FFF24490  ab09                              mov.l   38h+var_4[sp], r1
FFF24492  a10a                              mov.l   r2, 38h+var_24[sp]
FFF24494  aa0c                              mov.l   38h+var_14[sp], r4
FFF24496  71030c                            add     #38h+var_2C, sp, r3
FFF24499  3945fc                            bsr.w   sub_FFF240DE
FFF2449C  6101                              cmp     #0, r1
FFF2449E  200c                              beq.b   loc_FFF244AA
FFF244A0  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF244A7  382401                            bra.w   loc_FFF245CB
FFF244AA  a981                   loc_FFF244AA mov.l   38h+var_20[sp], r1
FFF244AC  06890103                          add     38h+var_2C[sp].l, r1
FFF244B0  c5100113                          mov.b   1[r1], 38h+var_25[sp]
FFF244B4  710112                            add     #38h+var_26, sp, r1
FFF244B7  05eda700                          bsr.a   sub_FFF2ECA4
FFF244BB  9109                              mov.w   r1, 38h+var_2E[sp]
FFF244BD  ab01                              mov.l   38h+var_8[sp], r1
FFF244BF  7c01                              btst    #0, r1
FFF244C1  15                                beq.s   loc_FFF244C6
FFF244C2  f80600                            mov.l   #0, 38h+var_38[sp]
FFF244C5  0c                                bra.s   loc_FFF244C9
FFF244C6  f80601                 loc_FFF244C6 mov.l   #1, 38h+var_38[sp]
FFF244C9  cd012b                 loc_FFF244C9 mov.b   38h+var_D[sp], r1
FFF244CC  755177                            cmp     #77h, r1 ; 'w'
FFF244CF  fcdbe0                            sceq.l  r14
FFF244D2  ec01                              mov.l   38h+var_38[sp], r1
FFF244D4  6101                              cmp     #0, r1
FFF244D6  2021                              beq.b   loc_FFF244F7
FFF244D8  5bee                              movu.b  r14, r14
FFF244DA  610e                              cmp     #0, r14
FFF244DC  203a                              beq.b   loc_FFF24516
FFF244DE  ed0e0b                            mov.l   38h+var_C[sp], r14
FFF244E1  b90a                              movu.w  38h+var_2E[sp], r2
FFF244E3  772200f000                        and     #0F000h, r2
FFF244E8  762eff0f                          and     #0FFFh, r14
FFF244EC  57e2                              or      r14, r2
FFF244EE  710112                            add     #38h+var_26, sp, r1
FFF244F1  0590a700                          bsr.a   sub_FFF2EC81
FFF244F5  2e21                              bra.b   loc_FFF24516
FFF244F7  5bee                   loc_FFF244F7 movu.b  r14, r14
FFF244F9  610e                              cmp     #0, r14
FFF244FB  2015                              beq.b   loc_FFF24510
FFF244FD  aa89                              mov.l   38h+var_C[sp], r1
FFF244FF  b90a                              movu.w  38h+var_2E[sp], r2
FFF24501  64f2                              and     #0Fh, r2
FFF24503  6c41                              shll    #4, r1
FFF24505  5712                              or      r1, r2
FFF24507  5f22                              movu.w  r2, r2
FFF24509  710112                            add     #38h+var_26, sp, r1
FFF2450C  0575a700                          bsr.a   sub_FFF2EC81
FFF24510  b909                   loc_FFF24510 movu.w  38h+var_2E[sp], r1
FFF24512  6841                              shlr    #4, r1
FFF24514  9109                              mov.w   r1, 38h+var_2E[sp]
FFF24516  cd012b                 loc_FFF24516 mov.b   38h+var_D[sp], r1
FFF24519  755177                            cmp     #77h, r1 ; 'w'
FFF2451C  3b8100                            bne.w   loc_FFF2459D
FFF2451F  a981                              mov.l   38h+var_20[sp], r1
FFF24521  06890103                          add     38h+var_2C[sp].l, r1
FFF24525  c5011301                          mov.b   38h+var_25[sp], 1[r1]
FFF24529  a981                              mov.l   38h+var_20[sp], r1
FFF2452B  7501ff                            cmp     #-1, r1
FFF2452E  200d                              beq.b   loc_FFF2453B
FFF24530  b481                              movu.b  38h+var_26[sp], r1
FFF24532  a982                              mov.l   38h+var_20[sp], r2
FFF24534  a88b                              mov.l   38h+var_2C[sp], r3
FFF24536  fe0321                            mov.b   r1, [r3, r2]
FFF24539  2e4b                              bra.b   loc_FFF24584
FFF2453B  a88b                   loc_FFF2453B mov.l   38h+var_2C[sp], r3
FFF2453D  a90a                              mov.l   38h+var_24[sp], r2
FFF2453F  ab09                              mov.l   38h+var_4[sp], r1
FFF24541  3957fc                            bsr.w   sub_FFF24198
FFF24544  a189                              mov.l   r1, 38h+var_1C[sp]
FFF24546  a989                              mov.l   38h+var_1C[sp], r1
FFF24548  6101                              cmp     #0, r1
FFF2454A  12                                beq.s   loc_FFF24554
FFF2454B  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF24552  2e79                              bra.b   loc_FFF245CB
FFF24554  a90a                   loc_FFF24554 mov.l   38h+var_24[sp], r2
FFF24556  6012                              sub     #1, r2
FFF24558  ab09                              mov.l   38h+var_4[sp], r1
FFF2455A  a10a                              mov.l   r2, 38h+var_24[sp]
FFF2455C  aa0c                              mov.l   38h+var_14[sp], r4
FFF2455E  71030c                            add     #38h+var_2C, sp, r3
FFF24561  397dfb                            bsr.w   sub_FFF240DE
FFF24564  a189                              mov.l   r1, 38h+var_1C[sp]
FFF24566  a989                              mov.l   38h+var_1C[sp], r1
FFF24568  6101                              cmp     #0, r1
FFF2456A  12                                beq.s   loc_FFF24574
FFF2456B  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF24572  2e59                              bra.b   loc_FFF245CB
FFF24574  ab09                   loc_FFF24574 mov.l   38h+var_4[sp], r1
FFF24576  ad99                              mov.l   5Ch[r1], r1
FFF24578  06890103                          add     38h+var_2C[sp].l, r1
FFF2457C  fbe6ff                            mov.l   #-1, r14
FFF2457F  b482                              movu.b  38h+var_26[sp], r2
FFF24581  fe01e2                            mov.b   r2, [r1, r14]
FFF24584  a88b                   loc_FFF24584 mov.l   38h+var_2C[sp], r3
FFF24586  a90a                              mov.l   38h+var_24[sp], r2
FFF24588  ab09                              mov.l   38h+var_4[sp], r1
FFF2458A  390efc                            bsr.w   sub_FFF24198
FFF2458D  a189                              mov.l   r1, 38h+var_1C[sp]
FFF2458F  a989                              mov.l   38h+var_1C[sp], r1
FFF24591  6101                              cmp     #0, r1
FFF24593  12                                beq.s   loc_FFF2459D
FFF24594  f90201f7ffff0f                    mov.l   #0FFFFFF7h, 38h+var_34[sp]
FFF2459B  2e30                              bra.b   loc_FFF245CB
FFF2459D  b909                   loc_FFF2459D movu.w  38h+var_2E[sp], r1
FFF2459F  7621ff0f                          and     #0FFFh, r1
FFF245A3  9109                              mov.w   r1, 38h+var_2E[sp]
FFF245A5  b909                              movu.w  38h+var_2E[sp], r1
FFF245A7  7601f70f                          cmp     #0FF7h, r1
FFF245AB  290b                              blt.b   loc_FFF245B6
FFF245AD  9909                              mov.w   38h+var_2E[sp], r1
FFF245AF  773100f000                        or      #0F000h, r1
FFF245B4  9109                              mov.w   r1, 38h+var_2E[sp]
FFF245B6  b909                   loc_FFF245B6 movu.w  38h+var_2E[sp], r1
FFF245B8  7701f8ff00                        cmp     #0FFF8h, r1
FFF245BD  290a                              blt.b   loc_FFF245C7
FFF245BF  f90201ffffff0f                    mov.l   #0FFFFFFFh, 38h+var_34[sp]
FFF245C6  0d                                bra.s   loc_FFF245CB
FFF245C7  b909                   loc_FFF245C7 movu.w  38h+var_2E[sp], r1
FFF245C9  a009                              mov.l   r1, 38h+var_34[sp]
FFF245CB  a809                   loc_FFF245CB mov.l   38h+var_34[sp], r1
FFF245CD  a201                              mov.l   r1, 38h+var_18[sp]
FFF245CF  670e                              rtsd    #0Eh
FFF245D1  7ea6                   sub_FFF245D1 push.l  r6   ; <<<< FUNC sub_FFF245D1
FFF245D3  7100e4                            add     #-1Ch, sp, sp
FFF245D6  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF245D8  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF245DA  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF245DC  a08c                              mov.l   r4, 1Ch+var_10[sp]
FFF245DE  6601                              mov.l   #0, r1
FFF245E0  ef12                              mov.l   r1, r2
FFF245E2  053ea8ff                          bsr.a   sub_FFF1EE20
FFF245E6  a981                              mov.l   1Ch+var_4[sp], r1
FFF245E8  052d17ff                          bsr.a   sub_FFF15D15
FFF245EC  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF245EE  a809                              mov.l   1Ch+var_18[sp], r1
FFF245F0  6101                              cmp     #0, r1
FFF245F2  16                                beq.s   loc_FFF245F8
FFF245F3  f806de                            mov.l   #-22h, 1Ch+var_1C[sp]
FFF245F6  2e27                              bra.b   loc_FFF2461D
FFF245F8  a88b                   loc_FFF245F8 mov.l   1Ch+var_10[sp], r3
FFF245FA  a90a                              mov.l   1Ch+var_8[sp], r2
FFF245FC  a981                              mov.l   1Ch+var_4[sp], r1
FFF245FE  a906                              mov.l   1Ch+var_C[sp], r6
FFF24600  392400                            bsr.w   sub_FFF24624
FFF24603  e361                              mov.l   r1, [r6]
FFF24605  a981                              mov.l   1Ch+var_4[sp], r1
FFF24607  051917ff                          bsr.a   sub_FFF15D20
FFF2460B  05ce16ff                          bsr.a   sub_FFF15CD9
FFF2460F  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF24611  a809                              mov.l   1Ch+var_18[sp], r1
FFF24613  6101                              cmp     #0, r1
FFF24615  15                                beq.s   loc_FFF2461A
FFF24616  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF24619  0c                                bra.s   loc_FFF2461D
FFF2461A  f80600                 loc_FFF2461A mov.l   #0, 1Ch+var_1C[sp]
FFF2461D  ec01                   loc_FFF2461D mov.l   1Ch+var_1C[sp], r1
FFF2461F  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24621  3f6608                            rtsd    #20h, r6-r6
FFF24624  7100d8                 sub_FFF24624 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF24624
FFF24627  a209                              mov.l   r1, 28h+var_4[sp]
FFF24629  a202                              mov.l   r2, 28h+var_8[sp]
FFF2462B  a18b                              mov.l   r3, 28h+var_C[sp]
FFF2462D  3c8700                            mov.b   #0, 28h+var_11[sp]
FFF24630  aa09                              mov.l   28h+var_4[sp], r1
FFF24632  8c12                              mov.b   10h[r1], r2
FFF24634  755220                            cmp     #20h, r2 ; ' '
FFF24637  2111                              bne.b   loc_FFF24648
FFF24639  a98b                              mov.l   28h+var_C[sp], r3
FFF2463B  aa02                              mov.l   28h+var_8[sp], r2
FFF2463D  39c304                            bsr.w   sub_FFF24B00
FFF24640  a009                              mov.l   r1, 28h+var_24[sp]
FFF24642  e10001                            mov.l   28h+var_24[sp], 28h+var_28[sp]
FFF24645  385f01                            bra.w   loc_FFF247A4
FFF24648  8c11                   loc_FFF24648 mov.b   10h[r1], r1
FFF2464A  755110                            cmp     #10h, r1
FFF2464D  aa09                              mov.l   28h+var_4[sp], r1
FFF2464F  ad99                              mov.l   5Ch[r1], r1
FFF24651  210e                              bne.b   loc_FFF2465F
FFF24653  6811                              shlr    #1, r1
FFF24655  aa0a                              mov.l   28h+var_4[sp], r2
FFF24657  068d2103                          mul     0Ch[r2].l, r1
FFF2465B  a081                              mov.l   r1, 28h+var_20[sp]
FFF2465D  2e10                              bra.b   loc_FFF2466D
FFF2465F  aa0a                   loc_FFF2465F mov.l   28h+var_4[sp], r2
FFF24661  068d2103                          mul     0Ch[r2].l, r1
FFF24665  6c11                              shll    #1, r1
FFF24667  fd749103                          divu    #3, r1
FFF2466B  a081                              mov.l   r1, 28h+var_20[sp]
FFF2466D  aa09                   loc_FFF2466D mov.l   28h+var_4[sp], r1
FFF2466F  a89a                              mov.l   0Ch[r1], r2
FFF24671  06cd1204                          mul     8[r1].uw, r2
FFF24675  06c91203                          add     6[r1].uw, r2
FFF24679  b91b                              movu.w  0Ah[r1], r3
FFF2467B  6c53                              shll    #5, r3
FFF2467D  06a1091317                        divu    5Ch[r1].l, r3
FFF24682  4b32                              add     r3, r2
FFF24684  a91b                              mov.l   14h[r1], r3
FFF24686  4323                              sub     r2, r3
FFF24688  06e1091302                        divu    4[r1].uw, r3
FFF2468D  6223                              add     #2, r3
FFF2468F  5f3e                              movu.w  r3, r14
FFF24691  06850e02                          cmp     28h+var_20[sp].l, r14
FFF24695  2228                              bgeu.b  loc_FFF246BD
FFF24697  aa09                              mov.l   28h+var_4[sp], r1
FFF24699  a89a                              mov.l   0Ch[r1], r2
FFF2469B  06cd1204                          mul     8[r1].uw, r2
FFF2469F  06c91203                          add     6[r1].uw, r2
FFF246A3  b91b                              movu.w  0Ah[r1], r3
FFF246A5  6c53                              shll    #5, r3
FFF246A7  06a1091317                        divu    5Ch[r1].l, r3
FFF246AC  4b32                              add     r3, r2
FFF246AE  a91b                              mov.l   14h[r1], r3
FFF246B0  4323                              sub     r2, r3
FFF246B2  06e1091302                        divu    4[r1].uw, r3
FFF246B7  6223                              add     #2, r3
FFF246B9  5f31                              movu.w  r3, r1
FFF246BB  a081                              mov.l   r1, 28h+var_20[sp]
FFF246BD  aa09                   loc_FFF246BD mov.l   28h+var_4[sp], r1
FFF246BF  e5100a03                          mov.l   28h[r1], 28h+var_1C[sp]
FFF246C3  38b200                            bra.w   loc_FFF24775
FFF246C6  a98b                   loc_FFF246C6 mov.l   28h+var_C[sp], r3
FFF246C8  a88a                              mov.l   28h+var_1C[sp], r2
FFF246CA  aa09                              mov.l   28h+var_4[sp], r1
FFF246CC  6040                              sub     #4, sp
FFF246CE  e303                              mov.l   r3, 2Ch+var_2C[sp]
FFF246D0  754472                            mov.l   #72h, r4 ; 'r'
FFF246D3  6603                              mov.l   #0, r3
FFF246D5  39a8fc                            bsr.w   sub_FFF2437D
FFF246D8  6240                              add     #4, sp
FFF246DA  a009                              mov.l   r1, 28h+var_24[sp]
FFF246DC  a809                              mov.l   28h+var_24[sp], r1
FFF246DE  6101                              cmp     #0, r1
FFF246E0  216b                              bne.b   loc_FFF2474B
FFF246E2  a889                              mov.l   28h+var_1C[sp], r1
FFF246E4  6211                              add     #1, r1
FFF246E6  aa0a                              mov.l   28h+var_4[sp], r2
FFF246E8  a2a1                              mov.l   r1, 28h[r2]
FFF246EA  a98b                              mov.l   28h+var_C[sp], r3
FFF246EC  a88a                              mov.l   28h+var_1C[sp], r2
FFF246EE  aa09                              mov.l   28h+var_4[sp], r1
FFF246F0  6040                              sub     #4, sp
FFF246F2  e303                              mov.l   r3, 2Ch+var_2C[sp]
FFF246F4  754477                            mov.l   #77h, r4 ; 'w'
FFF246F7  fb3effff00                        mov.l   #0FFFFh, r3
FFF246FC  3981fc                            bsr.w   sub_FFF2437D
FFF246FF  6240                              add     #4, sp
FFF24701  a101                              mov.l   r1, 28h+var_18[sp]
FFF24703  a901                              mov.l   28h+var_18[sp], r1
FFF24705  6101                              cmp     #0, r1
FFF24707  17                                beq.s   loc_FFF2470E
FFF24708  f80600                            mov.l   #0, 28h+var_28[sp]
FFF2470B  389900                            bra.w   loc_FFF247A4
FFF2470E  aa09                   loc_FFF2470E mov.l   28h+var_4[sp], r1
FFF24710  a88a                              mov.l   28h+var_1C[sp], r2
FFF24712  0685120b                          cmp     2Ch[r1].l, r2
FFF24716  1e                                bne.s   loc_FFF2471C
FFF24717  aa09                              mov.l   28h+var_4[sp], r1
FFF24719  3e1b00                            mov.l   #0, 2Ch[r1]
FFF2471C  aa01                   loc_FFF2471C mov.l   28h+var_8[sp], r1
FFF2471E  6101                              cmp     #0, r1
FFF24720  2026                              beq.b   loc_FFF24746
FFF24722  a98c                              mov.l   28h+var_C[sp], r4
FFF24724  a88b                              mov.l   28h+var_1C[sp], r3
FFF24726  aa02                              mov.l   28h+var_8[sp], r2
FFF24728  aa09                              mov.l   28h+var_4[sp], r1
FFF2472A  6040                              sub     #4, sp
FFF2472C  e304                              mov.l   r4, 2Ch+var_2C[sp]
FFF2472E  754477                            mov.l   #77h, r4 ; 'w'
FFF24731  394cfc                            bsr.w   sub_FFF2437D
FFF24734  6240                              add     #4, sp
FFF24736  a101                              mov.l   r1, 28h+var_18[sp]
FFF24738  a901                              mov.l   28h+var_18[sp], r1
FFF2473A  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF24740  1e                                bne.s   loc_FFF24746
FFF24741  f80600                            mov.l   #0, 28h+var_28[sp]
FFF24744  2e60                              bra.b   loc_FFF247A4
FFF24746  e10003                 loc_FFF24746 mov.l   28h+var_1C[sp], 28h+var_28[sp]
FFF24749  2e5b                              bra.b   loc_FFF247A4
FFF2474B  a809                   loc_FFF2474B mov.l   28h+var_24[sp], r1
FFF2474D  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF24753  1e                                bne.s   loc_FFF24759
FFF24754  f80600                            mov.l   #0, 28h+var_28[sp]
FFF24757  2e4d                              bra.b   loc_FFF247A4
FFF24759  aa09                   loc_FFF24759 mov.l   28h+var_4[sp], r1
FFF2475B  aa99                              mov.l   2Ch[r1], r1
FFF2475D  6101                              cmp     #0, r1
FFF2475F  2010                              beq.b   loc_FFF2476F
FFF24761  aa09                              mov.l   28h+var_4[sp], r1
FFF24763  e5110b0a                          mov.l   2Ch[r1], 28h[r1]
FFF24767  aa09                              mov.l   28h+var_4[sp], r1
FFF24769  3e1b00                            mov.l   #0, 2Ch[r1]
FFF2476C  3851ff                            bra.w   loc_FFF246BD
FFF2476F  a889                   loc_FFF2476F mov.l   28h+var_1C[sp], r1
FFF24771  6211                              add     #1, r1
FFF24773  a089                              mov.l   r1, 28h+var_1C[sp]
FFF24775  a889                   loc_FFF24775 mov.l   28h+var_1C[sp], r1
FFF24777  06850102                          cmp     28h+var_20[sp].l, r1
FFF2477B  2205                              bgeu.b  loc_FFF24780
FFF2477D  3849ff                            bra.w   loc_FFF246C6
FFF24780  a889                   loc_FFF24780 mov.l   28h+var_1C[sp], r1
FFF24782  06850102                          cmp     28h+var_20[sp].l, r1
FFF24786  211b                              bne.b   loc_FFF247A1
FFF24788  b589                              movu.b  28h+var_11[sp], r1
FFF2478A  711201                            add     #1, r1, r2
FFF2478D  858a                              mov.b   r2, 28h+var_11[sp]
FFF2478F  6101                              cmp     #0, r1
FFF24791  2110                              bne.b   loc_FFF247A1
FFF24793  aa09                              mov.l   28h+var_4[sp], r1
FFF24795  e5100a02                          mov.l   28h[r1], 28h+var_20[sp]
FFF24799  aa09                              mov.l   28h+var_4[sp], r1
FFF2479B  3e1a02                            mov.l   #2, 28h[r1]
FFF2479E  381fff                            bra.w   loc_FFF246BD
FFF247A1  f80600                 loc_FFF247A1 mov.l   #0, 28h+var_28[sp]
FFF247A4  ec01                   loc_FFF247A4 mov.l   28h+var_28[sp], r1
FFF247A6  a181                              mov.l   r1, 28h+var_10[sp]
FFF247A8  670a                              rtsd    #0Ah
FFF247AA  7ea6                   sub_FFF247AA push.l  r6   ; <<<< FUNC sub_FFF247AA
FFF247AC  7100e4                            add     #-1Ch, sp, sp
FFF247AF  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF247B1  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF247B3  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF247B5  a08c                              mov.l   r4, 1Ch+var_10[sp]
FFF247B7  a981                              mov.l   1Ch+var_4[sp], r1
FFF247B9  055c15ff                          bsr.a   sub_FFF15D15
FFF247BD  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF247BF  a809                              mov.l   1Ch+var_18[sp], r1
FFF247C1  6101                              cmp     #0, r1
FFF247C3  16                                beq.s   loc_FFF247C9
FFF247C4  f806de                            mov.l   #-22h, 1Ch+var_1C[sp]
FFF247C7  2e34                              bra.b   loc_FFF247FB
FFF247C9  a88b                   loc_FFF247C9 mov.l   1Ch+var_10[sp], r3
FFF247CB  a90a                              mov.l   1Ch+var_8[sp], r2
FFF247CD  a981                              mov.l   1Ch+var_4[sp], r1
FFF247CF  a906                              mov.l   1Ch+var_C[sp], r6
FFF247D1  6040                              sub     #4, sp
FFF247D3  e303                              mov.l   r3, 20h+var_20[sp]
FFF247D5  754472                            mov.l   #72h, r4 ; 'r'
FFF247D8  6603                              mov.l   #0, r3
FFF247DA  39a3fb                            bsr.w   sub_FFF2437D
FFF247DD  6240                              add     #4, sp
FFF247DF  e361                              mov.l   r1, [r6]
FFF247E1  a901                              mov.l   1Ch+var_C[sp], r1
FFF247E3  ec1e                              mov.l   [r1], r14
FFF247E5  740ef7ffff0f                      cmp     #0FFFFFF7h, r14
FFF247EB  2307                              bltu.b  loc_FFF247F2
FFF247ED  a901                              mov.l   1Ch+var_C[sp], r1
FFF247EF  f81600                            mov.l   #0, [r1]
FFF247F2  a981                   loc_FFF247F2 mov.l   1Ch+var_4[sp], r1
FFF247F4  052c15ff                          bsr.a   sub_FFF15D20
FFF247F8  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF247FB  ec01                   loc_FFF247FB mov.l   1Ch+var_1C[sp], r1
FFF247FD  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF247FF  3f6608                            rtsd    #20h, r6-r6
FFF24802  7ea6                   sub_FFF24802 push.l  r6   ; <<<< FUNC sub_FFF24802
FFF24804  7100dc                            add     #-24h, sp, sp
FFF24807  a201                              mov.l   r1, 24h+var_4[sp]
FFF24809  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2480B  a183                              mov.l   r3, 24h+var_C[sp]
FFF2480D  a10c                              mov.l   r4, 24h+var_10[sp]
FFF2480F  aa01                              mov.l   24h+var_4[sp], r1
FFF24811  b891                              movu.w  4[r1], r1
FFF24813  6121                              cmp     #2, r1
FFF24815  293b                              blt.b   loc_FFF24850
FFF24817  aa01                              mov.l   24h+var_4[sp], r1
FFF24819  a89a                              mov.l   0Ch[r1], r2
FFF2481B  06cd1204                          mul     8[r1].uw, r2
FFF2481F  06c91203                          add     6[r1].uw, r2
FFF24823  b91b                              movu.w  0Ah[r1], r3
FFF24825  6c53                              shll    #5, r3
FFF24827  06a1091317                        divu    5Ch[r1].l, r3
FFF2482C  4b32                              add     r3, r2
FFF2482E  a98b                              mov.l   24h+var_8[sp], r3
FFF24830  6213                              add     #1, r3
FFF24832  4323                              sub     r2, r3
FFF24834  b891                              movu.w  4[r1], r1
FFF24836  ef3e                              mov.l   r3, r14
FFF24838  fc271e                            divu    r1, r14
FFF2483B  4f1e                              mul     r1, r14
FFF2483D  43e3                              sub     r14, r3
FFF2483F  6103                              cmp     #0, r3
FFF24841  200f                              beq.b   loc_FFF24850
FFF24843  a989                              mov.l   24h+var_8[sp], r1
FFF24845  6211                              add     #1, r1
FFF24847  a982                              mov.l   24h+var_C[sp], r2
FFF24849  e321                              mov.l   r1, [r2]
FFF2484B  f80600                            mov.l   #0, 24h+var_24[sp]
FFF2484E  2e3d                              bra.b   loc_FFF2488B
FFF24850  a98a                   loc_FFF24850 mov.l   24h+var_8[sp], r2
FFF24852  aa01                              mov.l   24h+var_4[sp], r1
FFF24854  0591a7ff                          bsr.a   sub_FFF1EFE5
FFF24858  a089                              mov.l   r1, 24h+var_18[sp]
FFF2485A  a90c                              mov.l   24h+var_10[sp], r4
FFF2485C  a88a                              mov.l   24h+var_18[sp], r2
FFF2485E  aa01                              mov.l   24h+var_4[sp], r1
FFF24860  710308                            add     #24h+var_1C, sp, r3
FFF24863  396efd                            bsr.w   sub_FFF245D1
FFF24866  a009                              mov.l   r1, 24h+var_20[sp]
FFF24868  a809                              mov.l   24h+var_20[sp], r1
FFF2486A  6101                              cmp     #0, r1
FFF2486C  16                                beq.s   loc_FFF24872
FFF2486D  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF24870  2e1b                              bra.b   loc_FFF2488B
FFF24872  a881                   loc_FFF24872 mov.l   24h+var_1C[sp], r1
FFF24874  6101                              cmp     #0, r1
FFF24876  a986                              mov.l   24h+var_C[sp], r6
FFF24878  1e                                bne.s   loc_FFF2487E
FFF24879  f86600                            mov.l   #0, [r6]
FFF2487C  2e0c                              bra.b   loc_FFF24888
FFF2487E  a882                   loc_FFF2487E mov.l   24h+var_1C[sp], r2
FFF24880  aa01                              mov.l   24h+var_4[sp], r1
FFF24882  052aa7ff                          bsr.a   sub_FFF1EFAC
FFF24886  e361                              mov.l   r1, [r6]
FFF24888  f80600                 loc_FFF24888 mov.l   #0, 24h+var_24[sp]
FFF2488B  ec01                   loc_FFF2488B mov.l   24h+var_24[sp], r1
FFF2488D  a101                              mov.l   r1, 24h+var_14[sp]
FFF2488F  3f660a                            rtsd    #28h, r6-r6
FFF24892  7ea6                   sub_FFF24892 push.l  r6   ; <<<< FUNC sub_FFF24892
FFF24894  7100dc                            add     #-24h, sp, sp
FFF24897  a201                              mov.l   r1, 24h+var_4[sp]
FFF24899  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2489B  a183                              mov.l   r3, 24h+var_C[sp]
FFF2489D  a10c                              mov.l   r4, 24h+var_10[sp]
FFF2489F  aa01                              mov.l   24h+var_4[sp], r1
FFF248A1  b891                              movu.w  4[r1], r1
FFF248A3  6121                              cmp     #2, r1
FFF248A5  293b                              blt.b   loc_FFF248E0
FFF248A7  aa01                              mov.l   24h+var_4[sp], r1
FFF248A9  a89a                              mov.l   0Ch[r1], r2
FFF248AB  06cd1204                          mul     8[r1].uw, r2
FFF248AF  06c91203                          add     6[r1].uw, r2
FFF248B3  b91b                              movu.w  0Ah[r1], r3
FFF248B5  6c53                              shll    #5, r3
FFF248B7  06a1091317                        divu    5Ch[r1].l, r3
FFF248BC  4b32                              add     r3, r2
FFF248BE  a98b                              mov.l   24h+var_8[sp], r3
FFF248C0  6213                              add     #1, r3
FFF248C2  4323                              sub     r2, r3
FFF248C4  b891                              movu.w  4[r1], r1
FFF248C6  ef3e                              mov.l   r3, r14
FFF248C8  fc271e                            divu    r1, r14
FFF248CB  4f1e                              mul     r1, r14
FFF248CD  43e3                              sub     r14, r3
FFF248CF  6103                              cmp     #0, r3
FFF248D1  200f                              beq.b   loc_FFF248E0
FFF248D3  a989                              mov.l   24h+var_8[sp], r1
FFF248D5  6211                              add     #1, r1
FFF248D7  a982                              mov.l   24h+var_C[sp], r2
FFF248D9  e321                              mov.l   r1, [r2]
FFF248DB  f80600                            mov.l   #0, 24h+var_24[sp]
FFF248DE  2e3d                              bra.b   loc_FFF2491B
FFF248E0  a98a                   loc_FFF248E0 mov.l   24h+var_8[sp], r2
FFF248E2  aa01                              mov.l   24h+var_4[sp], r1
FFF248E4  0501a7ff                          bsr.a   sub_FFF1EFE5
FFF248E8  a089                              mov.l   r1, 24h+var_18[sp]
FFF248EA  a90c                              mov.l   24h+var_10[sp], r4
FFF248EC  a88a                              mov.l   24h+var_18[sp], r2
FFF248EE  aa01                              mov.l   24h+var_4[sp], r1
FFF248F0  710308                            add     #24h+var_1C, sp, r3
FFF248F3  39b7fe                            bsr.w   sub_FFF247AA
FFF248F6  a009                              mov.l   r1, 24h+var_20[sp]
FFF248F8  a809                              mov.l   24h+var_20[sp], r1
FFF248FA  6101                              cmp     #0, r1
FFF248FC  16                                beq.s   loc_FFF24902
FFF248FD  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF24900  2e1b                              bra.b   loc_FFF2491B
FFF24902  a881                   loc_FFF24902 mov.l   24h+var_1C[sp], r1
FFF24904  6101                              cmp     #0, r1
FFF24906  a986                              mov.l   24h+var_C[sp], r6
FFF24908  1e                                bne.s   loc_FFF2490E
FFF24909  f86600                            mov.l   #0, [r6]
FFF2490C  2e0c                              bra.b   loc_FFF24918
FFF2490E  a882                   loc_FFF2490E mov.l   24h+var_1C[sp], r2
FFF24910  aa01                              mov.l   24h+var_4[sp], r1
FFF24912  059aa6ff                          bsr.a   sub_FFF1EFAC
FFF24916  e361                              mov.l   r1, [r6]
FFF24918  f80600                 loc_FFF24918 mov.l   #0, 24h+var_24[sp]
FFF2491B  ec01                   loc_FFF2491B mov.l   24h+var_24[sp], r1
FFF2491D  a101                              mov.l   r1, 24h+var_14[sp]
FFF2491F  3f660a                            rtsd    #28h, r6-r6
FFF24922  7100e8                 sub_FFF24922 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF24922
FFF24925  a109                              mov.l   r1, 18h+var_4[sp]
FFF24927  a102                              mov.l   r2, 18h+var_8[sp]
FFF24929  a909                              mov.l   18h+var_4[sp], r1
FFF2492B  05ea13ff                          bsr.a   sub_FFF15D15
FFF2492F  a081                              mov.l   r1, 18h+var_10[sp]
FFF24931  a881                              mov.l   18h+var_10[sp], r1
FFF24933  6101                              cmp     #0, r1
FFF24935  16                                beq.s   loc_FFF2493B
FFF24936  f806de                            mov.l   #-22h, 18h+var_18[sp]
FFF24939  2e14                              bra.b   loc_FFF2494D
FFF2493B  a902                   loc_FFF2493B mov.l   18h+var_8[sp], r2
FFF2493D  a909                              mov.l   18h+var_4[sp], r1
FFF2493F  391400                            bsr.w   sub_FFF24953
FFF24942  a009                              mov.l   r1, 18h+var_14[sp]
FFF24944  a909                              mov.l   18h+var_4[sp], r1
FFF24946  05da13ff                          bsr.a   sub_FFF15D20
FFF2494A  e10001                            mov.l   18h+var_14[sp], 18h+var_18[sp]
FFF2494D  ec01                   loc_FFF2494D mov.l   18h+var_18[sp], r1
FFF2494F  a089                              mov.l   r1, 18h+var_C[sp]
FFF24951  6706                              rtsd    #6
FFF24953  7100e4                 sub_FFF24953 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF24953
FFF24956  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF24958  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2495A  a981                              mov.l   1Ch+var_4[sp], r1
FFF2495C  bf19                              movu.w  3Ah[r1], r1
FFF2495E  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24960  a909                              mov.l   1Ch+var_8[sp], r1
FFF24962  7211f40d                          add     #0DF4h, r1, r1
FFF24966  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF24968  a981                              mov.l   1Ch+var_4[sp], r1
FFF2496A  8c11                              mov.b   10h[r1], r1
FFF2496C  755120                            cmp     #20h, r1 ; ' '
FFF2496F  16                                beq.s   loc_FFF24975
FFF24970  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF24973  2e52                              bra.b   loc_FFF249C5
FFF24975  a90b                   loc_FFF24975 mov.l   1Ch+var_8[sp], r3
FFF24977  a882                              mov.l   1Ch+var_14[sp], r2
FFF24979  a981                              mov.l   1Ch+var_4[sp], r1
FFF2497B  72330c0c                          add     #0C0Ch, r3, r3
FFF2497F  6614                              mov.l   #1, r4
FFF24981  0590a6ff                          bsr.a   sub_FFF1F011
FFF24985  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF24987  a889                              mov.l   1Ch+var_10[sp], r1
FFF24989  6101                              cmp     #0, r1
FFF2498B  16                                beq.s   loc_FFF24991
FFF2498C  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF2498F  2e36                              bra.b   loc_FFF249C5
FFF24991  a809                   loc_FFF24991 mov.l   1Ch+var_18[sp], r1
FFF24993  711204                            add     #4, r1, r2
FFF24996  a00a                              mov.l   r2, 1Ch+var_18[sp]
FFF24998  a982                              mov.l   1Ch+var_4[sp], r2
FFF2499A  abaa                              mov.l   3Ch[r2], r2
FFF2499C  0537a300                          bsr.a   sub_FFF2ECD3
FFF249A0  a981                              mov.l   1Ch+var_4[sp], r1
FFF249A2  e5110a10                          mov.l   28h[r1], 40h[r1]
FFF249A6  a981                              mov.l   1Ch+var_4[sp], r1
FFF249A8  ac12                              mov.l   40h[r1], r2
FFF249AA  a809                              mov.l   1Ch+var_18[sp], r1
FFF249AC  0527a300                          bsr.a   sub_FFF2ECD3
FFF249B0  a90b                              mov.l   1Ch+var_8[sp], r3
FFF249B2  a882                              mov.l   1Ch+var_14[sp], r2
FFF249B4  a981                              mov.l   1Ch+var_4[sp], r1
FFF249B6  72330c0c                          add     #0C0Ch, r3, r3
FFF249BA  6614                              mov.l   #1, r4
FFF249BC  05e6a6ff                          bsr.a   sub_FFF1F0A2
FFF249C0  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF249C2  e10003                            mov.l   1Ch+var_10[sp], 1Ch+var_1C[sp]
FFF249C5  ec01                   loc_FFF249C5 mov.l   1Ch+var_1C[sp], r1
FFF249C7  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF249C9  6707                              rtsd    #7
FFF249CB  7100c8                 sub_FFF249CB add     #-38h, sp, sp   ; <<<< FUNC sub_FFF249CB
FFF249CE  a309                              mov.l   r1, 38h+var_4[sp]
FFF249D0  a302                              mov.l   r2, 38h+var_8[sp]
FFF249D2  a28b                              mov.l   r3, 38h+var_C[sp]
FFF249D4  3e0800                            mov.l   #0, 38h+var_18[sp]
FFF249D7  3e0200                            mov.l   #0, 38h+var_30[sp]
FFF249DA  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF249DD  ab09                              mov.l   38h+var_4[sp], r1
FFF249DF  ad9a                              mov.l   5Ch[r1], r2
FFF249E1  6822                              shlr    #2, r2
FFF249E3  068d1203                          mul     0Ch[r1].l, r2
FFF249E7  a182                              mov.l   r2, 38h+var_20[sp]
FFF249E9  ab09                              mov.l   38h+var_4[sp], r1
FFF249EB  a89a                              mov.l   0Ch[r1], r2
FFF249ED  06cd1204                          mul     8[r1].uw, r2
FFF249F1  06c91203                          add     6[r1].uw, r2
FFF249F5  b91b                              movu.w  0Ah[r1], r3
FFF249F7  6c53                              shll    #5, r3
FFF249F9  06a1091317                        divu    5Ch[r1].l, r3
FFF249FE  4b32                              add     r3, r2
FFF24A00  a91b                              mov.l   14h[r1], r3
FFF24A02  4323                              sub     r2, r3
FFF24A04  06e1091302                        divu    4[r1].uw, r3
FFF24A09  6223                              add     #2, r3
FFF24A0B  06850306                          cmp     38h+var_20[sp].l, r3
FFF24A0F  2226                              bgeu.b  loc_FFF24A35
FFF24A11  ab09                              mov.l   38h+var_4[sp], r1
FFF24A13  a89a                              mov.l   0Ch[r1], r2
FFF24A15  06cd1204                          mul     8[r1].uw, r2
FFF24A19  06c91203                          add     6[r1].uw, r2
FFF24A1D  b91b                              movu.w  0Ah[r1], r3
FFF24A1F  6c53                              shll    #5, r3
FFF24A21  06a1091317                        divu    5Ch[r1].l, r3
FFF24A26  4b32                              add     r3, r2
FFF24A28  a91b                              mov.l   14h[r1], r3
FFF24A2A  4323                              sub     r2, r3
FFF24A2C  06e1091302                        divu    4[r1].uw, r3
FFF24A31  6223                              add     #2, r3
FFF24A33  a183                              mov.l   r3, 38h+var_20[sp]
FFF24A35  ab09                   loc_FFF24A35 mov.l   38h+var_4[sp], r1
FFF24A37  e5100a07                          mov.l   28h[r1], 38h+var_1C[sp]
FFF24A3B  f90605ff                          mov.l   #-1, 38h+var_24[sp]
FFF24A3F  388e00                            bra.w   loc_FFF24ACD
FFF24A42  ab0a                   loc_FFF24A42 mov.l   38h+var_4[sp], r2
FFF24A44  adaa                              mov.l   5Ch[r2], r2
FFF24A46  6822                              shlr    #2, r2
FFF24A48  fc2721                            divu    r2, r1
FFF24A4B  a089                              mov.l   r1, 38h+var_2C[sp]
FFF24A4D  ab09                              mov.l   38h+var_4[sp], r1
FFF24A4F  ad99                              mov.l   5Ch[r1], r1
FFF24A51  6821                              shlr    #2, r1
FFF24A53  a98a                              mov.l   38h+var_1C[sp], r2
FFF24A55  ef2e                              mov.l   r2, r14
FFF24A57  fc271e                            divu    r1, r14
FFF24A5A  4f1e                              mul     r1, r14
FFF24A5C  43e2                              sub     r14, r2
FFF24A5E  6c22                              shll    #2, r2
FFF24A60  a102                              mov.l   r2, 38h+var_28[sp]
FFF24A62  a909                              mov.l   38h+var_24[sp], r1
FFF24A64  06850103                          cmp     38h+var_2C[sp].l, r1
FFF24A68  201e                              beq.b   loc_FFF24A86
FFF24A6A  aa8c                              mov.l   38h+var_C[sp], r4
FFF24A6C  a88a                              mov.l   38h+var_2C[sp], r2
FFF24A6E  ab09                              mov.l   38h+var_4[sp], r1
FFF24A70  710304                            add     #38h+var_34, sp, r3
FFF24A73  396bf6                            bsr.w   sub_FFF240DE
FFF24A76  a209                              mov.l   r1, 38h+var_14[sp]
FFF24A78  aa09                              mov.l   38h+var_14[sp], r1
FFF24A7A  6101                              cmp     #0, r1
FFF24A7C  16                                beq.s   loc_FFF24A82
FFF24A7D  e10009                            mov.l   38h+var_14[sp], 38h+var_38[sp]
FFF24A80  2e7a                              bra.b   loc_FFF24AFA
FFF24A82  e5000305               loc_FFF24A82 mov.l   38h+var_2C[sp], 38h+var_24[sp]
FFF24A86  a809                   loc_FFF24A86 mov.l   38h+var_34[sp], r1
FFF24A88  6101                              cmp     #0, r1
FFF24A8A  200e                              beq.b   loc_FFF24A98
FFF24A8C  a809                              mov.l   38h+var_34[sp], r1
FFF24A8E  06890104                          add     38h+var_28[sp].l, r1
FFF24A92  0588a200                          bsr.a   sub_FFF2ED1A
FFF24A96  a081                              mov.l   r1, 38h+var_30[sp]
FFF24A98  a881                   loc_FFF24A98 mov.l   38h+var_30[sp], r1
FFF24A9A  6101                              cmp     #0, r1
FFF24A9C  2115                              bne.b   loc_FFF24AB1
FFF24A9E  a989                              mov.l   38h+var_1C[sp], r1
FFF24AA0  ab02                              mov.l   38h+var_8[sp], r2
FFF24AA2  e321                              mov.l   r1, [r2]
FFF24AA4  a989                              mov.l   38h+var_1C[sp], r1
FFF24AA6  6211                              add     #1, r1
FFF24AA8  ab0a                              mov.l   38h+var_4[sp], r2
FFF24AAA  a2a1                              mov.l   r1, 28h[r2]
FFF24AAC  f80600                            mov.l   #0, 38h+var_38[sp]
FFF24AAF  2e4b                              bra.b   loc_FFF24AFA
FFF24AB1  ab09                   loc_FFF24AB1 mov.l   38h+var_4[sp], r1
FFF24AB3  aa99                              mov.l   2Ch[r1], r1
FFF24AB5  6101                              cmp     #0, r1
FFF24AB7  2010                              beq.b   loc_FFF24AC7
FFF24AB9  ab09                              mov.l   38h+var_4[sp], r1
FFF24ABB  e5110b0a                          mov.l   2Ch[r1], 28h[r1]
FFF24ABF  ab09                              mov.l   38h+var_4[sp], r1
FFF24AC1  3e1b00                            mov.l   #0, 2Ch[r1]
FFF24AC4  3871ff                            bra.w   loc_FFF24A35
FFF24AC7  a989                   loc_FFF24AC7 mov.l   38h+var_1C[sp], r1
FFF24AC9  6211                              add     #1, r1
FFF24ACB  a189                              mov.l   r1, 38h+var_1C[sp]
FFF24ACD  a989                   loc_FFF24ACD mov.l   38h+var_1C[sp], r1
FFF24ACF  06850106                          cmp     38h+var_20[sp].l, r1
FFF24AD3  2205                              bgeu.b  loc_FFF24AD8
FFF24AD5  386dff                            bra.w   loc_FFF24A42
FFF24AD8  06850106               loc_FFF24AD8 cmp     38h+var_20[sp].l, r1
FFF24ADC  211b                              bne.b   loc_FFF24AF7
FFF24ADE  aa01                              mov.l   38h+var_18[sp], r1
FFF24AE0  711201                            add     #1, r1, r2
FFF24AE3  a202                              mov.l   r2, 38h+var_18[sp]
FFF24AE5  6101                              cmp     #0, r1
FFF24AE7  2110                              bne.b   loc_FFF24AF7
FFF24AE9  ab09                              mov.l   38h+var_4[sp], r1
FFF24AEB  e5100a06                          mov.l   28h[r1], 38h+var_20[sp]
FFF24AEF  ab09                              mov.l   38h+var_4[sp], r1
FFF24AF1  3e1a02                            mov.l   #2, 28h[r1]
FFF24AF4  3841ff                            bra.w   loc_FFF24A35
FFF24AF7  f8069d                 loc_FFF24AF7 mov.l   #-63h, 38h+var_38[sp]
FFF24AFA  ec01                   loc_FFF24AFA mov.l   38h+var_38[sp], r1
FFF24AFC  a281                              mov.l   r1, 38h+var_10[sp]
FFF24AFE  670e                              rtsd    #0Eh
FFF24B00  7100e4                 sub_FFF24B00 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF24B00
FFF24B03  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF24B05  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF24B07  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF24B09  a981                              mov.l   1Ch+var_4[sp], r1
FFF24B0B  710204                            add     #1Ch+var_18, sp, r2
FFF24B0E  39bdfe                            bsr.w   sub_FFF249CB
FFF24B11  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24B13  a881                              mov.l   1Ch+var_14[sp], r1
FFF24B15  6101                              cmp     #0, r1
FFF24B17  16                                beq.s   loc_FFF24B1D
FFF24B18  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF24B1B  2e56                              bra.b   loc_FFF24B71
FFF24B1D  a904                   loc_FFF24B1D mov.l   1Ch+var_C[sp], r4
FFF24B1F  a80a                              mov.l   1Ch+var_18[sp], r2
FFF24B21  a981                              mov.l   1Ch+var_4[sp], r1
FFF24B23  fb32ffffff0f                      mov.l   #0FFFFFFFh, r3
FFF24B29  39b800                            bsr.w   sub_FFF24BE1
FFF24B2C  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24B2E  a881                              mov.l   1Ch+var_14[sp], r1
FFF24B30  6101                              cmp     #0, r1
FFF24B32  16                                beq.s   loc_FFF24B38
FFF24B33  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF24B36  2e3b                              bra.b   loc_FFF24B71
FFF24B38  a981                   loc_FFF24B38 mov.l   1Ch+var_4[sp], r1
FFF24B3A  a80a                              mov.l   1Ch+var_18[sp], r2
FFF24B3C  0685120b                          cmp     2Ch[r1].l, r2
FFF24B40  1e                                bne.s   loc_FFF24B46
FFF24B41  a981                              mov.l   1Ch+var_4[sp], r1
FFF24B43  3e1b00                            mov.l   #0, 2Ch[r1]
FFF24B46  a981                   loc_FFF24B46 mov.l   1Ch+var_4[sp], r1
FFF24B48  ab9a                              mov.l   3Ch[r1], r2
FFF24B4A  6012                              sub     #1, r2
FFF24B4C  a39a                              mov.l   r2, 3Ch[r1]
FFF24B4E  a909                              mov.l   1Ch+var_8[sp], r1
FFF24B50  6101                              cmp     #0, r1
FFF24B52  1e                                bne.s   loc_FFF24B58
FFF24B53  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF24B56  2e1b                              bra.b   loc_FFF24B71
FFF24B58  a904                   loc_FFF24B58 mov.l   1Ch+var_C[sp], r4
FFF24B5A  a80b                              mov.l   1Ch+var_18[sp], r3
FFF24B5C  a90a                              mov.l   1Ch+var_8[sp], r2
FFF24B5E  a981                              mov.l   1Ch+var_4[sp], r1
FFF24B60  398100                            bsr.w   sub_FFF24BE1
FFF24B63  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24B65  a881                              mov.l   1Ch+var_14[sp], r1
FFF24B67  6101                              cmp     #0, r1
FFF24B69  15                                beq.s   loc_FFF24B6E
FFF24B6A  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF24B6D  0c                                bra.s   loc_FFF24B71
FFF24B6E  e10001                 loc_FFF24B6E mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF24B71  ec01                   loc_FFF24B71 mov.l   1Ch+var_1C[sp], r1
FFF24B73  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF24B75  6707                              rtsd    #7
FFF24B77  7100d8                 sub_FFF24B77 add     #-28h, sp, sp   ; <<<< FUNC sub_FFF24B77
FFF24B7A  a209                              mov.l   r1, 28h+var_4[sp]
FFF24B7C  a202                              mov.l   r2, 28h+var_8[sp]
FFF24B7E  a18b                              mov.l   r3, 28h+var_C[sp]
FFF24B80  aa09                              mov.l   28h+var_4[sp], r1
FFF24B82  ad99                              mov.l   5Ch[r1], r1
FFF24B84  6821                              shlr    #2, r1
FFF24B86  aa02                              mov.l   28h+var_8[sp], r2
FFF24B88  fc2712                            divu    r1, r2
FFF24B8B  a082                              mov.l   r2, 28h+var_20[sp]
FFF24B8D  aa09                              mov.l   28h+var_4[sp], r1
FFF24B8F  ad99                              mov.l   5Ch[r1], r1
FFF24B91  6821                              shlr    #2, r1
FFF24B93  aa02                              mov.l   28h+var_8[sp], r2
FFF24B95  ef2e                              mov.l   r2, r14
FFF24B97  fc271e                            divu    r1, r14
FFF24B9A  4f1e                              mul     r1, r14
FFF24B9C  43e2                              sub     r14, r2
FFF24B9E  a00a                              mov.l   r2, 28h+var_24[sp]
FFF24BA0  a98c                              mov.l   28h+var_C[sp], r4
FFF24BA2  a882                              mov.l   28h+var_20[sp], r2
FFF24BA4  aa09                              mov.l   28h+var_4[sp], r1
FFF24BA6  71030c                            add     #28h+var_1C, sp, r3
FFF24BA9  3935f5                            bsr.w   sub_FFF240DE
FFF24BAC  a109                              mov.l   r1, 28h+var_14[sp]
FFF24BAE  a909                              mov.l   28h+var_14[sp], r1
FFF24BB0  6101                              cmp     #0, r1
FFF24BB2  2017                              beq.b   loc_FFF24BC9
FFF24BB4  aa09                              mov.l   28h+var_4[sp], r1
FFF24BB6  8c11                              mov.b   10h[r1], r1
FFF24BB8  755140                            cmp     #40h, r1 ; '@'
FFF24BBB  1e                                bne.s   loc_FFF24BC1
FFF24BBC  f806f7                            mov.l   #-9, 28h+var_28[sp]
FFF24BBF  2e1c                              bra.b   loc_FFF24BDB
FFF24BC1  f802f7ffff0f           loc_FFF24BC1 mov.l   #0FFFFFF7h, 28h+var_28[sp]
FFF24BC7  2e14                              bra.b   loc_FFF24BDB
FFF24BC9  a889                   loc_FFF24BC9 mov.l   28h+var_1C[sp], r1
FFF24BCB  a80a                              mov.l   28h+var_24[sp], r2
FFF24BCD  fe6211                            mov.l   [r2, r1], r1
FFF24BD0  a101                              mov.l   r1, 28h+var_18[sp]
FFF24BD2  710110                            add     #28h+var_18, sp, r1
FFF24BD5  0545a100                          bsr.a   sub_FFF2ED1A
FFF24BD9  e301                              mov.l   r1, 28h+var_28[sp]
FFF24BDB  ec01                   loc_FFF24BDB mov.l   28h+var_28[sp], r1
FFF24BDD  a181                              mov.l   r1, 28h+var_10[sp]
FFF24BDF  670a                              rtsd    #0Ah
FFF24BE1  7100d4                 sub_FFF24BE1 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF24BE1
FFF24BE4  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF24BE6  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF24BE8  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF24BEA  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF24BEC  aa81                              mov.l   2Ch+var_4[sp], r1
FFF24BEE  ad99                              mov.l   5Ch[r1], r1
FFF24BF0  6821                              shlr    #2, r1
FFF24BF2  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF24BF4  fc2712                            divu    r1, r2
FFF24BF7  a082                              mov.l   r2, 2Ch+var_24[sp]
FFF24BF9  aa81                              mov.l   2Ch+var_4[sp], r1
FFF24BFB  ad99                              mov.l   5Ch[r1], r1
FFF24BFD  6821                              shlr    #2, r1
FFF24BFF  aa0a                              mov.l   2Ch+var_8[sp], r2
FFF24C01  ef2e                              mov.l   r2, r14
FFF24C03  fc271e                            divu    r1, r14
FFF24C06  4f1e                              mul     r1, r14
FFF24C08  43e2                              sub     r14, r2
FFF24C0A  a00a                              mov.l   r2, 2Ch+var_28[sp]
FFF24C0C  a98c                              mov.l   2Ch+var_10[sp], r4
FFF24C0E  a882                              mov.l   2Ch+var_24[sp], r2
FFF24C10  aa81                              mov.l   2Ch+var_4[sp], r1
FFF24C12  71030c                            add     #2Ch+var_20, sp, r3
FFF24C15  39c9f4                            bsr.w   sub_FFF240DE
FFF24C18  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF24C1A  a909                              mov.l   2Ch+var_18[sp], r1
FFF24C1C  6101                              cmp     #0, r1
FFF24C1E  16                                beq.s   loc_FFF24C24
FFF24C1F  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF24C22  2e2b                              bra.b   loc_FFF24C4D
FFF24C24  710120                 loc_FFF24C24 add     #2Ch+var_C, sp, r1
FFF24C27  05f3a000                          bsr.a   sub_FFF2ED1A
FFF24C2B  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF24C2D  a901                              mov.l   2Ch+var_1C[sp], r1
FFF24C2F  a80a                              mov.l   2Ch+var_28[sp], r2
FFF24C31  a88b                              mov.l   2Ch+var_20[sp], r3
FFF24C33  fe2231                            mov.l   r1, [r2, r3]
FFF24C36  a88b                              mov.l   2Ch+var_20[sp], r3
FFF24C38  a882                              mov.l   2Ch+var_24[sp], r2
FFF24C3A  aa81                              mov.l   2Ch+var_4[sp], r1
FFF24C3C  395cf5                            bsr.w   sub_FFF24198
FFF24C3F  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF24C41  a909                              mov.l   2Ch+var_18[sp], r1
FFF24C43  6101                              cmp     #0, r1
FFF24C45  15                                beq.s   loc_FFF24C4A
FFF24C46  e10005                            mov.l   2Ch+var_18[sp], 2Ch+var_2C[sp]
FFF24C49  0c                                bra.s   loc_FFF24C4D
FFF24C4A  f80600                 loc_FFF24C4A mov.l   #0, 2Ch+var_2C[sp]
FFF24C4D  ec01                   loc_FFF24C4D mov.l   2Ch+var_2C[sp], r1
FFF24C4F  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF24C51  670b                              rtsd    #0Bh
FFF24C53  7100b8                 sub_FFF24C53 add     #-48h, sp, sp   ; <<<< FUNC sub_FFF24C53
FFF24C56  a409                              mov.l   r1, 48h+var_4[sp]
FFF24C58  a402                              mov.l   r2, 48h+var_8[sp]
FFF24C5A  a38b                              mov.l   r3, 48h+var_C[sp]
FFF24C5C  a384                              mov.l   r4, 48h+var_10[sp]
FFF24C5E  3e0b00                            mov.l   #0, 48h+var_1C[sp]
FFF24C61  3e0a00                            mov.l   #0, 48h+var_20[sp]
FFF24C64  3e0900                            mov.l   #0, 48h+var_24[sp]
FFF24C67  3e0800                            mov.l   #0, 48h+var_28[sp]
FFF24C6A  3e0200                            mov.l   #0, 48h+var_40[sp]
FFF24C6D  3e0100                            mov.l   #0, 48h+var_44[sp]
FFF24C70  ac09                              mov.l   48h+var_4[sp], r1
FFF24C72  ad9a                              mov.l   5Ch[r1], r2
FFF24C74  6822                              shlr    #2, r2
FFF24C76  068d1203                          mul     0Ch[r1].l, r2
FFF24C7A  a182                              mov.l   r2, 48h+var_30[sp]
FFF24C7C  ac09                              mov.l   48h+var_4[sp], r1
FFF24C7E  a89a                              mov.l   0Ch[r1], r2
FFF24C80  06cd1204                          mul     8[r1].uw, r2
FFF24C84  06c91203                          add     6[r1].uw, r2
FFF24C88  b91b                              movu.w  0Ah[r1], r3
FFF24C8A  6c53                              shll    #5, r3
FFF24C8C  06a1091317                        divu    5Ch[r1].l, r3
FFF24C91  4b32                              add     r3, r2
FFF24C93  a91b                              mov.l   14h[r1], r3
FFF24C95  4323                              sub     r2, r3
FFF24C97  06e1091302                        divu    4[r1].uw, r3
FFF24C9C  6223                              add     #2, r3
FFF24C9E  06850306                          cmp     48h+var_30[sp].l, r3
FFF24CA2  2226                              bgeu.b  loc_FFF24CC8
FFF24CA4  ac09                              mov.l   48h+var_4[sp], r1
FFF24CA6  a89a                              mov.l   0Ch[r1], r2
FFF24CA8  06cd1204                          mul     8[r1].uw, r2
FFF24CAC  06c91203                          add     6[r1].uw, r2
FFF24CB0  b91b                              movu.w  0Ah[r1], r3
FFF24CB2  6c53                              shll    #5, r3
FFF24CB4  06a1091317                        divu    5Ch[r1].l, r3
FFF24CB9  4b32                              add     r3, r2
FFF24CBB  a91b                              mov.l   14h[r1], r3
FFF24CBD  4323                              sub     r2, r3
FFF24CBF  06e1091302                        divu    4[r1].uw, r3
FFF24CC4  6223                              add     #2, r3
FFF24CC6  a183                              mov.l   r3, 48h+var_30[sp]
FFF24CC8  ac09                   loc_FFF24CC8 mov.l   48h+var_4[sp], r1
FFF24CCA  e5100a07                          mov.l   28h[r1], 48h+var_2C[sp]
FFF24CCE  f90605ff                          mov.l   #-1, 48h+var_34[sp]
FFF24CD2  389700                            bra.w   loc_FFF24D69
FFF24CD5  ac0a                   loc_FFF24CD5 mov.l   48h+var_4[sp], r2
FFF24CD7  adaa                              mov.l   5Ch[r2], r2
FFF24CD9  6822                              shlr    #2, r2
FFF24CDB  fc2721                            divu    r2, r1
FFF24CDE  a089                              mov.l   r1, 48h+var_3C[sp]
FFF24CE0  ac09                              mov.l   48h+var_4[sp], r1
FFF24CE2  ad99                              mov.l   5Ch[r1], r1
FFF24CE4  6821                              shlr    #2, r1
FFF24CE6  a98a                              mov.l   48h+var_2C[sp], r2
FFF24CE8  ef2e                              mov.l   r2, r14
FFF24CEA  fc271e                            divu    r1, r14
FFF24CED  4f1e                              mul     r1, r14
FFF24CEF  43e2                              sub     r14, r2
FFF24CF1  6c22                              shll    #2, r2
FFF24CF3  a102                              mov.l   r2, 48h+var_38[sp]
FFF24CF5  a909                              mov.l   48h+var_34[sp], r1
FFF24CF7  06850103                          cmp     48h+var_3C[sp].l, r1
FFF24CFB  201f                              beq.b   loc_FFF24D1A
FFF24CFD  ab84                              mov.l   48h+var_10[sp], r4
FFF24CFF  a88a                              mov.l   48h+var_3C[sp], r2
FFF24D01  ac09                              mov.l   48h+var_4[sp], r1
FFF24D03  710304                            add     #48h+var_44, sp, r3
FFF24D06  39d8f3                            bsr.w   sub_FFF240DE
FFF24D09  a301                              mov.l   r1, 48h+var_18[sp]
FFF24D0B  ab01                              mov.l   48h+var_18[sp], r1
FFF24D0D  6101                              cmp     #0, r1
FFF24D0F  17                                beq.s   loc_FFF24D16
FFF24D10  e1000c                            mov.l   48h+var_18[sp], 48h+var_48[sp]
FFF24D13  388300                            bra.w   loc_FFF24D96
FFF24D16  e5000305               loc_FFF24D16 mov.l   48h+var_3C[sp], 48h+var_34[sp]
FFF24D1A  a809                   loc_FFF24D1A mov.l   48h+var_44[sp], r1
FFF24D1C  6101                              cmp     #0, r1
FFF24D1E  200e                              beq.b   loc_FFF24D2C
FFF24D20  a809                              mov.l   48h+var_44[sp], r1
FFF24D22  06890104                          add     48h+var_38[sp].l, r1
FFF24D26  05f49f00                          bsr.a   sub_FFF2ED1A
FFF24D2A  a081                              mov.l   r1, 48h+var_40[sp]
FFF24D2C  a881                   loc_FFF24D2C mov.l   48h+var_40[sp], r1
FFF24D2E  6101                              cmp     #0, r1
FFF24D30  2133                              bne.b   loc_FFF24D63
FFF24D32  aa09                              mov.l   48h+var_24[sp], r1
FFF24D34  6211                              add     #1, r1
FFF24D36  06850107                          cmp     48h+var_2C[sp].l, r1
FFF24D3A  210d                              bne.b   loc_FFF24D47
FFF24D3C  aa81                              mov.l   48h+var_20[sp], r1
FFF24D3E  6211                              add     #1, r1
FFF24D40  a281                              mov.l   r1, 48h+var_20[sp]
FFF24D42  e5000709                          mov.l   48h+var_2C[sp], 48h+var_24[sp]
FFF24D46  0a                                bra.s   loc_FFF24D50
FFF24D47  3e0a01                 loc_FFF24D47 mov.l   #1, 48h+var_20[sp]
FFF24D4A  a989                              mov.l   48h+var_2C[sp], r1
FFF24D4C  a209                              mov.l   r1, 48h+var_24[sp]
FFF24D4E  a201                              mov.l   r1, 48h+var_28[sp]
FFF24D50  aa81                   loc_FFF24D50 mov.l   48h+var_20[sp], r1
FFF24D52  0685010f                          cmp     48h+var_C[sp].l, r1
FFF24D56  210d                              bne.b   loc_FFF24D63
FFF24D58  aa01                              mov.l   48h+var_28[sp], r1
FFF24D5A  ac02                              mov.l   48h+var_8[sp], r2
FFF24D5C  e321                              mov.l   r1, [r2]
FFF24D5E  f80600                            mov.l   #0, 48h+var_48[sp]
FFF24D61  2e35                              bra.b   loc_FFF24D96
FFF24D63  a989                   loc_FFF24D63 mov.l   48h+var_2C[sp], r1
FFF24D65  6211                              add     #1, r1
FFF24D67  a189                              mov.l   r1, 48h+var_2C[sp]
FFF24D69  a989                   loc_FFF24D69 mov.l   48h+var_2C[sp], r1
FFF24D6B  06850106                          cmp     48h+var_30[sp].l, r1
FFF24D6F  2205                              bgeu.b  loc_FFF24D74
FFF24D71  3864ff                            bra.w   loc_FFF24CD5
FFF24D74  06850106               loc_FFF24D74 cmp     48h+var_30[sp].l, r1
FFF24D78  211b                              bne.b   loc_FFF24D93
FFF24D7A  aa89                              mov.l   48h+var_1C[sp], r1
FFF24D7C  711201                            add     #1, r1, r2
FFF24D7F  a28a                              mov.l   r2, 48h+var_1C[sp]
FFF24D81  6101                              cmp     #0, r1
FFF24D83  2110                              bne.b   loc_FFF24D93
FFF24D85  ac09                              mov.l   48h+var_4[sp], r1
FFF24D87  e5100a06                          mov.l   28h[r1], 48h+var_30[sp]
FFF24D8B  ac09                              mov.l   48h+var_4[sp], r1
FFF24D8D  3e1a02                            mov.l   #2, 28h[r1]
FFF24D90  3838ff                            bra.w   loc_FFF24CC8
FFF24D93  f8069d                 loc_FFF24D93 mov.l   #-63h, 48h+var_48[sp]
FFF24D96  ec01                   loc_FFF24D96 mov.l   48h+var_48[sp], r1
FFF24D98  a309                              mov.l   r1, 48h+var_14[sp]
FFF24D9A  6712                              rtsd    #12h
FFF24D9C  7ea6                   sub_FFF24D9C push.l  r6   ; <<<< FUNC sub_FFF24D9C
FFF24D9E  7100e4                            add     #-1Ch, sp, sp
FFF24DA1  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF24DA3  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF24DA5  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF24DA7  a08c                              mov.l   r4, 1Ch+var_10[sp]
FFF24DA9  6601                              mov.l   #0, r1
FFF24DAB  ef12                              mov.l   r1, r2
FFF24DAD  0573a0ff                          bsr.a   sub_FFF1EE20
FFF24DB1  a981                              mov.l   1Ch+var_4[sp], r1
FFF24DB3  05620fff                          bsr.a   sub_FFF15D15
FFF24DB7  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF24DB9  a809                              mov.l   1Ch+var_18[sp], r1
FFF24DBB  6101                              cmp     #0, r1
FFF24DBD  16                                beq.s   loc_FFF24DC3
FFF24DBE  f806de                            mov.l   #-22h, 1Ch+var_1C[sp]
FFF24DC1  2e27                              bra.b   loc_FFF24DE8
FFF24DC3  a88b                   loc_FFF24DC3 mov.l   1Ch+var_10[sp], r3
FFF24DC5  a90a                              mov.l   1Ch+var_8[sp], r2
FFF24DC7  a981                              mov.l   1Ch+var_4[sp], r1
FFF24DC9  a906                              mov.l   1Ch+var_C[sp], r6
FFF24DCB  392400                            bsr.w   sub_FFF24DEF
FFF24DCE  e361                              mov.l   r1, [r6]
FFF24DD0  a981                              mov.l   1Ch+var_4[sp], r1
FFF24DD2  054e0fff                          bsr.a   sub_FFF15D20
FFF24DD6  05030fff                          bsr.a   sub_FFF15CD9
FFF24DDA  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF24DDC  a809                              mov.l   1Ch+var_18[sp], r1
FFF24DDE  6101                              cmp     #0, r1
FFF24DE0  15                                beq.s   loc_FFF24DE5
FFF24DE1  e10001                            mov.l   1Ch+var_18[sp], 1Ch+var_1C[sp]
FFF24DE4  0c                                bra.s   loc_FFF24DE8
FFF24DE5  f80600                 loc_FFF24DE5 mov.l   #0, 1Ch+var_1C[sp]
FFF24DE8  ec01                   loc_FFF24DE8 mov.l   1Ch+var_1C[sp], r1
FFF24DEA  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF24DEC  3f6608                            rtsd    #20h, r6-r6
FFF24DEF  7100dc                 sub_FFF24DEF add     #-24h, sp, sp   ; <<<< FUNC sub_FFF24DEF
FFF24DF2  a201                              mov.l   r1, 24h+var_4[sp]
FFF24DF4  a18a                              mov.l   r2, 24h+var_8[sp]
FFF24DF6  a183                              mov.l   r3, 24h+var_C[sp]
FFF24DF8  3e0400                            mov.l   #0, 24h+var_14[sp]
FFF24DFB  aa01                              mov.l   24h+var_4[sp], r1
FFF24DFD  8c12                              mov.b   10h[r1], r2
FFF24DFF  755220                            cmp     #20h, r2 ; ' '
FFF24E02  2111                              bne.b   loc_FFF24E13
FFF24E04  a983                              mov.l   24h+var_C[sp], r3
FFF24E06  a98a                              mov.l   24h+var_8[sp], r2
FFF24E08  39df00                            bsr.w   sub_FFF24EE7
FFF24E0B  a009                              mov.l   r1, 24h+var_20[sp]
FFF24E0D  e10001                            mov.l   24h+var_20[sp], 24h+var_24[sp]
FFF24E10  38d100                            bra.w   loc_FFF24EE1
FFF24E13  8c11                   loc_FFF24E13 mov.b   10h[r1], r1
FFF24E15  755110                            cmp     #10h, r1
FFF24E18  aa01                              mov.l   24h+var_4[sp], r1
FFF24E1A  ad99                              mov.l   5Ch[r1], r1
FFF24E1C  210e                              bne.b   loc_FFF24E2A
FFF24E1E  6811                              shlr    #1, r1
FFF24E20  aa02                              mov.l   24h+var_4[sp], r2
FFF24E22  068d2103                          mul     0Ch[r2].l, r1
FFF24E26  a081                              mov.l   r1, 24h+var_1C[sp]
FFF24E28  2e10                              bra.b   loc_FFF24E38
FFF24E2A  aa02                   loc_FFF24E2A mov.l   24h+var_4[sp], r2
FFF24E2C  068d2103                          mul     0Ch[r2].l, r1
FFF24E30  6c11                              shll    #1, r1
FFF24E32  fd749103                          divu    #3, r1
FFF24E36  a081                              mov.l   r1, 24h+var_1C[sp]
FFF24E38  aa01                   loc_FFF24E38 mov.l   24h+var_4[sp], r1
FFF24E3A  a89a                              mov.l   0Ch[r1], r2
FFF24E3C  06cd1204                          mul     8[r1].uw, r2
FFF24E40  06c91203                          add     6[r1].uw, r2
FFF24E44  b91b                              movu.w  0Ah[r1], r3
FFF24E46  6c53                              shll    #5, r3
FFF24E48  06a1091317                        divu    5Ch[r1].l, r3
FFF24E4D  4b32                              add     r3, r2
FFF24E4F  a91b                              mov.l   14h[r1], r3
FFF24E51  4323                              sub     r2, r3
FFF24E53  06e1091302                        divu    4[r1].uw, r3
FFF24E58  6223                              add     #2, r3
FFF24E5A  5f3e                              movu.w  r3, r14
FFF24E5C  06850e02                          cmp     24h+var_1C[sp].l, r14
FFF24E60  2228                              bgeu.b  loc_FFF24E88
FFF24E62  aa01                              mov.l   24h+var_4[sp], r1
FFF24E64  a89a                              mov.l   0Ch[r1], r2
FFF24E66  06cd1204                          mul     8[r1].uw, r2
FFF24E6A  06c91203                          add     6[r1].uw, r2
FFF24E6E  b91b                              movu.w  0Ah[r1], r3
FFF24E70  6c53                              shll    #5, r3
FFF24E72  06a1091317                        divu    5Ch[r1].l, r3
FFF24E77  4b32                              add     r3, r2
FFF24E79  a91b                              mov.l   14h[r1], r3
FFF24E7B  4323                              sub     r2, r3
FFF24E7D  06e1091302                        divu    4[r1].uw, r3
FFF24E82  6223                              add     #2, r3
FFF24E84  5f31                              movu.w  r3, r1
FFF24E86  a081                              mov.l   r1, 24h+var_1C[sp]
FFF24E88  a989                   loc_FFF24E88 mov.l   24h+var_8[sp], r1
FFF24E8A  6011                              sub     #1, r1
FFF24E8C  a089                              mov.l   r1, 24h+var_18[sp]
FFF24E8E  2e48                              bra.b   loc_FFF24ED6
FFF24E90  a983                   loc_FFF24E90 mov.l   24h+var_C[sp], r3
FFF24E92  a88a                              mov.l   24h+var_18[sp], r2
FFF24E94  aa01                              mov.l   24h+var_4[sp], r1
FFF24E96  6040                              sub     #4, sp
FFF24E98  e303                              mov.l   r3, 28h+var_28[sp]
FFF24E9A  754472                            mov.l   #72h, r4 ; 'r'
FFF24E9D  6603                              mov.l   #0, r3
FFF24E9F  39def4                            bsr.w   sub_FFF2437D
FFF24EA2  6240                              add     #4, sp
FFF24EA4  a009                              mov.l   r1, 24h+var_20[sp]
FFF24EA6  a809                              mov.l   24h+var_20[sp], r1
FFF24EA8  06850107                          cmp     24h+var_8[sp].l, r1
FFF24EAC  1e                                bne.s   loc_FFF24EB2
FFF24EAD  e10003                            mov.l   24h+var_18[sp], 24h+var_24[sp]
FFF24EB0  2e31                              bra.b   loc_FFF24EE1
FFF24EB2  a809                   loc_FFF24EB2 mov.l   24h+var_20[sp], r1
FFF24EB4  7401f7ffff0f                      cmp     #0FFFFFF7h, r1
FFF24EBA  1e                                bne.s   loc_FFF24EC0
FFF24EBB  f80600                            mov.l   #0, 24h+var_24[sp]
FFF24EBE  2e23                              bra.b   loc_FFF24EE1
FFF24EC0  a901                   loc_FFF24EC0 mov.l   24h+var_14[sp], r1
FFF24EC2  6101                              cmp     #0, r1
FFF24EC4  210c                              bne.b   loc_FFF24ED0
FFF24EC6  3e0301                            mov.l   #1, 24h+var_18[sp]
FFF24EC9  a901                              mov.l   24h+var_14[sp], r1
FFF24ECB  6211                              add     #1, r1
FFF24ECD  a101                              mov.l   r1, 24h+var_14[sp]
FFF24ECF  0f                                bra.s   loc_FFF24ED6
FFF24ED0  a889                   loc_FFF24ED0 mov.l   24h+var_18[sp], r1
FFF24ED2  6211                              add     #1, r1
FFF24ED4  a089                              mov.l   r1, 24h+var_18[sp]
FFF24ED6  a889                   loc_FFF24ED6 mov.l   24h+var_18[sp], r1
FFF24ED8  06850102                          cmp     24h+var_1C[sp].l, r1
FFF24EDC  23b4                              bltu.b  loc_FFF24E90
FFF24EDE  f80600                            mov.l   #0, 24h+var_24[sp]
FFF24EE1  ec01                   loc_FFF24EE1 mov.l   24h+var_24[sp], r1
FFF24EE3  a109                              mov.l   r1, 24h+var_10[sp]
FFF24EE5  6709                              rtsd    #9
FFF24EE7  7100c8                 sub_FFF24EE7 add     #-38h, sp, sp   ; <<<< FUNC sub_FFF24EE7
FFF24EEA  a309                              mov.l   r1, 38h+var_4[sp]
FFF24EEC  a302                              mov.l   r2, 38h+var_8[sp]
FFF24EEE  a28b                              mov.l   r3, 38h+var_C[sp]
FFF24EF0  3e0800                            mov.l   #0, 38h+var_18[sp]
FFF24EF3  3e0200                            mov.l   #0, 38h+var_30[sp]
FFF24EF6  3e0100                            mov.l   #0, 38h+var_34[sp]
FFF24EF9  ab09                              mov.l   38h+var_4[sp], r1
FFF24EFB  ad9a                              mov.l   5Ch[r1], r2
FFF24EFD  6822                              shlr    #2, r2
FFF24EFF  068d1203                          mul     0Ch[r1].l, r2
FFF24F03  a182                              mov.l   r2, 38h+var_20[sp]
FFF24F05  ab09                              mov.l   38h+var_4[sp], r1
FFF24F07  a89a                              mov.l   0Ch[r1], r2
FFF24F09  06cd1204                          mul     8[r1].uw, r2
FFF24F0D  06c91203                          add     6[r1].uw, r2
FFF24F11  b91b                              movu.w  0Ah[r1], r3
FFF24F13  6c53                              shll    #5, r3
FFF24F15  06a1091317                        divu    5Ch[r1].l, r3
FFF24F1A  4b32                              add     r3, r2
FFF24F1C  a91b                              mov.l   14h[r1], r3
FFF24F1E  4323                              sub     r2, r3
FFF24F20  06e1091302                        divu    4[r1].uw, r3
FFF24F25  6223                              add     #2, r3
FFF24F27  06850306                          cmp     38h+var_20[sp].l, r3
FFF24F2B  2226                              bgeu.b  loc_FFF24F51
FFF24F2D  ab09                              mov.l   38h+var_4[sp], r1
FFF24F2F  a89a                              mov.l   0Ch[r1], r2
FFF24F31  06cd1204                          mul     8[r1].uw, r2
FFF24F35  06c91203                          add     6[r1].uw, r2
FFF24F39  b91b                              movu.w  0Ah[r1], r3
FFF24F3B  6c53                              shll    #5, r3
FFF24F3D  06a1091317                        divu    5Ch[r1].l, r3
FFF24F42  4b32                              add     r3, r2
FFF24F44  a91b                              mov.l   14h[r1], r3
FFF24F46  4323                              sub     r2, r3
FFF24F48  06e1091302                        divu    4[r1].uw, r3
FFF24F4D  6223                              add     #2, r3
FFF24F4F  a183                              mov.l   r3, 38h+var_20[sp]
FFF24F51  ab01                   loc_FFF24F51 mov.l   38h+var_8[sp], r1
FFF24F53  6011                              sub     #1, r1
FFF24F55  a189                              mov.l   r1, 38h+var_1C[sp]
FFF24F57  f90605ff                          mov.l   #-1, 38h+var_24[sp]
FFF24F5B  2e7c                              bra.b   loc_FFF24FD7
FFF24F5D  ab09                   loc_FFF24F5D mov.l   38h+var_4[sp], r1
FFF24F5F  ad99                              mov.l   5Ch[r1], r1
FFF24F61  6821                              shlr    #2, r1
FFF24F63  a98a                              mov.l   38h+var_1C[sp], r2
FFF24F65  fc2712                            divu    r1, r2
FFF24F68  a08a                              mov.l   r2, 38h+var_2C[sp]
FFF24F6A  ab09                              mov.l   38h+var_4[sp], r1
FFF24F6C  ad99                              mov.l   5Ch[r1], r1
FFF24F6E  6821                              shlr    #2, r1
FFF24F70  a98a                              mov.l   38h+var_1C[sp], r2
FFF24F72  ef2e                              mov.l   r2, r14
FFF24F74  fc271e                            divu    r1, r14
FFF24F77  4f1e                              mul     r1, r14
FFF24F79  43e2                              sub     r14, r2
FFF24F7B  6c22                              shll    #2, r2
FFF24F7D  a102                              mov.l   r2, 38h+var_28[sp]
FFF24F7F  a909                              mov.l   38h+var_24[sp], r1
FFF24F81  06850103                          cmp     38h+var_2C[sp].l, r1
FFF24F85  201e                              beq.b   loc_FFF24FA3
FFF24F87  aa8c                              mov.l   38h+var_C[sp], r4
FFF24F89  a88a                              mov.l   38h+var_2C[sp], r2
FFF24F8B  ab09                              mov.l   38h+var_4[sp], r1
FFF24F8D  710304                            add     #38h+var_34, sp, r3
FFF24F90  394ef1                            bsr.w   sub_FFF240DE
FFF24F93  a209                              mov.l   r1, 38h+var_14[sp]
FFF24F95  aa09                              mov.l   38h+var_14[sp], r1
FFF24F97  6101                              cmp     #0, r1
FFF24F99  16                                beq.s   loc_FFF24F9F
FFF24F9A  f80600                            mov.l   #0, 38h+var_38[sp]
FFF24F9D  2e48                              bra.b   loc_FFF24FE5
FFF24F9F  e5000305               loc_FFF24F9F mov.l   38h+var_2C[sp], 38h+var_24[sp]
FFF24FA3  a809                   loc_FFF24FA3 mov.l   38h+var_34[sp], r1
FFF24FA5  6101                              cmp     #0, r1
FFF24FA7  200e                              beq.b   loc_FFF24FB5
FFF24FA9  a809                              mov.l   38h+var_34[sp], r1
FFF24FAB  06890104                          add     38h+var_28[sp].l, r1
FFF24FAF  056b9d00                          bsr.a   sub_FFF2ED1A
FFF24FB3  a081                              mov.l   r1, 38h+var_30[sp]
FFF24FB5  a881                   loc_FFF24FB5 mov.l   38h+var_30[sp], r1
FFF24FB7  0685010c                          cmp     38h+var_8[sp].l, r1
FFF24FBB  1e                                bne.s   loc_FFF24FC1
FFF24FBC  e10007                            mov.l   38h+var_1C[sp], 38h+var_38[sp]
FFF24FBF  2e26                              bra.b   loc_FFF24FE5
FFF24FC1  aa01                   loc_FFF24FC1 mov.l   38h+var_18[sp], r1
FFF24FC3  6101                              cmp     #0, r1
FFF24FC5  210c                              bne.b   loc_FFF24FD1
FFF24FC7  3e0702                            mov.l   #2, 38h+var_1C[sp]
FFF24FCA  aa01                              mov.l   38h+var_18[sp], r1
FFF24FCC  6211                              add     #1, r1
FFF24FCE  a201                              mov.l   r1, 38h+var_18[sp]
FFF24FD0  0f                                bra.s   loc_FFF24FD7
FFF24FD1  a989                   loc_FFF24FD1 mov.l   38h+var_1C[sp], r1
FFF24FD3  6211                              add     #1, r1
FFF24FD5  a189                              mov.l   r1, 38h+var_1C[sp]
FFF24FD7  a989                   loc_FFF24FD7 mov.l   38h+var_1C[sp], r1
FFF24FD9  06850106                          cmp     38h+var_20[sp].l, r1
FFF24FDD  2205                              bgeu.b  loc_FFF24FE2
FFF24FDF  387eff                            bra.w   loc_FFF24F5D
FFF24FE2  f80600                 loc_FFF24FE2 mov.l   #0, 38h+var_38[sp]
FFF24FE5  ec01                   loc_FFF24FE5 mov.l   38h+var_38[sp], r1
FFF24FE7  a281                              mov.l   r1, 38h+var_10[sp]
FFF24FE9  670e                              rtsd    #0Eh
FFF24FEB  6080                   sub_FFF24FEB sub     #8, sp   ; <<<< FUNC sub_FFF24FEB
FFF24FED  fbe2245e0600                      mov.l   #65E24h, r14
FFF24FF3  ecee                              mov.l   [r14], r14
FFF24FF5  610e                              cmp     #0, r14
FFF24FF7  1e                                bne.s   loc_FFF24FFD
FFF24FF8  f806ee                            mov.l   #-12h, 8+var_8[sp]
FFF24FFB  2e14                              bra.b   loc_FFF2500F
FFF24FFD  fbe22c5e0600           loc_FFF24FFD mov.l   #65E2Ch, r14
FFF25003  ecee                              mov.l   [r14], r14
FFF25005  610e                              cmp     #0, r14
FFF25007  1d                                bne.s   loc_FFF2500C
FFF25008  f806ef                            mov.l   #-11h, 8+var_8[sp]
FFF2500B  0c                                bra.s   loc_FFF2500F
FFF2500C  f80600                 loc_FFF2500C mov.l   #0, 8+var_8[sp]
FFF2500F  ec01                   loc_FFF2500F mov.l   8+var_8[sp], r1
FFF25011  a009                              mov.l   r1, 8+var_4[sp]
FFF25013  6702                              rtsd    #2
FFF25015  7100e4                 sub_FFF25015 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF25015
FFF25018  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2501A  928a                              mov.w   r2, 1Ch+var_6[sp]
FFF2501C  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF2501E  918c                              mov.w   r4, 1Ch+var_E[sp]
FFF25020  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF25023  9a8b                              mov.w   1Ch+var_6[sp], r3
FFF25025  a981                              mov.l   1Ch+var_4[sp], r1
FFF25027  76136804                          mul     #468h, r3
FFF2502B  6602                              mov.l   #0, r2
FFF2502D  ef24                              mov.l   r2, r4
FFF2502F  05809400                          bsr.a   sub_FFF2E4AF
FFF25033  998b                              mov.w   1Ch+var_E[sp], r3
FFF25035  a901                              mov.l   1Ch+var_C[sp], r1
FFF25037  76134c02                          mul     #24Ch, r3
FFF2503B  6602                              mov.l   #0, r2
FFF2503D  ef24                              mov.l   r2, r4
FFF2503F  05709400                          bsr.a   sub_FFF2E4AF
FFF25043  fbe2245e0600                      mov.l   #65E24h, r14
FFF25049  e10e06                            mov.l   1Ch+var_4[sp], [r14]
FFF2504C  fbe212250100                      mov.l   #12512h, r14
FFF25052  d10e0b                            mov.w   1Ch+var_6[sp], [r14]
FFF25055  fbe2285e0600                      mov.l   #65E28h, r14
FFF2505B  e10e04                            mov.l   1Ch+var_C[sp], [r14]
FFF2505E  fbe214250100                      mov.l   #12514h, r14
FFF25064  d10e07                            mov.w   1Ch+var_E[sp], [r14]
FFF25067  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2506D  f8e600                            mov.l   #0, [r14]
FFF25070  05240eff                          bsr.a   sub_FFF15E94
FFF25074  053d0eff                          bsr.a   sub_FFF15EB1
FFF25078  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2507A  a809                              mov.l   1Ch+var_18[sp], r1
FFF2507C  69f1                              shlr    #1Fh, r1
FFF2507E  6101                              cmp     #0, r1
FFF25080  2010                              beq.b   loc_FFF25090
FFF25082  6602                              mov.l   #0, r2
FFF25084  fb16e2                            mov.l   #-1Eh, r1
FFF25087  05999dff                          bsr.a   sub_FFF1EE20
FFF2508B  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2508D  388a00                            bra.w   loc_FFF25117
FFF25090  05730cff               loc_FFF25090 bsr.a   sub_FFF15D03
FFF25094  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF25096  a809                              mov.l   1Ch+var_18[sp], r1
FFF25098  6101                              cmp     #0, r1
FFF2509A  200f                              beq.b   loc_FFF250A9
FFF2509C  6602                              mov.l   #0, r2
FFF2509E  fb16dc                            mov.l   #-24h, r1
FFF250A1  057f9dff                          bsr.a   sub_FFF1EE20
FFF250A5  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF250A7  2e70                              bra.b   loc_FFF25117
FFF250A9  05820cff               loc_FFF250A9 bsr.a   sub_FFF15D2B
FFF250AD  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF250AF  a809                              mov.l   1Ch+var_18[sp], r1
FFF250B1  6101                              cmp     #0, r1
FFF250B3  200f                              beq.b   loc_FFF250C2
FFF250B5  6602                              mov.l   #0, r2
FFF250B7  fb16df                            mov.l   #-21h, r1
FFF250BA  05669dff                          bsr.a   sub_FFF1EE20
FFF250BE  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF250C0  2e57                              bra.b   loc_FFF25117
FFF250C2  05bd0cff               loc_FFF250C2 bsr.a   sub_FFF15D7F
FFF250C6  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF250C8  a809                              mov.l   1Ch+var_18[sp], r1
FFF250CA  6101                              cmp     #0, r1
FFF250CC  200f                              beq.b   loc_FFF250DB
FFF250CE  6602                              mov.l   #0, r2
FFF250D0  fb16d9                            mov.l   #-27h, r1
FFF250D3  054d9dff                          bsr.a   sub_FFF1EE20
FFF250D7  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF250D9  2e3e                              bra.b   loc_FFF25117
FFF250DB  05ce0cff               loc_FFF250DB bsr.a   sub_FFF15DA9
FFF250DF  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF250E1  a809                              mov.l   1Ch+var_18[sp], r1
FFF250E3  6101                              cmp     #0, r1
FFF250E5  200f                              beq.b   loc_FFF250F4
FFF250E7  6602                              mov.l   #0, r2
FFF250E9  fb16d6                            mov.l   #-2Ah, r1
FFF250EC  05349dff                          bsr.a   sub_FFF1EE20
FFF250F0  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF250F2  2e25                              bra.b   loc_FFF25117
FFF250F4  05050dff               loc_FFF250F4 bsr.a   sub_FFF15DF9
FFF250F8  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF250FA  a809                              mov.l   1Ch+var_18[sp], r1
FFF250FC  6101                              cmp     #0, r1
FFF250FE  200f                              beq.b   loc_FFF2510D
FFF25100  6602                              mov.l   #0, r2
FFF25102  fb16c2                            mov.l   #-3Eh, r1
FFF25105  051b9dff                          bsr.a   sub_FFF1EE20
FFF25109  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2510B  2e0c                              bra.b   loc_FFF25117
FFF2510D  6601                   loc_FFF2510D mov.l   #0, r1
FFF2510F  ef12                              mov.l   r1, r2
FFF25111  050f9dff                          bsr.a   sub_FFF1EE20
FFF25115  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF25117  ec01                   loc_FFF25117 mov.l   1Ch+var_1C[sp], r1
FFF25119  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2511B  6707                              rtsd    #7
FFF2511D  7100e8                 sub_FFF2511D add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2511D
FFF25120  a109                              mov.l   r1, 18h+var_4[sp]
FFF25122  848a                              mov.b   r2, 18h+var_5[sp]
FFF25124  a08b                              mov.l   r3, 18h+var_C[sp]
FFF25126  a084                              mov.l   r4, 18h+var_10[sp]
FFF25128  b705                              movu.b  18h+arg_0[sp], r5
FFF2512A  818d                              mov.b   r5, 18h+var_11[sp]
FFF2512C  a884                              mov.l   18h+var_10[sp], r4
FFF2512E  a88b                              mov.l   18h+var_C[sp], r3
FFF25130  8c8a                              mov.b   18h+var_5[sp], r2
FFF25132  a909                              mov.l   18h+var_4[sp], r1
FFF25134  6080                              sub     #8, sp
FFF25136  c305                              mov.b   r5, 20h+var_20[sp]
FFF25138  f90a010002                        mov.l   #200h, 20h+var_1C[sp]
FFF2513D  390900                            bsr.w   sub_FFF25146
FFF25140  6280                              add     #8, sp
FFF25142  e301                              mov.l   r1, 18h+var_18[sp]
FFF25144  6706                              rtsd    #6
FFF25146  7ea6                   sub_FFF25146 push.l  r6   ; <<<< FUNC sub_FFF25146
FFF25148  7100cc                            add     #-34h, sp, sp
FFF2514B  a301                              mov.l   r1, 34h+var_4[sp]
FFF2514D  c7022f                            mov.b   r2, 34h+var_5[sp]
FFF25150  a283                              mov.l   r3, 34h+var_C[sp]
FFF25152  a20c                              mov.l   r4, 34h+var_10[sp]
FFF25154  c5003c23                          mov.b   34h+arg_0[sp], 34h+var_11[sp]
FFF25158  e5001007                          mov.l   34h+arg_4[sp], 34h+var_18[sp]
FFF2515C  398ffe                            bsr.w   sub_FFF24FEB
FFF2515F  a109                              mov.l   r1, 34h+var_20[sp]
FFF25161  a909                              mov.l   34h+var_20[sp], r1
FFF25163  7501ee                            cmp     #-12h, r1
FFF25166  210f                              bne.b   loc_FFF25175
FFF25168  a909                              mov.l   34h+var_20[sp], r1
FFF2516A  6602                              mov.l   #0, r2
FFF2516C  05b49cff                          bsr.a   sub_FFF1EE20
FFF25170  a009                              mov.l   r1, 34h+var_30[sp]
FFF25172  383302                            bra.w   loc_FFF253A5
FFF25175  a98c                   loc_FFF25175 mov.l   34h+var_18[sp], r4
FFF25177  ab01                              mov.l   34h+var_4[sp], r1
FFF25179  754370                            mov.l   #70h, r3 ; 'p'
FFF2517C  6602                              mov.l   #0, r2
FFF2517E  05319300                          bsr.a   sub_FFF2E4AF
FFF25182  cd012f                            mov.b   34h+var_5[sp], r1
FFF25185  ab06                              mov.l   34h+var_4[sp], r6
FFF25187  05049600                          bsr.a   sub_FFF2E78B
FFF2518B  8469                              mov.b   r1, 11h[r6]
FFF2518D  aa81                              mov.l   34h+var_C[sp], r1
FFF2518F  ab02                              mov.l   34h+var_4[sp], r2
FFF25191  a1a1                              mov.l   r1, 18h[r2]
FFF25193  aa09                              mov.l   34h+var_10[sp], r1
FFF25195  ab02                              mov.l   34h+var_4[sp], r2
FFF25197  a1a9                              mov.l   r1, 1Ch[r2]
FFF25199  a989                              mov.l   34h+var_18[sp], r1
FFF2519B  ab02                              mov.l   34h+var_4[sp], r2
FFF2519D  a5a9                              mov.l   r1, 5Ch[r2]
FFF2519F  ab01                              mov.l   34h+var_4[sp], r1
FFF251A1  f9145800                          mov.b   #0, 58h[r1]
FFF251A5  cd0123                            mov.b   34h+var_11[sp], r1
FFF251A8  6101                              cmp     #0, r1
FFF251AA  16                                beq.s   loc_FFF251B0
FFF251AB  ab01                              mov.l   34h+var_4[sp], r1
FFF251AD  f11058                            bset    #0, 58h[r1].b
FFF251B0  ab01                   loc_FFF251B0 mov.l   34h+var_4[sp], r1
FFF251B2  3e1d00                            mov.l   #0, 34h[r1]
FFF251B5  ab01                              mov.l   34h+var_4[sp], r1
FFF251B7  3e1a02                            mov.l   #2, 28h[r1]
FFF251BA  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF251C0  ecee                              mov.l   [r14], r14
FFF251C2  610e                              cmp     #0, r14
FFF251C4  210d                              bne.b   loc_FFF251D1
FFF251C6  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF251CC  e10e0c                            mov.l   34h+var_4[sp], [r14]
FFF251CF  2e1a                              bra.b   loc_FFF251E9
FFF251D1  fbe22c5e0600           loc_FFF251D1 mov.l   #65E2Ch, r14
FFF251D7  e4e004                            mov.l   [r14], 34h+var_24[sp]
FFF251DA  0c                                bra.s   loc_FFF251DE
FFF251DB  e41004                 loc_FFF251DB mov.l   [r1], 34h+var_24[sp]
FFF251DE  a901                   loc_FFF251DE mov.l   34h+var_24[sp], r1
FFF251E0  ec1e                              mov.l   [r1], r14
FFF251E2  610e                              cmp     #0, r14
FFF251E4  21f7                              bne.b   loc_FFF251DB
FFF251E6  e1010c                            mov.l   34h+var_4[sp], [r1]
FFF251E9  ab01                   loc_FFF251E9 mov.l   34h+var_4[sp], r1
FFF251EB  f81600                            mov.l   #0, [r1]
FFF251EE  ab01                              mov.l   34h+var_4[sp], r1
FFF251F0  f9152400                          mov.w   #0, 48h[r1]
FFF251F4  ab01                              mov.l   34h+var_4[sp], r1
FFF251F6  f9152500                          mov.w   #0, 4Ah[r1]
FFF251FA  ab01                              mov.l   34h+var_4[sp], r1
FFF251FC  3e9100                            mov.l   #0, 44h[r1]
FFF251FF  ab01                              mov.l   34h+var_4[sp], r1
FFF25201  f9152800                          mov.w   #0, 50h[r1]
FFF25205  ab01                              mov.l   34h+var_4[sp], r1
FFF25207  f9152900                          mov.w   #0, 52h[r1]
FFF2520B  ab01                              mov.l   34h+var_4[sp], r1
FFF2520D  3e9300                            mov.l   #0, 4Ch[r1]
FFF25210  ab01                              mov.l   34h+var_4[sp], r1
FFF25212  a995                              mov.l   18h[r1], r5
FFF25214  6040                              sub     #4, sp
FFF25216  f80501                            mov.w   #1, 38h+var_38[sp]
FFF25219  6603                              mov.l   #0, r3
FFF2521B  6652                              mov.l   #5, r2
FFF2521D  ef34                              mov.l   r3, r4
FFF2521F  7f15                              jsr     r5
FFF25221  6240                              add     #4, sp
FFF25223  a109                              mov.l   r1, 34h+var_20[sp]
FFF25225  a909                              mov.l   34h+var_20[sp], r1
FFF25227  6101                              cmp     #0, r1
FFF25229  200d                              beq.b   loc_FFF25236
FFF2522B  a909                              mov.l   34h+var_20[sp], r1
FFF2522D  05289cff                          bsr.a   sub_FFF1EE55
FFF25231  a009                              mov.l   r1, 34h+var_30[sp]
FFF25233  387201                            bra.w   loc_FFF253A5
FFF25236  ab01                   loc_FFF25236 mov.l   34h+var_4[sp], r1
FFF25238  051b0bff                          bsr.a   sub_FFF15D53
FFF2523C  a109                              mov.l   r1, 34h+var_20[sp]
FFF2523E  a909                              mov.l   34h+var_20[sp], r1
FFF25240  69f1                              shlr    #1Fh, r1
FFF25242  6101                              cmp     #0, r1
FFF25244  2010                              beq.b   loc_FFF25254
FFF25246  6602                              mov.l   #0, r2
FFF25248  fb16d3                            mov.l   #-2Dh, r1
FFF2524B  05d59bff                          bsr.a   sub_FFF1EE20
FFF2524F  a009                              mov.l   r1, 34h+var_30[sp]
FFF25251  385401                            bra.w   loc_FFF253A5
FFF25254  cd0123                 loc_FFF25254 mov.b   34h+var_11[sp], r1
FFF25257  6101                              cmp     #0, r1
FFF25259  15                                beq.s   loc_FFF2525E
FFF2525A  f80600                            mov.l   #0, 34h+var_34[sp]
FFF2525D  0c                                bra.s   loc_FFF25261
FFF2525E  f80601                 loc_FFF2525E mov.l   #1, 34h+var_34[sp]
FFF25261  ec01                   loc_FFF25261 mov.l   34h+var_34[sp], r1
FFF25263  6101                              cmp     #0, r1
FFF25265  3a3601                            beq.w   loc_FFF2539B
FFF25268  ab01                              mov.l   34h+var_4[sp], r1
FFF2526A  a995                              mov.l   18h[r1], r5
FFF2526C  6040                              sub     #4, sp
FFF2526E  f80501                            mov.w   #1, 38h+var_38[sp]
FFF25271  6603                              mov.l   #0, r3
FFF25273  6672                              mov.l   #7, r2
FFF25275  ef34                              mov.l   r3, r4
FFF25277  7f15                              jsr     r5
FFF25279  6240                              add     #4, sp
FFF2527B  a109                              mov.l   r1, 34h+var_20[sp]
FFF2527D  a909                              mov.l   34h+var_20[sp], r1
FFF2527F  6101                              cmp     #0, r1
FFF25281  200d                              beq.b   loc_FFF2528E
FFF25283  a909                              mov.l   34h+var_20[sp], r1
FFF25285  05d09bff                          bsr.a   sub_FFF1EE55
FFF25289  a009                              mov.l   r1, 34h+var_30[sp]
FFF2528B  381a01                            bra.w   loc_FFF253A5
FFF2528E  ab01                   loc_FFF2528E mov.l   34h+var_4[sp], r1
FFF25290  8c11                              mov.b   10h[r1], r1
FFF25292  755140                            cmp     #40h, r1 ; '@'
FFF25295  203b                              beq.b   loc_FFF252D0
FFF25297  ab01                              mov.l   34h+var_4[sp], r1
FFF25299  ad9a                              mov.l   5Ch[r1], r2
FFF2529B  06cd1202                          mul     4[r1].uw, r2
FFF2529F  7702010002                        cmp     #20001h, r2
FFF252A4  232c                              bltu.b  loc_FFF252D0
FFF252A6  ab01                              mov.l   34h+var_4[sp], r1
FFF252A8  05b60aff                          bsr.a   sub_FFF15D5E
FFF252AC  a109                              mov.l   r1, 34h+var_20[sp]
FFF252AE  a909                              mov.l   34h+var_20[sp], r1
FFF252B0  6101                              cmp     #0, r1
FFF252B2  2010                              beq.b   loc_FFF252C2
FFF252B4  6602                              mov.l   #0, r2
FFF252B6  fb16cb                            mov.l   #-35h, r1
FFF252B9  05679bff                          bsr.a   sub_FFF1EE20
FFF252BD  a009                              mov.l   r1, 34h+var_30[sp]
FFF252BF  38e600                            bra.w   loc_FFF253A5
FFF252C2  6602                   loc_FFF252C2 mov.l   #0, r2
FFF252C4  fb16f0                            mov.l   #-10h, r1
FFF252C7  05599bff                          bsr.a   sub_FFF1EE20
FFF252CB  a009                              mov.l   r1, 34h+var_30[sp]
FFF252CD  38d800                            bra.w   loc_FFF253A5
FFF252D0  ab01                   loc_FFF252D0 mov.l   34h+var_4[sp], r1
FFF252D2  8c11                              mov.b   10h[r1], r1
FFF252D4  755120                            cmp     #20h, r1 ; ' '
FFF252D7  3bc400                            bne.w   loc_FFF2539B
FFF252DA  ab01                              mov.l   34h+var_4[sp], r1
FFF252DC  ab99                              mov.l   3Ch[r1], r1
FFF252DE  7501ff                            cmp     #-1, r1
FFF252E1  214d                              bne.b   loc_FFF2532E
FFF252E3  05b30bff                          bsr.a   sub_FFF15E96
FFF252E7  a081                              mov.l   r1, 34h+var_2C[sp]
FFF252E9  a881                              mov.l   34h+var_2C[sp], r1
FFF252EB  6101                              cmp     #0, r1
FFF252ED  ab01                              mov.l   34h+var_4[sp], r1
FFF252EF  212a                              bne.b   loc_FFF25319
FFF252F1  056d0aff                          bsr.a   sub_FFF15D5E
FFF252F5  a109                              mov.l   r1, 34h+var_20[sp]
FFF252F7  a909                              mov.l   34h+var_20[sp], r1
FFF252F9  6101                              cmp     #0, r1
FFF252FB  2010                              beq.b   loc_FFF2530B
FFF252FD  6602                              mov.l   #0, r2
FFF252FF  fb16cb                            mov.l   #-35h, r1
FFF25302  051e9bff                          bsr.a   sub_FFF1EE20
FFF25306  a009                              mov.l   r1, 34h+var_30[sp]
FFF25308  389d00                            bra.w   loc_FFF253A5
FFF2530B  6602                   loc_FFF2530B mov.l   #0, r2
FFF2530D  fb16e1                            mov.l   #-1Fh, r1
FFF25310  05109bff                          bsr.a   sub_FFF1EE20
FFF25314  a009                              mov.l   r1, 34h+var_30[sp]
FFF25316  388f00                            bra.w   loc_FFF253A5
FFF25319  8c19                   loc_FFF25319 mov.b   11h[r1], r1
FFF2531B  a884                              mov.l   34h+var_2C[sp], r4
FFF2531D  71020c                            add     #34h+var_28, sp, r2
FFF25320  ef23                              mov.l   r2, r3
FFF25322  05f23b00                          bsr.a   sub_FFF28F14
FFF25326  a109                              mov.l   r1, 34h+var_20[sp]
FFF25328  a881                              mov.l   34h+var_2C[sp], r1
FFF2532A  057c0bff                          bsr.a   sub_FFF15EA6
FFF2532E  ab01                   loc_FFF2532E mov.l   34h+var_4[sp], r1
FFF25330  ac11                              mov.l   40h[r1], r1
FFF25332  7501ff                            cmp     #-1, r1
FFF25335  1e                                bne.s   loc_FFF2533B
FFF25336  ab01                              mov.l   34h+var_4[sp], r1
FFF25338  3e9002                            mov.l   #2, 40h[r1]
FFF2533B  ab01                   loc_FFF2533B mov.l   34h+var_4[sp], r1
FFF2533D  e511100a                          mov.l   40h[r1], 28h[r1]
FFF25341  05550bff                          bsr.a   sub_FFF15E96
FFF25345  a081                              mov.l   r1, 34h+var_2C[sp]
FFF25347  a881                              mov.l   34h+var_2C[sp], r1
FFF25349  6101                              cmp     #0, r1
FFF2534B  ab01                              mov.l   34h+var_4[sp], r1
FFF2534D  2128                              bne.b   loc_FFF25375
FFF2534F  050f0aff                          bsr.a   sub_FFF15D5E
FFF25353  a109                              mov.l   r1, 34h+var_20[sp]
FFF25355  a909                              mov.l   34h+var_20[sp], r1
FFF25357  6101                              cmp     #0, r1
FFF25359  200f                              beq.b   loc_FFF25368
FFF2535B  6602                              mov.l   #0, r2
FFF2535D  fb16cb                            mov.l   #-35h, r1
FFF25360  05c09aff                          bsr.a   sub_FFF1EE20
FFF25364  a009                              mov.l   r1, 34h+var_30[sp]
FFF25366  2e3f                              bra.b   loc_FFF253A5
FFF25368  6602                   loc_FFF25368 mov.l   #0, r2
FFF2536A  fb16e1                            mov.l   #-1Fh, r1
FFF2536D  05b39aff                          bsr.a   sub_FFF1EE20
FFF25371  a009                              mov.l   r1, 34h+var_30[sp]
FFF25373  2e32                              bra.b   loc_FFF253A5
FFF25375  a884                   loc_FFF25375 mov.l   34h+var_2C[sp], r4
FFF25377  6643                              mov.l   #4, r3
FFF25379  71020c                            add     #34h+var_28, sp, r2
FFF2537C  05d7f8ff                          bsr.a   sub_FFF24C53
FFF25380  6101                              cmp     #0, r1
FFF25382  15                                beq.s   loc_FFF25387
FFF25383  f80600                            mov.l   #0, 34h+var_34[sp]
FFF25386  0c                                bra.s   loc_FFF2538A
FFF25387  f80601                 loc_FFF25387 mov.l   #1, 34h+var_34[sp]
FFF2538A  ec01                   loc_FFF2538A mov.l   34h+var_34[sp], r1
FFF2538C  6101                              cmp     #0, r1
FFF2538E  17                                beq.s   loc_FFF25395
FFF2538F  a889                              mov.l   34h+var_28[sp], r1
FFF25391  ab02                              mov.l   34h+var_4[sp], r2
FFF25393  a2a1                              mov.l   r1, 28h[r2]
FFF25395  a881                   loc_FFF25395 mov.l   34h+var_2C[sp], r1
FFF25397  050f0bff                          bsr.a   sub_FFF15EA6
FFF2539B  a909                   loc_FFF2539B mov.l   34h+var_20[sp], r1
FFF2539D  6602                              mov.l   #0, r2
FFF2539F  05819aff                          bsr.a   sub_FFF1EE20
FFF253A3  a009                              mov.l   r1, 34h+var_30[sp]
FFF253A5  a809                   loc_FFF253A5 mov.l   34h+var_30[sp], r1
FFF253A7  a181                              mov.l   r1, 34h+var_1C[sp]
FFF253A9  3f660e                            rtsd    #38h, r6-r6
FFF253AC  7100ec                 sub_FFF253AC add     #-14h, sp, sp   ; <<<< FUNC sub_FFF253AC
FFF253AF  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF253B5  e4e002                            mov.l   [r14], 14h+var_C[sp]
FFF253B8  3933fc                            bsr.w   sub_FFF24FEB
FFF253BB  a089                              mov.l   r1, 14h+var_8[sp]
FFF253BD  a889                              mov.l   14h+var_8[sp], r1
FFF253BF  7501ee                            cmp     #-12h, r1
FFF253C2  210f                              bne.b   loc_FFF253D1
FFF253C4  6601                              mov.l   #0, r1
FFF253C6  ef12                              mov.l   r1, r2
FFF253C8  05589aff                          bsr.a   sub_FFF1EE20
FFF253CC  e301                              mov.l   r1, 14h+var_14[sp]
FFF253CE  384801                            bra.w   loc_FFF25516
FFF253D1  fbe212250100           loc_FFF253D1 mov.l   #12512h, r14
FFF253D7  dce3                              mov.w   [r14], r3
FFF253D9  fbe2245e0600                      mov.l   #65E24h, r14
FFF253DF  ece1                              mov.l   [r14], r1
FFF253E1  76136804                          mul     #468h, r3
FFF253E5  6602                              mov.l   #0, r2
FFF253E7  ef24                              mov.l   r2, r4
FFF253E9  05c69000                          bsr.a   sub_FFF2E4AF
FFF253ED  fbe214250100                      mov.l   #12514h, r14
FFF253F3  dce3                              mov.w   [r14], r3
FFF253F5  fbe2285e0600                      mov.l   #65E28h, r14
FFF253FB  ece1                              mov.l   [r14], r1
FFF253FD  76134c02                          mul     #24Ch, r3
FFF25401  6602                              mov.l   #0, r2
FFF25403  ef24                              mov.l   r2, r4
FFF25405  05aa9000                          bsr.a   sub_FFF2E4AF
FFF25409  fbe2245e0600                      mov.l   #65E24h, r14
FFF2540F  f8e600                            mov.l   #0, [r14]
FFF25412  fbe212250100                      mov.l   #12512h, r14
FFF25418  f8e500                            mov.w   #0, [r14]
FFF2541B  fbe2285e0600                      mov.l   #65E28h, r14
FFF25421  f8e600                            mov.l   #0, [r14]
FFF25424  fbe214250100                      mov.l   #12514h, r14
FFF2542A  f8e500                            mov.w   #0, [r14]
FFF2542D  a881                              mov.l   14h+var_C[sp], r1
FFF2542F  6101                              cmp     #0, r1
FFF25431  2037                              beq.b   loc_FFF25468
FFF25433  a881                   loc_FFF25433 mov.l   14h+var_C[sp], r1
FFF25435  ae11                              mov.l   60h[r1], r1
FFF25437  6101                              cmp     #0, r1
FFF25439  2b1e                              ble.b   loc_FFF25457
FFF2543B  a881                              mov.l   14h+var_C[sp], r1
FFF2543D  052109ff                          bsr.a   sub_FFF15D5E
FFF25441  a089                              mov.l   r1, 14h+var_8[sp]
FFF25443  a889                              mov.l   14h+var_8[sp], r1
FFF25445  6101                              cmp     #0, r1
FFF25447  2010                              beq.b   loc_FFF25457
FFF25449  6602                              mov.l   #0, r2
FFF2544B  fb16cb                            mov.l   #-35h, r1
FFF2544E  05d299ff                          bsr.a   sub_FFF1EE20
FFF25452  e301                              mov.l   r1, 14h+var_14[sp]
FFF25454  38c200                            bra.w   loc_FFF25516
FFF25457  e5000201               loc_FFF25457 mov.l   14h+var_C[sp], 14h+var_10[sp]
FFF2545B  a881                              mov.l   14h+var_C[sp], r1
FFF2545D  e41002                            mov.l   [r1], 14h+var_C[sp]
FFF25460  a809                              mov.l   14h+var_10[sp], r1
FFF25462  ec1e                              mov.l   [r1], r14
FFF25464  610e                              cmp     #0, r14
FFF25466  21cd                              bne.b   loc_FFF25433
FFF25468  fbe22c5e0600           loc_FFF25468 mov.l   #65E2Ch, r14
FFF2546E  f8e600                            mov.l   #0, [r14]
FFF25471  05240aff                          bsr.a   sub_FFF15E95
FFF25475  05450aff                          bsr.a   sub_FFF15EBA
FFF25479  a089                              mov.l   r1, 14h+var_8[sp]
FFF2547B  a889                              mov.l   14h+var_8[sp], r1
FFF2547D  6101                              cmp     #0, r1
FFF2547F  2010                              beq.b   loc_FFF2548F
FFF25481  6602                              mov.l   #0, r2
FFF25483  fb16d0                            mov.l   #-30h, r1
FFF25486  059a99ff                          bsr.a   sub_FFF1EE20
FFF2548A  e301                              mov.l   r1, 14h+var_14[sp]
FFF2548C  388a00                            bra.w   loc_FFF25516
FFF2548F  057d08ff               loc_FFF2548F bsr.a   sub_FFF15D0C
FFF25493  a089                              mov.l   r1, 14h+var_8[sp]
FFF25495  a889                              mov.l   14h+var_8[sp], r1
FFF25497  6101                              cmp     #0, r1
FFF25499  200f                              beq.b   loc_FFF254A8
FFF2549B  6602                              mov.l   #0, r2
FFF2549D  fb16ce                            mov.l   #-32h, r1
FFF254A0  058099ff                          bsr.a   sub_FFF1EE20
FFF254A4  e301                              mov.l   r1, 14h+var_14[sp]
FFF254A6  2e70                              bra.b   loc_FFF25516
FFF254A8  058c08ff               loc_FFF254A8 bsr.a   sub_FFF15D34
FFF254AC  a089                              mov.l   r1, 14h+var_8[sp]
FFF254AE  a889                              mov.l   14h+var_8[sp], r1
FFF254B0  6101                              cmp     #0, r1
FFF254B2  200f                              beq.b   loc_FFF254C1
FFF254B4  6602                              mov.l   #0, r2
FFF254B6  fb16cf                            mov.l   #-31h, r1
FFF254B9  056799ff                          bsr.a   sub_FFF1EE20
FFF254BD  e301                              mov.l   r1, 14h+var_14[sp]
FFF254BF  2e57                              bra.b   loc_FFF25516
FFF254C1  05c908ff               loc_FFF254C1 bsr.a   sub_FFF15D8A
FFF254C5  a089                              mov.l   r1, 14h+var_8[sp]
FFF254C7  a889                              mov.l   14h+var_8[sp], r1
FFF254C9  6101                              cmp     #0, r1
FFF254CB  200f                              beq.b   loc_FFF254DA
FFF254CD  6602                              mov.l   #0, r2
FFF254CF  fb16cd                            mov.l   #-33h, r1
FFF254D2  054e99ff                          bsr.a   sub_FFF1EE20
FFF254D6  e301                              mov.l   r1, 14h+var_14[sp]
FFF254D8  2e3e                              bra.b   loc_FFF25516
FFF254DA  05da08ff               loc_FFF254DA bsr.a   sub_FFF15DB4
FFF254DE  a089                              mov.l   r1, 14h+var_8[sp]
FFF254E0  a889                              mov.l   14h+var_8[sp], r1
FFF254E2  6101                              cmp     #0, r1
FFF254E4  200f                              beq.b   loc_FFF254F3
FFF254E6  6602                              mov.l   #0, r2
FFF254E8  fb16cc                            mov.l   #-34h, r1
FFF254EB  053599ff                          bsr.a   sub_FFF1EE20
FFF254EF  e301                              mov.l   r1, 14h+var_14[sp]
FFF254F1  2e25                              bra.b   loc_FFF25516
FFF254F3  050f09ff               loc_FFF254F3 bsr.a   sub_FFF15E02
FFF254F7  a089                              mov.l   r1, 14h+var_8[sp]
FFF254F9  a889                              mov.l   14h+var_8[sp], r1
FFF254FB  6101                              cmp     #0, r1
FFF254FD  200f                              beq.b   loc_FFF2550C
FFF254FF  6602                              mov.l   #0, r2
FFF25501  fb16bf                            mov.l   #-41h, r1
FFF25504  051c99ff                          bsr.a   sub_FFF1EE20
FFF25508  e301                              mov.l   r1, 14h+var_14[sp]
FFF2550A  2e0c                              bra.b   loc_FFF25516
FFF2550C  6601                   loc_FFF2550C mov.l   #0, r1
FFF2550E  ef12                              mov.l   r1, r2
FFF25510  051099ff                          bsr.a   sub_FFF1EE20
FFF25514  e301                              mov.l   r1, 14h+var_14[sp]
FFF25516  ec01                   loc_FFF25516 mov.l   14h+var_14[sp], r1
FFF25518  a101                              mov.l   r1, 14h+var_4[sp]
FFF2551A  6705                              rtsd    #5
FFF2551C  7100e4                 sub_FFF2551C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2551C
FFF2551F  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF25521  39cafa                            bsr.w   sub_FFF24FEB
FFF25524  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF25526  a901                              mov.l   1Ch+var_C[sp], r1
FFF25528  6101                              cmp     #0, r1
FFF2552A  200f                              beq.b   loc_FFF25539
FFF2552C  a901                              mov.l   1Ch+var_C[sp], r1
FFF2552E  6602                              mov.l   #0, r2
FFF25530  05f098ff                          bsr.a   sub_FFF1EE20
FFF25534  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF25536  380501                            bra.w   loc_FFF2563B
FFF25539  a981                   loc_FFF25539 mov.l   1Ch+var_4[sp], r1
FFF2553B  3e1a02                            mov.l   #2, 28h[r1]
FFF2553E  a981                              mov.l   1Ch+var_4[sp], r1
FFF25540  393102                            bsr.w   sub_FFF25771
FFF25543  a981                              mov.l   1Ch+var_4[sp], r1
FFF25545  a995                              mov.l   18h[r1], r5
FFF25547  6040                              sub     #4, sp
FFF25549  f80501                            mov.w   #1, 20h+var_20[sp]
FFF2554C  6603                              mov.l   #0, r3
FFF2554E  6672                              mov.l   #7, r2
FFF25550  ef34                              mov.l   r3, r4
FFF25552  7f15                              jsr     r5
FFF25554  6240                              add     #4, sp
FFF25556  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF25558  a901                              mov.l   1Ch+var_C[sp], r1
FFF2555A  6101                              cmp     #0, r1
FFF2555C  200d                              beq.b   loc_FFF25569
FFF2555E  a901                              mov.l   1Ch+var_C[sp], r1
FFF25560  05f598ff                          bsr.a   sub_FFF1EE55
FFF25564  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF25566  38d500                            bra.w   loc_FFF2563B
FFF25569  a981                   loc_FFF25569 mov.l   1Ch+var_4[sp], r1
FFF2556B  8c11                              mov.b   10h[r1], r1
FFF2556D  755140                            cmp     #40h, r1 ; '@'
FFF25570  2024                              beq.b   loc_FFF25594
FFF25572  a981                              mov.l   1Ch+var_4[sp], r1
FFF25574  ad9a                              mov.l   5Ch[r1], r2
FFF25576  06cd1202                          mul     4[r1].uw, r2
FFF2557A  7702010002                        cmp     #20001h, r2
FFF2557F  2315                              bltu.b  loc_FFF25594
FFF25581  a981                              mov.l   1Ch+var_4[sp], r1
FFF25583  f11f58                            bclr    #7, 58h[r1].b
FFF25586  6602                              mov.l   #0, r2
FFF25588  fb16f0                            mov.l   #-10h, r1
FFF2558B  059598ff                          bsr.a   sub_FFF1EE20
FFF2558F  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF25591  38aa00                            bra.w   loc_FFF2563B
FFF25594  a981                   loc_FFF25594 mov.l   1Ch+var_4[sp], r1
FFF25596  8c11                              mov.b   10h[r1], r1
FFF25598  755120                            cmp     #20h, r1 ; ' '
FFF2559B  3b9100                            bne.w   loc_FFF2562C
FFF2559E  a981                              mov.l   1Ch+var_4[sp], r1
FFF255A0  ab99                              mov.l   3Ch[r1], r1
FFF255A2  7501ff                            cmp     #-1, r1
FFF255A5  2133                              bne.b   loc_FFF255D8
FFF255A7  05ef08ff                          bsr.a   sub_FFF15E96
FFF255AB  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF255AD  a881                              mov.l   1Ch+var_14[sp], r1
FFF255AF  6101                              cmp     #0, r1
FFF255B1  2110                              bne.b   loc_FFF255C1
FFF255B3  6602                              mov.l   #0, r2
FFF255B5  fb16e1                            mov.l   #-1Fh, r1
FFF255B8  056898ff                          bsr.a   sub_FFF1EE20
FFF255BC  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF255BE  387d00                            bra.w   loc_FFF2563B
FFF255C1  a981                   loc_FFF255C1 mov.l   1Ch+var_4[sp], r1
FFF255C3  8c19                              mov.b   11h[r1], r1
FFF255C5  a884                              mov.l   1Ch+var_14[sp], r4
FFF255C7  71020c                            add     #1Ch+var_10, sp, r2
FFF255CA  ef23                              mov.l   r2, r3
FFF255CC  05483900                          bsr.a   sub_FFF28F14
FFF255D0  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF255D2  a881                              mov.l   1Ch+var_14[sp], r1
FFF255D4  05d208ff                          bsr.a   sub_FFF15EA6
FFF255D8  a981                   loc_FFF255D8 mov.l   1Ch+var_4[sp], r1
FFF255DA  ac11                              mov.l   40h[r1], r1
FFF255DC  7501ff                            cmp     #-1, r1
FFF255DF  1e                                bne.s   loc_FFF255E5
FFF255E0  a981                              mov.l   1Ch+var_4[sp], r1
FFF255E2  3e9002                            mov.l   #2, 40h[r1]
FFF255E5  a981                   loc_FFF255E5 mov.l   1Ch+var_4[sp], r1
FFF255E7  e511100a                          mov.l   40h[r1], 28h[r1]
FFF255EB  05ab08ff                          bsr.a   sub_FFF15E96
FFF255EF  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF255F1  a881                              mov.l   1Ch+var_14[sp], r1
FFF255F3  6101                              cmp     #0, r1
FFF255F5  210f                              bne.b   loc_FFF25604
FFF255F7  6602                              mov.l   #0, r2
FFF255F9  fb16e1                            mov.l   #-1Fh, r1
FFF255FC  052498ff                          bsr.a   sub_FFF1EE20
FFF25600  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF25602  2e39                              bra.b   loc_FFF2563B
FFF25604  a884                   loc_FFF25604 mov.l   1Ch+var_14[sp], r4
FFF25606  a981                              mov.l   1Ch+var_4[sp], r1
FFF25608  6643                              mov.l   #4, r3
FFF2560A  71020c                            add     #1Ch+var_10, sp, r2
FFF2560D  0546f6ff                          bsr.a   sub_FFF24C53
FFF25611  6101                              cmp     #0, r1
FFF25613  15                                beq.s   loc_FFF25618
FFF25614  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF25617  0c                                bra.s   loc_FFF2561B
FFF25618  f80601                 loc_FFF25618 mov.l   #1, 1Ch+var_1C[sp]
FFF2561B  ec01                   loc_FFF2561B mov.l   1Ch+var_1C[sp], r1
FFF2561D  6101                              cmp     #0, r1
FFF2561F  17                                beq.s   loc_FFF25626
FFF25620  a889                              mov.l   1Ch+var_10[sp], r1
FFF25622  a982                              mov.l   1Ch+var_4[sp], r2
FFF25624  a2a1                              mov.l   r1, 28h[r2]
FFF25626  a881                   loc_FFF25626 mov.l   1Ch+var_14[sp], r1
FFF25628  057e08ff                          bsr.a   sub_FFF15EA6
FFF2562C  a981                   loc_FFF2562C mov.l   1Ch+var_4[sp], r1
FFF2562E  f11758                            bset    #7, 58h[r1].b
FFF25631  a901                              mov.l   1Ch+var_C[sp], r1
FFF25633  6602                              mov.l   #0, r2
FFF25635  05eb97ff                          bsr.a   sub_FFF1EE20
FFF25639  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2563B  a809                   loc_FFF2563B mov.l   1Ch+var_18[sp], r1
FFF2563D  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF2563F  6707                              rtsd    #7
FFF25641  7100ec                 sub_FFF25641 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF25641
FFF25644  a101                              mov.l   r1, 14h+var_4[sp]
FFF25646  39a5f9                            bsr.w   sub_FFF24FEB
FFF25649  a081                              mov.l   r1, 14h+var_C[sp]
FFF2564B  a881                              mov.l   14h+var_C[sp], r1
FFF2564D  6101                              cmp     #0, r1
FFF2564F  200e                              beq.b   loc_FFF2565D
FFF25651  a881                              mov.l   14h+var_C[sp], r1
FFF25653  6602                              mov.l   #0, r2
FFF25655  05cb97ff                          bsr.a   sub_FFF1EE20
FFF25659  a009                              mov.l   r1, 14h+var_10[sp]
FFF2565B  2e5c                              bra.b   loc_FFF256B7
FFF2565D  a901                   loc_FFF2565D mov.l   14h+var_4[sp], r1
FFF2565F  f51058                            btst    #0, 58h[r1].b
FFF25662  15                                beq.s   loc_FFF25667
FFF25663  f80600                            mov.l   #0, 14h+var_14[sp]
FFF25666  0c                                bra.s   loc_FFF2566A
FFF25667  f80601                 loc_FFF25667 mov.l   #1, 14h+var_14[sp]
FFF2566A  ec01                   loc_FFF2566A mov.l   14h+var_14[sp], r1
FFF2566C  6101                              cmp     #0, r1
FFF2566E  200f                              beq.b   loc_FFF2567D
FFF25670  6602                              mov.l   #0, r2
FFF25672  fb16f0                            mov.l   #-10h, r1
FFF25675  05ab97ff                          bsr.a   sub_FFF1EE20
FFF25679  a009                              mov.l   r1, 14h+var_10[sp]
FFF2567B  2e3c                              bra.b   loc_FFF256B7
FFF2567D  a901                   loc_FFF2567D mov.l   14h+var_4[sp], r1
FFF2567F  a995                              mov.l   18h[r1], r5
FFF25681  6040                              sub     #4, sp
FFF25683  f80501                            mov.w   #1, 18h+var_18[sp]
FFF25686  6603                              mov.l   #0, r3
FFF25688  6682                              mov.l   #8, r2
FFF2568A  ef34                              mov.l   r3, r4
FFF2568C  7f15                              jsr     r5
FFF2568E  6240                              add     #4, sp
FFF25690  a081                              mov.l   r1, 14h+var_C[sp]
FFF25692  a881                              mov.l   14h+var_C[sp], r1
FFF25694  6101                              cmp     #0, r1
FFF25696  200c                              beq.b   loc_FFF256A2
FFF25698  a881                              mov.l   14h+var_C[sp], r1
FFF2569A  05bb97ff                          bsr.a   sub_FFF1EE55
FFF2569E  a009                              mov.l   r1, 14h+var_10[sp]
FFF256A0  2e17                              bra.b   loc_FFF256B7
FFF256A2  a901                   loc_FFF256A2 mov.l   14h+var_4[sp], r1
FFF256A4  f9146c00                          mov.b   #0, 6Ch[r1]
FFF256A8  a901                              mov.l   14h+var_4[sp], r1
FFF256AA  f11f58                            bclr    #7, 58h[r1].b
FFF256AD  a881                              mov.l   14h+var_C[sp], r1
FFF256AF  6602                              mov.l   #0, r2
FFF256B1  056f97ff                          bsr.a   sub_FFF1EE20
FFF256B5  a009                              mov.l   r1, 14h+var_10[sp]
FFF256B7  a809                   loc_FFF256B7 mov.l   14h+var_10[sp], r1
FFF256B9  a089                              mov.l   r1, 14h+var_8[sp]
FFF256BB  6705                              rtsd    #5
FFF256BD  7100e4                 sub_FFF256BD add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF256BD
FFF256C0  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF256C2  6101                              cmp     #0, r1
FFF256C4  2110                              bne.b   loc_FFF256D4
FFF256C6  6602                              mov.l   #0, r2
FFF256C8  fb16f3                            mov.l   #-0Dh, r1
FFF256CB  055597ff                          bsr.a   sub_FFF1EE20
FFF256CF  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF256D1  389a00                            bra.w   loc_FFF2576B
FFF256D4  a981                   loc_FFF256D4 mov.l   1Ch+var_4[sp], r1
FFF256D6  f51058                            btst    #0, 58h[r1].b
FFF256D9  15                                beq.s   loc_FFF256DE
FFF256DA  f80600                            mov.l   #0, 1Ch+var_1C[sp]
FFF256DD  0c                                bra.s   loc_FFF256E1
FFF256DE  f80601                 loc_FFF256DE mov.l   #1, 1Ch+var_1C[sp]
FFF256E1  ec01                   loc_FFF256E1 mov.l   1Ch+var_1C[sp], r1
FFF256E3  6101                              cmp     #0, r1
FFF256E5  200f                              beq.b   loc_FFF256F4
FFF256E7  6602                              mov.l   #0, r2
FFF256E9  fb16f0                            mov.l   #-10h, r1
FFF256EC  053497ff                          bsr.a   sub_FFF1EE20
FFF256F0  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF256F2  2e79                              bra.b   loc_FFF2576B
FFF256F4  a981                   loc_FFF256F4 mov.l   1Ch+var_4[sp], r1
FFF256F6  056806ff                          bsr.a   sub_FFF15D5E
FFF256FA  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF256FC  a881                              mov.l   1Ch+var_14[sp], r1
FFF256FE  6101                              cmp     #0, r1
FFF25700  200f                              beq.b   loc_FFF2570F
FFF25702  6602                              mov.l   #0, r2
FFF25704  fb16cb                            mov.l   #-35h, r1
FFF25707  051997ff                          bsr.a   sub_FFF1EE20
FFF2570B  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2570D  2e5e                              bra.b   loc_FFF2576B
FFF2570F  fbe22c5e0600           loc_FFF2570F mov.l   #65E2Ch, r14
FFF25715  ecee                              mov.l   [r14], r14
FFF25717  06850e06                          cmp     1Ch+var_4[sp].l, r14
FFF2571B  2118                              bne.b   loc_FFF25733
FFF2571D  a981                              mov.l   1Ch+var_4[sp], r1
FFF2571F  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF25725  e01e                              mov.l   [r1], [r14]
FFF25727  6601                              mov.l   #0, r1
FFF25729  ef12                              mov.l   r1, r2
FFF2572B  05f596ff                          bsr.a   sub_FFF1EE20
FFF2572F  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF25731  2e3a                              bra.b   loc_FFF2576B
FFF25733  fbe22c5e0600           loc_FFF25733 mov.l   #65E2Ch, r14
FFF25739  e4e004                            mov.l   [r14], 1Ch+var_C[sp]
FFF2573C  a901                              mov.l   1Ch+var_C[sp], r1
FFF2573E  e41003                            mov.l   [r1], 1Ch+var_10[sp]
FFF25741  2e1a                              bra.b   loc_FFF2575B
FFF25743  a981                   loc_FFF25743 mov.l   1Ch+var_4[sp], r1
FFF25745  06850103                          cmp     1Ch+var_10[sp].l, r1
FFF25749  19                                bne.s   loc_FFF25752
FFF2574A  a889                              mov.l   1Ch+var_10[sp], r1
FFF2574C  a902                              mov.l   1Ch+var_C[sp], r2
FFF2574E  e012                              mov.l   [r1], [r2]
FFF25750  2e11                              bra.b   loc_FFF25761
FFF25752  e5000304               loc_FFF25752 mov.l   1Ch+var_10[sp], 1Ch+var_C[sp]
FFF25756  a901                              mov.l   1Ch+var_C[sp], r1
FFF25758  e41003                            mov.l   [r1], 1Ch+var_10[sp]
FFF2575B  a889                   loc_FFF2575B mov.l   1Ch+var_10[sp], r1
FFF2575D  6101                              cmp     #0, r1
FFF2575F  21e4                              bne.b   loc_FFF25743
FFF25761  6601                   loc_FFF25761 mov.l   #0, r1
FFF25763  ef12                              mov.l   r1, r2
FFF25765  05bb96ff                          bsr.a   sub_FFF1EE20
FFF25769  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2576B  a809                   loc_FFF2576B mov.l   1Ch+var_18[sp], r1
FFF2576D  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF2576F  6707                              rtsd    #7
FFF25771  6040                   sub_FFF25771 sub     #4, sp   ; <<<< FUNC sub_FFF25771
FFF25773  e301                              mov.l   r1, 4+var_4[sp]
FFF25775  3e1c00                            mov.l   #0, 30h[r1]
FFF25778  ec01                              mov.l   4+var_4[sp], r1
FFF2577A  3c9000                            mov.b   #0, 10h[r1]
FFF2577D  ec01                              mov.l   4+var_4[sp], r1
FFF2577F  3d1200                            mov.w   #0, 4[r1]
FFF25782  ec01                              mov.l   4+var_4[sp], r1
FFF25784  3d1300                            mov.w   #0, 6[r1]
FFF25787  ec01                              mov.l   4+var_4[sp], r1
FFF25789  3d1400                            mov.w   #0, 8[r1]
FFF2578C  ec01                              mov.l   4+var_4[sp], r1
FFF2578E  3d1500                            mov.w   #0, 0Ah[r1]
FFF25791  ec01                              mov.l   4+var_4[sp], r1
FFF25793  3e1500                            mov.l   #0, 14h[r1]
FFF25796  ec01                              mov.l   4+var_4[sp], r1
FFF25798  3e1300                            mov.l   #0, 0Ch[r1]
FFF2579B  ec01                              mov.l   4+var_4[sp], r1
FFF2579D  3e1d00                            mov.l   #0, 34h[r1]
FFF257A0  ec01                              mov.l   4+var_4[sp], r1
FFF257A2  3d9d00                            mov.w   #0, 3Ah[r1]
FFF257A5  ec01                              mov.l   4+var_4[sp], r1
FFF257A7  3e1f00                            mov.l   #0, 3Ch[r1]
FFF257AA  ec01                              mov.l   4+var_4[sp], r1
FFF257AC  3e9000                            mov.l   #0, 40h[r1]
FFF257AF  6701                              rtsd    #1
FFF257B1  7100e0                 sub_FFF257B1 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF257B1
FFF257B4  a189                              mov.l   r1, 20h+var_4[sp]
FFF257B6  930a                              mov.w   r2, 20h+var_6[sp]
FFF257B8  a10b                              mov.l   r3, 20h+var_C[sp]
FFF257BA  a104                              mov.l   r4, 20h+var_10[sp]
FFF257BC  c500240f                          mov.b   20h+arg_0[sp], 20h+var_11[sp]
FFF257C0  e5000a02                          mov.l   20h+arg_4[sp], 20h+var_18[sp]
FFF257C4  bb09                              movu.w  20h+var_6[sp], r1
FFF257C6  05669400                          bsr.a   sub_FFF2EC2C
FFF257CA  8089                              mov.b   r1, 20h+var_1D[sp]
FFF257CC  a885                              mov.l   20h+var_18[sp], r5
FFF257CE  590f0f                            movu.b  20h+var_11[sp], r15
FFF257D1  a904                              mov.l   20h+var_10[sp], r4
FFF257D3  a90b                              mov.l   20h+var_C[sp], r3
FFF257D5  888a                              mov.b   20h+var_1D[sp], r2
FFF257D7  a989                              mov.l   20h+var_4[sp], r1
FFF257D9  6080                              sub     #8, sp
FFF257DB  a00d                              mov.l   r5, 28h+var_24[sp]
FFF257DD  c30f                              mov.b   r15, 28h+var_28[sp]
FFF257DF  0567f9ff                          bsr.a   sub_FFF25146
FFF257E3  6280                              add     #8, sp
FFF257E5  a009                              mov.l   r1, 20h+var_1C[sp]
FFF257E7  6708                              rtsd    #8
FFF257E9  7100ec                 sub_FFF257E9 add     #-14h, sp, sp   ; <<<< FUNC sub_FFF257E9
FFF257EC  a101                              mov.l   r1, 14h+var_4[sp]
FFF257EE  ec11                              mov.l   [r1], r1
FFF257F0  056d97ff                          bsr.a   sub_FFF1EF5D
FFF257F4  a081                              mov.l   r1, 14h+var_C[sp]
FFF257F6  a881                              mov.l   14h+var_C[sp], r1
FFF257F8  6101                              cmp     #0, r1
FFF257FA  16                                beq.s   loc_FFF25800
FFF257FB  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF257FE  2e49                              bra.b   loc_FFF25847
FFF25800  a901                   loc_FFF25800 mov.l   14h+var_4[sp], r1
FFF25802  ed128e                            mov.l   238h[r1], r2
FFF25805  ec1e                              mov.l   [r1], r14
FFF25807  06a109e217                        divu    5Ch[r14].l, r2
FFF2580C  a00a                              mov.l   r2, 14h+var_10[sp]
FFF2580E  a901                              mov.l   14h+var_4[sp], r1
FFF25810  a891                              mov.l   8[r1], r1
FFF25812  6101                              cmp     #0, r1
FFF25814  2030                              beq.b   loc_FFF25844
FFF25816  a901                              mov.l   14h+var_4[sp], r1
FFF25818  aa11                              mov.l   20h[r1], r1
FFF2581A  6101                              cmp     #0, r1
FFF2581C  2028                              beq.b   loc_FFF25844
FFF2581E  a901                              mov.l   14h+var_4[sp], r1
FFF25820  a81b                              mov.l   4[r1], r3
FFF25822  aa12                              mov.l   20h[r1], r2
FFF25824  ec11                              mov.l   [r1], r1
FFF25826  b884                              movu.w  14h+var_10[sp], r4
FFF25828  057a98ff                          bsr.a   sub_FFF1F0A2
FFF2582C  a081                              mov.l   r1, 14h+var_C[sp]
FFF2582E  a881                              mov.l   14h+var_C[sp], r1
FFF25830  6101                              cmp     #0, r1
FFF25832  16                                beq.s   loc_FFF25838
FFF25833  e10002                            mov.l   14h+var_C[sp], 14h+var_14[sp]
FFF25836  2e11                              bra.b   loc_FFF25847
FFF25838  a901                   loc_FFF25838 mov.l   14h+var_4[sp], r1
FFF2583A  3e1200                            mov.l   #0, 8[r1]
FFF2583D  a901                              mov.l   14h+var_4[sp], r1
FFF2583F  fa144c0401                        mov.b   #1, 44Ch[r1]
FFF25844  f80600                 loc_FFF25844 mov.l   #0, 14h+var_14[sp]
FFF25847  ec01                   loc_FFF25847 mov.l   14h+var_14[sp], r1
FFF25849  a089                              mov.l   r1, 14h+var_8[sp]
FFF2584B  6705                              rtsd    #5
FFF2584D  7100e0                 sub_FFF2584D add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2584D
FFF25850  a189                              mov.l   r1, 20h+var_4[sp]
FFF25852  a182                              mov.l   r2, 20h+var_8[sp]
FFF25854  a10b                              mov.l   r3, 20h+var_C[sp]
FFF25856  a104                              mov.l   r4, 20h+var_10[sp]
FFF25858  a989                              mov.l   20h+var_4[sp], r1
FFF2585A  05bb04ff                          bsr.a   sub_FFF15D15
FFF2585E  a081                              mov.l   r1, 20h+var_18[sp]
FFF25860  a881                              mov.l   20h+var_18[sp], r1
FFF25862  6101                              cmp     #0, r1
FFF25864  16                                beq.s   loc_FFF2586A
FFF25865  f806de                            mov.l   #-22h, 20h+var_20[sp]
FFF25868  2e18                              bra.b   loc_FFF25880
FFF2586A  a904                   loc_FFF2586A mov.l   20h+var_10[sp], r4
FFF2586C  a90b                              mov.l   20h+var_C[sp], r3
FFF2586E  a982                              mov.l   20h+var_8[sp], r2
FFF25870  a989                              mov.l   20h+var_4[sp], r1
FFF25872  391400                            bsr.w   sub_FFF25886
FFF25875  a009                              mov.l   r1, 20h+var_1C[sp]
FFF25877  a989                              mov.l   20h+var_4[sp], r1
FFF25879  05a704ff                          bsr.a   sub_FFF15D20
FFF2587D  e10001                            mov.l   20h+var_1C[sp], 20h+var_20[sp]
FFF25880  ec01                   loc_FFF25880 mov.l   20h+var_20[sp], r1
FFF25882  a089                              mov.l   r1, 20h+var_14[sp]
FFF25884  6708                              rtsd    #8
FFF25886  7100b0                 sub_FFF25886 add     #-50h, sp, sp   ; <<<< FUNC sub_FFF25886
FFF25889  a489                              mov.l   r1, 50h+var_4[sp]
FFF2588B  a482                              mov.l   r2, 50h+var_8[sp]
FFF2588D  a40b                              mov.l   r3, 50h+var_C[sp]
FFF2588F  a404                              mov.l   r4, 50h+var_10[sp]
FFF25891  3e0c00                            mov.l   #0, 50h+var_20[sp]
FFF25894  3e0b00                            mov.l   #0, 50h+var_24[sp]
FFF25897  3e0a00                            mov.l   #0, 50h+var_28[sp]
FFF2589A  3e0900                            mov.l   #0, 50h+var_2C[sp]
FFF2589D  3e0300                            mov.l   #0, 50h+var_44[sp]
FFF258A0  3e0200                            mov.l   #0, 50h+var_48[sp]
FFF258A3  ac89                              mov.l   50h+var_4[sp], r1
FFF258A5  8c12                              mov.b   10h[r1], r2
FFF258A7  755220                            cmp     #20h, r2 ; ' '
FFF258AA  2110                              bne.b   loc_FFF258BA
FFF258AC  ad99                              mov.l   5Ch[r1], r1
FFF258AE  6821                              shlr    #2, r1
FFF258B0  ac8a                              mov.l   50h+var_4[sp], r2
FFF258B2  068d2103                          mul     0Ch[r2].l, r1
FFF258B6  a181                              mov.l   r1, 50h+var_38[sp]
FFF258B8  2e27                              bra.b   loc_FFF258DF
FFF258BA  8c11                   loc_FFF258BA mov.b   10h[r1], r1
FFF258BC  755110                            cmp     #10h, r1
FFF258BF  ac89                              mov.l   50h+var_4[sp], r1
FFF258C1  ad99                              mov.l   5Ch[r1], r1
FFF258C3  210e                              bne.b   loc_FFF258D1
FFF258C5  6811                              shlr    #1, r1
FFF258C7  ac8a                              mov.l   50h+var_4[sp], r2
FFF258C9  068d2103                          mul     0Ch[r2].l, r1
FFF258CD  a181                              mov.l   r1, 50h+var_38[sp]
FFF258CF  2e10                              bra.b   loc_FFF258DF
FFF258D1  ac8a                   loc_FFF258D1 mov.l   50h+var_4[sp], r2
FFF258D3  068d2103                          mul     0Ch[r2].l, r1
FFF258D7  6c11                              shll    #1, r1
FFF258D9  fd749103                          divu    #3, r1
FFF258DD  a181                              mov.l   r1, 50h+var_38[sp]
FFF258DF  ac89                   loc_FFF258DF mov.l   50h+var_4[sp], r1
FFF258E1  a89a                              mov.l   0Ch[r1], r2
FFF258E3  06cd1204                          mul     8[r1].uw, r2
FFF258E7  06c91203                          add     6[r1].uw, r2
FFF258EB  b91b                              movu.w  0Ah[r1], r3
FFF258ED  6c53                              shll    #5, r3
FFF258EF  06a1091317                        divu    5Ch[r1].l, r3
FFF258F4  4b32                              add     r3, r2
FFF258F6  a91b                              mov.l   14h[r1], r3
FFF258F8  4323                              sub     r2, r3
FFF258FA  06e1091302                        divu    4[r1].uw, r3
FFF258FF  6223                              add     #2, r3
FFF25901  06850306                          cmp     50h+var_38[sp].l, r3
FFF25905  2226                              bgeu.b  loc_FFF2592B
FFF25907  ac89                              mov.l   50h+var_4[sp], r1
FFF25909  a89a                              mov.l   0Ch[r1], r2
FFF2590B  06cd1204                          mul     8[r1].uw, r2
FFF2590F  06c91203                          add     6[r1].uw, r2
FFF25913  b91b                              movu.w  0Ah[r1], r3
FFF25915  6c53                              shll    #5, r3
FFF25917  06a1091317                        divu    5Ch[r1].l, r3
FFF2591C  4b32                              add     r3, r2
FFF2591E  a91b                              mov.l   14h[r1], r3
FFF25920  4323                              sub     r2, r3
FFF25922  06e1091302                        divu    4[r1].uw, r3
FFF25927  6223                              add     #2, r3
FFF25929  a183                              mov.l   r3, 50h+var_38[sp]
FFF2592B  ac89                   loc_FFF2592B mov.l   50h+var_4[sp], r1
FFF2592D  e5100a08                          mov.l   28h[r1], 50h+var_30[sp]
FFF25931  e5000807               loc_FFF25931 mov.l   50h+var_30[sp], 50h+var_34[sp]
FFF25935  f90605ff                          mov.l   #-1, 50h+var_3C[sp]
FFF25939  385c01                            bra.w   loc_FFF25A95
FFF2593C  ac89                   loc_FFF2593C mov.l   50h+var_4[sp], r1
FFF2593E  8c11                              mov.b   10h[r1], r1
FFF25940  755120                            cmp     #20h, r1 ; ' '
FFF25943  2126                              bne.b   loc_FFF25969
FFF25945  ac89                              mov.l   50h+var_4[sp], r1
FFF25947  ad99                              mov.l   5Ch[r1], r1
FFF25949  6821                              shlr    #2, r1
FFF2594B  a98a                              mov.l   50h+var_34[sp], r2
FFF2594D  fc2712                            divu    r1, r2
FFF25950  a102                              mov.l   r2, 50h+var_40[sp]
FFF25952  ac89                              mov.l   50h+var_4[sp], r1
FFF25954  ad99                              mov.l   5Ch[r1], r1
FFF25956  6821                              shlr    #2, r1
FFF25958  a98a                              mov.l   50h+var_34[sp], r2
FFF2595A  ef2e                              mov.l   r2, r14
FFF2595C  fc271e                            divu    r1, r14
FFF2595F  4f1e                              mul     r1, r14
FFF25961  43e2                              sub     r14, r2
FFF25963  6c22                              shll    #2, r2
FFF25965  a30a                              mov.l   r2, 50h+var_1C[sp]
FFF25967  2e4e                              bra.b   loc_FFF259B5
FFF25969  ac89                   loc_FFF25969 mov.l   50h+var_4[sp], r1
FFF2596B  8c11                              mov.b   10h[r1], r1
FFF2596D  755110                            cmp     #10h, r1
FFF25970  a989                              mov.l   50h+var_34[sp], r1
FFF25972  2124                              bne.b   loc_FFF25996
FFF25974  ac8a                              mov.l   50h+var_4[sp], r2
FFF25976  adaa                              mov.l   5Ch[r2], r2
FFF25978  6812                              shlr    #1, r2
FFF2597A  fc2721                            divu    r2, r1
FFF2597D  a101                              mov.l   r1, 50h+var_40[sp]
FFF2597F  ac89                              mov.l   50h+var_4[sp], r1
FFF25981  ad99                              mov.l   5Ch[r1], r1
FFF25983  6811                              shlr    #1, r1
FFF25985  a98a                              mov.l   50h+var_34[sp], r2
FFF25987  ef2e                              mov.l   r2, r14
FFF25989  fc271e                            divu    r1, r14
FFF2598C  4f1e                              mul     r1, r14
FFF2598E  43e2                              sub     r14, r2
FFF25990  6c12                              shll    #1, r2
FFF25992  a30a                              mov.l   r2, 50h+var_1C[sp]
FFF25994  2e21                              bra.b   loc_FFF259B5
FFF25996  ac8a                   loc_FFF25996 mov.l   50h+var_4[sp], r2
FFF25998  adaa                              mov.l   5Ch[r2], r2
FFF2599A  6c12                              shll    #1, r2
FFF2599C  6331                              mul     #3, r1
FFF2599E  fc2721                            divu    r2, r1
FFF259A1  a101                              mov.l   r1, 50h+var_40[sp]
FFF259A3  a989                              mov.l   50h+var_34[sp], r1
FFF259A5  6331                              mul     #3, r1
FFF259A7  6811                              shlr    #1, r1
FFF259A9  ac8a                              mov.l   50h+var_4[sp], r2
FFF259AB  adaa                              mov.l   5Ch[r2], r2
FFF259AD  068d0204                          mul     50h+var_40[sp].l, r2
FFF259B1  4321                              sub     r2, r1
FFF259B3  a309                              mov.l   r1, 50h+var_1C[sp]
FFF259B5  a909                   loc_FFF259B5 mov.l   50h+var_3C[sp], r1
FFF259B7  06850104                          cmp     50h+var_40[sp].l, r1
FFF259BB  2020                              beq.b   loc_FFF259DB
FFF259BD  ac04                              mov.l   50h+var_10[sp], r4
FFF259BF  a902                              mov.l   50h+var_40[sp], r2
FFF259C1  ac89                              mov.l   50h+var_4[sp], r1
FFF259C3  710308                            add     #50h+var_48, sp, r3
FFF259C6  0518e7ff                          bsr.a   sub_FFF240DE
FFF259CA  a381                              mov.l   r1, 50h+var_18[sp]
FFF259CC  ab81                              mov.l   50h+var_18[sp], r1
FFF259CE  6101                              cmp     #0, r1
FFF259D0  17                                beq.s   loc_FFF259D7
FFF259D1  e1000e                            mov.l   50h+var_18[sp], 50h+var_50[sp]
FFF259D4  38ec00                            bra.w   loc_FFF25AC0
FFF259D7  e5000405               loc_FFF259D7 mov.l   50h+var_40[sp], 50h+var_3C[sp]
FFF259DB  a881                   loc_FFF259DB mov.l   50h+var_48[sp], r1
FFF259DD  6101                              cmp     #0, r1
FFF259DF  2079                              beq.b   loc_FFF25A58
FFF259E1  ac89                              mov.l   50h+var_4[sp], r1
FFF259E3  8c11                              mov.b   10h[r1], r1
FFF259E5  755120                            cmp     #20h, r1 ; ' '
FFF259E8  2110                              bne.b   loc_FFF259F8
FFF259EA  a881                              mov.l   50h+var_48[sp], r1
FFF259EC  0689010d                          add     50h+var_1C[sp].l, r1
FFF259F0  052a9300                          bsr.a   sub_FFF2ED1A
FFF259F4  a089                              mov.l   r1, 50h+var_44[sp]
FFF259F6  2e62                              bra.b   loc_FFF25A58
FFF259F8  ac89                   loc_FFF259F8 mov.l   50h+var_4[sp], r1
FFF259FA  8c11                              mov.b   10h[r1], r1
FFF259FC  755110                            cmp     #10h, r1
FFF259FF  2110                              bne.b   loc_FFF25A0F
FFF25A01  a881                              mov.l   50h+var_48[sp], r1
FFF25A03  0689010d                          add     50h+var_1C[sp].l, r1
FFF25A07  059d9200                          bsr.a   sub_FFF2ECA4
FFF25A0B  a089                              mov.l   r1, 50h+var_44[sp]
FFF25A0D  2e4b                              bra.b   loc_FFF25A58
FFF25A0F  ab09                   loc_FFF25A0F mov.l   50h+var_1C[sp], r1
FFF25A11  a882                              mov.l   50h+var_48[sp], r2
FFF25A13  fec211                            movu.b  [r2, r1], r1
FFF25A16  8181                              mov.b   r1, 50h+var_4A[sp]
FFF25A18  ac89                              mov.l   50h+var_4[sp], r1
FFF25A1A  ad99                              mov.l   5Ch[r1], r1
FFF25A1C  6011                              sub     #1, r1
FFF25A1E  0685010d                          cmp     50h+var_1C[sp].l, r1
FFF25A22  2123                              bne.b   loc_FFF25A45
FFF25A24  f9060dff                          mov.l   #-1, 50h+var_1C[sp]
FFF25A28  a902                              mov.l   50h+var_40[sp], r2
FFF25A2A  6212                              add     #1, r2
FFF25A2C  ac89                              mov.l   50h+var_4[sp], r1
FFF25A2E  a102                              mov.l   r2, 50h+var_40[sp]
FFF25A30  ac04                              mov.l   50h+var_10[sp], r4
FFF25A32  710308                            add     #50h+var_48, sp, r3
FFF25A35  05a9e6ff                          bsr.a   sub_FFF240DE
FFF25A39  a381                              mov.l   r1, 50h+var_18[sp]
FFF25A3B  ab81                              mov.l   50h+var_18[sp], r1
FFF25A3D  6101                              cmp     #0, r1
FFF25A3F  16                                beq.s   loc_FFF25A45
FFF25A40  e1000e                            mov.l   50h+var_18[sp], 50h+var_50[sp]
FFF25A43  2e7d                              bra.b   loc_FFF25AC0
FFF25A45  ab09                   loc_FFF25A45 mov.l   50h+var_1C[sp], r1
FFF25A47  06890102                          add     50h+var_48[sp].l, r1
FFF25A4B  c5100107                          mov.b   1[r1], 50h+var_49[sp]
FFF25A4F  710106                            add     #50h+var_4A, sp, r1
FFF25A52  05529200                          bsr.a   sub_FFF2ECA4
FFF25A56  a089                              mov.l   r1, 50h+var_44[sp]
FFF25A58  a889                   loc_FFF25A58 mov.l   50h+var_44[sp], r1
FFF25A5A  6101                              cmp     #0, r1
FFF25A5C  2133                              bne.b   loc_FFF25A8F
FFF25A5E  aa81                              mov.l   50h+var_28[sp], r1
FFF25A60  6211                              add     #1, r1
FFF25A62  06850107                          cmp     50h+var_34[sp].l, r1
FFF25A66  210d                              bne.b   loc_FFF25A73
FFF25A68  aa89                              mov.l   50h+var_24[sp], r1
FFF25A6A  6211                              add     #1, r1
FFF25A6C  a289                              mov.l   r1, 50h+var_24[sp]
FFF25A6E  e500070a                          mov.l   50h+var_34[sp], 50h+var_28[sp]
FFF25A72  0a                                bra.s   loc_FFF25A7C
FFF25A73  3e0b01                 loc_FFF25A73 mov.l   #1, 50h+var_24[sp]
FFF25A76  a989                              mov.l   50h+var_34[sp], r1
FFF25A78  a281                              mov.l   r1, 50h+var_28[sp]
FFF25A7A  a209                              mov.l   r1, 50h+var_2C[sp]
FFF25A7C  aa89                   loc_FFF25A7C mov.l   50h+var_24[sp], r1
FFF25A7E  06850111                          cmp     50h+var_C[sp].l, r1
FFF25A82  210d                              bne.b   loc_FFF25A8F
FFF25A84  aa09                              mov.l   50h+var_2C[sp], r1
FFF25A86  ac82                              mov.l   50h+var_8[sp], r2
FFF25A88  e321                              mov.l   r1, [r2]
FFF25A8A  f80600                            mov.l   #0, 50h+var_50[sp]
FFF25A8D  2e33                              bra.b   loc_FFF25AC0
FFF25A8F  a989                   loc_FFF25A8F mov.l   50h+var_34[sp], r1
FFF25A91  6211                              add     #1, r1
FFF25A93  a189                              mov.l   r1, 50h+var_34[sp]
FFF25A95  a989                   loc_FFF25A95 mov.l   50h+var_34[sp], r1
FFF25A97  06850106                          cmp     50h+var_38[sp].l, r1
FFF25A9B  2205                              bgeu.b  loc_FFF25AA0
FFF25A9D  389ffe                            bra.w   loc_FFF2593C
FFF25AA0  a989                   loc_FFF25AA0 mov.l   50h+var_34[sp], r1
FFF25AA2  06850106                          cmp     50h+var_38[sp].l, r1
FFF25AA6  2117                              bne.b   loc_FFF25ABD
FFF25AA8  ab01                              mov.l   50h+var_20[sp], r1
FFF25AAA  711201                            add     #1, r1, r2
FFF25AAD  a302                              mov.l   r2, 50h+var_20[sp]
FFF25AAF  6101                              cmp     #0, r1
FFF25AB1  210c                              bne.b   loc_FFF25ABD
FFF25AB3  e5000806                          mov.l   50h+var_30[sp], 50h+var_38[sp]
FFF25AB7  3e0802                            mov.l   #2, 50h+var_30[sp]
FFF25ABA  3877fe                            bra.w   loc_FFF25931
FFF25ABD  f8069d                 loc_FFF25ABD mov.l   #-63h, 50h+var_50[sp]
FFF25AC0  ec01                   loc_FFF25AC0 mov.l   50h+var_50[sp], r1
FFF25AC2  a389                              mov.l   r1, 50h+var_14[sp]
FFF25AC4  6714                              rtsd    #14h
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
