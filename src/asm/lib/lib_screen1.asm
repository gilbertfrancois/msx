; Initialize screen 1. Depends on lib_vdp.asm

CGPTBL1     equ $0000           ; pattern generator table address
NAMTBL1     equ $1800           ; pattern name table address
COLTBL1     equ $2000           ; color table address
ATRTBL1     equ $1b00           ; sprite attribute table address
PATTBL1     equ $3800           ; sprite generator table address

_init_sc1:
    ; Initialize screen 1. This replaces the BIOS call CHGMOD.
    ; - Set the VDP to screen 1 mode.
    ; - Fill the pattern table with 0.
    ; - Fill the color table with FG, BG
    ; - Fill the name table with [0..255], 3 times.
    ; in:  none
    ; out: none
    ; registers: af, bc, de, hl
    ld b, _screen1_end - _screen1
    ld hl, _screen1
_init_sc1_loop:
    ld a, (hl)
    ; Disable interrupts before writing to VDP registers
    di
    out (VDPControl), a
    ei
    inc hl
    djnz _init_sc1_loop
    ; Clean the VRAM, or you get garbage on the screen.
    call _init_pattern_table
    call _init_name_table
    ld a, $f4
    call _init_color_table
    ret

_init_pattern_table:
    ; Fill pattern table with 0, empty screen.
    ld a, $2f
    ld de, CGPTBL1
    ld bc, $800
    call _fillvrm
    ret

_init_color_table:
    ; Fill color table with FG, BG
    ; in: a = FG color
    ; registers: af, bc, de
    ld a, $69
    ld de, COLTBL1
    ld bc, $800
    call _fillvrm
    ret

_init_name_table:
    ; Fill color table with FG, BG
    ; in: a = FG color
    ; registers: af, bc, de
    ld a, $20
    ld de, NAMTBL1
    ld bc, $300
    call _fillvrm
    ret

_screen1:
    db %00000000, %10000000
    db %11100000, %10000001
    db %00000110, %10000010
    db %10000000, %10000011
    db %00000000, %10000100
    db %00110110, %10000101
    db %00000111, %10000110
    ; db %00100001, %10000111
    db %11110100, %10000111
_screen1_end:

