; ==== ad_read  000032C0-00003560 ====
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
00003302  46fa                              bne     loc_32FE:8
00003304  7fa07270                          bclr    #7, @0xFFFFFFA0:8
00003308  2c98                              mov.b   @0xFFFFFF98:8, r4l
0000330A  6a8ca994                          mov.b   r4l, @0xFFFFA994:16
0000330E  fc05                              mov.b   #5, r4l
00003310  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
00003312  7fa07050                          bset    #5, @0xFFFFFFA0:8
00003316  7ea07350                 loc_3316 btst    #5, @0xFFFFFFA0:8
0000331A  46fa                              bne     loc_3316:8
0000331C  7fa07270                          bclr    #7, @0xFFFFFFA0:8
00003320  2c9a                              mov.b   @0xFFFFFF9A:8, r4l
00003322  6a8ca995                          mov.b   r4l, @0xFFFFA995:16
00003326  6a0c9550                 loc_3326 mov.b   @0xFFFF9550:16, r4l
0000332A  58600136                          bne     locret_3464:16
0000332E  fc06                              mov.b   #6, r4l
00003330  6a8c9550                          mov.b   r4l, @0xFFFF9550:16
00003334  fc00                              mov.b   #0, r4l
00003336  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
00003338  7fa07050                          bset    #5, @0xFFFFFFA0:8
0000333C  7ea07350                 loc_333C btst    #5, @0xFFFFFFA0:8
00003340  46fa                              bne     loc_333C:8
00003342  7fa07270                          bclr    #7, @0xFFFFFFA0:8
00003346  2c90                              mov.b   @0xFFFFFF90:8, r4l
00003348  6a8ca98c                          mov.b   r4l, @0xFFFFA98C:16
0000334C  f400                              mov.b   #0, r4h
0000334E  79061ae6                          mov.w   #0x1AE6, r6
00003352  5246                              mulxu.w r4, er6
00003354  5e03fa2c                          jsr     sub_3FA2C:24
00003358  0de6                              mov.w   e6, r6
0000335A  e60f                              and.b   #0xF, r6h
0000335C  0d6b                              mov.w   r6, e3
0000335E  f300                              mov.b   #0, r3h
00003360  fb00                              mov.b   #0, r3l
00003362  79260100                 loc_3362 cmp.w   #0x100, r6
00003366  584000f4                          bcc     loc_345E:16
0000336A  6a0c94c0                          mov.b   @0xFFFF94C0:16, r4l
0000336E  ac01                              cmp.b   #1, r4l
00003370  58600082                          bne     loc_33F6:16
00003374  f301                              mov.b   #1, r3h
00003376  fb01                              mov.b   #1, r3l
00003378  79260076                          cmp.w   #0x76, r6 ; 'v'
0000337C  584000de                          bcc     loc_345E:16
00003380  fb02                              mov.b   #2, r3l
00003382  ae75                              cmp.b   #0x75, r6l ; 'u'
00003384  584000d6                          bcc     loc_345E:16
00003388  fb03                              mov.b   #3, r3l
0000338A  ae73                              cmp.b   #0x73, r6l ; 's'
0000338C  584000ce                          bcc     loc_345E:16
00003390  fb04                              mov.b   #4, r3l
00003392  ae71                              cmp.b   #0x71, r6l ; 'q'
00003394  584000c6                          bcc     loc_345E:16
00003398  fb05                              mov.b   #5, r3l
0000339A  ae70                              cmp.b   #0x70, r6l ; 'p'
0000339C  584000be                          bcc     loc_345E:16
000033A0  fb06                              mov.b   #6, r3l
000033A2  ae68                              cmp.b   #0x68, r6l ; 'h'
000033A4  584000b6                          bcc     loc_345E:16
000033A8  fb07                              mov.b   #7, r3l
000033AA  ae63                              cmp.b   #0x63, r6l ; 'c'
000033AC  584000ae                          bcc     loc_345E:16
000033B0  fb08                              mov.b   #8, r3l
000033B2  ae59                              cmp.b   #0x59, r6l ; 'Y'
000033B4  584000a6                          bcc     loc_345E:16
000033B8  fb09                              mov.b   #9, r3l
000033BA  ae50                              cmp.b   #0x50, r6l ; 'P'
000033BC  5840009e                          bcc     loc_345E:16
000033C0  f302                              mov.b   #2, r3h
000033C2  fb01                              mov.b   #1, r3l
000033C4  ae39                              cmp.b   #0x39, r6l ; '9'
000033C6  58400094                          bcc     loc_345E:16
000033CA  fb02                              mov.b   #2, r3l
000033CC  ae38                              cmp.b   #0x38, r6l ; '8'
000033CE  5840008c                          bcc     loc_345E:16
000033D2  fb03                              mov.b   #3, r3l
000033D4  ae37                              cmp.b   #0x37, r6l ; '7'
000033D6  58400084                          bcc     loc_345E:16
000033DA  fb04                              mov.b   #4, r3l
000033DC  ae36                              cmp.b   #0x36, r6l ; '6'
000033DE  447e                              bcc     loc_345E:8
000033E0  fb05                              mov.b   #5, r3l
000033E2  ae35                              cmp.b   #0x35, r6l ; '5'
000033E4  4478                              bcc     loc_345E:8
000033E6  fb06                              mov.b   #6, r3l
000033E8  ae34                              cmp.b   #0x34, r6l ; '4'
000033EA  4472                              bcc     loc_345E:8
000033EC  fb07                              mov.b   #7, r3l
000033EE  ae33                              cmp.b   #0x33, r6l ; '3'
000033F0  446c                              bcc     loc_345E:8
000033F2  fb09                              mov.b   #9, r3l
000033F4  4068                              bra     loc_345E:8
000033F6  f301                     loc_33F6 mov.b   #1, r3h
000033F8  fb01                              mov.b   #1, r3l
000033FA  79260080                          cmp.w   #0x80, r6
000033FE  445e                              bcc     loc_345E:8
00003400  fb02                              mov.b   #2, r3l
00003402  ae79                              cmp.b   #0x79, r6l ; 'y'
00003404  4458                              bcc     loc_345E:8
00003406  fb03                              mov.b   #3, r3l
00003408  ae77                              cmp.b   #0x77, r6l ; 'w'
0000340A  4452                              bcc     loc_345E:8
0000340C  fb04                              mov.b   #4, r3l
0000340E  ae75                              cmp.b   #0x75, r6l ; 'u'
00003410  444c                              bcc     loc_345E:8
00003412  fb05                              mov.b   #5, r3l
00003414  ae73                              cmp.b   #0x73, r6l ; 's'
00003416  4446                              bcc     loc_345E:8
00003418  fb06                              mov.b   #6, r3l
0000341A  ae71                              cmp.b   #0x71, r6l ; 'q'
0000341C  4440                              bcc     loc_345E:8
0000341E  fb07                              mov.b   #7, r3l
00003420  ae65                              cmp.b   #0x65, r6l ; 'e'
00003422  443a                              bcc     loc_345E:8
00003424  fb08                              mov.b   #8, r3l
00003426  ae61                              cmp.b   #0x61, r6l ; 'a'
00003428  4434                              bcc     loc_345E:8
0000342A  fb09                              mov.b   #9, r3l
0000342C  ae50                              cmp.b   #0x50, r6l ; 'P'
0000342E  442e                              bcc     loc_345E:8
00003430  f302                              mov.b   #2, r3h
00003432  fb01                              mov.b   #1, r3l
00003434  ae41                              cmp.b   #0x41, r6l ; 'A'
00003436  4426                              bcc     loc_345E:8
00003438  fb02                              mov.b   #2, r3l
0000343A  ae40                              cmp.b   #0x40, r6l ; '@'
0000343C  4420                              bcc     loc_345E:8
0000343E  fb03                              mov.b   #3, r3l
00003440  ae39                              cmp.b   #0x39, r6l ; '9'
00003442  441a                              bcc     loc_345E:8
00003444  fb04                              mov.b   #4, r3l
00003446  ae38                              cmp.b   #0x38, r6l ; '8'
00003448  4414                              bcc     loc_345E:8
0000344A  fb05                              mov.b   #5, r3l
0000344C  ae37                              cmp.b   #0x37, r6l ; '7'
0000344E  440e                              bcc     loc_345E:8
00003450  fb06                              mov.b   #6, r3l
00003452  ae36                              cmp.b   #0x36, r6l ; '6'
00003454  4408                              bcc     loc_345E:8
00003456  fb07                              mov.b   #7, r3l
00003458  ae35                              cmp.b   #0x35, r6l ; '5'
0000345A  4402                              bcc     loc_345E:8
0000345C  fb09                              mov.b   #9, r3l
0000345E  01006b83a9bc             loc_345E mov.l   er3, @0xFFFFA9BC:16
00003464  5470                     locret_3464 rts
00003466  fc00                     sub_3466 mov.b   #0, r4l  ; <<< FUNC sub_3466
00003468  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
0000346A  7fa07050                          bset    #5, @0xFFFFFFA0:8
0000346E  7ea07350                 loc_346E btst    #5, @0xFFFFFFA0:8
00003472  46fa                              bne     loc_346E:8
00003474  7fa07270                          bclr    #7, @0xFFFFFFA0:8
00003478  2c90                              mov.b   @0xFFFFFF90:8, r4l
0000347A  f400                              mov.b   #0, r4h
0000347C  79061ae6                          mov.w   #0x1AE6, r6
00003480  5246                              mulxu.w r4, er6
00003482  5e03fa2c                          jsr     sub_3FA2C:24
00003486  0de6                              mov.w   e6, r6
00003488  e60f                              and.b   #0xF, r6h
0000348A  79260090                          cmp.w   #0x90, r6
0000348E  5470                              rts
00003490  7a0100000000             sub_3490 mov.l   #0, er1  ; <<< FUNC sub_3490
00003496  6e1aa998                 loc_3496 mov.b   @(-0x5668:16,er1), r2l
0000349A  6e12a9a0                          mov.b   @(-0x5660:16,er1), r2h
0000349E  1ca2                              cmp.b   r2l, r2h
000034A0  4738                              beq     loc_34DA:8
000034A2  6e9aa9a0                          mov.b   r2l, @(-0x5660:16,er1)
000034A6  7f5a7250                          bclr    #5, @0xFFFFFF5A:8
000034AA  6e12356c                          mov.b   @(0x356C:16,er1), r2h
000034AE  1052                              shll.w  #2, r2
000034B0  1052                              shll.w  #2, r2
000034B2  fe0c                              mov.b   #0xC, r6l
000034B4  7f5a7210                 loc_34B4 bclr    #1, @0xFFFFFF5A:8
000034B8  0000                              nop
000034BA  0000                              nop
000034BC  1012                              shll.w  r2
000034BE  7f5a6700                          bst     #0, @0xFFFFFF5A:8
000034C2  0000                              nop
000034C4  0000                              nop
000034C6  7f5a7010                          bset    #1, @0xFFFFFF5A:8
000034CA  1a0e                              dec.b   r6l
000034CC  46e6                              bne     loc_34B4:8
000034CE  7f5a7200                          bclr    #0, @0xFFFFFF5A:8
000034D2  7f5a7050                          bset    #5, @0xFFFFFF5A:8
000034D6  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
000034DA  0a09                     loc_34DA inc.b   r1l
000034DC  a908                              cmp.b   #8, r1l
000034DE  45b6                              bcs     loc_3496:8
000034E0  7a0100000000             sub_34E0 mov.l   #0, er1  ; <<< FUNC sub_34E0
000034E6  6e1aa9a8                 loc_34E6 mov.b   @(-0x5658:16,er1), r2l
000034EA  6e12a9b0                          mov.b   @(-0x5650:16,er1), r2h
000034EE  1ca2                              cmp.b   r2l, r2h
000034F0  4738                              beq     loc_352A:8
000034F2  6e9aa9b0                          mov.b   r2l, @(-0x5650:16,er1)
000034F6  7f5a7240                          bclr    #4, @0xFFFFFF5A:8
000034FA  6e12356c                          mov.b   @(0x356C:16,er1), r2h
000034FE  1052                              shll.w  #2, r2
00003500  1052                              shll.w  #2, r2
00003502  fe0c                              mov.b   #0xC, r6l
00003504  7f5a7210                 loc_3504 bclr    #1, @0xFFFFFF5A:8
00003508  0000                              nop
0000350A  0000                              nop
0000350C  1012                              shll.w  r2
0000350E  7f5a6700                          bst     #0, @0xFFFFFF5A:8
00003512  0000                              nop
00003514  0000                              nop
00003516  7f5a7010                          bset    #1, @0xFFFFFF5A:8
0000351A  1a0e                              dec.b   r6l
0000351C  46e6                              bne     loc_3504:8
0000351E  7f5a7200                          bclr    #0, @0xFFFFFF5A:8
00003522  7f5a7040                          bset    #4, @0xFFFFFF5A:8
00003526  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0000352A  0a09                     loc_352A inc.b   r1l
0000352C  a908                              cmp.b   #8, r1l
0000352E  45b6                              bcs     loc_34E6:8
00003530  5470                              rts
00003532  6a8ca9a4                          mov.b   r4l, @0xFFFFA9A4:16
00003536  7f5a7250                          bclr    #5, @0xFFFFFF5A:8
0000353A  f40a                              mov.b   #0xA, r4h
0000353C  1054                              shll.w  #2, r4
0000353E  1054                              shll.w  #2, r4
00003540  790c000c                          mov.w   #0xC, e4
00003544  7f5a7210                 loc_3544 bclr    #1, @0xFFFFFF5A:8
00003548  0000                              nop
0000354A  0000                              nop
0000354C  1014                              shll.w  r4
0000354E  7f5a6700                          bst     #0, @0xFFFFFF5A:8
00003552  0000                              nop
00003554  0000                              nop
00003556  7f5a7010                          bset    #1, @0xFFFFFF5A:8
0000355A  1b5c                              dec.w   #1, e4
0000355C  46e6                              bne     loc_3544:8
0000355E  7f5a7200                          bclr    #0, @0xFFFFFF5A:8
