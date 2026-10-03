; ==== io_init  000020C0-00002820 ====
000020C0  6a18817f7250             loc_20C0 bclr    #5, @0xFFFF817F:16
000020C6  5e003466                          jsr     sub_3466:24
000020CA  4504                              bcs     loc_20D0:8
000020CC  5e03e9fc                          jsr     loc_3E9FC:24
000020D0  7f5a7260                 loc_20D0 bclr    #6, @0xFFFFFF5A:8
000020D4  5a0027ae                          jmp     loc_27AE:24
000020D8  fe05                     sub_20D8 mov.b   #5, r6l  ; <<< FUNC sub_20D8
000020DA  5e00246c                 loc_20DA jsr     sub_246C:24
000020DE  1a0e                              dec.b   r6l
000020E0  46f8                              bne     loc_20DA:8
000020E2  5506                              bsr     sub_20EA:8
000020E4  470e                              beq     locret_20F4:8
000020E6  5502                              bsr     sub_20EA:8
000020E8  470a                              beq     locret_20F4:8
000020EA  5e0394b4                 sub_20EA jsr     sub_394B4:24  ; <<< FUNC sub_20EA
000020EE  6a0c8002                          mov.b   @0xFFFF8002:16, r4l
000020F2  acc9                              cmp.b   #0xC9, r4l
000020F4  5470                     locret_20F4 rts
000020F6  f901                     sub_20F6 mov.b   #1, r1l  ; <<< FUNC sub_20F6
000020F8  4002                              bra     loc_20FC:8
000020FA  f900                     sub_20FA mov.b   #0, r1l  ; <<< FUNC sub_20FA
000020FC  79040111                 loc_20FC mov.w   #0x111, r4
00002100  6b84fdc4                          mov.w   r4, @0xFFFFFDC4:16
00002104  fc00                              mov.b   #0, r4l
00002106  6a8cfbc2                          mov.b   r4l, @0xFFFFFBC2:16
0000210A  fca0                              mov.b   #0xA0, r4l
0000210C  6a8cfbc6                          mov.b   r4l, @0xFFFFFBC6:16
00002110  fc0c                              mov.b   #0xC, r4l
00002112  6a8cfbcb                          mov.b   r4l, @0xFFFFFBCB:16
00002116  fc00                              mov.b   #0, r4l
00002118  6a8cfbcd                          mov.b   r4l, @0xFFFFFBCD:16
0000211C  fc00                              mov.b   #0, r4l
0000211E  6a8cfbcc                          mov.b   r4l, @0xFFFFFBCC:16
00002122  0000                              nop
00002124  0000                              nop
00002126  7904d103                          mov.w   #0xD103, r4
0000212A  6b84fdc2                          mov.w   r4, @0xFFFFFDC2:16
0000212E  fc00                              mov.b   #0, r4l
00002130  3c32                              mov.b   r4l, @0xFFFFFF32:8
00002132  7a0600000000                      mov.l   #0, er6
00002138  7a0400ff7300                      mov.l   #0xFF7300, er4
0000213E  7a0500fee000                      mov.l   #0xFEE000, er5
00002144  1ad4                              sub.l   er5, er4
00002146  1174                              shlr.l  #2, er4
00002148  010069d6                 loc_2148 mov.l   er6, @er5
0000214C  0b95                              adds    #4, er5
0000214E  1b74                              dec.l   #1, er4
00002150  46f6                              bne     loc_2148:8
00002152  790404ae                          mov.w   #0x4AE, r4
00002156  7a050007b2a6                      mov.l   #(loc_7B2A5+1), er5
0000215C  7a0600ff6034                      mov.l   #0xFF6034, er6
00002162  7bd4598f                 loc_2162 eepmov.w
00002166  0d44                              mov.w   r4, r4
00002168  46f8                              bne     loc_2162:8
0000216A  7a0400ff8ee0                      mov.l   #0xFF8EE0, er4
00002170  01006b848122                      mov.l   er4, @0xFFFF8122:16
00002176  0fc0                              mov.l   er4, er0
00002178  01006b80812a                      mov.l   er0, @0xFFFF812A:16
0000217E  7a0400ff8fe8                      mov.l   #0xFF8FE8, er4
00002184  01006b848126                      mov.l   er4, @0xFFFF8126:16
0000218A  fc00                              mov.b   #0, r4l
0000218C  6a8c816f                          mov.b   r4l, @0xFFFF816F:16
00002190  79040000                          mov.w   #0, r4
00002194  6b84fbce                          mov.w   r4, @0xFFFFFBCE:16
00002198  fc00                              mov.b   #0, r4l
0000219A  3c5c                              mov.b   r4l, @0xFFFFFF5C:8
0000219C  fc7f                              mov.b   #0x7F, r4l
0000219E  6a8cfbb4                          mov.b   r4l, @0xFFFFFBB4:16
000021A2  fc80                              mov.b   #0x80, r4l
000021A4  6a8cfb8c                          mov.b   r4l, @0xFFFFFB8C:16
000021A8  fc03                              mov.b   #3, r4l
000021AA  6a8cfba4                          mov.b   r4l, @0xFFFFFBA4:16
000021AE  fc03                              mov.b   #3, r4l
000021B0  6a8cfbb8                          mov.b   r4l, @0xFFFFFBB8:16
000021B4  fcff                              mov.b   #0xFF, r4l
000021B6  6a8cfba8                          mov.b   r4l, @0xFFFFFBA8:16
000021BA  6a8c816e                          mov.b   r4l, @0xFFFF816E:16
000021BE  fc00                              mov.b   #0, r4l
000021C0  3c5b                              mov.b   r4l, @0xFFFFFF5B:8
000021C2  fc0c                              mov.b   #0xC, r4l
000021C4  6a8cfb8b                          mov.b   r4l, @0xFFFFFB8B:16
000021C8  fcbc                              mov.b   #0xBC, r4l
000021CA  3c5a                              mov.b   r4l, @0xFFFFFF5A:8
000021CC  fcff                              mov.b   #0xFF, r4l
000021CE  6a8cfb8a                          mov.b   r4l, @0xFFFFFB8A:16
000021D2  6a8c816d                          mov.b   r4l, @0xFFFF816D:16
000021D6  79045cd4                          mov.w   #0x5CD4, r4
000021DA  6b84fdc8                          mov.w   r4, @0xFFFFFDC8:16
000021DE  7904e8ff                          mov.w   #0xE8FF, r4
000021E2  6b84fdca                          mov.w   r4, @0xFFFFFDCA:16
000021E6  7904b700                          mov.w   #0xB700, r4
000021EA  6b84fdcc                          mov.w   r4, @0xFFFFFDCC:16
000021EE  fc00                              mov.b   #0, r4l
000021F0  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
000021F2  3ca1                              mov.b   r4l, @0xFFFFFFA1:8
000021F4  5e00246c                          jsr     sub_246C:24
000021F8  fc00                              mov.b   #0, r4l
000021FA  6a8c813a                          mov.b   r4l, @0xFFFF813A:16
000021FE  fec8                              mov.b   #0xC8, r6l
00002200  2c4c                     loc_2200 mov.b   @0xFFFFFF4C:8, r4l
00002202  ec7f                              and.b   #0x7F, r4l
00002204  ac7d                              cmp.b   #0x7D, r4l ; '}'
00002206  4716                              beq     loc_221E:8
00002208  1a0e                              dec.b   r6l
0000220A  46f4                              bne     loc_2200:8
0000220C  6a8c813b                          mov.b   r4l, @0xFFFF813B:16
00002210  a900                              cmp.b   #0, r1l
00002212  4604                              bne     loc_2218:8
00002214  5e054bf8                          jsr     sub_54BF8:24
00002218  5e054c44                 loc_2218 jsr     sub_54C44:24
0000221C  4022                              bra     loc_2240:8
0000221E  6a8c813b                 loc_221E mov.b   r4l, @0xFFFF813B:16
00002222  fc01                              mov.b   #1, r4l
00002224  6a8c813a                          mov.b   r4l, @0xFFFF813A:16
00002228  5e055ffe                          jsr     loc_55FFE:24
0000222C  01306df0                          stm.l   er0-er3, @-sp
00002230  01206df4                          stm.l   er4-er6, @-sp
00002234  5e078106                          jsr     loc_78105+1:24
00002238  01206d76                          ldm.l   @sp+, er4-er6
0000223C  01306d73                          ldm.l   @sp+, er0-er3
00002240  fc09                     loc_2240 mov.b   #9, r4l
00002242  3c59                              mov.b   r4l, @0xFFFFFF59:8
00002244  fc3d                              mov.b   #0x3D, r4l ; '='
00002246  6a8cfb89                          mov.b   r4l, @0xFFFFFB89:16
0000224A  6a8c816c                          mov.b   r4l, @0xFFFF816C:16
0000224E  fc00                              mov.b   #0, r4l
00002250  3c50                              mov.b   r4l, @0xFFFFFF50:8
00002252  fc40                              mov.b   #0x40, r4l ; '@'
00002254  6a8cfb80                          mov.b   r4l, @0xFFFFFB80:16
00002258  6a8c816a                          mov.b   r4l, @0xFFFF816A:16
0000225C  fc00                              mov.b   #0, r4l
0000225E  3c51                              mov.b   r4l, @0xFFFFFF51:8
00002260  fc00                              mov.b   #0, r4l
00002262  6a8cfb81                          mov.b   r4l, @0xFFFFFB81:16
00002266  fc00                              mov.b   #0, r4l
00002268  6a8cfbbc                          mov.b   r4l, @0xFFFFFBBC:16
0000226C  fca0                              mov.b   #0xA0, r4l
0000226E  3c52                              mov.b   r4l, @0xFFFFFF52:8
00002270  fcbf                              mov.b   #0xBF, r4l
00002272  6a8cfb82                          mov.b   r4l, @0xFFFFFB82:16
00002276  fc00                              mov.b   #0, r4l
00002278  3c55                              mov.b   r4l, @0xFFFFFF55:8
0000227A  fc00                              mov.b   #0, r4l
0000227C  6a8cfb85                          mov.b   r4l, @0xFFFFFB85:16
00002280  fcc0                              mov.b   #0xC0, r4l
00002282  3c5d                              mov.b   r4l, @0xFFFFFF5D:8
00002284  fc10                              mov.b   #0x10, r4l
00002286  6a8cfbb5                          mov.b   r4l, @0xFFFFFBB5:16
0000228A  fcf3                              mov.b   #0xF3, r4l
0000228C  6a8cfb8d                          mov.b   r4l, @0xFFFFFB8D:16
00002290  fc00                              mov.b   #0, r4l
00002292  3c5e                              mov.b   r4l, @0xFFFFFF5E:8
00002294  fc34                              mov.b   #0x34, r4l ; '4'
00002296  6a8cfbb6                          mov.b   r4l, @0xFFFFFBB6:16
0000229A  fc00                              mov.b   #0, r4l
0000229C  6a8cfb8e                          mov.b   r4l, @0xFFFFFB8E:16
000022A0  fc00                              mov.b   #0, r4l
000022A2  6a8cfbbd                          mov.b   r4l, @0xFFFFFBBD:16
000022A6  fc40                              mov.b   #0x40, r4l ; '@'
000022A8  6a8cfba5                          mov.b   r4l, @0xFFFFFBA5:16
000022AC  fc00                              mov.b   #0, r4l
000022AE  6a8cfbb9                          mov.b   r4l, @0xFFFFFBB9:16
000022B2  fcff                              mov.b   #0xFF, r4l
000022B4  6a8cfba9                          mov.b   r4l, @0xFFFFFBA9:16
000022B8  fc00                              mov.b   #0, r4l
000022BA  6a8cee51                          mov.b   r4l, @0xFFFFEE51:16
000022BE  fc00                              mov.b   #0, r4l
000022C0  6a8cee50                          mov.b   r4l, @0xFFFFEE50:16
000022C4  fc20                              mov.b   #0x20, r4l ; ' '
000022C6  3cc0                              mov.b   r4l, @0xFFFFFFC0:8
000022C8  fcc0                              mov.b   #0xC0, r4l
000022CA  3cc1                              mov.b   r4l, @0xFFFFFFC1:8
000022CC  fc00                              mov.b   #0, r4l
000022CE  3cc2                              mov.b   r4l, @0xFFFFFFC2:8
000022D0  3cc3                              mov.b   r4l, @0xFFFFFFC3:8
000022D2  fc40                              mov.b   #0x40, r4l ; '@'
000022D4  3cc4                              mov.b   r4l, @0xFFFFFFC4:8
000022D6  fc20                              mov.b   #0x20, r4l ; ' '
000022D8  3cd0                              mov.b   r4l, @0xFFFFFFD0:8
000022DA  fcc0                              mov.b   #0xC0, r4l
000022DC  3cd1                              mov.b   r4l, @0xFFFFFFD1:8
000022DE  fc00                              mov.b   #0, r4l
000022E0  3cd2                              mov.b   r4l, @0xFFFFFFD2:8
000022E2  fc40                              mov.b   #0x40, r4l ; '@'
000022E4  3cd4                              mov.b   r4l, @0xFFFFFFD4:8
000022E6  fc20                              mov.b   #0x20, r4l ; ' '
000022E8  3ce0                              mov.b   r4l, @0xFFFFFFE0:8
000022EA  fcc0                              mov.b   #0xC0, r4l
000022EC  3ce1                              mov.b   r4l, @0xFFFFFFE1:8
000022EE  fc00                              mov.b   #0, r4l
000022F0  3ce2                              mov.b   r4l, @0xFFFFFFE2:8
000022F2  fc40                              mov.b   #0x40, r4l ; '@'
000022F4  3ce4                              mov.b   r4l, @0xFFFFFFE4:8
000022F6  fc00                              mov.b   #0, r4l
000022F8  3cf0                              mov.b   r4l, @0xFFFFFFF0:8
000022FA  fcc0                              mov.b   #0xC0, r4l
000022FC  3cf1                              mov.b   r4l, @0xFFFFFFF1:8
000022FE  fc00                              mov.b   #0, r4l
00002300  3cf2                              mov.b   r4l, @0xFFFFFFF2:8
00002302  3cf3                              mov.b   r4l, @0xFFFFFFF3:8
00002304  fc40                              mov.b   #0x40, r4l ; '@'
00002306  3cf4                              mov.b   r4l, @0xFFFFFFF4:8
00002308  fc00                              mov.b   #0, r4l
0000230A  6a8cfee0                          mov.b   r4l, @0xFFFFFEE0:16
0000230E  fcc0                              mov.b   #0xC0, r4l
00002310  6a8cfee1                          mov.b   r4l, @0xFFFFFEE1:16
00002314  fc00                              mov.b   #0, r4l
00002316  6a8cfee2                          mov.b   r4l, @0xFFFFFEE2:16
0000231A  fc40                              mov.b   #0x40, r4l ; '@'
0000231C  6a8cfee4                          mov.b   r4l, @0xFFFFFEE4:16
00002320  5e002482                          jsr     sub_2482:24
00002324  fc0c                              mov.b   #0xC, r4l
00002326  6a8cfec0                          mov.b   r4l, @0xFFFFFEC0:16
0000232A  fc00                              mov.b   #0, r4l
0000232C  6a8cfeca                          mov.b   r4l, @0xFFFFFECA:16
00002330  fc00                              mov.b   #0, r4l
00002332  6a8cfec2                          mov.b   r4l, @0xFFFFFEC2:16
00002336  fc02                              mov.b   #2, r4l
00002338  6a8cfec1                          mov.b   r4l, @0xFFFFFEC1:16
0000233C  fc00                              mov.b   #0, r4l
0000233E  6a8cfecb                          mov.b   r4l, @0xFFFFFECB:16
00002342  fc00                              mov.b   #0, r4l
00002344  6a8cfec3                          mov.b   r4l, @0xFFFFFEC3:16
00002348  5e0446be                          jsr     sub_446BE:24
0000234C  5e00246c                          jsr     sub_246C:24
00002350  fc03                              mov.b   #3, r4l
00002352  3c6b                              mov.b   r4l, @0xFFFFFF6B:8
00002354  fc7f                              mov.b   #0x7F, r4l
00002356  3c69                              mov.b   r4l, @0xFFFFFF69:8
00002358  fc7f                              mov.b   #0x7F, r4l
0000235A  3c68                              mov.b   r4l, @0xFFFFFF68:8
0000235C  7f5a7060                          bset    #6, @0xFFFFFF5A:8
00002360  7a04000007d0                      mov.l   #0x7D0, er4
00002366  5e002472                          jsr     sub_2472:24
0000236A  7f5a7260                          bclr    #6, @0xFFFFFF5A:8
0000236E  7a04000007d0                      mov.l   #0x7D0, er4
00002374  5e002472                          jsr     sub_2472:24
00002378  fcdf                              mov.b   #0xDF, r4l
0000237A  3c6a                              mov.b   r4l, @0xFFFFFF6A:8
0000237C  fc00                              mov.b   #0, r4l
0000237E  6a8cfb90                          mov.b   r4l, @0xFFFFFB90:16
00002382  fc00                              mov.b   #0, r4l
00002384  6a8c8171                          mov.b   r4l, @0xFFFF8171:16
00002388  6a8c8170                          mov.b   r4l, @0xFFFF8170:16
0000238C  6a8c817e                          mov.b   r4l, @0xFFFF817E:16
00002390  6a8c817f                          mov.b   r4l, @0xFFFF817F:16
00002394  6a8c94b9                          mov.b   r4l, @0xFFFF94B9:16
00002398  79034000                          mov.w   #0x4000, r3
0000239C  2c40                              mov.b   @0xFFFFFF40:8, r4l
0000239E  ec80                              and.b   #0x80, r4l
000023A0  460a                              bne     loc_23AC:8
000023A2  79038000                          mov.w   #0x8000, r3
000023A6  6a1881707000                      bset    #0, @0xFFFF8170:16
000023AC  6b83fd6a                 loc_23AC mov.w   r3, @0xFFFFFD6A:16
000023B0  fc80                              mov.b   #0x80, r4l
000023B2  6a8cfb90                          mov.b   r4l, @0xFFFFFB90:16
000023B6  79030010                          mov.w   #0x10, r3
000023BA  2c45                              mov.b   @0xFFFFFF45:8, r4l
000023BC  ec04                              and.b   #4, r4l
000023BE  460a                              bne     loc_23CA:8
000023C0  79030020                          mov.w   #0x20, r3 ; ' '
000023C4  6a1881707010                      bset    #1, @0xFFFF8170:16
000023CA  6b83fd68                 loc_23CA mov.w   r3, @0xFFFFFD68:16
000023CE  fc04                              mov.b   #4, r4l
000023D0  6a8cfb95                          mov.b   r4l, @0xFFFFFB95:16
000023D4  0000                              nop
000023D6  0000                              nop
000023D8  0000                              nop
000023DA  79040480                          mov.w   #0x480, r4
000023DE  6b84ff34                          mov.w   r4, @0xFFFFFF34:16
000023E2  0000                              nop
000023E4  0000                              nop
000023E6  0000                              nop
000023E8  79040000                          mov.w   #0, r4
000023EC  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
000023F0  0700                              ldc.b   #0, ccr
000023F2  7f5a7060                          bset    #6, @0xFFFFFF5A:8
000023F6  5e00246c                          jsr     sub_246C:24
000023FA  6a18fba47060                      bset    #6, @0xFFFFFBA4:16
00002400  6a18fba47070                      bset    #7, @0xFFFFFBA4:16
00002406  5e037a14                          jsr     sub_37A14:24
0000240A  5e037a30                          jsr     sub_37A30:24
0000240E  5e037a4c                          jsr     sub_37A4C:24
00002412  fc10                              mov.b   #0x10, r4l
00002414  f400                              mov.b   #0, r4h
00002416  7a050000245c                      mov.l   #0x245C, er5
0000241C  7a0600ffa998                      mov.l   #0xFFA998, er6
00002422  7bd4598f                 loc_2422 eepmov.w
00002426  0d44                              mov.w   r4, r4
00002428  46f8                              bne     loc_2422:8
0000242A  fc10                              mov.b   #0x10, r4l
0000242C  f400                              mov.b   #0, r4h
0000242E  7a050000245c                      mov.l   #0x245C, er5
00002434  7a0600ffa9a8                      mov.l   #0xFFA9A8, er6
0000243A  7bd4598f                 loc_243A eepmov.w
0000243E  0d44                              mov.w   r4, r4
00002440  46f8                              bne     loc_243A:8
00002442  5e003490                          jsr     sub_3490:24
00002446  5e03347e                          jsr     sub_3347E:24
0000244A  5470                              rts
0000244C  0000                              nop
0000244E  0000                              nop
00002450  0000                              nop
00002452  0000                              nop
00002454  ffff                              mov.b   #0xFF, r7l
00002456  ffff                              mov.b   #0xFF, r7l
00002458  ffff                              mov.b   #0xFF, r7l
0000245A  ffff                              mov.b   #0xFF, r7l
0000245C  0000                              nop
0000245E  0000                              nop
00002460  0000                              nop
00002462  0000                              nop
00002464  ffff                              mov.b   #0xFF, r7l
00002466  ffff                              mov.b   #0xFF, r7l
00002468  ffff                              mov.b   #0xFF, r7l
0000246A  ffff                              mov.b   #0xFF, r7l
0000246C  7a04000186a0             sub_246C mov.l   #loc_186A0, er4  ; <<< FUNC sub_246C
00002472  0000                     sub_2472 nop  ; <<< FUNC sub_2472
00002474  0000                              nop
00002476  0000                              nop
00002478  0000                              nop
0000247A  0000                              nop
0000247C  1b74                              dec.l   #1, er4
0000247E  46f2                              bne     sub_2472:8
00002480  5470                              rts
00002482  fc21                     sub_2482 mov.b   #0x21, r4l ; '!'  ; <<< FUNC sub_2482
00002484  6a8cfef0                          mov.b   r4l, @0xFFFFFEF0:16
00002488  fcc0                              mov.b   #0xC0, r4l
0000248A  6a8cfef1                          mov.b   r4l, @0xFFFFFEF1:16
0000248E  fc00                              mov.b   #0, r4l
00002490  6a8cfef2                          mov.b   r4l, @0xFFFFFEF2:16
00002494  fc41                              mov.b   #0x41, r4l ; 'A'
00002496  6a8cfef4                          mov.b   r4l, @0xFFFFFEF4:16
0000249A  79040000                          mov.w   #0, r4
0000249E  6b84fef6                          mov.w   r4, @0xFFFFFEF6:16
000024A2  79044e20                          mov.w   #0x4E20, r4
000024A6  6b84fef8                          mov.w   r4, @0xFFFFFEF8:16
000024AA  fc20                              mov.b   #0x20, r4l ; ' '
000024AC  3cbc                              mov.b   r4l, @0xFFFFFFBC:8
000024AE  fc00                              mov.b   #0, r4l
000024B0  3cbd                              mov.b   r4l, @0xFFFFFFBD:8
000024B2  5470                              rts
000024B4  5470                              rts
000024B6  7a0700ff7f00             loc_24B6 mov.l   #0xFF7F00, sp
000024BC  6a18aa317250                      bclr    #5, @0xFFFFAA31:16
000024C2  fc00                              mov.b   #0, r4l
000024C4  6a8c8004                          mov.b   r4l, @0xFFFF8004:16
000024C8  79040111                          mov.w   #0x111, r4
000024CC  6b84fdc4                          mov.w   r4, @0xFFFFFDC4:16
000024D0  fc00                              mov.b   #0, r4l
000024D2  6a8cfbc2                          mov.b   r4l, @0xFFFFFBC2:16
000024D6  fca0                              mov.b   #0xA0, r4l
000024D8  6a8cfbc6                          mov.b   r4l, @0xFFFFFBC6:16
000024DC  fc0c                              mov.b   #0xC, r4l
000024DE  6a8cfbcb                          mov.b   r4l, @0xFFFFFBCB:16
000024E2  fc00                              mov.b   #0, r4l
000024E4  6a8cfbcd                          mov.b   r4l, @0xFFFFFBCD:16
000024E8  fc00                              mov.b   #0, r4l
000024EA  6a8cfbcc                          mov.b   r4l, @0xFFFFFBCC:16
000024EE  0000                              nop
000024F0  0000                              nop
000024F2  7904d103                          mov.w   #0xD103, r4
000024F6  6b84fdc2                          mov.w   r4, @0xFFFFFDC2:16
000024FA  fc00                              mov.b   #0, r4l
000024FC  3c32                              mov.b   r4l, @0xFFFFFF32:8
000024FE  7a0600000000                      mov.l   #0, er6
00002504  7a0400ff7300                      mov.l   #0xFF7300, er4
0000250A  7a0500fee000                      mov.l   #0xFEE000, er5
00002510  1ad4                              sub.l   er5, er4
00002512  1174                              shlr.l  #2, er4
00002514  010069d6                 loc_2514 mov.l   er6, @er5
00002518  0b95                              adds    #4, er5
0000251A  1b74                              dec.l   #1, er4
0000251C  46f6                              bne     loc_2514:8
0000251E  790404ae                          mov.w   #0x4AE, r4
00002522  7a050007b2a6                      mov.l   #(loc_7B2A5+1), er5
00002528  7a0600ff6034                      mov.l   #0xFF6034, er6
0000252E  7bd4598f                 loc_252E eepmov.w
00002532  0d44                              mov.w   r4, r4
00002534  46f8                              bne     loc_252E:8
00002536  79040000                          mov.w   #0, r4
0000253A  6b84ff34                          mov.w   r4, @0xFFFFFF34:16
0000253E  fc00                              mov.b   #0, r4l
00002540  3c5e                              mov.b   r4l, @0xFFFFFF5E:8
00002542  fc30                              mov.b   #0x30, r4l ; '0'
00002544  6a8cfbb6                          mov.b   r4l, @0xFFFFFBB6:16
00002548  fc00                              mov.b   #0, r4l
0000254A  6a8cfb8e                          mov.b   r4l, @0xFFFFFB8E:16
0000254E  fc00                              mov.b   #0, r4l
00002550  6a8cfbbd                          mov.b   r4l, @0xFFFFFBBD:16
00002554  6b04ff36                          mov.w   @0xFFFFFF36:16, r4
00002558  723c                              bclr    #3, r4l
0000255A  6b84ff36                          mov.w   r4, @0xFFFFFF36:16
0000255E  fe0c                              mov.b   #0xC, r6l
00002560  5e00246c                 loc_2560 jsr     sub_246C:24
00002564  2a4e                              mov.b   @0xFFFFFF4E:8, r2l
00002566  ea40                              and.b   #0x40, r2l
00002568  470c                              beq     loc_2576:8
0000256A  1a0e                              dec.b   r6l
0000256C  46f2                              bne     loc_2560:8
0000256E  5e0020f6                          jsr     sub_20F6:24
00002572  5a00dc5a                          jmp     loc_DC5A:24
00002576  79047cf4                 loc_2576 mov.w   #0x7CF4, r4
0000257A  6b84fdc8                          mov.w   r4, @0xFFFFFDC8:16
0000257E  7904ffff                          mov.w   #0xFFFF, r4
00002582  6b84fdca                          mov.w   r4, @0xFFFFFDCA:16
00002586  7904cd00                          mov.w   #0xCD00, r4
0000258A  6b84fdcc                          mov.w   r4, @0xFFFFFDCC:16
0000258E  fc00                              mov.b   #0, r4l
00002590  3ca0                              mov.b   r4l, @0xFFFFFFA0:8
00002592  3ca1                              mov.b   r4l, @0xFFFFFFA1:8
00002594  5e002482                          jsr     sub_2482:24
00002598  6a18817f7250                      bclr    #5, @0xFFFF817F:16
0000259E  5e003466                          jsr     sub_3466:24
000025A2  4504                              bcs     loc_25A8:8
000025A4  5e03e9f8                          jsr     loc_3E9F8:24
000025A8  5a0027ae                 loc_25A8 jmp     loc_27AE:24
000025AC  5e007fce                 loc_25AC jsr     sub_7FCE:24
000025B0  5e071044                          jsr     loc_71042+2:24
000025B4  5e074b08                          jsr     sub_74B08:24
000025B8  5e00246c                          jsr     sub_246C:24
000025BC  5e037a14                          jsr     sub_37A14:24
000025C0  5e037a30                          jsr     sub_37A30:24
000025C4  5e037a4c                          jsr     sub_37A4C:24
000025C8  fc10                              mov.b   #0x10, r4l
000025CA  f400                              mov.b   #0, r4h
000025CC  7a050000245c                      mov.l   #0x245C, er5
000025D2  7a0600ffa998                      mov.l   #0xFFA998, er6
000025D8  7bd4598f                 loc_25D8 eepmov.w
000025DC  0d44                              mov.w   r4, r4
000025DE  46f8                              bne     loc_25D8:8
000025E0  fc10                              mov.b   #0x10, r4l
000025E2  f400                              mov.b   #0, r4h
000025E4  7a050000245c                      mov.l   #0x245C, er5
000025EA  7a0600ffa9a8                      mov.l   #0xFFA9A8, er6
000025F0  7bd4598f                 loc_25F0 eepmov.w
000025F4  0d44                              mov.w   r4, r4
000025F6  46f8                              bne     loc_25F0:8
000025F8  5e003490                          jsr     sub_3490:24
000025FC  fcc8                              mov.b   #0xC8, r4l
000025FE  6a1089c17360                      btst    #6, @0xFFFF89C1:16
00002604  470e                              beq     loc_2614:8
00002606  5e03e7ee                          jsr     sub_3E7EE:24
0000260A  79040808                          mov.w   #0x808, r4
0000260E  6b84fbce                          mov.w   r4, @0xFFFFFBCE:16
00002612  fcc7                              mov.b   #0xC7, r4l
00002614  5e0394d2                 loc_2614 jsr     sub_394D2:24
00002618  6a10aa337300                      btst    #0, @0xFFFFAA33:16
0000261E  4610                              bne     loc_2630:8
00002620  6a0c8dde                          mov.b   @0xFFFF8DDE:16, r4l
00002624  4706                              beq     loc_262C:8
00002626  4b04                              bmi     loc_262C:8
00002628  551e                              bsr     sub_2648:8
0000262A  4004                              bra     loc_2630:8
0000262C  5e039ba0                 loc_262C jsr     sub_39BA0:24
00002630  6a18817f7250             loc_2630 bclr    #5, @0xFFFF817F:16
00002636  5e003466                          jsr     sub_3466:24
0000263A  4504                              bcs     loc_2640:8
0000263C  5e03ea28                          jsr     loc_3EA28:24
00002640  7f5a7260                 loc_2640 bclr    #6, @0xFFFFFF5A:8
00002644  5a0027ae                          jmp     loc_27AE:24
00002648  6a10aa317350             sub_2648 btst    #5, @0xFFFFAA31:16  ; <<< FUNC sub_2648
0000264E  472a                              beq     locret_267A:8
00002650  01006b048006                      mov.l   @0xFFFF8006:16, er4
00002656  01006b250000dd0e                  mov.l   @unk_DD0E:32, er5
0000265E  1fc5                              cmp.l   er4, er5
00002660  4618                              bne     locret_267A:8
00002662  6a048de1                          mov.b   @0xFFFF8DE1:16, r4h
00002666  6a0c8f4c                          mov.b   @0xFFFF8F4C:16, r4l
0000266A  1c4c                              cmp.b   r4h, r4l
0000266C  470c                              beq     locret_267A:8
0000266E  6a8c8de1                          mov.b   r4l, @0xFFFF8DE1:16
00002672  5e019a64                          jsr     sub_19A64:24
00002676  5e039cca                          jsr     sub_39CCA:24
0000267A  5470                     locret_267A rts
0000267C  7a0700ff7f00             nmi_handler mov.l   #0xFF7F00, sp  ; <<< FUNC nmi_handler
00002682  6a0cfba5                          mov.b   @0xFFFFFBA5:16, r4l
00002686  ecf0                              and.b   #0xF0, r4l
00002688  6a8cfba5                          mov.b   r4l, @0xFFFFFBA5:16
0000268C  5e007ff6                          jsr     loc_7FF6:24
00002690  5e03347e                          jsr     sub_3347E:24
00002694  5e074b08                          jsr     sub_74B08:24
00002698  7a04000007d0                      mov.l   #0x7D0, er4
0000269E  5e002472                          jsr     sub_2472:24
000026A2  5e037a14                          jsr     sub_37A14:24
000026A6  5e037a30                          jsr     sub_37A30:24
000026AA  5e037a4c                          jsr     sub_37A4C:24
000026AE  fc10                              mov.b   #0x10, r4l
000026B0  f400                              mov.b   #0, r4h
000026B2  7a050000245c                      mov.l   #0x245C, er5
000026B8  7a0600ffa998                      mov.l   #0xFFA998, er6
000026BE  7bd4598f                 loc_26BE eepmov.w
000026C2  0d44                              mov.w   r4, r4
000026C4  46f8                              bne     loc_26BE:8
000026C6  fc10                              mov.b   #0x10, r4l
000026C8  f400                              mov.b   #0, r4h
000026CA  7a050000245c                      mov.l   #0x245C, er5
000026D0  7a0600ffa9a8                      mov.l   #0xFFA9A8, er6
000026D6  7bd4598f                 loc_26D6 eepmov.w
000026DA  0d44                              mov.w   r4, r4
000026DC  46f8                              bne     loc_26D6:8
000026DE  5e003490                          jsr     sub_3490:24
000026E2  fc00                              mov.b   #0, r4l
000026E4  3c69                              mov.b   r4l, @0xFFFFFF69:8
000026E6  fc00                              mov.b   #0, r4l
000026E8  3c68                              mov.b   r4l, @0xFFFFFF68:8
000026EA  5e0452c6                          jsr     sub_452C6:24
000026EE  790407d0                          mov.w   #0x7D0, r4
000026F2  0000                     loc_26F2 nop
000026F4  0000                              nop
000026F6  0000                              nop
000026F8  0000                              nop
000026FA  0000                              nop
000026FC  1b54                              dec.w   #1, r4
000026FE  46f2                              bne     loc_26F2:8
00002700  7f5a7260                          bclr    #6, @0xFFFFFF5A:8
00002704  fc03                              mov.b   #3, r4l
00002706  6a8cfba4                          mov.b   r4l, @0xFFFFFBA4:16
0000270A  fc03                              mov.b   #3, r4l
0000270C  6a8cfbb8                          mov.b   r4l, @0xFFFFFBB8:16
00002710  fc03                              mov.b   #3, r4l
00002712  6a8cfba8                          mov.b   r4l, @0xFFFFFBA8:16
00002716  6a8c816e                          mov.b   r4l, @0xFFFF816E:16
0000271A  fa00                              mov.b   #0, r2l
0000271C  fc1f                              mov.b   #0x1F, r4l
0000271E  3c6a                              mov.b   r4l, @0xFFFFFF6A:8
00002720  6a8afb80                          mov.b   r2l, @0xFFFFFB80:16
00002724  6a8afb81                          mov.b   r2l, @0xFFFFFB81:16
00002728  6a8afb82                          mov.b   r2l, @0xFFFFFB82:16
0000272C  6a8afb85                          mov.b   r2l, @0xFFFFFB85:16
00002730  6a8afb8a                          mov.b   r2l, @0xFFFFFB8A:16
00002734  6a8afb8b                          mov.b   r2l, @0xFFFFFB8B:16
00002738  6a8afb8c                          mov.b   r2l, @0xFFFFFB8C:16
0000273C  6a8afb8d                          mov.b   r2l, @0xFFFFFB8D:16
00002740  6a8afb8e                          mov.b   r2l, @0xFFFFFB8E:16
00002744  6a8afba9                          mov.b   r2l, @0xFFFFFBA9:16
00002748  6a8aee50                          mov.b   r2l, @0xFFFFEE50:16
0000274C  7f5a7060                          bset    #6, @0xFFFFFF5A:8
00002750  6b04fdc8                          mov.w   @0xFFFFFDC8:16, r4
00002754  705c                              bset    #5, r4l
00002756  703c                              bset    #3, r4l
00002758  6b84fdc8                          mov.w   r4, @0xFFFFFDC8:16
0000275C  6b04fdca                          mov.w   @0xFFFFFDCA:16, r4
00002760  7044                              bset    #4, r4h
00002762  6b84fdca                          mov.w   r4, @0xFFFFFDCA:16
00002766  6b04fdcc                          mov.w   @0xFFFFFDCC:16, r4
0000276A  7014                              bset    #1, r4h
0000276C  6b84fdcc                          mov.w   r4, @0xFFFFFDCC:16
00002770  7f597230                          bclr    #3, @0xFFFFFF59:8
00002774  6a18817f7250                      bclr    #5, @0xFFFF817F:16
0000277A  6a10aa337300                      btst    #0, @0xFFFFAA33:16
00002780  462c                              bne     loc_27AE:8
00002782  6a0c8dde                          mov.b   @0xFFFF8DDE:16, r4l
00002786  4708                              beq     loc_2790:8
00002788  4b06                              bmi     loc_2790:8
0000278A  5e002648                          jsr     sub_2648:24
0000278E  401e                              bra     loc_27AE:8
00002790  01006b048006             loc_2790 mov.l   @0xFFFF8006:16, er4
00002796  01006b250000dd0e                  mov.l   @unk_DD0E:32, er5
0000279E  1fc5                              cmp.l   er4, er5
000027A0  460c                              bne     loc_27AE:8
000027A2  6a0c8002                          mov.b   @0xFFFF8002:16, r4l
000027A6  5e0394d2                          jsr     sub_394D2:24
000027AA  5e039ba0                          jsr     sub_39BA0:24
000027AE  0480                     loc_27AE orc     #0x80, ccr
000027B0  6a18ee2d7220                      bclr    #2, @0xFFFFEE2D:16
000027B6  fc00                              mov.b   #0, r4l
000027B8  6a8cee04                          mov.b   r4l, @0xFFFFEE04:16
000027BC  6a8cee05                          mov.b   r4l, @0xFFFFEE05:16
000027C0  6a8cee06                          mov.b   r4l, @0xFFFFEE06:16
000027C4  79020000                          mov.w   #0, r2
000027C8  fc1f                              mov.b   #0x1F, r4l
000027CA  3c6a                              mov.b   r4l, @0xFFFFFF6A:8
000027CC  6a8afb80                          mov.b   r2l, @0xFFFFFB80:16
000027D0  6a8afb81                          mov.b   r2l, @0xFFFFFB81:16
000027D4  6a8afb82                          mov.b   r2l, @0xFFFFFB82:16
000027D8  6a8afb85                          mov.b   r2l, @0xFFFFFB85:16
000027DC  6a8afb89                          mov.b   r2l, @0xFFFFFB89:16
000027E0  6a8afb8a                          mov.b   r2l, @0xFFFFFB8A:16
000027E4  6a8afb8b                          mov.b   r2l, @0xFFFFFB8B:16
000027E8  6a8afb8c                          mov.b   r2l, @0xFFFFFB8C:16
000027EC  6a8afb8d                          mov.b   r2l, @0xFFFFFB8D:16
000027F0  6a8afb8e                          mov.b   r2l, @0xFFFFFB8E:16
000027F4  6a8afba8                          mov.b   r2l, @0xFFFFFBA8:16
000027F8  6a8afba9                          mov.b   r2l, @0xFFFFFBA9:16
000027FC  6a8aee50                          mov.b   r2l, @0xFFFFEE50:16
00002800  6a8afbb4                          mov.b   r2l, @0xFFFFFBB4:16
00002804  6a8afbb5                          mov.b   r2l, @0xFFFFFBB5:16
00002808  6a8afbb6                          mov.b   r2l, @0xFFFFFBB6:16
0000280C  fc03                              mov.b   #3, r4l
0000280E  6a8cfbb8                          mov.b   r4l, @0xFFFFFBB8:16
00002812  6a8afbb9                          mov.b   r2l, @0xFFFFFBB9:16
00002816  5e00284e                          jsr     sub_284E:24
0000281A  79048e00                          mov.w   #0x8E00, r4
0000281E  6b84fdc6                          mov.w   r4, @0xFFFFFDC6:16
