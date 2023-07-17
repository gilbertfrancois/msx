if not defined PRINT_HEX


;  Input: number in HL, DE address output string 
; Output: Print Hex HL
; Pollutes: A, DE += 4
WRITE_HEX:
        LD      A, H                ;  1:4
        CALL    WRITE_HEX_A         ;  3:17
        LD      A, L                ;  1:4
        ; fall

;  In: A
; Out: 00 .. FF
;      DE += 2
WRITE_HEX_A:
        PUSH    AF                  ;  1:11
        RRA                         ;  1:4
        RRA                         ;  1:4
        RRA                         ;  1:4
        RRA                         ;  1:4
        CALL    WRITE_HEX_LO        ;  3:17
        POP     AF                  ;  1:10
        ; fall

;  In: A = number, DE = adr
; Out: (A & $0F) => '0'..'9','A'..'F'
;      DE++
WRITE_HEX_LO: 
        OR      $F0                 ;  2:7      reset H flag
        DAA                         ;  1:4      $F0..$F9 + $60 => $50..$59; $FA..$FF + $66 => $60..$65
        ADD     A, $A0              ;  2:7      $F0..$F9, $100..$105
        ADC     A, $40              ;  2:7      $30..$39, $41..$46   = '0'..'9', 'A'..'F'
        LD      (DE), A             ;  1:7
        INC     DE                  ;  1:6
        RET                         ;  1:10

        
;  Input: HL
; Output: Print Hex HL
; Pollutes: nothing
PRINT_HEX:
        PUSH    AF                  ;  1:11
        PUSH    BC                  ;  1:11
        PUSH    DE                  ;  1:11
        PUSH    HL                  ;  1:11

        LD      DE, PRINT_HEX_STR+1 ;  3:10     Address of string
        CALL    WRITE_HEX           ;  3:17
        
        LD      L, $1A              ;  2:7      Upper screen
        CALL    $1605               ;  3:17     Open channel
        LD      DE, PRINT_HEX_STR   ;  3:10     Address of string
        LD      BC, $04             ;  3:10     Length-1 of string to print
        CALL    $2040               ;  3:17     Print our string

        POP     HL                  ;  1:10
        POP     DE                  ;  1:10
        POP     BC                  ;  1:10
        POP     AF                  ;  1:10
;         HALT
;         HALT
        RET                         ;  1:10
        
PRINT_HEX_STR:
        defb    '$DEAD'      
 
;  Input: Stack first RET, second number
; Output: Print Hex number
; Pollutes: nothing 
PRINT_HEX_STACK:
        LD      ($+9), HL           ;  3:16     Save HL
        POP     HL                  ;  1:10     Ret
        EX      (SP), HL            ;  1:19     Hex number
        CALL    PRINT_HEX           ;  3:17
        LD      HL, $0000           ;  3:10     Load HL
        RET                         ;  1:10

;  Input: DE
; Output: Print Hex HL
; Pollutes: nothing
PRINT_HEX_DE:
        EX      DE, HL              ;  1:4
        CALL    PRINT_HEX           ;  3:17
        EX      DE, HL              ;  1:4
        RET                         ;  1:10

;  Input: BC
; Output: Print Hex HL
; Pollutes: nothing
PRINT_HEX_BC:
        PUSH    HL                  ;  1:11
        LD      H, B                ;  1:4
        LD      L, C                ;  1:4
        CALL    PRINT_HEX           ;  3:17
        POP     HL                  ;  1:10
        RET                         ;  1:10

endif
