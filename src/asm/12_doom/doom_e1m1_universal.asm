DOOM_E1M1_START
PLY_AKG_OPCODE_ADD_HL_BC_MSB db 65
PLY_AKG_FULL_INIT_CODE
PLY_AKG_OFFSET1B
PLY_AKG_USE_HOOKS
PLY_AKG_STOP_SOUNDS db 84
PLY_AKG_BITFORSOUND
PLY_AKG_OFFSET2B
RASM_VERSION db 50
    db 48
PLY_AKG_BITFORNOISE equ $+1
    dw DOOM_E1M1_ARPEGGIOTABLE
    dw DOOM_E1M1_ARPEGGIOTABLE
PLY_AKG_OPCODE_ADD_HL_BC_LSB equ $+1
    dw DOOM_E1M1_ARPEGGIOTABLE
    dw DOOM_E1M1_EFFECTBLOCKTABLE
    dw DOOM_E1M1_SUBSONG0_START
DOOM_E1M1_ARPEGGIOTABLE
DOOM_E1M1_PITCHTABLE
DOOM_E1M1_INSTRUMENTTABLE dw DOOM_E1M1_EMPTYINSTRUMENT
    dw DOOM_E1M1_INSTRUMENT1
    dw DOOM_E1M1_INSTRUMENT2
    dw DOOM_E1M1_INSTRUMENT3
    dw DOOM_E1M1_INSTRUMENT4
    dw DOOM_E1M1_INSTRUMENT5
    dw DOOM_E1M1_INSTRUMENT6
DOOM_E1M1_EMPTYINSTRUMENT db 0
DOOM_E1M1_EMPTYINSTRUMENT_LOOP db 0
    db 6
DOOM_E1M1_INSTRUMENT1 db 1
    db 121
    db 21
    db 121
PLY_AKG_OPCODE_INC_HL db 64
    db 4
    db 249
    db 113
    db 64
    db 252
    db 113
    db 64
PLY_AKG_OPCODE_DEC_HL db 248
    db 105
    db 64
    db 248
    db 97
    db 64
    db 244
    db 6
DOOM_E1M1_INSTRUMENT2 db 3
    db 249
    db 113
    db 32
PLY_AKG_OPCODE_SCF db 255
    db 255
    db 233
    db 97
    db 32
    db 1
    db 0
    db 217
    db 81
    db 32
    db 255
PLY_AKG_OPCODE_SBC_HL_BC_LSB db 255
    db 201
    db 65
    db 32
    db 1
    db 0
    db 185
    db 49
    db 32
    db 255
    db 255
    db 169
    db 33
    db 32
    db 1
    db 0
    db 153
    db 17
    db 32
    db 255
    db 255
    db 9
    db 32
    db 255
    db 255
    db 6
DOOM_E1M1_INSTRUMENT3 db 1
    db 121
    db 73
    db 13
    db 121
    db 64
    db 9
    db 121
    db 64
    db 6
    db 105
    db 69
    db 4
    db 89
    db 69
    db 2
    db 6
DOOM_E1M1_INSTRUMENT4 db 1
    db 248
    db 1
    db 232
    db 1
    db 216
    db 1
    db 200
    db 1
    db 184
    db 1
    db 168
    db 1
    db 152
    db 1
    db 136
    db 1
    db 6
DOOM_E1M1_INSTRUMENT5 db 4
    db 249
    db 241
    db 105
    db 32
    db 1
    db 0
    db 105
    db 32
    db 255
    db 255
DOOM_E1M1_INSTRUMENT5_LOOP db 105
    db 32
    db 2
    db 0
    db 105
    db 32
    db 254
    db 255
    db 105
    db 32
    db 2
    db 0
    db 105
    db 32
    db 254
    db 255
    db 7
    dw DOOM_E1M1_INSTRUMENT5_LOOP
DOOM_E1M1_INSTRUMENT6 db 3
    db 248
    db 1
    db 240
    db 1
    db 232
    db 1
    db 224
    db 1
    db 216
    db 1
    db 200
    db 1
    db 192
    db 1
    db 184
    db 1
    db 176
    db 1
    db 168
    db 1
    db 160
    db 1
    db 152
    db 1
    db 144
PLY_AKG_OPCODE_OR_A db 1
    db 136
    db 1
    db 6
DOOM_E1M1_EFFECTBLOCKTABLE dw DOOM_E1M1_EFFECTBLOCK_P18P240P0
    dw DOOM_E1M1_EFFECTBLOCK_P20P240P0
    dw DOOM_E1M1_EFFECTBLOCK_P4P0
    dw DOOM_E1M1_EFFECTBLOCK_P4P2
    dw DOOM_E1M1_EFFECTBLOCK_P18P32P0
PLY_AKG_OPCODE_ADD_A_IMMEDIATE equ $+1
    dw DOOM_E1M1_EFFECTBLOCK_P20P32P0
DOOM_E1M1_EFFECTBLOCK_P4P0 db 4
    db 0
DOOM_E1M1_EFFECTBLOCK_P4P2 db 4
    db 2
DOOM_E1M1_EFFECTBLOCK_P18P32P0 db 18
    db 32
    db 0
DOOM_E1M1_EFFECTBLOCK_P20P32P0 db 20
    db 32
    db 0
DOOM_E1M1_EFFECTBLOCK_P18P240P0 db 18
    db 240
    db 0
DOOM_E1M1_EFFECTBLOCK_P20P240P0 db 20
    db 240
PLY_AKG_OPCODE_SUB_IMMEDIATE db 0
DOOM_E1M1_SUBSONG0_START db 2
    db 1
    db 1
    db 1
    db 30
    db 6
    db 28
DOOM_E1M1_SUBSONG0_LINKER dw DOOM_E1M1_SUBSONG0_TRACK24
    dw DOOM_E1M1_SUBSONG0_TRACK24
    dw DOOM_E1M1_SUBSONG0_TRACK24
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK0
DOOM_E1M1_SUBSONG0_LINKER_LOOP dw DOOM_E1M1_SUBSONG0_TRACK1
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK2
PLY_AKG_OPCODE_SBC_HL_BC_MSB equ $+1
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK1
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK2
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK3
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK4
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK3
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK5
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK24
    dw DOOM_E1M1_SUBSONG0_TRACK6
    dw DOOM_E1M1_SUBSONG0_TRACK7
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK8
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK8
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK16
    dw DOOM_E1M1_SUBSONG0_TRACK10
    dw DOOM_E1M1_SUBSONG0_TRACK11
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK12
    dw DOOM_E1M1_SUBSONG0_TRACK13
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK12
    dw DOOM_E1M1_SUBSONG0_TRACK13
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK14
    dw DOOM_E1M1_SUBSONG0_TRACK15
    dw DOOM_E1M1_SUBSONG0_TRACK11
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK8
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK16
    dw DOOM_E1M1_SUBSONG0_TRACK17
    dw DOOM_E1M1_SUBSONG0_TRACK18
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK4
    dw DOOM_E1M1_SUBSONG0_TRACK19
    dw DOOM_E1M1_SUBSONG0_TRACK20
    dw DOOM_E1M1_SUBSONG0_TRACK21
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK8
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK1
    dw DOOM_E1M1_SUBSONG0_TRACK22
    dw DOOM_E1M1_SUBSONG0_TRACK23
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK1
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK2
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK1
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK2
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK24
    dw DOOM_E1M1_SUBSONG0_TRACK25
    dw DOOM_E1M1_SUBSONG0_TRACK26
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK27
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK27
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK16
    dw DOOM_E1M1_SUBSONG0_TRACK28
    dw DOOM_E1M1_SUBSONG0_TRACK29
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK30
    dw DOOM_E1M1_SUBSONG0_TRACK13
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK30
    dw DOOM_E1M1_SUBSONG0_TRACK13
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK14
    dw DOOM_E1M1_SUBSONG0_TRACK31
    dw DOOM_E1M1_SUBSONG0_TRACK32
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    dw DOOM_E1M1_SUBSONG0_TRACK27
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK35
    dw DOOM_E1M1_SUBSONG0_TRACK17
    dw DOOM_E1M1_SUBSONG0_TRACK18
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK4
    dw DOOM_E1M1_SUBSONG0_TRACK33
    dw DOOM_E1M1_SUBSONG0_TRACK20
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK1
    dw DOOM_E1M1_SUBSONG0_TRACK27
    dw DOOM_E1M1_SUBSONG0_TRACK0
    dw DOOM_E1M1_SUBSONG0_TRACK9
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK2
    dw DOOM_E1M1_SUBSONG0_TRACK1
    dw DOOM_E1M1_SUBSONG0_TRACK34
    dw DOOM_E1M1_SUBSONG0_TRACK5
    dw DOOM_E1M1_SUBSONG0_LINKERBLOCK3
    db 0
    db 0
    dw DOOM_E1M1_SUBSONG0_LINKER_LOOP
DOOM_E1M1_SUBSONG0_LINKERBLOCK0 db 8
    db 0
    db 0
    db 0
    dw DOOM_E1M1_SUBSONG0_SPEEDTRACK0
    dw DOOM_E1M1_SUBSONG0_EVENTTRACK0
DOOM_E1M1_SUBSONG0_LINKERBLOCK1 db 32
    db 0
    db 0
    db 0
    dw DOOM_E1M1_SUBSONG0_SPEEDTRACK0
    dw DOOM_E1M1_SUBSONG0_EVENTTRACK0
DOOM_E1M1_SUBSONG0_LINKERBLOCK2 db 24
    db 0
    db 0
    db 0
    dw DOOM_E1M1_SUBSONG0_SPEEDTRACK0
    dw DOOM_E1M1_SUBSONG0_EVENTTRACK0
DOOM_E1M1_SUBSONG0_LINKERBLOCK3 db 16
    db 0
    db 0
    db 0
    dw DOOM_E1M1_SUBSONG0_SPEEDTRACK1
    dw DOOM_E1M1_SUBSONG0_EVENTTRACK0
DOOM_E1M1_SUBSONG0_LINKERBLOCK4 db 64
    db 0
    db 0
    db 0
    dw DOOM_E1M1_SUBSONG0_SPEEDTRACK1
    dw DOOM_E1M1_SUBSONG0_EVENTTRACK0
DOOM_E1M1_SUBSONG0_TRACK0 db 204
    db 5
    db 2
    db 12
    db 24
    db 12
    db 12
    db 22
    db 12
    db 12
    db 20
    db 12
    db 12
    db 18
    db 12
    db 12
    db 19
    db 20
    db 12
    db 12
    db 24
    db 12
    db 12
    db 22
    db 12
    db 12
    db 20
    db 12
    db 12
    db 18
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK1 db 192
    db 2
    db 2
    db 61
    db 14
    db 0
    db 61
    db 9
    db 140
    db 5
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK2 db 128
    db 1
    db 61
    db 14
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK3 db 192
    db 2
    db 2
    db 0
    db 12
    db 0
    db 0
    db 10
    db 0
    db 0
    db 8
    db 0
    db 0
    db 6
    db 0
    db 0
    db 7
    db 8
    db 0
    db 0
    db 12
    db 0
    db 0
    db 10
    db 0
    db 0
    db 8
    db 0
    db 0
    db 204
    db 5
    db 2
    db 124
    db 5
    db 124
    db 4
    db 124
    db 5
    db 124
    db 4
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK4 db 128
    db 1
    db 61
    db 14
    db 0
    db 61
    db 12
    db 152
    db 4
    db 24
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK5 db 128
    db 1
    db 61
    db 6
    db 148
    db 6
    db 61
    db 6
    db 128
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK6 db 230
    db 2
    db 3
    db 36
    db 35
    db 38
    db 41
    db 39
    db 38
    db 35
    db 38
    db 39
    db 41
    db 43
    db 41
    db 39
    db 38
    db 35
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK7 db 128
    db 1
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK8 db 192
    db 2
    db 2
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 60
    db 0
    db 140
    db 5
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK9 db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK10 db 235
    db 2
    db 3
    db 39
    db 36
    db 39
    db 43
    db 39
    db 43
    db 48
    db 43
    db 39
    db 43
    db 39
    db 43
    db 48
    db 51
    db 55
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK11 db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 12
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK12 db 197
    db 2
    db 2
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 60
    db 5
    db 145
    db 5
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK13 db 209
    db 5
    db 2
    db 17
    db 29
    db 17
    db 17
    db 27
    db 17
    db 17
    db 25
    db 17
    db 17
    db 23
    db 17
    db 17
    db 24
    db 25
    db 17
    db 17
    db 29
    db 17
    db 17
    db 27
    db 17
    db 17
    db 153
    db 2
    db 145
    db 5
    db 17
    db 23
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK14 db 197
    db 2
    db 2
    db 126
    db 5
    db 126
    db 5
    db 126
    db 5
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK15 db 233
    db 5
    db 3
    db 166
    db 2
    db 36
    db 41
    db 36
    db 32
    db 36
    db 41
    db 44
    db 41
    db 36
    db 41
    db 36
    db 41
    db 36
    db 32
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK16 db 192
    db 2
    db 2
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 126
    db 0
    db 60
    db 140
    db 5
    db 60
    db 124
    db 1
    db 60
    db 124
    db 0
    db 60
    db 124
    db 1
    db 60
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK17 db 204
    db 5
    db 2
    db 60
    db 12
    db 60
    db 24
    db 60
    db 12
    db 60
    db 12
    db 60
    db 22
    db 60
    db 12
    db 60
    db 12
    db 60
    db 20
    db 60
    db 12
    db 60
    db 12
    db 60
    db 18
    db 60
    db 12
    db 60
    db 12
    db 60
    db 19
    db 60
    db 20
    db 60
    db 12
    db 60
    db 12
    db 60
    db 24
    db 60
    db 12
    db 60
    db 12
    db 60
    db 22
    db 60
    db 12
    db 60
    db 12
    db 60
    db 20
    db 60
    db 12
    db 60
    db 12
    db 60
    db 18
    db 60
    db 124
    db 0
    db 60
    db 124
    db 1
    db 60
    db 124
    db 0
    db 60
    db 124
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK18 db 128
    db 1
    db 126
    db 140
    db 3
    db 126
    db 128
    db 1
    db 60
    db 0
    db 60
    db 140
    db 3
    db 126
    db 128
    db 1
    db 126
    db 140
    db 3
    db 126
    db 128
    db 1
    db 126
    db 140
    db 3
    db 126
    db 128
    db 1
    db 126
    db 140
    db 3
    db 126
    db 128
    db 1
    db 60
    db 0
    db 60
    db 140
    db 3
    db 126
    db 12
    db 128
    db 1
    db 0
    db 140
    db 3
    db 12
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 12
    db 128
    db 1
    db 0
    db 140
    db 3
    db 12
    db 128
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK19 db 201
    db 2
    db 2
    db 60
    db 9
    db 60
    db 9
    db 60
    db 9
    db 60
    db 9
    db 60
    db 9
    db 60
    db 9
    db 60
    db 9
    db 60
    db 7
    db 60
    db 7
    db 60
    db 7
    db 60
    db 7
    db 60
    db 5
    db 60
    db 5
    db 145
    db 5
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK20 db 213
    db 5
    db 2
    db 21
    db 33
    db 21
    db 21
    db 31
    db 21
    db 21
    db 29
    db 21
    db 21
    db 27
    db 21
    db 21
    db 28
    db 29
    db 19
    db 19
    db 31
    db 19
    db 19
    db 29
    db 19
    db 19
    db 27
    db 18
    db 17
    db 25
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK21 db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK22 db 231
    db 2
    db 3
    db 43
    db 36
    db 31
    db 39
    db 36
    db 43
    db 39
    db 43
    db 39
    db 36
    db 31
    db 39
    db 43
    db 48
    db 51
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK23 db 128
    db 1
    db 126
    db 164
    db 6
    db 126
    db 164
    db 4
    db 126
    db 164
    db 6
    db 60
    db 36
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK24 db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK25 db 230
    db 2
    db 3
    db 36
    db 35
    db 31
    db 41
    db 38
    db 35
    db 31
    db 43
    db 41
    db 38
    db 35
    db 47
    db 45
    db 43
    db 41
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK26 db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 12
    db 60
    db 12
    db 60
    db 12
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK27 db 192
    db 2
    db 2
    db 60
    db 155
    db 5
    db 60
    db 128
    db 2
    db 154
    db 5
    db 128
    db 2
    db 60
    db 151
    db 5
    db 60
    db 128
    db 2
    db 150
    db 5
    db 128
    db 2
    db 60
    db 150
    db 5
    db 24
    db 128
    db 2
    db 60
    db 155
    db 5
    db 60
    db 128
    db 2
    db 154
    db 5
    db 128
    db 2
    db 60
    db 152
    db 5
    db 60
    db 128
    db 2
    db 149
    db 5
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK28 db 243
    db 2
    db 3
    db 48
    db 43
    db 39
    db 48
    db 51
    db 48
    db 43
    db 39
    db 43
    db 48
    db 43
    db 51
    db 48
    db 43
    db 39
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK29 db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK30 db 197
    db 2
    db 2
    db 60
    db 160
    db 5
    db 60
    db 133
    db 2
    db 159
    db 5
    db 133
    db 2
    db 60
    db 156
    db 5
    db 60
    db 133
    db 2
    db 155
    db 5
    db 133
    db 2
    db 60
    db 155
    db 5
    db 29
    db 133
    db 2
    db 60
    db 160
    db 5
    db 60
    db 133
    db 2
    db 159
    db 5
    db 133
    db 2
    db 60
    db 157
    db 5
    db 60
    db 133
    db 2
    db 155
    db 5
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK31 db 233
    db 5
    db 3
    db 37
    db 36
    db 41
    db 36
    db 32
    db 36
    db 41
    db 44
    db 41
    db 36
    db 41
    db 36
    db 41
    db 36
    db 32
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK32 db 140
    db 3
    db 60
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 140
    db 3
    db 12
    db 128
    db 1
    db 60
    db 140
    db 3
    db 60
    db 128
    db 1
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK33 db 201
    db 2
    db 2
    db 60
    db 167
    db 5
    db 60
    db 137
    db 2
    db 166
    db 5
    db 137
    db 2
    db 60
    db 164
    db 5
    db 60
    db 137
    db 2
    db 161
    db 5
    db 137
    db 2
    db 60
    db 161
    db 5
    db 36
    db 135
    db 2
    db 60
    db 166
    db 5
    db 60
    db 135
    db 2
    db 164
    db 5
    db 135
    db 2
    db 60
    db 163
    db 5
    db 60
    db 133
    db 2
    db 159
    db 5
    db 124
    db 0
    db 124
    db 1
    db 124
    db 0
    db 124
    db 1
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK34 db 235
    db 2
    db 3
    db 41
    db 38
    db 35
    db 31
    db 29
    db 26
    db 23
    db 47
    db 45
    db 43
    db 41
    db 38
    db 35
    db 31
    db 29
    db 61
    db 127
DOOM_E1M1_SUBSONG0_TRACK35 db 192
    db 2
    db 2
    db 126
    db 155
    db 5
    db 126
    db 128
    db 2
    db 60
    db 154
    db 5
    db 60
    db 128
    db 2
    db 126
    db 151
    db 5
    db 126
    db 128
    db 2
    db 60
    db 150
    db 5
    db 60
    db 128
    db 2
    db 126
    db 150
    db 5
    db 60
    db 24
    db 60
    db 128
    db 2
    db 126
    db 155
    db 5
    db 126
    db 128
    db 2
    db 60
    db 154
    db 5
    db 60
    db 128
    db 2
    db 126
    db 152
    db 5
    db 126
    db 128
    db 2
    db 60
    db 149
    db 5
    db 60
    db 124
    db 1
    db 60
    db 124
    db 0
    db 60
    db 124
    db 1
    db 60
    db 124
    db 0
    db 61
    db 127
DOOM_E1M1_SUBSONG0_SPEEDTRACK0 db 12
    db 253
DOOM_E1M1_SUBSONG0_SPEEDTRACK1 db 6
    db 253
DOOM_E1M1_SUBSONG0_EVENTTRACK0 db 255
PLY_AKG_START jp PLY_AKG_INIT
    jp PLY_AKG_PLAY
    jp PLY_AKG_INITTABLEORA_END
PLY_AKG_INIT ld de,4
    add hl,de
    inc hl
    inc hl
    inc hl
    inc hl
    ld de,PLY_AKG_INSTRUMENTSTABLE+1
    ldi
    ldi
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld (PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS1+1),bc
    ld (PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS2+1),bc
    add a,a
    ld e,a
    ld d,0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld de,5
    add hl,de
    ld de,PLY_AKG_CHANNEL3_READCELLEND+1
    ldi
    ld de,PLY_AKG_CHANNEL1_NOTE+1
    ldi
    ld (PLY_AKG_READLINKER+1),hl
    ld hl,PLY_AKG_INITTABLE0
    ld bc,3328
    call PLY_AKG_INIT_READWORDSANDFILL
    inc c
    ld hl,PLY_AKG_INITTABLE0_END
    ld b,3
    call PLY_AKG_INIT_READWORDSANDFILL
    ld hl,PLY_AKG_INITTABLE1_END
    ld bc,1207
    call PLY_AKG_INIT_READWORDSANDFILL
    ld hl,(PLY_AKG_INSTRUMENTSTABLE+1)
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl
    inc hl
    ld (PLY_AKG_ENDWITHOUTLOOP+1),hl
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT+1),hl
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT+1),hl
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT+1),hl
    ret 
PLY_AKG_INIT_READWORDSANDFILL_LOOP ld e,(hl)
    inc hl
    ld d,(hl)
    inc hl
    ld a,c
    ld (de),a
PLY_AKG_INIT_READWORDSANDFILL djnz PLY_AKG_INIT_READWORDSANDFILL_LOOP
    ret 
PLY_AKG_INITTABLE0 dw PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL+1
    dw PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER
    dw PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL+1
    dw PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER
    dw PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL+1
    dw PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER
    dw PLY_AKG_CHANNEL1_PITCH+1
    dw PLY_AKG_CHANNEL1_PITCH+2
    dw PLY_AKG_CHANNEL2_PITCH+1
    dw PLY_AKG_CHANNEL2_PITCH+2
    dw PLY_AKG_CHANNEL3_PITCH+1
    dw PLY_AKG_CHANNEL3_PITCH+2
PLY_AKG_INITTABLE0_END
PLY_AKG_INITTABLE1 dw PLY_AKG_PATTERNDECREASINGHEIGHT+1
    dw PLY_AKG_TICKDECREASINGCOUNTER+1
PLY_AKG_INITTABLE1_END
PLY_AKG_INITTABLEORA dw PLY_AKG_CHANNEL1_ISPITCH
    dw PLY_AKG_CHANNEL2_ISPITCH
    dw PLY_AKG_CHANNEL3_ISPITCH
PLY_AKG_INITTABLEORA_END
PLY_AKG_STOP ld (PLY_AKG_SAVESP+1),sp
    xor a
    ld l,a
    ld h,a
    ld (PLY_AKG_PSGREG8),a
    ld (PLY_AKG_PSGREG9),hl
    ld a,191
    jp PLY_AKG_SENDPSGREGISTERS
PLY_AKG_PLAY ld (PLY_AKG_SAVESP+1),sp
PLY_AKG_TICKDECREASINGCOUNTER ld a,1
    dec a
    jp nz,PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS
PLY_AKG_PATTERNDECREASINGHEIGHT ld a,1
    dec a
    jr nz,PLY_AKG_SETCURRENTLINEBEFOREREADLINE
PLY_AKG_READLINKER
PLY_AKG_READLINKER_PTLINKER ld sp,0
    pop hl
    ld a,l
    or h
    jr nz,PLY_AKG_READLINKER_NOLOOP
    pop hl
    ld sp,hl
    pop hl
PLY_AKG_READLINKER_NOLOOP ld (PLY_AKG_CHANNEL1_READTRACK+1),hl
    pop hl
    ld (PLY_AKG_CHANNEL2_READTRACK+1),hl
    pop hl
    ld (PLY_AKG_CHANNEL3_READTRACK+1),hl
    pop hl
    ld (PLY_AKG_READLINKER+1),sp
    ld sp,hl
    pop hl
    ld c,l
    pop hl
    pop hl
    ld (PLY_AKG_SPEEDTRACK_PTTRACK+1),hl
    xor a
    ld (PLY_AKG_READLINE+1),a
    ld (PLY_AKG_SPEEDTRACK_END+1),a
    ld (PLY_AKG_CHANNEL1_READCELLEND+1),a
    ld (PLY_AKG_CHANNEL2_READCELLEND+1),a
    ld a,c
PLY_AKG_SETCURRENTLINEBEFOREREADLINE ld (PLY_AKG_PATTERNDECREASINGHEIGHT+1),a
PLY_AKG_READLINE
PLY_AKG_SPEEDTRACK_WAITCOUNTER ld a,0
    sub 1
    jr nc,PLY_AKG_SPEEDTRACK_MUSTWAIT
PLY_AKG_SPEEDTRACK_PTTRACK ld hl,0
    ld a,(hl)
    inc hl
    srl a
    jr c,PLY_AKG_SPEEDTRACK_STOREPOINTERANDWAITCOUNTER
    jr nz,PLY_AKG_SPEEDTRACK_NORMALVALUE
    ld a,(hl)
    inc hl
PLY_AKG_SPEEDTRACK_NORMALVALUE ld (PLY_AKG_CHANNEL3_READCELLEND+1),a
    xor a
PLY_AKG_SPEEDTRACK_STOREPOINTERANDWAITCOUNTER ld (PLY_AKG_SPEEDTRACK_PTTRACK+1),hl
PLY_AKG_SPEEDTRACK_MUSTWAIT ld (PLY_AKG_READLINE+1),a
PLY_AKG_SPEEDTRACK_END
PLY_AKG_CHANNEL1_WAITCOUNTER ld a,0
    sub 1
    jr c,PLY_AKG_CHANNEL1_READTRACK
    ld (PLY_AKG_SPEEDTRACK_END+1),a
    jp PLY_AKG_CHANNEL1_READCELLEND
PLY_AKG_CHANNEL1_READTRACK
PLY_AKG_CHANNEL1_PTTRACK ld hl,0
    ld c,(hl)
    inc hl
    ld a,c
    and 63
    cp 60
    jr c,PLY_AKG_CHANNEL1_NOTE
    sub 60
    jp z,PLY_AKG_CHANNEL1_MAYBEEFFECTS
    dec a
    jr z,PLY_AKG_CHANNEL1_WAIT
    dec a
    jr z,PLY_AKG_CHANNEL1_SMALLWAIT
    ld a,(hl)
    inc hl
    jr PLY_AKG_CHANNEL1_AFTERNOTEKNOWN
PLY_AKG_CHANNEL1_SMALLWAIT ld a,c
    rlca 
    rlca 
    and 3
    inc a
    ld (PLY_AKG_SPEEDTRACK_END+1),a
    jr PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_WAIT ld a,(hl)
    ld (PLY_AKG_SPEEDTRACK_END+1),a
    inc hl
    jr PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_SAMEINSTRUMENT
PLY_AKG_CHANNEL1_PTBASEINSTRUMENT ld de,0
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT+1),de
    jr PLY_AKG_CHANNEL1_AFTERINSTRUMENT
PLY_AKG_CHANNEL1_NOTE
PLY_AKG_BASENOTEINDEX add a,0
PLY_AKG_CHANNEL1_AFTERNOTEKNOWN ld (PLY_AKG_CHANNEL1_TRACKNOTE+1),a
    rl c
    jr nc,PLY_AKG_CHANNEL1_SAMEINSTRUMENT
    ld a,(hl)
    inc hl
    exx
    ld l,a
    ld h,0
    add hl,hl
PLY_AKG_INSTRUMENTSTABLE ld de,0
    add hl,de
    ld sp,hl
    pop hl
    ld a,(hl)
    inc hl
    ld (PLY_AKG_CHANNEL1_INSTRUMENTSPEED+1),a
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT+1),hl
    ld (PLY_AKG_CHANNEL1_SAMEINSTRUMENT+1),hl
    exx
PLY_AKG_CHANNEL1_AFTERINSTRUMENT ex de,hl
    xor a
    ld l,a
    ld h,a
    ld (PLY_AKG_CHANNEL1_PITCH+1),hl
    ld (PLY_AKG_CHANNEL1_INSTRUMENTSTEP+2),a
    ld a,183
    ld (PLY_AKG_CHANNEL1_ISPITCH),a
    ex de,hl
    rl c
    jp c,PLY_AKG_CHANNEL1_READEFFECTS
PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER ld (PLY_AKG_CHANNEL1_READTRACK+1),hl
PLY_AKG_CHANNEL1_READCELLEND
PLY_AKG_CHANNEL2_WAITCOUNTER ld a,0
    sub 1
    jr c,PLY_AKG_CHANNEL2_READTRACK
    ld (PLY_AKG_CHANNEL1_READCELLEND+1),a
    jp PLY_AKG_CHANNEL2_READCELLEND
PLY_AKG_CHANNEL2_READTRACK
PLY_AKG_CHANNEL2_PTTRACK ld hl,0
    ld c,(hl)
    inc hl
    ld a,c
    and 63
    cp 60
    jr c,PLY_AKG_CHANNEL2_NOTE
    sub 60
    jp z,PLY_AKG_CHANNEL1_READEFFECTSEND
    dec a
    jr z,PLY_AKG_CHANNEL2_WAIT
    dec a
    jr z,PLY_AKG_CHANNEL2_SMALLWAIT
    ld a,(hl)
    inc hl
    jr PLY_AKG_CHANNEL2_AFTERNOTEKNOWN
PLY_AKG_CHANNEL2_SMALLWAIT ld a,c
    rlca 
    rlca 
    and 3
    inc a
    ld (PLY_AKG_CHANNEL1_READCELLEND+1),a
    jr PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_WAIT ld a,(hl)
    ld (PLY_AKG_CHANNEL1_READCELLEND+1),a
    inc hl
    jr PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_SAMEINSTRUMENT
PLY_AKG_CHANNEL2_PTBASEINSTRUMENT ld de,0
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT+1),de
    jr PLY_AKG_CHANNEL2_AFTERINSTRUMENT
PLY_AKG_CHANNEL2_NOTE ld b,a
    ld a,(PLY_AKG_CHANNEL1_NOTE+1)
    add a,b
PLY_AKG_CHANNEL2_AFTERNOTEKNOWN ld (PLY_AKG_CHANNEL2_TRACKNOTE+1),a
    rl c
    jr nc,PLY_AKG_CHANNEL2_SAMEINSTRUMENT
    ld a,(hl)
    inc hl
    exx
    ld e,a
    ld d,0
    ld hl,(PLY_AKG_INSTRUMENTSTABLE+1)
    add hl,de
    add hl,de
    ld sp,hl
    pop hl
    ld a,(hl)
    inc hl
    ld (PLY_AKG_CHANNEL2_INSTRUMENTSPEED+1),a
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT+1),hl
    ld (PLY_AKG_CHANNEL2_SAMEINSTRUMENT+1),hl
    exx
PLY_AKG_CHANNEL2_AFTERINSTRUMENT ex de,hl
    xor a
    ld l,a
    ld h,a
    ld (PLY_AKG_CHANNEL2_PITCH+1),hl
    ld (PLY_AKG_CHANNEL2_INSTRUMENTSTEP+2),a
    ld a,183
    ld (PLY_AKG_CHANNEL2_ISPITCH),a
    ex de,hl
    rl c
    jp c,PLY_AKG_CHANNEL2_READEFFECTS
PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER ld (PLY_AKG_CHANNEL2_READTRACK+1),hl
PLY_AKG_CHANNEL2_READCELLEND
PLY_AKG_CHANNEL3_WAITCOUNTER ld a,0
    sub 1
    jr c,PLY_AKG_CHANNEL3_READTRACK
    ld (PLY_AKG_CHANNEL2_READCELLEND+1),a
    jp PLY_AKG_CHANNEL3_READCELLEND
PLY_AKG_CHANNEL3_READTRACK
PLY_AKG_CHANNEL3_PTTRACK ld hl,0
    ld c,(hl)
    inc hl
    ld a,c
    and 63
    cp 60
    jr c,PLY_AKG_CHANNEL3_NOTE
    sub 60
    jp z,PLY_AKG_CHANNEL2_READEFFECTSEND
    dec a
    jr z,PLY_AKG_CHANNEL3_WAIT
    dec a
    jr z,PLY_AKG_CHANNEL3_SMALLWAIT
    ld a,(hl)
    inc hl
    jr PLY_AKG_CHANNEL3_AFTERNOTEKNOWN
PLY_AKG_CHANNEL3_SMALLWAIT ld a,c
    rlca 
    rlca 
    and 3
    inc a
    ld (PLY_AKG_CHANNEL2_READCELLEND+1),a
    jr PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_WAIT ld a,(hl)
    ld (PLY_AKG_CHANNEL2_READCELLEND+1),a
    inc hl
    jr PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_SAMEINSTRUMENT
PLY_AKG_CHANNEL3_PTBASEINSTRUMENT ld de,0
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT+1),de
    jr PLY_AKG_CHANNEL3_AFTERINSTRUMENT
PLY_AKG_CHANNEL3_NOTE ld b,a
    ld a,(PLY_AKG_CHANNEL1_NOTE+1)
    add a,b
PLY_AKG_CHANNEL3_AFTERNOTEKNOWN ld (PLY_AKG_CHANNEL3_TRACKNOTE+1),a
    rl c
    jr nc,PLY_AKG_CHANNEL3_SAMEINSTRUMENT
    ld a,(hl)
    inc hl
    exx
    ld e,a
    ld d,0
    ld hl,(PLY_AKG_INSTRUMENTSTABLE+1)
    add hl,de
    add hl,de
    ld sp,hl
    pop hl
    ld a,(hl)
    inc hl
    ld (PLY_AKG_CHANNEL3_INSTRUMENTSPEED+1),a
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT+1),hl
    ld (PLY_AKG_CHANNEL3_SAMEINSTRUMENT+1),hl
    exx
PLY_AKG_CHANNEL3_AFTERINSTRUMENT ex de,hl
    xor a
    ld l,a
    ld h,a
    ld (PLY_AKG_CHANNEL3_PITCH+1),hl
    ld (PLY_AKG_CHANNEL3_INSTRUMENTSTEP+2),a
    ld a,183
    ld (PLY_AKG_CHANNEL3_ISPITCH),a
    ex de,hl
    rl c
    jp c,PLY_AKG_CHANNEL3_READEFFECTS
PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER ld (PLY_AKG_CHANNEL3_READTRACK+1),hl
PLY_AKG_CHANNEL3_READCELLEND
PLY_AKG_CURRENTSPEED ld a,0
PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS ld (PLY_AKG_TICKDECREASINGCOUNTER+1),a
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER equ $+2
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL ld hl,0
    ld a,h
    ld (PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME+1),a
    ld de,0
PLY_AKG_CHANNEL1_PITCH ld hl,0
PLY_AKG_CHANNEL1_ISPITCH or a
    jr nc,PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL1_PITCHTRACK ld bc,0
    or a
PLY_AKG_CHANNEL1_PITCHTRACKADDORSBC_16BITS nop
    add hl,bc
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALCOUNTER ld a,0
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALVALUE equ $+1
PLY_AKG_CHANNEL1_PITCHTRACKDECIMALINSTR add a,0
    ld (PLY_AKG_CHANNEL1_PITCHTRACKDECIMALCOUNTER+1),a
    jr nc,PLY_AKG_CHANNEL1_PITCHNOCARRY
PLY_AKG_CHANNEL1_PITCHTRACKINTEGERADDORSUB inc hl
PLY_AKG_CHANNEL1_PITCHNOCARRY ld (PLY_AKG_CHANNEL1_PITCH+1),hl
PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL1_AFTERARPEGGIOPITCHVARIABLES
PLY_AKG_CHANNEL1_PITCH_END add hl,de
    ld (PLY_AKG_CHANNEL1_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS+1),hl
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER equ $+2
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL ld hl,0
    ld a,h
    ld (PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME+1),a
    ld de,0
PLY_AKG_CHANNEL2_PITCH ld hl,0
PLY_AKG_CHANNEL2_ISPITCH or a
    jr nc,PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL2_PITCHTRACK ld bc,0
    or a
PLY_AKG_CHANNEL2_PITCHTRACKADDORSBC_16BITS nop
    add hl,bc
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALCOUNTER ld a,0
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALVALUE equ $+1
PLY_AKG_CHANNEL2_PITCHTRACKDECIMALINSTR add a,0
    ld (PLY_AKG_CHANNEL2_PITCHTRACKDECIMALCOUNTER+1),a
    jr nc,PLY_AKG_CHANNEL2_PITCHNOCARRY
PLY_AKG_CHANNEL2_PITCHTRACKINTEGERADDORSUB inc hl
PLY_AKG_CHANNEL2_PITCHNOCARRY ld (PLY_AKG_CHANNEL2_PITCH+1),hl
PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL2_AFTERARPEGGIOPITCHVARIABLES
PLY_AKG_CHANNEL2_PITCH_END add hl,de
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS+1),hl
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER equ $+2
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL ld hl,0
    ld a,h
    ld (PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME+1),a
    ld de,0
PLY_AKG_CHANNEL3_PITCH ld hl,0
PLY_AKG_CHANNEL3_ISPITCH or a
    jr nc,PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL3_PITCHTRACK ld bc,0
    or a
PLY_AKG_CHANNEL3_PITCHTRACKADDORSBC_16BITS nop
    add hl,bc
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALCOUNTER ld a,0
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALVALUE equ $+1
PLY_AKG_CHANNEL3_PITCHTRACKDECIMALINSTR add a,0
    ld (PLY_AKG_CHANNEL3_PITCHTRACKDECIMALCOUNTER+1),a
    jr nc,PLY_AKG_CHANNEL3_PITCHNOCARRY
PLY_AKG_CHANNEL3_PITCHTRACKINTEGERADDORSUB inc hl
PLY_AKG_CHANNEL3_PITCHNOCARRY ld (PLY_AKG_CHANNEL3_PITCH+1),hl
PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL3_AFTERARPEGGIOPITCHVARIABLES
PLY_AKG_CHANNEL3_PITCH_END add hl,de
    ld (PLY_AKG_CHANNEL3_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS+1),hl
    ld sp,(PLY_AKG_SAVESP+1)
PLY_AKG_CHANNEL1_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH ld hl,0
PLY_AKG_CHANNEL1_TRACKNOTE ld de,0
    exx
PLY_AKG_CHANNEL1_INSTRUMENTSTEP ld iyl,0
PLY_AKG_CHANNEL1_PTINSTRUMENT ld hl,0
PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME ld de,57359
    call PLY_AKG_READINSTRUMENTCELL
    ld a,iyl
    inc a
PLY_AKG_CHANNEL1_INSTRUMENTSPEED cp 0
    jr c,PLY_AKG_CHANNEL1_SETINSTRUMENTSTEP
    ld (PLY_AKG_CHANNEL1_PTINSTRUMENT+1),hl
    xor a
PLY_AKG_CHANNEL1_SETINSTRUMENTSTEP ld (PLY_AKG_CHANNEL1_INSTRUMENTSTEP+2),a
    ld a,e
    ld (PLY_AKG_PSGREG8),a
    srl d
    exx
    ld (PLY_AKG_PSGREG01_INSTR+1),hl
PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL2_GENERATEDCURRENTPITCH ld hl,0
PLY_AKG_CHANNEL2_TRACKNOTE ld de,0
    exx
PLY_AKG_CHANNEL2_INSTRUMENTSTEP ld iyl,0
PLY_AKG_CHANNEL2_PTINSTRUMENT ld hl,0
PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME ld e,15
    nop
    call PLY_AKG_READINSTRUMENTCELL
    ld a,iyl
    inc a
PLY_AKG_CHANNEL2_INSTRUMENTSPEED cp 0
    jr c,PLY_AKG_CHANNEL2_SETINSTRUMENTSTEP
    ld (PLY_AKG_CHANNEL2_PTINSTRUMENT+1),hl
    xor a
PLY_AKG_CHANNEL2_SETINSTRUMENTSTEP ld (PLY_AKG_CHANNEL2_INSTRUMENTSTEP+2),a
    ld a,e
    ld (PLY_AKG_PSGREG9),a
    scf
    rr d
    exx
    ld (PLY_AKG_PSGREG23_INSTR+1),hl
PLY_AKG_CHANNEL3_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL3_GENERATEDCURRENTPITCH ld hl,0
PLY_AKG_CHANNEL3_TRACKNOTE ld de,0
    exx
PLY_AKG_CHANNEL3_INSTRUMENTSTEP ld iyl,0
PLY_AKG_CHANNEL3_PTINSTRUMENT ld hl,0
PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME ld e,15
    nop
    call PLY_AKG_READINSTRUMENTCELL
    ld a,iyl
    inc a
PLY_AKG_CHANNEL3_INSTRUMENTSPEED cp 0
    jr c,PLY_AKG_CHANNEL3_SETINSTRUMENTSTEP
    ld (PLY_AKG_CHANNEL3_PTINSTRUMENT+1),hl
    xor a
PLY_AKG_CHANNEL3_SETINSTRUMENTSTEP ld (PLY_AKG_CHANNEL3_INSTRUMENTSTEP+2),a
    ld a,e
    ld (PLY_AKG_PSGREG10),a
    ld a,d
    exx
    ld (PLY_AKG_PSGREG45_INSTR+1),hl
PLY_AKG_SENDPSGREGISTERS ld b,a
    ld a,7
    out (160),a
    ld a,b
    out (161),a
PLY_AKG_PSGREG01_INSTR ld hl,0
    xor a
    out (160),a
    ld a,l
    out (161),a
    ld a,1
    out (160),a
    ld a,h
    out (161),a
PLY_AKG_PSGREG23_INSTR ld hl,0
    ld a,2
    out (160),a
    ld a,l
    out (161),a
    ld a,3
    out (160),a
    ld a,h
    out (161),a
PLY_AKG_PSGREG45_INSTR ld hl,0
    ld a,4
    out (160),a
    ld a,l
    out (161),a
    ld a,5
    out (160),a
    ld a,h
    out (161),a
PLY_AKG_PSGREG6 equ $+1
PLY_AKG_PSGREG8 equ $+2
PLY_AKG_PSGREG6_8_INSTR ld hl,0
    ld a,6
    out (160),a
    ld a,l
    out (161),a
    ld a,8
    out (160),a
    ld a,h
    out (161),a
PLY_AKG_PSGREG9 equ $+1
PLY_AKG_PSGREG10 equ $+2
PLY_AKG_PSGREG9_10_INSTR ld hl,0
    ld a,9
    out (160),a
    ld a,l
    out (161),a
    ld a,10
    out (160),a
    ld a,h
    out (161),a
PLY_AKG_SAVESP ld sp,0
    ret 
PLY_AKG_CHANNEL1_MAYBEEFFECTS ld (PLY_AKG_SPEEDTRACK_END+1),a
    bit 6,c
    jp z,PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_READEFFECTS ld iy,PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
    ld ix,PLY_AKG_CHANNEL1_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
    ld de,PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
    jr PLY_AKG_CHANNEL3_READEFFECTSEND
PLY_AKG_CHANNEL1_READEFFECTSEND
PLY_AKG_CHANNEL2_MAYBEEFFECTS ld (PLY_AKG_CHANNEL1_READCELLEND+1),a
    bit 6,c
    jp z,PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_READEFFECTS ld iy,PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
    ld ix,PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
    ld de,PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
    jr PLY_AKG_CHANNEL3_READEFFECTSEND
PLY_AKG_CHANNEL2_READEFFECTSEND
PLY_AKG_CHANNEL3_MAYBEEFFECTS ld (PLY_AKG_CHANNEL2_READCELLEND+1),a
    bit 6,c
    jp z,PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_READEFFECTS ld iy,PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS
    ld ix,PLY_AKG_CHANNEL3_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
    ld de,PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_READEFFECTSEND
PLY_AKG_CHANNEL_READEFFECTS ld (PLY_AKG_CHANNEL_READEFFECTS_ENDJUMP+1),de
    ex de,hl
    ld a,(de)
    inc de
    sla a
    jr c,PLY_AKG_CHANNEL_READEFFECTS_RELATIVEADDRESS
    exx
    ld l,a
    ld h,0
PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS1 ld de,0
    add hl,de
    ld e,(hl)
    inc hl
    ld d,(hl)
PLY_AKG_CHANNEL_RE_EFFECTADDRESSKNOWN ld a,(de)
    inc de
    ld (PLY_AKG_CHANNEL_RE_EFFECTRETURN+1),a
    and 254
    ld l,a
    ld h,0
    ld sp,PLY_AKG_EFFECTTABLE
    add hl,sp
    ld sp,hl
    ret 
PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_CHANNEL_RE_READNEXTEFFECTINBLOCK ld a,0
    rra 
    jr c,PLY_AKG_CHANNEL_RE_EFFECTADDRESSKNOWN
    exx
    ex de,hl
PLY_AKG_CHANNEL_READEFFECTS_ENDJUMP jp 0
PLY_AKG_CHANNEL_READEFFECTS_RELATIVEADDRESS srl a
    exx
    ld h,a
    exx
    ld a,(de)
    inc de
    exx
    ld l,a
PLY_AKG_CHANNEL_READEFFECTS_EFFECTBLOCKS2 ld de,0
    add hl,de
    jr PLY_AKG_CHANNEL_RE_EFFECTADDRESSKNOWN
PLY_AKG_READINSTRUMENTCELL ld a,(hl)
    inc hl
    ld b,a
    rra 
    jp c,PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP
    rra 
    jr c,PLY_AKG_STH_OR_ENDWITHOUTLOOP
    rra 
PLY_AKG_NOSOFTNOHARD and 15
    sub e
    jr nc,PLY_AKG_NOSOFTNOHARD+6
    xor a
    ld e,a
    rl b
    jr nc,PLY_AKG_NSNH_NONOISE
    ld a,(hl)
    inc hl
    ld (PLY_AKG_PSGREG6),a
    set 2,d
    res 5,d
    ret 
PLY_AKG_NSNH_NONOISE
    set 2,d
    ret 
PLY_AKG_SOFT and 15
    sub e
    jr nc,PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON-1
    xor a
    ld e,a
PLY_AKG_SOFTONLY_HARDONLY_TESTSIMPLE_COMMON rl b
    jr nc,PLY_AKG_S_NOTSIMPLE
    ld c,0
    jr PLY_AKG_S_AFTERSIMPLETEST
PLY_AKG_S_NOTSIMPLE ld b,(hl)
    ld c,b
    inc hl
PLY_AKG_S_AFTERSIMPLETEST call PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD
    ld a,c
    and 31
    ret z
    ld (PLY_AKG_PSGREG6),a
    res 5,d
    ret 
PLY_AKG_ENDWITHOUTLOOP
PLY_AKG_EMPTYINSTRUMENTDATAPT ld hl,0
    inc hl
    xor a
    ld b,a
    jr PLY_AKG_NOSOFTNOHARD
PLY_AKG_STH_OR_ENDWITHOUTLOOP rra 
    jr PLY_AKG_ENDWITHOUTLOOP
PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP rra 
    jr c,PLY_AKG_H_OR_ENDWITHLOOP
    rra 
    jp nc,PLY_AKG_SOFT
PLY_AKG_H_OR_ENDWITHLOOP
PLY_AKG_ENDWITHLOOP ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp PLY_AKG_READINSTRUMENTCELL
PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD jr nc,PLY_AKG_S_OR_H_NEXTBYTE
    exx
    ex de,hl
    add hl,hl
    ld bc,PLY_AKG_PERIODTABLE
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    add hl,de
    exx
    rl b
    rl b
    rl b
    ret 
PLY_AKG_S_OR_H_NEXTBYTE rl b
    rl b
    jr nc,PLY_AKG_S_OR_H_AFTERARPEGGIO
    ld a,(hl)
    inc hl
    exx
    add a,e
    ld e,a
    exx
PLY_AKG_S_OR_H_AFTERARPEGGIO rl b
    jr nc,PLY_AKG_S_OR_H_AFTERPITCH
    ld a,(hl)
    inc hl
    exx
    add a,l
    ld l,a
    exx
    ld a,(hl)
    inc hl
    exx
    adc a,h
    ld h,a
    exx
PLY_AKG_S_OR_H_AFTERPITCH exx
    ex de,hl
    add hl,hl
    ld bc,PLY_AKG_PERIODTABLE
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    add hl,de
    exx
    ret 
PLY_AKG_EFFECTTABLE dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw PLY_AKG_EFFECT_VOLUME
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw PLY_AKG_EFFECT_PITCHUP
    dw PLY_AKG_EFFECT_PITCHDOWN
    dw PLY_AKG_EFFECT_PITCHSTOP
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
    dw DOOM_E1M1_START
PLY_AKG_EFFECT_VOLUME ld a,(de)
    inc de
    ld (iy-33),a
    jp PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_PITCHDOWN ld (iy-15),0
    ld (iy-14),9
    ld (iy-11),198
    ld (iy-4),35
PLY_AKG_EFFECT_PITCHUPDOWN_COMMON ld (iy-22),55
    ld a,(de)
    inc de
    ld (iy-10),a
    ld a,(de)
    inc de
    ld (iy-18),a
    jp PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_EFFECT_PITCHUP ld (iy-15),237
    ld (iy-14),66
    ld (iy-11),214
    ld (iy-4),43
    jr PLY_AKG_EFFECT_PITCHUPDOWN_COMMON
PLY_AKG_EFFECT_PITCHSTOP ld (iy-22),183
    jp PLY_AKG_CHANNEL_RE_EFFECTRETURN
PLY_AKG_PERIODTABLE dw 6778
    dw 6398
    dw 6039
    dw 5700
    dw 5380
    dw 5078
    dw 4793
    dw 4524
    dw 4270
    dw 4030
    dw 3804
    dw 3591
    dw 3389
    dw 3199
    dw 3019
    dw 2850
    dw 2690
    dw 2539
    dw 2397
    dw 2262
    dw 2135
    dw 2015
    dw 1902
    dw 1795
    dw 1695
    dw 1599
    dw 1510
    dw 1425
    dw 1345
    dw 1270
    dw 1198
    dw 1131
    dw 1068
    dw 1008
    dw 951
    dw 898
    dw 847
    dw 800
    dw 755
    dw 712
    dw 673
    dw 635
    dw 599
    dw 566
    dw 534
    dw 504
    dw 476
    dw 449
    dw 424
    dw 400
    dw 377
    dw 356
    dw 336
    dw 317
    dw 300
    dw 283
    dw 267
    dw 252
    dw 238
    dw 224
    dw 212
    dw 200
    dw 189
    dw 178
    dw 168
    dw 159
    dw 150
    dw 141
    dw 133
    dw 126
    dw 119
    dw 112
    dw 106
    dw 100
    dw 94
    dw 89
    dw 84
    dw 79
    dw 75
    dw 71
    dw 67
    dw 63
    dw 59
    dw 56
    dw 53
    dw 50
    dw 47
    dw 45
    dw 42
    dw 40
    dw 37
    dw 35
    dw 33
    dw 31
    dw 30
    dw 28
    dw 26
    dw 25
    dw 24
    dw 22
    dw 21
    dw 20
    dw 19
    dw 18
    dw 17
    dw 16
    dw 15
    dw 14
    dw 13
    dw 12
    dw 12
    dw 11
    dw 11
    dw 10
    dw 9
    dw 9
    dw 8
    dw 8
    dw 7
    dw 7
    dw 7
    dw 6
    dw 6
    dw 6
    dw 5
    dw 5
    dw 5
    dw 4
