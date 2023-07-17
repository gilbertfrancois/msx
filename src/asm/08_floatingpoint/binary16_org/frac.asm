if not defined @FRAC
    
; Fractional part, remainder after division by 1
;  In: HL any floating-point number
; Out: HL fractional part, with sign intact
; Pollutes: AF
@FRAC:
if not defined FRAC
; *****************************************
                    FRAC                ; *
; *****************************************
endif
        LD      A, H                ;  1:4
        AND     EXP_MASK            ;  2:7      delete sign and mantissa
        SUB     BIAS                ;  2:7
        RET     c                   ;  2:11/5   Pure fraction

        PUSH    BC                  ;  1:11
        RRCA                        ;  1:4
        RRCA                        ;  1:4
        LD      B, A                ;  1:4      exp
        LD      C, H                ;  1:4      sign
        JR      z, FRAC_NORMALIZE   ;  2:12/7

        CP      MANT_BITS           ;  2:7      0..16 - 10
        JR      nc, FRAC_ZERO_OUT   ;  2:12/7        

FRAC_NO_ZERO_EXP:                   ;           odmazani mantisy pred plovouci radovou carkou
        ADD     HL, HL              ;  1:11     mantissa << 1
        DJNZ    FRAC_NO_ZERO_EXP    ;  2:13/8   exp--

FRAC_NORMALIZE:
        LD      A, H                ;  1:4
        AND     MANT_MASK_HI        ;  2:7
        LD      H, A                ;  1:4
        OR      L                   ;  1:7
        JR      z, FRAC_MANT_ZERO   ;  2:12/7
                 
        LD      A, MANT_MASK_HI     ;  2:7
FRAC_LOOP:                          ;           normalizace cisla
        DEC     B                   ;  4:1      exp--
        ADD     HL, HL              ;  1:11     mantissa << 1
        CP      H                   ;  1:4
        JR      nc, FRAC_LOOP       ;  2:12/7   0,1,2,3 => again
        
        LD      A, B                ;  1:4      exp/4
        ADD     A, A                ;  1:4      exp/2
        ADD     A, A                ;  1:4      exp
        ADD     A, H                ;  1:4      exp + 1.mantissa
        ADD     A, BIAS-EXP_PLUS_ONE;  2:7 
        XOR     C                   ;  1:4
        AND     $FF - SIGN_MASK     ;  2:7      delete sign
        XOR     C                   ;  1:4 
        LD      H, A                ;  1:4
        POP     BC                  ;  1:10
        RET                         ;  1:10

FRAC_ZERO_OUT:
        LD      L, $00              ;  2:7

FRAC_MANT_ZERO:
        POP     BC                  ;  1:10
        LD      A, C                ;  1:4      sign
        AND     SIGN_MASK           ;  2:7
        LD      H, A                ;  1:4
        RET

endif
