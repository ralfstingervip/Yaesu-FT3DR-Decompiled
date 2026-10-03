; ==== func sub_C814  0000C814-0000C8BC ====
0000C814  6a10ac097310             sub_C814   btst    #1, @0xFFFFAC09:16  ; <<< FUNC sub_C814
0000C81A  4650                     loc_C81A   bne     loc_C86C:8
0000C81C  7a050000c8bc                        mov.l   #0xC8BC, er5
0000C822  6d54                                mov.w   @er5+, r4
0000C824  01006b06bc2c             loc_C824   mov.l   @0xFFFFBC2C:16, er6
0000C82A  7a1600000004                        add.l   #4, er6
0000C830  7bd4598f                 loc_C830   eepmov.w
0000C834  0d44                     loc_C834   mov.w   r4, r4
0000C836  46f8                                bne     loc_C830:8
0000C838  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C83E  7a1600000004                        add.l   #4, er6
0000C844  0fe1                                mov.l   er6, er1
0000C846  6a0dac07                 loc_C846   mov.b   @0xFFFFAC07:16, r5l
0000C84A  f500                                mov.b   #0, r5h
0000C84C  0a0d                                inc.b   r5l
0000C84E  1b06                                subs    #1, er6
0000C850  5e00d24c                            jsr     sub_D24C:24
0000C854  6a0cac08                            mov.b   @0xFFFFAC08:16, r4l
0000C858  7a64000000ff                        and.l   #0xFF, er4
0000C85E  78406a2c0000c8d4                    mov.b   @(0xC8D4:32,er4), r4l
0000C866  6e9c000a                            mov.b   r4l, @(0xA:16,er1)
0000C86A  403e                                bra     loc_C8AA:8
0000C86C  7a050000c8ca             loc_C86C   mov.l   #0xC8CA, er5
0000C872  6d54                                mov.w   @er5+, r4
0000C874  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C87A  7a1600000004                        add.l   #4, er6
0000C880  7bd4598f                 loc_C880   eepmov.w
0000C884  0d44                                mov.w   r4, r4
0000C886  46f8                                bne     loc_C880:8
0000C888  01006b06bc2c                        mov.l   @0xFFFFBC2C:16, er6
0000C88E  7a1600000004                        add.l   #4, er6
0000C894  6a0cac08                            mov.b   @0xFFFFAC08:16, r4l
0000C898  7a64000000ff                        and.l   #0xFF, er4
0000C89E  78406a2c0000c8d4                    mov.b   @(0xC8D4:32,er4), r4l
0000C8A6  6eec0006                            mov.b   r4l, @(6:16,er6)
0000C8AA  01006b06bc2c             loc_C8AA   mov.l   @0xFFFFBC2C:16, er6
0000C8B0  7a1600000000                        add.l   #0, er6
0000C8B6  fc02                                mov.b   #2, r4l
0000C8B8  68ec                                mov.b   r4l, @er6
0000C8BA  5470                                rts

; ==== func sub_25EAE  00025EAE-0002611A ====
00025EAE  7a0200ff1ad1             sub_25EAE  mov.l   #0xFF1AD1, er2  ; <<< FUNC sub_25EAE
00025EB4  6c2c                                mov.b   @er2+, r4l
00025EB6  ac46                                cmp.b   #0x46, r4l ; 'F'
00025EB8  477a                                beq     loc_25F34:8
00025EBA  ac30                                cmp.b   #0x30, r4l ; '0'
00025EBC  5860026c                            bne     loc_2612C:16
00025EC0  5e04b812                            jsr     sub_4B812:24
00025EC4  58b00264                            bmi     loc_2612C:16
00025EC8  7a0200ff1ad5                        mov.l   #0xFF1AD5, er2
00025ECE  6c2c                                mov.b   @er2+, r4l
00025ED0  ac2e                                cmp.b   #0x2E, r4l ; '.'
00025ED2  58600256                            bne     loc_2612C:16
00025ED6  5e04b812                            jsr     sub_4B812:24
00025EDA  58b0024e                            bmi     loc_2612C:16
00025EDE  7a0100ffb392                        mov.l   #0xFFB392, er1
00025EE4  7a0200ff1ad2                        mov.l   #0xFF1AD2, er2
00025EEA  5e025bac                            jsr     sub_25BAC:24
00025EEE  fc30                                mov.b   #0x30, r4l ; '0'
00025EF0  6c2e                                mov.b   @er2+, r6l
00025EF2  18ce                                sub.b   r4l, r6l
00025EF4  ee0f                                and.b   #0xF, r6l
00025EF6  fd0a                                mov.b   #0xA, r5l
00025EF8  50d6                                mulxu.b r5l, r6
00025EFA  682d                                mov.b   @er2, r5l
00025EFC  18cd                                sub.b   r4l, r5l
00025EFE  ed0f                                and.b   #0xF, r5l
00025F00  08de                                add.b   r5l, r6l
00025F02  7a66000000ff                        and.l   #0xFF, er6
00025F08  1036                                shll.l  er6
00025F0A  78606b2500025be2                    mov.w   @(loc_25BE2:32,er6), r5
00025F12  6b85b394                            mov.w   r5, @0xFFFFB394:16
00025F16  78606b2500025caa                    mov.w   @(loc_25CAA:32,er6), r5
00025F1E  6a8db39b                            mov.b   r5l, @0xFFFFB39B:16
00025F22  01006b05b392                        mov.l   @0xFFFFB392:16, er5
00025F28  5e03f522                            jsr     sub_3F522:24
00025F2C  586001fc                            bne     loc_2612C:16
00025F30  5e026172                            jsr     sub_26172:24
00025F34  6a2c00ff1adb             loc_25F34  mov.b   @0xFF1ADB:32, r4l
00025F3A  ac46                                cmp.b   #0x46, r4l ; 'F'
00025F3C  587000b6                            beq     loc_25FF6:16
00025F40  ac2b                                cmp.b   #0x2B, r4l ; '+'
00025F42  4704                                beq     loc_25F48:8
00025F44  ac2d                                cmp.b   #0x2D, r4l ; '-'
00025F46  4676                                bne     loc_25FBE:8
00025F48  790c0009                 loc_25F48  mov.w   #9, e4
00025F4C  7a0500ff1adc                        mov.l   #0xFF1ADC, er5
00025F52  7a0600026130                        mov.l   #loc_26130, er6
00025F58  6c54                     loc_25F58  mov.b   @er5+, r4h
00025F5A  6c6c                                mov.b   @er6+, r4l
00025F5C  1c4c                                cmp.b   r4h, r4l
00025F5E  4606                                bne     loc_25F66:8
00025F60  1b5c                                dec.w   #1, e4
00025F62  46f4                                bne     loc_25F58:8
00025F64  4058                                bra     loc_25FBE:8
00025F66  7a0200ff1adb             loc_25F66  mov.l   #0xFF1ADB, er2
00025F6C  6c2c                                mov.b   @er2+, r4l
00025F6E  fb02                                mov.b   #2, r3l
00025F70  ac2b                                cmp.b   #0x2B, r4l ; '+'
00025F72  4702                                beq     loc_25F76:8
00025F74  fb01                                mov.b   #1, r3l
00025F76  6a8bb39c                 loc_25F76  mov.b   r3l, @0xFFFFB39C:16
00025F7A  5e04b812                            jsr     sub_4B812:24
00025F7E  4b3e                                bmi     loc_25FBE:8
00025F80  7a0200ff1adf                        mov.l   #0xFF1ADF, er2
00025F86  6c2c                                mov.b   @er2+, r4l
00025F88  ac2e                                cmp.b   #0x2E, r4l ; '.'
00025F8A  4632                                bne     loc_25FBE:8
00025F8C  5e04b812                            jsr     sub_4B812:24
00025F90  4b2c                                bmi     loc_25FBE:8
00025F92  7a0100ffb396                        mov.l   #0xFFB396, er1
00025F98  7a0200ff1adc                        mov.l   #0xFF1ADC, er2
00025F9E  5e025bac                            jsr     sub_25BAC:24
00025FA2  fc30                                mov.b   #0x30, r4l ; '0'
00025FA4  6c26                                mov.b   @er2+, r6h
00025FA6  18c6                                sub.b   r4l, r6h
00025FA8  1046                                shll.b  #2, r6h
00025FAA  1046                                shll.b  #2, r6h
00025FAC  6c2e                                mov.b   @er2+, r6l
00025FAE  18ce                                sub.b   r4l, r6l
00025FB0  ee0f                                and.b   #0xF, r6l
00025FB2  146e                                or.b    r6h, r6l
00025FB4  689e                                mov.b   r6l, @er1
00025FB6  0b01                                adds    #1, er1
00025FB8  fc00                                mov.b   #0, r4l
00025FBA  689c                                mov.b   r4l, @er1
00025FBC  4012                                bra     loc_25FD0:8
00025FBE  fc00                     loc_25FBE  mov.b   #0, r4l
00025FC0  6a8cb39c                            mov.b   r4l, @0xFFFFB39C:16
00025FC4  7a0400000000                        mov.l   #0, er4
00025FCA  01006b84b396                        mov.l   er4, @0xFFFFB396:16
00025FD0  5e034e82                 loc_25FD0  jsr     sub_34E82:24
00025FD4  58600154                            bne     loc_2612C:16
00025FD8  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
00025FDC  4b0a                                bmi     loc_25FE8:8
00025FDE  5e025d72                            jsr     sub_25D72:24
00025FE2  58600146                            bne     loc_2612C:16
00025FE6  400e                                bra     loc_25FF6:8
00025FE8  01006b05b392             loc_25FE8  mov.l   @0xFFFFB392:16, er5
00025FEE  5e03f522                            jsr     sub_3F522:24
00025FF2  58600136                            bne     loc_2612C:16
00025FF6  6a2c00ff1ae5             loc_25FF6  mov.b   @0xFF1AE5:32, r4l
00025FFC  ac46                                cmp.b   #0x46, r4l ; 'F'
00025FFE  471c                                beq     loc_2601C:8
00026000  ac30                                cmp.b   #0x30, r4l ; '0'
00026002  4706                                beq     loc_2600A:8
00026004  ac31                                cmp.b   #0x31, r4l ; '1'
00026006  4702                                beq     loc_2600A:8
00026008  fc30                                mov.b   #0x30, r4l ; '0'
0002600A  6a048dde                 loc_2600A  mov.b   @0xFFFF8DDE:16, r4h
0002600E  4b0c                                bmi     loc_2601C:8
00026010  770c                                bld     #0, r4l
00026012  6e0c0012                            mov.b   @(0x12:16,er0), r4l
00026016  675c                                bst     #5, r4l
00026018  6e8c0012                            mov.b   r4l, @(0x12:16,er0)
0002601C  6a2c00ff1ae6             loc_2601C  mov.b   @0xFF1AE6:32, r4l
00026022  ac46                                cmp.b   #0x46, r4l ; 'F'
00026024  471e                                beq     loc_26044:8
00026026  ac31                                cmp.b   #0x31, r4l ; '1'
00026028  470c                                beq     loc_26036:8
0002602A  fb02                                mov.b   #2, r3l
0002602C  ac32                                cmp.b   #0x32, r4l ; '2'
0002602E  4708                                beq     loc_26038:8
00026030  fb03                                mov.b   #3, r3l
00026032  ac33                                cmp.b   #0x33, r4l ; '3'
00026034  4702                                beq     loc_26038:8
00026036  fb00                     loc_26036  mov.b   #0, r3l
00026038  fb00                     loc_26038  mov.b   #0, r3l
0002603A  6a0c8dde                            mov.b   @0xFFFF8DDE:16, r4l
0002603E  4b04                                bmi     loc_26044:8
00026040  6e8b0016                            mov.b   r3l, @(0x16:16,er0)
00026044  7a0200ff1ae7             loc_26044  mov.l   #0xFF1AE7, er2
0002604A  682c                                mov.b   @er2, r4l
0002604C  ac46                                cmp.b   #0x46, r4l ; 'F'
0002604E  472a                                beq     loc_2607A:8
00026050  5e02613e                            jsr     sub_2613E:24
00026054  4618                                bne     loc_2606E:8
00026056  fe00                                mov.b   #0, r6l
00026058  7a050000585a                        mov.l   #0x585A, er5
0002605E  6d54                     loc_2605E  mov.w   @er5+, r4
00026060  1154                                shlr.w  #2, r4
00026062  1154                                shlr.w  #2, r4
00026064  1d34                                cmp.w   r3, r4
00026066  4708                                beq     loc_26070:8
00026068  0a0e                                inc.b   r6l
0002606A  ae32                                cmp.b   #0x32, r6l ; '2'
0002606C  45f0                                bcs     loc_2605E:8
0002606E  fe0c                     loc_2606E  mov.b   #0xC, r6l
00026070  6a0c8dde                 loc_26070  mov.b   @0xFFFF8DDE:16, r4l
00026074  4b04                                bmi     loc_2607A:8
00026076  6e8e0017                            mov.b   r6l, @(0x17:16,er0)
0002607A  7a0200ff1aea             loc_2607A  mov.l   #0xFF1AEA, er2
00026080  682c                                mov.b   @er2, r4l
00026082  ac46                                cmp.b   #0x46, r4l ; 'F'
00026084  4726                                beq     loc_260AC:8
00026086  5e02613e                            jsr     sub_2613E:24
0002608A  4614                                bne     loc_260A0:8
0002608C  fe00                                mov.b   #0, r6l
0002608E  7a0500005072                        mov.l   #0x5072, er5
00026094  6d54                     loc_26094  mov.w   @er5+, r4
00026096  1d34                                cmp.w   r3, r4
00026098  4708                                beq     loc_260A2:8
0002609A  0a0e                                inc.b   r6l
0002609C  ae68                                cmp.b   #0x68, r6l ; 'h'
0002609E  45f4                                bcs     loc_26094:8
000260A0  fe00                     loc_260A0  mov.b   #0, r6l
000260A2  6a0c8dde                 loc_260A2  mov.b   @0xFFFF8DDE:16, r4l
000260A6  4b04                                bmi     loc_260AC:8
000260A8  6e8e0018                            mov.b   r6l, @(0x18:16,er0)
000260AC  6a2c00ff1aed             loc_260AC  mov.b   @0xFF1AED:32, r4l
000260B2  ac46                                cmp.b   #0x46, r4l ; 'F'
000260B4  4710                                beq     loc_260C6:8
000260B6  ac30                                cmp.b   #0x30, r4l ; '0'
000260B8  4706                                beq     loc_260C0:8
000260BA  ac31                                cmp.b   #0x31, r4l ; '1'
000260BC  4702                                beq     loc_260C0:8
000260BE  fc30                                mov.b   #0x30, r4l ; '0'
000260C0  ec01                     loc_260C0  and.b   #1, r4l
000260C2  6a8cb3d3                            mov.b   r4l, @0xFFFFB3D3:16
000260C6  7a0200ff1aee             loc_260C6  mov.l   #0xFF1AEE, er2
000260CC  682c                                mov.b   @er2, r4l
000260CE  ac46                                cmp.b   #0x46, r4l ; 'F'
000260D0  4712                                beq     loc_260E4:8
000260D2  6c23                                mov.b   @er2+, r3h
000260D4  682b                                mov.b   @er2, r3l
000260D6  5e06cb40                            jsr     sub_6CB40:24
000260DA  ab80                                cmp.b   #0x80, r3l
000260DC  4502                                bcs     loc_260E0:8
000260DE  fb00                                mov.b   #0, r3l
000260E0  6a8bb3d4                 loc_260E0  mov.b   r3l, @0xFFFFB3D4:16
000260E4  6a2c00ff1af0             loc_260E4  mov.b   @0xFF1AF0:32, r4l
000260EA  ac46                                cmp.b   #0x46, r4l ; 'F'
000260EC  4724                                beq     loc_26112:8
000260EE  ac30                                cmp.b   #0x30, r4l ; '0'
000260F0  4504                                bcs     loc_260F6:8
000260F2  ac34                                cmp.b   #0x34, r4l ; '4'
000260F4  4502                                bcs     loc_260F8:8
000260F6  fc33                     loc_260F6  mov.b   #0x33, r4l ; '3'
000260F8  6a0e8dde                 loc_260F8  mov.b   @0xFFFF8DDE:16, r6l
000260FC  4b14                                bmi     loc_26112:8
000260FE  ec03                                and.b   #3, r4l
00026100  7a64000000ff                        and.l   #0xFF, er4
00026106  78406a2c0002613a                    mov.b   @(loc_2613A:32,er4), r4l
0002610E  6e8c0013                            mov.b   r4l, @(0x13:16,er0)
00026112  fc31                     loc_26112  mov.b   #0x31, r4l ; '1'
00026114  6aac00ff1b11                        mov.b   r4l, @0xFF1B11:32

; ==== func sub_34BCA  00034BCA-00034C1A ====
00034BCA  55fc                     sub_34BCA  bsr     nullsub_29:8  ; <<< FUNC sub_34BCA
00034BCC  5e0356c8                            jsr     loc_356C8:24
00034BD0  5e03ef6e                            jsr     sub_3EF6E:24
00034BD4  6e0b0017                            mov.b   @(0x17:16,er0), r3l
00034BD8  ac07                                cmp.b   #7, r4l
00034BDA  4616                                bne     loc_34BF2:8
00034BDC  fc32                                mov.b   #0x32, r4l ; '2'
00034BDE  6a8c9579                            mov.b   r4l, @0xFFFF9579:16
00034BE2  6a0b896a                            mov.b   @0xFFFF896A:16, r3l
00034BE6  6a10aad17370                        btst    #7, @0xFFFFAAD1:16
00034BEC  4704                                beq     loc_34BF2:8
00034BEE  6a0b896b                            mov.b   @0xFFFF896B:16, r3l
00034BF2  7a63000000ff             loc_34BF2  and.l   #0xFF, er3
00034BF8  1033                                shll.l  er3
00034BFA  78306b2400035158                    mov.w   @((loc_35157+1):32,er3), r4
00034C02  6b84aab4                            mov.w   r4, @0xFFFFAAB4:16
00034C06  79040000                            mov.w   #0, r4
00034C0A  6b84aab2                            mov.w   r4, @0xFFFFAAB2:16
00034C0E  6a18aad27070                        bset    #7, @0xFFFFAAD2:16
00034C14  5e0351d6                            jsr     sub_351D6:24
00034C18  5470                                rts

; ==== func sub_502D2  000502D2-000503A0 ====
000502D2  01006b05a526             sub_502D2  mov.l   @0xFFFFA526:16, er5  ; <<< FUNC sub_502D2
000502D8  6c56                                mov.b   @er5+, r6h
000502DA  6c5e                                mov.b   @er5+, r6l
000502DC  0d6e                                mov.w   r6, e6
000502DE  6c56                                mov.b   @er5+, r6h
000502E0  6c5e                                mov.b   @er5+, r6l
000502E2  01006b86a52a                        mov.l   er6, @0xFFFFA52A:16
000502E8  6c54                                mov.b   @er5+, r4h
000502EA  6c5c                                mov.b   @er5+, r4l
000502EC  6b84a52e                            mov.w   r4, @0xFFFFA52E:16
000502F0  790c0006                            mov.w   #6, e4
000502F4  7a05000503a0                        mov.l   #loc_503A0, er5
000502FA  6d54                     loc_502FA  mov.w   @er5+, r4
000502FC  1de4                                cmp.w   e6, r4
000502FE  5870009c                            beq     locret_5039E:16
00050302  1b5c                                dec.w   #1, e4
00050304  46f4                                bne     loc_502FA:8
00050306  790c000b                            mov.w   #0xB, e4
0005030A  7a05000503ac                        mov.l   #loc_503AC, er5
00050310  6d54                     loc_50310  mov.w   @er5+, r4
00050312  1de4                                cmp.w   e6, r4
00050314  4608                                bne     loc_5031E:8
00050316  6854                                mov.b   @er5, r4h
00050318  1c64                                cmp.b   r6h, r4h
0005031A  58700080                            beq     locret_5039E:16
0005031E  0b85                     loc_5031E  adds    #2, er5
00050320  1b5c                                dec.w   #1, e4
00050322  46ec                                bne     loc_50310:8
00050324  790c0006                            mov.w   #6, e4
00050328  7a05000503d8                        mov.l   #(loc_503D7+1), er5
0005032E  6d54                     loc_5032E  mov.w   @er5+, r4
00050330  1de4                                cmp.w   e6, r4
00050332  4606                                bne     loc_5033A:8
00050334  6954                                mov.w   @er5, r4
00050336  1d64                                cmp.w   r6, r4
00050338  4764                                beq     locret_5039E:8
0005033A  0b85                     loc_5033A  adds    #2, er5
0005033C  1b5c                                dec.w   #1, e4
0005033E  46ee                                bne     loc_5032E:8
00050340  790c0002                            mov.w   #2, e4
00050344  7a05000503f0                        mov.l   #loc_503F0, er5
0005034A  6d54                     loc_5034A  mov.w   @er5+, r4
0005034C  1de4                                cmp.w   e6, r4
0005034E  4612                                bne     loc_50362:8
00050350  6954                                mov.w   @er5, r4
00050352  1d64                                cmp.w   r6, r4
00050354  460c                                bne     loc_50362:8
00050356  6e540002                            mov.b   @(2:16,er5), r4h
0005035A  6a0ca52e                            mov.b   @0xFFFFA52E:16, r4l
0005035E  1c4c                                cmp.b   r4h, r4l
00050360  473c                                beq     locret_5039E:8
00050362  0b95                     loc_50362  adds    #4, er5
00050364  1b5c                                dec.w   #1, e4
00050366  46e2                                bne     loc_5034A:8
00050368  790c0001                            mov.w   #1, e4
0005036C  7a05000503fc                        mov.l   #loc_503FC, er5
00050372  6d54                     loc_50372  mov.w   @er5+, r4
00050374  1de4                                cmp.w   e6, r4
00050376  461e                                bne     loc_50396:8
00050378  6954                                mov.w   @er5, r4
0005037A  1d64                                cmp.w   r6, r4
0005037C  4618                                bne     loc_50396:8
0005037E  6e540002                            mov.b   @(2:16,er5), r4h
00050382  6a0ca52e                            mov.b   @0xFFFFA52E:16, r4l
00050386  1c4c                                cmp.b   r4h, r4l
00050388  460c                                bne     loc_50396:8
0005038A  6e540003                            mov.b   @(3:16,er5), r4h
0005038E  6a0ca52f                            mov.b   @0xFFFFA52F:16, r4l
00050392  1c4c                                cmp.b   r4h, r4l
00050394  4708                                beq     locret_5039E:8
00050396  0b95                     loc_50396  adds    #4, er5
00050398  1b5c                                dec.w   #1, e4
0005039A  46d6                                bne     loc_50372:8
0005039C  fbff                                mov.b   #0xFF, r3l
0005039E  5470                     locret_5039E rts

; ==== func sub_5A7F2  0005A7F2-0005AE1E ====
0005A7F2  fc09                     sub_5A7F2  mov.b   #9, r4l  ; <<< FUNC sub_5A7F2
0005A7F4  f400                                mov.b   #0, r4h
0005A7F6  7a050005ae28                        mov.l   #loc_5AE28, er5
0005A7FC  7a0600ff2dc8                        mov.l   #0xFF2DC8, er6
0005A802  7bd4598f                 loc_5A802  eepmov.w
0005A806  0d44                                mov.w   r4, r4
0005A808  46f8                                bne     loc_5A802:8
0005A80A  7a0500ffb0e0                        mov.l   #0xFFB0E0, er5
0005A810  6a0c8c28                            mov.b   @0xFFFF8C28:16, r4l
0005A814  ac03                                cmp.b   #3, r4l
0005A816  58700572                            beq     loc_5AD8C:16
0005A81A  ac05                                cmp.b   #5, r4l
0005A81C  5870056c                            beq     loc_5AD8C:16
0005A820  f32c                                mov.b   #0x2C, r3h ; ','
0005A822  7a0100000000                        mov.l   #0, er1
0005A828  0f92                                mov.l   er1, er2
0005A82A  685c                                mov.b   @er5, r4l
0005A82C  aca0                                cmp.b   #0xA0, r4l
0005A82E  4780                                beq     loc_5A7B0:8
0005A830  aca6                                cmp.b   #0xA6, r4l
0005A832  58700098                            beq     loc_5A8CE:16
0005A836  aca7                                cmp.b   #0xA7, r4l
0005A838  58700092                            beq     loc_5A8CE:16
0005A83C  aca8                                cmp.b   #0xA8, r4l
0005A83E  58700106                            beq     loc_5A948:16
0005A842  aca9                                cmp.b   #0xA9, r4l
0005A844  58700390                            beq     loc_5ABD8:16
0005A848  acaa                                cmp.b   #0xAA, r4l
0005A84A  5870038a                            beq     loc_5ABD8:16
0005A84E  ac9c                                cmp.b   #0x9C, r4l
0005A850  4764                                beq     loc_5A8B6:8
0005A852  ac9e                                cmp.b   #0x9E, r4l
0005A854  4768                                beq     loc_5A8BE:8
0005A856  acab                                cmp.b   #0xAB, r4l
0005A858  476c                                beq     loc_5A8C6:8
0005A85A  acb6                                cmp.b   #0xB6, r4l
0005A85C  4770                                beq     loc_5A8CE:8
0005A85E  acb7                                cmp.b   #0xB7, r4l
0005A860  476c                                beq     loc_5A8CE:8
0005A862  acb8                                cmp.b   #0xB8, r4l
0005A864  587000e0                            beq     loc_5A948:16
0005A868  acb9                                cmp.b   #0xB9, r4l
0005A86A  5870036a                            beq     loc_5ABD8:16
0005A86E  acba                                cmp.b   #0xBA, r4l
0005A870  58700364                            beq     loc_5ABD8:16
0005A874  acbb                                cmp.b   #0xBB, r4l
0005A876  474e                                beq     loc_5A8C6:8
0005A878  ac90                                cmp.b   #0x90, r4l
0005A87A  5870ff2a                            beq     loc_5A7A8:16
0005A87E  ac9f                                cmp.b   #0x9F, r4l
0005A880  58600508                            bne     loc_5AD8C:16
0005A884  f404                                mov.b   #4, r4h
0005A886  6c59                     loc_5A886  mov.b   @er5+, r1l
0005A888  0c9a                                mov.b   r1l, r2l
0005A88A  1149                                shlr.b  #2, r1l
0005A88C  1149                                shlr.b  #2, r1l
0005A88E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A892  68ec                                mov.b   r4l, @er6
0005A894  0b06                                adds    #1, er6
0005A896  ea0f                                and.b   #0xF, r2l
0005A898  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A89C  68ec                                mov.b   r4l, @er6
0005A89E  0b06                                adds    #1, er6
0005A8A0  1a04                                dec.b   r4h
0005A8A2  46e2                                bne     loc_5A886:8
0005A8A4  fc0d                                mov.b   #0xD, r4l
0005A8A6  68ec                                mov.b   r4l, @er6
0005A8A8  0b06                                adds    #1, er6
0005A8AA  fc0a                                mov.b   #0xA, r4l
0005A8AC  68ec                                mov.b   r4l, @er6
0005A8AE  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A8B4  5470                                rts
0005A8B6  7a030005af34             loc_5A8B6  mov.l   #sub_5AF34, er3
0005A8BC  5470                                rts
0005A8BE  7a030005af4c             loc_5A8BE  mov.l   #loc_5AF4C, er3
0005A8C4  5470                                rts
0005A8C6  7a030005af5e             loc_5A8C6  mov.l   #loc_5AF5E, er3
0005A8CC  5470                                rts
0005A8CE  f401                     loc_5A8CE  mov.b   #1, r4h
0005A8D0  6c59                     loc_5A8D0  mov.b   @er5+, r1l
0005A8D2  0c9a                                mov.b   r1l, r2l
0005A8D4  1149                                shlr.b  #2, r1l
0005A8D6  1149                                shlr.b  #2, r1l
0005A8D8  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A8DC  68ec                                mov.b   r4l, @er6
0005A8DE  0b06                                adds    #1, er6
0005A8E0  ea0f                                and.b   #0xF, r2l
0005A8E2  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A8E6  68ec                                mov.b   r4l, @er6
0005A8E8  0b06                                adds    #1, er6
0005A8EA  1a04                                dec.b   r4h
0005A8EC  46e2                                bne     loc_5A8D0:8
0005A8EE  68e3                                mov.b   r3h, @er6
0005A8F0  0b06                                adds    #1, er6
0005A8F2  f406                                mov.b   #6, r4h
0005A8F4  6c59                     loc_5A8F4  mov.b   @er5+, r1l
0005A8F6  0c9a                                mov.b   r1l, r2l
0005A8F8  1149                                shlr.b  #2, r1l
0005A8FA  1149                                shlr.b  #2, r1l
0005A8FC  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A900  68ec                                mov.b   r4l, @er6
0005A902  0b06                                adds    #1, er6
0005A904  ea0f                                and.b   #0xF, r2l
0005A906  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A90A  68ec                                mov.b   r4l, @er6
0005A90C  0b06                                adds    #1, er6
0005A90E  1a04                                dec.b   r4h
0005A910  46e2                                bne     loc_5A8F4:8
0005A912  68e3                                mov.b   r3h, @er6
0005A914  0b06                                adds    #1, er6
0005A916  fc0a                                mov.b   #0xA, r4l
0005A918  6c54                     loc_5A918  mov.b   @er5+, r4h
0005A91A  a420                                cmp.b   #0x20, r4h ; ' '
0005A91C  4504                                bcs     loc_5A922:8
0005A91E  a47f                                cmp.b   #0x7F, r4h
0005A920  4502                                bcs     loc_5A924:8
0005A922  f43f                     loc_5A922  mov.b   #0x3F, r4h ; '?'
0005A924  68e4                     loc_5A924  mov.b   r4h, @er6
0005A926  0b06                                adds    #1, er6
0005A928  1a0c                                dec.b   r4l
0005A92A  46ec                                bne     loc_5A918:8
0005A92C  68e3                                mov.b   r3h, @er6
0005A92E  0b06                                adds    #1, er6
0005A930  fc0a                                mov.b   #0xA, r4l
0005A932  6c54                     loc_5A932  mov.b   @er5+, r4h
0005A934  a420                                cmp.b   #0x20, r4h ; ' '
0005A936  4504                                bcs     loc_5A93C:8
0005A938  a47f                                cmp.b   #0x7F, r4h
0005A93A  4502                                bcs     loc_5A93E:8
0005A93C  f43f                     loc_5A93C  mov.b   #0x3F, r4h ; '?'
0005A93E  68e4                     loc_5A93E  mov.b   r4h, @er6
0005A940  0b06                                adds    #1, er6
0005A942  1a0c                                dec.b   r4l
0005A944  46ec                                bne     loc_5A932:8
0005A946  4078                                bra     loc_5A9C0:8
0005A948  f401                     loc_5A948  mov.b   #1, r4h
0005A94A  6c59                     loc_5A94A  mov.b   @er5+, r1l
0005A94C  0c9a                                mov.b   r1l, r2l
0005A94E  1149                                shlr.b  #2, r1l
0005A950  1149                                shlr.b  #2, r1l
0005A952  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A956  68ec                                mov.b   r4l, @er6
0005A958  0b06                                adds    #1, er6
0005A95A  ea0f                                and.b   #0xF, r2l
0005A95C  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A960  68ec                                mov.b   r4l, @er6
0005A962  0b06                                adds    #1, er6
0005A964  1a04                                dec.b   r4h
0005A966  46e2                                bne     loc_5A94A:8
0005A968  68e3                                mov.b   r3h, @er6
0005A96A  0b06                                adds    #1, er6
0005A96C  f406                                mov.b   #6, r4h
0005A96E  6c59                     loc_5A96E  mov.b   @er5+, r1l
0005A970  0c9a                                mov.b   r1l, r2l
0005A972  1149                                shlr.b  #2, r1l
0005A974  1149                                shlr.b  #2, r1l
0005A976  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A97A  68ec                                mov.b   r4l, @er6
0005A97C  0b06                                adds    #1, er6
0005A97E  ea0f                                and.b   #0xF, r2l
0005A980  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A984  68ec                                mov.b   r4l, @er6
0005A986  0b06                                adds    #1, er6
0005A988  1a04                                dec.b   r4h
0005A98A  46e2                                bne     loc_5A96E:8
0005A98C  68e3                                mov.b   r3h, @er6
0005A98E  0b06                                adds    #1, er6
0005A990  fc0f                                mov.b   #0xF, r4l
0005A992  6c54                     loc_5A992  mov.b   @er5+, r4h
0005A994  a420                                cmp.b   #0x20, r4h ; ' '
0005A996  4504                                bcs     loc_5A99C:8
0005A998  a47f                                cmp.b   #0x7F, r4h
0005A99A  4502                                bcs     loc_5A99E:8
0005A99C  f43f                     loc_5A99C  mov.b   #0x3F, r4h ; '?'
0005A99E  68e4                     loc_5A99E  mov.b   r4h, @er6
0005A9A0  0b06                                adds    #1, er6
0005A9A2  1a0c                                dec.b   r4l
0005A9A4  46ec                                bne     loc_5A992:8
0005A9A6  68e3                                mov.b   r3h, @er6
0005A9A8  0b06                                adds    #1, er6
0005A9AA  fc05                                mov.b   #5, r4l
0005A9AC  6c54                     loc_5A9AC  mov.b   @er5+, r4h
0005A9AE  a420                                cmp.b   #0x20, r4h ; ' '
0005A9B0  4504                                bcs     loc_5A9B6:8
0005A9B2  a47f                                cmp.b   #0x7F, r4h
0005A9B4  4502                                bcs     loc_5A9B8:8
0005A9B6  f43f                     loc_5A9B6  mov.b   #0x3F, r4h ; '?'
0005A9B8  68e4                     loc_5A9B8  mov.b   r4h, @er6
0005A9BA  0b06                                adds    #1, er6
0005A9BC  1a0c                                dec.b   r4l
0005A9BE  46ec                                bne     loc_5A9AC:8
0005A9C0  68e3                     loc_5A9C0  mov.b   r3h, @er6
0005A9C2  0b06                                adds    #1, er6
0005A9C4  68e3                                mov.b   r3h, @er6
0005A9C6  0b06                                adds    #1, er6
0005A9C8  0b95                                adds    #4, er5
0005A9CA  f401                                mov.b   #1, r4h
0005A9CC  6c59                     loc_5A9CC  mov.b   @er5+, r1l
0005A9CE  0c9a                                mov.b   r1l, r2l
0005A9D0  1149                                shlr.b  #2, r1l
0005A9D2  1149                                shlr.b  #2, r1l
0005A9D4  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005A9D8  68ec                                mov.b   r4l, @er6
0005A9DA  0b06                                adds    #1, er6
0005A9DC  ea0f                                and.b   #0xF, r2l
0005A9DE  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005A9E2  68ec                                mov.b   r4l, @er6
0005A9E4  0b06                                adds    #1, er6
0005A9E6  1a04                                dec.b   r4h
0005A9E8  46e2                                bne     loc_5A9CC:8
0005A9EA  fc0d                                mov.b   #0xD, r4l
0005A9EC  68ec                                mov.b   r4l, @er6
0005A9EE  0b06                                adds    #1, er6
0005A9F0  fc0a                                mov.b   #0xA, r4l
0005A9F2  68ec                                mov.b   r4l, @er6
0005A9F4  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005A9FA  5470                                rts
0005A9FC  f401                     loc_5A9FC  mov.b   #1, r4h
0005A9FE  6c59                     loc_5A9FE  mov.b   @er5+, r1l
0005AA00  0c9a                                mov.b   r1l, r2l
0005AA02  1149                                shlr.b  #2, r1l
0005AA04  1149                                shlr.b  #2, r1l
0005AA06  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AA0A  68ec                                mov.b   r4l, @er6
0005AA0C  0b06                                adds    #1, er6
0005AA0E  ea0f                                and.b   #0xF, r2l
0005AA10  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AA14  68ec                                mov.b   r4l, @er6
0005AA16  0b06                                adds    #1, er6
0005AA18  1a04                                dec.b   r4h
0005AA1A  46e2                                bne     loc_5A9FE:8
0005AA1C  68e3                                mov.b   r3h, @er6
0005AA1E  0b06                                adds    #1, er6
0005AA20  f406                                mov.b   #6, r4h
0005AA22  6c59                     loc_5AA22  mov.b   @er5+, r1l
0005AA24  0c9a                                mov.b   r1l, r2l
0005AA26  1149                                shlr.b  #2, r1l
0005AA28  1149                                shlr.b  #2, r1l
0005AA2A  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AA2E  68ec                                mov.b   r4l, @er6
0005AA30  0b06                                adds    #1, er6
0005AA32  ea0f                                and.b   #0xF, r2l
0005AA34  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AA38  68ec                                mov.b   r4l, @er6
0005AA3A  0b06                                adds    #1, er6
0005AA3C  1a04                                dec.b   r4h
0005AA3E  46e2                                bne     loc_5AA22:8
0005AA40  68e3                                mov.b   r3h, @er6
0005AA42  0b06                                adds    #1, er6
0005AA44  790c0004                            mov.w   #4, e4
0005AA48  fc0a                     loc_5AA48  mov.b   #0xA, r4l
0005AA4A  6c54                     loc_5AA4A  mov.b   @er5+, r4h
0005AA4C  a420                                cmp.b   #0x20, r4h ; ' '
0005AA4E  4504                                bcs     loc_5AA54:8
0005AA50  a47f                                cmp.b   #0x7F, r4h
0005AA52  4502                                bcs     loc_5AA56:8
0005AA54  f43f                     loc_5AA54  mov.b   #0x3F, r4h ; '?'
0005AA56  68e4                     loc_5AA56  mov.b   r4h, @er6
0005AA58  0b06                                adds    #1, er6
0005AA5A  1a0c                                dec.b   r4l
0005AA5C  46ec                                bne     loc_5AA4A:8
0005AA5E  68e3                                mov.b   r3h, @er6
0005AA60  0b06                                adds    #1, er6
0005AA62  1b5c                                dec.w   #1, e4
0005AA64  46e2                                bne     loc_5AA48:8
0005AA66  fc0f                                mov.b   #0xF, r4l
0005AA68  6c54                     loc_5AA68  mov.b   @er5+, r4h
0005AA6A  a420                                cmp.b   #0x20, r4h ; ' '
0005AA6C  4504                                bcs     loc_5AA72:8
0005AA6E  a47f                                cmp.b   #0x7F, r4h
0005AA70  4502                                bcs     loc_5AA74:8
0005AA72  f43f                     loc_5AA72  mov.b   #0x3F, r4h ; '?'
0005AA74  68e4                     loc_5AA74  mov.b   r4h, @er6
0005AA76  0b06                                adds    #1, er6
0005AA78  1a0c                                dec.b   r4l
0005AA7A  46ec                                bne     loc_5AA68:8
0005AA7C  68e3                                mov.b   r3h, @er6
0005AA7E  0b06                                adds    #1, er6
0005AA80  fc05                                mov.b   #5, r4l
0005AA82  6c54                     loc_5AA82  mov.b   @er5+, r4h
0005AA84  a420                                cmp.b   #0x20, r4h ; ' '
0005AA86  4504                                bcs     loc_5AA8C:8
0005AA88  a47f                                cmp.b   #0x7F, r4h
0005AA8A  4502                                bcs     loc_5AA8E:8
0005AA8C  f43f                     loc_5AA8C  mov.b   #0x3F, r4h ; '?'
0005AA8E  68e4                     loc_5AA8E  mov.b   r4h, @er6
0005AA90  0b06                                adds    #1, er6
0005AA92  1a0c                                dec.b   r4l
0005AA94  46ec                                bne     loc_5AA82:8
0005AA96  68e3                                mov.b   r3h, @er6
0005AA98  0b06                                adds    #1, er6
0005AA9A  68e3                                mov.b   r3h, @er6
0005AA9C  0b06                                adds    #1, er6
0005AA9E  7a150000001c                        add.l   #0x1C, er5
0005AAA4  f401                                mov.b   #1, r4h
0005AAA6  6c59                     loc_5AAA6  mov.b   @er5+, r1l
0005AAA8  0c9a                                mov.b   r1l, r2l
0005AAAA  1149                                shlr.b  #2, r1l
0005AAAC  1149                                shlr.b  #2, r1l
0005AAAE  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AAB2  68ec                                mov.b   r4l, @er6
0005AAB4  0b06                                adds    #1, er6
0005AAB6  ea0f                                and.b   #0xF, r2l
0005AAB8  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AABC  68ec                                mov.b   r4l, @er6
0005AABE  0b06                                adds    #1, er6
0005AAC0  1a04                                dec.b   r4h
0005AAC2  46e2                                bne     loc_5AAA6:8
0005AAC4  fc0d                                mov.b   #0xD, r4l
0005AAC6  68ec                                mov.b   r4l, @er6
0005AAC8  0b06                                adds    #1, er6
0005AACA  fc0a                                mov.b   #0xA, r4l
0005AACC  68ec                                mov.b   r4l, @er6
0005AACE  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005AAD4  5470                                rts
0005AAD6  6a0bb122                 loc_5AAD6  mov.b   @0xFFFFB122:16, r3l
0005AADA  f401                                mov.b   #1, r4h
0005AADC  6c59                     loc_5AADC  mov.b   @er5+, r1l
0005AADE  0c9a                                mov.b   r1l, r2l
0005AAE0  1149                                shlr.b  #2, r1l
0005AAE2  1149                                shlr.b  #2, r1l
0005AAE4  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AAE8  68ec                                mov.b   r4l, @er6
0005AAEA  0b06                                adds    #1, er6
0005AAEC  ea0f                                and.b   #0xF, r2l
0005AAEE  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AAF2  68ec                                mov.b   r4l, @er6
0005AAF4  0b06                                adds    #1, er6
0005AAF6  1a04                                dec.b   r4h
0005AAF8  46e2                                bne     loc_5AADC:8
0005AAFA  68e3                                mov.b   r3h, @er6
0005AAFC  0b06                                adds    #1, er6
0005AAFE  f406                                mov.b   #6, r4h
0005AB00  6c59                     loc_5AB00  mov.b   @er5+, r1l
0005AB02  0c9a                                mov.b   r1l, r2l
0005AB04  1149                                shlr.b  #2, r1l
0005AB06  1149                                shlr.b  #2, r1l
0005AB08  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AB0C  68ec                                mov.b   r4l, @er6
0005AB0E  0b06                                adds    #1, er6
0005AB10  ea0f                                and.b   #0xF, r2l
0005AB12  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AB16  68ec                                mov.b   r4l, @er6
0005AB18  0b06                                adds    #1, er6
0005AB1A  1a04                                dec.b   r4h
0005AB1C  46e2                                bne     loc_5AB00:8
0005AB1E  68e3                                mov.b   r3h, @er6
0005AB20  0b06                                adds    #1, er6
0005AB22  ab02                                cmp.b   #2, r3l
0005AB24  4428                                bcc     loc_5AB4E:8
0005AB26  f401                                mov.b   #1, r4h
0005AB28  6c59                     loc_5AB28  mov.b   @er5+, r1l
0005AB2A  0c9a                                mov.b   r1l, r2l
0005AB2C  1149                                shlr.b  #2, r1l
0005AB2E  1149                                shlr.b  #2, r1l
0005AB30  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AB34  68ec                                mov.b   r4l, @er6
0005AB36  0b06                                adds    #1, er6
0005AB38  ea0f                                and.b   #0xF, r2l
0005AB3A  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AB3E  68ec                                mov.b   r4l, @er6
0005AB40  0b06                                adds    #1, er6
0005AB42  1a04                                dec.b   r4h
0005AB44  46e2                                bne     loc_5AB28:8
0005AB46  68e3                                mov.b   r3h, @er6
0005AB48  0b06                                adds    #1, er6
0005AB4A  fb57                                mov.b   #0x57, r3l ; 'W'
0005AB4C  4002                                bra     loc_5AB50:8
0005AB4E  fb58                     loc_5AB4E  mov.b   #0x58, r3l ; 'X'
0005AB50  6c59                     loc_5AB50  mov.b   @er5+, r1l
0005AB52  a903                                cmp.b   #3, r1l
0005AB54  4714                                beq     loc_5AB6A:8
0005AB56  a920                                cmp.b   #0x20, r1l ; ' '
0005AB58  4504                                bcs     loc_5AB5E:8
0005AB5A  a97f                                cmp.b   #0x7F, r1l
0005AB5C  4502                                bcs     loc_5AB60:8
0005AB5E  f93f                     loc_5AB5E  mov.b   #0x3F, r1l ; '?'
0005AB60  68e9                     loc_5AB60  mov.b   r1l, @er6
0005AB62  0b06                                adds    #1, er6
0005AB64  1a0b                                dec.b   r3l
0005AB66  46e8                                bne     loc_5AB50:8
0005AB68  402c                                bra     loc_5AB96:8
0005AB6A  f940                     loc_5AB6A  mov.b   #0x40, r1l ; '@'
0005AB6C  68e9                                mov.b   r1l, @er6
0005AB6E  0b06                                adds    #1, er6
0005AB70  fc2c                                mov.b   #0x2C, r4l ; ','
0005AB72  68ec                                mov.b   r4l, @er6
0005AB74  0b06                                adds    #1, er6
0005AB76  f401                                mov.b   #1, r4h
0005AB78  6c59                     loc_5AB78  mov.b   @er5+, r1l
0005AB7A  0c9a                                mov.b   r1l, r2l
0005AB7C  1149                                shlr.b  #2, r1l
0005AB7E  1149                                shlr.b  #2, r1l
0005AB80  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AB84  68ec                                mov.b   r4l, @er6
0005AB86  0b06                                adds    #1, er6
0005AB88  ea0f                                and.b   #0xF, r2l
0005AB8A  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AB8E  68ec                                mov.b   r4l, @er6
0005AB90  0b06                                adds    #1, er6
0005AB92  1a04                                dec.b   r4h
0005AB94  46e2                                bne     loc_5AB78:8
0005AB96  f32c                     loc_5AB96  mov.b   #0x2C, r3h ; ','
0005AB98  68e3                                mov.b   r3h, @er6
0005AB9A  0b06                                adds    #1, er6
0005AB9C  68e3                                mov.b   r3h, @er6
0005AB9E  0b06                                adds    #1, er6
0005ABA0  7a0500ffb19d                        mov.l   #0xFFB19D, er5
0005ABA6  f401                                mov.b   #1, r4h
0005ABA8  6c59                     loc_5ABA8  mov.b   @er5+, r1l
0005ABAA  0c9a                                mov.b   r1l, r2l
0005ABAC  1149                                shlr.b  #2, r1l
0005ABAE  1149                                shlr.b  #2, r1l
0005ABB0  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ABB4  68ec                                mov.b   r4l, @er6
0005ABB6  0b06                                adds    #1, er6
0005ABB8  ea0f                                and.b   #0xF, r2l
0005ABBA  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ABBE  68ec                                mov.b   r4l, @er6
0005ABC0  0b06                                adds    #1, er6
0005ABC2  1a04                                dec.b   r4h
0005ABC4  46e2                                bne     loc_5ABA8:8
0005ABC6  fc0d                                mov.b   #0xD, r4l
0005ABC8  68ec                                mov.b   r4l, @er6
0005ABCA  0b06                                adds    #1, er6
0005ABCC  fc0a                                mov.b   #0xA, r4l
0005ABCE  68ec                                mov.b   r4l, @er6
0005ABD0  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005ABD6  5470                                rts
0005ABD8  6a0bb0e5                 loc_5ABD8  mov.b   @0xFFFFB0E5:16, r3l
0005ABDC  114b                                shlr.b  #2, r3l
0005ABDE  114b                                shlr.b  #2, r3l
0005ABE0  f401                                mov.b   #1, r4h
0005ABE2  6c59                     loc_5ABE2  mov.b   @er5+, r1l
0005ABE4  0c9a                                mov.b   r1l, r2l
0005ABE6  1149                                shlr.b  #2, r1l
0005ABE8  1149                                shlr.b  #2, r1l
0005ABEA  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ABEE  68ec                                mov.b   r4l, @er6
0005ABF0  0b06                                adds    #1, er6
0005ABF2  ea0f                                and.b   #0xF, r2l
0005ABF4  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ABF8  68ec                                mov.b   r4l, @er6
0005ABFA  0b06                                adds    #1, er6
0005ABFC  1a04                                dec.b   r4h
0005ABFE  46e2                                bne     loc_5ABE2:8
0005AC00  68e3                                mov.b   r3h, @er6
0005AC02  0b06                                adds    #1, er6
0005AC04  f406                                mov.b   #6, r4h
0005AC06  6c59                     loc_5AC06  mov.b   @er5+, r1l
0005AC08  0c9a                                mov.b   r1l, r2l
0005AC0A  1149                                shlr.b  #2, r1l
0005AC0C  1149                                shlr.b  #2, r1l
0005AC0E  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AC12  68ec                                mov.b   r4l, @er6
0005AC14  0b06                                adds    #1, er6
0005AC16  ea0f                                and.b   #0xF, r2l
0005AC18  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AC1C  68ec                                mov.b   r4l, @er6
0005AC1E  0b06                                adds    #1, er6
0005AC20  1a04                                dec.b   r4h
0005AC22  46e2                                bne     loc_5AC06:8
0005AC24  68e3                                mov.b   r3h, @er6
0005AC26  0b06                                adds    #1, er6
0005AC28  ab02                                cmp.b   #2, r3l
0005AC2A  4428                                bcc     loc_5AC54:8
0005AC2C  f401                                mov.b   #1, r4h
0005AC2E  6c59                     loc_5AC2E  mov.b   @er5+, r1l
0005AC30  0c9a                                mov.b   r1l, r2l
0005AC32  1149                                shlr.b  #2, r1l
0005AC34  1149                                shlr.b  #2, r1l
0005AC36  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AC3A  68ec                                mov.b   r4l, @er6
0005AC3C  0b06                                adds    #1, er6
0005AC3E  ea0f                                and.b   #0xF, r2l
0005AC40  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AC44  68ec                                mov.b   r4l, @er6
0005AC46  0b06                                adds    #1, er6
0005AC48  1a04                                dec.b   r4h
0005AC4A  46e2                                bne     loc_5AC2E:8
0005AC4C  68e3                                mov.b   r3h, @er6
0005AC4E  0b06                                adds    #1, er6
0005AC50  fb17                                mov.b   #0x17, r3l
0005AC52  4002                                bra     loc_5AC56:8
0005AC54  fb18                     loc_5AC54  mov.b   #0x18, r3l
0005AC56  6c59                     loc_5AC56  mov.b   @er5+, r1l
0005AC58  a903                                cmp.b   #3, r1l
0005AC5A  4714                                beq     loc_5AC70:8
0005AC5C  a920                                cmp.b   #0x20, r1l ; ' '
0005AC5E  4504                                bcs     loc_5AC64:8
0005AC60  a97f                                cmp.b   #0x7F, r1l
0005AC62  4502                                bcs     loc_5AC66:8
0005AC64  f93f                     loc_5AC64  mov.b   #0x3F, r1l ; '?'
0005AC66  68e9                     loc_5AC66  mov.b   r1l, @er6
0005AC68  0b06                                adds    #1, er6
0005AC6A  1a0b                                dec.b   r3l
0005AC6C  46e8                                bne     loc_5AC56:8
0005AC6E  402c                                bra     loc_5AC9C:8
0005AC70  f940                     loc_5AC70  mov.b   #0x40, r1l ; '@'
0005AC72  68e9                                mov.b   r1l, @er6
0005AC74  0b06                                adds    #1, er6
0005AC76  fc2c                                mov.b   #0x2C, r4l ; ','
0005AC78  68ec                                mov.b   r4l, @er6
0005AC7A  0b06                                adds    #1, er6
0005AC7C  f401                                mov.b   #1, r4h
0005AC7E  6c59                     loc_5AC7E  mov.b   @er5+, r1l
0005AC80  0c9a                                mov.b   r1l, r2l
0005AC82  1149                                shlr.b  #2, r1l
0005AC84  1149                                shlr.b  #2, r1l
0005AC86  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AC8A  68ec                                mov.b   r4l, @er6
0005AC8C  0b06                                adds    #1, er6
0005AC8E  ea0f                                and.b   #0xF, r2l
0005AC90  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AC94  68ec                                mov.b   r4l, @er6
0005AC96  0b06                                adds    #1, er6
0005AC98  1a04                                dec.b   r4h
0005AC9A  46e2                                bne     loc_5AC7E:8
0005AC9C  f32c                     loc_5AC9C  mov.b   #0x2C, r3h ; ','
0005AC9E  68e3                                mov.b   r3h, @er6
0005ACA0  0b06                                adds    #1, er6
0005ACA2  68e3                                mov.b   r3h, @er6
0005ACA4  0b06                                adds    #1, er6
0005ACA6  7a0500ffb0ff                        mov.l   #0xFFB0FF, er5
0005ACAC  f401                                mov.b   #1, r4h
0005ACAE  6c59                     loc_5ACAE  mov.b   @er5+, r1l
0005ACB0  0c9a                                mov.b   r1l, r2l
0005ACB2  1149                                shlr.b  #2, r1l
0005ACB4  1149                                shlr.b  #2, r1l
0005ACB6  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ACBA  68ec                                mov.b   r4l, @er6
0005ACBC  0b06                                adds    #1, er6
0005ACBE  ea0f                                and.b   #0xF, r2l
0005ACC0  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ACC4  68ec                                mov.b   r4l, @er6
0005ACC6  0b06                                adds    #1, er6
0005ACC8  1a04                                dec.b   r4h
0005ACCA  46e2                                bne     loc_5ACAE:8
0005ACCC  fc0d                                mov.b   #0xD, r4l
0005ACCE  68ec                                mov.b   r4l, @er6
0005ACD0  0b06                                adds    #1, er6
0005ACD2  fc0a                                mov.b   #0xA, r4l
0005ACD4  68ec                                mov.b   r4l, @er6
0005ACD6  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005ACDC  5470                                rts
0005ACDE  f401                     loc_5ACDE  mov.b   #1, r4h
0005ACE0  6c59                     loc_5ACE0  mov.b   @er5+, r1l
0005ACE2  0c9a                                mov.b   r1l, r2l
0005ACE4  1149                                shlr.b  #2, r1l
0005ACE6  1149                                shlr.b  #2, r1l
0005ACE8  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ACEC  68ec                                mov.b   r4l, @er6
0005ACEE  0b06                                adds    #1, er6
0005ACF0  ea0f                                and.b   #0xF, r2l
0005ACF2  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ACF6  68ec                                mov.b   r4l, @er6
0005ACF8  0b06                                adds    #1, er6
0005ACFA  1a04                                dec.b   r4h
0005ACFC  46e2                                bne     loc_5ACE0:8
0005ACFE  68e3                                mov.b   r3h, @er6
0005AD00  0b06                                adds    #1, er6
0005AD02  f401                                mov.b   #1, r4h
0005AD04  6c59                     loc_5AD04  mov.b   @er5+, r1l
0005AD06  0c9a                                mov.b   r1l, r2l
0005AD08  1149                                shlr.b  #2, r1l
0005AD0A  1149                                shlr.b  #2, r1l
0005AD0C  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AD10  68ec                                mov.b   r4l, @er6
0005AD12  0b06                                adds    #1, er6
0005AD14  ea0f                                and.b   #0xF, r2l
0005AD16  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AD1A  68ec                                mov.b   r4l, @er6
0005AD1C  0b06                                adds    #1, er6
0005AD1E  1a04                                dec.b   r4h
0005AD20  46e2                                bne     loc_5AD04:8
0005AD22  68e3                                mov.b   r3h, @er6
0005AD24  0b06                                adds    #1, er6
0005AD26  fb12                                mov.b   #0x12, r3l
0005AD28  6a0cb13f                            mov.b   @0xFFFFB13F:16, r4l
0005AD2C  ac01                                cmp.b   #1, r4l
0005AD2E  4702                                beq     loc_5AD32:8
0005AD30  fb06                                mov.b   #6, r3l
0005AD32  fc05                     loc_5AD32  mov.b   #5, r4l
0005AD34  6c54                     loc_5AD34  mov.b   @er5+, r4h
0005AD36  a420                                cmp.b   #0x20, r4h ; ' '
0005AD38  4504                                bcs     loc_5AD3E:8
0005AD3A  a47f                                cmp.b   #0x7F, r4h
0005AD3C  4502                                bcs     loc_5AD40:8
0005AD3E  f43f                     loc_5AD3E  mov.b   #0x3F, r4h ; '?'
0005AD40  68e4                     loc_5AD40  mov.b   r4h, @er6
0005AD42  0b06                                adds    #1, er6
0005AD44  1a0c                                dec.b   r4l
0005AD46  46ec                                bne     loc_5AD34:8
0005AD48  68e3                                mov.b   r3h, @er6
0005AD4A  0b06                                adds    #1, er6
0005AD4C  1a0b                                dec.b   r3l
0005AD4E  46e2                                bne     loc_5AD32:8
0005AD50  68e3                                mov.b   r3h, @er6
0005AD52  0b06                                adds    #1, er6
0005AD54  7a0500ffb19d                        mov.l   #0xFFB19D, er5
0005AD5A  f401                                mov.b   #1, r4h
0005AD5C  6c59                     loc_5AD5C  mov.b   @er5+, r1l
0005AD5E  0c9a                                mov.b   r1l, r2l
0005AD60  1149                                shlr.b  #2, r1l
0005AD62  1149                                shlr.b  #2, r1l
0005AD64  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005AD68  68ec                                mov.b   r4l, @er6
0005AD6A  0b06                                adds    #1, er6
0005AD6C  ea0f                                and.b   #0xF, r2l
0005AD6E  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AD72  68ec                                mov.b   r4l, @er6
0005AD74  0b06                                adds    #1, er6
0005AD76  1a04                                dec.b   r4h
0005AD78  46e2                                bne     loc_5AD5C:8
0005AD7A  fc0d                                mov.b   #0xD, r4l
0005AD7C  68ec                                mov.b   r4l, @er6
0005AD7E  0b06                                adds    #1, er6
0005AD80  fc0a                                mov.b   #0xA, r4l
0005AD82  68ec                                mov.b   r4l, @er6
0005AD84  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005AD8A  5470                                rts
0005AD8C  6a0c8c28                 loc_5AD8C  mov.b   @0xFFFF8C28:16, r4l
0005AD90  ac05                                cmp.b   #5, r4l
0005AD92  4612                                bne     loc_5ADA6:8
0005AD94  685c                                mov.b   @er5, r4l
0005AD96  ac20                                cmp.b   #0x20, r4l ; ' '
0005AD98  4704                                beq     loc_5AD9E:8
0005AD9A  aca0                                cmp.b   #0xA0, r4l
0005AD9C  4608                                bne     loc_5ADA6:8
0005AD9E  fcff                     loc_5AD9E  mov.b   #0xFF, r4l
0005ADA0  6a8cb0c3                            mov.b   r4l, @0xFFFFB0C3:16
0005ADA4  4076                                bra     locret_5AE1C:8
0005ADA6  685c                     loc_5ADA6  mov.b   @er5, r4l
0005ADA8  ac19                                cmp.b   #0x19, r4l
0005ADAA  470a                                beq     loc_5ADB6:8
0005ADAC  ac16                                cmp.b   #0x16, r4l
0005ADAE  4706                                beq     loc_5ADB6:8
0005ADB0  790c0007                            mov.w   #7, e4
0005ADB4  4004                                bra     loc_5ADBA:8
0005ADB6  790c0017                 loc_5ADB6  mov.w   #0x17, e4
0005ADBA  f32c                     loc_5ADBA  mov.b   #0x2C, r3h ; ','
0005ADBC  7a0100000000                        mov.l   #0, er1
0005ADC2  0f92                                mov.l   er1, er2
0005ADC4  f404                     loc_5ADC4  mov.b   #4, r4h
0005ADC6  6c59                     loc_5ADC6  mov.b   @er5+, r1l
0005ADC8  0c9a                                mov.b   r1l, r2l
0005ADCA  1149                                shlr.b  #2, r1l
0005ADCC  1149                                shlr.b  #2, r1l
0005ADCE  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ADD2  68ec                                mov.b   r4l, @er6
0005ADD4  0b06                                adds    #1, er6
0005ADD6  ea0f                                and.b   #0xF, r2l
0005ADD8  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005ADDC  68ec                                mov.b   r4l, @er6
0005ADDE  0b06                                adds    #1, er6
0005ADE0  1a04                                dec.b   r4h
0005ADE2  46e2                                bne     loc_5ADC6:8
0005ADE4  68e3                                mov.b   r3h, @er6
0005ADE6  0b06                                adds    #1, er6
0005ADE8  1b5c                                dec.w   #1, e4
0005ADEA  46d8                                bne     loc_5ADC4:8
0005ADEC  f404                                mov.b   #4, r4h
0005ADEE  6c59                     loc_5ADEE  mov.b   @er5+, r1l
0005ADF0  0c9a                                mov.b   r1l, r2l
0005ADF2  1149                                shlr.b  #2, r1l
0005ADF4  1149                                shlr.b  #2, r1l
0005ADF6  6e1c455c                            mov.b   @(0x455C:16,er1), r4l
0005ADFA  68ec                                mov.b   r4l, @er6
0005ADFC  0b06                                adds    #1, er6
0005ADFE  ea0f                                and.b   #0xF, r2l
0005AE00  6e2c455c                            mov.b   @(0x455C:16,er2), r4l
0005AE04  68ec                                mov.b   r4l, @er6
0005AE06  0b06                                adds    #1, er6
0005AE08  1a04                                dec.b   r4h
0005AE0A  46e2                                bne     loc_5ADEE:8
0005AE0C  fc0d                                mov.b   #0xD, r4l
0005AE0E  68ec                                mov.b   r4l, @er6
0005AE10  0b06                                adds    #1, er6
0005AE12  fc0a                                mov.b   #0xA, r4l
0005AE14  68ec                                mov.b   r4l, @er6
0005AE16  7a0300ff2dc8                        mov.l   #0xFF2DC8, er3
0005AE1C  5470                     locret_5AE1C rts

; ==== func sub_5C7DE  0005C7DE-0005C876 ====
0005C7DE  7a060005c876             sub_5C7DE  mov.l   #unk_5C876, er6  ; <<< FUNC sub_5C7DE
0005C7E4  5e03f636                            jsr     sub_3F636:24
0005C7E8  6a0cb11e                            mov.b   @0xFFFFB11E:16, r4l
0005C7EC  4644                                bne     loc_5C832:8
0005C7EE  5e05c602                            jsr     sub_5C602:24
0005C7F2  6a0cb11f                            mov.b   @0xFFFFB11F:16, r4l
0005C7F6  7a64000000ff                        and.l   #0xFF, er4
0005C7FC  78406a2b0006d1e6                    mov.b   @(loc_6D1E6:32,er4), r3l
0005C804  6a0cb0b7                            mov.b   @0xFFFFB0B7:16, r4l
0005C808  ac04                                cmp.b   #4, r4l
0005C80A  470a                                beq     loc_5C816:8
0005C80C  68eb                     loc_5C80C  mov.b   r3l, @er6
0005C80E  0b06                                adds    #1, er6
0005C810  1a0a                                dec.b   r2l
0005C812  46f8                                bne     loc_5C80C:8
0005C814  4016                                bra     loc_5C82C:8
0005C816  79040006                 loc_5C816  mov.w   #6, r4
0005C81A  7a050005d2f2                        mov.l   #unk_5D2F2, er5
0005C820  7bd4598f                 loc_5C820  eepmov.w
0005C824  0d44                                mov.w   r4, r4
0005C826  46f8                                bne     loc_5C820:8
0005C828  68eb                                mov.b   r3l, @er6
0005C82A  0b06                                adds    #1, er6
0005C82C  5e05c78e                 loc_5C82C  jsr     sub_5C78E:24
0005C830  4042                                bra     locret_5C874:8
0005C832  5e05c87c                 loc_5C832  jsr     sub_5C87C:24
0005C836  6a0cb11f                            mov.b   @0xFFFFB11F:16, r4l
0005C83A  7a64000000ff                        and.l   #0xFF, er4
0005C840  78406a2b0006d1e6                    mov.b   @(loc_6D1E6:32,er4), r3l
0005C848  6a0cb0b7                            mov.b   @0xFFFFB0B7:16, r4l
0005C84C  ac0d                                cmp.b   #0xD, r4l
0005C84E  470a                                beq     loc_5C85A:8
0005C850  68eb                     loc_5C850  mov.b   r3l, @er6
0005C852  0b06                                adds    #1, er6
0005C854  1a0a                                dec.b   r2l
0005C856  46f8                                bne     loc_5C850:8
0005C858  4016                                bra     loc_5C870:8
0005C85A  79040005                 loc_5C85A  mov.w   #5, r4
0005C85E  7a050005d2f2                        mov.l   #unk_5D2F2, er5
0005C864  7bd4598f                 loc_5C864  eepmov.w
0005C868  0d44                                mov.w   r4, r4
0005C86A  46f8                                bne     loc_5C864:8
0005C86C  68eb                                mov.b   r3l, @er6
0005C86E  0b06                                adds    #1, er6
0005C870  5e05c9e4                 loc_5C870  jsr     sub_5C9E4:24
0005C874  5470                     locret_5C874 rts

; ==== func sub_68276  00068276-00068304 ====
00068276  7a0500ff8060             sub_68276  mov.l   #0xFF8060, er5  ; <<< FUNC sub_68276
0006827C  6a0cb416                            mov.b   @0xFFFFB416:16, r4l
00068280  471c                                beq     loc_6829E:8
00068282  ac01                                cmp.b   #1, r4l
00068284  4712                                beq     loc_68298:8
00068286  ac02                                cmp.b   #2, r4l
00068288  4708                                beq     loc_68292:8
0006828A  fc00                                mov.b   #0, r4l
0006828C  6a8cb416                            mov.b   r4l, @0xFFFFB416:16
00068290  400c                                bra     loc_6829E:8
00068292  6e5c0002                 loc_68292  mov.b   @(2:16,er5), r4l
00068296  400a                                bra     loc_682A2:8
00068298  6e5c0003                 loc_68298  mov.b   @(3:16,er5), r4l
0006829C  4004                                bra     loc_682A2:8
0006829E  6e5c0004                 loc_6829E  mov.b   @(4:16,er5), r4l
000682A2  ac30                     loc_682A2  cmp.b   #0x30, r4l ; '0'
000682A4  4514                                bcs     loc_682BA:8
000682A6  ac3a                                cmp.b   #0x3A, r4l ; ':'
000682A8  4512                                bcs     loc_682BC:8
000682AA  ac41                                cmp.b   #0x41, r4l ; 'A'
000682AC  450c                                bcs     loc_682BA:8
000682AE  ac5b                                cmp.b   #0x5B, r4l ; '['
000682B0  4510                                bcs     loc_682C2:8
000682B2  ac61                                cmp.b   #0x61, r4l ; 'a'
000682B4  4504                                bcs     loc_682BA:8
000682B6  ac7b                                cmp.b   #0x7B, r4l ; '{'
000682B8  4510                                bcs     loc_682CA:8
000682BA  fc30                     loc_682BA  mov.b   #0x30, r4l ; '0'
000682BC  f430                     loc_682BC  mov.b   #0x30, r4h ; '0'
000682BE  184c                                sub.b   r4h, r4l
000682C0  400e                                bra     loc_682D0:8
000682C2  f441                     loc_682C2  mov.b   #0x41, r4h ; 'A'
000682C4  184c                                sub.b   r4h, r4l
000682C6  8c0a                                add.b   #0xA, r4l
000682C8  4006                                bra     loc_682D0:8
000682CA  f461                     loc_682CA  mov.b   #0x61, r4h ; 'a'
000682CC  184c                                sub.b   r4h, r4l
000682CE  8c24                                add.b   #0x24, r4l ; '$'
000682D0  6a04b47e                 loc_682D0  mov.b   @0xFFFFB47E:16, r4h
000682D4  084c                                add.b   r4h, r4l
000682D6  7a64000000ff                        and.l   #0xFF, er4
000682DC  78406a2b0005df52                    mov.b   @((loc_5DF51+1):32,er4), r3l
000682E4  fc24                                mov.b   #0x24, r4l ; '$'
000682E6  50c3                                mulxu.b r4l, r3
000682E8  791300fa                            add.w   #0xFA, r3
000682EC  790b0000                            mov.w   #0, e3
000682F0  0fb4                                mov.l   er3, er4
000682F2  470e                                beq     locret_68302:8
000682F4  7905000a                            mov.w   #0xA, r5
000682F8  5353                                divxu.w r5, er3
000682FA  792b0005                            cmp.w   #5, e3
000682FE  4502                                bcs     locret_68302:8
00068300  0b53                                inc.w   #1, r3
00068302  5470                     locret_68302 rts

