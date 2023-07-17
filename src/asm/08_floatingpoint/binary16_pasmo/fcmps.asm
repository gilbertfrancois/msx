if not defined @FCMPS

; Compare two numbers with the same sign.
;    Input: HL >= 0, DE >= 0
;           HL <  0, DE <  0
;   Output: set flags for HL-DE
;           HL < DE set carry
;           HL = DE set zero
; Pollutes: AF
@FCMPS:
if not defined FCMPS
; *****************************************
                    FCMPS               ; *
; *****************************************
endif

        LD      A, H                ;  1:4
        SUB     D                   ;  1:4
        RET     nz                  ;  1:11/5
        LD      A, L                ;  1:4
        SUB     E                   ;  1:4
        RET                         ;  1:10

endif
