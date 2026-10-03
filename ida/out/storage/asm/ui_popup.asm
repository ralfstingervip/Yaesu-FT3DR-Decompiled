; ==== ui_popup  FFF0B800-FFF0C900  (file 30B800-30C900) ====
FFF0B800  5f31                   sub_FFF0B800 movu.w  r3, r1   ; <<<< FUNC sub_FFF0B800
FFF0B802  6604                              mov.l   #0, r4
FFF0B804  66d3                              mov.l   #0Dh, r3
FFF0B806  051d63fe                          bsr.a   sub_FFEF1B23
FFF0B80A  62c0                              add     #0Ch, sp
FFF0B80C  6706                              rtsd    #6
FFF0B80E  3c0907                 sub_FFF0B80E mov.b   #7, arg_5[sp]   ; <<<< FUNC sub_FFF0B80E
FFF0B811  b209                              movu.b  arg_5[sp], r1
FFF0B813  63e1                              mul     #0Eh, r1
FFF0B815  7542ca                            mov.l   #-36h, r2
FFF0B818  4312                              sub     r1, r2
FFF0B81A  fd748202                          div     #2, r2
FFF0B81E  9182                              mov.w   r2, arg_8[sp]
FFF0B820  ba81                              movu.w  arg_10[sp], r1
FFF0B822  06c90105                          add     arg_6[sp].uw, r1
FFF0B826  ba8b                              movu.w  arg_12[sp], r3
FFF0B828  06c90306                          add     arg_8[sp].uw, r3
FFF0B82C  b20a                              movu.b  arg_5[sp], r2
FFF0B82E  60c0                              sub     #0Ch, sp
FFF0B830  fb427caaf4ff                      mov.l   #aNoData, r4; "No Data"
FFF0B836  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B838  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B83A  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B83D  5f12                              movu.w  r1, r2
FFF0B83F  5f31                              movu.w  r3, r1
FFF0B841  6604                              mov.l   #0, r4
FFF0B843  66d3                              mov.l   #0Dh, r3
FFF0B845  05de62fe                          bsr.a   sub_FFEF1B23
FFF0B849  62c0                              add     #0Ch, sp
FFF0B84B  6706                              rtsd    #6
FFF0B84D  3c0909                 sub_FFF0B84D mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0B84D
FFF0B850  b209                              movu.b  arg_5[sp], r1
FFF0B852  63e1                              mul     #0Eh, r1
FFF0B854  7542ca                            mov.l   #-36h, r2
FFF0B857  4312                              sub     r1, r2
FFF0B859  fd748202                          div     #2, r2
FFF0B85D  9182                              mov.w   r2, arg_8[sp]
FFF0B85F  ba81                              movu.w  arg_10[sp], r1
FFF0B861  06c90105                          add     arg_6[sp].uw, r1
FFF0B865  ba8b                              movu.w  arg_12[sp], r3
FFF0B867  06c90306                          add     arg_8[sp].uw, r3
FFF0B86B  b20a                              movu.b  arg_5[sp], r2
FFF0B86D  60c0                              sub     #0Ch, sp
FFF0B86F  fb4284aaf4ff                      mov.l   #aConnected, r4; "Connected"
FFF0B875  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B877  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B879  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B87C  5f12                              movu.w  r1, r2
FFF0B87E  5f31                              movu.w  r3, r1
FFF0B880  6604                              mov.l   #0, r4
FFF0B882  66d3                              mov.l   #0Dh, r3
FFF0B884  059f62fe                          bsr.a   sub_FFEF1B23
FFF0B888  62c0                              add     #0Ch, sp
FFF0B88A  6706                              rtsd    #6
FFF0B88C  3c090d                 sub_FFF0B88C mov.b   #0Dh, arg_5[sp]   ; <<<< FUNC sub_FFF0B88C
FFF0B88F  b209                              movu.b  arg_5[sp], r1
FFF0B891  63e1                              mul     #0Eh, r1
FFF0B893  7542ca                            mov.l   #-36h, r2
FFF0B896  4312                              sub     r1, r2
FFF0B898  fd748202                          div     #2, r2
FFF0B89C  9182                              mov.w   r2, arg_8[sp]
FFF0B89E  ba81                              movu.w  arg_10[sp], r1
FFF0B8A0  06c90105                          add     arg_6[sp].uw, r1
FFF0B8A4  ba8b                              movu.w  arg_12[sp], r3
FFF0B8A6  06c90306                          add     arg_8[sp].uw, r3
FFF0B8AA  b20a                              movu.b  arg_5[sp], r2
FFF0B8AC  60c0                              sub     #0Ch, sp
FFF0B8AE  fb428eaaf4ff                      mov.l   #aNotConnected, r4; "Not Connected"
FFF0B8B4  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B8B6  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B8B8  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B8BB  5f12                              movu.w  r1, r2
FFF0B8BD  5f31                              movu.w  r3, r1
FFF0B8BF  6604                              mov.l   #0, r4
FFF0B8C1  66d3                              mov.l   #0Dh, r3
FFF0B8C3  056062fe                          bsr.a   sub_FFEF1B23
FFF0B8C7  62c0                              add     #0Ch, sp
FFF0B8C9  6706                              rtsd    #6
FFF0B8CB  3c090a                 sub_FFF0B8CB mov.b   #0Ah, arg_5[sp]   ; <<<< FUNC sub_FFF0B8CB
FFF0B8CE  b209                              movu.b  arg_5[sp], r1
FFF0B8D0  63e1                              mul     #0Eh, r1
FFF0B8D2  7542ca                            mov.l   #-36h, r2
FFF0B8D5  4312                              sub     r1, r2
FFF0B8D7  fd748202                          div     #2, r2
FFF0B8DB  9182                              mov.w   r2, arg_8[sp]
FFF0B8DD  ba81                              movu.w  arg_10[sp], r1
FFF0B8DF  06c90105                          add     arg_6[sp].uw, r1
FFF0B8E3  ba8b                              movu.w  arg_12[sp], r3
FFF0B8E5  06c90306                          add     arg_8[sp].uw, r3
FFF0B8E9  b20a                              movu.b  arg_5[sp], r2
FFF0B8EB  60c0                              sub     #0Ch, sp
FFF0B8ED  fb429caaf4ff                      mov.l   #aBusyError, r4; "Busy Error"
FFF0B8F3  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B8F5  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B8F7  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B8FA  5f12                              movu.w  r1, r2
FFF0B8FC  5f31                              movu.w  r3, r1
FFF0B8FE  6604                              mov.l   #0, r4
FFF0B900  66d3                              mov.l   #0Dh, r3
FFF0B902  052162fe                          bsr.a   sub_FFEF1B23
FFF0B906  62c0                              add     #0Ch, sp
FFF0B908  6706                              rtsd    #6
FFF0B90A  3c090d                 sub_FFF0B90A mov.b   #0Dh, arg_5[sp]   ; <<<< FUNC sub_FFF0B90A
FFF0B90D  b209                              movu.b  arg_5[sp], r1
FFF0B90F  63e1                              mul     #0Eh, r1
FFF0B911  7542ca                            mov.l   #-36h, r2
FFF0B914  4312                              sub     r1, r2
FFF0B916  fd748202                          div     #2, r2
FFF0B91A  9182                              mov.w   r2, arg_8[sp]
FFF0B91C  ba81                              movu.w  arg_10[sp], r1
FFF0B91E  06c90105                          add     arg_6[sp].uw, r1
FFF0B922  ba8b                              movu.w  arg_12[sp], r3
FFF0B924  06c90306                          add     arg_8[sp].uw, r3
FFF0B928  b20a                              movu.b  arg_5[sp], r2
FFF0B92A  60c0                              sub     #0Ch, sp
FFF0B92C  fb42a7aaf4ff                      mov.l   #aOfflineError, r4; "Offline Error"
FFF0B932  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B934  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B936  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B939  5f12                              movu.w  r1, r2
FFF0B93B  5f31                              movu.w  r3, r1
FFF0B93D  6604                              mov.l   #0, r4
FFF0B93F  66d3                              mov.l   #0Dh, r3
FFF0B941  05e261fe                          bsr.a   sub_FFEF1B23
FFF0B945  62c0                              add     #0Ch, sp
FFF0B947  6706                              rtsd    #6
FFF0B949  3c090c                 sub_FFF0B949 mov.b   #0Ch, arg_5[sp]   ; <<<< FUNC sub_FFF0B949
FFF0B94C  b209                              movu.b  arg_5[sp], r1
FFF0B94E  63e1                              mul     #0Eh, r1
FFF0B950  7542ca                            mov.l   #-36h, r2
FFF0B953  4312                              sub     r1, r2
FFF0B955  fd748202                          div     #2, r2
FFF0B959  9182                              mov.w   r2, arg_8[sp]
FFF0B95B  ba81                              movu.w  arg_10[sp], r1
FFF0B95D  06c90105                          add     arg_6[sp].uw, r1
FFF0B961  ba8b                              movu.w  arg_12[sp], r3
FFF0B963  06c90306                          add     arg_8[sp].uw, r3
FFF0B967  b20a                              movu.b  arg_5[sp], r2
FFF0B969  60c0                              sub     #0Ch, sp
FFF0B96B  fb42b5aaf4ff                      mov.l   #aNotAccepted, r4; "Not Accepted"
FFF0B971  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B973  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B975  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B978  5f12                              movu.w  r1, r2
FFF0B97A  5f31                              movu.w  r3, r1
FFF0B97C  6604                              mov.l   #0, r4
FFF0B97E  66d3                              mov.l   #0Dh, r3
FFF0B980  05a361fe                          bsr.a   sub_FFEF1B23
FFF0B984  62c0                              add     #0Ch, sp
FFF0B986  6706                              rtsd    #6
FFF0B988  3d061f                 sub_FFF0B988 mov.w   #1Fh, arg_8[sp]   ; <<<< FUNC sub_FFF0B988
FFF0B98B  3d0509                            mov.w   #9, arg_6[sp]
FFF0B98E  ba81                              movu.w  arg_10[sp], r1
FFF0B990  06c90105                          add     arg_6[sp].uw, r1
FFF0B994  ba8b                              movu.w  arg_12[sp], r3
FFF0B996  06c90306                          add     arg_8[sp].uw, r3
FFF0B99A  5f12                              movu.w  r1, r2
FFF0B99C  5f31                              movu.w  r3, r1
FFF0B99E  fb42dc2eedff                      mov.l   #unk_FFED2EDC, r4
FFF0B9A4  6613                              mov.l   #1, r3
FFF0B9A6  052faffe                          bsr.a   sub_FFEF68D5
FFF0B9AA  6706                              rtsd    #6
FFF0B9AC  3d0609                 sub_FFF0B9AC mov.w   #9, arg_8[sp]   ; <<<< FUNC sub_FFF0B9AC
FFF0B9AF  3d0509                            mov.w   #9, arg_6[sp]
FFF0B9B2  ba81                              movu.w  arg_10[sp], r1
FFF0B9B4  06c90105                          add     arg_6[sp].uw, r1
FFF0B9B8  ba8b                              movu.w  arg_12[sp], r3
FFF0B9BA  06c90306                          add     arg_8[sp].uw, r3
FFF0B9BE  5f12                              movu.w  r1, r2
FFF0B9C0  5f31                              movu.w  r3, r1
FFF0B9C2  fb42ec2eedff                      mov.l   #unk_FFED2EEC, r4
FFF0B9C8  6613                              mov.l   #1, r3
FFF0B9CA  050baffe                          bsr.a   sub_FFEF68D5
FFF0B9CE  6706                              rtsd    #6
FFF0B9D0  3c090a                 sub_FFF0B9D0 mov.b   #0Ah, arg_5[sp]   ; <<<< FUNC sub_FFF0B9D0
FFF0B9D3  b209                              movu.b  arg_5[sp], r1
FFF0B9D5  63e1                              mul     #0Eh, r1
FFF0B9D7  7542ca                            mov.l   #-36h, r2
FFF0B9DA  4312                              sub     r1, r2
FFF0B9DC  fd748202                          div     #2, r2
FFF0B9E0  9182                              mov.w   r2, arg_8[sp]
FFF0B9E2  ba81                              movu.w  arg_10[sp], r1
FFF0B9E4  06c90105                          add     arg_6[sp].uw, r1
FFF0B9E8  ba8b                              movu.w  arg_12[sp], r3
FFF0B9EA  06c90306                          add     arg_8[sp].uw, r3
FFF0B9EE  b20a                              movu.b  arg_5[sp], r2
FFF0B9F0  60c0                              sub     #0Ch, sp
FFF0B9F2  fb42c2aaf4ff                      mov.l   #aNoMatches, r4; "No Matches"
FFF0B9F8  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0B9FA  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0B9FC  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0B9FF  5f12                              movu.w  r1, r2
FFF0BA01  5f31                              movu.w  r3, r1
FFF0BA03  6604                              mov.l   #0, r4
FFF0BA05  66d3                              mov.l   #0Dh, r3
FFF0BA07  051c61fe                          bsr.a   sub_FFEF1B23
FFF0BA0B  62c0                              add     #0Ch, sp
FFF0BA0D  6706                              rtsd    #6
FFF0BA0F  3c090b                 sub_FFF0BA0F mov.b   #0Bh, arg_5[sp]   ; <<<< FUNC sub_FFF0BA0F
FFF0BA12  b209                              movu.b  arg_5[sp], r1
FFF0BA14  63e1                              mul     #0Eh, r1
FFF0BA16  7542ca                            mov.l   #-36h, r2
FFF0BA19  4312                              sub     r1, r2
FFF0BA1B  fd748202                          div     #2, r2
FFF0BA1F  9182                              mov.w   r2, arg_8[sp]
FFF0BA21  ba81                              movu.w  arg_10[sp], r1
FFF0BA23  06c90105                          add     arg_6[sp].uw, r1
FFF0BA27  ba8b                              movu.w  arg_12[sp], r3
FFF0BA29  06c90306                          add     arg_8[sp].uw, r3
FFF0BA2D  b20a                              movu.b  arg_5[sp], r2
FFF0BA2F  60c0                              sub     #0Ch, sp
FFF0BA31  fb42cdaaf4ff                      mov.l   #aEmgUpload, r4; "EMG UPLOAD?"
FFF0BA37  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BA39  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BA3B  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BA3E  5f12                              movu.w  r1, r2
FFF0BA40  5f31                              movu.w  r3, r1
FFF0BA42  6604                              mov.l   #0, r4
FFF0BA44  66d3                              mov.l   #0Dh, r3
FFF0BA46  05dd60fe                          bsr.a   sub_FFEF1B23
FFF0BA4A  62c0                              add     #0Ch, sp
FFF0BA4C  6706                              rtsd    #6
FFF0BA4E  3d061f                 sub_FFF0BA4E mov.w   #1Fh, arg_8[sp]   ; <<<< FUNC sub_FFF0BA4E
FFF0BA51  3d0509                            mov.w   #9, arg_6[sp]
FFF0BA54  ba81                              movu.w  arg_10[sp], r1
FFF0BA56  06c90105                          add     arg_6[sp].uw, r1
FFF0BA5A  ba8b                              movu.w  arg_12[sp], r3
FFF0BA5C  06c90306                          add     arg_8[sp].uw, r3
FFF0BA60  5f12                              movu.w  r1, r2
FFF0BA62  5f31                              movu.w  r3, r1
FFF0BA64  fb421c2fedff                      mov.l   #unk_FFED2F1C, r4
FFF0BA6A  6613                              mov.l   #1, r3
FFF0BA6C  0569aefe                          bsr.a   sub_FFEF68D5
FFF0BA70  6706                              rtsd    #6
FFF0BA72  3c0909                 sub_FFF0BA72 mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0BA72
FFF0BA75  b209                              movu.b  arg_5[sp], r1
FFF0BA77  63e1                              mul     #0Eh, r1
FFF0BA79  7542ca                            mov.l   #-36h, r2
FFF0BA7C  4312                              sub     r1, r2
FFF0BA7E  fd748202                          div     #2, r2
FFF0BA82  9182                              mov.w   r2, arg_8[sp]
FFF0BA84  ba81                              movu.w  arg_10[sp], r1
FFF0BA86  06c90105                          add     arg_6[sp].uw, r1
FFF0BA8A  ba8b                              movu.w  arg_12[sp], r3
FFF0BA8C  06c90306                          add     arg_8[sp].uw, r3
FFF0BA90  b20a                              movu.b  arg_5[sp], r2
FFF0BA92  60c0                              sub     #0Ch, sp
FFF0BA94  fb42d9aaf4ff                      mov.l   #aWProtect, r4; "W PROTECT"
FFF0BA9A  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BA9C  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BA9E  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BAA1  5f12                              movu.w  r1, r2
FFF0BAA3  5f31                              movu.w  r3, r1
FFF0BAA5  6604                              mov.l   #0, r4
FFF0BAA7  66d3                              mov.l   #0Dh, r3
FFF0BAA9  057a60fe                          bsr.a   sub_FFEF1B23
FFF0BAAD  62c0                              add     #0Ch, sp
FFF0BAAF  6706                              rtsd    #6
FFF0BAB1  3c0909                 sub_FFF0BAB1 mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0BAB1
FFF0BAB4  b209                              movu.b  arg_5[sp], r1
FFF0BAB6  63e1                              mul     #0Eh, r1
FFF0BAB8  7542ca                            mov.l   #-36h, r2
FFF0BABB  4312                              sub     r1, r2
FFF0BABD  fd748202                          div     #2, r2
FFF0BAC1  9182                              mov.w   r2, arg_8[sp]
FFF0BAC3  ba81                              movu.w  arg_10[sp], r1
FFF0BAC5  06c90105                          add     arg_6[sp].uw, r1
FFF0BAC9  ba8b                              movu.w  arg_12[sp], r3
FFF0BACB  06c90306                          add     arg_8[sp].uw, r3
FFF0BACF  b20a                              movu.b  arg_5[sp], r2
FFF0BAD1  60c0                              sub     #0Ch, sp
FFF0BAD3  fb42e3aaf4ff                      mov.l   #aMchError, r4; "MCH ERROR"
FFF0BAD9  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BADB  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BADD  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BAE0  5f12                              movu.w  r1, r2
FFF0BAE2  5f31                              movu.w  r3, r1
FFF0BAE4  6604                              mov.l   #0, r4
FFF0BAE6  66d3                              mov.l   #0Dh, r3
FFF0BAE8  053b60fe                          bsr.a   sub_FFEF1B23
FFF0BAEC  62c0                              add     #0Ch, sp
FFF0BAEE  6706                              rtsd    #6
FFF0BAF0  3c0909                 sub_FFF0BAF0 mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0BAF0
FFF0BAF3  b209                              movu.b  arg_5[sp], r1
FFF0BAF5  63e1                              mul     #0Eh, r1
FFF0BAF7  7542ca                            mov.l   #-36h, r2
FFF0BAFA  4312                              sub     r1, r2
FFF0BAFC  fd748202                          div     #2, r2
FFF0BB00  9182                              mov.w   r2, arg_8[sp]
FFF0BB02  ba81                              movu.w  arg_10[sp], r1
FFF0BB04  06c90105                          add     arg_6[sp].uw, r1
FFF0BB08  ba8b                              movu.w  arg_12[sp], r3
FFF0BB0A  06c90306                          add     arg_8[sp].uw, r3
FFF0BB0E  b20a                              movu.b  arg_5[sp], r2
FFF0BB10  60c0                              sub     #0Ch, sp
FFF0BB12  fb42edaaf4ff                      mov.l   #aBankFull, r4; "BANK FULL"
FFF0BB18  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BB1A  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BB1C  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BB1F  5f12                              movu.w  r1, r2
FFF0BB21  5f31                              movu.w  r3, r1
FFF0BB23  6604                              mov.l   #0, r4
FFF0BB25  66d3                              mov.l   #0Dh, r3
FFF0BB27  05fc5ffe                          bsr.a   sub_FFEF1B23
FFF0BB2B  62c0                              add     #0Ch, sp
FFF0BB2D  6706                              rtsd    #6
FFF0BB2F  3c0908                 sub_FFF0BB2F mov.b   #8, arg_5[sp]   ; <<<< FUNC sub_FFF0BB2F
FFF0BB32  b209                              movu.b  arg_5[sp], r1
FFF0BB34  63e1                              mul     #0Eh, r1
FFF0BB36  7542ca                            mov.l   #-36h, r2
FFF0BB39  4312                              sub     r1, r2
FFF0BB3B  fd748202                          div     #2, r2
FFF0BB3F  9182                              mov.w   r2, arg_8[sp]
FFF0BB41  ba81                              movu.w  arg_10[sp], r1
FFF0BB43  06c90105                          add     arg_6[sp].uw, r1
FFF0BB47  ba8b                              movu.w  arg_12[sp], r3
FFF0BB49  06c90306                          add     arg_8[sp].uw, r3
FFF0BB4D  b20a                              movu.b  arg_5[sp], r2
FFF0BB4F  60c0                              sub     #0Ch, sp
FFF0BB51  fb42f7aaf4ff                      mov.l   #aRegBank, r4; "REG BANK"
FFF0BB57  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BB59  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BB5B  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BB5E  5f12                              movu.w  r1, r2
FFF0BB60  5f31                              movu.w  r3, r1
FFF0BB62  6604                              mov.l   #0, r4
FFF0BB64  66d3                              mov.l   #0Dh, r3
FFF0BB66  05bd5ffe                          bsr.a   sub_FFEF1B23
FFF0BB6A  62c0                              add     #0Ch, sp
FFF0BB6C  6706                              rtsd    #6
FFF0BB6E  3c0907                 sub_FFF0BB6E mov.b   #7, arg_5[sp]   ; <<<< FUNC sub_FFF0BB6E
FFF0BB71  b209                              movu.b  arg_5[sp], r1
FFF0BB73  63e1                              mul     #0Eh, r1
FFF0BB75  7542ca                            mov.l   #-36h, r2
FFF0BB78  4312                              sub     r1, r2
FFF0BB7A  fd748202                          div     #2, r2
FFF0BB7E  9182                              mov.w   r2, arg_8[sp]
FFF0BB80  ba81                              movu.w  arg_10[sp], r1
FFF0BB82  06c90105                          add     arg_6[sp].uw, r1
FFF0BB86  ba8b                              movu.w  arg_12[sp], r3
FFF0BB88  06c90306                          add     arg_8[sp].uw, r3
FFF0BB8C  b20a                              movu.b  arg_5[sp], r2
FFF0BB8E  60c0                              sub     #0Ch, sp
FFF0BB90  fb4200abf4ff                      mov.l   #aNoBank, r4; "NO BANK"
FFF0BB96  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BB98  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BB9A  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BB9D  5f12                              movu.w  r1, r2
FFF0BB9F  5f31                              movu.w  r3, r1
FFF0BBA1  6604                              mov.l   #0, r4
FFF0BBA3  66d3                              mov.l   #0Dh, r3
FFF0BBA5  057e5ffe                          bsr.a   sub_FFEF1B23
FFF0BBA9  62c0                              add     #0Ch, sp
FFF0BBAB  6706                              rtsd    #6
FFF0BBAD  3c0908                 sub_FFF0BBAD mov.b   #8, arg_5[sp]   ; <<<< FUNC sub_FFF0BBAD
FFF0BBB0  b209                              movu.b  arg_5[sp], r1
FFF0BBB2  63e1                              mul     #0Eh, r1
FFF0BBB4  7542ca                            mov.l   #-36h, r2
FFF0BBB7  4312                              sub     r1, r2
FFF0BBB9  fd748202                          div     #2, r2
FFF0BBBD  9182                              mov.w   r2, arg_8[sp]
FFF0BBBF  ba81                              movu.w  arg_10[sp], r1
FFF0BBC1  06c90105                          add     arg_6[sp].uw, r1
FFF0BBC5  ba8b                              movu.w  arg_12[sp], r3
FFF0BBC7  06c90306                          add     arg_8[sp].uw, r3
FFF0BBCB  b20a                              movu.b  arg_5[sp], r2
FFF0BBCD  60c0                              sub     #0Ch, sp
FFF0BBCF  fb4208abf4ff                      mov.l   #aMsError, r4; "MS ERROR"
FFF0BBD5  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BBD7  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BBD9  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BBDC  5f12                              movu.w  r1, r2
FFF0BBDE  5f31                              movu.w  r3, r1
FFF0BBE0  6604                              mov.l   #0, r4
FFF0BBE2  66d3                              mov.l   #0Dh, r3
FFF0BBE4  053f5ffe                          bsr.a   sub_FFEF1B23
FFF0BBE8  62c0                              add     #0Ch, sp
FFF0BBEA  6706                              rtsd    #6
FFF0BBEC  3c0909                 sub_FFF0BBEC mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0BBEC
FFF0BBEF  b209                              movu.b  arg_5[sp], r1
FFF0BBF1  63e1                              mul     #0Eh, r1
FFF0BBF3  7542ca                            mov.l   #-36h, r2
FFF0BBF6  4312                              sub     r1, r2
FFF0BBF8  fd748202                          div     #2, r2
FFF0BBFC  9182                              mov.w   r2, arg_8[sp]
FFF0BBFE  ba81                              movu.w  arg_10[sp], r1
FFF0BC00  06c90105                          add     arg_6[sp].uw, r1
FFF0BC04  ba8b                              movu.w  arg_12[sp], r3
FFF0BC06  06c90306                          add     arg_8[sp].uw, r3
FFF0BC0A  b20a                              movu.b  arg_5[sp], r2
FFF0BC0C  60c0                              sub     #0Ch, sp
FFF0BC0E  fb4211abf4ff                      mov.l   #aNoMemory, r4; "NO MEMORY"
FFF0BC14  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BC16  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BC18  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BC1B  5f12                              movu.w  r1, r2
FFF0BC1D  5f31                              movu.w  r3, r1
FFF0BC1F  6604                              mov.l   #0, r4
FFF0BC21  66d3                              mov.l   #0Dh, r3
FFF0BC23  05005ffe                          bsr.a   sub_FFEF1B23
FFF0BC27  62c0                              add     #0Ch, sp
FFF0BC29  6706                              rtsd    #6
FFF0BC2B  3c090a                 sub_FFF0BC2B mov.b   #0Ah, arg_5[sp]   ; <<<< FUNC sub_FFF0BC2B
FFF0BC2E  b209                              movu.b  arg_5[sp], r1
FFF0BC30  63e1                              mul     #0Eh, r1
FFF0BC32  7542ca                            mov.l   #-36h, r2
FFF0BC35  4312                              sub     r1, r2
FFF0BC37  fd748202                          div     #2, r2
FFF0BC3B  9182                              mov.w   r2, arg_8[sp]
FFF0BC3D  ba81                              movu.w  arg_10[sp], r1
FFF0BC3F  06c90105                          add     arg_6[sp].uw, r1
FFF0BC43  ba8b                              movu.w  arg_12[sp], r3
FFF0BC45  06c90306                          add     arg_8[sp].uw, r3
FFF0BC49  b20a                              movu.b  arg_5[sp], r2
FFF0BC4B  60c0                              sub     #0Ch, sp
FFF0BC4D  fb421babf4ff                      mov.l   #aNoSdCard, r4; "NO SD CARD"
FFF0BC53  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BC55  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BC57  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BC5A  5f12                              movu.w  r1, r2
FFF0BC5C  5f31                              movu.w  r3, r1
FFF0BC5E  6604                              mov.l   #0, r4
FFF0BC60  66d3                              mov.l   #0Dh, r3
FFF0BC62  05c15efe                          bsr.a   sub_FFEF1B23
FFF0BC66  62c0                              add     #0Ch, sp
FFF0BC68  6706                              rtsd    #6
FFF0BC6A  3c090c                 sub_FFF0BC6A mov.b   #0Ch, arg_5[sp]   ; <<<< FUNC sub_FFF0BC6A
FFF0BC6D  b209                              movu.b  arg_5[sp], r1
FFF0BC6F  63e1                              mul     #0Eh, r1
FFF0BC71  7542ca                            mov.l   #-36h, r2
FFF0BC74  4312                              sub     r1, r2
FFF0BC76  fd748202                          div     #2, r2
FFF0BC7A  9182                              mov.w   r2, arg_8[sp]
FFF0BC7C  ba81                              movu.w  arg_10[sp], r1
FFF0BC7E  06c90105                          add     arg_6[sp].uw, r1
FFF0BC82  ba8b                              movu.w  arg_12[sp], r3
FFF0BC84  06c90306                          add     arg_8[sp].uw, r3
FFF0BC88  b20a                              movu.b  arg_5[sp], r2
FFF0BC8A  60c0                              sub     #0Ch, sp
FFF0BC8C  fb4226abf4ff                      mov.l   #aSdCardFull, r4; "SD CARD FULL"
FFF0BC92  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BC94  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BC96  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BC99  5f12                              movu.w  r1, r2
FFF0BC9B  5f31                              movu.w  r3, r1
FFF0BC9D  6604                              mov.l   #0, r4
FFF0BC9F  66d3                              mov.l   #0Dh, r3
FFF0BCA1  05825efe                          bsr.a   sub_FFEF1B23
FFF0BCA5  62c0                              add     #0Ch, sp
FFF0BCA7  6706                              rtsd    #6
FFF0BCA9  3c0904                 sub_FFF0BCA9 mov.b   #4, arg_5[sp]   ; <<<< FUNC sub_FFF0BCA9
FFF0BCAC  b209                              movu.b  arg_5[sp], r1
FFF0BCAE  63e1                              mul     #0Eh, r1
FFF0BCB0  7542ca                            mov.l   #-36h, r2
FFF0BCB3  4312                              sub     r1, r2
FFF0BCB5  fd748202                          div     #2, r2
FFF0BCB9  9182                              mov.w   r2, arg_8[sp]
FFF0BCBB  ba81                              movu.w  arg_10[sp], r1
FFF0BCBD  06c90105                          add     arg_6[sp].uw, r1
FFF0BCC1  ba8b                              movu.w  arg_12[sp], r3
FFF0BCC3  06c90306                          add     arg_8[sp].uw, r3
FFF0BCC7  b20a                              movu.b  arg_5[sp], r2
FFF0BCC9  60c0                              sub     #0Ch, sp
FFF0BCCB  fb4233abf4ff                      mov.l   #aHeat, r4; "HEAT"
FFF0BCD1  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BCD3  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BCD5  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BCD8  5f12                              movu.w  r1, r2
FFF0BCDA  5f31                              movu.w  r3, r1
FFF0BCDC  6604                              mov.l   #0, r4
FFF0BCDE  66d3                              mov.l   #0Dh, r3
FFF0BCE0  05435efe                          bsr.a   sub_FFEF1B23
FFF0BCE4  62c0                              add     #0Ch, sp
FFF0BCE6  6706                              rtsd    #6
FFF0BCE8  3c0906                 sub_FFF0BCE8 mov.b   #6, arg_5[sp]   ; <<<< FUNC sub_FFF0BCE8
FFF0BCEB  b209                              movu.b  arg_5[sp], r1
FFF0BCED  63e1                              mul     #0Eh, r1
FFF0BCEF  7542ca                            mov.l   #-36h, r2
FFF0BCF2  4312                              sub     r1, r2
FFF0BCF4  fd748202                          div     #2, r2
FFF0BCF8  9182                              mov.w   r2, arg_8[sp]
FFF0BCFA  ba81                              movu.w  arg_10[sp], r1
FFF0BCFC  06c90105                          add     arg_6[sp].uw, r1
FFF0BD00  ba8b                              movu.w  arg_12[sp], r3
FFF0BD02  06c90306                          add     arg_8[sp].uw, r3
FFF0BD06  b20a                              movu.b  arg_5[sp], r2
FFF0BD08  60c0                              sub     #0Ch, sp
FFF0BD0A  fb4238abf4ff                      mov.l   #aMOnly, r4; "M-ONLY"
FFF0BD10  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BD12  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BD14  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BD17  5f12                              movu.w  r1, r2
FFF0BD19  5f31                              movu.w  r3, r1
FFF0BD1B  6604                              mov.l   #0, r4
FFF0BD1D  66d3                              mov.l   #0Dh, r3
FFF0BD1F  05045efe                          bsr.a   sub_FFEF1B23
FFF0BD23  62c0                              add     #0Ch, sp
FFF0BD25  6706                              rtsd    #6
FFF0BD27  3c090a                 sub_FFF0BD27 mov.b   #0Ah, arg_5[sp]   ; <<<< FUNC sub_FFF0BD27
FFF0BD2A  b209                              movu.b  arg_5[sp], r1
FFF0BD2C  63e1                              mul     #0Eh, r1
FFF0BD2E  7542ca                            mov.l   #-36h, r2
FFF0BD31  4312                              sub     r1, r2
FFF0BD33  fd748202                          div     #2, r2
FFF0BD37  9182                              mov.w   r2, arg_8[sp]
FFF0BD39  ba81                              movu.w  arg_10[sp], r1
FFF0BD3B  06c90105                          add     arg_6[sp].uw, r1
FFF0BD3F  ba8b                              movu.w  arg_12[sp], r3
FFF0BD41  06c90306                          add     arg_8[sp].uw, r3
FFF0BD45  b20a                              movu.b  arg_5[sp], r2
FFF0BD47  60c0                              sub     #0Ch, sp
FFF0BD49  fb423fabf4ff                      mov.l   #aFirmError, r4; "FIRM ERROR"
FFF0BD4F  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BD51  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BD53  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BD56  5f12                              movu.w  r1, r2
FFF0BD58  5f31                              movu.w  r3, r1
FFF0BD5A  6604                              mov.l   #0, r4
FFF0BD5C  66d3                              mov.l   #0Dh, r3
FFF0BD5E  05c55dfe                          bsr.a   sub_FFEF1B23
FFF0BD62  62c0                              add     #0Ch, sp
FFF0BD64  6706                              rtsd    #6
FFF0BD66  3d060d                 sub_FFF0BD66 mov.w   #0Dh, arg_8[sp]   ; <<<< FUNC sub_FFF0BD66
FFF0BD69  3d0509                            mov.w   #9, arg_6[sp]
FFF0BD6C  ba81                              movu.w  arg_10[sp], r1
FFF0BD6E  06c90105                          add     arg_6[sp].uw, r1
FFF0BD72  ba8b                              movu.w  arg_12[sp], r3
FFF0BD74  06c90306                          add     arg_8[sp].uw, r3
FFF0BD78  5f12                              movu.w  r1, r2
FFF0BD7A  5f31                              movu.w  r3, r1
FFF0BD7C  fb420c2fedff                      mov.l   #unk_FFED2F0C, r4
FFF0BD82  6613                              mov.l   #1, r3
FFF0BD84  0551abfe                          bsr.a   sub_FFEF68D5
FFF0BD88  6706                              rtsd    #6
FFF0BD8A  3d0618                 sub_FFF0BD8A mov.w   #18h, arg_8[sp]   ; <<<< FUNC sub_FFF0BD8A
FFF0BD8D  3d0509                            mov.w   #9, arg_6[sp]
FFF0BD90  ba81                              movu.w  arg_10[sp], r1
FFF0BD92  06c90105                          add     arg_6[sp].uw, r1
FFF0BD96  ba8b                              movu.w  arg_12[sp], r3
FFF0BD98  06c90306                          add     arg_8[sp].uw, r3
FFF0BD9C  5f12                              movu.w  r1, r2
FFF0BD9E  5f31                              movu.w  r3, r1
FFF0BDA0  fb42fc2eedff                      mov.l   #unk_FFED2EFC, r4
FFF0BDA6  6613                              mov.l   #1, r3
FFF0BDA8  052dabfe                          bsr.a   sub_FFEF68D5
FFF0BDAC  6706                              rtsd    #6
FFF0BDAE  3c0909                 sub_FFF0BDAE mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0BDAE
FFF0BDB1  b209                              movu.b  arg_5[sp], r1
FFF0BDB3  63e1                              mul     #0Eh, r1
FFF0BDB5  7542ca                            mov.l   #-36h, r2
FFF0BDB8  4312                              sub     r1, r2
FFF0BDBA  fd748202                          div     #2, r2
FFF0BDBE  9182                              mov.w   r2, arg_8[sp]
FFF0BDC0  ba81                              movu.w  arg_10[sp], r1
FFF0BDC2  06c90105                          add     arg_6[sp].uw, r1
FFF0BDC6  ba8b                              movu.w  arg_12[sp], r3
FFF0BDC8  06c90306                          add     arg_8[sp].uw, r3
FFF0BDCC  b20a                              movu.b  arg_5[sp], r2
FFF0BDCE  60c0                              sub     #0Ch, sp
FFF0BDD0  fb424aabf4ff                      mov.l   #aSearching, r4; "Searching"
FFF0BDD6  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BDD8  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BDDA  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BDDD  5f12                              movu.w  r1, r2
FFF0BDDF  5f31                              movu.w  r3, r1
FFF0BDE1  6604                              mov.l   #0, r4
FFF0BDE3  66d3                              mov.l   #0Dh, r3
FFF0BDE5  053e5dfe                          bsr.a   sub_FFEF1B23
FFF0BDE9  62c0                              add     #0Ch, sp
FFF0BDEB  6706                              rtsd    #6
FFF0BDED  3c0909                 sub_FFF0BDED mov.b   #9, arg_5[sp]   ; <<<< FUNC sub_FFF0BDED
FFF0BDF0  b209                              movu.b  arg_5[sp], r1
FFF0BDF2  63e1                              mul     #0Eh, r1
FFF0BDF4  7542ca                            mov.l   #-36h, r2
FFF0BDF7  4312                              sub     r1, r2
FFF0BDF9  fd748202                          div     #2, r2
FFF0BDFD  9182                              mov.w   r2, arg_8[sp]
FFF0BDFF  ba81                              movu.w  arg_10[sp], r1
FFF0BE01  06c90105                          add     arg_6[sp].uw, r1
FFF0BE05  ba8b                              movu.w  arg_12[sp], r3
FFF0BE07  06c90306                          add     arg_8[sp].uw, r3
FFF0BE0B  b20a                              movu.b  arg_5[sp], r2
FFF0BE0D  60c0                              sub     #0Ch, sp
FFF0BE0F  fb4254abf4ff                      mov.l   #aNoDevice, r4; "No Device"
FFF0BE15  a00c                              mov.l   r4, 0Ch+var_8[sp]
FFF0BE17  c302                              mov.b   r2, 0Ch+var_C[sp]
FFF0BE19  3c0801                            mov.b   #1, 0Ch+var_4[sp]
FFF0BE1C  5f12                              movu.w  r1, r2
FFF0BE1E  5f31                              movu.w  r3, r1
FFF0BE20  6604                              mov.l   #0, r4
FFF0BE22  66d3                              mov.l   #0Dh, r3
FFF0BE24  05ff5cfe                          bsr.a   sub_FFEF1B23
FFF0BE28  62c0                              add     #0Ch, sp
FFF0BE2A  6706                              rtsd    #6
FFF0BE2C  6706                   sub_FFF0BE2C rtsd    #6   ; <<<< FUNC sub_FFF0BE2C
FFF0BE2E  7100e8                 sub_FFF0BE2E add     #-18h, sp, sp   ; <<<< FUNC sub_FFF0BE2E
FFF0BE31  9289                              mov.w   r1, 18h+var_2[sp]
FFF0BE33  9282                              mov.w   r2, 18h+var_4[sp]
FFF0BE35  920b                              mov.w   r3, 18h+var_6[sp]
FFF0BE37  9204                              mov.w   r4, 18h+var_8[sp]
FFF0BE39  c5001c0f                          mov.b   18h+arg_0[sp], 18h+var_9[sp]
FFF0BE3D  39680b                            bsr.w   sub_FFF0C9A5
FFF0BE40  ba82                              movu.w  18h+var_4[sp], r2
FFF0BE42  ba89                              movu.w  18h+var_2[sp], r1
FFF0BE44  3955f5                            bsr.w   sub_FFF0B399
FFF0BE47  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0BE4D  c5e01a05                          mov.b   1Ah[r14], 18h+var_13[sp]
FFF0BE51  05a144fe                          bsr.a   sub_FFEF02F2
FFF0BE55  8101                              mov.b   r1, 18h+var_14[sp]
FFF0BE57  b109                              movu.b  18h+var_13[sp], r1
FFF0BE59  6111                              cmp     #1, r1
FFF0BE5B  1a                                bne.s   loc_FFF0BE65
FFF0BE5C  b101                              movu.b  18h+var_14[sp], r1
FFF0BE5E  6101                              cmp     #0, r1
FFF0BE60  1d                                bne.s   loc_FFF0BE65
FFF0BE61  f80601                            mov.l   #1, 18h+var_18[sp]
FFF0BE64  0c                                bra.s   loc_FFF0BE68
FFF0BE65  f80600                 loc_FFF0BE65 mov.l   #0, 18h+var_18[sp]
FFF0BE68  ec01                   loc_FFF0BE68 mov.l   18h+var_18[sp], r1
FFF0BE6A  6101                              cmp     #0, r1
FFF0BE6C  3b8203                            bne.w   loc_FFF0C1EE
FFF0BE6F  3d0416                            mov.w   #16h, 18h+var_10[sp]
FFF0BE72  3d030e                            mov.w   #0Eh, 18h+var_12[sp]
FFF0BE75  b901                              movu.w  18h+var_10[sp], r1
FFF0BE77  71112e                            add     #2Eh, r1, r1 ; '.'
FFF0BE7A  9181                              mov.w   r1, 18h+var_C[sp]
FFF0BE7C  3d050b                            mov.w   #0Bh, 18h+var_E[sp]
FFF0BE7F  b389                              movu.b  18h+var_9[sp], r1
FFF0BE81  7111f0                            add     #-10h, r1, r1
FFF0BE84  6171                              cmp     #7, r1
FFF0BE86  2505                              bleu.b  loc_FFF0BE8B
FFF0BE88  386603                            bra.w   loc_FFF0C1EE
FFF0BE8B  fbe27a83f4ff           loc_FFF0BE8B mov.l   #unk_FFF4837A, r14
FFF0BE91  fe51ee                            mov.w   [r1, r14], r14
FFF0BE94  7f4e                              bra.l   r14
FFF0BE96  ba81                              movu.w  18h+var_4[sp], r1
FFF0BE98  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BE9C  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BE9E  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BEA2  5f12                              movu.w  r1, r2
FFF0BEA4  5f31                              movu.w  r3, r1
FFF0BEA6  fb42bc2dedff                      mov.l   #unk_FFED2DBC, r4
FFF0BEAC  6613                              mov.l   #1, r3
FFF0BEAE  0527aafe                          bsr.a   sub_FFEF68D5
FFF0BEB2  b901                              movu.w  18h+var_10[sp], r1
FFF0BEB4  711116                            add     #16h, r1, r1
FFF0BEB7  9101                              mov.w   r1, 18h+var_10[sp]
FFF0BEB9  ba81                              movu.w  18h+var_4[sp], r1
FFF0BEBB  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BEBF  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BEC1  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BEC5  5f12                              movu.w  r1, r2
FFF0BEC7  5f31                              movu.w  r3, r1
FFF0BEC9  fb420c2eedff                      mov.l   #unk_FFED2E0C, r4
FFF0BECF  6613                              mov.l   #1, r3
FFF0BED1  0504aafe                          bsr.a   sub_FFEF68D5
FFF0BED5  ba81                              movu.w  18h+var_4[sp], r1
FFF0BED7  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BEDB  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BEDD  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BEE1  60c0                              sub     #0Ch, sp
FFF0BEE3  fb225eabf4ff                      mov.l   #aUpload_0, r2; "UPLOAD"
FFF0BEE9  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0BEEB  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BEEE  f80406                            mov.b   #6, 24h+var_24[sp]
FFF0BEF1  5f12                              movu.w  r1, r2
FFF0BEF3  5f31                              movu.w  r3, r1
FFF0BEF5  6604                              mov.l   #0, r4
FFF0BEF7  66d3                              mov.l   #0Dh, r3
FFF0BEF9  052a5cfe                          bsr.a   sub_FFEF1B23
FFF0BEFD  62c0                              add     #0Ch, sp
FFF0BEFF  6706                              rtsd    #6
FFF0BF01  ba81                              movu.w  18h+var_4[sp], r1
FFF0BF03  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BF07  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BF09  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BF0D  5f12                              movu.w  r1, r2
FFF0BF0F  5f31                              movu.w  r3, r1
FFF0BF11  fb42bc2dedff                      mov.l   #unk_FFED2DBC, r4
FFF0BF17  6613                              mov.l   #1, r3
FFF0BF19  05bca9fe                          bsr.a   sub_FFEF68D5
FFF0BF1D  b901                              movu.w  18h+var_10[sp], r1
FFF0BF1F  711116                            add     #16h, r1, r1
FFF0BF22  9101                              mov.w   r1, 18h+var_10[sp]
FFF0BF24  ba81                              movu.w  18h+var_4[sp], r1
FFF0BF26  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BF2A  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BF2C  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BF30  5f12                              movu.w  r1, r2
FFF0BF32  5f31                              movu.w  r3, r1
FFF0BF34  fb42dc2dedff                      mov.l   #unk_FFED2DDC, r4
FFF0BF3A  6613                              mov.l   #1, r3
FFF0BF3C  0599a9fe                          bsr.a   sub_FFEF68D5
FFF0BF40  ba81                              movu.w  18h+var_4[sp], r1
FFF0BF42  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BF46  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BF48  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BF4C  60c0                              sub     #0Ch, sp
FFF0BF4E  fb225eabf4ff                      mov.l   #aUpload_0, r2; "UPLOAD"
FFF0BF54  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0BF56  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BF59  f80406                            mov.b   #6, 24h+var_24[sp]
FFF0BF5C  5f12                              movu.w  r1, r2
FFF0BF5E  5f31                              movu.w  r3, r1
FFF0BF60  6604                              mov.l   #0, r4
FFF0BF62  66d3                              mov.l   #0Dh, r3
FFF0BF64  05bf5bfe                          bsr.a   sub_FFEF1B23
FFF0BF68  62c0                              add     #0Ch, sp
FFF0BF6A  6706                              rtsd    #6
FFF0BF6C  ba81                              movu.w  18h+var_4[sp], r1
FFF0BF6E  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BF72  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BF74  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BF78  5f12                              movu.w  r1, r2
FFF0BF7A  5f31                              movu.w  r3, r1
FFF0BF7C  fb42bc2dedff                      mov.l   #unk_FFED2DBC, r4
FFF0BF82  6613                              mov.l   #1, r3
FFF0BF84  0551a9fe                          bsr.a   sub_FFEF68D5
FFF0BF88  b901                              movu.w  18h+var_10[sp], r1
FFF0BF8A  711116                            add     #16h, r1, r1
FFF0BF8D  9101                              mov.w   r1, 18h+var_10[sp]
FFF0BF8F  ba81                              movu.w  18h+var_4[sp], r1
FFF0BF91  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BF95  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BF97  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BF9B  5f12                              movu.w  r1, r2
FFF0BF9D  5f31                              movu.w  r3, r1
FFF0BF9F  fb421c2eedff                      mov.l   #unk_FFED2E1C, r4
FFF0BFA5  6613                              mov.l   #1, r3
FFF0BFA7  052ea9fe                          bsr.a   sub_FFEF68D5
FFF0BFAB  ba81                              movu.w  18h+var_4[sp], r1
FFF0BFAD  06c90105                          add     18h+var_E[sp].uw, r1
FFF0BFB1  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BFB3  06c90306                          add     18h+var_C[sp].uw, r3
FFF0BFB7  60c0                              sub     #0Ch, sp
FFF0BFB9  fb225eabf4ff                      mov.l   #aUpload_0, r2; "UPLOAD"
FFF0BFBF  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0BFC1  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0BFC4  f80406                            mov.b   #6, 24h+var_24[sp]
FFF0BFC7  5f12                              movu.w  r1, r2
FFF0BFC9  5f31                              movu.w  r3, r1
FFF0BFCB  6604                              mov.l   #0, r4
FFF0BFCD  66d3                              mov.l   #0Dh, r3
FFF0BFCF  05545bfe                          bsr.a   sub_FFEF1B23
FFF0BFD3  62c0                              add     #0Ch, sp
FFF0BFD5  6706                              rtsd    #6
FFF0BFD7  ba81                              movu.w  18h+var_4[sp], r1
FFF0BFD9  06c90103                          add     18h+var_12[sp].uw, r1
FFF0BFDD  ba8b                              movu.w  18h+var_2[sp], r3
FFF0BFDF  06c90304                          add     18h+var_10[sp].uw, r3
FFF0BFE3  5f12                              movu.w  r1, r2
FFF0BFE5  5f31                              movu.w  r3, r1
FFF0BFE7  fb428c2dedff                      mov.l   #unk_FFED2D8C, r4
FFF0BFED  6613                              mov.l   #1, r3
FFF0BFEF  05e6a8fe                          bsr.a   sub_FFEF68D5
FFF0BFF3  b901                              movu.w  18h+var_10[sp], r1
FFF0BFF5  711116                            add     #16h, r1, r1
FFF0BFF8  9101                              mov.w   r1, 18h+var_10[sp]
FFF0BFFA  ba81                              movu.w  18h+var_4[sp], r1
FFF0BFFC  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C000  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C002  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C006  5f12                              movu.w  r1, r2
FFF0C008  5f31                              movu.w  r3, r1
FFF0C00A  fb420c2eedff                      mov.l   #unk_FFED2E0C, r4
FFF0C010  6613                              mov.l   #1, r3
FFF0C012  05c3a8fe                          bsr.a   sub_FFEF68D5
FFF0C016  ba81                              movu.w  18h+var_4[sp], r1
FFF0C018  06c90105                          add     18h+var_E[sp].uw, r1
FFF0C01C  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C01E  06c90306                          add     18h+var_C[sp].uw, r3
FFF0C022  60c0                              sub     #0Ch, sp
FFF0C024  fb2265abf4ff                      mov.l   #aDownload, r2; "DOWNLOAD"
FFF0C02A  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0C02C  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0C02F  f80408                            mov.b   #8, 24h+var_24[sp]
FFF0C032  5f12                              movu.w  r1, r2
FFF0C034  5f31                              movu.w  r3, r1
FFF0C036  6604                              mov.l   #0, r4
FFF0C038  66d3                              mov.l   #0Dh, r3
FFF0C03A  05e95afe                          bsr.a   sub_FFEF1B23
FFF0C03E  62c0                              add     #0Ch, sp
FFF0C040  6706                              rtsd    #6
FFF0C042  ba81                              movu.w  18h+var_4[sp], r1
FFF0C044  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C048  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C04A  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C04E  5f12                              movu.w  r1, r2
FFF0C050  5f31                              movu.w  r3, r1
FFF0C052  fb428c2dedff                      mov.l   #unk_FFED2D8C, r4
FFF0C058  6613                              mov.l   #1, r3
FFF0C05A  057ba8fe                          bsr.a   sub_FFEF68D5
FFF0C05E  b901                              movu.w  18h+var_10[sp], r1
FFF0C060  711116                            add     #16h, r1, r1
FFF0C063  9101                              mov.w   r1, 18h+var_10[sp]
FFF0C065  ba81                              movu.w  18h+var_4[sp], r1
FFF0C067  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C06B  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C06D  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C071  5f12                              movu.w  r1, r2
FFF0C073  5f31                              movu.w  r3, r1
FFF0C075  fb42dc2dedff                      mov.l   #unk_FFED2DDC, r4
FFF0C07B  6613                              mov.l   #1, r3
FFF0C07D  0558a8fe                          bsr.a   sub_FFEF68D5
FFF0C081  ba81                              movu.w  18h+var_4[sp], r1
FFF0C083  06c90105                          add     18h+var_E[sp].uw, r1
FFF0C087  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C089  06c90306                          add     18h+var_C[sp].uw, r3
FFF0C08D  60c0                              sub     #0Ch, sp
FFF0C08F  fb2265abf4ff                      mov.l   #aDownload, r2; "DOWNLOAD"
FFF0C095  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0C097  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0C09A  f80408                            mov.b   #8, 24h+var_24[sp]
FFF0C09D  5f12                              movu.w  r1, r2
FFF0C09F  5f31                              movu.w  r3, r1
FFF0C0A1  6604                              mov.l   #0, r4
FFF0C0A3  66d3                              mov.l   #0Dh, r3
FFF0C0A5  057e5afe                          bsr.a   sub_FFEF1B23
FFF0C0A9  62c0                              add     #0Ch, sp
FFF0C0AB  6706                              rtsd    #6
FFF0C0AD  ba81                              movu.w  18h+var_4[sp], r1
FFF0C0AF  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C0B3  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C0B5  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C0B9  5f12                              movu.w  r1, r2
FFF0C0BB  5f31                              movu.w  r3, r1
FFF0C0BD  fb428c2dedff                      mov.l   #unk_FFED2D8C, r4
FFF0C0C3  6613                              mov.l   #1, r3
FFF0C0C5  0510a8fe                          bsr.a   sub_FFEF68D5
FFF0C0C9  b901                              movu.w  18h+var_10[sp], r1
FFF0C0CB  711116                            add     #16h, r1, r1
FFF0C0CE  9101                              mov.w   r1, 18h+var_10[sp]
FFF0C0D0  ba81                              movu.w  18h+var_4[sp], r1
FFF0C0D2  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C0D6  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C0D8  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C0DC  5f12                              movu.w  r1, r2
FFF0C0DE  5f31                              movu.w  r3, r1
FFF0C0E0  fb421c2eedff                      mov.l   #unk_FFED2E1C, r4
FFF0C0E6  6613                              mov.l   #1, r3
FFF0C0E8  05eda7fe                          bsr.a   sub_FFEF68D5
FFF0C0EC  ba81                              movu.w  18h+var_4[sp], r1
FFF0C0EE  06c90105                          add     18h+var_E[sp].uw, r1
FFF0C0F2  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C0F4  06c90306                          add     18h+var_C[sp].uw, r3
FFF0C0F8  60c0                              sub     #0Ch, sp
FFF0C0FA  fb2265abf4ff                      mov.l   #aDownload, r2; "DOWNLOAD"
FFF0C100  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0C102  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0C105  f80408                            mov.b   #8, 24h+var_24[sp]
FFF0C108  5f12                              movu.w  r1, r2
FFF0C10A  5f31                              movu.w  r3, r1
FFF0C10C  6604                              mov.l   #0, r4
FFF0C10E  66d3                              mov.l   #0Dh, r3
FFF0C110  05135afe                          bsr.a   sub_FFEF1B23
FFF0C114  62c0                              add     #0Ch, sp
FFF0C116  6706                              rtsd    #6
FFF0C118  ba81                              movu.w  18h+var_4[sp], r1
FFF0C11A  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C11E  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C120  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C124  5f12                              movu.w  r1, r2
FFF0C126  5f31                              movu.w  r3, r1
FFF0C128  fb42ac2dedff                      mov.l   #unk_FFED2DAC, r4
FFF0C12E  6613                              mov.l   #1, r3
FFF0C130  05a5a7fe                          bsr.a   sub_FFEF68D5
FFF0C134  b901                              movu.w  18h+var_10[sp], r1
FFF0C136  711116                            add     #16h, r1, r1
FFF0C139  9101                              mov.w   r1, 18h+var_10[sp]
FFF0C13B  ba81                              movu.w  18h+var_4[sp], r1
FFF0C13D  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C141  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C143  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C147  5f12                              movu.w  r1, r2
FFF0C149  5f31                              movu.w  r3, r1
FFF0C14B  fb42dc2dedff                      mov.l   #unk_FFED2DDC, r4
FFF0C151  6613                              mov.l   #1, r3
FFF0C153  0582a7fe                          bsr.a   sub_FFEF68D5
FFF0C157  ba81                              movu.w  18h+var_4[sp], r1
FFF0C159  06c90105                          add     18h+var_E[sp].uw, r1
FFF0C15D  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C15F  06c90306                          add     18h+var_C[sp].uw, r3
FFF0C163  60c0                              sub     #0Ch, sp
FFF0C165  fb226eabf4ff                      mov.l   #aSend, r2; "SEND"
FFF0C16B  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0C16D  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0C170  f80404                            mov.b   #4, 24h+var_24[sp]
FFF0C173  5f12                              movu.w  r1, r2
FFF0C175  5f31                              movu.w  r3, r1
FFF0C177  6604                              mov.l   #0, r4
FFF0C179  66d3                              mov.l   #0Dh, r3
FFF0C17B  05a859fe                          bsr.a   sub_FFEF1B23
FFF0C17F  62c0                              add     #0Ch, sp
FFF0C181  6706                              rtsd    #6
FFF0C183  ba81                              movu.w  18h+var_4[sp], r1
FFF0C185  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C189  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C18B  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C18F  5f12                              movu.w  r1, r2
FFF0C191  5f31                              movu.w  r3, r1
FFF0C193  fb42ac2dedff                      mov.l   #unk_FFED2DAC, r4
FFF0C199  6613                              mov.l   #1, r3
FFF0C19B  053aa7fe                          bsr.a   sub_FFEF68D5
FFF0C19F  b901                              movu.w  18h+var_10[sp], r1
FFF0C1A1  711116                            add     #16h, r1, r1
FFF0C1A4  9101                              mov.w   r1, 18h+var_10[sp]
FFF0C1A6  ba81                              movu.w  18h+var_4[sp], r1
FFF0C1A8  06c90103                          add     18h+var_12[sp].uw, r1
FFF0C1AC  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C1AE  06c90304                          add     18h+var_10[sp].uw, r3
FFF0C1B2  5f12                              movu.w  r1, r2
FFF0C1B4  5f31                              movu.w  r3, r1
FFF0C1B6  fb421c2eedff                      mov.l   #unk_FFED2E1C, r4
FFF0C1BC  6613                              mov.l   #1, r3
FFF0C1BE  0517a7fe                          bsr.a   sub_FFEF68D5
FFF0C1C2  ba81                              movu.w  18h+var_4[sp], r1
FFF0C1C4  06c90105                          add     18h+var_E[sp].uw, r1
FFF0C1C8  ba8b                              movu.w  18h+var_2[sp], r3
FFF0C1CA  06c90306                          add     18h+var_C[sp].uw, r3
FFF0C1CE  60c0                              sub     #0Ch, sp
FFF0C1D0  fb226eabf4ff                      mov.l   #aSend, r2; "SEND"
FFF0C1D6  a00a                              mov.l   r2, 24h+var_20[sp]
FFF0C1D8  3c0801                            mov.b   #1, 24h+var_1C[sp]
FFF0C1DB  f80404                            mov.b   #4, 24h+var_24[sp]
FFF0C1DE  5f12                              movu.w  r1, r2
FFF0C1E0  5f31                              movu.w  r3, r1
FFF0C1E2  6604                              mov.l   #0, r4
FFF0C1E4  66d3                              mov.l   #0Dh, r3
FFF0C1E6  053d59fe                          bsr.a   sub_FFEF1B23
FFF0C1EA  62c0                              add     #0Ch, sp
FFF0C1EC  6706                              rtsd    #6
FFF0C1EE  6706                   loc_FFF0C1EE rtsd    #6
FFF0C1F0  7100d4                 sub_FFF0C1F0 add     #-2Ch, sp, sp   ; <<<< FUNC sub_FFF0C1F0
FFF0C1F3  9509                              mov.w   r1, 2Ch+var_2[sp]
FFF0C1F5  9502                              mov.w   r2, 2Ch+var_4[sp]
FFF0C1F7  948b                              mov.w   r3, 2Ch+var_6[sp]
FFF0C1F9  9484                              mov.w   r4, 2Ch+var_8[sp]
FFF0C1FB  c5003023                          mov.b   2Ch+arg_0[sp], 2Ch+var_9[sp]
FFF0C1FF  3c8200                            mov.b   #0, 2Ch+var_1A[sp]
FFF0C202  3c8100                            mov.b   #0, 2Ch+var_1B[sp]
FFF0C205  39a007                            bsr.w   sub_FFF0C9A5
FFF0C208  bd02                              movu.w  2Ch+var_4[sp], r2
FFF0C20A  bd09                              movu.w  2Ch+var_2[sp], r1
FFF0C20C  398df1                            bsr.w   sub_FFF0B399
FFF0C20F  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0C215  c5e01a07                          mov.b   1Ah[r14], 2Ch+var_25[sp]
FFF0C219  05d940fe                          bsr.a   sub_FFEF02F2
FFF0C21D  8181                              mov.b   r1, 2Ch+var_26[sp]
FFF0C21F  b189                              movu.b  2Ch+var_25[sp], r1
FFF0C221  6111                              cmp     #1, r1
FFF0C223  1a                                bne.s   loc_FFF0C22D
FFF0C224  b181                              movu.b  2Ch+var_26[sp], r1
FFF0C226  6101                              cmp     #0, r1
FFF0C228  1d                                bne.s   loc_FFF0C22D
FFF0C229  f80601                            mov.l   #1, 2Ch+var_2C[sp]
FFF0C22C  0c                                bra.s   loc_FFF0C230
FFF0C22D  f80600                 loc_FFF0C22D mov.l   #0, 2Ch+var_2C[sp]
FFF0C230  ec01                   loc_FFF0C230 mov.l   2Ch+var_2C[sp], r1
FFF0C232  6101                              cmp     #0, r1
FFF0C234  3b3902                            bne.w   loc_FFF0C46D
FFF0C237  3d0508                            mov.w   #8, 2Ch+var_22[sp]
FFF0C23A  3d040e                            mov.w   #0Eh, 2Ch+var_24[sp]
FFF0C23D  b909                              movu.w  2Ch+var_22[sp], r1
FFF0C23F  711131                            add     #31h, r1, r1 ; '1'
FFF0C242  9189                              mov.w   r1, 2Ch+var_1E[sp]
FFF0C244  3d060b                            mov.w   #0Bh, 2Ch+var_20[sp]
FFF0C247  590123                            movu.b  2Ch+var_9[sp], r1
FFF0C24A  755121                            cmp     #21h, r1 ; '!'
FFF0C24D  3a1601                            beq.w   loc_FFF0C363
FFF0C250  755120                            cmp     #20h, r1 ; ' '
FFF0C253  3b1a02                            bne.w   loc_FFF0C46D
FFF0C256  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C258  06c90104                          add     2Ch+var_24[sp].uw, r1
FFF0C25C  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C25E  06c90305                          add     2Ch+var_22[sp].uw, r3
FFF0C262  5f12                              movu.w  r1, r2
FFF0C264  5f31                              movu.w  r3, r1
FFF0C266  fb42bc2dedff                      mov.l   #unk_FFED2DBC, r4
FFF0C26C  6613                              mov.l   #1, r3
FFF0C26E  0567a6fe                          bsr.a   sub_FFEF68D5
FFF0C272  b909                              movu.w  2Ch+var_22[sp], r1
FFF0C274  711116                            add     #16h, r1, r1
FFF0C277  9109                              mov.w   r1, 2Ch+var_22[sp]
FFF0C279  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C27B  06c90104                          add     2Ch+var_24[sp].uw, r1
FFF0C27F  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C281  06c90305                          add     2Ch+var_22[sp].uw, r3
FFF0C285  5f12                              movu.w  r1, r2
FFF0C287  5f31                              movu.w  r3, r1
FFF0C289  fb42cc33edff                      mov.l   #unk_FFED33CC, r4
FFF0C28F  6613                              mov.l   #1, r3
FFF0C291  0544a6fe                          bsr.a   sub_FFEF68D5
FFF0C295  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C297  06c90106                          add     2Ch+var_20[sp].uw, r1
FFF0C29B  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C29D  06c90307                          add     2Ch+var_1E[sp].uw, r3
FFF0C2A1  60c0                              sub     #0Ch, sp
FFF0C2A3  fb225eabf4ff                      mov.l   #aUpload_0, r2; "UPLOAD"
FFF0C2A9  a00a                              mov.l   r2, 38h+var_34[sp]
FFF0C2AB  3c0801                            mov.b   #1, 38h+var_30[sp]
FFF0C2AE  f80406                            mov.b   #6, 38h+var_38[sp]
FFF0C2B1  5f12                              movu.w  r1, r2
FFF0C2B3  5f31                              movu.w  r3, r1
FFF0C2B5  6604                              mov.l   #0, r4
FFF0C2B7  66d3                              mov.l   #0Dh, r3
FFF0C2B9  056a58fe                          bsr.a   sub_FFEF1B23
FFF0C2BD  62c0                              add     #0Ch, sp
FFF0C2BF  b989                              movu.w  2Ch+var_1E[sp], r1
FFF0C2C1  711162                            add     #62h, r1, r1 ; 'b'
FFF0C2C4  9189                              mov.w   r1, 2Ch+var_1E[sp]
FFF0C2C6  fbe2468e0000                      mov.l   #8E46h, r14
FFF0C2CC  58ee                              movu.b  [r14], r14
FFF0C2CE  755ef8                            cmp     #-8, r14
FFF0C2D1  213b                              bne.b   loc_FFF0C30C
FFF0C2D3  fb12468e0000                      mov.l   #8E46h, r1
FFF0C2D9  b019                              movu.b  1[r1], r1
FFF0C2DB  755116                            cmp     #16h, r1
FFF0C2DE  2024                              beq.b   loc_FFF0C302
FFF0C2E0  755112                            cmp     #12h, r1
FFF0C2E3  2013                              beq.b   loc_FFF0C2F6
FFF0C2E5  755111                            cmp     #11h, r1
FFF0C2E8  2124                              bne.b   loc_FFF0C30C
FFF0C2EA  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0C2F0  c5e03811                          mov.b   38h[r14], 2Ch+var_1B[sp]
FFF0C2F4  2e18                              bra.b   loc_FFF0C30C
FFF0C2F6  fbe24d8c0000           loc_FFF0C2F6 mov.l   #8C4Dh, r14
FFF0C2FC  c5e03811                          mov.b   38h[r14], 2Ch+var_1B[sp]
FFF0C300  2e0c                              bra.b   loc_FFF0C30C
FFF0C302  fbe24d8c0000           loc_FFF0C302 mov.l   #8C4Dh, r14
FFF0C308  c5e03911                          mov.b   39h[r14], 2Ch+var_1B[sp]
FFF0C30C  754310                 loc_FFF0C30C mov.l   #10h, r3
FFF0C30F  6602                              mov.l   #0, r2
FFF0C311  710113                            add     #2Ch+var_19, sp, r1
FFF0C314  0586effe                          bsr.a   sub_FFEFB29A
FFF0C318  b40b                              movu.b  2Ch+var_1B[sp], r3
FFF0C31A  710212                            add     #2Ch+var_1A, sp, r2
FFF0C31D  710113                            add     #2Ch+var_19, sp, r1
FFF0C320  05ab5cfd                          bsr.a   sub_FFEE1FCB
FFF0C324  b481                              movu.b  2Ch+var_1A[sp], r1
FFF0C326  6101                              cmp     #0, r1
FFF0C328  1c                                bne.s   loc_FFF0C32C
FFF0C329  3c8201                            mov.b   #1, 2Ch+var_1A[sp]
FFF0C32C  b481                   loc_FFF0C32C movu.b  2Ch+var_1A[sp], r1
FFF0C32E  710e13                            add     #2Ch+var_19, sp, r14
FFF0C331  754f73                            mov.l   #73h, r15 ; 's'
FFF0C334  fe0e1f                            mov.b   r15, [r14, r1]
FFF0C337  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C339  06c90106                          add     2Ch+var_20[sp].uw, r1
FFF0C33D  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C33F  06c90307                          add     2Ch+var_1E[sp].uw, r3
FFF0C343  b482                              movu.b  2Ch+var_1A[sp], r2
FFF0C345  60c0                              sub     #0Ch, sp
FFF0C347  71041f                            add     #38h+var_19, sp, r4
FFF0C34A  a00c                              mov.l   r4, 38h+var_34[sp]
FFF0C34C  6212                              add     #1, r2
FFF0C34E  c302                              mov.b   r2, 38h+var_38[sp]
FFF0C350  3c0801                            mov.b   #1, 38h+var_30[sp]
FFF0C353  5f12                              movu.w  r1, r2
FFF0C355  5f31                              movu.w  r3, r1
FFF0C357  6604                              mov.l   #0, r4
FFF0C359  66d3                              mov.l   #0Dh, r3
FFF0C35B  05c857fe                          bsr.a   sub_FFEF1B23
FFF0C35F  62c0                              add     #0Ch, sp
FFF0C361  670b                              rtsd    #0Bh
FFF0C363  3d0508                 loc_FFF0C363 mov.w   #8, 2Ch+var_22[sp]
FFF0C366  3d042c                            mov.w   #2Ch, 2Ch+var_24[sp] ; ','
FFF0C369  3d0708                            mov.w   #8, 2Ch+var_1E[sp]
FFF0C36C  3d0604                            mov.w   #4, 2Ch+var_20[sp]
FFF0C36F  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C371  06c90106                          add     2Ch+var_20[sp].uw, r1
FFF0C375  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C377  06c90307                          add     2Ch+var_1E[sp].uw, r3
FFF0C37B  60c0                              sub     #0Ch, sp
FFF0C37D  fb2273abf4ff                      mov.l   #aEmergency, r2; "EMERGENCY !!"
FFF0C383  a00a                              mov.l   r2, 38h+var_34[sp]
FFF0C385  3c0801                            mov.b   #1, 38h+var_30[sp]
FFF0C388  f8040c                            mov.b   #0Ch, 38h+var_38[sp]
FFF0C38B  5f12                              movu.w  r1, r2
FFF0C38D  5f31                              movu.w  r3, r1
FFF0C38F  6604                              mov.l   #0, r4
FFF0C391  66d3                              mov.l   #0Dh, r3
FFF0C393  059057fe                          bsr.a   sub_FFEF1B23
FFF0C397  62c0                              add     #0Ch, sp
FFF0C399  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C39B  06c90104                          add     2Ch+var_24[sp].uw, r1
FFF0C39F  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C3A1  06c90305                          add     2Ch+var_22[sp].uw, r3
FFF0C3A5  5f12                              movu.w  r1, r2
FFF0C3A7  5f31                              movu.w  r3, r1
FFF0C3A9  fb428c2dedff                      mov.l   #unk_FFED2D8C, r4
FFF0C3AF  6613                              mov.l   #1, r3
FFF0C3B1  0524a5fe                          bsr.a   sub_FFEF68D5
FFF0C3B5  b909                              movu.w  2Ch+var_22[sp], r1
FFF0C3B7  711116                            add     #16h, r1, r1
FFF0C3BA  9109                              mov.w   r1, 2Ch+var_22[sp]
FFF0C3BC  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C3BE  06c90104                          add     2Ch+var_24[sp].uw, r1
FFF0C3C2  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C3C4  06c90305                          add     2Ch+var_22[sp].uw, r3
FFF0C3C8  5f12                              movu.w  r1, r2
FFF0C3CA  5f31                              movu.w  r3, r1
FFF0C3CC  fb42cc33edff                      mov.l   #unk_FFED33CC, r4
FFF0C3D2  6613                              mov.l   #1, r3
FFF0C3D4  0501a5fe                          bsr.a   sub_FFEF68D5
FFF0C3D8  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0C3DE  c5e03705                          mov.b   37h[r14], 2Ch+var_27[sp]
FFF0C3E2  b109                              movu.b  2Ch+var_27[sp], r1
FFF0C3E4  6141                              cmp     #4, r1
FFF0C3E6  2b05                              ble.b   loc_FFF0C3EB
FFF0C3E8  388500                            bra.w   loc_FFF0C46D
FFF0C3EB  b989                   loc_FFF0C3EB movu.w  2Ch+var_1E[sp], r1
FFF0C3ED  711131                            add     #31h, r1, r1 ; '1'
FFF0C3F0  9189                              mov.w   r1, 2Ch+var_1E[sp]
FFF0C3F2  b981                              movu.w  2Ch+var_20[sp], r1
FFF0C3F4  711125                            add     #25h, r1, r1 ; '%'
FFF0C3F7  9181                              mov.w   r1, 2Ch+var_20[sp]
FFF0C3F9  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C3FB  06c90106                          add     2Ch+var_20[sp].uw, r1
FFF0C3FF  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C401  06c90307                          add     2Ch+var_1E[sp].uw, r3
FFF0C405  b10a                              movu.b  2Ch+var_27[sp], r2
FFF0C407  60c0                              sub     #0Ch, sp
FFF0C409  751214                            mul     #14h, r2
FFF0C40C  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0C412  4b24                              add     r2, r4
FFF0C414  71443a                            add     #3Ah, r4, r4 ; ':'
FFF0C417  a00c                              mov.l   r4, 38h+var_34[sp]
FFF0C419  3c0801                            mov.b   #1, 38h+var_30[sp]
FFF0C41C  f8040a                            mov.b   #0Ah, 38h+var_38[sp]
FFF0C41F  5f12                              movu.w  r1, r2
FFF0C421  5f31                              movu.w  r3, r1
FFF0C423  6604                              mov.l   #0, r4
FFF0C425  66d3                              mov.l   #0Dh, r3
FFF0C427  05fc56fe                          bsr.a   sub_FFEF1B23
FFF0C42B  62c0                              add     #0Ch, sp
FFF0C42D  3d0708                            mov.w   #8, 2Ch+var_1E[sp]
FFF0C430  b981                              movu.w  2Ch+var_20[sp], r1
FFF0C432  711125                            add     #25h, r1, r1 ; '%'
FFF0C435  9181                              mov.w   r1, 2Ch+var_20[sp]
FFF0C437  bd01                              movu.w  2Ch+var_4[sp], r1
FFF0C439  06c90106                          add     2Ch+var_20[sp].uw, r1
FFF0C43D  bd0b                              movu.w  2Ch+var_2[sp], r3
FFF0C43F  06c90307                          add     2Ch+var_1E[sp].uw, r3
FFF0C443  b10a                              movu.b  2Ch+var_27[sp], r2
FFF0C445  60c0                              sub     #0Ch, sp
FFF0C447  751214                            mul     #14h, r2
FFF0C44A  fb424d8c0000                      mov.l   #8C4Dh, r4
FFF0C450  4b24                              add     r2, r4
FFF0C452  714448                            add     #48h, r4, r4 ; 'H'
FFF0C455  a00c                              mov.l   r4, 38h+var_34[sp]
FFF0C457  3c0801                            mov.b   #1, 38h+var_30[sp]
FFF0C45A  f80405                            mov.b   #5, 38h+var_38[sp]
FFF0C45D  5f12                              movu.w  r1, r2
FFF0C45F  5f31                              movu.w  r3, r1
FFF0C461  6604                              mov.l   #0, r4
FFF0C463  66d3                              mov.l   #0Dh, r3
FFF0C465  05be56fe                          bsr.a   sub_FFEF1B23
FFF0C469  62c0                              add     #0Ch, sp
FFF0C46B  670b                              rtsd    #0Bh
FFF0C46D  670b                   loc_FFF0C46D rtsd    #0Bh
FFF0C46F  7100d8                 sub_FFF0C46F add     #-28h, sp, sp   ; <<<< FUNC sub_FFF0C46F
FFF0C472  9489                              mov.w   r1, 28h+var_2[sp]
FFF0C474  9482                              mov.w   r2, 28h+var_4[sp]
FFF0C476  940b                              mov.w   r3, 28h+var_6[sp]
FFF0C478  9404                              mov.w   r4, 28h+var_8[sp]
FFF0C47A  c5002c1f                          mov.b   28h+arg_0[sp], 28h+var_9[sp]
FFF0C47E  3d0cf6                            mov.w   #-0Ah, 28h+var_10[sp]
FFF0C481  3d0b00                            mov.w   #0, 28h+var_12[sp]
FFF0C484  fbe24d8c0000                      mov.l   #8C4Dh, r14
FFF0C48A  c5e01a07                          mov.b   1Ah[r14], 28h+var_21[sp]
FFF0C48E  05643efe                          bsr.a   sub_FFEF02F2
FFF0C492  8181                              mov.b   r1, 28h+var_22[sp]
FFF0C494  391105                            bsr.w   sub_FFF0C9A5
FFF0C497  bc82                              movu.w  28h+var_4[sp], r2
FFF0C499  bc89                              movu.w  28h+var_2[sp], r1
FFF0C49B  39feee                            bsr.w   sub_FFF0B399
FFF0C49E  b189                              movu.b  28h+var_21[sp], r1
FFF0C4A0  6111                              cmp     #1, r1
FFF0C4A2  1a                                bne.s   loc_FFF0C4AC
FFF0C4A3  b181                              movu.b  28h+var_22[sp], r1
FFF0C4A5  6101                              cmp     #0, r1
FFF0C4A7  1d                                bne.s   loc_FFF0C4AC
FFF0C4A8  f80601                            mov.l   #1, 28h+var_28[sp]
FFF0C4AB  0c                                bra.s   loc_FFF0C4AF
FFF0C4AC  f80600                 loc_FFF0C4AC mov.l   #0, 28h+var_28[sp]
FFF0C4AF  ec01                   loc_FFF0C4AF mov.l   28h+var_28[sp], r1
FFF0C4B1  6101                              cmp     #0, r1
FFF0C4B3  1c                                bne.s   loc_FFF0C4B7
FFF0C4B4  3c0601                            mov.b   #1, 28h+var_22[sp]
FFF0C4B7  b181                   loc_FFF0C4B7 movu.b  28h+var_22[sp], r1
FFF0C4B9  6111                              cmp     #1, r1
FFF0C4BB  3b0103                            bne.w   loc_FFF0C7BC
FFF0C4BE  3d0d0f                            mov.w   #0Fh, 28h+var_E[sp]
FFF0C4C1  b789                              movu.b  28h+var_9[sp], r1
FFF0C4C3  721e10ff                          add     #-0F0h, r1, r14
FFF0C4C7  613e                              cmp     #3, r14
FFF0C4C9  2205                              bgeu.b  loc_FFF0C4CE
FFF0C4CB  38b202                            bra.w   loc_FFF0C77D
FFF0C4CE  711ec0                 loc_FFF0C4CE add     #-40h, r1, r14
FFF0C4D1  613e                              cmp     #3, r14
FFF0C4D3  2205                              bgeu.b  loc_FFF0C4D8
FFF0C4D5  389900                            bra.w   loc_FFF0C56E
FFF0C4D8  711ea0                 loc_FFF0C4D8 add     #-60h, r1, r14
FFF0C4DB  613e                              cmp     #3, r14
FFF0C4DD  2205                              bgeu.b  loc_FFF0C4E2
FFF0C4DF  38d100                            bra.w   loc_FFF0C5B0
FFF0C4E2  711e90                 loc_FFF0C4E2 add     #-70h, r1, r14
FFF0C4E5  613e                              cmp     #3, r14
FFF0C4E7  2205                              bgeu.b  loc_FFF0C4EC
FFF0C4E9  380901                            bra.w   loc_FFF0C5F2
FFF0C4EC  711e80                 loc_FFF0C4EC add     #-80h, r1, r14
FFF0C4EF  613e                              cmp     #3, r14
FFF0C4F1  2205                              bgeu.b  loc_FFF0C4F6
FFF0C4F3  384101                            bra.w   loc_FFF0C634
FFF0C4F6  721e50ff               loc_FFF0C4F6 add     #-0B0h, r1, r14
FFF0C4FA  613e                              cmp     #3, r14
FFF0C4FC  2205                              bgeu.b  loc_FFF0C501
FFF0C4FE  387801                            bra.w   loc_FFF0C676
FFF0C501  721e40ff               loc_FFF0C501 add     #-0C0h, r1, r14
FFF0C505  613e                              cmp     #3, r14
FFF0C507  2205                              bgeu.b  loc_FFF0C50C
FFF0C509  38af01                            bra.w   loc_FFF0C6B8
FFF0C50C  721e30ff               loc_FFF0C50C add     #-0D0h, r1, r14
FFF0C510  613e                              cmp     #3, r14
FFF0C512  2205                              bgeu.b  loc_FFF0C517
FFF0C514  38e601                            bra.w   loc_FFF0C6FA
FFF0C517  721e20ff               loc_FFF0C517 add     #-0E0h, r1, r14
FFF0C51B  613e                              cmp     #3, r14
FFF0C51D  2205                              bgeu.b  loc_FFF0C522
FFF0C51F  381d02                            bra.w   loc_FFF0C73C
FFF0C522  7111d0                 loc_FFF0C522 add     #-30h, r1, r1
FFF0C525  6121                              cmp     #2, r1
FFF0C527  2505                              bleu.b  loc_FFF0C52C
FFF0C529  389302                            bra.w   loc_FFF0C7BC
FFF0C52C  3c8507                 loc_FFF0C52C mov.b   #7, 28h+var_13[sp]
FFF0C52F  ba89                              movu.w  28h+var_12[sp], r1
FFF0C531  62e1                              add     #0Eh, r1
FFF0C533  4d0115                            mul     28h+var_13[sp], r1
FFF0C536  bb02                              movu.w  28h+var_10[sp], r2
FFF0C538  4312                              sub     r1, r2
FFF0C53A  fd748202                          div     #2, r2
FFF0C53E  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C540  bc81                              movu.w  28h+var_4[sp], r1
FFF0C542  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C546  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C548  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C54C  b50a                              movu.b  28h+var_13[sp], r2
FFF0C54E  b584                              movu.b  28h+var_12[sp], r4
FFF0C550  60c0                              sub     #0Ch, sp
FFF0C552  fb5280abf4ff                      mov.l   #aDelete, r5; "DELETE?"
FFF0C558  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C55A  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C55C  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C55F  5f12                              movu.w  r1, r2
FFF0C561  5f31                              movu.w  r3, r1
FFF0C563  66d3                              mov.l   #0Dh, r3
FFF0C565  05be55fe                          bsr.a   sub_FFEF1B23
FFF0C569  62c0                              add     #0Ch, sp
FFF0C56B  385102                            bra.w   loc_FFF0C7BC
FFF0C56E  3c8507                 loc_FFF0C56E mov.b   #7, 28h+var_13[sp]
FFF0C571  ba89                              movu.w  28h+var_12[sp], r1
FFF0C573  62e1                              add     #0Eh, r1
FFF0C575  4d0115                            mul     28h+var_13[sp], r1
FFF0C578  bb02                              movu.w  28h+var_10[sp], r2
FFF0C57A  4312                              sub     r1, r2
FFF0C57C  fd748202                          div     #2, r2
FFF0C580  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C582  bc81                              movu.w  28h+var_4[sp], r1
FFF0C584  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C588  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C58A  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C58E  b50a                              movu.b  28h+var_13[sp], r2
FFF0C590  b584                              movu.b  28h+var_12[sp], r4
FFF0C592  60c0                              sub     #0Ch, sp
FFF0C594  fb5288abf4ff                      mov.l   #aFormat, r5; "FORMAT?"
FFF0C59A  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C59C  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C59E  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C5A1  5f12                              movu.w  r1, r2
FFF0C5A3  5f31                              movu.w  r3, r1
FFF0C5A5  66d3                              mov.l   #0Dh, r3
FFF0C5A7  057c55fe                          bsr.a   sub_FFEF1B23
FFF0C5AB  62c0                              add     #0Ch, sp
FFF0C5AD  380f02                            bra.w   loc_FFF0C7BC
FFF0C5B0  3c8505                 loc_FFF0C5B0 mov.b   #5, 28h+var_13[sp]
FFF0C5B3  ba89                              movu.w  28h+var_12[sp], r1
FFF0C5B5  62e1                              add     #0Eh, r1
FFF0C5B7  4d0115                            mul     28h+var_13[sp], r1
FFF0C5BA  bb02                              movu.w  28h+var_10[sp], r2
FFF0C5BC  4312                              sub     r1, r2
FFF0C5BE  fd748202                          div     #2, r2
FFF0C5C2  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C5C4  bc81                              movu.w  28h+var_4[sp], r1
FFF0C5C6  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C5CA  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C5CC  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C5D0  b50a                              movu.b  28h+var_13[sp], r2
FFF0C5D2  b584                              movu.b  28h+var_12[sp], r4
FFF0C5D4  60c0                              sub     #0Ch, sp
FFF0C5D6  fb5290abf4ff                      mov.l   #aSend_0, r5; "SEND?"
FFF0C5DC  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C5DE  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C5E0  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C5E3  5f12                              movu.w  r1, r2
FFF0C5E5  5f31                              movu.w  r3, r1
FFF0C5E7  66d3                              mov.l   #0Dh, r3
FFF0C5E9  053a55fe                          bsr.a   sub_FFEF1B23
FFF0C5ED  62c0                              add     #0Ch, sp
FFF0C5EF  38cd01                            bra.w   loc_FFF0C7BC
FFF0C5F2  3c850c                 loc_FFF0C5F2 mov.b   #0Ch, 28h+var_13[sp]
FFF0C5F5  ba89                              movu.w  28h+var_12[sp], r1
FFF0C5F7  62e1                              add     #0Eh, r1
FFF0C5F9  4d0115                            mul     28h+var_13[sp], r1
FFF0C5FC  bb02                              movu.w  28h+var_10[sp], r2
FFF0C5FE  4312                              sub     r1, r2
FFF0C600  fd748202                          div     #2, r2
FFF0C604  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C606  bc81                              movu.w  28h+var_4[sp], r1
FFF0C608  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C60C  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C60E  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C612  b50a                              movu.b  28h+var_13[sp], r2
FFF0C614  b584                              movu.b  28h+var_12[sp], r4
FFF0C616  60c0                              sub     #0Ch, sp
FFF0C618  fb5296abf4ff                      mov.l   #aSendToAll, r5; "SEND to ALL?"
FFF0C61E  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C620  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C622  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C625  5f12                              movu.w  r1, r2
FFF0C627  5f31                              movu.w  r3, r1
FFF0C629  66d3                              mov.l   #0Dh, r3
FFF0C62B  05f854fe                          bsr.a   sub_FFEF1B23
FFF0C62F  62c0                              add     #0Ch, sp
FFF0C631  388b01                            bra.w   loc_FFF0C7BC
FFF0C634  3c850a                 loc_FFF0C634 mov.b   #0Ah, 28h+var_13[sp]
FFF0C637  ba89                              movu.w  28h+var_12[sp], r1
FFF0C639  62e1                              add     #0Eh, r1
FFF0C63B  4d0115                            mul     28h+var_13[sp], r1
FFF0C63E  bb02                              movu.w  28h+var_10[sp], r2
FFF0C640  4312                              sub     r1, r2
FFF0C642  fd748202                          div     #2, r2
FFF0C646  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C648  bc81                              movu.w  28h+var_4[sp], r1
FFF0C64A  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C64E  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C650  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C654  b50a                              movu.b  28h+var_13[sp], r2
FFF0C656  b584                              movu.b  28h+var_12[sp], r4
FFF0C658  60c0                              sub     #0Ch, sp
FFF0C65A  fb52a3abf4ff                      mov.l   #aOverwrite, r5; "OVERWRITE?"
FFF0C660  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C662  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C664  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C667  5f12                              movu.w  r1, r2
FFF0C669  5f31                              movu.w  r3, r1
FFF0C66B  66d3                              mov.l   #0Dh, r3
FFF0C66D  05b654fe                          bsr.a   sub_FFEF1B23
FFF0C671  62c0                              add     #0Ch, sp
FFF0C673  384901                            bra.w   loc_FFF0C7BC
FFF0C676  3c8506                 loc_FFF0C676 mov.b   #6, 28h+var_13[sp]
FFF0C679  ba89                              movu.w  28h+var_12[sp], r1
FFF0C67B  62e1                              add     #0Eh, r1
FFF0C67D  4d0115                            mul     28h+var_13[sp], r1
FFF0C680  bb02                              movu.w  28h+var_10[sp], r2
FFF0C682  4312                              sub     r1, r2
FFF0C684  fd748202                          div     #2, r2
FFF0C688  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C68A  bc81                              movu.w  28h+var_4[sp], r1
FFF0C68C  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C690  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C692  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C696  b50a                              movu.b  28h+var_13[sp], r2
FFF0C698  b584                              movu.b  28h+var_12[sp], r4
FFF0C69A  60c0                              sub     #0Ch, sp
FFF0C69C  fb52aeabf4ff                      mov.l   #aWrite, r5; "WRITE?"
FFF0C6A2  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C6A4  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C6A6  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C6A9  5f12                              movu.w  r1, r2
FFF0C6AB  5f31                              movu.w  r3, r1
FFF0C6AD  66d3                              mov.l   #0Dh, r3
FFF0C6AF  057454fe                          bsr.a   sub_FFEF1B23
FFF0C6B3  62c0                              add     #0Ch, sp
FFF0C6B5  380701                            bra.w   loc_FFF0C7BC
FFF0C6B8  3c8505                 loc_FFF0C6B8 mov.b   #5, 28h+var_13[sp]
FFF0C6BB  ba89                              movu.w  28h+var_12[sp], r1
FFF0C6BD  62e1                              add     #0Eh, r1
FFF0C6BF  4d0115                            mul     28h+var_13[sp], r1
FFF0C6C2  bb02                              movu.w  28h+var_10[sp], r2
FFF0C6C4  4312                              sub     r1, r2
FFF0C6C6  fd748202                          div     #2, r2
FFF0C6CA  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C6CC  bc81                              movu.w  28h+var_4[sp], r1
FFF0C6CE  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C6D2  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C6D4  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C6D8  b50a                              movu.b  28h+var_13[sp], r2
FFF0C6DA  b584                              movu.b  28h+var_12[sp], r4
FFF0C6DC  60c0                              sub     #0Ch, sp
FFF0C6DE  fb52b5abf4ff                      mov.l   #aRead, r5; "READ?"
FFF0C6E4  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C6E6  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C6E8  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C6EB  5f12                              movu.w  r1, r2
FFF0C6ED  5f31                              movu.w  r3, r1
FFF0C6EF  66d3                              mov.l   #0Dh, r3
FFF0C6F1  053254fe                          bsr.a   sub_FFEF1B23
FFF0C6F5  62c0                              add     #0Ch, sp
FFF0C6F7  38c500                            bra.w   loc_FFF0C7BC
FFF0C6FA  3c850a                 loc_FFF0C6FA mov.b   #0Ah, 28h+var_13[sp]
FFF0C6FD  ba89                              movu.w  28h+var_12[sp], r1
FFF0C6FF  62e1                              add     #0Eh, r1
FFF0C701  4d0115                            mul     28h+var_13[sp], r1
FFF0C704  bb02                              movu.w  28h+var_10[sp], r2
FFF0C706  4312                              sub     r1, r2
FFF0C708  fd748202                          div     #2, r2
FFF0C70C  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C70E  bc81                              movu.w  28h+var_4[sp], r1
FFF0C710  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C714  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C716  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C71A  b50a                              movu.b  28h+var_13[sp], r2
FFF0C71C  b584                              movu.b  28h+var_12[sp], r4
FFF0C71E  60c0                              sub     #0Ch, sp
FFF0C720  fb52bbabf4ff                      mov.l   #aEmergency_0, r5; "EMERGENCY!"
FFF0C726  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C728  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C72A  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C72D  5f12                              movu.w  r1, r2
FFF0C72F  5f31                              movu.w  r3, r1
FFF0C731  66d3                              mov.l   #0Dh, r3
FFF0C733  05f053fe                          bsr.a   sub_FFEF1B23
FFF0C737  62c0                              add     #0Ch, sp
FFF0C739  388300                            bra.w   loc_FFF0C7BC
FFF0C73C  3c8509                 loc_FFF0C73C mov.b   #9, 28h+var_13[sp]
FFF0C73F  ba89                              movu.w  28h+var_12[sp], r1
FFF0C741  62e1                              add     #0Eh, r1
FFF0C743  4d0115                            mul     28h+var_13[sp], r1
FFF0C746  bb02                              movu.w  28h+var_10[sp], r2
FFF0C748  4312                              sub     r1, r2
FFF0C74A  fd748202                          div     #2, r2
FFF0C74E  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C750  bc81                              movu.w  28h+var_4[sp], r1
FFF0C752  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C756  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C758  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C75C  b50a                              movu.b  28h+var_13[sp], r2
FFF0C75E  b584                              movu.b  28h+var_12[sp], r4
FFF0C760  60c0                              sub     #0Ch, sp
FFF0C762  fb52c6abf4ff                      mov.l   #aDownload_0, r5; "DOWNLOAD?"
FFF0C768  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C76A  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C76C  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C76F  5f12                              movu.w  r1, r2
FFF0C771  5f31                              movu.w  r3, r1
FFF0C773  66d3                              mov.l   #0Dh, r3
FFF0C775  05ae53fe                          bsr.a   sub_FFEF1B23
FFF0C779  62c0                              add     #0Ch, sp
FFF0C77B  2e41                              bra.b   loc_FFF0C7BC
FFF0C77D  3c850d                 loc_FFF0C77D mov.b   #0Dh, 28h+var_13[sp]
FFF0C780  ba89                              movu.w  28h+var_12[sp], r1
FFF0C782  62e1                              add     #0Eh, r1
FFF0C784  4d0115                            mul     28h+var_13[sp], r1
FFF0C787  bb02                              movu.w  28h+var_10[sp], r2
FFF0C789  4312                              sub     r1, r2
FFF0C78B  fd748202                          div     #2, r2
FFF0C78F  9382                              mov.w   r2, 28h+var_C[sp]
FFF0C791  bc81                              movu.w  28h+var_4[sp], r1
FFF0C793  06c9010d                          add     28h+var_E[sp].uw, r1
FFF0C797  bc8b                              movu.w  28h+var_2[sp], r3
FFF0C799  06c9030e                          add     28h+var_C[sp].uw, r3
FFF0C79D  b50a                              movu.b  28h+var_13[sp], r2
FFF0C79F  b584                              movu.b  28h+var_12[sp], r4
FFF0C7A1  60c0                              sub     #0Ch, sp
FFF0C7A3  fb52d0abf4ff                      mov.l   #aRegistration, r5; "REGISTRATION?"
FFF0C7A9  a00d                              mov.l   r5, 34h+var_30[sp]
FFF0C7AB  c302                              mov.b   r2, 34h+var_34[sp]
FFF0C7AD  3c0801                            mov.b   #1, 34h+var_2C[sp]
FFF0C7B0  5f12                              movu.w  r1, r2
FFF0C7B2  5f31                              movu.w  r3, r1
FFF0C7B4  66d3                              mov.l   #0Dh, r3
FFF0C7B6  056d53fe                          bsr.a   sub_FFEF1B23
FFF0C7BA  62c0                              add     #0Ch, sp
FFF0C7BC  bc89                   loc_FFF0C7BC movu.w  28h+var_2[sp], r1
FFF0C7BE  6261                              add     #6, r1
FFF0C7C0  9209                              mov.w   r1, 28h+var_16[sp]
FFF0C7C2  bc81                              movu.w  28h+var_4[sp], r1
FFF0C7C4  711134                            add     #34h, r1, r1 ; '4'
FFF0C7C7  9201                              mov.w   r1, 28h+var_18[sp]
FFF0C7C9  3d0768                            mov.w   #68h, 28h+var_1A[sp] ; 'h'
FFF0C7CC  3d0639                            mov.w   #39h, 28h+var_1C[sp] ; '9'
FFF0C7CF  3c0b00                            mov.b   #0, 28h+var_1D[sp]
FFF0C7D2  2e3f                              bra.b   loc_FFF0C811
FFF0C7D4  ba02                   loc_FFF0C7D4 movu.w  28h+var_18[sp], r2
FFF0C7D6  49020b                            add     28h+var_1D[sp], r2
FFF0C7D9  ba09                              movu.w  28h+var_16[sp], r1
FFF0C7DB  6211                              add     #1, r1
FFF0C7DD  5f11                              movu.w  r1, r1
FFF0C7DF  6212                              add     #1, r2
FFF0C7E1  5f22                              movu.w  r2, r2
FFF0C7E3  fb42fcf0ecff                      mov.l   #unk_FFECF0FC, r4
FFF0C7E9  6613                              mov.l   #1, r3
FFF0C7EB  05eaa0fe                          bsr.a   sub_FFEF68D5
FFF0C7EF  ba02                              movu.w  28h+var_18[sp], r2
FFF0C7F1  49020b                            add     28h+var_1D[sp], r2
FFF0C7F4  ba09                              movu.w  28h+var_16[sp], r1
FFF0C7F6  71117f                            add     #7Fh, r1, r1
FFF0C7F9  5f11                              movu.w  r1, r1
FFF0C7FB  6212                              add     #1, r2
FFF0C7FD  5f22                              movu.w  r2, r2
FFF0C7FF  fb42fcf0ecff                      mov.l   #unk_FFECF0FC, r4
FFF0C805  6613                              mov.l   #1, r3
FFF0C807  05cea0fe                          bsr.a   sub_FFEF68D5
FFF0C80B  b289                              movu.b  28h+var_1D[sp], r1
FFF0C80D  6211                              add     #1, r1
FFF0C80F  8289                              mov.b   r1, 28h+var_1D[sp]
FFF0C811  b289                   loc_FFF0C811 movu.b  28h+var_1D[sp], r1
FFF0C813  06c50106                          cmp     28h+var_1C[sp].uw, r1
FFF0C817  29bd                              blt.b   loc_FFF0C7D4
FFF0C819  3d047e                            mov.w   #7Eh, 28h+var_20[sp] ; '~'
FFF0C81C  3c0a00                            mov.b   #0, 28h+var_1E[sp]
FFF0C81F  38e300                            bra.w   loc_FFF0C902
FFF0C822  b901                   loc_FFF0C822 movu.w  28h+var_20[sp], r1
FFF0C824  4d010a                            mul     28h+var_1E[sp], r1
FFF0C827  06c90109                          add     28h+var_16[sp].uw, r1
FFF0C82B  b98b                              movu.w  28h+var_1A[sp], r3
FFF0C82D  ba02                              movu.w  28h+var_18[sp], r2
FFF0C82F  6040                              sub     #4, sp
FFF0C831  f8099def                          mov.w   #-1063h, 2Ch+var_2C[sp]
FFF0C835  6223                              add     #2, r3
FFF0C837  5f33                              movu.w  r3, r3
FFF0C839  5f11                              movu.w  r1, r1
FFF0C83B  6614                              mov.l   #1, r4
FFF0C83D  050b54fe                          bsr.a   sub_FFEF1C48
FFF0C841  6240                              add     #4, sp
FFF0C843  ba01                              movu.w  28h+var_18[sp], r1
FFF0C845  06c90106                          add     28h+var_1C[sp].uw, r1
FFF0C849  b904                              movu.w  28h+var_20[sp], r4
FFF0C84B  4d040a                            mul     28h+var_1E[sp], r4
FFF0C84E  06c90409                          add     28h+var_16[sp].uw, r4
FFF0C852  b98a                              movu.w  28h+var_1A[sp], r2
FFF0C854  6040                              sub     #4, sp
FFF0C856  f8098631                          mov.w   #3186h, 2Ch+var_2C[sp]
FFF0C85A  6222                              add     #2, r2
FFF0C85C  5f23                              movu.w  r2, r3
FFF0C85E  6211                              add     #1, r1
FFF0C860  5f12                              movu.w  r1, r2
FFF0C862  5f41                              movu.w  r4, r1
FFF0C864  6614                              mov.l   #1, r4
FFF0C866  05e253fe                          bsr.a   sub_FFEF1C48
FFF0C86A  6240                              add     #4, sp
FFF0C86C  b901                              movu.w  28h+var_20[sp], r1
FFF0C86E  4d010a                            mul     28h+var_1E[sp], r1
FFF0C871  06c90109                          add     28h+var_16[sp].uw, r1
FFF0C875  b983                              movu.w  28h+var_1C[sp], r3
FFF0C877  ba02                              movu.w  28h+var_18[sp], r2
FFF0C879  6040                              sub     #4, sp
FFF0C87B  f8099def                          mov.w   #-1063h, 2Ch+var_2C[sp]
FFF0C87F  6223                              add     #2, r3
FFF0C881  5f34                              movu.w  r3, r4
FFF0C883  5f11                              movu.w  r1, r1
FFF0C885  6613                              mov.l   #1, r3
FFF0C887  05c153fe                          bsr.a   sub_FFEF1C48
FFF0C88B  6240                              add     #4, sp
FFF0C88D  b901                              movu.w  28h+var_20[sp], r1
FFF0C88F  4d010a                            mul     28h+var_1E[sp], r1
FFF0C892  06c90109                          add     28h+var_16[sp].uw, r1
FFF0C896  06c90107                          add     28h+var_1A[sp].uw, r1
FFF0C89A  b983                              movu.w  28h+var_1C[sp], r3
FFF0C89C  ba02                              movu.w  28h+var_18[sp], r2
FFF0C89E  6040                              sub     #4, sp
FFF0C8A0  f8098631                          mov.w   #3186h, 2Ch+var_2C[sp]
FFF0C8A4  6223                              add     #2, r3
FFF0C8A6  5f34                              movu.w  r3, r4
FFF0C8A8  6211                              add     #1, r1
FFF0C8AA  5f11                              movu.w  r1, r1
FFF0C8AC  6613                              mov.l   #1, r3
FFF0C8AE  059a53fe                          bsr.a   sub_FFEF1C48
FFF0C8B2  6240                              add     #4, sp
FFF0C8B4  b901                              movu.w  28h+var_20[sp], r1
FFF0C8B6  4d010a                            mul     28h+var_1E[sp], r1
FFF0C8B9  06c90109                          add     28h+var_16[sp].uw, r1
FFF0C8BD  06c90107                          add     28h+var_1A[sp].uw, r1
FFF0C8C1  ba02                              movu.w  28h+var_18[sp], r2
FFF0C8C3  6040                              sub     #4, sp
FFF0C8C5  f809d294                          mov.w   #-6B2Eh, 2Ch+var_2C[sp]
FFF0C8C9  6211                              add     #1, r1
FFF0C8CB  5f11                              movu.w  r1, r1
FFF0C8CD  6613                              mov.l   #1, r3
FFF0C8CF  ef34                              mov.l   r3, r4
FFF0C8D1  057753fe                          bsr.a   sub_FFEF1C48
FFF0C8D5  6240                              add     #4, sp
FFF0C8D7  ba01                              movu.w  28h+var_18[sp], r1
FFF0C8D9  06c90106                          add     28h+var_1C[sp].uw, r1
FFF0C8DD  b903                              movu.w  28h+var_20[sp], r3
FFF0C8DF  4d030a                            mul     28h+var_1E[sp], r3
FFF0C8E2  06c90309                          add     28h+var_16[sp].uw, r3
FFF0C8E6  6040                              sub     #4, sp
FFF0C8E8  f8098631                          mov.w   #3186h, 2Ch+var_2C[sp]
FFF0C8EC  6211                              add     #1, r1
FFF0C8EE  5f12                              movu.w  r1, r2
FFF0C8F0  5f31                              movu.w  r3, r1
FFF0C8F2  6613                              mov.l   #1, r3
FFF0C8F4  ef34                              mov.l   r3, r4
FFF0C8F6  055253fe                          bsr.a   sub_FFEF1C48
FFF0C8FA  6240                              add     #4, sp
FFF0C8FC  b281                              movu.b  28h+var_1E[sp], r1
FFF0C8FE  6211                              add     #1, r1
