if not defined @FWST

    include "color_flow_warning.asm"
    
; Store Word. Convert absolute value of a floating-point number into unsigned 16-bit integer.
;  In: HL = floating point to convert
; Out: HL = Word representation, set carry if overflow
; Pollutes: AF, B
@FWST:
if not defined FWST
; *****************************************
                    FWST                ; *
; *****************************************
endif        
        LD      A, H                ;  1:4
        LD      B, H                ;  1:4
        AND     MANT_MASK_HI        ;  2:7
        OR      IMPBIT_MASK         ;  2:7
        LD      H, A                ;  1:4
        LD      A, B                ;  1:4        
        AND     EXP_MASK            ;  2:7
        
        CP      BIAS+16*EXP_PLUS_ONE;  2:7
        JR      nc, FWST_OVERFLOW   ;  2:7/12

        SUB     BIAS-EXP_PLUS_ONE   ;  2:7
        JR      c, FWST_ZERO        ;  2:7/12
        
        RRCA                        ;  1:4
        RRCA                        ;  1:4
    
        SUB     $0B                 ;  2:7
        JR      nc, FWST_1024PLUS   ;  2:7

        DEC     HL                  ;  1:6          rounding ( 0.5000 down => 0.4999 down )
        NEG                         ;  2:8
        LD      B, A                ;  1:4
    if 0
        SUB     $08                 ;  2:7
        JR      c, $+8              ;  2:12/7
        LD      B, A                ;  1:4
        ADD     HL, HL              ;  1:11         rounding
        LD      L, H                ;  1:4
        LD      H, $00              ;  2:7
        INC     B                   ;  1:4        
    endif
        SRL     H                   ;  2:8
        RR      L                   ;  2:8
        DJNZ    $-4                 ;  2:13/8       1..7
        
        RET     nc                  ;  1:11/5
        INC     HL                  ;  1:6
    if carry_flow_warning
        OR      A                   ;  1:4
    endif
        RET                         ;  1:10
    
FWST_1024PLUS:
        RET     z                   ;  1:5/11
        LD      B, A                ;  1:4
        ADD     HL, HL              ;  1:11
        DJNZ    $-1                 ;  2:13/8
        RET                         ;  1:10
                
FWST_OVERFLOW:
    if color_flow_warning
        CALL    OVER_COL_WARNING    ;  3:17
    endif
        LD      HL, $FFFF           ;  3:10
    if carry_flow_warning
        SCF                         ;  1:4
    endif
        RET                         ;  1:10     RET with carry

FWST_ZERO:
    if carry_flow_warning
        XOR     A                   ;  1:4
        LD      H, A                ;  1:4
        LD      L, A                ;  1:4        
    else
        LD      HL, $0000           ;  3:10    
    endif
        RET                         ;  1:10     RET with carry
        
        

endif
