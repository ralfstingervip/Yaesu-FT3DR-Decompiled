; ==== bitbang_b  00037A00-00037C40 ====
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
00037A14  790d0040                 sub_37A14 mov.w   #0x40, e5 ; '@'  ; <<< FUNC sub_37A14
00037A18  6b8d8172                 loc_37A18 mov.w   e5, @0xFFFF8172:16
00037A1C  400a                              bra     loc_37A28:8
00037A1E  01006b058172             sub_37A1E mov.l   @0xFFFF8172:16, er5  ; <<< FUNC sub_37A1E
00037A24  1dd5                              cmp.w   e5, r5
00037A26  477e                              beq     locret_37AA6:8
00037A28  fc03                     loc_37A28 mov.b   #3, r4l
00037A2A  6b8d8174                          mov.w   e5, @0xFFFF8174:16
00037A2E  403e                              bra     loc_37A6E:8
00037A30  790d0000                 sub_37A30 mov.w   #0, e5  ; <<< FUNC sub_37A30
00037A34  6b8d8176                          mov.w   e5, @0xFFFF8176:16
00037A38  400a                     loc_37A38 bra     loc_37A44:8
00037A3A  01006b058176             sub_37A3A mov.l   @0xFFFF8176:16, er5  ; <<< FUNC sub_37A3A
00037A40  1dd5                              cmp.w   e5, r5
00037A42  4762                     loc_37A42 beq     locret_37AA6:8
00037A44  fc07                     loc_37A44 mov.b   #7, r4l
00037A46  6b8d8178                          mov.w   e5, @0xFFFF8178:16
00037A4A  4022                              bra     loc_37A6E:8
00037A4C  790d0000                 sub_37A4C mov.w   #0, e5  ; <<< FUNC sub_37A4C
00037A50  6b8d817a                          mov.w   e5, @0xFFFF817A:16
00037A54  400a                              bra     loc_37A60:8
00037A56  01006b05817a             sub_37A56 mov.l   @0xFFFF817A:16, er5  ; <<< FUNC sub_37A56
00037A5C  1dd5                              cmp.w   e5, r5
00037A5E  4746                              beq     locret_37AA6:8
00037A60  fc02                     loc_37A60 mov.b   #2, r4l
00037A62  6b8d817c                          mov.w   e5, @0xFFFF817C:16
00037A66  7f5a60c0                          bset    r4l, @0xFFFFFF5A:8
00037A6A  f410                              mov.b   #0x10, r4h
00037A6C  400a                              bra     loc_37A78:8
00037A6E  7f5a60c0                 loc_37A6E bset    r4l, @0xFFFFFF5A:8
00037A72  105d                     loc_37A72 shll.w  #2, e5
00037A74  105d                              shll.w  #2, e5
00037A76  f40c                              mov.b   #0xC, r4h
00037A78  7f5a7210                 loc_37A78 bclr    #1, @0xFFFFFF5A:8
00037A7C  0000                              nop
00037A7E  0000                              nop
00037A80  101d                              shll.w  e5
00037A82  7f5a6700                          bst     #0, @0xFFFFFF5A:8
00037A86  0000                              nop
00037A88  0000                              nop
00037A8A  7f5a7010                          bset    #1, @0xFFFFFF5A:8
00037A8E  1a04                              dec.b   r4h
00037A90  46e6                              bne     loc_37A78:8
00037A92  7f5a7200                          bclr    #0, @0xFFFFFF5A:8
00037A96  7f5a62c0                          bclr    r4l, @0xFFFFFF5A:8
00037A9A  0000                              nop
00037A9C  0000                              nop
00037A9E  7f5a60c0                          bset    r4l, @0xFFFFFF5A:8
00037AA2  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
00037AA6  5470                     locret_37AA6 rts
00037AA8  7f5d7000                 sub_37AA8 bset    #0, @0xFFFFFF5D:8  ; <<< FUNC sub_37AA8
00037AAC  fc0a                              mov.b   #0xA, r4l
00037AAE  0000                     loc_37AAE nop
00037AB0  0000                              nop
00037AB2  0000                              nop
00037AB4  0000                              nop
00037AB6  0000                              nop
00037AB8  0000                              nop
00037ABA  0000                              nop
00037ABC  0000                              nop
00037ABE  1a0c                              dec.b   r4l
00037AC0  46ec                              bne     loc_37AAE:8
00037AC2  5470                              rts
00037AC4  7a0500037dc4             sub_37AC4 mov.l   #unk_37DC4, er5  ; <<< FUNC sub_37AC4
00037ACA  5e037ba0                          jsr     sub_37BA0:24
00037ACE  7a0500037dd4                      mov.l   #unk_37DD4, er5
00037AD4  5e037ba0                          jsr     sub_37BA0:24
00037AD8  7a0500037de4                      mov.l   #unk_37DE4, er5
00037ADE  5e037ba0                          jsr     sub_37BA0:24
00037AE2  fc01                              mov.b   #1, r4l
00037AE4  6a8c9531                          mov.b   r4l, @0xFFFF9531:16
00037AE8  5470                              rts
00037AEA  7a0300037e4c             sub_37AEA mov.l   #loc_37E4C, er3  ; <<< FUNC sub_37AEA
00037AF0  5e037c62                          jsr     sub_37C62:24
00037AF4  4632                              bne     locret_37B28:8
00037AF6  7a0500ff9500                      mov.l   #0xFF9500, er5
00037AFC  5e037ba0                          jsr     sub_37BA0:24
00037B00  5e037c1e                          jsr     sub_37C1E:24
00037B04  4622                              bne     locret_37B28:8
00037B06  7a0500ff9500                      mov.l   #0xFF9500, er5
00037B0C  5e037ba0                          jsr     sub_37BA0:24
00037B10  7a0500037e40                      mov.l   #(loc_37E3F+1), er5
00037B16  6a10aadf7370                      btst    #7, @0xFFFFAADF:16
00037B1C  4706                              beq     loc_37B24:8
00037B1E  7a0500037e38                      mov.l   #(loc_37E37+1), er5
00037B24  5e037ba0                 loc_37B24 jsr     sub_37BA0:24
00037B28  5470                     locret_37B28 rts
00037B2A  7f5d7010                 sub_37B2A bset    #1, @0xFFFFFF5D:8  ; <<< FUNC sub_37B2A
00037B2E  fc0a                              mov.b   #0xA, r4l
00037B30  0000                     loc_37B30 nop
00037B32  0000                              nop
00037B34  0000                              nop
00037B36  0000                              nop
00037B38  0000                              nop
00037B3A  0000                              nop
00037B3C  0000                              nop
00037B3E  0000                              nop
00037B40  1a0c                              dec.b   r4l
00037B42  46ec                              bne     loc_37B30:8
00037B44  5470                              rts
00037B46  7a0500037da4             sub_37B46 mov.l   #unk_37DA4, er5  ; <<< FUNC sub_37B46
00037B4C  5556                              bsr     sub_37BA4:8
00037B4E  7a0500037dd4                      mov.l   #unk_37DD4, er5
00037B54  554e                              bsr     sub_37BA4:8
00037B56  7a0500037de4                      mov.l   #unk_37DE4, er5
00037B5C  5546                              bsr     sub_37BA4:8
00037B5E  fc01                              mov.b   #1, r4l
00037B60  6a8c9530                          mov.b   r4l, @0xFFFF9530:16
00037B64  5470                              rts
00037B66  7a0300037e48             sub_37B66 mov.l   #(loc_37E47+1), er3  ; <<< FUNC sub_37B66
00037B6C  5e037c62                          jsr     sub_37C62:24
00037B70  462c                              bne     locret_37B9E:8
00037B72  7a0500ff9500                      mov.l   #0xFF9500, er5
00037B78  552a                              bsr     sub_37BA4:8
00037B7A  5e037c30                          jsr     sub_37C30:24
00037B7E  461e                              bne     locret_37B9E:8
00037B80  7a0500ff9500                      mov.l   #0xFF9500, er5
00037B86  551c                              bsr     sub_37BA4:8
00037B88  7a0500037e30                      mov.l   #(loc_37E2F+1), er5
00037B8E  6a10aadf7370                      btst    #7, @0xFFFFAADF:16
00037B94  4706                              beq     loc_37B9C:8
00037B96  7a0500037e28                      mov.l   #unk_37E28, er5
00037B9C  5506                     loc_37B9C bsr     sub_37BA4:8
00037B9E  5470                     locret_37B9E rts
00037BA0  fc06                     sub_37BA0 mov.b   #6, r4l  ; <<< FUNC sub_37BA0
00037BA2  4002                              bra     loc_37BA6:8
00037BA4  fc07                     sub_37BA4 mov.b   #7, r4l  ; <<< FUNC sub_37BA4
00037BA6  7f5d7220                 loc_37BA6 bclr    #2, @0xFFFFFF5D:8
00037BAA  6d56                              mov.w   @er5+, r6
00037BAC  7f5d7230                 loc_37BAC bclr    #3, @0xFFFFFF5D:8
00037BB0  6d53                              mov.w   @er5+, r3
00037BB2  7f5d62c0                          bclr    r4l, @0xFFFFFF5D:8
00037BB6  f410                              mov.b   #0x10, r4h
00037BB8  1013                     loc_37BB8 shll.w  r3
00037BBA  7f5d6730                          bst     #3, @0xFFFFFF5D:8
00037BBE  0000                              nop
00037BC0  0000                              nop
00037BC2  7f5d7020                          bset    #2, @0xFFFFFF5D:8
00037BC6  0000                              nop
00037BC8  0000                              nop
00037BCA  7f5d7220                          bclr    #2, @0xFFFFFF5D:8
00037BCE  1a04                              dec.b   r4h
00037BD0  46e6                              bne     loc_37BB8:8
00037BD2  0000                              nop
00037BD4  0000                              nop
00037BD6  7f5d60c0                          bset    r4l, @0xFFFFFF5D:8
00037BDA  0000                              nop
00037BDC  0000                              nop
00037BDE  1a0e                              dec.b   r6l
00037BE0  46ca                              bne     loc_37BAC:8
00037BE2  7f5d7230                          bclr    #3, @0xFFFFFF5D:8
00037BE6  5470                              rts
00037BE8  5e034dc2                 sub_37BE8 jsr     sub_34DC2:24  ; <<< FUNC sub_37BE8
00037BEC  4608                              bne     loc_37BF6:8
00037BEE  01006b04aaae                      mov.l   @0xFFFFAAAE:16, er4
00037BF4  401c                              bra     loc_37C12:8
00037BF6  01006b04aaae             loc_37BF6 mov.l   @0xFFFFAAAE:16, er4
00037BFC  7a2405000000                      cmp.l   #0x5000000, er4
00037C02  4408                              bcc     loc_37C0C:8
00037C04  7a0405000000                      mov.l   #0x5000000, er4
00037C0A  4006                              bra     loc_37C12:8
00037C0C  01006f040042             loc_37C0C mov.l   @(0x42:16,er0), er4
00037C12  7a0500ffaa4a             loc_37C12 mov.l   #0xFFAA4A, er5
00037C18  010069d4                          mov.l   er4, @er5
00037C1C  5470                              rts
00037C1E  01006f040042             sub_37C1E mov.l   @(0x42:16,er0), er4  ; <<< FUNC sub_37C1E
00037C24  7a0500ffaa4a                      mov.l   #0xFFAA4A, er5
00037C2A  010069d4                          mov.l   er4, @er5
00037C2E  4018                              bra     loc_37C48:8
00037C30  55b6                     sub_37C30 bsr     sub_37BE8:8  ; <<< FUNC sub_37C30
00037C32  fd40                              mov.b   #0x40, r5l ; '@'
00037C34  01006b04aa4a                      mov.l   @0xFFFFAA4A:16, er4
00037C3A  7a2430000000                      cmp.l   #0x30000000, er4
