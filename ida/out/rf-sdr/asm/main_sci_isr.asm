; ==== sci_isr  00055F00-00056200 ====
00055F00  9810                              addx    #0x10, r0l
00055F02  0d4c                              mov.w   r4, e4
00055F04  6a049811                          mov.b   @0xFFFF9811:16, r4h
00055F08  6a0c9812                          mov.b   @0xFFFF9812:16, r4l
00055F0C  1fa4                              cmp.l   er2, er4
00055F0E  4666                              bne     loc_55F76:8
00055F10  6b04ba6c                          mov.w   @0xFFFFBA6C:16, r4
00055F14  470c                              beq     loc_55F22:8
00055F16  6b04ba6c                          mov.w   @0xFFFFBA6C:16, r4
00055F1A  6b84ba74                          mov.w   r4, @0xFFFFBA74:16
00055F1E  5e06ee36                          jsr     nullsub_39:24
00055F22  6a0cbc52                 loc_55F22 mov.b   @0xFFFFBC52:16, r4l
00055F26  ac02                              cmp.b   #2, r4l
00055F28  4726                              beq     loc_55F50:8
00055F2A  5e06a5c8                          jsr     sub_6A5C8:24
00055F2E  5e02ab28                          jsr     sub_2AB28:24
00055F32  6a18bbf27010                      bset    #1, @0xFFFFBBF2:16
00055F38  6a18bbf17040                      bset    #4, @0xFFFFBBF1:16
00055F3E  5e00af06                          jsr     sub_AF06:24
00055F42  fc03                              mov.b   #3, r4l
00055F44  6a8cbc4e                          mov.b   r4l, @0xFFFFBC4E:16
00055F48  fc00                              mov.b   #0, r4l
00055F4A  6a8cbc54                          mov.b   r4l, @0xFFFFBC54:16
00055F4E  4032                              bra     locret_55F82:8
00055F50  5e06a802                 loc_55F50 jsr     sub_6A802:24
00055F54  5e02ab28                          jsr     sub_2AB28:24
00055F58  6a18bbf27020                      bset    #2, @0xFFFFBBF2:16
00055F5E  6a18bbf17040                      bset    #4, @0xFFFFBBF1:16
00055F64  5e00af94                          jsr     sub_AF94:24
00055F68  fc02                              mov.b   #2, r4l
00055F6A  6a8cbc4e                          mov.b   r4l, @0xFFFFBC4E:16
00055F6E  fc00                              mov.b   #0, r4l
00055F70  6a8cbc54                          mov.b   r4l, @0xFFFFBC54:16
00055F74  400c                              bra     locret_55F82:8
00055F76  fc1d                     loc_55F76 mov.b   #0x1D, r4l
00055F78  6a8caae0                          mov.b   r4l, @0xFFFFAAE0:16
00055F7C  fc03                              mov.b   #3, r4l
00055F7E  6a8cbc4e                          mov.b   r4l, @0xFFFFBC4E:16
00055F82  5470                     locret_55F82 rts
00055F84  0cac                              mov.b   r2l, r4l
00055F86  470c                              beq     locret_55F94:8
00055F88  fc00                              mov.b   #0, r4l
00055F8A  6a8cbc56                          mov.b   r4l, @0xFFFFBC56:16
00055F8E  fc01                              mov.b   #1, r4l
00055F90  6a8cbc57                          mov.b   r4l, @0xFFFFBC57:16
00055F94  5470                     locret_55F94 rts
00055F96  6a0cbbe4                          mov.b   @0xFFFFBBE4:16, r4l
00055F9A  4652                              bne     locret_55FEE:8
00055F9C  6b04ba74                          mov.w   @0xFFFFBA74:16, r4
00055FA0  79240100                          cmp.w   #0x100, r4
00055FA4  4414                              bcc     loc_55FBA:8
00055FA6  6b84bc3e                          mov.w   r4, @0xFFFFBC3E:16
00055FAA  79040000                          mov.w   #0, r4
00055FAE  6b84ba74                          mov.w   r4, @0xFFFFBA74:16
00055FB2  01006b05bc48                      mov.l   @0xFFFFBC48:16, er5
00055FB8  4024                              bra     loc_55FDE:8
00055FBA  79340100                 loc_55FBA sub.w   #0x100, r4
00055FBE  6b84ba74                          mov.w   r4, @0xFFFFBA74:16
00055FC2  79040100                          mov.w   #0x100, r4
00055FC6  6b84bc3e                          mov.w   r4, @0xFFFFBC3E:16
00055FCA  01006b05bc48                      mov.l   @0xFFFFBC48:16, er5
00055FD0  0fd4                              mov.l   er5, er4
00055FD2  7a1400000100                      add.l   #0x100, er4
00055FD8  01006b84bc48                      mov.l   er4, @0xFFFFBC48:16
00055FDE  5e00b610                 loc_55FDE jsr     sub_B610:24
00055FE2  6b04ba74                          mov.w   @0xFFFFBA74:16, r4
00055FE6  4606                              bne     locret_55FEE:8
00055FE8  fc02                              mov.b   #2, r4l
00055FEA  6a8cbc57                          mov.b   r4l, @0xFFFFBC57:16
00055FEE  5470                     locret_55FEE rts
00055FF0  6a0cbbe4                          mov.b   @0xFFFFBBE4:16, r4l
00055FF4  4606                              bne     locret_55FFC:8
00055FF6  fc01                              mov.b   #1, r4l
00055FF8  6a8cbc56                          mov.b   r4l, @0xFFFFBC56:16
00055FFC  5470                     locret_55FFC rts
00055FFE  fc00                     loc_55FFE mov.b   #0, r4l
00056000  6a8c8180                          mov.b   r4l, @0xFFFF8180:16
00056004  6a8c8181                          mov.b   r4l, @0xFFFF8181:16
00056008  fc00                              mov.b   #0, r4l
0005600A  6a8c8183                          mov.b   r4l, @0xFFFF8183:16
0005600E  6a8c8182                          mov.b   r4l, @0xFFFF8182:16
00056012  f401                              mov.b   #1, r4h
00056014  fc00                              mov.b   #0, r4l
00056016  0d4c                              mov.w   r4, e4
00056018  7904ffff                          mov.w   #0xFFFF, r4
0005601C  01006b848184                      mov.l   er4, @0xFFFF8184:16
00056022  7a0400ff3cea                      mov.l   #0xFF3CEA, er4
00056028  01006b848152                      mov.l   er4, @0xFFFF8152:16
0005602E  01006b848156                      mov.l   er4, @0xFFFF8156:16
00056034  5470                              rts
00056036  6a0c8d20                          mov.b   @0xFFFF8D20:16, r4l
0005603A  460a                              bne     sub_56046:8
0005603C  5470                              rts
0005603E  6a0c8dd5                          mov.b   @0xFFFF8DD5:16, r4l
00056042  4602                              bne     sub_56046:8
00056044  5470                              rts
00056046  fc05                     sub_56046 mov.b   #5, r4l  ; <<< FUNC sub_56046
00056048  6a8cb0b4                          mov.b   r4l, @0xFFFFB0B4:16
0005604C  fc00                              mov.b   #0, r4l
0005604E  6a8cb0a4                          mov.b   r4l, @0xFFFFB0A4:16
00056052  5502                              bsr     sub_56056:8
00056054  5470                              rts
00056056  7f527200                 sub_56056 bclr    #0, @0xFFFFFF52:8  ; <<< FUNC sub_56056
0005605A  7f527230                          bclr    #3, @0xFFFFFF52:8
0005605E  6a18fba47220                      bclr    #2, @0xFFFFFBA4:16
00056064  7f527210                          bclr    #1, @0xFFFFFF52:8
00056068  7f527220                          bclr    #2, @0xFFFFFF52:8
0005606C  7f527240                          bclr    #4, @0xFFFFFF52:8
00056070  7f597240                          bclr    #4, @0xFFFFFF59:8
00056074  7a0400ff23c8                      mov.l   #0xFF23C8, er4
0005607A  01006b84815a                      mov.l   er4, @0xFFFF815A:16
00056080  01006b84815e                      mov.l   er4, @0xFFFF815E:16
00056086  6b04ff34                          mov.w   @0xFFFFFF34:16, r4
0005608A  722c                              bclr    #2, r4l
0005608C  6b84ff34                          mov.w   r4, @0xFFFFFF34:16
00056090  6a0cfb90                          mov.b   @0xFFFFFB90:16, r4l
00056094  722c                              bclr    #2, r4l
00056096  6a8cfb90                          mov.b   r4l, @0xFFFFFB90:16
0005609A  fc00                              mov.b   #0, r4l
0005609C  6a8cb0bb                          mov.b   r4l, @0xFFFFB0BB:16
000560A0  6a8cb0ac                          mov.b   r4l, @0xFFFFB0AC:16
000560A4  6a0cb0aa                          mov.b   @0xFFFFB0AA:16, r4l
000560A8  ec01                              and.b   #1, r4l
000560AA  6a8cb0aa                          mov.b   r4l, @0xFFFFB0AA:16
000560AE  6a0cbbf9                          mov.b   @0xFFFFBBF9:16, r4l
000560B2  ec01                              and.b   #1, r4l
000560B4  6a8cbbf9                          mov.b   r4l, @0xFFFFBBF9:16
000560B8  6a18b0aa7020                      bset    #2, @0xFFFFB0AA:16
000560BE  6a18bbf97020                      bset    #2, @0xFFFFBBF9:16
000560C4  fc00                              mov.b   #0, r4l
000560C6  6a8cb0a9                          mov.b   r4l, @0xFFFFB0A9:16
000560CA  fc00                              mov.b   #0, r4l
000560CC  6a8cb0ab                          mov.b   r4l, @0xFFFFB0AB:16
000560D0  fc00                              mov.b   #0, r4l
000560D2  6a8cb0ad                          mov.b   r4l, @0xFFFFB0AD:16
000560D6  fc00                              mov.b   #0, r4l
000560D8  6a8cb0b1                          mov.b   r4l, @0xFFFFB0B1:16
000560DC  fc00                              mov.b   #0, r4l
000560DE  6a8cb0cf                          mov.b   r4l, @0xFFFFB0CF:16
000560E2  fc00                              mov.b   #0, r4l
000560E4  6a8cb0d0                          mov.b   r4l, @0xFFFFB0D0:16
000560E8  fc00                              mov.b   #0, r4l
000560EA  6a8cb0af                          mov.b   r4l, @0xFFFFB0AF:16
000560EE  fc01                              mov.b   #1, r4l
000560F0  6a8cb0b7                          mov.b   r4l, @0xFFFFB0B7:16
000560F4  fc00                              mov.b   #0, r4l
000560F6  6a8cb0bc                          mov.b   r4l, @0xFFFFB0BC:16
000560FA  6a8cb0bd                          mov.b   r4l, @0xFFFFB0BD:16
000560FE  6a8cb0be                          mov.b   r4l, @0xFFFFB0BE:16
00056102  6a8cb11f                          mov.b   r4l, @0xFFFFB11F:16
00056106  6a8cb0c0                          mov.b   r4l, @0xFFFFB0C0:16
0005610A  6a8cb0c1                          mov.b   r4l, @0xFFFFB0C1:16
0005610E  fc00                              mov.b   #0, r4l
00056110  6a8cb0a7                          mov.b   r4l, @0xFFFFB0A7:16
00056114  fc00                              mov.b   #0, r4l
00056116  6a8cb0a6                          mov.b   r4l, @0xFFFFB0A6:16
0005611A  fc00                              mov.b   #0, r4l
0005611C  6a8cb0b3                          mov.b   r4l, @0xFFFFB0B3:16
00056120  6b048d88                          mov.w   @0xFFFF8D88:16, r4
00056124  6ba400ff0616                      mov.w   r4, @0xFF0616:32
0005612A  fcff                              mov.b   #0xFF, r4l
0005612C  6a8cb107                          mov.b   r4l, @0xFFFFB107:16
00056130  79040000                          mov.w   #0, r4
00056134  6b84b256                          mov.w   r4, @0xFFFFB256:16
00056138  6a8cb103                          mov.b   r4l, @0xFFFFB103:16
0005613C  6a8cb105                          mov.b   r4l, @0xFFFFB105:16
00056140  fcff                              mov.b   #0xFF, r4l
00056142  6aac00fef926                      mov.b   r4l, @0xFEF926:32
00056148  6aac00fef93a                      mov.b   r4l, @0xFEF93A:32
0005614E  6aac00fef94e                      mov.b   r4l, @0xFEF94E:32
00056154  fc00                              mov.b   #0, r4l
00056156  6a8cb102                          mov.b   r4l, @0xFFFFB102:16
0005615A  5470                              rts
0005615C  01106df4                 loc_5615C stm.l   er4-er5, @-sp
00056160  6a0c813a                          mov.b   @0xFFFF813A:16, r4l
00056164  4642                              bne     loc_561A8:8
00056166  2d8c                              mov.b   @0xFFFFFF8C:8, r5l
00056168  0cd5                              mov.b   r5l, r5h
0005616A  ed20                              and.b   #0x20, r5l
0005616C  4628                              bne     loc_56196:8
0005616E  e587                              and.b   #0x87, r5h
00056170  358c                              mov.b   r5h, @0xFFFFFF8C:8
00056172  2d8d                              mov.b   @0xFFFFFF8D:8, r5l
00056174  01006b04815e                      mov.l   @0xFFFF815E:16, er4
0005617A  68cd                              mov.b   r5l, @er4
0005617C  0b04                              adds    #1, er4
0005617E  792427c8                          cmp.w   #0x27C8, r4
00056182  4506                              bcs     loc_5618A:8
00056184  7a0400ff23c8                      mov.l   #0xFF23C8, er4
0005618A  01006b84815e             loc_5618A mov.l   er4, @0xFFFF815E:16
00056190  01106d75                          ldm.l   @sp+, er4-er5
00056194  5670                              rte
00056196  0c5d                     loc_56196 mov.b   r5h, r5l
00056198  edc7                              and.b   #0xC7, r5l
0005619A  3d8c                              mov.b   r5l, @0xFFFFFF8C:8
0005619C  7365                              btst    #6, r5h
0005619E  4702                              beq     loc_561A2:8
000561A0  2d8d                              mov.b   @0xFFFFFF8D:8, r5l
000561A2  01106d75                 loc_561A2 ldm.l   @sp+, er4-er5
000561A6  5670                              rte
000561A8  01306df0                 loc_561A8 stm.l   er0-er3, @-sp
000561AC  01206df4                          stm.l   er4-er6, @-sp
000561B0  5e07711e                          jsr     loc_7711D+1:24
000561B4  01206d76                          ldm.l   @sp+, er4-er6
000561B8  01306d73                          ldm.l   @sp+, er0-er3
000561BC  01106d75                          ldm.l   @sp+, er4-er5
000561C0  5670                              rte
000561C2  6df4                     loc_561C2 push.w  r4
000561C4  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
000561C8  722c                              bclr    #2, r4l
000561CA  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
000561CE  6b04fd6a                          mov.w   @0xFFFFFD6A:16, r4
000561D2  714c                              bnot    #4, r4l
000561D4  715c                              bnot    #5, r4l
000561D6  6b84fd6a                          mov.w   r4, @0xFFFFFD6A:16
000561DA  774c                              bld     #4, r4l
000561DC  6a18b0a26770                      bst     #7, @0xFFFFB0A2:16
000561E2  4538                              bcs     loc_5621C:8
000561E4  7ebc7340                          btst    #4, @0xFFFFFFBC:8
000561E8  4728                              beq     loc_56212:8
000561EA  7fbc7240                          bclr    #4, @0xFFFFFFBC:8
000561EE  6a0cfee5                          mov.b   @0xFFFFFEE5:16, r4l
000561F2  734c                              btst    #4, r4l
000561F4  4612                              bne     loc_56208:8
000561F6  6b04fee6                          mov.w   @0xFFFFFEE6:16, r4
000561FA  79247d00                          cmp.w   #0x7D00, r4
000561FE  4412                              bcc     loc_56212:8
