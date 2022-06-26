    db $FE
    dw FileStart
    dw FileEnd - 1
    dw Main

    ; org statement after the header
    org $c000

CHGMOD      equ $005f
; Function : Switches to given screenmode
; Input    : A  - screen mode
; Registers: All

LDIRVM      equ $005c
; Function : Block transfer from memory to VRAM 
; Input    : BC - blocklength
;            DE - Start address of VRAM
;            HL - Start address of memory
; Registers: All

LDIRMV      equ $0059
; Function : Block transfer from VRAM to memory 
; Input    : BC - blocklength
;            DE - Start address of memory
;            HL - Start address of VRAM
; Registers: All

VDPData     equ $98
VDPControl  equ $99
VramCache   equ $c400

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
