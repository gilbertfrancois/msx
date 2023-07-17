    ifndef MMUL2

; Warning: must be included before first use!

; Multiply the number by two by increasing the exponent.
;    Input: reg_hi, reg_lo
;   Output: number *= 2
; Pollutes: none ( danagy, bfloat)
;           AF ( binary16, keep all registers:  INC reg_hi ; 1:4
;                                               INC reg_hi ; 1:4
;                                               INC reg_hi ; 1:4
;                                               INC reg_hi ; 1:4 )
;      Use: MMUL2 H,L

    macro MMUL2, reg_hi, reg_lo
    if EXP_PLUS_ONE > 1
        ld a, \reg_hi
        add a, EXP_PLUS_ONE
        ; .WARNING EXP muze pretect!
        ld \reg_hi, a
    else
        inc \reg_hi
        ; .WARNING EXP muze pretect!
    endif
    endm

    endif
