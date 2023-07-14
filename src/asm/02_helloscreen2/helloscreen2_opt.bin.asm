; Hello World Screen 2
; Show bitmap tiles, using BIOS functions.
; 
ORGADR      equ $c800
CHGMOD      equ $005f
LDIRVM      equ $005c
SETWRT      equ $0053
VDPData     equ $98
VDPControl  equ $99
RomSize     equ $4000
TilePos     equ 0 * 8
CHGET	    equ $009f

    ; Place header before the binary.
    org ORGADR - 7
    ; Bin header, 7 bytes
    db $fe
    dw FileStart
    dw FileEnd - 1
    dw Main

FileStart:
Main:
    ; Change to screen 2
    ld a, 2
    call CHGMOD

    ; Copy Pattern0 to VRAM
    ld hl, Pattern0
    ld de, $0000 + TilePos
    ld bc, $0008
    call LDIRVM

    ; Copy Color0 map to VRAM
    ld hl, Color0
    ld de, $2000 + TilePos
    ld bc, $0008
    call LDIRVM

    ; Place pattern0 to (x,y)=(2, 1)
    ld hl, $1800 + 1 + 1*32
    call SETWRT
    ld a, $00
    out (VDPData), a

    ; Place pattern0 to (x,y)=(4, 2)
    ld hl, $1800 + 2 + 2*32
    call SETWRT
    ld a, $00
    out (VDPData), a

    call CHGET

    ; Change to screen 0
    ld a, 0
    call CHGMOD

    ret


Pattern0:
    db %10101010
    db %01010101
    db %10000010
    db %01000001
    db %10000010
    db %01000001
    db %10101010
    db %01010101

Color0:
    db $16
    db $19
    db $1b
    db $13
    db $12
    db $15
    db $14
    db $1d

FileEnd:
