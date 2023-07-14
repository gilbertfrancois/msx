ORGADR      equ $c800
CHGET       equ $009f
CHPUT       equ $00A2
CHGMOD      equ $005f
RomSize     equ $4000
LDIRVM      equ $005c
SETWRT      equ $0053
VDPData     equ $98
VDPControl  equ $99

FRAC	    equ 8
FRACV       equ 255
ROUNDV      equ 127

RamStart    equ $C000
heap        equ RamStart + 0
Buf         equ heap + 64
EndBuf      equ Buf + 5

    include "finit.asm"
        
    ; MACROS
    include "mmul2.asm"
    include "mge0.asm"
    include "msor.asm"

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
        include "fsub.asm"
        ; include "fadd.asm"
        ; INCLUDE "fdiv.asm"
        ; INCLUDE "flen.asm"
        ; INCLUDE "frac.asm"
        ; INCLUDE "fsqrt.asm"
        ; INCLUDE "fpow2.asm"
Main:
    
    ; call CHGET

    ; Change to screen 0
    ld a, 0
    call CHGMOD
    ld hl, FP72
    MMUL2 h, l
    ld ($9000), hl
    ld de, FN35
    ld hl, FP72
    MSOR h, l, d, e
    and $80
    ld ($9000), a

    ret

FileEnd:
