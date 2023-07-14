if not defined @FBLD

; Load Byte. Convert unsigned 8-bit integer into floating-point number
;  In:  A = Byte to convert
; Out: DE = floating point representation, zero flag if DE = 0
; Pollutes: AF
@FBLD:
if not defined FBLD
; *****************************************
                    FBLD                ; *
; *****************************************
endif
        FBLD_D EQU BIAS/EXP_PLUS_ONE+8 ;
        LD      D, FBLD_D           ;  2:7
FBLD_X:
        OR      A                   ;  1:4
        JR      z, FBLD_OUT_ZERO    ;  2:12/7   zero converted to positive epsilon
        EX      DE, HL              ;  1:4      save HL
FBLD_LOOP:
        ADD     A, A                ;  1:4
        DEC     H                   ;  1:4
        JR      nc, FBLD_LOOP       ;  2:12/7
        LD      L, A                ;  1:4
        ADD     HL, HL              ;  1:11
        ADD     HL, HL              ;  1:11
        EX      DE, HL              ;  1:4      load HL
        RET                         ;  1:10
FBLD_OUT_ZERO:
        LD      D, A                ;  1:4
        LD      E, A                ;  1:4
        RET                         ;  1:10

endif
