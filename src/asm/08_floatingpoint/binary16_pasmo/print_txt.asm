if not defined PRINT_TXT

    include "print_init.asm"

; Input:
;   Stack: first adress string, second return adress
PRINT_TXT:
        EX      (SP), HL            ;  1:19     Address of string
        PUSH    DE                  ;  1:11
        PUSH    BC                  ;  1:11
        PUSH    AF                  ;  1:11
        
        PUSH    HL                  ;  1:11
        LD      L, $1A              ;  2:7      Upper screen
        CALL    $1605               ;  3:17     Open channel
        POP     HL                  ;  1:10     Address of string
        
        LD      D, H                ;  1:4
        LD      E, L                ;  1:4
        LD      A, STOP_MARK        ;  2:7
PRINT_LENGTH:
        INC     HL                  ;  1:6
        CP      (HL)                ;  1:7
        JR      nz, PRINT_LENGTH    ;  2:12/7
        
        SBC     HL, DE              ;  2:15
        LD      B, H                ;  1:4
        LD      C, L                ;  1:4      BC = Lenght of string to print
        CALL    $203E               ;  3:17     Print our string

        POP     AF                  ;  1:10
        POP     BC                  ;  1:10
        POP     DE                  ;  1:10
        POP     HL                  ;  1:10        
;         HALT
;         HALT
        RET                         ;  1:10

endif
