if not defined @FDOT

include "fmul.asm"
include "fadd.asm"

; Scalar multiplication of two vectors
;  Input: A = dimensions, HL, DE = pointers to vectors
; Output: BC = dot product, HL += 2*A, DE += 2*A, A = 1
; Pollutes: AF, BC, DE, HL
; 42 bytes, without recursion
FDOT_LOOP:
        LD      (FDOT_OLD+1), HL    ;  3:16
        POP     HL                  ;  1:10     index HL
@FDOT:
if not defined FDOT
; *****************************************
                    FDOT                ; *
; *****************************************
endif

        LD      C, (HL)             ;  1:7
        INC     HL                  ;  1:6
        LD      B, (HL)             ;  1:7
        INC     HL                  ;  1:6
        PUSH    HL                  ;  1:11     index HL
        EX      DE, HL              ;  1:4
        LD      E, (HL)             ;  1:7
        INC     HL                  ;  1:6
        LD      D, (HL)             ;  1:7
        INC     HL                  ;  1:6
        PUSH    HL                  ;  1:11     index DE
        PUSH    AF                  ;  1:11     dimensions
    if defined print_register
        CALL    PRINT_DE
        CALL    PRINT_BC
    endif
        CALL    FMUL                ;  3:17     (hl = de * bc)
FDOT_OLD:
        LD      DE, $0000           ;  3:10
FDOT_CALL_FADD:
        db      $01                 ;  3:10     first: ld bc, FADD
        dw      FADD                ;  3:17     after: call FADD (hl = hl + de)
        LD      A, $CD              ;  2:7      opcode call **
        LD      (FDOT_CALL_FADD), A ;  3:13
        POP     AF                  ;  1:10     dimensions
        POP     DE                  ;  1:10     index DE
        DEC     A                   ;  1:4      dimensions--
        JR      nz, FDOT_LOOP       ;  2:12/7

        INC     A                   ;  1:4      opcode ld bc, **
        LD      (FDOT_CALL_FADD), A ;  3:13

        LD      B, H                ;  1:4
        LD      C, L                ;  1:4
        POP     HL                  ;  1:10     index HL
        RET                         ;  1:10	
        
endif
