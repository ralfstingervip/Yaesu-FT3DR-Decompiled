; ==== fat_more  FFF2E200-FFF2EE00  (file 32E200-32EE00) ====
FFF2E200  2b                                bne.b   loc_FFF2E22A
FFF2E201  a881                              mov.l   14h+var_C[sp], r1
FFF2E203  6c21                              shll    #2, r1
FFF2E205  fb                                .byte 0FBh
FFF2E206  22c4                              bgeu.b  loc_FFF2E1CA
FFF2E208  6aec                              shar    #0Eh, r12
FFF2E20A  ff4b12                            and     r1, r2, r11
FFF2E20D  b829                              movu.w  2[r2], r1
FFF2E20F  6881                              shlr    #8, r1
FFF2E211  a88a                              mov.l   14h+var_8[sp], r2
FFF2E213  c321                              mov.b   r1, [r2]
FFF2E215  a881                              mov.l   14h+var_C[sp], r1
FFF2E217  6c21                              shll    #2, r1
FFF2E219  fbe2c46aecff                      mov.l   #unk_FFEC6AC4, r14
FFF2E21F  4b1e                              add     r1, r14
FFF2E221  a889                              mov.l   14h+var_8[sp], r1
FFF2E223  c5e10201                          mov.b   2[r14], 1[r1]
FFF2E227  38cb00                            bra.w   loc_FFF2E2F2
FFF2E22A  a881                   loc_FFF2E22A mov.l   14h+var_C[sp], r1
FFF2E22C  6211                              add     #1, r1
FFF2E22E  a081                              mov.l   r1, 14h+var_C[sp]
FFF2E230  a881                   loc_FFF2E230 mov.l   14h+var_C[sp], r1
FFF2E232  6c21                              shll    #2, r1
FFF2E234  fbe2c46aecff                      mov.l   #unk_FFEC6AC4, r14
FFF2E23A  4b1e                              add     r1, r14
FFF2E23C  5cee                              movu.w  [r14], r14
FFF2E23E  610e                              cmp     #0, r14
FFF2E240  21ae                              bne.b   loc_FFF2E1EE
FFF2E242  38b000                            bra.w   loc_FFF2E2F2
FFF2E245  77014afa00             loc_FFF2E245 cmp     #0FA4Ah, r1
FFF2E24A  290f                              blt.b   loc_FFF2E259
FFF2E24C  b889                              movu.w  14h+var_E[sp], r1
FFF2E24E  77015bfa00                        cmp     #0FA5Bh, r1
FFF2E253  2a06                              bgt.b   loc_FFF2E259
FFF2E255  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E258  0c                                bra.s   loc_FFF2E25C
FFF2E259  f80600                 loc_FFF2E259 mov.l   #0, 14h+var_14[sp]
FFF2E25C  ec01                   loc_FFF2E25C mov.l   14h+var_14[sp], r1
FFF2E25E  6101                              cmp     #0, r1
FFF2E260  3a9200                            beq.w   loc_FFF2E2F2
FFF2E263  b889                              movu.w  14h+var_E[sp], r1
FFF2E265  77014afa00                        cmp     #0FA4Ah, r1
FFF2E26A  290f                              blt.b   loc_FFF2E279
FFF2E26C  b889                              movu.w  14h+var_E[sp], r1
FFF2E26E  770153fa00                        cmp     #0FA53h, r1
FFF2E273  2a06                              bgt.b   loc_FFF2E279
FFF2E275  f80601                            mov.l   #1, 14h+var_14[sp]
FFF2E278  0c                                bra.s   loc_FFF2E27C
FFF2E279  f80600                 loc_FFF2E279 mov.l   #0, 14h+var_14[sp]
FFF2E27C  ec01                   loc_FFF2E27C mov.l   14h+var_14[sp], r1
FFF2E27E  6101                              cmp     #0, r1
FFF2E280  201a                              beq.b   loc_FFF2E29A
FFF2E282  b889                              movu.w  14h+var_E[sp], r1
FFF2E284  72110a8d                          add     #-72F6h, r1, r1
FFF2E288  9089                              mov.w   r1, 14h+var_E[sp]
FFF2E28A  b889                              movu.w  14h+var_E[sp], r1
FFF2E28C  6881                              shlr    #8, r1
FFF2E28E  a88a                              mov.l   14h+var_8[sp], r2
FFF2E290  c321                              mov.b   r1, [r2]
FFF2E292  b181                              movu.b  14h+var_E[sp], r1
FFF2E294  a88a                              mov.l   14h+var_8[sp], r2
FFF2E296  8029                              mov.b   r1, 1[r2]
FFF2E298  2e5a                              bra.b   loc_FFF2E2F2
FFF2E29A  3e0200                 loc_FFF2E29A mov.l   #0, 14h+var_C[sp]
FFF2E29D  2e43                              bra.b   loc_FFF2E2E0
FFF2E29F  a881                   loc_FFF2E29F mov.l   14h+var_C[sp], r1
FFF2E2A1  6c21                              shll    #2, r1
FFF2E2A3  fbe2d86aecff                      mov.l   #unk_FFEC6AD8, r14
FFF2E2A9  4b1e                              add     r1, r14
FFF2E2AB  b889                              movu.w  14h+var_E[sp], r1
FFF2E2AD  06c4e1                            cmp     [r14].uw, r1
FFF2E2B0  212a                              bne.b   loc_FFF2E2DA
FFF2E2B2  a881                              mov.l   14h+var_C[sp], r1
FFF2E2B4  6c21                              shll    #2, r1
FFF2E2B6  fb22d86aecff                      mov.l   #unk_FFEC6AD8, r2
FFF2E2BC  4b12                              add     r1, r2
FFF2E2BE  b829                              movu.w  2[r2], r1
FFF2E2C0  6881                              shlr    #8, r1
FFF2E2C2  a88a                              mov.l   14h+var_8[sp], r2
FFF2E2C4  c321                              mov.b   r1, [r2]
FFF2E2C6  a881                              mov.l   14h+var_C[sp], r1
FFF2E2C8  6c21                              shll    #2, r1
FFF2E2CA  fbe2d86aecff                      mov.l   #unk_FFEC6AD8, r14
FFF2E2D0  4b1e                              add     r1, r14
FFF2E2D2  a889                              mov.l   14h+var_8[sp], r1
FFF2E2D4  c5e10201                          mov.b   2[r14], 1[r1]
FFF2E2D8  2e1a                              bra.b   loc_FFF2E2F2
FFF2E2DA  a881                   loc_FFF2E2DA mov.l   14h+var_C[sp], r1
FFF2E2DC  6211                              add     #1, r1
FFF2E2DE  a081                              mov.l   r1, 14h+var_C[sp]
FFF2E2E0  a881                   loc_FFF2E2E0 mov.l   14h+var_C[sp], r1
FFF2E2E2  6c21                              shll    #2, r1
FFF2E2E4  fbe2d86aecff                      mov.l   #unk_FFEC6AD8, r14
FFF2E2EA  4b1e                              add     r1, r14
FFF2E2EC  5cee                              movu.w  [r14], r14
FFF2E2EE  610e                              cmp     #0, r14
FFF2E2F0  21af                              bne.b   loc_FFF2E29F
FFF2E2F2  a889                   loc_FFF2E2F2 mov.l   14h+var_8[sp], r1
FFF2E2F4  6211                              add     #1, r1
FFF2E2F6  a089                              mov.l   r1, 14h+var_8[sp]
FFF2E2F8  a889                   loc_FFF2E2F8 mov.l   14h+var_8[sp], r1
FFF2E2FA  6211                              add     #1, r1
FFF2E2FC  a089                              mov.l   r1, 14h+var_8[sp]
FFF2E2FE  a889                   loc_FFF2E2FE mov.l   14h+var_8[sp], r1
FFF2E300  581e                              movu.b  [r1], r14
FFF2E302  610e                              cmp     #0, r14
FFF2E304  3b27fc                            bne.w   loc_FFF2DF2B
FFF2E307  6705                              rtsd    #5
FFF2E309  7100e0                 sub_FFF2E309 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2E309
FFF2E30C  a189                              mov.l   r1, 20h+var_4[sp]
FFF2E30E  a182                              mov.l   r2, 20h+var_8[sp]
FFF2E310  a10b                              mov.l   r3, 20h+var_C[sp]
FFF2E312  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF2E315  e5000702                          mov.l   20h+var_4[sp], 20h+var_18[sp]
FFF2E319  e5000601                          mov.l   20h+var_8[sp], 20h+var_1C[sp]
FFF2E31D  2e40                              bra.b   loc_FFF2E35D
FFF2E31F  a881                   loc_FFF2E31F mov.l   20h+var_18[sp], r1
FFF2E321  b019                              movu.b  1[r1], r1
FFF2E323  6101                              cmp     #0, r1
FFF2E325  1d                                bne.s   loc_FFF2E32A
FFF2E326  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2E329  0c                                bra.s   loc_FFF2E32D
FFF2E32A  f80600                 loc_FFF2E32A mov.l   #0, 20h+var_20[sp]
FFF2E32D  ec01                   loc_FFF2E32D mov.l   20h+var_20[sp], r1
FFF2E32F  6101                              cmp     #0, r1
FFF2E331  a809                              mov.l   20h+var_1C[sp], r1
FFF2E333  2134                              bne.b   loc_FFF2E367
FFF2E335  a882                              mov.l   20h+var_18[sp], r2
FFF2E337  c021                              mov.b   [r2], [r1]
FFF2E339  a809                              mov.l   20h+var_1C[sp], r1
FFF2E33B  6211                              add     #1, r1
FFF2E33D  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2E33F  a881                              mov.l   20h+var_18[sp], r1
FFF2E341  6211                              add     #1, r1
FFF2E343  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E345  a881                              mov.l   20h+var_18[sp], r1
FFF2E347  a80a                              mov.l   20h+var_1C[sp], r2
FFF2E349  c012                              mov.b   [r1], [r2]
FFF2E34B  a809                              mov.l   20h+var_1C[sp], r1
FFF2E34D  6211                              add     #1, r1
FFF2E34F  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2E351  a881                              mov.l   20h+var_18[sp], r1
FFF2E353  6211                              add     #1, r1
FFF2E355  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E357  a889                              mov.l   20h+var_14[sp], r1
FFF2E359  6211                              add     #1, r1
FFF2E35B  a089                              mov.l   r1, 20h+var_14[sp]
FFF2E35D  a881                   loc_FFF2E35D mov.l   20h+var_18[sp], r1
FFF2E35F  581e                              movu.b  [r1], r14
FFF2E361  610e                              cmp     #0, r14
FFF2E363  20bc                              beq.b   loc_FFF2E31F
FFF2E365  2ec5                              bra.b   loc_FFF2E32A
FFF2E367  f81400                 loc_FFF2E367 mov.b   #0, [r1]
FFF2E36A  a809                              mov.l   20h+var_1C[sp], r1
FFF2E36C  6211                              add     #1, r1
FFF2E36E  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2E370  a809                              mov.l   20h+var_1C[sp], r1
FFF2E372  f81400                            mov.b   #0, [r1]
FFF2E375  a909                              mov.l   20h+var_C[sp], r1
FFF2E377  f81401                            mov.b   #1, [r1]
FFF2E37A  a889                              mov.l   20h+var_14[sp], r1
FFF2E37C  a101                              mov.l   r1, 20h+var_10[sp]
FFF2E37E  6708                              rtsd    #8
FFF2E380  7ea6                   sub_FFF2E380 push.l  r6   ; <<<< FUNC sub_FFF2E380
FFF2E382  7100d8                            add     #-28h, sp, sp
FFF2E385  a209                              mov.l   r1, 28h+var_4[sp]
FFF2E387  a202                              mov.l   r2, 28h+var_8[sp]
FFF2E389  a102                              mov.l   r2, 28h+var_18[sp]
FFF2E38B  e5000903                          mov.l   28h+var_4[sp], 28h+var_1C[sp]
FFF2E38F  3e0600                            mov.l   #0, 28h+var_10[sp]
FFF2E392  3e0500                            mov.l   #0, 28h+var_14[sp]
FFF2E395  38cf00                            bra.w   loc_FFF2E464
FFF2E398  a901                   loc_FFF2E398 mov.l   28h+var_18[sp], r1
FFF2E39A  5811                              movu.b  [r1], r1
FFF2E39C  9109                              mov.w   r1, 28h+var_1E[sp]
FFF2E39E  a901                              mov.l   28h+var_18[sp], r1
FFF2E3A0  b019                              movu.b  1[r1], r1
FFF2E3A2  6c81                              shll    #8, r1
FFF2E3A4  06c90105                          add     28h+var_1E[sp].uw, r1
FFF2E3A8  9109                              mov.w   r1, 28h+var_1E[sp]
FFF2E3AA  b909                              movu.w  28h+var_1E[sp], r1
FFF2E3AC  6101                              cmp     #0, r1
FFF2E3AE  19                                bne.s   loc_FFF2E3B7
FFF2E3AF  a889                              mov.l   28h+var_1C[sp], r1
FFF2E3B1  f81400                            mov.b   #0, [r1]
FFF2E3B4  38b900                            bra.w   loc_FFF2E46D
FFF2E3B7  b909                   loc_FFF2E3B7 movu.w  28h+var_1E[sp], r1
FFF2E3B9  7551a5                            cmp     #-5Bh, r1
FFF2E3BC  19                                bne.s   loc_FFF2E3C5
FFF2E3BD  a889                              mov.l   28h+var_1C[sp], r1
FFF2E3BF  f8145c                            mov.b   #5Ch, [r1] ; '\'
FFF2E3C2  388a00                            bra.w   loc_FFF2E44C
FFF2E3C5  b909                   loc_FFF2E3C5 movu.w  28h+var_1E[sp], r1
FFF2E3C7  76013e20                          cmp     #203Eh, r1
FFF2E3CB  18                                bne.s   loc_FFF2E3D3
FFF2E3CC  a889                              mov.l   28h+var_1C[sp], r1
FFF2E3CE  f8147e                            mov.b   #7Eh, [r1] ; '~'
FFF2E3D1  2e7b                              bra.b   loc_FFF2E44C
FFF2E3D3  a901                   loc_FFF2E3D3 mov.l   28h+var_18[sp], r1
FFF2E3D5  b019                              movu.b  1[r1], r1
FFF2E3D7  7551ff                            cmp     #-1, r1
FFF2E3DA  210f                              bne.b   loc_FFF2E3E9
FFF2E3DC  a901                              mov.l   28h+var_18[sp], r1
FFF2E3DE  581e                              movu.b  [r1], r14
FFF2E3E0  755e61                            cmp     #61h, r14 ; 'a'
FFF2E3E3  2906                              blt.b   loc_FFF2E3E9
FFF2E3E5  f80601                            mov.l   #1, 28h+var_28[sp]
FFF2E3E8  0c                                bra.s   loc_FFF2E3EC
FFF2E3E9  f80600                 loc_FFF2E3E9 mov.l   #0, 28h+var_28[sp]
FFF2E3EC  ec01                   loc_FFF2E3EC mov.l   28h+var_28[sp], r1
FFF2E3EE  6101                              cmp     #0, r1
FFF2E3F0  200f                              beq.b   loc_FFF2E3FF
FFF2E3F2  a901                              mov.l   28h+var_18[sp], r1
FFF2E3F4  581e                              movu.b  [r1], r14
FFF2E3F6  755e9f                            cmp     #-61h, r14
FFF2E3F9  2a06                              bgt.b   loc_FFF2E3FF
FFF2E3FB  f80601                            mov.l   #1, 28h+var_28[sp]
FFF2E3FE  0c                                bra.s   loc_FFF2E402
FFF2E3FF  f80600                 loc_FFF2E3FF mov.l   #0, 28h+var_28[sp]
FFF2E402  ec01                   loc_FFF2E402 mov.l   28h+var_28[sp], r1
FFF2E404  6101                              cmp     #0, r1
FFF2E406  200f                              beq.b   loc_FFF2E415
FFF2E408  a901                              mov.l   28h+var_18[sp], r1
FFF2E40A  581e                              movu.b  [r1], r14
FFF2E40C  71ee40                            add     #40h, r14, r14 ; '@'
FFF2E40F  a889                              mov.l   28h+var_1C[sp], r1
FFF2E411  c31e                              mov.b   r14, [r1]
FFF2E413  2e39                              bra.b   loc_FFF2E44C
FFF2E415  b909                   loc_FFF2E415 movu.w  28h+var_1E[sp], r1
FFF2E417  755120                            cmp     #20h, r1 ; ' '
FFF2E41A  290d                              blt.b   loc_FFF2E427
FFF2E41C  b909                              movu.w  28h+var_1E[sp], r1
FFF2E41E  75517e                            cmp     #7Eh, r1 ; '~'
FFF2E421  2a06                              bgt.b   loc_FFF2E427
FFF2E423  f80601                            mov.l   #1, 28h+var_28[sp]
FFF2E426  0c                                bra.s   loc_FFF2E42A
FFF2E427  f80600                 loc_FFF2E427 mov.l   #0, 28h+var_28[sp]
FFF2E42A  ec01                   loc_FFF2E42A mov.l   28h+var_28[sp], r1
FFF2E42C  6101                              cmp     #0, r1
FFF2E42E  2010                              beq.b   loc_FFF2E43E
FFF2E430  a901                              mov.l   28h+var_18[sp], r1
FFF2E432  cc11                              mov.b   [r1], r1
FFF2E434  a88e                              mov.l   28h+var_1C[sp], r6
FFF2E436  05550300                          bsr.a   sub_FFF2E78B
FFF2E43A  c361                              mov.b   r1, [r6]
FFF2E43C  2e10                              bra.b   loc_FFF2E44C
FFF2E43E  e5000903               loc_FFF2E43E mov.l   28h+var_4[sp], 28h+var_1C[sp]
FFF2E442  a889                              mov.l   28h+var_1C[sp], r1
FFF2E444  f81400                            mov.b   #0, [r1]
FFF2E447  3e0100                            mov.l   #0, 28h+var_24[sp]
FFF2E44A  2e27                              bra.b   loc_FFF2E471
FFF2E44C  a901                   loc_FFF2E44C mov.l   28h+var_18[sp], r1
FFF2E44E  6221                              add     #2, r1
FFF2E450  a101                              mov.l   r1, 28h+var_18[sp]
FFF2E452  a889                              mov.l   28h+var_1C[sp], r1
FFF2E454  6211                              add     #1, r1
FFF2E456  a089                              mov.l   r1, 28h+var_1C[sp]
FFF2E458  a981                              mov.l   28h+var_10[sp], r1
FFF2E45A  6211                              add     #1, r1
FFF2E45C  a181                              mov.l   r1, 28h+var_10[sp]
FFF2E45E  a909                              mov.l   28h+var_14[sp], r1
FFF2E460  6211                              add     #1, r1
FFF2E462  a109                              mov.l   r1, 28h+var_14[sp]
FFF2E464  a981                   loc_FFF2E464 mov.l   28h+var_10[sp], r1
FFF2E466  61c1                              cmp     #0Ch, r1
FFF2E468  2805                              bge.b   loc_FFF2E46D
FFF2E46A  382eff                            bra.w   loc_FFF2E398
FFF2E46D  e5000501               loc_FFF2E46D mov.l   28h+var_14[sp], 28h+var_24[sp]
FFF2E471  a809                   loc_FFF2E471 mov.l   28h+var_24[sp], r1
FFF2E473  a189                              mov.l   r1, 28h+var_C[sp]
FFF2E475  3f660b                            rtsd    #2Ch, r6-r6
FFF2E478  7100e4                 sub_FFF2E478 add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2E478
FFF2E47B  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2E47D  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2E47F  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF2E481  a083                              mov.l   r3, 1Ch+var_14[sp]
FFF2E483  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF2E487  e10005                            mov.l   1Ch+var_8[sp], 1Ch+var_1C[sp]
FFF2E48A  2e14                              bra.b   loc_FFF2E49E
FFF2E48C  ec01                   loc_FFF2E48C mov.l   1Ch+var_1C[sp], r1
FFF2E48E  a80a                              mov.l   1Ch+var_18[sp], r2
FFF2E490  c012                              mov.b   [r1], [r2]
FFF2E492  a809                              mov.l   1Ch+var_18[sp], r1
FFF2E494  6211                              add     #1, r1
FFF2E496  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2E498  ec01                              mov.l   1Ch+var_1C[sp], r1
FFF2E49A  6211                              add     #1, r1
FFF2E49C  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2E49E  a881                   loc_FFF2E49E mov.l   1Ch+var_14[sp], r1
FFF2E4A0  7112ff                            add     #-1, r1, r2
FFF2E4A3  a082                              mov.l   r2, 1Ch+var_14[sp]
FFF2E4A5  6101                              cmp     #0, r1
FFF2E4A7  21e5                              bne.b   loc_FFF2E48C
FFF2E4A9  a981                              mov.l   1Ch+var_4[sp], r1
FFF2E4AB  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2E4AD  6707                              rtsd    #7
FFF2E4AF  7100d4                 sub_FFF2E4AF add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF2E4AF
FFF2E4B2  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF2E4B4  c70227                            mov.b   r2, 2Ch+var_5[sp]
FFF2E4B7  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF2E4B9  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF2E4BB  e5000a04                          mov.l   2Ch+var_4[sp], 2Ch+var_1C[sp]
FFF2E4BF  e5000a03                          mov.l   2Ch+var_4[sp], 2Ch+var_20[sp]
FFF2E4C3  663e                              mov.l   #3, r14
FFF2E4C5  06a10c0e0a                        tst     2Ch+var_4[sp].l, r14
FFF2E4CA  18                                bne.s   loc_FFF2E4D2
FFF2E4CB  aa01                              mov.l   2Ch+var_C[sp], r1
FFF2E4CD  06850107                          cmp     2Ch+var_10[sp].l, r1
FFF2E4D1  15                                beq.s   loc_FFF2E4D6
FFF2E4D2  f80601                 loc_FFF2E4D2 mov.l   #1, 2Ch+var_2C[sp]
FFF2E4D5  0c                                bra.s   loc_FFF2E4D9
FFF2E4D6  f80600                 loc_FFF2E4D6 mov.l   #0, 2Ch+var_2C[sp]
FFF2E4D9  ec01                   loc_FFF2E4D9 mov.l   2Ch+var_2C[sp], r1
FFF2E4DB  6101                              cmp     #0, r1
FFF2E4DD  2111                              bne.b   loc_FFF2E4EE
FFF2E4DF  2e21                              bra.b   loc_FFF2E500
FFF2E4E1  590127                 loc_FFF2E4E1 movu.b  2Ch+var_5[sp], r1
FFF2E4E4  a902                              mov.l   2Ch+var_1C[sp], r2
FFF2E4E6  c321                              mov.b   r1, [r2]
FFF2E4E8  a901                              mov.l   2Ch+var_1C[sp], r1
FFF2E4EA  6211                              add     #1, r1
FFF2E4EC  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2E4EE  aa01                   loc_FFF2E4EE mov.l   2Ch+var_C[sp], r1
FFF2E4F0  7112ff                            add     #-1, r1, r2
FFF2E4F3  a202                              mov.l   r2, 2Ch+var_C[sp]
FFF2E4F5  6101                              cmp     #0, r1
FFF2E4F7  21ea                              bne.b   loc_FFF2E4E1
FFF2E4F9  e5000a01                          mov.l   2Ch+var_4[sp], 2Ch+var_28[sp]
FFF2E4FD  389100                            bra.w   loc_FFF2E58E
FFF2E500  a989                   loc_FFF2E500 mov.l   2Ch+var_10[sp], r1
FFF2E502  6851                              shlr    #5, r1
FFF2E504  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2E506  590127                            movu.b  2Ch+var_5[sp], r1
FFF2E509  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF2E50B  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E50D  fdc81e                            shll    #8, r1, r14
FFF2E510  57e1                              or      r14, r1
FFF2E512  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF2E514  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E516  fdd01e                            shll    #10h, r1, r14
FFF2E519  57e1                              or      r14, r1
FFF2E51B  a081                              mov.l   r1, 2Ch+var_24[sp]
FFF2E51D  2e62                              bra.b   loc_FFF2E57F
FFF2E51F  a881                   loc_FFF2E51F mov.l   2Ch+var_24[sp], r1
FFF2E521  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E523  e321                              mov.l   r1, [r2]
FFF2E525  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E527  6241                              add     #4, r1
FFF2E529  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E52B  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E52D  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E52F  e321                              mov.l   r1, [r2]
FFF2E531  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E533  6241                              add     #4, r1
FFF2E535  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E537  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E539  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E53B  e321                              mov.l   r1, [r2]
FFF2E53D  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E53F  6241                              add     #4, r1
FFF2E541  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E543  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E545  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E547  e321                              mov.l   r1, [r2]
FFF2E549  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E54B  6241                              add     #4, r1
FFF2E54D  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E54F  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E551  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E553  e321                              mov.l   r1, [r2]
FFF2E555  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E557  6241                              add     #4, r1
FFF2E559  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E55B  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E55D  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E55F  e321                              mov.l   r1, [r2]
FFF2E561  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E563  6241                              add     #4, r1
FFF2E565  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E567  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E569  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E56B  e321                              mov.l   r1, [r2]
FFF2E56D  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E56F  6241                              add     #4, r1
FFF2E571  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E573  a881                              mov.l   2Ch+var_24[sp], r1
FFF2E575  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E577  e321                              mov.l   r1, [r2]
FFF2E579  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E57B  6241                              add     #4, r1
FFF2E57D  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E57F  a909                   loc_FFF2E57F mov.l   2Ch+var_18[sp], r1
FFF2E581  7112ff                            add     #-1, r1, r2
FFF2E584  a10a                              mov.l   r2, 2Ch+var_18[sp]
FFF2E586  6101                              cmp     #0, r1
FFF2E588  2197                              bne.b   loc_FFF2E51F
FFF2E58A  e5000a01                          mov.l   2Ch+var_4[sp], 2Ch+var_28[sp]
FFF2E58E  a809                   loc_FFF2E58E mov.l   2Ch+var_28[sp], r1
FFF2E590  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF2E592  670b                              rtsd    #0Bh
FFF2E594  7100d4                 sub_FFF2E594 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF2E594
FFF2E597  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF2E599  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF2E59B  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF2E59D  e5000906                          mov.l   2Ch+var_8[sp], 2Ch+var_14[sp]
FFF2E5A1  e5000a05                          mov.l   2Ch+var_4[sp], 2Ch+var_18[sp]
FFF2E5A5  e5000802                          mov.l   2Ch+var_C[sp], 2Ch+var_24[sp]
FFF2E5A9  a981                              mov.l   2Ch+var_14[sp], r1
FFF2E5AB  06890108                          add     2Ch+var_C[sp].l, r1
FFF2E5AF  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2E5B1  a909                              mov.l   2Ch+var_18[sp], r1
FFF2E5B3  06890108                          add     2Ch+var_C[sp].l, r1
FFF2E5B7  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E5B9  a981                              mov.l   2Ch+var_14[sp], r1
FFF2E5BB  06850105                          cmp     2Ch+var_18[sp].l, r1
FFF2E5BF  220e                              bgeu.b  loc_FFF2E5CD
FFF2E5C1  a901                              mov.l   2Ch+var_1C[sp], r1
FFF2E5C3  06850105                          cmp     2Ch+var_18[sp].l, r1
FFF2E5C7  2506                              bleu.b  loc_FFF2E5CD
FFF2E5C9  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF2E5CC  0c                                bra.s   loc_FFF2E5D0
FFF2E5CD  f80600                 loc_FFF2E5CD mov.l   #0, 2Ch+var_2C[sp]
FFF2E5D0  ec01                   loc_FFF2E5D0 mov.l   2Ch+var_2C[sp], r1
FFF2E5D2  6101                              cmp     #0, r1
FFF2E5D4  2116                              bne.b   loc_FFF2E5EA
FFF2E5D6  2e37                              bra.b   loc_FFF2E60D
FFF2E5D8  a901                   loc_FFF2E5D8 mov.l   2Ch+var_1C[sp], r1
FFF2E5DA  a88a                              mov.l   2Ch+var_20[sp], r2
FFF2E5DC  c012                              mov.b   [r1], [r2]
FFF2E5DE  a889                              mov.l   2Ch+var_20[sp], r1
FFF2E5E0  6011                              sub     #1, r1
FFF2E5E2  a089                              mov.l   r1, 2Ch+var_20[sp]
FFF2E5E4  a901                              mov.l   2Ch+var_1C[sp], r1
FFF2E5E6  6011                              sub     #1, r1
FFF2E5E8  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2E5EA  a881                   loc_FFF2E5EA mov.l   2Ch+var_24[sp], r1
FFF2E5EC  7112ff                            add     #-1, r1, r2
FFF2E5EF  a082                              mov.l   r2, 2Ch+var_24[sp]
FFF2E5F1  6101                              cmp     #0, r1
FFF2E5F3  21e5                              bne.b   loc_FFF2E5D8
FFF2E5F5  e5000a01                          mov.l   2Ch+var_4[sp], 2Ch+var_28[sp]
FFF2E5F9  2e23                              bra.b   loc_FFF2E61C
FFF2E5FB  a981                   loc_FFF2E5FB mov.l   2Ch+var_14[sp], r1
FFF2E5FD  a90a                              mov.l   2Ch+var_18[sp], r2
FFF2E5FF  c012                              mov.b   [r1], [r2]
FFF2E601  a909                              mov.l   2Ch+var_18[sp], r1
FFF2E603  6211                              add     #1, r1
FFF2E605  a109                              mov.l   r1, 2Ch+var_18[sp]
FFF2E607  a981                              mov.l   2Ch+var_14[sp], r1
FFF2E609  6211                              add     #1, r1
FFF2E60B  a181                              mov.l   r1, 2Ch+var_14[sp]
FFF2E60D  a881                   loc_FFF2E60D mov.l   2Ch+var_24[sp], r1
FFF2E60F  7112ff                            add     #-1, r1, r2
FFF2E612  a082                              mov.l   r2, 2Ch+var_24[sp]
FFF2E614  6101                              cmp     #0, r1
FFF2E616  21e5                              bne.b   loc_FFF2E5FB
FFF2E618  e5000a01                          mov.l   2Ch+var_4[sp], 2Ch+var_28[sp]
FFF2E61C  a809                   loc_FFF2E61C mov.l   2Ch+var_28[sp], r1
FFF2E61E  a189                              mov.l   r1, 2Ch+var_10[sp]
FFF2E620  670b                              rtsd    #0Bh
FFF2E622  7100f0                 sub_FFF2E622 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2E622
FFF2E625  a089                              mov.l   r1, 10h+var_4[sp]
FFF2E627  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E629  f80600                            mov.l   #0, 10h+var_10[sp]
FFF2E62C  0d                                bra.s   loc_FFF2E631
FFF2E62D  6211                   loc_FFF2E62D add     #1, r1
FFF2E62F  e301                              mov.l   r1, 10h+var_10[sp]
FFF2E631  a809                   loc_FFF2E631 mov.l   10h+var_C[sp], r1
FFF2E633  cc1e                              mov.b   [r1], r14
FFF2E635  6211                              add     #1, r1
FFF2E637  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E639  610e                              cmp     #0, r14
FFF2E63B  ec01                              mov.l   10h+var_10[sp], r1
FFF2E63D  21f0                              bne.b   loc_FFF2E62D
FFF2E63F  a081                              mov.l   r1, 10h+var_8[sp]
FFF2E641  6704                              rtsd    #4
FFF2E643  7100f0                 sub_FFF2E643 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2E643
FFF2E646  a089                              mov.l   r1, 10h+var_4[sp]
FFF2E648  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E64A  f80600                            mov.l   #0, 10h+var_10[sp]
FFF2E64D  0d                                bra.s   loc_FFF2E652
FFF2E64E  6211                   loc_FFF2E64E add     #1, r1
FFF2E650  e301                              mov.l   r1, 10h+var_10[sp]
FFF2E652  a809                   loc_FFF2E652 mov.l   10h+var_C[sp], r1
FFF2E654  5c1e                              movu.w  [r1], r14
FFF2E656  6221                              add     #2, r1
FFF2E658  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E65A  610e                              cmp     #0, r14
FFF2E65C  ec01                              mov.l   10h+var_10[sp], r1
FFF2E65E  21f0                              bne.b   loc_FFF2E64E
FFF2E660  6c11                              shll    #1, r1
FFF2E662  a081                              mov.l   r1, 10h+var_8[sp]
FFF2E664  6704                              rtsd    #4
FFF2E666  7100f0                 sub_FFF2E666 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2E666
FFF2E669  a089                              mov.l   r1, 10h+var_4[sp]
FFF2E66B  a082                              mov.l   r2, 10h+var_8[sp]
FFF2E66D  e10003                            mov.l   10h+var_4[sp], 10h+var_10[sp]
FFF2E670  a881                   loc_FFF2E670 mov.l   10h+var_8[sp], r1
FFF2E672  ec02                              mov.l   10h+var_10[sp], r2
FFF2E674  c012                              mov.b   [r1], [r2]
FFF2E676  ec01                              mov.l   10h+var_10[sp], r1
FFF2E678  6211                              add     #1, r1
FFF2E67A  cc2e                              mov.b   [r2], r14
FFF2E67C  e301                              mov.l   r1, 10h+var_10[sp]
FFF2E67E  a881                              mov.l   10h+var_8[sp], r1
FFF2E680  6211                              add     #1, r1
FFF2E682  a081                              mov.l   r1, 10h+var_8[sp]
FFF2E684  610e                              cmp     #0, r14
FFF2E686  21ea                              bne.b   loc_FFF2E670
FFF2E688  a889                              mov.l   10h+var_4[sp], r1
FFF2E68A  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E68C  6704                              rtsd    #4
FFF2E68E  7100e4                 sub_FFF2E68E add     #-1Ch, sp, sp   ; <<<< FUNC sub_FFF2E68E
FFF2E691  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2E693  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2E695  a103                              mov.l   r3, 1Ch+var_C[sp]
FFF2E697  e5000601                          mov.l   1Ch+var_4[sp], 1Ch+var_18[sp]
FFF2E69B  e10005                            mov.l   1Ch+var_8[sp], 1Ch+var_1C[sp]
FFF2E69E  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF2E6A1  2e26                              bra.b   loc_FFF2E6C7
FFF2E6A3  ec01                   loc_FFF2E6A3 mov.l   1Ch+var_1C[sp], r1
FFF2E6A5  cc1e                              mov.b   [r1], r14
FFF2E6A7  610e                              cmp     #0, r14
FFF2E6A9  a809                              mov.l   1Ch+var_18[sp], r1
FFF2E6AB  200d                              beq.b   loc_FFF2E6B8
FFF2E6AD  ec02                              mov.l   1Ch+var_1C[sp], r2
FFF2E6AF  c021                              mov.b   [r2], [r1]
FFF2E6B1  ec01                              mov.l   1Ch+var_1C[sp], r1
FFF2E6B3  6211                              add     #1, r1
FFF2E6B5  e301                              mov.l   r1, 1Ch+var_1C[sp]
FFF2E6B7  0c                                bra.s   loc_FFF2E6BB
FFF2E6B8  f81400                 loc_FFF2E6B8 mov.b   #0, [r1]
FFF2E6BB  a881                   loc_FFF2E6BB mov.l   1Ch+var_14[sp], r1
FFF2E6BD  6211                              add     #1, r1
FFF2E6BF  a081                              mov.l   r1, 1Ch+var_14[sp]
FFF2E6C1  a809                              mov.l   1Ch+var_18[sp], r1
FFF2E6C3  6211                              add     #1, r1
FFF2E6C5  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2E6C7  a881                   loc_FFF2E6C7 mov.l   1Ch+var_14[sp], r1
FFF2E6C9  06850104                          cmp     1Ch+var_C[sp].l, r1
FFF2E6CD  23d6                              bltu.b  loc_FFF2E6A3
FFF2E6CF  a981                              mov.l   1Ch+var_4[sp], r1
FFF2E6D1  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF2E6D3  6707                              rtsd    #7
FFF2E6D5  7100e0                 sub_FFF2E6D5 add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2E6D5
FFF2E6D8  a189                              mov.l   r1, 20h+var_4[sp]
FFF2E6DA  a182                              mov.l   r2, 20h+var_8[sp]
FFF2E6DC  a10b                              mov.l   r3, 20h+var_C[sp]
FFF2E6DE  e5000702                          mov.l   20h+var_4[sp], 20h+var_18[sp]
FFF2E6E2  e5000601                          mov.l   20h+var_8[sp], 20h+var_1C[sp]
FFF2E6E6  3e0300                            mov.l   #0, 20h+var_14[sp]
FFF2E6E9  2e5e                              bra.b   loc_FFF2E747
FFF2E6EB  a809                   loc_FFF2E6EB mov.l   20h+var_1C[sp], r1
FFF2E6ED  cc1e                              mov.b   [r1], r14
FFF2E6EF  610e                              cmp     #0, r14
FFF2E6F1  210d                              bne.b   loc_FFF2E6FE
FFF2E6F3  a809                              mov.l   20h+var_1C[sp], r1
FFF2E6F5  8819                              mov.b   1[r1], r1
FFF2E6F7  6101                              cmp     #0, r1
FFF2E6F9  1d                                bne.s   loc_FFF2E6FE
FFF2E6FA  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2E6FD  0c                                bra.s   loc_FFF2E701
FFF2E6FE  f80600                 loc_FFF2E6FE mov.l   #0, 20h+var_20[sp]
FFF2E701  ec01                   loc_FFF2E701 mov.l   20h+var_20[sp], r1
FFF2E703  6101                              cmp     #0, r1
FFF2E705  a881                              mov.l   20h+var_18[sp], r1
FFF2E707  2018                              beq.b   loc_FFF2E71F
FFF2E709  f81400                            mov.b   #0, [r1]
FFF2E70C  a881                              mov.l   20h+var_18[sp], r1
FFF2E70E  6211                              add     #1, r1
FFF2E710  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E712  a881                              mov.l   20h+var_18[sp], r1
FFF2E714  f81400                            mov.b   #0, [r1]
FFF2E717  a881                              mov.l   20h+var_18[sp], r1
FFF2E719  6211                              add     #1, r1
FFF2E71B  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E71D  2e24                              bra.b   loc_FFF2E741
FFF2E71F  a80a                   loc_FFF2E71F mov.l   20h+var_1C[sp], r2
FFF2E721  c021                              mov.b   [r2], [r1]
FFF2E723  a881                              mov.l   20h+var_18[sp], r1
FFF2E725  6211                              add     #1, r1
FFF2E727  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E729  a809                              mov.l   20h+var_1C[sp], r1
FFF2E72B  6211                              add     #1, r1
FFF2E72D  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2E72F  a809                              mov.l   20h+var_1C[sp], r1
FFF2E731  a882                              mov.l   20h+var_18[sp], r2
FFF2E733  c012                              mov.b   [r1], [r2]
FFF2E735  a881                              mov.l   20h+var_18[sp], r1
FFF2E737  6211                              add     #1, r1
FFF2E739  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E73B  a809                              mov.l   20h+var_1C[sp], r1
FFF2E73D  6211                              add     #1, r1
FFF2E73F  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2E741  a889                   loc_FFF2E741 mov.l   20h+var_14[sp], r1
FFF2E743  6211                              add     #1, r1
FFF2E745  a089                              mov.l   r1, 20h+var_14[sp]
FFF2E747  a889                   loc_FFF2E747 mov.l   20h+var_14[sp], r1
FFF2E749  06850105                          cmp     20h+var_C[sp].l, r1
FFF2E74D  239e                              bltu.b  loc_FFF2E6EB
FFF2E74F  a989                              mov.l   20h+var_4[sp], r1
FFF2E751  a101                              mov.l   r1, 20h+var_10[sp]
FFF2E753  6708                              rtsd    #8
FFF2E755  7100e8                 sub_FFF2E755 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2E755
FFF2E758  a109                              mov.l   r1, 18h+var_4[sp]
FFF2E75A  a102                              mov.l   r2, 18h+var_8[sp]
FFF2E75C  e5000502                          mov.l   18h+var_4[sp], 18h+var_10[sp]
FFF2E760  2e13                              bra.b   loc_FFF2E773
FFF2E762  e10002                 loc_FFF2E762 mov.l   18h+var_10[sp], 18h+var_18[sp]
FFF2E765  2e20                              bra.b   loc_FFF2E785
FFF2E767  8989                   loc_FFF2E767 mov.b   18h+var_11[sp], r1
FFF2E769  6101                              cmp     #0, r1
FFF2E76B  2017                              beq.b   loc_FFF2E782
FFF2E76D  a881                              mov.l   18h+var_10[sp], r1
FFF2E76F  6211                              add     #1, r1
FFF2E771  a081                              mov.l   r1, 18h+var_10[sp]
FFF2E773  a881                   loc_FFF2E773 mov.l   18h+var_10[sp], r1
FFF2E775  c41007                            mov.b   [r1], 18h+var_11[sp]
FFF2E778  8989                              mov.b   18h+var_11[sp], r1
FFF2E77A  06050110                          cmp     18h+var_8[sp].b, r1
FFF2E77E  20e4                              beq.b   loc_FFF2E762
FFF2E780  2ee7                              bra.b   loc_FFF2E767
FFF2E782  f80600                 loc_FFF2E782 mov.l   #0, 18h+var_18[sp]
FFF2E785  ec01                   loc_FFF2E785 mov.l   18h+var_18[sp], r1
FFF2E787  a089                              mov.l   r1, 18h+var_C[sp]
FFF2E789  6706                              rtsd    #6
FFF2E78B  6080                   sub_FFF2E78B sub     #8, sp   ; <<<< FUNC sub_FFF2E78B
FFF2E78D  8189                              mov.b   r1, 8+var_1[sp]
FFF2E78F  8989                              mov.b   8+var_1[sp], r1
FFF2E791  755161                            cmp     #61h, r1 ; 'a'
FFF2E794  290d                              blt.b   loc_FFF2E7A1
FFF2E796  8989                              mov.b   8+var_1[sp], r1
FFF2E798  75517a                            cmp     #7Ah, r1 ; 'z'
FFF2E79B  2a06                              bgt.b   loc_FFF2E7A1
FFF2E79D  f80601                            mov.l   #1, 8+var_8[sp]
FFF2E7A0  0c                                bra.s   loc_FFF2E7A4
FFF2E7A1  f80600                 loc_FFF2E7A1 mov.l   #0, 8+var_8[sp]
FFF2E7A4  ec01                   loc_FFF2E7A4 mov.l   8+var_8[sp], r1
FFF2E7A6  6101                              cmp     #0, r1
FFF2E7A8  b189                              movu.b  8+var_1[sp], r1
FFF2E7AA  11                                beq.s   loc_FFF2E7B3
FFF2E7AB  cf11                              mov.b   r1, r1
FFF2E7AD  7111e0                            add     #-20h, r1, r1
FFF2E7B0  8109                              mov.b   r1, 8+var_3[sp]
FFF2E7B2  0b                                bra.s   loc_FFF2E7B5
FFF2E7B3  8109                   loc_FFF2E7B3 mov.b   r1, 8+var_3[sp]
FFF2E7B5  c5000506               loc_FFF2E7B5 mov.b   8+var_3[sp], 8+var_2[sp]
FFF2E7B9  8981                              mov.b   8+var_2[sp], r1
FFF2E7BB  6702                              rtsd    #2
FFF2E7BD  6080                   sub_FFF2E7BD sub     #8, sp   ; <<<< FUNC sub_FFF2E7BD
FFF2E7BF  8189                              mov.b   r1, 8+var_1[sp]
FFF2E7C1  8989                              mov.b   8+var_1[sp], r1
FFF2E7C3  755141                            cmp     #41h, r1 ; 'A'
FFF2E7C6  290d                              blt.b   loc_FFF2E7D3
FFF2E7C8  8989                              mov.b   8+var_1[sp], r1
FFF2E7CA  75515a                            cmp     #5Ah, r1 ; 'Z'
FFF2E7CD  2a06                              bgt.b   loc_FFF2E7D3
FFF2E7CF  f80601                            mov.l   #1, 8+var_8[sp]
FFF2E7D2  0c                                bra.s   loc_FFF2E7D6
FFF2E7D3  f80600                 loc_FFF2E7D3 mov.l   #0, 8+var_8[sp]
FFF2E7D6  ec01                   loc_FFF2E7D6 mov.l   8+var_8[sp], r1
FFF2E7D8  6101                              cmp     #0, r1
FFF2E7DA  b189                              movu.b  8+var_1[sp], r1
FFF2E7DC  11                                beq.s   loc_FFF2E7E5
FFF2E7DD  cf11                              mov.b   r1, r1
FFF2E7DF  711120                            add     #20h, r1, r1 ; ' '
FFF2E7E2  8109                              mov.b   r1, 8+var_3[sp]
FFF2E7E4  0b                                bra.s   loc_FFF2E7E7
FFF2E7E5  8109                   loc_FFF2E7E5 mov.b   r1, 8+var_3[sp]
FFF2E7E7  c5000506               loc_FFF2E7E7 mov.b   8+var_3[sp], 8+var_2[sp]
FFF2E7EB  8981                              mov.b   8+var_2[sp], r1
FFF2E7ED  6702                              rtsd    #2
FFF2E7EF  7ea6                   sub_FFF2E7EF push.l  r6   ; <<<< FUNC sub_FFF2E7EF
FFF2E7F1  7100e8                            add     #-18h, sp, sp
FFF2E7F4  a109                              mov.l   r1, 18h+var_4[sp]
FFF2E7F6  a102                              mov.l   r2, 18h+var_8[sp]
FFF2E7F8  3e0200                            mov.l   #0, 18h+var_10[sp]
FFF2E7FB  2e44                              bra.b   loc_FFF2E83F
FFF2E7FD  8981                   loc_FFF2E7FD mov.b   18h+var_12[sp], r1
FFF2E7FF  6101                              cmp     #0, r1
FFF2E801  1d                                bne.s   loc_FFF2E806
FFF2E802  f80601                            mov.l   #1, 18h+var_18[sp]
FFF2E805  0c                                bra.s   loc_FFF2E809
FFF2E806  f80600                 loc_FFF2E806 mov.l   #0, 18h+var_18[sp]
FFF2E809  ec01                   loc_FFF2E809 mov.l   18h+var_18[sp], r1
FFF2E80B  6101                              cmp     #0, r1
FFF2E80D  2150                              bne.b   loc_FFF2E85D
FFF2E80F  8989                              mov.b   18h+var_11[sp], r1
FFF2E811  6101                              cmp     #0, r1
FFF2E813  1f                                bne.s   loc_FFF2E81A
FFF2E814  f90602ff                          mov.l   #-1, 18h+var_10[sp]
FFF2E818  2e45                              bra.b   loc_FFF2E85D
FFF2E81A  8981                   loc_FFF2E81A mov.b   18h+var_12[sp], r1
FFF2E81C  6101                              cmp     #0, r1
FFF2E81E  1e                                bne.s   loc_FFF2E824
FFF2E81F  3e0201                            mov.l   #1, 18h+var_10[sp]
FFF2E822  2e3b                              bra.b   loc_FFF2E85D
FFF2E824  8989                   loc_FFF2E824 mov.b   18h+var_11[sp], r1
FFF2E826  3965ff                            bsr.w   sub_FFF2E78B
FFF2E829  ef16                              mov.l   r1, r6
FFF2E82B  8981                              mov.b   18h+var_12[sp], r1
FFF2E82D  395eff                            bsr.w   sub_FFF2E78B
FFF2E830  4316                              sub     r1, r6
FFF2E832  818e                              mov.b   r6, 18h+var_11[sp]
FFF2E834  8989                              mov.b   18h+var_11[sp], r1
FFF2E836  6101                              cmp     #0, r1
FFF2E838  17                                beq.s   loc_FFF2E83F
FFF2E839  8989                              mov.b   18h+var_11[sp], r1
FFF2E83B  a081                              mov.l   r1, 18h+var_10[sp]
FFF2E83D  2e20                              bra.b   loc_FFF2E85D
FFF2E83F  a909                   loc_FFF2E83F mov.l   18h+var_4[sp], r1
FFF2E841  c41007                            mov.b   [r1], 18h+var_11[sp]
FFF2E844  a909                              mov.l   18h+var_4[sp], r1
FFF2E846  6211                              add     #1, r1
FFF2E848  a109                              mov.l   r1, 18h+var_4[sp]
FFF2E84A  a901                              mov.l   18h+var_8[sp], r1
FFF2E84C  c41006                            mov.b   [r1], 18h+var_12[sp]
FFF2E84F  a901                              mov.l   18h+var_8[sp], r1
FFF2E851  6211                              add     #1, r1
FFF2E853  a101                              mov.l   r1, 18h+var_8[sp]
FFF2E855  8989                              mov.b   18h+var_11[sp], r1
FFF2E857  6101                              cmp     #0, r1
FFF2E859  20a4                              beq.b   loc_FFF2E7FD
FFF2E85B  2eab                              bra.b   loc_FFF2E806
FFF2E85D  a881                   loc_FFF2E85D mov.l   18h+var_10[sp], r1
FFF2E85F  a089                              mov.l   r1, 18h+var_C[sp]
FFF2E861  3f6607                            rtsd    #1Ch, r6-r6
FFF2E864  7ea6                   sub_FFF2E864 push.l  r6   ; <<<< FUNC sub_FFF2E864
FFF2E866  7100dc                            add     #-24h, sp, sp
FFF2E869  a201                              mov.l   r1, 24h+var_4[sp]
FFF2E86B  a18a                              mov.l   r2, 24h+var_8[sp]
FFF2E86D  3e0500                            mov.l   #0, 24h+var_10[sp]
FFF2E870  e5000803                          mov.l   24h+var_4[sp], 24h+var_18[sp]
FFF2E874  e5000702                          mov.l   24h+var_8[sp], 24h+var_1C[sp]
FFF2E878  388f00                            bra.w   loc_FFF2E907
FFF2E87B  ba01                   loc_FFF2E87B movu.w  24h+var_14[sp], r1
FFF2E87D  6101                              cmp     #0, r1
FFF2E87F  1d                                bne.s   loc_FFF2E884
FFF2E880  f80601                            mov.l   #1, 24h+var_24[sp]
FFF2E883  0c                                bra.s   loc_FFF2E887
FFF2E884  f80600                 loc_FFF2E884 mov.l   #0, 24h+var_24[sp]
FFF2E887  ec01                   loc_FFF2E887 mov.l   24h+var_24[sp], r1
FFF2E889  6101                              cmp     #0, r1
FFF2E88B  3b9c00                            bne.w   loc_FFF2E927
FFF2E88E  ba09                              movu.w  24h+var_12[sp], r1
FFF2E890  6101                              cmp     #0, r1
FFF2E892  18                                bne.s   loc_FFF2E89A
FFF2E893  f90605ff                          mov.l   #-1, 24h+var_10[sp]
FFF2E897  389000                            bra.w   loc_FFF2E927
FFF2E89A  ba01                   loc_FFF2E89A movu.w  24h+var_14[sp], r1
FFF2E89C  6101                              cmp     #0, r1
FFF2E89E  1f                                bne.s   loc_FFF2E8A5
FFF2E89F  3e0501                            mov.l   #1, 24h+var_10[sp]
FFF2E8A2  388500                            bra.w   loc_FFF2E927
FFF2E8A5  a889                   loc_FFF2E8A5 mov.l   24h+var_18[sp], r1
FFF2E8A7  c41007                            mov.b   [r1], 24h+var_1D[sp]
FFF2E8AA  a889                              mov.l   24h+var_18[sp], r1
FFF2E8AC  6211                              add     #1, r1
FFF2E8AE  a089                              mov.l   r1, 24h+var_18[sp]
FFF2E8B0  a889                              mov.l   24h+var_18[sp], r1
FFF2E8B2  c41006                            mov.b   [r1], 24h+var_1E[sp]
FFF2E8B5  a889                              mov.l   24h+var_18[sp], r1
FFF2E8B7  6211                              add     #1, r1
FFF2E8B9  a089                              mov.l   r1, 24h+var_18[sp]
FFF2E8BB  a881                              mov.l   24h+var_1C[sp], r1
FFF2E8BD  c41005                            mov.b   [r1], 24h+var_1F[sp]
FFF2E8C0  a881                              mov.l   24h+var_1C[sp], r1
FFF2E8C2  6211                              add     #1, r1
FFF2E8C4  a081                              mov.l   r1, 24h+var_1C[sp]
FFF2E8C6  a881                              mov.l   24h+var_1C[sp], r1
FFF2E8C8  c41004                            mov.b   [r1], 24h+var_20[sp]
FFF2E8CB  a881                              mov.l   24h+var_1C[sp], r1
FFF2E8CD  6211                              add     #1, r1
FFF2E8CF  a081                              mov.l   r1, 24h+var_1C[sp]
FFF2E8D1  8981                              mov.b   24h+var_1E[sp], r1
FFF2E8D3  6101                              cmp     #0, r1
FFF2E8D5  1a                                bne.s   loc_FFF2E8DF
FFF2E8D6  8901                              mov.b   24h+var_20[sp], r1
FFF2E8D8  6101                              cmp     #0, r1
FFF2E8DA  1d                                bne.s   loc_FFF2E8DF
FFF2E8DB  f80601                            mov.l   #1, 24h+var_24[sp]
FFF2E8DE  0c                                bra.s   loc_FFF2E8E2
FFF2E8DF  f80600                 loc_FFF2E8DF mov.l   #0, 24h+var_24[sp]
FFF2E8E2  ec01                   loc_FFF2E8E2 mov.l   24h+var_24[sp], r1
FFF2E8E4  6101                              cmp     #0, r1
FFF2E8E6  2013                              beq.b   loc_FFF2E8F9
FFF2E8E8  8989                              mov.b   24h+var_1D[sp], r1
FFF2E8EA  39a1fe                            bsr.w   sub_FFF2E78B
FFF2E8ED  ef16                              mov.l   r1, r6
FFF2E8EF  8909                              mov.b   24h+var_1F[sp], r1
FFF2E8F1  399afe                            bsr.w   sub_FFF2E78B
FFF2E8F4  4316                              sub     r1, r6
FFF2E8F6  a10e                              mov.l   r6, 24h+var_10[sp]
FFF2E8F8  09                                bra.s   loc_FFF2E901
FFF2E8F9  ba09                   loc_FFF2E8F9 movu.w  24h+var_12[sp], r1
FFF2E8FB  06c10108                          sub     24h+var_14[sp].uw, r1
FFF2E8FF  a109                              mov.l   r1, 24h+var_10[sp]
FFF2E901  a909                   loc_FFF2E901 mov.l   24h+var_10[sp], r1
FFF2E903  6101                              cmp     #0, r1
FFF2E905  2122                              bne.b   loc_FFF2E927
FFF2E907  aa01                   loc_FFF2E907 mov.l   24h+var_4[sp], r1
FFF2E909  d41009                            mov.w   [r1], 24h+var_12[sp]
FFF2E90C  aa01                              mov.l   24h+var_4[sp], r1
FFF2E90E  6221                              add     #2, r1
FFF2E910  a201                              mov.l   r1, 24h+var_4[sp]
FFF2E912  a989                              mov.l   24h+var_8[sp], r1
FFF2E914  d41008                            mov.w   [r1], 24h+var_14[sp]
FFF2E917  a989                              mov.l   24h+var_8[sp], r1
FFF2E919  6221                              add     #2, r1
FFF2E91B  a189                              mov.l   r1, 24h+var_8[sp]
FFF2E91D  ba09                              movu.w  24h+var_12[sp], r1
FFF2E91F  6101                              cmp     #0, r1
FFF2E921  3a5aff                            beq.w   loc_FFF2E87B
FFF2E924  3860ff                            bra.w   loc_FFF2E884
FFF2E927  a909                   loc_FFF2E927 mov.l   24h+var_10[sp], r1
FFF2E929  a181                              mov.l   r1, 24h+var_C[sp]
FFF2E92B  3f660a                            rtsd    #28h, r6-r6
FFF2E92E  7ea6                   sub_FFF2E92E push.l  r6   ; <<<< FUNC sub_FFF2E92E
FFF2E930  7100e0                            add     #-20h, sp, sp
FFF2E933  a189                              mov.l   r1, 20h+var_4[sp]
FFF2E935  a182                              mov.l   r2, 20h+var_8[sp]
FFF2E937  a10b                              mov.l   r3, 20h+var_C[sp]
FFF2E939  3e0200                            mov.l   #0, 20h+var_18[sp]
FFF2E93C  2e69                              bra.b   loc_FFF2E9A5
FFF2E93E  a989                   loc_FFF2E93E mov.l   20h+var_4[sp], r1
FFF2E940  c4100f                            mov.b   [r1], 20h+var_11[sp]
FFF2E943  a989                              mov.l   20h+var_4[sp], r1
FFF2E945  6211                              add     #1, r1
FFF2E947  a189                              mov.l   r1, 20h+var_4[sp]
FFF2E949  a981                              mov.l   20h+var_8[sp], r1
FFF2E94B  c4100e                            mov.b   [r1], 20h+var_12[sp]
FFF2E94E  a981                              mov.l   20h+var_8[sp], r1
FFF2E950  6211                              add     #1, r1
FFF2E952  a181                              mov.l   r1, 20h+var_8[sp]
FFF2E954  8b89                              mov.b   20h+var_11[sp], r1
FFF2E956  6101                              cmp     #0, r1
FFF2E958  1a                                bne.s   loc_FFF2E962
FFF2E959  8b81                              mov.b   20h+var_12[sp], r1
FFF2E95B  6101                              cmp     #0, r1
FFF2E95D  1d                                bne.s   loc_FFF2E962
FFF2E95E  f80601                            mov.l   #1, 20h+var_20[sp]
FFF2E961  0c                                bra.s   loc_FFF2E965
FFF2E962  f80600                 loc_FFF2E962 mov.l   #0, 20h+var_20[sp]
FFF2E965  ec01                   loc_FFF2E965 mov.l   20h+var_20[sp], r1
FFF2E967  6101                              cmp     #0, r1
FFF2E969  16                                beq.s   loc_FFF2E96F
FFF2E96A  3e0100                            mov.l   #0, 20h+var_1C[sp]
FFF2E96D  2e43                              bra.b   loc_FFF2E9B0
FFF2E96F  8b89                   loc_FFF2E96F mov.b   20h+var_11[sp], r1
FFF2E971  6101                              cmp     #0, r1
FFF2E973  1f                                bne.s   loc_FFF2E97A
FFF2E974  f90601ff                          mov.l   #-1, 20h+var_1C[sp]
FFF2E978  2e38                              bra.b   loc_FFF2E9B0
FFF2E97A  8b81                   loc_FFF2E97A mov.b   20h+var_12[sp], r1
FFF2E97C  6101                              cmp     #0, r1
FFF2E97E  1e                                bne.s   loc_FFF2E984
FFF2E97F  3e0101                            mov.l   #1, 20h+var_1C[sp]
FFF2E982  2e2e                              bra.b   loc_FFF2E9B0
FFF2E984  8b89                   loc_FFF2E984 mov.b   20h+var_11[sp], r1
FFF2E986  3905fe                            bsr.w   sub_FFF2E78B
FFF2E989  ef16                              mov.l   r1, r6
FFF2E98B  8b81                              mov.b   20h+var_12[sp], r1
FFF2E98D  39fefd                            bsr.w   sub_FFF2E78B
FFF2E990  4316                              sub     r1, r6
FFF2E992  838e                              mov.b   r6, 20h+var_11[sp]
FFF2E994  8b89                              mov.b   20h+var_11[sp], r1
FFF2E996  6101                              cmp     #0, r1
FFF2E998  17                                beq.s   loc_FFF2E99F
FFF2E999  8b89                              mov.b   20h+var_11[sp], r1
FFF2E99B  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2E99D  2e13                              bra.b   loc_FFF2E9B0
FFF2E99F  a881                   loc_FFF2E99F mov.l   20h+var_18[sp], r1
FFF2E9A1  6211                              add     #1, r1
FFF2E9A3  a081                              mov.l   r1, 20h+var_18[sp]
FFF2E9A5  a881                   loc_FFF2E9A5 mov.l   20h+var_18[sp], r1
FFF2E9A7  06850105                          cmp     20h+var_C[sp].l, r1
FFF2E9AB  2393                              bltu.b  loc_FFF2E93E
FFF2E9AD  3e0100                            mov.l   #0, 20h+var_1C[sp]
FFF2E9B0  a809                   loc_FFF2E9B0 mov.l   20h+var_1C[sp], r1
FFF2E9B2  a101                              mov.l   r1, 20h+var_10[sp]
FFF2E9B4  3f6609                            rtsd    #24h, r6-r6
FFF2E9B7  7100f0                 sub_FFF2E9B7 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2E9B7
FFF2E9BA  a089                              mov.l   r1, 10h+var_4[sp]
FFF2E9BC  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E9BE  a809                   loc_FFF2E9BE mov.l   10h+var_C[sp], r1
FFF2E9C0  5811                              movu.b  [r1], r1
FFF2E9C2  0517f2ff                          bsr.a   sub_FFF2DBD9
FFF2E9C6  6101                              cmp     #0, r1
FFF2E9C8  a809                              mov.l   10h+var_C[sp], r1
FFF2E9CA  17                                beq.s   loc_FFF2E9D1
FFF2E9CB  6211                              add     #1, r1
FFF2E9CD  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E9CF  2e27                              bra.b   loc_FFF2E9F6
FFF2E9D1  581e                   loc_FFF2E9D1 movu.b  [r1], r14
FFF2E9D3  755e41                            cmp     #41h, r14 ; 'A'
FFF2E9D6  290f                              blt.b   loc_FFF2E9E5
FFF2E9D8  a809                              mov.l   10h+var_C[sp], r1
FFF2E9DA  581e                              movu.b  [r1], r14
FFF2E9DC  755e5a                            cmp     #5Ah, r14 ; 'Z'
FFF2E9DF  2a06                              bgt.b   loc_FFF2E9E5
FFF2E9E1  f80601                            mov.l   #1, 10h+var_10[sp]
FFF2E9E4  0c                                bra.s   loc_FFF2E9E8
FFF2E9E5  f80600                 loc_FFF2E9E5 mov.l   #0, 10h+var_10[sp]
FFF2E9E8  ec01                   loc_FFF2E9E8 mov.l   10h+var_10[sp], r1
FFF2E9EA  6101                              cmp     #0, r1
FFF2E9EC  12                                beq.s   loc_FFF2E9F6
FFF2E9ED  a809                              mov.l   10h+var_C[sp], r1
FFF2E9EF  581e                              movu.b  [r1], r14
FFF2E9F1  71ee20                            add     #20h, r14, r14 ; ' '
FFF2E9F4  c31e                              mov.b   r14, [r1]
FFF2E9F6  a809                   loc_FFF2E9F6 mov.l   10h+var_C[sp], r1
FFF2E9F8  6211                              add     #1, r1
FFF2E9FA  a009                              mov.l   r1, 10h+var_C[sp]
FFF2E9FC  a809                              mov.l   10h+var_C[sp], r1
FFF2E9FE  581e                              movu.b  [r1], r14
FFF2EA00  610e                              cmp     #0, r14
FFF2EA02  21bc                              bne.b   loc_FFF2E9BE
FFF2EA04  a889                              mov.l   10h+var_4[sp], r1
FFF2EA06  a081                              mov.l   r1, 10h+var_8[sp]
FFF2EA08  6704                              rtsd    #4
FFF2EA0A  7100f0                 sub_FFF2EA0A add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2EA0A
FFF2EA0D  a089                              mov.l   r1, 10h+var_4[sp]
FFF2EA0F  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF2EA12  2e0d                              bra.b   loc_FFF2EA1F
FFF2EA14  63a1                   loc_FFF2EA14 mul     #0Ah, r1
FFF2EA16  06090103                          add     10h+var_D[sp].b, r1
FFF2EA1A  7111d0                            add     #-30h, r1, r1
FFF2EA1D  a009                              mov.l   r1, 10h+var_C[sp]
FFF2EA1F  a889                   loc_FFF2EA1F mov.l   10h+var_4[sp], r1
FFF2EA21  c41003                            mov.b   [r1], 10h+var_D[sp]
FFF2EA24  a889                              mov.l   10h+var_4[sp], r1
FFF2EA26  6211                              add     #1, r1
FFF2EA28  888a                              mov.b   10h+var_D[sp], r2
FFF2EA2A  a089                              mov.l   r1, 10h+var_4[sp]
FFF2EA2C  6102                              cmp     #0, r2
FFF2EA2E  a809                              mov.l   10h+var_C[sp], r1
FFF2EA30  21e4                              bne.b   loc_FFF2EA14
FFF2EA32  a081                              mov.l   r1, 10h+var_8[sp]
FFF2EA34  6704                              rtsd    #4
FFF2EA36  7100e8                 sub_FFF2EA36 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2EA36
FFF2EA39  a109                              mov.l   r1, 18h+var_4[sp]
FFF2EA3B  a102                              mov.l   r2, 18h+var_8[sp]
FFF2EA3D  a08b                              mov.l   r3, 18h+var_C[sp]
FFF2EA3F  a909                              mov.l   18h+var_4[sp], r1
FFF2EA41  ef1e                              mov.l   r1, r14
FFF2EA43  fc273e                            divu    r3, r14
FFF2EA46  4f3e                              mul     r3, r14
FFF2EA48  43e1                              sub     r14, r1
FFF2EA4A  8189                              mov.b   r1, 18h+var_11[sp]
FFF2EA4C  a909                              mov.l   18h+var_4[sp], r1
FFF2EA4E  06a1090103                        divu    18h+var_C[sp].l, r1
FFF2EA53  a109                              mov.l   r1, 18h+var_4[sp]
FFF2EA55  6101                              cmp     #0, r1
FFF2EA57  200d                              beq.b   loc_FFF2EA64
FFF2EA59  a88b                              mov.l   18h+var_C[sp], r3
FFF2EA5B  a902                              mov.l   18h+var_8[sp], r2
FFF2EA5D  a909                              mov.l   18h+var_4[sp], r1
FFF2EA5F  39d7ff                            bsr.w   sub_FFF2EA36
FFF2EA62  a101                              mov.l   r1, 18h+var_8[sp]
FFF2EA64  8989                   loc_FFF2EA64 mov.b   18h+var_11[sp], r1
FFF2EA66  6191                              cmp     #9, r1
FFF2EA68  a902                              mov.l   18h+var_8[sp], r2
FFF2EA6A  2a08                              bgt.b   loc_FFF2EA72
FFF2EA6C  711130                            add     #30h, r1, r1 ; '0'
FFF2EA6F  e301                              mov.l   r1, 18h+var_18[sp]
FFF2EA71  0e                                bra.s   loc_FFF2EA77
FFF2EA72  711157                 loc_FFF2EA72 add     #57h, r1, r1 ; 'W'
FFF2EA75  e301                              mov.l   r1, 18h+var_18[sp]
FFF2EA77  ec01                   loc_FFF2EA77 mov.l   18h+var_18[sp], r1
FFF2EA79  c321                              mov.b   r1, [r2]
FFF2EA7B  a901                              mov.l   18h+var_8[sp], r1
FFF2EA7D  6211                              add     #1, r1
FFF2EA7F  a081                              mov.l   r1, 18h+var_10[sp]
FFF2EA81  6706                              rtsd    #6
FFF2EA83  7100e8                 sub_FFF2EA83 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2EA83
FFF2EA86  a109                              mov.l   r1, 18h+var_4[sp]
FFF2EA88  a102                              mov.l   r2, 18h+var_8[sp]
FFF2EA8A  a08b                              mov.l   r3, 18h+var_C[sp]
FFF2EA8C  6123                              cmp     #2, r3
FFF2EA8E  2909                              blt.b   loc_FFF2EA97
FFF2EA90  a889                              mov.l   18h+var_C[sp], r1
FFF2EA92  755125                            cmp     #25h, r1 ; '%'
FFF2EA95  2906                              blt.b   loc_FFF2EA9B
FFF2EA97  f80601                 loc_FFF2EA97 mov.l   #1, 18h+var_18[sp]
FFF2EA9A  0c                                bra.s   loc_FFF2EA9E
FFF2EA9B  f80600                 loc_FFF2EA9B mov.l   #0, 18h+var_18[sp]
FFF2EA9E  ec01                   loc_FFF2EA9E mov.l   18h+var_18[sp], r1
FFF2EAA0  6101                              cmp     #0, r1
FFF2EAA2  a901                              mov.l   18h+var_8[sp], r1
FFF2EAA4  16                                beq.s   loc_FFF2EAAA
FFF2EAA5  f81400                            mov.b   #0, [r1]
FFF2EAA8  2e3d                              bra.b   loc_FFF2EAE5
FFF2EAAA  a009                   loc_FFF2EAAA mov.l   r1, 18h+var_14[sp]
FFF2EAAC  a889                              mov.l   18h+var_C[sp], r1
FFF2EAAE  61a1                              cmp     #0Ah, r1
FFF2EAB0  210d                              bne.b   loc_FFF2EABD
FFF2EAB2  a909                              mov.l   18h+var_4[sp], r1
FFF2EAB4  69f1                              shlr    #1Fh, r1
FFF2EAB6  6101                              cmp     #0, r1
FFF2EAB8  15                                beq.s   loc_FFF2EABD
FFF2EAB9  f80601                            mov.l   #1, 18h+var_18[sp]
FFF2EABC  0c                                bra.s   loc_FFF2EAC0
FFF2EABD  f80600                 loc_FFF2EABD mov.l   #0, 18h+var_18[sp]
FFF2EAC0  ec01                   loc_FFF2EAC0 mov.l   18h+var_18[sp], r1
FFF2EAC2  6101                              cmp     #0, r1
FFF2EAC4  2015                              beq.b   loc_FFF2EAD9
FFF2EAC6  a809                              mov.l   18h+var_14[sp], r1
FFF2EAC8  f8142d                            mov.b   #2Dh, [r1] ; '-'
FFF2EACB  a809                              mov.l   18h+var_14[sp], r1
FFF2EACD  6211                              add     #1, r1
FFF2EACF  a009                              mov.l   r1, 18h+var_14[sp]
FFF2EAD1  6601                              mov.l   #0, r1
FFF2EAD3  06810105                          sub     18h+var_4[sp].l, r1
FFF2EAD7  a109                              mov.l   r1, 18h+var_4[sp]
FFF2EAD9  a88b                   loc_FFF2EAD9 mov.l   18h+var_C[sp], r3
FFF2EADB  a80a                              mov.l   18h+var_14[sp], r2
FFF2EADD  a909                              mov.l   18h+var_4[sp], r1
FFF2EADF  3957ff                            bsr.w   sub_FFF2EA36
FFF2EAE2  f81400                            mov.b   #0, [r1]
FFF2EAE5  a901                   loc_FFF2EAE5 mov.l   18h+var_8[sp], r1
FFF2EAE7  a081                              mov.l   r1, 18h+var_10[sp]
FFF2EAE9  6706                              rtsd    #6
FFF2EAEB  7ea6                   sub_FFF2EAEB push.l  r6   ; <<<< FUNC sub_FFF2EAEB
FFF2EAED  7100e4                            add     #-1Ch, sp, sp
FFF2EAF0  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2EAF2  a10a                              mov.l   r2, 1Ch+var_8[sp]
FFF2EAF4  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF2EAF7  3e0100                            mov.l   #0, 1Ch+var_18[sp]
FFF2EAFA  2e77                              bra.b   loc_FFF2EB71
FFF2EAFC  8b81                   loc_FFF2EAFC mov.b   1Ch+var_E[sp], r1
FFF2EAFE  6101                              cmp     #0, r1
FFF2EB00  1d                                bne.s   loc_FFF2EB05
FFF2EB01  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF2EB04  0c                                bra.s   loc_FFF2EB08
FFF2EB05  f80600                 loc_FFF2EB05 mov.l   #0, 1Ch+var_1C[sp]
FFF2EB08  ec01                   loc_FFF2EB08 mov.l   1Ch+var_1C[sp], r1
FFF2EB0A  6101                              cmp     #0, r1
FFF2EB0C  3b8500                            bne.w   loc_FFF2EB91
FFF2EB0F  8b89                              mov.b   1Ch+var_D[sp], r1
FFF2EB11  6101                              cmp     #0, r1
FFF2EB13  1f                                bne.s   loc_FFF2EB1A
FFF2EB14  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF2EB18  2e79                              bra.b   loc_FFF2EB91
FFF2EB1A  8b81                   loc_FFF2EB1A mov.b   1Ch+var_E[sp], r1
FFF2EB1C  6101                              cmp     #0, r1
FFF2EB1E  1e                                bne.s   loc_FFF2EB24
FFF2EB1F  3e0101                            mov.l   #1, 1Ch+var_18[sp]
FFF2EB22  2e6f                              bra.b   loc_FFF2EB91
FFF2EB24  a881                   loc_FFF2EB24 mov.l   1Ch+var_14[sp], r1
FFF2EB26  6101                              cmp     #0, r1
FFF2EB28  2013                              beq.b   loc_FFF2EB3B
FFF2EB2A  3e0200                            mov.l   #0, 1Ch+var_14[sp]
FFF2EB2D  8b89                              mov.b   1Ch+var_D[sp], r1
FFF2EB2F  0605010e                          cmp     1Ch+var_E[sp].b, r1
FFF2EB33  203e                              beq.b   loc_FFF2EB71
FFF2EB35  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF2EB39  2e58                              bra.b   loc_FFF2EB91
FFF2EB3B  b381                   loc_FFF2EB3B movu.b  1Ch+var_E[sp], r1
FFF2EB3D  059cf0ff                          bsr.a   sub_FFF2DBD9
FFF2EB41  6101                              cmp     #0, r1
FFF2EB43  2013                              beq.b   loc_FFF2EB56
FFF2EB45  3e0201                            mov.l   #1, 1Ch+var_14[sp]
FFF2EB48  8b89                              mov.b   1Ch+var_D[sp], r1
FFF2EB4A  0605010e                          cmp     1Ch+var_E[sp].b, r1
FFF2EB4E  2023                              beq.b   loc_FFF2EB71
FFF2EB50  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF2EB54  2e3d                              bra.b   loc_FFF2EB91
FFF2EB56  8b89                   loc_FFF2EB56 mov.b   1Ch+var_D[sp], r1
FFF2EB58  3933fc                            bsr.w   sub_FFF2E78B
FFF2EB5B  ef16                              mov.l   r1, r6
FFF2EB5D  8b81                              mov.b   1Ch+var_E[sp], r1
FFF2EB5F  392cfc                            bsr.w   sub_FFF2E78B
FFF2EB62  4316                              sub     r1, r6
FFF2EB64  838e                              mov.b   r6, 1Ch+var_D[sp]
FFF2EB66  8b89                              mov.b   1Ch+var_D[sp], r1
FFF2EB68  6101                              cmp     #0, r1
FFF2EB6A  17                                beq.s   loc_FFF2EB71
FFF2EB6B  8b89                              mov.b   1Ch+var_D[sp], r1
FFF2EB6D  a009                              mov.l   r1, 1Ch+var_18[sp]
FFF2EB6F  2e22                              bra.b   loc_FFF2EB91
FFF2EB71  a981                   loc_FFF2EB71 mov.l   1Ch+var_4[sp], r1
FFF2EB73  c4100f                            mov.b   [r1], 1Ch+var_D[sp]
FFF2EB76  a981                              mov.l   1Ch+var_4[sp], r1
FFF2EB78  6211                              add     #1, r1
FFF2EB7A  a181                              mov.l   r1, 1Ch+var_4[sp]
FFF2EB7C  a909                              mov.l   1Ch+var_8[sp], r1
FFF2EB7E  c4100e                            mov.b   [r1], 1Ch+var_E[sp]
FFF2EB81  a909                              mov.l   1Ch+var_8[sp], r1
FFF2EB83  6211                              add     #1, r1
FFF2EB85  a109                              mov.l   r1, 1Ch+var_8[sp]
FFF2EB87  8b89                              mov.b   1Ch+var_D[sp], r1
FFF2EB89  6101                              cmp     #0, r1
FFF2EB8B  3a71ff                            beq.w   loc_FFF2EAFC
FFF2EB8E  3877ff                            bra.w   loc_FFF2EB05
FFF2EB91  a809                   loc_FFF2EB91 mov.l   1Ch+var_18[sp], r1
FFF2EB93  a101                              mov.l   r1, 1Ch+var_C[sp]
FFF2EB95  3f6608                            rtsd    #20h, r6-r6
FFF2EB98  7100f0                 sub_FFF2EB98 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2EB98
FFF2EB9B  a089                              mov.l   r1, 10h+var_4[sp]
FFF2EB9D  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF2EBA0  2e0d                              bra.b   loc_FFF2EBAD
FFF2EBA2  63a1                   loc_FFF2EBA2 mul     #0Ah, r1
FFF2EBA4  06090103                          add     10h+var_D[sp].b, r1
FFF2EBA8  7111d0                            add     #-30h, r1, r1
FFF2EBAB  a009                              mov.l   r1, 10h+var_C[sp]
FFF2EBAD  a889                   loc_FFF2EBAD mov.l   10h+var_4[sp], r1
FFF2EBAF  c41003                            mov.b   [r1], 10h+var_D[sp]
FFF2EBB2  a889                              mov.l   10h+var_4[sp], r1
FFF2EBB4  6211                              add     #1, r1
FFF2EBB6  888a                              mov.b   10h+var_D[sp], r2
FFF2EBB8  a089                              mov.l   r1, 10h+var_4[sp]
FFF2EBBA  6102                              cmp     #0, r2
FFF2EBBC  a809                              mov.l   10h+var_C[sp], r1
FFF2EBBE  21e4                              bne.b   loc_FFF2EBA2
FFF2EBC0  a081                              mov.l   r1, 10h+var_8[sp]
FFF2EBC2  6704                              rtsd    #4
FFF2EBC4  7100e8                 sub_FFF2EBC4 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF2EBC4
FFF2EBC7  a109                              mov.l   r1, 18h+var_4[sp]
FFF2EBC9  a102                              mov.l   r2, 18h+var_8[sp]
FFF2EBCB  a08b                              mov.l   r3, 18h+var_C[sp]
FFF2EBCD  6123                              cmp     #2, r3
FFF2EBCF  2909                              blt.b   loc_FFF2EBD8
FFF2EBD1  a889                              mov.l   18h+var_C[sp], r1
FFF2EBD3  755125                            cmp     #25h, r1 ; '%'
FFF2EBD6  2906                              blt.b   loc_FFF2EBDC
FFF2EBD8  f80601                 loc_FFF2EBD8 mov.l   #1, 18h+var_18[sp]
FFF2EBDB  0c                                bra.s   loc_FFF2EBDF
FFF2EBDC  f80600                 loc_FFF2EBDC mov.l   #0, 18h+var_18[sp]
FFF2EBDF  ec01                   loc_FFF2EBDF mov.l   18h+var_18[sp], r1
FFF2EBE1  6101                              cmp     #0, r1
FFF2EBE3  a901                              mov.l   18h+var_8[sp], r1
FFF2EBE5  16                                beq.s   loc_FFF2EBEB
FFF2EBE6  f81400                            mov.b   #0, [r1]
FFF2EBE9  2e3d                              bra.b   loc_FFF2EC26
FFF2EBEB  a009                   loc_FFF2EBEB mov.l   r1, 18h+var_14[sp]
FFF2EBED  a889                              mov.l   18h+var_C[sp], r1
FFF2EBEF  61a1                              cmp     #0Ah, r1
FFF2EBF1  210d                              bne.b   loc_FFF2EBFE
FFF2EBF3  a909                              mov.l   18h+var_4[sp], r1
FFF2EBF5  69f1                              shlr    #1Fh, r1
FFF2EBF7  6101                              cmp     #0, r1
FFF2EBF9  15                                beq.s   loc_FFF2EBFE
FFF2EBFA  f80601                            mov.l   #1, 18h+var_18[sp]
FFF2EBFD  0c                                bra.s   loc_FFF2EC01
FFF2EBFE  f80600                 loc_FFF2EBFE mov.l   #0, 18h+var_18[sp]
FFF2EC01  ec01                   loc_FFF2EC01 mov.l   18h+var_18[sp], r1
FFF2EC03  6101                              cmp     #0, r1
FFF2EC05  2015                              beq.b   loc_FFF2EC1A
FFF2EC07  a809                              mov.l   18h+var_14[sp], r1
FFF2EC09  f8142d                            mov.b   #2Dh, [r1] ; '-'
FFF2EC0C  a809                              mov.l   18h+var_14[sp], r1
FFF2EC0E  6211                              add     #1, r1
FFF2EC10  a009                              mov.l   r1, 18h+var_14[sp]
FFF2EC12  6601                              mov.l   #0, r1
FFF2EC14  06810105                          sub     18h+var_4[sp].l, r1
FFF2EC18  a109                              mov.l   r1, 18h+var_4[sp]
FFF2EC1A  a88b                   loc_FFF2EC1A mov.l   18h+var_C[sp], r3
FFF2EC1C  a80a                              mov.l   18h+var_14[sp], r2
FFF2EC1E  a909                              mov.l   18h+var_4[sp], r1
FFF2EC20  3916fe                            bsr.w   sub_FFF2EA36
FFF2EC23  f81400                            mov.b   #0, [r1]
FFF2EC26  a901                   loc_FFF2EC26 mov.l   18h+var_8[sp], r1
FFF2EC28  a081                              mov.l   r1, 18h+var_10[sp]
FFF2EC2A  6706                              rtsd    #6
FFF2EC2C  6040                   sub_FFF2EC2C sub     #4, sp   ; <<<< FUNC sub_FFF2EC2C
FFF2EC2E  9009                              mov.w   r1, 4+var_2[sp]
FFF2EC30  6881                              shlr    #8, r1
FFF2EC32  c301                              mov.b   r1, 4+var_4[sp]
FFF2EC34  cc01                              mov.b   4+var_4[sp], r1
FFF2EC36  06090102                          add     4+var_2[sp].b, r1
FFF2EC3A  c301                              mov.b   r1, 4+var_4[sp]
FFF2EC3C  c40001                            mov.b   4+var_4[sp], 4+var_3[sp]
FFF2EC3F  b009                              movu.b  4+var_3[sp], r1
FFF2EC41  cf11                              mov.b   r1, r1
FFF2EC43  6701                              rtsd    #1
FFF2EC45  7100f0                 sub_FFF2EC45 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2EC45
FFF2EC48  a089                              mov.l   r1, 10h+var_4[sp]
FFF2EC4A  a082                              mov.l   r2, 10h+var_8[sp]
FFF2EC4C  e5000301                          mov.l   10h+var_4[sp], 10h+var_C[sp]
FFF2EC50  a881                   loc_FFF2EC50 mov.l   10h+var_8[sp], r1
FFF2EC52  d41001                            mov.w   [r1], 10h+var_E[sp]
FFF2EC55  b081                              movu.b  10h+var_E[sp], r1
FFF2EC57  a80a                              mov.l   10h+var_C[sp], r2
FFF2EC59  c321                              mov.b   r1, [r2]
FFF2EC5B  a809                              mov.l   10h+var_C[sp], r1
FFF2EC5D  6211                              add     #1, r1
FFF2EC5F  a009                              mov.l   r1, 10h+var_C[sp]
FFF2EC61  b809                              movu.w  10h+var_E[sp], r1
FFF2EC63  6881                              shlr    #8, r1
FFF2EC65  9009                              mov.w   r1, 10h+var_E[sp]
FFF2EC67  b081                              movu.b  10h+var_E[sp], r1
FFF2EC69  a80a                              mov.l   10h+var_C[sp], r2
FFF2EC6B  c321                              mov.b   r1, [r2]
FFF2EC6D  a809                              mov.l   10h+var_C[sp], r1
FFF2EC6F  6211                              add     #1, r1
FFF2EC71  a009                              mov.l   r1, 10h+var_C[sp]
FFF2EC73  a881                              mov.l   10h+var_8[sp], r1
FFF2EC75  5c1e                              movu.w  [r1], r14
FFF2EC77  6221                              add     #2, r1
FFF2EC79  a081                              mov.l   r1, 10h+var_8[sp]
FFF2EC7B  610e                              cmp     #0, r14
FFF2EC7D  21d3                              bne.b   loc_FFF2EC50
FFF2EC7F  6704                              rtsd    #4
FFF2EC81  60c0                   sub_FFF2EC81 sub     #0Ch, sp   ; <<<< FUNC sub_FFF2EC81
FFF2EC83  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF2EC85  908a                              mov.w   r2, 0Ch+var_6[sp]
FFF2EC87  e10002                            mov.l   0Ch+var_4[sp], 0Ch+var_C[sp]
FFF2EC8A  b181                              movu.b  0Ch+var_6[sp], r1
FFF2EC8C  ec02                              mov.l   0Ch+var_C[sp], r2
FFF2EC8E  c321                              mov.b   r1, [r2]
FFF2EC90  ec01                              mov.l   0Ch+var_C[sp], r1
FFF2EC92  6211                              add     #1, r1
FFF2EC94  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF2EC96  b889                              movu.w  0Ch+var_6[sp], r1
FFF2EC98  6881                              shlr    #8, r1
FFF2EC9A  9089                              mov.w   r1, 0Ch+var_6[sp]
FFF2EC9C  b181                              movu.b  0Ch+var_6[sp], r1
FFF2EC9E  ec02                              mov.l   0Ch+var_C[sp], r2
FFF2ECA0  c321                              mov.b   r1, [r2]
FFF2ECA2  6703                              rtsd    #3
FFF2ECA4  7100f0                 sub_FFF2ECA4 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2ECA4
FFF2ECA7  a089                              mov.l   r1, 10h+var_4[sp]
FFF2ECA9  6211                              add     #1, r1
FFF2ECAB  a009                              mov.l   r1, 10h+var_C[sp]
FFF2ECAD  a809                              mov.l   10h+var_C[sp], r1
FFF2ECAF  5811                              movu.b  [r1], r1
FFF2ECB1  9009                              mov.w   r1, 10h+var_E[sp]
FFF2ECB3  a809                              mov.l   10h+var_C[sp], r1
FFF2ECB5  6011                              sub     #1, r1
FFF2ECB7  a009                              mov.l   r1, 10h+var_C[sp]
FFF2ECB9  9809                              mov.w   10h+var_E[sp], r1
FFF2ECBB  6c81                              shll    #8, r1
FFF2ECBD  9009                              mov.w   r1, 10h+var_E[sp]
FFF2ECBF  a809                              mov.l   10h+var_C[sp], r1
FFF2ECC1  5811                              movu.b  [r1], r1
FFF2ECC3  06550101                          or      10h+var_E[sp].w, r1
FFF2ECC7  9009                              mov.w   r1, 10h+var_E[sp]
FFF2ECC9  d5000105                          mov.w   10h+var_E[sp], 10h+var_6[sp]
FFF2ECCD  9909                              mov.w   10h+var_6[sp], r1
FFF2ECCF  5f11                              movu.w  r1, r1
FFF2ECD1  6704                              rtsd    #4
FFF2ECD3  60c0                   sub_FFF2ECD3 sub     #0Ch, sp   ; <<<< FUNC sub_FFF2ECD3
FFF2ECD5  a081                              mov.l   r1, 0Ch+var_4[sp]
FFF2ECD7  a00a                              mov.l   r2, 0Ch+var_8[sp]
FFF2ECD9  e10002                            mov.l   0Ch+var_4[sp], 0Ch+var_C[sp]
FFF2ECDC  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ECDE  ec02                              mov.l   0Ch+var_C[sp], r2
FFF2ECE0  c321                              mov.b   r1, [r2]
FFF2ECE2  ec01                              mov.l   0Ch+var_C[sp], r1
FFF2ECE4  6211                              add     #1, r1
FFF2ECE6  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF2ECE8  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ECEA  6881                              shlr    #8, r1
FFF2ECEC  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2ECEE  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ECF0  ec02                              mov.l   0Ch+var_C[sp], r2
FFF2ECF2  c321                              mov.b   r1, [r2]
FFF2ECF4  ec01                              mov.l   0Ch+var_C[sp], r1
FFF2ECF6  6211                              add     #1, r1
FFF2ECF8  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF2ECFA  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ECFC  6881                              shlr    #8, r1
FFF2ECFE  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2ED00  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ED02  ec02                              mov.l   0Ch+var_C[sp], r2
FFF2ED04  c321                              mov.b   r1, [r2]
FFF2ED06  ec01                              mov.l   0Ch+var_C[sp], r1
FFF2ED08  6211                              add     #1, r1
FFF2ED0A  e301                              mov.l   r1, 0Ch+var_C[sp]
FFF2ED0C  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ED0E  6881                              shlr    #8, r1
FFF2ED10  a009                              mov.l   r1, 0Ch+var_8[sp]
FFF2ED12  a809                              mov.l   0Ch+var_8[sp], r1
FFF2ED14  ec02                              mov.l   0Ch+var_C[sp], r2
FFF2ED16  c321                              mov.b   r1, [r2]
FFF2ED18  6703                              rtsd    #3
FFF2ED1A  7100f0                 sub_FFF2ED1A add     #-10h, sp, sp   ; <<<< FUNC sub_FFF2ED1A
FFF2ED1D  a089                              mov.l   r1, 10h+var_4[sp]
FFF2ED1F  6231                              add     #3, r1
FFF2ED21  a009                              mov.l   r1, 10h+var_C[sp]
FFF2ED23  a809                              mov.l   10h+var_C[sp], r1
FFF2ED25  5811                              movu.b  [r1], r1
FFF2ED27  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED29  a809                              mov.l   10h+var_C[sp], r1
FFF2ED2B  6011                              sub     #1, r1
FFF2ED2D  a009                              mov.l   r1, 10h+var_C[sp]
FFF2ED2F  ec01                              mov.l   10h+var_10[sp], r1
FFF2ED31  6c81                              shll    #8, r1
FFF2ED33  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED35  a809                              mov.l   10h+var_C[sp], r1
FFF2ED37  5811                              movu.b  [r1], r1
FFF2ED39  069401                            or      [sp].l, r1
FFF2ED3C  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED3E  a809                              mov.l   10h+var_C[sp], r1
FFF2ED40  6011                              sub     #1, r1
FFF2ED42  a009                              mov.l   r1, 10h+var_C[sp]
FFF2ED44  ec01                              mov.l   10h+var_10[sp], r1
FFF2ED46  6c81                              shll    #8, r1
FFF2ED48  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED4A  a809                              mov.l   10h+var_C[sp], r1
FFF2ED4C  5811                              movu.b  [r1], r1
FFF2ED4E  069401                            or      [sp].l, r1
FFF2ED51  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED53  a809                              mov.l   10h+var_C[sp], r1
FFF2ED55  6011                              sub     #1, r1
FFF2ED57  a009                              mov.l   r1, 10h+var_C[sp]
FFF2ED59  ec01                              mov.l   10h+var_10[sp], r1
FFF2ED5B  6c81                              shll    #8, r1
FFF2ED5D  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED5F  a809                              mov.l   10h+var_C[sp], r1
FFF2ED61  5811                              movu.b  [r1], r1
FFF2ED63  069401                            or      [sp].l, r1
FFF2ED66  e301                              mov.l   r1, 10h+var_10[sp]
FFF2ED68  ec01                              mov.l   10h+var_10[sp], r1
FFF2ED6A  a081                              mov.l   r1, 10h+var_8[sp]
FFF2ED6C  6704                              rtsd    #4
FFF2ED6E  7100e0                 sub_FFF2ED6E add     #-20h, sp, sp   ; <<<< FUNC sub_FFF2ED6E
FFF2ED71  a189                              mov.l   r1, 20h+var_4[sp]
FFF2ED73  a182                              mov.l   r2, 20h+var_8[sp]
FFF2ED75  a10b                              mov.l   r3, 20h+var_C[sp]
FFF2ED77  a104                              mov.l   r4, 20h+var_10[sp]
FFF2ED79  051d71fe                          bsr.a   sub_FFF15E96
FFF2ED7D  a009                              mov.l   r1, 20h+var_1C[sp]
FFF2ED7F  a809                              mov.l   20h+var_1C[sp], r1
FFF2ED81  6101                              cmp     #0, r1
FFF2ED83  210f                              bne.b   loc_FFF2ED92
FFF2ED85  6602                              mov.l   #0, r2
FFF2ED87  fb16e1                            mov.l   #-1Fh, r1
FFF2ED8A  059600ff                          bsr.a   sub_FFF1EE20
FFF2ED8E  e301                              mov.l   r1, 20h+var_20[sp]
FFF2ED90  2e20                              bra.b   loc_FFF2EDB0
FFF2ED92  a80d                   loc_FFF2ED92 mov.l   20h+var_1C[sp], r5
FFF2ED94  a904                              mov.l   20h+var_10[sp], r4
FFF2ED96  a90b                              mov.l   20h+var_C[sp], r3
FFF2ED98  a982                              mov.l   20h+var_8[sp], r2
FFF2ED9A  a989                              mov.l   20h+var_4[sp], r1
FFF2ED9C  6040                              sub     #4, sp
FFF2ED9E  e305                              mov.l   r5, 24h+var_24[sp]
FFF2EDA0  391600                            bsr.w   sub_FFF2EDB6
FFF2EDA3  6240                              add     #4, sp
FFF2EDA5  a081                              mov.l   r1, 20h+var_18[sp]
FFF2EDA7  a809                              mov.l   20h+var_1C[sp], r1
FFF2EDA9  05fd70fe                          bsr.a   sub_FFF15EA6
FFF2EDAD  e10002                            mov.l   20h+var_18[sp], 20h+var_20[sp]
FFF2EDB0  ec01                   loc_FFF2EDB0 mov.l   20h+var_20[sp], r1
FFF2EDB2  a089                              mov.l   r1, 20h+var_14[sp]
FFF2EDB4  6708                              rtsd    #8
FFF2EDB6  6e67                   sub_FFF2EDB6 pushm   r6-r7   ; <<<< FUNC sub_FFF2EDB6
FFF2EDB8  7100d4                            add     #-2Ch, sp, sp
FFF2EDBB  a281                              mov.l   r1, 2Ch+var_4[sp]
FFF2EDBD  a20a                              mov.l   r2, 2Ch+var_8[sp]
FFF2EDBF  a203                              mov.l   r3, 2Ch+var_C[sp]
FFF2EDC1  a18c                              mov.l   r4, 2Ch+var_10[sp]
FFF2EDC3  e5000e06                          mov.l   2Ch+arg_0[sp], 2Ch+var_14[sp]
FFF2EDC7  fbe22c5e0600                      mov.l   #65E2Ch, r14
FFF2EDCD  e4e003                            mov.l   [r14], 2Ch+var_20[sp]
FFF2EDD0  051b62ff                          bsr.a   sub_FFF24FEB
FFF2EDD4  a101                              mov.l   r1, 2Ch+var_1C[sp]
FFF2EDD6  a901                              mov.l   2Ch+var_1C[sp], r1
FFF2EDD8  6101                              cmp     #0, r1
FFF2EDDA  200f                              beq.b   loc_FFF2EDE9
FFF2EDDC  a901                              mov.l   2Ch+var_1C[sp], r1
FFF2EDDE  6602                              mov.l   #0, r2
FFF2EDE0  054000ff                          bsr.a   sub_FFF1EE20
FFF2EDE4  a009                              mov.l   r1, 2Ch+var_28[sp]
FFF2EDE6  386e01                            bra.w   loc_FFF2EF54
FFF2EDE9  aa81                   loc_FFF2EDE9 mov.l   2Ch+var_4[sp], r1
FFF2EDEB  6101                              cmp     #0, r1
FFF2EDED  16                                beq.s   loc_FFF2EDF3
FFF2EDEE  aa09                              mov.l   2Ch+var_8[sp], r1
FFF2EDF0  6101                              cmp     #0, r1
FFF2EDF2  1d                                bne.s   loc_FFF2EDF7
FFF2EDF3  f80601                 loc_FFF2EDF3 mov.l   #1, 2Ch+var_2C[sp]
FFF2EDF6  0c                                bra.s   loc_FFF2EDFA
FFF2EDF7  f80600                 loc_FFF2EDF7 mov.l   #0, 2Ch+var_2C[sp]
FFF2EDFA  ec01                   loc_FFF2EDFA mov.l   2Ch+var_2C[sp], r1
FFF2EDFC  6101                              cmp     #0, r1
FFF2EDFE  2010                              beq.b   loc_FFF2EE0E
