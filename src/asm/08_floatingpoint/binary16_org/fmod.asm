if not defined @FMOD

    include "color_flow_warning.asm"
    
; Remainder after division.
;  In: BC dividend, HL modulus
; Out: HL remainder, HL = BC % HL       
; BC % HL = BC - int(BC/HL) * HL = frac(BC/HL) * HL  => does not return correct results with larger exponent difference
; Pollutes: AF, BC, DE

@FMOD:
if not defined FMOD
; *****************************************
                    FMOD                ; *
; *****************************************
endif        
        include "mcmpa.asm"
        MCMPA   H, L, B, C          ;           flag: abs(HL) - abs(BC)
        JP      c, FMOD_BC_GR       ;  3:10
        
        LD      H, B                ;  1:4
        LD      L, C                ;  1:4
        RET     nz                  ;  1:11/5
        LD      L, A                ;  1:4
        LD      A, B                ;  1:4
        AND     SIGN_MASK           ;  2:7
        LD      H, A                ;  1:4
        RET                         ;  1:11/5   FPMIN or FMMIN   

FMOD_BC_GR:
        LD      D, B                ;
        LD      E, C                ;           HL = DE % HL

        LD      A, H                ;
        AND     EXP_MASK            ;  2:7
        LD      B, A                ;

        LD      A, D                ;
        AND     EXP_MASK            ;  2:7
        SUB     B                   ;
        LD      C, A                ;           C = ( D_Exp - H_exp )

        LD      A, D                ;
        SUB     C                   ;  1:4
        AND     $FF - MANT_MASK_HI  ;  2:7
        LD      B, A                ;  1:4      B = D_sign + H_exp

        ADD     HL, HL              ;  1:11
        ADD     HL, HL              ;  1:11
        ADD     HL, HL              ;  1:11
        ADD     HL, HL              ;  1:11
        ADD     HL, HL              ;  1:11
        SET     7, H                ;  2:8      HL = 0 1mmm mmmm mmm0 0000

        EX      DE, HL              ;  1:4      HL = HL % DE

        XOR     A                   ;  1:4
        RR      H                   ;  2:8
        RR      L                   ;  2:8
        RRA                         ;  1:4
        RR      H                   ;  2:8
        RR      L                   ;  2:8
        RRA                         ;  1:4
        LD      H, L                ;  1:4
        LD      L, A                ;  1:4      HL = 1 mmmm mmmm mm00 0000

        LD      A, C                ;
        LD      C, EXP_PLUS_ONE     ;  2:7
        OR      A                   ;
        JP      z, FMOD_SAME_EXP    ;
FMOD_SUB:                           ;           HL - DE
        SBC     HL, DE              ;  2:15     HL = HL - DE/2
        JR      nc, FMOD_SUB        ;  3:10

FMOD_SHIFT_HL:
        SUB     C                   ;  1:4      exp--
        ADD     HL, HL              ;  1:11
        JP      nc, FMOD_SHIFT_HL   ;  3:10
        
        OR      A                   ;
        JR      z, FMOD_SAME_EXP    ;  2:7/12
        JP      p, FMOD_SUB         ;
        
        ADD     A, B                ;
        XOR     B                   ;
        JP      m, FMOD_UNDERFLOW   ;
        XOR     B                   ;
        LD      B, A                ;

FMOD_NORM:                          ;           HL = mmmm mmmm mmm0 0000
        XOR     A                   ;  1:4
        ADD     HL, HL              ;  1:11     HL = mmmm mmmm mm00 0000
        ADC     A, A                ;  1:4       A = 0000 000m
        ADD     HL, HL              ;  1:11     HL = mmmm mmmm m000 0000
        ADC     A, A                ;  1:4       A = 0000 00mm
        OR      B                   ;  1:4      RET with reset carry
        LD      L, H                ;  1:4
        LD      H, A                ;  1:4
        RET                         ;  1:10

FMOD_SAME_EXP:
        SLA     E                   ;  2:8
        RL      D                   ;  2:8      DE = 1mmm mmmm mmm0 0000
        OR      A                   ;  1:4
        SBC     HL, DE              ;  2:15
        RET     z                   ;           FPMIN

        JR      nc, FMOD_SHIFT_HL   ;
        
        ADD     HL, DE              ;
        JR      FMOD_NORM

FMOD_UNDERFLOW:
        LD      A, B                ;
        AND     SIGN_MASK           ;
        LD      H, A                ;
        LD      L, $00              ;
    if color_flow_warning
        CALL    UNDER_COL_WARNING   ;  3:17
    endif
    if carry_flow_warning
        SCF                         ;  1:4      carry = error
    endif        
        RET                         ;

endif
