if not defined @FCMPA

; Compare two numbers in absolute value.
;    Input: HL, DE 
;   Output: set flags for abs(HL)-abs(DE)
;           abs(HL) < abs(DE) set carry
;           abs(HL) = abs(DE) set zero
; Pollutes: AF
@FCMPA:
if not defined FCMPA
; *****************************************
                    FCMPA               ; *
; *****************************************
endif

    if SIGN_BIT > 7
        LD      A, H                ;  1:4
        XOR     D                   ;  1:4
        AND     SIGN_MASK           ;  2:7
        XOR     H                   ;  1:4      A = dhhh hhhh
        SUB     D                   ;  1:4
        RET     nz                  ;  1:11/5
        LD      A, L                ;  1:4
    else
        LD      A, H                ;  1:4
        SUB     D                   ;  1:4
        RET     nz                  ;  1:11/5
        LD      A, L                ;  1:4
        XOR     E                   ;  1:4
        AND     SIGN_MASK           ;  2:7
        XOR     L                   ;  1:4      A = elll llll
    endif
        SUB     E                   ;  1:4
        RET                         ;  1:10

endif
