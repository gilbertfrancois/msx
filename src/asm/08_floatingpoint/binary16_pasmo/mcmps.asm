if not defined MCMPS

; Warning: must be included before first use!

; Compare two numbers with the same sign.
;    Input: reg1_hi, reg1_lo, reg2_hi, reg2_lo
;   Output: set flags for reg1-reg2
; Pollutes: AF
;      Use: MCMPS H,L,D,E

MCMPS MACRO reg1_hi, reg1_lo, reg2_hi, reg2_lo
        LD      A, reg1_hi          ;  1:4
        SUB     reg2_hi             ;  1:4
    if 0
        JP      nz, $+5             ;  3:10
    else
        JR      nz, $+4             ;  2:12/7
    endif
        LD      A, reg1_lo          ;  1:4
        SUB     reg2_lo             ;  1:4
ENDM

endif
