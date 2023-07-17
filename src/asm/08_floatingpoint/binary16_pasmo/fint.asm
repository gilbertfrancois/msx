if not defined @FINT

; Round towards zero
; In: HL any floating-point number
; Out: HL same number rounded towards zero
; Pollutes: AF,B
@FINT:
if not defined FINT
; *****************************************
                    FINT                ; *
; *****************************************
endif
        LD      A, H                ;  1:4
        AND     EXP_MASK            ;  2:7
        SUB     BIAS                ;  2:7
        JR      c, FINT_ZERO        ;  2:12/7   Completely fractional

        RRCA                        ;  1:4
        RRCA                        ;  1:4
        SUB     MANT_BITS           ;  2:7      0..16 - 10
        RET     nc                  ;  1:11/5   10..16 = Already integer
        NEG                         ;  2:8      1..9
        
        CP      8                   ;  2:7
        JR      nc, FINT_LO_ZERO    ;  2:12/7
        LD      B, A                ;  1:4      1..7
        LD      A, $FF              ;  2:7
FINT_LOOP:
        ADD     A, A                ;  1:4
        DJNZ    FINT_LOOP           ;  2:12/8
        AND     L                   ;  1:4
        LD      L, A                ;  1:4
        RET                         ;  1:10
FINT_LO_ZERO:                       ;           0..2 Valid bits A = -3..-1
        LD      L, $00              ;  2:7
        RRCA                        ;  1:4
        RET     nc                  ;  1:11/5
        RES     0, H                ;  2:8
        RET                         ;  1:10
FINT_ZERO:
        LD      HL, FPMIN           ;  3:10
        RET                         ;  1:10
        
endif
