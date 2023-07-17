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

carry_flow_warning equ 0
color_flow_warning equ 0

    include "finit.asm"
        
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

; for ty=0 to 24
; for tx=0 to 32

; for yy=0 to 7
; for xx=0 to 7

; compute T(Xd -> Zx)
; compute T(Yd -> Zy)
; compute Zx -> Depth
; compute pixel state
; set pixel in memory

; next xx
; next yy

; next tx
; next ty

    ; ld a, 2
    ; call CHGMOD
    ; ld b, 255

    ; ; Copy Pattern0 to VRAM
    ; ld hl, Pattern
    ; ld de, $0000
    ; ld bc, 8
    ; call LDIRVM

    ; ; Copy Color0 map to VRAM
    ; ld hl, Color
    ; ld de, $2000
    ; ld bc, $0008
    ; call LDIRVM

    ; call CHGET
    ; ret


    ld hl, 25
    ld de, 21
    call _f16_from_int_dehl
    ld ($9000), hl

    ld hl, $4248 ; Pi
    call _f16_int_hl
    ld ($9002), hl
    
    ret

    ; Change to screen 0
    ; ld a, 0
    ; call CHGMOD
    ; ld hl, $4248 ; 72
    ; ld de, $4500 ; 128
    ; call _f16_mul_hl_de
    ; ld ($9000), hl
    call FunctionZ
    ld hl, (X)
    ld ($9000), hl
    ret


FunctionTx:
; In:  HL: Xd
; Out: HL: Cx
; Cx = (255-Xd) / 255 
    



FunctionZ:
; 540 X=0
; 550 Y=0
; 560 FOR D=0 TO DE-1
; 570 XN=X*X-Y*Y+CX
; 580 YN=2*X*Y+CY
; 590 IF (XN*XN+YN*YN) > 4 THEN RETURN
; 600 X=XN
; 610 Y=YN
; 620 NEXT D
; 540 X=0
    ld hl, 0
    ld (X), hl
; 550 Y=0
    ld (Y), hl
; 560 FOR D=0 TO DE-1
    ld b, $0f
FunctionZLoop:
    push bc
; 570 XN=X*X-Y*Y+CX
    ld hl, (X)
    call _f16_pow2_hl    ; X*X
    ld (Xn), hl          ; Xn := X*X
    ld hl, (Y)
    call _f16_pow2_hl    ; Y*Y 
    ld de, (Xn)
    call _f16_sub_hl_de  ; X*X - Y*Y
    ld de, (Cx)
    call _f16_add_hl_de  ; X*X - Y*Y + Cx
    ld (Xn), hl          ; Xn := X*X - Y*Y + Cx
; 580 YN=2*X*Y+CY
    ld hl, FP2           ; 2
    ld de, (X)           ; X
    call _f16_mul_hl_de  ; 2*X
    ld de, (Y)           ; Y
    call _f16_mul_hl_de  ; 2*X*Y
    ld de, (Cy)
    call _f16_add_hl_de  ; 2*X*Y + Cy
    ld (Yn), hl          ; Yn := 2*X*Y + Cy
; 590 IF (XN*XN+YN*YN) > 4 THEN RETURN
    ld hl, (Xn)
    call _f16_pow2_hl    ; XN*XN
    ld d, h
    ld e, l
    ld hl, (Yn)
    call _f16_pow2_hl    ; YN*YN
    call _f16_add_hl_de  ; XN*XN + YN*YN
    ld de, FP4           ; 4
    call _f16_gt_hl_de   ; (XN*XN + YN*YN) > 4 
    ld a, l
    jr nz, FunctionZEnd
; 600 X=XN
    ld hl, (Xn)
    ld (X), hl
; 610 Y=YN
    ld hl, (Yn)
    ld (Y), hl
; 620 NEXT D
    ld a, (Depth)
    inc a
    ld (Depth), a
    pop bc
    djnz FunctionZLoop
FunctionZEnd:
    ret

GetPixelState:
; 400 IF CM=0 THEN CP = D MOD 2 ELSE IF D>=DE THEN CP = 1 ELSE CP = 0
    ld a, (Depth)
    and 1
    ret



; CONSTANTS
Xc:
    db $00, $b8
Yc:
    db $0d, $b9
Size:
    db $00, $40
Stride:
    db $00
ColorMode:
    db $00 

; VARIABLES
X: 
    db $00, $00
Y:
    db $00, $00
Xn:
    db $00, $00
Yn:
    db $00, $00
Cx: 
    db $00, $3c ; 1
Cy:
    db $00, $40 ; 2
Depth:
    db $00
DepthMax:
    db $0f

Pattern:
    db $01, $02, $03, $04, $05
    db $10, $20, $30, $40, $50
Color:
    db $4f
    db $4f
    db $4f
    db $4f
    db $4f
    db $4f
    db $4f
    db $4f
      
    include "f16_lib.asm"

_f16_pow2_hl:
    push de
    ld d, h
    ld e, l
    call _f16_mul_hl_de
    pop de
    ret

FileEnd:
