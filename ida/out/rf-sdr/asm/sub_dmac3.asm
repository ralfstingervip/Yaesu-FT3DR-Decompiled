; window dmac3 file 332DA0-333000 map FFF32DA0-FFF33000 forced 190
; ==== dmac3  FFF32DA0-FFF33000 ====
FFF32DA0  1a                                bne.s   loc_FFF32DA8+2
FFF32DA1  762fda00                          and     #0DAh, r15
FFF32DA5  c7ef9c                            mov.b   r15, 9Ch[r14]
FFF32DA8  fbee07c108               loc_FFF32DA8 mov.l   #8C107h, r14
FFF32DAD  59ef9d                            movu.b  9Dh[r14], r15
FFF32DB0  753f1a                            or      #1Ah, r15
FFF32DB3  762fda00                          and     #0DAh, r15
FFF32DB7  c7ef9d                            mov.b   r15, 9Dh[r14]
FFF32DBA  fbee07c108                        mov.l   #8C107h, r14
FFF32DBF  f1ee18                            bclr    #6, 18h[r14].b
FFF32DC2  fbee07c108                        mov.l   #8C107h, r14
FFF32DC7  f1e718                            bset    #7, 18h[r14].b
FFF32DCA  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DCF  f0ef                              bclr    #7, [r14].b
FFF32DD1  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DD6  5aef6201                          movu.b  162h[r14], r15
FFF32DDA  656f                              or      #6, r15
FFF32DDC  762ff600                          and     #0F6h, r15
FFF32DE0  cbef6201                          mov.b   r15, 162h[r14]
FFF32DE4  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DE9  72ee6704                          add     #467h, r14, r14
FFF32DED  ecef                              mov.l   [r14], r15
FFF32DEF  783f                              bset    #3, r15
FFF32DF1  e3ef                              mov.l   r15, [r14]
FFF32DF3  fbee0d7208                        mov.l   #8720Dh, r14
FFF32DF8  f0e7                              bset    #7, [r14].b
FFF32DFA  02                                rts
FFF32DFB  6eef                     loc_FFF32DFB pushm   r14-r15
FFF32DFD  6e15                              pushm   r1-r5
FFF32DFF  05230300                          bsr.a   sub_FFF33122
FFF32E03  6f15                              popm    r1-r5
FFF32E05  6fef                              popm    r14-r15
FFF32E07  7f95                              rte
FFF32E09  6040                              sub     #4, sp
FFF32E0B  fbee002208                        mov.l   #82200h, r14
FFF32E10  f8e400                            mov.b   #0, [r14]
FFF32E13  399100                            bsr.w   sub_FFF32EA4
FFF32E16  fb1ed02008                        mov.l   #820D0h, r1
FFF32E1B  3c1c00                            mov.b   #0, 0Ch[r1]
FFF32E1E  fbee057208                        mov.l   #87205h, r14
FFF32E23  f0ec                              bclr    #4, [r14].b
FFF32E25  fbee057208                        mov.l   #87205h, r14
FFF32E2A  f1eb0a                            bclr    #3, 0Ah[r14].b
FFF32E2D  fbee057208                        mov.l   #87205h, r14
FFF32E32  fae407022c                        mov.b   #2Ch, 207h[r14] ; ','
FFF32E37  fbee057208                        mov.l   #87205h, r14
FFF32E3C  5aef2701                          movu.b  127h[r14], r15
FFF32E40  655f                              or      #5, r15
FFF32E42  762ff500                          and     #0F5h, r15
FFF32E46  cbef2701                          mov.b   r15, 127h[r14]
FFF32E4A  fbee057208                        mov.l   #87205h, r14
FFF32E4F  5aef7601                          movu.b  176h[r14], r15
FFF32E53  782f                              bset    #2, r15
FFF32E55  762ff400                          and     #0F4h, r15
FFF32E59  cbef7601                          mov.b   r15, 176h[r14]
FFF32E5D  fb1ed02008                        mov.l   #820D0h, r1
FFF32E62  3d1280                            mov.w   #-80h, 4[r1]
FFF32E65  fbeed02008                        mov.l   #820D0h, r14
FFF32E6A  f8e90192                          mov.w   #-6DFFh, [r14]
FFF32E6E  fb1ed02008                        mov.l   #820D0h, r1
FFF32E73  3c1f00                            mov.b   #0, 0Fh[r1]
FFF32E76  fbeed02008                        mov.l   #820D0h, r14
FFF32E7B  f1e00f                            bset    #0, 0Fh[r14].b
FFF32E7E  fb1ed02008                        mov.l   #820D0h, r1
FFF32E83  3c1310                            mov.b   #10h, 3[r1]
FFF32E86  fbee057208                        mov.l   #87205h, r14
FFF32E8B  f0e4                              bset    #4, [r14].b
FFF32E8D  fbee057208                        mov.l   #87205h, r14
FFF32E92  f1e30a                            bset    #3, 0Ah[r14].b
FFF32E95  fbee002208                        mov.l   #82200h, r14
FFF32E9A  f8e401                            mov.b   #1, [r14]
FFF32E9D  f80600                            mov.l   #0, [sp]
FFF32EA0  6601                              mov.l   #0, r1
FFF32EA2  6701                              rtsd    #1
FFF32EA4  fbeede2008               sub_FFF32EA4 mov.l   #820DEh, r14  ; <<< FUNC sub_FFF32EA4
FFF32EA9  f0ec                              bclr    #4, [r14].b
FFF32EAB  02                                rts
FFF32EAC  6080                              sub     #8, sp
FFF32EAE  a009                              mov.l   r1, 4[sp]
FFF32EB0  e302                              mov.l   r2, [sp]
FFF32EB2  6702                              rtsd    #2
FFF32EB4  60c0                              sub     #0Ch, sp
FFF32EB6  a081                              mov.l   r1, 8[sp]
FFF32EB8  a00a                              mov.l   r2, 4[sp]
FFF32EBA  e303                              mov.l   r3, [sp]
FFF32EBC  fb1ec02008                        mov.l   #820C0h, r1
FFF32EC1  3d1a80                            mov.w   #-80h, 14h[r1]
FFF32EC4  fbeec02008                        mov.l   #820C0h, r14
FFF32EC9  f9e9080192                        mov.w   #-6DFFh, 10h[r14]
FFF32ECE  fb1ec02008                        mov.l   #820C0h, r1
FFF32ED3  3c9c00                            mov.b   #0, 1Ch[r1]
FFF32ED6  fbeec02008                        mov.l   #820C0h, r14
FFF32EDB  e10e01                            mov.l   4[sp], [r14]
FFF32EDE  fbeec02008                        mov.l   #820C0h, r14
FFF32EE3  e50e0201                          mov.l   8[sp], 4[r14]
FFF32EE7  fbeec02008                        mov.l   #820C0h, r14
FFF32EEC  f9e20200008000                    mov.l   #800000h, 8[r14]
FFF32EF3  fb1ec02008                        mov.l   #820C0h, r1
FFF32EF8  a892                              mov.l   8[r1], r2
FFF32EFA  7872                              bset    #7, r2
FFF32EFC  a092                              mov.l   r2, 8[r1]
FFF32EFE  ec01                              mov.l   [sp], r1
FFF32F00  fb2ec02008                        mov.l   #820C0h, r2
FFF32F05  91a1                              mov.w   r1, 0Ch[r2]
FFF32F07  fb1ec02008                        mov.l   #820C0h, r1
FFF32F0C  3c9c01                            mov.b   #1, 1Ch[r1]
FFF32F0F  6703                              rtsd    #3
FFF32F11  60c0                              sub     #0Ch, sp
FFF32F13  3e0100                            mov.l   #0, 4[sp]
FFF32F16  2e24                              bra.b   loc_FFF32F3A
FFF32F18  fb1edc2008               loc_FFF32F18 mov.l   #820DCh, r1
FFF32F1D  b091                              movu.b  2[r1], r1
FFF32F1F  6871                              shlr    #7, r1
FFF32F21  8289                              mov.b   r1, 0Bh[sp]
FFF32F23  f5000b                            btst    #0, 0Bh[sp].b
FFF32F26  15                                beq.s   loc_FFF32F2B
FFF32F27  f80600                            mov.l   #0, [sp]
FFF32F2A  0c                                bra.s   loc_FFF32F2E
FFF32F2B  f80601                   loc_FFF32F2B mov.l   #1, [sp]
FFF32F2E  ec01                     loc_FFF32F2E mov.l   [sp], r1
FFF32F30  6101                              cmp     #0, r1
FFF32F32  2111                              bne.b   loc_FFF32F43
FFF32F34  a809                              mov.l   4[sp], r1
FFF32F36  6211                              add     #1, r1
FFF32F38  a009                              mov.l   r1, 4[sp]
FFF32F3A  a809                     loc_FFF32F3A mov.l   4[sp], r1
FFF32F3C  7701000010                        cmp     #100000h, r1
FFF32F41  23d7                              bltu.b  loc_FFF32F18
FFF32F43  fbeedc2008               loc_FFF32F43 mov.l   #820DCh, r14
FFF32F48  f8e400                            mov.b   #0, [r14]
FFF32F4B  6703                              rtsd    #3
FFF32F4D  60c0                              sub     #0Ch, sp
FFF32F4F  a081                              mov.l   r1, 8[sp]
FFF32F51  a00a                              mov.l   r2, 4[sp]
FFF32F53  e303                              mov.l   r3, [sp]
FFF32F55  fbeec02008                        mov.l   #820C0h, r14
FFF32F5A  f9e90a0080                        mov.w   #-8000h, 14h[r14]
FFF32F5F  fbeec02008                        mov.l   #820C0h, r14
FFF32F64  f9e9080182                        mov.w   #-7DFFh, 10h[r14]
FFF32F69  fb1ec02008                        mov.l   #820C0h, r1
FFF32F6E  3c9c00                            mov.b   #0, 1Ch[r1]
FFF32F71  fbeec02008                        mov.l   #820C0h, r14
FFF32F76  e10e01                            mov.l   4[sp], [r14]
FFF32F79  fbeec02008                        mov.l   #820C0h, r14
FFF32F7E  e50e0201                          mov.l   8[sp], 4[r14]
FFF32F82  fbeec02008                        mov.l   #820C0h, r14
FFF32F87  f9e20200008000                    mov.l   #800000h, 8[r14]
FFF32F8E  fb1ec02008                        mov.l   #820C0h, r1
FFF32F93  a892                              mov.l   8[r1], r2
FFF32F95  7872                              bset    #7, r2
FFF32F97  a092                              mov.l   r2, 8[r1]
FFF32F99  ec01                              mov.l   [sp], r1
FFF32F9B  fb2ec02008                        mov.l   #820C0h, r2
FFF32FA0  91a1                              mov.w   r1, 0Ch[r2]
FFF32FA2  fb1ec02008                        mov.l   #820C0h, r1
FFF32FA7  3c9c01                            mov.b   #1, 1Ch[r1]
FFF32FAA  6703                              rtsd    #3
FFF32FAC  60c0                              sub     #0Ch, sp
FFF32FAE  3e0100                            mov.l   #0, 4[sp]
FFF32FB1  2e24                              bra.b   loc_FFF32FD5
FFF32FB3  fb1edc2008               loc_FFF32FB3 mov.l   #820DCh, r1
FFF32FB8  b091                              movu.b  2[r1], r1
FFF32FBA  6871                              shlr    #7, r1
FFF32FBC  8289                              mov.b   r1, 0Bh[sp]
FFF32FBE  f5000b                            btst    #0, 0Bh[sp].b
FFF32FC1  15                                beq.s   loc_FFF32FC6
FFF32FC2  f80600                            mov.l   #0, [sp]
FFF32FC5  0c                                bra.s   loc_FFF32FC9
FFF32FC6  f80601                   loc_FFF32FC6 mov.l   #1, [sp]
FFF32FC9  ec01                     loc_FFF32FC9 mov.l   [sp], r1
FFF32FCB  6101                              cmp     #0, r1
FFF32FCD  2111                              bne.b   loc_FFF32FDE
FFF32FCF  a809                              mov.l   4[sp], r1
FFF32FD1  6211                              add     #1, r1
FFF32FD3  a009                              mov.l   r1, 4[sp]
FFF32FD5  a809                     loc_FFF32FD5 mov.l   4[sp], r1
FFF32FD7  7701000010                        cmp     #100000h, r1
FFF32FDC  23d7                              bltu.b  loc_FFF32FB3
FFF32FDE  fbeedc2008               loc_FFF32FDE mov.l   #820DCh, r14
FFF32FE3  f8e400                            mov.b   #0, [r14]
FFF32FE6  6703                              rtsd    #3
FFF32FE8  6040                              sub     #4, sp
FFF32FEA  fbe23c950600                      mov.l   #6953Ch, r14
FFF32FF0  f8e600                            mov.l   #0, [r14]
FFF32FF3  f80600                            mov.l   #0, [sp]
FFF32FF6  6601                              mov.l   #0, r1
FFF32FF8  6701                              rtsd    #1
FFF32FFA  6040                     loc_FFF32FFA sub     #4, sp
FFF32FFC  e301                              mov.l   r1, [sp]
FFF32FFE  fbe23c950600                      mov.l   #6953Ch, r14
