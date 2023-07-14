if not defined @FSQRT

; Square root of floating-point number
; In: HL
; Out: HL = abs(HL)^0.5, reset carry
; Pollutes: AF

; Mantissas of square roots
; exp = 2*e
; (2**exp * mantisa)**0.5 = 2**e * mantisa**0.5
; exp = 2*e+1
; (2**exp * mantisa)**0.5 = 2**e * mantisa**0.5 * 2**0.5

; (2^-3 * mantisa)^0.5 = 2^-1 * 2^-0.5 * mantisa^0.5 = 2^-2 * 2^+0.5 ...
; (2^-2 * mantisa)^0.5 = 2^-1 *          mantisa^0.5 = 2^-1 *        ...
; (2^-1 * mantisa)^0.5 = 2^+0 * 2^-0.5 * mantisa^0.5 = 2^-1 * 2^+0.5 ...
; (2^+0 * mantisa)^0.5 = 2^+0 *          mantisa^0.5 = 2^+0 *        ...
; (2^+1 * mantisa)^0.5 = 2^+0 * 2^+0.5 * mantisa^0.5 = 2^+0 * 2^+0.5 ...
; (2^+2 * mantisa)^0.5 = 2^+1 *          mantisa^0.5 = 2^+1 *        ...
; (2^+3 * mantisa)^0.5 = 2^+1 * 2^+0.5 * mantisa^0.5 = 2^+1 * 2^+0.5 ...

@FSQRT:
if not defined FSQRT
; *****************************************
                    FSQRT                 ; *
; *****************************************
endif
        LD      A, H                ;  1:4
        LD      (FSQRT_DATA), A     ;  3:13
        AND     2*MANT_MASK_HI+1    ;  2:7      0000 0emm
        ADD     A, A                ;  1:4
        ADD     A, SQR_TAB/256      ;  2:7
        LD      H, A                ;  1:4
FSQRT_DATA  EQU $+1
        LD      A, $00              ;  2:7
        AND     EXP_MASK            ;  2:7      ABS(HL)
        ADD     A, BIAS             ;  2:7      (x-bias)/2 + bias = (x+bias)/2, reset carry
        RRA                         ;  1:4
        AND     EXP_MASK            ;  2:7      0eee ee00
                
        OR      (HL)                ;  1:7      hi, RET with reset carry
        DEC     H                   ;  1:4
        LD      L, (HL)             ;  1:7      lo
        LD      H, A                ;  1:4
        
        RET                         ;  1:10

endif



