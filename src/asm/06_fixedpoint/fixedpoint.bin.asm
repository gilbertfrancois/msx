ORGADR	    equ $c800
CHGET	    equ $009f
CHPUT	    equ $00A2
CHGMOD	    equ $005f
RomSize     equ $4000
LDIRVM      equ $005c
SETWRT      equ $0053
VDPData     equ $98
VDPControl  equ $99

FRAC	    equ 8
FRACV	    equ 255
ROUNDV	    equ 127

RamStart    equ $C000
heap        equ RamStart + 0
Buf         equ heap + 64
EndBuf      equ Buf + 5

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
    
    ; call CHGET

    ; Change to screen 0
    ld a, 0
    call CHGMOD

    ; add
    ld hl, 768       ; 3.0
    ld de, 36        ; 0.140625
    call Add16
    ld ($9000), hl

    ; multiply
    ld hl, 804 ; 3.14159
    call ShiftRight4
    ld b, h
    ld c, l
    ld hl, 362 ; 1.4142
    call ShiftRight4
    ld d, h
    ld e, l
    call Mult16
    ld ($9002), hl ; 4.4428

    ld hl, $4248
    ld ($9004), hl

    ret
    
    include "test.asm"

; T-Cycles: 64
; Bytes: 16
; Trashed: None
ShiftRight4:
    SRL H
    RR L
    SRL H
    RR L
    SRL H
    RR L
    SRL H
    RR L
    ret

ShiftRight4Fast:
    LD A, L
    SRL H
    RRA
    SRL H
    RRA
    SRL H
    RRA
    SRL H
    RRA
    LD L, A
    ret

; Multiply 16-bit values (with 16-bit result)
; In: Multiply BC with DE
; Out: HL = result
;
Mult16:
    ld a,b
    ld b,16
Mult16_Loop:
    add hl,hl
    sla c
    rla
    jr nc,Mult16_NoAdd
    add hl,de
Mult16_NoAdd:
    djnz Mult16_Loop
    ret

;
; Divide 16-bit values (with 16-bit result)
; In: Divide BC by divider DE
; Out: BC = result, HL = rest
;
Div16:
    ld hl,0
    ld a,b
    ld b,8
Div16_Loop1:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd1
    add hl,de
Div16_NoAdd1:
    djnz Div16_Loop1
    rla
    cpl
    ld b,a
    ld a,c
    ld c,b
    ld b,8
Div16_Loop2:
    rla
    adc hl,hl
    sbc hl,de
    jr nc,Div16_NoAdd2
    add hl,de
Div16_NoAdd2:
    djnz Div16_Loop2
    rla
    cpl
    ld b,c
    ld c,a
    ret

Int2Fixed:
    ld h, l
    ld l, 0
    ret


Fixed2Int:
    ld bc, 127
    add hl, bc
    ld l, h
    ld h, 0
    ret

Lut:
    dw $0000, $0008, $0010, $0018, $0020, $0028, $0030, $0038, $0040, $0048, $0050, $0058, $0060, $0068, $0070, $0078
    
varX:
    db 01, 02, 03, 04

FileEnd:

