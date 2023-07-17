if not defined @FLN

    include "fadd.asm"

; logaritmus naturalis
; Input: HL 
; Output: HL = ln(abs(HL)) +- lowest bit (with exponent -1($3A..$3B) the error is bigger...)
; ln(2^e*m) = ln(2^e) + ln(m) = e*ln(2) + ln(m) = ln2_exp[e] + ln_m[m]
; Pollutes: AF, B, DE
@FLN:
if not defined FLN
; *****************************************
                     FLN                ; *
; *****************************************
endif
    if fix_ln
                                    ;           fixes input errors with exponent equal to -1 
        LD      A, H                ;  1:4       
        AND     $FF - SIGN_MASK     ;  2:7
        XOR     $3A                 ;  2:7
        RR      A                   ;  2:8      RRA unaffected zero flag
        JR      z, FLN_FIX          ;  2:12/7 
    endif
        LD      B, H                ;           save exp
        
        LD      A, H                ;           
        AND     MANT_MASK_HI        ;           HL = abs(HL)
        ADD     A, A                ;
        ADD     A, high LN_M        ;
        LD      H, A                ;           LN_M[]        
        LD      E, (HL)             ;
        INC     H                   ;           hi LN_M[]
        LD      D, (HL)             ;

        LD      A, B                ;           load exp
        AND     EXP_MASK            ;
        CP      BIAS                ;
        JR      z, FLN_NO_ADD       ;
        RRCA                        ;
        LD      H, high LN2_EXP     ;
        LD      L, A                ;           LN2_EXP[]

        LD      A, (HL)             ; 
        INC     L                   ;
        LD      H, (HL)             ;
        LD      L, A                ;
        
        LD      A, D                ;
        OR      E                   ;
        JP      nz, FADD            ;           HL = HL + DE = +-LN2_EXP[] + LN_M[]
        RET                         ;
    if fix_ln 
FLN_FIX:
        ADC     A, high LN_FIX      ;
        LD      H, A                ;
        LD      E, (HL)             ;
        INC     H                   ;
        INC     H                   ;
        LD      D, (HL)             ;
    endif
FLN_NO_ADD:
        EX      DE, HL              ;
        RET                         ;
        
endif
