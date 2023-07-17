if not defined MABS

; Warning: must be included before first use!

; Returns the absolute value of a number.
;    Input: reg_hi, reg_lo
;   Output: reg = abs(reg)
; Pollutes: none
;      Use: MABS H,L

MABS MACRO reg_hi, reg_lo
    if SIGN_BIT > 7
        RES     8-SIGN_BIT, reg_hi  ;  2:8      reg = abs(reg)
    else
        RES     SIGN_BIT, reg_lo    ;  2:8      reg = abs(reg)
    endif
ENDM

endif
