if not defined @FWLD

; Load Word. Convert unsigned 16-bit integer into floating-point number
;  In: HL = Word to convert
; Out: HL = floating point representation
; Pollutes: AF
@FWLD:
if not defined FWLD
; *****************************************
                    FWLD                ; *
; *****************************************
endif
        LD      A, H                ;  1:4
        OR      A                   ;  1:4
        JR      z, FWLD_BYTE        ;  2:12/7
        
        CP      2*EXP_PLUS_ONE      ;  2:7
        JR      c, FWLD_LOSSLESS    ;  2:12/7
        
        LD      A, BIAS/EXP_PLUS_ONE+16     ;  2:7  HL = xxxx xxxx xxxx xxxx
FWLD_NORM:
        ADD     HL, HL              ;  1:11
        DEC     A                   ;  1:4
        JR      nc, FWLD_NORM       ;  2:12/7        

        ADD     HL, HL              ;  1:11
        ADC     A, A                ;  1:4
        ADD     HL, HL              ;  1:11         
        ADC     A, A                ;  1:4          AHL = 0eee eemm mmmm mmmm ?rrr rrrr      
        RL      L                   ;  2:8          check for rounding
        LD      L, H                ;  1:4
        LD      H, A                ;  1:4
        RET     nc                  ;  1:11/5       0 rrrr rrr0
    if carry_flow_warning
        CCF                         ;  1:4
    endif
        RET     z                   ;  1:11/5       1 0000 0000
        INC     L                   ;  1:4          rounding up
        RET     nz                  ;  1:11/5
        INC     H                   ;  1:4
        RET                         ;  1:10
        
FWLD_BYTE:                          ;               HL = 0000 0000 xxxx xxxx
        OR      L                   ;  1:4
        RET     z                   ;  1:5/11
        LD      H, BIAS/EXP_PLUS_ONE+8 ;  2:7
FWLD_BYTE_NORM:
        ADD     A, A                ;  1:4
        DEC     H                   ;  1:4
        JR      nc, FWLD_BYTE_NORM  ;  2:12/7 
        LD      L, A                ;  1:4
        ADD     HL, HL              ;  1:11
        ADD     HL, HL              ;  1:11         RET with reset carry
        RET                         ;  1:10

FWLD_LOSSLESS:                      ;               HL = 0000 0xxx xxxx xxxx, set carry
                                    ;               $100 => $5C00
                                    ;               $200 => $6000, $300 => $6200
                                    ;               $400 => $6400, $500 => $6500, $600 => $6600, $700 => $6700
        AND     IMPBIT_MASK         ;  2:7
        LD      A, BIAS+EXP_PLUS_ONE*(MANT_BITS-1) ;  2:7
        JR      nz, FWLD_LOSSLESS_E ;  2:12/7        
    if 1
FWLD_LOSSLESS_N:
        ADD     HL, HL              ;  1:11
        SUB     $04                 ;  2:7
        BIT     2, H                ;  2:8
        JR      z, FWLD_LOSSLESS_N  ;  2:12/7
    else
        ADD     HL, HL              ;  1:11
        SUB     $04                 ;  2:7
        BIT     2, H                ;  2:8
        JR      nz, FWLD_LOSSLESS_E ;  2:12/7
        ADD     HL, HL              ;  1:11
        SUB     $04                 ;  2:7
    endif
FWLD_LOSSLESS_E:
        ADD     A, H                ;  1:4          RET with reset carry
        LD      H, A                ;  1:4
        RET                         ;  1:10

endif
