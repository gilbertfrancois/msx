if not defined @FDOT_REC

include "fmul.asm"
include "fadd.asm"

; Scalar multiplication of two vectors
;  Input: A = dimensions, HL, DE = pointers to vectors
; Output: BC = dot product, if (A != 1) HL = BC
; Pollutes: HL, DE, AF
; 34 bytes, recursion
@FDOT_REC:
if not defined FDOT_REC
; *****************************************
                  FDOT_REC              ; *
; *****************************************
endif
        PUSH    AF
        LD      C, (HL)
        INC     HL
        LD      B, (HL)
        PUSH    HL
        EX      DE, HL
        LD      E, (HL)
        INC     HL
        LD      D, (HL)
        PUSH    HL
    if defined print_register
        CALL    PRINT_DE
        CALL    PRINT_BC
    endif
        CALL    FMUL              ; HL = (DE*BC)
        LD      C, L
        LD      B, H
        POP     DE
        POP     HL
        POP     AF
        DEC     A
        RET     z
        INC     HL
        INC     DE
        PUSH    BC
        CALL    @FDOT_REC
        LD      L, C
        LD      H, B
        POP     DE
        CALL    FADD
        LD      C, L
        LD      B, H
        RET

endif
