if not defined @FCMP

    include "fcmps.asm"
    
; Compare two numbers.
;    Input: HL, DE 
;   Output: set flags for HL-DE
;           HL < DE set carry
;           HL = DE set zero
; Pollutes: AF
@FCMP:
if not defined FCMP
; *****************************************
                    FCMP               ; *
; *****************************************
endif

    if SIGN_BIT > 7
        LD      A, H                ;  1:4
        XOR     D                   ;  1:4
        JP      p, FCMPS            ;  3:10

        LD      A, H                ;  1:4
    else
        LD      A, L                ;  1:4
        XOR     E                   ;  1:4
        JP      p, FCMPS            ;  3:10

        LD      A, L                ;  1:4
    endif
        ADD     A, A                ;  1:4
        INC     A                   ;  1:4      reset zero
        RET                         ;  1:10

endif
