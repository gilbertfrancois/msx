if not defined FEQUALS

    INCLUDE "print_init.asm"

;  Comparing of two floating point numbers with minimum tolerance. Does not solve overflow and underflow HL
;    Input: HL, BC
;   Output: if      ( HL            == BC ) {   set zero; reset carry; A = COL_GREEN;  }
;           else if ( HL + rounding == BC ) {   set zero;   set carry; A = COL_YELLOW; }
;           else if ( HL - rounding == BC ) {   set zero;   set carry; A = COL_AZURE;  }
;           else                            { reset zero;   set carry; A = COL_RED;    }
; Pollutes: AF
FEQUALS:                            ; HL == BC?
        LD      A, L
        SUB     C
        JR      nz, FEQUALS_PLUS
        LD      A, H
        SUB     B
        LD      A, COL_GREEN
        RET     z

; HL = seee eemm mmmm mmmm
FEQUALS_PLUS:                       ;           HL + rounding == BC?
        INC     HL                  ;  1:6
        LD      A, L                ;  1:4       
        SUB     C                   ;  1:4
        LD      A, H                ;  1:4       
        DEC     HL                  ;  1:6
        JR      nz, FEQUALS_MINUS   ;  2:12/7
        SUB     B                   ;  1:4
        LD      A, COL_YELLOW       ;  2:7
        SCF                         ;  1:4
        RET     z                   ;  1:11/5

FEQUALS_MINUS:                      ;           HL - rounding == BC?
        DEC     HL                  ;  1:6
        LD      A, L                ;  1:4       
        SUB     C                   ;  1:4
        LD      A, H                ;  1:4       
        INC     HL                  ;  1:6
        JR      nz, FEQUALS_FAIL    ;  2:12/7
        SUB     B                   ;  1:4
        LD      A, COL_AZURE        ;  2:7
        SCF                         ;  1:4
        RET     z                   ;  1:11/5

FEQUALS_FAIL:
        LD      A, COL_RED          ;  2:7
        SCF                         ;  1:4
        RET                         ;  1:10
 
 endif
 
