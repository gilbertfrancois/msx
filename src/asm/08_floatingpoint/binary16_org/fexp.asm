if not defined @FEXP

    
    include "fmul.asm"
    include "color_flow_warning.asm"
    
; Natural exponential function
; Input: HL 
; Output: HL = exp(HL)) +- lowest 2 bit
; e^((2^e)*m) = 
; e^((2^e)*(m1+m0.5+m0.25+m0.125+m0.0.0625)) 
; m1 => b1 = 1, m0.5 => b0.5 = 0 or 1, m0.25 => b0.25 = 0 or 1, ...
; e^( b1*  (2^e) + b0.5*  (2^e-1) + b0.25*  (2^e-2) + b0.125*  (2^e-3) + b0.0625*  (2^e-4) + ... ) = 
;     b1*e^(2^e) * b0.5*e^(2^e-1) * b0.25*e^(2^e-2) * b0.125*e^(2^e-3) * b0.0625*e^(2^e-4) * ... 
; Pollutes: AF, BC, DE
@FEXP:
if not defined FEXP
; *****************************************
                    FEXP                ; *
; *****************************************
endif
        LD      A, H                ;
        AND     EXP_MASK            ;
        CP      4*$13               ;
        JR      nc, FEXP_FLOW       ;
        
        LD      A, H                ;  1:4
        AND     $FF - MANT_MASK_HI  ;  2:7      A = seee ee00
        RRCA                        ;  1:4      A = 0see eee0
        LD      E, A                ;  1:4
        INC     E                   ;  1:4      0see eee1
        LD      D, high EXP_TAB     ;  2:7

        LD      A, H                ;  1:4
        AND     MANT_MASK_HI        ;  2:7      AL = 0000 00mm   mmmm mmmm
        RRA                         ;           AL = 0000 000m m mmmm mmmm
        RR      L                   ;           AL = 0000 000m   mmmm mmmm m
        RRA                         ;           AL = m000 0000 m mmmm mmmm
        RR      L                   ;           AL = m000 0000   mmmm mmmm m
        RRA                         ;           AL = mm00 0000   mmmm mmmm, reset carry
        LD      H, L                ;
        LD      L, A                ;           DE = mmmm mmmm   mm00 0000
        
        LD      A, (DE)             ;
        LD      C, A                ;
        DEC     E                   ;
        LD      A, (DE)             ;
        LD      B, A                ;
        DEC     C                   ;
        PUSH    BC                  ;           result
        
FEXP_ZEROBIT:
        JR      z, FEXP_EXIT        ;

FEXP_LOOP:
        DEC     E                   ;  1:4      exp--
        LD      A, (DE)             ;
        LD      C, A                ;
        DEC     C                   ;
        JR      z, FEXP_EXIT        ;
        DEC     E                   ;
        ADC     HL, HL              ;  2:15
        JR      nc, FEXP_ZEROBIT    ;  2:12/7
        
        LD      A, (DE)             ;
        LD      B, A                ;

        EX      (SP), HL            ;  1:19     mantissa <> result
        PUSH    DE                  ;  1:11     index
        EX      DE, HL              ;  1:4
        CALL    FMUL                ;  3:17     HL = BC * DE
        POP     DE                  ;  1:10     index
        EX      (SP), HL            ;  1:19     result <> mantissa

        JP      FEXP_LOOP           ;
        
FEXP_EXIT:
        POP     HL                  ;           result
        RET                         ;
        
FEXP_FLOW:
        LD      A, H                ;
        ADD     A, A                ;           sign out
        JR      c, FEXP_UNDER       ;
FEXP_OVER:                          ;
    if color_flow_warning
        CALL    OVER_COL_WARNING    ;
    endif
    if carry_flow_warning
        SCF                         ;
    endif
        LD      HL, FPMAX           ;
        RET                         ;

FEXP_UNDER:
    if color_flow_warning
        CALL    UNDER_COL_WARNING   ;
    endif    
        LD      HL, FPMIN           ;
        RET                         ;

endif
