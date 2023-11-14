ORGADR      equ $c000
CHGET       equ $009f
CHPUT       equ $00A2
CHGMOD      equ $005f
LDIRVM      equ $005c
SETWRT      equ $0053
VDPData     equ $98
VDPControl  equ $99

FRAC        equ 8
FRACV       equ 255
ROUNDV      equ 127

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
    call Init
    call LoopX
    call NewLn
    ret 

LoopX:
    ld a, (x)
    ld l, a
    ld h, 0
    call FunctionTx
    ld (cx), hl
    ld a, (y)
    ld l, a
    ld h, 0
    call FunctionTy
    ld (cy), hl
    ; call FunctionZ
        ld hl, (Depth)
        inc hl
        ld (Depth), hl
        call PrintPixel
    ld a, (x)
    inc a
    ld (x), a
    cp 32
    jp nz, LoopX
        ; ld hl, stry
        ; call PrintStr
    ld a, 0
    ld (x), a
    ld a, (y)
    inc a
    ld (y), a
    cp 22
    jp nz, LoopX
    ret


    
Init:
    ; calc cx_min, cx_max
    ld hl, (SizeWidth)
    ld de, FP2 
    call _f16_div_hl_de
    ld de, (cx_center)
    ex de, hl
    call _f16_sub_hl_de
    ld (cx_min), hl
    ld de, (SizeWidth)
    call _f16_add_hl_de
    ld (cx_max), hl
    ; calc cy_min, cy_max
    ld hl, (SizeHeight)
    ld de, FP2 
    call _f16_div_hl_de
    ld de, (cy_center)
    ex de, hl
    call _f16_sub_hl_de
    ld (cy_min), hl
    ld de, (SizeHeight)
    call _f16_add_hl_de
    ld (cy_max), hl
    ret

FunctionTx:
;  in: hl <- x (display coordinate)
; out: hl <- cx 
; 370 DEF FN TX(DX)=(DX/255)*SI*1.5+X0
    call _f16_from_int_dehl
    ld de, FP31
    ex de, hl
    call _f16_div_hl_de
    ld de, (SizeWidth)
    call _f16_mul_hl_de
    ld de, cx_min
    call _f16_add_hl_de
    ret

FunctionTy:
;  in: hl <- y (display coordinate)
; out: hl <- cy
    call _f16_from_int_dehl
    ld de, FP23
    ex de, hl
    call _f16_div_hl_de
    ld de, (SizeHeight)
    call _f16_mul_hl_de
    ld de, cy_min
    call _f16_add_hl_de
    ret


FunctionZ:
; 650 ZX=0
    ld hl, 0
    ld (zx), hl
; 660 ZY=0
    ld (zy), hl
; 670 FOR D=0 TO DE-1
    ld b, $0f
FunctionZLoop:
    push bc
; 680 ZU=ZX*ZX-ZY*ZY+CX
    ld hl, (zy)          ; hl <- zy
    call _f16_pow2_hl    ; hl <- zy^2
    push hl              ; st <- zy^2
    ld hl, (zx)          ; hl <- zx
    call _f16_pow2_hl    ; hl <- zx^2
    pop de               ; de <- zy^2 
    call _f16_sub_hl_de  ; hl <- zx^2 - zy^2
    ld de, (cx)          ; de <- cx
    call _f16_add_hl_de  ; hl <- zx^2 - zy^2 + cx
    ld (zu), hl          ; zu <- zx^2 - zy^2 + cx
; 690 ZV=2*ZX*ZY+CY
    ld hl, FP2           ; hl <- 2
    ld de, (zx)          ; de <- zx
    call _f16_mul_hl_de  ; hl <- 2*zx
    ld de, (zy)          ; de <- zy
    call _f16_mul_hl_de  ; hl <- 2*zx*zy
    ld de, (cy)          ; de <- cy
    call _f16_add_hl_de  ; hl <- 2*zx*zy + cy
    ld (zv), hl          ; zv <- 2*zx*zy + cy
; 700 IF (ZU*ZU+ZV*ZV) > 4 THEN RETURN
    ld hl, (zu)          ; hl <- zu
    call _f16_pow2_hl    ; hl <- zu^2
    ex de, hl            ; de <- zu^2
    ld hl, (zv)          ; hl <- zv
    call _f16_pow2_hl    ; hl <- zv^2
    call _f16_add_hl_de  ; hl <- zu^2 + zv^2
    ld de, FP4           ; de <- 4
    call _f16_gt_hl_de   ; hl <- zu^2 + zv^2 > 4
    ld a, l              ; if a!=0 then 
    jr nz, FunctionZEnd
; 600 X=XN
    ld hl, (zu)
    ld (zx), hl
; 610 Y=YN
    ld hl, (zv)
    ld (zy), hl
; 620 NEXT D
    ld a, (Depth)
    inc a
    ld (Depth), a
    pop bc
    djnz FunctionZLoop
FunctionZEnd:
    ret

PrintPixel:
; 400 IF CM=0 THEN CP = D MOD 2 ELSE IF D>=DE THEN CP = 1 ELSE CP = 0
    ld a, (Depth)
    and 1
    cp 0
    jp nz, PrintPixelOdd
    jp z, PrintPixelEven
PrintPixelOdd:
    ld hl, strOne
    call PrintStr
    ret
PrintPixelEven:
    ld hl, strZero
    call PrintStr
    ret

_f16_pow2_hl:
    push de
    ld d, h
    ld e, l
    call _f16_mul_hl_de
    pop de
    ret

PrintStr:
    ld a, (hl)
    cp 0
    ret z
    inc hl
    call CHPUT
    jr PrintStr

NewLn:
    push af
    ld a, 13
    call CHPUT
    ld a, 10
    call CHPUT
    pop af
    ret

    include "f16_lib.asm"

; CONSTANTS
cx_center:
    db $00, $b8
cy_center:
    db $0d, $b9
cx_min: 
    db $00, $00
cx_max:
    db $00, $00
cy_min: 
    db $00, $00
cy_max: 
    db $00, $00
SizeWidth:
    db $00, $42  ; 3
SizeHeight:
    db $00, $40  ; 2


; VARIABLES
x: 
    db $00
y: 
    db $00
cx: 
    db $00, $00
cy:
    db $00, $00
zx: 
    db $00, $00
zy:
    db $00, $00
zu:
    db $00, $00
zv:
    db $00, $00
Depth:
    db $00
DepthMax:
    db $0f

Pattern:
    db $01, $02, $03, $04
    db $10, $20, $30, $40
Color:
    db $4f, $4f, $4f, $4f
    db $4f, $4f, $4f, $4f
      
strOne:
    db "a", 0
strZero:
    db "b", 0


FileEnd:
