if not defined @FADDP
        ; continue from @FADD (if it was included)
     
; Add two floating point numbers with the same sign
;  In: HL, DE numbers to add, no restrictions
; Out: HL = HL + DE,  if ( overflow ) set carry
; Pollutes: AF, B, DE
; -------------- HL + DE ---------------
; HL = (+HL) + (+DE)
; HL = (-HL) + (-DE)
@FADDP:
if not defined FADDP
; *****************************************
                   FADDP                ; *
; *****************************************
endif
        LD      A, H                ;  1:4
        OR      MANT_MASK_HI        ;  2:7
        SUB     D                   ;  1:4
        JP      nc, FADDP_HL_GR     ;  3:10
        EX      DE, HL              ;  1:4      nejvyssi bit mel byt 0
        CPL                         ;  1:4
        ADD     A, 1 + MANT_MASK_HI ;  2:7      NEG + MANT_MASK_HI
FADDP_HL_GR:
        AND     EXP_MASK            ;  1:4      0ee eee00
        JR      z, FADDP_EQ_EXP     ;  2:12/7   neresime zaokrouhlovani
        CP      4*(2 + MANT_BITS)   ;  2:7      pri posunu vetsim nez o MANT_BITS + NEUKLADANY_BIT + ZAOKROUHLOVACI_BIT uz mantisy nemaji prekryt
        RET     nc                  ;  1:11/5   HL + DE = HL, RET with reset carry
        CALL    SRLDEC_DE           ;  3:17     DE = --(( DE & 11 1111 1111 ) | 100 0000 0000 ) >> --(A/4)
        
        LD      B, H                ;  1:4
        LD      A, H                ;  1:4
        OR      SIGN_MASK + EXP_MASK;  2:7
        LD      H, A                ;  1:4      HL = 1111 11?? ???? ????      
        LD      A, B                ;  1:4
        OR      MANT_MASK_HI        ;  2:7      A = ???? ??11 = sign + exp
        
        ADD     HL, HL              ;  1:11     HL = 1111 1??? ???? ???0, kvuli zaokrouhleni potrebujeme znat hodnotu prvniho bitu za desetinou carkou 
        ADD     HL, DE              ;  1:11 
        JR      nc, FADDP_SAME_EXP
                                    ;           HL = 000. 0??? ???? ????, protoze pretekl o bit, tak musime zvednout exp a posunout mantisu doleva
        SRA     H                   ;  2:8
        RR      L                   ;  2:8      HL = 0000 .0?? ???? ????
        INC     HL                  ;  1:6      HL = 0000 .??? ???? ????, rounding, overflow is not possible!
        SRA     H                   ;  2:8
        RR      L                   ;  2:8      HL = 0000 0.?? ???? ????
        
FADDP_EXP_PLUS:
        INC     A                   ;  1:4      A = seee ee11 + 1 = sign + ++exp        
        ADD     A, H                ;  1:4      ???? ??00 + H
        LD      H, A                ;  1:4
        XOR     B                   ;  1:4      RET with reset carry
        RET     p                   ;  1:11/5
        
        LD      D, B                ;  1:4
        JR      FADDP_OVERFLOW      ;  2:12


FADDP_SAME_EXP:                     ;           HL = 1111 1??? ???? ????
        INC     HL                  ;  1:6      rounding
        SRA     H                   ;  2:8      H = 1111 11??       
        JR      z, FADDP_EXP_PLUS   ;  2:12/7
        RR      L                   ;  2:8
        
        AND     H                   ;  1:4      A = seee ee11 | 1111 11mm, RET with reset carry
        LD      H, A                ;  1:4
        RET                         ;  1:10
        
FADDP_EQ_EXP:                       ;           HL exp = DE exp
        LD      A, D                ;  1:4      dddd dddd
        XOR     H                   ;  1:4      xxxx xxxx
        AND     MANT_MASK_HI        ;  2:7      0000 00xx
        XOR     H                   ;  1:4      hhhh hhdd
        LD      D, A                ;  1:4      HL_sign + HL_exp + DE_mant
        
        ADD     HL, DE              ;  1:11     HL = s eeee emmm mmmm mmmm
        LD      A, H                ;  1:4
        RRA                         ;  1:4
        RR      L                   ;  2:8      AL =   seee eemm mmmm mmmm
        ADD     A, EXP_PLUS_ONE     ;  2:7           + 0000 0100
        LD      H, A                ;  1:4
        XOR     D                   ;  1:4      reset carry
        RET     p                   ;  1:11/5
        
; In: (BIT 7, D) = SIGN
; Out: HL = +- infinity
FADDP_OVERFLOW:
    if color_flow_warning
        CALL    OVER_COL_WARNING    ;  3:17
    endif
        RL      D                   ;  2:8
        JR      nc,  FADDP_OUT_FPMAX;  2:12/7

FADDP_OUT_FMMAX:
        LD      HL, FMMAX           ;  3:10
    if carry_flow_warning
        SCF                         ;  1:4          carry = error
    endif
        RET                         ;  1:10

FADDP_OUT_FPMAX:
        LD      HL, FPMAX           ;  3:10
    if carry_flow_warning
        SCF                         ;  1:4          carry = error
    endif
        RET                         ;  1:10

    include "srl_de.asm"
    include "color_flow_warning.asm"

endif
