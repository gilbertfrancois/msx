if not defined @FSUBP

include "color_flow_warning.asm"

; Subtraction two floating-point numbers with the same signs
;  In: HL,DE numbers to add, no restrictions
; Out: HL = HL + DE, if ( carry_flow_warning && underflow ) set carry
; Pollutes: AF, B, DE
; -------------- HL - DE ---------------
; HL = (+HL) - (+DE) = (+HL) + (-DE)
; HL = (-HL) - (-DE) = (-HL) + (+DE)
@FSUBP:
if not defined FSUBP
; *****************************************
                   FSUBP                ; *
; *****************************************
endif
        LD      A, D                ;  1:4
        XOR     SIGN_MASK           ;  2:7
        LD      D, A                ;  1:4

; Add two floating-point numbers with the opposite signs
;  In: HL, DE numbers to add, no restrictions
; Out: HL = HL + DE
; Pollutes: AF, B, DE
; -------------- HL + DE ---------------
; HL = (+HL) + (-DE)
; HL = (-HL) + (+DE)
FSUBP_FADD_OP_SGN:
;   abs(D)  >   abs(H)
; 1100 0000 - 0000 0100 = $0C0 - $04 = $BC = 1011 1100
; 0100 0000 - 1000 0100 = $140 - $84 = $BC = 1011 1100
;   abs(D)  =   abs(H)
; 1100 0000 - 0100 0000 = $0C0 - $40 = $80 = 1000 0000
; 0100 0000 - 1100 0000 = $140 - $C0 = $80 = 1000 0000
;   abs(D)  <   abs(H)
; 1000 0100 - 0100 0000 = $084 - $40 = $44 = 0100 0100
; 0000 0100 - 1100 0000 = $104 - $C0 = $44 = 0100 0100

        LD      A, D                ;  1:4
        SUB     H                   ;  1:4
        JP      p, FSUBP_HL_GR      ;  3:10
        ADD     A, A                ;  1:4      sign out
        JR      nz, FSUBP_DE_GR     ;  2:12/7   
                                    ;           (HL_exp == DE_exp) && (HL_mant_hi = DE_mant_hi)
        LD      A, L                ;  1:4
        SUB     E                   ;  1:4
        JR      z, FSUBP_UNDERFLOW  ;  2:12/7   (HL_exp == DE_exp) && (HL_mant    = DE_mant   ) => HL = -DE
        JR      nc, FSUBP_HL_GR     ;  2:12/7
FSUBP_DE_GR:
        EX      DE, HL              ;  1:4
FSUBP_HL_GR:

        LD      A, H                ;  1:4
        AND     $FF - MANT_MASK_HI  ;  2:7      
        LD      B, A                ;  1:4      seee ee00
        
        OR      MANT_MASK_HI        ;  2:7
        SUB     D                   ;  1:4
        AND     EXP_MASK            ;  2:7
        JR      z, FSUBP_EQ_EXP     ;  2:12/7   need reset carry
        
        CP      4*(2 + MANT_BITS)   ;  2:7      pri posunu vetsim nez o MANT_BITS + NEUKLADANY_BIT + ZAOKROUHLOVACI_BIT uz mantisy nemaji prekryt
        JR      nc, FSUBP_TOOBIG    ;  1:11/5   HL - DE = HL
        
        CALL    SRL_DE              ;  3:17     Out: DE = (( DE & 11 1111 1111 ) | 100 0000 0000 ) >> (-2+A/4)
        
;     -------- HL - DE -------

        LD      A, H                ;  1:4
        AND     MANT_MASK_HI        ;  2:7
        LD      H, A                ;  1:4      HL = 0000 00mm mmmm mmmm
        ADD     HL, HL              ;  1:11     HL = 0000 0mmm mmmm mmm0, rounding
        ADD     HL, HL              ;  1:11     HL = 0000 mmmm mmmm mm00, rounding
        SBC     HL, DE              ;  2:15
        JR      c, FSUBP_NEXT       ;  2:12/7
                                    ;           HL = 0000 mmmm mmmm mmmm
        INC     HL                  ;  1:6      rounding  (...mm00 - DE + 1 =< 1 1111 1111 1100 + 1)
        LD      A, H                ;  1:4
        RRA                         ;  1:4
        RR      L                   ;  2:8      AL = 0000 0mmm mmmm mmmm
        OR      A                   ;  1:4      reset carry
        RRA                         ;  1:4
        RR      L                   ;  2:8      AL = 0000 00mm mmmm mmmm
        OR      B                   ;  1:4      reset carry
        LD      H, A                ;  1:4
        RET                         ;  1:10

FSUBP_NEXT:                         ;           HL = 1111 mmmm mmmm mmmm
        LD      A, H                ;  1:4
        AND     $0F                 ;  2:7
        RRA                         ;  1:4
        LD      H, A                ;  1:4
        RR      L                   ;  2:8      HL = 0000 0mmm mmmm mmmm
        LD      A, MANT_MASK_HI     ;  2:7
        LD      E, $FE              ;  2:7      -2
        CP      H                   ;  1:4      
        JR      nc, FSUBP_LOOP      ;  2:7/12
        JP      FSUBP_NORM_OK       ;  3:10

FSUBP_EQ_EXP:                       ;           need reset carry        
        SBC     HL, DE              ;  2:15     (HL_exp = DE_exp) && (HL_mant > DE_mant)  =>  HL - DE > 0
                                    ;           HL = 1000 00mm mmmm mmmm
        LD      A, MANT_MASK_HI     ;  2:7
        LD      E, $FF              ;  2:7      -1
FSUBP_LOOP:                         ;           normalizace cisla
        ADD     HL, HL              ;  1:11     musime posouvat minimalne jednou, protoze NEUKLADANY_BIT byl vynulovan
        DEC     E                   ;  1:4      exp--
        CP      H                   ;  1:4      
        JR      nc, FSUBP_LOOP      ;  2:7/12   jump cca 3.7x
FSUBP_NORM_OK:
        
        LD      A, E                ;  1:4      -(exp+1) << 0
        ADD     A, A                ;  1:4      -(exp+1) << 1
        ADD     A, A                ;  1:4      -(exp+1) << 2
        ADD     A, H                ;  1:4      +0000 01mm
        ADD     A, B                ;  1:4      +seee ee00
        LD      H, A                ;  1:4

        XOR     B                   ;  1:4      reset carry
        RET     p                   ;  1:11/5
        
        LD      H, B                ;  1:4
FSUBP_UNDERFLOW:
        LD      A, H                ;  1:4
        AND     SIGN_MASK           ;  2:7
        LD      H, A                ;  1:4
        LD      L, $00              ;  2:7
    if color_flow_warning
        CALL    UNDER_COL_WARNING   ;  3:17
    endif
    if carry_flow_warning
        SCF                         ;  1:4      carry = error
    endif        
        RET                         ;  1:10
        
; $6C00 - $3C12 = $6BFF !!!
; HL_exp - DE_exp = 12
;                   A98 7654 3210
;              HL = 100 0000 0000
;        HL << 12 = 100 0000 0000 0000 0000 0000
;              DE =                100 0001 0010
;(HL << 12 ) - DE = 011 1111 1111 1011 1110 1110, HL_exp--
;                    A9 8765 4321 0
; zaokrouhleni   =  011 1111 1111 1       !!!        
FSUBP_TOOBIG:
        RET     nz                  ;  1:11/5   HL_exp - DE_exp > 10+1+1 => HL - DE = HL
        LD      A, H                ;  1:4      seee eemm
        SUB     B                   ;  1:4     -seee ee00
        OR      L                   ;  1:4      mmmm mmmm
        RET     nz                  ;  1:11/5   HL_mant  > 1.0            => HL - DE = HL

        DEC     HL                  ;  1:6      exp-- => seee ee00 0000 0000 => seee ee11 1111 1111
        RET                         ;  1:10     HL_exp = 10 + 1 + DE_exp  => HL_exp >= 11 => exp-1 not underflow
        
        
if not defined @SRL_DE
    include "srl_de.asm"
endif

endif
