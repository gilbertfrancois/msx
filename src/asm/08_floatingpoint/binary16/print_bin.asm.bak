if not defined PRINT_BIN

;    Input: HL
;   Output: "+(2^+exp)*1.mant issa"
; Pollutes: nothing
PRINT_BIN:
        PUSH    AF                  ;  1:11
        PUSH    BC                  ;  1:11
        PUSH    DE                  ;  1:11
        PUSH    HL                  ;  1:11
                
        ADD     HL, HL              ;  1:11     Sign        
        LD      A, $95              ;  2:7
        ADC     A, $00              ;  2:7      $95, $96
        RLCA                        ;  1:4      $2B = '+', $2D = '-'
        LD      (PRINT_BIN_STR), A  ;  3:13

        XOR     A                   ;  1:4
        LD      B, EXP_BITS         ;  2:7
PRINT_BIN_READ_EXP:
        ADD     HL, HL              ;  1:11
        ADC     A, A                ;  1:4
        DJNZ    PRINT_BIN_READ_EXP  ;  2:13/8
        
        EX      DE, HL              ;  1:4      Save HL
        LD      HL, PRINT_BIN_EXP   ;  3:10
        LD      (HL), '+'           ;  2:10     $2B
        SUB     BIAS / EXP_PLUS_ONE ;  2:7
        JR      nc, PRINT_BIN_PEXP  ;  2:12/7
        LD      (HL), '-'           ;  2:10     $2D
        NEG                         ;  2:8
PRINT_BIN_PEXP:
        INC     HL                  ;  1:6

        LD      B, $0A              ;  2:7
        CALL    A_DIV_B             ;  3:17
        ADD     A, '0'              ;  2:7
        LD      (HL), A             ;  1:7
        
        EX      DE, HL              ;  1:4
        
        LD      DE, PRINT_BIN_MAN_0 ;  3:10
        LD      B, $04              ;  2:7
        CALL    PRINT_BIN_MANTISSA  ;  3:17

        LD      DE, PRINT_BIN_MAN_4 ;  3:10
        LD      B, $04              ;  2:7
        CALL    PRINT_BIN_MANTISSA  ;  3:17

        LD      DE, PRINT_BIN_MAN_8 ;  3:10
        LD      B, MANT_BITS-$08    ;  2:7
        CALL    PRINT_BIN_MANTISSA  ;  3:17

        LD      L, $1A              ;  2:7      Upper screen
        CALL    $1605               ;  3:17     Open channel
        LD      DE, PRINT_BIN_STR   ;  3:10     Address of string
        LD      BC, PRINT_BIN_LEN-1 ;  3:10     Length-1 of string to print
        CALL    $2040               ;  3:17     Print our string
        
        POP     HL                  ;  1:10
        POP     DE                  ;  1:10
        POP     BC                  ;  1:10
        POP     AF                  ;  1:10
;         HALT
;         HALT
        RET                         ;  1:10



; In: DE Address, B number bits, HL source
; Out: DE += B, B = 0
PRINT_BIN_MANTISSA:
        XOR     A                   ;  1:4
        ADD     HL, HL              ;  1:11
        ADC     A, '0'              ;  2:7          $30, $31
        LD      (DE), A             ;  1:7
        INC     DE                  ;  1:6
        DJNZ    PRINT_BIN_MANTISSA  ;  2:13/8
        RET                         ;  1:10


; In: A, B, HL = Adress
; Out: C = '0' + A / B, A = A mod B, HL++
A_DIV_B:
        LD      C, '0'-1            ;  2:7
A_DIV_B_LOOP:
        INC     C                   ;  1:4
        SUB     B                   ;  1:4
        JR      nc, A_DIV_B_LOOP    ;  2:12/7
        LD      (HL), C             ;  1:7
        INC     HL                  ;  1:6
        ADD     A, B                ;  1:4
        RET                         ;  1:10
        
        
PRINT_BIN_STR: 
    DEFB        '+(2', $5E
PRINT_BIN_EXP:
    DEFB        '+00)*1.'
PRINT_BIN_MAN_0:
    DEFS        4
    DEFB        BRIGHT, 1, ' '
PRINT_BIN_MAN_4:
    DEFS        4
    DEFB        BRIGHT, 0, ' '
PRINT_BIN_MAN_8:    
    DEFS        MANT_BITS-8

PRINT_BIN_LEN   EQU $-PRINT_BIN_STR


endif
