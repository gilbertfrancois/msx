if not defined MSOR

; Warning: must be included before first use!

; Sign OR of two numbers.
;    Input: reg1_hi, reg1_lo, reg2_hi, reg2_lo
;   Output: (BIT 7, A) = reg1_sign or reg2_sign
; Pollutes: AF
;      Use: MSOR H,L,D,E
MSOR MACRO reg1_hi, reg1_lo, reg2_hi, reg2_lo
    if SIGN_BIT > 7
        LD      A, reg1_hi
        OR      reg2_hi             ; sign or sign
    else
        LD      A, reg1_lo
        OR      reg2_lo             ; sign or sign
    endif
ENDM

endif
