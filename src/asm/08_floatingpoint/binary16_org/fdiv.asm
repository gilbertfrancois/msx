if not defined @FDIV

include "fdiv_pow2.asm"

; ---------------------------------------------
;  Input:  BC , HL
; Output: HL = BC / HL   =>   DE = 1 / HL   =>   HL = BC * DE
; if ( 1.m = 1.0 ) => 1/(2^x * 1.0) = 1/2^x * 1/1.0 = 2^-x * 1.0    
; if ( 1.m > 1.0 ) => 1/(2^x * 1.m) = 1/2^x * 1/1.m = 2^-x * 0.9999 .. 0.5001   =>   2^(-x-1) * 1.0002 .. 1.9998    
; Pollutes: AF, BC, DE
@FDIV:
if not defined FDIV
; *****************************************
                    FDIV                ; *
; *****************************************
endif
        LD      A, H                ;  1:4
        AND     MANT_MASK_HI        ;  2:7      clear carry
        LD      D, A                ;  1:4      D = hi mantissa
        OR      L                   ;  1:4
        JR      z, FDIV_POW2        ;  2:12/7   fdiv_pow2.asm  
        
                                    ;           if ( 1.m > 1.0 ) => 1/(2^x * 1.m) = 1/2^x * 1/1.m = 2^-x * 0.9999 .. 0.5001   =>   2^(-x-1) * 1.0002 .. 1.9998            
        LD      A, D                ;  1:4
        ADD     A, A                ;  1:4
        ADD     A, DIVTAB / 256     ;  2:7
        LD      D, A                ;  1:4
        
        LD      A, H                ;  1:4
        AND     EXP_MASK            ;  2:7
        LD      E, A                ;  1:4
        LD      A, $74              ;  2:7      $74 - ($3C+4*X) = $38-4*X= $3C-4*X-4
        SUB     E                   ;  1:4
        JR      nc, FDIV_EXP_OK     ;  2:12/7

        ; A = $F8, $FC = -8, -4
        ADD     A, B                ;  1:4      
        XOR     B                   ;  1:4
        JP      m, FDIV_UNDERFLOW   ;  3:10     fdiv_pow2.asm
        XOR     B                   ;  1:4
        LD      B, A                ;  1:4
        
        XOR     A                   ;  1:4
FDIV_EXP_OK:        
        XOR     H                   ;  1:4
        AND     $FF - SIGN_MASK     ;  2:7
        XOR     H                   ;  1:4
        LD      H, D                ;  1:4
        LD      E, (HL)             ;  1:7      lo mantisa       
        INC     H                   ;  1:4
        OR      (HL)                ;  1:7      hi mantisa
FDIV_LD_D_A:
        LD      D, A                ;  1:4      sign & exp & hi mantisa
        ; DE = 1 / HL
        ; continue with FMUL
        
        ; HL = DE * BC
if defined @FMUL
    .ERROR  You must exclude the file "fmul.asm" or include "fdiv.asm" first
else
    include "fmul.asm"
endif
     
endif
