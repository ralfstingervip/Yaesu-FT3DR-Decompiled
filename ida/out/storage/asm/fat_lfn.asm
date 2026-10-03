; ==== fat_lfn  FFF208C0-FFF20A40  (file 3208C0-320A40) ====
FFF208C0  755e2e                            cmp     #2Eh, r14 ; '.'
FFF208C3  2113                              bne.b   loc_FFF208D6
FFF208C5  b289                              movu.b  1Ch+var_11[sp], r1
FFF208C7  6191                              cmp     #9, r1
FFF208C9  2908                              blt.b   loc_FFF208D1
FFF208CB  f90601ff                          mov.l   #-1, 1Ch+var_18[sp]
FFF208CF  2e3d                              bra.b   loc_FFF2090C
FFF208D1  3c0a07                 loc_FFF208D1 mov.b   #7, 1Ch+var_12[sp]
FFF208D4  2e10                              bra.b   loc_FFF208E4
FFF208D6  b289                   loc_FFF208D6 movu.b  1Ch+var_11[sp], r1
FFF208D8  a90a                              mov.l   1Ch+var_8[sp], r2
FFF208DA  fec21e                            movu.b  [r2, r1], r14
FFF208DD  b281                              movu.b  1Ch+var_12[sp], r1
FFF208DF  a982                              mov.l   1Ch+var_4[sp], r2
FFF208E1  fe021e                            mov.b   r14, [r2, r1]
FFF208E4  b289                   loc_FFF208E4 movu.b  1Ch+var_11[sp], r1
FFF208E6  6211                              add     #1, r1
FFF208E8  8289                              mov.b   r1, 1Ch+var_11[sp]
FFF208EA  b281                              movu.b  1Ch+var_12[sp], r1
FFF208EC  6211                              add     #1, r1
FFF208EE  8281                              mov.b   r1, 1Ch+var_12[sp]
FFF208F0  b289                   loc_FFF208F0 movu.b  1Ch+var_11[sp], r1
FFF208F2  61b1                              cmp     #0Bh, r1
FFF208F4  2a0c                              bgt.b   loc_FFF20900
FFF208F6  b281                              movu.b  1Ch+var_12[sp], r1
FFF208F8  61b1                              cmp     #0Bh, r1
FFF208FA  2a06                              bgt.b   loc_FFF20900
FFF208FC  f80601                            mov.l   #1, 1Ch+var_1C[sp]
FFF208FF  0c                                bra.s   loc_FFF20903
FFF20900  f80600                 loc_FFF20900 mov.l   #0, 1Ch+var_1C[sp]
FFF20903  ec01                   loc_FFF20903 mov.l   1Ch+var_1C[sp], r1
FFF20905  6101                              cmp     #0, r1
FFF20907  21a7                              bne.b   loc_FFF208AE
FFF20909  3e0100                 loc_FFF20909 mov.l   #0, 1Ch+var_18[sp]
FFF2090C  a809                   loc_FFF2090C mov.l   1Ch+var_18[sp], r1
FFF2090E  a089                              mov.l   r1, 1Ch+var_10[sp]
FFF20910  6707                              rtsd    #7
FFF20912  7100f0                 sub_FFF20912 add     #-10h, sp, sp   ; <<<< FUNC sub_FFF20912
FFF20915  a089                              mov.l   r1, 10h+var_4[sp]
FFF20917  3c0300                            mov.b   #0, 10h+var_D[sp]
FFF2091A  3e0100                            mov.l   #0, 10h+var_C[sp]
FFF2091D  2e23                              bra.b   loc_FFF20940
FFF2091F  a809                   loc_FFF2091F mov.l   10h+var_C[sp], r1
FFF20921  a88a                              mov.l   10h+var_4[sp], r2
FFF20923  fec211                            movu.b  [r2, r1], r1
FFF20926  490103                            add     10h+var_D[sp], r1
FFF20929  8089                              mov.b   r1, 10h+var_D[sp]
FFF2092B  b089                              movu.b  10h+var_D[sp], r1
FFF2092D  6c71                              shll    #7, r1
FFF2092F  8081                              mov.b   r1, 10h+var_E[sp]
FFF20931  b089                              movu.b  10h+var_D[sp], r1
FFF20933  6811                              shlr    #1, r1
FFF20935  550102                            or      10h+var_E[sp], r1
FFF20938  8089                              mov.b   r1, 10h+var_D[sp]
FFF2093A  a809                              mov.l   10h+var_C[sp], r1
FFF2093C  6211                              add     #1, r1
FFF2093E  a009                              mov.l   r1, 10h+var_C[sp]
FFF20940  a809                   loc_FFF20940 mov.l   10h+var_C[sp], r1
FFF20942  61a1                              cmp     #0Ah, r1
FFF20944  29db                              blt.b   loc_FFF2091F
FFF20946  a809                              mov.l   10h+var_C[sp], r1
FFF20948  a88a                              mov.l   10h+var_4[sp], r2
FFF2094A  fec211                            movu.b  [r2, r1], r1
FFF2094D  490103                            add     10h+var_D[sp], r1
FFF20950  8289                              mov.b   r1, 10h+var_5[sp]
FFF20952  b289                              movu.b  10h+var_5[sp], r1
FFF20954  5b11                              movu.b  r1, r1
FFF20956  6704                              rtsd    #4
FFF20958  7100e8                 sub_FFF20958 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF20958
FFF2095B  a109                              mov.l   r1, 18h+var_4[sp]
FFF2095D  fbe2f0adf4ff                      mov.l   #asc_FFF4ADF0, r14; "+,;=[]"
FFF20963  c4e005                            mov.b   [r14], 18h+var_13[sp]
FFF20966  c5e00106                          mov.b   1[r14], 18h+var_12[sp]
FFF2096A  c5e00207                          mov.b   2[r14], 18h+var_11[sp]
FFF2096E  c5e00308                          mov.b   3[r14], 18h+var_10[sp]
FFF20972  c5e00409                          mov.b   4[r14], 18h+var_F[sp]
FFF20976  c5e0050a                          mov.b   5[r14], 18h+var_E[sp]
FFF2097A  c5e0060b                          mov.b   6[r14], 18h+var_D[sp]
FFF2097E  3e0300                            mov.l   #0, 18h+var_C[sp]
FFF20981  2e1c                              bra.b   loc_FFF2099D
FFF20983  a889                   loc_FFF20983 mov.l   18h+var_C[sp], r1
FFF20985  710e05                            add     #18h+var_13, sp, r14
FFF20988  fe4e1e                            mov.b   [r14, r1], r14
FFF2098B  a909                              mov.l   18h+var_4[sp], r1
FFF2098D  cc1f                              mov.b   [r1], r15
FFF2098F  47ef                              cmp     r14, r15
FFF20991  1e                                bne.s   loc_FFF20997
FFF20992  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20995  2e17                              bra.b   loc_FFF209AC
FFF20997  a889                   loc_FFF20997 mov.l   18h+var_C[sp], r1
FFF20999  6211                              add     #1, r1
FFF2099B  a089                              mov.l   r1, 18h+var_C[sp]
FFF2099D  a889                   loc_FFF2099D mov.l   18h+var_C[sp], r1
FFF2099F  710e05                            add     #18h+var_13, sp, r14
FFF209A2  fe4e1e                            mov.b   [r14, r1], r14
FFF209A5  610e                              cmp     #0, r14
FFF209A7  21dc                              bne.b   loc_FFF20983
FFF209A9  f80600                            mov.l   #0, 18h+var_18[sp]
FFF209AC  ec01                   loc_FFF209AC mov.l   18h+var_18[sp], r1
FFF209AE  a101                              mov.l   r1, 18h+var_8[sp]
FFF209B0  6706                              rtsd    #6
FFF209B2  7100e8                 sub_FFF209B2 add     #-18h, sp, sp   ; <<<< FUNC sub_FFF209B2
FFF209B5  a109                              mov.l   r1, 18h+var_4[sp]
FFF209B7  a102                              mov.l   r2, 18h+var_8[sp]
FFF209B9  f90e03a08601                      mov.l   #186A0h, 18h+var_C[sp]
FFF209BF  e5000501                          mov.l   18h+var_4[sp], 18h+var_14[sp]
FFF209C3  a909                              mov.l   18h+var_4[sp], r1
FFF209C5  f81400                            mov.b   #0, [r1]
FFF209C8  a901                              mov.l   18h+var_8[sp], r1
FFF209CA  770140420f                        cmp     #0F4240h, r1
FFF209CF  2308                              bltu.b  loc_FFF209D7
FFF209D1  f90e043f420f                      mov.l   #0F423Fh, 18h+var_8[sp]
FFF209D7  a901                   loc_FFF209D7 mov.l   18h+var_8[sp], r1
FFF209D9  06a1090103                        divu    18h+var_C[sp].l, r1
FFF209DE  8289                              mov.b   r1, 18h+var_D[sp]
FFF209E0  8a89                              mov.b   18h+var_D[sp], r1
FFF209E2  6101                              cmp     #0, r1
FFF209E4  2b1d                              ble.b   loc_FFF20A01
FFF209E6  8a89                              mov.b   18h+var_D[sp], r1
FFF209E8  711130                            add     #30h, r1, r1 ; '0'
FFF209EB  a90a                              mov.l   18h+var_4[sp], r2
FFF209ED  c321                              mov.b   r1, [r2]
FFF209EF  a909                              mov.l   18h+var_4[sp], r1
FFF209F1  6211                              add     #1, r1
FFF209F3  a109                              mov.l   r1, 18h+var_4[sp]
FFF209F5  8a89                              mov.b   18h+var_D[sp], r1
FFF209F7  068d0103                          mul     18h+var_C[sp].l, r1
FFF209FB  a902                              mov.l   18h+var_8[sp], r2
FFF209FD  4312                              sub     r1, r2
FFF209FF  a102                              mov.l   r2, 18h+var_8[sp]
FFF20A01  8a89                   loc_FFF20A01 mov.b   18h+var_D[sp], r1
FFF20A03  6101                              cmp     #0, r1
FFF20A05  210d                              bne.b   loc_FFF20A12
FFF20A07  a809                              mov.l   18h+var_14[sp], r1
FFF20A09  cc1e                              mov.b   [r1], r14
FFF20A0B  610e                              cmp     #0, r14
FFF20A0D  15                                beq.s   loc_FFF20A12
FFF20A0E  f80601                            mov.l   #1, 18h+var_18[sp]
FFF20A11  0c                                bra.s   loc_FFF20A15
FFF20A12  f80600                 loc_FFF20A12 mov.l   #0, 18h+var_18[sp]
FFF20A15  ec01                   loc_FFF20A15 mov.l   18h+var_18[sp], r1
FFF20A17  6101                              cmp     #0, r1
FFF20A19  200d                              beq.b   loc_FFF20A26
FFF20A1B  a909                              mov.l   18h+var_4[sp], r1
FFF20A1D  f81430                            mov.b   #30h, [r1] ; '0'
FFF20A20  a909                              mov.l   18h+var_4[sp], r1
FFF20A22  6211                              add     #1, r1
FFF20A24  a109                              mov.l   r1, 18h+var_4[sp]
FFF20A26  a889                   loc_FFF20A26 mov.l   18h+var_C[sp], r1
FFF20A28  fd74910a                          divu    #0Ah, r1
FFF20A2C  a089                              mov.l   r1, 18h+var_C[sp]
FFF20A2E  a889                              mov.l   18h+var_C[sp], r1
FFF20A30  6101                              cmp     #0, r1
FFF20A32  21a5                              bne.b   loc_FFF209D7
FFF20A34  a909                              mov.l   18h+var_4[sp], r1
FFF20A36  f81400                            mov.b   #0, [r1]
FFF20A39  6706                              rtsd    #6
FFF20A3B  7100e8                 sub_FFF20A3B add     #-18h, sp, sp   ; <<<< FUNC sub_FFF20A3B
FFF20A3E  a109                              mov.l   r1, 18h+var_4[sp]
