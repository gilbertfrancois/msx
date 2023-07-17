if not defined MNEG

;  Warning: must be included before first use!

; Returns the absolute value of a number.
;    Input: reg_hi, reg_lo
;   Output: reg = -reg
; Pollutes: AF (keep all registers: SLA reg ; 2:8
;                                   CCF     ; 1:4
;                                   RR reg  ; 2:8 )
;      Use: MNEG H,L

MNEG MACRO reg_hi, reg_lo
    if SIGN_BIT > 7
        LD      A, reg_hi           ;  1:4
        XOR     SIGN_MASK           ;  2:7
        LD      reg_hi, A           ;  1:4      reg = -reg
    else
        LD      A, reg_lo           ;  1:4
        XOR     SIGN_MASK           ;  2:7
        LD      reg_lo, A           ;  1:4      reg = -reg
    endif
ENDM

endif
