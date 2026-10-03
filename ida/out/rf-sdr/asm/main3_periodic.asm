; ==== periodic  00002900-00003300 ====
00002900  6b84ffc6                          mov.w   r4, @0xFFFFFFC6:16
00002904  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
00002908  724c                              bclr    #4, r4l
0000290A  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
0000290E  25c5                              mov.b   @0xFFFFFFC5:8, r5h
00002910  7345                              btst    #4, r5h
00002912  4706                              beq     loc_291A:8
00002914  0c5d                              mov.b   r5h, r5l
00002916  724d                              bclr    #4, r5l
00002918  3dc5                              mov.b   r5l, @0xFFFFFFC5:8
0000291A  01006b04811a             loc_291A mov.l   @0xFFFF811A:16, er4
00002920  5940                              jmp     @er4
00002922  01106df4                 sub_2922 stm.l   er4-er5, @-sp  ; <<< FUNC sub_2922
00002926  6b0dffe6                          mov.w   @0xFFFFFFE6:16, e5
0000292A  79040000                          mov.w   #0, r4
0000292E  6b84ffe6                          mov.w   r4, @0xFFFFFFE6:16
00002932  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
00002936  725c                              bclr    #5, r4l
00002938  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
0000293C  25e5                              mov.b   @0xFFFFFFE5:8, r5h
0000293E  7345                              btst    #4, r5h
00002940  4706                              beq     loc_2948:8
00002942  0c5d                              mov.b   r5h, r5l
00002944  724d                              bclr    #4, r5l
00002946  3de5                              mov.b   r5l, @0xFFFFFFE5:8
00002948  01006b04811e             loc_2948 mov.l   @0xFFFF811E:16, er4
0000294E  5940                              jmp     @er4
00002950  01106df4                 sub_2950 stm.l   er4-er5, @-sp  ; <<< FUNC sub_2950
00002954  7fd57200                          bclr    #0, @0xFFFFFFD5:8
00002958  6a10aad27370                      btst    #7, @0xFFFFAAD2:16
0000295E  471c                              beq     loc_297C:8
00002960  7a0500000000                      mov.l   #0, er5
00002966  6b04aab2                          mov.w   @0xFFFFAAB2:16, r4
0000296A  0c4d                              mov.b   r4h, r5l
0000296C  6e5d3656                          mov.b   @(0x3656:16,er5), r5l
00002970  3d69                              mov.b   r5l, @0xFFFFFF69:8
00002972  6b05aab4                          mov.w   @0xFFFFAAB4:16, r5
00002976  0945                              add.w   r4, r5
00002978  6b85aab2                          mov.w   r5, @0xFFFFAAB2:16
0000297C  6a10aad27320             loc_297C btst    #2, @0xFFFFAAD2:16
00002982  4740                              beq     loc_29C4:8
00002984  01006df6                          push.l  er6
00002988  7a0500000000                      mov.l   #0, er5
0000298E  6b06aaba                          mov.w   @0xFFFFAABA:16, r6
00002992  0c6d                              mov.b   r6h, r5l
00002994  6e5e3656                          mov.b   @(0x3656:16,er5), r6l
00002998  110e                              shlr.b  r6l
0000299A  6b04aabc                          mov.w   @0xFFFFAABC:16, r4
0000299E  0c4d                              mov.b   r4h, r5l
000029A0  6e563656                          mov.b   @(0x3656:16,er5), r6h
000029A4  1106                              shlr.b  r6h
000029A6  086e                              add.b   r6h, r6l
000029A8  3e68                              mov.b   r6l, @0xFFFFFF68:8
000029AA  01006b05aaba                      mov.l   @0xFFFFAABA:16, er5
000029B0  01006b06aabe                      mov.l   @0xFFFFAABE:16, er6
000029B6  09ed                              add.w   e6, e5
000029B8  0965                              add.w   r6, r5
000029BA  01006b85aaba                      mov.l   er5, @0xFFFFAABA:16
000029C0  01006d76                          pop.l   er6
000029C4  01106d75                 loc_29C4 ldm.l   @sp+, er4-er5
000029C8  5670                              rte
000029CA  6df4                     sub_29CA push.w  r4  ; <<< FUNC sub_29CA
000029CC  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
000029D0  727c                              bclr    #7, r4l
000029D2  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
000029D6  6a10817f7300                      btst    #0, @0xFFFF817F:16
000029DC  472a                              beq     loc_2A08:8
000029DE  6a0c94b9                          mov.b   @0xFFFF94B9:16, r4l
000029E2  4624                              bne     loc_2A08:8
000029E4  2c4e                              mov.b   @0xFFFFFF4E:8, r4l
000029E6  6a1081707300                      btst    #0, @0xFFFF8170:16
000029EC  4606                              bne     loc_29F4:8
000029EE  733c                              btst    #3, r4l
000029F0  470a                              beq     loc_29FC:8
000029F2  4004                              bra     loc_29F8:8
000029F4  733c                     loc_29F4 btst    #3, r4l
000029F6  4604                              bne     loc_29FC:8
000029F8  fc80                     loc_29F8 mov.b   #0x80, r4l
000029FA  4002                              bra     loc_29FE:8
000029FC  fc81                     loc_29FC mov.b   #0x81, r4l
000029FE  6a8c8171                 loc_29FE mov.b   r4l, @0xFFFF8171:16
00002A02  fc04                              mov.b   #4, r4l
00002A04  6a8c94b9                          mov.b   r4l, @0xFFFF94B9:16
00002A08  6b04fd6a                 loc_2A08 mov.w   @0xFFFFFD6A:16, r4
00002A0C  7174                              bnot    #7, r4h
00002A0E  7164                              bnot    #6, r4h
00002A10  6b84fd6a                          mov.w   r4, @0xFFFFFD6A:16
00002A14  6a1881707100                      bnot    #0, @0xFFFF8170:16
00002A1A  6d74                              pop.w   r4
00002A1C  5670                              rte
00002A1E  6df4                     sub_2A1E push.w  r4  ; <<< FUNC sub_2A1E
00002A20  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
00002A24  7224                              bclr    #2, r4h
00002A26  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
00002A2A  0480                              orc     #0x80, ccr
00002A2C  5a002050                          jmp     loc_2050:24
00002A30  6df4                     sub_2A30 push.w  r4  ; <<< FUNC sub_2A30
00002A32  6a18fef57200                      bclr    #0, @0xFFFFFEF5:16
00002A38  6a0c94b8                          mov.b   @0xFFFF94B8:16, r4l
00002A3C  4706                              beq     loc_2A44:8
00002A3E  1a0c                              dec.b   r4l
00002A40  6a8c94b8                          mov.b   r4l, @0xFFFF94B8:16
00002A44  6a0c94b9                 loc_2A44 mov.b   @0xFFFF94B9:16, r4l
00002A48  4706                              beq     loc_2A50:8
00002A4A  1a0c                              dec.b   r4l
00002A4C  6a8c94b9                          mov.b   r4l, @0xFFFF94B9:16
00002A50  6a0c94ba                 loc_2A50 mov.b   @0xFFFF94BA:16, r4l
00002A54  4706                              beq     loc_2A5C:8
00002A56  1a0c                              dec.b   r4l
00002A58  6a8c94ba                          mov.b   r4l, @0xFFFF94BA:16
00002A5C  6d74                     loc_2A5C pop.w   r4
00002A5E  5670                              rte
00002A60  6df4                     sub_2A60 push.w  r4  ; <<< FUNC sub_2A60
00002A62  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
00002A66  7224                              bclr    #2, r4h
00002A68  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
00002A6C  2c4e                              mov.b   @0xFFFFFF4E:8, r4l
00002A6E  6a1081707310                      btst    #1, @0xFFFF8170:16
00002A74  4606                              bne     loc_2A7C:8
00002A76  731c                              btst    #1, r4l
00002A78  470a                              beq     loc_2A84:8
00002A7A  4004                              bra     loc_2A80:8
00002A7C  731c                     loc_2A7C btst    #1, r4l
00002A7E  4604                              bne     loc_2A84:8
00002A80  fc80                     loc_2A80 mov.b   #0x80, r4l
00002A82  4002                              bra     loc_2A86:8
00002A84  fc81                     loc_2A84 mov.b   #0x81, r4l
00002A86  6a8cbbe3                 loc_2A86 mov.b   r4l, @0xFFFFBBE3:16
00002A8A  6b04fd68                          mov.w   @0xFFFFFD68:16, r4
00002A8E  715c                              bnot    #5, r4l
00002A90  714c                              bnot    #4, r4l
00002A92  6b84fd68                          mov.w   r4, @0xFFFFFD68:16
00002A96  6a1881707110                      bnot    #1, @0xFFFF8170:16
00002A9C  6d74                              pop.w   r4
00002A9E  5670                              rte
00002AA0  fc0a                     sub_2AA0 mov.b   #0xA, r4l  ; <<< FUNC sub_2AA0
00002AA2  6a8c9534                          mov.b   r4l, @0xFFFF9534:16
00002AA6  6a8c9535                          mov.b   r4l, @0xFFFF9535:16
00002AAA  fc32                              mov.b   #0x32, r4l ; '2'
00002AAC  6a8c9561                          mov.b   r4l, @0xFFFF9561:16
00002AB0  5e003576                 loc_2AB0 jsr     sub_3576:24
00002AB4  6a0c9561                          mov.b   @0xFFFF9561:16, r4l
00002AB8  46f6                              bne     loc_2AB0:8
00002ABA  fc00                              mov.b   #0, r4l
00002ABC  6a8c89bb                          mov.b   r4l, @0xFFFF89BB:16
00002AC0  5e00698c                          jsr     sub_698C:24
00002AC4  5e0100e4                          jsr     sub_100E4:24
00002AC8  fcff                              mov.b   #0xFF, r4l
00002ACA  6a8cad68                          mov.b   r4l, @0xFFFFAD68:16
00002ACE  01006b240001021e                  mov.l   @dword_1021E:32, er4
00002AD6  1fa4                              cmp.l   er2, er4
00002AD8  461e                              bne     loc_2AF8:8
00002ADA  fc00                              mov.b   #0, r4l
00002ADC  6a8cad68                          mov.b   r4l, @0xFFFFAD68:16
00002AE0  fc20                              mov.b   #0x20, r4l ; ' '
00002AE2  f400                              mov.b   #0, r4h
00002AE4  7a050000f6d6                      mov.l   #0xF6D6, er5
00002AEA  7a0600ffbb98                      mov.l   #0xFFBB98, er6
00002AF0  7bd4598f                 loc_2AF0 eepmov.w
00002AF4  0d44                              mov.w   r4, r4
00002AF6  46f8                              bne     loc_2AF0:8
00002AF8  fcff                     loc_2AF8 mov.b   #0xFF, r4l
00002AFA  6a8ca9ed                          mov.b   r4l, @0xFFFFA9ED:16
00002AFE  5e003576                          jsr     sub_3576:24
00002B02  5e00325a                          jsr     sub_325A:24
00002B06  5e00faf6                          jsr     loc_FAF6:24
00002B0A  6a0cad68                          mov.b   @0xFFFFAD68:16, r4l
00002B0E  acff                              cmp.b   #0xFF, r4l
00002B10  4708                              beq     loc_2B1A:8
00002B12  5e003756                          jsr     sub_3756:24
00002B16  4be0                              bmi     loc_2AF8:8
00002B18  4708                              beq     locret_2B22:8
00002B1A  fcff                     loc_2B1A mov.b   #0xFF, r4l
00002B1C  6a8cad68                          mov.b   r4l, @0xFFFFAD68:16
00002B20  40d6                              bra     loc_2AF8:8
00002B22  5470                     locret_2B22 rts
00002B24  01006b00812a             loc_2B24 mov.l   @0xFFFF812A:16, er0
00002B2A  5e0020ea                          jsr     sub_20EA:24
00002B2E  4706                              beq     loc_2B36:8
00002B30  fcc9                              mov.b   #0xC9, r4l
00002B32  5e0394d2                          jsr     sub_394D2:24
00002B36  5e07351e                 loc_2B36 jsr     sub_7351E:24
00002B3A  5e002dce                          jsr     loc_2DCE:24
00002B3E  5e002d7c                          jsr     loc_2D7C:24
00002B42  fc0a                              mov.b   #0xA, r4l
00002B44  6a8c9534                          mov.b   r4l, @0xFFFF9534:16
00002B48  6a8c9535                          mov.b   r4l, @0xFFFF9535:16
00002B4C  fc32                              mov.b   #0x32, r4l ; '2'
00002B4E  6a8c9561                          mov.b   r4l, @0xFFFF9561:16
00002B52  5e010168                          jsr     loc_10168:24
00002B56  4708                              beq     loc_2B60:8
00002B58  5e0030e0                          jsr     loc_30E0:24
00002B5C  5e0031e2                          jsr     loc_31E2:24
00002B60  5e020ec4                 loc_2B60 jsr     sub_20EC4:24
00002B64  6a10aa357350                      btst    #5, @0xFFFFAA35:16
00002B6A  463c                              bne     loc_2BA8:8
00002B6C  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002B72  01006b008122                      mov.l   @0xFFFF8122:16, er0
00002B78  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002B7E  5e02d5ba                          jsr     sub_2D5BA:24
00002B82  6a18817e7000                      bset    #0, @0xFFFF817E:16
00002B88  01006b008126                      mov.l   @0xFFFF8126:16, er0
00002B8E  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002B94  5e02e1ac                          jsr     sub_2E1AC:24
00002B98  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002B9E  7a0000ff90f0                      mov.l   #0xFF90F0, er0
00002BA4  5e033f3e                          jsr     sub_33F3E:24
00002BA8  5e010760                 loc_2BA8 jsr     sub_10760:24
00002BAC  5e02011c                          jsr     sub_2011C:24
00002BB0  5e03298a                          jsr     sub_3298A:24
00002BB4  fc00                              mov.b   #0, r4l
00002BB6  6a8c8003                          mov.b   r4l, @0xFFFF8003:16
00002BBA  5e03e772                          jsr     sub_3E772:24
00002BBE  6a0c8dde                          mov.b   @0xFFFF8DDE:16, r4l
00002BC2  58600c02                          bne     loc_37C8:16
00002BC6  fcff                     loc_2BC6 mov.b   #0xFF, r4l
00002BC8  6a8ca9ed                          mov.b   r4l, @0xFFFFA9ED:16
00002BCC  5e003576                          jsr     sub_3576:24
00002BD0  5e00325a                          jsr     sub_325A:24
00002BD4  5e0032c0                          jsr     sub_32C0:24
00002BD8  6a0c97fe                          mov.b   @0xFFFF97FE:16, r4l
00002BDC  4704                              beq     loc_2BE2:8
00002BDE  5e073930                          jsr     loc_73930:24
00002BE2  6a0c813a                 loc_2BE2 mov.b   @0xFFFF813A:16, r4l
00002BE6  4604                              bne     loc_2BEC:8
00002BE8  5e054fec                          jsr     loc_54FEC:24
00002BEC  6a0c9d2d                 loc_2BEC mov.b   @0xFFFF9D2D:16, r4l
00002BF0  4710                              beq     loc_2C02:8
00002BF2  5e04753e                          jsr     loc_4753E:24
00002BF6  6a10aa357300                      btst    #0, @0xFFFFAA35:16
00002BFC  4604                              bne     loc_2C02:8
00002BFE  5e046652                          jsr     sub_46652:24
00002C02  5e00faf6                 loc_2C02 jsr     loc_FAF6:24
00002C06  6a0c813a                          mov.b   @0xFFFF813A:16, r4l
00002C0A  461c                              bne     loc_2C28:8
00002C0C  5e06fd82                          jsr     loc_6FD82:24
00002C10  5e0545ac                          jsr     sub_545AC:24
00002C14  5e05469c                          jsr     sub_5469C:24
00002C18  5e0548be                          jsr     sub_548BE:24
00002C1C  5e05ed18                          jsr     loc_5ED18:24
00002C20  5e055b7a                          jsr     loc_55B7A:24
00002C24  5e0453a0                          jsr     sub_453A0:24
00002C28  5e01079e                 loc_2C28 jsr     sub_1079E:24
00002C2C  01006b00812a                      mov.l   @0xFFFF812A:16, er0
00002C32  6e0c0001                          mov.b   @(1:16,er0), r4l
00002C36  acec                              cmp.b   #0xEC, r4l
00002C38  587000ae                          beq     loc_2CEA:16
00002C3C  aced                              cmp.b   #0xED, r4l
00002C3E  587000a8                          beq     loc_2CEA:16
00002C42  acee                              cmp.b   #0xEE, r4l
00002C44  5870009e                          beq     loc_2CE6:16
00002C48  6a0c94c0                          mov.b   @0xFFFF94C0:16, r4l
00002C4C  ac01                              cmp.b   #1, r4l
00002C4E  4758                              beq     loc_2CA8:8
00002C50  6b04a9bc                          mov.w   @0xFFFFA9BC:16, r4
00002C54  79240087                          cmp.w   #0x87, r4
00002C58  4506                              bcs     loc_2C60:8
00002C5A  6a10aa357720                      bld     #2, @0xFFFFAA35:16
00002C60  7f526770                 loc_2C60 bst     #7, @0xFFFFFF52:8
00002C64  fc00                              mov.b   #0, r4l
00002C66  6a8c92cd                          mov.b   r4l, @0xFFFF92CD:16
00002C6A  6a108ea07370                      btst    #7, @0xFFFF8EA0:16
00002C70  470a                              beq     loc_2C7C:8
00002C72  5e002e60                          jsr     loc_2E60:24
00002C76  5e0030a2                          jsr     loc_30A2:24
00002C7A  401e                              bra     loc_2C9A:8
00002C7C  6a108ea07360             loc_2C7C btst    #6, @0xFFFF8EA0:16
00002C82  470e                              beq     loc_2C92:8
00002C84  5e02f400                          jsr     sub_2F400:24
00002C88  5e0330f0                          jsr     sub_330F0:24
00002C8C  5e0030a2                          jsr     loc_30A2:24
00002C90  4008                              bra     loc_2C9A:8
00002C92  5e030f00                 loc_2C92 jsr     sub_30F00:24
00002C96  5e002e60                          jsr     loc_2E60:24
00002C9A  5e03835e                 loc_2C9A jsr     loc_3835E:24
00002C9E  5e038b9e                          jsr     loc_38B9E:24
00002CA2  5e0340a8                          jsr     loc_340A8:24
00002CA6  401c                              bra     loc_2CC4:8
00002CA8  5e034538                 loc_2CA8 jsr     loc_34538:24
00002CAC  5e03835e                          jsr     loc_3835E:24
00002CB0  5e038b9e                          jsr     loc_38B9E:24
00002CB4  5e03505c                          jsr     loc_3505C:24
00002CB8  5e04927a                          jsr     loc_4927A:24
00002CBC  5e034eee                          jsr     loc_34EEE:24
00002CC0  5e056236                          jsr     sub_56236:24
00002CC4  5e039080                 loc_2CC4 jsr     loc_39080:24
00002CC8  5e03e682                          jsr     sub_3E682:24
00002CCC  5e003490                          jsr     sub_3490:24
00002CD0  5e03e354                          jsr     sub_3E354:24
00002CD4  5e03e60e                          jsr     sub_3E60E:24
00002CD8  5e0045f6                          jsr     loc_45F6:24
00002CDC  5526                              bsr     sub_2D04:8
00002CDE  5e033040                          jsr     sub_33040:24
00002CE2  5800fee0                          bra     loc_2BC6:16
00002CE6  5e05dcfe                 loc_2CE6 jsr     sub_5DCFE:24
00002CEA  6b04a9bc                 loc_2CEA mov.w   @0xFFFFA9BC:16, r4
00002CEE  79240087                          cmp.w   #0x87, r4
00002CF2  4506                              bcs     loc_2CFA:8
00002CF4  6a10aa357720                      bld     #2, @0xFFFFAA35:16
00002CFA  7f526770                 loc_2CFA bst     #7, @0xFFFFFF52:8
00002CFE  5e03835e                          jsr     loc_3835E:24
00002D02  40c0                              bra     loc_2CC4:8
00002D04  6a0aaa30                 sub_2D04 mov.b   @0xFFFFAA30:16, r2l  ; <<< FUNC sub_2D04
00002D08  731a                              btst    #1, r2l
00002D0A  470c                              beq     loc_2D18:8
00002D0C  6a18aa307210                      bclr    #1, @0xFFFFAA30:16
00002D12  fc00                              mov.b   #0, r4l
00002D14  6a8ca9e1                          mov.b   r4l, @0xFFFFA9E1:16
00002D18  6a0ba9e1                 loc_2D18 mov.b   @0xFFFFA9E1:16, r3l
00002D1C  7a63000000ff                      and.l   #0xFF, er3
00002D22  1073                              shll.l  #2, er3
00002D24  01006f362d2c                      mov.l   @(0x2D2C:16,er3), er6
00002D2A  5960                              jmp     @er6
00002D2C  0000                              nop
00002D2E  2d38                              mov.b   @0xFFFFFF38:8, r5l
00002D30  0000                              nop
00002D32  2d56                              mov.b   @0xFFFFFF56:8, r5l
00002D34  0000                              nop
00002D36  2d6e                              mov.b   @0xFFFFFF6E:8, r5l
00002D38  731a                              btst    #1, r2l
00002D3A  4718                              beq     locret_2D54:8
00002D3C  6a0b8993                          mov.b   @0xFFFF8993:16, r3l
00002D40  4712                              beq     locret_2D54:8
00002D42  79040708                          mov.w   #0x708, r4
00002D46  f300                              mov.b   #0, r3h
00002D48  5243                              mulxu.w r4, er3
00002D4A  6b8395f2                          mov.w   r3, @0xFFFF95F2:16
00002D4E  fc01                              mov.b   #1, r4l
00002D50  6a8ca9e1                          mov.b   r4l, @0xFFFFA9E1:16
00002D54  5470                     locret_2D54 rts
00002D56  6b0495f2                          mov.w   @0xFFFF95F2:16, r4
00002D5A  7924003d                          cmp.w   #0x3D, r4 ; '='
00002D5E  440c                              bcc     locret_2D6C:8
00002D60  fc1b                              mov.b   #0x1B, r4l
00002D62  6a8caae0                          mov.b   r4l, @0xFFFFAAE0:16
00002D66  fc02                              mov.b   #2, r4l
00002D68  6a8ca9e1                          mov.b   r4l, @0xFFFFA9E1:16
00002D6C  5470                     locret_2D6C rts
00002D6E  6b0495f2                          mov.w   @0xFFFF95F2:16, r4
00002D72  4606                              bne     locret_2D7A:8
00002D74  0480                              orc     #0x80, ccr
00002D76  5a0025ac                          jmp     loc_25AC:24
00002D7A  5470                     locret_2D7A rts
00002D7C  5e032bdc                 loc_2D7C jsr     loc_32BDC:24
00002D80  5e00ebe0                          jsr     sub_EBE0:24
00002D84  6a8b92cc                          mov.b   r3l, @0xFFFF92CC:16
00002D88  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002D8E  7a0000ff90f0                      mov.l   #0xFF90F0, er0
00002D94  5e03f3a4                          jsr     sub_3F3A4:24
00002D98  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002D9E  01006b008122                      mov.l   @0xFFFF8122:16, er0
00002DA4  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002DAA  5e03f3a4                          jsr     sub_3F3A4:24
00002DAE  6a18817e7000                      bset    #0, @0xFFFF817E:16
00002DB4  01006b008126                      mov.l   @0xFFFF8126:16, er0
00002DBA  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002DC0  5e03f3a4                          jsr     sub_3F3A4:24
00002DC4  5e010760                          jsr     sub_10760:24
00002DC8  5e03f4a2                          jsr     sub_3F4A2:24
00002DCC  5470                              rts
00002DCE  6a1889be7260             loc_2DCE bclr    #6, @0xFFFF89BE:16
00002DD4  6a1889c07240                      bclr    #4, @0xFFFF89C0:16
00002DDA  6a1889c37210                      bclr    #1, @0xFFFF89C3:16
00002DE0  fc00                              mov.b   #0, r4l
00002DE2  6a8c8eaa                          mov.b   r4l, @0xFFFF8EAA:16
00002DE6  fc00                              mov.b   #0, r4l
00002DE8  6a8c89c9                          mov.b   r4l, @0xFFFF89C9:16
00002DEC  6a188c2c7200                      bclr    #0, @0xFFFF8C2C:16
00002DF2  6a188c2c7210                      bclr    #1, @0xFFFF8C2C:16
00002DF8  fc00                              mov.b   #0, r4l
00002DFA  6a8c8cfa                          mov.b   r4l, @0xFFFF8CFA:16
00002DFE  fc00                              mov.b   #0, r4l
00002E00  6a8c8f47                          mov.b   r4l, @0xFFFF8F47:16
00002E04  6a8c904f                          mov.b   r4l, @0xFFFF904F:16
00002E08  6a8c9157                          mov.b   r4l, @0xFFFF9157:16
00002E0C  6a0c8004                          mov.b   @0xFFFF8004:16, r4l
00002E10  4704                              beq     loc_2E16:8
00002E12  ac04                              cmp.b   #4, r4l
00002E14  4506                              bcs     loc_2E1C:8
00002E16  fc00                     loc_2E16 mov.b   #0, r4l
00002E18  6a8cb0cc                          mov.b   r4l, @0xFFFFB0CC:16
00002E1C  5e01d2c0                 loc_2E1C jsr     sub_1D2C0:24
00002E20  5470                              rts
00002E22  fc00                     sub_2E22 mov.b   #0, r4l  ; <<< FUNC sub_2E22
00002E24  6a8c92cd                          mov.b   r4l, @0xFFFF92CD:16
00002E28  6a108ea57300                      btst    #0, @0xFFFF8EA5:16
00002E2E  462e                              bne     locret_2E5E:8
00002E30  6a0c8ea6                          mov.b   @0xFFFF8EA6:16, r4l
00002E34  4728                              beq     locret_2E5E:8
00002E36  4b26                              bmi     locret_2E5E:8
00002E38  731c                              btst    #1, r4l
00002E3A  4622                              bne     locret_2E5E:8
00002E3C  730c                              btst    #0, r4l
00002E3E  471e                              beq     locret_2E5E:8
00002E40  6a108ea77300                      btst    #0, @0xFFFF8EA7:16
00002E46  4616                              bne     locret_2E5E:8
00002E48  6a108ea77370                      btst    #7, @0xFFFF8EA7:16
00002E4E  460e                              bne     locret_2E5E:8
00002E50  6a108ea07370                      btst    #7, @0xFFFF8EA0:16
00002E56  4706                              beq     locret_2E5E:8
00002E58  fc01                              mov.b   #1, r4l
00002E5A  6a8c92cd                          mov.b   r4l, @0xFFFF92CD:16
00002E5E  5470                     locret_2E5E rts
00002E60  6a108ea57300             loc_2E60 btst    #0, @0xFFFF8EA5:16
00002E66  467a                              bne     loc_2EE2:8
00002E68  6a0c8ea6                          mov.b   @0xFFFF8EA6:16, r4l
00002E6C  4730                              beq     loc_2E9E:8
00002E6E  4b72                              bmi     loc_2EE2:8
00002E70  731c                              btst    #1, r4l
00002E72  466e                              bne     loc_2EE2:8
00002E74  730c                              btst    #0, r4l
00002E76  4726                              beq     loc_2E9E:8
00002E78  6a108ea77300                      btst    #0, @0xFFFF8EA7:16
00002E7E  4662                              bne     loc_2EE2:8
00002E80  6a108ea77370                      btst    #7, @0xFFFF8EA7:16
00002E86  586000c2                          bne     loc_2F4C:16
00002E8A  6a108ea07370                      btst    #7, @0xFFFF8EA0:16
00002E90  4706                              beq     loc_2E98:8
00002E92  fc01                              mov.b   #1, r4l
00002E94  6a8c92cd                          mov.b   r4l, @0xFFFF92CD:16
00002E98  5e02f400                 loc_2E98 jsr     sub_2F400:24
00002E9C  4044                              bra     loc_2EE2:8
00002E9E  5e0330f0                 loc_2E9E jsr     sub_330F0:24
00002EA2  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002EA8  01006b008122                      mov.l   @0xFFFF8122:16, er0
00002EAE  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002EB4  5e02c9ea                          jsr     loc_2C9EA:24
00002EB8  5e056236                          jsr     sub_56236:24
00002EBC  5e063216                          jsr     sub_63216:24
00002EC0  6a18bc0b7270                      bclr    #7, @0xFFFFBC0B:16
00002EC6  5e06802a                          jsr     sub_6802A:24
00002ECA  5e02ed5e                          jsr     loc_2ED5E:24
00002ECE  5e002e22                          jsr     sub_2E22:24
00002ED2  5e02f1da                          jsr     loc_2F1DA:24
00002ED6  5e03df86                          jsr     sub_3DF86:24
00002EDA  5e010760                          jsr     sub_10760:24
00002EDE  5800009a                          bra     locret_2F7C:16
00002EE2  6a18817e7200             loc_2EE2 bclr    #0, @0xFFFF817E:16
00002EE8  01006b008122                      mov.l   @0xFFFF8122:16, er0
00002EEE  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002EF4  5e02c9ea                          jsr     loc_2C9EA:24
00002EF8  5e056236                          jsr     sub_56236:24
00002EFC  5e063216                          jsr     sub_63216:24
00002F00  6a18bc0b7270                      bclr    #7, @0xFFFFBC0B:16
00002F06  5e06802a                          jsr     sub_6802A:24
00002F0A  5e02ed5e                          jsr     loc_2ED5E:24
00002F0E  5e002e22                          jsr     sub_2E22:24
00002F12  5e02f1da                          jsr     loc_2F1DA:24
00002F16  5e03df86                          jsr     sub_3DF86:24
00002F1A  5e010760                          jsr     sub_10760:24
00002F1E  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002F24  7a0000ff90f0                      mov.l   #0xFF90F0, er0
00002F2A  6a10b0a47320                      btst    #2, @0xFFFFB0A4:16
00002F30  4708                              beq     loc_2F3A:8
00002F32  6a10b0ce7330                      btst    #3, @0xFFFFB0CE:16
00002F38  4704                              beq     loc_2F3E:8
00002F3A  5e056236                 loc_2F3A jsr     sub_56236:24
00002F3E  5e0337e2                 loc_2F3E jsr     loc_337E2:24
00002F42  5e0330b6                          jsr     loc_330B6:24
00002F46  5e010760                          jsr     sub_10760:24
00002F4A  4030                              bra     locret_2F7C:8
00002F4C  5e02f400                 loc_2F4C jsr     sub_2F400:24
00002F50  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002F56  7a0000ff90f0                      mov.l   #0xFF90F0, er0
00002F5C  6a10b0a47320                      btst    #2, @0xFFFFB0A4:16
00002F62  4708                              beq     loc_2F6C:8
00002F64  6a10b0ce7330                      btst    #3, @0xFFFFB0CE:16
00002F6A  4704                              beq     loc_2F70:8
00002F6C  5e056236                 loc_2F6C jsr     sub_56236:24
00002F70  5e0337e2                 loc_2F70 jsr     loc_337E2:24
00002F74  5e0330b6                          jsr     loc_330B6:24
00002F78  5e010760                          jsr     sub_10760:24
00002F7C  5470                     locret_2F7C rts
00002F7E  6a108ea57300             loc_2F7E btst    #0, @0xFFFF8EA5:16
00002F84  4670                              bne     loc_2FF6:8
00002F86  6a0c8ea6                          mov.b   @0xFFFF8EA6:16, r4l
00002F8A  4730                              beq     loc_2FBC:8
00002F8C  4b68                              bmi     loc_2FF6:8
00002F8E  731c                              btst    #1, r4l
00002F90  4664                              bne     loc_2FF6:8
00002F92  730c                              btst    #0, r4l
00002F94  4726                              beq     loc_2FBC:8
00002F96  6a108ea77300                      btst    #0, @0xFFFF8EA7:16
00002F9C  4658                              bne     loc_2FF6:8
00002F9E  6a108ea77370                      btst    #7, @0xFFFF8EA7:16
00002FA4  586000ae                          bne     loc_3056:16
00002FA8  6a108ea07370                      btst    #7, @0xFFFF8EA0:16
00002FAE  4706                              beq     loc_2FB6:8
00002FB0  fc01                              mov.b   #1, r4l
00002FB2  6a8c92cd                          mov.b   r4l, @0xFFFF92CD:16
00002FB6  5e02f400                 loc_2FB6 jsr     sub_2F400:24
00002FBA  403a                              bra     loc_2FF6:8
00002FBC  5e0330f0                 loc_2FBC jsr     sub_330F0:24
00002FC0  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00002FC6  01006b008122                      mov.l   @0xFFFF8122:16, er0
00002FCC  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00002FD2  5e02c9ea                          jsr     loc_2C9EA:24
00002FD6  5e056236                          jsr     sub_56236:24
00002FDA  5e063216                          jsr     sub_63216:24
00002FDE  5e002e22                          jsr     sub_2E22:24
00002FE2  5e02f1da                          jsr     loc_2F1DA:24
00002FE6  5e03df86                          jsr     sub_3DF86:24
00002FEA  5e06b74e                          jsr     sub_6B74E:24
00002FEE  5e010760                          jsr     sub_10760:24
00002FF2  580000aa                          bra     locret_30A0:16
00002FF6  6a18817e7200             loc_2FF6 bclr    #0, @0xFFFF817E:16
00002FFC  01006b008122                      mov.l   @0xFFFF8122:16, er0
00003002  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00003008  5e02c9ea                          jsr     loc_2C9EA:24
0000300C  5e056236                          jsr     sub_56236:24
00003010  5e063216                          jsr     sub_63216:24
00003014  5e002e22                          jsr     sub_2E22:24
00003018  5e02f1da                          jsr     loc_2F1DA:24
0000301C  5e03df86                          jsr     sub_3DF86:24
00003020  5e06b74e                          jsr     sub_6B74E:24
00003024  5e010760                          jsr     sub_10760:24
00003028  6a18817e7200                      bclr    #0, @0xFFFF817E:16
0000302E  7a0000ff90f0                      mov.l   #0xFF90F0, er0
00003034  6a10b0a47320                      btst    #2, @0xFFFFB0A4:16
0000303A  4708                              beq     loc_3044:8
0000303C  6a10b0ce7330                      btst    #3, @0xFFFFB0CE:16
00003042  4704                              beq     loc_3048:8
00003044  5e056236                 loc_3044 jsr     sub_56236:24
00003048  5e0337e2                 loc_3048 jsr     loc_337E2:24
0000304C  5e0330b6                          jsr     loc_330B6:24
00003050  5e010760                          jsr     sub_10760:24
00003054  404a                              bra     locret_30A0:8
00003056  5e02f400                 loc_3056 jsr     sub_2F400:24
0000305A  6a18817e7200                      bclr    #0, @0xFFFF817E:16
00003060  7a0000ff90f0                      mov.l   #0xFF90F0, er0
00003066  6a10b0a47320                      btst    #2, @0xFFFFB0A4:16
0000306C  4708                              beq     loc_3076:8
0000306E  6a10b0ce7330                      btst    #3, @0xFFFFB0CE:16
00003074  4704                              beq     loc_307A:8
00003076  5e056236                 loc_3076 jsr     sub_56236:24
0000307A  5e0337e2                 loc_307A jsr     loc_337E2:24
0000307E  5e0330b6                          jsr     loc_330B6:24
00003082  5e010760                          jsr     sub_10760:24
00003086  6a18817e7200                      bclr    #0, @0xFFFF817E:16
0000308C  01006b008122                      mov.l   @0xFFFF8122:16, er0
00003092  01006b80812a                      mov.l   er0, @0xFFFF812A:16
00003098  5e06b74e                          jsr     sub_6B74E:24
0000309C  5e010760                          jsr     sub_10760:24
000030A0  5470                     locret_30A0 rts
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
