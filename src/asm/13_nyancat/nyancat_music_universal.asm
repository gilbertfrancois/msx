_NYANCAT_MUSIC_START
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
    dw _NYANCAT_MUSIC_ARPEGGIOTABLE
    dw _NYANCAT_MUSIC_ARPEGGIOTABLE
PLY_AKG_OPCODE_ADD_HL_BC_LSB equ $+1
    dw _NYANCAT_MUSIC_ARPEGGIOTABLE
    dw _NYANCAT_MUSIC_EFFECTBLOCKTABLE
    dw _NYANCAT_MUSIC_EFFECTBLOCKTABLE
_NYANCAT_MUSIC_ARPEGGIOTABLE
_NYANCAT_MUSIC_PITCHTABLE
_NYANCAT_MUSIC_INSTRUMENTTABLE dw _NYANCAT_MUSIC_EMPTYINSTRUMENT
    dw _NYANCAT_MUSIC_INSTRUMENT1
    dw _NYANCAT_MUSIC_INSTRUMENT2
    dw _NYANCAT_MUSIC_INSTRUMENT3
    dw _NYANCAT_MUSIC_INSTRUMENT4
    dw _NYANCAT_MUSIC_INSTRUMENT5
_NYANCAT_MUSIC_EMPTYINSTRUMENT db 0
_NYANCAT_MUSIC_EMPTYINSTRUMENT_LOOP db 0
    db 6
_NYANCAT_MUSIC_INSTRUMENT1 db 1
    db 241
    db 121
    db 32
    db 1
    db 0
PLY_AKG_OPCODE_INC_HL db 105
    db 32
    db 255
    db 255
    db 97
    db 32
    db 1
    db 0
PLY_AKG_OPCODE_DEC_HL db 89
    db 32
    db 255
    db 255
    db 81
    db 32
    db 1
    db 0
    db 73
    db 32
    db 255
    db 255
PLY_AKG_OPCODE_SCF db 65
    db 32
    db 1
    db 0
    db 57
    db 32
    db 255
    db 255
    db 49
    db 32
    db 1
PLY_AKG_OPCODE_SBC_HL_BC_LSB db 0
    db 41
    db 32
    db 255
    db 255
    db 33
    db 32
    db 1
    db 0
    db 25
    db 32
    db 255
    db 255
    db 17
    db 32
    db 1
    db 0
    db 9
    db 32
    db 255
    db 255
    db 6
_NYANCAT_MUSIC_INSTRUMENT2 db 1
_NYANCAT_MUSIC_INSTRUMENT2_LOOP db 34
    db 131
    db 7
    dw _NYANCAT_MUSIC_INSTRUMENT2_LOOP
_NYANCAT_MUSIC_INSTRUMENT3 db 1
    db 121
    db 1
    db 121
    db 64
    db 4
    db 249
    db 113
    db 64
    db 252
    db 113
    db 64
    db 248
    db 105
    db 64
    db 248
    db 97
    db 64
    db 244
    db 6
_NYANCAT_MUSIC_INSTRUMENT4 db 1
    db 121
    db 128
    db 221
    db 13
    db 241
    db 232
    db 10
    db 192
    db 10
    db 184
    db 10
    db 168
    db 10
    db 152
    db 10
    db 144
    db 7
    db 144
    db 4
    db 136
    db 2
    db 136
    db 1
    db 0
    db 0
    db 0
    db 6
_NYANCAT_MUSIC_INSTRUMENT5 db 1
    db 248
    db 1
    db 232
    db 1
    db 216
    db 1
    db 192
    db 1
    db 168
    db 1
    db 6
_NYANCAT_MUSIC_EFFECTBLOCKTABLE
_NYANCAT_MUSIC_SUBSONG0_START db 2
    db 0
    db 1
    db 2
    db 17
    db 6
    db 21
_NYANCAT_MUSIC_SUBSONG0_LINKER dw _NYANCAT_MUSIC_SUBSONG0_TRACK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK1
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK2
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK3
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK1
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK4
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
_NYANCAT_MUSIC_SUBSONG0_LINKER_LOOP dw _NYANCAT_MUSIC_SUBSONG0_TRACK5
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK7
PLY_AKG_OPCODE_OR_A dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK8
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK11
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
PLY_AKG_OPCODE_ADD_A_IMMEDIATE equ $+1
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK7
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK12
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK20
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK5
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
PLY_AKG_OPCODE_SUB_IMMEDIATE equ $+1
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK7
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK8
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK11
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK7
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK13
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
PLY_AKG_OPCODE_SBC_HL_BC_MSB dw _NYANCAT_MUSIC_SUBSONG0_TRACK19
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK14
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK15
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK16
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK17
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK20
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK14
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK15
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK16
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK6
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK10
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK18
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK9
    dw _NYANCAT_MUSIC_SUBSONG0_TRACK19
    dw _NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0
    db 0
    db 0
    dw _NYANCAT_MUSIC_SUBSONG0_LINKER_LOOP
_NYANCAT_MUSIC_SUBSONG0_LINKERBLOCK0 db 16
    db 0
    db 0
    db 0
    dw _NYANCAT_MUSIC_SUBSONG0_SPEEDTRACK0
    dw _NYANCAT_MUSIC_SUBSONG0_EVENTTRACK0
_NYANCAT_MUSIC_SUBSONG0_TRACK0 db 170
    db 1
    db 43
    db 45
    db 60
    db 50
    db 60
    db 42
    db 43
    db 45
    db 50
    db 54
    db 55
    db 54
    db 49
    db 50
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK1 db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK2 db 156
    db 4
    db 126
    db 28
    db 126
    db 131
    db 3
    db 126
    db 156
    db 4
    db 131
    db 3
    db 3
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK3 db 173
    db 1
    db 60
    db 42
    db 43
    db 45
    db 60
    db 50
    db 60
    db 52
    db 49
    db 50
    db 52
    db 55
    db 54
    db 55
    db 54
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK4 db 131
    db 3
    db 126
    db 156
    db 4
    db 126
    db 28
    db 126
    db 28
    db 60
    db 28
    db 28
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK5 db 173
    db 1
    db 60
    db 47
    db 60
    db 40
    db 42
    db 60
    db 40
    db 41
    db 40
    db 38
    db 60
    db 38
    db 60
    db 40
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK6 db 135
    db 2
    db 60
    db 19
    db 60
    db 9
    db 60
    db 21
    db 60
    db 6
    db 60
    db 18
    db 60
    db 11
    db 60
    db 23
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK7 db 131
    db 3
    db 60
    db 179
    db 5
    db 60
    db 156
    db 4
    db 60
    db 179
    db 5
    db 60
    db 131
    db 3
    db 60
    db 179
    db 5
    db 60
    db 156
    db 4
    db 60
    db 179
    db 5
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK8 db 169
    db 1
    db 60
    db 41
    db 40
    db 38
    db 40
    db 42
    db 45
    db 47
    db 42
    db 45
    db 40
    db 42
    db 38
    db 40
    db 38
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK9 db 132
    db 2
    db 60
    db 16
    db 60
    db 9
    db 60
    db 21
    db 60
    db 2
    db 60
    db 14
    db 60
    db 4
    db 60
    db 16
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK10 db 131
    db 3
    db 60
    db 179
    db 5
    db 60
    db 156
    db 4
    db 60
    db 179
    db 5
    db 60
    db 131
    db 3
    db 60
    db 3
    db 60
    db 156
    db 4
    db 60
    db 179
    db 5
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK11 db 170
    db 1
    db 60
    db 45
    db 60
    db 47
    db 42
    db 45
    db 40
    db 42
    db 38
    db 40
    db 42
    db 41
    db 40
    db 38
    db 40
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK12 db 169
    db 1
    db 60
    db 38
    db 40
    db 42
    db 45
    db 40
    db 41
    db 40
    db 38
    db 40
    db 60
    db 38
    db 60
    db 40
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK13 db 169
    db 1
    db 60
    db 38
    db 40
    db 42
    db 45
    db 40
    db 41
    db 40
    db 38
    db 40
    db 60
    db 38
    db 60
    db 38
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK14 db 166
    db 1
    db 60
    db 33
    db 35
    db 38
    db 60
    db 33
    db 35
    db 38
    db 40
    db 42
    db 38
    db 43
    db 42
    db 43
    db 45
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK15 db 166
    db 1
    db 60
    db 38
    db 60
    db 33
    db 35
    db 38
    db 35
    db 43
    db 42
    db 40
    db 38
    db 31
    db 30
    db 31
    db 33
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK16 db 166
    db 1
    db 60
    db 33
    db 35
    db 38
    db 60
    db 33
    db 35
    db 38
    db 38
    db 40
    db 42
    db 38
    db 33
    db 35
    db 33
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK17 db 166
    db 1
    db 60
    db 38
    db 37
    db 38
    db 33
    db 35
    db 38
    db 43
    db 42
    db 43
    db 45
    db 38
    db 60
    db 37
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK18 db 166
    db 1
    db 60
    db 38
    db 37
    db 38
    db 33
    db 35
    db 38
    db 43
    db 42
    db 43
    db 45
    db 38
    db 60
    db 40
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK19 db 131
    db 3
    db 60
    db 179
    db 5
    db 60
    db 156
    db 4
    db 60
    db 179
    db 5
    db 60
    db 131
    db 3
    db 60
    db 3
    db 60
    db 156
    db 4
    db 60
    db 28
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_TRACK20 db 131
    db 3
    db 60
    db 179
    db 5
    db 60
    db 156
    db 4
    db 60
    db 179
    db 5
    db 60
    db 131
    db 3
    db 60
    db 3
    db 60
    db 156
    db 4
    db 60
    db 28
    db 28
    db 61
    db 127
_NYANCAT_MUSIC_SUBSONG0_SPEEDTRACK0 db 10
    db 253
_NYANCAT_MUSIC_SUBSONG0_EVENTTRACK0 db 255
PLY_AKG_START jp PLY_AKG_INIT
    jp PLY_AKG_PLAY
    jp PLY_AKG_INITTABLE1_END
PLY_AKG_INIT ld de,8
    add hl,de
    ld de,PLY_AKG_INSTRUMENTSTABLE+1
    ldi
    ldi
    inc hl
    inc hl
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
    ld bc,1792
    call PLY_AKG_INIT_READWORDSANDFILL
    inc c
    ld hl,PLY_AKG_INITTABLE0_END
    ld b,3
    call PLY_AKG_INIT_READWORDSANDFILL
    ld hl,PLY_AKG_INITTABLE1_END
    ld bc,439
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
PLY_AKG_INITTABLE0_END
PLY_AKG_INITTABLE1 dw PLY_AKG_PATTERNDECREASINGHEIGHT+1
    dw PLY_AKG_TICKDECREASINGCOUNTER+1
PLY_AKG_INITTABLE1_END
PLY_AKG_INITTABLEORA
PLY_AKG_INITTABLEORA_END
PLY_AKG_STOP ld (PLY_AKG_PSGREG13_END+1),sp
    xor a
    ld l,a
    ld h,a
    ld (PLY_AKG_PSGREG8),a
    ld (PLY_AKG_PSGREG9),hl
    ld a,191
    jp PLY_AKG_SENDPSGREGISTERS
PLY_AKG_PLAY ld (PLY_AKG_PSGREG13_END+1),sp
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
    ld (PLY_AKG_CHANNEL1_INSTRUMENTSTEP+2),a
    ex de,hl
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
    ld (PLY_AKG_CHANNEL2_INSTRUMENTSTEP+2),a
    ex de,hl
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
    ld (PLY_AKG_CHANNEL3_INSTRUMENTSTEP+2),a
    ex de,hl
PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER ld (PLY_AKG_CHANNEL3_READTRACK+1),hl
PLY_AKG_CHANNEL3_READCELLEND
PLY_AKG_CURRENTSPEED ld a,0
PLY_AKG_SETSPEEDBEFOREPLAYSTREAMS ld (PLY_AKG_TICKDECREASINGCOUNTER+1),a
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGER equ $+2
PLY_AKG_CHANNEL1_INVERTEDVOLUMEINTEGERANDDECIMAL ld hl,0
    ld a,h
    ld (PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME+1),a
    ld de,0
    ld hl,0
PLY_AKG_CHANNEL1_SOUNDSTREAM_RELATIVEMODIFIERADDRESS add hl,de
    ld (PLY_AKG_CHANNEL1_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS+1),hl
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGER equ $+2
PLY_AKG_CHANNEL2_INVERTEDVOLUMEINTEGERANDDECIMAL ld hl,0
    ld a,h
    ld (PLY_AKG_CHANNEL2_GENERATEDCURRENTINVERTEDVOLUME+1),a
    ld de,0
    ld hl,0
PLY_AKG_CHANNEL2_SOUNDSTREAM_RELATIVEMODIFIERADDRESS add hl,de
    ld (PLY_AKG_CHANNEL2_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS+1),hl
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGER equ $+2
PLY_AKG_CHANNEL3_INVERTEDVOLUMEINTEGERANDDECIMAL ld hl,0
    ld a,h
    ld (PLY_AKG_CHANNEL3_GENERATEDCURRENTINVERTEDVOLUME+1),a
    ld de,0
    ld hl,0
PLY_AKG_CHANNEL3_SOUNDSTREAM_RELATIVEMODIFIERADDRESS add hl,de
    ld (PLY_AKG_CHANNEL3_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS+1),hl
    ld sp,(PLY_AKG_PSGREG13_END+1)
PLY_AKG_CHANNEL1_PLAYINSTRUMENT_RELATIVEMODIFIERADDRESS
PLY_AKG_CHANNEL1_GENERATEDCURRENTPITCH ld hl,0
PLY_AKG_CHANNEL1_TRACKNOTE ld de,0
    exx
PLY_AKG_CHANNEL1_INSTRUMENTSTEP ld iyl,0
PLY_AKG_CHANNEL1_PTINSTRUMENT ld hl,0
PLY_AKG_CHANNEL1_GENERATEDCURRENTINVERTEDVOLUME ld de,57359
    call PLY_AKG_CHANNEL3_READEFFECTSEND
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
    call PLY_AKG_CHANNEL3_READEFFECTSEND
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
    call PLY_AKG_CHANNEL3_READEFFECTSEND
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
PLY_AKG_PSGHARDWAREPERIOD_INSTR ld hl,0
    ld a,11
    out (160),a
    ld a,l
    out (161),a
    ld a,12
    out (160),a
    ld a,h
    out (161),a
    ld a,13
    out (160),a
PLY_AKG_PSGREG13_INSTR ld a,0
PLY_AKG_PSGREG13_OLDVALUE cp 255
    jr z,PLY_AKG_PSGREG13_END
    ld (PLY_AKG_PSGREG13_OLDVALUE+1),a
    out (161),a
PLY_AKG_PSGREG13_END
PLY_AKG_SAVESP ld sp,0
    ret 
PLY_AKG_CHANNEL1_MAYBEEFFECTS ld (PLY_AKG_SPEEDTRACK_END+1),a
    jp PLY_AKG_CHANNEL1_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL1_READEFFECTSEND
PLY_AKG_CHANNEL2_MAYBEEFFECTS ld (PLY_AKG_CHANNEL1_READCELLEND+1),a
    jp PLY_AKG_CHANNEL2_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL2_READEFFECTSEND
PLY_AKG_CHANNEL3_MAYBEEFFECTS ld (PLY_AKG_CHANNEL2_READCELLEND+1),a
    jp PLY_AKG_CHANNEL3_BEFOREEND_STORECELLPOINTER
PLY_AKG_CHANNEL3_READEFFECTSEND
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
    jr c,PLY_AKG_ENDWITHOUTLOOP
    call PLY_AKG_STOH_HTOS_SANDH_COMMON
    ld (PLY_AKG_SH_JUMPRATIO+1),a
    exx
    ld e,l
    ld d,h
PLY_AKG_SH_JUMPRATIO jr PLY_AKG_SH_JUMPRATIO+2
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    jr nc,PLY_AKG_SH_JUMPRATIOEND
    inc hl
PLY_AKG_SH_JUMPRATIOEND ld (PLY_AKG_PSGHARDWAREPERIOD_INSTR+1),hl
    ex de,hl
    exx
    ret 
PLY_AKG_S_OR_H_OR_SAH_OR_ENDWITHLOOP rra 
    jr c,PLY_AKG_H_OR_ENDWITHLOOP
    rra 
    jp nc,PLY_AKG_SOFT
PLY_AKG_H_OR_ENDWITHLOOP
PLY_AKG_ENDWITHLOOP ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jp PLY_AKG_CHANNEL3_READEFFECTSEND
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
    jr c,PLY_AKG_S_OR_H_FORCEDPERIOD
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
PLY_AKG_S_OR_H_FORCEDPERIOD ld a,(hl)
    inc hl
    exx
    ld l,a
    exx
    ld a,(hl)
    inc hl
    exx
    ld h,a
    exx
    rl b
    rl b
    ret 
PLY_AKG_STOH_HTOS_SANDH_COMMON ld e,16
    rra 
    and 7
    add a,8
    ld (PLY_AKG_PSGREG13_INSTR+1),a
    rl b
    ld c,(hl)
    ld b,c
    inc hl
    rl b
    call PLY_AKG_S_OR_H_CHECKIFSIMPLEFIRST_CALCULATEPERIOD
    ld a,c
    rla 
    rla 
    and 28
    ret 
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
