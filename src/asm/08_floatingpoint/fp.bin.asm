ORGADR      equ $c800
CHGET       equ $009f
CHPUT       equ $00A2
CHGMOD      equ $005f
RomSize     equ $4000
LDIRVM      equ $005c
SETWRT      equ $0053
VDPData     equ $98
VDPControl  equ $99

FRAC        equ 8
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
    
    ; calc Xmin, Xmax
    ld hl, (SizeWidth)
    ld de, FP2 
    call _f16_div_hl_de
    ld de, (Xc)
    ex de, hl
    call _f16_sub_hl_de
    ld (Xmin), hl
    ld de, (SizeWidth)
    call _f16_add_hl_de
    ld (Xmax), hl
    ; ld hl, (Xmin)
    ; ld ($9000), hl
    ; ld hl, (Xmax)
    ; ld ($9002), hl

    ; calc Ymin, Ymax
    ld hl, (SizeHeight)
    ld de, FP2 
    call _f16_div_hl_de
    ld de, (Yc)
    ex de, hl
    call _f16_sub_hl_de
    ld (Ymin), hl
    ld de, (SizeHeight)
    call _f16_add_hl_de
    ld (Ymax), hl
    ld hl, (Ymin)
    ld ($9000), hl
    ld hl, (Ymax)
    ld ($9002), hl

    ret

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

    ; ld hl, &4248
    ; call _f16_int_hl

    ; call _f16_from_int_dehl

    ; ld hl, &0001
    ; call _f16_from_int_dehl
    ; ld ($9000), hl

    ; ld hl, &0002
    ; call _f16_from_int_dehl
    ; ld ($9002), hl

    ; ld hl, &0072
    ; call _f16_from_int_dehl
    ; ld ($9004), hl



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
    ld (zx), hl
; 550 Y=0
    ld (zy), hl
; 560 FOR D=0 TO DE-1
    ld b, $0f
FunctionZLoop:
    push bc
; 570 XN=X*X-Y*Y+CX
    ld hl, (zx)
    call _f16_pow2_hl    ; X*X
    ld (znx), hl          ; Xn := X*X
    ld hl, (zy)
    call _f16_pow2_hl    ; Y*Y 
    ld de, (znx)
    call _f16_sub_hl_de  ; X*X - Y*Y
    ld de, (cx)
    call _f16_add_hl_de  ; X*X - Y*Y + Cx
    ld (znx), hl          ; Xn := X*X - Y*Y + Cx
; 580 YN=2*X*Y+CY
    ld hl, FP2           ; 2
    ld de, (zx)           ; X
    call _f16_mul_hl_de  ; 2*X
    ld de, (zy)           ; Y
    call _f16_mul_hl_de  ; 2*X*Y
    ld de, (cy)
    call _f16_add_hl_de  ; 2*X*Y + Cy
    ld (zny), hl          ; Yn := 2*X*Y + Cy
; 590 IF (XN*XN+YN*YN) > 4 THEN RETURN
    ld hl, (znx)
    call _f16_pow2_hl    ; XN*XN
    ld d, h
    ld e, l
    ld hl, (zny)
    call _f16_pow2_hl    ; YN*YN
    call _f16_add_hl_de  ; XN*XN + YN*YN
    ld de, FP4           ; 4
    call _f16_gt_hl_de   ; (XN*XN + YN*YN) > 4 
    ld a, l
    jr nz, FunctionZEnd
; 600 X=XN
    ld hl, (znx)
    ld (zx), hl
; 610 Y=YN
    ld hl, (zny)
    ld (zy), hl
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
SizeWidth:
    db $00, $42
SizeHeight:
    db $00, $40
Xmin: 
    db $00, $00
Xmax:
    db $00, $00
Ymin: 
    db $00, $00
Ymax: 
    db $00, $00

Stride:
    db $00
ColorMode:
    db $00 

; VARIABLES
zx: 
    db $00, $00
zy:
    db $00, $00
znx:
    db $00, $00
zny:
    db $00, $00
cx: 
    db $00, $3c ; 1
cy:
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
