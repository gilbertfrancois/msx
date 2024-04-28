ORGADR      equ $100

    org $100
    jp Main
        
FileStart:
Main:
    call InitScreen
    ;1 - Initializes the music.
    ld hl,DOOM_E1M1_START
    xor a     ;The Subsong to play (&gt;=0).
    call PLY_AKG_INIT

    ;2 - Wait for the frame flyback (MSX/Spectrum/Pentagon specific).
Sync:
    ei
    nop
    halt
    di
    call PLY_AKG_PLAY
    jr Sync

InitScreen:
    call _init_sc2
    di
    ld hl, pattern_generator_table_start
    ld de, CGPTBL2
    ld bc, pattern_generator_table_end - pattern_generator_table_start
    call _ldirvm

    ld hl, color_table_start
    ld de, COLTBL2
    ld bc, color_table_end - color_table_start
    call _ldirvm
    ei

    ret

Includes:
    include "doom_e1m1_universal.asm"
    include "lib_screen2.asm"
    include "lib_vdp.asm"
    include "titlescreen.asm"
FileEnd: 
