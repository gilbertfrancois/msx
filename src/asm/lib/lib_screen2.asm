; Initialize screen 2. Depends on lib_vdp.asm

CGPTBL2     equ $0000           ; pattern generator table address
NAMTBL2     equ $1800           ; pattern name table address
COLTBL2     equ $2000           ; color table address
ATRTBL2     equ $1b00           ; sprite attribute table address
PATTBL2     equ $3800           ; sprite generator table address

_init_sc2:
    ; Initialize screen 2. This replaces the BIOS call CHGMOD.
    ; - Set the VDP to screen 2 mode.
    ; - Fill the pattern table with 0.
    ; - Fill the color table with FG, BG
    ; - Fill the name table with [0..255], 3 times.
    ; in:  none
    ; out: none
    ; registers: af, bc, de, hl
    ld b, _screen2_end - _screen2
    ld hl, _screen2
_init_sc2_loop:
    ld a, (hl)
    ; Disable interrupts before writing to VDP registers
    di
    out (VDPControl), a
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
    ld de, CGPTBL2
    ld bc, $1800
    call _fillvrm
    ret

_init_color_table:
    ; Fill color table with FG, BG
    ; in: a = FG color
    ; registers: af, bc, de
    ld de, COLTBL2
    ld bc, $1800
    call _fillvrm
    ret

_init_name_table:
    ; Resets the name table 3 times from 0 to 255
    ; in:        none
    ; registers: af, bc, de
    ld de, NAMTBL2
    call _setwrt_de
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


