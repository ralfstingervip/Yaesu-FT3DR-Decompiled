; ==== pll_writer  00037A00-00037F80 ====
00037A00  4471                              bcc     loc_37A72:8
00037A02  0000                              nop
00037A04  4534                              bcs     loc_37A3A:8
00037A06  0000                              nop
00037A08  4538                              bcs     loc_37A42:8
00037A0A  0000                              nop
00037A0C  4590                              bcs     loc_3799E:8
00037A0E  0000                              nop
00037A10  4626                              bne     loc_37A38:8
00037A12  0000                              nop
00037A14  790d0040                 sub_37A14 mov.w   #0x40, e5 ; '@'  ; <<< FUNC sub_37A14
00037A18  6b8d8172                          mov.w   e5, @0xFFFF8172:16
00037A1C  400a                              bra     loc_37A28:8
00037A1E  01006b058172             loc_37A1E mov.l   @0xFFFF8172:16, er5
00037A24  1dd5                              cmp.w   e5, r5
00037A26  477e                              beq     locret_37AA6:8
00037A28  fc03                     loc_37A28 mov.b   #3, r4l
00037A2A  6b8d8174                          mov.w   e5, @0xFFFF8174:16
00037A2E  403e                              bra     loc_37A6E:8
00037A30  790d0000                 sub_37A30 mov.w   #0, e5  ; <<< FUNC sub_37A30
00037A34  6b8d8176                          mov.w   e5, @0xFFFF8176:16
00037A38  400a                     loc_37A38 bra     loc_37A44:8
00037A3A  01006b058176             loc_37A3A mov.l   @0xFFFF8176:16, er5
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
00037AA8  7f5d7000                          bset    #0, @0xFFFFFF5D:8
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
00037AC4  7a0500037dc4                      mov.l   #unk_37DC4, er5
00037ACA  5e037ba0                          jsr     sub_37BA0:24
00037ACE  7a0500037dd4                      mov.l   #unk_37DD4, er5
00037AD4  5e037ba0                          jsr     sub_37BA0:24
00037AD8  7a0500037de4                      mov.l   #unk_37DE4, er5
00037ADE  5e037ba0                          jsr     sub_37BA0:24
00037AE2  fc01                              mov.b   #1, r4l
00037AE4  6a8c9531                          mov.b   r4l, @0xFFFF9531:16
00037AE8  5470                              rts
00037AEA  7a0300037e4c                      mov.l   #loc_37E4C, er3
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
00037B2A  7f5d7010                 loc_37B2A bset    #1, @0xFFFFFF5D:8
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
00037B46  7a0500037da4             loc_37B46 mov.l   #unk_37DA4, er5
00037B4C  5556                              bsr     sub_37BA4:8
00037B4E  7a0500037dd4                      mov.l   #unk_37DD4, er5
00037B54  554e                              bsr     sub_37BA4:8
00037B56  7a0500037de4                      mov.l   #unk_37DE4, er5
00037B5C  5546                              bsr     sub_37BA4:8
00037B5E  fc01                              mov.b   #1, r4l
00037B60  6a8c9530                          mov.b   r4l, @0xFFFF9530:16
00037B64  5470                              rts
00037B66  7a0300037e48             loc_37B66 mov.l   #(loc_37E47+1), er3
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
00037C40  4502                              bcs     loc_37C44:8
00037C42  fd10                              mov.b   #0x10, r5l
00037C44  6a8d9517                 loc_37C44 mov.b   r5l, @0xFFFF9517:16
00037C48  79040016                 loc_37C48 mov.w   #0x16, r4
00037C4C  7a0500037e12                      mov.l   #unk_37E12, er5
00037C52  7a0600ff9500                      mov.l   #0xFF9500, er6
00037C58  7bd4598f                 loc_37C58 eepmov.w
00037C5C  0d44                              mov.w   r4, r4
00037C5E  46f8                              bne     loc_37C58:8
00037C60  4034                              bra     loc_37C96:8
00037C62  79040016                 sub_37C62 mov.w   #0x16, r4  ; <<< FUNC sub_37C62
00037C66  7a0500037dfc                      mov.l   #unk_37DFC, er5
00037C6C  7a0600ff9500                      mov.l   #0xFF9500, er6
00037C72  7bd4598f                 loc_37C72 eepmov.w
00037C76  0d44                              mov.w   r4, r4
00037C78  46f8                              bne     loc_37C72:8
00037C7A  0fb6                              mov.l   er3, er6
00037C7C  5e037842                          jsr     loc_37842:24
00037C80  01006b05aa4a                      mov.l   @0xFFFFAA4A:16, er5
00037C86  01006b24000327c8                  mov.l   @dword_327C8:32, er4
00037C8E  1fc5                              cmp.l   er4, er5
00037C90  6a18aadf6770                      bst     #7, @0xFFFFAADF:16
00037C96  01006b05aa4a             loc_37C96 mov.l   @0xFFFFAA4A:16, er5
00037C9C  7a0600037e50                      mov.l   #unk_37E50, er6
00037CA2  5e03f5b2                          jsr     sub_3F5B2:24
00037CA6  586000e0                          bne     locret_37D8A:16
00037CAA  6b8394f6                          mov.w   r3, @0xFFFF94F6:16
00037CAE  7a0500ffaa4a                      mov.l   #0xFFAA4A, er5
00037CB4  5e03f986                          jsr     sub_3F986:24
00037CB8  6a0c94f7                          mov.b   @0xFFFF94F7:16, r4l
00037CBC  7a64000000ff                      and.l   #0xFF, er4
00037CC2  78406a2c00037eae                  mov.b   @(byte_37EAE:32,er4), r4l
00037CCA  0fe3                              mov.l   er6, er3
00037CCC  5e03f900                          jsr     sub_3F900:24
00037CD0  0fb1                              mov.l   er3, er1
00037CD2  0fb6                              mov.l   er3, er6
00037CD4  7a040057e400                      mov.l   #0x57E400, er4
00037CDA  6a10aadf7300                      btst    #0, @0xFFFFAADF:16
00037CE0  4706                              beq     loc_37CE8:8
00037CE2  7a0400432380                      mov.l   #0x432380, er4
00037CE8  5e03f778                 loc_37CE8 jsr     sub_3F778:24
00037CEC  6a8e94fc                          mov.b   r6l, @0xFFFF94FC:16
00037CF0  6a0c94f7                          mov.b   @0xFFFF94F7:16, r4l
00037CF4  7a64000000ff                      and.l   #0xFF, er4
00037CFA  78406a2c00037eae                  mov.b   @(byte_37EAE:32,er4), r4l
00037D02  fd7d                              mov.b   #0x7D, r5l ; '}'
00037D04  50c5                              mulxu.b r4l, r5
00037D06  0d52                              mov.w   r5, r2
00037D08  7a040057e400                      mov.l   #0x57E400, er4
00037D0E  6a10aadf7300                      btst    #0, @0xFFFFAADF:16
00037D14  4706                              beq     loc_37D1C:8
00037D16  7a0400432380                      mov.l   #0x432380, er4
00037D1C  5354                     loc_37D1C divxu.w r5, er4
00037D1E  6b8494f8                          mov.w   r4, @0xFFFF94F8:16
00037D22  7a030057e400                      mov.l   #0x57E400, er3
00037D28  6a10aadf7300                      btst    #0, @0xFFFFAADF:16
00037D2E  4706                              beq     loc_37D36:8
00037D30  7a0300432380                      mov.l   #0x432380, er3
00037D36  7a0400000000             loc_37D36 mov.l   #0, er4
00037D3C  6a0c94fc                          mov.b   @0xFFFF94FC:16, r4l
00037D40  5e03f900                          jsr     sub_3F900:24
00037D44  1ab1                              sub.l   er3, er1
00037D46  5321                              divxu.w r2, er1
00037D48  6b8194fa                          mov.w   r1, @0xFFFF94FA:16
00037D4C  6b0494fa                          mov.w   @0xFFFF94FA:16, r4
00037D50  6a849507                          mov.b   r4h, @0xFFFF9507:16
00037D54  6a8c9509                          mov.b   r4l, @0xFFFF9509:16
00037D58  6b0494f8                          mov.w   @0xFFFF94F8:16, r4
00037D5C  6a84950b                          mov.b   r4h, @0xFFFF950B:16
00037D60  6a8c950d                          mov.b   r4l, @0xFFFF950D:16
00037D64  6a0c94f7                          mov.b   @0xFFFF94F7:16, r4l
00037D68  6a1094f67700                      bld     #0, @0xFFFF94F6:16
00037D6E  673c                              bst     #3, r4l
00037D70  104c                              shll.b  #2, r4l
00037D72  104c                              shll.b  #2, r4l
00037D74  6a8c950f                          mov.b   r4l, @0xFFFF950F:16
00037D78  6a0c94fc                          mov.b   @0xFFFF94FC:16, r4l
00037D7C  6a8c9511                          mov.b   r4l, @0xFFFF9511:16
00037D80  6a0c9517                          mov.b   @0xFFFF9517:16, r4l
00037D84  6a8c9513                          mov.b   r4l, @0xFFFF9513:16
00037D88  fc00                              mov.b   #0, r4l
00037D8A  5470                     locret_37D8A rts
00037D8C  00                                .byte    0
00037D8D  01                                .byte    1
00037D8E  01                                .byte    1
00037D8F  0a00                              inc.b   r0h
00037D91  01                                .byte    1
00037D92  2b4a                              mov.b   @0xFFFFFF4A:8, r3l
00037D94  00                                .byte    0
00037D95  0720                              ldc.b   #0x20, ccr ; ' '
00037D97  00                                .byte    0
00037D98  210c                              mov.b   @0xFFFFFF0C:8, r1h
00037D9A  2211                              mov.b   @0xFFFFFF11:8, r2h
00037D9C  234b                              mov.b   @0xFFFFFF4B:8, r3h
00037D9E  2400                              mov.b   @0xFFFFFF00:8, r4h
00037DA0  2517                              mov.b   @0xFFFFFF17:8, r5h
00037DA2  2a00                              mov.b   @0xFFFFFF00:8, r2l
00037DA4  00                       unk_37DA4 .byte    0
00037DA5  0720                              ldc.b   #0x20, ccr ; ' '
00037DA7  00                                .byte    0
00037DA8  210c                              mov.b   @0xFFFFFF0C:8, r1h
00037DAA  2211                              mov.b   @0xFFFFFF11:8, r2h
00037DAC  236b                              mov.b   @0xFFFFFF6B:8, r3h
00037DAE  2400                              mov.b   @0xFFFFFF00:8, r4h
00037DB0  2517                              mov.b   @0xFFFFFF17:8, r5h
00037DB2  2a00                              mov.b   @0xFFFFFF00:8, r2l
00037DB4  00                                .byte    0
00037DB5  0720                              ldc.b   #0x20, ccr ; ' '
00037DB7  00                                .byte    0
00037DB8  210c                              mov.b   @0xFFFFFF0C:8, r1h
00037DBA  2211                              mov.b   @0xFFFFFF11:8, r2h
00037DBC  234b                              mov.b   @0xFFFFFF4B:8, r3h
00037DBE  2400                              mov.b   @0xFFFFFF00:8, r4h
00037DC0  2507                              mov.b   @0xFFFFFF07:8, r5h
00037DC2  2a00                              mov.b   @0xFFFFFF00:8, r2l
00037DC4  00                       unk_37DC4 .byte    0
00037DC5  0720                              ldc.b   #0x20, ccr ; ' '
00037DC7  00                                .byte    0
00037DC8  210c                              mov.b   @0xFFFFFF0C:8, r1h
00037DCA  2211                              mov.b   @0xFFFFFF11:8, r2h
00037DCC  236b                              mov.b   @0xFFFFFF6B:8, r3h
00037DCE  2400                              mov.b   @0xFFFFFF00:8, r4h
00037DD0  2507                              mov.b   @0xFFFFFF07:8, r5h
00037DD2  2a00                              mov.b   @0xFFFFFF00:8, r2l
00037DD4  00                       unk_37DD4 .byte    0
00037DD5  0708                              ldc.b   #8, ccr
00037DD7  00                                .byte    0
00037DD8  0900                              add.w   r0, r0
00037DDA  0a00                              inc.b   r0h
00037DDC  0b00                              adds    #1, er0
00037DDE  0c7f                              mov.b   r7h, r7l
00037DE0  0dff                              mov.w   e7, e7
00037DE2  0eff                              addx    r7l, r7l
00037DE4  00                       unk_37DE4 .byte    0
00037DE5  0718                              ldc.b   #0x18, ccr
00037DE7  00                                .byte    0
00037DE8  1900                              sub.w   r0, r0
00037DEA  1a                                .byte 0x1A
00037DEB  401b                              bra     loc_37E06+1:8
00037DED  00                                .byte    0
00037DEE  1c7f                              cmp.b   r7h, r7l
00037DF0  1dff                              cmp.w   e7, e7
00037DF2  1eff                              subx    r7l, r7l
00037DF4  00                                .byte    0
00037DF5  01                                .byte    1
00037DF6  1a                                .byte 0x1A
00037DF7  4000                              bra     unk_37DF9:8
00037DF9  01                       unk_37DF9 .byte    1
00037DFA  1a00                              dec.b   r0h
00037DFC  00                       unk_37DFC .byte    0
00037DFD  0a                                .byte  0xA
00037DFE  2601                              mov.b   @0xFFFFFF01:8, r6h
00037E00  2701                              mov.b   @0xFFFFFF01:8, r7h
00037E02  0203                              stc.b   ccr, r3h
00037E04  0320                              ldmac   er0, mach
00037E06  040b                     loc_37E06 orc     #0xB, ccr
00037E08  0540                              xorc    #0x40, ccr ; '@'
00037E0A  06c0                              andc    #0xC0, ccr
00037E0C  0728                              ldc.b   #0x28, ccr ; '('
00037E0E  0a00                              inc.b   r0h
00037E10  0b00                              adds    #1, er0
00037E12  00                       unk_37E12 .byte    0
00037E13  0a                                .byte  0xA
00037E14  2801                              mov.b   @0xFFFFFF01:8, r0l
00037E16  2901                              mov.b   @0xFFFFFF01:8, r1l
00037E18  1204                              rotxl.b r4h
00037E1A  13b0                              rotr.l  er0
00037E1C  140b                              or.b    r0h, r3l
00037E1E  1540                              xor.b   r4h, r0h
00037E20  16c0                              and.b   r4l, r0h
00037E22  17                                .byte 0x17
00037E23  281a                     loc_37E23 mov.b   @0xFFFFFF1A:8, r0l
00037E25  00                                .byte    0
00037E26  1b00                              subs    #1, er0
00037E28  00                       unk_37E28 .byte    0
00037E29  030f                              ldc.b   r7l, ccr
00037E2B  101f                     loc_37E2B shll.w  e7
00037E2D  af01                              cmp.b   #1, r7l
00037E2F  0a00                     loc_37E2F inc.b   r0h
00037E31  030f                              ldc.b   r7l, ccr
00037E33  141f                              or.b    r1h, r7l
00037E35  af01                              cmp.b   #1, r7l
00037E37  0a00                     loc_37E37 inc.b   r0h
00037E39  030f                              ldc.b   r7l, ccr
00037E3B  101f                              shll.w  e7
00037E3D  af01                              cmp.b   #1, r7l
00037E3F  0a00                     loc_37E3F inc.b   r0h
00037E41  030f                              ldc.b   r7l, ccr
00037E43  141f                              or.b    r1h, r7l
00037E45  af01                              cmp.b   #1, r7l
00037E47  0a05                     loc_37E47 inc.b   r5h
00037E49  8050                              add.b   #0x50, r0h ; 'P'
00037E4B  00                                .byte    0
00037E4C  0571                     loc_37E4C xorc    #0x71, ccr ; 'q'
00037E4E  5000                              mulxu.b r0h, r0
00037E50  00                       unk_37E50 .byte    0
00037E51  0a00                              inc.b   r0h
00037E53  0904                              add.w   r0, r4
00037E55  6875                              mov.b   @sp, r5h
00037E57  00                                .byte    0
00037E58  0656                              andc    #0x56, ccr ; 'V'
00037E5A  2000                              mov.b   @0xFFFFFF00:8, r0h
00037E5C  00                                .byte    0
00037E5D  0506                              xorc    #6, ccr
00037E5F  56                                .byte 0x56 ; V
00037E60  2500                              mov.b   @0xFFFFFF00:8, r5h
00037E62  0999                              add.w   e1, e1
00037E64  9500                              addx    #0, r5h
00037E66  01                                .byte    1
00037E67  0510                              xorc    #0x10, ccr
00037E69  0000                              nop
00037E6B  00                                .byte    0
00037E6C  1312                              rotxr.w r2
00037E6E  4500                              bcs     unk_37E70:8
00037E70  00                       unk_37E70 .byte    0
00037E71  0413                              orc     #0x13, ccr
00037E73  1250                              rotxl.w #2, r0
00037E75  00                                .byte    0
00037E76  2099                              mov.b   @0xFFFFFF99:8, r0h
00037E78  9500                              addx    #0, r5h
00037E7A  01                                .byte    1
00037E7B  0421                              orc     #0x21, ccr ; '!'
00037E7D  0000                              nop
00037E7F  00                                .byte    0
00037E80  2624                              mov.b   @0xFFFFFF24:8, r6h
00037E82  9500                              addx    #0, r5h
00037E84  00                                .byte    0
00037E85  0326                              ldmac   er6, mach
00037E87  2500                              mov.b   @0xFFFFFF00:8, r5h
00037E89  00                                .byte    0
00037E8A  4199                              brn     loc_37E23+1:8
00037E8C  9500                              addx    #0, r5h
00037E8E  01                                .byte    1
00037E8F  03                                .byte    3
00037E90  4200                              bhi     loc_37E92:8
00037E92  0000                     loc_37E92 nop
00037E94  52                                .byte 0x52 ; R
00037E95  4995                              bvs     loc_37E2B+1:8
00037E97  0000                              nop
00037E99  02                                .byte    2
00037E9A  5250                              mulxu.w r5, er0
00037E9C  0000                              nop
00037E9E  8409                              add.b   #9, r4h
00037EA0  9500                              addx    #0, r5h
00037EA2  01                                .byte    1
00037EA3  02                                .byte    2
00037EA4  8410                              add.b   #0x10, r4h
00037EA6  0000                              nop
00037EA8  9999                              addx    #0x99, r1l
00037EAA  9500                              addx    #0, r5h
00037EAC  00                                .byte    0
00037EAD  01                                .byte    1
00037EAE  00                       byte_37EAE .byte 0
00037EAF  0204                              stc.b   ccr, r4h
00037EB1  0810                              add.b   r1h, r0h
00037EB3  2000                              mov.b   @0xFFFFFF00:8, r0h
00037EB5  00                                .byte    0
00037EB6  7904000e                 loc_37EB6 mov.w   #0xE, r4
00037EBA  7a0500038066                      mov.l   #unk_38066, er5
00037EC0  7a0600ff8e40                      mov.l   #0xFF8E40, er6
00037EC6  7bd4598f                 loc_37EC6 eepmov.w
00037ECA  0d44                              mov.w   r4, r4
00037ECC  46f8                              bne     loc_37EC6:8
00037ECE  6a0c8e41                          mov.b   @0xFFFF8E41:16, r4l
00037ED2  6a8c8e4e                          mov.b   r4l, @0xFFFF8E4E:16
00037ED6  5470                              rts
00037ED8  fc00                              mov.b   #0, r4l
00037EDA  6a8c94fd                          mov.b   r4l, @0xFFFF94FD:16
00037EDE  5470                              rts
00037EE0  7a0600038006                      mov.l   #unk_38006, er6
00037EE6  5e03f636                          jsr     sub_3F636:24
00037EEA  5470                              rts
00037EEC  6a0b94fd                          mov.b   @0xFFFF94FD:16, r3l
00037EF0  7a63000000ff                      and.l   #0xFF, er3
00037EF6  1073                              shll.l  #2, er3
00037EF8  78                                .byte 0x78 ; x
00037EF9  b06b                              subx    #0x6B, r0h ; 'k'
00037EFB  2600                              mov.b   @0xFFFFFF00:8, r6h
00037EFD  03                                .byte    3
00037EFE  7f                                .byte 0x7F ; 
00037EFF  ce59                              or.b    #0x59, r6l
00037F01  607a                              bset    r7h, r2l
00037F03  0600                              andc    #0, ccr
00037F05  03                                .byte    3
00037F06  800c                              add.b   #0xC, r0h
00037F08  4070                              bra     loc_37F7A:8
00037F0A  6a108ea07360                      btst    #6, @0xFFFF8EA0:16
00037F10  4708                              beq     loc_37F1A:8
00037F12  7a0600038018                      mov.l   #unk_38018, er6
00037F18  4060                              bra     loc_37F7A:8
00037F1A  7a0600038012             loc_37F1A mov.l   #unk_38012, er6
00037F20  4058                              bra     loc_37F7A:8
00037F22  7a060003801e                      mov.l   #unk_3801E, er6
00037F28  4050                              bra     loc_37F7A:8
00037F2A  7a0600038024                      mov.l   #unk_38024, er6
00037F30  4048                              bra     loc_37F7A:8
00037F32  7a060003802a                      mov.l   #unk_3802A, er6
00037F38  4040                              bra     loc_37F7A:8
00037F3A  7a0600038030                      mov.l   #unk_38030, er6
00037F40  4038                              bra     loc_37F7A:8
00037F42  7a0600038036                      mov.l   #unk_38036, er6
00037F48  4030                              bra     loc_37F7A:8
00037F4A  7a060003803c                      mov.l   #unk_3803C, er6
00037F50  4028                              bra     loc_37F7A:8
00037F52  7a0600038042                      mov.l   #unk_38042, er6
00037F58  4020                              bra     loc_37F7A:8
00037F5A  7a0600038048                      mov.l   #unk_38048, er6
00037F60  4018                              bra     loc_37F7A:8
00037F62  7a060003804e                      mov.l   #unk_3804E, er6
00037F68  4010                              bra     loc_37F7A:8
00037F6A  7a0600038054                      mov.l   #unk_38054, er6
00037F70  4008                              bra     loc_37F7A:8
00037F72  7a0600038060                      mov.l   #unk_38060, er6
00037F78  4000                              bra     loc_37F7A:8
00037F7A  5e03f62e                 loc_37F7A jsr     sub_3F62E:24
00037F7E  4012                              bra     loc_37F92:8
