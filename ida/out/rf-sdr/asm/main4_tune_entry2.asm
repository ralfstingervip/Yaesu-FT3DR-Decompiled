; ==== tune_entry2  000377C2-00037A30 ====
000377C2  6a10fba57370             sub_377C2 btst    #7, @0xFFFFFBA5:16  ; <<< FUNC sub_377C2
000377C8  470c                              beq     loc_377D6:8
000377CA  6a18fba57270                      bclr    #7, @0xFFFFFBA5:16
000377D0  6a18fba57060                      bset    #6, @0xFFFFFBA5:16
000377D6  5534                     loc_377D6 bsr     sub_3780C:8
000377D8  6e0c0095                          mov.b   @(0x95:16,er0), r4l
000377DC  4626                              bne     loc_37804:8
000377DE  fcff                              mov.b   #0xFF, r4l
000377E0  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
000377E4  6a0c9530                          mov.b   @0xFFFF9530:16, r4l
000377E8  4608                              bne     loc_377F2:8
000377EA  5e037b2a                          jsr     sub_37B2A:24
000377EE  5e037b46                          jsr     sub_37B46:24
000377F2  5e037b66                 loc_377F2 jsr     sub_37B66:24
000377F6  fcf3                              mov.b   #0xF3, r4l
000377F8  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
000377FC  fc00                              mov.b   #0, r4l
000377FE  6e8c0094                          mov.b   r4l, @(0x94:16,er0)
00037802  4006                              bra     locret_3780A:8
00037804  fc00                     loc_37804 mov.b   #0, r4l
00037806  6e8c0095                          mov.b   r4l, @(0x95:16,er0)
0003780A  5470                     locret_3780A rts
0003780C  6a18aadf7200             sub_3780C bclr    #0, @0xFFFFAADF:16  ; <<< FUNC sub_3780C
00037812  6a10aadf7700             sub_37812 bld     #0, @0xFFFFAADF:16  ; <<< FUNC sub_37812
00037818  6a18817367e0                      bist    #6, @0xFFFF8173:16
0003781E  5e037a1e                          jsr     sub_37A1E:24
00037822  6a10aadf7300                      btst    #0, @0xFFFFAADF:16
00037828  470a                              beq     loc_37834:8
0003782A  6a0c8068                          mov.b   @0xFFFF8068:16, r4l
0003782E  6a8ca9a9                          mov.b   r4l, @0xFFFFA9A9:16
00037832  4008                              bra     loc_3783C:8
00037834  6a0c8056                 loc_37834 mov.b   @0xFFFF8056:16, r4l
00037838  6a8ca9a9                          mov.b   r4l, @0xFFFFA9A9:16
0003783C  5e0034e0                 loc_3783C jsr     sub_34E0:24
00037840  5470                              rts
00037842  6e0c008d                 loc_37842 mov.b   @(0x8D:16,er0), r4l
00037846  ac05                              cmp.b   #5, r4l
00037848  4634                              bne     loc_3787E:8
0003784A  01006df6                          push.l  er6
0003784E  01006f040042                      mov.l   @(0x42:16,er0), er4
00037854  5e01dec6                          jsr     sub_1DEC6:24
00037858  4706                              beq     unk_37860:8
0003785A  7a0600000000                      mov.l   #0, er6
00037860  78                       unk_37860 .byte 0x78 ; x
00037861  e06b                              and.b   #0x6B, r0h
00037863  2600                              mov.b   @0xFFFFFF00:8, r6h
00037865  01                                .byte    1
00037866  deea                              xor.b   #0xEA, r6l
00037868  01006f040042                      mov.l   @(0x42:16,er0), er4
0003786E  7a64ffff0000                      and.l   #0xFFFF0000, er4
00037874  01f06464                          or.l    er6, er4
00037878  01006d76                          pop.l   er6
0003787C  4006                              bra     loc_37884:8
0003787E  01006f040042             loc_3787E mov.l   @(0x42:16,er0), er4
00037884  7a0500ffaa4a             loc_37884 mov.l   #0xFFAA4A, er5
0003788A  010069d4                          mov.l   er4, @er5
0003788E  6e0c008f                          mov.b   @(0x8F:16,er0), r4l
00037892  734c                              btst    #4, r4l
00037894  4606                              bne     loc_3789C:8
00037896  5e03f94c                          jsr     sub_3F94C:24
0003789A  4004                              bra     locret_378A0:8
0003789C  5e03f924                 loc_3789C jsr     sub_3F924:24
000378A0  5470                     locret_378A0 rts
000378A2  6a10fba57370             sub_378A2 btst    #7, @0xFFFFFBA5:16  ; <<< FUNC sub_378A2
000378A8  586000a8                          bne     loc_37954:16
000378AC  6a18fba57070                      bset    #7, @0xFFFFFBA5:16
000378B2  6a108ea07360                      btst    #6, @0xFFFF8EA0:16
000378B8  4706                              beq     loc_378C0:8
000378BA  6a0c8dd5                          mov.b   @0xFFFF8DD5:16, r4l
000378BE  4004                              bra     loc_378C4:8
000378C0  6a0c8d20                 loc_378C0 mov.b   @0xFFFF8D20:16, r4l
000378C4  4720                     loc_378C4 beq     loc_378E6:8
000378C6  ac01                              cmp.b   #1, r4l
000378C8  4716                              beq     loc_378E0:8
000378CA  6a108ea07360                      btst    #6, @0xFFFF8EA0:16
000378D0  4706                              beq     loc_378D8:8
000378D2  6a0c8ec5                          mov.b   @0xFFFF8EC5:16, r4l
000378D6  4004                              bra     loc_378DC:8
000378D8  6a0c8eb6                 loc_378D8 mov.b   @0xFFFF8EB6:16, r4l
000378DC  ac04                     loc_378DC cmp.b   #4, r4l
000378DE  4404                              bcc     loc_378E4:8
000378E0  fc01                     loc_378E0 mov.b   #1, r4l
000378E2  4002                              bra     loc_378E6:8
000378E4  fc00                     loc_378E4 mov.b   #0, r4l
000378E6  4624                     loc_378E6 bne     loc_3790C:8
000378E8  6a0c8aa0                          mov.b   @0xFFFF8AA0:16, r4l
000378EC  4710                              beq     loc_378FE:8
000378EE  6a10aad37320                      btst    #2, @0xFFFFAAD3:16
000378F4  4616                              bne     loc_3790C:8
000378F6  6a10aad37300                      btst    #0, @0xFFFFAAD3:16
000378FC  460e                              bne     loc_3790C:8
000378FE  6a0c89bb                 loc_378FE mov.b   @0xFFFF89BB:16, r4l
00037902  4608                              bne     loc_3790C:8
00037904  6a18fba57260                      bclr    #6, @0xFFFFFBA5:16
0003790A  4006                              bra     loc_37912:8
0003790C  6a18fba57060             loc_3790C bset    #6, @0xFFFFFBA5:16
00037912  6a1881727200             loc_37912 bclr    #0, @0xFFFF8172:16
00037918  5e037a1e                          jsr     sub_37A1E:24
0003791C  5e037be8                          jsr     sub_37BE8:24
00037920  6a0c94fe                          mov.b   @0xFFFF94FE:16, r4l
00037924  470c                              beq     loc_37932:8
00037926  1a0c                              dec.b   r4l
00037928  770c                              bld     #0, r4l
0003792A  6a18aadf6700                      bst     #0, @0xFFFFAADF:16
00037930  401e                              bra     loc_37950:8
00037932  6a18aadf7200             loc_37932 bclr    #0, @0xFFFFAADF:16
00037938  01006b05aa4a                      mov.l   @0xFFFFAA4A:16, er5
0003793E  7a0600037988                      mov.l   #unk_37988, er6
00037944  5e03f5b2                          jsr     sub_3F5B2:24
00037948  4606                              bne     loc_37950:8
0003794A  6a18aadf7000                      bset    #0, @0xFFFFAADF:16
00037950  5e037812                 loc_37950 jsr     sub_37812:24
00037954  6e0c0095                 loc_37954 mov.b   @(0x95:16,er0), r4l
00037958  4626                              bne     loc_37980:8
0003795A  fcff                              mov.b   #0xFF, r4l
0003795C  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
00037960  6a0c9530                          mov.b   @0xFFFF9530:16, r4l
00037964  4608                              bne     loc_3796E:8
00037966  5e037b2a                          jsr     sub_37B2A:24
0003796A  5e037b46                          jsr     sub_37B46:24
0003796E  5e037b66                 loc_3796E jsr     sub_37B66:24
00037972  fcf3                              mov.b   #0xF3, r4l
00037974  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
00037978  fc00                              mov.b   #0, r4l
0003797A  6e8c0094                          mov.b   r4l, @(0x94:16,er0)
0003797E  4006                     loc_3797E bra     locret_37986:8
00037980  fc00                     loc_37980 mov.b   #0, r4l
00037982  6e8c0095                          mov.b   r4l, @(0x95:16,er0)
00037986  5470                     locret_37986 rts
00037988  00                       unk_37988 .byte    0
00037989  0800                              add.b   r0h, r0h
0003798B  1114                              shlr.w  r4
0003798D  0500                     loc_3798D xorc    #0, ccr
0003798F  00                                .byte    0
00037990  1407                              or.b    r0h, r7h
00037992  0000                              nop
00037994  1413                              or.b    r1h, r3h
00037996  5000                              mulxu.b r0h, r0
00037998  1415                              or.b    r1h, r5h
0003799A  5000                              mulxu.b r0h, r0
0003799C  1430                              or.b    r3h, r0h
0003799E  8000                     loc_3799E add.b   #0, r0h
000379A0  1433                              or.b    r3h, r3h
000379A2  0000                              nop
000379A4  1438                              or.b    r3h, r0l
000379A6  5000                              mulxu.b r0h, r0
000379A8  1441                              or.b    r4h, r1h
000379AA  5000                              mulxu.b r0h, r0
000379AC  1447                              or.b    r4h, r7h
000379AE  0000                              nop
000379B0  1448                              or.b    r4h, r0l
000379B2  4000                              bra     loc_379B4:8
000379B4  1456                     loc_379B4 or.b    r5h, r6h
000379B6  5000                              mulxu.b r0h, r0
000379B8  1458                              or.b    r5h, r0l
000379BA  5000                              mulxu.b r0h, r0
000379BC  1464                              or.b    r6h, r4h
000379BE  0000                              nop
000379C0  1467                              or.b    r6h, r7h
000379C2  0000                              nop
000379C4  1472                              or.b    r7h, r2h
000379C6  5000                              mulxu.b r0h, r0
000379C8  1475                              or.b    r7h, r5h
000379CA  5000                              mulxu.b r0h, r0
000379CC  1481                              or.b    r0l, r1h
000379CE  8000                              add.b   #0, r0h
000379D0  1483                              or.b    r0l, r3h
000379D2  5000                              mulxu.b r0h, r0
000379D4  1583                              xor.b   r0l, r3h
000379D6  0000                              nop
000379D8  1584                              xor.b   r0l, r4h
000379DA  5000                              mulxu.b r0h, r0
000379DC  1625                              and.b   r2h, r5h
000379DE  5000                              mulxu.b r0h, r0
000379E0  1627                              and.b   r2h, r7h
000379E2  0000                              nop
000379E4  1715                              not.w   r5
000379E6  0000                              nop
000379E8  17                                .byte 0x17
000379E9  4000                              bra     unk_379EB:8
000379EB  00                       unk_379EB .byte    0
000379EC  4314                              bls     loc_37A02:8
000379EE  0000                              nop
000379F0  4326                              bls     loc_37A18:8
000379F2  0000                              nop
000379F4  4389                              bls     loc_3797E:8
000379F6  0000                              nop
000379F8  4395                              bls     loc_3798D+1:8
000379FA  0000                              nop
000379FC  4458                              bcc     sub_37A56:8
000379FE  0000                              nop
00037A00  4471                              bcc     loc_37A72:8
00037A02  0000                     loc_37A02 nop
00037A04  4534                              bcs     sub_37A3A:8
00037A06  0000                              nop
00037A08  4538                              bcs     loc_37A42:8
00037A0A  0000                              nop
00037A0C  4590                              bcs     loc_3799E:8
00037A0E  0000                              nop
00037A10  4626                              bne     loc_37A38:8
00037A12  0000                              nop
00037A14  790d0040                 loc_37A14 mov.w   #0x40, e5 ; '@'
00037A18  6b8d8172                 loc_37A18 mov.w   e5, @0xFFFF8172:16
00037A1C  400a                              bra     loc_37A28:8
00037A1E  01006b058172             sub_37A1E mov.l   @0xFFFF8172:16, er5  ; <<< FUNC sub_37A1E
00037A24  1dd5                              cmp.w   e5, r5
00037A26  477e                              beq     locret_37AA6:8
00037A28  fc03                     loc_37A28 mov.b   #3, r4l
00037A2A  6b8d8174                          mov.w   e5, @0xFFFF8174:16
00037A2E  403e                              bra     loc_37A6E:8
