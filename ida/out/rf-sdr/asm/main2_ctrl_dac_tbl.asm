; ==== ctrl_dac_tbl  00003560-00003600 ====
00003560  7200                              bclr    #0, r0h
00003562  7f5a7050                          bset    #5, @0xFFFFFF5A:8
00003566  7f5a7210                          bclr    #1, @0xFFFFFF5A:8
0000356A  5470                              rts
0000356C  0804                              add.b   r0h, r4h
0000356E  0c02                              mov.b   r0h, r2h
00003570  0a06                              inc.b   r6h
00003572  0e01                              addx    r0h, r1h
00003574  5470                     locret_3574 rts
00003576  6a0c94b8                 sub_3576 mov.b   @0xFFFF94B8:16, r4l  ; <<< FUNC sub_3576
0000357A  46f8                              bne     locret_3574:8
0000357C  fc02                              mov.b   #2, r4l
0000357E  6a8c94b8                          mov.b   r4l, @0xFFFF94B8:16
00003582  79060058                          mov.w   #0x58, r6 ; 'X'
00003586  7a0500ff9536                      mov.l   #0xFF9536, er5
0000358C  685c                     loc_358C mov.b   @er5, r4l
0000358E  4704                              beq     loc_3594:8
00003590  1a0c                              dec.b   r4l
00003592  68dc                              mov.b   r4l, @er5
00003594  0b05                     loc_3594 adds    #1, er5
00003596  1b56                              dec.w   #1, r6
00003598  46f2                              bne     loc_358C:8
0000359A  7906001c                          mov.w   #0x1C, r6
0000359E  7a0500ff95b2                      mov.l   #0xFF95B2, er5
000035A4  6954                     loc_35A4 mov.w   @er5, r4
000035A6  4704                              beq     loc_35AC:8
000035A8  1b54                              dec.w   #1, r4
000035AA  69d4                              mov.w   r4, @er5
000035AC  0b85                     loc_35AC adds    #2, er5
000035AE  1bd6                              dec.w   #2, r6
000035B0  46f2                              bne     loc_35A4:8
000035B2  f400                              mov.b   #0, r4h
000035B4  6a0cb47e                          mov.b   @0xFFFFB47E:16, r4l
000035B8  ac3f                              cmp.b   #0x3F, r4l ; '?'
000035BA  4404                              bcc     loc_35C0:8
000035BC  0a0c                              inc.b   r4l
000035BE  0cc4                              mov.b   r4l, r4h
000035C0  6a84b47e                 loc_35C0 mov.b   r4h, @0xFFFFB47E:16
000035C4  6a0c9534                          mov.b   @0xFFFF9534:16, r4l
000035C8  1a0c                              dec.b   r4l
000035CA  6a8c9534                          mov.b   r4l, @0xFFFF9534:16
000035CE  4674                              bne     locret_3644:8
000035D0  fc0a                              mov.b   #0xA, r4l
000035D2  6a8c9534                          mov.b   r4l, @0xFFFF9534:16
000035D6  79060024                          mov.w   #0x24, r6 ; '$'
000035DA  7a0500ff958e                      mov.l   #0xFF958E, er5
000035E0  685c                     loc_35E0 mov.b   @er5, r4l
000035E2  4704                              beq     loc_35E8:8
000035E4  1a0c                              dec.b   r4l
000035E6  68dc                              mov.b   r4l, @er5
000035E8  0b05                     loc_35E8 adds    #1, er5
000035EA  1b56                              dec.w   #1, r6
000035EC  46f2                              bne     loc_35E0:8
000035EE  7906001c                          mov.w   #0x1C, r6
000035F2  7a0500ff95ce                      mov.l   #0xFF95CE, er5
000035F8  6954                     loc_35F8 mov.w   @er5, r4
000035FA  4704                              beq     loc_3600:8
000035FC  1b54                              dec.w   #1, r4
000035FE  69d4                              mov.w   r4, @er5
