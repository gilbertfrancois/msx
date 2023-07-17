if not defined @FMUL

        ; continue from @FDIV (if it was included)

; ---------------------------------------------
; Input:  BC, DE
; Output: HL = DE * BC, if ( overflow or underflow ) set carry
; A_mantisa * 2^A_exp * B_mantisa * 2^B_exp = A_mantisa * B_mantisa *2^(A_exp + B_exp)
@FMUL:
if not defined FMUL
; *****************************************
                    FMUL                ; *
; *****************************************
endif

        LD      A, B                ;  1:4
        AND     $FF - MANT_MASK_HI  ;  2:7
        LD      L, A                ;  1:4      seee ee00
        XOR     B                   ;  1:4
        LD      B, A                ;  1:4      0000 00mm

        LD      A, D                ;  1:4
        AND     $FF - MANT_MASK_HI  ;  2:7
        LD      H, A                ;  1:4      seee ee00
        XOR     D                   ;  1:4
        LD      D, A                ;  1:4      0000 00mm

        LD      A, L                ;  1:4
        ADD     A, H                ;  1:4
        SUB     BIAS                ;  2:7
        
        PUSH    AF                  ;  1:11     seee ee00 sz-h-pnc

        XOR     L                   ;  1:4
        XOR     H                   ;  1:4
        JP      m, FMUL_FLOW        ;  3:10
        
        ; A = (EXP-BIAS + EXP-BIAS) + BIAS = EXP-BIAS + EXP

        ; 16 + 16 =  32!!=> $7C + $7C - $3C = $F8 - $3C = $BC !!
        ;  9 +  8 =  17!!=> $60 + $5C - $3C = $BC - $3C = $80 !!
        ;  8 +  8 =  16  => $5C + $5C - $3C = $B8 - $3C = $7C
        ; -7 + -7 = -14  => $20 + $20 - $3C = $40 - $3C = $04
        ; -8 + -7 = -15  => $1C + $20 - $3C = $3C - $3C = $00
        ; -8 + -8 = -16!!=> $1C + $1C - $3C = $38 - $3C = $FC !!
        ;-15 + -15= -30!!=> $00 + $00 - $3C = $00 - $3C = $C4 !!      
        ; overflow           $BC..$F8 - $3C =       $80..$BC   
        ; ok                 $3C..$B8 - $3C =       $00..$7C  (u $7C a vysokych mantis to jeste pretece na $80)
        ; underflow          $00..$38 - $3C =       $C4..$FC  (u $FC je sance ze u vysokych mantis se to jeste zachrani a preleze na $00)
        
FMUL_CHANCE:
        LD      H, B                ;  1:4
        LD      L, C                ;  1:4
        ADD     HL, DE              ;  1:11     reset carry   
        EX      DE, HL              ;  1:4      DE = A+B         
        SBC     HL, BC              ;  2:15     HL = B-A
        JR      nc, FMUL_HL_GR      ;  2:12/7

        XOR     A                   ;  1:4      HL < 0
        SUB     L                   ;  1:4
        LD      L, A                ;  1:4
        SBC     A, A                ;  1:4
        SUB     H                   ;  1:4      $100-H or $FF-H
        LD      H, A                ;  1:4      HL = -HL 
        
FMUL_HL_GR:
        LD      A, H                ;  1:4
        ADD     A, A                ;  1:4      2x  (lo+hi)
        ADD     A, Tab_AmB_lo_0/256 ;  2:7
        LD      H, A                ;  1:4
        
        LD      A, D                ;  1:4
        ADD     A, A                ;  1:4      2x
        ADD     A, D                ;  1:4      3x (lo+med+hi)
        ADD     A, Tab_ApB_lo_0/256 ;  2:7
        LD      D, A                ;  1:4
                                    ;           24 bit (DE) + 16 bit (HL) 
        LD      A, (DE)             ;  1:7      lo (DE)
        ADD     A, (HL)             ;  1:7     +lo (HL) for carry only
        LD      C, A                ;  1:4
        INC     D                   ;  1:4
        INC     H                   ;  1:4
        LD      A, (DE)             ;  1:7      med(DE)
        ADC     A, (HL)             ;  1:7     +hi(HL)
        LD      L, A                ;  1:4      LO result
        INC     D                   ;  1:4
        LD      A, (DE)             ;  1:7      hi (DE) = 4..15
        ADC     A, $00              ;  2:7      HI result & clear carry        
                                    ;           (ApB)+(AmB) >= $8 00 00 => pricti: $80
                                    ;           (ApB)+(AmB) >= $4 00 00 => pricti: $0
        CP      $08                 ;  2:7      0000 0?mmm
        JR      c, FMUL_NO_SHIFT    ;  2:12/7        
                                    ;           61.117554%
        BIT     7, C                ;  2:8
        JR      z, FMUL_SHIFT       ;  2:12/7
        LD      H, A                ;  1:4
        INC     HL                  ;  1:6      (ApB)+(AmB) >= $8 00 00 => pricti: $80
        LD      A, H                ;  1:4
                                    
FMUL_SHIFT:                         ;           AL =   0000 1mmm mmmm mmmm
        RRA                         ;  1:4      
        RR      L                   ;  2:8      AL = 0000 01mm mmmm mmmm
        POP     BC                  ;  1:10     BC = seee ee00 sz-h-pnc 
        ADD     A, B                ;  1:4
        LD      H, A                ;  1:4
        XOR     C                   ;  1:4      reset carry
        RET     p                   ;  1:11/5
        
        LD      A, C                ;  1:4
        OR      $FF - SIGN_MASK     ;  2:7
        JR      FMUL_OVERFLOW       ;  2:12     overflow
     
     
FMUL_NO_SHIFT:                      ;           38.882446%
        AND     MANT_MASK_HI        ;  2:7      A  = 0000 00mm
        POP     BC                  ;  1:10     BC = seee ee00 sz-h-pnc 
        ADD     A, B                ;  1:4      
        LD      H, A                ;  1:4
        XOR     C                   ;  1:4      reset carry
        RET     p                   ;  1:11/5
        
        LD      A, C                ;  1:4
        AND     SIGN_MASK           ;  2:7
        JR      FMUL_UNDERFLOW      ;  2:12     underflow
     
     
;  In: the opposite sign is stored on the stack
FMUL_FLOW:
        ADD     HL, HL              ;  1:11     sign out in H and in L
        LD      A, L                ;  1:4
        ADD     A, H                ;  1:4
        JR      c, FMUL_OVERFLOW_S  ;  2:12/7
     
FMUL_UNDERFLOW_S:
        POP     HL                  ;  1:10     HL = seee ee00 sz-h-pnc
        LD      A, H                ;  1:4
        XOR     $FC                 ;  2:7
        ADD     A, A                ;  1:4      opposite sign out
        JR      nz, FMUL_NO_CHANCE  ;  2:12/7
        
                                    ;           exp = - BIAS - EXP_PLUS_ONE = EXP_MASK
        RR      L                   ;  2:8      opposite (but real) sign in
        PUSH    HL                  ;  1:11
        JR      FMUL_CHANCE         ;  2:12    
FMUL_NO_CHANCE:
        
        LD      A, H                ;  1:4
        OR      $FF - SIGN_MASK     ;  2:7
        INC     A                   ;  1:4      1000 0000 or 0000 0000
FMUL_UNDERFLOW:
        LD      H, A                ;  1:4
        LD      L, $00              ;  2:7
    if color_flow_warning
        CALL    UNDER_COL_WARNING   ;  3:17
    endif
    if carry_flow_warning
        SCF                         ;  1:4          carry = error
    endif
        RET                         ;  1:10
     
     
FMUL_OVERFLOW_S:
        POP     AF                  ;  1:10     AF = seee ee00 sz-h-pnc
        AND     SIGN_MASK           ;  2:7
        DEC     A                   ;  1:4      0111 1111 or 1111 1111
FMUL_OVERFLOW:
        LD      H, A                ;  1:4
        LD      L, $FF              ;  2:7
    if color_flow_warning
        CALL    OVER_COL_WARNING    ;  3:17
    endif
    if carry_flow_warning
        SCF                         ;  1:4          carry = error
    endif
        RET                         ;  1:10

    include "color_flow_warning.asm"
  
endif
