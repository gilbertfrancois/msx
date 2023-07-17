if not defined MCMPA

; Warning: must be included before first use!

; Compare two numbers in absolute value.
;    Input: reg1_hi, reg1_lo, reg2_hi, reg2_lo
;   Output: set flags for abs(reg1)-abs(reg2)
; Pollutes: AF
;      Use: MCMPA B,C,D,E   ; flags for abs(BC)-abs(DE)

MCMPA MACRO reg1_hi, reg1_lo, reg2_hi, reg2_lo

    if SIGN_BIT > 7
        LD      A, reg1_hi          ;  1:4
        XOR     reg2_hi             ;  1:4
        AND     SIGN_MASK           ;  2:7
        XOR     reg1_hi             ;  1:4      A = 2111 1111
        SUB     reg2_hi             ;  1:4
    if 0
        JP      nz, $+5             ;  3:10    
    else
        JR      nz, $+4             ;  2:12/7
    endif
        LD      A, reg1_lo          ;  1:4
    else
        LD      A, reg1_hi          ;  1:4
        SUB     reg2_hi             ;  1:4
    if 0
        JP      nz, $+9             ;  3:10
    else
        JR      nz, $+8             ;  2:12/7
    endif
        LD      A, reg1_lo          ;  1:4
        XOR     reg2_lo             ;  1:4
        AND     SIGN_MASK           ;  2:7
        XOR     reg1_lo             ;  1:4      A = 2111 1111
    endif
        SUB     reg2_lo             ;  1:4
ENDM

endif
