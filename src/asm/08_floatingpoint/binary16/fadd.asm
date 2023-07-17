    ; continue from _FSUB (if it was included)
        
; Add two floating-point numbers
;  In: HL, DE numbers to add, no restrictions
; Out: HL = HL + DE
; Pollutes: AF, B, DE
; *****************************************
FADD:
; *****************************************
    if SIGN_BIT = $0F
        LD      A, H                ;  1:4
        XOR     D                   ;  1:4
        JP      m, FSUBP_FADD_OP_SGN;  3:10
    endif
    if SIGN_BIT = $07
        LD      A, L                ;  1:4
        XOR     E                   ;  1:4
        JP      m, FSUBP_FADD_OP_SGN;  3:10
    endif
    if SIGN_BIT != $07 && SIGN_BIT != $0F
        .ERROR Unexpected value in SIGN_BIT!
    endif
