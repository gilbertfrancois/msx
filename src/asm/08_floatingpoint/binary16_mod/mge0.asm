    ifndef MGE0

; Warning: must be included before first use!

; Set zero if the number is positive. Beware of negative zero.
; if (number >= 0) set zero; else reset zero;
;    Input: reg_hi, reg_lo
;   Output: zero flag if floating-point number is positive
; Pollutes: F
;      Use: MGE0 H,L

    macro MGE0, reg_hi, reg_lo
    if SIGN_BIT > 7
        bit SIGN_BIT - 8, \reg_hi;  2:8
    else
        bit SIGN_BIT, \reg_lo    ;  2:8
    endif
    endm
    endif
