if not defined @FPOW2

; Square of a floating-point number
; In: HL = number to square
; Out: HL = HL * HL
; Pollutes: AF
@FPOW2:
if not defined FPOW2
; *****************************************
                    FPOW2                ; *
; *****************************************
endif
        PUSH    BC              ;  1:11
        PUSH    DE              ;  1:11
        LD      B, H            ;  1:4
        LD      C, L            ;  1:4        
        EX      DE, HL          ;  1:4
        call    FMUL            ;         HL = (DE*BC)
        POP     DE              ;  1:10
        POP     BC              ;  1:10
        RET

    include "fmul.asm"
endif
