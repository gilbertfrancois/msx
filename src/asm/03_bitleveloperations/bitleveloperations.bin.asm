ORGADR      equ $c000
CHGMOD      equ $005f
LDIRVM      equ $005c
LDIRMV      equ $0059
VDPData     equ $98
VDPControl  equ $99
VramCache   equ $c400

    ; Place header before the binary.
    org ORGADR - 7
    ; Bin header, 7 bytes
    db $fe
    dw FileStart
    dw FileEnd - 1
    dw Main

    ; org statement after the header
    org ORGADR

FileStart:
Main:
    ; Go to screen 1
    ld a, 1
    call CHGMOD

    ; Make a copy of the pattern table in RAM.
    ld hl, $0000
    ld de, VramCache
    ld bc, $0800
    call LDIRMV

    ;============================================================ 
    ld hl, VramCache  ; Start of the cache in RAM
    ld bc, $0800      ; Block size: 256 characters * 8 byte
Again:
    ld a, (hl)
    ; uncomment one of the 3 lines below to see the effect
    ; and %1111000
    ; or %11110000
    xor %11110000
    ld (hl), a
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, Again
    ;============================================================ 

    ; Copy to the pattern table in VRAM
    ld hl, VramCache
    ld de, $0000
    ld bc, $0800
    call LDIRVM
    
    ret

FileEnd:
