; ==== port_init  000030E0-00003200 ====
000030E0  6a1089c27300             sub_30E0 btst    #0, @0xFFFF89C2:16  ; <<< FUNC sub_30E0
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
00003166  5e039080                          jsr     loc_3907F+1:24
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
000031E2  6a0c8d26                 sub_31E2 mov.b   @0xFFFF8D26:16, r4l  ; <<< FUNC sub_31E2
000031E6  acff                              cmp.b   #0xFF, r4l
000031E8  4622                              bne     locret_320C:8
000031EA  6a18aa357050                      bset    #5, @0xFFFFAA35:16
000031F0  6a18b0577070                      bset    #7, @0xFFFFB057:16
000031F6  6a18aa317260                      bclr    #6, @0xFFFFAA31:16
000031FC  fc00                              mov.b   #0, r4l
000031FE  6a8c9537                          mov.b   r4l, @0xFFFF9537:16
