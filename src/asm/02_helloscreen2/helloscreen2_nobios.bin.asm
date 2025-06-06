ORGADR      equ $c000
VDPData     equ $98
VDPControl  equ $99
CGPTBL      equ $0000           ; pattern generator table address
NAMTBL      equ $1800           ; pattern name table address
COLTBL      equ $2000           ; color table address
ATRTBL      equ $1b00           ; sprite attribute table address
PATTBL      equ $3800           ; sprite generator table address

    ; Place header before the binary_
    org ORGADR - 7
    ; Bin header, 7 bytes
    db $fe
    dw _file_start
    dw _file_end - 1
    dw _main

    org ORGADR

_file_start:
_main:
    
    call _init_sc2
    
    ; Create tile 0 in the pattern table
    ld hl, _pattern
    ld de, CGPTBL + 0
    ld b, 8
    call _ldirvm

    ; Create colors for tile 0 in the color table
    ld hl, _color
    ld de, COLTBL + 0
    ld b, 8
    call _ldirvm

    ; Place tile 0 in the name table at location (1,1)
    ld de, NAMTBL + 1 + 1*32
    call _setwrt
    ld a, $00
    out (VDPData), a

    ; Place tile 0 in the name table at location (2,2)
    ld de, NAMTBL + 2 + 2*32
    call _setwrt
    ld a, $00
    out (VDPData), a

    di
    halt

_init_sc2:
    ; Initialize screen 2. This replaces the BIOS call CHGMOD.
    ; - Set the VDP to screen 2 mode.
    ; - Fill the pattern table with 0.
    ; - Fill the color table with FG, BG
    ; - Fill the name table with [0..255], 3 times.
    ; in:  none
    ; out: none
    ; registers: af, bc, de, hl
    ld c, VdpControl
    ld b, _screen2_end - _screen2
    ld hl, _screen2
_init_sc2_loop:
    ld a, (hl)
    ; Disable interrupts before writing to VDP registers
    di
    out (c), a
    ei
    inc hl
    djnz _init_sc2_loop
    ; Clean the VRAM, or you get garbage on the screen.
    call _init_pattern_table
    call _init_name_table
    ld a, $F4
    call _init_color_table
    ret

_init_pattern_table:
    ; Fill pattern table with 0, empty screen.
    ld a, $00
    ld de, CGPTBL
    ld bc, $1800
    call _fillvrm
    ret

_init_color_table:
    ; Fill color table with FG, BG
    ; in: a = FG color
    ; registers: af, bc, de
    ld de, COLTBL
    ld bc, $1800
    call _fillvrm
    ret

_fillvrm:
    ; Fill vram with a value
    ; in:  a = Data byte
    ;     de = Destination vram address
    ;     bc = Number of bytes to be written
    ;     
    push af
    call _setwrt
_fillvrm_loop:
    pop af
    out (VDPData), a
    push af
    dec bc
    ld a, c
    or b
    jr nz, _fillvrm_loop
    pop af
    ret

_init_name_table:
    ; Resets the name table 3 times from 0 to 255
    ; in:        none
    ; registers: af, bc, de
    ld de, NAMTBL
    call _setwrt
    ld b, 3
_init_name_table_next_b:
    ld a, 0
_init_name_table_next_a:
    out (VDPData), a
    inc a
    jr nz, _init_name_table_next_a
    dec b
    jr nz, _init_name_table_next_b
    ret

_setwrt:
    ; Enable VDP to write.
    ; in       : de = destination vram address
    ; registers: af, de
    ld a, e
    out (VDPControl), a
    ld a, d
    or %01000000                ; set 1 = write mode (0 = read)
    out (VDPControl), a
    ret

_ldirvm:
    ; Copy data to vram. The write block must be smaller than 256 bytes.
    ; in: hl = source ram address
    ;     de = destination vram address
    ;     b = number of bytes
    ; registers: af, bc, de, hl
    call _setwrt
    ld c, VDPData
_ldirvm_loop:
    outi
    jp nz, _ldirvm_loop
    ret

_pattern:
    db %10101010
    db %01010101
    db %10000010
    db %01000001
    db %10000010
    db %01000001
    db %10101010
    db %01010101

_color:
    db $16
    db $19
    db $1b
    db $13
    db $12
    db $15
    db $14
    db $1d

_screen2:
    db %00000010, %10000000
    db %11100000, %10000001
    db %00000110, %10000010
    db %11111111, %10000011
    db %00000011, %10000100
    db %00110110, %10000101
    db %00000111, %10000110
    db %11110100, %10000111
_screen2_end:

_file_end:
