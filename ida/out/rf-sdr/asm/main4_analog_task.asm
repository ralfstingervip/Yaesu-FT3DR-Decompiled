; ==== analog_task  000030A2-00003300 ====
000030A2  6a18817e7000             loc_30A2 bset    #0, @0xFFFF817E:16
000030A8  01006b008126                      mov.l   @0xFFFF8126:16, er0
000030AE  01006b80812a                      mov.l   er0, @0xFFFF812A:16
000030B4  5e02d8cc                          jsr     loc_2D8CC:24
000030B8  5e056272                          jsr     sub_56272:24
000030BC  6a108ea07370                      btst    #7, @0xFFFF8EA0:16
000030C2  460a                              bne     loc_30CE:8
000030C4  6a18bc0b7070                      bset    #7, @0xFFFFBC0B:16
000030CA  5e06802a                          jsr     sub_6802A:24
000030CE  5e02efbe                 loc_30CE jsr     loc_2EFBE:24
000030D2  5e030ce6                          jsr     loc_30CE6:24
000030D6  5e03e192                          jsr     sub_3E192:24
000030DA  5e010760                          jsr     sub_10760:24
000030DE  5470                              rts
000030E0  6a1089c27300             loc_30E0 btst    #0, @0xFFFF89C2:16
000030E6  58700096                          beq     locret_3180:16
000030EA  6a0c816f                          mov.b   @0xFFFF816F:16, r4l
000030EE  5860008e                          bne     locret_3180:16
000030F2  fe04                              mov.b   #4, r6l
000030F4  7a0500ff896c                      mov.l   #0xFF896C, er5
000030FA  5e016a4c                          jsr     sub_16A4C:24
000030FE  58b0007e                          bmi     locret_3180:16
00003102  fc02                              mov.b   #2, r4l
00003104  6a8cad68                          mov.b   r4l, @0xFFFFAD68:16
00003108  7a04ffffffff                      mov.l   #0xFFFFFFFF, er4
0000310E  01006b84ad8a                      mov.l   er4, @0xFFFFAD8A:16
00003114  5e003576                 loc_3114 jsr     sub_3576:24
00003118  6a0c9561                          mov.b   @0xFFFF9561:16, r4l
0000311C  46f6                              bne     loc_3114:8
0000311E  5e005634                          jsr     sub_5634:24
00003122  fcff                     loc_3122 mov.b   #0xFF, r4l
00003124  6a8ca9ed                          mov.b   r4l, @0xFFFFA9ED:16
00003128  5e003576                          jsr     sub_3576:24
0000312C  5e00325a                          jsr     sub_325A:24
00003130  5e0032c0                          jsr     sub_32C0:24
00003134  5e04753e                          jsr     loc_4753E:24
00003138  5e00faf6                          jsr     loc_FAF6:24
0000313C  5544                              bsr     sub_3182:8
0000313E  4b08                              bmi     loc_3148:8
00003140  473e                              beq     locret_3180:8
00003142  0480                              orc     #0x80, ccr
00003144  5a0025ac                          jmp     loc_25AC:24
00003148  01006b00812a             loc_3148 mov.l   @0xFFFF812A:16, er0
0000314E  6b04a9bc                          mov.w   @0xFFFFA9BC:16, r4
00003152  79240087                          cmp.w   #0x87, r4
00003156  4506                              bcs     loc_315E:8
00003158  6a10aa357720                      bld     #2, @0xFFFFAA35:16
0000315E  7f526770                 loc_315E bst     #7, @0xFFFFFF52:8
00003162  5e03835e                          jsr     loc_3835E:24
00003166  5e039080                          jsr     loc_39080:24
0000316A  5e03e682                          jsr     sub_3E682:24
0000316E  5e003490                          jsr     sub_3490:24
00003172  5e03e354                          jsr     sub_3E354:24
00003176  5e03e60e                          jsr     sub_3E60E:24
0000317A  5e002d04                          jsr     sub_2D04:24
0000317E  40a2                              bra     loc_3122:8
00003180  5470                     locret_3180 rts
00003182  6a0aa9ed                 sub_3182 mov.b   @0xFFFFA9ED:16, r2l  ; <<< FUNC sub_3182
00003186  4b56                              bmi     loc_31DE:8
00003188  aa0a                              cmp.b   #0xA, r2l
0000318A  4652                              bne     loc_31DE:8
0000318C  5e010be8                          jsr     sub_10BE8:24
00003190  5e02a600                          jsr     sub_2A600:24
00003194  4648                              bne     loc_31DE:8
00003196  fc0b                              mov.b   #0xB, r4l
00003198  6a8caae0                          mov.b   r4l, @0xFFFFAAE0:16
0000319C  6a0cad8d                          mov.b   @0xFFFFAD8D:16, r4l
000031A0  acff                              cmp.b   #0xFF, r4l
000031A2  4736                              beq     loc_31DA:8
000031A4  01006b05896c                      mov.l   @0xFFFF896C:16, er5
000031AA  01006b06ad8a                      mov.l   @0xFFFFAD8A:16, er6
000031B0  1fd6                              cmp.l   er5, er6
000031B2  4622                              bne     loc_31D6:8
000031B4  6a18aa317060                      bset    #6, @0xFFFFAA31:16
000031BA  fcfa                              mov.b   #0xFA, r4l
000031BC  6a8c9537                          mov.b   r4l, @0xFFFF9537:16
000031C0  6a18aae17010                      bset    #1, @0xFFFFAAE1:16
000031C6  6a0ca9ef                          mov.b   @0xFFFFA9EF:16, r4l
000031CA  ac06                              cmp.b   #6, r4l
000031CC  4604                              bne     loc_31D2:8
000031CE  5e010444                          jsr     sub_10444:24
000031D2  fc00                     loc_31D2 mov.b   #0, r4l
000031D4  400a                              bra     locret_31E0:8
000031D6  fc01                     loc_31D6 mov.b   #1, r4l
000031D8  4006                              bra     locret_31E0:8
000031DA  5e005634                 loc_31DA jsr     sub_5634:24
000031DE  fcff                     loc_31DE mov.b   #0xFF, r4l
000031E0  5470                     locret_31E0 rts
000031E2  6a0c8d26                 loc_31E2 mov.b   @0xFFFF8D26:16, r4l
000031E6  acff                              cmp.b   #0xFF, r4l
000031E8  4622                              bne     locret_320C:8
000031EA  6a18aa357050                      bset    #5, @0xFFFFAA35:16
000031F0  6a18b0577070                      bset    #7, @0xFFFFB057:16
000031F6  6a18aa317260                      bclr    #6, @0xFFFFAA31:16
000031FC  fc00                              mov.b   #0, r4l
000031FE  6a8c9537                          mov.b   r4l, @0xFFFF9537:16
00003202  5e010748                          jsr     sub_10748:24
00003206  fce9                              mov.b   #0xE9, r4l
00003208  6e8c0001                          mov.b   r4l, @(1:16,er0)
0000320C  5470                     locret_320C rts
0000320E  6a18aa357050             sub_320E bset    #5, @0xFFFFAA35:16  ; <<< FUNC sub_320E
00003214  5e010748                          jsr     sub_10748:24
00003218  6a18aa307260                      bclr    #6, @0xFFFFAA30:16
0000321E  fc01                              mov.b   #1, r4l
00003220  6a8cad68                          mov.b   r4l, @0xFFFFAD68:16
00003224  fcb3                              mov.b   #0xB3, r4l
00003226  6e8c0001                          mov.b   r4l, @(1:16,er0)
0000322A  5470                              rts
0000322C  55e0                              bsr     sub_320E:8
0000322E  5e05e0e8                          jsr     sub_5E0E8:24
00003232  5470                              rts
00003234  55d8                              bsr     sub_320E:8
00003236  5e05e128                          jsr     sub_5E128:24
0000323A  5470                              rts
0000323C  6a18aa357250             loc_323C bclr    #5, @0xFFFFAA35:16
00003242  5e010748                          jsr     sub_10748:24
00003246  6a18aa307260                      bclr    #6, @0xFFFFAA30:16
0000324C  fc00                              mov.b   #0, r4l
0000324E  6a8cad68                          mov.b   r4l, @0xFFFFAD68:16
00003252  fc00                              mov.b   #0, r4l
00003254  6e8c0001                          mov.b   r4l, @(1:16,er0)
00003258  5470                              rts
0000325A  2a4e                     sub_325A mov.b   @0xFFFFFF4E:8, r2l  ; <<< FUNC sub_325A
0000325C  ea40                              and.b   #0x40, r2l
0000325E  6a0ba9e0                          mov.b   @0xFFFFA9E0:16, r3l
00003262  7a63000000ff                      and.l   #0xFF, er3
00003268  1073                              shll.l  #2, er3
0000326A  01006f363272                      mov.l   @(0x3272:16,er3), er6
00003270  5960                              jmp     @er6
00003272  0000                              nop
00003274  327e                              mov.b   r2h, @0xFFFFFF7E:8
00003276  0000                              nop
00003278  328a                              mov.b   r2h, @0xFFFFFF8A:8
0000327A  0000                              nop
0000327C  329c                              mov.b   r2h, @0xFFFFFF9C:8
0000327E  0caa                              mov.b   r2l, r2l
00003280  4606                              bne     locret_3288:8
00003282  fc01                              mov.b   #1, r4l
00003284  6a8ca9e0                          mov.b   r4l, @0xFFFFA9E0:16
00003288  5470                     locret_3288 rts
0000328A  0caa                              mov.b   r2l, r2l
0000328C  470c                              beq     locret_329A:8
0000328E  fc50                              mov.b   #0x50, r4l ; 'P'
00003290  6a8c9536                          mov.b   r4l, @0xFFFF9536:16
00003294  fc02                              mov.b   #2, r4l
00003296  6a8ca9e0                          mov.b   r4l, @0xFFFFA9E0:16
0000329A  5470                     locret_329A rts
0000329C  0caa                              mov.b   r2l, r2l
0000329E  470c                              beq     loc_32AC:8
000032A0  6a0c9536                          mov.b   @0xFFFF9536:16, r4l
000032A4  4618                              bne     locret_32BE:8
000032A6  0480                              orc     #0x80, ccr
000032A8  5a0025ac                          jmp     loc_25AC:24
000032AC  6a0c9536                 loc_32AC mov.b   @0xFFFF9536:16, r4l
000032B0  ac46                              cmp.b   #0x46, r4l ; 'F'
000032B2  4404                              bcc     loc_32B8:8
000032B4  5e01cf0a                          jsr     sub_1CF0A:24
000032B8  fc01                     loc_32B8 mov.b   #1, r4l
000032BA  6a8ca9e0                          mov.b   r4l, @0xFFFFA9E0:16
000032BE  5470                     locret_32BE rts
000032C0  fc02                     sub_32C0 mov.b   #2, r4l  ; <<< FUNC sub_32C0
000032C2  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
000032C4  7fa07050                          bset    #5, @0xFFFFFFA0:8
000032C8  7ea07350                 loc_32C8 btst    #5, @0xFFFFFFA0:8
000032CC  46fa                              bne     loc_32C8:8
000032CE  7fa07270                          bclr    #7, @0xFFFFFFA0:8
000032D2  2c94                              mov.b   @0xFFFFFF94:8, r4l
000032D4  6a8ca992                          mov.b   r4l, @0xFFFFA992:16
000032D8  fc03                              mov.b   #3, r4l
000032DA  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
000032DC  7fa07050                          bset    #5, @0xFFFFFFA0:8
000032E0  7ea07350                 loc_32E0 btst    #5, @0xFFFFFFA0:8
000032E4  46fa                              bne     loc_32E0:8
000032E6  7fa07270                          bclr    #7, @0xFFFFFFA0:8
000032EA  2c96                              mov.b   @0xFFFFFF96:8, r4l
000032EC  6a8ca993                          mov.b   r4l, @0xFFFFA993:16
000032F0  6a0c8dde                          mov.b   @0xFFFF8DDE:16, r4l
000032F4  4630                              bne     loc_3326:8
000032F6  fc04                              mov.b   #4, r4l
000032F8  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
000032FA  7fa07050                          bset    #5, @0xFFFFFFA0:8
000032FE  7ea07350                 loc_32FE btst    #5, @0xFFFFFFA0:8
