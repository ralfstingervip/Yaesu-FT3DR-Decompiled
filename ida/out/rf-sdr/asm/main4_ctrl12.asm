; ==== ctrl12  000312E0-00031400 ====
000312E0  138e                              rotr.b  r6l
000312E2  6a0c8dd5                          mov.b   @0xFFFF8DD5:16, r4l
000312E6  4708                              beq     loc_312F0:8
000312E8  6a1881777010                      bset    #1, @0xFFFF8177:16
000312EE  4006                              bra     loc_312F6:8
000312F0  6a1881777210             loc_312F0 bclr    #1, @0xFFFF8177:16
000312F6  5e037a3a                 loc_312F6 jsr     sub_37A3A:24
000312FA  5470                              rts
000312FC  00                                .byte    0
000312FD  0202                              stc.b   ccr, r2h
000312FF  00                                .byte    0
00031300  0404                              orc     #4, ccr
00031302  0404                              orc     #4, ccr
00031304  0404                              orc     #4, ccr
00031306  0408                              orc     #8, ccr
00031308  0808                              add.b   r0h, r0l
0003130A  0808                              add.b   r0h, r0l
0003130C  0808                              add.b   r0h, r0l
0003130E  0808                              add.b   r0h, r0l
00031310  0000                              nop
00031312  0000                              nop
00031314  0000                              nop
00031316  0000                              nop
00031318  0000                              nop
0003131A  0000                              nop
0003131C  0000                              nop
0003131E  0000                              nop
00031320  0000                              nop
00031322  0000                              nop
00031324  6e0c0012                          mov.b   @(0x12:16,er0), r4l
00031328  734c                              btst    #4, r4l
0003132A  4620                              bne     loc_3134C:8
0003132C  7a0600030c3e                      mov.l   #unk_30C3E, er6
00031332  6e0c008e                          mov.b   @(0x8E:16,er0), r4l
00031336  ac0b                              cmp.b   #0xB, r4l
00031338  4506                              bcs     loc_31340:8
0003133A  7a0600030c62                      mov.l   #unk_30C62, er6
00031340  01006f050042             loc_31340 mov.l   @(0x42:16,er0), er5
00031346  5e03f5b2                          jsr     sub_3F5B2:24
0003134A  4606                              bne     loc_31352:8
0003134C  7f527250                 loc_3134C bclr    #5, @0xFFFFFF52:8
00031350  4004                              bra     loc_31356:8
00031352  7f527050                 loc_31352 bset    #5, @0xFFFFFF52:8
00031356  6e0c0012                 loc_31356 mov.b   @(0x12:16,er0), r4l
0003135A  734c                              btst    #4, r4l
0003135C  4620                              bne     loc_3137E:8
0003135E  7a0600030c86                      mov.l   #unk_30C86, er6
00031364  6e0c008e                          mov.b   @(0x8E:16,er0), r4l
00031368  ac0b                              cmp.b   #0xB, r4l
0003136A  4506                              bcs     loc_31372:8
0003136C  7a0600030cba                      mov.l   #unk_30CBA, er6
00031372  01006f050042             loc_31372 mov.l   @(0x42:16,er0), er5
00031378  5e03f5b2                          jsr     sub_3F5B2:24
0003137C  4608                              bne     loc_31386:8
0003137E  6a18bbe07070             loc_3137E bset    #7, @0xFFFFBBE0:16
00031384  4006                              bra     locret_3138C:8
00031386  6a18bbe07270             loc_31386 bclr    #7, @0xFFFFBBE0:16
0003138C  5470                     locret_3138C rts
0003138E  6e0c0086                          mov.b   @(0x86:16,er0), r4l
00031392  730c                              btst    #0, r4l
00031394  460e                              bne     loc_313A4:8
00031396  6e0c0039                          mov.b   @(0x39:16,er0), r4l
0003139A  775c                              bld     #5, r4l
0003139C  6a1881766710                      bst     #1, @0xFFFF8176:16
000313A2  400a                              bra     locret_313AE:8
000313A4  5520                     loc_313A4 bsr     sub_313C6:8
000313A6  4006                              bra     locret_313AE:8
000313A8  6a1881767010                      bset    #1, @0xFFFF8176:16
000313AE  5470                     locret_313AE rts
000313B0  6e0c0086                          mov.b   @(0x86:16,er0), r4l
000313B4  700c                              bset    #0, r4l
000313B6  6e8c0086                          mov.b   r4l, @(0x86:16,er0)
000313BA  6a1881767010                      bset    #1, @0xFFFF8176:16
000313C0  5e037a3a                          jsr     sub_37A3A:24
000313C4  5470                              rts
000313C6  6e0c0086                 sub_313C6 mov.b   @(0x86:16,er0), r4l  ; <<< FUNC sub_313C6
000313CA  720c                              bclr    #0, r4l
000313CC  6e8c0086                          mov.b   r4l, @(0x86:16,er0)
000313D0  6e0c0039                          mov.b   @(0x39:16,er0), r4l
000313D4  775c                              bld     #5, r4l
000313D6  6a1881766710                      bst     #1, @0xFFFF8176:16
000313DC  5e037a3a                          jsr     sub_37A3A:24
000313E0  5470                              rts
000313E2  0f85                              mov.l   er0, er5
000313E4  7a1500000042                      add.l   #0x42, er5 ; 'B'
000313EA  5e03f986                          jsr     sub_3F986:24
000313EE  79032710                          mov.w   #0x2710, r3
000313F2  6e0c0004                          mov.b   @(4:16,er0), r4l
000313F6  ac00                              cmp.b   #0, r4l
000313F8  4604                              bne     loc_313FE:8
000313FA  790303e8                          mov.w   #0x3E8, r3
000313FE  5336                     loc_313FE divxu.w r3, er6
