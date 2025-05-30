; Subtract two floating-point numbers
;  In: HL, DE numbers to subtract, no restrictions
; Out: HL = HL - DE
; Pollutes: AF, B, DE
; *****************************************
FSUB:
; *****************************************
    if SIGN_BIT = $0F
        LD      A, D                ;  1:4
        XOR     SIGN_MASK           ;  2:7
        LD      D, A                ;  1:4      DE = -DE
    endif
    if SIGN_BIT = $07
        LD      A, E                ;  1:4
        XOR     SIGN_MASK           ;  2:7
        LD      E, A                ;  1:4      DE = -DE
    endif
    if SIGN_BIT != $07 && SIGN_BIT != $0F
        .err Unexpected value in SIGN_BIT!
    endif
