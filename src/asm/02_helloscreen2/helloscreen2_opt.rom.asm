; Hello World Screen 2
; Show bitmap tiles, using self written 'copy to VRAM' routines.
;
ORGADR      equ $4000
CHGMOD      equ $005f
VDPData     equ $98
VDPControl  equ $99
RomSize     equ $4000
TilePos     equ 0 * 8

    ; org statement before the header
    org ORGADR
    ; ROM header
    db "AB"
    dw Main
    dw 0, 0, 0, 0, 0, 0


Main:
    ; Change to screen 2
    ld a, 2
    call CHGMOD
     
    ; Copy Pattern0 to VRAM
    ld hl, $0000 + TilePos
    call SetVDPWriteAddress
    ld hl, Pattern0
    ld b, 8
    ld c, VDPData
    call CopyToVRAM
    
    ; Copy Color0 map to VRAM
    ld hl, $2000 + TilePos
    call SetVDPWriteAddress
    ld hl, Color0
    ld b, 8
    ld c, VDPData
    call CopyToVRAM

    ; Place pattern0 to (x,y)=(2, 1)
    ld hl, $1800 + 1 + 1*32
    call SetVDPWriteAddress
    ld a, $00
    out (VDPData), a
    
    ; Place pattern0 to (x,y)=(4, 2)
    ld hl, $1800 + 2 + 2*32
    call SetVDPWriteAddress
    ld a, $00
    out (VDPData), a
    
    di
    halt


CopyToVRAM:
    ; Don't use otir on MSX1
    ; See http://map.grauw.nl/articles/vdp_tut.php#vramtiming
    outi
    jp nz, CopyToVRAM
    ret

SetVDPWriteAddress:
    ld a, l
    out (VDPControl), a
    ld a, h
    or %01000000
    out (VDPControl), a
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


ProgEnd:
    ds $4000 + RomSize - ProgEnd, 255


