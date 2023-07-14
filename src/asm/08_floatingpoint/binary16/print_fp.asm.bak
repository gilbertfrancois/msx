if not defined PRINT_FP

    include "print_txt.asm"
    include "print_hex.asm"
    include "print_bin.asm"
    

; In: HL = 'ba' => print "ab:"
PRINT_XX:
        LD      (PRINT_XX_DATA), HL ;  3:16
        CALL    PRINT_TXT           ;  3:17
PRINT_XX_DATA:
        defb    'FP:'
        
PRINT_TXT_SPACE:
        CALL    PRINT_TXT
        defb    ' '
        
PRINT_TXT_NEW_LINE:
        CALL    PRINT_TXT
        defb    NEW_LINE

PRINT_TXT_CONTINUE:
        CALL    PRINT_TXT
        defb    INK, COL_WHITE, 'Continue '
                
PRINT_TXT_EXIT:
        CALL    PRINT_TXT
        defb    INK, COL_WHITE, 'Exit '

PRINT_TXT_FDOT:
        CALL    PRINT_TXT
        defb    INK, COL_WHITE, 'FDot', NEW_LINE
        
defb    STOP_MARK

; In: A = COLOR
PRINT_SET_COLOR:
        PUSH    HL                  ;  1:11
        LD      HL, COL_ADR         ;  3:10
        XOR     (HL)                ;  1:7
        AND     $07                 ;  2:7
        XOR     (HL)                ;  1:7
        LD      (HL), A             ;  1:7
        POP     HL                  ;  1:10
        RET                         ;  1:10


;  Input: floating-point number in HL
; Output: Print decimal exponent and binary mantissa and hex all
; Pollutes: nothing
        ;  0123456789ABCDEF0123456789ABCDEF
        ; "-(2^+05)*1.1111 0000 11 $D3C0"
PRINT_FP:
        CALL    PRINT_BIN           ;  3:17
        CALL    PRINT_TXT_SPACE     ;  3:17
        CALL    PRINT_HEX           ;  3:17

        RET                         ;  1:10


;  Input: floating-point number in stack
; Output: Print decimal exponent and binary mantissa and hex all
; Pollutes: nothing
        ;  0123456789ABCDEF0123456789ABCDEF
        ; "-(2^+005)*1.1111 000 $D3C0"
PRINT_FP_STACK:
        LD      A, COL_AZURE
PRINT_FP_STACK_COL:
        CALL    PRINT_SET_COLOR
        LD      (PRINT_FP_STACK_HL), HL ;  3:16 
        POP     HL                  ;  1:10     HL = ret
        EX      (SP), HL            ;  1:19
        CALL    PRINT_FP
PRINT_FP_STACK_HL  EQU $+1
        LD      HL, $0000
        RET

; ------------- Registry ---------------
                
PRINT_DE:
        LD      A, COL_AZURE        ;  2:7
PRINT_DE_COL:
        CALL    PRINT_SET_COLOR     ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, 'D'+'E' * 256   ;  3:10     "DE"
        CALL    PRINT_XX            ;  3:17
        LD      H, D                ;  1:4
        LD      L, E                ;  1:4
        CALL    PRINT_FP            ;  3:17
        POP     HL                  ;  1:10
        RET                         ;  1:10
        
        
PRINT_BC:
        LD      A, COL_AZURE        ;  2:7
PRINT_BC_COL:
        CALL    PRINT_SET_COLOR     ;  3:17
        PUSH    HL                  ;  1:11
        LD      HL, 'B'+'C' * 256   ;  3:10     "BC"
        CALL    PRINT_XX            ;  3:17
        LD      H, B                ;  1:4
        LD      L, C                ;  1:4
        CALL    PRINT_FP            ;  3:17
        POP     HL                  ;  1:10
        RET                         ;  1:10


PRINT_HL:
        LD      A, COL_AZURE        ;  2:7
PRINT_HL_COL:
        PUSH    HL                  ;  1:11
        LD      HL, 'H'+'L' * 256   ;  3:10     "HL"
        ; Fall..
        
        
; Nevolat pomoci CALL! Only JP/JR PRINT_XFP
; In: original HL on stack, HL = 'ba' => print "ab:"
PRINT_XFP:
        CALL    PRINT_SET_COLOR     ;  3:17
PRINT_XFP_NO_COL:
        CALL    PRINT_XX            ;  3:17
        POP     HL                  ;  1:10
        JP      PRINT_FP            ;  3:10

endif
