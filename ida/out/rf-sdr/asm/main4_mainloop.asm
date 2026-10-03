; ==== mainloop  00002AA0-00002E60 ====
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
00002C84  5e02f400                          jsr     loc_2F400:24
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
