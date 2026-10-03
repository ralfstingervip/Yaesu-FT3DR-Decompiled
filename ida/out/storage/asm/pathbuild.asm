; ==== pathbuild  FFF3B880-FFF40100  (file 33B880-340100) ====
FFF3B880  00                                brk
FFF3B881  fbe2630c0100                      mov.l   #10C63h, r14
FFF3B887  f8e400                            mov.b   #0, [r14]
FFF3B88A  fbe2fc840600                      mov.l   #684FCh, r14
FFF3B890  f8e600                            mov.l   #0, [r14]
FFF3B893  fbe26e250100                      mov.l   #1256Eh, r14
FFF3B899  f8e500                            mov.w   #0, [r14]
FFF3B89C  fbe26a250100                      mov.l   #1256Ah, r14
FFF3B8A2  f8e500                            mov.w   #0, [r14]
FFF3B8A5  fbe2640c0100                      mov.l   #10C64h, r14
FFF3B8AB  f8e400                            mov.b   #0, [r14]
FFF3B8AE  fbe2650c0100                      mov.l   #10C65h, r14
FFF3B8B4  f8e402                            mov.b   #2, [r14]
FFF3B8B7  fbe26c250100                      mov.l   #1256Ch, r14
FFF3B8BD  f8e500                            mov.w   #0, [r14]
FFF3B8C0  fbe25f080100                      mov.l   #1085Fh, r14
FFF3B8C6  f8e400                 sub_FFF3B8C6 mov.b   #0, [r14]   ; <<<< FUNC sub_FFF3B8C6
FFF3B8C9  6701                              rtsd    #1
FFF3B8CB  754264                 sub_FFF3B8CB mov.l   #64h, r2 ; 'd'   ; <<<< FUNC sub_FFF3B8CB
FFF3B8CE  6651                              mov.l   #5, r1
FFF3B8D0  0508e6ff                          bsr.a   sub_FFF39ED8
FFF3B8D4  fbe260080100                      mov.l   #10860h, r14
FFF3B8DA  f8e403                            mov.b   #3, [r14]
FFF3B8DD  02                                rts
FFF3B8DE  7100d4                 sub_FFF3B8DE add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF3B8DE
FFF3B8E1  6601                              mov.l   #0, r1
FFF3B8E3  9509                              mov.w   r1, 2Ch+var_2[sp]
FFF3B8E5  9501                              mov.w   r1, 2Ch+var_4[sp]
FFF3B8E7  9489                              mov.w   r1, 2Ch+var_6[sp]
FFF3B8E9  f9042501                          mov.b   #1, 2Ch+var_7[sp]
FFF3B8ED  6601                              mov.l   #0, r1
FFF3B8EF  a201                              mov.l   r1, 2Ch+var_C[sp]
FFF3B8F1  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF3B8F3  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF3B8F5  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF3B8F7  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF3B8F9  fb1258250100                      mov.l   #12558h, r1
FFF3B8FF  6602                              mov.l   #0, r2
FFF3B901  9212                              mov.w   r2, 10h[r1]
FFF3B903  a09a                              mov.l   r2, 0Ch[r1]
FFF3B905  a092                              mov.l   r2, 8[r1]
FFF3B907  a01a                              mov.l   r2, 4[r1]
FFF3B909  e312                              mov.l   r2, [r1]
FFF3B90B  fbe29b220100                      mov.l   #1229Bh, r14
FFF3B911  58ee                              movu.b  [r14], r14
FFF3B913  611e                              cmp     #1, r14
FFF3B915  3b0d01                            bne.w   loc_FFF3BA22
FFF3B918  051e83ff                          bsr.a   sub_FFF33C36
FFF3B91C  710110                            add     #2Ch+var_1C, sp, r1
FFF3B91F  05f971fd                          bsr.a   sub_FFF12B18
FFF3B923  9489                              mov.w   r1, 2Ch+var_6[sp]
FFF3B925  bc89                              movu.w  2Ch+var_6[sp], r1
FFF3B927  6101                              cmp     #0, r1
FFF3B929  2152                              bne.b   loc_FFF3B97B
FFF3B92B  fbe26c250100                      mov.l   #1256Ch, r14
FFF3B931  d10e08                            mov.w   2Ch+var_1C[sp], [r14]
FFF3B934  2e47                              bra.b   loc_FFF3B97B
FFF3B936  fb1262080100           loc_FFF3B936 mov.l   #10862h, r1
FFF3B93C  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3B942  e0e1                              mov.l   [r14], [r1]
FFF3B944  fbe21883edff                      mov.l   #off_FFED8318, r14; "FT3D"
FFF3B94A  bd0a                              movu.w  2Ch+var_2[sp], r2
FFF3B94C  fe62ee                            mov.l   [r2, r14], r14
FFF3B94F  fb36ff                            mov.l   #-1, r3
FFF3B952  6602                              mov.l   #0, r2
FFF3B954  7f80                              suntil.b
FFF3B956  6011                              sub     #1, r1
FFF3B958  efe2                              mov.l   r14, r2
FFF3B95A  7f87                              smovu
FFF3B95C  fb1262080100                      mov.l   #10862h, r1
FFF3B962  059772fd                          bsr.a   sub_FFF12BF9
FFF3B966  c70125                            mov.b   r1, 2Ch+var_7[sp]
FFF3B969  590125                            movu.b  2Ch+var_7[sp], r1
FFF3B96C  6111                              cmp     #1, r1
FFF3B96E  17                                beq.s   loc_FFF3B975
FFF3B96F  9d01                              mov.w   2Ch+var_4[sp], r1
FFF3B971  6211                              add     #1, r1
FFF3B973  9501                              mov.w   r1, 2Ch+var_4[sp]
FFF3B975  9d09                   loc_FFF3B975 mov.w   2Ch+var_2[sp], r1
FFF3B977  6211                              add     #1, r1
FFF3B979  9509                              mov.w   r1, 2Ch+var_2[sp]
FFF3B97B  fbe21883edff           loc_FFF3B97B mov.l   #off_FFED8318, r14; "FT3D"
FFF3B981  bd09                              movu.w  2Ch+var_2[sp], r1
FFF3B983  fe61ee                            mov.l   [r1, r14], r14
FFF3B986  610e                              cmp     #0, r14
FFF3B988  21ae                              bne.b   loc_FFF3B936
FFF3B98A  fb1258250100                      mov.l   #12558h, r1
FFF3B990  3d1090                            mov.w   #-70h, [r1]
FFF3B993  fb1258250100                      mov.l   #12558h, r1
FFF3B999  3d1101                            mov.w   #1, 2[r1]
FFF3B99C  fb1258250100                      mov.l   #12558h, r1
FFF3B9A2  3d1300                            mov.w   #0, 6[r1]
FFF3B9A5  fbe258250100                      mov.l   #12558h, r14
FFF3B9AB  fbf26c250100                      mov.l   #1256Ch, r15
FFF3B9B1  d4fe02                            mov.w   [r15], 4[r14]
FFF3B9B4  bd01                              movu.w  2Ch+var_4[sp], r1
FFF3B9B6  6101                              cmp     #0, r1
FFF3B9B8  200c                              beq.b   loc_FFF3B9C4
FFF3B9BA  fb12d0830600                      mov.l   #683D0h, r1
FFF3B9C0  3d10c9                            mov.w   #-37h, [r1]
FFF3B9C3  0a                                bra.s   loc_FFF3B9CD
FFF3B9C4  fb12d0830600           loc_FFF3B9C4 mov.l   #683D0h, r1
FFF3B9CA  3d10c8                            mov.w   #-38h, [r1]
FFF3B9CD  fb12d0830600           loc_FFF3B9CD mov.l   #683D0h, r1
FFF3B9D3  3d1c00                            mov.w   #0, 18h[r1]
FFF3B9D6  7100c8                            add     #-38h, sp, sp
FFF3B9D9  754312                            mov.l   #12h, r3
FFF3B9DC  fb2258250100                      mov.l   #12558h, r2
FFF3B9E2  ef01                              mov.l   sp, r1
FFF3B9E4  7f8f                              smovf
FFF3B9E6  ef01                              mov.l   sp, r1
FFF3B9E8  711114                            add     #14h, r1, r1
FFF3B9EB  754324                            mov.l   #24h, r3 ; '$'
FFF3B9EE  fb22d0830600                      mov.l   #683D0h, r2
FFF3B9F4  7f8f                              smovf
FFF3B9F6  6602                              mov.l   #0, r2
FFF3B9F8  7541fe                            mov.l   #-2, r1
FFF3B9FB  05e11efa                          bsr.a   sub_FFEDD8DC
FFF3B9FF  710038                            add     #38h, sp, sp ; '8'
FFF3BA02  f80400                            mov.b   #0, 2Ch+var_2C[sp]
FFF3BA05  3e0100                            mov.l   #0, 2Ch+var_28[sp]
FFF3BA08  3e0200                            mov.l   #0, 2Ch+var_24[sp]
FFF3BA0B  ef03                              mov.l   sp, r3
FFF3BA0D  6642                              mov.l   #4, r2
FFF3BA0F  754149                            mov.l   #49h, r1 ; 'I'
FFF3BA12  05b4a0fe                          bsr.a   sub_FFF25AC6
FFF3BA16  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF3BA18  a889                              mov.l   2Ch+var_20[sp], r1
FFF3BA1A  6101                              cmp     #0, r1
FFF3BA1C  1e                                bne.s   loc_FFF3BA22
FFF3BA1D  39c93f                            bsr.w   sub_FFF3F9E6
FFF3BA20  670b                              rtsd    #0Bh
FFF3BA22  670b                   loc_FFF3BA22 rtsd    #0Bh
FFF3BA24  7100f0                 sub_FFF3BA24 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3BA24
FFF3BA27  f80400                            mov.b   #0, 10h+var_10[sp]
FFF3BA2A  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF3BA2D  3e0200                            mov.l   #0, 10h+var_8[sp]
FFF3BA30  fb12f7aff4ff                      mov.l   #aILmrepair, r1; "local tree, not in this repo"
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
FFF3BA5A  05dc81ff               sub_FFF3BA5A bsr.a   sub_FFF33C36   ; <<<< FUNC sub_FFF3BA5A
FFF3BA5E  754340                            mov.l   #40h, r3 ; '@'
FFF3BA61  6602                              mov.l   #0, r2
FFF3BA63  fb12660c0100                      mov.l   #10C66h, r1
FFF3BA69  7f88                              sstr.b
FFF3BA6B  fb12660e0100                      mov.l   #10E66h, r1
FFF3BA71  6602                              mov.l   #0, r2
FFF3BA73  a19a                              mov.l   r2, 1Ch[r1]
FFF3BA75  a192                              mov.l   r2, 18h[r1]
FFF3BA77  a11a                              mov.l   r2, 14h[r1]
FFF3BA79  a112                              mov.l   r2, 10h[r1]
FFF3BA7B  a09a                              mov.l   r2, 0Ch[r1]
FFF3BA7D  a092                              mov.l   r2, 8[r1]
FFF3BA7F  a01a                              mov.l   r2, 4[r1]
FFF3BA81  e312                              mov.l   r2, [r1]
FFF3BA83  fb3a0004                          mov.l   #400h, r3
FFF3BA87  6602                              mov.l   #0, r2
FFF3BA89  fb12660f0100                      mov.l   #10F66h, r1
FFF3BA8F  7f88                              sstr.b
FFF3BA91  fb1258250100                      mov.l   #12558h, r1
FFF3BA97  6602                              mov.l   #0, r2
FFF3BA99  9212                              mov.w   r2, 10h[r1]
FFF3BA9B  a09a                              mov.l   r2, 0Ch[r1]
FFF3BA9D  a092                              mov.l   r2, 8[r1]
FFF3BA9F  a01a                              mov.l   r2, 4[r1]
FFF3BAA1  e312                              mov.l   r2, [r1]
FFF3BAA3  fb1258250100                      mov.l   #12558h, r1
FFF3BAA9  3d1090                            mov.w   #-70h, [r1]
FFF3BAAC  fb1258250100                      mov.l   #12558h, r1
FFF3BAB2  3d1101                            mov.w   #1, 2[r1]
FFF3BAB5  fb1258250100                      mov.l   #12558h, r1
FFF3BABB  3d1300                            mov.w   #0, 6[r1]
FFF3BABE  fbe258250100                      mov.l   #12558h, r14
FFF3BAC4  fbf26c250100                      mov.l   #1256Ch, r15
FFF3BACA  d4fe02                            mov.w   [r15], 4[r14]
FFF3BACD  fb12d0830600                      mov.l   #683D0h, r1
FFF3BAD3  3d10cd                            mov.w   #-33h, [r1]
FFF3BAD6  fb12d0830600                      mov.l   #683D0h, r1
FFF3BADC  3d1c00                            mov.w   #0, 18h[r1]
FFF3BADF  7100c8                            add     #-38h, sp, sp
FFF3BAE2  754312                            mov.l   #12h, r3
FFF3BAE5  fb2258250100                      mov.l   #12558h, r2
FFF3BAEB  ef01                              mov.l   sp, r1
FFF3BAED  7f8f                              smovf
FFF3BAEF  ef01                              mov.l   sp, r1
FFF3BAF1  711114                            add     #14h, r1, r1
FFF3BAF4  754324                            mov.l   #24h, r3 ; '$'
FFF3BAF7  fb22d0830600                      mov.l   #683D0h, r2
FFF3BAFD  7f8f                              smovf
FFF3BAFF  6602                              mov.l   #0, r2
FFF3BB01  7541fe                            mov.l   #-2, r1
FFF3BB04  05d81dfa                          bsr.a   sub_FFEDD8DC
FFF3BB08  710038                            add     #38h, sp, sp
FFF3BB0B  02                                rts
FFF3BB0C  7100e4                 sub_FFF3BB0C add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF3BB0C
FFF3BB0F  3d0d00                            mov.w   #0, 1Ch+var_2[sp]
FFF3BB12  3d0c00                            mov.w   #0, 1Ch+var_4[sp]
FFF3BB15  3c8701                            mov.b   #1, 1Ch+var_5[sp]
FFF3BB18  6601                              mov.l   #0, r1
FFF3BB1A  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF3BB1C  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF3BB1E  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF3BB20  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF3BB22  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF3BB24  fb1258250100                      mov.l   #12558h, r1
FFF3BB2A  6602                              mov.l   #0, r2
FFF3BB2C  9212                              mov.w   r2, 10h[r1]
FFF3BB2E  a09a                              mov.l   r2, 0Ch[r1]
FFF3BB30  a092                              mov.l   r2, 8[r1]
FFF3BB32  a01a                              mov.l   r2, 4[r1]
FFF3BB34  e312                              mov.l   r2, [r1]
FFF3BB36  ef01                              mov.l   sp, r1
FFF3BB38  05e06ffd                          bsr.a   sub_FFF12B18
FFF3BB3C  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF3BB3E  bb09                              movu.w  1Ch+var_2[sp], r1
FFF3BB40  6101                              cmp     #0, r1
FFF3BB42  3bd300                            bne.w   loc_FFF3BC15
FFF3BB45  fbe26c250100                      mov.l   #1256Ch, r14
FFF3BB4B  d00e                              mov.w   1Ch+var_1C[sp], [r14]
FFF3BB4D  38c800                            bra.w   loc_FFF3BC15
FFF3BB50  fb1262080100           loc_FFF3BB50 mov.l   #10862h, r1
FFF3BB56  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3BB5C  e0e1                              mov.l   [r14], [r1]
FFF3BB5E  fbe21883edff                      mov.l   #off_FFED8318, r14; "FT3D"
FFF3BB64  bb02                              movu.w  1Ch+var_4[sp], r2
FFF3BB66  fe62ee                            mov.l   [r2, r14], r14
FFF3BB69  fb36ff                            mov.l   #-1, r3
FFF3BB6C  6602                              mov.l   #0, r2
FFF3BB6E  7f80                              suntil.b
FFF3BB70  6011                              sub     #1, r1
FFF3BB72  efe2                              mov.l   r14, r2
FFF3BB74  7f87                              smovu
FFF3BB76  fb1262080100                      mov.l   #10862h, r1
FFF3BB7C  057d70fd                          bsr.a   sub_FFF12BF9
FFF3BB80  8589                              mov.b   r1, 1Ch+var_5[sp]
FFF3BB82  b589                              movu.b  1Ch+var_5[sp], r1
FFF3BB84  6111                              cmp     #1, r1
FFF3BB86  3a8900                            beq.w   loc_FFF3BC0F
FFF3BB89  fb1262080100                      mov.l   #10862h, r1
FFF3BB8F  051e70fd                          bsr.a   sub_FFF12BAD
FFF3BB93  9309                              mov.w   r1, 1Ch+var_2[sp]
FFF3BB95  bb09                              movu.w  1Ch+var_2[sp], r1
FFF3BB97  6101                              cmp     #0, r1
FFF3BB99  2076                              beq.b   loc_FFF3BC0F
FFF3BB9B  754312                            mov.l   #12h, r3
FFF3BB9E  fb2234250100                      mov.l   #12534h, r2
FFF3BBA4  fb1258250100                      mov.l   #12558h, r1
FFF3BBAA  7f8f                              smovf
FFF3BBAC  fb1258250100                      mov.l   #12558h, r1
FFF3BBB2  3d1090                            mov.w   #-70h, [r1]
FFF3BBB5  fb1258250100                      mov.l   #12558h, r1
FFF3BBBB  3d1101                            mov.w   #1, 2[r1]
FFF3BBBE  fbe258250100                      mov.l   #12558h, r14
FFF3BBC4  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3BBC9  fbe258250100                      mov.l   #12558h, r14
FFF3BBCF  fbf26c250100                      mov.l   #1256Ch, r15
FFF3BBD5  d4fe02                            mov.w   [r15], 4[r14]
FFF3BBD8  fb12d0830600                      mov.l   #683D0h, r1
FFF3BBDE  3d1c00                            mov.w   #0, 18h[r1]
FFF3BBE1  7100c8                            add     #-38h, sp, sp
FFF3BBE4  754312                            mov.l   #12h, r3
FFF3BBE7  fb2258250100                      mov.l   #12558h, r2
FFF3BBED  ef01                              mov.l   sp, r1
FFF3BBEF  7f8f                              smovf
FFF3BBF1  ef01                              mov.l   sp, r1
FFF3BBF3  711114                            add     #14h, r1, r1
FFF3BBF6  754324                            mov.l   #24h, r3 ; '$'
FFF3BBF9  fb22d0830600                      mov.l   #683D0h, r2
FFF3BBFF  7f8f                              smovf
FFF3BC01  6602                              mov.l   #0, r2
FFF3BC03  7541fe                            mov.l   #-2, r1
FFF3BC06  05d61cfa                          bsr.a   sub_FFEDD8DC
FFF3BC0A  710038                            add     #38h, sp, sp ; '8'
FFF3BC0D  6707                              rtsd    #7
FFF3BC0F  9b01                   loc_FFF3BC0F mov.w   1Ch+var_4[sp], r1
FFF3BC11  6211                              add     #1, r1
FFF3BC13  9301                              mov.w   r1, 1Ch+var_4[sp]
FFF3BC15  fbe21883edff           loc_FFF3BC15 mov.l   #off_FFED8318, r14; "FT3D"
FFF3BC1B  bb01                              movu.w  1Ch+var_4[sp], r1
FFF3BC1D  fe61ee                            mov.l   [r1, r14], r14
FFF3BC20  610e                              cmp     #0, r14
FFF3BC22  3b2eff                            bne.w   loc_FFF3BB50
FFF3BC25  754312                            mov.l   #12h, r3
FFF3BC28  fb2234250100                      mov.l   #12534h, r2
FFF3BC2E  fb1258250100                      mov.l   #12558h, r1
FFF3BC34  7f8f                              smovf
FFF3BC36  fb1258250100                      mov.l   #12558h, r1
FFF3BC3C  3d1090                            mov.w   #-70h, [r1]
FFF3BC3F  fb1258250100                      mov.l   #12558h, r1
FFF3BC45  3d1101                            mov.w   #1, 2[r1]
FFF3BC48  fb1258250100                      mov.l   #12558h, r1
FFF3BC4E  3d1300                            mov.w   #0, 6[r1]
FFF3BC51  fbe258250100                      mov.l   #12558h, r14
FFF3BC57  fbf26c250100                      mov.l   #1256Ch, r15
FFF3BC5D  d4fe02                            mov.w   [r15], 4[r14]
FFF3BC60  fb12d0830600                      mov.l   #683D0h, r1
FFF3BC66  3d1c00                            mov.w   #0, 18h[r1]
FFF3BC69  7100c8                            add     #-38h, sp, sp
FFF3BC6C  754312                            mov.l   #12h, r3
FFF3BC6F  fb2258250100                      mov.l   #12558h, r2
FFF3BC75  ef01                              mov.l   sp, r1
FFF3BC77  7f8f                              smovf
FFF3BC79  ef01                              mov.l   sp, r1
FFF3BC7B  711114                            add     #14h, r1, r1
FFF3BC7E  754324                            mov.l   #24h, r3 ; '$'
FFF3BC81  fb22d0830600                      mov.l   #683D0h, r2
FFF3BC87  7f8f                              smovf
FFF3BC89  6602                              mov.l   #0, r2
FFF3BC8B  7541fe                            mov.l   #-2, r1
FFF3BC8E  054e1cfa                          bsr.a   sub_FFEDD8DC
FFF3BC92  710038                            add     #38h, sp, sp
FFF3BC95  6707                              rtsd    #7
FFF3BC97  7100e0                 sub_FFF3BC97 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF3BC97
FFF3BC9A  a189                              mov.l   r1, 20h+var_4[sp]
FFF3BC9C  3c8900                            mov.b   #0, 20h+var_7[sp]
FFF3BC9F  3d0b00                            mov.w   #0, 20h+var_A[sp]
FFF3BCA2  6601                              mov.l   #0, r1
FFF3BCA4  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BCA6  a089                              mov.l   r1, 20h+var_14[sp]
FFF3BCA8  a081                              mov.l   r1, 20h+var_18[sp]
FFF3BCAA  fbe25f080100                      mov.l   #1085Fh, r14
FFF3BCB0  58ee                              movu.b  [r14], r14
FFF3BCB2  611e                              cmp     #1, r14
FFF3BCB4  200d                              beq.b   loc_FFF3BCC1
FFF3BCB6  fbe260080100                      mov.l   #10860h, r14
FFF3BCBC  58ee                              movu.b  [r14], r14
FFF3BCBE  614e                              cmp     #4, r14
FFF3BCC0  1d                                bne.s   loc_FFF3BCC5
FFF3BCC1  f80601                 loc_FFF3BCC1 mov.l   #1, 20h+var_20[sp]
FFF3BCC4  0c                                bra.s   loc_FFF3BCC8
FFF3BCC5  f80600                 loc_FFF3BCC5 mov.l   #0, 20h+var_20[sp]
FFF3BCC8  ec01                   loc_FFF3BCC8 mov.l   20h+var_20[sp], r1
FFF3BCCA  6101                              cmp     #0, r1
FFF3BCCC  11                                beq.s   loc_FFF3BCD5
FFF3BCCD  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF3BCD2  388b04                            bra.w   loc_FFF3C15D
FFF3BCD5  754340                 loc_FFF3BCD5 mov.l   #40h, r3 ; '@'
FFF3BCD8  6602                              mov.l   #0, r2
FFF3BCDA  fb12660c0100                      mov.l   #10C66h, r1
FFF3BCE0  7f88                              sstr.b
FFF3BCE2  754340                            mov.l   #40h, r3 ; '@'
FFF3BCE5  6602                              mov.l   #0, r2
FFF3BCE7  fb12a60c0100                      mov.l   #10CA6h, r1
FFF3BCED  7f88                              sstr.b
FFF3BCEF  754340                            mov.l   #40h, r3 ; '@'
FFF3BCF2  6602                              mov.l   #0, r2
FFF3BCF4  fb12e60c0100                      mov.l   #10CE6h, r1
FFF3BCFA  7f88                              sstr.b
FFF3BCFC  754340                            mov.l   #40h, r3 ; '@'
FFF3BCFF  6602                              mov.l   #0, r2
FFF3BD01  fb12260d0100                      mov.l   #10D26h, r1
FFF3BD07  7f88                              sstr.b
FFF3BD09  fb12660e0100                      mov.l   #10E66h, r1
FFF3BD0F  6602                              mov.l   #0, r2
FFF3BD11  a19a                              mov.l   r2, 1Ch[r1]
FFF3BD13  a192                              mov.l   r2, 18h[r1]
FFF3BD15  a11a                              mov.l   r2, 14h[r1]
FFF3BD17  a112                              mov.l   r2, 10h[r1]
FFF3BD19  a09a                              mov.l   r2, 0Ch[r1]
FFF3BD1B  a092                              mov.l   r2, 8[r1]
FFF3BD1D  a01a                              mov.l   r2, 4[r1]
FFF3BD1F  e312                              mov.l   r2, [r1]
FFF3BD21  fb12860e0100                      mov.l   #10E86h, r1
FFF3BD27  6602                              mov.l   #0, r2
FFF3BD29  a19a                              mov.l   r2, 1Ch[r1]
FFF3BD2B  a192                              mov.l   r2, 18h[r1]
FFF3BD2D  a11a                              mov.l   r2, 14h[r1]
FFF3BD2F  a112                              mov.l   r2, 10h[r1]
FFF3BD31  a09a                              mov.l   r2, 0Ch[r1]
FFF3BD33  a092                              mov.l   r2, 8[r1]
FFF3BD35  a01a                              mov.l   r2, 4[r1]
FFF3BD37  e312                              mov.l   r2, [r1]
FFF3BD39  fb12a60e0100                      mov.l   #10EA6h, r1
FFF3BD3F  6602                              mov.l   #0, r2
FFF3BD41  a19a                              mov.l   r2, 1Ch[r1]
FFF3BD43  a192                              mov.l   r2, 18h[r1]
FFF3BD45  a11a                              mov.l   r2, 14h[r1]
FFF3BD47  a112                              mov.l   r2, 10h[r1]
FFF3BD49  a09a                              mov.l   r2, 0Ch[r1]
FFF3BD4B  a092                              mov.l   r2, 8[r1]
FFF3BD4D  a01a                              mov.l   r2, 4[r1]
FFF3BD4F  e312                              mov.l   r2, [r1]
FFF3BD51  fb12c60e0100                      mov.l   #10EC6h, r1
FFF3BD57  6602                              mov.l   #0, r2
FFF3BD59  a19a                              mov.l   r2, 1Ch[r1]
FFF3BD5B  a192                              mov.l   r2, 18h[r1]
FFF3BD5D  a11a                              mov.l   r2, 14h[r1]
FFF3BD5F  a112                              mov.l   r2, 10h[r1]
FFF3BD61  a09a                              mov.l   r2, 0Ch[r1]
FFF3BD63  a092                              mov.l   r2, 8[r1]
FFF3BD65  a01a                              mov.l   r2, 4[r1]
FFF3BD67  e312                              mov.l   r2, [r1]
FFF3BD69  fb3a0004                          mov.l   #400h, r3
FFF3BD6D  6602                              mov.l   #0, r2
FFF3BD6F  fb12660f0100                      mov.l   #10F66h, r1
FFF3BD75  7f88                              sstr.b
FFF3BD77  fb3a0004                          mov.l   #400h, r3
FFF3BD7B  6602                              mov.l   #0, r2
FFF3BD7D  fb1266130100                      mov.l   #11366h, r1
FFF3BD83  7f88                              sstr.b
FFF3BD85  fb3a0004                          mov.l   #400h, r3
FFF3BD89  6602                              mov.l   #0, r2
FFF3BD8B  fb1266170100                      mov.l   #11766h, r1
FFF3BD91  7f88                              sstr.b
FFF3BD93  fb3a0004                          mov.l   #400h, r3
FFF3BD97  6602                              mov.l   #0, r2
FFF3BD99  fb12661b0100                      mov.l   #11B66h, r1
FFF3BD9F  7f88                              sstr.b
FFF3BDA1  fb12f0840600                      mov.l   #684F0h, r1
FFF3BDA7  b819                              movu.w  2[r1], r1
FFF3BDA9  6101                              cmp     #0, r1
FFF3BDAB  3b9700                            bne.w   loc_FFF3BE42
FFF3BDAE  754340                            mov.l   #40h, r3 ; '@'
FFF3BDB1  6602                              mov.l   #0, r2
FFF3BDB3  fb12660d0100                      mov.l   #10D66h, r1
FFF3BDB9  7f88                              sstr.b
FFF3BDBB  754340                            mov.l   #40h, r3 ; '@'
FFF3BDBE  6602                              mov.l   #0, r2
FFF3BDC0  fb12a60d0100                      mov.l   #10DA6h, r1
FFF3BDC6  7f88                              sstr.b
FFF3BDC8  754340                            mov.l   #40h, r3 ; '@'
FFF3BDCB  6602                              mov.l   #0, r2
FFF3BDCD  fb12e60d0100                      mov.l   #10DE6h, r1
FFF3BDD3  7f88                              sstr.b
FFF3BDD5  754340                            mov.l   #40h, r3 ; '@'
FFF3BDD8  6602                              mov.l   #0, r2
FFF3BDDA  fb12260e0100                      mov.l   #10E26h, r1
FFF3BDE0  7f88                              sstr.b
FFF3BDE2  fb12e60e0100                      mov.l   #10EE6h, r1
FFF3BDE8  6602                              mov.l   #0, r2
FFF3BDEA  a19a                              mov.l   r2, 1Ch[r1]
FFF3BDEC  a192                              mov.l   r2, 18h[r1]
FFF3BDEE  a11a                              mov.l   r2, 14h[r1]
FFF3BDF0  a112                              mov.l   r2, 10h[r1]
FFF3BDF2  a09a                              mov.l   r2, 0Ch[r1]
FFF3BDF4  a092                              mov.l   r2, 8[r1]
FFF3BDF6  a01a                              mov.l   r2, 4[r1]
FFF3BDF8  e312                              mov.l   r2, [r1]
FFF3BDFA  fb12060f0100                      mov.l   #10F06h, r1
FFF3BE00  6602                              mov.l   #0, r2
FFF3BE02  a19a                              mov.l   r2, 1Ch[r1]
FFF3BE04  a192                              mov.l   r2, 18h[r1]
FFF3BE06  a11a                              mov.l   r2, 14h[r1]
FFF3BE08  a112                              mov.l   r2, 10h[r1]
FFF3BE0A  a09a                              mov.l   r2, 0Ch[r1]
FFF3BE0C  a092                              mov.l   r2, 8[r1]
FFF3BE0E  a01a                              mov.l   r2, 4[r1]
FFF3BE10  e312                              mov.l   r2, [r1]
FFF3BE12  fb12260f0100                      mov.l   #10F26h, r1
FFF3BE18  6602                              mov.l   #0, r2
FFF3BE1A  a19a                              mov.l   r2, 1Ch[r1]
FFF3BE1C  a192                              mov.l   r2, 18h[r1]
FFF3BE1E  a11a                              mov.l   r2, 14h[r1]
FFF3BE20  a112                              mov.l   r2, 10h[r1]
FFF3BE22  a09a                              mov.l   r2, 0Ch[r1]
FFF3BE24  a092                              mov.l   r2, 8[r1]
FFF3BE26  a01a                              mov.l   r2, 4[r1]
FFF3BE28  e312                              mov.l   r2, [r1]
FFF3BE2A  fb12460f0100                      mov.l   #10F46h, r1
FFF3BE30  6602                              mov.l   #0, r2
FFF3BE32  a19a                              mov.l   r2, 1Ch[r1]
FFF3BE34  a192                              mov.l   r2, 18h[r1]
FFF3BE36  a11a                              mov.l   r2, 14h[r1]
FFF3BE38  a112                              mov.l   r2, 10h[r1]
FFF3BE3A  a09a                              mov.l   r2, 0Ch[r1]
FFF3BE3C  a092                              mov.l   r2, 8[r1]
FFF3BE3E  a01a                              mov.l   r2, 4[r1]
FFF3BE40  e312                              mov.l   r2, [r1]
FFF3BE42  a989                   loc_FFF3BE42 mov.l   20h+var_4[sp], r1
FFF3BE44  b211                              movu.b  8[r1], r1
FFF3BE46  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BE48  a901                              mov.l   20h+var_10[sp], r1
FFF3BE4A  6c81                              shll    #8, r1
FFF3BE4C  a98a                              mov.l   20h+var_4[sp], r2
FFF3BE4E  552109                            or      9[r2], r1
FFF3BE51  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BE53  a901                              mov.l   20h+var_10[sp], r1
FFF3BE55  fbe234250100                      mov.l   #12534h, r14
FFF3BE5B  d3e1                              mov.w   r1, [r14]
FFF3BE5D  a989                              mov.l   20h+var_4[sp], r1
FFF3BE5F  b291                              movu.b  0Ah[r1], r1
FFF3BE61  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BE63  a901                              mov.l   20h+var_10[sp], r1
FFF3BE65  6c81                              shll    #8, r1
FFF3BE67  a98a                              mov.l   20h+var_4[sp], r2
FFF3BE69  55210b                            or      0Bh[r2], r1
FFF3BE6C  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BE6E  a901                              mov.l   20h+var_10[sp], r1
FFF3BE70  6151                              cmp     #5, r1
FFF3BE72  230a                              bltu.b  loc_FFF3BE7C
FFF3BE74  f90903ffff                        mov.w   #-1, 20h+var_1A[sp]
FFF3BE79  38e402                            bra.w   loc_FFF3C15D
FFF3BE7C  a901                   loc_FFF3BE7C mov.l   20h+var_10[sp], r1
FFF3BE7E  fb2234250100                      mov.l   #12534h, r2
FFF3BE84  9029                              mov.w   r1, 2[r2]
FFF3BE86  a989                              mov.l   20h+var_4[sp], r1
FFF3BE88  b311                              movu.b  0Ch[r1], r1
FFF3BE8A  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BE8C  a901                              mov.l   20h+var_10[sp], r1
FFF3BE8E  6c81                              shll    #8, r1
FFF3BE90  a98a                              mov.l   20h+var_4[sp], r2
FFF3BE92  55210d                            or      0Dh[r2], r1
FFF3BE95  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BE97  a901                              mov.l   20h+var_10[sp], r1
FFF3BE99  fb2234250100                      mov.l   #12534h, r2
FFF3BE9F  90a1                              mov.w   r1, 4[r2]
FFF3BEA1  a989                              mov.l   20h+var_4[sp], r1
FFF3BEA3  b391                              movu.b  0Eh[r1], r1
FFF3BEA5  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BEA7  a901                              mov.l   20h+var_10[sp], r1
FFF3BEA9  6c81                              shll    #8, r1
FFF3BEAB  a98a                              mov.l   20h+var_4[sp], r2
FFF3BEAD  55210f                            or      0Fh[r2], r1
FFF3BEB0  a101                              mov.l   r1, 20h+var_10[sp]
FFF3BEB2  a901                              mov.l   20h+var_10[sp], r1
FFF3BEB4  fb2234250100                      mov.l   #12534h, r2
FFF3BEBA  90a9                              mov.w   r1, 6[r2]
FFF3BEBC  a989                              mov.l   20h+var_4[sp], r1
FFF3BEBE  c5101019                          mov.b   10h[r1], 20h+var_7[sp]
FFF3BEC2  b609                              movu.b  20h+var_7[sp], r1
FFF3BEC4  6841                              shlr    #4, r1
FFF3BEC6  6191                              cmp     #9, r1; switch 10 cases
FFF3BEC8  2475                              bgtu.b  def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BECA  fbe21380f4ff                      mov.l   #jpt_FFF3BED3, r14
FFF3BED0  fe41ee                            mov.b   [r1, r14], r14
FFF3BED3  7f4e                              bra.l   r14; switch jump
FFF3BED5  b609                   loc_FFF3BED5 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 0
FFF3BED7  64f1                              and     #0Fh, r1
FFF3BED9  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BEDB  2e62                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BEDD  b609                   loc_FFF3BEDD movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 1
FFF3BEDF  64f1                              and     #0Fh, r1
FFF3BEE1  62a1                              add     #0Ah, r1
FFF3BEE3  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BEE5  2e58                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BEE7  b609                   loc_FFF3BEE7 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 2
FFF3BEE9  64f1                              and     #0Fh, r1
FFF3BEEB  711114                            add     #14h, r1, r1
FFF3BEEE  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BEF0  2e4d                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BEF2  b609                   loc_FFF3BEF2 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 3
FFF3BEF4  64f1                              and     #0Fh, r1
FFF3BEF6  71111e                            add     #1Eh, r1, r1
FFF3BEF9  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BEFB  2e42                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BEFD  b609                   loc_FFF3BEFD movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 4
FFF3BEFF  64f1                              and     #0Fh, r1
FFF3BF01  711128                            add     #28h, r1, r1 ; '('
FFF3BF04  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF06  2e37                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BF08  b609                   loc_FFF3BF08 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 5
FFF3BF0A  64f1                              and     #0Fh, r1
FFF3BF0C  711132                            add     #32h, r1, r1 ; '2'
FFF3BF0F  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF11  2e2c                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BF13  b609                   loc_FFF3BF13 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 6
FFF3BF15  64f1                              and     #0Fh, r1
FFF3BF17  71113c                            add     #3Ch, r1, r1 ; '<'
FFF3BF1A  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF1C  2e21                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BF1E  b609                   loc_FFF3BF1E movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 7
FFF3BF20  64f1                              and     #0Fh, r1
FFF3BF22  711146                            add     #46h, r1, r1 ; 'F'
FFF3BF25  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF27  2e16                              bra.b   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BF29  b609                   loc_FFF3BF29 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 8
FFF3BF2B  753150                            or      #50h, r1 ; 'P'
FFF3BF2E  75215f                            and     #5Fh, r1 ; '_'
FFF3BF31  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF33  0a                                bra.s   def_FFF3BED3; jumptable FFF3BED3 default case
FFF3BF34  b609                   loc_FFF3BF34 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 case 9
FFF3BF36  64f1                              and     #0Fh, r1
FFF3BF38  71115a                            add     #5Ah, r1, r1 ; 'Z'
FFF3BF3B  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF3D  b609                   def_FFF3BED3 movu.b  20h+var_7[sp], r1; jumptable FFF3BED3 default case
FFF3BF3F  fb2234250100                      mov.l   #12534h, r2
FFF3BF45  9121                              mov.w   r1, 8[r2]
FFF3BF47  a989                              mov.l   20h+var_4[sp], r1
FFF3BF49  c5101119                          mov.b   11h[r1], 20h+var_7[sp]
FFF3BF4D  b609                              movu.b  20h+var_7[sp], r1
FFF3BF4F  6841                              shlr    #4, r1
FFF3BF51  6111                              cmp     #1, r1
FFF3BF53  200d                              beq.b   loc_FFF3BF60
FFF3BF55  6101                              cmp     #0, r1
FFF3BF57  2111                              bne.b   loc_FFF3BF68
FFF3BF59  b609                              movu.b  20h+var_7[sp], r1
FFF3BF5B  64f1                              and     #0Fh, r1
FFF3BF5D  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF5F  09                                bra.s   loc_FFF3BF68
FFF3BF60  b609                   loc_FFF3BF60 movu.b  20h+var_7[sp], r1
FFF3BF62  64f1                              and     #0Fh, r1
FFF3BF64  62a1                              add     #0Ah, r1
FFF3BF66  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF68  b609                   loc_FFF3BF68 movu.b  20h+var_7[sp], r1
FFF3BF6A  fb2234250100                      mov.l   #12534h, r2
FFF3BF70  9129                              mov.w   r1, 0Ah[r2]
FFF3BF72  a989                              mov.l   20h+var_4[sp], r1
FFF3BF74  c5101219                          mov.b   12h[r1], 20h+var_7[sp]
FFF3BF78  b609                              movu.b  20h+var_7[sp], r1
FFF3BF7A  6841                              shlr    #4, r1
FFF3BF7C  6131                              cmp     #3, r1
FFF3BF7E  202a                              beq.b   loc_FFF3BFA8
FFF3BF80  6111                              cmp     #1, r1
FFF3BF82  2012                              beq.b   loc_FFF3BF94
FFF3BF84  6121                              cmp     #2, r1
FFF3BF86  2018                              beq.b   loc_FFF3BF9E
FFF3BF88  6101                              cmp     #0, r1
FFF3BF8A  2127                              bne.b   loc_FFF3BFB1
FFF3BF8C  b609                              movu.b  20h+var_7[sp], r1
FFF3BF8E  64f1                              and     #0Fh, r1
FFF3BF90  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF92  2e1f                              bra.b   loc_FFF3BFB1
FFF3BF94  b609                   loc_FFF3BF94 movu.b  20h+var_7[sp], r1
FFF3BF96  64f1                              and     #0Fh, r1
FFF3BF98  62a1                              add     #0Ah, r1
FFF3BF9A  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BF9C  2e15                              bra.b   loc_FFF3BFB1
FFF3BF9E  b609                   loc_FFF3BF9E movu.b  20h+var_7[sp], r1
FFF3BFA0  64f1                              and     #0Fh, r1
FFF3BFA2  711114                            add     #14h, r1, r1
FFF3BFA5  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BFA7  0a                                bra.s   loc_FFF3BFB1
FFF3BFA8  b609                   loc_FFF3BFA8 movu.b  20h+var_7[sp], r1
FFF3BFAA  64f1                              and     #0Fh, r1
FFF3BFAC  71111e                            add     #1Eh, r1, r1
FFF3BFAF  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BFB1  b609                   loc_FFF3BFB1 movu.b  20h+var_7[sp], r1
FFF3BFB3  fb2234250100                      mov.l   #12534h, r2
FFF3BFB9  91a1                              mov.w   r1, 0Ch[r2]
FFF3BFBB  a989                              mov.l   20h+var_4[sp], r1
FFF3BFBD  c5101419                          mov.b   14h[r1], 20h+var_7[sp]
FFF3BFC1  b609                              movu.b  20h+var_7[sp], r1
FFF3BFC3  6841                              shlr    #4, r1
FFF3BFC5  6121                              cmp     #2, r1
FFF3BFC7  201b                              beq.b   loc_FFF3BFE2
FFF3BFC9  6111                              cmp     #1, r1
FFF3BFCB  200e                              beq.b   loc_FFF3BFD9
FFF3BFCD  6101                              cmp     #0, r1
FFF3BFCF  211c                              bne.b   loc_FFF3BFEB
FFF3BFD1  b609                              movu.b  20h+var_7[sp], r1
FFF3BFD3  64f1                              and     #0Fh, r1
FFF3BFD5  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BFD7  2e14                              bra.b   loc_FFF3BFEB
FFF3BFD9  b609                   loc_FFF3BFD9 movu.b  20h+var_7[sp], r1
FFF3BFDB  64f1                              and     #0Fh, r1
FFF3BFDD  62a1                              add     #0Ah, r1
FFF3BFDF  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BFE1  0a                                bra.s   loc_FFF3BFEB
FFF3BFE2  b609                   loc_FFF3BFE2 movu.b  20h+var_7[sp], r1
FFF3BFE4  64f1                              and     #0Fh, r1
FFF3BFE6  711114                            add     #14h, r1, r1
FFF3BFE9  8609                              mov.b   r1, 20h+var_7[sp]
FFF3BFEB  b609                   loc_FFF3BFEB movu.b  20h+var_7[sp], r1
FFF3BFED  fb2234250100                      mov.l   #12534h, r2
FFF3BFF3  91a9                              mov.w   r1, 0Eh[r2]
FFF3BFF5  a989                              mov.l   20h+var_4[sp], r1
FFF3BFF7  c5101519                          mov.b   15h[r1], 20h+var_7[sp]
FFF3BFFB  b609                              movu.b  20h+var_7[sp], r1
FFF3BFFD  6841                              shlr    #4, r1
FFF3BFFF  6151                              cmp     #5, r1
FFF3C001  2048                              beq.b   loc_FFF3C049
FFF3C003  6111                              cmp     #1, r1
FFF3C005  201a                              beq.b   loc_FFF3C01F
FFF3C007  6121                              cmp     #2, r1
FFF3C009  2020                              beq.b   loc_FFF3C029
FFF3C00B  6131                              cmp     #3, r1
FFF3C00D  2027                              beq.b   loc_FFF3C034
FFF3C00F  6141                              cmp     #4, r1
FFF3C011  202e                              beq.b   loc_FFF3C03F
FFF3C013  6101                              cmp     #0, r1
FFF3C015  213d                              bne.b   loc_FFF3C052
FFF3C017  b609                              movu.b  20h+var_7[sp], r1
FFF3C019  64f1                              and     #0Fh, r1
FFF3C01B  8609                              mov.b   r1, 20h+var_7[sp]
FFF3C01D  2e35                              bra.b   loc_FFF3C052
FFF3C01F  b609                   loc_FFF3C01F movu.b  20h+var_7[sp], r1
FFF3C021  64f1                              and     #0Fh, r1
FFF3C023  62a1                              add     #0Ah, r1
FFF3C025  8609                              mov.b   r1, 20h+var_7[sp]
FFF3C027  2e2b                              bra.b   loc_FFF3C052
FFF3C029  b609                   loc_FFF3C029 movu.b  20h+var_7[sp], r1
FFF3C02B  64f1                              and     #0Fh, r1
FFF3C02D  711114                            add     #14h, r1, r1
FFF3C030  8609                              mov.b   r1, 20h+var_7[sp]
FFF3C032  2e20                              bra.b   loc_FFF3C052
FFF3C034  b609                   loc_FFF3C034 movu.b  20h+var_7[sp], r1
FFF3C036  64f1                              and     #0Fh, r1
FFF3C038  71111e                            add     #1Eh, r1, r1
FFF3C03B  8609                              mov.b   r1, 20h+var_7[sp]
FFF3C03D  2e15                              bra.b   loc_FFF3C052
FFF3C03F  b609                   loc_FFF3C03F movu.b  20h+var_7[sp], r1
FFF3C041  64f1                              and     #0Fh, r1
FFF3C043  711128                            add     #28h, r1, r1 ; '('
FFF3C046  8609                              mov.b   r1, 20h+var_7[sp]
FFF3C048  0a                                bra.s   loc_FFF3C052
FFF3C049  b609                   loc_FFF3C049 movu.b  20h+var_7[sp], r1
FFF3C04B  64f1                              and     #0Fh, r1
FFF3C04D  711132                            add     #32h, r1, r1 ; '2'
FFF3C050  8609                              mov.b   r1, 20h+var_7[sp]
FFF3C052  b609                   loc_FFF3C052 movu.b  20h+var_7[sp], r1
FFF3C054  fb2234250100                      mov.l   #12534h, r2
FFF3C05A  9221                              mov.w   r1, 10h[r2]
FFF3C05C  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C062  ecee                              mov.l   [r14], r14
FFF3C064  f8e600                            mov.l   #0, [r14]
FFF3C067  fb1234250100                      mov.l   #12534h, r1
FFF3C06D  ba11                              movu.w  10h[r1], r1
FFF3C06F  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C075  ece2                              mov.l   [r14], r2
FFF3C077  a029                              mov.l   r1, 4[r2]
FFF3C079  fb1234250100                      mov.l   #12534h, r1
FFF3C07F  b999                              movu.w  0Eh[r1], r1
FFF3C081  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C087  ece2                              mov.l   [r14], r2
FFF3C089  a0a1                              mov.l   r1, 8[r2]
FFF3C08B  fb1234250100                      mov.l   #12534h, r1
FFF3C091  b991                              movu.w  0Ch[r1], r1
FFF3C093  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C099  ece2                              mov.l   [r14], r2
FFF3C09B  a0a9                              mov.l   r1, 0Ch[r2]
FFF3C09D  fb1234250100                      mov.l   #12534h, r1
FFF3C0A3  b919                              movu.w  0Ah[r1], r1
FFF3C0A5  6011                              sub     #1, r1
FFF3C0A7  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C0AD  ece2                              mov.l   [r14], r2
FFF3C0AF  a121                              mov.l   r1, 10h[r2]
FFF3C0B1  fb1234250100                      mov.l   #12534h, r1
FFF3C0B7  b911                              movu.w  8[r1], r1
FFF3C0B9  711164                            add     #64h, r1, r1 ; 'd'
FFF3C0BC  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C0C2  ece2                              mov.l   [r14], r2
FFF3C0C4  a129                              mov.l   r1, 14h[r2]
FFF3C0C6  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C0CC  ece1                              mov.l   [r14], r1
FFF3C0CE  3e1600                            mov.l   #0, 18h[r1]
FFF3C0D1  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C0D7  ece1                              mov.l   [r14], r1
FFF3C0D9  3e1700                            mov.l   #0, 1Ch[r1]
FFF3C0DC  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C0E2  ece1                              mov.l   [r14], r1
FFF3C0E4  3e1800                            mov.l   #0, 20h[r1]
FFF3C0E7  fb12f0840600                      mov.l   #684F0h, r1
FFF3C0ED  b819                              movu.w  2[r1], r1
FFF3C0EF  6101                              cmp     #0, r1
FFF3C0F1  2113                              bne.b   loc_FFF3C104
FFF3C0F3  754312                            mov.l   #12h, r3
FFF3C0F6  fb2234250100                      mov.l   #12534h, r2
FFF3C0FC  fb1246250100                      mov.l   #12546h, r1
FFF3C102  7f8f                              smovf
FFF3C104  3d0b00                 loc_FFF3C104 mov.w   #0, 20h+var_A[sp]
FFF3C107  2e3c                              bra.b   loc_FFF3C143
FFF3C109  ba89                   loc_FFF3C109 movu.w  20h+var_A[sp], r1
FFF3C10B  711eff                            add     #-1, r1, r14
FFF3C10E  613e                              cmp     #3, r14
FFF3C110  231a                              bltu.b  loc_FFF3C12A
FFF3C112  6101                              cmp     #0, r1
FFF3C114  2129                              bne.b   loc_FFF3C13D
FFF3C116  3e0318                            mov.l   #18h, 20h+var_14[sp]
FFF3C119  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF3C11C  a88b                              mov.l   20h+var_14[sp], r3
FFF3C11E  ba8a                              movu.w  20h+var_A[sp], r2
FFF3C120  a989                              mov.l   20h+var_4[sp], r1
FFF3C122  710408                            add     #20h+var_18, sp, r4
FFF3C125  398223                            bsr.w   sub_FFF3E4A7
FFF3C128  2e15                              bra.b   loc_FFF3C13D
FFF3C12A  e5000203               loc_FFF3C12A mov.l   20h+var_18[sp], 20h+var_14[sp]
FFF3C12E  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF3C131  a88b                              mov.l   20h+var_14[sp], r3
FFF3C133  ba8a                              movu.w  20h+var_A[sp], r2
FFF3C135  a989                              mov.l   20h+var_4[sp], r1
FFF3C137  710408                            add     #20h+var_18, sp, r4
FFF3C13A  396d23                            bsr.w   sub_FFF3E4A7
FFF3C13D  9a89                   loc_FFF3C13D mov.w   20h+var_A[sp], r1
FFF3C13F  6211                              add     #1, r1
FFF3C141  9289                              mov.w   r1, 20h+var_A[sp]
FFF3C143  fbe234250100           loc_FFF3C143 mov.l   #12534h, r14
FFF3C149  ba89                              movu.w  20h+var_A[sp], r1
FFF3C14B  06c5e101                          cmp     2[r14].uw, r1
FFF3C14F  29ba                              blt.b   loc_FFF3C109
FFF3C151  fbe260080100                      mov.l   #10860h, r14
FFF3C157  f8e404                            mov.b   #4, [r14]
FFF3C15A  3d0300                            mov.w   #0, 20h+var_1A[sp]
FFF3C15D  d500030d               loc_FFF3C15D mov.w   20h+var_1A[sp], 20h+var_6[sp]
FFF3C161  bb09                              movu.w  20h+var_6[sp], r1
FFF3C163  6708                              rtsd    #8
FFF3C165  60c0                   sub_FFF3C165 sub     #0Ch, sp   ; <<<< FUNC sub_FFF3C165
FFF3C167  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3C169  3c0700                            mov.b   #0, 0Ch+var_5[sp]
FFF3C16C  a881                              mov.l   0Ch+var_4[sp], r1
FFF3C16E  581e                              movu.b  [r1], r14
FFF3C170  755ef6                            cmp     #-0Ah, r14
FFF3C173  210e                              bne.b   loc_FFF3C181
FFF3C175  a881                              mov.l   0Ch+var_4[sp], r1
FFF3C177  b019                              movu.b  1[r1], r1
FFF3C179  755110                            cmp     #10h, r1
FFF3C17C  1d                                bne.s   loc_FFF3C181
FFF3C17D  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF3C180  0c                                bra.s   loc_FFF3C184
FFF3C181  f80600                 loc_FFF3C181 mov.l   #0, 0Ch+var_C[sp]
FFF3C184  ec01                   loc_FFF3C184 mov.l   0Ch+var_C[sp], r1
FFF3C186  6101                              cmp     #0, r1
FFF3C188  3ac300                            beq.w   loc_FFF3C24B
FFF3C18B  fbe2b1220100                      mov.l   #122B1h, r14
FFF3C191  58ee                              movu.b  [r14], r14
FFF3C193  610e                              cmp     #0, r14
FFF3C195  2028                              beq.b   loc_FFF3C1BD
FFF3C197  059490fd                          bsr.a   sub_FFF1522B
FFF3C19B  05378ffd                          bsr.a   sub_FFF150D2
FFF3C19F  fbe278020200                      mov.l   #20278h, r14
FFF3C1A5  eeee4dc0                          mov.l   30134h[r14], r14
FFF3C1A9  610e                              cmp     #0, r14
FFF3C1AB  2012                              beq.b   loc_FFF3C1BD
FFF3C1AD  fb1278020200                      mov.l   #20278h, r1
FFF3C1B3  ee124dc0                          mov.l   30134h[r1], r2
FFF3C1B7  6261                              add     #6, r1
FFF3C1B9  055c79fd                          bsr.a   sub_FFF13B15
FFF3C1BD  fbe20a250100           loc_FFF3C1BD mov.l   #1250Ah, r14
FFF3C1C3  5cee                              movu.w  [r14], r14
FFF3C1C5  611e                              cmp     #1, r14
FFF3C1C7  200d                              beq.b   loc_FFF3C1D4
FFF3C1C9  fb120a250100                      mov.l   #1250Ah, r1
FFF3C1CF  b819                              movu.w  2[r1], r1
FFF3C1D1  6111                              cmp     #1, r1
FFF3C1D3  1d                                bne.s   loc_FFF3C1D8
FFF3C1D4  f80601                 loc_FFF3C1D4 mov.l   #1, 0Ch+var_C[sp]
FFF3C1D7  0c                                bra.s   loc_FFF3C1DB
FFF3C1D8  f80600                 loc_FFF3C1D8 mov.l   #0, 0Ch+var_C[sp]
FFF3C1DB  ec01                   loc_FFF3C1DB mov.l   0Ch+var_C[sp], r1
FFF3C1DD  6101                              cmp     #0, r1
FFF3C1DF  210d                              bne.b   loc_FFF3C1EC
FFF3C1E1  fb120a250100                      mov.l   #1250Ah, r1
FFF3C1E7  b891                              movu.w  4[r1], r1
FFF3C1E9  6111                              cmp     #1, r1
FFF3C1EB  1d                                bne.s   loc_FFF3C1F0
FFF3C1EC  f80601                 loc_FFF3C1EC mov.l   #1, 0Ch+var_C[sp]
FFF3C1EF  0c                                bra.s   loc_FFF3C1F3
FFF3C1F0  f80600                 loc_FFF3C1F0 mov.l   #0, 0Ch+var_C[sp]
FFF3C1F3  ec01                   loc_FFF3C1F3 mov.l   0Ch+var_C[sp], r1
FFF3C1F5  6101                              cmp     #0, r1
FFF3C1F7  201c                              beq.b   loc_FFF3C213
FFF3C1F9  fbe2b1220100                      mov.l   #122B1h, r14
FFF3C1FF  58ee                              movu.b  [r14], r14
FFF3C201  610e                              cmp     #0, r14
FFF3C203  2010                              beq.b   loc_FFF3C213
FFF3C205  fbee1a7208                        mov.l   #8721Ah, r14
FFF3C20A  f0e2                              bset    #2, [r14].b
FFF3C20C  fbee801a0c                        mov.l   #0C1A80h, r14
FFF3C211  f0e6                              bset    #6, [r14].b
FFF3C213  fbe2b4220100           loc_FFF3C213 mov.l   #122B4h, r14
FFF3C219  58ee                              movu.b  [r14], r14
FFF3C21B  601e                              sub     #1, r14
FFF3C21D  615e                              cmp     #5, r14
FFF3C21F  2423                              bgtu.b  loc_FFF3C242
FFF3C221  fbe2b4220100                      mov.l   #122B4h, r14
FFF3C227  f8e403                            mov.b   #3, [r14]
FFF3C22A  fbe2b6220100                      mov.l   #122B6h, r14
FFF3C230  f8e400                            mov.b   #0, [r14]
FFF3C233  6641                              mov.l   #4, r1
FFF3C235  0530ddff                          bsr.a   sub_FFF39F65
FFF3C239  fbe25f080100                      mov.l   #1085Fh, r14
FFF3C23F  f8e400                            mov.b   #0, [r14]
FFF3C242  fbe2b1220100           loc_FFF3C242 mov.l   #122B1h, r14
FFF3C248  f8e400                            mov.b   #0, [r14]
FFF3C24B  a881                   loc_FFF3C24B mov.l   0Ch+var_4[sp], r1
FFF3C24D  c5101b07                          mov.b   1Bh[r1], 0Ch+var_5[sp]
FFF3C251  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C253  6161                              cmp     #6, r1
FFF3C255  205f                              beq.b   loc_FFF3C2B4
FFF3C257  6111                              cmp     #1, r1
FFF3C259  2021                              beq.b   loc_FFF3C27A
FFF3C25B  6121                              cmp     #2, r1
FFF3C25D  2028                              beq.b   loc_FFF3C285
FFF3C25F  6131                              cmp     #3, r1
FFF3C261  202f                              beq.b   loc_FFF3C290
FFF3C263  6141                              cmp     #4, r1
FFF3C265  2037                              beq.b   loc_FFF3C29C
FFF3C267  6151                              cmp     #5, r1
FFF3C269  203f                              beq.b   loc_FFF3C2A8
FFF3C26B  6101                              cmp     #0, r1
FFF3C26D  2152                              bne.b   loc_FFF3C2BF
FFF3C26F  fbe26e250100                      mov.l   #1256Eh, r14
FFF3C275  f8e500                            mov.w   #0, [r14]
FFF3C278  2e50                              bra.b   loc_FFF3C2C8
FFF3C27A  fbe26e250100           loc_FFF3C27A mov.l   #1256Eh, r14
FFF3C280  f8e564                            mov.w   #64h, [r14] ; 'd'
FFF3C283  2e45                              bra.b   loc_FFF3C2C8
FFF3C285  fb126e250100           loc_FFF3C285 mov.l   #1256Eh, r1
FFF3C28B  3d10c8                            mov.w   #-38h, [r1]
FFF3C28E  2e3a                              bra.b   loc_FFF3C2C8
FFF3C290  fbe26e250100           loc_FFF3C290 mov.l   #1256Eh, r14
FFF3C296  f8e9f401                          mov.w   #1F4h, [r14]
FFF3C29A  2e2e                              bra.b   loc_FFF3C2C8
FFF3C29C  fbe26e250100           loc_FFF3C29C mov.l   #1256Eh, r14
FFF3C2A2  f8e9e803                          mov.w   #3E8h, [r14]
FFF3C2A6  2e22                              bra.b   loc_FFF3C2C8
FFF3C2A8  fbe26e250100           loc_FFF3C2A8 mov.l   #1256Eh, r14
FFF3C2AE  f8e9b80b                          mov.w   #0BB8h, [r14]
FFF3C2B2  2e16                              bra.b   loc_FFF3C2C8
FFF3C2B4  fbe26e250100           loc_FFF3C2B4 mov.l   #1256Eh, r14
FFF3C2BA  f8e97017                          mov.w   #1770h, [r14]
FFF3C2BE  0a                                bra.s   loc_FFF3C2C8
FFF3C2BF  fbe26e250100           loc_FFF3C2BF mov.l   #1256Eh, r14
FFF3C2C5  f8e500                            mov.w   #0, [r14]
FFF3C2C8  fbe26e250100           loc_FFF3C2C8 mov.l   #1256Eh, r14
FFF3C2CE  5cee                              movu.w  [r14], r14
FFF3C2D0  610e                              cmp     #0, r14
FFF3C2D2  1c                                bne.s   loc_FFF3C2D6
FFF3C2D3  39001f                            bsr.w   sub_FFF3E1D3
FFF3C2D6  a881                   loc_FFF3C2D6 mov.l   0Ch+var_4[sp], r1
FFF3C2D8  c5100a07                          mov.b   0Ah[r1], 0Ch+var_5[sp]
FFF3C2DC  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C2DE  6841                              shlr    #4, r1
FFF3C2E0  6191                              cmp     #9, r1; switch 10 cases
FFF3C2E2  2475                              bgtu.b  def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C2E4  fbe21d80f4ff                      mov.l   #jpt_FFF3C2ED, r14
FFF3C2EA  fe41ee                            mov.b   [r1, r14], r14
FFF3C2ED  7f4e                              bra.l   r14; switch jump
FFF3C2EF  b189                   loc_FFF3C2EF movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 0
FFF3C2F1  64f1                              and     #0Fh, r1
FFF3C2F3  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C2F5  2e62                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C2F7  b189                   loc_FFF3C2F7 movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 1
FFF3C2F9  64f1                              and     #0Fh, r1
FFF3C2FB  62a1                              add     #0Ah, r1
FFF3C2FD  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C2FF  2e58                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C301  b189                   loc_FFF3C301 movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 2
FFF3C303  64f1                              and     #0Fh, r1
FFF3C305  711114                            add     #14h, r1, r1
FFF3C308  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C30A  2e4d                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C30C  b189                   loc_FFF3C30C movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 3
FFF3C30E  64f1                              and     #0Fh, r1
FFF3C310  71111e                            add     #1Eh, r1, r1
FFF3C313  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C315  2e42                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C317  b189                   loc_FFF3C317 movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 4
FFF3C319  64f1                              and     #0Fh, r1
FFF3C31B  711128                            add     #28h, r1, r1 ; '('
FFF3C31E  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C320  2e37                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C322  b189                   loc_FFF3C322 movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 5
FFF3C324  64f1                              and     #0Fh, r1
FFF3C326  711132                            add     #32h, r1, r1 ; '2'
FFF3C329  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C32B  2e2c                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C32D  b189                   loc_FFF3C32D movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 6
FFF3C32F  64f1                              and     #0Fh, r1
FFF3C331  71113c                            add     #3Ch, r1, r1 ; '<'
FFF3C334  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C336  2e21                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C338  b189                   loc_FFF3C338 movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 7
FFF3C33A  64f1                              and     #0Fh, r1
FFF3C33C  711146                            add     #46h, r1, r1 ; 'F'
FFF3C33F  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C341  2e16                              bra.b   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C343  b189                   loc_FFF3C343 movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 8
FFF3C345  753150                            or      #50h, r1 ; 'P'
FFF3C348  75215f                            and     #5Fh, r1 ; '_'
FFF3C34B  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C34D  0a                                bra.s   def_FFF3C2ED; jumptable FFF3C2ED default case
FFF3C34E  b189                   loc_FFF3C34E movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED case 9
FFF3C350  64f1                              and     #0Fh, r1
FFF3C352  71115a                            add     #5Ah, r1, r1 ; 'Z'
FFF3C355  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C357  b189                   def_FFF3C2ED movu.b  0Ch+var_5[sp], r1; jumptable FFF3C2ED default case
FFF3C359  711164                            add     #64h, r1, r1 ; 'd'
FFF3C35C  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C362  ece2                              mov.l   [r14], r2
FFF3C364  a129                              mov.l   r1, 14h[r2]
FFF3C366  a881                              mov.l   0Ch+var_4[sp], r1
FFF3C368  c5100b07                          mov.b   0Bh[r1], 0Ch+var_5[sp]
FFF3C36C  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C36E  6841                              shlr    #4, r1
FFF3C370  6111                              cmp     #1, r1
FFF3C372  200d                              beq.b   loc_FFF3C37F
FFF3C374  6101                              cmp     #0, r1
FFF3C376  2111                              bne.b   loc_FFF3C387
FFF3C378  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C37A  64f1                              and     #0Fh, r1
FFF3C37C  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C37E  09                                bra.s   loc_FFF3C387
FFF3C37F  b189                   loc_FFF3C37F movu.b  0Ch+var_5[sp], r1
FFF3C381  64f1                              and     #0Fh, r1
FFF3C383  62a1                              add     #0Ah, r1
FFF3C385  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C387  b189                   loc_FFF3C387 movu.b  0Ch+var_5[sp], r1
FFF3C389  6011                              sub     #1, r1
FFF3C38B  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C391  ece2                              mov.l   [r14], r2
FFF3C393  a121                              mov.l   r1, 10h[r2]
FFF3C395  a881                              mov.l   0Ch+var_4[sp], r1
FFF3C397  c5100c07                          mov.b   0Ch[r1], 0Ch+var_5[sp]
FFF3C39B  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C39D  6841                              shlr    #4, r1
FFF3C39F  6131                              cmp     #3, r1
FFF3C3A1  202a                              beq.b   loc_FFF3C3CB
FFF3C3A3  6111                              cmp     #1, r1
FFF3C3A5  2012                              beq.b   loc_FFF3C3B7
FFF3C3A7  6121                              cmp     #2, r1
FFF3C3A9  2018                              beq.b   loc_FFF3C3C1
FFF3C3AB  6101                              cmp     #0, r1
FFF3C3AD  2127                              bne.b   loc_FFF3C3D4
FFF3C3AF  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C3B1  64f1                              and     #0Fh, r1
FFF3C3B3  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C3B5  2e1f                              bra.b   loc_FFF3C3D4
FFF3C3B7  b189                   loc_FFF3C3B7 movu.b  0Ch+var_5[sp], r1
FFF3C3B9  64f1                              and     #0Fh, r1
FFF3C3BB  62a1                              add     #0Ah, r1
FFF3C3BD  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C3BF  2e15                              bra.b   loc_FFF3C3D4
FFF3C3C1  b189                   loc_FFF3C3C1 movu.b  0Ch+var_5[sp], r1
FFF3C3C3  64f1                              and     #0Fh, r1
FFF3C3C5  711114                            add     #14h, r1, r1
FFF3C3C8  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C3CA  0a                                bra.s   loc_FFF3C3D4
FFF3C3CB  b189                   loc_FFF3C3CB movu.b  0Ch+var_5[sp], r1
FFF3C3CD  64f1                              and     #0Fh, r1
FFF3C3CF  71111e                            add     #1Eh, r1, r1
FFF3C3D2  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C3D4  fbe2145c0600           loc_FFF3C3D4 mov.l   #65C14h, r14
FFF3C3DA  ece1                              mov.l   [r14], r1
FFF3C3DC  b18a                              movu.b  0Ch+var_5[sp], r2
FFF3C3DE  a09a                              mov.l   r2, 0Ch[r1]
FFF3C3E0  a881                              mov.l   0Ch+var_4[sp], r1
FFF3C3E2  c5100e07                          mov.b   0Eh[r1], 0Ch+var_5[sp]
FFF3C3E6  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C3E8  6841                              shlr    #4, r1
FFF3C3EA  6121                              cmp     #2, r1
FFF3C3EC  201b                              beq.b   loc_FFF3C407
FFF3C3EE  6111                              cmp     #1, r1
FFF3C3F0  200e                              beq.b   loc_FFF3C3FE
FFF3C3F2  6101                              cmp     #0, r1
FFF3C3F4  211c                              bne.b   loc_FFF3C410
FFF3C3F6  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C3F8  64f1                              and     #0Fh, r1
FFF3C3FA  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C3FC  2e14                              bra.b   loc_FFF3C410
FFF3C3FE  b189                   loc_FFF3C3FE movu.b  0Ch+var_5[sp], r1
FFF3C400  64f1                              and     #0Fh, r1
FFF3C402  62a1                              add     #0Ah, r1
FFF3C404  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C406  0a                                bra.s   loc_FFF3C410
FFF3C407  b189                   loc_FFF3C407 movu.b  0Ch+var_5[sp], r1
FFF3C409  64f1                              and     #0Fh, r1
FFF3C40B  711114                            add     #14h, r1, r1
FFF3C40E  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C410  fbe2145c0600           loc_FFF3C410 mov.l   #65C14h, r14
FFF3C416  ece1                              mov.l   [r14], r1
FFF3C418  b18a                              movu.b  0Ch+var_5[sp], r2
FFF3C41A  a092                              mov.l   r2, 8[r1]
FFF3C41C  a881                              mov.l   0Ch+var_4[sp], r1
FFF3C41E  c5100f07                          mov.b   0Fh[r1], 0Ch+var_5[sp]
FFF3C422  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C424  6841                              shlr    #4, r1
FFF3C426  6151                              cmp     #5, r1
FFF3C428  2048                              beq.b   loc_FFF3C470
FFF3C42A  6111                              cmp     #1, r1
FFF3C42C  201a                              beq.b   loc_FFF3C446
FFF3C42E  6121                              cmp     #2, r1
FFF3C430  2020                              beq.b   loc_FFF3C450
FFF3C432  6131                              cmp     #3, r1
FFF3C434  2027                              beq.b   loc_FFF3C45B
FFF3C436  6141                              cmp     #4, r1
FFF3C438  202e                              beq.b   loc_FFF3C466
FFF3C43A  6101                              cmp     #0, r1
FFF3C43C  213d                              bne.b   loc_FFF3C479
FFF3C43E  b189                              movu.b  0Ch+var_5[sp], r1
FFF3C440  64f1                              and     #0Fh, r1
FFF3C442  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C444  2e35                              bra.b   loc_FFF3C479
FFF3C446  b189                   loc_FFF3C446 movu.b  0Ch+var_5[sp], r1
FFF3C448  64f1                              and     #0Fh, r1
FFF3C44A  62a1                              add     #0Ah, r1
FFF3C44C  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C44E  2e2b                              bra.b   loc_FFF3C479
FFF3C450  b189                   loc_FFF3C450 movu.b  0Ch+var_5[sp], r1
FFF3C452  64f1                              and     #0Fh, r1
FFF3C454  711114                            add     #14h, r1, r1
FFF3C457  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C459  2e20                              bra.b   loc_FFF3C479
FFF3C45B  b189                   loc_FFF3C45B movu.b  0Ch+var_5[sp], r1
FFF3C45D  64f1                              and     #0Fh, r1
FFF3C45F  71111e                            add     #1Eh, r1, r1
FFF3C462  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C464  2e15                              bra.b   loc_FFF3C479
FFF3C466  b189                   loc_FFF3C466 movu.b  0Ch+var_5[sp], r1
FFF3C468  64f1                              and     #0Fh, r1
FFF3C46A  711128                            add     #28h, r1, r1 ; '('
FFF3C46D  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C46F  0a                                bra.s   loc_FFF3C479
FFF3C470  b189                   loc_FFF3C470 movu.b  0Ch+var_5[sp], r1
FFF3C472  64f1                              and     #0Fh, r1
FFF3C474  711132                            add     #32h, r1, r1 ; '2'
FFF3C477  8189                              mov.b   r1, 0Ch+var_5[sp]
FFF3C479  fbe2145c0600           loc_FFF3C479 mov.l   #65C14h, r14
FFF3C47F  ece1                              mov.l   [r14], r1
FFF3C481  b18a                              movu.b  0Ch+var_5[sp], r2
FFF3C483  a01a                              mov.l   r2, 4[r1]
FFF3C485  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C48B  ecee                              mov.l   [r14], r14
FFF3C48D  f8e600                            mov.l   #0, [r14]
FFF3C490  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C496  ece1                              mov.l   [r14], r1
FFF3C498  3e1600                            mov.l   #0, 18h[r1]
FFF3C49B  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C4A1  ece1                              mov.l   [r14], r1
FFF3C4A3  3e1700                            mov.l   #0, 1Ch[r1]
FFF3C4A6  fbe2145c0600                      mov.l   #65C14h, r14
FFF3C4AC  ece1                              mov.l   [r14], r1
FFF3C4AE  3e1800                            mov.l   #0, 20h[r1]
FFF3C4B1  fbe2b3220100                      mov.l   #122B3h, r14
FFF3C4B7  f8e401                            mov.b   #1, [r14]
FFF3C4BA  6703                              rtsd    #3
FFF3C4BC  6040                   sub_FFF3C4BC sub     #4, sp   ; <<<< FUNC sub_FFF3C4BC
FFF3C4BE  3d0100                            mov.w   #0, 4+var_2[sp]
FFF3C4C1  3d0100                            mov.w   #0, 4+var_2[sp]
FFF3C4C4  388802                            bra.w   loc_FFF3C74C
FFF3C4C7  b809                   loc_FFF3C4C7 movu.w  4+var_2[sp], r1
FFF3C4C9  751124                            mul     #24h, r1 ; '$'
FFF3C4CC  fb22d0830600                      mov.l   #683D0h, r2
FFF3C4D2  4b12                              add     r1, r2
FFF3C4D4  b829                              movu.w  2[r2], r1
FFF3C4D6  711efb                            add     #-5, r1, r14
FFF3C4D9  612e                              cmp     #2, r14
FFF3C4DB  2205                              bgeu.b  loc_FFF3C4E0
FFF3C4DD  381802                            bra.w   loc_FFF3C6F5
FFF3C4E0  6111                   loc_FFF3C4E0 cmp     #1, r1
FFF3C4E2  3ad201                            beq.w   loc_FFF3C6B4
FFF3C4E5  6141                              cmp     #4, r1
FFF3C4E7  3a2d02                            beq.w   loc_FFF3C714
FFF3C4EA  6101                              cmp     #0, r1
FFF3C4EC  3b5a02                            bne.w   loc_FFF3C746
FFF3C4EF  b809                              movu.w  4+var_2[sp], r1
FFF3C4F1  751124                            mul     #24h, r1 ; '$'
FFF3C4F4  fbe2d0830600                      mov.l   #683D0h, r14
FFF3C4FA  4b1e                              add     r1, r14
FFF3C4FC  5cee                              movu.w  [r14], r14
FFF3C4FE  755e78                            cmp     #78h, r14 ; 'x'
FFF3C501  3a8d01                            beq.w   loc_FFF3C68E
FFF3C504  71eff3                            add     #-0Dh, r14, r15
FFF3C507  614f                              cmp     #4, r15
FFF3C509  2345                              bltu.b  loc_FFF3C54E
FFF3C50B  755e12                            cmp     #12h, r14
FFF3C50E  3a8601                            beq.w   loc_FFF3C694
FFF3C511  755e14                            cmp     #14h, r14
FFF3C514  205a                              beq.b   loc_FFF3C56E
FFF3C516  755e1e                            cmp     #1Eh, r14
FFF3C519  2075                              beq.b   loc_FFF3C58E
FFF3C51B  755e28                            cmp     #28h, r14 ; '('
FFF3C51E  3a9000                            beq.w   loc_FFF3C5AE
FFF3C521  755e32                            cmp     #32h, r14 ; '2'
FFF3C524  3aaa00                            beq.w   loc_FFF3C5CE
FFF3C527  755e3c                            cmp     #3Ch, r14 ; '<'
FFF3C52A  3ac400                            beq.w   loc_FFF3C5EE
FFF3C52D  755e46                            cmp     #46h, r14 ; 'F'
FFF3C530  3ade00                            beq.w   loc_FFF3C60E
FFF3C533  755e50                            cmp     #50h, r14 ; 'P'
FFF3C536  3af800                            beq.w   loc_FFF3C62E
FFF3C539  755e64                            cmp     #64h, r14 ; 'd'
FFF3C53C  3a3201                            beq.w   loc_FFF3C66E
FFF3C53F  755e6e                            cmp     #6Eh, r14 ; 'n'
FFF3C542  3a0c01                            beq.w   loc_FFF3C64E
FFF3C545  60ae                              sub     #0Ah, r14
FFF3C547  611e                              cmp     #1, r14
FFF3C549  2505                              bleu.b  loc_FFF3C54E
FFF3C54B  38fb01                            bra.w   loc_FFF3C746
FFF3C54E  b809                   loc_FFF3C54E movu.w  4+var_2[sp], r1
FFF3C550  7100dc                            add     #-24h, sp, sp
FFF3C553  751124                            mul     #24h, r1 ; '$'
FFF3C556  fb22d0830600                      mov.l   #683D0h, r2
FFF3C55C  4b12                              add     r1, r2
FFF3C55E  754324                            mov.l   #24h, r3 ; '$'
FFF3C561  ef01                              mov.l   sp, r1
FFF3C563  7f8f                              smovf
FFF3C565  39ad08                            bsr.w   sub_FFF3CE12
FFF3C568  710024                            add     #24h, sp, sp ; '$'
FFF3C56B  38db01                            bra.w   loc_FFF3C746
FFF3C56E  b809                   loc_FFF3C56E movu.w  4+var_2[sp], r1
FFF3C570  7100dc                            add     #-24h, sp, sp
FFF3C573  751124                            mul     #24h, r1 ; '$'
FFF3C576  fb22d0830600                      mov.l   #683D0h, r2
FFF3C57C  4b12                              add     r1, r2
FFF3C57E  754324                            mov.l   #24h, r3 ; '$'
FFF3C581  ef01                              mov.l   sp, r1
FFF3C583  7f8f                              smovf
FFF3C585  39530a                            bsr.w   sub_FFF3CFD8
FFF3C588  710024                            add     #24h, sp, sp ; '$'
FFF3C58B  38bb01                            bra.w   loc_FFF3C746
FFF3C58E  b809                   loc_FFF3C58E movu.w  4+var_2[sp], r1
FFF3C590  7100dc                            add     #-24h, sp, sp
FFF3C593  751124                            mul     #24h, r1 ; '$'
FFF3C596  fb22d0830600                      mov.l   #683D0h, r2
FFF3C59C  4b12                              add     r1, r2
FFF3C59E  754324                            mov.l   #24h, r3 ; '$'
FFF3C5A1  ef01                              mov.l   sp, r1
FFF3C5A3  7f8f                              smovf
FFF3C5A5  39340b                            bsr.w   sub_FFF3D0D9
FFF3C5A8  710024                            add     #24h, sp, sp ; '$'
FFF3C5AB  389b01                            bra.w   loc_FFF3C746
FFF3C5AE  b809                   loc_FFF3C5AE movu.w  4+var_2[sp], r1
FFF3C5B0  7100dc                            add     #-24h, sp, sp
FFF3C5B3  751124                            mul     #24h, r1 ; '$'
FFF3C5B6  fb22d0830600                      mov.l   #683D0h, r2
FFF3C5BC  4b12                              add     r1, r2
FFF3C5BE  754324                            mov.l   #24h, r3 ; '$'
FFF3C5C1  ef01                              mov.l   sp, r1
FFF3C5C3  7f8f                              smovf
FFF3C5C5  39440c                            bsr.w   sub_FFF3D209
FFF3C5C8  710024                            add     #24h, sp, sp ; '$'
FFF3C5CB  387b01                            bra.w   loc_FFF3C746
FFF3C5CE  b809                   loc_FFF3C5CE movu.w  4+var_2[sp], r1
FFF3C5D0  7100dc                            add     #-24h, sp, sp
FFF3C5D3  751124                            mul     #24h, r1 ; '$'
FFF3C5D6  fb22d0830600                      mov.l   #683D0h, r2
FFF3C5DC  4b12                              add     r1, r2
FFF3C5DE  754324                            mov.l   #24h, r3 ; '$'
FFF3C5E1  ef01                              mov.l   sp, r1
FFF3C5E3  7f8f                              smovf
FFF3C5E5  39180d                            bsr.w   sub_FFF3D2FD
FFF3C5E8  710024                            add     #24h, sp, sp ; '$'
FFF3C5EB  385b01                            bra.w   loc_FFF3C746
FFF3C5EE  b809                   loc_FFF3C5EE movu.w  4+var_2[sp], r1
FFF3C5F0  7100dc                            add     #-24h, sp, sp
FFF3C5F3  751124                            mul     #24h, r1 ; '$'
FFF3C5F6  fb22d0830600                      mov.l   #683D0h, r2
FFF3C5FC  4b12                              add     r1, r2
FFF3C5FE  754324                            mov.l   #24h, r3 ; '$'
FFF3C601  ef01                              mov.l   sp, r1
FFF3C603  7f8f                              smovf
FFF3C605  39c20d                            bsr.w   sub_FFF3D3C7
FFF3C608  710024                            add     #24h, sp, sp ; '$'
FFF3C60B  383b01                            bra.w   loc_FFF3C746
FFF3C60E  b809                   loc_FFF3C60E movu.w  4+var_2[sp], r1
FFF3C610  7100dc                            add     #-24h, sp, sp
FFF3C613  751124                            mul     #24h, r1 ; '$'
FFF3C616  fb22d0830600                      mov.l   #683D0h, r2
FFF3C61C  4b12                              add     r1, r2
FFF3C61E  754324                            mov.l   #24h, r3 ; '$'
FFF3C621  ef01                              mov.l   sp, r1
FFF3C623  7f8f                              smovf
FFF3C625  396a0e                            bsr.w   sub_FFF3D48F
FFF3C628  710024                            add     #24h, sp, sp ; '$'
FFF3C62B  381b01                            bra.w   loc_FFF3C746
FFF3C62E  b809                   loc_FFF3C62E movu.w  4+var_2[sp], r1
FFF3C630  7100dc                            add     #-24h, sp, sp
FFF3C633  751124                            mul     #24h, r1 ; '$'
FFF3C636  fb22d0830600                      mov.l   #683D0h, r2
FFF3C63C  4b12                              add     r1, r2
FFF3C63E  754324                            mov.l   #24h, r3 ; '$'
FFF3C641  ef01                              mov.l   sp, r1
FFF3C643  7f8f                              smovf
FFF3C645  39110f                            bsr.w   sub_FFF3D556
FFF3C648  710024                            add     #24h, sp, sp ; '$'
FFF3C64B  38fb00                            bra.w   loc_FFF3C746
FFF3C64E  b809                   loc_FFF3C64E movu.w  4+var_2[sp], r1
FFF3C650  7100dc                            add     #-24h, sp, sp
FFF3C653  751124                            mul     #24h, r1 ; '$'
FFF3C656  fb22d0830600                      mov.l   #683D0h, r2
FFF3C65C  4b12                              add     r1, r2
FFF3C65E  754324                            mov.l   #24h, r3 ; '$'
FFF3C661  ef01                              mov.l   sp, r1
FFF3C663  7f8f                              smovf
FFF3C665  39c41b                            bsr.w   sub_FFF3E229
FFF3C668  710024                            add     #24h, sp, sp ; '$'
FFF3C66B  38db00                            bra.w   loc_FFF3C746
FFF3C66E  b809                   loc_FFF3C66E movu.w  4+var_2[sp], r1
FFF3C670  7100dc                            add     #-24h, sp, sp
FFF3C673  751124                            mul     #24h, r1 ; '$'
FFF3C676  fb22d0830600                      mov.l   #683D0h, r2
FFF3C67C  4b12                              add     r1, r2
FFF3C67E  754324                            mov.l   #24h, r3 ; '$'
FFF3C681  ef01                              mov.l   sp, r1
FFF3C683  7f8f                              smovf
FFF3C685  39131d                            bsr.w   sub_FFF3E398
FFF3C688  710024                            add     #24h, sp, sp ; '$'
FFF3C68B  38bb00                            bra.w   loc_FFF3C746
FFF3C68E  397ef4                 loc_FFF3C68E bsr.w   sub_FFF3BB0C
FFF3C691  38b500                            bra.w   loc_FFF3C746
FFF3C694  b809                   loc_FFF3C694 movu.w  4+var_2[sp], r1
FFF3C696  7100dc                            add     #-24h, sp, sp
FFF3C699  751124                            mul     #24h, r1 ; '$'
FFF3C69C  fb22d0830600                      mov.l   #683D0h, r2
FFF3C6A2  4b12                              add     r1, r2
FFF3C6A4  754324                            mov.l   #24h, r3 ; '$'
FFF3C6A7  ef01                              mov.l   sp, r1
FFF3C6A9  7f8f                              smovf
FFF3C6AB  392504                            bsr.w   sub_FFF3CAD0
FFF3C6AE  710024                            add     #24h, sp, sp ; '$'
FFF3C6B1  389500                            bra.w   loc_FFF3C746
FFF3C6B4  b809                   loc_FFF3C6B4 movu.w  4+var_2[sp], r1
FFF3C6B6  751124                            mul     #24h, r1 ; '$'
FFF3C6B9  fbe2d0830600                      mov.l   #683D0h, r14
FFF3C6BF  4b1e                              add     r1, r14
FFF3C6C1  5cee                              movu.w  [r14], r14
FFF3C6C3  71efff                            add     #-1, r14, r15
FFF3C6C6  613f                              cmp     #3, r15
FFF3C6C8  2308                              bltu.b  loc_FFF3C6D0
FFF3C6CA  605e                              sub     #5, r14
FFF3C6CC  614e                              cmp     #4, r14
FFF3C6CE  2478                              bgtu.b  loc_FFF3C746
FFF3C6D0  b80c                   loc_FFF3C6D0 movu.w  4+var_2[sp], r4
FFF3C6D2  7100dc                            add     #-24h, sp, sp
FFF3C6D5  ef4e                              mov.l   r4, r14
FFF3C6D7  751e24                            mul     #24h, r14 ; '$'
FFF3C6DA  fb22d0830600                      mov.l   #683D0h, r2
FFF3C6E0  4be2                              add     r14, r2
FFF3C6E2  754324                            mov.l   #24h, r3 ; '$'
FFF3C6E5  ef01                              mov.l   sp, r1
FFF3C6E7  7f8f                              smovf
FFF3C6E9  6214                              add     #1, r4
FFF3C6EB  5b41                              movu.b  r4, r1
FFF3C6ED  397800                            bsr.w   sub_FFF3C765
FFF3C6F0  710024                            add     #24h, sp, sp ; '$'
FFF3C6F3  2e53                              bra.b   loc_FFF3C746
FFF3C6F5  b809                   loc_FFF3C6F5 movu.w  4+var_2[sp], r1
FFF3C6F7  7100dc                            add     #-24h, sp, sp
FFF3C6FA  751124                            mul     #24h, r1 ; '$'
FFF3C6FD  fb22d0830600                      mov.l   #683D0h, r2
FFF3C703  4b12                              add     r1, r2
FFF3C705  754324                            mov.l   #24h, r3 ; '$'
FFF3C708  ef01                              mov.l   sp, r1
FFF3C70A  7f8f                              smovf
FFF3C70C  398024                            bsr.w   sub_FFF3EB8C
FFF3C70F  710024                            add     #24h, sp, sp ; '$'
FFF3C712  2e34                              bra.b   loc_FFF3C746
FFF3C714  b809                   loc_FFF3C714 movu.w  4+var_2[sp], r1
FFF3C716  751124                            mul     #24h, r1 ; '$'
FFF3C719  fbe2d0830600                      mov.l   #683D0h, r14
FFF3C71F  4b1e                              add     r1, r14
FFF3C721  5cee                              movu.w  [r14], r14
FFF3C723  601e                              sub     #1, r14
FFF3C725  612e                              cmp     #2, r14
FFF3C727  241f                              bgtu.b  loc_FFF3C746
FFF3C729  b809                              movu.w  4+var_2[sp], r1
FFF3C72B  7100dc                            add     #-24h, sp, sp
FFF3C72E  751124                            mul     #24h, r1 ; '$'
FFF3C731  fb22d0830600                      mov.l   #683D0h, r2
FFF3C737  4b12                              add     r1, r2
FFF3C739  754324                            mov.l   #24h, r3 ; '$'
FFF3C73C  ef01                              mov.l   sp, r1
FFF3C73E  7f8f                              smovf
FFF3C740  39d101                            bsr.w   sub_FFF3C911
FFF3C743  710024                            add     #24h, sp, sp ; '$'
FFF3C746  9809                   loc_FFF3C746 mov.w   4+var_2[sp], r1
FFF3C748  6211                              add     #1, r1
FFF3C74A  9009                              mov.w   r1, 4+var_2[sp]
FFF3C74C  fbe234250100           loc_FFF3C74C mov.l   #12534h, r14
FFF3C752  b809                              movu.w  4+var_2[sp], r1
FFF3C754  06c5e101                          cmp     2[r14].uw, r1
FFF3C758  2805                              bge.b   loc_FFF3C75D
FFF3C75A  386dfd                            bra.w   loc_FFF3C4C7
FFF3C75D  39230f                 loc_FFF3C75D bsr.w   sub_FFF3D680
FFF3C760  390e14                            bsr.w   sub_FFF3DB6E
FFF3C763  6701                              rtsd    #1
FFF3C765  7ea6                   sub_FFF3C765 push.l  r6   ; <<<< FUNC sub_FFF3C765
FFF3C767  7100e0                            add     #-20h, sp, sp
FFF3C76A  8789                              mov.b   r1, 20h+var_1[sp]
FFF3C76C  3d0d00                            mov.w   #0, 20h+var_6[sp]
FFF3C76F  710628                            add     #20h+arg_0, sp, r6
FFF3C772  fb1258250100                      mov.l   #12558h, r1
FFF3C778  6602                              mov.l   #0, r2
FFF3C77A  9212                              mov.w   r2, 10h[r1]
FFF3C77C  a09a                              mov.l   r2, 0Ch[r1]
FFF3C77E  a092                              mov.l   r2, 8[r1]
FFF3C780  a01a                              mov.l   r2, 4[r1]
FFF3C782  e312                              mov.l   r2, [r1]
FFF3C784  f809ffff                          mov.w   #-1, 20h+var_20[sp]
FFF3C788  fb1262080100                      mov.l   #10862h, r1
FFF3C78E  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3C794  e0e1                              mov.l   [r14], [r1]
FFF3C796  a8e4                              mov.l   8[r6], r4
FFF3C798  fb36ff                            mov.l   #-1, r3
FFF3C79B  6602                              mov.l   #0, r2
FFF3C79D  7f80                              suntil.b
FFF3C79F  6011                              sub     #1, r1
FFF3C7A1  ef42                              mov.l   r4, r2
FFF3C7A3  7f87                              smovu
FFF3C7A5  fbe6ff                            mov.l   #-1, r14
FFF3C7A8  660f                              mov.l   #0, r15
FFF3C7AA  fb5262080100                      mov.l   #10862h, r5
FFF3C7B0  ef51                              mov.l   r5, r1
FFF3C7B2  eff2                              mov.l   r15, r2
FFF3C7B4  efe3                              mov.l   r14, r3
FFF3C7B6  7f80                              suntil.b
FFF3C7B8  6011                              sub     #1, r1
FFF3C7BA  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3C7C0  7f87                              smovu
FFF3C7C2  a8ec                              mov.l   0Ch[r6], r4
FFF3C7C4  ef51                              mov.l   r5, r1
FFF3C7C6  eff2                              mov.l   r15, r2
FFF3C7C8  efe3                              mov.l   r14, r3
FFF3C7CA  7f80                              suntil.b
FFF3C7CC  6011                              sub     #1, r1
FFF3C7CE  ef42                              mov.l   r4, r2
FFF3C7D0  7f87                              smovu
FFF3C7D2  fb1262080100                      mov.l   #10862h, r1
FFF3C7D8  a009                              mov.l   r1, 20h+var_1C[sp]
FFF3C7DA  e5600502                          mov.l   14h[r6], 20h+var_18[sp]
FFF3C7DE  e5600803                          mov.l   20h[r6], 20h+var_14[sp]
FFF3C7E2  e5600404                          mov.l   10h[r6], 20h+var_10[sp]
FFF3C7E6  754312                            mov.l   #12h, r3
FFF3C7E9  fb2234250100                      mov.l   #12534h, r2
FFF3C7EF  fb1258250100                      mov.l   #12558h, r1
FFF3C7F5  7f8f                              smovf
FFF3C7F7  5c6e                              movu.w  [r6], r14
FFF3C7F9  71effb                            add     #-5, r14, r15
FFF3C7FC  615f                              cmp     #5, r15
FFF3C7FE  2335                              bltu.b  loc_FFF3C833
FFF3C800  612e                              cmp     #2, r14
FFF3C802  2017                              beq.b   loc_FFF3C819
FFF3C804  613e                              cmp     #3, r14
FFF3C806  2020                              beq.b   loc_FFF3C826
FFF3C808  611e                              cmp     #1, r14
FFF3C80A  2135                              bne.b   loc_FFF3C83F
FFF3C80C  3d0a00                            mov.w   #0, 20h+var_C[sp]
FFF3C80F  ef01                              mov.l   sp, r1
FFF3C811  051464fd                          bsr.a   sub_FFF12C25
FFF3C815  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C817  2e2d                              bra.b   loc_FFF3C844
FFF3C819  3d0a01                 loc_FFF3C819 mov.w   #1, 20h+var_C[sp]
FFF3C81C  ef01                              mov.l   sp, r1
FFF3C81E  050764fd                          bsr.a   sub_FFF12C25
FFF3C822  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C824  2e20                              bra.b   loc_FFF3C844
FFF3C826  3d0a02                 loc_FFF3C826 mov.w   #2, 20h+var_C[sp]
FFF3C829  ef01                              mov.l   sp, r1
FFF3C82B  05fa63fd                          bsr.a   sub_FFF12C25
FFF3C82F  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C831  2e13                              bra.b   loc_FFF3C844
FFF3C833  d4600a                 loc_FFF3C833 mov.w   [r6], 20h+var_C[sp]
FFF3C836  ef01                              mov.l   sp, r1
FFF3C838  055d65fd                          bsr.a   sub_FFF12D95
FFF3C83C  9309                              mov.w   r1, 20h+var_6[sp]
FFF3C83E  0e                                bra.s   loc_FFF3C844
FFF3C83F  f9090dffff             loc_FFF3C83F mov.w   #-1, 20h+var_6[sp]
FFF3C844  bb09                   loc_FFF3C844 movu.w  20h+var_6[sp], r1
FFF3C846  6101                              cmp     #0, r1
FFF3C848  205b                              beq.b   loc_FFF3C8A3
FFF3C84A  fbe258250100                      mov.l   #12558h, r14
FFF3C850  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3C855  fb1258250100                      mov.l   #12558h, r1
FFF3C85B  3d1090                            mov.w   #-70h, [r1]
FFF3C85E  fb1258250100                      mov.l   #12558h, r1
FFF3C864  3d1101                            mov.w   #1, 2[r1]
FFF3C867  fbe258250100                      mov.l   #12558h, r14
FFF3C86D  fbf26c250100                      mov.l   #1256Ch, r15
FFF3C873  d4fe02                            mov.w   [r15], 4[r14]
FFF3C876  3d6c00                            mov.w   #0, 18h[r6]
FFF3C879  7100c8                            add     #-38h, sp, sp
FFF3C87C  754312                            mov.l   #12h, r3
FFF3C87F  fb2258250100                      mov.l   #12558h, r2
FFF3C885  ef01                              mov.l   sp, r1
FFF3C887  7f8f                              smovf
FFF3C889  ef01                              mov.l   sp, r1
FFF3C88B  711114                            add     #14h, r1, r1
FFF3C88E  754324                            mov.l   #24h, r3 ; '$'
FFF3C891  ef62                              mov.l   r6, r2
FFF3C893  7f8f                              smovf
FFF3C895  6602                              mov.l   #0, r2
FFF3C897  7541fe                            mov.l   #-2, r1
FFF3C89A  054210fa                          bsr.a   sub_FFEDD8DC
FFF3C89E  710038                            add     #38h, sp, sp ; '8'
FFF3C8A1  2e65                              bra.b   loc_FFF3C906
FFF3C8A3  fbe234250100           loc_FFF3C8A3 mov.l   #12534h, r14
FFF3C8A9  b789                              movu.b  20h+var_1[sp], r1
FFF3C8AB  06c5e101                          cmp     2[r14].uw, r1
FFF3C8AF  2157                              bne.b   loc_FFF3C906
FFF3C8B1  fb1258250100                      mov.l   #12558h, r1
FFF3C8B7  3d1300                            mov.w   #0, 6[r1]
FFF3C8BA  fb1258250100                      mov.l   #12558h, r1
FFF3C8C0  3d1090                            mov.w   #-70h, [r1]
FFF3C8C3  fb1258250100                      mov.l   #12558h, r1
FFF3C8C9  3d1101                            mov.w   #1, 2[r1]
FFF3C8CC  fbe258250100                      mov.l   #12558h, r14
FFF3C8D2  fbf26c250100                      mov.l   #1256Ch, r15
FFF3C8D8  d4fe02                            mov.w   [r15], 4[r14]
FFF3C8DB  3d6c00                            mov.w   #0, 18h[r6]
FFF3C8DE  7100c8                            add     #-38h, sp, sp
FFF3C8E1  754312                            mov.l   #12h, r3
FFF3C8E4  fb2258250100                      mov.l   #12558h, r2
FFF3C8EA  ef01                              mov.l   sp, r1
FFF3C8EC  7f8f                              smovf
FFF3C8EE  ef01                              mov.l   sp, r1
FFF3C8F0  711114                            add     #14h, r1, r1
FFF3C8F3  754324                            mov.l   #24h, r3 ; '$'
FFF3C8F6  ef62                              mov.l   r6, r2
FFF3C8F8  7f8f                              smovf
FFF3C8FA  6602                              mov.l   #0, r2
FFF3C8FC  7541fe                            mov.l   #-2, r1
FFF3C8FF  05dd0ffa                          bsr.a   sub_FFEDD8DC
FFF3C903  710038                            add     #38h, sp, sp ; '8'
FFF3C906  d5000d0e               loc_FFF3C906 mov.w   20h+var_6[sp], 20h+var_4[sp]
FFF3C90A  9b81                              mov.w   20h+var_4[sp], r1
FFF3C90C  5f11                              movu.w  r1, r1
FFF3C90E  3f6609                            rtsd    #24h, r6-r6
FFF3C911  7ea6                   sub_FFF3C911 push.l  r6   ; <<<< FUNC sub_FFF3C911
FFF3C913  7100d4                            add     #-2Ch, sp, sp
FFF3C916  3d8400                            mov.w   #0, 2Ch+var_4[sp]
FFF3C919  710634                            add     #2Ch+arg_0, sp, r6
FFF3C91C  f9042700                          mov.b   #0, 2Ch+var_5[sp]
FFF3C920  fb1258250100                      mov.l   #12558h, r1
FFF3C926  6602                              mov.l   #0, r2
FFF3C928  9212                              mov.w   r2, 10h[r1]
FFF3C92A  a09a                              mov.l   r2, 0Ch[r1]
FFF3C92C  a092                              mov.l   r2, 8[r1]
FFF3C92E  a01a                              mov.l   r2, 4[r1]
FFF3C930  e312                              mov.l   r2, [r1]
FFF3C932  754312                            mov.l   #12h, r3
FFF3C935  fb2234250100                      mov.l   #12534h, r2
FFF3C93B  fb1258250100                      mov.l   #12558h, r1
FFF3C941  7f8f                              smovf
FFF3C943  71011c                            add     #2Ch+var_10, sp, r1
FFF3C946  05f41ffa                          bsr.a   sub_FFEDE93A
FFF3C94A  c70127                            mov.b   r1, 2Ch+var_5[sp]
FFF3C94D  590127                            movu.b  2Ch+var_5[sp], r1
FFF3C950  6111                              cmp     #1, r1
FFF3C952  2061                              beq.b   loc_FFF3C9B3
FFF3C954  fbe258250100                      mov.l   #12558h, r14
FFF3C95A  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3C95F  fb1258250100                      mov.l   #12558h, r1
FFF3C965  3d1090                            mov.w   #-70h, [r1]
FFF3C968  fb1258250100                      mov.l   #12558h, r1
FFF3C96E  3d1101                            mov.w   #1, 2[r1]
FFF3C971  fbe258250100                      mov.l   #12558h, r14
FFF3C977  fbf26c250100                      mov.l   #1256Ch, r15
FFF3C97D  d4fe02                            mov.w   [r15], 4[r14]
FFF3C980  3d6c00                            mov.w   #0, 18h[r6]
FFF3C983  7100c8                            add     #-38h, sp, sp
FFF3C986  754312                            mov.l   #12h, r3
FFF3C989  fb2258250100                      mov.l   #12558h, r2
FFF3C98F  ef01                              mov.l   sp, r1
FFF3C991  7f8f                              smovf
FFF3C993  ef01                              mov.l   sp, r1
FFF3C995  711114                            add     #14h, r1, r1
FFF3C998  754324                            mov.l   #24h, r3 ; '$'
FFF3C99B  ef62                              mov.l   r6, r2
FFF3C99D  7f8f                              smovf
FFF3C99F  6602                              mov.l   #0, r2
FFF3C9A1  7541fe                            mov.l   #-2, r1
FFF3C9A4  05380ffa                          bsr.a   sub_FFEDD8DC
FFF3C9A8  710038                            add     #38h, sp, sp ; '8'
FFF3C9AB  f90901ffff                        mov.w   #-1, 2Ch+var_2A[sp]
FFF3C9B0  381701                            bra.w   loc_FFF3CAC7
FFF3C9B3  fb1258250100           loc_FFF3C9B3 mov.l   #12558h, r1
FFF3C9B9  6602                              mov.l   #0, r2
FFF3C9BB  9212                              mov.w   r2, 10h[r1]
FFF3C9BD  a09a                              mov.l   r2, 0Ch[r1]
FFF3C9BF  a092                              mov.l   r2, 8[r1]
FFF3C9C1  a01a                              mov.l   r2, 4[r1]
FFF3C9C3  e312                              mov.l   r2, [r1]
FFF3C9C5  6601                              mov.l   #0, r1
FFF3C9C7  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF3C9C9  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF3C9CB  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF3C9CD  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF3C9CF  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF3C9D1  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF3C9D3  f90902ffff                        mov.w   #-1, 2Ch+var_28[sp]
FFF3C9D8  fbe262080100                      mov.l   #10862h, r14
FFF3C9DE  fbf2f3aff4ff                      mov.l   #unk_FFF4AFF3, r15
FFF3C9E4  e0fe                              mov.l   [r15], [r14]
FFF3C9E6  a8e4                              mov.l   8[r6], r4
FFF3C9E8  fb36ff                            mov.l   #-1, r3
FFF3C9EB  6602                              mov.l   #0, r2
FFF3C9ED  fb1262080100                      mov.l   #10862h, r1
FFF3C9F3  7f80                              suntil.b
FFF3C9F5  6011                              sub     #1, r1
FFF3C9F7  ef42                              mov.l   r4, r2
FFF3C9F9  7f87                              smovu
FFF3C9FB  fb36ff                            mov.l   #-1, r3
FFF3C9FE  6602                              mov.l   #0, r2
FFF3CA00  fb1262080100                      mov.l   #10862h, r1
FFF3CA06  7f80                              suntil.b
FFF3CA08  6011                              sub     #1, r1
FFF3CA0A  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3CA10  7f87                              smovu
FFF3CA12  a8ec                              mov.l   0Ch[r6], r4
FFF3CA14  fb36ff                            mov.l   #-1, r3
FFF3CA17  6602                              mov.l   #0, r2
FFF3CA19  fb1262080100                      mov.l   #10862h, r1
FFF3CA1F  7f80                              suntil.b
FFF3CA21  6011                              sub     #1, r1
FFF3CA23  ef42                              mov.l   r4, r2
FFF3CA25  7f87                              smovu
FFF3CA27  fb1262080100                      mov.l   #10862h, r1
FFF3CA2D  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF3CA2F  e5600503                          mov.l   14h[r6], 2Ch+var_20[sp]
FFF3CA33  e5000704                          mov.l   2Ch+var_10[sp], 2Ch+var_1C[sp]
FFF3CA37  e5600405                          mov.l   10h[r6], 2Ch+var_18[sp]
FFF3CA3B  5c6e                              movu.w  [r6], r14
FFF3CA3D  613e                              cmp     #3, r14
FFF3CA3F  2011                              beq.b   loc_FFF3CA50
FFF3CA41  612e                              cmp     #2, r14
FFF3CA43  11                                beq.s   loc_FFF3CA4C
FFF3CA44  611e                              cmp     #1, r14
FFF3CA46  210d                              bne.b   loc_FFF3CA53
FFF3CA48  3d0c00                            mov.w   #0, 2Ch+var_14[sp]
FFF3CA4B  08                                bra.s   loc_FFF3CA53
FFF3CA4C  3d0c01                 loc_FFF3CA4C mov.w   #1, 2Ch+var_14[sp]
FFF3CA4F  0c                                bra.s   loc_FFF3CA53
FFF3CA50  3d0c02                 loc_FFF3CA50 mov.w   #2, 2Ch+var_14[sp]
FFF3CA53  710104                 loc_FFF3CA53 add     #2Ch+var_28, sp, r1
FFF3CA56  05cf61fd                          bsr.a   sub_FFF12C25
FFF3CA5A  9501                              mov.w   r1, 2Ch+var_4[sp]
FFF3CA5C  bd01                              movu.w  2Ch+var_4[sp], r1
FFF3CA5E  6101                              cmp     #0, r1
FFF3CA60  200e                              beq.b   loc_FFF3CA6E
FFF3CA62  fbe258250100                      mov.l   #12558h, r14
FFF3CA68  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CA6D  0a                                bra.s   loc_FFF3CA77
FFF3CA6E  fb1258250100           loc_FFF3CA6E mov.l   #12558h, r1
FFF3CA74  3d1300                            mov.w   #0, 6[r1]
FFF3CA77  fb1258250100           loc_FFF3CA77 mov.l   #12558h, r1
FFF3CA7D  3d1090                            mov.w   #-70h, [r1]
FFF3CA80  fb1258250100                      mov.l   #12558h, r1
FFF3CA86  3d1101                            mov.w   #1, 2[r1]
FFF3CA89  fbe258250100                      mov.l   #12558h, r14
FFF3CA8F  fbf26c250100                      mov.l   #1256Ch, r15
FFF3CA95  d4fe02                            mov.w   [r15], 4[r14]
FFF3CA98  3d6c00                            mov.w   #0, 18h[r6]
FFF3CA9B  7100c8                            add     #-38h, sp, sp
FFF3CA9E  754312                            mov.l   #12h, r3
FFF3CAA1  fb2258250100                      mov.l   #12558h, r2
FFF3CAA7  ef01                              mov.l   sp, r1
FFF3CAA9  7f8f                              smovf
FFF3CAAB  ef01                              mov.l   sp, r1
FFF3CAAD  711114                            add     #14h, r1, r1
FFF3CAB0  754324                            mov.l   #24h, r3 ; '$'
FFF3CAB3  ef62                              mov.l   r6, r2
FFF3CAB5  7f8f                              smovf
FFF3CAB7  6602                              mov.l   #0, r2
FFF3CAB9  7541fe                            mov.l   #-2, r1
FFF3CABC  05200efa                          bsr.a   sub_FFEDD8DC
FFF3CAC0  710038                            add     #38h, sp, sp ; '8'
FFF3CAC3  d5001401                          mov.w   2Ch+var_4[sp], 2Ch+var_2A[sp]
FFF3CAC7  d5000115               loc_FFF3CAC7 mov.w   2Ch+var_2A[sp], 2Ch+var_2[sp]
FFF3CACB  bd09                              movu.w  2Ch+var_2[sp], r1
FFF3CACD  3f660c                            rtsd    #30h, r6-r6
FFF3CAD0  7ea6                   sub_FFF3CAD0 push.l  r6   ; <<<< FUNC sub_FFF3CAD0
FFF3CAD2  7200bcfb                          add     #-444h, sp, sp
FFF3CAD6  fa05200200                        mov.w   #0, 444h+var_4[sp]
FFF3CADB  fa051f0200                        mov.w   #0, 444h+var_6[sp]
FFF3CAE0  72064c04                          add     #444h+arg_0, sp, r6
FFF3CAE4  fa051e0200                        mov.w   #0, 444h+var_8[sp]
FFF3CAE9  fa051d0200                        mov.w   #0, 444h+var_A[sp]
FFF3CAEE  fa051c0200                        mov.w   #0, 444h+var_C[sp]
FFF3CAF3  fa060d0100                        mov.l   #0, 444h+var_10[sp]
FFF3CAF8  3d0900                            mov.w   #0, 444h+var_432[sp]
FFF3CAFB  3d0800                            mov.w   #0, 444h+var_434[sp]
FFF3CAFE  fb1258250100                      mov.l   #12558h, r1
FFF3CB04  6602                              mov.l   #0, r2
FFF3CB06  9212                              mov.w   r2, 10h[r1]
FFF3CB08  a09a                              mov.l   r2, 0Ch[r1]
FFF3CB0A  a092                              mov.l   r2, 8[r1]
FFF3CB0C  a01a                              mov.l   r2, 4[r1]
FFF3CB0E  e312                              mov.l   r2, [r1]
FFF3CB10  754312                            mov.l   #12h, r3
FFF3CB13  fb2234250100                      mov.l   #12534h, r2
FFF3CB19  fb1258250100                      mov.l   #12558h, r1
FFF3CB1F  7f8f                              smovf
FFF3CB21  fb1262080100                      mov.l   #10862h, r1
FFF3CB27  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3CB2D  e0e1                              mov.l   [r14], [r1]
FFF3CB2F  a8e4                              mov.l   8[r6], r4
FFF3CB31  fb36ff                            mov.l   #-1, r3
FFF3CB34  6602                              mov.l   #0, r2
FFF3CB36  7f80                              suntil.b
FFF3CB38  6011                              sub     #1, r1
FFF3CB3A  ef42                              mov.l   r4, r2
FFF3CB3C  7f87                              smovu
FFF3CB3E  fbe6ff                            mov.l   #-1, r14
FFF3CB41  660f                              mov.l   #0, r15
FFF3CB43  fb5262080100                      mov.l   #10862h, r5
FFF3CB49  ef51                              mov.l   r5, r1
FFF3CB4B  eff2                              mov.l   r15, r2
FFF3CB4D  efe3                              mov.l   r14, r3
FFF3CB4F  7f80                              suntil.b
FFF3CB51  6011                              sub     #1, r1
FFF3CB53  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3CB59  7f87                              smovu
FFF3CB5B  a8ec                              mov.l   0Ch[r6], r4
FFF3CB5D  ef51                              mov.l   r5, r1
FFF3CB5F  eff2                              mov.l   r15, r2
FFF3CB61  efe3                              mov.l   r14, r3
FFF3CB63  7f80                              suntil.b
FFF3CB65  6011                              sub     #1, r1
FFF3CB67  ef42                              mov.l   r4, r2
FFF3CB69  7f87                              smovu
FFF3CB6B  72023404                          add     #444h+var_10, sp, r2
FFF3CB6F  fb1262080100                      mov.l   #10862h, r1
FFF3CB75  057e65fd                          bsr.a   sub_FFF130F3
FFF3CB79  38d100                            bra.w   loc_FFF3CC4A
FFF3CB7C  5e011e02               loc_FFF3CB7C movu.w  444h+var_8[sp], r1
FFF3CB80  6ca1                              shll    #0Ah, r1
FFF3CB82  ee020d01                          mov.l   444h+var_10[sp], r2
FFF3CB86  4312                              sub     r1, r2
FFF3CB88  db021d02                          mov.w   r2, 444h+var_A[sp]
FFF3CB8C  0f                                bra.s   loc_FFF3CB93
FFF3CB8D  fa091d020004           loc_FFF3CB8D mov.w   #400h, 444h+var_A[sp]
FFF3CB93  5e011f02               loc_FFF3CB93 movu.w  444h+var_6[sp], r1
FFF3CB97  6101                              cmp     #0, r1
FFF3CB99  18                                bne.s   loc_FFF3CBA1
FFF3CB9A  fa051c020d                        mov.w   #0Dh, 444h+var_C[sp]
FFF3CB9F  2e17                              bra.b   loc_FFF3CBB6
FFF3CBA1  5e011d02               loc_FFF3CBA1 movu.w  444h+var_A[sp], r1
FFF3CBA5  7601ff03                          cmp     #3FFh, r1
FFF3CBA9  2a08                              bgt.b   loc_FFF3CBB1
FFF3CBAB  fa051c020f                        mov.w   #0Fh, 444h+var_C[sp]
FFF3CBB0  0e                                bra.s   loc_FFF3CBB6
FFF3CBB1  fa051c020e             loc_FFF3CBB1 mov.w   #0Eh, 444h+var_C[sp]
FFF3CBB6  3d0e00                 loc_FFF3CBB6 mov.w   #0, 444h+var_428[sp]
FFF3CBB9  fb1262080100                      mov.l   #10862h, r1
FFF3CBBF  a201                              mov.l   r1, 444h+var_424[sp]
FFF3CBC1  710134                            add     #444h+var_410, sp, r1
FFF3CBC4  a281                              mov.l   r1, 444h+var_41C[sp]
FFF3CBC6  5e011f02                          movu.w  444h+var_6[sp], r1
FFF3CBCA  a209                              mov.l   r1, 444h+var_420[sp]
FFF3CBCC  5e011d02                          movu.w  444h+var_A[sp], r1
FFF3CBD0  a289                              mov.l   r1, 444h+var_418[sp]
FFF3CBD2  d6001c0218                        mov.w   444h+var_C[sp], 444h+var_414[sp]
FFF3CBD7  71011c                            add     #444h+var_428, sp, r1
FFF3CBDA  05c163fd                          bsr.a   sub_FFF12F9B
FFF3CBDE  db012002                          mov.w   r1, 444h+var_4[sp]
FFF3CBE2  5e012002                          movu.w  444h+var_4[sp], r1
FFF3CBE6  6101                              cmp     #0, r1
FFF3CBE8  3b8c00                            bne.w   loc_FFF3CC74
FFF3CBEB  e5000a06                          mov.l   444h+var_41C[sp], 444h+var_42C[sp]
FFF3CBEF  5e011f02                          movu.w  444h+var_6[sp], r1
FFF3CBF3  701100100e07                      add     #70E1000h, r1, r1
FFF3CBF9  a109                              mov.l   r1, 444h+var_430[sp]
FFF3CBFB  5e011d02                          movu.w  444h+var_A[sp], r1
FFF3CBFF  fd8212                            shlr    #2, r1, r2
FFF3CC02  fd74c103                          tst     #3, r1
FFF3CC06  1c                                bne.s   loc_FFF3CC0A
FFF3CC07  920a                              mov.w   r2, 444h+var_432[sp]
FFF3CC09  0d                                bra.s   loc_FFF3CC0E
FFF3CC0A  6212                   loc_FFF3CC0A add     #1, r2
FFF3CC0C  920a                              mov.w   r2, 444h+var_432[sp]
FFF3CC0E  3d0800                 loc_FFF3CC0E mov.w   #0, 444h+var_434[sp]
FFF3CC11  2e1a                              bra.b   loc_FFF3CC2B
FFF3CC13  a981                   loc_FFF3CC13 mov.l   444h+var_42C[sp], r1
FFF3CC15  a90a                              mov.l   444h+var_430[sp], r2
FFF3CC17  e012                              mov.l   [r1], [r2]
FFF3CC19  a981                              mov.l   444h+var_42C[sp], r1
FFF3CC1B  6241                              add     #4, r1
FFF3CC1D  a181                              mov.l   r1, 444h+var_42C[sp]
FFF3CC1F  a909                              mov.l   444h+var_430[sp], r1
FFF3CC21  6241                              add     #4, r1
FFF3CC23  a109                              mov.l   r1, 444h+var_430[sp]
FFF3CC25  9a01                              mov.w   444h+var_434[sp], r1
FFF3CC27  6211                              add     #1, r1
FFF3CC29  9201                              mov.w   r1, 444h+var_434[sp]
FFF3CC2B  ba01                   loc_FFF3CC2B movu.w  444h+var_434[sp], r1
FFF3CC2D  06c50109                          cmp     444h+var_432[sp].uw, r1
FFF3CC31  29e2                              blt.b   loc_FFF3CC13
FFF3CC33  de011e02                          mov.w   444h+var_8[sp], r1
FFF3CC37  6211                              add     #1, r1
FFF3CC39  db011e02                          mov.w   r1, 444h+var_8[sp]
FFF3CC3D  5e011e02                          movu.w  444h+var_8[sp], r1
FFF3CC41  6ca1                              shll    #0Ah, r1
FFF3CC43  0686010d01                        cmp     444h+var_10[sp].l, r1
FFF3CC48  222c                              bgeu.b  loc_FFF3CC74
FFF3CC4A  fb3a0004               loc_FFF3CC4A mov.l   #400h, r3
FFF3CC4E  6602                              mov.l   #0, r2
FFF3CC50  710134                            add     #444h+var_410, sp, r1
FFF3CC53  7f88                              sstr.b
FFF3CC55  5e011e02                          movu.w  444h+var_8[sp], r1
FFF3CC59  6ca1                              shll    #0Ah, r1
FFF3CC5B  db011f02                          mov.w   r1, 444h+var_6[sp]
FFF3CC5F  5e011e02                          movu.w  444h+var_8[sp], r1
FFF3CC63  6211                              add     #1, r1
FFF3CC65  6ca1                              shll    #0Ah, r1
FFF3CC67  0686010d01                        cmp     444h+var_10[sp].l, r1
FFF3CC6C  2505                              bleu.b  loc_FFF3CC71
FFF3CC6E  380eff                            bra.w   loc_FFF3CB7C
FFF3CC71  381cff                 loc_FFF3CC71 bra.w   loc_FFF3CB8D
FFF3CC74  5e012002               loc_FFF3CC74 movu.w  444h+var_4[sp], r1
FFF3CC78  6101                              cmp     #0, r1
FFF3CC7A  2010                              beq.b   loc_FFF3CC8A
FFF3CC7C  fbe258250100                      mov.l   #12558h, r14
FFF3CC82  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CC87  382c01                            bra.w   loc_FFF3CDB3
FFF3CC8A  fb3e005802             loc_FFF3CC8A mov.l   #25800h, r3
FFF3CC8F  6602                              mov.l   #0, r2
FFF3CC91  fb1200b80b07                      mov.l   #70BB800h, r1
FFF3CC97  0503e6fb                          bsr.a   sub_FFEFB29A
FFF3CC9B  05691bfa                          bsr.a   sub_FFEDE804
FFF3CC9F  8389                              mov.b   r1, 444h+var_435[sp]
FFF3CCA1  b389                              movu.b  444h+var_435[sp], r1
FFF3CCA3  6111                              cmp     #1, r1
FFF3CCA5  3b0301                            bne.w   loc_FFF3CDA8
FFF3CCA8  fbe20c230100                      mov.l   #1230Ch, r14
FFF3CCAE  d4e006                            mov.w   [r14], 444h+var_438[sp]
FFF3CCB1  fbe20c230100                      mov.l   #1230Ch, r14
FFF3CCB7  d5e00105                          mov.w   2[r14], 444h+var_43A[sp]
FFF3CCBB  b981                              movu.w  444h+var_438[sp], r1
FFF3CCBD  76014001                          cmp     #140h, r1
FFF3CCC1  2a09                              bgt.b   loc_FFF3CCCA
FFF3CCC3  b909                              movu.w  444h+var_43A[sp], r1
FFF3CCC5  7551f1                            cmp     #-0Fh, r1
FFF3CCC8  2906                              blt.b   loc_FFF3CCCE
FFF3CCCA  f80601                 loc_FFF3CCCA mov.l   #1, 444h+var_444[sp]
FFF3CCCD  0c                                bra.s   loc_FFF3CCD1
FFF3CCCE  f80600                 loc_FFF3CCCE mov.l   #0, 444h+var_444[sp]
FFF3CCD1  ec01                   loc_FFF3CCD1 mov.l   444h+var_444[sp], r1
FFF3CCD3  6101                              cmp     #0, r1
FFF3CCD5  200e                              beq.b   loc_FFF3CCE3
FFF3CCD7  b981                              movu.w  444h+var_438[sp], r1
FFF3CCD9  6811                              shlr    #1, r1
FFF3CCDB  9181                              mov.w   r1, 444h+var_438[sp]
FFF3CCDD  b909                              movu.w  444h+var_43A[sp], r1
FFF3CCDF  6811                              shlr    #1, r1
FFF3CCE1  9109                              mov.w   r1, 444h+var_43A[sp]
FFF3CCE3  b981                   loc_FFF3CCE3 movu.w  444h+var_438[sp], r1
FFF3CCE5  7551a0                            cmp     #-60h, r1
FFF3CCE8  2a0d                              bgt.b   loc_FFF3CCF5
FFF3CCEA  b909                              movu.w  444h+var_43A[sp], r1
FFF3CCEC  755178                            cmp     #78h, r1 ; 'x'
FFF3CCEF  2a06                              bgt.b   loc_FFF3CCF5
FFF3CCF1  f80601                            mov.l   #1, 444h+var_444[sp]
FFF3CCF4  0c                                bra.s   loc_FFF3CCF8
FFF3CCF5  f80600                 loc_FFF3CCF5 mov.l   #0, 444h+var_444[sp]
FFF3CCF8  ec01                   loc_FFF3CCF8 mov.l   444h+var_444[sp], r1
FFF3CCFA  6101                              cmp     #0, r1
FFF3CCFC  2014                              beq.b   loc_FFF3CD10
FFF3CCFE  3d0300                            mov.w   #0, 444h+var_43E[sp]
FFF3CD01  3d0400                            mov.w   #0, 444h+var_43C[sp]
FFF3CD04  9981                              mov.w   444h+var_438[sp], r1
FFF3CD06  6c11                              shll    #1, r1
FFF3CD08  9181                              mov.w   r1, 444h+var_438[sp]
FFF3CD0A  9909                              mov.w   444h+var_43A[sp], r1
FFF3CD0C  6c11                              shll    #1, r1
FFF3CD0E  9109                              mov.w   r1, 444h+var_43A[sp]
FFF3CD10  fb1a4001               loc_FFF3CD10 mov.l   #140h, r1
FFF3CD14  06c10106                          sub     444h+var_438[sp].uw, r1
FFF3CD18  fd748102                          div     #2, r1
FFF3CD1C  9101                              mov.w   r1, 444h+var_43C[sp]
FFF3CD1E  7541f0                            mov.l   #-10h, r1
FFF3CD21  06c10105                          sub     444h+var_43A[sp].uw, r1
FFF3CD25  fd748102                          div     #2, r1
FFF3CD29  9089                              mov.w   r1, 444h+var_43E[sp]
FFF3CD2B  050236fb                          bsr.a   sub_FFEF032D
FFF3CD2F  6040                              sub     #4, sp
FFF3CD31  f80500                            mov.w   #0, 448h+var_448[sp]
FFF3CD34  7544f0                            mov.l   #-10h, r4
FFF3CD37  fb3a4001                          mov.l   #140h, r3
FFF3CD3B  6601                              mov.l   #0, r1
FFF3CD3D  ef12                              mov.l   r1, r2
FFF3CD3F  05094ffb                          bsr.a   sub_FFEF1C48
FFF3CD43  6240                              add     #4, sp
FFF3CD45  b90c                              movu.w  444h+var_43A[sp], r4
FFF3CD47  b983                              movu.w  444h+var_438[sp], r3
FFF3CD49  b88a                              movu.w  444h+var_43E[sp], r2
FFF3CD4B  b901                              movu.w  444h+var_43C[sp], r1
FFF3CD4D  6040                              sub     #4, sp
FFF3CD4F  f80200b80b07                      mov.l   #70BB800h, 448h+var_448[sp]
FFF3CD55  05a31bfa                          bsr.a   sub_FFEDE8F8
FFF3CD59  6240                              add     #4, sp
FFF3CD5B  6040                              sub     #4, sp
FFF3CD5D  3d00f0                            mov.w   #-10h, [sp]
FFF3CD60  fb4a4001                          mov.l   #140h, r4
FFF3CD64  6602                              mov.l   #0, r2
FFF3CD66  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3CD6C  ef23                              mov.l   r2, r3
FFF3CD6E  054d2cfb                          bsr.a   sub_FFEEF9BB
FFF3CD72  6240                              add     #4, sp
FFF3CD74  8389                              mov.b   r1, 444h+var_435[sp]
FFF3CD76  b389                              movu.b  444h+var_435[sp], r1
FFF3CD78  6111                              cmp     #1, r1
FFF3CD7A  2123                              bne.b   loc_FFF3CD9D
FFF3CD7C  fbe2798d0000                      mov.l   #8D79h, r14
FFF3CD82  f8e400                            mov.b   #0, [r14]
FFF3CD85  6601                              mov.l   #0, r1
FFF3CD87  ef12                              mov.l   r1, r2
FFF3CD89  057f36fb                          bsr.a   sub_FFEF0408
FFF3CD8D  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3CD93  050b2dfb                          bsr.a   sub_FFEEFA9E
FFF3CD97  6621                              mov.l   #2, r1
FFF3CD99  05d41bfa                          bsr.a   sub_FFEDE96D
FFF3CD9D  fb1258250100           loc_FFF3CD9D mov.l   #12558h, r1
FFF3CDA3  3d1300                            mov.w   #0, 6[r1]
FFF3CDA6  2e0d                              bra.b   loc_FFF3CDB3
FFF3CDA8  fbe258250100           loc_FFF3CDA8 mov.l   #12558h, r14
FFF3CDAE  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CDB3  fb1258250100           loc_FFF3CDB3 mov.l   #12558h, r1
FFF3CDB9  3d1090                            mov.w   #-70h, [r1]
FFF3CDBC  fb1258250100                      mov.l   #12558h, r1
FFF3CDC2  3d1101                            mov.w   #1, 2[r1]
FFF3CDC5  fbe258250100                      mov.l   #12558h, r14
FFF3CDCB  fbf26c250100                      mov.l   #1256Ch, r15
FFF3CDD1  d4fe02                            mov.w   [r15], 4[r14]
FFF3CDD4  3d6c00                            mov.w   #0, 18h[r6]
FFF3CDD7  7100c8                            add     #-38h, sp, sp
FFF3CDDA  754312                            mov.l   #12h, r3
FFF3CDDD  fb2258250100                      mov.l   #12558h, r2
FFF3CDE3  ef01                              mov.l   sp, r1
FFF3CDE5  7f8f                              smovf
FFF3CDE7  ef01                              mov.l   sp, r1
FFF3CDE9  711114                            add     #14h, r1, r1
FFF3CDEC  754324                            mov.l   #24h, r3 ; '$'
FFF3CDEF  ef62                              mov.l   r6, r2
FFF3CDF1  7f8f                              smovf
FFF3CDF3  6602                              mov.l   #0, r2
FFF3CDF5  7541fe                            mov.l   #-2, r1
FFF3CDF8  05e40afa                          bsr.a   sub_FFEDD8DC
FFF3CDFC  710038                            add     #38h, sp, sp ; '8'
FFF3CDFF  da0020022102                      mov.w   444h+var_4[sp], 444h+var_2[sp]
FFF3CE05  de012102                          mov.w   444h+var_2[sp], r1
FFF3CE09  5f11                              movu.w  r1, r1
FFF3CE0B  72004404                          add     #444h, sp, sp
FFF3CE0F  7eb6                              pop     r6
FFF3CE11  02                                rts
FFF3CE12  7ea6                   sub_FFF3CE12 push.l  r6   ; <<<< FUNC sub_FFF3CE12
FFF3CE14  7200e0fb                          add     #-420h, sp, sp
FFF3CE18  fa050e0200                        mov.w   #0, 420h+var_4[sp]
FFF3CE1D  72062804                          add     #420h+arg_0, sp, r6
FFF3CE21  fa06060100                        mov.l   #0, 420h+var_8[sp]
FFF3CE26  fb1258250100                      mov.l   #12558h, r1
FFF3CE2C  6602                              mov.l   #0, r2
FFF3CE2E  9212                              mov.w   r2, 10h[r1]
FFF3CE30  a09a                              mov.l   r2, 0Ch[r1]
FFF3CE32  a092                              mov.l   r2, 8[r1]
FFF3CE34  a01a                              mov.l   r2, 4[r1]
FFF3CE36  e312                              mov.l   r2, [r1]
FFF3CE38  f80500                            mov.w   #0, 420h+var_420[sp]
FFF3CE3B  fb1262080100                      mov.l   #10862h, r1
FFF3CE41  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3CE47  e0e1                              mov.l   [r14], [r1]
FFF3CE49  a8e4                              mov.l   8[r6], r4
FFF3CE4B  fb36ff                            mov.l   #-1, r3
FFF3CE4E  6602                              mov.l   #0, r2
FFF3CE50  7f80                              suntil.b
FFF3CE52  6011                              sub     #1, r1
FFF3CE54  ef42                              mov.l   r4, r2
FFF3CE56  7f87                              smovu
FFF3CE58  fbe6ff                            mov.l   #-1, r14
FFF3CE5B  660f                              mov.l   #0, r15
FFF3CE5D  fb5262080100                      mov.l   #10862h, r5
FFF3CE63  ef51                              mov.l   r5, r1
FFF3CE65  eff2                              mov.l   r15, r2
FFF3CE67  efe3                              mov.l   r14, r3
FFF3CE69  7f80                              suntil.b
FFF3CE6B  6011                              sub     #1, r1
FFF3CE6D  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3CE73  7f87                              smovu
FFF3CE75  a8ec                              mov.l   0Ch[r6], r4
FFF3CE77  ef51                              mov.l   r5, r1
FFF3CE79  eff2                              mov.l   r15, r2
FFF3CE7B  efe3                              mov.l   r14, r3
FFF3CE7D  7f80                              suntil.b
FFF3CE7F  6011                              sub     #1, r1
FFF3CE81  ef42                              mov.l   r4, r2
FFF3CE83  7f87                              smovu
FFF3CE85  fb1262080100                      mov.l   #10862h, r1
FFF3CE8B  a009                              mov.l   r1, 420h+var_41C[sp]
FFF3CE8D  710118                            add     #420h+var_408, sp, r1
FFF3CE90  a089                              mov.l   r1, 420h+var_414[sp]
FFF3CE92  e5600502                          mov.l   14h[r6], 420h+var_418[sp]
FFF3CE96  e5600404                          mov.l   10h[r6], 420h+var_410[sp]
FFF3CE9A  754312                            mov.l   #12h, r3
FFF3CE9D  fb2234250100                      mov.l   #12534h, r2
FFF3CEA3  fb1258250100                      mov.l   #12558h, r1
FFF3CEA9  7f8f                              smovf
FFF3CEAB  5c6e                              movu.w  [r6], r14
FFF3CEAD  71eff3                            add     #-0Dh, r14, r15
FFF3CEB0  614f                              cmp     #4, r15
FFF3CEB2  2328                              bltu.b  loc_FFF3CEDA
FFF3CEB4  61be                              cmp     #0Bh, r14
FFF3CEB6  2015                              beq.b   loc_FFF3CECB
FFF3CEB8  61ae                              cmp     #0Ah, r14
FFF3CEBA  216a                              bne.b   loc_FFF3CF24
FFF3CEBC  3d0a00                            mov.w   #0, 420h+var_40C[sp]
FFF3CEBF  ef01                              mov.l   sp, r1
FFF3CEC1  05ca5ffd                          bsr.a   sub_FFF12E8B
FFF3CEC5  db010e02                          mov.w   r1, 420h+var_4[sp]
FFF3CEC9  2e61                              bra.b   loc_FFF3CF2A
FFF3CECB  3d0a01                 loc_FFF3CECB mov.w   #1, 420h+var_40C[sp]
FFF3CECE  ef01                              mov.l   sp, r1
FFF3CED0  05bb5ffd                          bsr.a   sub_FFF12E8B
FFF3CED4  db010e02                          mov.w   r1, 420h+var_4[sp]
FFF3CED8  2e52                              bra.b   loc_FFF3CF2A
FFF3CEDA  5c6e                   loc_FFF3CEDA movu.w  [r6], r14
FFF3CEDC  61de                              cmp     #0Dh, r14
FFF3CEDE  2116                              bne.b   loc_FFF3CEF4
FFF3CEE0  fbee1a7208                        mov.l   #8721Ah, r14
FFF3CEE5  f0ea                              bclr    #2, [r14].b
FFF3CEE7  fbee801a0c                        mov.l   #0C1A80h, r14
FFF3CEEC  f0ee                              bclr    #6, [r14].b
FFF3CEEE  6661                              mov.l   #6, r1
FFF3CEF0  0575d0ff                          bsr.a   sub_FFF39F65
FFF3CEF4  d4600a                 loc_FFF3CEF4 mov.w   [r6], 420h+var_40C[sp]
FFF3CEF7  ef01                              mov.l   sp, r1
FFF3CEF9  05a260fd                          bsr.a   sub_FFF12F9B
FFF3CEFD  db010e02                          mov.w   r1, 420h+var_4[sp]
FFF3CF01  5c6e                              movu.w  [r6], r14
FFF3CF03  61fe                              cmp     #0Fh, r14
FFF3CF05  2125                              bne.b   loc_FFF3CF2A
FFF3CF07  fbee1a7208                        mov.l   #8721Ah, r14
FFF3CF0C  f0e2                              bset    #2, [r14].b
FFF3CF0E  fbee801a0c                        mov.l   #0C1A80h, r14
FFF3CF13  f0e6                              bset    #6, [r14].b
FFF3CF15  fbe26e250100                      mov.l   #1256Eh, r14
FFF3CF1B  5ce2                              movu.w  [r14], r2
FFF3CF1D  6661                              mov.l   #6, r1
FFF3CF1F  05b9cfff                          bsr.a   sub_FFF39ED8
FFF3CF23  0f                                bra.s   loc_FFF3CF2A
FFF3CF24  fa090e02ffff           loc_FFF3CF24 mov.w   #-1, 420h+var_4[sp]
FFF3CF2A  5e010e02               loc_FFF3CF2A movu.w  420h+var_4[sp], r1
FFF3CF2E  6101                              cmp     #0, r1
FFF3CF30  2012                              beq.b   loc_FFF3CF42
FFF3CF32  fbe258250100                      mov.l   #12558h, r14
FFF3CF38  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3CF3D  3d6c00                            mov.w   #0, 18h[r6]
FFF3CF40  2e37                              bra.b   loc_FFF3CF77
FFF3CF42  fb1258250100           loc_FFF3CF42 mov.l   #12558h, r1
FFF3CF48  3d1300                            mov.w   #0, 6[r1]
FFF3CF4B  a961                              mov.l   10h[r6], r1
FFF3CF4D  9361                              mov.w   r1, 18h[r6]
FFF3CF4F  fa06060100                        mov.l   #0, 420h+var_8[sp]
FFF3CF54  2e1a                              bra.b   loc_FFF3CF6E
FFF3CF56  ee010601               loc_FFF3CF56 mov.l   420h+var_8[sp], r1
FFF3CF5A  a88a                              mov.l   420h+var_414[sp], r2
FFF3CF5C  fec21e                            movu.b  [r2, r1], r14
FFF3CF5F  aa62                              mov.l   20h[r6], r2
FFF3CF61  fe021e                            mov.b   r14, [r2, r1]
FFF3CF64  ee010601                          mov.l   420h+var_8[sp], r1
FFF3CF68  6211                              add     #1, r1
FFF3CF6A  eb010601                          mov.l   r1, 420h+var_8[sp]
FFF3CF6E  bb61                   loc_FFF3CF6E movu.w  18h[r6], r1
FFF3CF70  0686010601                        cmp     420h+var_8[sp].l, r1
FFF3CF75  24e1                              bgtu.b  loc_FFF3CF56
FFF3CF77  bb61                   loc_FFF3CF77 movu.w  18h[r6], r1
FFF3CF79  72119000                          add     #90h, r1, r1
FFF3CF7D  fbe258250100                      mov.l   #12558h, r14
FFF3CF83  d3e1                              mov.w   r1, [r14]
FFF3CF85  fb1258250100                      mov.l   #12558h, r1
FFF3CF8B  3d1101                            mov.w   #1, 2[r1]
FFF3CF8E  fbe258250100                      mov.l   #12558h, r14
FFF3CF94  fbf26c250100                      mov.l   #1256Ch, r15
FFF3CF9A  d4fe02                            mov.w   [r15], 4[r14]
FFF3CF9D  7100c8                            add     #-38h, sp, sp
FFF3CFA0  754312                            mov.l   #12h, r3
FFF3CFA3  fb2258250100                      mov.l   #12558h, r2
FFF3CFA9  ef01                              mov.l   sp, r1
FFF3CFAB  7f8f                              smovf
FFF3CFAD  ef01                              mov.l   sp, r1
FFF3CFAF  711114                            add     #14h, r1, r1
FFF3CFB2  754324                            mov.l   #24h, r3 ; '$'
FFF3CFB5  ef62                              mov.l   r6, r2
FFF3CFB7  7f8f                              smovf
FFF3CFB9  6602                              mov.l   #0, r2
FFF3CFBB  7541fe                            mov.l   #-2, r1
FFF3CFBE  051e09fa                          bsr.a   sub_FFEDD8DC
FFF3CFC2  710038                            add     #38h, sp, sp ; '8'
FFF3CFC5  da000e020f02                      mov.w   420h+var_4[sp], 420h+var_2[sp]
FFF3CFCB  de010f02                          mov.w   420h+var_2[sp], r1
FFF3CFCF  5f11                              movu.w  r1, r1
FFF3CFD1  72002004                          add     #420h, sp, sp
FFF3CFD5  7eb6                              pop     r6
FFF3CFD7  02                                rts
FFF3CFD8  7ea6                   sub_FFF3CFD8 push.l  r6   ; <<<< FUNC sub_FFF3CFD8
FFF3CFDA  6080                              sub     #8, sp
FFF3CFDC  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3CFDF  710610                            add     #8+arg_0, sp, r6
FFF3CFE2  f80600                            mov.l   #0, 8+var_8[sp]
FFF3CFE5  fb1258250100                      mov.l   #12558h, r1
FFF3CFEB  6602                              mov.l   #0, r2
FFF3CFED  9212                              mov.w   r2, 10h[r1]
FFF3CFEF  a09a                              mov.l   r2, 0Ch[r1]
FFF3CFF1  a092                              mov.l   r2, 8[r1]
FFF3CFF3  a01a                              mov.l   r2, 4[r1]
FFF3CFF5  e312                              mov.l   r2, [r1]
FFF3CFF7  fb1262080100                      mov.l   #10862h, r1
FFF3CFFD  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D003  e0e1                              mov.l   [r14], [r1]
FFF3D005  a8e4                              mov.l   8[r6], r4
FFF3D007  fb36ff                            mov.l   #-1, r3
FFF3D00A  6602                              mov.l   #0, r2
FFF3D00C  7f80                              suntil.b
FFF3D00E  6011                              sub     #1, r1
FFF3D010  ef42                              mov.l   r4, r2
FFF3D012  7f87                              smovu
FFF3D014  fbe6ff                            mov.l   #-1, r14
FFF3D017  660f                              mov.l   #0, r15
FFF3D019  fb5262080100                      mov.l   #10862h, r5
FFF3D01F  ef51                              mov.l   r5, r1
FFF3D021  eff2                              mov.l   r15, r2
FFF3D023  efe3                              mov.l   r14, r3
FFF3D025  7f80                              suntil.b
FFF3D027  6011                              sub     #1, r1
FFF3D029  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3D02F  7f87                              smovu
FFF3D031  a8ec                              mov.l   0Ch[r6], r4
FFF3D033  ef51                              mov.l   r5, r1
FFF3D035  eff2                              mov.l   r15, r2
FFF3D037  efe3                              mov.l   r14, r3
FFF3D039  7f80                              suntil.b
FFF3D03B  6011                              sub     #1, r1
FFF3D03D  ef42                              mov.l   r4, r2
FFF3D03F  7f87                              smovu
FFF3D041  754312                            mov.l   #12h, r3
FFF3D044  fb2234250100                      mov.l   #12534h, r2
FFF3D04A  fb1258250100                      mov.l   #12558h, r1
FFF3D050  7f8f                              smovf
FFF3D052  ef02                              mov.l   sp, r2
FFF3D054  fb1262080100                      mov.l   #10862h, r1
FFF3D05A  059960fd                          bsr.a   sub_FFF130F3
FFF3D05E  9081                              mov.w   r1, 8+var_4[sp]
FFF3D060  b881                              movu.w  8+var_4[sp], r1
FFF3D062  6101                              cmp     #0, r1
FFF3D064  2012                              beq.b   loc_FFF3D076
FFF3D066  fbe258250100                      mov.l   #12558h, r14
FFF3D06C  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D071  3e6400                            mov.l   #0, 10h[r6]
FFF3D074  2e0e                              bra.b   loc_FFF3D082
FFF3D076  fb1258250100           loc_FFF3D076 mov.l   #12558h, r1
FFF3D07C  3d1300                            mov.w   #0, 6[r1]
FFF3D07F  e40604                            mov.l   8+var_8[sp], 10h[r6]
FFF3D082  fb1258250100           loc_FFF3D082 mov.l   #12558h, r1
FFF3D088  3d1090                            mov.w   #-70h, [r1]
FFF3D08B  fb1258250100                      mov.l   #12558h, r1
FFF3D091  3d1101                            mov.w   #1, 2[r1]
FFF3D094  fbe258250100                      mov.l   #12558h, r14
FFF3D09A  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D0A0  d4fe02                            mov.w   [r15], 4[r14]
FFF3D0A3  3d6c00                            mov.w   #0, 18h[r6]
FFF3D0A6  7100c8                            add     #-38h, sp, sp
FFF3D0A9  754312                            mov.l   #12h, r3
FFF3D0AC  fb2258250100                      mov.l   #12558h, r2
FFF3D0B2  ef01                              mov.l   sp, r1
FFF3D0B4  7f8f                              smovf
FFF3D0B6  ef01                              mov.l   sp, r1
FFF3D0B8  711114                            add     #14h, r1, r1
FFF3D0BB  754324                            mov.l   #24h, r3 ; '$'
FFF3D0BE  ef62                              mov.l   r6, r2
FFF3D0C0  7f8f                              smovf
FFF3D0C2  6602                              mov.l   #0, r2
FFF3D0C4  7541fe                            mov.l   #-2, r1
FFF3D0C7  051508fa                          bsr.a   sub_FFEDD8DC
FFF3D0CB  710038                            add     #38h, sp, sp ; '8'
FFF3D0CE  d5000203                          mov.w   8+var_4[sp], 8+var_2[sp]
FFF3D0D2  9889                              mov.w   8+var_2[sp], r1
FFF3D0D4  5f11                              movu.w  r1, r1
FFF3D0D6  3f6603                            rtsd    #0Ch, r6-r6
FFF3D0D9  7ea6                   sub_FFF3D0D9 push.l  r6   ; <<<< FUNC sub_FFF3D0D9
FFF3D0DB  7100d8                            add     #-28h, sp, sp
FFF3D0DE  3d8200                            mov.w   #0, 28h+var_4[sp]
FFF3D0E1  3d8100                            mov.w   #0, 28h+var_6[sp]
FFF3D0E4  710630                            add     #28h+arg_0, sp, r6
FFF3D0E7  fb1258250100                      mov.l   #12558h, r1
FFF3D0ED  6602                              mov.l   #0, r2
FFF3D0EF  9212                              mov.w   r2, 10h[r1]
FFF3D0F1  a09a                              mov.l   r2, 0Ch[r1]
FFF3D0F3  a092                              mov.l   r2, 8[r1]
FFF3D0F5  a01a                              mov.l   r2, 4[r1]
FFF3D0F7  e312                              mov.l   r2, [r1]
FFF3D0F9  3d8200                            mov.w   #0, 28h+var_4[sp]
FFF3D0FC  2e20                              bra.b   loc_FFF3D11C
FFF3D0FE  aa61                   loc_FFF3D0FE mov.l   20h[r6], r1
FFF3D100  bc82                              movu.w  28h+var_4[sp], r2
FFF3D102  fec12e                            movu.b  [r1, r2], r14
FFF3D105  610e                              cmp     #0, r14
FFF3D107  201c                              beq.b   loc_FFF3D123
FFF3D109  aa61                              mov.l   20h[r6], r1
FFF3D10B  bc82                              movu.w  28h+var_4[sp], r2
FFF3D10D  fec12e                            movu.b  [r1, r2], r14
FFF3D110  710f02                            add     #28h+var_26, sp, r15
FFF3D113  fe0f2e                            mov.b   r14, [r15, r2]
FFF3D116  9c81                              mov.w   28h+var_4[sp], r1
FFF3D118  6211                              add     #1, r1
FFF3D11A  9481                              mov.w   r1, 28h+var_4[sp]
FFF3D11C  bc81                   loc_FFF3D11C movu.w  28h+var_4[sp], r1
FFF3D11E  755120                            cmp     #20h, r1 ; ' '
FFF3D121  29dd                              blt.b   loc_FFF3D0FE
FFF3D123  bc81                   loc_FFF3D123 movu.w  28h+var_4[sp], r1
FFF3D125  710e02                            add     #28h+var_26, sp, r14
FFF3D128  660f                              mov.l   #0, r15
FFF3D12A  fe0e1f                            mov.b   r15, [r14, r1]
FFF3D12D  fb1262080100                      mov.l   #10862h, r1
FFF3D133  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D139  e0e1                              mov.l   [r14], [r1]
FFF3D13B  a8e4                              mov.l   8[r6], r4
FFF3D13D  fb36ff                            mov.l   #-1, r3
FFF3D140  6602                              mov.l   #0, r2
FFF3D142  7f80                              suntil.b
FFF3D144  6011                              sub     #1, r1
FFF3D146  ef42                              mov.l   r4, r2
FFF3D148  7f87                              smovu
FFF3D14A  fbe6ff                            mov.l   #-1, r14
FFF3D14D  660f                              mov.l   #0, r15
FFF3D14F  fb5262080100                      mov.l   #10862h, r5
FFF3D155  ef51                              mov.l   r5, r1
FFF3D157  eff2                              mov.l   r15, r2
FFF3D159  efe3                              mov.l   r14, r3
FFF3D15B  7f80                              suntil.b
FFF3D15D  6011                              sub     #1, r1
FFF3D15F  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3D165  7f87                              smovu
FFF3D167  a8ec                              mov.l   0Ch[r6], r4
FFF3D169  ef51                              mov.l   r5, r1
FFF3D16B  eff2                              mov.l   r15, r2
FFF3D16D  efe3                              mov.l   r14, r3
FFF3D16F  7f80                              suntil.b
FFF3D171  6011                              sub     #1, r1
FFF3D173  ef42                              mov.l   r4, r2
FFF3D175  7f87                              smovu
FFF3D177  754312                            mov.l   #12h, r3
FFF3D17A  fb2234250100                      mov.l   #12534h, r2
FFF3D180  fb1258250100                      mov.l   #12558h, r1
FFF3D186  7f8f                              smovf
FFF3D188  710202                            add     #28h+var_26, sp, r2
FFF3D18B  fb1262080100                      mov.l   #10862h, r1
FFF3D191  05c85ffd                          bsr.a   sub_FFF13159
FFF3D195  9409                              mov.w   r1, 28h+var_6[sp]
FFF3D197  bc09                              movu.w  28h+var_6[sp], r1
FFF3D199  6101                              cmp     #0, r1
FFF3D19B  200e                              beq.b   loc_FFF3D1A9
FFF3D19D  fbe258250100                      mov.l   #12558h, r14
FFF3D1A3  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D1A8  0a                                bra.s   loc_FFF3D1B2
FFF3D1A9  fb1258250100           loc_FFF3D1A9 mov.l   #12558h, r1
FFF3D1AF  3d1300                            mov.w   #0, 6[r1]
FFF3D1B2  fb1258250100           loc_FFF3D1B2 mov.l   #12558h, r1
FFF3D1B8  3d1090                            mov.w   #-70h, [r1]
FFF3D1BB  fb1258250100                      mov.l   #12558h, r1
FFF3D1C1  3d1101                            mov.w   #1, 2[r1]
FFF3D1C4  fbe258250100                      mov.l   #12558h, r14
FFF3D1CA  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D1D0  d4fe02                            mov.w   [r15], 4[r14]
FFF3D1D3  3d6c00                            mov.w   #0, 18h[r6]
FFF3D1D6  7100c8                            add     #-38h, sp, sp
FFF3D1D9  754312                            mov.l   #12h, r3
FFF3D1DC  fb2258250100                      mov.l   #12558h, r2
FFF3D1E2  ef01                              mov.l   sp, r1
FFF3D1E4  7f8f                              smovf
FFF3D1E6  ef01                              mov.l   sp, r1
FFF3D1E8  711114                            add     #14h, r1, r1
FFF3D1EB  754324                            mov.l   #24h, r3 ; '$'
FFF3D1EE  ef62                              mov.l   r6, r2
FFF3D1F0  7f8f                              smovf
FFF3D1F2  6602                              mov.l   #0, r2
FFF3D1F4  7541fe                            mov.l   #-2, r1
FFF3D1F7  05e506fa                          bsr.a   sub_FFEDD8DC
FFF3D1FB  710038                            add     #38h, sp, sp ; '8'
FFF3D1FE  d5001113                          mov.w   28h+var_6[sp], 28h+var_2[sp]
FFF3D202  9c89                              mov.w   28h+var_2[sp], r1
FFF3D204  5f11                              movu.w  r1, r1
FFF3D206  3f660b                            rtsd    #2Ch, r6-r6
FFF3D209  7ea6                   sub_FFF3D209 push.l  r6   ; <<<< FUNC sub_FFF3D209
FFF3D20B  6040                              sub     #4, sp
FFF3D20D  f80500                            mov.w   #0, 4+var_4[sp]
FFF3D210  71060c                            add     #4+arg_0, sp, r6
FFF3D213  fb1258250100                      mov.l   #12558h, r1
FFF3D219  6602                              mov.l   #0, r2
FFF3D21B  9212                              mov.w   r2, 10h[r1]
FFF3D21D  a09a                              mov.l   r2, 0Ch[r1]
FFF3D21F  a092                              mov.l   r2, 8[r1]
FFF3D221  a01a                              mov.l   r2, 4[r1]
FFF3D223  e312                              mov.l   r2, [r1]
FFF3D225  fb1262080100                      mov.l   #10862h, r1
FFF3D22B  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D231  e0e1                              mov.l   [r14], [r1]
FFF3D233  a8e4                              mov.l   8[r6], r4
FFF3D235  fb36ff                            mov.l   #-1, r3
FFF3D238  6602                              mov.l   #0, r2
FFF3D23A  7f80                              suntil.b
FFF3D23C  6011                              sub     #1, r1
FFF3D23E  ef42                              mov.l   r4, r2
FFF3D240  7f87                              smovu
FFF3D242  fbe6ff                            mov.l   #-1, r14
FFF3D245  660f                              mov.l   #0, r15
FFF3D247  fb5262080100                      mov.l   #10862h, r5
FFF3D24D  ef51                              mov.l   r5, r1
FFF3D24F  eff2                              mov.l   r15, r2
FFF3D251  efe3                              mov.l   r14, r3
FFF3D253  7f80                              suntil.b
FFF3D255  6011                              sub     #1, r1
FFF3D257  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3D25D  7f87                              smovu
FFF3D25F  a8ec                              mov.l   0Ch[r6], r4
FFF3D261  ef51                              mov.l   r5, r1
FFF3D263  eff2                              mov.l   r15, r2
FFF3D265  efe3                              mov.l   r14, r3
FFF3D267  7f80                              suntil.b
FFF3D269  6011                              sub     #1, r1
FFF3D26B  ef42                              mov.l   r4, r2
FFF3D26D  7f87                              smovu
FFF3D26F  754312                            mov.l   #12h, r3
FFF3D272  fb2234250100                      mov.l   #12534h, r2
FFF3D278  fb1258250100                      mov.l   #12558h, r1
FFF3D27E  7f8f                              smovf
FFF3D280  fb1262080100                      mov.l   #10862h, r1
FFF3D286  05fe5efd                          bsr.a   sub_FFF13184
FFF3D28A  d301                              mov.w   r1, 4+var_4[sp]
FFF3D28C  5c01                              movu.w  4+var_4[sp], r1
FFF3D28E  6101                              cmp     #0, r1
FFF3D290  200e                              beq.b   loc_FFF3D29E
FFF3D292  fbe258250100                      mov.l   #12558h, r14
FFF3D298  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D29D  0a                                bra.s   loc_FFF3D2A7
FFF3D29E  fb1258250100           loc_FFF3D29E mov.l   #12558h, r1
FFF3D2A4  3d1300                            mov.w   #0, 6[r1]
FFF3D2A7  fb1258250100           loc_FFF3D2A7 mov.l   #12558h, r1
FFF3D2AD  3d1090                            mov.w   #-70h, [r1]
FFF3D2B0  fb1258250100                      mov.l   #12558h, r1
FFF3D2B6  3d1101                            mov.w   #1, 2[r1]
FFF3D2B9  fbe258250100                      mov.l   #12558h, r14
FFF3D2BF  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D2C5  d4fe02                            mov.w   [r15], 4[r14]
FFF3D2C8  3d6c00                            mov.w   #0, 18h[r6]
FFF3D2CB  7100c8                            add     #-38h, sp, sp
FFF3D2CE  754312                            mov.l   #12h, r3
FFF3D2D1  fb2258250100                      mov.l   #12558h, r2
FFF3D2D7  ef01                              mov.l   sp, r1
FFF3D2D9  7f8f                              smovf
FFF3D2DB  ef01                              mov.l   sp, r1
FFF3D2DD  711114                            add     #14h, r1, r1
FFF3D2E0  754324                            mov.l   #24h, r3 ; '$'
FFF3D2E3  ef62                              mov.l   r6, r2
FFF3D2E5  7f8f                              smovf
FFF3D2E7  6602                              mov.l   #0, r2
FFF3D2E9  7541fe                            mov.l   #-2, r1
FFF3D2EC  05f005fa                          bsr.a   sub_FFEDD8DC
FFF3D2F0  710038                            add     #38h, sp, sp ; '8'
FFF3D2F3  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3D2F6  9809                              mov.w   4+var_2[sp], r1
FFF3D2F8  5f11                              movu.w  r1, r1
FFF3D2FA  3f6602                            rtsd    #8, r6-r6
FFF3D2FD  7ea6                   sub_FFF3D2FD push.l  r6   ; <<<< FUNC sub_FFF3D2FD
FFF3D2FF  6040                              sub     #4, sp
FFF3D301  f80500                            mov.w   #0, 4+var_4[sp]
FFF3D304  71060c                            add     #4+arg_0, sp, r6
FFF3D307  fb1258250100                      mov.l   #12558h, r1
FFF3D30D  6602                              mov.l   #0, r2
FFF3D30F  9212                              mov.w   r2, 10h[r1]
FFF3D311  a09a                              mov.l   r2, 0Ch[r1]
FFF3D313  a092                              mov.l   r2, 8[r1]
FFF3D315  a01a                              mov.l   r2, 4[r1]
FFF3D317  e312                              mov.l   r2, [r1]
FFF3D319  fb1262080100                      mov.l   #10862h, r1
FFF3D31F  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D325  e0e1                              mov.l   [r14], [r1]
FFF3D327  a8e4                              mov.l   8[r6], r4
FFF3D329  fb36ff                            mov.l   #-1, r3
FFF3D32C  6602                              mov.l   #0, r2
FFF3D32E  7f80                              suntil.b
FFF3D330  6011                              sub     #1, r1
FFF3D332  ef42                              mov.l   r4, r2
FFF3D334  7f87                              smovu
FFF3D336  754312                            mov.l   #12h, r3
FFF3D339  fb2234250100                      mov.l   #12534h, r2
FFF3D33F  fb1258250100                      mov.l   #12558h, r1
FFF3D345  7f8f                              smovf
FFF3D347  fb1262080100                      mov.l   #10862h, r1
FFF3D34D  056058fd                          bsr.a   sub_FFF12BAD
FFF3D351  d301                              mov.w   r1, 4+var_4[sp]
FFF3D353  5c01                              movu.w  4+var_4[sp], r1
FFF3D355  6101                              cmp     #0, r1
FFF3D357  200e                              beq.b   loc_FFF3D365
FFF3D359  fbe258250100                      mov.l   #12558h, r14
FFF3D35F  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D364  0a                                bra.s   loc_FFF3D36E
FFF3D365  fb1258250100           loc_FFF3D365 mov.l   #12558h, r1
FFF3D36B  3d1300                            mov.w   #0, 6[r1]
FFF3D36E  3d60c9                 loc_FFF3D36E mov.w   #-37h, [r6]
FFF3D371  fb1258250100                      mov.l   #12558h, r1
FFF3D377  3d1090                            mov.w   #-70h, [r1]
FFF3D37A  fb1258250100                      mov.l   #12558h, r1
FFF3D380  3d1101                            mov.w   #1, 2[r1]
FFF3D383  fbe258250100                      mov.l   #12558h, r14
FFF3D389  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D38F  d4fe02                            mov.w   [r15], 4[r14]
FFF3D392  3d6c00                            mov.w   #0, 18h[r6]
FFF3D395  7100c8                            add     #-38h, sp, sp
FFF3D398  754312                            mov.l   #12h, r3
FFF3D39B  fb2258250100                      mov.l   #12558h, r2
FFF3D3A1  ef01                              mov.l   sp, r1
FFF3D3A3  7f8f                              smovf
FFF3D3A5  ef01                              mov.l   sp, r1
FFF3D3A7  711114                            add     #14h, r1, r1
FFF3D3AA  754324                            mov.l   #24h, r3 ; '$'
FFF3D3AD  ef62                              mov.l   r6, r2
FFF3D3AF  7f8f                              smovf
FFF3D3B1  6602                              mov.l   #0, r2
FFF3D3B3  7541fe                            mov.l   #-2, r1
FFF3D3B6  052605fa                          bsr.a   sub_FFEDD8DC
FFF3D3BA  710038                            add     #38h, sp, sp ; '8'
FFF3D3BD  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3D3C0  9809                              mov.w   4+var_2[sp], r1
FFF3D3C2  5f11                              movu.w  r1, r1
FFF3D3C4  3f6602                            rtsd    #8, r6-r6
FFF3D3C7  7ea6                   sub_FFF3D3C7 push.l  r6   ; <<<< FUNC sub_FFF3D3C7
FFF3D3C9  6040                              sub     #4, sp
FFF3D3CB  3c0201                            mov.b   #1, 4+var_2[sp]
FFF3D3CE  71060c                            add     #4+arg_0, sp, r6
FFF3D3D1  fb1258250100                      mov.l   #12558h, r1
FFF3D3D7  6602                              mov.l   #0, r2
FFF3D3D9  9212                              mov.w   r2, 10h[r1]
FFF3D3DB  a09a                              mov.l   r2, 0Ch[r1]
FFF3D3DD  a092                              mov.l   r2, 8[r1]
FFF3D3DF  a01a                              mov.l   r2, 4[r1]
FFF3D3E1  e312                              mov.l   r2, [r1]
FFF3D3E3  fb1262080100                      mov.l   #10862h, r1
FFF3D3E9  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D3EF  e0e1                              mov.l   [r14], [r1]
FFF3D3F1  a8e4                              mov.l   8[r6], r4
FFF3D3F3  fb36ff                            mov.l   #-1, r3
FFF3D3F6  6602                              mov.l   #0, r2
FFF3D3F8  7f80                              suntil.b
FFF3D3FA  6011                              sub     #1, r1
FFF3D3FC  ef42                              mov.l   r4, r2
FFF3D3FE  7f87                              smovu
FFF3D400  754312                            mov.l   #12h, r3
FFF3D403  fb2234250100                      mov.l   #12534h, r2
FFF3D409  fb1258250100                      mov.l   #12558h, r1
FFF3D40F  7f8f                              smovf
FFF3D411  fb1262080100                      mov.l   #10862h, r1
FFF3D417  05e257fd                          bsr.a   sub_FFF12BF9
FFF3D41B  8081                              mov.b   r1, 4+var_2[sp]
FFF3D41D  b081                              movu.b  4+var_2[sp], r1
FFF3D41F  6111                              cmp     #1, r1
FFF3D421  200e                              beq.b   loc_FFF3D42F
FFF3D423  fbe258250100                      mov.l   #12558h, r14
FFF3D429  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D42E  0a                                bra.s   loc_FFF3D438
FFF3D42F  fb1258250100           loc_FFF3D42F mov.l   #12558h, r1
FFF3D435  3d1300                            mov.w   #0, 6[r1]
FFF3D438  fb1258250100           loc_FFF3D438 mov.l   #12558h, r1
FFF3D43E  3d1090                            mov.w   #-70h, [r1]
FFF3D441  fb1258250100                      mov.l   #12558h, r1
FFF3D447  3d1101                            mov.w   #1, 2[r1]
FFF3D44A  fbe258250100                      mov.l   #12558h, r14
FFF3D450  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D456  d4fe02                            mov.w   [r15], 4[r14]
FFF3D459  3d6c00                            mov.w   #0, 18h[r6]
FFF3D45C  7100c8                            add     #-38h, sp, sp
FFF3D45F  754312                            mov.l   #12h, r3
FFF3D462  fb2258250100                      mov.l   #12558h, r2
FFF3D468  ef01                              mov.l   sp, r1
FFF3D46A  7f8f                              smovf
FFF3D46C  ef01                              mov.l   sp, r1
FFF3D46E  711114                            add     #14h, r1, r1
FFF3D471  754324                            mov.l   #24h, r3 ; '$'
FFF3D474  ef62                              mov.l   r6, r2
FFF3D476  7f8f                              smovf
FFF3D478  6602                              mov.l   #0, r2
FFF3D47A  7541fe                            mov.l   #-2, r1
FFF3D47D  055f04fa                          bsr.a   sub_FFEDD8DC
FFF3D481  710038                            add     #38h, sp, sp ; '8'
FFF3D484  c5000203                          mov.b   4+var_2[sp], 4+var_1[sp]
FFF3D488  b089                              movu.b  4+var_1[sp], r1
FFF3D48A  5b11                              movu.b  r1, r1
FFF3D48C  3f6602                            rtsd    #8, r6-r6
FFF3D48F  7ea6                   sub_FFF3D48F push.l  r6   ; <<<< FUNC sub_FFF3D48F
FFF3D491  6040                              sub     #4, sp
FFF3D493  f80500                            mov.w   #0, 4+var_4[sp]
FFF3D496  71060c                            add     #4+arg_0, sp, r6
FFF3D499  fb1258250100                      mov.l   #12558h, r1
FFF3D49F  6602                              mov.l   #0, r2
FFF3D4A1  9212                              mov.w   r2, 10h[r1]
FFF3D4A3  a09a                              mov.l   r2, 0Ch[r1]
FFF3D4A5  a092                              mov.l   r2, 8[r1]
FFF3D4A7  a01a                              mov.l   r2, 4[r1]
FFF3D4A9  e312                              mov.l   r2, [r1]
FFF3D4AB  fb1262080100                      mov.l   #10862h, r1
FFF3D4B1  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D4B7  e0e1                              mov.l   [r14], [r1]
FFF3D4B9  a8e4                              mov.l   8[r6], r4
FFF3D4BB  fb36ff                            mov.l   #-1, r3
FFF3D4BE  6602                              mov.l   #0, r2
FFF3D4C0  7f80                              suntil.b
FFF3D4C2  6011                              sub     #1, r1
FFF3D4C4  ef42                              mov.l   r4, r2
FFF3D4C6  7f87                              smovu
FFF3D4C8  754312                            mov.l   #12h, r3
FFF3D4CB  fb2234250100                      mov.l   #12534h, r2
FFF3D4D1  fb1258250100                      mov.l   #12558h, r1
FFF3D4D7  7f8f                              smovf
FFF3D4D9  fb1262080100                      mov.l   #10862h, r1
FFF3D4DF  05f456fd                          bsr.a   sub_FFF12BD3
FFF3D4E3  d301                              mov.w   r1, 4+var_4[sp]
FFF3D4E5  5c01                              movu.w  4+var_4[sp], r1
FFF3D4E7  6101                              cmp     #0, r1
FFF3D4E9  200e                              beq.b   loc_FFF3D4F7
FFF3D4EB  fbe258250100                      mov.l   #12558h, r14
FFF3D4F1  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D4F6  0a                                bra.s   loc_FFF3D500
FFF3D4F7  fb1258250100           loc_FFF3D4F7 mov.l   #12558h, r1
FFF3D4FD  3d1300                            mov.w   #0, 6[r1]
FFF3D500  fb1258250100           loc_FFF3D500 mov.l   #12558h, r1
FFF3D506  3d1090                            mov.w   #-70h, [r1]
FFF3D509  fb1258250100                      mov.l   #12558h, r1
FFF3D50F  3d1101                            mov.w   #1, 2[r1]
FFF3D512  fbe258250100                      mov.l   #12558h, r14
FFF3D518  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D51E  d4fe02                            mov.w   [r15], 4[r14]
FFF3D521  3d6c00                            mov.w   #0, 18h[r6]
FFF3D524  7100c8                            add     #-38h, sp, sp
FFF3D527  754312                            mov.l   #12h, r3
FFF3D52A  fb2258250100                      mov.l   #12558h, r2
FFF3D530  ef01                              mov.l   sp, r1
FFF3D532  7f8f                              smovf
FFF3D534  ef01                              mov.l   sp, r1
FFF3D536  711114                            add     #14h, r1, r1
FFF3D539  754324                            mov.l   #24h, r3 ; '$'
FFF3D53C  ef62                              mov.l   r6, r2
FFF3D53E  7f8f                              smovf
FFF3D540  6602                              mov.l   #0, r2
FFF3D542  7541fe                            mov.l   #-2, r1
FFF3D545  059703fa                          bsr.a   sub_FFEDD8DC
FFF3D549  710038                            add     #38h, sp, sp ; '8'
FFF3D54C  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3D54F  9809                              mov.w   4+var_2[sp], r1
FFF3D551  5f11                              movu.w  r1, r1
FFF3D553  3f6602                            rtsd    #8, r6-r6
FFF3D556  7ea6                   sub_FFF3D556 push.l  r6   ; <<<< FUNC sub_FFF3D556
FFF3D558  6080                              sub     #8, sp
FFF3D55A  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3D55D  710610                            add     #8+arg_0, sp, r6
FFF3D560  fb1258250100                      mov.l   #12558h, r1
FFF3D566  6602                              mov.l   #0, r2
FFF3D568  9212                              mov.w   r2, 10h[r1]
FFF3D56A  a09a                              mov.l   r2, 0Ch[r1]
FFF3D56C  a092                              mov.l   r2, 8[r1]
FFF3D56E  a01a                              mov.l   r2, 4[r1]
FFF3D570  e312                              mov.l   r2, [r1]
FFF3D572  754312                            mov.l   #12h, r3
FFF3D575  fb2234250100                      mov.l   #12534h, r2
FFF3D57B  fb1258250100                      mov.l   #12558h, r1
FFF3D581  7f8f                              smovf
FFF3D583  fbe25f080100                      mov.l   #1085Fh, r14
FFF3D589  58ee                              movu.b  [r14], r14
FFF3D58B  610e                              cmp     #0, r14
FFF3D58D  2061                              beq.b   loc_FFF3D5EE
FFF3D58F  fbe258250100                      mov.l   #12558h, r14
FFF3D595  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D59A  fb1258250100                      mov.l   #12558h, r1
FFF3D5A0  3d1090                            mov.w   #-70h, [r1]
FFF3D5A3  fb1258250100                      mov.l   #12558h, r1
FFF3D5A9  3d1101                            mov.w   #1, 2[r1]
FFF3D5AC  fbe258250100                      mov.l   #12558h, r14
FFF3D5B2  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D5B8  d4fe02                            mov.w   [r15], 4[r14]
FFF3D5BB  3d6c00                            mov.w   #0, 18h[r6]
FFF3D5BE  7100c8                            add     #-38h, sp, sp
FFF3D5C1  754312                            mov.l   #12h, r3
FFF3D5C4  fb2258250100                      mov.l   #12558h, r2
FFF3D5CA  ef01                              mov.l   sp, r1
FFF3D5CC  7f8f                              smovf
FFF3D5CE  ef01                              mov.l   sp, r1
FFF3D5D0  711114                            add     #14h, r1, r1
FFF3D5D3  754324                            mov.l   #24h, r3 ; '$'
FFF3D5D6  ef62                              mov.l   r6, r2
FFF3D5D8  7f8f                              smovf
FFF3D5DA  6602                              mov.l   #0, r2
FFF3D5DC  7541fe                            mov.l   #-2, r1
FFF3D5DF  05fd02fa                          bsr.a   sub_FFEDD8DC
FFF3D5E3  710038                            add     #38h, sp, sp ; '8'
FFF3D5E6  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF3D5EB  388c00                            bra.w   loc_FFF3D677
FFF3D5EE  fbe25f080100           loc_FFF3D5EE mov.l   #1085Fh, r14
FFF3D5F4  f8e401                            mov.b   #1, [r14]
FFF3D5F7  059854fd                          bsr.a   sub_FFF12A8F
FFF3D5FB  9081                              mov.w   r1, 8+var_4[sp]
FFF3D5FD  b881                              movu.w  8+var_4[sp], r1
FFF3D5FF  6101                              cmp     #0, r1
FFF3D601  200e                              beq.b   loc_FFF3D60F
FFF3D603  fbe258250100                      mov.l   #12558h, r14
FFF3D609  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D60E  0a                                bra.s   loc_FFF3D618
FFF3D60F  fb1258250100           loc_FFF3D60F mov.l   #12558h, r1
FFF3D615  3d1300                            mov.w   #0, 6[r1]
FFF3D618  fb1258250100           loc_FFF3D618 mov.l   #12558h, r1
FFF3D61E  3d1090                            mov.w   #-70h, [r1]
FFF3D621  fb1258250100                      mov.l   #12558h, r1
FFF3D627  3d1101                            mov.w   #1, 2[r1]
FFF3D62A  fbe258250100                      mov.l   #12558h, r14
FFF3D630  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D636  d4fe02                            mov.w   [r15], 4[r14]
FFF3D639  3d6c00                            mov.w   #0, 18h[r6]
FFF3D63C  7100c8                            add     #-38h, sp, sp
FFF3D63F  754312                            mov.l   #12h, r3
FFF3D642  fb2258250100                      mov.l   #12558h, r2
FFF3D648  ef01                              mov.l   sp, r1
FFF3D64A  7f8f                              smovf
FFF3D64C  ef01                              mov.l   sp, r1
FFF3D64E  711114                            add     #14h, r1, r1
FFF3D651  754324                            mov.l   #24h, r3 ; '$'
FFF3D654  ef62                              mov.l   r6, r2
FFF3D656  7f8f                              smovf
FFF3D658  6602                              mov.l   #0, r2
FFF3D65A  7541fe                            mov.l   #-2, r1
FFF3D65D  057f02fa                          bsr.a   sub_FFEDD8DC
FFF3D661  710038                            add     #38h, sp, sp ; '8'
FFF3D664  fbe25f080100                      mov.l   #1085Fh, r14
FFF3D66A  f8e400                            mov.b   #0, [r14]
FFF3D66D  6601                              mov.l   #0, r1
FFF3D66F  053355ff                          bsr.a   sub_FFF32BA2
FFF3D673  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF3D677  d5000103               loc_FFF3D677 mov.w   8+var_6[sp], 8+var_2[sp]
FFF3D67B  b889                              movu.w  8+var_2[sp], r1
FFF3D67D  3f6603                            rtsd    #0Ch, r6-r6
FFF3D680  6080                   sub_FFF3D680 sub     #8, sp   ; <<<< FUNC sub_FFF3D680
FFF3D682  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3D685  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D688  fb12f0840600                      mov.l   #684F0h, r1
FFF3D68E  b819                              movu.w  2[r1], r1
FFF3D690  6111                              cmp     #1, r1
FFF3D692  18                                bne.s   loc_FFF3D69A
FFF3D693  f809ffff                          mov.w   #-1, 8+var_8[sp]
FFF3D697  38e901                            bra.w   loc_FFF3D880
FFF3D69A  fbe2f0840600           loc_FFF3D69A mov.l   #684F0h, r14
FFF3D6A0  f8e500                            mov.w   #0, [r14]
FFF3D6A3  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D6A6  2e49                              bra.b   loc_FFF3D6EF
FFF3D6A8  b809                   loc_FFF3D6A8 movu.w  8+var_6[sp], r1
FFF3D6AA  751124                            mul     #24h, r1 ; '$'
FFF3D6AD  fbe260840600                      mov.l   #68460h, r14
FFF3D6B3  4b1e                              add     r1, r14
FFF3D6B5  5cee                              movu.w  [r14], r14
FFF3D6B7  755e5a                            cmp     #5Ah, r14 ; 'Z'
FFF3D6BA  212f                              bne.b   loc_FFF3D6E9
FFF3D6BC  b809                              movu.w  8+var_6[sp], r1
FFF3D6BE  751124                            mul     #24h, r1 ; '$'
FFF3D6C1  fb2260840600                      mov.l   #68460h, r2
FFF3D6C7  4b12                              add     r1, r2
FFF3D6C9  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D6CF  5ce1                              movu.w  [r14], r1
FFF3D6D1  751124                            mul     #24h, r1 ; '$'
FFF3D6D4  0689e102                          add     8[r14].l, r1
FFF3D6D8  754324                            mov.l   #24h, r3 ; '$'
FFF3D6DB  7f8f                              smovf
FFF3D6DD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D6E3  dcef                              mov.w   [r14], r15
FFF3D6E5  621f                              add     #1, r15
FFF3D6E7  d3ef                              mov.w   r15, [r14]
FFF3D6E9  9809                   loc_FFF3D6E9 mov.w   8+var_6[sp], r1
FFF3D6EB  6211                              add     #1, r1
FFF3D6ED  9009                              mov.w   r1, 8+var_6[sp]
FFF3D6EF  fbe234250100           loc_FFF3D6EF mov.l   #12534h, r14
FFF3D6F5  b809                              movu.w  8+var_6[sp], r1
FFF3D6F7  06c5e101                          cmp     2[r14].uw, r1
FFF3D6FB  29ad                              blt.b   loc_FFF3D6A8
FFF3D6FD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D703  5cee                              movu.w  [r14], r14
FFF3D705  610e                              cmp     #0, r14
FFF3D707  3a7601                            beq.w   loc_FFF3D87D
FFF3D70A  fb12f0840600                      mov.l   #684F0h, r1
FFF3D710  3d1101                            mov.w   #1, 2[r1]
FFF3D713  fbe25f080100                      mov.l   #1085Fh, r14
FFF3D719  f8e405                            mov.b   #5, [r14]
FFF3D71C  fb12f0840600                      mov.l   #684F0h, r1
FFF3D722  3d1200                            mov.w   #0, 4[r1]
FFF3D725  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D728  384501                            bra.w   loc_FFF3D86D
FFF3D72B  fb1262080100           loc_FFF3D72B mov.l   #10862h, r1
FFF3D731  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D737  e0e1                              mov.l   [r14], [r1]
FFF3D739  fb22f0840600                      mov.l   #684F0h, r2
FFF3D73F  a8a2                              mov.l   8[r2], r2
FFF3D741  a8a4                              mov.l   8[r2], r4
FFF3D743  fb36ff                            mov.l   #-1, r3
FFF3D746  6602                              mov.l   #0, r2
FFF3D748  7f80                              suntil.b
FFF3D74A  6011                              sub     #1, r1
FFF3D74C  ef42                              mov.l   r4, r2
FFF3D74E  7f87                              smovu
FFF3D750  fbe6ff                            mov.l   #-1, r14
FFF3D753  660f                              mov.l   #0, r15
FFF3D755  fb5262080100                      mov.l   #10862h, r5
FFF3D75B  ef51                              mov.l   r5, r1
FFF3D75D  eff2                              mov.l   r15, r2
FFF3D75F  efe3                              mov.l   r14, r3
FFF3D761  7f80                              suntil.b
FFF3D763  6011                              sub     #1, r1
FFF3D765  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3D76B  7f87                              smovu
FFF3D76D  fb12f0840600                      mov.l   #684F0h, r1
FFF3D773  a891                              mov.l   8[r1], r1
FFF3D775  a89c                              mov.l   0Ch[r1], r4
FFF3D777  ef51                              mov.l   r5, r1
FFF3D779  eff2                              mov.l   r15, r2
FFF3D77B  efe3                              mov.l   r14, r3
FFF3D77D  7f80                              suntil.b
FFF3D77F  6011                              sub     #1, r1
FFF3D781  ef42                              mov.l   r4, r2
FFF3D783  7f87                              smovu
FFF3D785  fb12f0840600                      mov.l   #684F0h, r1
FFF3D78B  9892                              mov.w   4[r1], r2
FFF3D78D  6212                              add     #1, r2
FFF3D78F  9092                              mov.w   r2, 4[r1]
FFF3D791  fb1258250100                      mov.l   #12558h, r1
FFF3D797  6602                              mov.l   #0, r2
FFF3D799  9212                              mov.w   r2, 10h[r1]
FFF3D79B  a09a                              mov.l   r2, 0Ch[r1]
FFF3D79D  a092                              mov.l   r2, 8[r1]
FFF3D79F  a01a                              mov.l   r2, 4[r1]
FFF3D7A1  e312                              mov.l   r2, [r1]
FFF3D7A3  754312                            mov.l   #12h, r3
FFF3D7A6  fb2246250100                      mov.l   #12546h, r2
FFF3D7AC  fb1258250100                      mov.l   #12558h, r1
FFF3D7B2  7f8f                              smovf
FFF3D7B4  fb12f0840600                      mov.l   #684F0h, r1
FFF3D7BA  a891                              mov.l   8[r1], r1
FFF3D7BC  a99a                              mov.l   1Ch[r1], r2
FFF3D7BE  fb3287d8f3ff                      mov.l   #sub_FFF3D887, r3
FFF3D7C4  fb1262080100                      mov.l   #10862h, r1
FFF3D7CA  05e059fd                          bsr.a   sub_FFF131AA
FFF3D7CE  9081                              mov.w   r1, 8+var_4[sp]
FFF3D7D0  b881                              movu.w  8+var_4[sp], r1
FFF3D7D2  6101                              cmp     #0, r1
FFF3D7D4  3aa900                            beq.w   loc_FFF3D87D
FFF3D7D7  fbe258250100                      mov.l   #12558h, r14
FFF3D7DD  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D7E2  fb1258250100                      mov.l   #12558h, r1
FFF3D7E8  3d1090                            mov.w   #-70h, [r1]
FFF3D7EB  fb1258250100                      mov.l   #12558h, r1
FFF3D7F1  3d1101                            mov.w   #1, 2[r1]
FFF3D7F4  fbe258250100                      mov.l   #12558h, r14
FFF3D7FA  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D800  d4fe02                            mov.w   [r15], 4[r14]
FFF3D803  fb12f0840600                      mov.l   #684F0h, r1
FFF3D809  a891                              mov.l   8[r1], r1
FFF3D80B  3d1c00                            mov.w   #0, 18h[r1]
FFF3D80E  fb12f0840600                      mov.l   #684F0h, r1
FFF3D814  a894                              mov.l   8[r1], r4
FFF3D816  7100c8                            add     #-38h, sp, sp
FFF3D819  754312                            mov.l   #12h, r3
FFF3D81C  fb2258250100                      mov.l   #12558h, r2
FFF3D822  ef01                              mov.l   sp, r1
FFF3D824  7f8f                              smovf
FFF3D826  ef01                              mov.l   sp, r1
FFF3D828  711114                            add     #14h, r1, r1
FFF3D82B  754324                            mov.l   #24h, r3 ; '$'
FFF3D82E  ef42                              mov.l   r4, r2
FFF3D830  7f8f                              smovf
FFF3D832  6602                              mov.l   #0, r2
FFF3D834  7541fe                            mov.l   #-2, r1
FFF3D837  05a500fa                          bsr.a   sub_FFEDD8DC
FFF3D83B  710038                            add     #38h, sp, sp ; '8'
FFF3D83E  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D844  5cef                              movu.w  [r14], r15
FFF3D846  06c5ef02                          cmp     4[r14].uw, r15
FFF3D84A  211d                              bne.b   loc_FFF3D867
FFF3D84C  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D852  f8e500                            mov.w   #0, [r14]
FFF3D855  fb12f0840600                      mov.l   #684F0h, r1
FFF3D85B  3d1200                            mov.w   #0, 4[r1]
FFF3D85E  fb12f0840600                      mov.l   #684F0h, r1
FFF3D864  3d1100                            mov.w   #0, 2[r1]
FFF3D867  9809                   loc_FFF3D867 mov.w   8+var_6[sp], r1
FFF3D869  6211                              add     #1, r1
FFF3D86B  9009                              mov.w   r1, 8+var_6[sp]
FFF3D86D  fbe2f0840600           loc_FFF3D86D mov.l   #684F0h, r14
FFF3D873  b809                              movu.w  8+var_6[sp], r1
FFF3D875  06c4e1                            cmp     [r14].uw, r1
FFF3D878  2805                              bge.b   loc_FFF3D87D
FFF3D87A  38b1fe                            bra.w   loc_FFF3D72B
FFF3D87D  f80500                 loc_FFF3D87D mov.w   #0, 8+var_8[sp]
FFF3D880  d40003                 loc_FFF3D880 mov.w   8+var_8[sp], 8+var_2[sp]
FFF3D883  b889                              movu.w  8+var_2[sp], r1
FFF3D885  6702                              rtsd    #2
FFF3D887  6080                   sub_FFF3D887 sub     #8, sp   ; <<<< FUNC sub_FFF3D887
FFF3D889  9089                              mov.w   r1, 8+var_2[sp]
FFF3D88B  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3D88E  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3D891  f80500                            mov.w   #0, 8+var_8[sp]
FFF3D894  fb1258250100                      mov.l   #12558h, r1
FFF3D89A  6602                              mov.l   #0, r2
FFF3D89C  9212                              mov.w   r2, 10h[r1]
FFF3D89E  a09a                              mov.l   r2, 0Ch[r1]
FFF3D8A0  a092                              mov.l   r2, 8[r1]
FFF3D8A2  a01a                              mov.l   r2, 4[r1]
FFF3D8A4  e312                              mov.l   r2, [r1]
FFF3D8A6  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D8AC  d5e00202                          mov.w   4[r14], 8+var_4[sp]
FFF3D8B0  b889                              movu.w  8+var_2[sp], r1
FFF3D8B2  6101                              cmp     #0, r1
FFF3D8B4  3b8d00                            bne.w   loc_FFF3D941
FFF3D8B7  754312                            mov.l   #12h, r3
FFF3D8BA  fb2246250100                      mov.l   #12546h, r2
FFF3D8C0  fb1258250100                      mov.l   #12558h, r1
FFF3D8C6  7f8f                              smovf
FFF3D8C8  fb1258250100                      mov.l   #12558h, r1
FFF3D8CE  3d1300                            mov.w   #0, 6[r1]
FFF3D8D1  b881                              movu.w  8+var_4[sp], r1
FFF3D8D3  6011                              sub     #1, r1
FFF3D8D5  d301                              mov.w   r1, 8+var_8[sp]
FFF3D8D7  fb1258250100                      mov.l   #12558h, r1
FFF3D8DD  3d1090                            mov.w   #-70h, [r1]
FFF3D8E0  fb1258250100                      mov.l   #12558h, r1
FFF3D8E6  3d1101                            mov.w   #1, 2[r1]
FFF3D8E9  fbe258250100                      mov.l   #12558h, r14
FFF3D8EF  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D8F5  d4fe02                            mov.w   [r15], 4[r14]
FFF3D8F8  5c01                              movu.w  8+var_8[sp], r1
FFF3D8FA  751124                            mul     #24h, r1 ; '$'
FFF3D8FD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D903  0689e102                          add     8[r14].l, r1
FFF3D907  3d1c00                            mov.w   #0, 18h[r1]
FFF3D90A  5c04                              movu.w  8+var_8[sp], r4
FFF3D90C  751424                            mul     #24h, r4 ; '$'
FFF3D90F  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D915  0689e402                          add     8[r14].l, r4
FFF3D919  7100c8                            add     #-38h, sp, sp
FFF3D91C  754312                            mov.l   #12h, r3
FFF3D91F  fb2258250100                      mov.l   #12558h, r2
FFF3D925  ef01                              mov.l   sp, r1
FFF3D927  7f8f                              smovf
FFF3D929  ef01                              mov.l   sp, r1
FFF3D92B  711114                            add     #14h, r1, r1
FFF3D92E  754324                            mov.l   #24h, r3 ; '$'
FFF3D931  ef42                              mov.l   r4, r2
FFF3D933  7f8f                              smovf
FFF3D935  6602                              mov.l   #0, r2
FFF3D937  7541fe                            mov.l   #-2, r1
FFF3D93A  05a2fff9                          bsr.a   sub_FFEDD8DC
FFF3D93E  710038                            add     #38h, sp, sp ; '8'
FFF3D941  b889                   loc_FFF3D941 movu.w  8+var_2[sp], r1
FFF3D943  6111                              cmp     #1, r1
FFF3D945  3b8f00                            bne.w   loc_FFF3D9D4
FFF3D948  754312                            mov.l   #12h, r3
FFF3D94B  fb2246250100                      mov.l   #12546h, r2
FFF3D951  fb1258250100                      mov.l   #12558h, r1
FFF3D957  7f8f                              smovf
FFF3D959  fbe258250100                      mov.l   #12558h, r14
FFF3D95F  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3D964  b881                              movu.w  8+var_4[sp], r1
FFF3D966  6011                              sub     #1, r1
FFF3D968  d301                              mov.w   r1, 8+var_8[sp]
FFF3D96A  fb1258250100                      mov.l   #12558h, r1
FFF3D970  3d1090                            mov.w   #-70h, [r1]
FFF3D973  fb1258250100                      mov.l   #12558h, r1
FFF3D979  3d1101                            mov.w   #1, 2[r1]
FFF3D97C  fbe258250100                      mov.l   #12558h, r14
FFF3D982  fbf26c250100                      mov.l   #1256Ch, r15
FFF3D988  d4fe02                            mov.w   [r15], 4[r14]
FFF3D98B  5c01                              movu.w  8+var_8[sp], r1
FFF3D98D  751124                            mul     #24h, r1 ; '$'
FFF3D990  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D996  0689e102                          add     8[r14].l, r1
FFF3D99A  3d1c00                            mov.w   #0, 18h[r1]
FFF3D99D  5c04                              movu.w  8+var_8[sp], r4
FFF3D99F  751424                            mul     #24h, r4 ; '$'
FFF3D9A2  fbe2f0840600                      mov.l   #684F0h, r14
FFF3D9A8  0689e402                          add     8[r14].l, r4
FFF3D9AC  7100c8                            add     #-38h, sp, sp
FFF3D9AF  754312                            mov.l   #12h, r3
FFF3D9B2  fb2258250100                      mov.l   #12558h, r2
FFF3D9B8  ef01                              mov.l   sp, r1
FFF3D9BA  7f8f                              smovf
FFF3D9BC  ef01                              mov.l   sp, r1
FFF3D9BE  711114                            add     #14h, r1, r1
FFF3D9C1  754324                            mov.l   #24h, r3 ; '$'
FFF3D9C4  ef42                              mov.l   r4, r2
FFF3D9C6  7f8f                              smovf
FFF3D9C8  6602                              mov.l   #0, r2
FFF3D9CA  7541fe                            mov.l   #-2, r1
FFF3D9CD  050ffff9                          bsr.a   sub_FFEDD8DC
FFF3D9D1  710038                            add     #38h, sp, sp ; '8'
FFF3D9D4  fbe2f0840600           loc_FFF3D9D4 mov.l   #684F0h, r14
FFF3D9DA  b881                              movu.w  8+var_4[sp], r1
FFF3D9DC  06c4e1                            cmp     [r14].uw, r1
FFF3D9DF  2905                              blt.b   loc_FFF3D9E4
FFF3D9E1  386e01                            bra.w   loc_FFF3DB4F
FFF3D9E4  d10002                 loc_FFF3D9E4 mov.w   8+var_4[sp], 8+var_8[sp]
FFF3D9E7  385601                            bra.w   loc_FFF3DB3D
FFF3D9EA  fb1262080100           loc_FFF3D9EA mov.l   #10862h, r1
FFF3D9F0  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3D9F6  e0e1                              mov.l   [r14], [r1]
FFF3D9F8  5c02                              movu.w  8+var_8[sp], r2
FFF3D9FA  751224                            mul     #24h, r2 ; '$'
FFF3D9FD  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DA03  0689e202                          add     8[r14].l, r2
FFF3DA07  a8a4                              mov.l   8[r2], r4
FFF3DA09  fb36ff                            mov.l   #-1, r3
FFF3DA0C  6602                              mov.l   #0, r2
FFF3DA0E  7f80                              suntil.b
FFF3DA10  6011                              sub     #1, r1
FFF3DA12  ef42                              mov.l   r4, r2
FFF3DA14  7f87                              smovu
FFF3DA16  fbe6ff                            mov.l   #-1, r14
FFF3DA19  660f                              mov.l   #0, r15
FFF3DA1B  fb5262080100                      mov.l   #10862h, r5
FFF3DA21  ef51                              mov.l   r5, r1
FFF3DA23  eff2                              mov.l   r15, r2
FFF3DA25  efe3                              mov.l   r14, r3
FFF3DA27  7f80                              suntil.b
FFF3DA29  6011                              sub     #1, r1
FFF3DA2B  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3DA31  7f87                              smovu
FFF3DA33  5c01                              movu.w  8+var_8[sp], r1
FFF3DA35  751124                            mul     #24h, r1 ; '$'
FFF3DA38  fb42f0840600                      mov.l   #684F0h, r4
FFF3DA3E  06894102                          add     8[r4].l, r1
FFF3DA42  a89c                              mov.l   0Ch[r1], r4
FFF3DA44  ef51                              mov.l   r5, r1
FFF3DA46  eff2                              mov.l   r15, r2
FFF3DA48  efe3                              mov.l   r14, r3
FFF3DA4A  7f80                              suntil.b
FFF3DA4C  6011                              sub     #1, r1
FFF3DA4E  ef42                              mov.l   r4, r2
FFF3DA50  7f87                              smovu
FFF3DA52  fb12f0840600                      mov.l   #684F0h, r1
FFF3DA58  9892                              mov.w   4[r1], r2
FFF3DA5A  6212                              add     #1, r2
FFF3DA5C  9092                              mov.w   r2, 4[r1]
FFF3DA5E  754312                            mov.l   #12h, r3
FFF3DA61  fb2246250100                      mov.l   #12546h, r2
FFF3DA67  fb1258250100                      mov.l   #12558h, r1
FFF3DA6D  7f8f                              smovf
FFF3DA6F  5c01                              movu.w  8+var_8[sp], r1
FFF3DA71  751124                            mul     #24h, r1 ; '$'
FFF3DA74  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DA7A  0689e102                          add     8[r14].l, r1
FFF3DA7E  a99a                              mov.l   1Ch[r1], r2
FFF3DA80  fb3287d8f3ff                      mov.l   #sub_FFF3D887, r3
FFF3DA86  fb1262080100                      mov.l   #10862h, r1
FFF3DA8C  051e57fd                          bsr.a   sub_FFF131AA
FFF3DA90  9009                              mov.w   r1, 8+var_6[sp]
FFF3DA92  b809                              movu.w  8+var_6[sp], r1
FFF3DA94  6101                              cmp     #0, r1
FFF3DA96  3ad600                            beq.w   loc_FFF3DB6C
FFF3DA99  fbe258250100                      mov.l   #12558h, r14
FFF3DA9F  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3DAA4  fb1258250100                      mov.l   #12558h, r1
FFF3DAAA  3d1090                            mov.w   #-70h, [r1]
FFF3DAAD  fb1258250100                      mov.l   #12558h, r1
FFF3DAB3  3d1101                            mov.w   #1, 2[r1]
FFF3DAB6  fbe258250100                      mov.l   #12558h, r14
FFF3DABC  fbf26c250100                      mov.l   #1256Ch, r15
FFF3DAC2  d4fe02                            mov.w   [r15], 4[r14]
FFF3DAC5  5c01                              movu.w  8+var_8[sp], r1
FFF3DAC7  751124                            mul     #24h, r1 ; '$'
FFF3DACA  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DAD0  0689e102                          add     8[r14].l, r1
FFF3DAD4  3d1c00                            mov.w   #0, 18h[r1]
FFF3DAD7  5c04                              movu.w  8+var_8[sp], r4
FFF3DAD9  751424                            mul     #24h, r4 ; '$'
FFF3DADC  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DAE2  0689e402                          add     8[r14].l, r4
FFF3DAE6  7100c8                            add     #-38h, sp, sp
FFF3DAE9  754312                            mov.l   #12h, r3
FFF3DAEC  fb2258250100                      mov.l   #12558h, r2
FFF3DAF2  ef01                              mov.l   sp, r1
FFF3DAF4  7f8f                              smovf
FFF3DAF6  ef01                              mov.l   sp, r1
FFF3DAF8  711114                            add     #14h, r1, r1
FFF3DAFB  754324                            mov.l   #24h, r3 ; '$'
FFF3DAFE  ef42                              mov.l   r4, r2
FFF3DB00  7f8f                              smovf
FFF3DB02  6602                              mov.l   #0, r2
FFF3DB04  7541fe                            mov.l   #-2, r1
FFF3DB07  05d5fdf9                          bsr.a   sub_FFEDD8DC
FFF3DB0B  710038                            add     #38h, sp, sp ; '8'
FFF3DB0E  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DB14  5cef                              movu.w  [r14], r15
FFF3DB16  06c5ef02                          cmp     4[r14].uw, r15
FFF3DB1A  211d                              bne.b   loc_FFF3DB37
FFF3DB1C  fbe2f0840600                      mov.l   #684F0h, r14
FFF3DB22  f8e500                            mov.w   #0, [r14]
FFF3DB25  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB2B  3d1200                            mov.w   #0, 4[r1]
FFF3DB2E  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB34  3d1100                            mov.w   #0, 2[r1]
FFF3DB37  dc01                   loc_FFF3DB37 mov.w   8+var_8[sp], r1
FFF3DB39  6211                              add     #1, r1
FFF3DB3B  d301                              mov.w   r1, 8+var_8[sp]
FFF3DB3D  fbe2f0840600           loc_FFF3DB3D mov.l   #684F0h, r14
FFF3DB43  5c01                              movu.w  8+var_8[sp], r1
FFF3DB45  06c4e1                            cmp     [r14].uw, r1
FFF3DB48  2805                              bge.b   loc_FFF3DB4D
FFF3DB4A  38a0fe                            bra.w   loc_FFF3D9EA
FFF3DB4D  2e1f                   loc_FFF3DB4D bra.b   loc_FFF3DB6C
FFF3DB4F  fbe2f0840600           loc_FFF3DB4F mov.l   #684F0h, r14
FFF3DB55  f8e500                            mov.w   #0, [r14]
FFF3DB58  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB5E  3d1200                            mov.w   #0, 4[r1]
FFF3DB61  fb12f0840600                      mov.l   #684F0h, r1
FFF3DB67  3d1100                            mov.w   #0, 2[r1]
FFF3DB6A  6702                              rtsd    #2
FFF3DB6C  6702                   loc_FFF3DB6C rtsd    #2
FFF3DB6E  7100f0                 sub_FFF3DB6E add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3DB6E
FFF3DB71  6601                              mov.l   #0, r1
FFF3DB73  9181                              mov.w   r1, 10h+var_4[sp]
FFF3DB75  9109                              mov.w   r1, 10h+var_6[sp]
FFF3DB77  9101                              mov.w   r1, 10h+var_8[sp]
FFF3DB79  fb1258250100                      mov.l   #12558h, r1
FFF3DB7F  6602                              mov.l   #0, r2
FFF3DB81  9212                              mov.w   r2, 10h[r1]
FFF3DB83  a09a                              mov.l   r2, 0Ch[r1]
FFF3DB85  a092                              mov.l   r2, 8[r1]
FFF3DB87  a01a                              mov.l   r2, 4[r1]
FFF3DB89  e312                              mov.l   r2, [r1]
FFF3DB8B  3d0600                            mov.w   #0, 10h+var_4[sp]
FFF3DB8E  2e4b                              bra.b   loc_FFF3DBD9
FFF3DB90  b981                   loc_FFF3DB90 movu.w  10h+var_4[sp], r1
FFF3DB92  751124                            mul     #24h, r1 ; '$'
FFF3DB95  fb22d0830600                      mov.l   #683D0h, r2
FFF3DB9B  4b12                              add     r1, r2
FFF3DB9D  b829                              movu.w  2[r2], r1
FFF3DB9F  6121                              cmp     #2, r1
FFF3DBA1  2014                              beq.b   loc_FFF3DBB5
FFF3DBA3  b981                              movu.w  10h+var_4[sp], r1
FFF3DBA5  751124                            mul     #24h, r1 ; '$'
FFF3DBA8  fb22d0830600                      mov.l   #683D0h, r2
FFF3DBAE  4b12                              add     r1, r2
FFF3DBB0  b829                              movu.w  2[r2], r1
FFF3DBB2  6131                              cmp     #3, r1
FFF3DBB4  1d                                bne.s   loc_FFF3DBB9
FFF3DBB5  f80601                 loc_FFF3DBB5 mov.l   #1, 10h+var_10[sp]
FFF3DBB8  0c                                bra.s   loc_FFF3DBBC
FFF3DBB9  f80600                 loc_FFF3DBB9 mov.l   #0, 10h+var_10[sp]
FFF3DBBC  ec01                   loc_FFF3DBBC mov.l   10h+var_10[sp], r1
FFF3DBBE  6101                              cmp     #0, r1
FFF3DBC0  2013                              beq.b   loc_FFF3DBD3
FFF3DBC2  9909                              mov.w   10h+var_6[sp], r1
FFF3DBC4  6211                              add     #1, r1
FFF3DBC6  9109                              mov.w   r1, 10h+var_6[sp]
FFF3DBC8  fbe2620c0100                      mov.l   #10C62h, r14
FFF3DBCE  c10e0c                            mov.b   10h+var_4[sp], [r14]
FFF3DBD1  2e16                              bra.b   loc_FFF3DBE7
FFF3DBD3  9981                   loc_FFF3DBD3 mov.w   10h+var_4[sp], r1
FFF3DBD5  6211                              add     #1, r1
FFF3DBD7  9181                              mov.w   r1, 10h+var_4[sp]
FFF3DBD9  fbe234250100           loc_FFF3DBD9 mov.l   #12534h, r14
FFF3DBDF  b981                              movu.w  10h+var_4[sp], r1
FFF3DBE1  06c5e101                          cmp     2[r14].uw, r1
FFF3DBE5  29ab                              blt.b   loc_FFF3DB90
FFF3DBE7  b909                   loc_FFF3DBE7 movu.w  10h+var_6[sp], r1
FFF3DBE9  6101                              cmp     #0, r1
FFF3DBEB  3a7202                            beq.w   loc_FFF3DE5D
FFF3DBEE  fbe25f080100                      mov.l   #1085Fh, r14
FFF3DBF4  58ee                              movu.b  [r14], r14
FFF3DBF6  610e                              cmp     #0, r14
FFF3DBF8  2011                              beq.b   loc_FFF3DC09
FFF3DBFA  fbe25f080100                      mov.l   #1085Fh, r14
FFF3DC00  58ee                              movu.b  [r14], r14
FFF3DC02  61ce                              cmp     #0Ch, r14
FFF3DC04  15                                beq.s   loc_FFF3DC09
FFF3DC05  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3DC08  0c                                bra.s   loc_FFF3DC0C
FFF3DC09  f80600                 loc_FFF3DC09 mov.l   #0, 10h+var_10[sp]
FFF3DC0C  ec01                   loc_FFF3DC0C mov.l   10h+var_10[sp], r1
FFF3DC0E  6101                              cmp     #0, r1
FFF3DC10  2011                              beq.b   loc_FFF3DC21
FFF3DC12  fbe25f080100                      mov.l   #1085Fh, r14
FFF3DC18  58ee                              movu.b  [r14], r14
FFF3DC1A  61de                              cmp     #0Dh, r14
FFF3DC1C  15                                beq.s   loc_FFF3DC21
FFF3DC1D  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3DC20  0c                                bra.s   loc_FFF3DC24
FFF3DC21  f80600                 loc_FFF3DC21 mov.l   #0, 10h+var_10[sp]
FFF3DC24  ec01                   loc_FFF3DC24 mov.l   10h+var_10[sp], r1
FFF3DC26  6101                              cmp     #0, r1
FFF3DC28  2011                              beq.b   loc_FFF3DC39
FFF3DC2A  fbe25f080100                      mov.l   #1085Fh, r14
FFF3DC30  58ee                              movu.b  [r14], r14
FFF3DC32  614e                              cmp     #4, r14
FFF3DC34  15                                beq.s   loc_FFF3DC39
FFF3DC35  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3DC38  0c                                bra.s   loc_FFF3DC3C
FFF3DC39  f80600                 loc_FFF3DC39 mov.l   #0, 10h+var_10[sp]
FFF3DC3C  ec01                   loc_FFF3DC3C mov.l   10h+var_10[sp], r1
FFF3DC3E  6101                              cmp     #0, r1
FFF3DC40  3a9700                            beq.w   loc_FFF3DCD7
FFF3DC43  754312                            mov.l   #12h, r3
FFF3DC46  fb2234250100                      mov.l   #12534h, r2
FFF3DC4C  fb1258250100                      mov.l   #12558h, r1
FFF3DC52  7f8f                              smovf
FFF3DC54  fbe258250100                      mov.l   #12558h, r14
FFF3DC5A  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3DC5F  fb1258250100                      mov.l   #12558h, r1
FFF3DC65  3d1090                            mov.w   #-70h, [r1]
FFF3DC68  fb1258250100                      mov.l   #12558h, r1
FFF3DC6E  3d1101                            mov.w   #1, 2[r1]
FFF3DC71  fbe258250100                      mov.l   #12558h, r14
FFF3DC77  fbf26c250100                      mov.l   #1256Ch, r15
FFF3DC7D  d4fe02                            mov.w   [r15], 4[r14]
FFF3DC80  fbe2620c0100                      mov.l   #10C62h, r14
FFF3DC86  58ee                              movu.b  [r14], r14
FFF3DC88  751e24                            mul     #24h, r14 ; '$'
FFF3DC8B  fb12d0830600                      mov.l   #683D0h, r1
FFF3DC91  4be1                              add     r14, r1
FFF3DC93  3d1c00                            mov.w   #0, 18h[r1]
FFF3DC96  fbe2620c0100                      mov.l   #10C62h, r14
FFF3DC9C  58ee                              movu.b  [r14], r14
FFF3DC9E  7100c8                            add     #-38h, sp, sp
FFF3DCA1  754312                            mov.l   #12h, r3
FFF3DCA4  fb2258250100                      mov.l   #12558h, r2
FFF3DCAA  ef01                              mov.l   sp, r1
FFF3DCAC  7f8f                              smovf
FFF3DCAE  751e24                            mul     #24h, r14 ; '$'
FFF3DCB1  fb22d0830600                      mov.l   #683D0h, r2
FFF3DCB7  4be2                              add     r14, r2
FFF3DCB9  ef01                              mov.l   sp, r1
FFF3DCBB  711114                            add     #14h, r1, r1
FFF3DCBE  754324                            mov.l   #24h, r3 ; '$'
FFF3DCC1  7f8f                              smovf
FFF3DCC3  6602                              mov.l   #0, r2
FFF3DCC5  7541fe                            mov.l   #-2, r1
FFF3DCC8  0514fcf9                          bsr.a   sub_FFEDD8DC
FFF3DCCC  710038                            add     #38h, sp, sp ; '8'
FFF3DCCF  f90903ffff                        mov.w   #-1, 10h+var_A[sp]
FFF3DCD4  388e01                            bra.w   loc_FFF3DE62
FFF3DCD7  fbe261080100           loc_FFF3DCD7 mov.l   #10861h, r14
FFF3DCDD  58ee                              movu.b  [r14], r14
FFF3DCDF  611e                              cmp     #1, r14
FFF3DCE1  200d                              beq.b   loc_FFF3DCEE
FFF3DCE3  fbe26e250100                      mov.l   #1256Eh, r14
FFF3DCE9  5cee                              movu.w  [r14], r14
FFF3DCEB  610e                              cmp     #0, r14
FFF3DCED  1d                                bne.s   loc_FFF3DCF2
FFF3DCEE  f80601                 loc_FFF3DCEE mov.l   #1, 10h+var_10[sp]
FFF3DCF1  0c                                bra.s   loc_FFF3DCF5
FFF3DCF2  f80600                 loc_FFF3DCF2 mov.l   #0, 10h+var_10[sp]
FFF3DCF5  ec01                   loc_FFF3DCF5 mov.l   10h+var_10[sp], r1
FFF3DCF7  6101                              cmp     #0, r1
FFF3DCF9  3a9700                            beq.w   loc_FFF3DD90
FFF3DCFC  754312                            mov.l   #12h, r3
FFF3DCFF  fb2234250100                      mov.l   #12534h, r2
FFF3DD05  fb1258250100                      mov.l   #12558h, r1
FFF3DD0B  7f8f                              smovf
FFF3DD0D  fbe258250100                      mov.l   #12558h, r14
FFF3DD13  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3DD18  fb1258250100                      mov.l   #12558h, r1
FFF3DD1E  3d1090                            mov.w   #-70h, [r1]
FFF3DD21  fb1258250100                      mov.l   #12558h, r1
FFF3DD27  3d1101                            mov.w   #1, 2[r1]
FFF3DD2A  fbe258250100                      mov.l   #12558h, r14
FFF3DD30  fbf26c250100                      mov.l   #1256Ch, r15
FFF3DD36  d4fe02                            mov.w   [r15], 4[r14]
FFF3DD39  fbe2620c0100                      mov.l   #10C62h, r14
FFF3DD3F  58ee                              movu.b  [r14], r14
FFF3DD41  751e24                            mul     #24h, r14 ; '$'
FFF3DD44  fb12d0830600                      mov.l   #683D0h, r1
FFF3DD4A  4be1                              add     r14, r1
FFF3DD4C  3d1c00                            mov.w   #0, 18h[r1]
FFF3DD4F  fbe2620c0100                      mov.l   #10C62h, r14
FFF3DD55  58ee                              movu.b  [r14], r14
FFF3DD57  7100c8                            add     #-38h, sp, sp
FFF3DD5A  754312                            mov.l   #12h, r3
FFF3DD5D  fb2258250100                      mov.l   #12558h, r2
FFF3DD63  ef01                              mov.l   sp, r1
FFF3DD65  7f8f                              smovf
FFF3DD67  751e24                            mul     #24h, r14 ; '$'
FFF3DD6A  fb22d0830600                      mov.l   #683D0h, r2
FFF3DD70  4be2                              add     r14, r2
FFF3DD72  ef01                              mov.l   sp, r1
FFF3DD74  711114                            add     #14h, r1, r1
FFF3DD77  754324                            mov.l   #24h, r3 ; '$'
FFF3DD7A  7f8f                              smovf
FFF3DD7C  6602                              mov.l   #0, r2
FFF3DD7E  7541fe                            mov.l   #-2, r1
FFF3DD81  055bfbf9                          bsr.a   sub_FFEDD8DC
FFF3DD85  710038                            add     #38h, sp, sp ; '8'
FFF3DD88  f90903ffff                        mov.w   #-1, 10h+var_A[sp]
FFF3DD8D  38d500                            bra.w   loc_FFF3DE62
FFF3DD90  fbe2620c0100           loc_FFF3DD90 mov.l   #10C62h, r14
FFF3DD96  58ee                              movu.b  [r14], r14
FFF3DD98  751e24                            mul     #24h, r14 ; '$'
FFF3DD9B  fb12d0830600                      mov.l   #683D0h, r1
FFF3DDA1  4be1                              add     r14, r1
FFF3DDA3  b819                              movu.w  2[r1], r1
FFF3DDA5  6131                              cmp     #3, r1
FFF3DDA7  205e                              beq.b   loc_FFF3DE05
FFF3DDA9  6121                              cmp     #2, r1
FFF3DDAB  3bae00                            bne.w   loc_FFF3DE59
FFF3DDAE  fbe2620c0100                      mov.l   #10C62h, r14
FFF3DDB4  58ee                              movu.b  [r14], r14
FFF3DDB6  7100dc                            add     #-24h, sp, sp
FFF3DDB9  751e24                            mul     #24h, r14 ; '$'
FFF3DDBC  fb22d0830600                      mov.l   #683D0h, r2
FFF3DDC2  4be2                              add     r14, r2
FFF3DDC4  754324                            mov.l   #24h, r3 ; '$'
FFF3DDC7  ef01                              mov.l   sp, r1
FFF3DDC9  7f8f                              smovf
FFF3DDCB  399f00                            bsr.w   sub_FFF3DE6A
FFF3DDCE  710024                            add     #24h, sp, sp ; '$'
FFF3DDD1  9101                              mov.w   r1, 10h+var_8[sp]
FFF3DDD3  b901                              movu.w  10h+var_8[sp], r1
FFF3DDD5  6101                              cmp     #0, r1
FFF3DDD7  3b8200                            bne.w   loc_FFF3DE59
FFF3DDDA  fbe26e250100                      mov.l   #1256Eh, r14
FFF3DDE0  5ce2                              movu.w  [r14], r2
FFF3DDE2  6661                              mov.l   #6, r1
FFF3DDE4  05f4c0ff                          bsr.a   sub_FFF39ED8
FFF3DDE8  fbe2640c0100                      mov.l   #10C64h, r14
FFF3DDEE  f8e401                            mov.b   #1, [r14]
FFF3DDF1  fbe261080100                      mov.l   #10861h, r14
FFF3DDF7  f8e401                            mov.b   #1, [r14]
FFF3DDFA  fbe25f080100                      mov.l   #1085Fh, r14
FFF3DE00  f8e405                            mov.b   #5, [r14]
FFF3DE03  2e56                              bra.b   loc_FFF3DE59
FFF3DE05  fbe2620c0100           loc_FFF3DE05 mov.l   #10C62h, r14
FFF3DE0B  58ee                              movu.b  [r14], r14
FFF3DE0D  7100dc                            add     #-24h, sp, sp
FFF3DE10  751e24                            mul     #24h, r14 ; '$'
FFF3DE13  fb22d0830600                      mov.l   #683D0h, r2
FFF3DE19  4be2                              add     r14, r2
FFF3DE1B  754324                            mov.l   #24h, r3 ; '$'
FFF3DE1E  ef01                              mov.l   sp, r1
FFF3DE20  7f8f                              smovf
FFF3DE22  394401                            bsr.w   sub_FFF3DF66
FFF3DE25  710024                            add     #24h, sp, sp ; '$'
FFF3DE28  9101                              mov.w   r1, 10h+var_8[sp]
FFF3DE2A  b901                              movu.w  10h+var_8[sp], r1
FFF3DE2C  6101                              cmp     #0, r1
FFF3DE2E  212b                              bne.b   loc_FFF3DE59
FFF3DE30  fbe26e250100                      mov.l   #1256Eh, r14
FFF3DE36  5ce2                              movu.w  [r14], r2
FFF3DE38  6661                              mov.l   #6, r1
FFF3DE3A  059ec0ff                          bsr.a   sub_FFF39ED8
FFF3DE3E  fbe2640c0100                      mov.l   #10C64h, r14
FFF3DE44  f8e401                            mov.b   #1, [r14]
FFF3DE47  fbe261080100                      mov.l   #10861h, r14
FFF3DE4D  f8e401                            mov.b   #1, [r14]
FFF3DE50  fbe25f080100                      mov.l   #1085Fh, r14
FFF3DE56  f8e405                            mov.b   #5, [r14]
FFF3DE59  3d0300                 loc_FFF3DE59 mov.w   #0, 10h+var_A[sp]
FFF3DE5C  0e                                bra.s   loc_FFF3DE62
FFF3DE5D  f90903ffff             loc_FFF3DE5D mov.w   #-1, 10h+var_A[sp]
FFF3DE62  d5000307               loc_FFF3DE62 mov.w   10h+var_A[sp], 10h+var_2[sp]
FFF3DE66  b989                              movu.w  10h+var_2[sp], r1
FFF3DE68  6704                              rtsd    #4
FFF3DE6A  7ea6                   sub_FFF3DE6A push.l  r6   ; <<<< FUNC sub_FFF3DE6A
FFF3DE6C  6040                              sub     #4, sp
FFF3DE6E  f80500                            mov.w   #0, 4+var_4[sp]
FFF3DE71  71060c                            add     #4+arg_0, sp, r6
FFF3DE74  fb1258250100                      mov.l   #12558h, r1
FFF3DE7A  6602                              mov.l   #0, r2
FFF3DE7C  9212                              mov.w   r2, 10h[r1]
FFF3DE7E  a09a                              mov.l   r2, 0Ch[r1]
FFF3DE80  a092                              mov.l   r2, 8[r1]
FFF3DE82  a01a                              mov.l   r2, 4[r1]
FFF3DE84  e312                              mov.l   r2, [r1]
FFF3DE86  fb1262080100                      mov.l   #10862h, r1
FFF3DE8C  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3DE92  e0e1                              mov.l   [r14], [r1]
FFF3DE94  a8e4                              mov.l   8[r6], r4
FFF3DE96  fb36ff                            mov.l   #-1, r3
FFF3DE99  6602                              mov.l   #0, r2
FFF3DE9B  7f80                              suntil.b
FFF3DE9D  6011                              sub     #1, r1
FFF3DE9F  ef42                              mov.l   r4, r2
FFF3DEA1  7f87                              smovu
FFF3DEA3  fbe6ff                            mov.l   #-1, r14
FFF3DEA6  660f                              mov.l   #0, r15
FFF3DEA8  fb5262080100                      mov.l   #10862h, r5
FFF3DEAE  ef51                              mov.l   r5, r1
FFF3DEB0  eff2                              mov.l   r15, r2
FFF3DEB2  efe3                              mov.l   r14, r3
FFF3DEB4  7f80                              suntil.b
FFF3DEB6  6011                              sub     #1, r1
FFF3DEB8  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3DEBE  7f87                              smovu
FFF3DEC0  a8ec                              mov.l   0Ch[r6], r4
FFF3DEC2  ef51                              mov.l   r5, r1
FFF3DEC4  eff2                              mov.l   r15, r2
FFF3DEC6  efe3                              mov.l   r14, r3
FFF3DEC8  7f80                              suntil.b
FFF3DECA  6011                              sub     #1, r1
FFF3DECC  ef42                              mov.l   r4, r2
FFF3DECE  7f87                              smovu
FFF3DED0  754312                            mov.l   #12h, r3
FFF3DED3  fb2234250100                      mov.l   #12534h, r2
FFF3DED9  fb1258250100                      mov.l   #12558h, r1
FFF3DEDF  7f8f                              smovf
FFF3DEE1  fb3262e0f3ff                      mov.l   #sub_FFF3E062, r3
FFF3DEE7  6602                              mov.l   #0, r2
FFF3DEE9  fb1262080100                      mov.l   #10862h, r1
FFF3DEEF  05306ffd                          bsr.a   sub_FFF14E1F
FFF3DEF3  d301                              mov.w   r1, 4+var_4[sp]
FFF3DEF5  5c01                              movu.w  4+var_4[sp], r1
FFF3DEF7  6101                              cmp     #0, r1
FFF3DEF9  200e                              beq.b   loc_FFF3DF07
FFF3DEFB  fbe258250100                      mov.l   #12558h, r14
FFF3DF01  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3DF06  0a                                bra.s   loc_FFF3DF10
FFF3DF07  fb1258250100           loc_FFF3DF07 mov.l   #12558h, r1
FFF3DF0D  3d1300                            mov.w   #0, 6[r1]
FFF3DF10  fb1258250100           loc_FFF3DF10 mov.l   #12558h, r1
FFF3DF16  3d1090                            mov.w   #-70h, [r1]
FFF3DF19  fb1258250100                      mov.l   #12558h, r1
FFF3DF1F  3d1101                            mov.w   #1, 2[r1]
FFF3DF22  fbe258250100                      mov.l   #12558h, r14
FFF3DF28  fbf26c250100                      mov.l   #1256Ch, r15
FFF3DF2E  d4fe02                            mov.w   [r15], 4[r14]
FFF3DF31  3d6c00                            mov.w   #0, 18h[r6]
FFF3DF34  7100c8                            add     #-38h, sp, sp
FFF3DF37  754312                            mov.l   #12h, r3
FFF3DF3A  fb2258250100                      mov.l   #12558h, r2
FFF3DF40  ef01                              mov.l   sp, r1
FFF3DF42  7f8f                              smovf
FFF3DF44  ef01                              mov.l   sp, r1
FFF3DF46  711114                            add     #14h, r1, r1
FFF3DF49  754324                            mov.l   #24h, r3 ; '$'
FFF3DF4C  ef62                              mov.l   r6, r2
FFF3DF4E  7f8f                              smovf
FFF3DF50  6602                              mov.l   #0, r2
FFF3DF52  7541fe                            mov.l   #-2, r1
FFF3DF55  0587f9f9                          bsr.a   sub_FFEDD8DC
FFF3DF59  710038                            add     #38h, sp, sp ; '8'
FFF3DF5C  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3DF5F  9809                              mov.w   4+var_2[sp], r1
FFF3DF61  5f11                              movu.w  r1, r1
FFF3DF63  3f6602                            rtsd    #8, r6-r6
FFF3DF66  7ea6                   sub_FFF3DF66 push.l  r6   ; <<<< FUNC sub_FFF3DF66
FFF3DF68  6040                              sub     #4, sp
FFF3DF6A  f80500                            mov.w   #0, 4+var_4[sp]
FFF3DF6D  71060c                            add     #4+arg_0, sp, r6
FFF3DF70  fb1258250100                      mov.l   #12558h, r1
FFF3DF76  6602                              mov.l   #0, r2
FFF3DF78  9212                              mov.w   r2, 10h[r1]
FFF3DF7A  a09a                              mov.l   r2, 0Ch[r1]
FFF3DF7C  a092                              mov.l   r2, 8[r1]
FFF3DF7E  a01a                              mov.l   r2, 4[r1]
FFF3DF80  e312                              mov.l   r2, [r1]
FFF3DF82  fb1262080100                      mov.l   #10862h, r1
FFF3DF88  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3DF8E  e0e1                              mov.l   [r14], [r1]
FFF3DF90  a8e4                              mov.l   8[r6], r4
FFF3DF92  fb36ff                            mov.l   #-1, r3
FFF3DF95  6602                              mov.l   #0, r2
FFF3DF97  7f80                              suntil.b
FFF3DF99  6011                              sub     #1, r1
FFF3DF9B  ef42                              mov.l   r4, r2
FFF3DF9D  7f87                              smovu
FFF3DF9F  fbe6ff                            mov.l   #-1, r14
FFF3DFA2  660f                              mov.l   #0, r15
FFF3DFA4  fb5262080100                      mov.l   #10862h, r5
FFF3DFAA  ef51                              mov.l   r5, r1
FFF3DFAC  eff2                              mov.l   r15, r2
FFF3DFAE  efe3                              mov.l   r14, r3
FFF3DFB0  7f80                              suntil.b
FFF3DFB2  6011                              sub     #1, r1
FFF3DFB4  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3DFBA  7f87                              smovu
FFF3DFBC  a8ec                              mov.l   0Ch[r6], r4
FFF3DFBE  ef51                              mov.l   r5, r1
FFF3DFC0  eff2                              mov.l   r15, r2
FFF3DFC2  efe3                              mov.l   r14, r3
FFF3DFC4  7f80                              suntil.b
FFF3DFC6  6011                              sub     #1, r1
FFF3DFC8  ef42                              mov.l   r4, r2
FFF3DFCA  7f87                              smovu
FFF3DFCC  754312                            mov.l   #12h, r3
FFF3DFCF  fb2234250100                      mov.l   #12534h, r2
FFF3DFD5  fb1258250100                      mov.l   #12558h, r1
FFF3DFDB  7f8f                              smovf
FFF3DFDD  fb3262e0f3ff                      mov.l   #sub_FFF3E062, r3
FFF3DFE3  6612                              mov.l   #1, r2
FFF3DFE5  fb1262080100                      mov.l   #10862h, r1
FFF3DFEB  05346efd                          bsr.a   sub_FFF14E1F
FFF3DFEF  d301                              mov.w   r1, 4+var_4[sp]
FFF3DFF1  5c01                              movu.w  4+var_4[sp], r1
FFF3DFF3  6101                              cmp     #0, r1
FFF3DFF5  200e                              beq.b   loc_FFF3E003
FFF3DFF7  fbe234250100                      mov.l   #12534h, r14
FFF3DFFD  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3E002  0a                                bra.s   loc_FFF3E00C
FFF3E003  fb1234250100           loc_FFF3E003 mov.l   #12534h, r1
FFF3E009  3d1300                            mov.w   #0, 6[r1]
FFF3E00C  fb1258250100           loc_FFF3E00C mov.l   #12558h, r1
FFF3E012  3d1090                            mov.w   #-70h, [r1]
FFF3E015  fb1258250100                      mov.l   #12558h, r1
FFF3E01B  3d1101                            mov.w   #1, 2[r1]
FFF3E01E  fbe258250100                      mov.l   #12558h, r14
FFF3E024  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E02A  d4fe02                            mov.w   [r15], 4[r14]
FFF3E02D  3d6c00                            mov.w   #0, 18h[r6]
FFF3E030  7100c8                            add     #-38h, sp, sp
FFF3E033  754312                            mov.l   #12h, r3
FFF3E036  fb2258250100                      mov.l   #12558h, r2
FFF3E03C  ef01                              mov.l   sp, r1
FFF3E03E  7f8f                              smovf
FFF3E040  ef01                              mov.l   sp, r1
FFF3E042  711114                            add     #14h, r1, r1
FFF3E045  754324                            mov.l   #24h, r3 ; '$'
FFF3E048  ef62                              mov.l   r6, r2
FFF3E04A  7f8f                              smovf
FFF3E04C  6602                              mov.l   #0, r2
FFF3E04E  7541fe                            mov.l   #-2, r1
FFF3E051  058bf8f9                          bsr.a   sub_FFEDD8DC
FFF3E055  710038                            add     #38h, sp, sp ; '8'
FFF3E058  d40001                            mov.w   4+var_4[sp], 4+var_2[sp]
FFF3E05B  9809                              mov.w   4+var_2[sp], r1
FFF3E05D  5f11                              movu.w  r1, r1
FFF3E05F  3f6602                            rtsd    #8, r6-r6
FFF3E062  6040                   sub_FFF3E062 sub     #4, sp   ; <<<< FUNC sub_FFF3E062
FFF3E064  9009                              mov.w   r1, 4+var_2[sp]
FFF3E066  fb1258250100                      mov.l   #12558h, r1
FFF3E06C  6602                              mov.l   #0, r2
FFF3E06E  9212                              mov.w   r2, 10h[r1]
FFF3E070  a09a                              mov.l   r2, 0Ch[r1]
FFF3E072  a092                              mov.l   r2, 8[r1]
FFF3E074  a01a                              mov.l   r2, 4[r1]
FFF3E076  e312                              mov.l   r2, [r1]
FFF3E078  fbe261080100                      mov.l   #10861h, r14
FFF3E07E  f8e400                            mov.b   #0, [r14]
FFF3E081  b809                              movu.w  4+var_2[sp], r1
FFF3E083  6121                              cmp     #2, r1
FFF3E085  3ba300                            bne.w   loc_FFF3E128
FFF3E088  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E08E  f8e400                            mov.b   #0, [r14]
FFF3E091  754312                            mov.l   #12h, r3
FFF3E094  fb2234250100                      mov.l   #12534h, r2
FFF3E09A  fb1258250100                      mov.l   #12558h, r1
FFF3E0A0  7f8f                              smovf
FFF3E0A2  fb1258250100                      mov.l   #12558h, r1
FFF3E0A8  3d1090                            mov.w   #-70h, [r1]
FFF3E0AB  fb1258250100                      mov.l   #12558h, r1
FFF3E0B1  3d1101                            mov.w   #1, 2[r1]
FFF3E0B4  fbe258250100                      mov.l   #12558h, r14
FFF3E0BA  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E0C0  d4fe02                            mov.w   [r15], 4[r14]
FFF3E0C3  fbe2620c0100                      mov.l   #10C62h, r14
FFF3E0C9  58ee                              movu.b  [r14], r14
FFF3E0CB  751e24                            mul     #24h, r14 ; '$'
FFF3E0CE  fb12d0830600                      mov.l   #683D0h, r1
FFF3E0D4  4be1                              add     r14, r1
FFF3E0D6  3d1c00                            mov.w   #0, 18h[r1]
FFF3E0D9  fbe2620c0100                      mov.l   #10C62h, r14
FFF3E0DF  58ee                              movu.b  [r14], r14
FFF3E0E1  751e24                            mul     #24h, r14 ; '$'
FFF3E0E4  fb12d0830600                      mov.l   #683D0h, r1
FFF3E0EA  4be1                              add     r14, r1
FFF3E0EC  3d10d2                            mov.w   #-2Eh, [r1]
FFF3E0EF  fbe2620c0100                      mov.l   #10C62h, r14
FFF3E0F5  58ee                              movu.b  [r14], r14
FFF3E0F7  7100c8                            add     #-38h, sp, sp
FFF3E0FA  754312                            mov.l   #12h, r3
FFF3E0FD  fb2258250100                      mov.l   #12558h, r2
FFF3E103  ef01                              mov.l   sp, r1
FFF3E105  7f8f                              smovf
FFF3E107  751e24                            mul     #24h, r14 ; '$'
FFF3E10A  fb22d0830600                      mov.l   #683D0h, r2
FFF3E110  4be2                              add     r14, r2
FFF3E112  ef01                              mov.l   sp, r1
FFF3E114  711114                            add     #14h, r1, r1
FFF3E117  754324                            mov.l   #24h, r3 ; '$'
FFF3E11A  7f8f                              smovf
FFF3E11C  6602                              mov.l   #0, r2
FFF3E11E  7541fe                            mov.l   #-2, r1
FFF3E121  05bbf7f9                          bsr.a   sub_FFEDD8DC
FFF3E125  710038                            add     #38h, sp, sp ; '8'
FFF3E128  b809                   loc_FFF3E128 movu.w  4+var_2[sp], r1
FFF3E12A  6111                              cmp     #1, r1
FFF3E12C  3ba500                            bne.w   loc_FFF3E1D1
FFF3E12F  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E135  f8e400                            mov.b   #0, [r14]
FFF3E138  754312                            mov.l   #12h, r3
FFF3E13B  fb2234250100                      mov.l   #12534h, r2
FFF3E141  fb1258250100                      mov.l   #12558h, r1
FFF3E147  7f8f                              smovf
FFF3E149  fb1258250100                      mov.l   #12558h, r1
FFF3E14F  3d1090                            mov.w   #-70h, [r1]
FFF3E152  fb1258250100                      mov.l   #12558h, r1
FFF3E158  3d1101                            mov.w   #1, 2[r1]
FFF3E15B  fbe258250100                      mov.l   #12558h, r14
FFF3E161  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E167  d4fe02                            mov.w   [r15], 4[r14]
FFF3E16A  fbe2620c0100                      mov.l   #10C62h, r14
FFF3E170  58ee                              movu.b  [r14], r14
FFF3E172  751e24                            mul     #24h, r14 ; '$'
FFF3E175  fb12d0830600                      mov.l   #683D0h, r1
FFF3E17B  4be1                              add     r14, r1
FFF3E17D  3d1c00                            mov.w   #0, 18h[r1]
FFF3E180  fbe2620c0100                      mov.l   #10C62h, r14
FFF3E186  58ee                              movu.b  [r14], r14
FFF3E188  751e24                            mul     #24h, r14 ; '$'
FFF3E18B  fb12d0830600                      mov.l   #683D0h, r1
FFF3E191  4be1                              add     r14, r1
FFF3E193  3d10fb                            mov.w   #-5, [r1]
FFF3E196  fbe2620c0100                      mov.l   #10C62h, r14
FFF3E19C  58ee                              movu.b  [r14], r14
FFF3E19E  7100c8                            add     #-38h, sp, sp
FFF3E1A1  754312                            mov.l   #12h, r3
FFF3E1A4  fb2258250100                      mov.l   #12558h, r2
FFF3E1AA  ef01                              mov.l   sp, r1
FFF3E1AC  7f8f                              smovf
FFF3E1AE  751e24                            mul     #24h, r14 ; '$'
FFF3E1B1  fb22d0830600                      mov.l   #683D0h, r2
FFF3E1B7  4be2                              add     r14, r2
FFF3E1B9  ef01                              mov.l   sp, r1
FFF3E1BB  711114                            add     #14h, r1, r1
FFF3E1BE  754324                            mov.l   #24h, r3 ; '$'
FFF3E1C1  7f8f                              smovf
FFF3E1C3  6602                              mov.l   #0, r2
FFF3E1C5  7541fe                            mov.l   #-2, r1
FFF3E1C8  0514f7f9                          bsr.a   sub_FFEDD8DC
FFF3E1CC  710038                            add     #38h, sp, sp ; '8'
FFF3E1CF  6701                              rtsd    #1
FFF3E1D1  6701                   loc_FFF3E1D1 rtsd    #1
FFF3E1D3  6080                   sub_FFF3E1D3 sub     #8, sp   ; <<<< FUNC sub_FFF3E1D3
FFF3E1D5  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3E1D8  fbe261080100                      mov.l   #10861h, r14
FFF3E1DE  58ee                              movu.b  [r14], r14
FFF3E1E0  610e                              cmp     #0, r14
FFF3E1E2  18                                bne.s   loc_FFF3E1EA
FFF3E1E3  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF3E1E8  2e39                              bra.b   loc_FFF3E221
FFF3E1EA  6661                   loc_FFF3E1EA mov.l   #6, r1
FFF3E1EC  0579bdff                          bsr.a   sub_FFF39F65
FFF3E1F0  fbe2640c0100                      mov.l   #10C64h, r14
FFF3E1F6  f8e400                            mov.b   #0, [r14]
FFF3E1F9  05036dfd                          bsr.a   sub_FFF14EFC
FFF3E1FD  9081                              mov.w   r1, 8+var_4[sp]
FFF3E1FF  b881                              movu.w  8+var_4[sp], r1
FFF3E201  6101                              cmp     #0, r1
FFF3E203  10                                beq.s   loc_FFF3E20B
FFF3E204  f90901ffff                        mov.w   #-1, 8+var_6[sp]
FFF3E209  2e18                              bra.b   loc_FFF3E221
FFF3E20B  fbe261080100           loc_FFF3E20B mov.l   #10861h, r14
FFF3E211  f8e400                            mov.b   #0, [r14]
FFF3E214  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E21A  f8e400                            mov.b   #0, [r14]
FFF3E21D  d5000201                          mov.w   8+var_4[sp], 8+var_6[sp]
FFF3E221  d5000103               loc_FFF3E221 mov.w   8+var_6[sp], 8+var_2[sp]
FFF3E225  b889                              movu.w  8+var_2[sp], r1
FFF3E227  6702                              rtsd    #2
FFF3E229  7ea6                   sub_FFF3E229 push.l  r6   ; <<<< FUNC sub_FFF3E229
FFF3E22B  7100e4                            add     #-1Ch, sp, sp
FFF3E22E  3d0c00                            mov.w   #0, 1Ch+var_4[sp]
FFF3E231  3d0b00                            mov.w   #0, 1Ch+var_6[sp]
FFF3E234  710624                            add     #1Ch+arg_0, sp, r6
FFF3E237  fb1258250100                      mov.l   #12558h, r1
FFF3E23D  6602                              mov.l   #0, r2
FFF3E23F  9212                              mov.w   r2, 10h[r1]
FFF3E241  a09a                              mov.l   r2, 0Ch[r1]
FFF3E243  a092                              mov.l   r2, 8[r1]
FFF3E245  a01a                              mov.l   r2, 4[r1]
FFF3E247  e312                              mov.l   r2, [r1]
FFF3E249  754312                            mov.l   #12h, r3
FFF3E24C  fb2234250100                      mov.l   #12534h, r2
FFF3E252  fb1258250100                      mov.l   #12558h, r1
FFF3E258  7f8f                              smovf
FFF3E25A  ef01                              mov.l   sp, r1
FFF3E25C  05bc48fd                          bsr.a   sub_FFF12B18
FFF3E260  9301                              mov.w   r1, 1Ch+var_4[sp]
FFF3E262  bb01                              movu.w  1Ch+var_4[sp], r1
FFF3E264  6101                              cmp     #0, r1
FFF3E266  200f                              beq.b   loc_FFF3E275
FFF3E268  fbe258250100                      mov.l   #12558h, r14
FFF3E26E  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3E273  2e13                              bra.b   loc_FFF3E286
FFF3E275  fbe26c250100           loc_FFF3E275 mov.l   #1256Ch, r14
FFF3E27B  d00e                              mov.w   1Ch+var_1C[sp], [r14]
FFF3E27D  fb1258250100                      mov.l   #12558h, r1
FFF3E283  3d1300                            mov.w   #0, 6[r1]
FFF3E286  fbe258250100           loc_FFF3E286 mov.l   #12558h, r14
FFF3E28C  d40e02                            mov.w   1Ch+var_1C[sp], 4[r14]
FFF3E28F  3d0b00                            mov.w   #0, 1Ch+var_6[sp]
FFF3E292  5c01                              movu.w  1Ch+var_1C[sp], r1
FFF3E294  6881                              shlr    #8, r1
FFF3E296  aa62                              mov.l   20h[r6], r2
FFF3E298  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E29A  fe0231                            mov.b   r1, [r2, r3]
FFF3E29D  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E29F  6211                              add     #1, r1
FFF3E2A1  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E2A3  aa61                              mov.l   20h[r6], r1
FFF3E2A5  5802                              movu.b  1Ch+var_1C[sp], r2
FFF3E2A7  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E2A9  fe0132                            mov.b   r2, [r1, r3]
FFF3E2AC  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E2AE  6211                              add     #1, r1
FFF3E2B0  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E2B2  3d0b02                            mov.w   #2, 1Ch+var_6[sp]
FFF3E2B5  a809                              mov.l   1Ch+var_18[sp], r1
FFF3E2B7  6981                              shlr    #18h, r1
FFF3E2B9  aa62                              mov.l   20h[r6], r2
FFF3E2BB  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E2BD  fe0231                            mov.b   r1, [r2, r3]
FFF3E2C0  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E2C2  6211                              add     #1, r1
FFF3E2C4  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E2C6  a809                              mov.l   1Ch+var_18[sp], r1
FFF3E2C8  6901                              shlr    #10h, r1
FFF3E2CA  aa62                              mov.l   20h[r6], r2
FFF3E2CC  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E2CE  fe0231                            mov.b   r1, [r2, r3]
FFF3E2D1  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E2D3  6211                              add     #1, r1
FFF3E2D5  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E2D7  a809                              mov.l   1Ch+var_18[sp], r1
FFF3E2D9  6881                              shlr    #8, r1
FFF3E2DB  aa62                              mov.l   20h[r6], r2
FFF3E2DD  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E2DF  fe0231                            mov.b   r1, [r2, r3]
FFF3E2E2  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E2E4  6211                              add     #1, r1
FFF3E2E6  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E2E8  aa61                              mov.l   20h[r6], r1
FFF3E2EA  b102                              movu.b  1Ch+var_18[sp], r2
FFF3E2EC  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E2EE  fe0132                            mov.b   r2, [r1, r3]
FFF3E2F1  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E2F3  6211                              add     #1, r1
FFF3E2F5  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E2F7  3d0b06                            mov.w   #6, 1Ch+var_6[sp]
FFF3E2FA  a881                              mov.l   1Ch+var_14[sp], r1
FFF3E2FC  6981                              shlr    #18h, r1
FFF3E2FE  aa62                              mov.l   20h[r6], r2
FFF3E300  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E302  fe0231                            mov.b   r1, [r2, r3]
FFF3E305  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E307  6211                              add     #1, r1
FFF3E309  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E30B  a881                              mov.l   1Ch+var_14[sp], r1
FFF3E30D  6901                              shlr    #10h, r1
FFF3E30F  aa62                              mov.l   20h[r6], r2
FFF3E311  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E313  fe0231                            mov.b   r1, [r2, r3]
FFF3E316  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E318  6211                              add     #1, r1
FFF3E31A  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E31C  a881                              mov.l   1Ch+var_14[sp], r1
FFF3E31E  6881                              shlr    #8, r1
FFF3E320  aa62                              mov.l   20h[r6], r2
FFF3E322  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E324  fe0231                            mov.b   r1, [r2, r3]
FFF3E327  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E329  6211                              add     #1, r1
FFF3E32B  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E32D  aa61                              mov.l   20h[r6], r1
FFF3E32F  b202                              movu.b  1Ch+var_14[sp], r2
FFF3E331  ba8b                              movu.w  1Ch+var_6[sp], r3
FFF3E333  fe0132                            mov.b   r2, [r1, r3]
FFF3E336  9a89                              mov.w   1Ch+var_6[sp], r1
FFF3E338  6211                              add     #1, r1
FFF3E33A  9289                              mov.w   r1, 1Ch+var_6[sp]
FFF3E33C  3d6c0a                            mov.w   #0Ah, 18h[r6]
FFF3E33F  bb61                              movu.w  18h[r6], r1
FFF3E341  72119000                          add     #90h, r1, r1
FFF3E345  fbe258250100                      mov.l   #12558h, r14
FFF3E34B  d3e1                              mov.w   r1, [r14]
FFF3E34D  fb1258250100                      mov.l   #12558h, r1
FFF3E353  3d1101                            mov.w   #1, 2[r1]
FFF3E356  fbe258250100                      mov.l   #12558h, r14
FFF3E35C  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E362  d4fe02                            mov.w   [r15], 4[r14]
FFF3E365  7100c8                            add     #-38h, sp, sp
FFF3E368  754312                            mov.l   #12h, r3
FFF3E36B  fb2258250100                      mov.l   #12558h, r2
FFF3E371  ef01                              mov.l   sp, r1
FFF3E373  7f8f                              smovf
FFF3E375  ef01                              mov.l   sp, r1
FFF3E377  711114                            add     #14h, r1, r1
FFF3E37A  754324                            mov.l   #24h, r3 ; '$'
FFF3E37D  ef62                              mov.l   r6, r2
FFF3E37F  7f8f                              smovf
FFF3E381  6602                              mov.l   #0, r2
FFF3E383  7541fe                            mov.l   #-2, r1
FFF3E386  0556f5f9                          bsr.a   sub_FFEDD8DC
FFF3E38A  710038                            add     #38h, sp, sp ; '8'
FFF3E38D  d5000c0d                          mov.w   1Ch+var_4[sp], 1Ch+var_2[sp]
FFF3E391  9b09                              mov.w   1Ch+var_2[sp], r1
FFF3E393  5f11                              movu.w  r1, r1
FFF3E395  3f6608                            rtsd    #20h, r6-r6
FFF3E398  7ea6                   sub_FFF3E398 push.l  r6   ; <<<< FUNC sub_FFF3E398
FFF3E39A  60c0                              sub     #0Ch, sp
FFF3E39C  3d0400                            mov.w   #0, 0Ch+var_4[sp]
FFF3E39F  710614                            add     #0Ch+arg_0, sp, r6
FFF3E3A2  3d0300                            mov.w   #0, 0Ch+var_6[sp]
FFF3E3A5  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF3E3A8  3c0301                            mov.b   #1, 0Ch+var_9[sp]
FFF3E3AB  fb1258250100                      mov.l   #12558h, r1
FFF3E3B1  6602                              mov.l   #0, r2
FFF3E3B3  9212                              mov.w   r2, 10h[r1]
FFF3E3B5  a09a                              mov.l   r2, 0Ch[r1]
FFF3E3B7  a092                              mov.l   r2, 8[r1]
FFF3E3B9  a01a                              mov.l   r2, 4[r1]
FFF3E3BB  e312                              mov.l   r2, [r1]
FFF3E3BD  754312                            mov.l   #12h, r3
FFF3E3C0  fb2234250100                      mov.l   #12534h, r2
FFF3E3C6  fb1258250100                      mov.l   #12558h, r1
FFF3E3CC  7f8f                              smovf
FFF3E3CE  2e45                              bra.b   loc_FFF3E413
FFF3E3D0  fb1262080100           loc_FFF3E3D0 mov.l   #10862h, r1
FFF3E3D6  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3E3DC  e0e1                              mov.l   [r14], [r1]
FFF3E3DE  fbe21883edff                      mov.l   #off_FFED8318, r14; "FT3D"
FFF3E3E4  b88a                              movu.w  0Ch+var_6[sp], r2
FFF3E3E6  fe62ee                            mov.l   [r2, r14], r14
FFF3E3E9  fb36ff                            mov.l   #-1, r3
FFF3E3EC  6602                              mov.l   #0, r2
FFF3E3EE  7f80                              suntil.b
FFF3E3F0  6011                              sub     #1, r1
FFF3E3F2  efe2                              mov.l   r14, r2
FFF3E3F4  7f87                              smovu
FFF3E3F6  fb1262080100                      mov.l   #10862h, r1
FFF3E3FC  05fd47fd                          bsr.a   sub_FFF12BF9
FFF3E400  8089                              mov.b   r1, 0Ch+var_9[sp]
FFF3E402  b089                              movu.b  0Ch+var_9[sp], r1
FFF3E404  6111                              cmp     #1, r1
FFF3E406  17                                beq.s   loc_FFF3E40D
FFF3E407  9881                              mov.w   0Ch+var_8[sp], r1
FFF3E409  6211                              add     #1, r1
FFF3E40B  9081                              mov.w   r1, 0Ch+var_8[sp]
FFF3E40D  9889                   loc_FFF3E40D mov.w   0Ch+var_6[sp], r1
FFF3E40F  6211                              add     #1, r1
FFF3E411  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF3E413  fbe21883edff           loc_FFF3E413 mov.l   #off_FFED8318, r14; "FT3D"
FFF3E419  b889                              movu.w  0Ch+var_6[sp], r1
FFF3E41B  fe61ee                            mov.l   [r1, r14], r14
FFF3E41E  610e                              cmp     #0, r14
FFF3E420  21b0                              bne.b   loc_FFF3E3D0
FFF3E422  b881                              movu.w  0Ch+var_8[sp], r1
FFF3E424  6101                              cmp     #0, r1
FFF3E426  15                                beq.s   loc_FFF3E42B
FFF3E427  3d60c9                            mov.w   #-37h, [r6]
FFF3E42A  0c                                bra.s   loc_FFF3E42E
FFF3E42B  3d60c8                 loc_FFF3E42B mov.w   #-38h, [r6]
FFF3E42E  fbe29b220100           loc_FFF3E42E mov.l   #1229Bh, r14
FFF3E434  58ee                              movu.b  [r14], r14
FFF3E436  611e                              cmp     #1, r14
FFF3E438  210d                              bne.b   loc_FFF3E445
FFF3E43A  fb1258250100                      mov.l   #12558h, r1
FFF3E440  3d1300                            mov.w   #0, 6[r1]
FFF3E443  2e0d                              bra.b   loc_FFF3E450
FFF3E445  fbe258250100           loc_FFF3E445 mov.l   #12558h, r14
FFF3E44B  f9e903ffff                        mov.w   #-1, 6[r14]
FFF3E450  fb1258250100           loc_FFF3E450 mov.l   #12558h, r1
FFF3E456  3d1090                            mov.w   #-70h, [r1]
FFF3E459  fb1258250100                      mov.l   #12558h, r1
FFF3E45F  3d1101                            mov.w   #1, 2[r1]
FFF3E462  fbe258250100                      mov.l   #12558h, r14
FFF3E468  fbf26c250100                      mov.l   #1256Ch, r15
FFF3E46E  d4fe02                            mov.w   [r15], 4[r14]
FFF3E471  3d6c00                            mov.w   #0, 18h[r6]
FFF3E474  7100c8                            add     #-38h, sp, sp
FFF3E477  754312                            mov.l   #12h, r3
FFF3E47A  fb2258250100                      mov.l   #12558h, r2
FFF3E480  ef01                              mov.l   sp, r1
FFF3E482  7f8f                              smovf
FFF3E484  ef01                              mov.l   sp, r1
FFF3E486  711114                            add     #14h, r1, r1
FFF3E489  754324                            mov.l   #24h, r3 ; '$'
FFF3E48C  ef62                              mov.l   r6, r2
FFF3E48E  7f8f                              smovf
FFF3E490  6602                              mov.l   #0, r2
FFF3E492  7541fe                            mov.l   #-2, r1
FFF3E495  0547f4f9                          bsr.a   sub_FFEDD8DC
FFF3E499  710038                            add     #38h, sp, sp ; '8'
FFF3E49C  d5000405                          mov.w   0Ch+var_4[sp], 0Ch+var_2[sp]
FFF3E4A0  9909                              mov.w   0Ch+var_2[sp], r1
FFF3E4A2  5f11                              movu.w  r1, r1
FFF3E4A4  3f6604                            rtsd    #10h, r6-r6
FFF3E4A7  710080                 sub_FFF3E4A7 add     #-80h, sp, sp   ; <<<< FUNC sub_FFF3E4A7
FFF3E4AA  a789                              mov.l   r1, 80h+var_4[sp]
FFF3E4AC  d7023d                            mov.w   r2, 80h+var_6[sp]
FFF3E4AF  a70b                              mov.l   r3, 80h+var_C[sp]
FFF3E4B1  a704                              mov.l   r4, 80h+var_10[sp]
FFF3E4B3  f9053600                          mov.w   #0, 80h+var_14[sp]
FFF3E4B7  f9053500                          mov.w   #0, 80h+var_16[sp]
FFF3E4BB  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E4BF  f9053300                          mov.w   #0, 80h+var_1A[sp]
FFF3E4C3  3e8800                            mov.l   #0, 80h+var_20[sp]
FFF3E4C6  af09                              mov.l   80h+var_C[sp], r1
FFF3E4C8  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E4CB  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E4CE  af8a                              mov.l   80h+var_4[sp], r2
FFF3E4D0  fec211                            movu.b  [r2, r1], r1
FFF3E4D3  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E4D6  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E4D9  6211                              add     #1, r1
FFF3E4DB  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E4DE  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E4E1  6c81                              shll    #8, r1
FFF3E4E3  af8a                              mov.l   80h+var_4[sp], r2
FFF3E4E5  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E4E9  5421                              or      [r2], r1
FFF3E4EB  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E4EE  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E4F1  6211                              add     #1, r1
FFF3E4F3  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E4F6  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E4F9  751124                            mul     #24h, r1 ; '$'
FFF3E4FC  fbe2d0830600                      mov.l   #683D0h, r14
FFF3E502  4b1e                              add     r1, r14
FFF3E504  d10e35                            mov.w   80h+var_16[sp], [r14]
FFF3E507  fb12f0840600                      mov.l   #684F0h, r1
FFF3E50D  b819                              movu.w  2[r1], r1
FFF3E50F  6101                              cmp     #0, r1
FFF3E511  2113                              bne.b   loc_FFF3E524
FFF3E513  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E516  751124                            mul     #24h, r1 ; '$'
FFF3E519  fbe260840600                      mov.l   #68460h, r14
FFF3E51F  4b1e                              add     r1, r14
FFF3E521  d10e35                            mov.w   80h+var_16[sp], [r14]
FFF3E524  5d0136                 loc_FFF3E524 movu.w  80h+var_14[sp], r1
FFF3E527  af8a                              mov.l   80h+var_4[sp], r2
FFF3E529  fec211                            movu.b  [r2, r1], r1
FFF3E52C  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E52F  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E532  6211                              add     #1, r1
FFF3E534  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E537  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E53A  6c81                              shll    #8, r1
FFF3E53C  af8a                              mov.l   80h+var_4[sp], r2
FFF3E53E  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E542  5421                              or      [r2], r1
FFF3E544  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E547  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E54A  6211                              add     #1, r1
FFF3E54C  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E54F  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E552  751124                            mul     #24h, r1 ; '$'
FFF3E555  fb22d0830600                      mov.l   #683D0h, r2
FFF3E55B  4b12                              add     r1, r2
FFF3E55D  d5023501                          mov.w   80h+var_16[sp], 2[r2]
FFF3E561  fb12f0840600                      mov.l   #684F0h, r1
FFF3E567  b819                              movu.w  2[r1], r1
FFF3E569  6101                              cmp     #0, r1
FFF3E56B  2114                              bne.b   loc_FFF3E57F
FFF3E56D  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E570  751124                            mul     #24h, r1 ; '$'
FFF3E573  fb2260840600                      mov.l   #68460h, r2
FFF3E579  4b12                              add     r1, r2
FFF3E57B  d5023501                          mov.w   80h+var_16[sp], 2[r2]
FFF3E57F  5d0136                 loc_FFF3E57F movu.w  80h+var_14[sp], r1
FFF3E582  af8a                              mov.l   80h+var_4[sp], r2
FFF3E584  fec211                            movu.b  [r2, r1], r1
FFF3E587  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E58A  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E58D  6211                              add     #1, r1
FFF3E58F  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E592  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E595  6c81                              shll    #8, r1
FFF3E597  af8a                              mov.l   80h+var_4[sp], r2
FFF3E599  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E59D  5421                              or      [r2], r1
FFF3E59F  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E5A2  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E5A5  6211                              add     #1, r1
FFF3E5A7  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E5AA  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E5AD  751124                            mul     #24h, r1 ; '$'
FFF3E5B0  fb22d0830600                      mov.l   #683D0h, r2
FFF3E5B6  4b12                              add     r1, r2
FFF3E5B8  d5023502                          mov.w   80h+var_16[sp], 4[r2]
FFF3E5BC  fb12f0840600                      mov.l   #684F0h, r1
FFF3E5C2  b819                              movu.w  2[r1], r1
FFF3E5C4  6101                              cmp     #0, r1
FFF3E5C6  2114                              bne.b   loc_FFF3E5DA
FFF3E5C8  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E5CB  751124                            mul     #24h, r1 ; '$'
FFF3E5CE  fb2260840600                      mov.l   #68460h, r2
FFF3E5D4  4b12                              add     r1, r2
FFF3E5D6  d5023502                          mov.w   80h+var_16[sp], 4[r2]
FFF3E5DA  d5003633               loc_FFF3E5DA mov.w   80h+var_14[sp], 80h+var_1A[sp]
FFF3E5DE  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E5E1  751124                            mul     #24h, r1 ; '$'
FFF3E5E4  fb22d0830600                      mov.l   #683D0h, r2
FFF3E5EA  4b12                              add     r1, r2
FFF3E5EC  b8a1                              movu.w  4[r2], r1
FFF3E5EE  711eff                            add     #-1, r1, r14
FFF3E5F1  616e                              cmp     #6, r14
FFF3E5F3  2357                              bltu.b  loc_FFF3E64A
FFF3E5F5  6101                              cmp     #0, r1
FFF3E5F7  3b9200                            bne.w   loc_FFF3E689
FFF3E5FA  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E5FD  6211                              add     #1, r1
FFF3E5FF  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E602  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E606  2e2f                              bra.b   loc_FFF3E635
FFF3E608  5d0136                 loc_FFF3E608 movu.w  80h+var_14[sp], r1
FFF3E60B  af8a                              mov.l   80h+var_4[sp], r2
FFF3E60D  fec21e                            movu.b  [r2, r1], r14
FFF3E610  610e                              cmp     #0, r14
FFF3E612  202b                              beq.b   loc_FFF3E63D
FFF3E614  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E617  af8a                              mov.l   80h+var_4[sp], r2
FFF3E619  fec21e                            movu.b  [r2, r1], r14
FFF3E61C  710f20                            add     #80h+var_60, sp, r15
FFF3E61F  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E622  fe0f1e                            mov.b   r14, [r15, r1]
FFF3E625  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E628  6211                              add     #1, r1
FFF3E62A  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E62D  dd0134                            mov.w   80h+var_18[sp], r1
FFF3E630  6211                              add     #1, r1
FFF3E632  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E635  5d0134                 loc_FFF3E635 movu.w  80h+var_18[sp], r1
FFF3E638  755140                            cmp     #40h, r1 ; '@'
FFF3E63B  29cd                              blt.b   loc_FFF3E608
FFF3E63D  5d0134                 loc_FFF3E63D movu.w  80h+var_18[sp], r1
FFF3E640  710e20                            add     #80h+var_60, sp, r14
FFF3E643  660f                              mov.l   #0, r15
FFF3E645  fe0e1f                            mov.b   r15, [r14, r1]
FFF3E648  2e41                              bra.b   loc_FFF3E689
FFF3E64A  f9053400               loc_FFF3E64A mov.w   #0, 80h+var_18[sp]
FFF3E64E  2e34                              bra.b   loc_FFF3E682
FFF3E650  5d013d                 loc_FFF3E650 movu.w  80h+var_6[sp], r1
FFF3E653  751124                            mul     #24h, r1 ; '$'
FFF3E656  fb22d0830600                      mov.l   #683D0h, r2
FFF3E65C  4b12                              add     r1, r2
FFF3E65E  b8a1                              movu.w  4[r2], r1
FFF3E660  06c50134                          cmp     80h+var_18[sp].uw, r1
FFF3E664  2116                              bne.b   loc_FFF3E67A
FFF3E666  fbe21883edff                      mov.l   #off_FFED8318, r14; "FT3D"
FFF3E66C  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E66F  fe61e2                            mov.l   [r1, r14], r2
FFF3E672  fb36ff                            mov.l   #-1, r3
FFF3E675  710120                            add     #80h+var_60, sp, r1
FFF3E678  7f87                              smovu
FFF3E67A  dd0134                 loc_FFF3E67A mov.w   80h+var_18[sp], r1
FFF3E67D  6211                              add     #1, r1
FFF3E67F  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E682  5d0134                 loc_FFF3E682 movu.w  80h+var_18[sp], r1
FFF3E685  6171                              cmp     #7, r1
FFF3E687  29c9                              blt.b   loc_FFF3E650
FFF3E689  5d013d                 loc_FFF3E689 movu.w  80h+var_6[sp], r1
FFF3E68C  751124                            mul     #24h, r1 ; '$'
FFF3E68F  fb22d0830600                      mov.l   #683D0h, r2
FFF3E695  4b12                              add     r1, r2
FFF3E697  a8a1                              mov.l   8[r2], r1
FFF3E699  fb36ff                            mov.l   #-1, r3
FFF3E69C  710220                            add     #80h+var_60, sp, r2
FFF3E69F  7f87                              smovu
FFF3E6A1  fb12f0840600                      mov.l   #684F0h, r1
FFF3E6A7  b819                              movu.w  2[r1], r1
FFF3E6A9  6101                              cmp     #0, r1
FFF3E6AB  211a                              bne.b   loc_FFF3E6C5
FFF3E6AD  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E6B0  751124                            mul     #24h, r1 ; '$'
FFF3E6B3  fb2260840600                      mov.l   #68460h, r2
FFF3E6B9  4b12                              add     r1, r2
FFF3E6BB  a8a1                              mov.l   8[r2], r1
FFF3E6BD  fb36ff                            mov.l   #-1, r3
FFF3E6C0  710220                            add     #80h+var_60, sp, r2
FFF3E6C3  7f87                              smovu
FFF3E6C5  5d0133                 loc_FFF3E6C5 movu.w  80h+var_1A[sp], r1
FFF3E6C8  711140                            add     #40h, r1, r1 ; '@'
FFF3E6CB  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E6CE  d5003633                          mov.w   80h+var_14[sp], 80h+var_1A[sp]
FFF3E6D2  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E6D6  2e2e                              bra.b   loc_FFF3E704
FFF3E6D8  5d0136                 loc_FFF3E6D8 movu.w  80h+var_14[sp], r1
FFF3E6DB  af8a                              mov.l   80h+var_4[sp], r2
FFF3E6DD  fec21e                            movu.b  [r2, r1], r14
FFF3E6E0  610e                              cmp     #0, r14
FFF3E6E2  202a                              beq.b   loc_FFF3E70C
FFF3E6E4  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E6E7  af8a                              mov.l   80h+var_4[sp], r2
FFF3E6E9  fec21e                            movu.b  [r2, r1], r14
FFF3E6EC  ef0f                              mov.l   sp, r15
FFF3E6EE  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E6F1  fe0f1e                            mov.b   r14, [r15, r1]
FFF3E6F4  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E6F7  6211                              add     #1, r1
FFF3E6F9  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E6FC  dd0134                            mov.w   80h+var_18[sp], r1
FFF3E6FF  6211                              add     #1, r1
FFF3E701  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E704  5d0134                 loc_FFF3E704 movu.w  80h+var_18[sp], r1
FFF3E707  755120                            cmp     #20h, r1 ; ' '
FFF3E70A  29ce                              blt.b   loc_FFF3E6D8
FFF3E70C  5d0134                 loc_FFF3E70C movu.w  80h+var_18[sp], r1
FFF3E70F  ef0e                              mov.l   sp, r14
FFF3E711  660f                              mov.l   #0, r15
FFF3E713  fe0e1f                            mov.b   r15, [r14, r1]
FFF3E716  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E719  751124                            mul     #24h, r1 ; '$'
FFF3E71C  fb22d0830600                      mov.l   #683D0h, r2
FFF3E722  4b12                              add     r1, r2
FFF3E724  a8a9                              mov.l   0Ch[r2], r1
FFF3E726  fb36ff                            mov.l   #-1, r3
FFF3E729  ef02                              mov.l   sp, r2
FFF3E72B  7f87                              smovu
FFF3E72D  fb12f0840600                      mov.l   #684F0h, r1
FFF3E733  b819                              movu.w  2[r1], r1
FFF3E735  6101                              cmp     #0, r1
FFF3E737  2119                              bne.b   loc_FFF3E750
FFF3E739  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E73C  751124                            mul     #24h, r1 ; '$'
FFF3E73F  fb2260840600                      mov.l   #68460h, r2
FFF3E745  4b12                              add     r1, r2
FFF3E747  a8a9                              mov.l   0Ch[r2], r1
FFF3E749  fb36ff                            mov.l   #-1, r3
FFF3E74C  ef02                              mov.l   sp, r2
FFF3E74E  7f87                              smovu
FFF3E750  5d0133                 loc_FFF3E750 movu.w  80h+var_1A[sp], r1
FFF3E753  711120                            add     #20h, r1, r1 ; ' '
FFF3E756  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E759  3e8800                            mov.l   #0, 80h+var_20[sp]
FFF3E75C  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E75F  af8a                              mov.l   80h+var_4[sp], r2
FFF3E761  fec211                            movu.b  [r2, r1], r1
FFF3E764  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E766  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E769  6211                              add     #1, r1
FFF3E76B  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E76E  ae01                              mov.l   80h+var_20[sp], r1
FFF3E770  6c81                              shll    #8, r1
FFF3E772  af8a                              mov.l   80h+var_4[sp], r2
FFF3E774  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E778  5421                              or      [r2], r1
FFF3E77A  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E77C  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E77F  6211                              add     #1, r1
FFF3E781  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E784  ae01                              mov.l   80h+var_20[sp], r1
FFF3E786  6c81                              shll    #8, r1
FFF3E788  af8a                              mov.l   80h+var_4[sp], r2
FFF3E78A  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E78E  5421                              or      [r2], r1
FFF3E790  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E792  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E795  6211                              add     #1, r1
FFF3E797  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E79A  ae01                              mov.l   80h+var_20[sp], r1
FFF3E79C  6c81                              shll    #8, r1
FFF3E79E  af8a                              mov.l   80h+var_4[sp], r2
FFF3E7A0  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E7A4  5421                              or      [r2], r1
FFF3E7A6  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E7A8  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E7AB  6211                              add     #1, r1
FFF3E7AD  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E7B0  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E7B3  751124                            mul     #24h, r1 ; '$'
FFF3E7B6  fb22d0830600                      mov.l   #683D0h, r2
FFF3E7BC  4b12                              add     r1, r2
FFF3E7BE  e5021804                          mov.l   80h+var_20[sp], 10h[r2]
FFF3E7C2  fb12f0840600                      mov.l   #684F0h, r1
FFF3E7C8  b819                              movu.w  2[r1], r1
FFF3E7CA  6101                              cmp     #0, r1
FFF3E7CC  2114                              bne.b   loc_FFF3E7E0
FFF3E7CE  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E7D1  751124                            mul     #24h, r1 ; '$'
FFF3E7D4  fb2260840600                      mov.l   #68460h, r2
FFF3E7DA  4b12                              add     r1, r2
FFF3E7DC  e5021804                          mov.l   80h+var_20[sp], 10h[r2]
FFF3E7E0  3e8800                 loc_FFF3E7E0 mov.l   #0, 80h+var_20[sp]
FFF3E7E3  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E7E6  af8a                              mov.l   80h+var_4[sp], r2
FFF3E7E8  fec211                            movu.b  [r2, r1], r1
FFF3E7EB  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E7ED  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E7F0  6211                              add     #1, r1
FFF3E7F2  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E7F5  ae01                              mov.l   80h+var_20[sp], r1
FFF3E7F7  6c81                              shll    #8, r1
FFF3E7F9  af8a                              mov.l   80h+var_4[sp], r2
FFF3E7FB  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E7FF  5421                              or      [r2], r1
FFF3E801  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E803  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E806  6211                              add     #1, r1
FFF3E808  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E80B  ae01                              mov.l   80h+var_20[sp], r1
FFF3E80D  6c81                              shll    #8, r1
FFF3E80F  af8a                              mov.l   80h+var_4[sp], r2
FFF3E811  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E815  5421                              or      [r2], r1
FFF3E817  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E819  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E81C  6211                              add     #1, r1
FFF3E81E  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E821  ae01                              mov.l   80h+var_20[sp], r1
FFF3E823  6c81                              shll    #8, r1
FFF3E825  af8a                              mov.l   80h+var_4[sp], r2
FFF3E827  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E82B  5421                              or      [r2], r1
FFF3E82D  a601                              mov.l   r1, 80h+var_20[sp]
FFF3E82F  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E832  6211                              add     #1, r1
FFF3E834  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E837  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E83A  751124                            mul     #24h, r1 ; '$'
FFF3E83D  fb22d0830600                      mov.l   #683D0h, r2
FFF3E843  4b12                              add     r1, r2
FFF3E845  e5021805                          mov.l   80h+var_20[sp], 14h[r2]
FFF3E849  fb12f0840600                      mov.l   #684F0h, r1
FFF3E84F  b819                              movu.w  2[r1], r1
FFF3E851  6101                              cmp     #0, r1
FFF3E853  2114                              bne.b   loc_FFF3E867
FFF3E855  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E858  751124                            mul     #24h, r1 ; '$'
FFF3E85B  fb2260840600                      mov.l   #68460h, r2
FFF3E861  4b12                              add     r1, r2
FFF3E863  e5021805                          mov.l   80h+var_20[sp], 14h[r2]
FFF3E867  f9053500               loc_FFF3E867 mov.w   #0, 80h+var_16[sp]
FFF3E86B  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E86E  af8a                              mov.l   80h+var_4[sp], r2
FFF3E870  fec211                            movu.b  [r2, r1], r1
FFF3E873  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E876  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E879  6211                              add     #1, r1
FFF3E87B  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E87E  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E881  6c81                              shll    #8, r1
FFF3E883  af8a                              mov.l   80h+var_4[sp], r2
FFF3E885  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E889  5421                              or      [r2], r1
FFF3E88B  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E88E  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E891  6211                              add     #1, r1
FFF3E893  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E896  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E899  751124                            mul     #24h, r1 ; '$'
FFF3E89C  fb22d0830600                      mov.l   #683D0h, r2
FFF3E8A2  4b12                              add     r1, r2
FFF3E8A4  d502350c                          mov.w   80h+var_16[sp], 18h[r2]
FFF3E8A8  fb12f0840600                      mov.l   #684F0h, r1
FFF3E8AE  b819                              movu.w  2[r1], r1
FFF3E8B0  6101                              cmp     #0, r1
FFF3E8B2  2114                              bne.b   loc_FFF3E8C6
FFF3E8B4  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E8B7  751124                            mul     #24h, r1 ; '$'
FFF3E8BA  fb2260840600                      mov.l   #68460h, r2
FFF3E8C0  4b12                              add     r1, r2
FFF3E8C2  d502350c                          mov.w   80h+var_16[sp], 18h[r2]
FFF3E8C6  f9053500               loc_FFF3E8C6 mov.w   #0, 80h+var_16[sp]
FFF3E8CA  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E8CD  af8a                              mov.l   80h+var_4[sp], r2
FFF3E8CF  fec211                            movu.b  [r2, r1], r1
FFF3E8D2  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E8D5  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E8D8  6211                              add     #1, r1
FFF3E8DA  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E8DD  dd0135                            mov.w   80h+var_16[sp], r1
FFF3E8E0  6c81                              shll    #8, r1
FFF3E8E2  af8a                              mov.l   80h+var_4[sp], r2
FFF3E8E4  06c90236                          add     80h+var_14[sp].uw, r2
FFF3E8E8  5421                              or      [r2], r1
FFF3E8EA  d70135                            mov.w   r1, 80h+var_16[sp]
FFF3E8ED  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E8F0  6211                              add     #1, r1
FFF3E8F2  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E8F5  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E8F8  751124                            mul     #24h, r1 ; '$'
FFF3E8FB  fb22d0830600                      mov.l   #683D0h, r2
FFF3E901  4b12                              add     r1, r2
FFF3E903  5d0135                            movu.w  80h+var_16[sp], r1
FFF3E906  a1a9                              mov.l   r1, 1Ch[r2]
FFF3E908  fb12f0840600                      mov.l   #684F0h, r1
FFF3E90E  b819                              movu.w  2[r1], r1
FFF3E910  6101                              cmp     #0, r1
FFF3E912  2115                              bne.b   loc_FFF3E927
FFF3E914  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E917  751124                            mul     #24h, r1 ; '$'
FFF3E91A  fb2260840600                      mov.l   #68460h, r2
FFF3E920  4b12                              add     r1, r2
FFF3E922  5d0135                            movu.w  80h+var_16[sp], r1
FFF3E925  a1a9                              mov.l   r1, 1Ch[r2]
FFF3E927  5d0136                 loc_FFF3E927 movu.w  80h+var_14[sp], r1
FFF3E92A  62e1                              add     #0Eh, r1
FFF3E92C  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E92F  f9053400                          mov.w   #0, 80h+var_18[sp]
FFF3E933  2e30                              bra.b   loc_FFF3E963
FFF3E935  5d0136                 loc_FFF3E935 movu.w  80h+var_14[sp], r1
FFF3E938  af8a                              mov.l   80h+var_4[sp], r2
FFF3E93A  fec21e                            movu.b  [r2, r1], r14
FFF3E93D  5d013d                            movu.w  80h+var_6[sp], r1
FFF3E940  751124                            mul     #24h, r1 ; '$'
FFF3E943  fb22d0830600                      mov.l   #683D0h, r2
FFF3E949  4b12                              add     r1, r2
FFF3E94B  aa21                              mov.l   20h[r2], r1
FFF3E94D  5d0234                            movu.w  80h+var_18[sp], r2
FFF3E950  fe012e                            mov.b   r14, [r1, r2]
FFF3E953  dd0136                            mov.w   80h+var_14[sp], r1
FFF3E956  6211                              add     #1, r1
FFF3E958  d70136                            mov.w   r1, 80h+var_14[sp]
FFF3E95B  dd0134                            mov.w   80h+var_18[sp], r1
FFF3E95E  6211                              add     #1, r1
FFF3E960  d70134                            mov.w   r1, 80h+var_18[sp]
FFF3E963  5d013d                 loc_FFF3E963 movu.w  80h+var_6[sp], r1
FFF3E966  751124                            mul     #24h, r1 ; '$'
FFF3E969  fbe2d0830600                      mov.l   #683D0h, r14
FFF3E96F  4b1e                              add     r1, r14
FFF3E971  5d0134                            movu.w  80h+var_18[sp], r1
FFF3E974  06c5e10c                          cmp     18h[r14].uw, r1
FFF3E978  29bd                              blt.b   loc_FFF3E935
FFF3E97A  5d0136                            movu.w  80h+var_14[sp], r1
FFF3E97D  af02                              mov.l   80h+var_10[sp], r2
FFF3E97F  e321                              mov.l   r1, [r2]
FFF3E981  f9053700                          mov.w   #0, 80h+var_12[sp]
FFF3E985  dd0137                            mov.w   80h+var_12[sp], r1
FFF3E988  5f11                              movu.w  r1, r1
FFF3E98A  6720                              rtsd    #20h
FFF3E98C  7100f0                 sub_FFF3E98C add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3E98C
FFF3E98F  a089                              mov.l   r1, 10h+var_4[sp]
FFF3E991  3d0400                            mov.w   #0, 10h+var_8[sp]
FFF3E994  3d0300                            mov.w   #0, 10h+var_A[sp]
FFF3E997  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E99D  58ee                              movu.b  [r14], r14
FFF3E99F  610e                              cmp     #0, r14
FFF3E9A1  2011                              beq.b   loc_FFF3E9B2
FFF3E9A3  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E9A9  58ee                              movu.b  [r14], r14
FFF3E9AB  61ce                              cmp     #0Ch, r14
FFF3E9AD  15                                beq.s   loc_FFF3E9B2
FFF3E9AE  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3E9B1  0c                                bra.s   loc_FFF3E9B5
FFF3E9B2  f80600                 loc_FFF3E9B2 mov.l   #0, 10h+var_10[sp]
FFF3E9B5  ec01                   loc_FFF3E9B5 mov.l   10h+var_10[sp], r1
FFF3E9B7  6101                              cmp     #0, r1
FFF3E9B9  2011                              beq.b   loc_FFF3E9CA
FFF3E9BB  fbe25f080100                      mov.l   #1085Fh, r14
FFF3E9C1  58ee                              movu.b  [r14], r14
FFF3E9C3  615e                              cmp     #5, r14
FFF3E9C5  15                                beq.s   loc_FFF3E9CA
FFF3E9C6  f80601                            mov.l   #1, 10h+var_10[sp]
FFF3E9C9  0c                                bra.s   loc_FFF3E9CD
FFF3E9CA  f80600                 loc_FFF3E9CA mov.l   #0, 10h+var_10[sp]
FFF3E9CD  ec01                   loc_FFF3E9CD mov.l   10h+var_10[sp], r1
FFF3E9CF  3d0400                            mov.w   #0, 10h+var_8[sp]
FFF3E9D2  6101                              cmp     #0, r1
FFF3E9D4  202f                              beq.b   loc_FFF3EA03
FFF3E9D6  b901                              movu.w  10h+var_8[sp], r1
FFF3E9D8  fbe2661f0100                      mov.l   #11F66h, r14
FFF3E9DE  fbf6a0                            mov.l   #-60h, r15
FFF3E9E1  fe0e1f                            mov.b   r15, [r14, r1]
FFF3E9E4  9901                              mov.w   10h+var_8[sp], r1
FFF3E9E6  6211                              add     #1, r1
FFF3E9E8  9101                              mov.w   r1, 10h+var_8[sp]
FFF3E9EA  b904                              movu.w  10h+var_8[sp], r4
FFF3E9EC  fb32661f0100                      mov.l   #11F66h, r3
FFF3E9F2  6602                              mov.l   #0, r2
FFF3E9F4  7541ea                            mov.l   #-16h, r1
FFF3E9F7  0504edf9                          bsr.a   sub_FFEDD6FB
FFF3E9FB  f90902ffff                        mov.w   #-1, 10h+var_C[sp]
FFF3EA00  38da00                            bra.w   loc_FFF3EADA
FFF3EA03  3d0300                 loc_FFF3EA03 mov.w   #0, 10h+var_A[sp]
FFF3EA06  2e30                              bra.b   loc_FFF3EA36
FFF3EA08  b901                   loc_FFF3EA08 movu.w  10h+var_8[sp], r1
FFF3EA0A  06890103                          add     10h+var_4[sp].l, r1
FFF3EA0E  591e21                            movu.b  21h[r1], r14
FFF3EA11  755eff                            cmp     #-1, r14
FFF3EA14  2028                              beq.b   loc_FFF3EA3C
FFF3EA16  b901                              movu.w  10h+var_8[sp], r1
FFF3EA18  06890103                          add     10h+var_4[sp].l, r1
FFF3EA1C  591e21                            movu.b  21h[r1], r14
FFF3EA1F  fbf266200100                      mov.l   #12066h, r15
FFF3EA25  b889                              movu.w  10h+var_A[sp], r1
FFF3EA27  fe0f1e                            mov.b   r14, [r15, r1]
FFF3EA2A  9901                              mov.w   10h+var_8[sp], r1
FFF3EA2C  6211                              add     #1, r1
FFF3EA2E  9101                              mov.w   r1, 10h+var_8[sp]
FFF3EA30  9889                              mov.w   10h+var_A[sp], r1
FFF3EA32  6211                              add     #1, r1
FFF3EA34  9089                              mov.w   r1, 10h+var_A[sp]
FFF3EA36  b889                   loc_FFF3EA36 movu.w  10h+var_A[sp], r1
FFF3EA38  61f1                              cmp     #0Fh, r1
FFF3EA3A  29ce                              blt.b   loc_FFF3EA08
FFF3EA3C  b889                   loc_FFF3EA3C movu.w  10h+var_A[sp], r1
FFF3EA3E  fbe266200100                      mov.l   #12066h, r14
FFF3EA44  660f                              mov.l   #0, r15
FFF3EA46  fe0e1f                            mov.b   r15, [r14, r1]
FFF3EA49  fb1262080100                      mov.l   #10862h, r1
FFF3EA4F  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3EA55  e0e1                              mov.l   [r14], [r1]
FFF3EA57  fb221883edff                      mov.l   #off_FFED8318, r2; "FT3D"
FFF3EA5D  a9a4                              mov.l   18h[r2], r4
FFF3EA5F  fb36ff                            mov.l   #-1, r3
FFF3EA62  6602                              mov.l   #0, r2
FFF3EA64  7f80                              suntil.b
FFF3EA66  6011                              sub     #1, r1
FFF3EA68  ef42                              mov.l   r4, r2
FFF3EA6A  7f87                              smovu
FFF3EA6C  fbe6ff                            mov.l   #-1, r14
FFF3EA6F  660f                              mov.l   #0, r15
FFF3EA71  fb5262080100                      mov.l   #10862h, r5
FFF3EA77  ef51                              mov.l   r5, r1
FFF3EA79  eff2                              mov.l   r15, r2
FFF3EA7B  efe3                              mov.l   r14, r3
FFF3EA7D  7f80                              suntil.b
FFF3EA7F  6011                              sub     #1, r1
FFF3EA81  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3EA87  7f87                              smovu
FFF3EA89  ef51                              mov.l   r5, r1
FFF3EA8B  eff2                              mov.l   r15, r2
FFF3EA8D  efe3                              mov.l   r14, r3
FFF3EA8F  7f80                              suntil.b
FFF3EA91  6011                              sub     #1, r1
FFF3EA93  fb2266200100                      mov.l   #12066h, r2
FFF3EA99  7f87                              smovu
FFF3EA9B  fb36ff                            mov.l   #-1, r3
FFF3EA9E  6602                              mov.l   #0, r2
FFF3EAA0  fb1262080100                      mov.l   #10862h, r1
FFF3EAA6  7f80                              suntil.b
FFF3EAA8  6011                              sub     #1, r1
FFF3EAAA  fb2205b0f4ff                      mov.l   #aWav_0, r2; ".wav"
FFF3EAB0  7f87                              smovu
FFF3EAB2  fb36ff                            mov.l   #-1, r3
FFF3EAB5  fb2262080100                      mov.l   #10862h, r2
FFF3EABB  fb1266200100                      mov.l   #12066h, r1
FFF3EAC1  7f87                              smovu
FFF3EAC3  a889                              mov.l   10h+var_4[sp], r1
FFF3EAC5  fbe2b7220100                      mov.l   #122B7h, r14
FFF3EACB  c11e20                            mov.b   20h[r1], [r14]
FFF3EACE  fbe2b5220100                      mov.l   #122B5h, r14
FFF3EAD4  f8e405                            mov.b   #5, [r14]
FFF3EAD7  3d0200                            mov.w   #0, 10h+var_C[sp]
FFF3EADA  d5000205               loc_FFF3EADA mov.w   10h+var_C[sp], 10h+var_6[sp]
FFF3EADE  b909                              movu.w  10h+var_6[sp], r1
FFF3EAE0  6704                              rtsd    #4
FFF3EAE2  6080                   sub_FFF3EAE2 sub     #8, sp   ; <<<< FUNC sub_FFF3EAE2
FFF3EAE4  3e0100                            mov.l   #0, 8+var_4[sp]
FFF3EAE7  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3EAEA  fbe2b7220100                      mov.l   #122B7h, r14
FFF3EAF0  58ee                              movu.b  [r14], r14
FFF3EAF2  755e10                            cmp     #10h, r14
FFF3EAF5  206b                              beq.b   loc_FFF3EB60
FFF3EAF7  611e                              cmp     #1, r14
FFF3EAF9  203b                              beq.b   loc_FFF3EB34
FFF3EAFB  612e                              cmp     #2, r14
FFF3EAFD  2042                              beq.b   loc_FFF3EB3F
FFF3EAFF  613e                              cmp     #3, r14
FFF3EB01  2049                              beq.b   loc_FFF3EB4A
FFF3EB03  614e                              cmp     #4, r14
FFF3EB05  2050                              beq.b   loc_FFF3EB55
FFF3EB07  610e                              cmp     #0, r14
FFF3EB09  3b8100                            bne.w   loc_FFF3EB8A
FFF3EB0C  fbe2b1220100                      mov.l   #122B1h, r14
FFF3EB12  58ee                              movu.b  [r14], r14
FFF3EB14  610e                              cmp     #0, r14
FFF3EB16  2174                              bne.b   loc_FFF3EB8A
FFF3EB18  fb1266200100                      mov.l   #12066h, r1
FFF3EB1E  392806                            bsr.w   sub_FFF3F146
FFF3EB21  9009                              mov.w   r1, 8+var_6[sp]
FFF3EB23  b809                              movu.w  8+var_6[sp], r1
FFF3EB25  6101                              cmp     #0, r1
FFF3EB27  2163                              bne.b   loc_FFF3EB8A
FFF3EB29  fbe2b1220100                      mov.l   #122B1h, r14
FFF3EB2F  f8e401                            mov.b   #1, [r14]
FFF3EB32  6702                              rtsd    #2
FFF3EB34  fb1266200100           loc_FFF3EB34 mov.l   #12066h, r1
FFF3EB3A  39c506                            bsr.w   sub_FFF3F1FF
FFF3EB3D  6702                              rtsd    #2
FFF3EB3F  fb1266200100           loc_FFF3EB3F mov.l   #12066h, r1
FFF3EB45  39c807                            bsr.w   sub_FFF3F30D
FFF3EB48  6702                              rtsd    #2
FFF3EB4A  fb1266200100           loc_FFF3EB4A mov.l   #12066h, r1
FFF3EB50  39ee08                            bsr.w   sub_FFF3F43E
FFF3EB53  6702                              rtsd    #2
FFF3EB55  fb1266200100           loc_FFF3EB55 mov.l   #12066h, r1
FFF3EB5B  39740a                            bsr.w   sub_FFF3F5CF
FFF3EB5E  6702                              rtsd    #2
FFF3EB60  059b8aff               loc_FFF3EB60 bsr.a   sub_FFF375FB
FFF3EB64  a009                              mov.l   r1, 8+var_4[sp]
FFF3EB66  fbe2fc840600                      mov.l   #684FCh, r14
FFF3EB6C  ecee                              mov.l   [r14], r14
FFF3EB6E  06850e01                          cmp     8+var_4[sp].l, r14
FFF3EB72  2018                              beq.b   loc_FFF3EB8A
FFF3EB74  fbe2fc840600                      mov.l   #684FCh, r14
FFF3EB7A  e10e01                            mov.l   8+var_4[sp], [r14]
FFF3EB7D  a80a                              mov.l   8+var_4[sp], r2
FFF3EB7F  fb1266200100                      mov.l   #12066h, r1
FFF3EB85  39c30a                            bsr.w   sub_FFF3F648
FFF3EB88  6702                              rtsd    #2
FFF3EB8A  6702                   loc_FFF3EB8A rtsd    #2
FFF3EB8C  7ea6                   sub_FFF3EB8C push.l  r6   ; <<<< FUNC sub_FFF3EB8C
FFF3EB8E  7200d4fb                          add     #-42Ch, sp, sp
FFF3EB92  fa05140200                        mov.w   #0, 42Ch+var_4[sp]
FFF3EB97  fa05130200                        mov.w   #0, 42Ch+var_6[sp]
FFF3EB9C  72063404                          add     #42Ch+arg_0, sp, r6
FFF3EBA0  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EBA6  58ee                              movu.b  [r14], r14
FFF3EBA8  610e                              cmp     #0, r14
FFF3EBAA  2011                              beq.b   loc_FFF3EBBB
FFF3EBAC  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EBB2  58ee                              movu.b  [r14], r14
FFF3EBB4  615e                              cmp     #5, r14
FFF3EBB6  15                                beq.s   loc_FFF3EBBB
FFF3EBB7  f80601                            mov.l   #1, 42Ch+var_42C[sp]
FFF3EBBA  0c                                bra.s   loc_FFF3EBBE
FFF3EBBB  f80600                 loc_FFF3EBBB mov.l   #0, 42Ch+var_42C[sp]
FFF3EBBE  ec01                   loc_FFF3EBBE mov.l   42Ch+var_42C[sp], r1
FFF3EBC0  6101                              cmp     #0, r1
FFF3EBC2  2037                              beq.b   loc_FFF3EBF9
FFF3EBC4  5e061402                          movu.w  42Ch+var_4[sp], r6
FFF3EBC8  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EBCE  fbf6a0                            mov.l   #-60h, r15
FFF3EBD1  fe0e6f                            mov.b   r15, [r14, r6]
FFF3EBD4  de061402                          mov.w   42Ch+var_4[sp], r6
FFF3EBD8  6216                              add     #1, r6
FFF3EBDA  db061402                          mov.w   r6, 42Ch+var_4[sp]
FFF3EBDE  5e041402                          movu.w  42Ch+var_4[sp], r4
FFF3EBE2  fb32661f0100                      mov.l   #11F66h, r3
FFF3EBE8  6602                              mov.l   #0, r2
FFF3EBEA  7541ea                            mov.l   #-16h, r1
FFF3EBED  050eebf9                          bsr.a   sub_FFEDD6FB
FFF3EBF1  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3EBF6  38fa01                            bra.w   loc_FFF3EDF0
FFF3EBF9  fbe2b4220100           loc_FFF3EBF9 mov.l   #122B4h, r14
FFF3EBFF  58ee                              movu.b  [r14], r14
FFF3EC01  617e                              cmp     #7, r14
FFF3EC03  2137                              bne.b   loc_FFF3EC3A
FFF3EC05  5e061402                          movu.w  42Ch+var_4[sp], r6
FFF3EC09  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EC0F  fbf6a0                            mov.l   #-60h, r15
FFF3EC12  fe0e6f                            mov.b   r15, [r14, r6]
FFF3EC15  de061402                          mov.w   42Ch+var_4[sp], r6
FFF3EC19  6216                              add     #1, r6
FFF3EC1B  db061402                          mov.w   r6, 42Ch+var_4[sp]
FFF3EC1F  5e041402                          movu.w  42Ch+var_4[sp], r4
FFF3EC23  fb32661f0100                      mov.l   #11F66h, r3
FFF3EC29  6602                              mov.l   #0, r2
FFF3EC2B  7541ea                            mov.l   #-16h, r1
FFF3EC2E  05cdeaf9                          bsr.a   sub_FFEDD6FB
FFF3EC32  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3EC37  38b901                            bra.w   loc_FFF3EDF0
FFF3EC3A  fa090602ffff           loc_FFF3EC3A mov.w   #-1, 42Ch+var_20[sp]
FFF3EC40  fa05100200                        mov.w   #0, 42Ch+var_C[sp]
FFF3EC45  66d3                              mov.l   #0Dh, r3
FFF3EC47  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3EC4D  fb1262080100                      mov.l   #10862h, r1
FFF3EC53  7f87                              smovu
FFF3EC55  fb1262080100                      mov.l   #10862h, r1
FFF3EC5B  eb010401                          mov.l   r1, 42Ch+var_1C[sp]
FFF3EC5F  fa06050100                        mov.l   #0, 42Ch+var_18[sp]
FFF3EC64  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3EC6A  e4e003                            mov.l   [r14], 42Ch+var_420[sp]
FFF3EC6D  a8e4                              mov.l   8[r6], r4
FFF3EC6F  fb36ff                            mov.l   #-1, r3
FFF3EC72  6602                              mov.l   #0, r2
FFF3EC74  71010c                            add     #42Ch+var_420, sp, r1
FFF3EC77  7f80                              suntil.b
FFF3EC79  6011                              sub     #1, r1
FFF3EC7B  ef42                              mov.l   r4, r2
FFF3EC7D  7f87                              smovu
FFF3EC7F  fbe6ff                            mov.l   #-1, r14
FFF3EC82  660f                              mov.l   #0, r15
FFF3EC84  71050c                            add     #42Ch+var_420, sp, r5
FFF3EC87  ef51                              mov.l   r5, r1
FFF3EC89  eff2                              mov.l   r15, r2
FFF3EC8B  efe3                              mov.l   r14, r3
FFF3EC8D  7f80                              suntil.b
FFF3EC8F  6011                              sub     #1, r1
FFF3EC91  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3EC97  7f87                              smovu
FFF3EC99  a8ec                              mov.l   0Ch[r6], r4
FFF3EC9B  ef51                              mov.l   r5, r1
FFF3EC9D  eff2                              mov.l   r15, r2
FFF3EC9F  efe3                              mov.l   r14, r3
FFF3ECA1  7f80                              suntil.b
FFF3ECA3  6011                              sub     #1, r1
FFF3ECA5  ef42                              mov.l   r4, r2
FFF3ECA7  7f87                              smovu
FFF3ECA9  71010c                            add     #42Ch+var_420, sp, r1
FFF3ECAC  eb010601                          mov.l   r1, 42Ch+var_14[sp]
FFF3ECB0  fb36ff                            mov.l   #-1, r3
FFF3ECB3  6602                              mov.l   #0, r2
FFF3ECB5  71010c                            add     #42Ch+var_420, sp, r1
FFF3ECB8  7f80                              suntil.b
FFF3ECBA  fb16fe                            mov.l   #-2, r1
FFF3ECBD  4331                              sub     r3, r1
FFF3ECBF  eb010701                          mov.l   r1, 42Ch+var_10[sp]
FFF3ECC3  72010c04                          add     #42Ch+var_20, sp, r1
FFF3ECC7  055e3ffd                          bsr.a   sub_FFF12C25
FFF3ECCB  db011302                          mov.w   r1, 42Ch+var_6[sp]
FFF3ECCF  5e011302                          movu.w  42Ch+var_6[sp], r1
FFF3ECD3  6101                              cmp     #0, r1
FFF3ECD5  3bc000                            bne.w   loc_FFF3ED95
FFF3ECD8  a882                              mov.l   42Ch+var_424[sp], r2
FFF3ECDA  6532                              or      #3, r2
FFF3ECDC  fb1262080100                      mov.l   #10862h, r1
FFF3ECE2  053f8bfe                          bsr.a   sub_FFF27821
FFF3ECE6  b869                              movu.w  2[r6], r1
FFF3ECE8  6161                              cmp     #6, r1
FFF3ECEA  205a                              beq.b   loc_FFF3ED44
FFF3ECEC  6151                              cmp     #5, r1
FFF3ECEE  3bed00                            bne.w   loc_FFF3EDDB
FFF3ECF1  7100dc                            add     #-24h, sp, sp
FFF3ECF4  754324                            mov.l   #24h, r3 ; '$'
FFF3ECF7  ef01                              mov.l   sp, r1
FFF3ECF9  ef62                              mov.l   r6, r2
FFF3ECFB  7f8f                              smovf
FFF3ECFD  390301                            bsr.w   sub_FFF3EE00
FFF3ED00  710024                            add     #24h, sp, sp ; '$'
FFF3ED03  db011302                          mov.w   r1, 42Ch+var_6[sp]
FFF3ED07  5e061302                          movu.w  42Ch+var_6[sp], r6
FFF3ED0B  6106                              cmp     #0, r6
FFF3ED0D  3ace00                            beq.w   loc_FFF3EDDB
FFF3ED10  66d3                              mov.l   #0Dh, r3
FFF3ED12  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3ED18  fb1262080100                      mov.l   #10862h, r1
FFF3ED1E  7f87                              smovu
FFF3ED20  fb1262080100                      mov.l   #10862h, r1
FFF3ED26  055e44fd                          bsr.a   sub_FFF13184
FFF3ED2A  fbe25f080100                      mov.l   #1085Fh, r14
FFF3ED30  f8e400                            mov.b   #0, [r14]
FFF3ED33  fbe2b4220100                      mov.l   #122B4h, r14
FFF3ED39  f8e400                            mov.b   #0, [r14]
FFF3ED3C  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3ED41  38af00                            bra.w   loc_FFF3EDF0
FFF3ED44  7100dc                 loc_FFF3ED44 add     #-24h, sp, sp
FFF3ED47  754324                            mov.l   #24h, r3 ; '$'
FFF3ED4A  ef01                              mov.l   sp, r1
FFF3ED4C  ef62                              mov.l   r6, r2
FFF3ED4E  7f8f                              smovf
FFF3ED50  397a01                            bsr.w   sub_FFF3EECA
FFF3ED53  710024                            add     #24h, sp, sp ; '$'
FFF3ED56  db011302                          mov.w   r1, 42Ch+var_6[sp]
FFF3ED5A  5e011302                          movu.w  42Ch+var_6[sp], r1
FFF3ED5E  6101                              cmp     #0, r1
FFF3ED60  207b                              beq.b   loc_FFF3EDDB
FFF3ED62  66d3                              mov.l   #0Dh, r3
FFF3ED64  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3ED6A  fb1262080100                      mov.l   #10862h, r1
FFF3ED70  7f87                              smovu
FFF3ED72  fb1262080100                      mov.l   #10862h, r1
FFF3ED78  050c44fd                          bsr.a   sub_FFF13184
FFF3ED7C  fbe25f080100                      mov.l   #1085Fh, r14
FFF3ED82  f8e400                            mov.b   #0, [r14]
FFF3ED85  fbe2b4220100                      mov.l   #122B4h, r14
FFF3ED8B  f8e400                            mov.b   #0, [r14]
FFF3ED8E  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3ED93  2e5d                              bra.b   loc_FFF3EDF0
FFF3ED95  5e011402               loc_FFF3ED95 movu.w  42Ch+var_4[sp], r1
FFF3ED99  fbe2661f0100                      mov.l   #11F66h, r14
FFF3ED9F  fbf6a0                            mov.l   #-60h, r15
FFF3EDA2  fe0e1f                            mov.b   r15, [r14, r1]
FFF3EDA5  de011402                          mov.w   42Ch+var_4[sp], r1
FFF3EDA9  6211                              add     #1, r1
FFF3EDAB  db011402                          mov.w   r1, 42Ch+var_4[sp]
FFF3EDAF  5e041402                          movu.w  42Ch+var_4[sp], r4
FFF3EDB3  fb32661f0100                      mov.l   #11F66h, r3
FFF3EDB9  6602                              mov.l   #0, r2
FFF3EDBB  7541ea                            mov.l   #-16h, r1
FFF3EDBE  053de9f9                          bsr.a   sub_FFEDD6FB
FFF3EDC2  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EDC8  f8e400                            mov.b   #0, [r14]
FFF3EDCB  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EDD1  f8e400                            mov.b   #0, [r14]
FFF3EDD4  f90903ffff                        mov.w   #-1, 42Ch+var_426[sp]
FFF3EDD9  2e17                              bra.b   loc_FFF3EDF0
FFF3EDDB  fbe2b6220100           loc_FFF3EDDB mov.l   #122B6h, r14
FFF3EDE1  f8e403                            mov.b   #3, [r14]
FFF3EDE4  754264                            mov.l   #64h, r2 ; 'd'
FFF3EDE7  6641                              mov.l   #4, r1
FFF3EDE9  05efb0ff                          bsr.a   sub_FFF39ED8
FFF3EDED  3d0300                            mov.w   #0, 42Ch+var_426[sp]
FFF3EDF0  d900031502             loc_FFF3EDF0 mov.w   42Ch+var_426[sp], 42Ch+var_2[sp]
FFF3EDF5  5e011502                          movu.w  42Ch+var_2[sp], r1
FFF3EDF9  72002c04                          add     #42Ch, sp, sp
FFF3EDFD  7eb6                              pop     r6
FFF3EDFF  02                                rts
FFF3EE00  6080                   sub_FFF3EE00 sub     #8, sp   ; <<<< FUNC sub_FFF3EE00
FFF3EE02  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3EE05  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3EE08  71040c                            add     #8+arg_0, sp, r4
FFF3EE0B  fb1262080100                      mov.l   #10862h, r1
FFF3EE11  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3EE17  e0e1                              mov.l   [r14], [r1]
FFF3EE19  a8c5                              mov.l   8[r4], r5
FFF3EE1B  fb36ff                            mov.l   #-1, r3
FFF3EE1E  6602                              mov.l   #0, r2
FFF3EE20  7f80                              suntil.b
FFF3EE22  6011                              sub     #1, r1
FFF3EE24  ef52                              mov.l   r5, r2
FFF3EE26  7f87                              smovu
FFF3EE28  fbe6ff                            mov.l   #-1, r14
FFF3EE2B  660f                              mov.l   #0, r15
FFF3EE2D  fb5262080100                      mov.l   #10862h, r5
FFF3EE33  ef51                              mov.l   r5, r1
FFF3EE35  eff2                              mov.l   r15, r2
FFF3EE37  efe3                              mov.l   r14, r3
FFF3EE39  7f80                              suntil.b
FFF3EE3B  6011                              sub     #1, r1
FFF3EE3D  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3EE43  7f87                              smovu
FFF3EE45  a8cc                              mov.l   0Ch[r4], r4
FFF3EE47  ef51                              mov.l   r5, r1
FFF3EE49  eff2                              mov.l   r15, r2
FFF3EE4B  efe3                              mov.l   r14, r3
FFF3EE4D  7f80                              suntil.b
FFF3EE4F  6011                              sub     #1, r1
FFF3EE51  ef42                              mov.l   r4, r2
FFF3EE53  7f87                              smovu
FFF3EE55  fb22a5f8f3ff                      mov.l   #sub_FFF3F8A5, r2
FFF3EE5B  fb1262080100                      mov.l   #10862h, r1
FFF3EE61  054a5bfd                          bsr.a   sub_FFF149AB
FFF3EE65  9081                              mov.w   r1, 8+var_4[sp]
FFF3EE67  b881                              movu.w  8+var_4[sp], r1
FFF3EE69  6101                              cmp     #0, r1
FFF3EE6B  b809                              movu.w  8+var_6[sp], r1
FFF3EE6D  2028                              beq.b   loc_FFF3EE95
FFF3EE6F  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EE75  fbf6a0                            mov.l   #-60h, r15
FFF3EE78  fe01ef                            mov.b   r15, [r1, r14]
FFF3EE7B  9809                              mov.w   8+var_6[sp], r1
FFF3EE7D  6211                              add     #1, r1
FFF3EE7F  9009                              mov.w   r1, 8+var_6[sp]
FFF3EE81  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EE87  f8e400                            mov.b   #0, [r14]
FFF3EE8A  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EE90  f8e400                            mov.b   #0, [r14]
FFF3EE93  2e1c                              bra.b   loc_FFF3EEAF
FFF3EE95  fbe2661f0100           loc_FFF3EE95 mov.l   #11F66h, r14
FFF3EE9B  660f                              mov.l   #0, r15
FFF3EE9D  fe01ef                            mov.b   r15, [r1, r14]
FFF3EEA0  9809                              mov.w   8+var_6[sp], r1
FFF3EEA2  6211                              add     #1, r1
FFF3EEA4  9009                              mov.w   r1, 8+var_6[sp]
FFF3EEA6  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EEAC  f8e40d                            mov.b   #0Dh, [r14]
FFF3EEAF  b80c                   loc_FFF3EEAF movu.w  8+var_6[sp], r4
FFF3EEB1  fb32661f0100                      mov.l   #11F66h, r3
FFF3EEB7  6602                              mov.l   #0, r2
FFF3EEB9  7541ea                            mov.l   #-16h, r1
FFF3EEBC  053fe8f9                          bsr.a   sub_FFEDD6FB
FFF3EEC0  d5000203                          mov.w   8+var_4[sp], 8+var_2[sp]
FFF3EEC4  9889                              mov.w   8+var_2[sp], r1
FFF3EEC6  5f11                              movu.w  r1, r1
FFF3EEC8  6702                              rtsd    #2
FFF3EECA  6080                   sub_FFF3EECA sub     #8, sp   ; <<<< FUNC sub_FFF3EECA
FFF3EECC  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3EECF  3d0100                            mov.w   #0, 8+var_6[sp]
FFF3EED2  71040c                            add     #8+arg_0, sp, r4
FFF3EED5  fb1262080100                      mov.l   #10862h, r1
FFF3EEDB  fbe2f3aff4ff                      mov.l   #unk_FFF4AFF3, r14
FFF3EEE1  e0e1                              mov.l   [r14], [r1]
FFF3EEE3  a8c5                              mov.l   8[r4], r5
FFF3EEE5  fb36ff                            mov.l   #-1, r3
FFF3EEE8  6602                              mov.l   #0, r2
FFF3EEEA  7f80                              suntil.b
FFF3EEEC  6011                              sub     #1, r1
FFF3EEEE  ef52                              mov.l   r5, r2
FFF3EEF0  7f87                              smovu
FFF3EEF2  fbe6ff                            mov.l   #-1, r14
FFF3EEF5  660f                              mov.l   #0, r15
FFF3EEF7  fb5262080100                      mov.l   #10862h, r5
FFF3EEFD  ef51                              mov.l   r5, r1
FFF3EEFF  eff2                              mov.l   r15, r2
FFF3EF01  efe3                              mov.l   r14, r3
FFF3EF03  7f80                              suntil.b
FFF3EF05  6011                              sub     #1, r1
FFF3EF07  fb2203b0f4ff                      mov.l   #asc_FFF4B003, r2; "\\"
FFF3EF0D  7f87                              smovu
FFF3EF0F  a8cc                              mov.l   0Ch[r4], r4
FFF3EF11  ef51                              mov.l   r5, r1
FFF3EF13  eff2                              mov.l   r15, r2
FFF3EF15  efe3                              mov.l   r14, r3
FFF3EF17  7f80                              suntil.b
FFF3EF19  6011                              sub     #1, r1
FFF3EF1B  ef42                              mov.l   r4, r2
FFF3EF1D  7f87                              smovu
FFF3EF1F  fb22a5f8f3ff                      mov.l   #sub_FFF3F8A5, r2
FFF3EF25  fb1262080100                      mov.l   #10862h, r1
FFF3EF2B  05cf5cfd                          bsr.a   sub_FFF14BFA
FFF3EF2F  9081                              mov.w   r1, 8+var_4[sp]
FFF3EF31  b881                              movu.w  8+var_4[sp], r1
FFF3EF33  6101                              cmp     #0, r1
FFF3EF35  b809                              movu.w  8+var_6[sp], r1
FFF3EF37  2028                              beq.b   loc_FFF3EF5F
FFF3EF39  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EF3F  fbf6a0                            mov.l   #-60h, r15
FFF3EF42  fe01ef                            mov.b   r15, [r1, r14]
FFF3EF45  9809                              mov.w   8+var_6[sp], r1
FFF3EF47  6211                              add     #1, r1
FFF3EF49  9009                              mov.w   r1, 8+var_6[sp]
FFF3EF4B  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EF51  f8e400                            mov.b   #0, [r14]
FFF3EF54  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EF5A  f8e400                            mov.b   #0, [r14]
FFF3EF5D  2e1c                              bra.b   loc_FFF3EF79
FFF3EF5F  fbe2661f0100           loc_FFF3EF5F mov.l   #11F66h, r14
FFF3EF65  660f                              mov.l   #0, r15
FFF3EF67  fe01ef                            mov.b   r15, [r1, r14]
FFF3EF6A  9809                              mov.w   8+var_6[sp], r1
FFF3EF6C  6211                              add     #1, r1
FFF3EF6E  9009                              mov.w   r1, 8+var_6[sp]
FFF3EF70  fbe25f080100                      mov.l   #1085Fh, r14
FFF3EF76  f8e40d                            mov.b   #0Dh, [r14]
FFF3EF79  b80c                   loc_FFF3EF79 movu.w  8+var_6[sp], r4
FFF3EF7B  fb32661f0100                      mov.l   #11F66h, r3
FFF3EF81  6602                              mov.l   #0, r2
FFF3EF83  7541ea                            mov.l   #-16h, r1
FFF3EF86  0575e7f9                          bsr.a   sub_FFEDD6FB
FFF3EF8A  d5000203                          mov.w   8+var_4[sp], 8+var_2[sp]
FFF3EF8E  9889                              mov.w   8+var_2[sp], r1
FFF3EF90  5f11                              movu.w  r1, r1
FFF3EF92  6702                              rtsd    #2
FFF3EF94  60c0                   sub_FFF3EF94 sub     #0Ch, sp   ; <<<< FUNC sub_FFF3EF94
FFF3EF96  3d0400                            mov.w   #0, 0Ch+var_4[sp]
FFF3EF99  3d0300                            mov.w   #0, 0Ch+var_6[sp]
FFF3EF9C  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EFA2  58ee                              movu.b  [r14], r14
FFF3EFA4  617e                              cmp     #7, r14
FFF3EFA6  2011                              beq.b   loc_FFF3EFB7
FFF3EFA8  fbe2b4220100                      mov.l   #122B4h, r14
FFF3EFAE  58ee                              movu.b  [r14], r14
FFF3EFB0  619e                              cmp     #9, r14
FFF3EFB2  15                                beq.s   loc_FFF3EFB7
FFF3EFB3  f80601                            mov.l   #1, 0Ch+var_C[sp]
FFF3EFB6  0c                                bra.s   loc_FFF3EFBA
FFF3EFB7  f80600                 loc_FFF3EFB7 mov.l   #0, 0Ch+var_C[sp]
FFF3EFBA  ec01                   loc_FFF3EFBA mov.l   0Ch+var_C[sp], r1
FFF3EFBC  6101                              cmp     #0, r1
FFF3EFBE  10                                beq.s   loc_FFF3EFC6
FFF3EFBF  f90902ffff                        mov.w   #-1, 0Ch+var_8[sp]
FFF3EFC4  2e6b                              bra.b   loc_FFF3F02F
FFF3EFC6  05295bfd               loc_FFF3EFC6 bsr.a   sub_FFF14AEF
FFF3EFCA  9101                              mov.w   r1, 0Ch+var_4[sp]
FFF3EFCC  b901                              movu.w  0Ch+var_4[sp], r1
FFF3EFCE  6101                              cmp     #0, r1
FFF3EFD0  2029                              beq.b   loc_FFF3EFF9
FFF3EFD2  b889                              movu.w  0Ch+var_6[sp], r1
FFF3EFD4  fbe2661f0100                      mov.l   #11F66h, r14
FFF3EFDA  fbf6a0                            mov.l   #-60h, r15
FFF3EFDD  fe0e1f                            mov.b   r15, [r14, r1]
FFF3EFE0  9889                              mov.w   0Ch+var_6[sp], r1
FFF3EFE2  6211                              add     #1, r1
FFF3EFE4  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF3EFE6  b88c                              movu.w  0Ch+var_6[sp], r4
FFF3EFE8  fb32661f0100                      mov.l   #11F66h, r3
FFF3EFEE  6602                              mov.l   #0, r2
FFF3EFF0  7541ea                            mov.l   #-16h, r1
FFF3EFF3  0508e7f9                          bsr.a   sub_FFEDD6FB
FFF3EFF7  2e1a                              bra.b   loc_FFF3F011
FFF3EFF9  fbe2b4220100           loc_FFF3EFF9 mov.l   #122B4h, r14
FFF3EFFF  f8e408                            mov.b   #8, [r14]
FFF3F002  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F008  f8e400                            mov.b   #0, [r14]
FFF3F00B  6641                              mov.l   #4, r1
FFF3F00D  0558afff                          bsr.a   sub_FFF39F65
FFF3F011  66d3                   loc_FFF3F011 mov.l   #0Dh, r3
FFF3F013  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3F019  fb1262080100                      mov.l   #10862h, r1
FFF3F01F  7f87                              smovu
FFF3F021  fb1262080100                      mov.l   #10862h, r1
FFF3F027  055d41fd                          bsr.a   sub_FFF13184
FFF3F02B  d5000402                          mov.w   0Ch+var_4[sp], 0Ch+var_8[sp]
FFF3F02F  d5000205               loc_FFF3F02F mov.w   0Ch+var_8[sp], 0Ch+var_2[sp]
FFF3F033  b909                              movu.w  0Ch+var_2[sp], r1
FFF3F035  6703                              rtsd    #3
FFF3F037  60c0                   sub_FFF3F037 sub     #0Ch, sp   ; <<<< FUNC sub_FFF3F037
FFF3F039  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3F03B  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF3F03E  3d0100                            mov.w   #0, 0Ch+var_A[sp]
FFF3F041  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F047  58ee                              movu.b  [r14], r14
FFF3F049  619e                              cmp     #9, r14
FFF3F04B  1f                                bne.s   loc_FFF3F052
FFF3F04C  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF3F050  2e63                              bra.b   loc_FFF3F0B3
FFF3F052  05765bfd               loc_FFF3F052 bsr.a   sub_FFF14BC8
FFF3F056  9081                              mov.w   r1, 0Ch+var_8[sp]
FFF3F058  b881                              movu.w  0Ch+var_8[sp], r1
FFF3F05A  6101                              cmp     #0, r1
FFF3F05C  2018                              beq.b   loc_FFF3F074
FFF3F05E  b809                              movu.w  0Ch+var_A[sp], r1
FFF3F060  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F066  fbf6a0                            mov.l   #-60h, r15
FFF3F069  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F06C  9809                              mov.w   0Ch+var_A[sp], r1
FFF3F06E  6211                              add     #1, r1
FFF3F070  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF3F072  2e2d                              bra.b   loc_FFF3F09F
FFF3F074  fbe2b4220100           loc_FFF3F074 mov.l   #122B4h, r14
FFF3F07A  f8e409                            mov.b   #9, [r14]
FFF3F07D  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F083  f8e400                            mov.b   #0, [r14]
FFF3F086  6641                              mov.l   #4, r1
FFF3F088  05ddaeff                          bsr.a   sub_FFF39F65
FFF3F08C  b809                              movu.w  0Ch+var_A[sp], r1
FFF3F08E  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F094  660f                              mov.l   #0, r15
FFF3F096  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F099  9809                              mov.w   0Ch+var_A[sp], r1
FFF3F09B  6211                              add     #1, r1
FFF3F09D  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF3F09F  b80c                   loc_FFF3F09F movu.w  0Ch+var_A[sp], r4
FFF3F0A1  fb32661f0100                      mov.l   #11F66h, r3
FFF3F0A7  6602                              mov.l   #0, r2
FFF3F0A9  7541ea                            mov.l   #-16h, r1
FFF3F0AC  054fe6f9                          bsr.a   sub_FFEDD6FB
FFF3F0B0  d10002                            mov.w   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF3F0B3  d40003                 loc_FFF3F0B3 mov.w   0Ch+var_C[sp], 0Ch+var_6[sp]
FFF3F0B6  b889                              movu.w  0Ch+var_6[sp], r1
FFF3F0B8  6703                              rtsd    #3
FFF3F0BA  60c0                   sub_FFF3F0BA sub     #0Ch, sp   ; <<<< FUNC sub_FFF3F0BA
FFF3F0BC  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3F0BE  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF3F0C1  3d0100                            mov.w   #0, 0Ch+var_A[sp]
FFF3F0C4  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F0CA  58ee                              movu.b  [r14], r14
FFF3F0CC  619e                              cmp     #9, r14
FFF3F0CE  17                                beq.s   loc_FFF3F0D5
FFF3F0CF  f809ffff                          mov.w   #-1, 0Ch+var_C[sp]
FFF3F0D3  2e6c                              bra.b   loc_FFF3F13F
FFF3F0D5  05655cfd               loc_FFF3F0D5 bsr.a   sub_FFF14D3A
FFF3F0D9  9081                              mov.w   r1, 0Ch+var_8[sp]
FFF3F0DB  b881                              movu.w  0Ch+var_8[sp], r1
FFF3F0DD  6101                              cmp     #0, r1
FFF3F0DF  2018                              beq.b   loc_FFF3F0F7
FFF3F0E1  b809                              movu.w  0Ch+var_A[sp], r1
FFF3F0E3  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F0E9  fbf6a0                            mov.l   #-60h, r15
FFF3F0EC  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F0EF  9809                              mov.w   0Ch+var_A[sp], r1
FFF3F0F1  6211                              add     #1, r1
FFF3F0F3  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF3F0F5  2e36                              bra.b   loc_FFF3F12B
FFF3F0F7  fbe2b4220100           loc_FFF3F0F7 mov.l   #122B4h, r14
FFF3F0FD  f8e407                            mov.b   #7, [r14]
FFF3F100  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F106  f8e400                            mov.b   #0, [r14]
FFF3F109  6641                              mov.l   #4, r1
FFF3F10B  055aaeff                          bsr.a   sub_FFF39F65
FFF3F10F  b809                              movu.w  0Ch+var_A[sp], r1
FFF3F111  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F117  660f                              mov.l   #0, r15
FFF3F119  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F11C  9809                              mov.w   0Ch+var_A[sp], r1
FFF3F11E  6211                              add     #1, r1
FFF3F120  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF3F122  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F128  f8e40d                            mov.b   #0Dh, [r14]
FFF3F12B  b80c                   loc_FFF3F12B movu.w  0Ch+var_A[sp], r4
FFF3F12D  fb32661f0100                      mov.l   #11F66h, r3
FFF3F133  6602                              mov.l   #0, r2
FFF3F135  7541ea                            mov.l   #-16h, r1
FFF3F138  05c3e5f9                          bsr.a   sub_FFEDD6FB
FFF3F13C  d10002                            mov.w   0Ch+var_8[sp], 0Ch+var_C[sp]
FFF3F13F  d40003                 loc_FFF3F13F mov.w   0Ch+var_C[sp], 0Ch+var_6[sp]
FFF3F142  b889                              movu.w  0Ch+var_6[sp], r1
FFF3F144  6703                              rtsd    #3
FFF3F146  7100f0                 sub_FFF3F146 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF3F146
FFF3F149  a089                              mov.l   r1, 10h+var_4[sp]
FFF3F14B  3d0400                            mov.w   #0, 10h+var_8[sp]
FFF3F14E  3d0300                            mov.w   #0, 10h+var_A[sp]
FFF3F151  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F157  58ee                              movu.b  [r14], r14
FFF3F159  612e                              cmp     #2, r14
FFF3F15B  200d                              beq.b   loc_FFF3F168
FFF3F15D  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F163  58ee                              movu.b  [r14], r14
FFF3F165  611e                              cmp     #1, r14
FFF3F167  1d                                bne.s   loc_FFF3F16C
FFF3F168  f80601                 loc_FFF3F168 mov.l   #1, 10h+var_10[sp]
FFF3F16B  0c                                bra.s   loc_FFF3F16F
FFF3F16C  f80600                 loc_FFF3F16C mov.l   #0, 10h+var_10[sp]
FFF3F16F  ec01                   loc_FFF3F16F mov.l   10h+var_10[sp], r1
FFF3F171  6101                              cmp     #0, r1
FFF3F173  10                                beq.s   loc_FFF3F17B
FFF3F174  f90902ffff                        mov.w   #-1, 10h+var_C[sp]
FFF3F179  2e7e                              bra.b   loc_FFF3F1F7
FFF3F17B  fbe2b4220100           loc_FFF3F17B mov.l   #122B4h, r14
FFF3F181  f8e401                            mov.b   #1, [r14]
FFF3F184  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F18A  f8e400                            mov.b   #0, [r14]
FFF3F18D  6641                              mov.l   #4, r1
FFF3F18F  05d6adff                          bsr.a   sub_FFF39F65
FFF3F193  a889                              mov.l   10h+var_4[sp], r1
FFF3F195  fb32cbf7f3ff                      mov.l   #sub_FFF3F7CB, r3
FFF3F19B  6602                              mov.l   #0, r2
FFF3F19D  05e250fd                          bsr.a   sub_FFF1427F
FFF3F1A1  9101                              mov.w   r1, 10h+var_8[sp]
FFF3F1A3  b901                              movu.w  10h+var_8[sp], r1
FFF3F1A5  6101                              cmp     #0, r1
FFF3F1A7  b889                              movu.w  10h+var_A[sp], r1
FFF3F1A9  201f                              beq.b   loc_FFF3F1C8
FFF3F1AB  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F1B1  fbf6a0                            mov.l   #-60h, r15
FFF3F1B4  fe01ef                            mov.b   r15, [r1, r14]
FFF3F1B7  9889                              mov.w   10h+var_A[sp], r1
FFF3F1B9  6211                              add     #1, r1
FFF3F1BB  9089                              mov.w   r1, 10h+var_A[sp]
FFF3F1BD  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F1C3  f8e400                            mov.b   #0, [r14]
FFF3F1C6  2e1c                              bra.b   loc_FFF3F1E2
FFF3F1C8  fbe2661f0100           loc_FFF3F1C8 mov.l   #11F66h, r14
FFF3F1CE  660f                              mov.l   #0, r15
FFF3F1D0  fe01ef                            mov.b   r15, [r1, r14]
FFF3F1D3  9889                              mov.w   10h+var_A[sp], r1
FFF3F1D5  6211                              add     #1, r1
FFF3F1D7  9089                              mov.w   r1, 10h+var_A[sp]
FFF3F1D9  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F1DF  f8e40c                            mov.b   #0Ch, [r14]
FFF3F1E2  b88c                   loc_FFF3F1E2 movu.w  10h+var_A[sp], r4
FFF3F1E4  fb32661f0100                      mov.l   #11F66h, r3
FFF3F1EA  6602                              mov.l   #0, r2
FFF3F1EC  7541ea                            mov.l   #-16h, r1
FFF3F1EF  050ce5f9                          bsr.a   sub_FFEDD6FB
FFF3F1F3  d5000402                          mov.w   10h+var_8[sp], 10h+var_C[sp]
FFF3F1F7  d5000205               loc_FFF3F1F7 mov.w   10h+var_C[sp], 10h+var_6[sp]
FFF3F1FB  b909                              movu.w  10h+var_6[sp], r1
FFF3F1FD  6704                              rtsd    #4
FFF3F1FF  7200dcfe               sub_FFF3F1FF add     #-124h, sp, sp   ; <<<< FUNC sub_FFF3F1FF
FFF3F203  e70148                            mov.l   r1, 124h+var_4[sp]
FFF3F206  f9058e00                          mov.w   #0, 124h+var_8[sp]
FFF3F20A  f9058d00                          mov.w   #0, 124h+var_A[sp]
FFF3F20E  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F214  58ee                              movu.b  [r14], r14
FFF3F216  612e                              cmp     #2, r14
FFF3F218  200d                              beq.b   loc_FFF3F225
FFF3F21A  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F220  58ee                              movu.b  [r14], r14
FFF3F222  611e                              cmp     #1, r14
FFF3F224  1d                                bne.s   loc_FFF3F229
FFF3F225  f80601                 loc_FFF3F225 mov.l   #1, 124h+var_124[sp]
FFF3F228  0c                                bra.s   loc_FFF3F22C
FFF3F229  f80600                 loc_FFF3F229 mov.l   #0, 124h+var_124[sp]
FFF3F22C  ec01                   loc_FFF3F22C mov.l   124h+var_124[sp], r1
FFF3F22E  6101                              cmp     #0, r1
FFF3F230  11                                beq.s   loc_FFF3F239
FFF3F231  f90903ffff                        mov.w   #-1, 124h+var_11E[sp]
FFF3F236  38ce00                            bra.w   loc_FFF3F304
FFF3F239  fbe2b4220100           loc_FFF3F239 mov.l   #122B4h, r14
FFF3F23F  f8e402                            mov.b   #2, [r14]
FFF3F242  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F248  f8e400                            mov.b   #0, [r14]
FFF3F24B  6641                              mov.l   #4, r1
FFF3F24D  0518adff                          bsr.a   sub_FFF39F65
FFF3F251  710108                            add     #124h+var_11C, sp, r1
FFF3F254  05185bfd                          bsr.a   sub_FFF14D6C
FFF3F258  fb36ff                            mov.l   #-1, r3
FFF3F25B  ed0248                            mov.l   124h+var_4[sp], r2
FFF3F25E  71010a                            add     #124h+var_11A, sp, r1
FFF3F261  7f83                              scmpu
FFF3F263  fcdb12                            scgeu.l r1
FFF3F266  fcdbe5                            scleu.l r14
FFF3F269  43e1                              sub     r14, r1
FFF3F26B  d7018e                            mov.w   r1, 124h+var_8[sp]
FFF3F26E  5d018e                            movu.w  124h+var_8[sp], r1
FFF3F271  6101                              cmp     #0, r1
FFF3F273  201b                              beq.b   loc_FFF3F28E
FFF3F275  f9064400                          mov.l   #0, 124h+var_14[sp]
FFF3F279  ed0244                            mov.l   124h+var_14[sp], r2
FFF3F27C  ed0148                            mov.l   124h+var_4[sp], r1
FFF3F27F  fb32cbf7f3ff                      mov.l   #sub_FFF3F7CB, r3
FFF3F285  05fa4ffd                          bsr.a   sub_FFF1427F
FFF3F289  d7018e                            mov.w   r1, 124h+var_8[sp]
FFF3F28C  2e1d                              bra.b   loc_FFF3F2A9
FFF3F28E  ed0e44                 loc_FFF3F28E mov.l   124h+var_14[sp], r14
FFF3F291  755e2c                            cmp     #2Ch, r14 ; ','
FFF3F294  2406                              bgtu.b  loc_FFF3F29A
FFF3F296  f9064400                          mov.l   #0, 124h+var_14[sp]
FFF3F29A  ed0244                 loc_FFF3F29A mov.l   124h+var_14[sp], r2
FFF3F29D  ed0148                            mov.l   124h+var_4[sp], r1
FFF3F2A0  6613                              mov.l   #1, r3
FFF3F2A2  059151fd                          bsr.a   sub_FFF14433
FFF3F2A6  d7018e                            mov.w   r1, 124h+var_8[sp]
FFF3F2A9  5d018e                 loc_FFF3F2A9 movu.w  124h+var_8[sp], r1
FFF3F2AC  6101                              cmp     #0, r1
FFF3F2AE  5d018d                            movu.w  124h+var_A[sp], r1
FFF3F2B1  2021                              beq.b   loc_FFF3F2D2
FFF3F2B3  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F2B9  fbf6a0                            mov.l   #-60h, r15
FFF3F2BC  fe01ef                            mov.b   r15, [r1, r14]
FFF3F2BF  dd018d                            mov.w   124h+var_A[sp], r1
FFF3F2C2  6211                              add     #1, r1
FFF3F2C4  d7018d                            mov.w   r1, 124h+var_A[sp]
FFF3F2C7  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F2CD  f8e400                            mov.b   #0, [r14]
FFF3F2D0  2e1e                              bra.b   loc_FFF3F2EE
FFF3F2D2  fbe2661f0100           loc_FFF3F2D2 mov.l   #11F66h, r14
FFF3F2D8  660f                              mov.l   #0, r15
FFF3F2DA  fe01ef                            mov.b   r15, [r1, r14]
FFF3F2DD  dd018d                            mov.w   124h+var_A[sp], r1
FFF3F2E0  6211                              add     #1, r1
FFF3F2E2  d7018d                            mov.w   r1, 124h+var_A[sp]
FFF3F2E5  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F2EB  f8e40c                            mov.b   #0Ch, [r14]
FFF3F2EE  5d048d                 loc_FFF3F2EE movu.w  124h+var_A[sp], r4
FFF3F2F1  fb32661f0100                      mov.l   #11F66h, r3
FFF3F2F7  6602                              mov.l   #0, r2
FFF3F2F9  7541ea                            mov.l   #-16h, r1
FFF3F2FC  05ffe3f9                          bsr.a   sub_FFEDD6FB
FFF3F300  d5008e03                          mov.w   124h+var_8[sp], 124h+var_11E[sp]
FFF3F304  d500038f               loc_FFF3F304 mov.w   124h+var_11E[sp], 124h+var_6[sp]
FFF3F308  5d018f                            movu.w  124h+var_6[sp], r1
FFF3F30B  6749                              rtsd    #49h
FFF3F30D  7200e0fe               sub_FFF3F30D add     #-120h, sp, sp   ; <<<< FUNC sub_FFF3F30D
FFF3F311  e70147                            mov.l   r1, 120h+var_4[sp]
FFF3F314  f9058c00                          mov.w   #0, 120h+var_8[sp]
FFF3F318  f9058b00                          mov.w   #0, 120h+var_A[sp]
FFF3F31C  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F322  58ee                              movu.b  [r14], r14
FFF3F324  614e                              cmp     #4, r14
FFF3F326  19                                bne.s   loc_FFF3F32F
FFF3F327  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF3F32C  38fb00                            bra.w   loc_FFF3F427
FFF3F32F  fbe2b4220100           loc_FFF3F32F mov.l   #122B4h, r14
FFF3F335  f8e404                            mov.b   #4, [r14]
FFF3F338  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F33E  f8e401                            mov.b   #1, [r14]
FFF3F341  05ea5efd                          bsr.a   sub_FFF1522B
FFF3F345  058d5dfd                          bsr.a   sub_FFF150D2
FFF3F349  710104                            add     #120h+var_11C, sp, r1
FFF3F34C  05205afd                          bsr.a   sub_FFF14D6C
FFF3F350  fb36ff                            mov.l   #-1, r3
FFF3F353  ed0247                            mov.l   120h+var_4[sp], r2
FFF3F356  710106                            add     #120h+var_11A, sp, r1
FFF3F359  7f83                              scmpu
FFF3F35B  fcdb12                            scgeu.l r1
FFF3F35E  fcdbe5                            scleu.l r14
FFF3F361  43e1                              sub     r14, r1
FFF3F363  d7018c                            mov.w   r1, 120h+var_8[sp]
FFF3F366  5d018c                            movu.w  120h+var_8[sp], r1
FFF3F369  6101                              cmp     #0, r1
FFF3F36B  201b                              beq.b   loc_FFF3F386
FFF3F36D  f906432c                          mov.l   #2Ch, 120h+var_14[sp] ; ','
FFF3F371  ed0243                            mov.l   120h+var_14[sp], r2
FFF3F374  ed0147                            mov.l   120h+var_4[sp], r1
FFF3F377  fb32cbf7f3ff                      mov.l   #sub_FFF3F7CB, r3
FFF3F37D  05f951fd                          bsr.a   sub_FFF14576
FFF3F381  d7018c                            mov.w   r1, 120h+var_8[sp]
FFF3F384  2e11                              bra.b   loc_FFF3F395
FFF3F386  ed0243                 loc_FFF3F386 mov.l   120h+var_14[sp], r2
FFF3F389  ed0147                            mov.l   120h+var_4[sp], r1
FFF3F38C  6623                              mov.l   #2, r3
FFF3F38E  05a550fd                          bsr.a   sub_FFF14433
FFF3F392  d7018c                            mov.w   r1, 120h+var_8[sp]
FFF3F395  5d018c                 loc_FFF3F395 movu.w  120h+var_8[sp], r1
FFF3F398  6101                              cmp     #0, r1
FFF3F39A  5d018b                            movu.w  120h+var_A[sp], r1
FFF3F39D  2050                              beq.b   loc_FFF3F3ED
FFF3F39F  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F3A5  fbf6a0                            mov.l   #-60h, r15
FFF3F3A8  fe01ef                            mov.b   r15, [r1, r14]
FFF3F3AB  dd018b                            mov.w   120h+var_A[sp], r1
FFF3F3AE  6211                              add     #1, r1
FFF3F3B0  d7018b                            mov.w   r1, 120h+var_A[sp]
FFF3F3B3  5d048b                            movu.w  120h+var_A[sp], r4
FFF3F3B6  fb32661f0100                      mov.l   #11F66h, r3
FFF3F3BC  6602                              mov.l   #0, r2
FFF3F3BE  7541ea                            mov.l   #-16h, r1
FFF3F3C1  053ae3f9                          bsr.a   sub_FFEDD6FB
FFF3F3C5  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F3CB  f8e400                            mov.b   #0, [r14]
FFF3F3CE  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F3D4  f8e400                            mov.b   #0, [r14]
FFF3F3D7  6641                              mov.l   #4, r1
FFF3F3D9  058cabff                          bsr.a   sub_FFF39F65
FFF3F3DD  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F3E3  f8e400                            mov.b   #0, [r14]
FFF3F3E6  f90901ffff                        mov.w   #-1, 120h+var_11E[sp]
FFF3F3EB  2e3c                              bra.b   loc_FFF3F427
FFF3F3ED  fbe2661f0100           loc_FFF3F3ED mov.l   #11F66h, r14
FFF3F3F3  660f                              mov.l   #0, r15
FFF3F3F5  fe01ef                            mov.b   r15, [r1, r14]
FFF3F3F8  dd018b                            mov.w   120h+var_A[sp], r1
FFF3F3FB  6211                              add     #1, r1
FFF3F3FD  d7018b                            mov.w   r1, 120h+var_A[sp]
FFF3F400  5d048b                            movu.w  120h+var_A[sp], r4
FFF3F403  fb32661f0100                      mov.l   #11F66h, r3
FFF3F409  6602                              mov.l   #0, r2
FFF3F40B  7541ea                            mov.l   #-16h, r1
FFF3F40E  05ede2f9                          bsr.a   sub_FFEDD6FB
FFF3F412  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F418  f8e40c                            mov.b   #0Ch, [r14]
FFF3F41B  754232                            mov.l   #32h, r2 ; '2'
FFF3F41E  6641                              mov.l   #4, r1
FFF3F420  05b8aaff                          bsr.a   sub_FFF39ED8
FFF3F424  3d0100                            mov.w   #0, 120h+var_11E[sp]
FFF3F427  d500018d               loc_FFF3F427 mov.w   120h+var_11E[sp], 120h+var_6[sp]
FFF3F42B  5d018d                            movu.w  120h+var_6[sp], r1
FFF3F42E  6748                              rtsd    #48h
FFF3F430  05cc52fd               sub_FFF3F430 bsr.a   sub_FFF146FC   ; <<<< FUNC sub_FFF3F430
FFF3F434  754232                            mov.l   #32h, r2 ; '2'
FFF3F437  6641                              mov.l   #4, r1
FFF3F439  059faaff                          bsr.a   sub_FFF39ED8
FFF3F43D  02                                rts
FFF3F43E  7200dcfe               sub_FFF3F43E add     #-124h, sp, sp   ; <<<< FUNC sub_FFF3F43E
FFF3F442  e70148                            mov.l   r1, 124h+var_4[sp]
FFF3F445  f9058e00                          mov.w   #0, 124h+var_8[sp]
FFF3F449  f9058d00                          mov.w   #0, 124h+var_A[sp]
FFF3F44D  f9064500                          mov.l   #0, 124h+var_10[sp]
FFF3F451  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F457  58ee                              movu.b  [r14], r14
FFF3F459  615e                              cmp     #5, r14
FFF3F45B  19                                bne.s   loc_FFF3F464
FFF3F45C  f90901ffff                        mov.w   #-1, 124h+var_122[sp]
FFF3F461  385701                            bra.w   loc_FFF3F5B8
FFF3F464  fbe2b4220100           loc_FFF3F464 mov.l   #122B4h, r14
FFF3F46A  f8e405                            mov.b   #5, [r14]
FFF3F46D  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F473  f8e402                            mov.b   #2, [r14]
FFF3F476  05b55dfd                          bsr.a   sub_FFF1522B
FFF3F47A  05585cfd                          bsr.a   sub_FFF150D2
FFF3F47E  710104                            add     #124h+var_120, sp, r1
FFF3F481  05eb58fd                          bsr.a   sub_FFF14D6C
FFF3F485  fb36ff                            mov.l   #-1, r3
FFF3F488  ed0248                            mov.l   124h+var_4[sp], r2
FFF3F48B  710106                            add     #124h+var_11E, sp, r1
FFF3F48E  7f83                              scmpu
FFF3F490  fcdb12                            scgeu.l r1
FFF3F493  fcdbe5                            scleu.l r14
FFF3F496  43e1                              sub     r14, r1
FFF3F498  d7018e                            mov.w   r1, 124h+var_8[sp]
FFF3F49B  5d018e                            movu.w  124h+var_8[sp], r1
FFF3F49E  6101                              cmp     #0, r1
FFF3F4A0  15                                beq.s   loc_FFF3F4A5
FFF3F4A1  f9064300                          mov.l   #0, 124h+var_18[sp]
FFF3F4A5  ed0e43                 loc_FFF3F4A5 mov.l   124h+var_18[sp], r14
FFF3F4A8  770e008002                        cmp     #28000h, r14
FFF3F4AD  245f                              bgtu.b  loc_FFF3F50C
FFF3F4AF  f9064500                          mov.l   #0, 124h+var_10[sp]
FFF3F4B3  5d018d                            movu.w  124h+var_A[sp], r1
FFF3F4B6  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F4BC  754f11                            mov.l   #11h, r15
FFF3F4BF  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F4C2  dd018d                            mov.w   124h+var_A[sp], r1
FFF3F4C5  6211                              add     #1, r1
FFF3F4C7  d7018d                            mov.w   r1, 124h+var_A[sp]
FFF3F4CA  5d048d                            movu.w  124h+var_A[sp], r4
FFF3F4CD  fb32661f0100                      mov.l   #11F66h, r3
FFF3F4D3  6602                              mov.l   #0, r2
FFF3F4D5  7541ea                            mov.l   #-16h, r1
FFF3F4D8  0523e2f9                          bsr.a   sub_FFEDD6FB
FFF3F4DC  ed0145                            mov.l   124h+var_10[sp], r1
FFF3F4DF  05f180ff                          bsr.a   sub_FFF375D0
FFF3F4E3  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F4E9  f8e400                            mov.b   #0, [r14]
FFF3F4EC  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F4F2  f8e400                            mov.b   #0, [r14]
FFF3F4F5  6641                              mov.l   #4, r1
FFF3F4F7  056eaaff                          bsr.a   sub_FFF39F65
FFF3F4FB  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F501  f8e400                            mov.b   #0, [r14]
FFF3F504  f90901ffff                        mov.w   #-1, 124h+var_122[sp]
FFF3F509  38af00                            bra.w   loc_FFF3F5B8
FFF3F50C  e5004345               loc_FFF3F50C mov.l   124h+var_18[sp], 124h+var_10[sp]
FFF3F510  ed0145                            mov.l   124h+var_10[sp], r1
FFF3F513  05bd80ff                          bsr.a   sub_FFF375D0
FFF3F517  ed0245                            mov.l   124h+var_10[sp], r2
FFF3F51A  ed0148                            mov.l   124h+var_4[sp], r1
FFF3F51D  6623                              mov.l   #2, r3
FFF3F51F  05144ffd                          bsr.a   sub_FFF14433
FFF3F523  d7018e                            mov.w   r1, 124h+var_8[sp]
FFF3F526  5d018e                            movu.w  124h+var_8[sp], r1
FFF3F529  6101                              cmp     #0, r1
FFF3F52B  5d018d                            movu.w  124h+var_A[sp], r1
FFF3F52E  2050                              beq.b   loc_FFF3F57E
FFF3F530  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F536  fbf6a0                            mov.l   #-60h, r15
FFF3F539  fe01ef                            mov.b   r15, [r1, r14]
FFF3F53C  dd018d                            mov.w   124h+var_A[sp], r1
FFF3F53F  6211                              add     #1, r1
FFF3F541  d7018d                            mov.w   r1, 124h+var_A[sp]
FFF3F544  5d048d                            movu.w  124h+var_A[sp], r4
FFF3F547  fb32661f0100                      mov.l   #11F66h, r3
FFF3F54D  6602                              mov.l   #0, r2
FFF3F54F  7541ea                            mov.l   #-16h, r1
FFF3F552  05a9e1f9                          bsr.a   sub_FFEDD6FB
FFF3F556  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F55C  f8e400                            mov.b   #0, [r14]
FFF3F55F  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F565  f8e400                            mov.b   #0, [r14]
FFF3F568  6641                              mov.l   #4, r1
FFF3F56A  05fba9ff                          bsr.a   sub_FFF39F65
FFF3F56E  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F574  f8e400                            mov.b   #0, [r14]
FFF3F577  f90901ffff                        mov.w   #-1, 124h+var_122[sp]
FFF3F57C  2e3c                              bra.b   loc_FFF3F5B8
FFF3F57E  fbe2661f0100           loc_FFF3F57E mov.l   #11F66h, r14
FFF3F584  660f                              mov.l   #0, r15
FFF3F586  fe01ef                            mov.b   r15, [r1, r14]
FFF3F589  dd018d                            mov.w   124h+var_A[sp], r1
FFF3F58C  6211                              add     #1, r1
FFF3F58E  d7018d                            mov.w   r1, 124h+var_A[sp]
FFF3F591  5d048d                            movu.w  124h+var_A[sp], r4
FFF3F594  fb32661f0100                      mov.l   #11F66h, r3
FFF3F59A  6602                              mov.l   #0, r2
FFF3F59C  7541ea                            mov.l   #-16h, r1
FFF3F59F  055ce1f9                          bsr.a   sub_FFEDD6FB
FFF3F5A3  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F5A9  f8e40c                            mov.b   #0Ch, [r14]
FFF3F5AC  754232                            mov.l   #32h, r2 ; '2'
FFF3F5AF  6641                              mov.l   #4, r1
FFF3F5B1  0527a9ff                          bsr.a   sub_FFF39ED8
FFF3F5B5  3d0100                            mov.w   #0, 124h+var_122[sp]
FFF3F5B8  d500018f               loc_FFF3F5B8 mov.w   124h+var_122[sp], 124h+var_6[sp]
FFF3F5BC  5d018f                            movu.w  124h+var_6[sp], r1
FFF3F5BF  6749                              rtsd    #49h
FFF3F5C1  05db51fd               sub_FFF3F5C1 bsr.a   sub_FFF1479C   ; <<<< FUNC sub_FFF3F5C1
FFF3F5C5  754232                            mov.l   #32h, r2 ; '2'
FFF3F5C8  6641                              mov.l   #4, r1
FFF3F5CA  050ea9ff                          bsr.a   sub_FFF39ED8
FFF3F5CE  02                                rts
FFF3F5CF  60c0                   sub_FFF3F5CF sub     #0Ch, sp   ; <<<< FUNC sub_FFF3F5CF
FFF3F5D1  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF3F5D3  3d0200                            mov.w   #0, 0Ch+var_8[sp]
FFF3F5D6  3d0100                            mov.w   #0, 0Ch+var_A[sp]
FFF3F5D9  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F5DF  f8e403                            mov.b   #3, [r14]
FFF3F5E2  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F5E8  f8e400                            mov.b   #0, [r14]
FFF3F5EB  6641                              mov.l   #4, r1
FFF3F5ED  0578a9ff                          bsr.a   sub_FFF39F65
FFF3F5F1  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F5F7  f8e400                            mov.b   #0, [r14]
FFF3F5FA  052953fd                          bsr.a   sub_FFF14923
FFF3F5FE  9081                              mov.w   r1, 0Ch+var_8[sp]
FFF3F600  b881                              movu.w  0Ch+var_8[sp], r1
FFF3F602  6101                              cmp     #0, r1
FFF3F604  b809                              movu.w  0Ch+var_A[sp], r1
FFF3F606  2016                              beq.b   loc_FFF3F61C
FFF3F608  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F60E  fbf6a0                            mov.l   #-60h, r15
FFF3F611  fe01ef                            mov.b   r15, [r1, r14]
FFF3F614  9809                              mov.w   0Ch+var_A[sp], r1
FFF3F616  6211                              add     #1, r1
FFF3F618  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF3F61A  2e13                              bra.b   loc_FFF3F62D
FFF3F61C  fbe2661f0100           loc_FFF3F61C mov.l   #11F66h, r14
FFF3F622  660f                              mov.l   #0, r15
FFF3F624  fe01ef                            mov.b   r15, [r1, r14]
FFF3F627  9809                              mov.w   0Ch+var_A[sp], r1
FFF3F629  6211                              add     #1, r1
FFF3F62B  9009                              mov.w   r1, 0Ch+var_A[sp]
FFF3F62D  b80c                   loc_FFF3F62D movu.w  0Ch+var_A[sp], r4
FFF3F62F  fb32661f0100                      mov.l   #11F66h, r3
FFF3F635  6602                              mov.l   #0, r2
FFF3F637  7541ea                            mov.l   #-16h, r1
FFF3F63A  05c1e0f9                          bsr.a   sub_FFEDD6FB
FFF3F63E  d5000203                          mov.w   0Ch+var_8[sp], 0Ch+var_6[sp]
FFF3F642  9889                              mov.w   0Ch+var_6[sp], r1
FFF3F644  5f11                              movu.w  r1, r1
FFF3F646  6703                              rtsd    #3
FFF3F648  7200d4fe               sub_FFF3F648 add     #-12Ch, sp, sp   ; <<<< FUNC sub_FFF3F648
FFF3F64C  e7014a                            mov.l   r1, 12Ch+var_4[sp]
FFF3F64F  e70249                            mov.l   r2, 12Ch+var_8[sp]
FFF3F652  f9059000                          mov.w   #0, 12Ch+var_C[sp]
FFF3F656  f9058f00                          mov.w   #0, 12Ch+var_E[sp]
FFF3F65A  f9064600                          mov.l   #0, 12Ch+var_14[sp]
FFF3F65E  f9064500                          mov.l   #0, 12Ch+var_18[sp]
FFF3F662  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F668  f8e406                            mov.b   #6, [r14]
FFF3F66B  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F671  f8e400                            mov.b   #0, [r14]
FFF3F674  6641                              mov.l   #4, r1
FFF3F676  05efa8ff                          bsr.a   sub_FFF39F65
FFF3F67A  05b15bfd                          bsr.a   sub_FFF1522B
FFF3F67E  05545afd                          bsr.a   sub_FFF150D2
FFF3F682  710104                            add     #12Ch+var_128, sp, r1
FFF3F685  05e756fd                          bsr.a   sub_FFF14D6C
FFF3F689  fb36ff                            mov.l   #-1, r3
FFF3F68C  ed024a                            mov.l   12Ch+var_4[sp], r2
FFF3F68F  710106                            add     #12Ch+var_126, sp, r1
FFF3F692  7f83                              scmpu
FFF3F694  fcdb12                            scgeu.l r1
FFF3F697  fcdbe5                            scleu.l r14
FFF3F69A  43e1                              sub     r14, r1
FFF3F69C  d70190                            mov.w   r1, 12Ch+var_C[sp]
FFF3F69F  5d0190                            movu.w  12Ch+var_C[sp], r1
FFF3F6A2  6101                              cmp     #0, r1
FFF3F6A4  3a8300                            beq.w   loc_FFF3F727
FFF3F6A7  ed014a                            mov.l   12Ch+var_4[sp], r1
FFF3F6AA  72021401                          add     #12Ch+var_18, sp, r2
FFF3F6AE  055243fd                          bsr.a   sub_FFF13A00
FFF3F6B2  d70190                            mov.w   r1, 12Ch+var_C[sp]
FFF3F6B5  5d0190                            movu.w  12Ch+var_C[sp], r1
FFF3F6B8  6101                              cmp     #0, r1
FFF3F6BA  203c                              beq.b   loc_FFF3F6F6
FFF3F6BC  5d018f                            movu.w  12Ch+var_E[sp], r1
FFF3F6BF  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F6C5  fbf6a0                            mov.l   #-60h, r15
FFF3F6C8  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F6CB  dd018f                            mov.w   12Ch+var_E[sp], r1
FFF3F6CE  6211                              add     #1, r1
FFF3F6D0  d7018f                            mov.w   r1, 12Ch+var_E[sp]
FFF3F6D3  5d048f                            movu.w  12Ch+var_E[sp], r4
FFF3F6D6  fb32661f0100                      mov.l   #11F66h, r3
FFF3F6DC  6602                              mov.l   #0, r2
FFF3F6DE  7541ea                            mov.l   #-16h, r1
FFF3F6E1  051ae0f9                          bsr.a   sub_FFEDD6FB
FFF3F6E5  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F6EB  f8e400                            mov.b   #0, [r14]
FFF3F6EE  f90901ffff                        mov.w   #-1, 12Ch+var_12A[sp]
FFF3F6F3  38cf00                            bra.w   loc_FFF3F7C2
FFF3F6F6  ed0149                 loc_FFF3F6F6 mov.l   12Ch+var_8[sp], r1
FFF3F6F9  06850145                          cmp     12Ch+var_18[sp].l, r1
FFF3F6FD  230c                              bltu.b  loc_FFF3F709
FFF3F6FF  ed0142                            mov.l   12Ch+var_24[sp], r1
FFF3F702  7111d4                            add     #-2Ch, r1, r1
FFF3F705  e70146                            mov.l   r1, 12Ch+var_14[sp]
FFF3F708  0a                                bra.s   loc_FFF3F712
FFF3F709  ed0149                 loc_FFF3F709 mov.l   12Ch+var_8[sp], r1
FFF3F70C  7111d4                            add     #-2Ch, r1, r1
FFF3F70F  e70146                            mov.l   r1, 12Ch+var_14[sp]
FFF3F712  ed0246                 loc_FFF3F712 mov.l   12Ch+var_14[sp], r2
FFF3F715  ed014a                            mov.l   12Ch+var_4[sp], r1
FFF3F718  fb32cbf7f3ff                      mov.l   #sub_FFF3F7CB, r3
FFF3F71E  05614bfd                          bsr.a   sub_FFF1427F
FFF3F722  d70190                            mov.w   r1, 12Ch+var_C[sp]
FFF3F725  2e23                              bra.b   loc_FFF3F748
FFF3F727  ed0149                 loc_FFF3F727 mov.l   12Ch+var_8[sp], r1
FFF3F72A  06850142                          cmp     12Ch+var_24[sp].l, r1
FFF3F72E  2307                              bltu.b  loc_FFF3F735
FFF3F730  e5004246                          mov.l   12Ch+var_24[sp], 12Ch+var_14[sp]
FFF3F734  0d                                bra.s   loc_FFF3F739
FFF3F735  e5004946               loc_FFF3F735 mov.l   12Ch+var_8[sp], 12Ch+var_14[sp]
FFF3F739  ed0246                 loc_FFF3F739 mov.l   12Ch+var_14[sp], r2
FFF3F73C  ed014a                            mov.l   12Ch+var_4[sp], r1
FFF3F73F  6613                              mov.l   #1, r3
FFF3F741  05f24cfd                          bsr.a   sub_FFF14433
FFF3F745  d70190                            mov.w   r1, 12Ch+var_C[sp]
FFF3F748  5d0190                 loc_FFF3F748 movu.w  12Ch+var_C[sp], r1
FFF3F74B  6101                              cmp     #0, r1
FFF3F74D  5d018f                            movu.w  12Ch+var_E[sp], r1
FFF3F750  2041                              beq.b   loc_FFF3F791
FFF3F752  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F758  fbf6a0                            mov.l   #-60h, r15
FFF3F75B  fe01ef                            mov.b   r15, [r1, r14]
FFF3F75E  dd018f                            mov.w   12Ch+var_E[sp], r1
FFF3F761  6211                              add     #1, r1
FFF3F763  d7018f                            mov.w   r1, 12Ch+var_E[sp]
FFF3F766  5d048f                            movu.w  12Ch+var_E[sp], r4
FFF3F769  fb32661f0100                      mov.l   #11F66h, r3
FFF3F76F  6602                              mov.l   #0, r2
FFF3F771  7541ea                            mov.l   #-16h, r1
FFF3F774  0587dff9                          bsr.a   sub_FFEDD6FB
FFF3F778  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F77E  f8e400                            mov.b   #0, [r14]
FFF3F781  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F787  f8e400                            mov.b   #0, [r14]
FFF3F78A  f90901ffff                        mov.w   #-1, 12Ch+var_12A[sp]
FFF3F78F  2e33                              bra.b   loc_FFF3F7C2
FFF3F791  fbe2661f0100           loc_FFF3F791 mov.l   #11F66h, r14
FFF3F797  660f                              mov.l   #0, r15
FFF3F799  fe01ef                            mov.b   r15, [r1, r14]
FFF3F79C  dd018f                            mov.w   12Ch+var_E[sp], r1
FFF3F79F  6211                              add     #1, r1
FFF3F7A1  d7018f                            mov.w   r1, 12Ch+var_E[sp]
FFF3F7A4  5d048f                            movu.w  12Ch+var_E[sp], r4
FFF3F7A7  fb32661f0100                      mov.l   #11F66h, r3
FFF3F7AD  6602                              mov.l   #0, r2
FFF3F7AF  7541ea                            mov.l   #-16h, r1
FFF3F7B2  0549dff9                          bsr.a   sub_FFEDD6FB
FFF3F7B6  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F7BC  f8e40c                            mov.b   #0Ch, [r14]
FFF3F7BF  3d0100                            mov.w   #0, 12Ch+var_12A[sp]
FFF3F7C2  d5000191               loc_FFF3F7C2 mov.w   12Ch+var_12A[sp], 12Ch+var_A[sp]
FFF3F7C6  5d0191                            movu.w  12Ch+var_A[sp], r1
FFF3F7C9  674b                              rtsd    #4Bh
FFF3F7CB  6040                   sub_FFF3F7CB sub     #4, sp   ; <<<< FUNC sub_FFF3F7CB
FFF3F7CD  9009                              mov.w   r1, 4+var_2[sp]
FFF3F7CF  f80500                            mov.w   #0, 4+var_4[sp]
FFF3F7D2  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F7D8  f8e400                            mov.b   #0, [r14]
FFF3F7DB  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F7E1  f8e400                            mov.b   #0, [r14]
FFF3F7E4  6641                              mov.l   #4, r1
FFF3F7E6  057fa7ff                          bsr.a   sub_FFF39F65
FFF3F7EA  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F7F0  f8e400                            mov.b   #0, [r14]
FFF3F7F3  b809                              movu.w  4+var_2[sp], r1
FFF3F7F5  6111                              cmp     #1, r1
FFF3F7F7  2127                              bne.b   loc_FFF3F81E
FFF3F7F9  5c01                              movu.w  4+var_4[sp], r1
FFF3F7FB  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F801  754f10                            mov.l   #10h, r15
FFF3F804  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F807  dc01                              mov.w   4+var_4[sp], r1
FFF3F809  6211                              add     #1, r1
FFF3F80B  d301                              mov.w   r1, 4+var_4[sp]
FFF3F80D  5c04                              movu.w  4+var_4[sp], r4
FFF3F80F  fb32661f0100                      mov.l   #11F66h, r3
FFF3F815  6602                              mov.l   #0, r2
FFF3F817  7541ea                            mov.l   #-16h, r1
FFF3F81A  05e1def9                          bsr.a   sub_FFEDD6FB
FFF3F81E  b809                   loc_FFF3F81E movu.w  4+var_2[sp], r1
FFF3F820  6151                              cmp     #5, r1
FFF3F822  2127                              bne.b   loc_FFF3F849
FFF3F824  5c01                              movu.w  4+var_4[sp], r1
FFF3F826  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F82C  754f11                            mov.l   #11h, r15
FFF3F82F  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F832  dc01                              mov.w   4+var_4[sp], r1
FFF3F834  6211                              add     #1, r1
FFF3F836  d301                              mov.w   r1, 4+var_4[sp]
FFF3F838  5c04                              movu.w  4+var_4[sp], r4
FFF3F83A  fb32661f0100                      mov.l   #11F66h, r3
FFF3F840  6602                              mov.l   #0, r2
FFF3F842  7541ea                            mov.l   #-16h, r1
FFF3F845  05b6def9                          bsr.a   sub_FFEDD6FB
FFF3F849  b809                   loc_FFF3F849 movu.w  4+var_2[sp], r1
FFF3F84B  6121                              cmp     #2, r1
FFF3F84D  2126                              bne.b   loc_FFF3F873
FFF3F84F  5c01                              movu.w  4+var_4[sp], r1
FFF3F851  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F857  660f                              mov.l   #0, r15
FFF3F859  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F85C  dc01                              mov.w   4+var_4[sp], r1
FFF3F85E  6211                              add     #1, r1
FFF3F860  d301                              mov.w   r1, 4+var_4[sp]
FFF3F862  5c04                              movu.w  4+var_4[sp], r4
FFF3F864  fb32661f0100                      mov.l   #11F66h, r3
FFF3F86A  6602                              mov.l   #0, r2
FFF3F86C  7541ea                            mov.l   #-16h, r1
FFF3F86F  058cdef9                          bsr.a   sub_FFEDD6FB
FFF3F873  b809                   loc_FFF3F873 movu.w  4+var_2[sp], r1
FFF3F875  7701ffff00                        cmp     #0FFFFh, r1
FFF3F87A  2129                              bne.b   loc_FFF3F8A3
FFF3F87C  5c01                              movu.w  4+var_4[sp], r1
FFF3F87E  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F884  fbf6a0                            mov.l   #-60h, r15
FFF3F887  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F88A  dc01                              mov.w   4+var_4[sp], r1
FFF3F88C  6211                              add     #1, r1
FFF3F88E  d301                              mov.w   r1, 4+var_4[sp]
FFF3F890  5c04                              movu.w  4+var_4[sp], r4
FFF3F892  fb32661f0100                      mov.l   #11F66h, r3
FFF3F898  6602                              mov.l   #0, r2
FFF3F89A  7541ea                            mov.l   #-16h, r1
FFF3F89D  055edef9                          bsr.a   sub_FFEDD6FB
FFF3F8A1  6701                              rtsd    #1
FFF3F8A3  6701                   loc_FFF3F8A3 rtsd    #1
FFF3F8A5  6040                   sub_FFF3F8A5 sub     #4, sp   ; <<<< FUNC sub_FFF3F8A5
FFF3F8A7  9009                              mov.w   r1, 4+var_2[sp]
FFF3F8A9  f80500                            mov.w   #0, 4+var_4[sp]
FFF3F8AC  fbe2b4220100                      mov.l   #122B4h, r14
FFF3F8B2  f8e400                            mov.b   #0, [r14]
FFF3F8B5  fbe2b6220100                      mov.l   #122B6h, r14
FFF3F8BB  f8e400                            mov.b   #0, [r14]
FFF3F8BE  6641                              mov.l   #4, r1
FFF3F8C0  05a5a6ff                          bsr.a   sub_FFF39F65
FFF3F8C4  b809                              movu.w  4+var_2[sp], r1
FFF3F8C6  6121                              cmp     #2, r1
FFF3F8C8  212f                              bne.b   loc_FFF3F8F7
FFF3F8CA  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F8D0  f8e400                            mov.b   #0, [r14]
FFF3F8D3  5c01                              movu.w  4+var_4[sp], r1
FFF3F8D5  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F8DB  660f                              mov.l   #0, r15
FFF3F8DD  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F8E0  dc01                              mov.w   4+var_4[sp], r1
FFF3F8E2  6211                              add     #1, r1
FFF3F8E4  d301                              mov.w   r1, 4+var_4[sp]
FFF3F8E6  5c04                              movu.w  4+var_4[sp], r4
FFF3F8E8  fb32661f0100                      mov.l   #11F66h, r3
FFF3F8EE  6602                              mov.l   #0, r2
FFF3F8F0  7541ea                            mov.l   #-16h, r1
FFF3F8F3  0508def9                          bsr.a   sub_FFEDD6FB
FFF3F8F7  b809                   loc_FFF3F8F7 movu.w  4+var_2[sp], r1
FFF3F8F9  6131                              cmp     #3, r1
FFF3F8FB  2149                              bne.b   loc_FFF3F944
FFF3F8FD  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F903  f8e400                            mov.b   #0, [r14]
FFF3F906  5c01                              movu.w  4+var_4[sp], r1
FFF3F908  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F90E  661f                              mov.l   #1, r15
FFF3F910  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F913  dc01                              mov.w   4+var_4[sp], r1
FFF3F915  6211                              add     #1, r1
FFF3F917  d301                              mov.w   r1, 4+var_4[sp]
FFF3F919  5c04                              movu.w  4+var_4[sp], r4
FFF3F91B  fb32661f0100                      mov.l   #11F66h, r3
FFF3F921  6602                              mov.l   #0, r2
FFF3F923  7541ea                            mov.l   #-16h, r1
FFF3F926  05d5ddf9                          bsr.a   sub_FFEDD6FB
FFF3F92A  66d3                              mov.l   #0Dh, r3
FFF3F92C  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3F932  fb1262080100                      mov.l   #10862h, r1
FFF3F938  7f87                              smovu
FFF3F93A  fb1262080100                      mov.l   #10862h, r1
FFF3F940  054438fd                          bsr.a   sub_FFF13184
FFF3F944  b809                   loc_FFF3F944 movu.w  4+var_2[sp], r1
FFF3F946  6141                              cmp     #4, r1
FFF3F948  2149                              bne.b   loc_FFF3F991
FFF3F94A  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F950  f8e400                            mov.b   #0, [r14]
FFF3F953  5c01                              movu.w  4+var_4[sp], r1
FFF3F955  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F95B  662f                              mov.l   #2, r15
FFF3F95D  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F960  dc01                              mov.w   4+var_4[sp], r1
FFF3F962  6211                              add     #1, r1
FFF3F964  d301                              mov.w   r1, 4+var_4[sp]
FFF3F966  5c04                              movu.w  4+var_4[sp], r4
FFF3F968  fb32661f0100                      mov.l   #11F66h, r3
FFF3F96E  6602                              mov.l   #0, r2
FFF3F970  7541ea                            mov.l   #-16h, r1
FFF3F973  0588ddf9                          bsr.a   sub_FFEDD6FB
FFF3F977  66d3                              mov.l   #0Dh, r3
FFF3F979  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3F97F  fb1262080100                      mov.l   #10862h, r1
FFF3F985  7f87                              smovu
FFF3F987  fb1262080100                      mov.l   #10862h, r1
FFF3F98D  05f737fd                          bsr.a   sub_FFF13184
FFF3F991  b809                   loc_FFF3F991 movu.w  4+var_2[sp], r1
FFF3F993  7701ffff00                        cmp     #0FFFFh, r1
FFF3F998  214c                              bne.b   loc_FFF3F9E4
FFF3F99A  fbe25f080100                      mov.l   #1085Fh, r14
FFF3F9A0  f8e400                            mov.b   #0, [r14]
FFF3F9A3  5c01                              movu.w  4+var_4[sp], r1
FFF3F9A5  fbe2661f0100                      mov.l   #11F66h, r14
FFF3F9AB  fbf6a0                            mov.l   #-60h, r15
FFF3F9AE  fe0e1f                            mov.b   r15, [r14, r1]
FFF3F9B1  dc01                              mov.w   4+var_4[sp], r1
FFF3F9B3  6211                              add     #1, r1
FFF3F9B5  d301                              mov.w   r1, 4+var_4[sp]
FFF3F9B7  5c04                              movu.w  4+var_4[sp], r4
FFF3F9B9  fb32661f0100                      mov.l   #11F66h, r3
FFF3F9BF  6602                              mov.l   #0, r2
FFF3F9C1  7541ea                            mov.l   #-16h, r1
FFF3F9C4  0537ddf9                          bsr.a   sub_FFEDD6FB
FFF3F9C8  66d3                              mov.l   #0Dh, r3
FFF3F9CA  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3F9D0  fb1262080100                      mov.l   #10862h, r1
FFF3F9D6  7f87                              smovu
FFF3F9D8  fb1262080100                      mov.l   #10862h, r1
FFF3F9DE  05a637fd                          bsr.a   sub_FFF13184
FFF3F9E2  6701                              rtsd    #1
FFF3F9E4  6701                   loc_FFF3F9E4 rtsd    #1
FFF3F9E6  7200d8fb               sub_FFF3F9E6 add     #-428h, sp, sp   ; <<<< FUNC sub_FFF3F9E6
FFF3F9EA  fa05120200                        mov.w   #0, 428h+var_4[sp]
FFF3F9EF  fa06080100                        mov.l   #0, 428h+var_8[sp]
FFF3F9F4  3d0400                            mov.w   #0, 428h+var_420[sp]
FFF3F9F7  3d0e00                            mov.w   #0, 428h+var_40C[sp]
FFF3F9FA  66d3                              mov.l   #0Dh, r3
FFF3F9FC  fb220ab0f4ff                      mov.l   #aIRecbackup, r2; "local tree, not in this repo"
FFF3FA02  fb1262080100                      mov.l   #10862h, r1
FFF3FA08  7f87                              smovu
FFF3FA0A  fb1262080100                      mov.l   #10862h, r1
FFF3FA10  a089                              mov.l   r1, 428h+var_41C[sp]
FFF3FA12  710120                            add     #428h+var_408, sp, r1
FFF3FA15  a109                              mov.l   r1, 428h+var_414[sp]
FFF3FA17  3e0400                            mov.l   #0, 428h+var_418[sp]
FFF3FA1A  72022004                          add     #428h+var_8, sp, r2
FFF3FA1E  fb1262080100                      mov.l   #10862h, r1
FFF3FA24  05cf36fd                          bsr.a   sub_FFF130F3
FFF3FA28  db011202                          mov.w   r1, 428h+var_4[sp]
FFF3FA2C  5e011202                          movu.w  428h+var_4[sp], r1
FFF3FA30  6101                              cmp     #0, r1
FFF3FA32  2014                              beq.b   loc_FFF3FA46
FFF3FA34  fb1262080100                      mov.l   #10862h, r1
FFF3FA3A  054a37fd                          bsr.a   sub_FFF13184
FFF3FA3E  f90901ffff                        mov.w   #-1, 428h+var_426[sp]
FFF3FA43  38a600                            bra.w   loc_FFF3FAE9
FFF3FA46  5e011002               loc_FFF3FA46 movu.w  428h+var_8[sp], r1
FFF3FA4A  a181                              mov.l   r1, 428h+var_410[sp]
FFF3FA4C  710108                            add     #428h+var_420, sp, r1
FFF3FA4F  053c34fd                          bsr.a   sub_FFF12E8B
FFF3FA53  db011202                          mov.w   r1, 428h+var_4[sp]
FFF3FA57  5e011202                          movu.w  428h+var_4[sp], r1
FFF3FA5B  6101                              cmp     #0, r1
FFF3FA5D  2013                              beq.b   loc_FFF3FA70
FFF3FA5F  fb1262080100                      mov.l   #10862h, r1
FFF3FA65  051f37fd                          bsr.a   sub_FFF13184
FFF3FA69  f90901ffff                        mov.w   #-1, 428h+var_426[sp]
FFF3FA6E  2e7b                              bra.b   loc_FFF3FAE9
FFF3FA70  fb1262080100           loc_FFF3FA70 mov.l   #10862h, r1
FFF3FA76  050e37fd                          bsr.a   sub_FFF13184
FFF3FA7A  ee010801                          mov.l   428h+var_8[sp], r1
FFF3FA7E  710e20                            add     #428h+var_408, sp, r14
FFF3FA81  660f                              mov.l   #0, r15
FFF3FA83  fe0e1f                            mov.b   r15, [r14, r1]
FFF3FA86  72022004                          add     #428h+var_8, sp, r2
FFF3FA8A  710120                            add     #428h+var_408, sp, r1
FFF3FA8D  396a00                            bsr.w   sub_FFF3FAF7
FFF3FA90  ee010801                          mov.l   428h+var_8[sp], r1
FFF3FA94  6081                              sub     #8, r1
FFF3FA96  fb22b4030500                      mov.l   #503B4h, r2
FFF3FA9C  a029                              mov.l   r1, 4[r2]
FFF3FA9E  ee010801                          mov.l   428h+var_8[sp], r1
FFF3FAA2  7111d4                            add     #-2Ch, r1, r1
FFF3FAA5  fb22b4030500                      mov.l   #503B4h, r2
FFF3FAAB  a2a1                              mov.l   r1, 28h[r2]
FFF3FAAD  fb2217b0f4ff                      mov.l   #aR_0, r2; "r+"
FFF3FAB3  710120                            add     #428h+var_408, sp, r1
FFF3FAB6  059264fd                          bsr.a   sub_FFF15F48
FFF3FABA  a009                              mov.l   r1, 428h+var_424[sp]
FFF3FABC  a80c                              mov.l   428h+var_424[sp], r4
FFF3FABE  6104                              cmp     #0, r4
FFF3FAC0  210f                              bne.b   loc_FFF3FACF
FFF3FAC2  ef41                              mov.l   r4, r1
FFF3FAC4  055673fd                          bsr.a   sub_FFF16E1A
FFF3FAC8  f90901ffff                        mov.w   #-1, 428h+var_426[sp]
FFF3FACD  2e1c                              bra.b   loc_FFF3FAE9
FFF3FACF  75432c                 loc_FFF3FACF mov.l   #2Ch, r3 ; ','
FFF3FAD2  6612                              mov.l   #1, r2
FFF3FAD4  fb12b4030500                      mov.l   #503B4h, r1
FFF3FADA  05368afd                          bsr.a   sub_FFF18510
FFF3FADE  a809                              mov.l   428h+var_424[sp], r1
FFF3FAE0  053a73fd                          bsr.a   sub_FFF16E1A
FFF3FAE4  d600120201                        mov.w   428h+var_4[sp], 428h+var_426[sp]
FFF3FAE9  d900011302             loc_FFF3FAE9 mov.w   428h+var_426[sp], 428h+var_2[sp]
FFF3FAEE  5e011302                          movu.w  428h+var_2[sp], r1
FFF3FAF2  72002804                          add     #428h, sp, sp
FFF3FAF6  02                                rts
FFF3FAF7  720098fb               sub_FFF3FAF7 add     #-468h, sp, sp   ; <<<< FUNC sub_FFF3FAF7
FFF3FAFB  eb011901                          mov.l   r1, 468h+var_4[sp]
FFF3FAFF  eb021801                          mov.l   r2, 468h+var_8[sp]
FFF3FB03  fa052e0200                        mov.w   #0, 468h+var_C[sp]
FFF3FB08  fa06160100                        mov.l   #0, 468h+var_10[sp]
FFF3FB0D  fa06150100                        mov.l   #0, 468h+var_14[sp]
FFF3FB12  ee011901                          mov.l   468h+var_4[sp], r1
FFF3FB16  72025804                          add     #468h+var_10, sp, r2
FFF3FB1A  05d935fd                          bsr.a   sub_FFF130F3
FFF3FB1E  db012e02                          mov.w   r1, 468h+var_C[sp]
FFF3FB22  5e012e02                          movu.w  468h+var_C[sp], r1
FFF3FB26  6101                              cmp     #0, r1
FFF3FB28  11                                beq.s   loc_FFF3FB31
FFF3FB29  f90901ffff                        mov.w   #-1, 468h+var_466[sp]
FFF3FB2E  381701                            bra.w   loc_FFF3FC45
FFF3FB31  ee011901               loc_FFF3FB31 mov.l   468h+var_4[sp], r1
FFF3FB35  710204                            add     #468h+var_464, sp, r2
FFF3FB38  05647afe                          bsr.a   sub_FFF2759C
FFF3FB3C  db012e02                          mov.w   r1, 468h+var_C[sp]
FFF3FB40  5e012e02                          movu.w  468h+var_C[sp], r1
FFF3FB44  6101                              cmp     #0, r1
FFF3FB46  11                                beq.s   loc_FFF3FB4F
FFF3FB47  f90901ffff                        mov.w   #-1, 468h+var_466[sp]
FFF3FB4C  38f900                            bra.w   loc_FFF3FC45
FFF3FB4F  fbe2145c0600           loc_FFF3FB4F mov.l   #65C14h, r14
FFF3FB55  ecee                              mov.l   [r14], r14
FFF3FB57  e10e04                            mov.l   468h+var_458[sp], [r14]
FFF3FB5A  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FB60  ece1                              mov.l   [r14], r1
FFF3FB62  e5010501                          mov.l   468h+var_454[sp], 4[r1]
FFF3FB66  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FB6C  ece1                              mov.l   [r14], r1
FFF3FB6E  e5010602                          mov.l   468h+var_450[sp], 8[r1]
FFF3FB72  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FB78  ece1                              mov.l   [r14], r1
FFF3FB7A  e5010703                          mov.l   468h+var_44C[sp], 0Ch[r1]
FFF3FB7E  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FB84  ece1                              mov.l   [r14], r1
FFF3FB86  e5010804                          mov.l   468h+var_448[sp], 10h[r1]
FFF3FB8A  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FB90  ece1                              mov.l   [r14], r1
FFF3FB92  e5010905                          mov.l   468h+var_444[sp], 14h[r1]
FFF3FB96  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FB9C  ece1                              mov.l   [r14], r1
FFF3FB9E  e5010a06                          mov.l   468h+var_440[sp], 18h[r1]
FFF3FBA2  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FBA8  ece1                              mov.l   [r14], r1
FFF3FBAA  e5010b07                          mov.l   468h+var_43C[sp], 1Ch[r1]
FFF3FBAE  fbe2145c0600                      mov.l   #65C14h, r14
FFF3FBB4  ece1                              mov.l   [r14], r1
FFF3FBB6  e5010c08                          mov.l   468h+var_438[sp], 20h[r1]
FFF3FBBA  ee011601                          mov.l   468h+var_10[sp], r1
FFF3FBBE  7111d4                            add     #-2Ch, r1, r1
FFF3FBC1  eb011501                          mov.l   r1, 468h+var_14[sp]
FFF3FBC5  ee011501                          mov.l   468h+var_14[sp], r1
FFF3FBC9  7c01                              btst    #0, r1
FFF3FBCB  206b                              beq.b   loc_FFF3FC36
FFF3FBCD  fa091e02ffff                      mov.w   #-1, 468h+var_2C[sp]
FFF3FBD3  fa05280202                        mov.w   #2, 468h+var_18[sp]
FFF3FBD8  fb36ff                            mov.l   #-1, r3
FFF3FBDB  ee021901                          mov.l   468h+var_4[sp], r2
FFF3FBDF  fb1262080100                      mov.l   #10862h, r1
FFF3FBE5  7f87                              smovu
FFF3FBE7  fb1262080100                      mov.l   #10862h, r1
FFF3FBED  eb011001                          mov.l   r1, 468h+var_28[sp]
FFF3FBF1  ee011601                          mov.l   468h+var_10[sp], r1
FFF3FBF5  6011                              sub     #1, r1
FFF3FBF7  eb011101                          mov.l   r1, 468h+var_24[sp]
FFF3FBFB  f9043c00                          mov.b   #0, 468h+var_42C[sp]
FFF3FBFF  f9043d00                          mov.b   #0, 468h+var_42B[sp]
FFF3FC03  71013c                            add     #468h+var_42C, sp, r1
FFF3FC06  eb011201                          mov.l   r1, 468h+var_20[sp]
FFF3FC0A  fa06130102                        mov.l   #2, 468h+var_1C[sp]
FFF3FC0F  ee011601                          mov.l   468h+var_10[sp], r1
FFF3FC13  6211                              add     #1, r1
FFF3FC15  ee021801                          mov.l   468h+var_8[sp], r2
FFF3FC19  e321                              mov.l   r1, [r2]
FFF3FC1B  72013c04                          add     #468h+var_2C, sp, r1
FFF3FC1F  050630fd                          bsr.a   sub_FFF12C25
FFF3FC23  db012e02                          mov.w   r1, 468h+var_C[sp]
FFF3FC27  5e012e02                          movu.w  468h+var_C[sp], r1
FFF3FC2B  6101                              cmp     #0, r1
FFF3FC2D  2113                              bne.b   loc_FFF3FC40
FFF3FC2F  f90901ffff                        mov.w   #-1, 468h+var_466[sp]
FFF3FC34  2e11                              bra.b   loc_FFF3FC45
FFF3FC36  ee011601               loc_FFF3FC36 mov.l   468h+var_10[sp], r1
FFF3FC3A  ee021801                          mov.l   468h+var_8[sp], r2
FFF3FC3E  e321                              mov.l   r1, [r2]
FFF3FC40  d6002e0201             loc_FFF3FC40 mov.w   468h+var_C[sp], 468h+var_466[sp]
FFF3FC45  d900012f02             loc_FFF3FC45 mov.w   468h+var_466[sp], 468h+var_A[sp]
FFF3FC4A  5e012f02                          movu.w  468h+var_A[sp], r1
FFF3FC4E  72006804                          add     #468h, sp, sp
FFF3FC52  02                                rts
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
FFF3FE0D  fbe2468e0000           sub_FFF3FE0D mov.l   #8E46h, r14   ; <<<< FUNC sub_FFF3FE0D
FFF3FE13  58ee                              movu.b  [r14], r14
FFF3FE15  755ef1                            cmp     #-0Fh, r14
FFF3FE18  212c                              bne.b   loc_FFF3FE44
FFF3FE1A  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF3FE20  58ee                              movu.b  [r14], r14
FFF3FE22  613e                              cmp     #3, r14
FFF3FE24  2a16                              bgt.b   loc_FFF3FE3A
FFF3FE26  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF3FE2C  58ee                              movu.b  [r14], r14
FFF3FE2E  fbf23883edff                      mov.l   #off_FFED8338, r15
FFF3FE34  fe6efe                            mov.l   [r14, r15], r14
FFF3FE37  7f1e                              jsr     r14
FFF3FE39  02                                rts
FFF3FE3A  fbe24c8c0000           loc_FFF3FE3A mov.l   #8C4Ch, r14
FFF3FE40  f8e403                            mov.b   #3, [r14]
FFF3FE43  02                                rts
FFF3FE44  02                     loc_FFF3FE44 rts
FFF3FE45  6611                   sub_FFF3FE45 mov.l   #1, r1   ; <<<< FUNC sub_FFF3FE45
FFF3FE47  394d01                            bsr.w   sub_FFF3FF94
FFF3FE4A  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF3FE50  58ef                              movu.b  [r14], r15
FFF3FE52  621f                              add     #1, r15
FFF3FE54  c3ef                              mov.b   r15, [r14]
FFF3FE56  02                                rts
FFF3FE57  6080                   sub_FFF3FE57 sub     #8, sp   ; <<<< FUNC sub_FFF3FE57
FFF3FE59  05d404fb                          bsr.a   sub_FFEF032D
FFF3FE5D  052ba7fb                          bsr.a   sub_FFEFA588
FFF3FE61  3d0200                            mov.w   #0, 8+var_4[sp]
FFF3FE64  3d0380                            mov.w   #-80h, 8+var_2[sp]
FFF3FE67  3c0300                            mov.b   #0, 8+var_5[sp]
FFF3FE6A  2e29                              bra.b   loc_FFF3FE93
FFF3FE6C  b881                   loc_FFF3FE6C movu.w  8+var_4[sp], r1
FFF3FE6E  b88a                              movu.w  8+var_2[sp], r2
FFF3FE70  6040                              sub     #4, sp
FFF3FE72  f809ef7b                          mov.w   #7BEFh, 0Ch+var_C[sp]
FFF3FE76  fbea4001                          mov.l   #140h, r14
FFF3FE7A  431e                              sub     r1, r14
FFF3FE7C  5fe3                              movu.w  r14, r3
FFF3FE7E  6614                              mov.l   #1, r4
FFF3FE80  05c81dfb                          bsr.a   sub_FFEF1C48
FFF3FE84  6240                              add     #4, sp
FFF3FE86  b889                              movu.w  8+var_2[sp], r1
FFF3FE88  711110                            add     #10h, r1, r1
FFF3FE8B  9089                              mov.w   r1, 8+var_2[sp]
FFF3FE8D  b089                              movu.b  8+var_5[sp], r1
FFF3FE8F  6211                              add     #1, r1
FFF3FE91  8089                              mov.b   r1, 8+var_5[sp]
FFF3FE93  b089                   loc_FFF3FE93 movu.b  8+var_5[sp], r1
FFF3FE95  6131                              cmp     #3, r1
FFF3FE97  29d5                              blt.b   loc_FFF3FE6C
FFF3FE99  6661                              mov.l   #6, r1
FFF3FE9B  05f49ffb                          bsr.a   sub_FFEF9E8F
FFF3FE9F  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF3FEA5  58ef                              movu.b  [r14], r15
FFF3FEA7  621f                              add     #1, r15
FFF3FEA9  c3ef                              mov.b   r15, [r14]
FFF3FEAB  6702                              rtsd    #2
FFF3FEAD  6040                   sub_FFF3FEAD sub     #4, sp   ; <<<< FUNC sub_FFF3FEAD
FFF3FEAF  6040                              sub     #4, sp
FFF3FEB1  3d00f0                            mov.w   #-10h, [sp]
FFF3FEB4  fb4a4001                          mov.l   #140h, r4
FFF3FEB8  6602                              mov.l   #0, r2
FFF3FEBA  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3FEC0  ef23                              mov.l   r2, r3
FFF3FEC2  05f9fafa                          bsr.a   sub_FFEEF9BB
FFF3FEC6  6240                              add     #4, sp
FFF3FEC8  8089                              mov.b   r1, 4+var_1[sp]
FFF3FECA  b089                              movu.b  4+var_1[sp], r1
FFF3FECC  6111                              cmp     #1, r1
FFF3FECE  1a                                bne.s   loc_FFF3FED8
FFF3FECF  396003                            bsr.w   sub_FFF4022F
FFF3FED2  059d04fb                          bsr.a   sub_FFEF036F
FFF3FED6  6701                              rtsd    #1
FFF3FED8  6701                   loc_FFF3FED8 rtsd    #1
FFF3FEDA  6040                   sub_FFF3FEDA sub     #4, sp   ; <<<< FUNC sub_FFF3FEDA
FFF3FEDC  6040                              sub     #4, sp
FFF3FEDE  f8054e                            mov.w   #4Eh, 8+var_8[sp] ; 'N'
FFF3FEE1  fb4a4001                          mov.l   #140h, r4
FFF3FEE5  754369                            mov.l   #69h, r3 ; 'i'
FFF3FEE8  6602                              mov.l   #0, r2
FFF3FEEA  fb12b8d30100                      mov.l   #1D3B8h, r1
FFF3FEF0  05cbfafa                          bsr.a   sub_FFEEF9BB
FFF3FEF4  6240                              add     #4, sp
FFF3FEF6  8089                              mov.b   r1, 4+var_1[sp]
FFF3FEF8  b089                              movu.b  4+var_1[sp], r1
FFF3FEFA  6111                              cmp     #1, r1
FFF3FEFC  2110                              bne.b   loc_FFF3FF0C
FFF3FEFE  754269                            mov.l   #69h, r2 ; 'i'
FFF3FF01  6601                              mov.l   #0, r1
FFF3FF03  39c703                            bsr.w   sub_FFF402CA
FFF3FF06  056904fb                          bsr.a   sub_FFEF036F
FFF3FF0A  6701                              rtsd    #1
FFF3FF0C  6701                   loc_FFF3FF0C rtsd    #1
FFF3FF0E  6040                   sub_FFF3FF0E sub     #4, sp   ; <<<< FUNC sub_FFF3FF0E
FFF3FF10  052f01fb                          bsr.a   sub_FFEF003F
FFF3FF14  fbe2738f0000                      mov.l   #8F73h, r14
FFF3FF1A  c3e1                              mov.b   r1, [r14]
FFF3FF1C  fbe2738f0000                      mov.l   #8F73h, r14
FFF3FF22  58ee                              movu.b  [r14], r14
FFF3FF24  755eff                            cmp     #-1, r14
FFF3FF27  1e                                bne.s   loc_FFF3FF2D
FFF3FF28  6601                              mov.l   #0, r1
FFF3FF2A  396a00                            bsr.w   sub_FFF3FF94
FFF3FF2D  fbe2738f0000           loc_FFF3FF2D mov.l   #8F73h, r14
FFF3FF33  58ee                              movu.b  [r14], r14
FFF3FF35  755eff                            cmp     #-1, r14
FFF3FF38  2013                              beq.b   loc_FFF3FF4B
FFF3FF3A  fbe2738f0000                      mov.l   #8F73h, r14
FFF3FF40  58ee                              movu.b  [r14], r14
FFF3FF42  755e23                            cmp     #23h, r14 ; '#'
FFF3FF45  2406                              bgtu.b  loc_FFF3FF4B
FFF3FF47  f80601                            mov.l   #1, 4+var_4[sp]
FFF3FF4A  0c                                bra.s   loc_FFF3FF4E
FFF3FF4B  f80600                 loc_FFF3FF4B mov.l   #0, 4+var_4[sp]
FFF3FF4E  ec01                   loc_FFF3FF4E mov.l   4+var_4[sp], r1
FFF3FF50  6101                              cmp     #0, r1
FFF3FF52  2029                              beq.b   loc_FFF3FF7B
FFF3FF54  0530fcfa                          bsr.a   sub_FFEEFB84
FFF3FF58  6101                              cmp     #0, r1
FFF3FF5A  2121                              bne.b   loc_FFF3FF7B
FFF3FF5C  fbe2738f0000                      mov.l   #8F73h, r14
FFF3FF62  58e1                              movu.b  [r14], r1
FFF3FF64  058600fb                          bsr.a   sub_FFEEFFEA
FFF3FF68  fbe2738f0000                      mov.l   #8F73h, r14
FFF3FF6E  58ee                              movu.b  [r14], r14
FFF3FF70  fbf24883edff                      mov.l   #off_FFED8348, r15
FFF3FF76  fe6efe                            mov.l   [r14, r15], r14
FFF3FF79  7f1e                              jsr     r14
FFF3FF7B  fbe24c8c0000           loc_FFF3FF7B mov.l   #8C4Ch, r14
FFF3FF81  58ee                              movu.b  [r14], r14
FFF3FF83  614e                              cmp     #4, r14
FFF3FF85  290d                              blt.b   loc_FFF3FF92
FFF3FF87  fbe24c8c0000                      mov.l   #8C4Ch, r14
FFF3FF8D  f8e403                            mov.b   #3, [r14]
FFF3FF90  6701                              rtsd    #1
FFF3FF92  6701                   loc_FFF3FF92 rtsd    #1
FFF3FF94  6040                   sub_FFF3FF94 sub     #4, sp   ; <<<< FUNC sub_FFF3FF94
FFF3FF96  8089                              mov.b   r1, 4+var_1[sp]
FFF3FF98  05d140fb                          bsr.a   sub_FFEF4069
FFF3FF9C  391400                            bsr.w   sub_FFF3FFB0
FFF3FF9F  051b41fb                          bsr.a   sub_FFEF40BA
FFF3FFA3  b089                              movu.b  4+var_1[sp], r1
FFF3FFA5  6111                              cmp     #1, r1
FFF3FFA7  1f                                bne.s   loc_FFF3FFAE
FFF3FFA8  058400fb                          bsr.a   sub_FFEF002C
FFF3FFAC  6701                              rtsd    #1
FFF3FFAE  6701                   loc_FFF3FFAE rtsd    #1
FFF3FFB0  6040                   sub_FFF3FFB0 sub     #4, sp   ; <<<< FUNC sub_FFF3FFB0
FFF3FFB2  3c0300                            mov.b   #0, 4+var_1[sp]
FFF3FFB5  3c0200                            mov.b   #0, 4+var_2[sp]
FFF3FFB8  3c0100                            mov.b   #0, 4+var_3[sp]
FFF3FFBB  058741fb                          bsr.a   sub_FFEF4142
FFF3FFBF  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF3FFC5  71ee20                            add     #20h, r14, r14 ; ' '
FFF3FFC8  fbf29cd30100                      mov.l   #1D39Ch, r15
FFF3FFCE  e3fe                              mov.l   r14, [r15]
FFF3FFD0  fb22468e0000                      mov.l   #8E46h, r2
FFF3FFD6  712220                            add     #20h, r2, r2 ; ' '
FFF3FFD9  fb124d8c0000                      mov.l   #8C4Dh, r1
FFF3FFDF  711120                            add     #20h, r1, r1 ; ' '
FFF3FFE2  6633                              mov.l   #3, r3
FFF3FFE4  05c342fb                          bsr.a   sub_FFEF42A7
FFF3FFE8  3c0100                            mov.b   #0, 4+var_3[sp]
FFF3FFEB  3c0300                            mov.b   #0, 4+var_1[sp]
FFF3FFEE  2e3e                              bra.b   loc_FFF4002C
FFF3FFF0  b089                   loc_FFF3FFF0 movu.b  4+var_1[sp], r1
FFF3FFF2  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF3FFF8  4b1e                              add     r1, r14
FFF3FFFA  59ee6c                            movu.b  6Ch[r14], r14
FFF3FFFD  fbf2468e0000                      mov.l   #8E46h, r15
FFF40003  4b1f                              add     r1, r15
FFF40005  45fe6c                            cmp     6Ch[r15], r14
FFF40008  201e                              beq.b   loc_FFF40026
FFF4000A  b089                              movu.b  4+var_1[sp], r1
FFF4000C  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40012  4b1e                              add     r1, r14
FFF40014  fbf2468e0000                      mov.l   #8E46h, r15
FFF4001A  4b1f                              add     r1, r15
FFF4001C  c5fe6c6c                          mov.b   6Ch[r15], 6Ch[r14]
FFF40020  b009                              movu.b  4+var_3[sp], r1
FFF40022  6211                              add     #1, r1
FFF40024  8009                              mov.b   r1, 4+var_3[sp]
FFF40026  b089                   loc_FFF40026 movu.b  4+var_1[sp], r1
FFF40028  6211                              add     #1, r1
FFF4002A  8089                              mov.b   r1, 4+var_1[sp]
FFF4002C  b089                   loc_FFF4002C movu.b  4+var_1[sp], r1
FFF4002E  61f1                              cmp     #0Fh, r1
FFF40030  2bc0                              ble.b   loc_FFF3FFF0
FFF40032  b009                              movu.b  4+var_3[sp], r1
FFF40034  6101                              cmp     #0, r1
FFF40036  17                                beq.s   loc_FFF4003D
FFF40037  6611                              mov.l   #1, r1
FFF40039  05b5fefa                          bsr.a   sub_FFEEFEEE
FFF4003D  fbe24d8c0000           loc_FFF4003D mov.l   #8C4Dh, r14
FFF40043  59ee7c                            movu.b  7Ch[r14], r14
FFF40046  fbf2468e0000                      mov.l   #8E46h, r15
FFF4004C  45fe7c                            cmp     7Ch[r15], r14
FFF4004F  2018                              beq.b   loc_FFF40067
FFF40051  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40057  fbf2468e0000                      mov.l   #8E46h, r15
FFF4005D  c5fe7c7c                          mov.b   7Ch[r15], 7Ch[r14]
FFF40061  6611                              mov.l   #1, r1
FFF40063  058bfefa                          bsr.a   sub_FFEEFEEE
FFF40067  fbe24d8c0000           loc_FFF40067 mov.l   #8C4Dh, r14
FFF4006D  59ee7d                            movu.b  7Dh[r14], r14
FFF40070  fbf2468e0000                      mov.l   #8E46h, r15
FFF40076  45fe7d                            cmp     7Dh[r15], r14
FFF40079  2018                              beq.b   loc_FFF40091
FFF4007B  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF40081  fbf2468e0000                      mov.l   #8E46h, r15
FFF40087  c5fe7d7d                          mov.b   7Dh[r15], 7Dh[r14]
FFF4008B  6611                              mov.l   #1, r1
FFF4008D  0561fefa                          bsr.a   sub_FFEEFEEE
FFF40091  3c0100                 loc_FFF40091 mov.b   #0, 4+var_3[sp]
FFF40094  3c0300                            mov.b   #0, 4+var_1[sp]
FFF40097  38d400                            bra.w   loc_FFF4016B
FFF4009A  b089                   loc_FFF4009A movu.b  4+var_1[sp], r1
FFF4009C  6361                              mul     #6, r1
FFF4009E  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF400A4  4b1e                              add     r1, r14
FFF400A6  59ee7e                            movu.b  7Eh[r14], r14
FFF400A9  fbf2468e0000                      mov.l   #8E46h, r15
FFF400AF  4b1f                              add     r1, r15
FFF400B1  45fe7e                            cmp     7Eh[r15], r14
FFF400B4  2020                              beq.b   loc_FFF400D4
FFF400B6  b089                              movu.b  4+var_1[sp], r1
FFF400B8  6361                              mul     #6, r1
FFF400BA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF400C0  4b1e                              add     r1, r14
FFF400C2  fbf2468e0000                      mov.l   #8E46h, r15
FFF400C8  4b1f                              add     r1, r15
FFF400CA  c5fe7e7e                          mov.b   7Eh[r15], 7Eh[r14]
FFF400CE  b009                              movu.b  4+var_3[sp], r1
FFF400D0  6211                              add     #1, r1
FFF400D2  8009                              mov.b   r1, 4+var_3[sp]
FFF400D4  b089                   loc_FFF400D4 movu.b  4+var_1[sp], r1
FFF400D6  6361                              mul     #6, r1
FFF400D8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF400DE  4b1e                              add     r1, r14
FFF400E0  59ee7f                            movu.b  7Fh[r14], r14
FFF400E3  fbf2468e0000                      mov.l   #8E46h, r15
FFF400E9  4b1f                              add     r1, r15
FFF400EB  45fe7f                            cmp     7Fh[r15], r14
FFF400EE  2020                              beq.b   loc_FFF4010E
FFF400F0  b089                              movu.b  4+var_1[sp], r1
FFF400F2  6361                              mul     #6, r1
FFF400F4  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF400FA  4b1e                              add     r1, r14
FFF400FC  fbf2468e0000                      mov.l   #8E46h, r15
