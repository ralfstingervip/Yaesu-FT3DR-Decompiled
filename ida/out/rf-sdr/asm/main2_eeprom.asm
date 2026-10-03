; ==== eeprom  0003E800-0003ED00 ====
0003E800  a412                              cmp.b   #0x12, r4h
0003E802  4502                              bcs     loc_3E806:8
0003E804  7064                              bset    #6, r4h
0003E806  7074                     loc_3E806 bset    #7, r4h
0003E808  707c                              bset    #7, r4l
0003E80A  fb00                              mov.b   #0, r3l
0003E80C  6a8ba9cc                          mov.b   r3l, @0xFFFFA9CC:16
0003E810  6a84a9cd                          mov.b   r4h, @0xFFFFA9CD:16
0003E814  6a8ca9ce                          mov.b   r4l, @0xFFFFA9CE:16
0003E818  fe03                              mov.b   #3, r6l
0003E81A  fa68                              mov.b   #0x68, r2l ; 'h'
0003E81C  7a0500ffa9cc                      mov.l   #0xFFA9CC, er5
0003E822  5e03e90a                          jsr     sub_3E90A:24
0003E826  5470                              rts
0003E828  fe06                     sub_3E828 mov.b   #6, r6l  ; <<< FUNC sub_3E828
0003E82A  fa65                              mov.b   #0x65, r2l ; 'e'
0003E82C  01006df5                          push.l  er5
0003E830  5e03e864                          jsr     sub_3E864:24
0003E834  01006d75                          pop.l   er5
0003E838  6e5c0002                          mov.b   @(2:16,er5), r4l
0003E83C  ec3f                              and.b   #0x3F, r4l
0003E83E  6edc0002                          mov.b   r4l, @(2:16,er5)
0003E842  6e5c0004                          mov.b   @(4:16,er5), r4l
0003E846  ec3f                              and.b   #0x3F, r4l
0003E848  6edc0004                          mov.b   r4l, @(4:16,er5)
0003E84C  fc00                              mov.b   #0, r4l
0003E84E  6edc0006                          mov.b   r4l, @(6:16,er5)
0003E852  6a8ca505                          mov.b   r4l, @0xFFFFA505:16
0003E856  6a8cb1c4                          mov.b   r4l, @0xFFFFB1C4:16
0003E85A  6a8cba3d                          mov.b   r4l, @0xFFFFBA3D:16
0003E85E  6a8cbadb                          mov.b   r4l, @0xFFFFBADB:16
0003E862  5470                              rts
0003E864  7f5a7010                 sub_3E864 bset    #1, @0xFFFFFF5A:8  ; <<< FUNC sub_3E864
0003E868  7f5d7040                          bset    #4, @0xFFFFFF5D:8
0003E86C  7f5d7050                          bset    #5, @0xFFFFFF5D:8
0003E870  0000                              nop
0003E872  0000                              nop
0003E874  0000                              nop
0003E876  0000                              nop
0003E878  0000                              nop
0003E87A  f608                              mov.b   #8, r6h
0003E87C  100a                     loc_3E87C shll.b  r2l
0003E87E  7f5d6740                          bst     #4, @0xFFFFFF5D:8
0003E882  0000                              nop
0003E884  0000                              nop
0003E886  0000                              nop
0003E888  0000                              nop
0003E88A  0000                              nop
0003E88C  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0003E890  0000                              nop
0003E892  0000                              nop
0003E894  0000                              nop
0003E896  0000                              nop
0003E898  0000                              nop
0003E89A  7f5a7010                          bset    #1, @0xFFFFFF5A:8
0003E89E  1a06                              dec.b   r6h
0003E8A0  46da                              bne     loc_3E87C:8
0003E8A2  fce3                              mov.b   #0xE3, r4l
0003E8A4  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
0003E8A8  0000                              nop
0003E8AA  0000                              nop
0003E8AC  0000                              nop
0003E8AE  0000                              nop
0003E8B0  0000                              nop
0003E8B2  f608                     loc_3E8B2 mov.b   #8, r6h
0003E8B4  7f5a7210                 loc_3E8B4 bclr    #1, @0xFFFFFF5A:8
0003E8B8  0000                              nop
0003E8BA  0000                              nop
0003E8BC  0000                              nop
0003E8BE  0000                              nop
0003E8C0  0000                              nop
0003E8C2  7f5a7010                          bset    #1, @0xFFFFFF5A:8
0003E8C6  0000                              nop
0003E8C8  0000                              nop
0003E8CA  0000                              nop
0003E8CC  0000                              nop
0003E8CE  0000                              nop
0003E8D0  7e4d7740                          bld     #4, @0xFFFFFF4D:8
0003E8D4  130b                              rotxr.b r3l
0003E8D6  1a06                              dec.b   r6h
0003E8D8  46da                              bne     loc_3E8B4:8
0003E8DA  68db                              mov.b   r3l, @er5
0003E8DC  0b05                              adds    #1, er5
0003E8DE  1a0e                              dec.b   r6l
0003E8E0  46d0                              bne     loc_3E8B2:8
0003E8E2  7f5d7250                          bclr    #5, @0xFFFFFF5D:8
0003E8E6  0000                              nop
0003E8E8  0000                              nop
0003E8EA  0000                              nop
0003E8EC  0000                              nop
0003E8EE  0000                              nop
0003E8F0  fcf3                              mov.b   #0xF3, r4l
0003E8F2  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
0003E8F6  0000                              nop
0003E8F8  0000                              nop
0003E8FA  0000                              nop
0003E8FC  0000                              nop
0003E8FE  0000                              nop
0003E900  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0003E904  7f5d7240                          bclr    #4, @0xFFFFFF5D:8
0003E908  5470                              rts
0003E90A  7f5a7010                 sub_3E90A bset    #1, @0xFFFFFF5A:8  ; <<< FUNC sub_3E90A
0003E90E  7f5d7040                          bset    #4, @0xFFFFFF5D:8
0003E912  7f5d7050                          bset    #5, @0xFFFFFF5D:8
0003E916  0000                              nop
0003E918  0000                              nop
0003E91A  0000                              nop
0003E91C  0000                              nop
0003E91E  0000                              nop
0003E920  f608                              mov.b   #8, r6h
0003E922  100a                     loc_3E922 shll.b  r2l
0003E924  7f5d6740                          bst     #4, @0xFFFFFF5D:8
0003E928  0000                              nop
0003E92A  0000                              nop
0003E92C  0000                              nop
0003E92E  0000                              nop
0003E930  0000                              nop
0003E932  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0003E936  0000                              nop
0003E938  0000                              nop
0003E93A  0000                              nop
0003E93C  0000                              nop
0003E93E  0000                              nop
0003E940  7f5a7010                          bset    #1, @0xFFFFFF5A:8
0003E944  1a06                              dec.b   r6h
0003E946  46da                              bne     loc_3E922:8
0003E948  6c5a                     loc_3E948 mov.b   @er5+, r2l
0003E94A  f608                              mov.b   #8, r6h
0003E94C  110a                     loc_3E94C shlr.b  r2l
0003E94E  7f5d6740                          bst     #4, @0xFFFFFF5D:8
0003E952  0000                              nop
0003E954  0000                              nop
0003E956  0000                              nop
0003E958  0000                              nop
0003E95A  0000                              nop
0003E95C  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0003E960  0000                              nop
0003E962  0000                              nop
0003E964  0000                              nop
0003E966  0000                              nop
0003E968  0000                              nop
0003E96A  7f5a7010                          bset    #1, @0xFFFFFF5A:8
0003E96E  1a06                              dec.b   r6h
0003E970  46da                              bne     loc_3E94C:8
0003E972  1a0e                              dec.b   r6l
0003E974  46d2                              bne     loc_3E948:8
0003E976  7f5d7250                          bclr    #5, @0xFFFFFF5D:8
0003E97A  0000                              nop
0003E97C  0000                              nop
0003E97E  0000                              nop
0003E980  0000                              nop
0003E982  0000                              nop
0003E984  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0003E988  7f5d7240                          bclr    #4, @0xFFFFFF5D:8
0003E98C  5470                              rts
0003E98E  01                       unk_3E98E .byte    1
0003E98F  0203                     loc_3E98F stc.b   ccr, r3h
0003E991  0419                     loc_3E991 orc     #0x19, ccr
0003E993  01                                .byte    1
0003E994  01                                .byte    1
0003E995  01                                .byte    1
0003E996  0000                              nop
0003E998  0000                              nop
0003E99A  6a0ab3e8                 sub_3E99A mov.b   @0xFFFFB3E8:16, r2l  ; <<< FUNC sub_3E99A
0003E99E  6a18b3e87270                      bclr    #7, @0xFFFFB3E8:16
0003E9A4  6a18b3e87260                      bclr    #6, @0xFFFFB3E8:16
0003E9AA  6a0cb3e9                          mov.b   @0xFFFFB3E9:16, r4l
0003E9AE  4618                              bne     loc_3E9C8:8
0003E9B0  6a18b3e87000                      bset    #0, @0xFFFFB3E8:16
0003E9B6  737a                              btst    #7, r2l
0003E9B8  470c                              beq     locret_3E9C6:8
0003E9BA  fc32                              mov.b   #0x32, r4l ; '2'
0003E9BC  6a8c9566                          mov.b   r4l, @0xFFFF9566:16
0003E9C0  fc01                              mov.b   #1, r4l
0003E9C2  6a8cb3e9                          mov.b   r4l, @0xFFFFB3E9:16
0003E9C6  5470                     locret_3E9C6 rts
0003E9C8  737a                     loc_3E9C8 btst    #7, r2l
0003E9CA  4612                              bne     loc_3E9DE:8
0003E9CC  736a                              btst    #6, r2l
0003E9CE  470e                              beq     loc_3E9DE:8
0003E9D0  6a18b3e87000                      bset    #0, @0xFFFFB3E8:16
0003E9D6  fc00                              mov.b   #0, r4l
0003E9D8  6a8cb3e9                          mov.b   r4l, @0xFFFFB3E9:16
0003E9DC  4018                              bra     locret_3E9F6:8
0003E9DE  6a0c9566                 loc_3E9DE mov.b   @0xFFFF9566:16, r4l
0003E9E2  4612                              bne     locret_3E9F6:8
0003E9E4  6a18b3e87100                      bnot    #0, @0xFFFFB3E8:16
0003E9EA  6a18817e7010                      bset    #1, @0xFFFF817E:16
0003E9F0  fc32                              mov.b   #0x32, r4l ; '2'
0003E9F2  6a8c9566                          mov.b   r4l, @0xFFFF9566:16
0003E9F6  5470                     locret_3E9F6 rts
0003E9F8  5e0020f6                 sub_3E9F8 jsr     sub_20F6:24  ; <<< FUNC sub_3E9F8
0003E9FC  6a188ea07260             sub_3E9FC bclr    #6, @0xFFFF8EA0:16  ; <<< FUNC sub_3E9FC
0003EA02  6a18817e7200                      bclr    #0, @0xFFFF817E:16
0003EA08  01006b008122                      mov.l   @0xFFFF8122:16, er0
0003EA0E  01006b80812a                      mov.l   er0, @0xFFFF812A:16
0003EA14  5e039598                          jsr     sub_39598:24
0003EA18  5e039566                          jsr     sub_39566:24
0003EA1C  5e0069a8                          jsr     nullsub_4:24
0003EA20  6a18aa357220                      bclr    #2, @0xFFFFAA35:16
0003EA26  4008                              bra     loc_3EA30:8
0003EA28  5e007806                 sub_3EA28 jsr     nullsub_5:24  ; <<< FUNC sub_3EA28
0003EA2C  5e056046                          jsr     sub_56046:24
0003EA30  5e02f578                 loc_3EA30 jsr     sub_2F578:24
0003EA34  5e02f550                          jsr     sub_2F550:24
0003EA38  5e031072                          jsr     sub_31072:24
0003EA3C  5e03104a                          jsr     sub_3104A:24
0003EA40  5e03ec50                          jsr     sub_3EC50:24
0003EA44  7f5b7030                          bset    #3, @0xFFFFFF5B:8
0003EA48  7f5b7020                          bset    #2, @0xFFFFFF5B:8
0003EA4C  7f5d7210                          bclr    #1, @0xFFFFFF5D:8
0003EA50  7f5d7200                          bclr    #0, @0xFFFFFF5D:8
0003EA54  6a10aa357320                      btst    #2, @0xFFFFAA35:16
0003EA5A  4604                              bne     loc_3EA60:8
0003EA5C  7f527270                          bclr    #7, @0xFFFFFF52:8
0003EA60  fd00                     loc_3EA60 mov.b   #0, r5l
0003EA62  5e030aee                          jsr     sub_30AEE:24
0003EA66  fd00                              mov.b   #0, r5l
0003EA68  5e032430                          jsr     sub_32430:24
0003EA6C  fc0a                              mov.b   #0xA, r4l
0003EA6E  6a8c9534                          mov.b   r4l, @0xFFFF9534:16
0003EA72  6a8c9535                          mov.b   r4l, @0xFFFF9535:16
0003EA76  fc32                              mov.b   #0x32, r4l ; '2'
0003EA78  6a8c9561                          mov.b   r4l, @0xFFFF9561:16
0003EA7C  fc28                              mov.b   #0x28, r4l ; '('
0003EA7E  6a8ca999                          mov.b   r4l, @0xFFFFA999:16
0003EA82  5e003490                          jsr     sub_3490:24
0003EA86  5e03ec3c                          jsr     sub_3EC3C:24
0003EA8A  6a18817b7050                      bset    #5, @0xFFFF817B:16
0003EA90  5e037a56                          jsr     sub_37A56:24
0003EA94  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0003EA98  5e003466                          jsr     sub_3466:24
0003EA9C  58500134                          bcs     locret_3EBD4:16
0003EAA0  5e003576                 loc_3EAA0 jsr     sub_3576:24
0003EAA4  6a0c9561                          mov.b   @0xFFFF9561:16, r4l
0003EAA8  46f6                              bne     loc_3EAA0:8
0003EAAA  fc00                              mov.b   #0, r4l
0003EAAC  6a8ca9dd                          mov.b   r4l, @0xFFFFA9DD:16
0003EAB0  6a8ca9de                          mov.b   r4l, @0xFFFFA9DE:16
0003EAB4  fb04                              mov.b   #4, r3l
0003EAB6  5e00694a                          jsr     sub_694A:24
0003EABA  fcfe                              mov.b   #0xFE, r4l
0003EABC  6a8c9590                          mov.b   r4l, @0xFFFF9590:16
0003EAC0  5e003466                 loc_3EAC0 jsr     sub_3466:24
0003EAC4  5850010c                          bcs     locret_3EBD4:16
0003EAC8  5e003576                          jsr     sub_3576:24
0003EACC  7e427360                          btst    #6, @0xFFFFFF42:8
0003EAD0  471a                              beq     loc_3EAEC:8
0003EAD2  6a0c9590                          mov.b   @0xFFFF9590:16, r4l
0003EAD6  46e8                              bne     loc_3EAC0:8
0003EAD8  fb03                              mov.b   #3, r3l
0003EADA  5e00694a                          jsr     sub_694A:24
0003EADE  5e003466                 loc_3EADE jsr     sub_3466:24
0003EAE2  585000ee                          bcs     locret_3EBD4:16
0003EAE6  7e427360                          btst    #6, @0xFFFFFF42:8
0003EAEA  46f2                              bne     loc_3EADE:8
0003EAEC  5e003466                 loc_3EAEC jsr     sub_3466:24
0003EAF0  585000e0                          bcs     locret_3EBD4:16
0003EAF4  6a10aa357320                      btst    #2, @0xFFFFAA35:16
0003EAFA  4604                              bne     loc_3EB00:8
0003EAFC  7f527270                          bclr    #7, @0xFFFFFF52:8
0003EB00  79040e10                 loc_3EB00 mov.w   #0xE10, r4
0003EB04  6b8495f6                          mov.w   r4, @0xFFFF95F6:16
0003EB08  79049ab0                          mov.w   #0x9AB0, r4
0003EB0C  6b8495f4                          mov.w   r4, @0xFFFF95F4:16
0003EB10  fc01                              mov.b   #1, r4l
0003EB12  6a8ca9dd                          mov.b   r4l, @0xFFFFA9DD:16
0003EB16  fb00                              mov.b   #0, r3l
0003EB18  5e00694a                          jsr     sub_694A:24
0003EB1C  fc00                              mov.b   #0, r4l
0003EB1E  6a8ca9df                          mov.b   r4l, @0xFFFFA9DF:16
0003EB22  5e003466                 loc_3EB22 jsr     sub_3466:24
0003EB26  585000aa                          bcs     locret_3EBD4:16
0003EB2A  5e003576                          jsr     sub_3576:24
0003EB2E  5e03ebd6                          jsr     sub_3EBD6:24
0003EB32  7e427360                          btst    #6, @0xFFFFFF42:8
0003EB36  4616                              bne     loc_3EB4E:8
0003EB38  6a10a9df7300                      btst    #0, @0xFFFFA9DF:16
0003EB3E  4706                              beq     loc_3EB46:8
0003EB40  6a18a9df7010                      bset    #1, @0xFFFFA9DF:16
0003EB46  6a18a9df7220             loc_3EB46 bclr    #2, @0xFFFFA9DF:16
0003EB4C  4026                              bra     loc_3EB74:8
0003EB4E  6a10a9df7320             loc_3EB4E btst    #2, @0xFFFFA9DF:16
0003EB54  470c                              beq     loc_3EB62:8
0003EB56  6a0c9590                          mov.b   @0xFFFF9590:16, r4l
0003EB5A  472e                              beq     loc_3EB8A:8
0003EB5C  5e03ec06                          jsr     sub_3EC06:24
0003EB60  4012                              bra     loc_3EB74:8
0003EB62  6a18a9df7000             loc_3EB62 bset    #0, @0xFFFFA9DF:16
0003EB68  6a18a9df7020                      bset    #2, @0xFFFFA9DF:16
0003EB6E  fc3c                              mov.b   #0x3C, r4l ; '<'
0003EB70  6a8c9590                          mov.b   r4l, @0xFFFF9590:16
0003EB74  6b0495f4                 loc_3EB74 mov.w   @0xFFFF95F4:16, r4
0003EB78  46a8                              bne     loc_3EB22:8
0003EB7A  6a0ca9df                          mov.b   @0xFFFFA9DF:16, r4l
0003EB7E  ec03                              and.b   #3, r4l
0003EB80  ac03                              cmp.b   #3, r4l
0003EB82  479e                              beq     loc_3EB22:8
0003EB84  f300                              mov.b   #0, r3h
0003EB86  fb02                              mov.b   #2, r3l
0003EB88  4038                              bra     loc_3EBC2:8
0003EB8A  6a10a9df7370             loc_3EB8A btst    #7, @0xFFFFA9DF:16
0003EB90  4622                              bne     loc_3EBB4:8
0003EB92  fc00                              mov.b   #0, r4l
0003EB94  6a8ca9df                          mov.b   r4l, @0xFFFFA9DF:16
0003EB98  6a18a9df7070                      bset    #7, @0xFFFFA9DF:16
0003EB9E  6a18a9df7000                      bset    #0, @0xFFFFA9DF:16
0003EBA4  6a18a9df7020                      bset    #2, @0xFFFFA9DF:16
0003EBAA  fc3c                              mov.b   #0x3C, r4l ; '<'
0003EBAC  6a8c9590                          mov.b   r4l, @0xFFFF9590:16
0003EBB0  5800ff6e                          bra     loc_3EB22:16
0003EBB4  f30a                     loc_3EBB4 mov.b   #0xA, r3h
0003EBB6  fb01                              mov.b   #1, r3l
0003EBB8  6a0ca9df                          mov.b   @0xFFFFA9DF:16, r4l
0003EBBC  ec03                              and.b   #3, r4l
0003EBBE  ac03                              cmp.b   #3, r4l
0003EBC0  4700                              beq     loc_3EBC2:8
0003EBC2  6a83a9dd                 loc_3EBC2 mov.b   r3h, @0xFFFFA9DD:16
0003EBC6  5e00694a                          jsr     sub_694A:24
0003EBCA  7f527070                          bset    #7, @0xFFFFFF52:8
0003EBCE  5e003466                 loc_3EBCE jsr     sub_3466:24
0003EBD2  44fa                              bcc     loc_3EBCE:8
0003EBD4  5470                     locret_3EBD4 rts
0003EBD6  6a0ca9de                 sub_3EBD6 mov.b   @0xFFFFA9DE:16, r4l  ; <<< FUNC sub_3EBD6
0003EBDA  ac01                              cmp.b   #1, r4l
0003EBDC  4726                              beq     locret_3EC04:8
0003EBDE  6a0ca9dd                          mov.b   @0xFFFFA9DD:16, r4l
0003EBE2  ac08                              cmp.b   #8, r4l
0003EBE4  441e                              bcc     locret_3EC04:8
0003EBE6  6b0495f6                          mov.w   @0xFFFF95F6:16, r4
0003EBEA  4618                              bne     locret_3EC04:8
0003EBEC  79040e10                          mov.w   #0xE10, r4
0003EBF0  6b8495f6                          mov.w   r4, @0xFFFF95F6:16
0003EBF4  6a0ca9dd                          mov.b   @0xFFFFA9DD:16, r4l
0003EBF8  0a0c                              inc.b   r4l
0003EBFA  6a8ca9dd                          mov.b   r4l, @0xFFFFA9DD:16
0003EBFE  fb00                              mov.b   #0, r3l
0003EC00  5e00694a                          jsr     sub_694A:24
0003EC04  5470                     locret_3EC04 rts
0003EC06  fc01                     sub_3EC06 mov.b   #1, r4l  ; <<< FUNC sub_3EC06
0003EC08  6a8ca9de                          mov.b   r4l, @0xFFFFA9DE:16
0003EC0C  f302                              mov.b   #2, r3h
0003EC0E  fb2a                              mov.b   #0x2A, r3l ; '*'
0003EC10  fc03                              mov.b   #3, r4l
0003EC12  f608                              mov.b   #8, r6h
0003EC14  6a0e9590                          mov.b   @0xFFFF9590:16, r6l
0003EC18  1cbe                     loc_3EC18 cmp.b   r3l, r6l
0003EC1A  4408                              bcc     loc_3EC24:8
0003EC1C  0a03                              inc.b   r3h
0003EC1E  18cb                              sub.b   r4l, r3l
0003EC20  1a06                              dec.b   r6h
0003EC22  46f4                              bne     loc_3EC18:8
0003EC24  a30a                     loc_3EC24 cmp.b   #0xA, r3h
0003EC26  4712                              beq     locret_3EC3A:8
0003EC28  6a0ca9dd                          mov.b   @0xFFFFA9DD:16, r4l
0003EC2C  1cc3                              cmp.b   r4l, r3h
0003EC2E  450a                              bcs     locret_3EC3A:8
0003EC30  6a83a9dd                          mov.b   r3h, @0xFFFFA9DD:16
0003EC34  fb00                              mov.b   #0, r3l
0003EC36  5e00694a                          jsr     sub_694A:24
0003EC3A  5470                     locret_3EC3A rts
0003EC3C  5e038160                 sub_3EC3C jsr     sub_38160:24  ; <<< FUNC sub_3EC3C
0003EC40  7f5d7210                          bclr    #1, @0xFFFFFF5D:8
0003EC44  7f5d7200                          bclr    #0, @0xFFFFFF5D:8
0003EC48  6a18fba57260                      bclr    #6, @0xFFFFFBA5:16
0003EC4E  5470                              rts
0003EC50  0480                     sub_3EC50 orc     #0x80, ccr  ; <<< FUNC sub_3EC50
0003EC52  6a18ee2d7220                      bclr    #2, @0xFFFFEE2D:16
0003EC58  fc00                              mov.b   #0, r4l
0003EC5A  6a8cee04                          mov.b   r4l, @0xFFFFEE04:16
0003EC5E  6a8cee05                          mov.b   r4l, @0xFFFFEE05:16
0003EC62  6a8cee06                          mov.b   r4l, @0xFFFFEE06:16
0003EC66  fc00                              mov.b   #0, r4l
0003EC68  3c69                              mov.b   r4l, @0xFFFFFF69:8
0003EC6A  fc64                              mov.b   #0x64, r4l ; 'd'
0003EC6C  0000                     loc_3EC6C nop
0003EC6E  0000                              nop
0003EC70  0000                              nop
0003EC72  0000                              nop
0003EC74  0000                              nop
0003EC76  0000                              nop
0003EC78  0000                              nop
0003EC7A  0000                              nop
0003EC7C  0000                              nop
0003EC7E  0000                              nop
0003EC80  0000                              nop
0003EC82  0000                              nop
0003EC84  0000                              nop
0003EC86  0000                              nop
0003EC88  0000                              nop
0003EC8A  0000                              nop
0003EC8C  1a0c                              dec.b   r4l
0003EC8E  46dc                              bne     loc_3EC6C:8
0003EC90  fc1f                              mov.b   #0x1F, r4l
0003EC92  3c6a                              mov.b   r4l, @0xFFFFFF6A:8
0003EC94  79045cf4                          mov.w   #0x5CF4, r4
0003EC98  6b84fdc8                          mov.w   r4, @0xFFFFFDC8:16
0003EC9C  7904ffff                          mov.w   #0xFFFF, r4
0003ECA0  6b84fdca                          mov.w   r4, @0xFFFFFDCA:16
0003ECA4  79048d00                          mov.w   #0x8D00, r4
0003ECA8  6b84fdcc                          mov.w   r4, @0xFFFFFDCC:16
0003ECAC  5e00284e                          jsr     sub_284E:24
0003ECB0  5e0446be                          jsr     sub_446BE:24
0003ECB4  067f                              andc    #0x7F, ccr
0003ECB6  5470                              rts
0003ECB8  6a0c800f                 loc_3ECB8 mov.b   @0xFFFF800F:16, r4l
0003ECBC  f401                              mov.b   #1, r4h
0003ECBE  4702                              beq     locret_3ECC2:8
0003ECC0  ac00                              cmp.b   #0, r4l
0003ECC2  5470                     locret_3ECC2 rts
0003ECC4  6a0c800f                          mov.b   @0xFFFF800F:16, r4l
0003ECC8  f401                              mov.b   #1, r4h
0003ECCA  4706                              beq     locret_3ECD2:8
0003ECCC  ac00                              cmp.b   #0, r4l
0003ECCE  4702                              beq     locret_3ECD2:8
0003ECD0  ac06                              cmp.b   #6, r4l
0003ECD2  5470                     locret_3ECD2 rts
0003ECD4  6a0c800f                 loc_3ECD4 mov.b   @0xFFFF800F:16, r4l
0003ECD8  f401                              mov.b   #1, r4h
0003ECDA  ac01                              cmp.b   #1, r4l
0003ECDC  5470                              rts
0003ECDE  6a0c800f                 loc_3ECDE mov.b   @0xFFFF800F:16, r4l
0003ECE2  f401                              mov.b   #1, r4h
0003ECE4  ac02                              cmp.b   #2, r4l
0003ECE6  4508                              bcs     loc_3ECF0:8
0003ECE8  ac05                              cmp.b   #5, r4l
0003ECEA  4404                              bcc     loc_3ECF0:8
0003ECEC  fc00                              mov.b   #0, r4l
0003ECEE  4002                              bra     locret_3ECF2:8
0003ECF0  fc01                     loc_3ECF0 mov.b   #1, r4l
0003ECF2  5470                     locret_3ECF2 rts
0003ECF4  01006df5                 loc_3ECF4 push.l  er5
0003ECF8  01006df6                          push.l  er6
0003ECFC  fb11                              mov.b   #0x11, r3l
0003ECFE  7a050003ed22                      mov.l   #dword_3ED22, er5
