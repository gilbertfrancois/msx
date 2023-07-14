    ifndef MSOR

; Warning: must be included before first use!

; Sign OR of two numbers.
;    Input: reg1_hi, reg1_lo, reg2_hi, reg2_lo
;   Output: (BIT 7, A) = reg1_sign or reg2_sign
; Pollutes: AF
;      Use: MSOR H,L,D,E
    macro MSOR, reg1_hi, reg1_lo, reg2_hi, reg2_lo
    if SIGN_BIT > 7
        ld      a, \reg1_hi
        or      \reg2_hi             ; sign or sign
    else
        ld      a, \reg1_lo
        or      \reg2_lo             ; sign or sign
    endif
    endm
    endif
