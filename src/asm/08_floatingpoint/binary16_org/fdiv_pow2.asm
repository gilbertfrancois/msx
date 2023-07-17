if not defined @FDIV_POW2

include "color_flow_warning.asm"

;  Input:  BC, HL with a mantissa equal to 1.0 (seee ee00 0000 0000)
; Output: HL = BC / HL = BC / (1.0 * 2^HL_exp) = BC * 1.0 * 2^-HL_exp, if ( overflow or underflow ) set carry
; Pollutes: AF, BC, DE

; if ( 1.m = 1.0 ) => 1/(2^x * 1.0) = 1/2^x * 1/1.0 = 2^-x * 1.0    
; New_sign = BC_sign ^ HL_sign
; New_exp  = (BC_exp - BIAS) + ( BIAS - HL_exp ) + BIAS = BIAS + BC_exp - HL_exp
; New_mant = BC_mant * 1.0 = BC_mant
@FDIV_POW2:
if not defined FDIV_POW2
; *****************************************
                 FDIV_POW2              ; *
; *****************************************
endif

        LD      A, H                ;  1:4
        AND     EXP_MASK            ;  2:7      HL_exp
        LD      L, A                ;  1:4

        XOR     H                   ;  1:4      HL_sign
        XOR     B                   ;  1:4
        AND     SIGN_MASK           ;  2:7
        LD      H, A                ;  1:4      New_sign
        
        LD      A, B                ;  1:4
        AND     EXP_MASK            ;  2:7      BC_exp
        ADD     A, BIAS             ;  2:7
        SUB     L                   ;  1:4      0eee ee00
        
        JR      c, FDIV_POW2_UNDER  ;  2:12/7
        JP      m, FDIV_POW2_OVER   ;  3:10
        
        OR      H                   ;  1:4      seee ee00
        XOR     B                   ;  1:4
        AND     $FF - MANT_MASK_HI  ;  2:7
        XOR     B                   ;  1:4      seee eemm
        LD      H, A                ;  1:4
        LD      L, C                ;  1:4
        RET                         ;  1:10

;  Input: H xor B = sign
; Output: HL = +- zero
; Uses FDIV function
FDIV_UNDERFLOW:
        LD      A, H                ;  1:4
        XOR     B                   ;  1:4
        AND     SIGN_MASK           ;  2:7
        LD      H, A                ;  1:4

FDIV_POW2_UNDER:
        LD      L, $00              ;  2:7
    if color_flow_warning
        CALL    UNDER_COL_WARNING   ;  3:17
    endif
    if carry_flow_warning
        SCF                         ;  1:4      carry = error
    endif
        RET                         ;  1:10

FDIV_POW2_OVER:
        LD      L, $FF              ;  2:7
        LD      A, H                ;  1:4
        OR      $FF - SIGN_MASK     ;  2:7
        LD      H, A                ;  1:4
    if color_flow_warning
        CALL    OVER_COL_WARNING   ;  3:17
    endif
    if carry_flow_warning
        SCF                         ;  1:4      carry = error
    endif
        RET                         ;  1:10
     
endif
